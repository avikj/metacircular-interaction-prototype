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

{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- बहुशाखा — the dependent refinement sums branchwise, and the books
-- balance.
--
-- TERM.  बहु (many) and शाखा (branch — also the word for a recension
-- of a Veda, a branch of the one text).  The compound बहु-शाखा, "the
-- many-branched", is built HERE and no source is claimed for it
-- (CLAUDE.md, naming rule, note 2).
--
-- SEED.  The owner's transmission of 2026-08-23, the Born ladder,
-- steps 3–4, taken at their arithmetic floor.  `SthulaBhara_…` did the
-- BINARY split (two branches, sizes a+1 and b+1).  This module does
-- the general dependent family: a coarse outcome space Fin (suc c),
-- each outcome y refining into suc (k y) microbranches — sizes vary
-- per branch, which is exactly what "replace an outcome by equally
-- weighted microbranches" needs when different outcomes refine
-- differently.
--
-- WHAT IS PROVED (over a bare magma _+ᵂ_; the ledger of algebra spent
-- continues from SamaVibhaga (none) and SthulaBhara (assoc): this
-- module spends NONE — every step is total-ext and total-const).
--
--   शाखायोगः     the nested total of a branchwise-constant refinement
--                is the coarse total of the multiplicities:
--                nested (λ y _ → h y) ≡ total (λ y → (k y + 1)·(h y)).
--   प्रतिष्ठा     refinement preserves the books: if each branch's
--                equal microweights recompose to the coarse weight
--                ((k y + 1)·(h y) ≡ wC y), then the nested micro total
--                IS the coarse total — so normalization transfers,
--                both ways, along refl-composition.
--   समशाखा      the equal-amplitude case (one h for every branch of
--                every outcome): the coarse weight of y is forced to
--                its multiplicity (k y + 1)·h — the exact
--                division-free form of "rational weights by branch
--                multiplicity": m/(m+n) is a name for m·h under total
--                normalization, now over ANY finite family.
--
-- WHAT IS NOT CLAIMED, and it is the quantum boundary, kept open per
-- the transmission's instruction: (1) that a REVERSIBLE transformation
-- realizes a given refinement — that is the physical content of step 3
-- and no part of it is formalized here; (2) enumeration-independence
-- of the nested sum (invariance of total under Fin-equivalences) —
-- that permutation lemma needs commutativity and a punch-out argument
-- and is owed separately; without it, "the" total means the total in
-- the given enumeration.  Steps 3–5 remain open and distinct.
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
  -- weight to its multiplicity, under any normalization 𝟙 of the
  -- micro space.
  समशाखा : (𝟙 : W) (c : ℕ) (k : Fin (suc c) → ℕ) (h : W)
         → शाखितयोगः c k (λ _ _ → h) ≡ 𝟙
         → total _+ᵂ_ c (λ y → गुणः _+ᵂ_ (k y) h) ≡ 𝟙
  समशाखा 𝟙 c k h norm = sym (शाखायोगः c k (λ _ → h)) ∙ norm
