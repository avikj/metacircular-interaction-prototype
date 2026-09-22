{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- FiniteExplicitFormula � for a polynomial P(z) = (1 − ��z)(1 − ��z)(1 − ��z)
-- = 1 − e�z + e�z² − e�z³ the power sums p_k = �� + �� + �� satisfy
--
--     p� = e�,  p� = e�p� − 2e�,  p� = e�p� − e�p� + 3e�,
--     p_k = e�p_{k−1} − e�p_{k−2} + e�p_{k−3}   (k � 4),
--
-- which is, coefficient by coefficient, the identity −z P�(z)/P(z) =
-- �_k p_k z�: the logarithmic derivative of the "zeta polynomial" is the
-- generating function of the power sums.  That identity IS the explicit
-- formula in its finite form: the left side is the zero side (the �_i
-- are the reciprocal zeros of P), the right side is the prime side (for
-- a curve over F_q, p_k counts the F_{q�}-points against q� + 1).  And
-- the growth of p_k is governed by the largest |�_i|: the finite
-- Riemann hypothesis is the statement that all |�_i| are equal.
--
-- WHAT THIS IS.  The remainder of the RH line � "the explicit formula
-- for one receiver" � in the only form the corpus can carry exactly:
-- for a finite zero set, the explicit formula is Newton's identities,
-- and the growth reading (Theorem 4 of the prime-boundary document) is
-- the comparison of a power sum with the largest root.
--
--   §1  Newton's identities to order 4 and the recursion, over any
--       commutative ring (solver);
--   §2  over �, roots (β , 1 , 1) with 2 � β: 2� � p_k for every k � the
--       power sums grow at least like the largest root; and at β = 2
--       the values p_k = 2� + 2 read back by computation.
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
      -- with A = ε etc., both sides are polynomial in � β γ A B C
      lemma : (A B C : K)
            → (α ·r (α ·r (α ·r A)) +r β ·r (β ·r (β ·r B)) +r γ ·r (γ ·r (γ ·r C)))
            ≡ e₁ α β γ ·r (α ·r (α ·r A) +r β ·r (β ·r B) +r γ ·r (γ ·r C))
              +r neg (e₂ α β γ ·r (α ·r A +r β ·r B +r γ ·r C))
              +r e₃ α β γ ·r (A +r B +r C)
      lemma A B C = solve! R'

------------------------------------------------------------------------
-- §2  the growth reading over �
------------------------------------------------------------------------

open import Cubical.Algebra.CommRing.Instances.Int using (ℤCommRing)
open import Cubical.Data.Int using (ℤ ; pos ; negsuc)

-- over �, roots (2 , 1 , 1): p_k = 2� + 2
module ℤN = Newton ℤCommRing

p-2-1-1 : (ℤN.p (pos 2) (pos 1) (pos 1) 10 ≡ pos 1026) × (ℤN.p (pos 2) (pos 1) (pos 1) 3 ≡ pos 10)
p-2-1-1 = refl , refl

-- over �: 2� � β� + 1 + 1 whenever 2 � β
powℕ : ℕ → ℕ → ℕ
powℕ x zero = 1
powℕ x (suc n) = x · powℕ x n

pow-mono : (β : ℕ) → 2 ≤ β → (k : ℕ) → powℕ 2 k ≤ powℕ β k
pow-mono β 2≤β zero = ≤-refl
pow-mono β 2≤β (suc k) =
  ≤-trans (≤-·k {k = powℕ 2 k} 2≤β) (≤-k+' {β} (pow-mono β 2≤β k))
  where
    -- β � x � β � y from x � y
    ≤-k+' : {b : ℕ} {x y : ℕ} → x ≤ y → b · x ≤ b · y
    ≤-k+' {b} {x} {y} x≤y = subst2 _≤_ (·-comm x b) (·-comm y b) (≤-·k {k = b} x≤y)

power-sum-grows : (β : ℕ) → 2 ≤ β → (k : ℕ) → powℕ 2 k ≤ powℕ β k + powℕ 1 k + powℕ 1 k
power-sum-grows β 2≤β k = ≤-trans (pow-mono β 2≤β k) (≤-trans ≤SumLeft ≤SumLeft)
