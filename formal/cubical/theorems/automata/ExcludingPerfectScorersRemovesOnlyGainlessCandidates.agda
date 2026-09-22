{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- ExcludingPerfectScorersRemovesOnlyGainlessCandidates
--
-- Seam 1 reads:
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
------------------------------------------------------------------------

module ExcludingPerfectScorersRemovesOnlyGainlessCandidates where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (ℕ ; discreteℕ)
open import Cubical.Data.Nat.Order using (_≤_ ; _<_ ; ≤-trans ; ¬m<m)
open import Cubical.Data.List using (List ; [] ; _∷_)
open import Cubical.Data.Sigma
open import Cubical.Relation.Nullary using (¬_ ; Dec ; yes ; no)

open import KramaAstiNasti_TheFourthCornerCannotLiveOverAnEnumerableDecidableInstanceSet
  using (Any)
open import TheParetoStratumIsDecidableAndTheFilterIsExact
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
