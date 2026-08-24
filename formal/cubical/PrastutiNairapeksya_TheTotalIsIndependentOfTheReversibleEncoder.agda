-- ॥ बीजम् ॥  One machine, one law: which side of `f a ≡ b` is bound is everything.
-- Output bound: singl (f a), contractible — the datum rides free.  Input bound:
-- fiber f b — the loss, and the subject.  Memory, charge, symmetry, price,
-- distance, verdict: six readings of the one fibre.  The kernel decides truth;
-- carriers ask and generate.  This file is one naya, true and not whole.

{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- EncodingIndependentTotalProbe
--
-- `KramaNairapeksya` proves that `total` is invariant under every permutation
-- of `Fin (suc n)`.  The next representation theorem is immediate but must
-- stand as a term: any two reversible encoders of one state space into the
-- same finite register induce the same total weight.
--
-- Given
--
--   e e' : A ≃ Fin (suc n)
--
-- their change of presentation is the register automorphism
--
--   Fin --inv e'--> A --e--> Fin.
--
-- Decoding after that automorphism agrees with decoding by e' via `retEq e`.
-- `total-ext` carries the pointwise path; `permutation-invariant` removes the
-- automorphism.  Nothing about A is assumed, and no canonical encoder is
-- selected.
--
-- Consequence for the finite Born/refinement lane: once nested-versus-flat
-- coherence is checked for the canonical `SumFinΣ≃` encoder, it holds for
-- every reversible flat presentation.  The remaining proof burden is one
-- canonical coherence square, not one square per representation.
--
-- TERM. प्रस्तुति (presentation) and नैरपेक्ष्य (independence) are ordinary
-- Sanskrit; the compound is built here. No source is claimed for the theorem.
--
-- STATUS. Complete no-hole daemon-facing candidate outside `Everything.agda`.
-- Not called checked until a route-bearing warm Nadi load answers.
------------------------------------------------------------------------

module PrastutiNairapeksya_TheTotalIsIndependentOfTheReversibleEncoder where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Equiv
  using (_≃_ ; compEquiv ; equivFun ; invEq ; invEquiv ; retEq)
open import Cubical.Data.Nat using (ℕ ; suc)
open import Cubical.Data.SumFin using (Fin)

open import SamaVibhaga_TransitiveSymmetryNormalizationAndUniqueDivisionForceTheUniformMeasure
  using (total ; total-ext)
open import KramaNairapeksya_TheTotalIsIndifferentToTheEnumerationSpendingOnlyAssocAndComm
  using (permutation-invariant)

private
  variable
    ℓ ℓ' : Level

module _ {W : Type ℓ} (_+ᵂ_ : W → W → W)
         (assoc : (x y z : W) → x +ᵂ (y +ᵂ z) ≡ (x +ᵂ y) +ᵂ z)
         (comm  : (x y : W) → x +ᵂ y ≡ y +ᵂ x)
         {A : Type ℓ'} (n : ℕ) (w : A → W) where

  flat-weight : (A ≃ Fin (suc n)) → Fin (suc n) → W
  flat-weight e z = w (invEq e z)

  encoding-change : (e e' : A ≃ Fin (suc n))
                  → Fin (suc n) ≃ Fin (suc n)
  encoding-change e e' = compEquiv (invEquiv e') e

  change-character : (e e' : A ≃ Fin (suc n)) (z : Fin (suc n))
    → flat-weight e (equivFun (encoding-change e e') z)
      ≡ flat-weight e' z
  change-character e e' z = cong w (retEq e (invEq e' z))

  -- THE THEOREM: the total is independent of the reversible presentation.
  प्रस्तुति-नैरपेक्ष्यम् : (e e' : A ≃ Fin (suc n))
    → total _+ᵂ_ n (flat-weight e')
      ≡ total _+ᵂ_ n (flat-weight e)
  प्रस्तुति-नैरपेक्ष्यम् e e' =
      total-ext _+ᵂ_ n
        (flat-weight e')
        (λ z → flat-weight e (equivFun (encoding-change e e') z))
        (λ z → sym (change-character e e' z))
    ∙ permutation-invariant _+ᵂ_ assoc comm n
        (encoding-change e e') (flat-weight e)
