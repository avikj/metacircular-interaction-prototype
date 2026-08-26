{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- ClosureTowerCollapse
--
-- checked term rather than a paragraph.
--
-- §0) erects a transfinite tower
--
--     Θ_{ν+1} := κ(Θ_ν),   Θ_λ := ⋃_{ν<λ} Θ_ν,   Θ_∞ := ⋃_λ Θ_λ
--
-- over the map κ(Θ) = ⋂ { Υ ⊇ Θ | Υ closed under the nine operations }.
-- The tower is constant from stage one, because κ is a closure operator:
-- an intersection of closed sets is closed, so κ(Θ) is itself closed, so
-- it is the LEAST closed superset of itself, so κ∘κ = κ.
--
-- What is proved below, for an arbitrary signature of binary and unary
-- operations on an arbitrary type:
--
--   ⟪⟫-infl      S ⊆ ⟪ S ⟫                      (inflationary)
--   ⟪⟫-closed    ClosedUnder ⟪ S ⟫              (κ lands in the closed sets)
--   ⟪⟫-least     S ⊆ U → ClosedUnder U → ⟪ S ⟫ ⊆ U
--                                                (the universal property)
--   ⟪⟫-mono      S ⊆ T → ⟪ S ⟫ ⊆ ⟪ T ⟫          (monotone)
--   ⟪⟫-idem      ⟪ ⟪ S ⟫ ⟫ ≡ ⟪ S ⟫              (Proposition 1's engine)
--   tower-const  Θ S (suc n) ≡ Θ S 1            (Proposition 1)
--   tower-limit  Θ S (suc n) ≡ ⟪ S ⟫            (so every limit stage, being
--                                                a union of a constant chain,
--                                                is ⟪ S ⟫ as well)
--
-- and `seed-tower-const`, the same statement at the source's own signature:
-- three binary operations (⊕ ⊗ ∘) and six unary ones (∂ δ Γ Φ (-)^∨ ⌜-⌝).
--
-- ON THE INTERSECTION.  The source's κ is written as an intersection over
-- ALL supersets Υ, which is impredicative: at a fixed universe ℓ that
-- quantifier ranges over ℙ A : Type (ℓ-suc ℓ), so the result does not land
-- in ℙ A and the tower Θ_{ν+1} := κ(Θ_ν) does not even typecheck without
-- propositional resizing.  `⟪_⟫` below is the predicative rendering: the
-- closure is generated inductively and truncated, and `⟪⟫-least` proves it
-- has exactly the universal property the intersection was there to supply
-- — it IS the least closed superset.  Nothing is assumed that the source
-- constructed; the construction is carried out at a level where iterating
-- it is meaningful.  That the impredicative form does not typecheck is a
-- second, independent reason the transfinite ladder is not doing work.
------------------------------------------------------------------------

module ClosureTowerCollapse where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.HLevels
open import Cubical.Foundations.Powerset
open import Cubical.Data.Nat using (ℕ; zero; suc)
open import Cubical.Data.Sigma
open import Cubical.HITs.PropositionalTruncation
  using (∥_∥₁; ∣_∣₁; squash₁; rec; rec2)

private
  variable
    ℓ : Level

------------------------------------------------------------------------
-- A signature: `I` binary operations and `J` unary ones on `A`.

module Signature {A : Type ℓ} {I J : Type ℓ}
                 (bin : I → A → A → A)
                 (un  : J → A → A) where

  ----------------------------------------------------------------------
  -- closed subsets

  ClosedUnder : ℙ A → Type ℓ
  ClosedUnder U =
      ((i : I) (a b : A) → a ∈ U → b ∈ U → bin i a b ∈ U)
    × ((j : J) (a : A) → a ∈ U → un j a ∈ U)

  isPropClosedUnder : (U : ℙ A) → isProp (ClosedUnder U)
  isPropClosedUnder U =
    isProp×
      (isPropΠ5 λ i a b _ _ → ∈-isProp U (bin i a b))
      (isPropΠ3 λ j a _ → ∈-isProp U (un j a))

  ----------------------------------------------------------------------
  -- the closure, generated

  data Gen (S : ℙ A) : A → Type ℓ where
    incl : {a : A}   → a ∈ S → Gen S a
    genB : (i : I) {a b : A} → Gen S a → Gen S b → Gen S (bin i a b)
    genU : (j : J) {a : A}   → Gen S a → Gen S (un j a)

  ⟪_⟫ : ℙ A → ℙ A
  ⟪ S ⟫ a = ∥ Gen S a ∥₁ , squash₁

  ----------------------------------------------------------------------
  -- the three closure-operator laws

  ⟪⟫-infl : (S : ℙ A) → S ⊆ ⟪ S ⟫
  ⟪⟫-infl S a x = ∣ incl x ∣₁

  ⟪⟫-closed : (S : ℙ A) → ClosedUnder ⟪ S ⟫
  ⟪⟫-closed S =
      (λ i a b p q → rec2 squash₁ (λ p' q' → ∣ genB i p' q' ∣₁) p q)
    , (λ j a p     → rec  squash₁ (λ p'    → ∣ genU j p'    ∣₁) p)

  -- the universal property the source's intersection was there to supply
  ⟪⟫-least : (S U : ℙ A) → S ⊆ U → ClosedUnder U → ⟪ S ⟫ ⊆ U
  ⟪⟫-least S U S⊆U (cB , cU) a = rec (∈-isProp U a) (go a)
    where
    go : (a : A) → Gen S a → a ∈ U
    go a (incl x)                = S⊆U a x
    go _ (genB i {a} {b} p q)    = cB i a b (go a p) (go b q)
    go _ (genU j {a}   p)        = cU j a   (go a p)

  ⟪⟫-mono : (S T : ℙ A) → S ⊆ T → ⟪ S ⟫ ⊆ ⟪ T ⟫
  ⟪⟫-mono S T S⊆T =
    ⟪⟫-least S ⟪ T ⟫ (λ a x → ⟪⟫-infl T a (S⊆T a x)) (⟪⟫-closed T)

  -- Proposition 1's engine: κ(Θ) is closed, hence its own least closed
  -- superset, hence κ∘κ = κ.
  ⟪⟫-idem : (S : ℙ A) → ⟪ ⟪ S ⟫ ⟫ ≡ ⟪ S ⟫
  ⟪⟫-idem S =
    ⊆-antisym ⟪ ⟪ S ⟫ ⟫ ⟪ S ⟫
      (⟪⟫-least ⟪ S ⟫ ⟪ S ⟫ (⊆-refl ⟪ S ⟫) (⟪⟫-closed S))
      (⟪⟫-infl ⟪ S ⟫)

  ----------------------------------------------------------------------
  -- the tower

  Θ : ℙ A → ℕ → ℙ A
  Θ S zero    = S
  Θ S (suc n) = ⟪ Θ S n ⟫

  -- Proposition 1.  Every stage above the zeroth is the first.
  tower-limit : (S : ℙ A) (n : ℕ) → Θ S (suc n) ≡ ⟪ S ⟫
  tower-limit S zero    = refl
  tower-limit S (suc n) =
    cong ⟪_⟫ (tower-limit S n) ∙ ⟪⟫-idem S

  tower-const : (S : ℙ A) (n : ℕ) → Θ S (suc n) ≡ Θ S 1
  tower-const S n = tower-limit S n ∙ sym (tower-limit S zero)

  -- Hence a limit stage ⋃_{ν<λ} Θ_ν adds nothing: the chain it unions is
  -- constant, so Θ_λ = Θ_1 = Θ_∞, and the transfinite ladder above stage
  -- one is empty.  `tower-limit` is that statement; the union itself needs
  -- no separate proof because a union of a constant family of subsets is
  -- that subset.

------------------------------------------------------------------------
-- The source's own signature: §0's nine operations, three binary and six
-- unary.  ⊕ ⊗ ∘ / ∂ δ Γ Φ (-)^∨ ⌜-⌝.

-- `after` is the source's `∘`; the name `comp` is taken by a cubical
-- primitive (Cubical.Core.Primitives), and `∘` by function composition.
data Op₂ : Type₀ where
  oplus otimes after : Op₂

data Op₁ : Type₀ where
  boundary defect generate transform dual quoted : Op₁

module Seed {A : Type₀}
            (bin : Op₂ → A → A → A)
            (un  : Op₁ → A → A) where

  open Signature bin un public

  -- Θ_1 = Θ_2 = ⋯ = Θ_∞ for the seed grammar itself.
  seed-tower-const : (S : ℙ A) (n : ℕ) → Θ S (suc n) ≡ Θ S 1
  seed-tower-const = tower-const
