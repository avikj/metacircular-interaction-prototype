{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- DistinctPrimesAreCoprime
--
-- The last gap in the chain `BezoutIsGCD` Â§5 names.
--
--   `Kuttaka.bezout`     ryabhaa's procedure returns the multipliers
--   `CoprimePowers`      certificates compose: coprime bases âŸ coprime powers
--   `BezoutIsGCD`        a certificate is an `isGCD _ _ 1`
--   `CRTChain`           `isGCD` data âŸ the residue equivalence
--   HERE                 distinct primes are coprime
--
-- â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”
-- THE STATEMENT
--
--     distinct-primes-coprime :
--       IsPrime p â’ IsPrime q â’ Â (p â‰¡ q) â’ isGCD p q 1
--
-- with `IsPrime` the definition already in this lane
-- (`WalkJumps.IsPrime`: `1 < p` and every divisor is `1` or `p`).
--
-- The argument is the schoolbook one and it is three lines: a common
-- divisor `d` of `p` and `q` is `1` or `p` by primality of `p`; if it is
-- `p` then `p âˆ q`, so `p` is `1` or `q` by primality of `q`; `p â‰  1`
-- because `1 < p`, and `p â‰  q` by hypothesis.  So `d â‰¡ 1`.
--
-- â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”
-- WHAT IS NOW COMPLETE
--
-- Combining with `CoprimePowers` and `BezoutIsGCD`, the walk's residue
-- count is available at EVERY frontier and not only at named ones, given
-- the primality of the installed bases â” which `WalkPrimePowers` supplies
-- and `PrimalityDecision.decIsPrime` decides.
--
-- What made this the last gap rather than the first is worth recording:
-- every earlier step was a certificate composing, and this one is the
-- only place where a case analysis on a PREDICATE was unavoidable.  The
-- kuaka's habit of returning a construction carried the chain as far as
-- it could go, and stopped exactly where primality enters.
--
-- CHECKED: Agda 2.6.3, cubical v0.5 â” the container, not the repository
-- pin.  No postulates, no holes.
------------------------------------------------------------------------

module DistinctPrimesAreCoprime where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat
open import Cubical.Data.Nat.Order
open import Cubical.Data.Nat.Divisibility using (_âˆ£_ ; âˆ£-oneË¡ ; âˆ£-refl)
open import Cubical.Data.Nat.GCD using (isGCD ; isCD)
open import Cubical.Data.Sigma
open import Cubical.Data.Sum using (_âŠŽ_ ; inl ; inr)
open import Cubical.Data.Empty as Empty using (âŠ¥)
open import Cubical.Relation.Nullary using (Â¬_)

open import WalkJumps using (IsPrime)

------------------------------------------------------------------------
-- 1.  A prime is not 1
------------------------------------------------------------------------

prime-â‰¢1 : (p : â„•) â†’ IsPrime p â†’ Â¬ (p â‰¡ 1)
prime-â‰¢1 p pr pâ‰¡1 = Â¬m<m (subst (1 <_) pâ‰¡1 (pr .fst))

------------------------------------------------------------------------
-- 2.  THE STATEMENT
------------------------------------------------------------------------

distinct-primes-coprime :
  (p q : â„•) â†’ IsPrime p â†’ IsPrime q â†’ Â¬ (p â‰¡ q) â†’ isGCD p q 1
distinct-primes-coprime p q pp qq pâ‰¢q =
  (âˆ£-oneË¡ p , âˆ£-oneË¡ q) , divides
  where
  divides : (d : â„•) â†’ isCD p q d â†’ d âˆ£ 1
  divides d (dâˆ£p , dâˆ£q) = go (pp .snd d dâˆ£p)
    where
    go : (d â‰¡ 1) âŠŽ (d â‰¡ p) â†’ d âˆ£ 1
    go (inl dâ‰¡1) = âˆ£-refl dâ‰¡1
    go (inr dâ‰¡p) = Empty.rec (bad (qq .snd p (subst (_âˆ£ q) dâ‰¡p dâˆ£q)))
      where
      bad : (p â‰¡ 1) âŠŽ (p â‰¡ q) â†’ âŠ¥
      bad (inl pâ‰¡1) = prime-â‰¢1 p pp pâ‰¡1
      bad (inr pâ‰¡q) = pâ‰¢q pâ‰¡q

------------------------------------------------------------------------
-- 3.  It runs, on the walk's own bases.
------------------------------------------------------------------------

open import PrimalityDecision using (decIsPrime)
open import Cubical.Relation.Nullary using (Dec ; yes ; no)
open import Cubical.Data.Bool using (Bool ; true ; false ; falseâ‰¢true)

-- read a decision off, with the impossible branch discharged by the
-- computation rather than by a fabricated witness
isYes : {A : Type} â†’ Dec A â†’ Bool
isYes (yes _) = true
isYes (no  _) = false

fromDec : {A : Type} (d : Dec A) â†’ isYes d â‰¡ true â†’ A
fromDec (yes a) _ = a
fromDec (no  _) p = Empty.rec (falseâ‰¢true p)

prime-2 : IsPrime 2
prime-2 = fromDec (decIsPrime 2) refl

prime-3 : IsPrime 3
prime-3 = fromDec (decIsPrime 3) refl

2â‰¢3 : Â¬ (2 â‰¡ 3)
2â‰¢3 p = znots (injSuc (injSuc p))

coprime-2-3 : isGCD 2 3 1
coprime-2-3 = distinct-primes-coprime 2 3 prime-2 prime-3 2â‰¢3

------------------------------------------------------------------------
-- 4.  The chain is closed.
--
-- `distinct-primes-coprime` + `CoprimePowers.coprime-powers` +
-- `BezoutIsGCD.bezNâ’isGCD` + `CRTChain.crtChain` is the walk's residue
-- count from primality alone, with `LosslessLowerBound` making the count
-- a minimum and `OptimalObservation` making "optimal" a definition rather
-- than a word.
--
-- Five modules, one chain, and the only case analysis in it is here.
------------------------------------------------------------------------
