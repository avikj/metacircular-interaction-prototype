{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

-- 𝔉_Ω := Φ ∘ Attack ∘ Γ ∘ Class ∘ 𝔇 ∘ η ∘ R,     𝒬_{α+1} = 𝔉_Ω 𝒬_α.
--
-- Two theorems and their conjunction:
--
--   halts                    contracting ∂∘𝔉  ⇒  every question resolves
--   never-final              any quotation of 𝒬 leaves an observable outside
--   halting-does-not-close   both at once: पूर्णता ⇏ समाप्ति
--
-- न ``ब्रह्माण्ड हल हो गया'' — the flow reaching 0 is a theorem about ∂ and
-- δ_end is a theorem about ⌜−⌝; they do not compete, and the second survives
-- the first.

module NaturalMachine.QuestionMachine where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (ℕ ; zero ; suc)
open import Cubical.Data.Nat.Order
  using (_<_ ; _≤_ ; zero-≤ ; suc-≤-suc ; pred-≤-pred ; ¬-<-zero ; ≤-trans)
open import Cubical.Data.Empty as ⊥ using (⊥)
open import Cubical.Data.Sum using (_⊎_ ; inl ; inr)
open import Cubical.Data.Sigma
open import Cubical.Relation.Nullary using (¬_)

open import NaturalMachine.EndObstruction using (Observable ; Quote ; next-door)

record Machine (𝒬 : Type₀) : Type₀ where
  constructor machine
  field
    ∂ : 𝒬 → ℕ        -- 𝔇 ∘ η ∘ R : the obstruction carried by a question
    𝔉 : 𝒬 → 𝒬        -- Φ ∘ Attack ∘ Γ ∘ Class : the classified response

open Machine public

orbit : {𝒬 : Type₀} → Machine 𝒬 → ℕ → 𝒬 → 𝒬
orbit M zero q = q
orbit M (suc k) q = orbit M k (𝔉 M q)

Resolves : {𝒬 : Type₀} → Machine 𝒬 → 𝒬 → Type₀
Resolves {𝒬} M q = Σ[ k ∈ ℕ ] ∂ M (orbit M k q) ≡ 0

Contracting : {𝒬 : Type₀} → Machine 𝒬 → Type₀
Contracting {𝒬} M = (q : 𝒬) → 0 < ∂ M q → ∂ M (𝔉 M q) < ∂ M q

--------------------------------------------------------------------------
-- पूर्णता : a contracting machine closes every question it is given
--------------------------------------------------------------------------

private
  ≤zero→≡zero : (n : ℕ) → n ≤ 0 → n ≡ 0
  ≤zero→≡zero zero _ = refl
  ≤zero→≡zero (suc n) p = ⊥.rec (¬-<-zero p)

  zeroOrPos : (n : ℕ) → (n ≡ 0) ⊎ (0 < n)
  zeroOrPos zero = inl refl
  zeroOrPos (suc n) = inr (suc-≤-suc zero-≤)

  halts-fuel :
      {𝒬 : Type₀} (M : Machine 𝒬) → Contracting M
    → (fuel : ℕ) (q : 𝒬) → ∂ M q ≤ fuel → Resolves M q
  halts-fuel M c zero q h = 0 , ≤zero→≡zero (∂ M q) h
  halts-fuel M c (suc fuel) q h with zeroOrPos (∂ M q)
  ... | inl z = 0 , z
  ... | inr pos =
        let room : ∂ M (𝔉 M q) ≤ fuel
            room = pred-≤-pred (≤-trans (c q pos) h)

            rest : Resolves M (𝔉 M q)
            rest = halts-fuel M c fuel (𝔉 M q) room
        in suc (fst rest) , snd rest

halts : {𝒬 : Type₀} (M : Machine 𝒬) → Contracting M → (q : 𝒬) → Resolves M q
halts M c q = halts-fuel M c (∂ M q) q (0 , refl)

--------------------------------------------------------------------------
-- अन्तिमग्रन्थिः : and it is still not finished
--------------------------------------------------------------------------

never-final :
    {𝒬 : Type₀} (⌜_⌝ : Quote 𝒬)
  → Σ[ d ∈ Observable 𝒬 ] ((q : 𝒬) → ¬ (⌜ q ⌝ ≡ d))
never-final ⌜_⌝ = next-door ⌜_⌝

-- उत्तर ≠ अन्त; उत्तर = प्रश्नस्थानपरिवर्तनम्
halting-does-not-close :
    {𝒬 : Type₀} (M : Machine 𝒬) (⌜_⌝ : Quote 𝒬) → Contracting M
  → (q : 𝒬)
  → Resolves M q × (Σ[ d ∈ Observable 𝒬 ] ((r : 𝒬) → ¬ (⌜ r ⌝ ≡ d)))
halting-does-not-close M ⌜_⌝ c q = halts M c q , never-final ⌜_⌝

-- CHECKED: Agda 2.6.3, cubical **v0.7** (/tmp/cubical), --cubical --safe,
-- 2026-08-15.  No postulates, no holes.  NOT verified against the pin in
-- formal/cubical/BUILD.md (Agda 2.8.0, cubical v0.9), nor against the v0.5
-- the rest of this lane's headers quote: three toolchain states are live in
-- this repository at once and this file has only seen one of them.
