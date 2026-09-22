{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- PrastutiNairapeksya_TheTotalIsIndependentOfTheReversibleEncoder
--
-- `KramaNairapeksya` proves that `total` is invariant under every permutation
-- of `Fin (suc n)`.  This representation theorem is immediate but must
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
-- Consequence for the finite Born/refinement lane: nested-versus-flat
-- coherence for the canonical `SumFinΣ` encoder transfers to every
-- reversible flat presentation, so one canonical coherence square
-- suffices rather than one square per representation.
--
-- TERM. प्रस्तुति (presentation) and नैरपेक्ष्य (independence) are ordinary
-- ; the compound is built here.
------------------------------------------------------------------------

module PrastutiNairapeksya_TheTotalIsIndependentOfTheReversibleEncoder where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Equiv
  using (_≃_ ; compEquiv ; equivFun ; invEq ; invEquiv ; retEq)
open import Cubical.Data.Nat using (ℕ ; suc)
open import Cubical.Data.SumFin using (Fin)

open import SamaVibhaga_TransitiveSymmetryNormalizationAndUniqueDivisionForceTheUniformMeasure
  using (total ; total-ext)
open import OrderNairapeksya_TheTotalIsIndifferentToTheEnumerationSpendingOnlyAssocAndComm
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
