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

-- BenchHeadDepth — measured cheapening from installing the corpus theorem W3.
--
-- OBJECTIVE (RUNTIME.md §4 item 5): make a real corpus theorem enter the
-- natural-machine runtime and measurably cheapen a future computation.  The
-- theorem is Thm W3 (formal/cubical/HeadDepthMerge.agda):
--
--     b Fermat-blind on q^a  ⟺  a ≤ e_b(q),   e_b(q) a-independent,
--
-- installed as the single rewrite  fb(q,a,b) → le(a, eb(q,b))  (HeadDepthVocab).
--
-- WHAT IS MEASURED.  A batch of blindness queries {fb(q,a,b)} over the certified
-- 1048-triple range is decided two ways, using the MACHINE'S OWN `normalize`:
--
--   WITHOUT the e_b rewrite:  fb(q,a,b) is irreducible — each query is its own
--     head-depth-free core, so the batch presents K distinct expensive cores
--     (one modular exponentiation per triple, per the direct Fermat test).
--
--   WITH the e_b rewrite:     normalize rewrites fb(q,a,b) → le(a, eb(q,b)); the
--     a-dimension moves into the cheap `le(a, ·)` wrapper and the only
--     irreducible expensive cores left are the eb(q,b) head-depth carriers —
--     M distinct ones (one per (q,b) pair).
--
-- The pruned fraction is reported the way MathMachine's log reports it:
--     pruned% = 100 * (1 − normed / raw).
-- Here raw = K query cores, normed = distinct expensive cores that survive.
--
-- All load-bearing counts are exact integers.  The only Double is the final %
-- display, and the exact fraction (and its closed form) is printed alongside it.
--
-- SOUNDNESS FIREWALL.  Before measuring, the installed rewrite is checked to
-- COMPUTE THE SAME BIT as the direct Fermat test on every one of the K triples,
-- by exact integer arithmetic (the analogue of MathMachine's definition
-- firewall, and a self-contained re-run of HeadDepthMerge.agda's w3Certificate).
-- A single disagreement aborts the benchmark: an unsound rewrite must not be
-- credited with pruning.

module Main (main) where

import qualified Data.Set as S
import Text.Printf (printf)
import System.Exit (exitFailure)
import Control.Monad (when, unless)
import HeadDepthVocab

-- distinct expensive cores in the normalized batch under a given rule set
distinctCores :: [Rule] -> String -> [Term] -> S.Set Term
distinctCores rules coreHead batch =
  S.fromList
    [ c
    | q <- batch
    , c <- coresHeadedBy coreHead (normalize rules q) ]

main :: IO ()
main = do
  let triples = certifiedTriples
      pairs   = certifiedPairs
      queries = [ fbQuery q a b | (q,a,b) <- triples ]

  -- ---- soundness firewall: the installed rewrite is faithful on the range
  let disagreements =
        [ (q,a,b)
        | (q,a,b) <- triples
        , fermatBlind q a b /= aLeE q a b ]
  printf "FIREWALL  triples=%d disagreements=%d  (installed rewrite fb->le(a,eb) is %s)\n"
    (length triples) (length disagreements)
    (if null disagreements then "SOUND on the range" else "UNSOUND")
  unless (null disagreements) $ do
    putStrLn "  ABORT: installed rewrite disagrees with the direct Fermat test; refusing to credit pruning."
    mapM_ (\t -> putStrLn ("    disagreement at " ++ show t)) (take 8 disagreements)
    exitFailure

  -- ---- the measurement, via the machine's own normalize
  let rulesWithout = leDefs                 -- no e_b knowledge installed
      rulesWith    = w3Rule : leDefs        -- Thm W3 installed as a rewrite

      -- WITHOUT: fb is irreducible, each query is its own head-depth-free core
      coresWithout = distinctCores rulesWithout "fb" queries
      -- WITH: the surviving expensive cores are the eb(q,b) head-depth carriers
      coresWith    = distinctCores rulesWith "eb" queries

      k = S.size coresWithout          -- raw expensive cores  (= |triples|)
      m = S.size coresWith             -- surviving cores      (= |pairs|)

      -- proof-step accounting: total rewrite steps to normalize the batch
      stepsWithout = sum [ snd (normalizeSteps rulesWithout q) | q <- queries ]
      stepsWith    = sum [ snd (normalizeSteps rulesWith    q) | q <- queries ]

  -- cross-checks tying the term-space measurement to the exact combinatorics
  when (k /= length triples) $
    printf "  WARN: core count %d /= triple count %d\n" k (length triples)
  when (m /= length pairs) $
    printf "  WARN: eb-core count %d /= (q,b)-pair count %d\n" m (length pairs)

  let removed      = k - m
      prunedTimes10 = (removed * 1000) `div` k     -- exact tenths of a percent
      prunedPct :: Double
      prunedPct = 100 * (1 - fromIntegral m / fromIntegral k)

  putStrLn ""
  putStrLn "== blindness-query term space (MathMachine normalize, exact counts) =="
  -- printed in the machine's own round-log shape
  printf "round 0  vocab=fb,eb,le,s,0  size=-  terms=%d normed=%d pruned=%.1f%%  cores=fb  steps=%d   (WITHOUT e_b)\n"
    k k (0.0 :: Double) stepsWithout
  printf "round 0  vocab=fb,eb,le,s,0  size=-  terms=%d normed=%d pruned=%.1f%%  cores=eb  steps=%d   (WITH  e_b : Thm W3)\n"
    k m prunedPct stepsWith
  putStrLn ""
  printf "PRUNED  installing e_b removes %d of %d blindness-query expensive cores = %.1f%% of the term space\n"
    removed k prunedPct
  printf "        exact fraction removed = %d/%d = %d.%d%%   (M=%d distinct (q,b) head-depth cores survive)\n"
    removed k (prunedTimes10 `div` 10) (prunedTimes10 `mod` 10) m

  -- DERIVED, not fitted (CLAUDE.md): every (q,b) pair in the range carries all
  -- A=4 values of a, so K = A·M exactly, hence pruned = 1 − 1/A = (A−1)/A.
  let bigA = 4
  printf "        derived closed form: K = A*M with A=%d  =>  pruned = (A-1)/A = %d/%d = exactly %d.%d%%\n"
    bigA (bigA-1) bigA (((bigA-1)*1000 `div` bigA) `div` 10) (((bigA-1)*1000 `div` bigA) `mod` 10)
  let exactMatch = removed * bigA == (bigA - 1) * k && k == bigA * m
  printf "        exact-arithmetic check  K==A*M and removed*A==(A-1)*K : %s\n"
    (if exactMatch then "PASS (measurement == derived 3/4)" else "FAIL")
  unless exactMatch $ exitFailure

  putStrLn ""
  printf "STEPS   rewrite steps to decide the batch: without=%d  with=%d  (the with-column pays one fb->le step per query and then stops at the shared eb core)\n"
    stepsWithout stepsWith
