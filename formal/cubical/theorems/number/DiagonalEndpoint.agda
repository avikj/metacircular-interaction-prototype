{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- DiagonalEndpoint
--
-- Factory VI's diagonal endpoint compiler.  The analytic work is deliberately
-- proof-relevant input: a family supplies a near-boundary witness at the
-- scale-selected index, and a subcritical certificate proves that its factor
-- is below the least permitted non-unit.  The compiler then uses the exact
-- discrete gap to return the unit boundary.  No prime theorem is postulated.
------------------------------------------------------------------------

module DiagonalEndpoint where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (ℕ)
open import Cubical.Data.Nat.Order using (_≤_ ; _<_ ; ≤-trans ; ¬m<m)
open import Cubical.Data.Sum using (_⊎_ ; inl ; inr)
open import Cubical.Data.Empty as Empty using (⊥ ; rec)
open import Cubical.Data.Sigma using (Σ-syntax ; fst ; _,_)

record FactorState (m⋆ : ℕ) : Type₀ where
  field
    factor : ℕ
    -- The completed factor field has a discrete unit/non-unit split.
    gap : (factor ≡ 1) ⊎ (m⋆ ≤ factor)

record NearFamily (m⋆ : ℕ) : Type₁ where
  field
    threshold : ℕ → ℕ
    -- The near-boundary theorem itself.  Its concrete arithmetic meaning
    -- (a ≤ b^(1/m), factor share, etc.) belongs to the instance.
    near : (m : ℕ) → (x : ℕ) → threshold m ≤ x → Type₀
    witness : (m : ℕ) → (x : ℕ) → (h : threshold m ≤ x) →
      Σ[ state ∈ FactorState m⋆ ] near m x h

record DiagonalCertificate {m⋆ : ℕ}
  (F : NearFamily m⋆) : Type₀ where
  field
    choose : ℕ → ℕ
    applicable : (x : ℕ) → NearFamily.threshold F (choose x) ≤ x
    -- This is the exact subcritical threshold-growth conclusion: after
    -- diagonal choice, the supplied near-boundary estimate is absolutely
    -- below the discrete gap.  It is not hidden in an unproved real limit.
    small : (x : ℕ) →
      FactorState.factor
        (fst (NearFamily.witness F (choose x) x (applicable x))) < m⋆

UnitWitness : {m⋆ : ℕ} → FactorState m⋆ → Type₀
UnitWitness state = FactorState.factor state ≡ 1

-- The compiler is a total, proof-relevant operation.  Its only impossible
-- branch is the non-unit side of the completed factor gap.
DiagonalEndpoint : {m⋆ : ℕ}
  (F : NearFamily m⋆) → (C : DiagonalCertificate F) →
  (x : ℕ) → UnitWitness
    (fst (NearFamily.witness F
      (DiagonalCertificate.choose C x) x
      (DiagonalCertificate.applicable C x)))
DiagonalEndpoint F C x with
  FactorState.gap
    (fst (NearFamily.witness F (DiagonalCertificate.choose C x) x
      (DiagonalCertificate.applicable C x)))
... | inl unit = unit
... | inr nonunit = Empty.rec (¬m<m
    (≤-trans (DiagonalCertificate.small C x) nonunit))

-- A small exact control: once a certificate has selected a factor below 2,
-- the completed field is forced onto its prime/unit boundary.
binary-gap-control : {a : ℕ} →
  (a ≡ 1) ⊎ (2 ≤ a) → a < 2 → a ≡ 1
binary-gap-control gap small with gap
... | inl unit = unit
... | inr nonunit = Empty.rec (¬m<m (≤-trans small nonunit))
