module Bend.UCM.Storage
  ( saveCheckedSource
  , branchBindings
  , loadStoredComponent
  , loadDependencyClosedBook
  , loadDependencyClosedEntryBook
  , loadDependencyClosedEntryBookByHashRef
  , loadBendPresentationForHashRef
  , loadBendDefinitionTypeTextByHashRef
  , exportBendSyncEnvelope
  , importBendSyncEnvelope
  , lookupBendMemberByAuthoredName
  ) where

import Core.Admission (CheckedSource(..))
import Core.Provenance (OriginRole(..), SourceOrigin(..))
import Core.ComponentPlan (ComponentPlan(..), AddressedComponent(..), addressComponents, decodeStoredComponent)
import Core.CanonicalComponent (syntheticMemberName)
import Core.SemanticIdentity (checkedNatIdentity,semanticVersion)
import Core.SyncEnvelope (SyncEnvelope(..), SyncDependency(..), SyncPresentation(..), encodeSyncEnvelope)
import Core.Type (Book(..), Name)
import Crypto.Hash (Digest, SHA3_512, hash)
import qualified Data.ByteArray as ByteArray
import qualified Data.ByteString as Bytes
import qualified Data.ByteString.Lazy as Lazy
import qualified Data.Map.Strict as Map
import Data.List (nub, sortOn)
import qualified Data.Set as Set
import qualified Data.Text as Text
import qualified Data.Text.Encoding as Text
import qualified U.Codebase.Reference as Ref
import qualified U.Codebase.Sqlite.Queries as Q
import qualified U.Codebase.Sqlite.Reference as S
import U.Codebase.Sqlite.DbId (ObjectId)
import U.Codebase.Sqlite.V2.HashHandle (v2HashHandle)
import qualified Unison.Hash as Hash
import qualified Unison.Referent as Referent
import Unison.Sqlite (Transaction)
import qualified Unison.Sqlite as Sqlite

-- | Convert the canonical Bend addresses into the ordinary derived refs used
-- by UCM's causal branch/name machinery. A same-name HIT and definition get
-- separate type and term bindings. The caller applies these through UCM's
-- normal branch step after the checked objects have been stored.
branchBindings :: CheckedSource -> Either String ([(Name, Referent.Referent)], [(Name, Ref.Reference)])
branchBindings checked = do
  addressed <- addressComponents checked
  pure (foldMap bindings addressed)
  where
    bindings (AddressedComponent plan digest _) =
      let Book defs hits = componentBook plan
          ref i = Ref.ReferenceDerived (Ref.Id (Hash.fromByteString digest) (fromIntegral i))
          named = zip (componentNames plan) [0 :: Int ..]
       in ( [(name, Referent.Ref (ref i)) | (name, i) <- named, Map.member name defs]
          , [(name, ref i) | (name, i) <- named, Map.member name hits]
          )

