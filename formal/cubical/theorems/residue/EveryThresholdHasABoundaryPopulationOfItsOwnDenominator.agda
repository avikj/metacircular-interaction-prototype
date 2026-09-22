{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- EveryThresholdHasABoundaryPopulationOfItsOwnDenominator
--
-- `TheStrictThresholdsAreTheSameChainAndDifferOnlyAtTheBoundary` showed
-- that the strict and non-strict families differ exactly at a
-- population sitting ON a threshold, exhibited ONE such population at
-- ONE threshold.  This module shows that EVERY threshold has such a
-- population.
--
-- It is a statement about ℕ, and there is no divisibility in it: the
-- denominator itself is the length.  For p ≤ suc q, the population of
-- p trues followed by (suc q ∸ p) falses has length exactly suc q and
-- count exactly p, so `p · length ≡ suc q · count` holds on the nose.
--
-- ────────────────────────────────────────────────────────────────────
-- WHY THE STATEMENT CARRIES ITS LENGTH, and this is the whole care in
-- the module.  The EMPTY population satisfies `AtLeast p q` and refutes
-- `Above p q` for EVERY p and q, since `p · 0 ≡ 0 ≡ suc q · 0`.  So
-- "every threshold has a boundary population" is TRUE VACUOUSLY and
-- proving it that way would establish nothing about the gap between the
-- families.  The theorem below therefore returns the length as part of
-- the claim — `length bs ≡ suc q`, hence at least one — and the
-- vacuous witness does not satisfy it.  A Σ whose interesting content
-- is omitted is the same defect as a figure quoted without its input.
--
-- ────────────────────────────────────────────────────────────────────
-- WHAT IS PROVED
--
--   falses / pop           the population, by recursion on ℕ, never
--                          touching `Fin` or an index
--   countPop / lengthPop   count (pop p k) ≡ p, length (pop p k) ≡ p + k
--   boundaryEquation       p · length ≡ suc q · count, exactly
--   everyThresholdHasABoundaryPopulation
--                          for p ≤ suc q: a population of length suc q
--                          meeting the threshold and refuting the
--                          strict one
--
-- The hypothesis `p ≤ suc q` is what "a threshold" means here — p/(suc
-- q) above 1 is not a rate any population can meet non-vacuously, since
-- `count ≤ length` is proved in `RateOneIsExactlyTheUniversalClaim`.
------------------------------------------------------------------------

module EveryThresholdHasABoundaryPopulationOfItsOwnDenominator where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat
  using (ℕ ; zero ; suc ; _+_ ; _·_ ; +-comm ; ·-comm ; 0≡m·0)
open import Cubical.Data.Nat.Order using (_≤_ ; _<_ ; ≤-refl ; ¬m<m)
open import Cubical.Data.Bool using (Bool ; true ; false)
open import Cubical.Data.List using (List ; [] ; _∷_)
open import Cubical.Data.Sigma
open import Cubical.Relation.Nullary using (¬_)

open import RateOneIsExactlyTheUniversalClaim
  using (count ; length)
open import TheThresholdOrderIsTotalAndTheClaimIsAntitone
  using (AtLeast)
open import TheStrictThresholdsAreTheSameChainAndDifferOnlyAtTheBoundary
  using (Above)

------------------------------------------------------------------------
-- 1.  The population, by recursion on ℕ
------------------------------------------------------------------------

falses : ℕ → List Bool
falses zero    = []
falses (suc k) = false ∷ falses k

pop : ℕ → ℕ → List Bool
pop zero    k = falses k
pop (suc p) k = true ∷ pop p k

countFalses : (k : ℕ) → count (falses k) ≡ 0
countFalses zero    = refl
countFalses (suc k) = countFalses k

lengthFalses : (k : ℕ) → length (falses k) ≡ k
lengthFalses zero    = refl
lengthFalses (suc k) = cong suc (lengthFalses k)

countPop : (p k : ℕ) → count (pop p k) ≡ p
countPop zero    k = countFalses k
countPop (suc p) k = cong suc (countPop p k)

lengthPop : (p k : ℕ) → length (pop p k) ≡ p + k
lengthPop zero    k = lengthFalses k
lengthPop (suc p) k = cong suc (lengthPop p k)

------------------------------------------------------------------------
-- 2.  It sits exactly on the threshold
------------------------------------------------------------------------

boundaryEquation :
  (p q k : ℕ) → k + p ≡ suc q
  → p · length (pop p k) ≡ suc q · count (pop p k)
boundaryEquation p q k eq =
    cong (p ·_) (lengthPop p k)
  ∙ cong (p ·_) (+-comm p k)
  ∙ cong (p ·_) eq
  ∙ ·-comm p (suc q)
  ∙ cong (suc q ·_) (sym (countPop p k))

------------------------------------------------------------------------
-- 3.  Hence every threshold has one, of length its own denominator
--
-- cubical's `m ≤ n` IS `Σ[ k ] k + m ≡ n`, so the hypothesis supplies
-- the number of falses directly — no subtraction and no divisibility.
------------------------------------------------------------------------

everyThresholdHasABoundaryPopulation :
  (p q : ℕ) → p ≤ suc q
  → Σ[ bs ∈ List Bool ]
      ((length bs ≡ suc q) × (AtLeast p q bs) × (¬ Above p q bs))
everyThresholdHasABoundaryPopulation p q (k , eq) =
  pop p k , (len , atl , nab)
  where
    eqn : p · length (pop p k) ≡ suc q · count (pop p k)
    eqn = boundaryEquation p q k eq

    len : length (pop p k) ≡ suc q
    len = lengthPop p k ∙ +-comm p k ∙ eq

    atl : AtLeast p q (pop p k)
    atl = subst (p · length (pop p k) ≤_) eqn ≤-refl

    nab : ¬ Above p q (pop p k)
    nab h = ¬m<m (subst (p · length (pop p k) <_) (sym eqn) h)

------------------------------------------------------------------------
-- 4.  The vacuous witness, stated so it cannot be mistaken for the
--     theorem
--
-- The empty population meets every threshold and refutes every strict
-- one.  §3 is not this, and the length component is what separates them.
------------------------------------------------------------------------

emptyMeetsEveryThreshold : (p q : ℕ) → AtLeast p q []
emptyMeetsEveryThreshold p q = subst2 _≤_ (0≡m·0 p) (0≡m·0 (suc q)) ≤-refl

emptyIsAboveNoThreshold : (p q : ℕ) → ¬ Above p q []
emptyIsAboveNoThreshold p q h =
  ¬m<m (subst (p · 0 <_) (sym (0≡m·0 (suc q)) ∙ 0≡m·0 p) h)

------------------------------------------------------------------------
-- MINIMALITY.  Whether a boundary population SHORTER than suc q exists is the
-- divisibility question, settled in `MinimalityOfABoundaryPopulationNeedsLowestTerms`:
--   twoOverFourHasAShortBoundaryPopulation / soMinimalityFailsWithoutLowestTerms
--       at 2/4 the population `true ∷ false ∷ []` is a boundary
--       population — 2 · 2 ≡ 4 ≡ 4 · 1 — of length 2 < 4.
--
-- So "in lowest terms" is not a convenience.  Dropping it makes the
-- minimality statement FALSE, and `pop p k` above is then not minimal.
--
-- The positive half at numerator one:
--
--   boundaryDividesAtNumeratorOne   suc q ∣ length bs
--   minimalityAtNumeratorOne        hence suc q ≤ length bs, for a
--                                   non-empty boundary population
--
-- because at p = 1 there is nothing to cancel.
--
-- 2/4 and 1/2 are the same RATE and different PAIRS, and here the
-- quotient by rate has a visible consequence:
-- MINIMALITY IS NOT A PROPERTY OF THE RATE, only of the pair.
--
------------------------------------------------------------------------
