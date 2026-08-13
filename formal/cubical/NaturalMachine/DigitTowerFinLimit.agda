{-# OPTIONS --cubical --safe --no-import-sorts #-}

-- Attempt at the open item left by `NaturalMachine.DigitTowerFin`:
-- does the *inverse limit* also behave under the function presentation?
--
-- `DigitTowerFin` showed the transport warning on the base-two carry
-- obstruction is a `Vec` artefact (28 warnings -> 0).  It explicitly did not
-- port `InvLim` or the reversal equivalence.  This file takes the first step:
-- the MSD tower, whose transition map deletes the *most* significant digit.

module NaturalMachine.DigitTowerFinLimit where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Function using (_∘_)
open import Cubical.Foundations.Isomorphism using (Iso ; iso ; isoToEquiv)
open import Cubical.Foundations.Equiv using (_≃_)
open import Cubical.Data.Nat using (ℕ ; zero ; suc)
open import Cubical.Data.Sigma using (Σ-syntax ; _,_ ; fst ; snd)
open import Cubical.Data.Fin using (Fin ; toℕ ; injectSuc ; flast)

private
  variable
    ℓ : Level
    A : Type ℓ

------------------------------------------------------------------------
-- Digit words as functions; deletion as precomposition.
------------------------------------------------------------------------

W : Type ℓ → ℕ → Type ℓ
W A n = Fin n → A

-- Delete the most significant digit: restrict along Fin n ↪ Fin (suc n).
dropMSD : (n : ℕ) → W A (suc n) → W A n
dropMSD n w = w ∘ injectSuc

InvLim : (X : ℕ → Type ℓ) → ((n : ℕ) → X (suc n) → X n) → Type ℓ
InvLim X step = Σ[ x ∈ ((n : ℕ) → X n) ]
                  ((n : ℕ) → step n (x (suc n)) ≡ x n)

MSDLimit : Type ℓ → Type ℓ
MSDLimit A = InvLim (W A) dropMSD

------------------------------------------------------------------------
-- The comparison with plain sequences.
--
-- `injectSuc` is the identity on the underlying natural number, so a
-- sequence restricts coherently with no coherence work at all: the proof
-- obligation is `refl`.  That is the whole point of the presentation --
-- in the `Vec` version the corresponding step is a structural induction.
------------------------------------------------------------------------

fromSeq : (ℕ → A) → MSDLimit A
fst (fromSeq f) n i = f (toℕ i)
snd (fromSeq f) n   = refl

-- Evaluation in the other direction: read digit m off the level where it is
-- the top index.  `toℕ (flast {m}) ≡ m` holds by construction.
toSeq : MSDLimit A → (ℕ → A)
toSeq (x , _) m = x (suc m) flast

-- One round trip is definitional.
toSeq-fromSeq : (f : ℕ → A) → (m : ℕ) → toSeq (fromSeq f) m ≡ f m
toSeq-fromSeq f m = refl

------------------------------------------------------------------------
-- What is and is not established here, stated precisely.
--
-- DEFINITIONAL, above, with no induction and no lemma:
--   * the coherence obligation of `fromSeq` is `refl`, because `injectSuc`
--     is the identity on `toℕ`.  In the `Vec` presentation the same step is
--     a structural induction (`dropMSD-snoc`).
--   * `toSeq ∘ fromSeq ≡ id` pointwise is `refl`, because
--     `toℕ (flast {m}) ≡ m` by construction.
--
-- OPEN: `fromSeq ∘ toSeq ≡ id`, i.e.
--
--     (L : MSDLimit A) (n : ℕ) (i : Fin n) → fst L n i ≡ toSeq L (toℕ i)
--
-- The mathematics is routine: coherence gives `fst L n i ≡ fst L (suc n)
-- (injectSuc i)` and `injectSuc` preserves `toℕ`, so one walks up to the
-- level where `i` is the top index and appeals to `toℕ`-injectivity of `Fin`.
--
-- The obstruction is a MISSING LEMMA, not a difficulty: the induction needs
-- to split `Fin (suc n)` at the TOP,
--
--     (i : Fin (suc n)) → (i ≡ flast) ⊎ (Σ[ j ∈ Fin n ] injectSuc j ≡ i),
--
-- whereas `Cubical.Data.Fin` supplies `fsplit`, which splits at the BOTTOM
-- (`fzero` versus `fsuc`).  The MSD tower deletes the top; the library's
-- eliminator opens the bottom.  Supplying that top-splitting is the whole of
-- the remaining work, and it is a `Fin` lemma with no digits in it.
--
-- Recording this rather than half-proving it: the two definitional facts are
-- real and are the point (they are what the `Vec` presentation pays induction
-- for), and the third is named with its exact missing ingredient.
