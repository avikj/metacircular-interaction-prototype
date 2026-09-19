module Core.Provenance
  ( OriginRole(..)
  , SourceOrigin(..)
  , OriginMap
  , sourceOrigins
  , collectFileOrigins
  ) where

import Control.Exception (IOException, try)
import Control.Monad (foldM)
import qualified Data.ByteString as Bytes
import qualified Data.Map.Strict as Map
import qualified Data.Set as Set
import qualified Data.Text as Text
import qualified Data.Text.Encoding as Text
import System.Directory (doesFileExist, makeAbsolute)
import System.FilePath (takeDirectory, (</>))

import Core.Import (mergeBooks)
import Core.Parse.Book (doParseBookWithSpans)
import Core.Type (Book(..), Name)

data OriginRole = DefinitionOrigin | HitOrigin
  deriving (Eq, Ord, Show)

data SourceOrigin = SourceOrigin
  { originPath :: FilePath
  , originText :: String
  , originStartByte :: Int
  , originEndByte :: Int
  } deriving (Eq, Show)

type OriginMap = Map.Map (Name, OriginRole) SourceOrigin

-- | Keep explicit module-load lines at their original character width so
-- Megaparsec offsets still address the original authored source. Aliased
-- `import Path as Name` lines stay intact for Bend's ordinary parser.
splitLoadsWithOffsets :: String -> ([FilePath], String)
splitLoadsWithOffsets = go
  where
    go [] = ([], [])
    go input =
      let (line, suffix) = break (== '\n') input
          newline = case suffix of [] -> []; _ : rest -> '\n' : rest
          (laterLoads, laterSource) = go (drop 1 suffix)
       in case words line of
            ["import", path] -> (path : laterLoads, replicate (length line) ' ' ++ take 1 newline ++ laterSource)
            _ -> (laterLoads, line ++ take 1 newline ++ laterSource)

sourceOrigins :: FilePath -> String -> Either String (Book, OriginMap, [FilePath])
sourceOrigins path source = do
  let (loads, parseText) = splitLoadsWithOffsets source
  (book@(Book defs hits), spans) <- doParseBookWithSpans path parseText
  let spanMap = Map.fromList spans
      byteOffset chars = Bytes.length (Text.encodeUtf8 (Text.pack (take chars source)))
      origin name = case Map.lookup name spanMap of
        Nothing -> Left ("Bend declaration has no source span: " ++ name)
        Just (start,end) ->
          Right (SourceOrigin path source (byteOffset start) (byteOffset end))
  definitions <- traverse (\name -> (,) (name,DefinitionOrigin) <$> origin name) (Map.keys defs)
  declarations <- traverse (\name -> (,) (name,HitOrigin) <$> origin name) (Map.keys hits)
  pure (book, Map.fromList (definitions ++ declarations), loads)

-- | Mirror Bend2's explicit module search and its name-based automatic file
-- search, while keeping metadata separate from the checked executable Book.
-- A final coverage check prevents a merged import from being attributed to
-- the requesting source file when its true source cannot be found.
collectFileOrigins :: FilePath -> Book -> IO (Either String OriginMap)
collectFileOrigins entry finalBook = do
  root <- makeAbsolute entry
  explicit <- scanExplicit Set.empty root
  case explicit of
    Left err -> pure (Left err)
    Right (_,origins) -> finish origins Set.empty
  where
    finalKeys (Book defs hits) =
      Set.fromList ([(name,DefinitionOrigin) | name <- Map.keys defs] ++
                    [(name,HitOrigin) | name <- Map.keys hits])
    required = finalKeys finalBook
    finish origins attempted =
      case Set.toAscList (required `Set.difference` Map.keysSet origins) of
        [] -> pure (Right (Map.restrictKeys origins required))
        ((name,_):_) | Set.member name attempted ->
          pure (Left ("Bend imported member has no authored source: " ++ name))
        ((name,_):_) -> do
          candidate <- findAutomatic name
          case candidate of
            Nothing -> pure (Left ("Bend imported member has no source file: " ++ name))
            Just path -> do
              found <- scanExplicit Set.empty path
              case found of
                Left err -> pure (Left err)
                Right (_,more) -> finish (Map.union origins more) (Set.insert name attempted)
    findAutomatic name = firstExisting
      [name ++ ".bend", name ++ ".bend.py", name </> "_.bend", name </> "_.bend.py"]
    firstExisting [] = pure Nothing
    firstExisting (path:rest) = do
      exists <- doesFileExist path
      if exists then Just <$> makeAbsolute path else firstExisting rest

scanExplicit :: Set.Set FilePath -> FilePath -> IO (Either String (Book, OriginMap))
scanExplicit visited path
  | Set.member path visited = pure (Right (Book Map.empty Map.empty, Map.empty))
  | otherwise = do
      readResult <- try (readFile path) :: IO (Either IOException String)
      case readResult of
        Left err -> pure (Left ("Bend source read failed: " ++ show err))
        Right source -> case sourceOrigins path source of
          Left err -> pure (Left ("Bend source parse failed at " ++ path ++ ": " ++ err))
          Right (localBook,localOrigins,loads) ->
            foldM (addImport (Set.insert path visited) (takeDirectory path))
              (Right (localBook,localOrigins)) loads

addImport :: Set.Set FilePath -> FilePath -> Either String (Book,OriginMap) -> FilePath -> IO (Either String (Book,OriginMap))
addImport _ _ (Left err) _ = pure (Left err)
addImport visited directory (Right (book,origins)) modulePath = do
  let local = directory </> (modulePath ++ ".bend")
      cwd = modulePath ++ ".bend"
  localExists <- doesFileExist local
  candidate <- makeAbsolute (if localExists then local else cwd)
  exists <- doesFileExist candidate
  if not exists
    then pure (Left ("Bend module import not found: " ++ modulePath))
    else do
      imported <- scanExplicit visited candidate
      pure (fmap (\(otherBook,otherOrigins) ->
        (mergeBooks book otherBook,Map.union origins otherOrigins)) imported)
