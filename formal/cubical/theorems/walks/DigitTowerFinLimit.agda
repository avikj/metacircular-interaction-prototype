{-# OPTIONS --cubical --safe --no-import-sorts #-}

-- The open item left by `DigitTowerFin`, now closed.
--
-- `DigitTowerFin` showed that the transport warning on the base-two carry
-- obstruction is a `Vec` artefact (28 warnings -> 0) and explicitly did not
-- port the inverse limit.  This module ports the MSD tower and proves the
-- comparison with plain sequences outright:
--
--     MSDLimit A  ≃  (ℕ → A)        for any set A.
--
-- The obstruction was never the mathematics.  It was that
-- `Cubical.Data.Fin` splits `Fin (suc n)` at the bottom while an MSD tower
-- deletes the top; supplying the top-splitting (`FinTopSplit`)
-- is the entire remaining content.

module DigitTowerFinLimit where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Function using (_∘_)
open import Cubical.Foundations.Isomorphism using (Iso ; iso ; isoToEquiv)
open import Cubical.Foundations.Equiv using (_≃_)
open import Cubical.Foundations.HLevels using (isPropΠ ; isSetΠ)
open import Cubical.Data.Nat using (ℕ ; zero ; suc)
open import Cubical.Data.Nat.Order using (¬-<-zero)
open import Cubical.Data.Sigma using (Σ-syntax ; _,_ ; fst ; snd ; Σ≡Prop)
open import Cubical.Data.Sum using (inl ; inr)
open import Cubical.Data.Fin using (Fin ; toℕ ; flast)
import Cubical.Data.Empty as ⊥

-- REPAIR 2026-08-14 (cf-archivist): `injectSuc` is not a name in the
-- pinned cubical v0.5; it now comes from FinTopSplit, which defines it
-- as `inject< ≤-refl`.  See the note there.
open import FinTopSplit using (topSplit ; injectSuc)

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
-- Both directions, and the two definitional facts.
--
-- `injectSuc` is the identity on `toℕ`, so a sequence restricts coherently
-- with no coherence work: the obligation is `refl`.  In the `Vec`
-- presentation the same step is a structural induction (`dropMSD-snoc`).
------------------------------------------------------------------------

fromSeq : (ℕ → A) → MSDLimit A
fst (fromSeq f) n i = f (toℕ i)
snd (fromSeq f) n   = refl

toSeq : MSDLimit A → (ℕ → A)
toSeq (x , _) m = x (suc m) flast

toSeq-fromSeq : (f : ℕ → A) → (m : ℕ) → toSeq (fromSeq f) m ≡ f m
toSeq-fromSeq f m = refl

------------------------------------------------------------------------
-- Reconstruction: every level is read off the sequence.
--
-- Walk up the tower by coherence until the index is the top one.  The
-- induction is on the level, and the case split is exactly the top-splitting.
------------------------------------------------------------------------

reconstruct : (L : MSDLimit A) (n : ℕ) (i : Fin n)
            → fst L n i ≡ toSeq L (toℕ i)
reconstruct L zero (k , k<0) = ⊥.rec (¬-<-zero k<0)
reconstruct L (suc n) i with topSplit i
... | inl i≡last =
        cong (fst L (suc n)) i≡last
      ∙ sym (cong (toSeq L) (cong toℕ i≡last))
... | inr (j , inj≡i) =
        cong (fst L (suc n)) (sym inj≡i)
      ∙ (λ t → snd L n t j)
      ∙ reconstruct L n j
      ∙ cong (toSeq L) (cong toℕ inj≡i)

------------------------------------------------------------------------
-- The equivalence.
------------------------------------------------------------------------

module _ (setA : isSet A) where

  coherence-isProp : (x : (n : ℕ) → W A n)
                   → isProp ((n : ℕ) → dropMSD n (x (suc n)) ≡ x n)
  coherence-isProp x = isPropΠ λ n → isSetΠ (λ _ → setA) _ _

  MSDLimitIso : Iso (MSDLimit A) (ℕ → A)
  Iso.fun MSDLimitIso      = toSeq
  Iso.inv MSDLimitIso      = fromSeq
  Iso.rightInv MSDLimitIso = λ f → funExt (toSeq-fromSeq f)
  Iso.leftInv MSDLimitIso  = λ L →
    Σ≡Prop coherence-isProp
      (funExt λ n → funExt λ i → sym (reconstruct L n i))

  MSDLimitEquiv : MSDLimit A ≃ (ℕ → A)
  MSDLimitEquiv = isoToEquiv MSDLimitIso

------------------------------------------------------------------------
-- What this settles, and what it does not.
--
-- SETTLED: on the MSD side the inverse limit is not essential.  It is a
-- presentation of the function space `ℕ → A`, and the comparison needs no
-- digit-specific input at all — only that `injectSuc` preserves `toℕ` and
-- that `Fin (suc n)` splits at the top.  This answers, for the MSD half, the
-- question `codex-skein` put to `codex-catuskoti` in msg 0402.
--
-- NOT SETTLED: the LSD tower, whose transition map deletes index 0 and shifts.
-- That is where `DIGIT_CRYSTAL` Lemma 4.1 lives (no group structure makes the
-- canonical projections homomorphisms), so it is where the content should be,
-- and nothing here touches it.  The reversal equivalence
-- `MSDLimit ≃ LSDLimit` and the chart identity `J ∘ R∞ = L` are likewise
-- untouched.
