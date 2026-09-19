-- | Native execution entry for Bend2 components resolved from a UCM codebase.
-- The caller supplies a checked, dependency-closed Book with a `main` entry.
-- This module does not reinterpret Bend2 terms or replace its HVM4 runtime.
module Bend.UCM.Execution
  ( ExecutionError (..),
    ExecutionResult (..),
    compileCheckedBook,
    selectEntryAsMain,
    runCheckedBook,
    runCompiledNetFile,
  )
where

import Control.Exception (IOException, bracket, try)
import Control.Monad (unless)
import qualified Data.Map as Map
import Core.Type (Book (..))
import Core.Type (Name)
import Core.Reify (Flat (..), reflectDefn, reflectHit, reifyDefn, reifyHit)
import System.Directory (getTemporaryDirectory, removeFile)
import System.Exit (ExitCode (..))
import System.IO (Handle, hClose, hIsClosed, hPutStr, openTempFile)
import System.Process (readProcessWithExitCode)
import qualified Target.HVM4Full as HVM4Full

data ExecutionError
  = MissingMain
  | HvmIoError IOException
  | HvmFailure ExitCode String String
  deriving (Show)

data ExecutionResult = ExecutionResult
  { output :: String,
    diagnostics :: String
  }
  deriving (Eq, Show)

-- | Emit exactly Bend2's existing full cubical target. The codebase's
-- addressing and artifact cache belong outside the net and this function.
compileCheckedBook :: Book -> Either ExecutionError String
compileCheckedBook book@(Book definitions _)
  | Map.member "main" definitions = Right (HVM4Full.compileFull book)
  | otherwise = Left MissingMain

-- | Select a persisted member without emitting a duplicate definition.
-- Refs to the selected synthetic name, including recursive refs, follow the
-- key rename. HIT names and constructor tags remain untouched.
selectEntryAsMain :: Name -> Book -> Either String Book
selectEntryAsMain entry (Book definitions hits)
  | entry == "main" = Right (Book definitions hits)
  | Map.member "main" definitions = Left "dependency closure already defines main"
  | otherwise = case Map.lookup entry definitions of
      Nothing -> Left ("selected member is not an executable definition: " ++ entry)
      Just _ -> do
        renamedDefinitions <- traverse (reflectDefn . renameFlat . reifyDefn) definitions
        renamedHits <- traverse (reflectHit . renameFlat . reifyHit) hits
        let selected = renamedDefinitions Map.! entry
        pure (Book (Map.insert "main" selected (Map.delete entry renamedDefinitions)) renamedHits)
  where
    renameFlat (Global name) | name == entry = Global "main"
    renameFlat (Node tag children) = Node tag (map renameFlat children)
    renameFlat atom = atom

-- | Run the emitted net. A UCM reference must first be resolved into a
-- checked Book, including the complete term and HIT dependency closure.
-- HVM is invoked once per run; there is no codebase lookup in reduction.
runCheckedBook :: FilePath -> Book -> IO (Either ExecutionError ExecutionResult)
runCheckedBook hvm book = case compileCheckedBook book of
  Left err -> pure (Left err)
  Right net -> do
    outcome <- try (withTempNet net (runCompiledNetFile hvm))
    pure (either (Left . HvmIoError) id outcome)

-- | Run an emitted artifact from a codebase cache without recompiling it.
-- The cache owner is responsible for the Book/emitter/runtime version key.
runCompiledNetFile :: FilePath -> FilePath -> IO (Either ExecutionError ExecutionResult)
runCompiledNetFile hvm netPath = do
  outcome <- try (readProcessWithExitCode hvm [netPath, "-s", "-C10"] "")
  pure $ case outcome of
    Left err -> Left (HvmIoError err)
    Right (ExitSuccess, stdout, stderr) -> Right (ExecutionResult stdout stderr)
    Right (status, stdout, stderr) -> Left (HvmFailure status stdout stderr)

withTempNet :: String -> (FilePath -> IO a) -> IO a
withTempNet net action = do
  directory <- getTemporaryDirectory
  bracket
    (openTempFile directory "bend-ucm-net.hvm4")
    cleanup
    (\(path, handle) -> do
        hPutStr handle net
        hClose handle
        action path
    )
  where
    cleanup :: (FilePath, Handle) -> IO ()
    cleanup (path, handle) = do
      closed <- hIsClosed handle
      unless closed (hClose handle)
      removeFile path
