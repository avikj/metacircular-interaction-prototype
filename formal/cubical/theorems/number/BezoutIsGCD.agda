{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- BezoutIsGCD
--
-- `CoprimePowers` closes the composition law for B©zout certificates and
-- names what is left: the bridge from a certificate to `isGCD _ _ 1`,
-- which is what `CRTChain.Coprimes` consumes.  Here is the bridge.
--
-- â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”
-- THE STATEMENT
--
-- Over â•, cleared of subtraction â” which is how the kuaka states its
-- own output, as a pair of multipliers with a unit remainder:
--
--     BezN a b  =  Î x, Î y,  aÂx â‰¡ bÂy + 1
--
--     bezNâ’isGCD :  BezN a b â’ isGCD a b 1
--
-- A common divisor `d` of `a` and `b` divides `aÂx` and `bÂy`, so it
-- divides their difference â” and in â•, where there is no difference to
-- take, the argument goes through the witnesses exactly as
-- `SuccessorIsNotTropical.cd-consecutive` does: `uÂd â‰¡ vÂd + 1` forces
-- `v < u`, and then `(suc k)Âd â‰¡ 1` by cancellation.
--
-- â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”
-- WHAT THIS COMPLETES
--
--   `CoprimePowers`  coprime bases âŸ coprime powers, certificates composing
--   here             a certificate âŸ `isGCD _ _ 1`
--   `CRTChain`       `isGCD` data âŸ the residue equivalence, any frontier
--
-- so the chain from ryabhaa's multipliers to the walk's residue count
-- is now unbroken except for one arithmetical fact, stated below.
--
-- STILL OPEN, and it is now the only gap: that distinct primes are
-- coprime, i.e. that a certificate EXISTS for `p, q`.  Nothing above
-- produces one; the walk's concrete frontiers compute gcds instead
-- (`CRTChain.walk8-coprimes`), and that is enough for any named frontier
-- and not enough for all of them.
--
-- CHECKED: Agda 2.6.3, cubical v0.5 â” the container, not the repository
-- pin.  No postulates, no holes.
------------------------------------------------------------------------

module BezoutIsGCD where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat
open import Cubical.Data.Nat.Order
open import Cubical.Data.Nat.Divisibility using (_âˆ£_ ; âˆ£-untrunc ; âˆ£-oneË¡)
open import Cubical.Data.Nat.GCD using (isGCD ; isCD)
open import Cubical.Data.Sigma
open import Cubical.Data.Sum using (_âŠŽ_ ; inl ; inr)
open import Cubical.Data.Empty as Empty using (âŠ¥)
open import Cubical.HITs.PropositionalTruncation using (âˆ£_âˆ£â‚)
open import Cubical.Tactics.NatSolver.Reflection using (solveâ„•!)

------------------------------------------------------------------------
-- 1.  The kuaka's output, cleared of subtraction
------------------------------------------------------------------------

BezN : â„• â†’ â„• â†’ Type
BezN a b = Î£[ x âˆˆ â„• ] Î£[ y âˆˆ â„• ] (a Â· x â‰¡ b Â· y + 1)

------------------------------------------------------------------------
-- 2.  The one arithmetic step: uÂd â‰¡ vÂd + 1 forces d to be a unit
------------------------------------------------------------------------

private
  shuffle : (Î± d x : â„•) â†’ (Î± Â· d) Â· x â‰¡ (Î± Â· x) Â· d
  shuffle Î± d x = solveâ„•!

unit-from-step : (u v d : â„•) â†’ u Â· d â‰¡ v Â· d + 1 â†’ d âˆ£ 1
unit-from-step u v d p = go (splitâ„•-â‰¤ u v)
  where
  vd<ud : (v Â· d) < (u Â· d)
  vd<ud = subst (suc (v Â· d) â‰¤_) (sym (+-comm (v Â· d) 1) âˆ™ sym p) â‰¤-refl

  go : ((u â‰¤ v) âŠŽ (v < u)) â†’ d âˆ£ 1
  go (inl uâ‰¤v) = Empty.rec (Â¬m<m (â‰¤<-trans (â‰¤-Â·k uâ‰¤v) vd<ud))
  go (inr v<u) = âˆ£ suc k , unit âˆ£â‚
    where
    k : â„•
    k = v<u .fst

    pk : k + suc v â‰¡ u
    pk = v<u .snd

    step2 : (k Â· d) + ((suc v) Â· d) â‰¡ (v Â· d) + 1
    step2 = Â·-distribÊ³ k (suc v) d âˆ™ cong (_Â· d) pk âˆ™ p

    step3 : ((k Â· d) + d) + (v Â· d) â‰¡ 1 + (v Â· d)
    step3 = sym (+-assoc (k Â· d) d (v Â· d)) âˆ™ step2 âˆ™ +-comm (v Â· d) 1

    step4 : (k Â· d) + d â‰¡ 1
    step4 = inj-+m step3

    unit : (suc k) Â· d â‰¡ 1
    unit = +-comm d (k Â· d) âˆ™ step4

------------------------------------------------------------------------
-- 3.  THE BRIDGE
------------------------------------------------------------------------

bezNâ†’isGCD : (a b : â„•) â†’ BezN a b â†’ isGCD a b 1
bezNâ†’isGCD a b (x , y , p) =
  (âˆ£-oneË¡ a , âˆ£-oneË¡ b) , divides
  where
  divides : (d : â„•) â†’ isCD a b d â†’ d âˆ£ 1
  divides d (dâˆ£a , dâˆ£b) = go (âˆ£-untrunc dâˆ£a) (âˆ£-untrunc dâˆ£b)
    where
    go : Î£[ Î± âˆˆ â„• ] (Î± Â· d â‰¡ a) â†’ Î£[ Î² âˆˆ â„• ] (Î² Â· d â‰¡ b) â†’ d âˆ£ 1
    go (Î± , pa) (Î² , pb) =
      unit-from-step (Î± Â· x) (Î² Â· y) d
        ( sym (shuffle Î± d x)
        âˆ™ cong (_Â· x) pa
        âˆ™ p
        âˆ™ cong (Î» z â†’ (z Â· y) + 1) (sym pb)
        âˆ™ cong (_+ 1) (shuffle Î² d y) )

------------------------------------------------------------------------
-- 4.  It runs: 8 and 9, from the certificate the kuaka would produce.
--
--   8Â8 = 64 = 9Â7 + 1.
------------------------------------------------------------------------

bez-8-9 : BezN 8 9
bez-8-9 = 8 , 7 , refl

gcd-8-9 : isGCD 8 9 1
gcd-8-9 = bezNâ†’isGCD 8 9 bez-8-9

------------------------------------------------------------------------
-- 5.  The chain, now unbroken except at one place.
--
--   `Kuttaka.bezout`     ryabhaa's procedure returns the multipliers
--   `CoprimePowers`      certificates compose: coprime bases âŸ coprime powers
--   here                 a certificate is an `isGCD _ _ 1`
--   `CRTChain`           `isGCD` data âŸ the residue equivalence
--   `LosslessLowerBound` and the count is a minimum
--
-- The one remaining gap is the EXISTENCE of a certificate for two
-- distinct primes.  Everything downstream of it is done.
------------------------------------------------------------------------
