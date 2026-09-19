{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- PrimeCofactorCoprime
--
-- The third and last of the pieces `PFreePart` named:
--
--     prime-power-âˆ-coprime :
--       IsPrime p â’ Â (p âˆ m) â’ isGCD (p ^ a) m 1
--
-- â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”
-- CORRECTION TO `FrontierMember` Â§7
--
-- That section, written one commit ago, said this piece "is the only
-- one of the three that needs Euclid rather than structure".  It is
-- not.  It needs no Euclid at all, and the reason is visible in the
-- definition this lane already uses:
--
--     IsPrime p = (1 < p) — ((d : â•) â’ d âˆ p â’ (d â‰¡ 1) âŠ (d â‰¡ p))
--
-- A common divisor `d` of `p` and `m` is therefore `1` or `p`.  If it
-- were `p` then `p âˆ m`, which is the hypothesis' negation.  So `d â‰¡ 1`.
-- Three lines, and the non-divisibility hypothesis discharges the bad
-- branch by itself â” it does the work that `DistinctPrimesAreCoprime`
-- needed a SECOND primality for.  The template there is strictly
-- harder than the statement here, which is what made the estimate
-- wrong in the direction of pessimism.
--
-- The rule this thread earned was "no estimates".  The estimate was
-- offered anyway, inside a sentence explaining what remained, and it
-- was wrong for the fourth time.  Recorded rather than edited.
--
-- â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”
-- THE LIFT TO POWERS IS PURE REUSE
--
-- `CoprimePowersN.posPow`, `isGCDâ’Bez`, `Bezâ’isGCD` and
-- `CoprimePowers.bez-pow` are already here and already checked.  Only
-- the LEFT argument is raised, so the route is bez-sym / bez-pow /
-- bez-sym rather than `coprime-powers`, which raises both.
--
-- CHECKED: Agda 2.6.3, cubical v0.5 â” the container, not the repository
-- pin.  No postulates, no holes.
------------------------------------------------------------------------

module PrimeCofactorCoprime where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat
open import Cubical.Data.Nat.Divisibility using (_âˆ£_ ; âˆ£-oneË¡ ; âˆ£-refl)
open import Cubical.Data.Nat.GCD using (isGCD ; isCD)
open import Cubical.Data.Int using (â„¤ ; pos)
open import Cubical.Data.Sigma
open import Cubical.Data.Sum using (_âŠŽ_ ; inl ; inr)
open import Cubical.Data.Empty as Empty using (âŠ¥)
open import Cubical.Relation.Nullary using (Â¬_)
open import Cubical.Algebra.CommRing.Instances.Int using (â„¤CommRing)

open import WalkJumps using (IsPrime)
open import CoprimePowers using (module Bezout)
open import CoprimePowersN using (posPow ; isGCDâ†’Bez ; Bezâ†’isGCD)

open Bezout â„¤CommRing using (Bez ; pow ; bez-sym ; bez-pow)

------------------------------------------------------------------------
-- 1.  A prime is coprime to anything it does not divide
------------------------------------------------------------------------

prime-âˆ¤-coprime : (p m : â„•) â†’ IsPrime p â†’ Â¬ (p âˆ£ m) â†’ isGCD p m 1
prime-âˆ¤-coprime p m pp pâˆ¤m = (âˆ£-oneË¡ p , âˆ£-oneË¡ m) , divides
  where
  divides : (d : â„•) â†’ isCD p m d â†’ d âˆ£ 1
  divides d (dâˆ£p , dâˆ£m) = go (pp .snd d dâˆ£p)
    where
    go : (d â‰¡ 1) âŠŽ (d â‰¡ p) â†’ d âˆ£ 1
    go (inl dâ‰¡1) = âˆ£-refl dâ‰¡1
    go (inr dâ‰¡p) = Empty.rec (pâˆ¤m (subst (_âˆ£ m) dâ‰¡p dâˆ£m))

------------------------------------------------------------------------
-- 2.  And so is every power of it
------------------------------------------------------------------------

prime-power-âˆ¤-coprime :
  (p m a : â„•) â†’ IsPrime p â†’ Â¬ (p âˆ£ m) â†’ isGCD (p ^ a) m 1
prime-power-âˆ¤-coprime p m a pp pâˆ¤m =
  Bezâ†’isGCD (p ^ a) m
    (subst (Î» z â†’ Bez z (pos m)) (sym (posPow p a)) lifted)
  where
  base : Bez (pos p) (pos m)
  base = isGCDâ†’Bez p m (prime-âˆ¤-coprime p m pp pâˆ¤m)

  -- only the left argument is raised, so: swap, raise, swap back
  lifted : Bez (pow (pos p) a) (pos m)
  lifted = bez-sym {a = pos m} {b = pow (pos p) a}
             (bez-pow {a = pos m} {b = pos p}
               (bez-sym {a = pos p} {b = pos m} base) a)

------------------------------------------------------------------------
-- 3.  All three pieces are now closed.
--
--   ExponentBound          a â‰ logOf p k   when p^a âˆ n â‰ k
--                          (and `logOf` acquired a specification, which
--                          it had never had)
--   FrontierMember         (p , logOf p k) âˆˆ frontierList k for p prime,
--                          p â‰ k
--   here                   isGCD (p ^ a) m' 1  from  Â (p âˆ m')
--
-- What they were named for is `FrontierDivides` Â§2's hard half â” that
-- every m â‰ k divides `prodOf (frontierList k)`.  The pieces exist; the
-- assembly does not yet, and it needs two more things that are not in
-- this list: that an entry divides the product of the list it is in,
-- and a strong induction peeling m by `PFreePart`.
--
-- Those are named, not estimated.
------------------------------------------------------------------------
