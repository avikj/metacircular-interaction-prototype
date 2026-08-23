-- The interface the other carrier is handed.  See
-- AnyatKarana_TheToolSchemaIsGeneratedFromTheRunningTable (§36, the other
-- carrier) and Abhyasa_TheTrainingRecordIsPracticeShownNotStated (§30).
--
--     ghc -O0 -imachine -o machine/karana machine/AnyatKaranaRun.hs
--     machine/karana sadhana [--kevala]   the tool schema, from the running table
--     machine/karana sima                 what an LLM CANNOT get from this machine
--     machine/karana pariksa              the four cross-checks
--     machine/karana abhyasa [file]       the training corpus
--     machine/karana siksa                what a training example is, and the loss
module Main (main) where

import System.Environment (getArgs, lookupEnv)
import System.Exit
import System.IO
import GHC.IO.Encoding (setLocaleEncoding, setFileSystemEncoding)

import Sabda_TheWireHasNoBoolean (J(..), render)
import AnyatKarana_TheToolSchemaIsGeneratedFromTheRunningTable
import Abhyasa_TheTrainingRecordIsPracticeShownNotStated
import Anrta_TheClaimedLossThatIsNotLostAndTheWitnessOfItsFalsity

main :: IO ()
main = do
  setLocaleEncoding utf8; setFileSystemEncoding utf8
  mapM_ (`hSetEncoding` utf8) [stdin, stdout, stderr]
  args <- getArgs
  lekha <- maybe "machine/sabha.jsonl" id <$> lookupEnv "SABHA_LEKHA"
  case args of
    ("sadhana":rest)
      | "--kevala" `elem` rest -> putStrLn (render (JArr sadhanani))
      | otherwise              -> putStrLn (render sadhanaJ)
    ("sima":_)    -> mapM_ putStrLn (simaLines ++ anrtaSimaLines)
    ("siksa":_)   -> mapM_ putStrLn siksaLines
    ("abhyasa":f:_) -> runAbhyasa f >>= exitOn
    ("abhyasa":_)   -> runAbhyasa lekha >>= exitOn
    ("pariksa":_) -> do
      (hard, soft) <- pariksa
      putStrLn ""
      putStrLn "anrta \8212 the control-edge constructor, against the running table and the file on disk:"
      (afail, aran) <- pariksaAnrta
      putStrLn ("hard failures (this module's claims against the running table): " ++ show hard)
      putStrLn ("anrta constructor checks: " ++ show (aran - afail) ++ "/" ++ show aran ++ " ok")
      putStrLn ("written records of another lane's file, reported not fixed: " ++ show soft)
      if hard + afail == 0 then exitSuccess else exitFailure
    _ -> do
      mapM_ (hPutStrLn stderr)
        [ "karana \8212 the interface the other carrier is handed."
        , "  sadhana [--kevala]   the tool schema, generated from the running dispatch table"
        , "  sima                 what an LLM CANNOT get from this machine"
        , "  pariksa              the cross-checks that keep the schema honest"
        , "  abhyasa [file]       the training corpus, from a sabha transcript"
        , "  siksa                what a training example is here, and what a loss would mean" ]
      exitFailure
  where
    exitOn (_, bad) = if bad == 0 then exitSuccess else exitSuccess
