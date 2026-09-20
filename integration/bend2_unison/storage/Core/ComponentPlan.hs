module Core.ComponentPlan
  ( ComponentPlan(..)
  , AddressedComponent(..)
  , planComponents
  , structuralKey
  , addressComponents
  , decodeStoredComponent
  ) where

import Core.Admission (CheckedMember(..), CheckedSource(..), memberDependencies)
import Core.Reify (Flat(..), reifyDefn, reifyHit)
import Core.CanonicalComponent (canonicalOrder, decodeCanonicalComponentSynthetic)
import Core.Type (Book(..), Name)
import qualified Core.Type as Bend
import Crypto.Hash (Digest, SHA3_512, hash)
import qualified Data.ByteArray as ByteArray
import qualified Data.ByteString as Bytes
import qualified Data.ByteString.Lazy as Lazy
import Data.Graph (SCC(..), stronglyConnComp)
import qualified Data.Map.Strict as Map
import qualified Data.Set as Set

-- | A dependency-closed admission order. Each group is one native codebase
-- component. Definitions and HIT declarations with the same Bend name stay
-- together so constructor-generated definitions are not silently discarded.
data ComponentPlan = ComponentPlan
  { componentNames :: [Name]
  , componentBook :: Book
  , componentMemberDependencies :: Map.Map Name (Set.Set Name)
  , componentExternalDependencies :: Set.Set Name
  }

data AddressedComponent = AddressedComponent
  { addressedPlan :: ComponentPlan
  , addressedDigest :: Bytes.ByteString
  , addressedBytes :: Lazy.ByteString
  }

planComponents :: CheckedSource -> Either String [ComponentPlan]
planComponents checked = do
  let Book defs hits = checkedBook checked
      members = checkedMembers checked
      names = Set.fromList (Map.keys defs ++ Map.keys hits)
      dependencyMap = Map.fromListWith Set.union
        [ (memberName member, memberDependencies member) | member <- members ]
      unknown = Set.unions (Map.elems dependencyMap) `Set.difference` names
  if not (Set.null unknown)
    then Left ("unresolved Bend2 dependencies: " ++ show (Set.toList unknown))
    else do
      let graph =
            [ (name, name, Set.toList (Map.findWithDefault Set.empty name dependencyMap))
            | name <- Set.toAscList names ]
          groups = map (Set.fromList . flatten) (stronglyConnComp graph)
          readyPlans = map (makePlan defs hits dependencyMap) groups
      orderPlans Set.empty readyPlans []
  where
    flatten (AcyclicSCC x) = [x]
    flatten (CyclicSCC xs) = xs

    orderPlans _ [] acc = Right (reverse acc)
    orderPlans available pending acc =
      case break (\p -> componentExternalDependencies p `Set.isSubsetOf` available) pending of
        (_, []) -> Left "cyclic Bend2 component dependency plan"
        (before, selected : after) ->
          orderPlans
            (available `Set.union` Set.fromList (componentNames selected))
            (before ++ after)
            (selected : acc)

memberName :: CheckedMember -> Name
memberName (CheckedDefn name _ _ _) = name
memberName (CheckedHit name _) = name

makePlan :: Map.Map Name Bend.Defn -> Map.Map Name Bend.HitDecl -> Map.Map Name (Set.Set Name) -> Set.Set Name -> ComponentPlan
makePlan defs hits dependencyMap names =
  ComponentPlan
    { componentNames = Set.toAscList names
    , componentBook = Book
        (Map.filterWithKey (\name _ -> Set.member name names) defs)
        (Map.filterWithKey (\name _ -> Set.member name names) hits)
    , componentMemberDependencies = Map.filterWithKey (\name _ -> Set.member name names) dependencyMap
    , componentExternalDependencies =
        Set.unions [Map.findWithDefault Set.empty name dependencyMap | name <- Set.toList names]
          `Set.difference` names
    }

-- | Hash input for a checked component. Local refs become member indices;
-- external refs become already addressed dependency hashes. Binder names and
-- source positions are presentation only. This is structural identity, not a
-- claim of Bend checker established normal-form identity.
structuralKey :: Map.Map Name (Bytes.ByteString, Int) -> ComponentPlan -> Either String Flat
structuralKey resolved plan = do
  let Book defs hits = componentBook plan
      locals = Map.fromList (zip (componentNames plan) [0 :: Int ..])
  entries <- traverse (entry defs hits locals) (componentNames plan)
  pure (Node "BendCheckedComponentV1" entries)
  where
    entry defs hits locals name = do
      definition <- traverse (resolveFlat locals . reifyDefn) (Map.lookup name defs)
      hit <- traverse (resolveFlat locals . reifyHit) (Map.lookup name hits)
      pure (Node "Member" [maybe (BoolAtom False) id definition, maybe (BoolAtom False) id hit])

    resolveFlat locals flat = case flat of
      Global name ->
        case Map.lookup name locals of
          Just i -> Right (Node "LocalRef" [NatAtom i])
          Nothing -> case Map.lookup name resolved of
            Just (digest, memberIndex) -> Right (Node "ExternalRef" [Node "Digest" (map (WordAtom . fromIntegral) (Bytes.unpack digest)), NatAtom memberIndex])
            Nothing -> Left ("unresolved Bend2 reference in structural key: " ++ name)
      Node "Loc" [_, term] -> resolveFlat locals term
      Node "Sub" [term] -> resolveFlat locals term
      Node tag [Text _, body] | tag `elem` ["Fix", "Lam", "PLm"] ->
        Node tag . pure <$> resolveFlat locals body
      Node tag children -> Node tag <$> traverse (resolveFlat locals) children
      other -> Right other

-- | Address components in dependency order. The digest covers the exact
-- name-free canonical bytes persisted in the codebase, including resolved
-- external component references and HIT constructor ordinals. The returned
-- member order is the canonical slot order used by every codebase reference.
addressComponents :: CheckedSource -> Either String [AddressedComponent]
addressComponents checked = do
  plans <- planComponents checked
  go Map.empty plans []
  where
    go _ [] acc = Right (reverse acc)
    go resolved (plan : rest) acc = do
      (canonicalNames, bytes) <- canonicalOrder
        (componentNames plan) resolved (checkedBook checked) (componentBook plan)
      let digest = ByteArray.convert (hash (Lazy.toStrict bytes) :: Digest SHA3_512)
          resolved' = foldr
            (\(name, memberIndex) -> Map.insert name (digest, memberIndex))
            resolved
            (zip canonicalNames [0 ..])
          canonicalPlan = plan {componentNames = canonicalNames}
      go resolved' rest (AddressedComponent canonicalPlan digest bytes : acc)

decodeStoredComponent :: Bytes.ByteString -> Lazy.ByteString -> Either String Book
decodeStoredComponent = decodeCanonicalComponentSynthetic
