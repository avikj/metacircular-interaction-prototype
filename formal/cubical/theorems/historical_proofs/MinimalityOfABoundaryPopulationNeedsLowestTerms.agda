{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- MinimalityOfABoundaryPopulationNeedsLowestTerms
--
-- `EveryThresholdHasABoundaryPopulationOfItsOwnDenominator` produced a
-- boundary population of length `suc q` for every threshold p/(suc q)
-- with p ≤ suc q.
-- Whether a SHORTER boundary population exists is the divisibility
-- question, and this module checks the half that decides whether the
-- lowest-terms condition is doing any work: **without
-- lowest terms, minimality is false**, and a two-element population
-- witnesses it at 2/4.  So the coprimality condition is not a technical
-- convenience; dropping it breaks the theorem.
--
-- ────────────────────────────────────────────────────────────────────
-- WHAT IS PROVED
--
--   Boundary p q bs        p · length bs ≡ suc q · count bs
--   boundaryDividesAtNumeratorOne
--                          at p = 1: suc q ∣ length bs, outright
--   minimalityAtNumeratorOne
--                          hence a non-empty boundary population at
--                          1/(suc q) has length ≥ suc q — the pop of
--                          §3 there is minimal, for p = 1
--   twoOverFourHasAShortBoundaryPopulation
--                          at 2/4 the population `true ∷ false ∷ []` is
--                          a boundary population of length 2 < 4
--   soMinimalityFailsWithoutLowestTerms
--                          the two together: the same statement that
--                          holds at 1/(suc q) is FALSE at 2/4
--
-- 2/4 and 1/2 are the same rate.  The threshold order `⊑` of
-- `TheThresholdOrderIsTotalAndTheClaimIsAntitone` is a total PREORDER
-- and is not quotiented by that, and this is the first place where the
-- missing quotient has visible consequences: minimality is not a
-- property of the RATE, only of the PAIR.
------------------------------------------------------------------------

module MinimalityOfABoundaryPopulationNeedsLowestTerms where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat
  using (ℕ ; zero ; suc ; _+_ ; _·_ ; +-comm ; ·-comm ; ·-identityˡ
        ; injSuc ; snotz)
open import Cubical.Data.Nat.Order
  using (_≤_ ; _<_ ; ≤-trans ; ¬-<-zero)
open import Cubical.Data.Nat.Divisibility using (_∣_ ; ∣-right ; m∣n→m≤n)
open import Cubical.Data.Bool using (Bool ; true ; false)
open import Cubical.Data.List using (List ; [] ; _∷_)
open import Cubical.Data.Sigma
open import Cubical.Relation.Nullary using (¬_)

open import RateOneIsExactlyTheUniversalClaim
  using (count ; length ; countIsAtMostLength)

------------------------------------------------------------------------
-- 1.  Sitting exactly on a threshold
------------------------------------------------------------------------

Boundary : ℕ → ℕ → List Bool → Type
Boundary p q bs = p · length bs ≡ suc q · count bs

------------------------------------------------------------------------
-- 2.  At numerator one, the denominator divides the length
--
-- `1 · L ≡ suc q · C` is `L ≡ suc q · C` once `·-identityˡ` is used,
-- and that is already a divisibility witness — no Euclid needed,
-- because there is nothing to cancel.
------------------------------------------------------------------------

boundaryDividesAtNumeratorOne :
  (q : ℕ) (bs : List Bool) → Boundary 1 q bs → suc q ∣ length bs
boundaryDividesAtNumeratorOne q bs b =
  subst (suc q ∣_) shape (∣-right (count bs))
  where
    shape : count bs · suc q ≡ length bs
    shape = ·-comm (count bs) (suc q) ∙ sym b ∙ ·-identityˡ (length bs)

minimalityAtNumeratorOne :
  (q : ℕ) (bs : List Bool) → Boundary 1 q bs → 1 ≤ count bs
  → suc q ≤ length bs
minimalityAtNumeratorOne q bs b pos =
  m∣n→m≤n nonzero (boundaryDividesAtNumeratorOne q bs b)
  where
    lengthPos : 1 ≤ length bs
    lengthPos = ≤-trans pos (countIsAtMostLength bs)

    nonzero : ¬ length bs ≡ 0
    nonzero e = ¬-<-zero (subst (1 ≤_) e lengthPos)

------------------------------------------------------------------------
-- 3.  Without lowest terms it is false
--
-- 2/4 is the same RATE as 1/2 and a different PAIR.  One true and one
-- false is a boundary population there — 2 · 2 ≡ 4 ≡ 4 · 1 — of length
-- 2, which is strictly less than the denominator 4.
------------------------------------------------------------------------

short : List Bool
short = true ∷ false ∷ []

shortIsABoundaryPopulation : Boundary 2 3 short
shortIsABoundaryPopulation = refl

shortIsShorterThanTheDenominator : ¬ (4 ≤ length short)
shortIsShorterThanTheDenominator (k , e) =
  snotz (injSuc (injSuc (sym (+-comm k 4) ∙ e)))

shortIsNonEmpty : 1 ≤ count short
shortIsNonEmpty = 0 , refl

soMinimalityFailsWithoutLowestTerms :
  (Boundary 2 3 short) × (1 ≤ count short) × (¬ (4 ≤ length short))
soMinimalityFailsWithoutLowestTerms =
  shortIsABoundaryPopulation , shortIsNonEmpty ,
  shortIsShorterThanTheDenominator
