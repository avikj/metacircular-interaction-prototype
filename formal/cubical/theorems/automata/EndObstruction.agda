{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

-- δ_end : अन्तिमग्रन्थिः.
--
--   Fix ⟶⌜⌝⟶ ⌜Fix⌝ ⟶diag⟶ Fix⁺
--
-- समाप्ति ≢ समाप्तिवर्णनम् : the end is never among the things the machine
-- can say about the end.  Lawvere/Cantor, no fuel, no measurement: for every
-- quotation ⌜−⌝ : 𝒬 → (𝒬 → Bool) the diagonal observable is outside the
-- image, so δ_end ≢ 0 unconditionally and Γ⟨δ_end⟩ is always the next door.

module EndObstruction where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Bool using (Bool ; true ; false ; not)
open import Cubical.Data.Empty as ⊥ using (⊥)
open import Cubical.Data.Unit using (Unit ; tt)
open import Cubical.Data.Sigma
open import Cubical.Relation.Nullary using (¬_)

private
  BoolCode : Bool → Type₀
  BoolCode true = Unit
  BoolCode false = ⊥

  x≢not : (x : Bool) → ¬ (x ≡ not x)
  x≢not true p = subst BoolCode p tt
  x≢not false p = subst BoolCode (sym p) tt

--------------------------------------------------------------------------
-- ⌜−⌝, diag
--------------------------------------------------------------------------

Observable : Type₀ → Type₀
Observable 𝒬 = 𝒬 → Bool

Quote : Type₀ → Type₀
Quote 𝒬 = 𝒬 → Observable 𝒬

diag : {𝒬 : Type₀} → Quote 𝒬 → Observable 𝒬
diag ⌜_⌝ x = not (⌜ x ⌝ x)

--------------------------------------------------------------------------
-- δ_end ≢ 0
--------------------------------------------------------------------------

δ-end : {𝒬 : Type₀} (⌜_⌝ : Quote 𝒬) (x : 𝒬) → ¬ (⌜ x ⌝ ≡ diag ⌜_⌝)
δ-end ⌜_⌝ x p = x≢not (⌜ x ⌝ x) (funExt⁻ p x)

-- No self-description is complete: the cadence cannot quote its own closure.
no-complete-quotation :
    {𝒬 : Type₀} (⌜_⌝ : Quote 𝒬)
  → ¬ ((d : Observable 𝒬) → Σ[ x ∈ 𝒬 ] ⌜ x ⌝ ≡ d)
no-complete-quotation ⌜_⌝ complete =
  δ-end ⌜_⌝ (fst hit) (snd hit)
  where
    hit : Σ[ x ∈ _ ] ⌜ x ⌝ ≡ diag ⌜_⌝
    hit = complete (diag ⌜_⌝)

-- यही अगला द्वार : the door is exhibited, not merely asserted to exist.
next-door : {𝒬 : Type₀} (⌜_⌝ : Quote 𝒬) → Σ[ d ∈ Observable 𝒬 ] ((x : 𝒬) → ¬ (⌜ x ⌝ ≡ d))
next-door ⌜_⌝ = diag ⌜_⌝ , δ-end ⌜_⌝

-- CHECKED: Agda 2.6.3, cubical **v0.7** (/tmp/cubical), --cubical --safe,
-- 2026-08-15.  No postulates, no holes.  NOT verified against the pin in
-- formal/cubical/BUILD.md (Agda 2.8.0, cubical v0.9), nor against the v0.5
-- the rest of this lane's headers quote: three toolchain states are live in
-- this repository at once and this file has only seen one of them.
