{-# LANGUAGE BlockArguments #-}
module Main where

import Bend.UCM.Execution (output, runCheckedBook, selectEntryAsMain)
import Bend.UCM.Storage
  ( saveCheckedSource, loadDependencyClosedEntryBook, exportBendSyncEnvelope )
import Core.SyncEnvelope (SyncEnvelope(..))
import Core.Admission (CheckedSource(..), admitSource)
import Core.ComponentPlan (AddressedComponent(..), ComponentPlan(..), addressComponents)
import qualified Data.Map.Strict as Map
import Data.List (find)
import qualified Data.Text as Text
import qualified U.Codebase.Sqlite.Queries as Q
import qualified U.Codebase.Sqlite.Entity as Entity
import U.Codebase.Sqlite.V2.HashHandle (v2HashHandle)
import qualified U.Codebase.Reference as Ref
import qualified Unison.Hash as Hash
import qualified Unison.Hash32 as Hash32
import qualified Unison.Sqlite as Sqlite
import System.Environment (getArgs)
import System.IO (hClose, openTempFile)

main :: IO ()
main = do
  [sourcePath,hvmPath] <- getArgs
  source <- readFile sourcePath
  checked <- either (const (fail "Bend source admission failed")) pure (admitSource sourcePath source)
  components <- either fail pure (addressComponents checked)
  (firstPath,firstHandle) <- openTempFile "/private/tmp" "bend-native-first.sqlite"
  hClose firstHandle
  (secondPath,secondHandle) <- openTempFile "/private/tmp" "bend-native-second.sqlite"
  hClose secondHandle
  original <- runCheckedBook hvmPath (checkedBook checked)
  originalOutput <- either (fail . show) (pure . output) original
  Sqlite.withConnection "bend-first" firstPath \first -> do
    prepare first
    saved <- Sqlite.runTransaction first (saveCheckedSource checked)
    refs <- either fail pure saved
    mainRef <- maybe (fail "main has no native reference") pure (Map.lookup "main" refs)
    firstLoaded <- Sqlite.runTransaction first (loadDependencyClosedEntryBook mainRef)
    (firstEntry,firstBook) <- either fail pure firstLoaded
    firstRunnable <- either fail pure (selectEntryAsMain firstEntry firstBook)
    firstRun <- runCheckedBook hvmPath firstRunnable
    firstOutput <- either (fail . show) (pure . output) firstRun
    assertExecution originalOutput firstOutput
    envelopes <- Sqlite.runTransaction first $ mapM (\addressed -> do
      let digest = Hash.fromByteString (addressedDigest addressed)
      oid <- Q.expectObjectIdForPrimaryHash digest
      exported <- exportBendSyncEnvelope oid
      syncEntity <- Q.expectEntity (Hash32.fromHash digest)
      temp <- Q.syncToTempEntity syncEntity
      pure (exported,temp,case (syncEntity,temp) of
        (Entity.B _,Entity.B _) -> True
        _ -> False)) components
    imported <- mapM (either fail pure . (\(value,_,_) -> value)) envelopes
    if all (\(_,_,ok) -> ok) envelopes then pure () else fail "Bend sync temp format differs"
    Sqlite.withConnection "bend-second" secondPath \second -> do
      prepare second
      results <- Sqlite.runTransaction second $ sequence
        [Q.saveTempEntityInMain v2HashHandle
          (Hash32.fromHash (Hash.fromByteString (addressedDigest addressed))) temp
        | (addressed,(_,temp,_)) <- zip components envelopes]
      if all isBendResult results then pure () else fail "Bend sync temp entity did not save as a Bend object"
      mainComponent <- maybe (fail "main addressed component is absent") pure
        (find (elem "main" . componentNames . addressedPlan) components)
      let mainDigest = addressedDigest mainComponent
      secondMainId <- Sqlite.runTransaction second $ do
        oid <- Q.expectObjectIdForPrimaryHash (Hash.fromByteString mainDigest)
        let Ref.Id _ mainIndex = mainRef
        pure (Ref.Id oid mainIndex)
      secondLoaded <- Sqlite.runTransaction second (loadDependencyClosedEntryBook secondMainId)
      (secondEntry,secondBook) <- either fail pure secondLoaded
      secondRunnable <- either fail pure (selectEntryAsMain secondEntry secondBook)
      secondRun <- runCheckedBook hvmPath secondRunnable
      secondOutput <- either (fail . show) (pure . output) secondRun
      assertExecution originalOutput secondOutput
      reexported <- Sqlite.runTransaction second $ mapM (\addressed -> do
        oid <- Q.expectObjectIdForPrimaryHash (Hash.fromByteString (addressedDigest addressed))
        exportBendSyncEnvelope oid) components
      replayed <- mapM (either fail pure) reexported
      if replayed == imported then pure () else
        fail ("Bend sync import lost dependencies or authored presentations: " ++
          show [(i, dependencies a, dependencies b, length (presentations a), length (presentations b)) |
            (i,a,b) <- zip3 [0 :: Int ..] imported replayed, a /= b])
      putStrLn ("native Transaction + sync import/export: " ++ show (length components) ++ " components, 0 #4992")

isBendResult :: Either a b -> Bool
isBendResult result = case result of
  Right _ -> True
  Left _ -> False

prepare :: Sqlite.Connection -> IO ()
prepare connection = do
  let sqlRoot = "/private/tmp/unison-84b95a623711b57b9ff7163f124b214d626b81e4/codebase2/codebase-sqlite/sql/"
  createSql <- readFile (sqlRoot ++ "create.sql")
  Sqlite.runTransaction connection $ do
    Sqlite.executeStatements (Text.pack createSql)
    Q.addTempEntityTables
    Q.addBendComponentTables

assertExecution :: String -> String -> IO ()
assertExecution expected actual =
  let stable = \value -> (take 1 (lines value), filter (\line ->
        take 7 line == "- Itrs:") (lines value))
   in if stable expected == stable actual then pure () else fail ("native HVM result differs: " ++ show (stable expected, stable actual))
