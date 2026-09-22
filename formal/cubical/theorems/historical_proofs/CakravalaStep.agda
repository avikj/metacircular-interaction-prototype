{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- Cakravala
--
-- The cyclic method's step, as a checked term.
--
-- `Bhavana.agda` has the composition law and the two divisibility
-- conversions; this file supplies the STEP â” the thing that makes
-- the method cyclic â” and nothing more.
--
-- â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”
-- PROVENANCE
--
-- Jayadeva, c. 950 CE, reported by Udayadivkara in the *Sundar*
-- (11th c.); Bhskara II, *Bjagaita*, 1150 CE, where it is worked in
-- full and applied to D = 61 and D = 67.  It solves xÂ² âˆ’ D yÂ² = 1 for
-- every non-square D, in a handful of cycles, six centuries before
-- Brouncker and Lagrange.  Euler's attribution of the equation to Pell â”
-- who never worked on it â” is later still and is the name it is taught
-- under.
--
-- â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”
-- THE STEP
--
-- A state is a triple (a, b, k) with aÂ² âˆ’ D bÂ² = k.  Given m with
-- k | a + bm, the next state is
--
--     a' = (a m + D b)/k,   b' = (a + b m)/k,   k' = (mÂ² âˆ’ D)/k.
--
-- `cakravala-step` below proves the state condition is preserved, in
-- CLEARED form â” no division anywhere in the statement:
--
--     kÂa' = am + Db,  kÂb' = a + bm,  kÂk' = mÂ² âˆ’ D
--        âŸ  (kÂk)Â(a'Â² âˆ’ D b'Â²)  â‰¡  (kÂk)Âk'
--
-- One solver identity does the work:
--
--     (am + Db)Â² âˆ’ D(a + bm)Â²  â‰¡  (aÂ² âˆ’ DbÂ²)(mÂ² âˆ’ D)
--
-- which is Brahmagupta's composition specialised to the trivial triple
-- (m, 1, mÂ² âˆ’ D) â” the one instance the cakravla actually uses.
--
-- â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”
-- WHAT THE CLEARED FORM SAYS
--
-- The identity is unconditional.  The DESCENT â” concluding a'Â² âˆ’ Db'Â² = k'
-- from the cleared form â” needs cancelling kÂ², i.e. k invertible or the
-- ring cancellative.  That is precisely what
-- `DescentIsNotInversion` found and `DescentCostsTheIntegers` priced:
-- the cakravla's descent is division by a scalar, not inversion in the
-- composition monoid, and dividing is what costs the integers.
--
-- So the oldest algorithm here and the newest theorem here say the same
-- thing, and the algorithm said it first: **the cycle turns on a
-- division.**
--
------------------------------------------------------------------------

module CakravalaStep where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Int using (â„¤ ; pos ; negsuc)
open import Cubical.Algebra.CommRing
open import Cubical.Algebra.CommRing.Instances.Int using (â„¤CommRing)
open import Cubical.Tactics.CommRingSolver.Reflection

private
  variable
    â„“ : Level

module Cycle (R : CommRing â„“) where

  open CommRingStr (snd R)

  A : Type â„“
  A = fst R

  -- the state condition: (a, b, k) lies on the form xÂ² âˆ’ D yÂ²
  OnForm : A â†’ A â†’ A â†’ A â†’ Type â„“
  OnForm D a b k = (a Â· a) - (D Â· (b Â· b)) â‰¡ k

  private
    -- pull kÂ² through the form
    homog : (D k a' b' : A) â†’
      (k Â· k) Â· ((a' Â· a') - (D Â· (b' Â· b')))
      â‰¡ ((k Â· a') Â· (k Â· a')) - (D Â· ((k Â· b') Â· (k Â· b')))
    homog D k a' b' = solve! R

    -- BRAHMAGUPTA, at the trivial triple (m, 1, mÂ² âˆ’ D).  This is the
    -- whole engine of the cyclic method.
    bhavana-trivial : (D a b m : A) â†’
      (((a Â· m) + (D Â· b)) Â· ((a Â· m) + (D Â· b)))
      - (D Â· ((a + (b Â· m)) Â· (a + (b Â· m))))
      â‰¡ ((a Â· a) - (D Â· (b Â· b))) Â· ((m Â· m) - D)
    bhavana-trivial D a b m = solve! R

    regroup : (k k' : A) â†’ k Â· (k Â· k') â‰¡ (k Â· k) Â· k'
    regroup k k' = solve! R

  ----------------------------------------------------------------------
  -- THE STEP.  Cleared of denominators, so no division appears.
  ----------------------------------------------------------------------

  cakravala-step :
    (D a b k m a' b' k' : A)
    â†’ OnForm D a b k
    â†’ k Â· a' â‰¡ (a Â· m) + (D Â· b)
    â†’ k Â· b' â‰¡ a + (b Â· m)
    â†’ k Â· k' â‰¡ (m Â· m) - D
    â†’ (k Â· k) Â· ((a' Â· a') - (D Â· (b' Â· b'))) â‰¡ (k Â· k) Â· k'
  cakravala-step D a b k m a' b' k' onform ha hb hk =
      homog D k a' b'
    âˆ™ congâ‚‚ (Î» p q â†’ (p Â· p) - (D Â· (q Â· q))) ha hb
    âˆ™ bhavana-trivial D a b m
    âˆ™ congâ‚‚ _Â·_ onform (sym hk)
    âˆ™ regroup k k'

------------------------------------------------------------------------
-- A CYCLE, RUN.  Bhskara's own example, D = 61, first step.
--
--   start   (a,b,k) = (8, 1, 3)        64 âˆ’ 61 = 3
--   choose  m = 7                      3 | 8 + 1Â7 = 15,  mÂ² âˆ’ D = âˆ’12
--   then    a' = (8Â7 + 61)/3 = 39,  b' = 15/3 = 5,  k' = âˆ’12/3 = âˆ’4
--   check   39Â² âˆ’ 61Â5Â² = 1521 âˆ’ 1525 = âˆ’4
--
-- The state condition is preserved, and note that |k| RISES here, 3 to 4.
-- The cyclic method does not descend monotonically in |k|; that is why it
-- needs Bhskaraâ™s choice rule (m = 7 minimises |mÂ² âˆ’ 61| = 12 among the
-- m with 3 | 8 + m) and why termination is not the algebra.  Both states
-- are checked below by `refl`.
------------------------------------------------------------------------

open Cycle â„¤CommRing using (OnForm)

start-61 : OnForm (pos 61) (pos 8) (pos 1) (pos 3)
start-61 = refl

next-61 : OnForm (pos 61) (pos 39) (pos 5) (negsuc 3)
next-61 = refl

-- negsuc 3 is âˆ’4, so the next state is (39, 5, âˆ’4)
------------------------------------------------------------------------
