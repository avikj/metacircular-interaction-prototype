{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- CakravalaNeedsKuttaka
--
-- `Cakravala` proves the cyclic method's step preserves the form and then
-- lists what it does not prove, first item: *that a suitable m exists*.
--
-- It does, and the mechanism was available in 499 CE.
--
-- â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”
-- THE CONDITION IS A KUAKA
--
-- Bhskara's step needs an m with
--
--     k | a + b m.
--
-- That is `b m â‰¡ âˆ’a (mod k)`, i.e. a solution of the linear indeterminate
-- equation `b m + k t = âˆ’a` â” which is exactly what ryabhaa's kuaka
-- ("pulveriser", *ryabhaya* 2.32â“33, 499 CE) computes, six and a half
-- centuries before the method that needs it.
--
-- `Kuttaka.agda` in this repository already has the pulveriser as a
-- checked theorem: `bezout` extracts a B©zout pair from a division run,
-- and `inhomogeneous` scales it by the ia to any multiple of the gcd.
-- This module does one thing â” points the second at the cakravla:
--
--     cakravala-choice :  Run b k 1  â’  Î m, Î c,  a + bÂm â‰¡ kÂc
--
-- Given a division run witnessing gcd(b,k) = 1, the choice Bhskara's
-- rule ranges over is non-empty, always, for every a.  The rule then
-- selects among the solutions (minimising |mÂ² âˆ’ D|); the kuaka
-- guarantees there is something to select from.
--
-- â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”
-- WHY THIS IS THE WEAVE AND NOT A CITATION
--
-- CLAUDE.md's table lists kuaka (499), bhvan (628), and cakravla
-- (950/1150) as three entries. They are not three entries. The third
-- calls the first at every cycle and cannot run without it, and the
-- composition it descends along is the second. One method, built over six
-- centuries, whose steps are in this repository as three separate files
-- that did not reference each other until this one.
--
-- â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”
--
-- Still not claimed, from `Cakravala`'s list: that Bhskara's minimality
-- rule is well defined or optimal, that |k'| < |k|, that the cycle
-- terminates, or that a solution exists for every non-square D.  One item
-- of five is closed here.
--
-- CHECKED: Agda 2.6.3, cubical v0.5 â” the container, not the repository
-- pin.  No postulates, no holes.
------------------------------------------------------------------------

module CakravalaNeedsKuttaka where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Int using (â„¤ ; pos ; negsuc ; _Â·_ ; _+_ ; -_)
open import Cubical.Data.Sigma
open import Cubical.Algebra.CommRing.Instances.Int using (â„¤CommRing)
open import Cubical.Tactics.CommRingSolver.Reflection using (solve!)

open import Kuttaka using (Run ; stop ; div ; inhomogeneous)

private
  unitÂ· : (x : â„¤) â†’ pos 1 Â· x â‰¡ x
  unitÂ· x = solve! â„¤CommRing

  peel : (a b m k t : â„¤) â†’ a + b Â· m â‰¡ a + ((b Â· m + k Â· t) + (- (k Â· t)))
  peel a b m k t = solve! â„¤CommRing

  close : (a k t : â„¤) â†’ a + ((- a) + (- (k Â· t))) â‰¡ k Â· (- t)
  close a k t = solve! â„¤CommRing

------------------------------------------------------------------------
-- The pulveriser supplies Bhskara's choice
------------------------------------------------------------------------

cakravala-choice :
  (a b k : â„¤) â†’ Run b k (pos 1)
  â†’ Î£[ m âˆˆ â„¤ ] Î£[ c âˆˆ â„¤ ] (a + b Â· m â‰¡ k Â· c)
cakravala-choice a b k run with inhomogeneous b k (pos 1) (- a) run
... | (m , t , sol) = m , (- t) ,
      ( peel a b m k t
      âˆ™ cong (Î» z â†’ a + (z + (- (k Â· t)))) (sol âˆ™ unitÂ· (- a))
      âˆ™ close a k t )

------------------------------------------------------------------------
-- It runs.  gcd(5, 3) = 1 by one division step, so at a state with
-- b = 5, k = 3 the condition k | a + bÂm is solvable for every a.
------------------------------------------------------------------------

run-5-3 : Run (pos 5) (pos 3) (pos 1)
run-5-3 = div (pos 5) (pos 3) (pos 1) (pos 2) (pos 1) refl
            (div (pos 3) (pos 2) (pos 1) (pos 1) (pos 1) refl
              (div (pos 2) (pos 1) (pos 2) (pos 0) (pos 1) refl
                (stop (pos 1))))

choice-for-8 : Î£[ m âˆˆ â„¤ ] Î£[ c âˆˆ â„¤ ] (pos 8 + pos 5 Â· m â‰¡ pos 3 Â· c)
choice-for-8 = cakravala-choice (pos 8) (pos 5) (pos 3) run-5-3

------------------------------------------------------------------------
-- The sentence.
--
-- The cakravla is not a method that happens to use the pulveriser.  It
-- CALLS the pulveriser once per cycle and does not run without it, and it
-- descends along the composition law.  Kuaka 499, bhvan 628,
-- cakravla 950/1150: one construction, six hundred years, three files in
-- this repository that until now did not know about each other.
------------------------------------------------------------------------
