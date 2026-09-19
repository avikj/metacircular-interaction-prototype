{-# LANGUAGE LambdaCase #-}
{-# LANGUAGE ScopedTypeVariables #-}

-- | Executable Bend2 source entry for the UCM integration. This exercises the
-- same admission and full HVM4 execution boundaries that UCM will call after
-- resolving native Bend components from its codebase.
module Main (main) where

import Bend.UCM.Execution (ExecutionError (..), ExecutionResult (..), runCheckedBook)
import Control.Concurrent (threadDelay)
import Control.Exception (IOException, evaluate, try)
import Core.Admission (AdmissionError (..), CheckedSource (..), admitBook)
import Core.CLI (parseFile)
import Core.Type (Book)
import Data.List (intercalate)
import System.Environment (getArgs, lookupEnv)
import System.Exit (ExitCode, exitFailure)
import System.IO (hFlush, hPutStr, hPutStrLn, stderr, stdout)

data Command = Check FilePath | Run FilePath | Watch FilePath

main :: IO ()
main = do
  args <- getArgs
  command <- case args of
    ["check", path] -> pure (Check path)
    ["run", path] -> pure (Run path)
    ["watch", path] -> pure (Watch path)
    _ -> die "usage: bend-ucm-proto (check|run|watch) FILE.bend"
  hvm <- maybe "hvm" id <$> lookupEnv "HVM4"
  case command of
    Check path -> loadAndCheck path >>= either die (const $ putStrLn "checked")
    Run path -> loadAndCheck path >>= either die (execute hvm)
    Watch path -> watchFile hvm path

-- | Core.CLI.parseFile already resolves Bend2 imports. Admission runs the
-- existing checker against that whole Book without terminal-side effects.
loadAndCheck :: FilePath -> IO (Either String CheckedSource)
loadAndCheck path = do
  readResult <- try (readFile path >>= \source -> evaluate (length source) >> pure source)
  case readResult of
    Left (err :: IOException) -> pure (Left (show err))
    Right source -> do
      parsed <- try (parseFile path) :: IO (Either ExitCode Book)
      pure $ case parsed of
        Left status -> Left ("Bend2 import or parse failed: " ++ show status)
        Right book -> either (Left . renderAdmission) Right (admitBook path source book)

execute :: FilePath -> CheckedSource -> IO ()
execute hvm checked = do
  outcome <- runCheckedBook hvm (checkedBook checked)
  case outcome of
    Left err -> die (renderExecution err)
    Right (ExecutionResult out diagnostics) -> do
      putStr out
      hFlush stdout
      hPutStr stderr diagnostics

-- | Source-change preview until the native UCM file event is connected.
-- Every change is re-admitted; only checked Books reach HVM4.
watchFile :: FilePath -> FilePath -> IO ()
watchFile hvm path = loop Nothing
  where
    loop previous = do
      current <- try (readFile path >>= \source -> evaluate (length source) >> pure source)
      case current of
        Left (err :: IOException) -> do
          hPutStrLn stderr ("watch: " ++ show err)
          threadDelay 250000
          loop previous
        Right source -> do
          if Just source == previous
            then threadDelay 250000 >> loop previous
            else do
              putStrLn ("changed: " ++ path)
              hFlush stdout
              admitted <- loadAndCheck path
              case admitted of
                Left err -> hPutStrLn stderr err
                Right checked -> execute hvm checked
              threadDelay 250000
              loop (Just source)

renderAdmission :: AdmissionError -> String
renderAdmission = \case
  ParseFailure err -> "parse: " ++ err
  DefinitionTypeFailure name err -> "type of " ++ name ++ ": " ++ show err
  DefinitionTermFailure name err -> "definition " ++ name ++ ": " ++ show err
  HitTypeFailure name err -> "HIT " ++ name ++ ": " ++ show err
  HitConstructorFailure hit ctor err -> "HIT " ++ hit ++ "." ++ ctor ++ ": " ++ show err

renderExecution :: ExecutionError -> String
renderExecution = \case
  MissingMain -> "run: checked Book has no main definition"
  HvmIoError err -> "HVM4 I/O: " ++ show err
  HvmFailure status out diagnostics -> intercalate "\n" ["HVM4: " ++ show status, out, diagnostics]

die :: String -> IO a
die message = hPutStrLn stderr message >> exitFailure
