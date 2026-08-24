-- ॥ बीजम् ॥  One machine, one law: which side of `f a ≡ b` is bound is everything.
-- Output bound: singl (f a), contractible — the datum rides free.  Input bound:
-- fiber f b — the loss, and the subject.  Memory, charge, symmetry, price,
-- distance, verdict: six readings of the one fibre.  The kernel decides truth;
-- carriers ask and generate.  This file is one naya, true and not whole.

{-# LANGUAGE LambdaCase #-}

-- A minimal executable Haskell -> Agda -> installation seam.
-- Run: runghc machine/AgdaRewriteGate.hs
--
-- Hardening (2026-08-16): the admission gate now (a) wraps every Agda
-- invocation in a hard wall-clock timeout so a pathological candidate is
-- REJECTED instead of hanging the mining loop, distinguishing "refuted by
-- timeout" from "refuted by type error" from "admitted"; and (b) caches
-- verdicts by candidate-source hash so an identical candidate module is never
-- re-checked. The temp module is also written under formal/cubical/ with a
-- module name matching its file, so Agda's .agda-lib discovery resolves the
-- `cubical` dependency (a bare mktemp dir could not, and every candidate
-- silently "failed" before this fix).
module Main (main) where

import qualified Certificate as C
import Control.Exception (finally)
import Control.Monad (forM_)
import Data.Bits (xor)
import Data.IORef (IORef, modifyIORef', newIORef, readIORef)
import Data.List (foldl', isPrefixOf)
import qualified Data.Map.Strict as Map
import Data.Time.Clock (diffUTCTime, getCurrentTime)
import Data.Word (Word64)
import GHC.IO.Encoding (setLocaleEncoding, utf8)
import Numeric (showHex)
import System.Directory (getCurrentDirectory, removePathForcibly)
import System.Exit (ExitCode (..), exitFailure)
import System.FilePath ((</>))
import System.IO.Unsafe (unsafePerformIO)
import System.Process (CreateProcess (cwd), proc, readCreateProcessWithExitCode)
import System.Timeout (timeout)

-- ---------------------------------------------------------------------------
-- Hardening knobs
-- ---------------------------------------------------------------------------

-- Per-candidate wall-clock bound handed to coreutils `timeout` (seconds).
-- A candidate that does not typecheck within this bound is refuted-by-timeout.
agdaTimeoutSecs :: Int
agdaTimeoutSecs = 12

-- coreutils `timeout` escalates TERM -> KILL after this grace window, so a
-- candidate that ignores SIGTERM is still guaranteed to die.
agdaKillGraceSecs :: Int
agdaKillGraceSecs = 5

-- Haskell-side backstop: if coreutils `timeout` itself wedged, this async
-- timeout still returns control (and withCreateProcess tears the child down).
-- Comfortably larger than the coreutils bound + grace.
backstopMicros :: Int
backstopMicros = (agdaTimeoutSecs + agdaKillGraceSecs + 8) * 1000000

-- The three resolutions of a candidate. Every candidate resolves to exactly
-- one of these; none of them hang the loop.
data Verdict
  = Admitted          -- Agda exit 0: the certificate typechecks; install it.
  | RefutedTypeError  -- Agda nonzero (not a timeout): a real type error.
  | RefutedTimeout    -- killed at the wall-clock bound; refused, not installed.
  deriving (Eq, Show)

verdictAdmitted :: Verdict -> Bool
verdictAdmitted = (== Admitted)

-- ---------------------------------------------------------------------------
-- Certificate grammar (unchanged executable face of RewriteCertificate)
-- ---------------------------------------------------------------------------

data Term = Var | Zero | Suc Term | Add Term Term deriving (Eq, Show)

data StepCert
  = AddZero Term
  | AddSuc Term Term
  | SucStep StepCert
  | AddLeft StepCert Term
  | AddRight Term StepCert
  | Reverse StepCert
  deriving (Eq, Show)

data Derivation
  = Done Term
  | Then StepCert Derivation
  deriving (Eq, Show)

-- The executable face of RewriteCertificate's hypothesis-indexed language.
-- The distinguished variable is `Var`; Agda checks that `Hypothesis` is used
-- only at the predecessor endpoints named by the certificate.
data HypStepCert
  = LiftStep StepCert
  | Hypothesis
  | ReverseHypothesis
  | HypSuc HypStepCert
  | HypAddLeft HypStepCert Term
  | HypAddRight Term HypStepCert
  deriving (Eq, Show)

data HypDerivation
  = HypDone Term
  | HypThen HypStepCert HypDerivation
  deriving (Eq, Show)

data InductionCertificate = InductionCertificate
  { inductionSource :: Term
  , inductionTarget :: Term
  , baseDerivation :: Derivation
  , stepDerivation :: HypDerivation
  } deriving (Eq, Show)

-- Unlike MathMachine's current String, the certificate carries its exact
-- conclusion. Agda checks both that the derivation has these endpoints and,
-- through RewriteCertificate.derivation-sound, that the installed endpoints
-- denote pointwise-equal functions Nat -> Nat.
data Certificate = Certificate
  { source :: Term
  , target :: Term
  , derivation :: Derivation
  } deriving (Eq, Show)

renderTerm :: Term -> String
renderTerm = \case
  Var -> "var"
  Zero -> "zero"
  Suc x -> "(suc " ++ renderTerm x ++ ")"
  Add x y -> "(add " ++ renderTerm x ++ " " ++ renderTerm y ++ ")"

renderStep :: StepCert -> String
renderStep = \case
  AddZero x -> "(add-zero " ++ renderTerm x ++ ")"
  AddSuc x y -> "(add-suc " ++ renderTerm x ++ " " ++ renderTerm y ++ ")"
  SucStep p -> "(suc-step " ++ renderStep p ++ ")"
  AddLeft p z -> "(add-left " ++ renderStep p ++ " " ++ renderTerm z ++ ")"
  AddRight z p -> "(add-right " ++ renderTerm z ++ " " ++ renderStep p ++ ")"
  Reverse p -> "(reverse " ++ renderStep p ++ ")"

renderDerivation :: Derivation -> String
renderDerivation = \case
  Done x -> "(done " ++ renderTerm x ++ ")"
  Then p rest -> "(then-step " ++ renderStep p ++ " " ++ renderDerivation rest ++ ")"

renderHypStep :: HypStepCert -> String
renderHypStep = \case
  LiftStep p -> "(lift-step " ++ renderStep p ++ ")"
  Hypothesis -> "hypothesis"
  ReverseHypothesis -> "reverse-hypothesis"
  HypSuc p -> "(hyp-suc " ++ renderHypStep p ++ ")"
  HypAddLeft p z -> "(hyp-add-left " ++ renderHypStep p ++ " " ++ renderTerm z ++ ")"
  HypAddRight z p -> "(hyp-add-right " ++ renderTerm z ++ " " ++ renderHypStep p ++ ")"

renderHypDerivation :: HypDerivation -> String
renderHypDerivation = \case
  HypDone x -> "(hyp-done " ++ renderTerm x ++ ")"
  HypThen p rest ->
    "(hyp-then " ++ renderHypStep p ++ " " ++ renderHypDerivation rest ++ ")"

-- The module marker every rendered candidate carries; the gate rewrites it to
-- a per-candidate unique name (see substModuleName) so the file name and the
-- module name agree under formal/cubical/.
moduleMarker :: String
moduleMarker = "module Gate where"

renderModule :: Certificate -> String
renderModule c = unlines
  [ "{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}"
  , moduleMarker
  , "open import NaturalMachine.RewriteCertificate"
  , "candidate : Derivation " ++ renderTerm (source c) ++ " " ++ renderTerm (target c)
  , "candidate = " ++ renderDerivation (derivation c)
  ]

renderInductionModule :: InductionCertificate -> String
renderInductionModule c = unlines
  [ "{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}"
  , moduleMarker
  , "open import NaturalMachine.RewriteCertificate"
  , "candidate : InductionCertificate "
      ++ renderTerm (inductionSource c) ++ " " ++ renderTerm (inductionTarget c)
  , "candidate = record"
  , "  { base = " ++ renderDerivation (baseDerivation c)
  , "  ; step = " ++ renderHypDerivation (stepDerivation c)
  , "  }"
  ]

-- ---------------------------------------------------------------------------
-- The hardened admission gate
-- ---------------------------------------------------------------------------

-- FNV-1a 64-bit over the candidate source: the cache key and the source of
-- the per-candidate module name. Exact hashing, no dependency added.
fnvHash :: String -> Word64
fnvHash = foldl' step 0xcbf29ce484222325
  where
    step h c = (h `xor` fromIntegral (fromEnum c)) * 0x100000001b3

candidateHash :: String -> String
candidateHash src = showHex (fnvHash src) ""

moduleNameFor :: String -> String
moduleNameFor h = "GateCand" ++ h

-- Rewrite the fixed `module Gate where` marker to a unique per-candidate name,
-- so the on-disk file GateCand<hash>.agda has a matching module declaration.
substModuleName :: String -> String -> String
substModuleName newName = go
  where
    repl = "module " ++ newName ++ " where"
    go [] = []
    go s@(x : xs)
      | moduleMarker `isPrefixOf` s = repl ++ drop (length moduleMarker) s
      | otherwise = x : go xs

-- Process-wide verdict cache, keyed by candidate-source hash. An identical
-- candidate is answered from here and never handed to Agda a second time.
{-# NOINLINE gateCache #-}
gateCache :: IORef (Map.Map String Verdict)
gateCache = unsafePerformIO (newIORef Map.empty)

-- Classify one finished (or non-finishing) Agda run into a Verdict.
--   exit 0            -> Admitted
--   exit 124          -> coreutils `timeout` sent SIGTERM at the bound
--   exit 137          -> coreutils escalated to SIGKILL after the grace window
--   backstop fired    -> RefutedTimeout (child torn down by withCreateProcess)
--   any other nonzero -> RefutedTypeError
classifyExit :: Maybe ExitCode -> Verdict
classifyExit = \case
  Nothing -> RefutedTimeout
  Just ExitSuccess -> Admitted
  Just (ExitFailure 124) -> RefutedTimeout
  Just (ExitFailure 137) -> RefutedTimeout
  Just (ExitFailure _) -> RefutedTypeError

-- Run Agda on one rendered source under a hard wall-clock bound, returning a
-- Verdict and the wall-clock seconds spent. Never blocks past the backstop.
-- The result is memoised by source hash; a cache hit does no Agda work.
checkSource :: FilePath -> String -> IO (Verdict, Double, Bool)
checkSource repo src = do
  let h = candidateHash src
  cached <- Map.lookup h <$> readIORef gateCache
  case cached of
    Just v -> pure (v, 0, True)
    Nothing -> do
      t0 <- getCurrentTime
      verdict <- runAgdaBounded repo h src
      t1 <- getCurrentTime
      modifyIORef' gateCache (Map.insert h verdict)
      pure (verdict, realToFrac (diffUTCTime t1 t0), False)

runAgdaBounded :: FilePath -> String -> String -> IO Verdict
runAgdaBounded repo h src = do
  let cubicalDir = repo </> "formal" </> "cubical"
      modName = moduleNameFor h
      fileBase = modName ++ ".agda"
      filePath = cubicalDir </> fileBase
      renamed = substModuleName modName src
      -- coreutils timeout kills the whole Agda process at the bound; the
      -- Haskell backstop only matters if coreutils itself wedges.
      cp = (proc "timeout"
              [ "-k", show agdaKillGraceSecs
              , show agdaTimeoutSecs
              , "agda", fileBase ]) { cwd = Just cubicalDir }
  (do writeFile filePath renamed
      result <- timeout backstopMicros (readCreateProcessWithExitCode cp "")
      -- THE FITNESS, ADDED 2026-08-20.  Agda's own words were discarded here
      -- (`Just (code, _, _)`) and `Admitted` was `exit 0` and nothing else —
      -- from a child launched through `timeout`, which is already a wrapper,
      -- and therefore already a place where a zero can come from something
      -- that is not agda.  `C.vetForeignRun` reads the output on this call
      -- and, once per process, watches the kernel reject `(suc x) ≡ x`; a
      -- zero it will not honour arrives here as a non-zero and classifies as
      -- `RefutedTypeError`, which is fail-closed and is the direction this
      -- module's header already requires.
      case result of
        Nothing -> pure (classifyExit Nothing)
        Just (code, out, err) -> do
          (code', _) <- C.vetForeignRun repo code (out ++ err)
          pure (classifyExit (Just code')))
    `finally` do
      removePathForcibly filePath
      removePathForcibly (cubicalDir </> (modName ++ ".agdai"))

validateSourceWithAgda :: FilePath -> String -> IO Bool
validateSourceWithAgda repo src =
  (\(v, _, _) -> verdictAdmitted v) <$> checkSource repo src

validateWithAgda :: FilePath -> Certificate -> IO Bool
validateWithAgda repo = validateSourceWithAgda repo . renderModule

validateInductionWithAgda :: FilePath -> InductionCertificate -> IO Bool
validateInductionWithAgda repo = validateSourceWithAgda repo . renderInductionModule

-- ---------------------------------------------------------------------------
-- Installation set (unchanged)
-- ---------------------------------------------------------------------------

data CheckedCertificate
  = DirectCertificate Certificate
  | InductiveCertificate InductionCertificate
  deriving (Eq, Show)

data NativeRule = NativeRule
  { ruleName :: String
  , ruleSource :: Term
  , ruleTarget :: Term
  , ruleCertificate :: CheckedCertificate
  } deriving (Eq, Show)

type Rules = [NativeRule]

-- Applicability is retained as an exact source match. A checked theorem does
-- not become a globally firing rewrite.
applyNative :: NativeRule -> Term -> Maybe Term
applyNative rule input
  | input == ruleSource rule = Just (ruleTarget rule)
  | otherwise = Nothing

-- Preserve operation identity and multiplicity. Equal targets are parallel
-- futures, not evidence that the branches may be collapsed.
parallelFutures :: Rules -> Term -> [(NativeRule, Term)]
parallelFutures rules input =
  [ (rule, output) | rule <- rules, Just output <- [applyNative rule input] ]

-- The rule enters the executable set only on Agda's successful exit.
validateAndInstall :: FilePath -> String -> Rules -> Certificate -> IO (Bool, Rules)
validateAndInstall repo name rules c = do
  accepted <- validateWithAgda repo c
  let native = NativeRule name (source c) (target c) (DirectCertificate c)
  pure (accepted, if accepted then rules ++ [native] else rules)

validateAndInstallInduction :: FilePath -> String -> Rules
  -> InductionCertificate -> IO (Bool, Rules)
validateAndInstallInduction repo name rules c = do
  accepted <- validateInductionWithAgda repo c
  let native = NativeRule name (inductionSource c) (inductionTarget c)
        (InductiveCertificate c)
  pure (accepted, if accepted then rules ++ [native] else rules)

-- ---------------------------------------------------------------------------
-- Regression certificates (unchanged)
-- ---------------------------------------------------------------------------

good :: Certificate
good = Certificate
  (Add Var (Suc Zero))
  (Suc Var)
  (Then (AddSuc Var Zero)
    (Then (SucStep (AddZero Var)) (Done (Suc Var))))

-- One altered constructor: the inner add-zero step is no longer transported
-- through suc. Its source cannot match the preceding step's target.
mutated :: Certificate
mutated = Certificate
  (Add Var (Suc Zero))
  (Suc Var)
  (Then (AddSuc Var Zero)
    (Then (AddZero Var) (Done (Suc Var))))

-- The executable gate used to expose only `suc-step`, although the checked
-- calculus also permits rewriting under either argument of addition and
-- reversing a certified step.  These controls keep all three transports live.
underLeft :: Certificate
underLeft = Certificate
  (Add (Add Var Zero) Var)
  (Add Var Var)
  (Then (AddLeft (AddZero Var) Var) (Done (Add Var Var)))

underRightReversed :: Certificate
underRightReversed = Certificate
  (Add Var Var)
  (Add Var (Add Var Zero))
  (Then (AddRight Var (Reverse (AddZero Var)))
    (Done (Add Var (Add Var Zero))))

zeroPlusInduction :: InductionCertificate
zeroPlusInduction = InductionCertificate
  (Add Zero Var)
  Var
  (Then (AddZero Zero) (Done Zero))
  (HypThen (LiftStep (AddSuc Zero Var))
    (HypThen (HypSuc Hypothesis) (HypDone (Suc Var))))

-- The first step reaches `suc (0 + var)`.  The bare hypothesis has endpoints
-- `0 + var` and `var`, so using it without `hyp-suc` must be rejected.
malformedInduction :: InductionCertificate
malformedInduction = InductionCertificate
  (Add Zero Var)
  Var
  (Then (AddZero Zero) (Done Zero))
  (HypThen (LiftStep (AddSuc Zero Var))
    (HypThen Hypothesis (HypDone (Suc Var))))

-- ---------------------------------------------------------------------------
-- Hardening demonstration: three candidates, none of which may hang.
-- ---------------------------------------------------------------------------

-- Build a unary Peano literal over the demo's own N (no builtin Nat, so the
-- kernel cannot GMP-accelerate it).
peano :: Int -> String
peano n = concat (replicate n "(s ") ++ "z" ++ replicate n ')'

-- A candidate that is well-typed and passes --safe termination checking, yet
-- forces the kernel into a 2^30-call conversion during typechecking. It cannot
-- finish inside the bound: the gate must refute it by timeout, not hang.
nonterminatingSource :: String
nonterminatingSource = unlines
  [ "{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}"
  , moduleMarker
  , "open import Cubical.Foundations.Prelude"
  , "data N : Type where"
  , "  z : N"
  , "  s : N \8594 N"
  , "data B : Type where"
  , "  tt ff : B"
  , "and : B \8594 B \8594 B"
  , "and tt b = b"
  , "and ff _ = ff"
  , "loop : N \8594 N \8594 B"
  , "loop z _ = tt"
  , "loop (s n) k = and (loop n k) (loop n (s k))"
  , "n30 : N"
  , "n30 = " ++ peano 30
  , "stall : loop n30 z \8801 tt"
  , "stall = refl"
  ]

data DemoOutcome = DemoOutcome
  { demoName :: String
  , demoVerdict :: Verdict
  , demoSeconds :: Double
  , demoCached :: Bool
  }

runDemoCandidate :: FilePath -> String -> String -> IO DemoOutcome
runDemoCandidate repo name src = do
  (v, secs, cached) <- checkSource repo src
  pure (DemoOutcome name v secs cached)

reportOutcome :: DemoOutcome -> IO ()
reportOutcome o =
  putStrLn $ "  " ++ pad 22 (demoName o)
    ++ pad 18 (show (demoVerdict o))
    ++ timing
    ++ (if demoCached o then "  (cache hit)" else "")
  where
    timing = show (fromIntegral (round (demoSeconds o * 100) :: Integer) / 100 :: Double) ++ "s"
    pad n s = s ++ replicate (max 1 (n - length s)) ' '

-- ---------------------------------------------------------------------------

main :: IO ()
main = do
  setLocaleEncoding utf8
  repo <- getCurrentDirectory

  -- (A) Hardening proof: three candidates, each resolving to a distinct
  -- Verdict without hanging the loop. Run first so the timings are fresh
  -- (the regression suite below then rides the warm cache).
  putStrLn ("HARDENING DEMO (bound " ++ show agdaTimeoutSecs
            ++ "s, kill +" ++ show agdaKillGraceSecs ++ "s):")
  fastAdmit <- runDemoCandidate repo "fast-admit" (renderModule good)
  typeError <- runDemoCandidate repo "type-error" (renderModule mutated)
  stall <- runDemoCandidate repo "kernel-nonterminating" nonterminatingSource
  -- Re-feed the admit candidate to exercise the hash cache (no Agda work).
  cachedAdmit <- runDemoCandidate repo "fast-admit (repeat)" (renderModule good)
  let outcomes = [fastAdmit, typeError, stall, cachedAdmit]
  forM_ outcomes reportOutcome

  let hardeningOK =
        demoVerdict fastAdmit == Admitted
          && demoVerdict typeError == RefutedTypeError
          && demoVerdict stall == RefutedTimeout
          && demoVerdict cachedAdmit == Admitted
          && demoCached cachedAdmit
          && demoSeconds stall < fromIntegral (agdaTimeoutSecs + agdaKillGraceSecs + 4)

  if hardeningOK
    then putStrLn "HARDENING GATE CHECKED: admit / reject-typeerror / reject-timeout all resolve; cache hit confirmed; no hang"
    else do
      putStrLn "hardening failure: unexpected verdict, cache miss, or timeout overran the bound"
      exitFailure

  -- (B) Regression: the ordinary certificate seam still admits/refutes
  -- correctly through the hardened, cached, timeout-wrapped path.
  putStrLn ""
  (ok, rules1) <- validateAndInstall repo "good" [] good
  (bad, rules2) <- validateAndInstall repo "mutated" rules1 mutated
  (leftOk, rules3) <- validateAndInstall repo "under-left" rules2 underLeft
  (rightReverseOk, rules4) <- validateAndInstall repo "under-right-reversed" rules3 underRightReversed
  -- A second checked installation with the same extensional action remains a
  -- second future. This is the executable no-premature-collapse control.
  (duplicateOk, rules5) <- validateAndInstall repo "good-second-source" rules4 good
  (inductionOk, rules6) <-
    validateAndInstallInduction repo "zero-plus-induction" rules5 zeroPlusInduction
  (malformedInductionOk, rules7) <-
    validateAndInstallInduction repo "malformed-induction" rules6 malformedInduction
  let futures = parallelFutures rules5 (source good)
      controlled = case rules1 of
        [rule] -> applyNative rule (source good) == Just (target good)
               && applyNative rule Zero == Nothing
        _ -> False
      regressionOK =
        ok && not bad && leftOk && rightReverseOk
          && duplicateOk
          && inductionOk
          && not malformedInductionOk
          && rules7 == rules6
          && map ruleName (drop (length rules5) rules6) == ["zero-plus-induction"]
          && length rules1 == 1
          && rules2 == rules1
          && controlled
          && map (ruleName . fst) futures == ["good", "good-second-source"]

  if regressionOK
    then putStrLn "AGDA GRAMMAR GATE CHECKED: direct + induction; malformed traces rejected"
    else do
      putStrLn ("gate failure: accepted=" ++ show ok ++ ", mutated=" ++ show bad
                ++ ", installed=" ++ show rules2)
      exitFailure
