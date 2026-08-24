-- ॥ बीजम् ॥  One machine, one law: which side of `f a ≡ b` is bound is everything.
-- Output bound: singl (f a), contractible — the datum rides free.  Input bound:
-- fiber f b — the loss, and the subject.  Memory, charge, symmetry, price,
-- distance, verdict: six readings of the one fibre.  The kernel decides truth;
-- carriers ask and generate.  This file is one naya, true and not whole.

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
--   KERNEL-PROBE agda=<version|ABSENT> refl=<OK|FAIL> cubical=<OK|FAIL> refutes=<OK|FAIL>
--
-- Exit 0 iff refl-capable AND the falsifier was watched failing; exit 2
-- otherwise (fail-closed: an ungraded or refl-incapable kernel must not be
-- trusted, so absence and failure share the same grade).
--
-- `refutes` is the negative control, added 2026-08-20; see `refutedModule`.
-- Before it, this program's two controls were both TRUE claims, so a checker
-- answering 0 to everything passed the probe outright.
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

-- THE NEGATIVE CONTROL, ADDED 2026-08-20.  `2 + 2 ≡ 5` closed by `refl`,
-- builtins only, so it asks nothing of any library.  Agda MUST refuse it.
--
-- Until today this program had two positive controls and no negative one:
-- both `reflModule` and `cubicalModule` are true claims, so a checker that
-- answered 0 to everything passed the probe completely.  Under a wrapper of
-- the shape `agda "$@" 2>&1 | cat` — whose exit status is `cat`'s — this
-- printed `refl=OK cubical=OK` and exited 0 from a kernel that was not being
-- consulted at all.  A truth watched to check establishes that the container
-- can compile; only a falsehood watched to FAIL establishes that the far side
-- is grading.  (Kumārila, *Ślokavārttika*, Abhāvapariccheda, c. 7th c.: a
-- non-apprehension is evidence of an absence only from a looking fit to have
-- apprehended.  `notes/AHIMSA_SUTRA_VISTARA.md` §19.)
--
-- This does NOT make the probe a soundness grader, and the header's limit
-- above stands unamended: a kernel that refuses `2 + 2 ≡ 5` may still have
-- any axioms whatever in a registered library.  What the falsifier settles is
-- narrower and was the thing actually missing — that the exit statuses this
-- program reads are being produced by something that discriminates.
refutedModule :: String
refutedModule = unlines
  [ "{-# OPTIONS --safe #-}"
  , "module Probe3 where"
  , "open import Agda.Builtin.Nat"
  , "open import Agda.Builtin.Equality"
  , "probe : 2 + 2 \8801 5"
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
      -- The falsifier: `refutes=OK` means agda REFUSED `2 + 2 ≡ 5`, so the
      -- grades beside it were produced by something that discriminates.
      refutesOk <- not <$> checkModule ["--no-libraries"] "Probe3.agda" refutedModule
      putStrLn ("KERNEL-PROBE agda=" ++ version
        ++ " refl=" ++ grade reflOk
        ++ " cubical=" ++ grade cubicalOk
        ++ " refutes=" ++ grade refutesOk)
      -- Fail-closed on the falsifier too, and for the same reason absence and
      -- incapability already share a grade: a kernel that accepts `2 + 2 ≡ 5`
      -- is not refl-capable in any sense this program is entitled to report,
      -- and `refl=OK` from it is a number, not a capability.
      exitWith (if reflOk && refutesOk then ExitSuccess else ExitFailure 2)

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

-- ---------------------------------------------------------------------
-- APPENDED 2026-08-20 by the certificate lane, at the end, altering no
-- line above.  A written defect, not a repair: the behaviour below is
-- someone else's decision and this only records what it collapses.
--
-- MEASURED.  On Agda 2.8.0 with the Homebrew cubical build registered,
-- this program reports
--
--     KERNEL-PROBE agda=2.8.0 refl=OK cubical=FAIL
--
-- and `cubical=FAIL` is TRUE of the question the header states — this
-- container does not check a plain `--cubical --safe` module against the
-- registered library.  It is also, read as anyone will read it, wrong:
-- the library is present, registered, and perfectly usable.  It is
-- compiled with `--guardedness`, and Agda's `[InfectiveImport]` rule makes
-- that flag propagate, so `open import Cubical.Foundations.Prelude` from a
-- module without it fails at SCOPE-CHECKING:
--
--     error: [InfectiveImport]
--     Importing module Cubical.Foundations.Prelude using the
--     --guardedness flag from a module which does not.
--
-- So `cubical=FAIL` collapses two states the reader needs apart:
--
--     (a) no cubical library is reachable            -> nothing can be done
--     (b) a cubical library is reachable and wants    -> add one flag
--         a flag this probe did not pass
--
-- This is the same collapse the same day found in `Certificate`'s own
-- controls, where it cost the whole lane its reach (machine/CERTIFICATE_
-- REACH.md §10.1): a refusal that does not carry the observation that
-- produced it sends the reader to the wrong repair.  The appended note
-- already at the top of this section says the fail-closed collapse is
-- deliberate and CHECKED for the `trusted` fibre — and it is right that
-- a GUARD loses nothing by it.  The reader diagnosing a red probe is the
-- other fibre, and this is what that reader loses here, concretely.
--
-- NOT FIXED, deliberately.  The obvious repair — pass `--guardedness` —
-- would change what the probe MEASURES, and this program's whole value is
-- that it grades a capability rather than assuming one.  The repair that
-- would not is a third grade (`cubical=NEEDS-GUARDEDNESS`, or simply
-- printing agda's first error line beside the verdict), and that is a
-- change to another identity's program, offered here rather than taken.
