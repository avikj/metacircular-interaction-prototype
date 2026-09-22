{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- PrimeCofactorCoprime
--
-- The third and last of the pieces `PFreePart` named:
--
--     prime-power-∤-coprime :
--       IsPrime p → ¬ (p ∣ m) → isGCD (p ^ a) m 1
--
-- ────────────────────────────────────────────────────────────────────
-- NO EUCLID IS NEEDED
--
-- The reason is visible in the definition this lane already uses:
--
--     IsPrime p = (1 < p) × ((d : ℕ) → d ∣ p → (d ≡ 1) ⊎ (d ≡ p))
--
-- A common divisor `d` of `p` and `m` is therefore `1` or `p`.  If it
-- were `p` then `p ∣ m`, which is the hypothesis' negation.  So `d ≡ 1`.
-- Three lines, and the non-divisibility hypothesis discharges the bad
-- branch by itself — it does the work that `DistinctPrimesAreCoprime`
-- needed a SECOND primality for.
--
-- ────────────────────────────────────────────────────────────────────
-- THE LIFT TO POWERS IS PURE REUSE
--
-- `CoprimePowersN.posPow`, `isGCD→Bez`, `Bez→isGCD` and
-- `CoprimePowers.bez-pow` are already here and already checked.  Only
-- the LEFT argument is raised, so the route is bez-sym / bez-pow /
-- bez-sym rather than `coprime-powers`, which raises both.
------------------------------------------------------------------------

module PrimeCofactorCoprime where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat
open import Cubical.Data.Nat.Divisibility using (_∣_ ; ∣-oneˡ ; ∣-refl)
open import Cubical.Data.Nat.GCD using (isGCD ; isCD)
open import Cubical.Data.Int using (ℤ ; pos)
open import Cubical.Data.Sigma
open import Cubical.Data.Sum using (_⊎_ ; inl ; inr)
open import Cubical.Data.Empty as Empty using (⊥)
open import Cubical.Relation.Nullary using (¬_)
open import Cubical.Algebra.CommRing.Instances.Int using (ℤCommRing)

open import WalkJumps using (IsPrime)
open import CoprimePowers using (module Bezout)
open import CoprimePowersN using (posPow ; isGCD→Bez ; Bez→isGCD)

open Bezout ℤCommRing using (Bez ; pow ; bez-sym ; bez-pow)

------------------------------------------------------------------------
-- 1.  A prime is coprime to anything it does not divide
------------------------------------------------------------------------

prime-∤-coprime : (p m : ℕ) → IsPrime p → ¬ (p ∣ m) → isGCD p m 1
prime-∤-coprime p m pp p∤m = (∣-oneˡ p , ∣-oneˡ m) , divides
  where
  divides : (d : ℕ) → isCD p m d → d ∣ 1
  divides d (d∣p , d∣m) = go (pp .snd d d∣p)
    where
    go : (d ≡ 1) ⊎ (d ≡ p) → d ∣ 1
    go (inl d≡1) = ∣-refl d≡1
    go (inr d≡p) = Empty.rec (p∤m (subst (_∣ m) d≡p d∣m))

------------------------------------------------------------------------
-- 2.  And so is every power of it
------------------------------------------------------------------------

prime-power-∤-coprime :
  (p m a : ℕ) → IsPrime p → ¬ (p ∣ m) → isGCD (p ^ a) m 1
prime-power-∤-coprime p m a pp p∤m =
  Bez→isGCD (p ^ a) m
    (subst (λ z → Bez z (pos m)) (sym (posPow p a)) lifted)
  where
  base : Bez (pos p) (pos m)
  base = isGCD→Bez p m (prime-∤-coprime p m pp p∤m)

  -- only the left argument is raised, so: swap, raise, swap back
  lifted : Bez (pow (pos p) a) (pos m)
  lifted = bez-sym {a = pos m} {b = pow (pos p) a}
             (bez-pow {a = pos m} {b = pos p}
               (bez-sym {a = pos p} {b = pos m} base) a)

------------------------------------------------------------------------
-- 3.  The three pieces.
--
--   ExponentBound          a ≤ logOf p k   when p^a ∣ n ≤ k
--   FrontierMember         (p , logOf p k) ∈ frontierList k for p prime,
--                          p ≤ k
--   here                   isGCD (p ^ a) m' 1  from  ¬ (p ∣ m')
------------------------------------------------------------------------