-- | Admit checked Bend2 SCCs in dependency order, keeping the Bend book as
-- native codebase object bytes. UCM calls this inside Codebase.runTransaction.
-- Each Bend name maps to the native object/member reference used by Unison's
-- dependency index. This does not compile or run the program.
saveCheckedSource :: CheckedSource -> Transaction (Either String (Map.Map Name S.Id))
saveCheckedSource checked =
  case addressComponents checked of
    Left err -> pure (Left err)
    Right components -> go Map.empty components
  where
    go resolved [] = pure (Right resolved)
    go resolved (AddressedComponent plan digest bytes : rest) = do
      let names = componentNames plan
          localNames = Set.fromList names
          indexedNames = zip names [0 ..]
          external name =
            if Set.member name localNames then Right Nothing
            else case Map.lookup name resolved of
              Nothing -> Left ("unresolved codebase dependency: " ++ name)
              Just ref -> Right (Just (Ref.ReferenceDerived ref))
          externalFor name =
            traverse external (Set.toAscList (Map.findWithDefault Set.empty name (componentMemberDependencies plan)))
          memberExternal =
            traverse (\(name, i) -> fmap ((,) (fromIntegral i) . foldr (maybe id (:)) []) (externalFor name)) indexedNames
      case memberExternal of
        -- addressComponents already proved every external name has an earlier
        -- component. If that invariant breaks after writes, throw so the
        -- enclosing SQLite transaction rolls back atomically.
        Left err -> Sqlite.unsafeIO (ioError (userError err))
        Right dependencies -> do
          objectId <- Q.saveBendComponent
            v2HashHandle
            (Hash.fromByteString digest)
            (Lazy.toStrict bytes)
            dependencies
          let localRefs = Map.fromList
                [ (name, Ref.Id objectId (fromIntegral i)) | (name, i) <- indexedNames ]
              resolved' = Map.union localRefs resolved
          mapM_ (\(name, i) -> do
            let origins = nub [origin | role <- [DefinitionOrigin,HitOrigin],
                                        Just origin <- [Map.lookup (name,role) (checkedOrigins checked)]]
            case origins of
              [] -> Sqlite.unsafeIO (ioError (userError ("missing Bend source for " ++ name)))
              _ -> mapM_ (saveOrigin objectId (fromIntegral i) name) origins) indexedNames
          mapM_ (\(name, i) -> case checkedNatIdentity checked name of
            Nothing -> pure ()
            Just semanticDigest -> Q.saveBendSemanticIdentity objectId (fromIntegral i)
              semanticVersion (Hash.fromByteString semanticDigest)) indexedNames
          mapM_ (indexLocalDependencies objectId localRefs localNames plan) indexedNames
          go resolved' rest

    saveOrigin objectId member name origin = do
      let bytes = Text.encodeUtf8 (Text.pack (originText origin))
          digest = ByteArray.convert (hash bytes :: Digest SHA3_512) :: Bytes.ByteString
      Q.saveBendPresentation objectId member digest bytes
        (fromIntegral (originStartByte origin)) (fromIntegral (originEndByte origin))
        (Text.pack name) (Text.pack (originPath origin))

    indexLocalDependencies :: ObjectId -> Map.Map Name S.Id -> Set.Set Name -> ComponentPlan -> (Name, Int) -> Transaction ()
    indexLocalDependencies objectId localRefs localNames plan (name, i) =
      let dependencies = Map.findWithDefault Set.empty name (componentMemberDependencies plan)
          local = Set.toAscList (dependencies `Set.intersection` localNames)
          refs = [Ref.ReferenceDerived ref | dep <- local, Just ref <- [Map.lookup dep localRefs]]
       in Q.addToDependentsIndex refs (Ref.Id objectId (fromIntegral i))

-- | Load a Bend object with its type tag checked, then decode its versioned
-- first-order AST back to the exact Bend Book for the HVM full emitter.
loadStoredComponent :: ObjectId -> Transaction (Maybe (Either String Book))
loadStoredComponent objectId = do
  maybeBytes <- Q.loadBendBytes objectId
  case maybeBytes of
    Nothing -> pure Nothing
    Just bytes -> do
      digest <- Hash.toByteString <$> Q.expectPrimaryHashByObjectId objectId
      let actualDigest = ByteArray.convert (hash bytes :: Digest SHA3_512) :: Bytes.ByteString
      pure (Just (if digest == actualDigest
        then decodeStoredComponent digest (Lazy.fromStrict bytes)
        else Left "Bend2 component hash does not match stored bytes"))

-- | Exact authored-name lookup for the initial UCM command. Native namespace
-- resolution can later narrow this by project/branch; duplicate results are
-- deliberately reported as ambiguous instead of choosing a historical item.
lookupBendMemberByAuthoredName :: Name -> Transaction (Either String S.Id)
lookupBendMemberByAuthoredName name = do
  matches <- Q.findBendMembersByAuthoredName (Text.pack name)
  pure (case matches of
    [ref] -> Right ref
    [] -> Left ("no stored Bend2 member named " ++ name)
    _ -> Left ("ambiguous stored Bend2 member name " ++ name))

-- | Return the synthetic executable name for the selected native reference
-- together with its dependency-closed Book. CLI can alias this entry as main
-- for the existing HVM full runner without rewriting any component body.
loadDependencyClosedEntryBook :: S.Id -> Transaction (Either String (Name, Book))
loadDependencyClosedEntryBook ref@(Ref.Id objectId memberIndex) = do
  closed <- loadDependencyClosedBook ref
  case closed of
    Left err -> pure (Left err)
    Right book@(Book defs _) -> do
      digest <- Hash.toByteString <$> Q.expectPrimaryHashByObjectId objectId
      let entryName = syntheticMemberName digest (fromIntegral memberIndex)
      pure (if Map.member entryName defs
        then Right (entryName, book)
        else Left ("selected Bend2 reference has no executable definition: " ++ entryName))

-- | Resolve a UCM branch's content-addressed reference to the Bend object it
-- names. This is the route for `bend.run NAME` after UCM namespace resolution.
loadDependencyClosedEntryBookByHashRef :: Ref.Id -> Transaction (Either String (Name, Book))
loadDependencyClosedEntryBookByHashRef (Ref.Id componentHash memberIndex) = do
  maybeObjectId <- Q.loadObjectIdForPrimaryHash componentHash
  case maybeObjectId of
    Nothing -> pure (Left "UCM branch references a missing Bend2 component")
    Just objectId -> do
      maybeBend <- Q.loadBendBytes objectId
      case maybeBend of
        Nothing -> pure (Left "UCM branch reference is not a Bend2 component")
        Just _ -> loadDependencyClosedEntryBook (Ref.Id objectId memberIndex)

