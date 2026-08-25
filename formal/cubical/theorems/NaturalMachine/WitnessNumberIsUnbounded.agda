{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- NaturalMachine.WitnessNumberIsUnbounded
--
-- `WitnessNumberIsTwo` left one item open and refused to estimate it:
-- *"whether any absence in this corpus has witness number above 2.  §3
-- gives a general floor and nothing here gives a general ceiling."*
--
-- There is no general ceiling.  Witness number 3 is realised, so the
-- uniform 2 across this corpus is a fact ABOUT THIS CORPUS and not a
-- theorem about absences.  That distinction is the whole point of having
-- fixed a measure.
--
-- ────────────────────────────────────────────────────────────────────
-- THE WITNESS
--
-- Three standpoints, three points, and each standpoint wrong at exactly
-- one of them:
--
--     law d x  =  ⊥      when d ≡ x
--     law d x  =  Unit   otherwise
--
-- A list refutes exactly when it contains all three points, because a
-- decoder survives every point but its own.  So:
--
--     Refutes law (t0 ∷ t1 ∷ t2 ∷ [])          §3
--     ¬ Refutes law (a ∷ b ∷ [])   for all a b §4
--
-- and the witness number is exactly 3.  The nine cases of §4 are the
-- pigeonhole, written out: from any two points some standpoint is
-- missing, and the missing one survives.
--
-- ────────────────────────────────────────────────────────────────────
-- WHAT IT IS, READ AS NAYAVĀDA
--
-- This is the plurality condition with a number on it.  Two standpoints
-- in disagreement are separated by two observations; three standpoints
-- that disagree pairwise need three, and no pair will do — not because
-- the third is hard to find but because every pair leaves a survivor.
--
-- The standing anekānta law (887641a7) is that a collapse exists IFF
-- every pair of standpoints agrees.  Plurality is one way to fail that,
-- not the only one.  This says how much plurality costs to
-- demonstrate: one witness per standpoint, when the standpoints
-- disagree in general position.  A durnaya — a standpoint asserting
-- itself by denying the others — is exactly the degenerate case where
-- one witness would have sufficed, and it is not this one.
--
-- ────────────────────────────────────────────────────────────────────
-- WHAT THIS DOES TO THE DEFLATIONARY THREAD
--
-- It sharpens rather than weakens it.  The reading "every absence here
-- is exact, so the barrier language is stronger than the objects
-- warrant" survives, and it is now a claim with content: the objects
-- here all cost 2, and 2 is not forced — 3 exists, one type-former
-- away.  Before this module the uniform 2 could have been an artefact
-- of the measure.  It is not; it is a fact about the sites.
--
-- NOT CLAIMED: that witness number is unbounded above 3.  The same
-- construction at n points plainly gives n, and its upper bound is one
-- line, but the LOWER bound at general n is a pigeonhole this module
-- does not prove — §4 is n = 3 by enumeration.  Named, not estimated.
--
-- CHECKED: Agda 2.6.3, cubical v0.5 — the container, not the repository
-- pin.  No postulates, no holes.
------------------------------------------------------------------------

module NaturalMachine.WitnessNumberIsUnbounded where

open import Cubical.Foundations.Prelude
open import Cubical.Data.List using (List ; [] ; _∷_)
open import Cubical.Data.Sigma
open import Cubical.Data.Unit using (Unit ; tt ; Unit* ; tt*)
open import Cubical.Data.Empty as Empty using (⊥)
open import Cubical.Relation.Nullary using (¬_)

open import NaturalMachine.WitnessNumberIsTwo using (AllHold ; Refutes)

------------------------------------------------------------------------
-- 1.  Three standpoints
------------------------------------------------------------------------

data Three : Type₀ where
  t0 t1 t2 : Three

------------------------------------------------------------------------
-- 2.  Each is wrong at exactly its own point
------------------------------------------------------------------------

law : Three → Three → Type₀
law t0 t0 = ⊥
law t0 t1 = Unit
law t0 t2 = Unit
law t1 t0 = Unit
law t1 t1 = ⊥
law t1 t2 = Unit
law t2 t0 = Unit
law t2 t1 = Unit
law t2 t2 = ⊥

------------------------------------------------------------------------
-- 3.  THREE POINTS REFUTE
--
-- Each decoder meets its own point in the list, and `law d d` is ⊥.
------------------------------------------------------------------------

triple : List Three
triple = t0 ∷ t1 ∷ t2 ∷ []

three-refute : Refutes law triple
three-refute t0 (bad , _)         = bad
three-refute t1 (_ , bad , _)     = bad
three-refute t2 (_ , _ , bad , _) = bad

------------------------------------------------------------------------
-- 4.  NO PAIR DOES — the pigeonhole, written out
--
-- From any two points a standpoint is missing, and a missing standpoint
-- survives the whole list.
------------------------------------------------------------------------

missing : (a b : Three) → Σ[ d ∈ Three ] AllHold law d (a ∷ b ∷ [])
missing t0 t0 = t1 , tt , tt , tt*
missing t0 t1 = t2 , tt , tt , tt*
missing t0 t2 = t1 , tt , tt , tt*
missing t1 t0 = t2 , tt , tt , tt*
missing t1 t1 = t0 , tt , tt , tt*
missing t1 t2 = t0 , tt , tt , tt*
missing t2 t0 = t1 , tt , tt , tt*
missing t2 t1 = t0 , tt , tt , tt*
missing t2 t2 = t0 , tt , tt , tt*

no-pair-refutes : (a b : Three) → ¬ Refutes law (a ∷ b ∷ [])
no-pair-refutes a b ref = ref (missing a b .fst) (missing a b .snd)

-- and a fortiori nothing shorter
missing₁ : (a : Three) → Σ[ d ∈ Three ] AllHold law d (a ∷ [])
missing₁ t0 = t1 , tt , tt*
missing₁ t1 = t0 , tt , tt*
missing₁ t2 = t0 , tt , tt*

no-single-refutes : (a : Three) → ¬ Refutes law (a ∷ [])
no-single-refutes a ref = ref (missing₁ a .fst) (missing₁ a .snd)

no-empty-refutes : ¬ Refutes law []
no-empty-refutes ref = ref t0 tt*

------------------------------------------------------------------------
-- 5.  THE WITNESS NUMBER IS EXACTLY 3
------------------------------------------------------------------------

witness-number-3 :
    Refutes law triple
  × ((a b : Three) → ¬ Refutes law (a ∷ b ∷ []))
  × ((a : Three) → ¬ Refutes law (a ∷ []))
  × (¬ Refutes law [])
witness-number-3 =
  three-refute , no-pair-refutes , no-single-refutes , no-empty-refutes

------------------------------------------------------------------------
-- 6.  And the absence it measures is a real one
--
-- No standpoint is right everywhere, which is the statement the whole
-- measure exists to quantify.
------------------------------------------------------------------------

open import NaturalMachine.WitnessNumberIsTwo using (refutes→absent)

no-universal-standpoint : ¬ (Σ[ d ∈ Three ] ((x : Three) → law d x))
no-universal-standpoint = refutes→absent law triple three-refute

------------------------------------------------------------------------
-- 7.  What is settled and what is not.
--
-- SETTLED.  Witness number is not bounded by 2.  The corpus's uniform 2
-- is a property of its sites, not of the notion of absence — which is
-- what a measure is for, and what could not be said before one was
-- fixed.
--
-- OPEN, named.  Whether witness number is unbounded.  The n-point
-- version of §2 has the obvious upper bound; the lower bound needs a
-- pigeonhole at general n, and §4 is an enumeration at n = 3.
--
-- ALSO OPEN, and more interesting.  Whether any absence arising from
-- MATHEMATICS in this corpus — rather than constructed to order, as
-- this one was — has witness number above 2.  Nothing found so far
-- does.  That may be a fact about the mathematics or about how the
-- sites were chosen, and this module cannot tell which.
------------------------------------------------------------------------

------------------------------------------------------------------------
-- 8.  THE SHARPER QUESTION IN §7 IS ANSWERED, and the answer is
--     neither of the two options offered there.
--
-- §7 asked whether the corpus's uniform 2 is "a fact about the
-- mathematics or about how the sites were chosen", and said this module
-- could not tell which.  It is neither: it is a fact about the DECODER
-- SPACE.  `NaturalMachine.WhyTheSitesAreTwo` proves
--
--     Discrete Y → CollisionFree q t ys → ¬ Refutes (factorLaw q t) ys
--
-- so over an unconstrained decoder space `Image q → T` with discrete
-- observations, a list refutes only by containing a collision — and a
-- collision is already a pair.  Every site in this corpus satisfies
-- both hypotheses, so 2 was never contingent there.
--
-- This module is consistent with that and shows where the hypothesis
-- bites.  Its decoders are THREE ATOMS, not all functions: the survivor
-- each pair leaves is a function the unconstrained space would have
-- contained anyway.  Constrain the decoders and the number can rise;
-- leave them unconstrained over discrete Y and it cannot.
------------------------------------------------------------------------

------------------------------------------------------------------------
-- 9.  THE UNBOUNDEDNESS ITEM IN §7 IS SETTLED, and more strongly than
--     it was asked.
--
-- §7 said the n-point version has the obvious upper bound but that the
-- lower bound at general n "needs a pigeonhole this module does not
-- prove".  No pigeonhole is needed.
--
-- `NaturalMachine.WitnessNumberCanBeInfinite` generalises §2 to any
-- discrete A and CHARACTERISES the refuting lists rather than bounding
-- them: a list refutes exactly when it contains every point.  At A =
-- Three that recovers 3.  At A = ℕ it gives
--
--     no-finite-list-refutes :
--       (ys : List ℕ) → ¬ Refutes (diagLaw discreteℕ) ys
--
-- while the absence still holds — so the witness number there is not
-- merely large, it is not a number at all.
--
-- Characterising the refuting lists turned out to be easier than
-- counting them, which is the same lesson as the rest of this thread:
-- fix what is being measured before reaching for a bound.
------------------------------------------------------------------------
