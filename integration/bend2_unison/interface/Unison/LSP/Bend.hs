{-# LANGUAGE OverloadedStrings #-}

module Unison.LSP.Bend
  ( isBendUri
  , checkBendFile
  , bendHover
  , bendDefinition
  ) where

import Bend.UCM.Storage (loadDependencyClosedEntryBookByHashRef,loadBendPresentationForHashRef)
import Core.Deps (getDeps)
import Core.LspAnalysis
import Core.Provenance (OriginRole(..),SourceOrigin(..),sourceOrigins)
import Core.Type (Book(..),Span(..),hitCtors,hitType,ctorType)
import qualified Data.ByteString as Bytes
import qualified Data.Map.Strict as Map
import qualified Data.Set as Set
import qualified Data.Text as Text
import Data.Text.Encoding (decodeUtf8')
import Numeric (showHex)
import Network.URI (escapeURIString,isUnreserved)
import System.Directory (makeAbsolute)
import Language.LSP.Protocol.Lens (HasCharacter(character),HasLine(line))
import Language.LSP.Protocol.Types
import Unison.LSP.Diagnostics (mkDiagnostic,reportDiagnostics)
import Unison.LSP.Types (Lsp,Env(..),getCurrentNames)
import qualified Unison.LSP.VFS as VFS
import qualified Unison.Codebase as Codebase
import Unison.Sqlite (Transaction)
import qualified U.Codebase.Reference as Ref
import Control.Monad.Reader (asks)
import qualified Unison.Names as Names
import qualified Unison.Referent as Referent
import qualified Bend.UCM.Name as BendName
import Unison.Prelude hiding (hoistMaybe)

isBendUri :: Uri -> Bool
isBendUri = Text.isSuffixOf ".bend" . getUri

checkBendFile :: Uri -> Lsp ()
checkBendFile uri = do
  source <- runMaybeT (VFS.getFileContents uri)
  for_ source $ \(version,contents) -> do
    outcome <- analyzeBendBuffer uri contents
    let diagnostics = case outcome of
          Right _ -> []
          Left failure ->
            [mkDiagnostic uri (maybe (wholeFile contents) bendRange (diagnosticSpan failure))
              DiagnosticSeverity_Error [] (Text.pack (diagnosticMessage failure)) []]
    reportDiagnostics uri (Just version) diagnostics

bendHover :: Uri -> Position -> Lsp (Maybe Hover)
bendHover uri pos = runMaybeT do
  (_,contents) <- VFS.getFileContents uri
  analysis <- hoistMaybe . either (const Nothing) Just =<< lift (analyzeBendBuffer uri contents)
  (typ,span) <- hoistMaybe (bendHoverAt analysis (bendPosition pos))
  let address = case bendReferenceAt analysis (bendPosition pos) of
        Nothing -> ""
        Just (digest,member) ->
          "\nComponent `" ++ hexBytes digest ++ "/" ++ show member ++ "`"
  pure Hover
    { _contents = InL (MarkupContent MarkupKind_Markdown
        (Text.pack ("```bend\n: " ++ typ ++ "\n```" ++ address)))
    , _range = bendRange <$> span
    }

bendDefinition :: Uri -> Position -> Lsp (Maybe (Uri,Range))
bendDefinition uri pos = runMaybeT do
  (_,contents) <- VFS.getFileContents uri
  analysis <- hoistMaybe . either (const Nothing) Just =<< lift (analyzeBendBuffer uri contents)
  name <- hoistMaybe (bendDefinitionNameAt analysis (bendPosition pos))
  case bendDefinitionAt analysis (bendPosition pos) of
    Just span -> pure (uri,bendRange span)
    Nothing -> do
      names <- lift getCurrentNames
      ref <- hoistMaybe (either (const Nothing) Just (branchRef names name))
      cb <- asks codebase
      presentations <- liftIO (Codebase.runTransaction cb (loadBendPresentationForHashRef ref))
      rows <- hoistMaybe (either (const Nothing) Just presentations)
      (sourcePath,sourceBytes,authoredName) <- hoistMaybe (listToMaybe rows)
      sourceText <- hoistMaybe (either (const Nothing) Just (decodeUtf8' sourceBytes))
      (_,origins,_) <- hoistMaybe (either (const Nothing) Just
        (sourceOrigins (Text.unpack sourcePath) (Text.unpack sourceText)))
      targetOrigin <- hoistMaybe (Map.lookup (Text.unpack authoredName,DefinitionOrigin) origins <|>
        Map.lookup (Text.unpack authoredName,HitOrigin) origins)
      targetSpan <- hoistMaybe (declarationNameSpan (Text.unpack authoredName) targetOrigin)
      absolutePath <- liftIO (makeAbsolute (Text.unpack sourcePath))
      let targetUri = Uri (Text.pack ("file://" ++
            escapeURIString (\c -> c == '/' || isUnreserved c) absolutePath))
      pure (targetUri,bendRange targetSpan)

analyzeBendBuffer :: Uri -> Text.Text -> Lsp (Either BendDiagnostic BendAnalysis)
analyzeBendBuffer uri contents =
  case fmap (\(book,_,_) -> book) (sourceOrigins (Text.unpack (getUri uri)) (Text.unpack contents)) of
    Left reason -> pure (Left (BendDiagnostic Nothing reason))
    Right local -> do
      cb <- asks codebase
      names <- getCurrentNames
      assembled <- liftIO (Codebase.runTransaction cb (resolveImports names local))
      pure $ case assembled of
        Left reason -> Left (BendDiagnostic Nothing reason)
        Right book -> analyzeBendBook (Text.unpack (getUri uri)) (Text.unpack contents) book local

resolveImports :: Names.Names -> Book -> Transaction (Either String Book)
resolveImports names local@(Book defs hits) = do
  let localNames = Map.keysSet defs `Set.union` Map.keysSet hits
      dependencies = Set.unions
        ( [getDeps body `Set.union` getDeps typ | (_,body,typ) <- Map.elems defs]
       ++ [getDeps (hitType hit) `Set.union` Set.unions (map (getDeps . ctorType . snd) (hitCtors hit))
          | hit <- Map.elems hits])
      external = Set.toAscList (dependencies `Set.difference` localNames)
  foldM add (Right local) external
  where
    add (Left reason) _ = pure (Left reason)
    add (Right book) imported = do
      let ref = branchRef names imported
      case ref of
        Left reason -> pure (Left reason)
        Right nativeRef -> do
          loaded <- loadDependencyClosedEntryBookByHashRef nativeRef
          pure $ do
            (synthetic,Book dependencyDefs dependencyHits) <- loaded
            let Book currentDefs currentHits = book
                aliasDefs = maybe Map.empty (Map.singleton imported) (Map.lookup synthetic dependencyDefs)
                aliasHits = maybe Map.empty (Map.singleton imported) (Map.lookup synthetic dependencyHits)
            if Map.null aliasDefs && Map.null aliasHits
              then Left ("stored Bend2 dependency has no member: " ++ imported)
              else Right (Book
                (Map.unions [currentDefs,aliasDefs,dependencyDefs])
                (Map.unions [currentHits,aliasHits,dependencyHits]))

branchRef :: Names.Names -> String -> Either String Ref.Id
branchRef names imported = do
  let unisonName = Text.replace "/" "." (Text.pack imported)
  parsed <- BendName.fromBendName unisonName
  case Set.toList (Names.termsNamed names parsed) of
    [referent] -> maybe (Left ("Bend import is not a term: " ++ imported))
      Right (Referent.toTermReferenceId referent)
    [] -> Left ("Bend import is absent from current branch: " ++ imported)
    _ -> Left ("ambiguous Bend import in current branch: " ++ imported)

declarationNameSpan :: String -> SourceOrigin -> Maybe Span
declarationNameSpan name origin = do
  let source = encodeUtf8 (Text.pack (originText origin))
      declaration = Bytes.drop (originStartByte origin) source
      keywordLength
        | "def " `Bytes.isPrefixOf` declaration = Just 4
        | "type " `Bytes.isPrefixOf` declaration = Just 5
        | otherwise = Nothing
  width <- keywordLength
  let nameBytes = encodeUtf8 (Text.pack name)
      nameStart = originStartByte origin + width
  if not (nameBytes `Bytes.isPrefixOf` Bytes.drop nameStart source)
    then Nothing
    else do
      prefix <- either (const Nothing) Just (decodeUtf8' (Bytes.take nameStart source))
      let line = 1 + Text.count "\n" prefix
          column = 1 + Text.length (Text.takeWhileEnd (/= '\n') prefix)
      pure (Span (line,column) (line,column + Text.length (Text.pack name) - 1)
        (originPath origin))

hoistMaybe :: Maybe a -> MaybeT Lsp a
hoistMaybe = MaybeT . pure

bendPosition :: Position -> (Int,Int)
bendPosition pos = (fromIntegral (pos ^. line) + 1,fromIntegral (pos ^. character) + 1)

bendRange :: Span -> Range
bendRange span =
  let (bl,bc) = spanBeg span
      (el,ec) = spanEnd span
  in Range (Position (fromIntegral (max 0 (bl-1))) (fromIntegral (max 0 (bc-1))))
           (Position (fromIntegral (max 0 (el-1))) (fromIntegral (max 0 ec)))

wholeFile :: Text.Text -> Range
wholeFile contents =
  let rows = Text.lines contents
      endLine = max 0 (length rows - 1)
      endColumn = if null rows then 0 else Text.length (last rows)
  in Range (Position 0 0) (Position (fromIntegral endLine) (fromIntegral endColumn))

hexBytes :: Bytes.ByteString -> String
hexBytes = concatMap (\byte -> let value = showHex byte "" in if length value == 1 then '0':value else value) . Bytes.unpack
