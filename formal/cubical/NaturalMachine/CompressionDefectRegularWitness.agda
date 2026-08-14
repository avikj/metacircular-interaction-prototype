{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- NaturalMachine.CompressionDefectRegularWitness
--
-- A nonzero element of a ring has an explicit witness in the ring's regular
-- left action: act on `1r`.  Specializing the element to the raw product
-- expression exported as `CompressionDefect.defect` converts nonvanishing
-- into an inhabited witness type for this regular representation.  Reading
-- that expression as a structured compression defect additionally requires
-- the enclosing idempotent/complement/semigroup laws.
--
-- This does not extract a state in an arbitrary intended module or carrier.
-- Such an extraction needs a declared action and a witness-producing
-- faithfulness/nontriviality hypothesis.  In particular, this leaf does not
-- close the general T18.5 witness direction.
------------------------------------------------------------------------

module NaturalMachine.CompressionDefectRegularWitness where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Structure using (⟨_⟩)
open import Cubical.Data.Nat using (ℕ)
open import Cubical.Data.Sigma using (Σ-syntax ; _,_)
open import Cubical.Relation.Nullary using (¬_)
open import Cubical.Algebra.Ring

import NaturalMachine.CompressionDefect as CD

private
  variable
    ℓ : Level

module _ (A : Ring ℓ) where
  open RingStr (snd A)
  open RingTheory A

  -- Zero divisors are harmless: the chosen regular-action state is `1r`,
  -- and the only ring law used is `a · 1r ≡ a`.
  regular-action-detects-nonzero :
    (a : ⟨ A ⟩) → ¬ (a ≡ 0r)
    → Σ[ x ∈ ⟨ A ⟩ ] ¬ (a · x ≡ 0r)
  regular-action-detects-nonzero a nonzero =
    1r , λ acts-zero → nonzero (sym (·IdR a) ∙ acts-zero)

  -- The sampled raw CompressionDefect product, observed through the regular
  -- action.
  -- No projector, complement, or semigroup law is needed to expose a witness
  -- once this particular ring element is assumed nonzero.
  nonzero-compression-defect→regular-witness :
    (e q : ⟨ A ⟩) (T : ℕ → ⟨ A ⟩) (t s : ℕ)
    → ¬ (CD.defect A e q T t s ≡ 0r)
    → Σ[ x ∈ ⟨ A ⟩ ]
        ¬ (CD.defect A e q T t s · x ≡ 0r)
  nonzero-compression-defect→regular-witness e q T t s nonzero =
    regular-action-detects-nonzero (CD.defect A e q T t s) nonzero
