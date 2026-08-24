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
-- BahuShakhaEnumerationIndependenceProbe
--
-- Consequences of the checked `KramaNairapeksya` theorem. These are separated
-- from the generic finite-fold result so the kernel can distinguish a defect
-- in dependent reindexing from the already-closed permutation theorem.
--
-- `BahuShakha.शाखितयोगः` should be independent of:
--
--   * every microbranch enumeration, independently at each coarse outcome;
--   * the outer enumeration of coarse outcomes;
--   * both changes simultaneously.
--
-- This turns its multiplicity law from a theorem about one listed presentation
-- into a theorem about the finite fibres themselves. The only algebra spent is
-- the generic theorem's associativity and commutativity; dependent reindexing
-- itself is `total-ext` plus composition.
--
-- STATUS. Complete no-hole daemon-facing candidate outside `Everything.agda`.
-- The imported generic theorem is checked; only these three consequences await
-- a route-bearing warm Nadi verdict.
------------------------------------------------------------------------

module ShakhitaNairapeksya_TheNestedTotalIsIndifferentToInnerOuterAndSimultaneousReEnumeration where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Equiv using (_≃_ ; equivFun)
open import Cubical.Data.Nat using (ℕ ; suc)
open import Cubical.Data.SumFin using (Fin)

open import SamaVibhaga_TransitiveSymmetryNormalizationAndUniqueDivisionForceTheUniformMeasure
  using (total ; total-ext)
open import BahuShakha_TheDependentRefinementSumsBranchwiseAndTheBooksBalance
  using (शाखितयोगः)
open import KramaNairapeksya_TheTotalIsIndifferentToTheEnumerationSpendingOnlyAssocAndComm
  using (permutation-invariant)

private
  variable
    ℓ : Level

module _ {W : Type ℓ} (_+ᵂ_ : W → W → W)
         (assoc : (x y z : W) → x +ᵂ (y +ᵂ z) ≡ (x +ᵂ y) +ᵂ z)
         (comm  : (x y : W) → x +ᵂ y ≡ y +ᵂ x) where

  -- Every micro-fibre may be re-enumerated by its own equivalence.
  inner-invariant :
    (c : ℕ) (k : Fin (suc c) → ℕ)
    (w : (y : Fin (suc c)) → Fin (suc (k y)) → W)
    (e : (y : Fin (suc c)) → Fin (suc (k y)) ≃ Fin (suc (k y)))
    → शाखितयोगः _+ᵂ_ c k (λ y x → w y (equivFun (e y) x))
      ≡ शाखितयोगः _+ᵂ_ c k w
  inner-invariant c k w e =
    total-ext _+ᵂ_ c
      (λ y → total _+ᵂ_ (k y) (λ x → w y (equivFun (e y) x)))
      (λ y → total _+ᵂ_ (k y) (w y))
      (λ y → permutation-invariant _+ᵂ_ assoc comm (k y) (e y) (w y))

  -- The coarse outcomes themselves may be re-enumerated. Their dependent
  -- branch sizes move with them; no transport cast is needed because the
  -- reindexed family is stated at its actual index.
  outer-invariant :
    (c : ℕ) (k : Fin (suc c) → ℕ)
    (w : (y : Fin (suc c)) → Fin (suc (k y)) → W)
    (e : Fin (suc c) ≃ Fin (suc c))
    → शाखितयोगः _+ᵂ_ c
        (λ y → k (equivFun e y))
        (λ y x → w (equivFun e y) x)
      ≡ शाखितयोगः _+ᵂ_ c k w
  outer-invariant c k w e =
    permutation-invariant _+ᵂ_ assoc comm c e
      (λ y → total _+ᵂ_ (k y) (w y))

  -- Both levels may move at once: first remove every inner enumeration, then
  -- remove the outer one. This is the exact two-level receipt needed by the
  -- branch-refinement/Born lane.
  nested-invariant :
    (c : ℕ) (k : Fin (suc c) → ℕ)
    (w : (y : Fin (suc c)) → Fin (suc (k y)) → W)
    (e : Fin (suc c) ≃ Fin (suc c))
    (r : (y : Fin (suc c))
       → Fin (suc (k (equivFun e y))) ≃ Fin (suc (k (equivFun e y))))
    → शाखितयोगः _+ᵂ_ c
        (λ y → k (equivFun e y))
        (λ y x → w (equivFun e y) (equivFun (r y) x))
      ≡ शाखितयोगः _+ᵂ_ c k w
  nested-invariant c k w e r =
      inner-invariant c
        (λ y → k (equivFun e y))
        (λ y x → w (equivFun e y) x)
        r
    ∙ outer-invariant c k w e
