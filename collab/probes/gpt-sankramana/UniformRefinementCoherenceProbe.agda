{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- UniformRefinementCoherenceProbe
--
-- The finite Born lane now has:
--   * dependent branchwise arithmetic (`BahuShakha`);
--   * enumeration-independence (`KramaNairapeksya`);
--   * rectangular Fubini (`ParivartaYoga`);
--   * a reversible dependent flat register on the Nadi wire
--     (`BahuShakhaSetuProbe`).
--
-- This probe closes the equal-amplitude coherence square for arbitrary
-- dependent branch sizes.  Let each coarse outcome y refine into
-- `suc (k y)` micro-outcomes, all carrying one weight h.  Define
-- `micro-pred c k` so the total number of micro-outcomes is
-- `suc (micro-pred c k)`.  Then:
--
--   nested branch total  ≡  one total over Fin (suc (micro-pred c k)).
--
-- The proof has three independent receipts:
--
--   1. `flat-count`: the dependent Sigma really has that finite cardinality;
--   2. `गुण-संयोजनम्`: two nonempty repeated sums concatenate, spending
--      associativity only;
--   3. `शाखायोगः` + `total-const`: nested constant branches and the flat
--      constant register both reduce to the same repeated sum.
--
-- Canonical order spends ASSOC only.  `KramaNairapeksya` then says every other
-- reversible encoding gives the same flat total, spending COMM to erase the
-- presentation.  Thus algebra and representation costs remain separated.
--
-- WHAT THIS REACHES.
--   * the equal-amplitude Born/refinement coherence square for every finite
--     dependent branch family;
--   * normalization transfers in both directions between nested and flat;
--   * a canonical reversible encoder into exactly the register being summed.
--
-- WHAT THIS DOES NOT CLAIM.
--   * arbitrary nonconstant dependent Fubini remains open;
--   * no Hilbert-space unitary, amplitudes, or physical implementation;
--   * no continuity/noncontextual extension.
--
-- TERM. समशाखा is the checked equal-branch vocabulary; सामञ्जस्य is ordinary
-- Sanskrit for coherence/agreement. The compound is built here; no source is
-- claimed for the theorem.
--
-- STATUS. Complete no-hole daemon-facing candidate outside `Everything.agda`.
-- Not called checked until a route-bearing warm Nadi load answers.
------------------------------------------------------------------------

module UniformRefinementCoherenceProbe where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Equiv using (_≃_ ; compEquiv)
open import Cubical.Foundations.Univalence using (pathToEquiv)
open import Cubical.Data.Nat using (ℕ ; zero ; suc ; _+_)
open import Cubical.Data.Nat.Properties using (+-zero)
open import Cubical.Data.Sigma using (Σ ; Σ-syntax)
open import Cubical.Data.SumFin using (Fin ; fzero ; fsuc ; totalSum)
open import Cubical.Data.SumFin.Properties using (SumFinΣ≃)

open import SamaVibhaga_TransitiveSymmetryNormalizationAndUniqueDivisionForceTheUniformMeasure
  using (total ; गुणः ; total-const)
open import BahuShakha_TheDependentRefinementSumsBranchwiseAndTheBooksBalance
  using (शाखितयोगः ; शाखायोगः)

private
  variable
    ℓ : Level

------------------------------------------------------------------------
-- 1. The predecessor of the total number of dependent micro-outcomes.
------------------------------------------------------------------------

micro-pred : (c : ℕ) → (Fin (suc c) → ℕ) → ℕ
micro-pred zero    k = k fzero
micro-pred (suc c) k =
  k fzero + suc (micro-pred c (λ y → k (fsuc y)))

flat-count : (c : ℕ) (k : Fin (suc c) → ℕ)
  → totalSum (λ y → suc (k y)) ≡ suc (micro-pred c k)
flat-count zero k = +-zero (suc (k fzero))
flat-count (suc c) k =
  cong (λ t → suc (k fzero + t))
       (flat-count c (λ y → k (fsuc y)))

Micro : (c : ℕ) → (Fin (suc c) → ℕ) → Type
Micro c k = Σ[ y ∈ Fin (suc c) ] Fin (suc (k y))

Flat : (c : ℕ) → (Fin (suc c) → ℕ) → Type
Flat c k = Fin (suc (micro-pred c k))

canonical-flatten : (c : ℕ) (k : Fin (suc c) → ℕ)
  → Micro c k ≃ Flat c k
canonical-flatten c k =
  compEquiv (SumFinΣ≃ (suc c) (λ y → suc (k y)))
            (pathToEquiv (cong Fin (flat-count c k)))

------------------------------------------------------------------------
-- 2. Repeated sums concatenate. This is the only W-algebra spent.
------------------------------------------------------------------------

module _ {W : Type ℓ} (_+ᵂ_ : W → W → W)
         (assoc : (x y z : W) → x +ᵂ (y +ᵂ z) ≡ (x +ᵂ y) +ᵂ z) where

  गुण-संयोजनम् : (a b : ℕ) (h : W)
    → गुणः _+ᵂ_ a h +ᵂ गुणः _+ᵂ_ b h
      ≡ गुणः _+ᵂ_ (a + suc b) h
  गुण-संयोजनम् zero    b h = refl
  गुण-संयोजनम् (suc a) b h =
      sym (assoc h (गुणः _+ᵂ_ a h) (गुणः _+ᵂ_ b h))
    ∙ cong (h +ᵂ_) (गुण-संयोजनम् a b h)

  multiplicity-onefold : (c : ℕ) (k : Fin (suc c) → ℕ) (h : W)
    → total _+ᵂ_ c (λ y → गुणः _+ᵂ_ (k y) h)
      ≡ गुणः _+ᵂ_ (micro-pred c k) h
  multiplicity-onefold zero k h = refl
  multiplicity-onefold (suc c) k h =
      cong (गुणः _+ᵂ_ (k fzero) h +ᵂ_)
           (multiplicity-onefold c (λ y → k (fsuc y)) h)
    ∙ गुण-संयोजनम् (k fzero)
        (micro-pred c (λ y → k (fsuc y))) h

  --------------------------------------------------------------------------
  -- 3. THE COHERENCE SQUARE: nested uniform refinement = one flat total.
  --------------------------------------------------------------------------

  समशाखा-सामञ्जस्यम् : (c : ℕ) (k : Fin (suc c) → ℕ) (h : W)
    → शाखितयोगः _+ᵂ_ c k (λ _ _ → h)
      ≡ total _+ᵂ_ (micro-pred c k) (λ _ → h)
  समशाखा-सामञ्जस्यम् c k h =
      शाखायोगः _+ᵂ_ c k (λ _ → h)
    ∙ multiplicity-onefold c k h
    ∙ sym (total-const _+ᵂ_ (micro-pred c k) h)

  nested-normalization→flat : (𝟙 : W)
    (c : ℕ) (k : Fin (suc c) → ℕ) (h : W)
    → शाखितयोगः _+ᵂ_ c k (λ _ _ → h) ≡ 𝟙
    → total _+ᵂ_ (micro-pred c k) (λ _ → h) ≡ 𝟙
  nested-normalization→flat 𝟙 c k h norm =
    sym (समशाखा-सामञ्जस्यम् c k h) ∙ norm

  flat-normalization→nested : (𝟙 : W)
    (c : ℕ) (k : Fin (suc c) → ℕ) (h : W)
    → total _+ᵂ_ (micro-pred c k) (λ _ → h) ≡ 𝟙
    → शाखितयोगः _+ᵂ_ c k (λ _ _ → h) ≡ 𝟙
  flat-normalization→nested 𝟙 c k h norm =
    समशाखा-सामञ्जस्यम् c k h ∙ norm
