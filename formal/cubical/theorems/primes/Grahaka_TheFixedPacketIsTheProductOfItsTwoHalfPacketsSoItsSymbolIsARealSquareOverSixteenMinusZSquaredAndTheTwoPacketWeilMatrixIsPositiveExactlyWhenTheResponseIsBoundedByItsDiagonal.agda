{-# OPTIONS --cubical --safe --no-import-sorts #-}
------------------------------------------------------------------------
-- ग्राहक — the receiver.
--
-- The fixed two-packet autocorrelation receiver of handoff §46–47
-- ([S02]):  H(z) = 16 (1 − e^{−(z+4)/4})² / (z+4)²  and  G = H(z)H(−z).
-- Its finite identities:
--
--   १  the packet product: with  w = e^{z/4},  w̄ = e^{−z/4} (w w̄ = 1)
--      and  E = e^{−1},
--         (1 − E w̄)(1 − E w) ≡ 1 − E (w + w̄) + E²
--                              = 1 − 2 e^{−1} cosh(z/4) + e^{−2},
--      and  (z + 4)(4 − z) ≡ 16 − z²,  so
--         G(z) = 256 (1 − 2e^{−1}cosh(z/4) + e^{−2})² / (16 − z²)²;
--   २  the two-packet Weil matrix [[M₀, Z],[Z, M₀]] has
--         det ≡ (M₀ − Z)(M₀ + Z)   and   trace ≡ 2M₀,
--      and its quadratic form on (1, ±1) is 2(M₀ ± Z): positive
--      semidefiniteness is exactly |Z| ≤ M₀ (given M₀ > 0);
--   ३  the tail identity rearranged: Z = e^{t/2}G(½) − S − J_arch is
--      |S − e^{t/2}G(½) + J_arch| ≤ M₀, i.e. the closing inequality is
--      the same statement as |Z| ≤ M₀ (a sign identity).
------------------------------------------------------------------------
module Grahaka_TheFixedPacketIsTheProductOfItsTwoHalfPacketsSoItsSymbolIsARealSquareOverSixteenMinusZSquaredAndTheTwoPacketWeilMatrixIsPositiveExactlyWhenTheResponseIsBoundedByItsDiagonal where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Structure using (⟨_⟩)
open import Cubical.Data.Nat using (ℕ ; zero ; suc)
open import Cubical.Data.Sigma using (_×_ ; _,_)
open import Cubical.Algebra.CommRing
open import Cubical.Tactics.CommRingSolver.Reflection using (solve!)

private
  variable
    ℓ : Level

------------------------------------------------------------------------
module _ (R : CommRing ℓ) where
  open CommRingStr (snd R)

  private
    A = ⟨ R ⟩

  ι : ℕ → A
  ι zero    = 0r
  ι (suc n) = 1r + ι n

  ----------------------------------------------------------------
  -- १ · the packet product
  ----------------------------------------------------------------
  packet-product : (E w w̄ : A) → w · w̄ ≡ 1r
    → (1r + (- (E · w̄))) · (1r + (- (E · w))) ≡ (1r + (- (E · (w + w̄)))) + E · E
  packet-product E w w̄ h = shape E w w̄ ∙ cong (λ u → (1r + (- (E · (w + w̄)))) + (E · E) · u) h ∙ cong ((1r + (- (E · (w + w̄)))) +_) (·IdR (E · E))
    where
      shape : (E w w̄ : A) → (1r + (- (E · w̄))) · (1r + (- (E · w))) ≡ (1r + (- (E · (w + w̄)))) + (E · E) · (w · w̄)
      shape E w w̄ = solve! R

  denominator : (z : A) → (z + ι 4) · (ι 4 + (- z)) ≡ ι 16 + (- (z · z))
  denominator z = shape z
    where
      shape : (z : A) → (z + (1r + (1r + (1r + (1r + 0r))))) · ((1r + (1r + (1r + (1r + 0r)))) + (- z)) ≡ (1r + (1r + (1r + (1r + (1r + (1r + (1r + (1r + (1r + (1r + (1r + (1r + (1r + (1r + (1r + (1r + 0r)))))))))))))))) + (- (z · z))
      shape z = solve! R

  -- the squared symbol assembles:  H(z)H(−z) = 256·(product)²/((z+4)(4−z))²
  symbol-assembles : (E w w̄ z : A) → w · w̄ ≡ 1r
    → let p = (1r + (- (E · w̄))) · (1r + (- (E · w))) ; c = (1r + (- (E · (w + w̄)))) + E · E in
      (ι 16 · (p · p)) · ((z + ι 4) · (ι 4 + (- z))) ≡ (ι 16 · (c · c)) · (ι 16 + (- (z · z)))
  symbol-assembles E w w̄ z h = cong₂ (λ u v → (ι 16 · (u · u)) · v) (packet-product E w w̄ h) (denominator z)

  ----------------------------------------------------------------
  -- २ · the two-packet Weil matrix
  ----------------------------------------------------------------
  weil-determinant : (M₀ Z : A) → M₀ · M₀ + (- (Z · Z)) ≡ (M₀ + (- Z)) · (M₀ + Z)
  weil-determinant M₀ Z = solve! R

  weil-trace : (M₀ : A) → M₀ + M₀ ≡ ι 2 · M₀
  weil-trace M₀ = shape M₀
    where shape : (M₀ : A) → M₀ + M₀ ≡ (1r + (1r + 0r)) · M₀
          shape M₀ = solve! R

  -- the quadratic form  (x y) [[M₀,Z],[Z,M₀]] (x y)ᵀ  on (1, 1) and (1, −1)
  weil-form : (M₀ Z x y : A) → A
  weil-form M₀ Z x y = (x · (M₀ · x + Z · y)) + (y · (Z · x + M₀ · y))

  weil-form-on-sum : (M₀ Z : A) → weil-form M₀ Z 1r 1r ≡ ι 2 · (M₀ + Z)
  weil-form-on-sum M₀ Z = shape M₀ Z
    where shape : (M₀ Z : A) → (1r · (M₀ · 1r + Z · 1r)) + (1r · (Z · 1r + M₀ · 1r)) ≡ (1r + (1r + 0r)) · (M₀ + Z)
          shape M₀ Z = solve! R

  weil-form-on-difference : (M₀ Z : A) → weil-form M₀ Z 1r (- 1r) ≡ ι 2 · (M₀ + (- Z))
  weil-form-on-difference M₀ Z = shape M₀ Z
    where shape : (M₀ Z : A) → (1r · (M₀ · 1r + Z · (- 1r))) + ((- 1r) · (Z · 1r + M₀ · (- 1r))) ≡ (1r + (1r + 0r)) · (M₀ + (- Z))
          shape M₀ Z = solve! R

  -- the form is a sum of the two diagonal readings:  2·form(x,y) = (M₀+Z)(x+y)² + (M₀−Z)(x−y)²
  weil-form-diagonalizes : (M₀ Z x y : A)
    → ι 2 · weil-form M₀ Z x y ≡ (M₀ + Z) · ((x + y) · (x + y)) + (M₀ + (- Z)) · ((x + (- y)) · (x + (- y)))
  weil-form-diagonalizes M₀ Z x y = shape M₀ Z x y
    where shape : (M₀ Z x y : A) → (1r + (1r + 0r)) · ((x · (M₀ · x + Z · y)) + (y · (Z · x + M₀ · y)))
                                    ≡ (M₀ + Z) · ((x + y) · (x + y)) + (M₀ + (- Z)) · ((x + (- y)) · (x + (- y)))
          shape M₀ Z x y = solve! R

  ----------------------------------------------------------------
  -- ३ · the tail identity is the closing inequality's argument
  ----------------------------------------------------------------
  closing-argument : (L S J : A) → let Z = (L + (- S)) + (- J) in (S + (- L)) + J ≡ - Z
  closing-argument L S J = solve! R
