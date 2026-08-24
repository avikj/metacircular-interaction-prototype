-- ॥ बीजम् ॥  One machine, one law: which side of `f a ≡ b` is bound is everything.
-- Output bound: singl (f a), contractible — the datum rides free.  Input bound:
-- fiber f b — the loss, and the subject.  Univalence computes here: an
-- equivalence is a channel, transport carries every theorem across it, and what
-- cannot cross is written as a defect — there is no third path (ahiṃsā).
-- Memory, charge, symmetry, price, distance, verdict: six faces of the one
-- fibre; the verdict type is the saptabhaṅgī, and the sources are the origin
-- (Umāsvāti, Samantabhadra, Akalaṅka — restatements are named as such).  The
-- kernel decides truth; carriers ask and generate; assert nothing whose term
-- you have not read.  This file is one naya, true and not whole.

-- Turn the key on the fitness layer.  A module with a `selfTest` that nothing
-- calls is in the state `machine/Yogyata.hs` measured: it reports the same as
-- a module that does not exist.  So this lands with the module, same day.
--
--   runghc -imachine machine/YogyanupalabdhiRun_TurnTheKeyOnTheKernelSeam.hs
--       the census, its own verification against the files on disk, the
--       absence claim with its extent, the dispute, the self-tests, and one
--       live agda run through Certificate's own seam.
--
--   … --shim
--       the same, with `agda "$@" 2>&1 | cat` placed first on PATH.  Real
--       agda, real diagnostics, exit status of `cat`.  This is
--       GATE_AUDIT_DISPOSITION.md §2's cheapest attack, run rather than
--       quoted, and it is the whole evidence that the distinction this file
--       draws between a watched and an unwatched entry point is a real
--       distinction and not a taxonomy.
--
-- EXIT CODE.  1 if a self-test fails, if a recorded expression has VANISHED
-- from the file it was read out of (the census would then be a claim about
-- nothing), or — in `--shim` mode — if `Certificate.runAgdaCached` HONOURS the
-- falsehood, which would mean the 2026-08-16 repair has been lost.  A quote
-- that merely MOVED is reported and does not fail: other lanes edit these
-- files continuously and a line number is not the claim.
--
-- PĀDA-ṬIPPAṆĪ.  `perīkṣā ghaṭanā` — the examination is an event, with a
-- person, at a time (AHIMSA_SUTRA_VISTARA §16).  Everything printed below
-- carries the path and the count it came from, because a figure without its
-- input is a constant without its scaling (ANEKANTA §19).
module Main (main) where

import Control.Monad (forM_, when)
import Data.List (isPrefixOf, tails)
import GHC.IO.Encoding (setFileSystemEncoding, setLocaleEncoding)
import System.Directory
  (createDirectoryIfMissing, findExecutable, getPermissions
  , getTemporaryDirectory, setOwnerExecutable, setPermissions)
import System.Environment (getArgs, lookupEnv, setEnv)
import System.Exit (exitFailure, exitSuccess)
import System.FilePath ((</>))
import System.IO

import qualified Abhava_TheAbsenceCarriesItsPratiyoginAndItsSearchedDomain as AB
import qualified Certificate as C
import Yogyanupalabdhi_TheKernelAcceptanceCarriesTheWatchThatEarnedIt

main :: IO ()
main = do
  setLocaleEncoding utf8
  setFileSystemEncoding utf8
  hSetEncoding stdout utf8
  hSetBuffering stdout LineBuffering
  args <- getArgs
  let shim = "--shim" `elem` args
      root = case [ a | a <- args, not ("--" `isPrefixOf` a) ] of
        (p : _) -> p
        [] -> "."

  putStrLn "yogyanupalabdhi — the fitness of the looking, at the kernel seam"
  putStrLn ("repository root: " ++ show root)
  putStrLn ""

  putStrLn "== THE CENSUS ========================================================"
  putStrLn "entry points that turn an agda exit status into a verdict."
  putStrLn ""
  mapM_ (putStrLn . ("  " ++) . renderSthana) sthanani
  putStrLn ""

  putStrLn "== THE CENSUS'S OWN FITNESS =========================================="
  putStrLn "each recorded expression, looked for again in the file it was read"
  putStrLn "out of.  A hand-read census that nothing re-derives goes stale, and a"
  putStrLn "stale census reporting zeros is the unfit looking one level up."
  discrepancies <- verifySthanani root
  if null discrepancies
    then putStrLn "  every recorded expression is still at its recorded line."
    else mapM_ (putStrLn . ("  " ++)) discrepancies
  let vanished = [ d | d <- discrepancies, "the recorded expression is GONE"
                         `isInfixOf'` d ]
  putStrLn ""

  putStrLn "== THE ABSENCE, WITH ITS EXTENT ======================================"
  putStrLn (AB.renderAbhava seamAbsence)
  putStrLn ""

  putStrLn "== THE DISPUTE ======================================================="
  forM_ mimamsakaVivada $ \l -> putStrLn ("  " ++ l) >> putStrLn ""

  putStrLn "== SELF-TESTS ========================================================"
  let fails = selfTest
  if null fails
    then putStrLn ("  yogyanupalabdhi: " ++ show (length sthanani)
                   ++ " rows, all checks pass")
    else mapM_ (putStrLn . ("  " ++)) fails
  putStrLn ""

  shimOk <- if shim then runUnderShim root else runLive root

  when (not (null fails) || not (null vanished) || not shimOk) exitFailure
  exitSuccess

