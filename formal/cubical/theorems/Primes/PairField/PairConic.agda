{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- Primes.PairField.PairConic
--
-- One conic, two readings.  The identity
--
--   (w + r) · (w − r) = w² − r²
--
-- carries both Goldbach's question and Fermat's factorization method:
-- fix the sum 2w and ask which r make both legs prime (Goldbach's
-- reading); fix the product N and search for w with w² − N a square
-- (Fermat's reading).  The two problems are the same curve held by
-- different projections.
--
-- This module is the ℕ-with-order chart of that conic.  Over ℕ the
-- subtraction is truncated, so the identity needs the hypothesis r ≤ w
-- that makes it true; the mathematically honest primary statement is
-- the addition form conic⁺, from which the ∸ form is derived.
--
-- PairCoordinates proves the ring version of the same
-- algebra (splitNorm, over an arbitrary commutative ring).  This file
-- is deliberately NOT importing it: same conic, different carrier.
--
-- NOT claimed: any primality statement, any Goldbach statement.  Only
-- the conic and its two projections.
------------------------------------------------------------------------

module Primes.PairField.PairConic where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Sigma
open import Cubical.Data.Nat
open import Cubical.Data.Nat.Order
open import Cubical.Tactics.NatSolver.Reflection

------------------------------------------------------------------------
-- §1  The conic, in its honest (addition) form
------------------------------------------------------------------------

private
  -- The polynomial core, with the hypothesis already substituted:
  -- writing w = k + r, the identity is pure semiring algebra.
  key : (k r : ℕ) → ((k + r) + r) · k + r · r ≡ (k + r) · (k + r)
  key k r = solveℕ!

-- Truncated subtraction under the hypothesis: w ∸ r recovers the
-- witness k of r ≤ w.
private
  ∸-witness : (w r k : ℕ) → k + r ≡ w → w ∸ r ≡ k
  ∸-witness w r k p = cong (_∸ r) (sym p) ∙ +∸ k r

-- The primary statement: an addition-form identity, no truncation pain.
conic⁺ : (w r : ℕ) → r ≤ w → (w + r) · (w ∸ r) + r · r ≡ w · w
conic⁺ w r (k , p) =
  cong₂ (λ a b → (a + r) · b + r · r) (sym p) (∸-witness w r k p)
  ∙ key k r
  ∙ cong (λ a → a · a) p

-- The ∸ form, derived: a + c ≡ b forces a ≡ b ∸ c in ℕ.
conic : (w r : ℕ) → r ≤ w → (w + r) · (w ∸ r) ≡ w · w ∸ r · r
conic w r r≤w =
  sym (+∸ ((w + r) · (w ∸ r)) (r · r))
  ∙ cong (_∸ (r · r)) (conic⁺ w r r≤w)

------------------------------------------------------------------------
-- §2  The two readings, as structure
------------------------------------------------------------------------

-- A point of the conic's ℕ chart: centre w, half-gap r, with the order
-- hypothesis that keeps the subtraction honest.
Pair : Type₀
Pair = Σ ℕ (λ w → Σ ℕ (λ r → r ≤ w))

-- Sum reading (Goldbach's projection): the fixed even sum 2w.
π₊ : Pair → ℕ
π₊ (w , r , _) = w + w

-- Product reading (Fermat's projection): the factored product.
πₓ : Pair → ℕ
πₓ (w , r , _) = (w + r) · (w ∸ r)

------------------------------------------------------------------------
-- §3  One concrete point: w = 8, r = 3
------------------------------------------------------------------------

point : Pair
point = 8 , 3 , (5 , refl)

-- Held by the sum projection: 16.
π₊point : π₊ point ≡ 16
π₊point = refl

-- Held by the product projection: 55, arriving factored as 5 · 11.
πₓpoint : πₓ point ≡ 55
πₓpoint = refl

πₓpoint-factored : πₓ point ≡ 5 · 11
πₓpoint-factored = refl
