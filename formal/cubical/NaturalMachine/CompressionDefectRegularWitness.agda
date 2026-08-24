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
open import Cubical.Data.Nat using (ℕ) renaming (_+_ to _+ℕ_)
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
  -- The imported `defect` interface binds the enclosing laws even though its
  -- displayed value is the raw product.  Once that element is supplied and
  -- assumed nonzero, the witness extraction itself uses only the ring unit.
  nonzero-compression-defect→regular-witness :
    (e q : ⟨ A ⟩)
    (eIdem : e · e ≡ e)
    (eq1 : e + q ≡ 1r)
    (T : ℕ → ⟨ A ⟩)
    (Tsemi : (t s : ℕ) → T t · T s ≡ T (t +ℕ s))
    (t s : ℕ)
    → ¬ (CD.defect A e q eIdem eq1 T Tsemi t s ≡ 0r)
    → Σ[ x ∈ ⟨ A ⟩ ]
        ¬ (CD.defect A e q eIdem eq1 T Tsemi t s · x ≡ 0r)
  nonzero-compression-defect→regular-witness
      e q eIdem eq1 T Tsemi t s nonzero =
    regular-action-detects-nonzero
      (CD.defect A e q eIdem eq1 T Tsemi t s) nonzero