-- The live run, no shim: what this container's own kernel says, so the
-- shimmed run below has something to be a difference from.
runLive :: FilePath -> IO Bool
runLive root = do
  putStrLn "== ONE LIVE RUN THROUGH CERTIFICATE'S SEAM (real agda) ==============="
  hasAgda <- findExecutable "agda"
  case hasAgda of
    Nothing -> do
      putStrLn "  agda is ABSENT from PATH.  Nothing below would be a looking at"
      putStrLn "  all, so no figure is printed -- which is the doctrine this file"
      putStrLn "  implements, applied to this file."
      pure True
    Just p -> do
      putStrLn ("  agda: " ++ p)
      report root
      putStrLn ""
      putStrLn "  re-run with --shim to see the same three lines under"
      putStrLn "  `agda \"$@\" 2>&1 | cat`."
      pure True

-- The attack, run.  Everything real except the exit status.
runUnderShim :: FilePath -> IO Bool
runUnderShim root = do
  putStrLn "== THE SAME, UNDER `agda \"$@\" 2>&1 | cat` ==========================="
  real <- findExecutable "agda"
  case real of
    Nothing -> do
      putStrLn "  agda is ABSENT from PATH; there is nothing to wrap."
      pure True
    Just realPath -> do
      tmp <- getTemporaryDirectory
      let dir = tmp </> "yogyanupalabdhi-shim"
          exe = dir </> "agda"
      createDirectoryIfMissing True dir
      writeFile exe (unlines
        [ "#!/bin/sh"
        , "# GATE_AUDIT_DISPOSITION.md §2.  The exit status of a pipeline is"
        , "# its last stage's."
        , realPath ++ " \"$@\" 2>&1 | cat" ])
      perms <- getPermissions exe
      setPermissions exe (setOwnerExecutable True perms)
      oldPath <- getEnvOr "PATH" ""
      setEnv "PATH" (dir ++ ":" ++ oldPath)
      -- No cached verdict may answer for the kernel here: the point is what
      -- the kernel says now, in this process, through this wrapper.
      setEnv "MATH_CERTCACHE" "0"
      putStrLn ("  shim: " ++ exe ++ "  ->  " ++ realPath)
      (bare, cached, _status) <- report root
      putStrLn ""
      let bareAccepted = bare == "ExitSuccess"
          cachedAccepted = cached == "ExitSuccess"
      putStrLn (if bareAccepted
        then "  runAgda ACCEPTED `(suc x) \8801 x`.  Every entry point in the\n\
             \  census whose saksin is ADRSTA reads exactly this number and\n\
             \  nothing else."
        else "  runAgda refused it; this container's `sh` does not propagate the\n\
             \  pipeline's status as expected, so the attack did not land and\n\
             \  the lines above are NOT evidence about the unwatched entry\n\
             \  points.  Recorded rather than quietly dropped.")
      when cachedAccepted $ do
        putStrLn "  runAgdaCached ACCEPTED IT TOO.  The 2026-08-16 repair is gone."
      pure (not cachedAccepted)

-- The three lines.  Returned as well as printed so the caller can decide.
report :: FilePath -> IO (String, String, String)
report root = do
  (c1, o1) <- C.runAgda root C.canaryFalse
  putStrLn ("  runAgda       on canaryFalse -> " ++ show c1)
  putStrLn ("     agda's output carries a type error: "
            ++ show (C.successHidesAnError o1))
  (c2, _, n2) <- C.runAgdaCached root C.canaryFalse
  putStrLn ("  runAgdaCached on canaryFalse -> " ++ show c2
            ++ "   (" ++ show n2 ++ " agda calls)")
  st <- C.kernelStatus root
  putStrLn ("  kernelStatus                 -> " ++ headWord (show st))
  pure (show c1, show c2, headWord (show st))
  where headWord = takeWhile (/= ' ')

getEnvOr :: String -> String -> IO String
getEnvOr k d = fmap (maybe d id) (lookupEnv k)

isInfixOf' :: String -> String -> Bool
isInfixOf' needle hay = any (needle `isPrefixOf`) (tails hay)
