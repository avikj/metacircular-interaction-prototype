-- ॥ बीजम् ॥  One machine, one law: which side of `f a ≡ b` is bound is everything.
-- Output bound: singl (f a), contractible — the datum rides free.  Input bound:
-- fiber f b — the loss, and the subject.  Memory, charge, symmetry, price,
-- distance, verdict: six readings of the one fibre.  The kernel decides truth;
-- carriers ask and generate.  This file is one naya, true and not whole.

-- ObstructionCensus — run the saptabhaṅgī census over machine/machine.log.
--
-- `Obstruction.hs` is deliberately NOT `module Main` (its header says why),
-- so the measurement it defines needs a driver.  This is that driver, and
-- nothing else: every number it prints is computed in `Obstruction`, so a
-- reader checking the claim reads that module, not this one.
--
--   runghc machine/ObstructionCensus.hs machine/machine.log
--
-- It also re-prints the four counts this repository has already published
-- about the same log, so that a change to `triage` cannot silently
-- invalidate a documented figure without the regression showing up here.

module Main (main) where

import Obstruction
import Data.List (isInfixOf, nub)
import System.Environment (getArgs)
import System.IO (hSetEncoding, utf8, stdout, stderr, openFile, IOMode(ReadMode)
                 , hGetContents)

main :: IO ()
main = do
  -- The log is UTF-8 (Agda prints ℕ, ≡, ∸, ·).  Fixed here rather than left
  -- to the ambient locale, so the run is reproducible off this machine.
  hSetEncoding stdout utf8
  hSetEncoding stderr utf8
  args <- getArgs
  let path = case args of (p:_) -> p; [] -> "machine/machine.log"
  h <- openFile path ReadMode
  hSetEncoding h utf8
  ls <- fmap lines (hGetContents h)
  putStr (censusReport ls)

  let rejects   = [ l | l <- ls, "KERNEL-REJECT" `isInfixOf` l ]
      residuals = [ p | l <- rejects, Just p <- [residualOf l] ]
      distinct  = nub residuals
      cur       = curriculum rejects
      goals     = nub (map goalOfRejectLine rejects)

  putStrLn ""
  putStrLn "-- published figures, recomputed (regression guard) --"
  -- THE INPUT IS NOT IN THE REPOSITORY.  `.gitignore:16` excludes
  -- machine/machine.log, so every count below is taken against a file that no
  -- other reader has, that no clone reproduces, and that grows whenever the
  -- engine is run.  The bracketed reference values were measured on an
  -- EARLIER, SMALLER log and are therefore not reproducible -- a disagreement
  -- between a bracket and its number is not evidence of a regression in
  -- `triage`, it is evidence that the log moved.  Printing the log's identity
  -- first is the minimum that makes any figure below quotable at all: a count
  -- without its input is the same defect as a constant without its scaling.
  putStrLn ("  INPUT (untracked, .gitignore:16): " ++ path)
  putStrLn ("    " ++ show (length ls) ++ " lines")
  putStrLn ("  rejections                 " ++ show (length rejects)
            ++ "   [1457 on the 2026-08-18 log; 1092 before that]")
  putStrLn ("  residuals recovered        " ++ show (length residuals)
            ++ "   [1303 on the 2026-08-18 log; 946 before that]")
  putStrLn ("  distinct residuals         " ++ show (length distinct)
            ++ "    [112 on the 2026-08-18 log; 107 misreported before that]")
  putStrLn ("  distinct stalled goals     " ++ show (length goals)
            ++ "    [raw count; the curriculum section's 130 is the next line]")
  putStrLn ("    of those, goals with a queueable residual  "
            ++ show (length (nub [ goalOfRejectLine l
                                 | l <- rejects, Just p <- [residualOf l]
                                 , Pravishati _ <- [pravesha (triage p)] ]))
            ++ "  <- this is what 130 counted")
  putStrLn ("  residuals ruled tusnim (silence; once Plausible)  "
            ++ show (length [ () | p <- distinct
                                 , KTusnim <- [verdictKind (triage p)] ]))
  putStrLn ("  distinct lemmas demanded   " ++ show (length cur)
            ++ "     [curriculum section says 78]")
  putStrLn ("  top 8 unblock              " ++ show (sum (map snd (take 8 cur)))
            ++ "     [curriculum section says 54]")

  putStrLn ""
  putStrLn "-- the standpoint split, measured --"
  let accepted = acceptedClaims ls
      rejClaims = nub (map goalOfRejectLine rejects)
      both = [ c | c <- rejClaims, c `elem` accepted ]
  putStrLn ("  distinct claims accepted by some naya   " ++ show (length accepted))
  putStrLn ("  distinct claims denied by kernel-refl   " ++ show (length rejClaims))
  putStrLn ("  claims in BOTH streams (syad asti-nasti, krama)  " ++ show (length both))
  putStrLn "  the first eight of them:"
  mapM_ (\c -> putStrLn ("    " ++ c)) (take 8 both)

  putStrLn ""
  putStrLn "-- kernel-refl's own report, which the sevenfold does NOT see --"
  putStrLn "   (TacticTooWeak = same claim, different naya: a bhanga situation."
  putStrLn "    Residual      = the naya shift CHANGED THE SUBJECT.  A change of"
  putStrLn "                    dharmin is not a bhanga at all; saptabhangi"
  putStrLn "                    presupposes one subject throughout.)"
  let obs = map (evKernelRefl . evidenceOfReject accepted) rejects
      cnt f = length (filter f obs)
  putStrLn ("  TacticTooWeak  " ++ show (cnt (\o -> case o of TacticTooWeak _ -> True; _ -> False)))
  putStrLn ("  Residual       " ++ show (cnt (\o -> case o of Residual _      -> True; _ -> False)))
  putStrLn ("  Unparsed       " ++ show (cnt (\o -> case o of Unparsed _      -> True; _ -> False)))

  putStrLn ""
  putStrLn "-- tactics named on ACCEPT lines (this is the naya list) --"
  let tactics = [ tacticOfAcceptLine l | l <- ls, "KERNEL-ACCEPT" `isInfixOf` l ]
  mapM_ (\t -> putStrLn ("  " ++ show (length (filter (== t) tactics)) ++ "  " ++ t))
        (nub tactics)

  ok <- selfTest
  putStrLn ""
  putStrLn ("selfTest all green: " ++ show ok)

