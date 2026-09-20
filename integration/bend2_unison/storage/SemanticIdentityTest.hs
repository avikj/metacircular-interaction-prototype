{-# LANGUAGE BlockArguments #-}
{-# LANGUAGE OverloadedStrings #-}
module Main where

import Bend.UCM.Storage (saveCheckedSource)
import Core.Admission (admitSource)
import Core.SemanticIdentity (checkedNatIdentity,semanticVersion)
import Data.ByteString qualified as Bytes
import Data.Map.Strict qualified as Map
import Data.Text qualified as Text
import System.IO (hClose,openTempFile)
import U.Codebase.Reference qualified as Ref
import U.Codebase.Sqlite.Queries qualified as Q
import Unison.Hash qualified as Hash
import Unison.Sqlite qualified as Sqlite

main :: IO ()
main = do
  let path = "integration/bend2_unison/storage/fixtures/SemanticNat.bend"
  source <- readFile path
  checked <- either (const (fail "semantic fixture must check")) pure (admitSource path source)
  direct <- maybe (fail "direct has no finite semantic identity") pure
    (checkedNatIdentity checked "direct")
  beta <- maybe (fail "beta has no finite semantic identity") pure
    (checkedNatIdentity checked "beta")
  assert (direct == beta) "Bend checker did not establish beta-equivalent identity"
  assert (checkedNatIdentity checked "alias" == Nothing)
    "reference-bearing definition unexpectedly indexed"
  (databasePath,handle) <- openTempFile "/private/tmp" "bend-semantic.sqlite"
  hClose handle
  schema <- readFile "/private/tmp/unison-84b95a623711b57b9ff7163f124b214d626b81e4/codebase2/codebase-sqlite/sql/create.sql"
  Sqlite.withConnection "bend-semantic" databasePath \connection -> do
    Sqlite.runTransaction connection do
      Sqlite.executeStatements (Text.pack schema)
      Q.addTempEntityTables
      Q.addBendComponentTables
    saved <- Sqlite.runTransaction connection (saveCheckedSource checked)
    refs <- either fail pure saved
    let Just directRef@(Ref.Id directObject _) = Map.lookup "direct" refs
        Just betaRef@(Ref.Id betaObject _) = Map.lookup "beta" refs
        Just aliasRef = Map.lookup "alias" refs
    assert (directObject /= betaObject) "exact structural objects unexpectedly merged"
    found <- Sqlite.runTransaction connection
      (Q.findBendMembersBySemanticIdentity semanticVersion (Hash.fromByteString direct))
    assert (length found == 2 && directRef `elem` found && betaRef `elem` found)
      "native semantic index did not find both beta-equivalent members"
    assert (aliasRef `notElem` found) "native semantic index included unsupported alias"
    assert (Bytes.length direct == 64) "semantic digest length"
    putStrLn "checked Nat beta identity + native SQLite lookup passed"

assert :: Bool -> String -> IO ()
assert True _ = pure ()
assert False message = fail message
