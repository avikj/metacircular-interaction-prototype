-- मुख — the mouth.  THE ONE UNJUDGED FILE.
--
-- This driver contains no proposing logic: every candidate it utters is
-- computed by the Haskell that MAlonzo emitted from the CHECKED proposer
-- (formal/executable/Prastava.agda).  What remains here is exactly the
-- IO boundary the kernel cannot judge, kept small enough to read in one
-- breath: read the refusal list, hand each line to the checked proposer,
-- write each candidate to the store, ask the kernel, keep the receipt.
--
--   utter  = d_run_422 (checked)
--   judge  = agda (the kernel)
--   keep   = the store (formal/cubical/Prastuta/ + phala.tsv)
--   re-read= the next run starts from the store's refusals
--
-- Build and run (from the repository root):
--   sh formal/executable/run-mukha.sh machine/sanghatta-report-2026-08-23.txt
module Main (main) where

import qualified Data.Text as T
import qualified Data.Text.IO as TIO
import qualified PrastavaAPI as P
import System.Environment (getArgs)
import System.Exit (ExitCode (..), exitFailure)
import System.Process (readCreateProcessWithExitCode, proc, cwd, env)
import System.Directory (createDirectoryIfMissing, removeFile, doesFileExist)
import System.IO (hSetEncoding, stdout, utf8)
import GHC.IO.Encoding (setLocaleEncoding)
import Control.Monad (forM_, unless)
import Data.List (isInfixOf)
import qualified System.Environment as E

storeDir, receiptFile :: FilePath
storeDir = "formal/cubical/Prastuta"
receiptFile = "formal/cubical/Prastuta/phala.tsv"

-- the kernel, asked from formal/cubical so the module path resolves
judge :: FilePath -> IO (Bool, String)
judge rel = do
  environ <- E.getEnvironment
  (code, out, err) <- readCreateProcessWithExitCode
    (proc "agda" [rel]) { cwd = Just "formal/cubical"
                        , env = Just (("LC_ALL", "C.UTF-8") : environ) } ""
  pure (code == ExitSuccess, take 300 (filter (/= '\n') (out ++ err)))

receipt :: String -> String -> String -> String -> IO ()
receipt name verdict line detail =
  appendFile receiptFile
    (name ++ "\t" ++ verdict ++ "\t" ++ line ++ "\t" ++ detail ++ "\n")

tag :: Int -> String
tag 0 = "landed:refl"
tag k = "landed:induction-candidate-" ++ show k

tryCandidates :: String -> String -> Int -> [T.Text] -> String -> IO ()
tryCandidates name line _ [] lastErr = do
  let f = storeDir ++ "/" ++ name ++ ".agda"
  exists <- doesFileExist f
  unless (not exists) (removeFile f)
  receipt name "refused:kernel" line lastErr
  putStrLn ("  " ++ name ++ "  refused by the kernel: " ++ take 120 lastErr)
tryCandidates name line k (c : cs) _ = do
  let f = storeDir ++ "/" ++ name ++ ".agda"
  TIO.writeFile f c
  (ok, msg) <- judge ("Prastuta/" ++ name ++ ".agda")
  if ok
    then do
      receipt name (tag k) line ""
      putStrLn ("  " ++ name ++ "  " ++ tag k ++ "  " ++ line)
    else tryCandidates name line (k + 1) cs msg

pairLines :: String -> [String]
pairLines = filter (elem '\t') . dropWhile (not . isInfixOf "non-joining") . lines

main :: IO ()
main = do
  setLocaleEncoding utf8
  hSetEncoding stdout utf8
  args <- getArgs
  report <- case args of
    [p] -> readFile p
    _ -> putStrLn "usage: mukha REPORT" >> exitFailure >> pure ""
  createDirectoryIfMissing True storeDir
  -- the store is the memory: a pair with a receipt is never re-asked,
  -- and numbering continues from the store's high-water mark.
  haveReceipts <- doesFileExist receiptFile
  prior <- if haveReceipts then lines <$> readFile receiptFile else pure []
  let seen = [ takeWhile (/= '\t') (drop 1 (dropWhile (/= '\t') r))
             | r <- prior ]  -- verdict column ignored; the pair is field 3+
      seenPairs = [ drop 1 (dropWhile (/= '\t') (drop 1 (dropWhile (/= '\t') r)))
                  | r <- prior ]
      priorN = length prior
      fresh = [ l | l <- pairLines report
              , not (any (l `isInfixOf`) seenPairs) ]
      ps = zip [(priorN + 1) ..] fresh
  putStrLn ("mukha: " ++ show (length (pairLines report))
            ++ " pairs from the refusal list, "
            ++ show (length fresh) ++ " new (receipts remember "
            ++ show priorN ++ ")")
  forM_ ps $ \(i, line) -> do
    let name = "P" ++ pad (show i)
        _ = seen
    case P.run (T.pack name) (T.pack line) of
      (h : rest)
        | h == T.pack "OK" -> tryCandidates name line 0 rest ""
        | otherwise ->
            let why = concatMap T.unpack rest
            in receipt name "refused:proposer" line why
               >> putStrLn ("  " ++ name ++ "  refused by the proposer: " ++ why)
      [] -> receipt name "refused:proposer" line "empty answer"
  putStrLn ("receipts: " ++ receiptFile)
  where
    pad s = replicate (3 - length s) '0' ++ s
