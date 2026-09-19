module Bend.UCM.Display (DisplayNames, loadDisplayNames, displayTypeText) where

import Bend.UCM.Storage qualified as Storage
import Core.CanonicalComponent (parseSyntheticMemberName, syntheticConstructorName)
import Core.Provenance (sourceOrigins)
import Core.Type (Book (..), HitDecl (..))
import Data.Foldable (toList)
import Data.Map.Strict qualified as Map
import Data.Set qualified as Set
import Data.Text qualified as Text
import Data.Text.Encoding qualified as TextE
import U.Codebase.Reference (Id' (Id))
import Unison.Hash qualified as Hash
import Unison.Name qualified as Name
import Unison.NameSegment qualified as NameSegment
import Unison.Names (Names)
import Unison.Names qualified as Names
import Unison.Reference qualified as Reference
import Unison.Referent qualified as Referent
import Unison.Sqlite (Transaction)

data DisplayNames = DisplayNames Names (Map.Map String String)

-- | Constructors have no branch entry. Resolve their authored spelling by
-- ordinal from each HIT's stored presentation.
loadDisplayNames :: Names -> Transaction DisplayNames
loadDisplayNames names = do
  groups <- traverse constructorsFor (Set.toList (Names.typeReferences names))
  let occurrences = Map.fromListWith Set.union
        [ (token, Set.singleton authored) | group <- groups, (token, authored) <- group ]
      unique = Map.mapMaybe (\choices -> case Set.toList choices of
        [authored] -> Just authored
        _ -> Nothing) occurrences
  pure (DisplayNames names unique)
  where
    constructorsFor (Reference.DerivedId ref@(Id digest slot)) = do
      found <- Storage.loadBendPresentationForHashRef ref
      pure $ case found of
        Left _ -> []
        Right forms -> concatMap (oneForm (Hash.toByteString digest) (fromIntegral slot)) forms
    constructorsFor _ = pure []

    oneForm digest slot (path, bytes, hitName) =
      case TextE.decodeUtf8' bytes of
        Left _ -> []
        Right source -> case sourceOrigins (Text.unpack path) (Text.unpack source) of
          Left _ -> []
          Right (Book _ hits, _, _) ->
            case Map.lookup (Text.unpack hitName) hits of
              Nothing -> []
              Just hit ->
                [ (syntheticConstructorName digest slot ordinal, authored)
                | (ordinal, (authored, _)) <- zip [0 ..] (hitCtors hit) ]

-- | Resolve an exact canonical token against the selected branch. If aliases
-- make its display name ambiguous, preserve the content-addressed token.
displayFlatName :: DisplayNames -> String -> String
displayFlatName (DisplayNames names constructors) token =
  case Map.lookup token constructors of
    Just authored -> authored
    Nothing -> case parseSyntheticMemberName token of
      Nothing -> token
      Just (digest, member) ->
        let ref = Reference.DerivedId (Id (Hash.fromByteString digest) (fromIntegral member))
            candidates = Names.namesForReferent names (Referent.Ref ref)
              `Set.union` Names.namesForReference names ref
         in case Set.toList candidates of
              [name] -> Text.unpack (Text.intercalate (Text.pack ".")
                (map NameSegment.toUnescapedText (toList (Name.segments name))))
              _ -> token

-- | Bend's existing checked-type printer emits canonical names as identifier
-- tokens. Rewrite only complete identifiers; punctuation and binders remain
-- exactly as printed by Bend.
displayTypeText :: DisplayNames -> Text.Text -> Text.Text
displayTypeText names = Text.pack . go . Text.unpack
  where
    go [] = []
    go input@(char : rest)
      | identifier char =
          let (token, remaining) = span identifier input
           in displayFlatName names token ++ go remaining
      | otherwise = char : go rest

    identifier char =
      ('a' <= char && char <= 'z')
        || ('A' <= char && char <= 'Z')
        || ('0' <= char && char <= '9')
        || char == '_'
