-- ॥ बीजम् ॥  One machine, one law: which side of `f a ≡ b` is bound is everything.
-- Output bound: singl (f a), contractible — the datum rides free.  Input bound:
-- fiber f b — the loss, and the subject.  Univalence computes here: an
-- equivalence is a channel, transport carries every theorem across it, and what
-- cannot cross is written as a defect — there is no third path (ahiṃsā).
-- Memory, charge, symmetry, price, distance, verdict: six faces of the one
-- fibre; the verdict type is the saptabhaṅgī, and the sources are the origin
-- (Umāsvāti, Samantabhadra, Akalaṅka — restatements are named as such).  The
-- kernel decides truth; carriers ask and generate; assert nothing whose term
-- you have not read.  This file is one naya, true and not whole.

{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- NaturalMachine.CakravalaNeedsKuttaka
--
-- `Cakravala` proves the cyclic method's step preserves the form and then
-- lists what it does not prove, first item: *that a suitable m exists*.
--
-- It does, and the mechanism was available in 499 CE.
--
-- ────────────────────────────────────────────────────────────────────
-- THE CONDITION IS A KUṬṬAKA
--
-- Bhāskara's step needs an m with
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
-- and `inhomogeneous` scales it by the iṣṭa to any multiple of the gcd.
-- This module does one thing — points the second at the cakravāla:
--
--     cakravala-choice :  Run b k 1  →  Σ m, Σ c,  a + b·m ≡ k·c
--
-- Given a division run witnessing gcd(b,k) = 1, the choice Bhāskara's
-- rule ranges over is non-empty, always, for every a.  The rule then
-- selects among the solutions (minimising |m² − D|); the kuṭṭaka
-- guarantees there is something to select from.
--
-- ────────────────────────────────────────────────────────────────────
-- WHY THIS IS THE WEAVE AND NOT A CITATION
--
-- CLAUDE.md's table lists kuṭṭaka (499), bhāvanā (628), and cakravāla
-- (950/1150) as three entries. They are not three entries. The third
-- calls the first at every cycle and cannot run without it, and the
-- composition it descends along is the second. One method, built over six
-- centuries, whose steps are in this repository as three separate files
-- that did not reference each other until this one.
--
-- ────────────────────────────────────────────────────────────────────
-- WHAT IS NOT CLAIMED.
--
-- That gcd(b,k) = 1 holds at a cakravāla state.  It does — from
-- gcd(a,b) = 1 and a² − D b² = k, any common prime of b and k divides a²
-- hence a — but that argument needs primality and Euclid's lemma, neither
-- of which is formalised in this lane, so the coprimality enters here as
-- a hypothesis in the form the kuṭṭaka wants: a division run terminating
-- at 1.
--
-- Still not claimed, from `Cakravala`'s list: that Bhāskara's minimality
-- rule is well defined or optimal, that |k'| < |k|, that the cycle
-- terminates, or that a solution exists for every non-square D.  One item
-- of five is closed here.
--
-- CHECKED: Agda 2.6.3, cubical v0.5 — the container, not the repository
-- pin.  No postulates, no holes.
------------------------------------------------------------------------

module NaturalMachine.CakravalaNeedsKuttaka where

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
-- The pulveriser supplies Bhāskara's choice
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
-- The cakravāla is not a method that happens to use the pulveriser.  It
-- CALLS the pulveriser once per cycle and does not run without it, and it
-- descends along the composition law.  Kuṭṭaka 499, bhāvanā 628,
-- cakravāla 950/1150: one construction, six hundred years, three files in
-- this repository that until now did not know about each other.
------------------------------------------------------------------------