-- | Recover authored source locations for a branch-native Bend reference.
loadBendPresentationForHashRef :: Ref.Id -> Transaction (Either String [(Text.Text, Bytes.ByteString, Text.Text)])
loadBendPresentationForHashRef (Ref.Id componentHash memberIndex) = do
  maybeObjectId <- Q.loadObjectIdForPrimaryHash componentHash
  case maybeObjectId of
    Nothing -> pure (Left "UCM branch references a missing Bend2 component")
    Just objectId -> do
      maybeBend <- Q.loadBendBytes objectId
      case maybeBend of
        Nothing -> pure (Left "UCM branch reference is not a Bend2 component")
        Just _ -> do
          forms <- Q.loadBendPresentations objectId memberIndex
          pure (Right [(path,source,name) | (_,source,_,_,name,path) <- forms])

-- | Display a stored Bend definition's own checked type without loading its
-- dependency closure. Ordinary Unison refs return Nothing; malformed native
-- components and missing selected slots remain explicit errors.
loadBendDefinitionTypeTextByHashRef :: Ref.Id -> Transaction (Either String (Maybe Text.Text))
loadBendDefinitionTypeTextByHashRef (Ref.Id componentHash memberIndex) = do
  maybeObjectId <- Q.loadObjectIdForPrimaryHash componentHash
  case maybeObjectId of
    Nothing -> pure (Left "UCM branch references a missing component")
    Just objectId -> do
      maybeBend <- Q.loadBendBytes objectId
      case maybeBend of
        Nothing -> pure (Right Nothing)
        Just _ -> do
          loaded <- loadStoredComponent objectId
          pure $ case loaded of
            Nothing -> Left "Bend component disappeared during type display"
            Just (Left err) -> Left err
            Just (Right (Book defs _)) ->
              let name = syntheticMemberName (Hash.toByteString componentHash) (fromIntegral memberIndex)
               in case Map.lookup name defs of
                    Nothing -> Left ("Bend member has no definition: " ++ name)
                    Just (_,_,typ) -> Right (Just (Text.pack (show typ)))

-- | Export exact canonical bytes together with resolved member dependencies
-- and every retained authored presentation. Branch name/history refs are
-- synchronized by UCM's separate causal namespace protocol.
exportBendSyncEnvelope :: ObjectId -> Transaction (Either String SyncEnvelope)
exportBendSyncEnvelope objectId = do
  loaded <- loadStoredComponent objectId
  case loaded of
    Nothing -> pure (Left "object is not a Bend2 component")
    Just (Left err) -> pure (Left err)
    Just (Right (Book defs hits)) -> do
      bytes <- Q.loadBendBytes objectId
      digest <- Hash.toByteString <$> Q.expectPrimaryHashByObjectId objectId
      let count = Set.size (Map.keysSet defs `Set.union` Map.keysSet hits)
      indexed <- mapM (exportMember objectId) [0 .. count - 1]
      pure (case bytes of
        Nothing -> Left "Bend2 component bytes disappeared during sync export"
        Just blob -> Right (SyncEnvelope digest blob
          (sortOn (\dep -> (dependentMember dep, dependencyDigest dep, dependencyMember dep)) (concatMap fst indexed))
          (concatMap snd indexed)))
  where
    exportMember oid member = do
      refs <- Q.getBendMemberDependencyIds (Ref.Id oid (fromIntegral member))
      deps <- mapM (\(Ref.Id depOid depMember) -> do
        hashBytes <- Hash.toByteString <$> Q.expectPrimaryHashByObjectId depOid
        pure (SyncDependency (fromIntegral member) hashBytes (fromIntegral depMember))) refs
      forms <- Q.loadBendPresentations oid (fromIntegral member)
      pure (deps,
        [SyncPresentation (fromIntegral member) sourceDigest sourceBytes
          (fromIntegral start) (fromIntegral end) (Text.encodeUtf8 name) (Text.encodeUtf8 path)
        | (sourceDigest,sourceBytes,start,end,name,path) <- forms])