-- ---------------------------------------------------------------------
-- APPENDED 2026-08-19 by a later reader, at the end, altering no line
-- above.  Pointer only; nothing here corrects this module -- it states
-- the defect itself, in its own comment, and prints the input's identity
-- and line count first precisely so a figure is quotable at all.
--
-- The sentence
--
--   "a disagreement between a bracket and its number is not evidence of
--    a regression in `triage`, it is evidence that the log moved"
--
-- is now a checked theorem, in
-- `formal/cubical/NaturalMachine/AFigureWithoutItsInputDecidesNothing.agda`
-- (--safe, no postulates, no holes; container green under Agda 2.6.3 +
-- cubical v0.5, NOT the declared pin).
--
--   theFigureAloneSettlesNothing
--       the SAME figure can come from two DIFFERENT reports, and
--       DIFFERENT figures from ONE report -- so with the input unknown
--       the comparison is uninformative in BOTH directions.  That is
--       stronger than "the guard is weak": it is not a guard.
--
--   mismatchAtSharedInputRefutes : (f g) (x) → not (f x = g x)
--                                            → not (f = g)
--   matchAtSharedInputEstablishesNothing
--       so sharing the input buys exactly a ONE-SIDED test.  Mismatch
--       refutes report-identity; match does not establish it.  The
--       natural summary "the numbers agree, so nothing changed" is what
--       the second of those refutes.
--
-- Printing the input's identity and line count before any figure is
-- exactly what moves a report from the first situation to the second.
-- ---------------------------------------------------------------------
