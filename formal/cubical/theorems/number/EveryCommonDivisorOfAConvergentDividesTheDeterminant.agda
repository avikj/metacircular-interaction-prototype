{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- EveryCommonDivisorOfAConvergentDividesTheDeterminant
--
-- A corollary of the LOSSLESS face, not the missing third face.  Any
-- common divisor of a convergent's numerator and denominator divides the
-- determinant of that convergent and the next — which, under the
-- standard seeds, is ±1.  So a convergent carries no common factor that
-- the unit determinant does not already bound.
--
-- ────────────────────────────────────────────────────────────────────
-- WHERE THIS SITS, AND WHAT IT IS NOT
--
-- `notes/KUTTAKA_JIVA_DECISIONLESS_PULVERIZER.md`'s `PROVE` tag asks
-- whether lossless / complete / stable recur for the convergents.
--
--   lossless  answered  (`TheValliConvergentDeterminantAlternates`)
--   stable    answered  (`ConvergentsAreDeterminedByThePrefixOfTheValli`)
--   complete  STILL NOT ANSWERED, and this module does not answer it
--
-- I attempted COMPLETE this cycle and it does not come from the
-- recurrence.  `Purnata.पूर्णतया-गुरुतमः` says enough grant always
-- resolves; at the convergents that is "the vallī of a rational
-- terminates, and the last convergent cross-multiplies back to it" —
-- i.e. `num K · b ≡ a · den K` for the terminal index K.  Every part of
-- that except the cross-multiplication is about how the quotients are
-- PRODUCED, which is the kuṭṭaka (`Gati`, `Purnata`, `GurutamaSiddha`),
-- not about the two-step recurrence these modules study.  So the third
-- face needs those modules, and saying that is the honest report; this
-- module is what the attempt produced on the way, and it is a corollary
-- of the first face rather than progress on the third.
--
-- WHAT IS NOT CLAIMED.  NOT that the convergents are in lowest terms.
-- That needs "a divisor of ±1 in ℤ is ±1", a classification of units
-- which is NOT proved here and NOT imported.  §2 stops exactly where the
-- algebra stops: the common divisor divides a unit.  Calling that
-- "coprime" would be asserting the missing step.
--
-- SOURCING LIMIT.  Verse-level sourcing OWED AND NOT CLAIMED, as for
-- both Kuttaka lanes and both convergent modules; nothing here is a
-- reading of Gaṇitapāda 32–33.
--
-- CHECKED on the CONTAINER (Agda 2.6.3, cubical v0.5 — NOT the declared
-- pin, Agda 2.8.0 + cubical v0.9).  --safe, no postulates, no holes.
------------------------------------------------------------------------

module EveryCommonDivisorOfAConvergentDividesTheDeterminant where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (ℕ ; suc)
open import Cubical.Data.Int using (ℤ ; pos ; _·_ ; _-_)
open import Cubical.Data.Sigma
open import Cubical.Algebra.CommRing.Instances.Int using (ℤCommRing)
open import Cubical.Tactics.CommRingSolver.Reflection using (solve!)

open import TheValliConvergentDeterminantAlternates
  using (num ; den ; det ; signed ; standardDeterminantIsAUnit)

------------------------------------------------------------------------
-- 1.  Divisibility over ℤ, and the one ring identity the proof needs
------------------------------------------------------------------------

_divides_ : ℤ → ℤ → Type
d divides x = Σ[ c ∈ ℤ ] (x ≡ c · d)

private
  pullOut : (x d E F y : ℤ) → (x · d) · E - F · (y · d) ≡ (x · E - F · y) · d
  pullOut x d E F y = solve! ℤCommRing

------------------------------------------------------------------------
-- 2.  A common divisor of a convergent divides its determinant
------------------------------------------------------------------------

module _ (a : ℕ → ℤ) (p₀ p₁ q₀ q₁ : ℤ) where

  private
    N : ℕ → ℤ
    N = num a p₀ p₁ q₀ q₁

    D : ℕ → ℤ
    D = den a p₀ p₁ q₀ q₁

  commonDivisorDividesDet :
    (k : ℕ) (d : ℤ)
    → d divides N k → d divides D k
    → d divides det a p₀ p₁ q₀ q₁ k
  commonDivisorDividesDet k d (x , nx) (y , dy) =
      (x · D (suc k) - N (suc k) · y)
    , ( cong₂ _-_ (cong (_· D (suc k)) nx) (cong (N (suc k) ·_) dy)
      ∙ pullOut x d (D (suc k)) (N (suc k)) y )

------------------------------------------------------------------------
-- 3.  Under the standard seeds, that determinant is a unit
------------------------------------------------------------------------

commonDivisorDividesAUnit :
  (a : ℕ → ℤ) (k : ℕ) (d : ℤ)
  → d divides num a (pos 1) (a 0) (pos 0) (pos 1) k
  → d divides den a (pos 1) (a 0) (pos 0) (pos 1) k
  → d divides signed k (pos 1)
commonDivisorDividesAUnit a k d dn dd =
  subst (d divides_)
    (standardDeterminantIsAUnit a k)
    (commonDivisorDividesDet a (pos 1) (a 0) (pos 0) (pos 1) k d dn dd)

------------------------------------------------------------------------
-- 4.  The report on the third face
--
-- COMPLETE is not here and is not close.  The two convergent modules
-- study a recurrence given a vallī; completeness is a statement about
-- where the vallī comes from and that it stops.  Anyone continuing this
-- should start from `Gati` and `Purnata`, not from these two.
------------------------------------------------------------------------
