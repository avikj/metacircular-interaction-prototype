{-# LANGUAGE BlockArguments #-}
{-# LANGUAGE OverloadedStrings #-}
module Main where

import Bend.UCM.Storage (saveCheckedSource, exportBendSyncEnvelope)
import Core.Admission (admitBookWithOrigins)
import Core.CLI qualified as Bend
import Core.Provenance (collectFileOrigins)
import Core.SyncEnvelope (SyncEnvelope(..), SyncPresentation(..))
import Data.ByteString qualified as Bytes
import Data.Map.Strict qualified as Map
import Data.Text qualified as Text
import Data.Text.Encoding qualified as Text
import System.Directory (makeAbsolute)
import System.FilePath ((</>))
import System.IO (hClose,openTempFile)
import U.Codebase.Sqlite.Queries qualified as Q
import U.Codebase.Reference qualified as Ref
import Unison.Sqlite qualified as Sqlite

main :: IO ()
main = do
  let directory = "integration/bend2_unison/admission/fixtures/Imports"
  sourcePath <- makeAbsolute (directory </> "Main.bend")
  importedPath <- makeAbsolute (directory </> "Library.bend")
  source <- readFile sourcePath
  importedSource <- readFile importedPath
  book <- Bend.parseFile sourcePath
  origins <- collectFileOrigins sourcePath book >>= either fail pure
  checked <- either (const (fail "imported admission failed")) pure
    (admitBookWithOrigins sourcePath source book origins)
  (databasePath,handle) <- openTempFile "/private/tmp" "bend-import-provenance.sqlite"
  hClose handle
  schema <- readFile "/private/tmp/unison-84b95a623711b57b9ff7163f124b214d626b81e4/codebase2/codebase-sqlite/sql/create.sql"
  Sqlite.withConnection "bend-import-provenance" databasePath \connection -> do
    Sqlite.runTransaction connection do
      Sqlite.executeStatements (Text.pack schema)
      Q.addTempEntityTables
      Q.addBendComponentTables
    saved <- Sqlite.runTransaction connection (saveCheckedSource checked)
    refs <- either fail pure saved
    let Just (Ref.Id mainObject mainMember) = Map.lookup "main" refs
        Just (Ref.Id importedObject importedMember) = Map.lookup "two" refs
    (mainRows,importedRows,importedSync) <- Sqlite.runTransaction connection do
      mainRows <- Q.loadBendPresentations mainObject mainMember
      importedRows <- Q.loadBendPresentations importedObject importedMember
      sync <- exportBendSyncEnvelope importedObject
      pure (mainRows,importedRows,sync)
    checkRows sourcePath source "main" mainRows
    checkRows importedPath importedSource "two" importedRows
    envelope <- either fail pure importedSync
    let importedForms = [p | p <- presentations envelope,
          presentationName p == "two"]
    assert (any (\p -> presentationPath p == Text.encodeUtf8 (Text.pack importedPath) &&
      presentationSource p == Text.encodeUtf8 (Text.pack importedSource)) importedForms)
      "sync envelope lost imported source"
    putStrLn "native imported presentation + sync provenance passed"

checkRows path source name rows = case rows of
  [(_,bytes,start,end,authored,storedPath)] -> do
    assert (bytes == Text.encodeUtf8 (Text.pack source)) "stored source bytes"
    assert (authored == name && storedPath == Text.pack path) "stored authored path"
    let selected = Bytes.take (fromIntegral (end-start)) (Bytes.drop (fromIntegral start) bytes)
    assert (Bytes.isInfixOf (Text.encodeUtf8 ("def " <> name)) selected) "stored declaration byte range"
  _ -> fail "expected exactly one imported presentation"

assert True _ = pure ()
assert False message = fail message
