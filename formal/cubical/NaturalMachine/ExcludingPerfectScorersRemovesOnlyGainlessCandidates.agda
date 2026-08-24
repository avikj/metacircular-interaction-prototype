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

{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- NaturalMachine.ExcludingPerfectScorersRemovesOnlyGainlessCandidates
--
-- `notes/DARWIN_GODEL_MATH.md` §2 lists four paper/code seams.  Seam 3
-- was checked two cycles ago; this is SEAM 1, and it reads:
--
--   "The paper's parent-eligibility set excludes perfect-score agents.
--    The released `choose_selfimproves` function does not make that
--    exclusion; every archived node whose metadata loads becomes a
--    candidate."
--
-- Stated that way it is a discrepancy.  Its mathematical content is
-- WHY the exclusion is there and WHEN dropping it is observable, and
-- both are short.
--
-- ────────────────────────────────────────────────────────────────────
-- WHAT IS PROVED
--
--   noStrictImprovementAtTheCap
--       under a score bound, an agent AT the bound admits no strictly
--       better agent.  So the paper's exclusion is not a heuristic or a
--       taste: it removes candidates whose possible gain is PROVABLY
--       zero, and a scheduler sampling them spends mass where no
--       improvement exists.
--   eligible / eligibleKeepsEveryImperfectAgent
--       the eligibility filter, computed — reusing the decidable-filter
--       kit and `discreteℕ` — together with the fact that it keeps
--       every agent below the cap
--   theSeamIsInvisibleExactlyWhenNobodyIsPerfect
--       so if no archived agent attains the cap, the two eligibility
--       sets have the same members and the seam cannot be observed
--
-- **This is the same shape seam 3 turned out to have,** and finding it
-- twice in one section is the point worth recording: a defect that is
-- undetectable exactly where it is harmless.  For seam 3 the branch
-- agreed with its comment only on a constant archive, where selection
-- carries no information.  For seam 1 the missing exclusion changes
-- nothing until some agent is perfect — and once one is, every sample
-- drawn on it is provably gainless.  Neither seam is cosmetic and
-- neither is visible in a benign archive.
--
-- ────────────────────────────────────────────────────────────────────
-- GRADE, unchanged and load-bearing: **I DID NOT READ THE CODE.**  §2
-- restricts its observations to one pinned commit of an external
-- repository, and this repository's egress rules mean no request to
-- github.com was made.  What is checked is the ORDER-THEORETIC CONTENT
-- OF §2'S SENTENCE, assuming the sentence describes the function
-- correctly.  If §2 misread it, nothing here is affected and nothing
-- here defends §2.
--
-- NO NOVELTY.  "Nothing exceeds a bound that is attained" is
-- elementary.  It is attached here because §2 records the discrepancy
-- without the reason, and the reason is what tells an implementer
-- whether to care.
--
-- WHAT IS NOT CLAIMED.  The CONVERSE of the first theorem — that an
-- agent below the cap DOES admit a strict improvement — is false in
-- general and is not claimed: the cap bounds the score, it does not
-- populate it.  Nothing is said about the SAMPLING WEIGHTS: §5.2's
-- `p_i` and the exploration mass `η` do not appear, so "spends mass
-- where no improvement exists" is a reading of the theorem, not a
-- quantitative claim, and no share of wasted budget is computed.
-- Scores are ℕ; §2's are accuracies.  "Perfect" is modelled as
-- attaining a stated cap, and no claim is made that the DGM's notion of
-- a perfect score is that.  Seams 2 and 4 remain untouched: adjacent
-- string literals concatenated by Python, and which model reads the
-- logs, are not order-theoretic.
--
-- CHECKED on the CONTAINER (Agda 2.6.3, cubical v0.5 — NOT the declared
-- pin, Agda 2.8.0 + cubical v0.9).  --safe, no postulates, no holes.
------------------------------------------------------------------------

module NaturalMachine.ExcludingPerfectScorersRemovesOnlyGainlessCandidates where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (ℕ ; discreteℕ)
open import Cubical.Data.Nat.Order using (_≤_ ; _<_ ; ≤-trans ; ¬m<m)
open import Cubical.Data.List using (List ; [] ; _∷_)
open import Cubical.Data.Sigma
open import Cubical.Relation.Nullary using (¬_ ; Dec ; yes ; no)

open import NaturalMachine.KramaAstiNasti_TheFourthCornerCannotLiveOverAnEnumerableDecidableInstanceSet
  using (Any)
open import NaturalMachine.TheParetoStratumIsDecidableAndTheFilterIsExact
  using (decNeg ; filterDec ; filterDecKeepsEverySatisfier)

module _ {A : Type} (score : A → ℕ) (cap : ℕ)
         (bounded : (a : A) → score a ≤ cap) where

  ------------------------------------------------------------------
  -- 1.  Why the exclusion is there
  ------------------------------------------------------------------

  AtCap : A → Type
  AtCap a = score a ≡ cap

  noStrictImprovementAtTheCap :
    (a : A) → AtCap a → ¬ (Σ[ b ∈ A ] (score a < score b))
  noStrictImprovementAtTheCap a atcap (b , lt) =
    ¬m<m (≤-trans (subst (_< score b) atcap lt) (bounded b))

  ------------------------------------------------------------------
  -- 2.  The eligibility filter, computed
  ------------------------------------------------------------------

  Imperfect : A → Type
  Imperfect a = ¬ AtCap a

  decImperfect : (a : A) → Dec (Imperfect a)
  decImperfect a = decNeg (discreteℕ (score a) cap)

  eligible : List A → List A
  eligible = filterDec Imperfect decImperfect

  eligibleKeepsEveryImperfectAgent :
    (xs : List A) (a : A)
    → Any (λ y → y ≡ a) xs → Imperfect a
    → Any (λ y → y ≡ a) (eligible xs)
  eligibleKeepsEveryImperfectAgent =
    filterDecKeepsEverySatisfier Imperfect decImperfect

  ------------------------------------------------------------------
  -- 3.  So the seam is invisible exactly when nobody is perfect
  ------------------------------------------------------------------

  theSeamIsInvisibleExactlyWhenNobodyIsPerfect :
    ((a : A) → Imperfect a)
    → (xs : List A) (a : A)
    → Any (λ y → y ≡ a) xs → Any (λ y → y ≡ a) (eligible xs)
  theSeamIsInvisibleExactlyWhenNobodyIsPerfect noneAtCap xs a mem =
    eligibleKeepsEveryImperfectAgent xs a mem (noneAtCap a)
