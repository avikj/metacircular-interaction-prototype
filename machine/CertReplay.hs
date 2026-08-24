-- ॥ बीजम् ॥  One machine, one law: which side of `f a ≡ b` is bound is everything.
-- Output bound: singl (f a), contractible — the datum rides free.  Input bound:
-- fiber f b — the loss, and the subject.  Memory, charge, symmetry, price,
-- distance, verdict: six readings of the one fibre.  The kernel decides truth;
-- carriers ask and generate.  This file is one naya, true and not whole.

-- CertReplay.hs — replay-completeness for the machine's installed library.
--
-- WHAT THIS MEASURES, AND WHY IT IS NOT A FITTED NUMBER
--
-- machine/library.txt is the machine's memory of what it has proved.  As
-- written it is a trust-me list: each line is an equation plus a prose note
-- ("[induction on x]"), and re-reading it re-runs the proof SEARCH rather
-- than re-checking a fixed proof.  The corpus (V2.5/V3 certificate standard)
-- wants the file to be a re-checkable LEDGER instead.
--
-- This program measures how far library.txt already is from that standard,
-- with no floating-point anywhere: each library entry either does or does
-- not survive the full ledger round-trip
--
--     library line
--        │  parseLibraryLine            (read the equation the machine wrote)
--        ▼
--     (Equation, note)
--        │  certifyCert                 (prove once; RECORD the exact witness)
--        ▼
--     SerialCert  ──serializeCert──▶  ledger text
--                                          │  parseSerialCert
--                                          ▼
--                                     SerialCert'   (must equal SerialCert)
--                                          │  replayCert  (reconstruct + agda)
--                                          ▼
--                                     re-checked  lhs ≡ rhs   (same theorem)
--
-- An entry ROUND-TRIPS iff: it certifies at all; the serialised form parses
-- back to the identical certificate; the reconstructed module re-checks under
-- agda; and the re-checked endpoints are the equation the file records.  The
-- reported completeness fraction is (#round-trip) / (#library lines) — a
-- count of machine-checked terms, not a correlation.
--
-- Anything short of a full round-trip is a "trust-me-only" line: the gap the
-- ledger standard exists to close.
--
-- Build + run from the repository root:
--
--     ghc -O0 -Wall -main-is CertReplay.main \
--         -outputdir /tmp/replay-build -o /tmp/replay \
--         machine/Certificate.hs machine/CertReplay.hs
--     /tmp/replay                 # or: /tmp/replay <repo-root> <library-file>
--
-- On success it writes the replayable ledger to machine/library.certs and
-- exits 0 only if every library line round-trips (completeness = 1).

module CertReplay (main) where

import Certificate
  ( Equation
  , SerialCert(..)
  , certifyCert
  , parseLibraryLine
  , parseSerialCert
  , replayCert
  , serializeCert
  )
import Control.Monad (forM)
import Data.List (isInfixOf)
import System.Environment (getArgs)
import System.Exit (exitFailure, exitSuccess)
import System.IO
import Text.Printf (printf)

-- The outcome of putting one library line through the whole pipeline.
data Outcome
  = RoundTrip SerialCert String   -- ^ full ledger round-trip; witness tag
  | NoCertificate String          -- ^ certifyCert could not prove it
  | SerialiseBroken               -- ^ serialize→parse changed the certificate
  | ReplayFailed String           -- ^ reconstructed module did not re-check
  | EndpointsChanged              -- ^ re-checked a different theorem
  deriving (Show)

witnessTag :: SerialCert -> String
witnessTag sc = case show (scWitness sc) of
  s | "WRefl" `isInfixOf` s      -> "refl"
    | "WInduction" `isInfixOf` s -> "induction"
    | otherwise                  -> "?"

process :: FilePath -> (Equation, String) -> IO Outcome
process root (eq, note) = do
  disc <- certifyCert [] root (eq, note)
  case disc of
    Left err  -> pure (NoCertificate err)
    Right sc0 ->
      case parseSerialCert (serializeCert sc0) of
        Nothing               -> pure SerialiseBroken
        Just sc1
          | sc1 /= sc0        -> pure SerialiseBroken
          | (scLhs sc1, scRhs sc1) /= eq -> pure EndpointsChanged
          | otherwise -> do
              r <- replayCert root sc1
              case r of
                Left err -> pure (ReplayFailed err)
                Right () -> pure (RoundTrip sc1 (witnessTag sc1))

main :: IO ()
main = do
  hSetEncoding stdout utf8
  hSetBuffering stdout LineBuffering
  argv <- getArgs
  let (root, libFile) = case argv of
        (p : f : _) -> (p, f)
        [p]         -> (p, "machine/library.txt")
        []          -> (".", "machine/library.txt")
  printf "Replay-completeness for %s (repo root %s).\n\n" (show libFile) (show root)

  raw <- readFile (root ++ "/" ++ libFile)
  let parsed = [ (ln, parseLibraryLine ln) | ln <- lines raw, not (blank ln) ]
      total  = length parsed

  results <- forM parsed $ \(ln, mp) -> case mp of
    Nothing        -> do report ln (NoCertificate "line did not parse")
                         pure (ln, Nothing, NoCertificate "unparseable")
    Just (eq, nt)  -> do o <- process root (eq, nt)
                         report ln o
                         pure (ln, Just (eq, o), o)

  let outcomes  = [ o | (_, _, o) <- results ]
      roundTrip = length [ () | RoundTrip _ _ <- outcomes ]
      certs     = [ sc | (_, Just (_, RoundTrip sc _), _) <- results ]

  putStrLn ""
  printf "library lines               : %d\n" total
  printf "round-trip (re-checkable)   : %d\n" roundTrip
  printf "trust-me-only (the gap)     : %d\n" (total - roundTrip)
  if total == 0
    then printf "replay-completeness         : n/a (empty library)\n"
    else printf "replay-completeness         : %d/%d = %s\n"
           roundTrip total (frac roundTrip total)

  -- Emit the replayable ledger for the entries that round-tripped.
  let ledger = concatMap serializeCert certs
  writeFile (root ++ "/machine/library.certs") ledger
  printf "\nwrote %d certificate(s) to machine/library.certs\n" (length certs)

  if roundTrip == total && total > 0
    then do putStrLn "REPLAY-COMPLETE: every library line is a re-checkable certificate"
            exitSuccess
    else do putStrLn "INCOMPLETE: some library lines are trust-me-only"
            exitFailure
  where
    blank s = all (`elem` " \t\r\n") s
    frac a b = show a ++ "/" ++ show b ++ " (exact, not fitted)" ++
               if a == b then " = 1" else ""
    report ln o = do
      let tag = case o of
            RoundTrip _ w   -> "OK    round-trip (" ++ w ++ ")"
            NoCertificate e -> "NO    no certificate: " ++ clip e
            SerialiseBroken -> "NO    serialise round-trip broken"
            ReplayFailed e  -> "NO    replay failed: " ++ clip e
            EndpointsChanged-> "NO    endpoints changed under round-trip"
      printf "  %-40s | %s\n" (clip40 (trim ln)) tag
    trim = unwords . words
    clip s   = if length s > 60 then take 57 s ++ "..." else s
    clip40 s = if length s > 40 then take 37 s ++ "..." else s
