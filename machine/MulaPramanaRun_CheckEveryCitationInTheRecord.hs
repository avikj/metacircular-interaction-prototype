-- ॥ बीजम् ॥  One machine, one law: which side of `f a ≡ b` is bound is everything.
-- Output bound: singl (f a), contractible — the datum rides free.  Input bound:
-- fiber f b — the loss, and the subject.  Memory, charge, symmetry, price,
-- distance, verdict: six readings of the one fibre.  The kernel decides truth;
-- carriers ask and generate.  This file is one naya, true and not whole.

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
--
-- ────────────────────────────────────────────────────────────────────
-- THE CENSUS THAT DID NOT LOOK REPORTED A CLEAN RECORD.  2026-08-22.
-- Recorded here and not in `machine/dosa.lekha`, whose chain is broken
-- from record 0040 and whose `write` refuses to append; resealing it is
-- the edit that organ was founded to forbid.
--
-- `readFileOr` was `(_, out, _) <- readProcessWithExitCode "cat" [p] ""`,
-- discarding the exit status at the pattern and stderr with it, so an
-- existing file that could not be opened came back as `""`.  Both passes
-- read a NUMBER off that empty string:
--
--   pass 1  `lns = []`, so the run printed "(no registry at …)" — a claim
--           that the file is absent, about a file `doesFileExist` had just
--           said is present — and then sthira 0 / nashta 0 / achalya 0 /
--           refused 0, four zeros that read as a clean registry.
--   pass 2  `hits = []`, so each unread record contributed 0 to "moving
--           citations still standing in the record".  The count this
--           header calls "the thing that has to fall" falls to zero by a
--           file being unreadable.
--
-- The discarded slot is the child's own sentence: `cat` says "Permission
-- denied" or "Is a directory" and it was dropped one function above the
-- place that turned its silence into a finding.
--
-- EXHIBITED, NOT ASSERTED.  A scratch tree holding a copy of
-- `machine/dosa.lekha` — which carries 61 moving citations in this clone —
-- with `chmod 000` on it and no registry beside it.  Against the code at
-- HEAD before this commit, the whole of pass 2 read:
--
--     machine/dosa.lekha: 0 record line(s) carry one
--     machine/naya.kosha: 0 record line(s) carry one
--     machine/mula.pramana: 0 record line(s) carry one
--     moving citations still standing in the record: 0
--
-- A clean record, reported over a file the process could not open, by the
-- program whose subject is citations that resolve after their object is
-- gone.
--
-- REPAIRED by not reporting a number that was not computed.  A file that
-- was not read is named, with the reason, and is EXCLUDED from the tally
-- rather than counted as zero; and "absent" and "present, read, and
-- holding only comments" are now two different sentences, because they are
-- two different facts about the record.  Kumārila's condition, which the
-- spec module cites in its own header: a non-apprehension is evidence of
-- an absence only from a looking fit to have apprehended.
module Main (main) where

import MulaPramana_ACitationNamesAFixedObjectOrItIsNotOne
import System.IO
import GHC.IO.Encoding (setLocaleEncoding, setFileSystemEncoding, utf8)
import Control.Exception (try, IOException)
import System.Directory (doesFileExist)
import System.Exit (ExitCode(..))
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

-- | The read, with the reason it failed.  See the header record: `""` here
--   was being read as a finding by both passes.
readFileOr :: FilePath -> IO (Either String String)
readFileOr p = do
  ok <- doesFileExist p
  if not ok then pure (Left ("no file at " ++ p)) else do
    r <- try (readProcessWithExitCode "cat" [p] "")
    pure $ case r of
      Left e -> Left ("cat could not be run: "
                      ++ oneLine (show (e :: IOException)))
      Right (ExitSuccess, out, _) -> Right out
      Right (_, _, err)           -> Left (oneLine err)

oneLine :: String -> String
oneLine s = case [ l | l <- lines s, not (all isSpace l) ] of
  (l : _) -> take 160 l
  []      -> "no message"

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
  ereg <- readFileOr registry
  case ereg of
    -- No tally.  Four zeros printed here would read as a clean registry,
    -- and nothing was looked at.
    Left why -> do
      putStrLn ("  the registry was not read: " ++ why)
      putStrLn "  no tally follows -- a census that did not look must not"
      putStrLn "  print zeros, which read as a record with nothing in it."
    Right reg -> do
      let lns = [ l | l <- lines reg, isRecord l ]
      if null lns
        then putStrLn ("  " ++ registry ++ " was read and holds no record"
                       ++ " line -- comments only, which is not absence")
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
  let counted = [ n | Just n <- tot ]
      unread  = [ () | Nothing <- tot ]
  putStrLn ""
  putStrLn ("  moving citations still standing in the record: " ++ show (sum counted)
            ++ (if null unread then ""
                else "  -- over " ++ show (length counted) ++ " of "
                     ++ show (length scanned) ++ " records; the "
                     ++ show (length unread) ++ " named NOT READ above are not"
                     ++ " in this number, because zero for them would be a"
                     ++ " claim about a file nobody opened"))

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

census :: FilePath -> IO (Maybe Int)
census p = do
  eb <- readFileOr p
  case eb of
    Left why -> do
      putStrLn ("\n  " ++ p ++ ": NOT READ -- " ++ why)
      putStrLn ("    no count is reported for it.  Zero here would say this"
                ++ " record carries no moving citation, which is a claim"
                ++ " about a file nobody opened.")
      pure Nothing
    Right body -> Just <$> censusOf p body

censusOf :: FilePath -> String -> IO Int
censusOf p body = do
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
