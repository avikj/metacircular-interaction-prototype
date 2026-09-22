{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- CakravalaNeedsKuttaka
--
-- `Cakravala` proves the cyclic method's step preserves the form.  A
-- suitable m exists, and the mechanism was available in 499 CE.
--
-- ────────────────────────────────────────────────────────────────────
-- THE CONDITION IS A KUAKA
--
-- Bhskara's step needs an m with
--
--     k | a + b m.
--
-- That is `b m ≡ −a (mod k)`, i.e. a solution of the linear indeterminate
-- equation `b m + k t = −a` — which is exactly what Āryabhaṭa's kuṭṭaka
-- ("pulveriser", *Āryabhaṭīya* 2.32–33, 499 CE) computes, six and a half
-- centuries before the method that needs it.
--
-- `Kuttaka.agda` in this repository already has the pulveriser as a
-- checked theorem: `bezout` extracts a Bézout pair from a division run,
-- and `inhomogeneous` scales it by the ia to any multiple of the gcd.
-- This module does one thing — points the second at the cakravāla:
--
--     cakravala-choice :  Run b k 1  →  Σ m, Σ c,  a + b·m ≡ k·c
--
-- Given a division run witnessing gcd(b,k) = 1, the choice Bhskara's
-- rule ranges over is non-empty, always, for every a.  The rule then
-- selects among the solutions (minimising |m² − D|); the kuaka
-- guarantees there is something to select from.
--
-- ────────────────────────────────────────────────────────────────────
-- WHY THIS IS THE WEAVE AND NOT A CITATION
--
-- The entries kuaka (499), bhvan (628), and cakravla
-- (950/1150) are not three entries. The third
-- calls the first at every cycle and cannot run without it, and the
-- composition it descends along is the second. One method, built over six
-- centuries, whose steps are in this repository as three separate files
-- that did not reference each other until this one.
--
------------------------------------------------------------------------

module CakravalaNeedsKuttaka where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Int using (ℤ ; pos ; negsuc ; _·_ ; _+_ ; -_)
open import Cubical.Data.Sigma
open import Cubical.Algebra.CommRing.Instances.Int using (ℤCommRing)
open import Cubical.Tactics.CommRingSolver.Reflection using (solve!)

open import Kuttaka using (Run ; stop ; div ; inhomogeneous)

private
  unit· : (x : ℤ) → pos 1 · x ≡ x
  unit· x = solve! ℤCommRing

  peel : (a b m k t : ℤ) → a + b · m ≡ a + ((b · m + k · t) + (- (k · t)))
  peel a b m k t = solve! ℤCommRing

  close : (a k t : ℤ) → a + ((- a) + (- (k · t))) ≡ k · (- t)
  close a k t = solve! ℤCommRing

------------------------------------------------------------------------
-- The pulveriser supplies Bhskara's choice
------------------------------------------------------------------------

cakravala-choice :
  (a b k : ℤ) → Run b k (pos 1)
  → Σ[ m ∈ ℤ ] Σ[ c ∈ ℤ ] (a + b · m ≡ k · c)
cakravala-choice a b k run with inhomogeneous b k (pos 1) (- a) run
... | (m , t , sol) = m , (- t) ,
      ( peel a b m k t
      ∙ cong (λ z → a + (z + (- (k · t)))) (sol ∙ unit· (- a))
      ∙ close a k t )

------------------------------------------------------------------------
-- It runs.  gcd(5, 3) = 1 by one division step, so at a state with
-- b = 5, k = 3 the condition k | a + b·m is solvable for every a.
------------------------------------------------------------------------

run-5-3 : Run (pos 5) (pos 3) (pos 1)
run-5-3 = div (pos 5) (pos 3) (pos 1) (pos 2) (pos 1) refl
            (div (pos 3) (pos 2) (pos 1) (pos 1) (pos 1) refl
              (div (pos 2) (pos 1) (pos 2) (pos 0) (pos 1) refl
                (stop (pos 1))))

choice-for-8 : Σ[ m ∈ ℤ ] Σ[ c ∈ ℤ ] (pos 8 + pos 5 · m ≡ pos 3 · c)
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
