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
  putStrLn ("  rejections                 " ++ show (length rejects)
            ++ "   [header now says 1457; said 1092 before 2026-08-18]")
  putStrLn ("  residuals recovered        " ++ show (length residuals)
            ++ "   [header now says 1303; said 946 before 2026-08-18]")
  putStrLn ("  distinct residuals         " ++ show (length distinct)
            ++ "    [header says 112; triage section said 107, corrected]")
  putStrLn ("  distinct stalled goals     " ++ show (length goals)
            ++ "    [raw count; the curriculum section's 130 is the next line]")
  putStrLn ("    of those, goals with a queueable residual  "
            ++ show (length (nub [ goalOfRejectLine l
                                 | l <- rejects, Just p <- [residualOf l]
                                 , queueable (triage p) ]))
            ++ "  <- this is what 130 counted")
  putStrLn ("  residuals ruled Silent (was Plausible)  "
            ++ show (length [ () | p <- distinct, triage p == Silent ]))
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
