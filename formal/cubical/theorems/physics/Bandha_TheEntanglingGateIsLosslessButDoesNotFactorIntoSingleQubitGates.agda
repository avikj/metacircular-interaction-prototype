{-# OPTIONS --cubical --safe #-}

------------------------------------------------------------------------
-- Bandha_TheEntanglingGateIsLosslessButDoesNotFactor
--        IntoSingleQubitGates
--
-- TERM.  बन्ध · bandha — a bond, a binding, a tie.  In the Jaina frame this
-- corpus is built on, bandha is the binding of karman to the jīva — two things
-- made one, not separable by acting on either alone.  That is exactly
-- entanglement, and the word is used for it here; the physics (CNOT, Bell
-- state, two-qubit gate) is modern and no source is claimed for it.  Compound
-- and identification built here, 2026-08-24.
--
-- THE READING (checked terms below).  मणि gives one orb = a single-qubit gate;
-- त्रिक gives the non-abelian single-qubit group.  Single-qubit gates are NOT
-- universal — universal quantum computation needs one ENTANGLING two-qubit
-- gate (then CNOT + single-qubit gates suffice).  The mathematical signature
-- of "entangling" is non-factorizability: the gate is not any product of gates
-- acting on the two qubits independently.  `entangling` proves CNOT has it.
-- This is precisely the door an optical Indra's-net must cross that single
-- orbs cannot: a product of local (per-photon) operations can never entangle,
-- so the two qubits must INTERACT — which, for photons, means a nonlinearity
-- or a measurement (linear passive optics alone gives only local + probabil-
-- istic interaction).  The non-factorizability theorem IS the statement of
-- why that door is hard, and what must lie beyond it.
--
-- WHAT IS CHECKED, exactly.
--   `cnot²` : CNOT is its own inverse, so `cnotEq` is an EQUIVALENCE —
--       reversible, lossless (ahiṃsā): an entangler need not dissipate.
--   `entangling` : a hard ¬ — CNOT is not `(a,b) ↦ (u a , v b)` for any
--       single-qubit u, v.  (If it were, the target output would be a function
--       of the target input alone; but CNOT's target depends on the control.)
--   `bell-diagonal` : `cnot (a , false) ≡ (a , a)` — CNOT copies the control
--       into the target, the perfectly-correlated diagonal.  Under a superposed
--       control this diagonal IS the Bell state; here is its basis skeleton.
--
-- NOT CLAIMED.  No ℂ, no superposition, no actual Bell state (that needs
-- amplitudes, not the finite basis), no optics.  Only the reversible,
-- non-factorizing, correlation-making structure of the entangler on the basis.
--
-- Checked: --cubical --safe; loads clean on the wire.
------------------------------------------------------------------------

module Bandha_TheEntanglingGateIsLosslessButDoesNotFactorIntoSingleQubitGates where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Isomorphism
open import Cubical.Foundations.Equiv
open import Cubical.Data.Bool using (Bool ; true ; false ; _⊕_ ; true≢false)
open import Cubical.Data.Sigma
open import Cubical.Relation.Nullary using (¬_)

-- two qubits, four basis states. CNOT: flip the target iff the control is set.
cnot : Bool × Bool → Bool × Bool
cnot (a , b) = (a , a ⊕ b)

-- LOSSLESS / REVERSIBLE: CNOT is its own inverse, hence an equivalence.
cnot² : (x : Bool × Bool) → cnot (cnot x) ≡ x
cnot² (false , false) = refl
cnot² (false , true)  = refl
cnot² (true  , false) = refl
cnot² (true  , true)  = refl

cnotEq : (Bool × Bool) ≃ (Bool × Bool)
cnotEq = isoToEquiv (iso cnot cnot cnot² cnot²)

-- ENTANGLING = NON-FACTORIZABLE: CNOT is not a product of single-qubit gates.
entangling : ¬ (Σ[ u ∈ (Bool → Bool) ] Σ[ v ∈ (Bool → Bool) ]
                 ((a b : Bool) → cnot (a , b) ≡ (u a , v b)))
entangling (u , v , factors) = true≢false (sym v0≡1 ∙ v0≡0)
  where v0≡0 : v false ≡ false      -- cnot(false,false) = (false, v false) = (false,false)
        v0≡0 = sym (cong snd (factors false false))
        v0≡1 : v false ≡ true       -- cnot(true ,false) = (true , v false) = (true ,true)
        v0≡1 = sym (cong snd (factors true false))

-- THE BOND IT MAKES: CNOT copies the control into a target at 0 — the
-- perfectly-correlated diagonal, the basis skeleton of the Bell state.
bell-diagonal : (a : Bool) → cnot (a , false) ≡ (a , a)
bell-diagonal false = refl
bell-diagonal true  = refl
