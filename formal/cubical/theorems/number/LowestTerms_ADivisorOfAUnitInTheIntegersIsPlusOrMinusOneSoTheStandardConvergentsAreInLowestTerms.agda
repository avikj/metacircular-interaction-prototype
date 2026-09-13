{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- LowestTerms_ADivisorOfAUnitInTheIntegersIsPlusOrMinusOneSoTheStandardConvergentsAreInLowestTerms
--
-- Closes the absence stated in
-- `EveryCommonDivisorOfAConvergentDividesTheDeterminant`, which says:
--
--   "SYĀT — THE CLAIM, EXACTLY.  NOT that the convergents are in lowest
--    terms.  That needs "a divisor of ±1 in ℤ is ±1", a classification
--    of units which is NOT proved here and NOT imported.  §2 stops
--    exactly where the algebra stops: the common divisor divides a
--    unit.  Calling that "coprime" would be asserting the missing step."
--
-- WHAT IS PROVED HERE.
--
--   §1  In ℕ, x · y ≡ 1 forces x ≡ 1            (`natProductOneLeft`)
--   §2  In ℤ, a · b ≡ 1 forces a ≡ 1 or a ≡ -1   (`unitIsPlusOrMinusOne`,
--       and the same for b, `unitIsPlusOrMinusOneʳ`) — the classification
--       of units of ℤ, obtained through `abs` and the multiplicativity
--       lemma `abs·` of Cubical.Data.Int.Properties.
--   §3  A divisor of ±1 is ±1                     (`divisorOfAUnitIsAUnit`),
--       and in particular a divisor of `signed k (pos 1)` is ±1
--       (`divisorOfSignedOne`), using abs (signed k x) ≡ abs x.
--   §4  Every common divisor of the k-th standard convergent's numerator
--       and denominator is ±1                     (`standardConvergentsAreInLowestTerms`).
--       This IMPORTS §3 of the earlier module (`commonDivisorDividesAUnit`)
--       and does not re-prove it; the only new step is §3 here.
--
-- Divisibility is the earlier module's own relation `_divides_`
-- (d divides x  =  Σ c. x ≡ c · d), imported, not redefined, so §4 is
-- stated in exactly its terms.
--
-- WHAT IS NOT PROVED HERE.  Nothing about the third face (COMPLETE):
-- this module says nothing about where the vallī comes from or that it
-- terminates.  "Lowest terms" here means precisely: every common divisor
-- of numerator and denominator is a unit of ℤ, and the units of ℤ are
-- exactly ±1.  No gcd is computed and no Bézout witness is produced.
--
-- --safe, no postulates, no holes.
------------------------------------------------------------------------

module LowestTerms_ADivisorOfAUnitInTheIntegersIsPlusOrMinusOneSoTheStandardConvergentsAreInLowestTerms where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Empty as ⊥ using ()
open import Cubical.Data.Sum using (_⊎_ ; inl ; inr)
open import Cubical.Data.Sigma
open import Cubical.Data.Nat as ℕ
  using (ℕ ; zero ; suc ; injSuc ; snotz ; znots
        ; m+n≡0→m≡0×n≡0 ; 0≡n·sm→0≡n ; 0≡m·0)
open import Cubical.Data.Int using (ℤ ; pos ; negsuc ; -_ ; _·_ ; abs)
open import Cubical.Data.Int.Properties using (abs· ; abs- ; abs→⊎ ; ⊎→abs ; ·Comm)

open import TheValliConvergentDeterminantAlternates using (num ; den ; signed)
open import EveryCommonDivisorOfAConvergentDividesTheDeterminant
  using (_divides_ ; commonDivisorDividesAUnit)

------------------------------------------------------------------------
-- 1.  In ℕ, a product equal to 1 has left factor 1
--
-- suc x · suc y  unfolds to  suc (y + x · suc y), so the equation
-- suc x · suc y ≡ 1 peels to y + x · suc y ≡ 0, whence x · suc y ≡ 0,
-- whence x ≡ 0.
------------------------------------------------------------------------

natProductOneLeft : (x y : ℕ) → x ℕ.· y ≡ 1 → x ≡ 1
natProductOneLeft zero    y       p = ⊥.rec (znots p)
natProductOneLeft (suc x) zero    p = ⊥.rec (snotz (sym p ∙ sym (0≡m·0 (suc x))))
natProductOneLeft (suc x) (suc y) p =
  cong suc (sym (0≡n·sm→0≡n (sym (snd (m+n≡0→m≡0×n≡0 (injSuc p))))))

------------------------------------------------------------------------
-- 2.  The units of ℤ are exactly ±1
------------------------------------------------------------------------

absProductOneLeft : (a b : ℤ) → abs (a · b) ≡ 1 → abs a ≡ 1
absProductOneLeft a b p = natProductOneLeft (abs a) (abs b) (sym (abs· a b) ∙ p)

-- If a · b ≡ 1 then a ≡ 1 or a ≡ -1.  (- pos 1 is negsuc 0 by computation.)
unitIsPlusOrMinusOne : (a b : ℤ) → a · b ≡ pos 1 → (a ≡ pos 1) ⊎ (a ≡ - pos 1)
unitIsPlusOrMinusOne a b p = abs→⊎ a 1 (absProductOneLeft a b (cong abs p))

unitIsPlusOrMinusOneʳ : (a b : ℤ) → a · b ≡ pos 1 → (b ≡ pos 1) ⊎ (b ≡ - pos 1)
unitIsPlusOrMinusOneʳ a b p = unitIsPlusOrMinusOne b a (·Comm b a ∙ p)

-- The same statement with the literal constructors, for anyone who wants
-- to read "-1" as negsuc 0 rather than as - pos 1.
unitIsPosOneOrNegsucZero : (a b : ℤ) → a · b ≡ pos 1 → (a ≡ pos 1) ⊎ (a ≡ negsuc 0)
unitIsPosOneOrNegsucZero = unitIsPlusOrMinusOne

------------------------------------------------------------------------
-- 3.  A divisor of ±1 is ±1
--
-- This is the sentence the earlier module names as missing.  From
-- u ≡ c · d and abs u ≡ 1 we get abs d · abs c ≡ 1, so abs d ≡ 1.
------------------------------------------------------------------------

divisorOfAbsOne : (u d : ℤ) → abs u ≡ 1 → d divides u → (d ≡ pos 1) ⊎ (d ≡ - pos 1)
divisorOfAbsOne u d au (c , e) =
  abs→⊎ d 1 (absProductOneLeft d c (cong abs (·Comm d c ∙ sym e) ∙ au))

divisorOfAUnitIsAUnit :
  (u d : ℤ) → (u ≡ pos 1) ⊎ (u ≡ - pos 1) → d divides u → (d ≡ pos 1) ⊎ (d ≡ - pos 1)
divisorOfAUnitIsAUnit u d uUnit = divisorOfAbsOne u d (⊎→abs u 1 uUnit)

-- `signed k x` is x with k sign flips; its absolute value is that of x.
absSigned : (k : ℕ) (x : ℤ) → abs (signed k x) ≡ abs x
absSigned zero    x = refl
absSigned (suc k) x = abs- (signed k x) ∙ absSigned k x

divisorOfSignedOne : (k : ℕ) (d : ℤ) → d divides signed k (pos 1) → (d ≡ pos 1) ⊎ (d ≡ - pos 1)
divisorOfSignedOne k d = divisorOfAbsOne (signed k (pos 1)) d (absSigned k (pos 1))

------------------------------------------------------------------------
-- 4.  The standard convergents are in lowest terms
--
-- Under the standard seeds p₀ = 1, p₁ = a 0, q₀ = 0, q₁ = 1, every
-- common divisor of num k and den k is ±1.  The first step (the common
-- divisor divides signed k (pos 1)) is the earlier module's §3, imported.
------------------------------------------------------------------------

standardConvergentsAreInLowestTerms :
  (a : ℕ → ℤ) (k : ℕ) (d : ℤ)
  → d divides num a (pos 1) (a 0) (pos 0) (pos 1) k
  → d divides den a (pos 1) (a 0) (pos 0) (pos 1) k
  → (d ≡ pos 1) ⊎ (d ≡ - pos 1)
standardConvergentsAreInLowestTerms a k d dn dd =
  divisorOfSignedOne k d (commonDivisorDividesAUnit a k d dn dd)
