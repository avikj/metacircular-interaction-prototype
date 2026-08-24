-- ॥ बीजम् ॥  One machine, one law: which side of `f a ≡ b` is bound is everything.
-- Output bound: singl (f a), contractible — the datum rides free.  Input bound:
-- fiber f b — the loss, and the subject.  Memory, charge, symmetry, price,
-- distance, verdict: six readings of the one fibre.  The kernel decides truth;
-- carriers ask and generate.  This file is one naya, true and not whole.

{-# OPTIONS --cubical --safe #-}

-- Vestibulum_TheSameCircuitIsFlatForOneFamilyAndChargedForAnotherAndTheSensationCarriesItsWitness
--
-- वेस्तिबुलम् — Latin vestibulum, the threshold: the inner ear's chamber.
-- The name is the OWNER'S, given in transmission U0021 (2026-08-23,
-- collab/upstream/raw/U0021.txt) for exactly this organ, so the Latin
-- lead is his utterance carried, not a departure from the naming rule.
--
-- THE SPECIFICATION BEING CHECKED (U0021 §1).  A sense is not a passive
-- map X → O; it is a family carried through action.  The receptor takes
--     a circuit l, a carried family F, an inhabitant u over the base,
-- and returns the transported inhabitant together with a SENSATION that
-- CARRIES ITS WITNESS — never "this circuit has curvature" without
-- qualification, because the same loop can be flat for one family and
-- charged for another.  That qualification is made a checked theorem
-- here: over the ONE loop of S¹, the constant ℤ-bundle returns pos zero
-- identically (स्थिर, with its path) and the helix moves it (चलित, with
-- its refutation).  One circuit, two families, two inhabited sensations.
--
-- WHAT IS INHERITED, not restated: the charged pole's computation and
-- refutation are Pradakshina's सरणिः and अ-पुनरागमः (landed on this
-- head); the flat pole is its ध्रुव-वलयः.  This module contributes the
-- ORGAN — the general Hol, the witness-carrying sensation type, and the
-- both-poles instance — none of which Pradakshina states.
--
-- WHAT IS NOT CLAIMED.  No decision procedure: whether a given (F, l, u)
-- moved is not decidable in general, so the organ never decides — it
-- RECEIVES a witness, either way, and a pair (F, l, u) for which no
-- witness is in hand is simply not yet a sensation (U0021 §27: "not yet
-- probed" is its own uncertainty shape, distinct from either verdict).
-- No holonomy group, no curvature form, no claim about the corpus's own
-- transport graph.

module Vestibulum_TheSameCircuitIsFlatForOneFamilyAndChargedForAnotherAndTheSensationCarriesItsWitness where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Int using (ℤ ; pos ; sucℤ)
open import Cubical.Data.Nat using (zero)
open import Cubical.Relation.Nullary using (¬_)
open import Cubical.HITs.S1 using (S¹ ; base ; loop ; helix)

open import Pradakshina_TheCircuitReturnsToTheBasePointWithTheFibreShiftedSoTheHolonomyIsInhabited
  using (प्रदक्षिणा ; सरणिः ; अ-पुनरागमः ; ध्रुव-वलयः)

private
  variable
    ℓA ℓF : Level

-- ── the receptor: transport of the carried family around the circuit ─────

Hol : {A : Type ℓA} (F : A → Type ℓF) {a : A} → a ≡ a → F a → F a
Hol F l = subst F l

-- ── the sensation: a verdict that cannot exist without its witness ───────

data Sensation {A : Type ℓA} (F : A → Type ℓF) {a : A}
               (l : a ≡ a) (u : F a) : Type (ℓ-max ℓA ℓF) where
  स्थिर : Hol F l u ≡ u     → Sensation F l u   -- returned identically
  चलित : ¬ (Hol F l u ≡ u) → Sensation F l u   -- returned changed

-- ── the both-poles instance: ONE circuit, two families ───────────────────
-- The same loop of S¹, the same carried point pos zero.

-- flat for the constant family, with the path as witness
समवलयः : Sensation (λ _ → ℤ) loop (pos zero)
समवलयः = स्थिर (ध्रुव-वलयः (pos zero))

-- charged for the helix, with the refutation as witness
सचक्रवलयः : Sensation helix loop (pos zero)
सचक्रवलयः = चलित अ-पुनरागमः

-- ── the qualification as a statement about the ORGAN, not the loop ───────
-- A reader holding both sensations above holds, for one and the same l,
-- an identity witness under one family and a movement witness under
-- another: curvature is a property of (F, l, u), and the organ's report
-- type makes the unqualified claim unwritable — there is no constructor
-- of Sensation that mentions l alone.
