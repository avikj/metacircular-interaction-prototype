-- A standalone kernel capability probe.  Run: runghc machine/KernelProbe.hs
--
-- MathMachine's gate invokes `agda` and assumes its kernel's capabilities;
-- msg 0632 recorded that containers differ (Agda 2.6.3+cubical here, Agda 2.8
-- elsewhere, sometimes no agda at all) and that the gate should probe its
-- kernel at startup rather than assume it.  This program is that probe, and
-- nothing else: it grades capability, not soundness.  A passing probe says
-- "this kernel checks this class of module"; it certifies nothing about the
-- axioms of any registered library.
--
-- Verdict line (machine-readable, one line, always printed unless agda is
-- absent from PATH):
--
--   KERNEL-PROBE agda=<version|ABSENT> refl=<OK|FAIL> cubical=<OK|FAIL>
--
-- Exit 0 iff refl-capable; exit 2 otherwise (fail-closed: an ungraded or
-- refl-incapable kernel must not be trusted, so absence and failure share
-- the same grade).
module Main (main) where

import Control.Exception (finally)
import System.Directory (findExecutable, removePathForcibly)
import System.Exit (ExitCode (..), exitWith)
import System.FilePath ((</>))
import System.IO (IOMode (WriteMode), hPutStr, hSetEncoding, utf8, withFile)
import System.Process (readProcess, readProcessWithExitCode)

-- The probe modules contain `≡`; the container's locale is not guaranteed
-- to be UTF-8, so the handle encoding is forced rather than inherited.
writeFileUtf8 :: FilePath -> String -> IO ()
writeFileUtf8 path text = withFile path WriteMode $ \h -> do
  hSetEncoding h utf8
  hPutStr h text

-- REFL-CAPABLE: builtin modules only.  This needs no library at all, so it
-- is checked with --no-libraries — a broken or missing library registration
-- must not fail the probe of the kernel itself.
reflModule :: String
reflModule = unlines
  [ "{-# OPTIONS --safe #-}"
  , "module Probe1 where"
  , "open import Agda.Builtin.Nat"
  , "open import Agda.Builtin.Equality"
  , "probe : 2 + 2 \8801 4"
  , "probe = refl"
  ]

-- CUBICAL-CAPABLE: succeeds only if a cubical library is registered (here
-- via ~/.agda/defaults); `≡` is the path type and `refl` a constant path.
cubicalModule :: String
cubicalModule = unlines
  [ "{-# OPTIONS --cubical --safe #-}"
  , "module Probe2 where"
  , "open import Cubical.Foundations.Prelude"
  , "open import Agda.Builtin.Nat"
  , "probe : 2 + 2 \8801 4"
  , "probe = refl"
  ]

-- Each probe checks in a private mktemp directory, removed on every exit
-- path, exceptions included.
checkModule :: [String] -> FilePath -> String -> IO Bool
checkModule extraArgs name source = do
  tmp <- init <$> readProcess "mktemp" ["-d"] ""
  let file = tmp </> name
  (do writeFileUtf8 file source
      (code, _, _) <- readProcessWithExitCode "agda"
        (extraArgs ++ ["-i", tmp, file]) ""
      pure (code == ExitSuccess))
    `finally` removePathForcibly tmp

-- "Agda version 2.6.3" -> "2.6.3"; anything unrecognised is reported
-- verbatim as UNKNOWN rather than guessed at.
probeVersion :: IO String
probeVersion = do
  (code, out, _) <- readProcessWithExitCode "agda" ["--version"] ""
  pure $ case (code, words out) of
    (ExitSuccess, "Agda" : "version" : v : _) -> v
    _ -> "UNKNOWN"

grade :: Bool -> String
grade True = "OK"
grade False = "FAIL"

main :: IO ()
main = do
  agdaPath <- findExecutable "agda"
  case agdaPath of
    Nothing -> do
      putStrLn "KERNEL-PROBE agda=ABSENT refl=FAIL cubical=FAIL"
      exitWith (ExitFailure 2)
    Just _ -> do
      version <- probeVersion
      reflOk <- checkModule ["--no-libraries"] "Probe1.agda" reflModule
      cubicalOk <- checkModule [] "Probe2.agda" cubicalModule
      putStrLn ("KERNEL-PROBE agda=" ++ version
        ++ " refl=" ++ grade reflOk
        ++ " cubical=" ++ grade cubicalOk)
      exitWith (if reflOk then ExitSuccess else ExitFailure 2)

-- ---------------------------------------------------------------------
-- APPENDED 2026-08-19 by a later reader, at the end, altering no line
-- above.  Pointer only; nothing here corrects this program.
--
-- "Absence and failure share the same grade" is a deliberate collapse,
-- and its exact shape is now checked in
-- `formal/cubical/NaturalMachine/FailClosedForgetsOnlyTheReasonForDistrust.agda`
-- (--safe, no postulates, no holes; container green under Agda 2.6.3 +
-- cubical v0.5, NOT the declared pin):
--
--   trustDeterminesTheState : trusted s = true  -> s = capable
--   distrustForgetsTheReason: absent and incapable share a verdict and
--                             are distinct
--   distrustDeterminesOnlyNotCapable
--
-- So the map to the verdict is INJECTIVE over `true` and two-to-one over
-- `false`.  A guard consumes only the true fibre and therefore loses
-- nothing it uses; a reader diagnosing a red probe consumes the false
-- fibre, where the verdict alone cannot tell a missing compiler from a
-- broken one.  Which is exactly why this program prints
-- `agda=<version|ABSENT>` on the SAME line as the grade: the reason for
-- distrust is carried BESIDE the verdict, not inside it.  The collapse
-- is right and the adjacent field is what makes it right.
--
-- NOT bridged there, because this file states the limit first: that
-- capability implies soundness.  It does not, and that module models no
-- libraries and no axioms.
--
-- NOT modelled there: the present/refl-capable/cubical-incapable state,
-- which this program's verdict line records separately.
-- ---------------------------------------------------------------------
