{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- MinimalityOfABoundaryPopulationNeedsLowestTerms
--
-- `EveryThresholdHasABoundaryPopulationOfItsOwnDenominator` produced a
-- boundary population of length `suc q` for every threshold p/(suc q)
-- with p ≤ suc q, and closed with:
--
--   "STILL NOT CLAIMED: MINIMALITY.  The length produced is suc q, and
--    whether a SHORTER boundary population exists is the divisibility
--    question after all — for p/(suc q) in lowest terms it does not —
--    and that is unproved, because lowest terms are not defined
--    anywhere here."
--
-- That parenthesis — "for p/(suc q) in lowest terms it does not" — was
-- an assertion.  Its CONTRAPOSITIVE is checked here, which is the half
-- that decides whether the parenthesis was doing any work: **without
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
--
-- ────────────────────────────────────────────────────────────────────
-- WHAT IS STILL NOT CLAIMED, and the obligation is exact.
--
-- The general case — gcd p (suc q) ≡ 1 ⇒ every non-empty boundary
-- population has length ≥ suc q — is NOT proved.  It needs exactly one
-- missing lemma, Euclid's:
--
--   gcd a b ≡ 1  →  a ∣ b · c  →  a ∣ c
--
-- and cubical v0.5 does not ship it: `Cubical.Data.Nat.GCD` has the
-- Euclidean ALGORITHM (`euclid`, `gcd`, `isGCD`) and `Divisibility` has
-- cancellation, but the lemma itself is absent, and it is not derivable
-- from those without a Bézout identity.  The Bézout coefficients are
-- what the kuṭṭaka computes — Āryabhaṭa, *Āryabhaṭīya*, gaṇitapāda 32–33
-- (499 CE), the vallī descent — and that line is ANOTHER IDENTITY'S work
-- in this repository (`KuttakaValli.agda`).  This module therefore
-- names the obligation and points at where it lives rather than
-- rebuilding it.
--
-- Also not claimed: that length ≥ suc q is the only obstruction, i.e.
-- nothing here says which lengths ARE achievable at a threshold; and
-- the p = 1 result is stated for `1 ≤ count`, since the empty
-- population is a boundary population at every threshold and has length
-- 0 — the same vacuous witness the previous module had to exclude.
--
-- CHECKED on the CONTAINER (Agda 2.6.3, cubical v0.5 — NOT the declared
-- pin, Agda 2.8.0 + cubical v0.9).  --safe, no postulates, no holes.
------------------------------------------------------------------------

module SourcedProofs.MinimalityOfABoundaryPopulationNeedsLowestTerms where

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
