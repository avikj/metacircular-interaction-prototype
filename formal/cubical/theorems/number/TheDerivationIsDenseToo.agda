{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- TheDerivationIsDenseToo
--
-- A companion to `NumberIsExponentialInDerivation`: the derivation is dense.
--
-- â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”
-- THE BOUND, AND WHAT IT DOES NOT COVER
--
-- That module proves `suc e â‰ b ^ e` â” the numeric factor is exponential
-- in the exponent it encodes.  A coordinatewise bound does not by itself
-- account for the gap between what the walk carries and what
-- distinguishing k inputs requires, because it says nothing about HOW
-- MANY COORDINATES there are.
--
-- And there are many.  cap(k) = lcm(1..k) is divisible by every prime
-- p â‰ k, so its derivation has a nonzero entry at every such p:
--
--     the walk's derivation is DENSE.
--
-- `cap-is-dense` below checks this for the walk's frontier-8 state
-- against the basis 2,3,5,7 â” every coordinate nonzero, support 4 out of
-- 4.  So the derivation is not a compact object either.  Its coordinate
-- count grows with the number of primes below the frontier, and the
-- exponential saving `suc e â‰ b ^ e` buys nothing across coordinates,
-- only within one.
--
-- â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”
-- THE VERDICT
--
--   the numeric encoding is A mechanism of the walk's size.  Whether it
--   is THE mechanism depends on comparing a sum of exponents against a
--   count of primes, which is exactly the Chebyshev-type input the
--   other module does not use.
--
-- The estimate is unavailable in this lane, and quoting it would be the
-- error CLAUDE.md forbids.
------------------------------------------------------------------------

module TheDerivationIsDenseToo where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (â„• ; zero ; suc ; _+_ ; snotz)
open import Cubical.Data.Sigma
open import Cubical.Data.Unit using (Unit ; tt)
open import Cubical.Data.List using (List ; [] ; _âˆ·_ ; length)
open import Cubical.Relation.Nullary using (Â¬_)

open import SumProductTorus using (Exp ; val ; primes4)

------------------------------------------------------------------------
-- 1.  Density and support
------------------------------------------------------------------------

Dense : (bs : List â„•) â†’ Exp bs â†’ Type
Dense []       _        = Unit
Dense (b âˆ· bs) (x , xs) = (Â¬ (x â‰¡ 0)) Ã— Dense bs xs

support : (bs : List â„•) â†’ Exp bs â†’ â„•
support []       _        = 0
support (b âˆ· bs) (x , xs) = step x + support bs xs
  where
  step : â„• â†’ â„•
  step zero    = 0
  step (suc _) = 1

------------------------------------------------------------------------
-- 2.  A dense derivation has full support: one entry per basis element
------------------------------------------------------------------------

denseâ†’full : (bs : List â„•) (u : Exp bs) â†’ Dense bs u â†’ support bs u â‰¡ length bs
denseâ†’full []       _        _        = refl
denseâ†’full (b âˆ· bs) (zero  , xs) (nz , ds) = Empty.rec (nz refl)
  where open import Cubical.Data.Empty as Empty using (âŠ¥)
denseâ†’full (b âˆ· bs) (suc x , xs) (nz , ds) = cong suc (denseâ†’full bs xs ds)

------------------------------------------------------------------------
-- 3.  The walk's state is dense.
--
-- cap 8 = 840 = 2Â³Â3Â5Â7 â” every prime â‰ 8 appears, because every prime
-- p â‰ k divides lcm(1..k) for the trivial reason that p is one of the
-- numbers being joined.
------------------------------------------------------------------------

cap8 : Exp primes4
cap8 = 3 , 1 , 1 , 1 , tt

cap8-is-840 : val primes4 cap8 â‰¡ 840
cap8-is-840 = refl

cap-is-dense : Dense primes4 cap8
cap-is-dense = snotz , snotz , snotz , snotz , tt

cap-support-is-full : support primes4 cap8 â‰¡ length primes4
cap-support-is-full = denseâ†’full primes4 cap8 cap-is-dense

cap-support-is-four : support primes4 cap8 â‰¡ 4
cap-support-is-four = cap-support-is-full

------------------------------------------------------------------------
-- 4.  The verdict, in one line.
--
-- The number is exponential in each exponent (previous module) AND the
-- derivation has one exponent per prime below the frontier (here).  The
-- first is a saving within a coordinate; the second is a cost across
-- them; and which dominates is a question about âˆ_{pâ‰k} versus Ï(k) that
-- neither module answers.
------------------------------------------------------------------------
