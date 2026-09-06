{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- FiniteExplicitFormula — for a polynomial P(z) = (1 − α₁z)(1 − α₂z)(1 − α₃z)
-- = 1 − e₁z + e₂z² − e₃z³ the power sums p_k = α₁ᵏ + α₂ᵏ + α₃ᵏ satisfy
--
--     p₁ = e₁,  p₂ = e₁p₁ − 2e₂,  p₃ = e₁p₂ − e₂p₁ + 3e₃,
--     p_k = e₁p_{k−1} − e₂p_{k−2} + e₃p_{k−3}   (k ≥ 4),
--
-- which is, coefficient by coefficient, the identity −z P′(z)/P(z) =
-- Σ_k p_k zᵏ: the logarithmic derivative of the "zeta polynomial" is the
-- generating function of the power sums.  That identity IS the explicit
-- formula in its finite form: the left side is the zero side (the α_i
-- are the reciprocal zeros of P), the right side is the prime side (for
-- a curve over F_q, p_k counts the F_{qᵏ}-points against qᵏ + 1).  And
-- the growth of p_k is governed by the largest |α_i|: the finite
-- Riemann hypothesis is the statement that all |α_i| are equal.
--
-- WHAT THIS IS.  The remainder of the RH line — "the explicit formula
-- for one receiver" — in the only form the corpus can carry exactly:
-- for a finite zero set, the explicit formula is Newton's identities,
-- and the growth reading (Theorem 4 of the prime-boundary document) is
-- the comparison of a power sum with the largest root.
--
--   §1  Newton's identities to order 4 and the recursion, over any
--       commutative ring (solver);
--   §2  over ℕ, roots (β , 1 , 1) with 2 ≤ β: 2ᵏ ≤ p_k for every k — the
--       power sums grow at least like the largest root; and at β = 2
--       the values p_k = 2ᵏ + 2 read back by computation.
--
-- SYĀT — THE CLAIM, EXACTLY.  Ring identities in three roots and an ℕ
-- inequality.  The infinite zero set of ζ, the limit, and the
-- Laplace-pole argument are NOT here; this is the finite core of them.
------------------------------------------------------------------------

module FiniteExplicitFormula_NewtonsIdentitiesArePowerSumsOfTheRootsEqualToCoefficientRecursionsAndTheGrowthOfThePowerSumsIsTheLargestRoot where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Sigma using (_,_ ; fst ; snd ; _×_)
open import Cubical.Data.Nat using (ℕ ; zero ; suc ; _+_ ; _·_ ; +-comm ; ·-comm)
open import Cubical.Data.Nat.Order
open import Cubical.Algebra.CommRing
open import Cubical.Tactics.CommRingSolver

module Newton {ℓ : Level} (R' : CommRing ℓ) where

  open CommRingStr (R' .snd) renaming (_+_ to _+r_ ; _·_ to _·r_ ; -_ to neg)

  private
    K : Type ℓ
    K = fst R'

  -- elementary symmetric functions of three roots
  e₁ e₂ e₃ : (α β γ : K) → K
  e₁ α β γ = α +r β +r γ
  e₂ α β γ = α ·r β +r β ·r γ +r γ ·r α
  e₃ α β γ = α ·r β ·r γ

  -- power sums
  pow : K → ℕ → K
  pow x zero = 1r
  pow x (suc n) = x ·r pow x n

  p : (α β γ : K) → ℕ → K
  p α β γ k = pow α k +r pow β k +r pow γ k

  two three : K
  two = 1r +r 1r
  three = two +r 1r

  newton₁ : (α β γ : K) → p α β γ 1 ≡ e₁ α β γ
  newton₁ α β γ = solve! R'

  newton₂ : (α β γ : K) → p α β γ 2 ≡ e₁ α β γ ·r p α β γ 1 +r neg (two ·r e₂ α β γ)
  newton₂ α β γ = solve! R'

  newton₃ : (α β γ : K) → p α β γ 3 ≡ e₁ α β γ ·r p α β γ 2 +r neg (e₂ α β γ ·r p α β γ 1) +r three ·r e₃ α β γ
  newton₃ α β γ = solve! R'

  -- the recursion from order 4 on: the polynomial's own recurrence
  newton-rec : (α β γ : K) (k : ℕ)
             → p α β γ (suc (suc (suc k)))
             ≡ e₁ α β γ ·r p α β γ (suc (suc k)) +r neg (e₂ α β γ ·r p α β γ (suc k)) +r e₃ α β γ ·r p α β γ k
  newton-rec α β γ k = lemma (pow α k) (pow β k) (pow γ k)
    where
      -- with A = αᵏ etc., both sides are polynomial in α β γ A B C
      lemma : (A B C : K)
            → (α ·r (α ·r (α ·r A)) +r β ·r (β ·r (β ·r B)) +r γ ·r (γ ·r (γ ·r C)))
            ≡ e₁ α β γ ·r (α ·r (α ·r A) +r β ·r (β ·r B) +r γ ·r (γ ·r C))
              +r neg (e₂ α β γ ·r (α ·r A +r β ·r B +r γ ·r C))
              +r e₃ α β γ ·r (A +r B +r C)
      lemma A B C = solve! R'

------------------------------------------------------------------------
-- §2  the growth reading over ℕ
------------------------------------------------------------------------

open import Cubical.Algebra.CommRing.Instances.Int using (ℤCommRing)
open import Cubical.Data.Int using (ℤ ; pos ; negsuc)

-- over ℤ, roots (2 , 1 , 1): p_k = 2ᵏ + 2
module ℤN = Newton ℤCommRing

p-2-1-1 : (ℤN.p (pos 2) (pos 1) (pos 1) 10 ≡ pos 1026) × (ℤN.p (pos 2) (pos 1) (pos 1) 3 ≡ pos 10)
p-2-1-1 = refl , refl

-- over ℕ: 2ᵏ ≤ βᵏ + 1 + 1 whenever 2 ≤ β
powℕ : ℕ → ℕ → ℕ
powℕ x zero = 1
powℕ x (suc n) = x · powℕ x n

pow-mono : (β : ℕ) → 2 ≤ β → (k : ℕ) → powℕ 2 k ≤ powℕ β k
pow-mono β 2≤β zero = ≤-refl
pow-mono β 2≤β (suc k) =
  ≤-trans (≤-·k {k = powℕ 2 k} 2≤β) (≤-k+' {β} (pow-mono β 2≤β k))
  where
    -- β · x ≤ β · y from x ≤ y
    ≤-k+' : {b : ℕ} {x y : ℕ} → x ≤ y → b · x ≤ b · y
    ≤-k+' {b} {x} {y} x≤y = subst2 _≤_ (·-comm x b) (·-comm y b) (≤-·k {k = b} x≤y)

power-sum-grows : (β : ℕ) → 2 ≤ β → (k : ℕ) → powℕ 2 k ≤ powℕ β k + powℕ 1 k + powℕ 1 k
power-sum-grows β 2≤β k = ≤-trans (pow-mono β 2≤β k) (≤-trans ≤SumLeft ≤SumLeft)
