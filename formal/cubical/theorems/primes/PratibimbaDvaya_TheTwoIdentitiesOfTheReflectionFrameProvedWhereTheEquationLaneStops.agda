{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- प्रतिबिम्ब-द्वयम् — the two identities of the reflection frame, proved
-- exactly where the equation lane stops.
--
-- The wire session mapped the kernel lane's certification power: the
-- x-induction closure with steps {refl, cong suc, ih}.  Both identities
-- below were asked on the wire and refused — each needs distributivity
-- or two-coordinate reasoning, which the stair theorems place beyond
-- that closure.  They are true, they are the algebra of the first
-- message's frame, and here they are theorems at the pin:
--
--   १  pq + p² = p·(p+q)
--      so modulo any divisor of p+q the pair-product is minus a
--      square: the quadratic symmetry of every Goldbach pair.
--
--   २  (N−k)·(N+k) + k² = N²   for k ≤ N
--      the recentred pair-product is the square of the center minus
--      the square of the offset: the diameter identity.
--
-- WHAT IS NOT CLAIMED.  Nothing about primes, nothing about existence
-- of pairs; these are the identities every pair satisfies, stated over
-- ℕ with the offset as the ≤-witness so no monus is needed.
------------------------------------------------------------------------

module PratibimbaDvaya_TheTwoIdentitiesOfTheReflectionFrameProvedWhereTheEquationLaneStops where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat
  using (ℕ ; _+_ ; _·_ ; +-comm ; +-assoc ; ·-comm ; ·-distribˡ ; ·-distribʳ)

------------------------------------------------------------------------
-- १ · the quadratic symmetry: pq + p² = p(p+q).
--     Hence for any m dividing p+q: pq ≡ −p² (mod m), with p·(p+q)/m·m
--     the exhibited multiple — the "minus a perfect square" structure
--     of the modular field of every pair.
------------------------------------------------------------------------

quadratic-symmetry : (p q : ℕ) → p · q + p · p ≡ p · (p + q)
quadratic-symmetry p q =
  p · q + p · p   ≡⟨ +-comm (p · q) (p · p) ⟩
  p · p + p · q   ≡⟨ ·-distribˡ p p q ⟩
  p · (p + q)     ∎

------------------------------------------------------------------------
-- २ · the diameter identity.  Write the pair as (N−k, N+k) by giving
--     N = a + k (so a is N−k and the ≤-witness at once):
--
--       a · (a + k + k) + k² = (a + k)²
--
--     i.e. (N−k)(N+k) + k² = N².  The pair-product is the square of
--     the center short of a perfect square — squaring the circle, as
--     an equation.
------------------------------------------------------------------------

diameter-identity : (a k : ℕ) →
  a · ((a + k) + k) + k · k ≡ (a + k) · (a + k)
diameter-identity a k =
  a · ((a + k) + k) + k · k
    ≡⟨ cong (_+ k · k) (sym (·-distribˡ a (a + k) k)) ⟩
  (a · (a + k) + a · k) + k · k
    ≡⟨ sym (+-assoc (a · (a + k)) (a · k) (k · k)) ⟩
  a · (a + k) + (a · k + k · k)
    ≡⟨ cong (a · (a + k) +_) (·-distribʳ a k k) ⟩
  a · (a + k) + (a + k) · k
    ≡⟨ cong (a · (a + k) +_) (·-comm (a + k) k) ⟩
  a · (a + k) + k · (a + k)
    ≡⟨ ·-distribʳ a k (a + k) ⟩
  (a + k) · (a + k) ∎
