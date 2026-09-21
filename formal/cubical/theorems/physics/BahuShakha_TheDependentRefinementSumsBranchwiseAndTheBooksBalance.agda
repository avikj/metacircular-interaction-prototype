{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- �������� � the dependent refinement sums branchwise, and the books
-- balance.
--
-- TERM.  ��� (many) and ����� (branch � also the word for a recension
-- of a Veda, a branch of the one text).  The compound ���-�����, "the
-- many-branched", is built HERE.
--
-- SEED.  The Born ladder,
-- steps 3�4, taken at their arithmetic floor.  `SthulaBhara_�` did the
-- BINARY split (two branches, sizes a+1 and b+1).  This module does
-- the general dependent family: a coarse outcome space Fin (suc c),
-- each outcome y refining into suc (k y) microbranches � sizes vary
-- per branch, which is exactly what "replace an outcome by equally
-- weighted microbranches" needs when different outcomes refine
-- differently.
--
-- WHAT IS PROVED (over a bare magma _+�_; the ledger of algebra spent
-- continues from SamaVibhaga (none) and SthulaBhara (assoc): this
-- module spends NONE � every step is total-ext and total-const).
--
--   �����������     the nested total of a branchwise-constant refinement
--                is the coarse total of the multiplicities:
--                nested (λ y _ � h y) ≡ total (λ y � (k y + 1)�(h y)).
--   ���������     refinement preserves the books: if each branch's
--                equal microweights recompose to the coarse weight
--                ((k y + 1)�(h y) ≡ wC y), then the nested micro total
--                IS the coarse total � so normalization transfers,
--                both ways, along refl-composition.
--   �������      the equal-amplitude case (one h for every branch of
--                every outcome): the coarse weight of y is forced to
--                its multiplicity (k y + 1)�h � the exact
--                division-free form of "rational weights by branch
--                multiplicity": m/(m+n) is a name for m�h under total
--                normalization, now over ANY finite family.
--
------------------------------------------------------------------------

module BahuShakha_TheDependentRefinementSumsBranchwiseAndTheBooksBalance where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (ℕ ; zero ; suc)
open import Cubical.Data.SumFin using (Fin ; fzero ; fsuc)

open import SamaVibhaga_TransitiveSymmetryNormalizationAndUniqueDivisionForceTheUniformMeasure
  using (total ; गुणः ; total-ext ; total-const)

private
  variable
    ℓ : Level

module _ {W : Type ℓ} (_+ᵂ_ : W → W → W) where

  -- the nested total: sum each outcome's branches, then sum outcomes.
  शाखितयोगः : (c : ℕ) (k : Fin (suc c) → ℕ)
            → ((y : Fin (suc c)) → Fin (suc (k y)) → W) → W
  शाखितयोगः c k w = total _+ᵂ_ c (λ y → total _+ᵂ_ (k y) (w y))

  -- branchwise-constant refinement sums to the multiplicities.
  शाखायोगः : (c : ℕ) (k : Fin (suc c) → ℕ) (h : Fin (suc c) → W)
           → शाखितयोगः c k (λ y _ → h y)
             ≡ total _+ᵂ_ c (λ y → गुणः _+ᵂ_ (k y) (h y))
  शाखायोगः c k h =
    total-ext _+ᵂ_ c (λ y → total _+ᵂ_ (k y) (λ _ → h y))
                     (λ y → गुणः _+ᵂ_ (k y) (h y))
                     (λ y → total-const _+ᵂ_ (k y) (h y))

  -- refinement preserves the books: branch recomposition equations
  -- carry the nested micro total onto the coarse total.
  प्रतिष्ठा : (c : ℕ) (k : Fin (suc c) → ℕ)
            (h : Fin (suc c) → W) (wC : Fin (suc c) → W)
          → ((y : Fin (suc c)) → गुणः _+ᵂ_ (k y) (h y) ≡ wC y)
          → शाखितयोगः c k (λ y _ → h y) ≡ total _+ᵂ_ c wC
  प्रतिष्ठा c k h wC branch =
      शाखायोगः c k h
    ∙ total-ext _+ᵂ_ c (λ y → गुणः _+ᵂ_ (k y) (h y)) wC branch

  -- the equal-amplitude case: one h everywhere forces every coarse
  -- weight to its multiplicity, under any normalization � of the
  -- micro space.
  समशाखा : (𝟙 : W) (c : ℕ) (k : Fin (suc c) → ℕ) (h : W)
         → शाखितयोगः c k (λ _ _ → h) ≡ 𝟙
         → total _+ᵂ_ c (λ y → गुणः _+ᵂ_ (k y) h) ≡ 𝟙
  समशाखा 𝟙 c k h norm = sym (शाखायोगः c k (λ _ → h)) ∙ norm
