{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- EveryCommonDivisorOfAConvergentDividesTheDeterminant
--
-- A corollary of the LOSSLESS face.  Any
-- common divisor of a convergent's numerator and denominator divides the
-- determinant of that convergent and the next — which, under the
-- standard seeds, is ±1.  So a convergent carries no common factor that
-- the unit determinant does not already bound.
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
