{-# OPTIONS --cubical --safe #-}

------------------------------------------------------------------------
-- Bandha_TheEntanglingGateIsLosslessButDoesNotFactor
--        IntoSingleQubitGates
--
-- TERM.  àà¨àà§ Â bandha â” a bond, a binding, a tie.  In the Jaina frame this
-- corpus is built on, bandha is the binding of karman to the jva â” two things
-- made one, not separable by acting on either alone.  That is exactly
-- entanglement, and the word is used for it here; the physics (CNOT, Bell
-- state, two-qubit gate) is modern and no source is claimed for it.  Compound
-- and identification built here, 2026-08-24.
--
-- THE READING (checked terms below).  à®àà¿ gives one orb = a single-qubit gate;
-- ààà°à¿à• gives the non-abelian single-qubit group.  Single-qubit gates are NOT
-- universal â” universal quantum computation needs one ENTANGLING two-qubit
-- gate (then CNOT + single-qubit gates suffice).  The mathematical signature
-- of "entangling" is non-factorizability: the gate is not any product of gates
-- acting on the two qubits independently.  `entangling` proves CNOT has it.
-- This is precisely the door an optical Indra's-net must cross that single
-- orbs cannot: a product of local (per-photon) operations can never entangle,
-- so the two qubits must INTERACT â” which, for photons, means a nonlinearity
-- or a measurement (linear passive optics alone gives only local + probabil-
-- istic interaction).  The non-factorizability theorem IS the statement of
-- why that door is hard, and what must lie beyond it.
--
-- WHAT IS CHECKED, exactly.
--   `cnotÂ²` : CNOT is its own inverse, so `cnotEq` is an EQUIVALENCE â”
--       reversible, lossless (ahis): an entangler need not dissipate.
--   `entangling` : a hard Â â” CNOT is not `(a,b) â¦ (u a , v b)` for any
--       single-qubit u, v.  (If it were, the target output would be a function
--       of the target input alone; but CNOT's target depends on the control.)
--   `bell-diagonal` : `cnot (a , false) â‰¡ (a , a)` â” CNOT copies the control
--       into the target, the perfectly-correlated diagonal.  Under a superposed
--       control this diagonal IS the Bell state; here is its basis skeleton.
--
-- Checked: --cubical --safe; loads clean on the wire.
------------------------------------------------------------------------

module Bandha_TheEntanglingGateIsLosslessButDoesNotFactorIntoSingleQubitGates where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Isomorphism
open import Cubical.Foundations.Equiv
open import Cubical.Data.Bool using (Bool ; true ; false ; _âŠ•_ ; trueâ‰¢false)
open import Cubical.Data.Sigma
open import Cubical.Relation.Nullary using (Â¬_)

-- two qubits, four basis states. CNOT: flip the target iff the control is set.
cnot : Bool Ã— Bool â†’ Bool Ã— Bool
cnot (a , b) = (a , a âŠ• b)

-- LOSSLESS / REVERSIBLE: CNOT is its own inverse, hence an equivalence.
cnotÂ² : (x : Bool Ã— Bool) â†’ cnot (cnot x) â‰¡ x
cnotÂ² (false , false) = refl
cnotÂ² (false , true)  = refl
cnotÂ² (true  , false) = refl
cnotÂ² (true  , true)  = refl

cnotEq : (Bool Ã— Bool) â‰ƒ (Bool Ã— Bool)
cnotEq = isoToEquiv (iso cnot cnot cnotÂ² cnotÂ²)

-- ENTANGLING = NON-FACTORIZABLE: CNOT is not a product of single-qubit gates.
entangling : Â¬ (Î£[ u âˆˆ (Bool â†’ Bool) ] Î£[ v âˆˆ (Bool â†’ Bool) ]
                 ((a b : Bool) â†’ cnot (a , b) â‰¡ (u a , v b)))
entangling (u , v , factors) = trueâ‰¢false (sym v0â‰¡1 âˆ™ v0â‰¡0)
  where v0â‰¡0 : v false â‰¡ false      -- cnot(false,false) = (false, v false) = (false,false)
        v0â‰¡0 = sym (cong snd (factors false false))
        v0â‰¡1 : v false â‰¡ true       -- cnot(true ,false) = (true , v false) = (true ,true)
        v0â‰¡1 = sym (cong snd (factors true false))

-- THE BOND IT MAKES: CNOT copies the control into a target at 0 â” the
-- perfectly-correlated diagonal, the basis skeleton of the Bell state.
bell-diagonal : (a : Bool) â†’ cnot (a , false) â‰¡ (a , a)
bell-diagonal false = refl
bell-diagonal true  = refl
