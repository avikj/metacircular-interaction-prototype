{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- LosslessTransportReturnsTheObjectWithAllItsFibers
--
-- The univalent dependent codec.  A reversible recoding e : A ≃ B is not
-- an external agreement that A and B "represent the same thing"; by
-- univalence it is an identity along which every dependent object
-- transports.  A value-only codec is insufficient: the entire dependent
-- neighbourhood must return.
--
-- Given a fibre family P : A → Type (invariants, proofs, the object's
-- relationships to its surroundings), the codec carries a dependent datum
-- (x , p) — value AND fibre — and this file proves it is LOSSLESS: it is
-- an equivalence
--
--     Σ A P  ≃  Σ B (P ∘ e⁻¹),
--
-- so the round trip returns (x , p), the datum together with all of its
-- fibre.  "Lossless transport means the object returns together with all
-- its fibers."
--
-- Machine-checked, Agda 2.8.0 + cubical v0.9, --safe, no postulates.
------------------------------------------------------------------------

module LosslessTransportReturnsTheObjectWithAllItsFibers where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Equiv
open import Cubical.Foundations.Univalence
open import Cubical.Data.Sigma

private variable
  ℓ ℓ' : Level

module _ {A : Type ℓ} {B : Type ℓ} (e : A ≃ B) where

  -- The dependent codec: base recoding e, fibre carried by transporting P
  -- along the univalent identity.  It is an equivalence — nothing in the
  -- fibre is lost.
  dependent-codec : (P : A → Type ℓ')
                  → Σ A P ≃ Σ B (λ b → P (invEq e b))
  dependent-codec P =
    Σ-cong-equiv e (λ a → pathToEquiv (cong P (sym (retEq e a))))

  encode : (P : A → Type ℓ') → Σ A P → Σ B (λ b → P (invEq e b))
  encode P = equivFun (dependent-codec P)

  decode : (P : A → Type ℓ') → Σ B (λ b → P (invEq e b)) → Σ A P
  decode P = invEq (dependent-codec P)

  -- LOSSLESS: the datum and its whole fibre come back.
  round-trip : (P : A → Type ℓ') (xp : Σ A P) → decode P (encode P xp) ≡ xp
  round-trip P = retEq (dependent-codec P)

  -- and the other side.
  round-trip' : (P : A → Type ℓ') (yq : Σ B (λ b → P (invEq e b)))
              → encode P (decode P yq) ≡ yq
  round-trip' P = secEq (dependent-codec P)
