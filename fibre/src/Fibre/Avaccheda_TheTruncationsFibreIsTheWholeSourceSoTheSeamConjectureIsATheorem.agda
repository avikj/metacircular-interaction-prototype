{-# OPTIONS --cubical --safe --guardedness #-}

------------------------------------------------------------------------
-- Punarāgamana · अवच्छेदः — the seam, closed.
--
-- `SakalaVikalaDesa_…` wrote, of the distinction between levels ३ and ४
-- of its five-level scale: its candidate criterion "rests on an
-- unchecked conjecture, `(x : ∥ A ∥₁) → fibre ∣_∣₁ x ≃ A`."  It is not a
-- conjecture.  The fibre of the truncation map over any point is the
-- whole source: a point of the fibre is a source element together with
-- a path in a proposition, and paths in a proposition are contractible.
--
--   अवच्छेदः : (x : ∥ A ∥₁) → fiber ∣_∣₁ x ≃ A
--
-- So at level ४ the fibre is the WHOLE of the source, on the nose, and
-- the census's `विकलादेश` (two distinct points of the fibre) is inhabited
-- at every point as soon as A has two distinct points — which is the
-- "crowded" reading of the truncation, not a coarse one.
--
-- The parent corpus holds the same fact as
-- `theorems/residue/Avacchedaka_TheTruncationsFibreIsTheWholeSource…`;
-- it is restated here because this library takes no dependency outside
-- itself, and a seam should not be closed by prose.
------------------------------------------------------------------------

module Fibre.Avaccheda_TheTruncationsFibreIsTheWholeSourceSoTheSeamConjectureIsATheorem where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Equiv using (_≃_ ; fiber)
open import Cubical.Foundations.Isomorphism using (isoToEquiv ; iso)
open import Cubical.Data.Sigma using (_,_ ; fst ; snd ; ΣPathP)
open import Cubical.Data.Bool using (Bool ; true ; false ; true≢false)
open import Cubical.Relation.Nullary using (¬_)
open import Cubical.HITs.PropositionalTruncation using (∥_∥₁ ; ∣_∣₁ ; squash₁)

private
  variable
    ℓ : Level

-- the fibre of the truncation over any point is the whole source
अवच्छेदः : {A : Type ℓ} (x : ∥ A ∥₁) → fiber ∣_∣₁ x ≃ A
अवच्छेदः {A = A} x = isoToEquiv (iso fst back sec ret)
  where
  back : A → fiber ∣_∣₁ x
  back a = a , squash₁ ∣ a ∣₁ x

  sec : (a : A) → fst (back a) ≡ a
  sec a = refl

  ret : (p : fiber ∣_∣₁ x) → back (fst p) ≡ p
  ret p = ΣPathP (refl , isProp→isSet squash₁ _ _ _ _)

-- hence any two distinct source points are two distinct points of every
-- fibre: the truncation is crowded wherever the source is
द्वयम् : {A : Type ℓ} (x : ∥ A ∥₁) (a b : A) → ¬ (a ≡ b)
       → ¬ ((a , squash₁ ∣ a ∣₁ x) ≡ (b , squash₁ ∣ b ∣₁ x))
द्वयम् x a b ne e = ne (cong fst e)

-- the two-point instance the census used, at the truncation of Bool
बूल-द्वयम् : (x : ∥ Bool ∥₁) → ¬ ((true , squash₁ ∣ true ∣₁ x) ≡ (false , squash₁ ∣ false ∣₁ x))
बूल-द्वयम् x = द्वयम् x true false true≢false
