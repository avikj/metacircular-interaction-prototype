{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- FiniteFoldPresentationIndependenceProbe
--
-- The immediate payoff of `PermutationInvariantTotalProbe`.
--
-- A nonempty finite type A is presented by an equivalence
--
--     e : A ≃ Fin (suc n).
--
-- The fold induced by e should not make e canonical.  For two presentations
-- e and f of the same size, their change-of-presentation map is a permutation
-- of Fin (suc n).  Permutation invariance therefore proves that both folds
-- agree.  No unit is introduced: the weight carrier remains only an
-- associative commutative semigroup, exactly as in the finite Born lane.
--
-- STATUS.  Complete and hole-free, contingent on the still-open kernel
-- receipt for `PermutationInvariantTotalProbe`.  Stage both probes in one
-- include root for Nadi.
------------------------------------------------------------------------

module FiniteFoldPresentationIndependenceProbe where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Equiv
  using (_≃_ ; compEquiv ; equivFun ; invEq ; invEquiv ; retEq)
open import Cubical.Data.Nat using (ℕ ; suc)
open import Cubical.Data.SumFin using (Fin)

open import SamaVibhaga_TransitiveSymmetryNormalizationAndUniqueDivisionForceTheUniformMeasure
  using (total ; total-ext)
open import PermutationInvariantTotalProbe
  using (permutation-invariant)

private
  variable
    ℓ ℓ' : Level
    n : ℕ
    A : Type ℓ

module _ {W : Type ℓ'} (_+ᵂ_ : W → W → W)
         (assoc : (x y z : W) → x +ᵂ (y +ᵂ z) ≡ (x +ᵂ y) +ᵂ z)
         (comm  : (x y : W) → x +ᵂ y ≡ y +ᵂ x) where

  finiteFold : (n : ℕ) → A ≃ Fin (suc n) → (A → W) → W
  finiteFold n e w = total _+ᵂ_ n (λ i → w (invEq e i))

  -- Read an index in presentation f as the index of the same A-element in e.
  presentationChange :
    (e f : A ≃ Fin (suc n)) → Fin (suc n) ≃ Fin (suc n)
  presentationChange e f = compEquiv (invEquiv f) e

  presentationChange-character :
    (e f : A ≃ Fin (suc n)) (i : Fin (suc n))
    → invEq e (equivFun (presentationChange e f) i) ≡ invEq f i
  presentationChange-character e f i = retEq e (invEq f i)

  -- THE PAYOFF: the fold does not privilege either presentation.
  presentation-independent :
    (e f : A ≃ Fin (suc n)) (w : A → W)
    → finiteFold n f w ≡ finiteFold n e w
  presentation-independent e f w =
      total-ext _+ᵂ_ n
        (λ i → w (invEq f i))
        (λ i → w (invEq e (equivFun (presentationChange e f) i)))
        (λ i → cong w (sym (presentationChange-character e f i)))
    ∙ permutation-invariant _+ᵂ_ assoc comm n
        (presentationChange e f)
        (λ i → w (invEq e i))
