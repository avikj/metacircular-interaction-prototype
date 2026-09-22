{-# LANGUAGE OverloadedStrings #-}
module Main where

import Core.CLI qualified as Bend
import Core.Admission (CheckedSource (..), admitBookWithOrigins)
import Core.Provenance (OriginRole (..), SourceOrigin (..), collectFileOrigins)
import Data.ByteString qualified as Bytes
import Data.Map.Strict qualified as Map
import Data.Text qualified as Text
import Data.Text.Encoding qualified as Text
import System.Directory (makeAbsolute)
import System.FilePath ((</>))

main :: IO ()
main = do
  let directory = "integration/bend2_unison/admission/fixtures/Imports"
  path <- makeAbsolute (directory </> "Main.bend")
  importedPath <- makeAbsolute (directory </> "Library.bend")
  source <- readFile path
  importedSource <- readFile importedPath
  book <- Bend.parseFile path
  origins <- collectFileOrigins path book >>= either fail pure
  checked <- either (const (fail "imported source admission failed")) pure (admitBookWithOrigins path source book origins)
  let mainOrigin = Map.lookup ("main",DefinitionOrigin) (checkedOrigins checked)
      importedOrigin = Map.lookup ("two",DefinitionOrigin) (checkedOrigins checked)
  case (mainOrigin,importedOrigin) of
    (Just mainValue,Just importedValue) -> do
      assert (originPath mainValue == path) "main path"
      assert (originText mainValue == source) "main exact source"
      assert (originPath importedValue == importedPath) "imported path"
      assert (originText importedValue == importedSource) "imported exact source"
      let mainBytes = Text.encodeUtf8 (Text.pack source)
          importedBytes = Text.encodeUtf8 (Text.pack importedSource)
          mainSlice = Bytes.take (originEndByte mainValue - originStartByte mainValue) (Bytes.drop (originStartByte mainValue) mainBytes)
          importedSlice = Bytes.take (originEndByte importedValue - originStartByte importedValue) (Bytes.drop (originStartByte importedValue) importedBytes)
      assert (Bytes.isInfixOf "def main" mainSlice) "main range"
      assert (Bytes.isInfixOf "def two" importedSlice) "imported range"
      assert (not (Bytes.isInfixOf "import Library" mainSlice)) "main range excludes import"
      assert (not (Bytes.isInfixOf "# " importedSlice)) "imported range excludes leading comment"
      putStrLn "per-member imported source provenance passed"
    _ -> fail "expected main and imported member origins"
  cubicalPath <- makeAbsolute "collab/bend2-interactive-cubical/path_transport.bend"
  cubicalSource <- readFile cubicalPath
  cubicalBook <- Bend.parseFile cubicalPath
  cubicalOrigins <- collectFileOrigins cubicalPath cubicalBook >>= either fail pure
  _ <- either (const (fail "cubical HIT provenance admission failed")) pure
    (admitBookWithOrigins cubicalPath cubicalSource cubicalBook cubicalOrigins)
  assert (Map.member ("Segment",DefinitionOrigin) cubicalOrigins &&
          Map.member ("Segment",HitOrigin) cubicalOrigins) "cubical generated member origin"
  putStrLn "cubical checked-book provenance passed"

assert :: Bool -> String -> IO ()
assert True _ = pure ()
assert False message = fail message
