{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- नियति — fate.  THE MACHINE HAS EXACTLY ONE EXECUTION: DETERMINISM
-- IS CONTRACTIBILITY OF THE STREAM.
--
-- Vishvayantra's `Exec mc` is the type of productive infinite runs
-- from mc: a now, a receipt that now is mc, and a rest from the
-- stepped configuration.  This file proves the type is CONTRACTIBLE:
-- `exec mc` inhabits it, and every inhabitant is a path away — the
-- path built coinductively, component by component, with the same
-- ∨-square that collapses a receipt onto refl.
--
-- Read it as a definition receiving its theorem: "deterministic"
-- usually means a functional transition relation, a condition on
-- steps.  Here it is a statement about the whole unfolding at once —
-- the space of infinite histories from any configuration is a point.
-- Nondeterminism would make Exec a genuine space; the universal
-- machine's is contractible, and the kernel checks the contraction.
--
-- With it, the run really is a monoid action of (ℕ, +, 0), on the
-- nose at zero and by AnulomaViloma's run-additive in general: one
-- machine, one clock, one history.
------------------------------------------------------------------------

module Niyati_TheMachineHasExactlyOneExecutionDeterminismIsContractibilityOfTheStream where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (ℕ ; zero)
open import Cubical.Data.Sigma

open import Vishvayantra_TheTuringStepIsTheVisibleProjectionOfTheLosslessStepAndTheKeptFibreIsTheSource
open Exec

------------------------------------------------------------------------
-- §1  Every execution is the execution.
------------------------------------------------------------------------

exec-unique : (mc : Machine) (e : Exec mc) → exec mc ≡ e
now  (exec-unique mc e i) = here e (~ i)
here (exec-unique mc e i) = λ j → here e (~ i ∨ j)
next (exec-unique mc e i) = exec-unique (uStep mc) (next e) i

-- THE THEOREM.  One configuration, one history: the space of
-- productive runs from mc is contractible.
one-execution : (mc : Machine) → isContr (Exec mc)
one-execution mc = exec mc , exec-unique mc

------------------------------------------------------------------------
-- §2  The clock acts.
------------------------------------------------------------------------

-- Zero steps is the identity, on the nose.
run-zero : (mc : Machine) → run zero mc ≡ mc
run-zero mc = refl

-- Together with AnulomaViloma's run-additive, run is a monoid action
-- of (ℕ, +, 0) on Machine; this file records the unit law at its
-- home.