-- | Import an envelope only after validating its content hash and resolving
-- all dependency objects. Missing dependencies leave no partial object.
importBendSyncEnvelope :: SyncEnvelope -> Transaction (Either String ObjectId)
importBendSyncEnvelope envelope =
  case encodeSyncEnvelope envelope of
    Left err -> pure (Left err)
    Right _ -> case decodeStoredComponent (componentDigest envelope) (Lazy.fromStrict (componentBytes envelope)) of
      Left err -> pure (Left err)
      Right (Book defs hits) -> do
        let count = Set.size (Map.keysSet defs `Set.union` Map.keysSet hits)
            validMember i = fromIntegral i < count
            inRange = all (validMember . dependentMember) (dependencies envelope)
              && all (validMember . dependencyMember) [dep | dep <- dependencies envelope, dependencyDigest dep == componentDigest envelope]
              && all (validMember . presentationMember) (presentations envelope)
        if not inRange then pure (Left "Bend2 sync envelope member index is out of range") else do
          let (localDeps,externalDeps) =
                foldr (\dep (local,external) -> if dependencyDigest dep == componentDigest envelope
                  then (dep:local,external) else (local,dep:external)) ([],[]) (dependencies envelope)
          resolved <- traverse resolveDependency externalDeps
          case sequence resolved of
            Left err -> pure (Left err)
            Right deps -> do
              let grouped = Map.fromListWith (++) [(dependentMember dep, [ref]) | (dep,ref) <- deps]
                  byMember = [(fromIntegral i, Map.findWithDefault [] (fromIntegral i) grouped) | i <- [0 .. count - 1]]
              oid <- Q.saveBendComponent v2HashHandle (Hash.fromByteString (componentDigest envelope))
                (componentBytes envelope) byMember
              mapM_ (saveLocalDependency oid) localDeps
              mapM_ (saveForm oid) (presentations envelope)
              pure (Right oid)
  where
    resolveDependency dep = do
      maybeOid <- Q.loadObjectIdForPrimaryHash (Hash.fromByteString (dependencyDigest dep))
      case maybeOid of
        Nothing -> pure (Left "missing Bend2 sync dependency")
        Just oid -> do
          maybeBend <- Q.loadBendBytes oid
          pure (case maybeBend of
            Nothing -> Left "Bend2 sync dependency has a non-Bend object type"
            Just _ -> Right (dep, Ref.ReferenceDerived (Ref.Id oid (fromIntegral (dependencyMember dep)))))
    saveForm oid form = Q.saveBendPresentation oid (fromIntegral (presentationMember form))
      (presentationSourceDigest form) (presentationSource form)
      (fromIntegral (presentationStart form)) (fromIntegral (presentationEnd form))
      (Text.decodeUtf8 (presentationName form)) (Text.decodeUtf8 (presentationPath form))
    saveLocalDependency oid dep = Q.addToDependentsIndex
      [Ref.ReferenceDerived (Ref.Id oid (fromIntegral (dependencyMember dep)))]
      (Ref.Id oid (fromIntegral (dependentMember dep)))

-- | Rebuild the complete Bend Book reachable from a native member reference.
-- UCM can hand the result directly to the existing full HVM emitter.
loadDependencyClosedBook :: S.Id -> Transaction (Either String Book)
loadDependencyClosedBook (Ref.Id rootObjectId _) =
  go Set.empty [rootObjectId] (Book Map.empty Map.empty)
  where
    go _ [] book = pure (Right book)
    go visited (objectId : pending) book
      | Set.member objectId visited = go visited pending book
      | otherwise = do
          loaded <- loadStoredComponent objectId
          case loaded of
            Nothing -> do
              actualType <- Q.loadObjectType objectId
              pure (Left (case actualType of
                Nothing -> "missing Bend2 component object " ++ show objectId
                Just ty -> "non-Bend dependency in Bend2 closure: " ++ show ty))
            Just (Left err) -> pure (Left err)
            Just (Right component@(Book defs hits)) ->
              case mergeBook book component of
                Left err -> pure (Left err)
                Right merged -> do
                  let memberCount = Set.size (Map.keysSet defs `Set.union` Map.keysSet hits)
                  dependencies <- concat <$> mapM
                    (Q.getDependencyIdsForDependent . Ref.Id objectId . fromIntegral)
                    [0 .. memberCount - 1]
                  let dependencyObjects =
                        [ depObjectId | Ref.Id depObjectId _ <- dependencies ]
                  go (Set.insert objectId visited) (dependencyObjects ++ pending) merged

    mergeBook (Book existingDefs existingHits) (Book nextDefs nextHits)
      | not (Map.null (Map.intersection existingDefs nextDefs)) =
          Left "duplicate Bend2 definition name in codebase dependency closure"
      | not (Map.null (Map.intersection existingHits nextHits)) =
          Left "duplicate Bend2 HIT name in codebase dependency closure"
      | otherwise =
          Right (Book (Map.union existingDefs nextDefs) (Map.union existingHits nextHits))
