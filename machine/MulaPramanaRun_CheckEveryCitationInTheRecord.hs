-- MulaPramanaRun_CheckEveryCitationInTheRecord
--
--     runghc -imachine machine/MulaPramanaRun_CheckEveryCitationInTheRecord.hs
--
-- Two passes over this repository's own records.
--
--   PASS 1, the REGISTRY.  `machine/mula.pramana` holds the citations this
--   lane has pinned, one designation per line, in the four fixed forms.
--   Every one is parsed (a moving form cannot get past the parser) and
--   then RESOLVED against git and the working tree.  A rot is reported as
--   nashta, which is a denial; an unpinnable target is reported as
--   achalya, which is silence and is a different answer.
--
--   PASS 2, the SCAN.  Every line of the record files below is scanned for
--   citations that name a moving object.  This is a census, not a verdict:
--   the historical records here are APPEND-ONLY (machine/dosa.lekha says
--   so in its first line), so a moving citation already written is not
--   deleted.  It is counted, and the count is the thing that has to fall.
module Main (main) where

import MulaPramana_ACitationNamesAFixedObjectOrItIsNotOne
import System.IO
import GHC.IO.Encoding (setLocaleEncoding, setFileSystemEncoding, utf8)
import System.Directory (doesFileExist)
import System.Process (readProcessWithExitCode)
import Data.List (isPrefixOf, sort, nub, intercalate)
import Data.Char (isSpace)

registry :: FilePath
registry = "machine/mula.pramana"

-- The record files whose citations are scanned.  Chosen because each one
-- is a REPLAY record: it exists so a later reader can re-run it.
scanned :: [FilePath]
scanned =
  [ "machine/dosa.lekha"
  , "machine/naya.kosha"
  , "machine/mula.pramana"
  ]

rule :: String -> IO ()
rule t = putStrLn ("\n== " ++ t ++ " " ++ replicate (max 0 (66 - length t)) '=')

readFileOr :: FilePath -> IO String
readFileOr p = do
  ok <- doesFileExist p
  if not ok then pure "" else do
    (_, out, _) <- readProcessWithExitCode "cat" [p] ""
    pure out

isRecord :: String -> Bool
isRecord l = not (null t) && not ("#" `isPrefixOf` t)
  where t = dropWhile isSpace l

main :: IO ()
main = do
  setLocaleEncoding utf8; setFileSystemEncoding utf8; hSetEncoding stdout utf8
  putStrLn "=== MULA-PRAMANA: a citation names a fixed object or it is not one ==="
  putStrLn "spec: machine/MulaPramana_ACitationNamesAFixedObjectOrItIsNotOne.hs"
  putStrLn "law : never a position, never a quantity the record is inside,"
  putStrLn "      never a HEAD-relative query."

  -- ─────────────────────────────────────────────────── pass 1
  rule "pass 1 -- the registry, parsed then resolved"
  reg <- readFileOr registry
  let lns  = [ l | l <- lines reg, isRecord l ]
  if null lns
    then putStrLn ("  (no registry at " ++ registry ++ ")")
    else pure ()
  results <- mapM one (zip [1 :: Int ..] lns)
  let nSthira  = length [ () | Just (Sthira _)  <- results ]
      nNashta  = length [ () | Just (Nashta _)  <- results ]
      nAchalya = length [ () | Just (Achalya _) <- results ]
      nRefused = length [ () | Nothing <- results ]
  putStrLn ""
  putStrLn ("  sthira  " ++ show nSthira  ++ "   the object is there")
  putStrLn ("  nashta  " ++ show nNashta  ++ "   fit looking, object absent -- ROTTED")
  putStrLn ("  achalya " ++ show nAchalya ++ "   nothing fit to look in -- not a denial")
  putStrLn ("  refused " ++ show nRefused ++ "   the parser would not build it")

  -- ─────────────────────────────────────────────────── pass 2
  rule "pass 2 -- census of moving citations already in the record"
  putStrLn "  (append-only records: these are counted, never edited away)"
  tot <- mapM census scanned
  putStrLn ""
  putStrLn ("  moving citations still standing in the record: " ++ show (sum tot))

  -- ─────────────────────────────────────────────────── laws
  rule "self-test -- the pure laws of the designation"
  mapM_ (\(nm, ok) -> putStrLn ("  " ++ (if ok then "ok  " else "FAIL") ++ "  " ++ nm))
        selfTest
  let bad = length [ () | (_, False) <- selfTest ]
  putStrLn ("\n  " ++ show (length selfTest - bad) ++ " / " ++ show (length selfTest)
            ++ " pass" ++ (if bad == 0 then "" else "  -- FAILURES ABOVE"))

one :: (Int, String) -> IO (Maybe Sthiti)
one (i, l) = case parse l of
  Left c -> do
    putStrLn ("\n  [" ++ show i ++ "] REFUSED AT CONSTRUCTION")
    putStrLn ("      " ++ take 100 l)
    putStrLn ("      " ++ calatGloss c)
    pure Nothing
  Right n -> do
    st <- pariksha n
    putStrLn ("\n  [" ++ show i ++ "] " ++ nirdeshaKind n)
    putStrLn ("      " ++ nirdeshaShow n)
    putStrLn ("      " ++ sthitiGloss st)
    pure (Just st)

census :: FilePath -> IO Int
census p = do
  body <- readFileOr p
  let hits = [ (k, l, ds)
             | (k, l) <- zip [1 :: Int ..] (lines body)
             , isRecord l
             , let ds = scanLine l
             , not (null ds) ]
  putStrLn ("\n  " ++ p ++ ": " ++ show (length hits) ++ " record line(s) carry one")
  mapM_ (\(k, l, ds) -> do
            -- the line's own number is printed as a NAVIGATION aid and is
            -- explicitly not the citation: the citation is the text.
            putStrLn ("    text: " ++ take 96 (dropWhile isSpace l))
            mapM_ (\d -> putStrLn ("      -> " ++ calatGloss d)) (nub ds))
        (take 12 hits)
  if length hits > 12
    then putStrLn ("    ... and " ++ show (length hits - 12) ++ " more")
    else pure ()
  pure (length hits)
