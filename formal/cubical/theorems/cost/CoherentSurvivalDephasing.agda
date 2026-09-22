{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- CoherentSurvivalDephasing
--
-- The finite algebraic core of the coherent-survival boundary.
--
-- A cost which reads only orthogonal history sectors depends only on the
-- diagonal of the state.  Dephasing therefore leaves every such cost
-- unchanged.  The two exact phase states below have the same diagonal, so
-- no diagonal history cost distinguishes them, while an off-diagonal port
-- separates them.  Coherence changes the scheduling state only after that
-- extra port is declared.
------------------------------------------------------------------------

module CoherentSurvivalDephasing where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Structure using (⟨_⟩)
open import Cubical.Data.Sigma using (_×_ ; _,_)
open import Cubical.Data.Int
  using (ℤ ; pos ; negsuc ; posNotnegsuc)
  renaming (_+_ to _+ℤ_ ; _·_ to _·ℤ_)
open import Cubical.Relation.Nullary using (¬_)
open import Cubical.Algebra.Ring using (Ring ; RingStr)

------------------------------------------------------------------------
-- 1. Every diagonal history cost factors through dephasing
------------------------------------------------------------------------

record Matrix₂ {ℓ : Level} (A : Type ℓ) : Type ℓ where
  constructor matrix₂
  field
    m00 m01 m10 m11 : A

open Matrix₂ public

SameDiagonal : {ℓ : Level} {A : Type ℓ} → Matrix₂ A → Matrix₂ A → Type ℓ
SameDiagonal ρ σ = (m00 ρ ≡ m00 σ) × (m11 ρ ≡ m11 σ)

module DiagonalHistoryCost {ℓ : Level} (R : Ring ℓ) where
  open RingStr (snd R)

  dephase : Matrix₂ ⟨ R ⟩ → Matrix₂ ⟨ R ⟩
  dephase ρ = matrix₂ (m00 ρ) 0r 0r (m11 ρ)

  diagonalCost : ⟨ R ⟩ → ⟨ R ⟩ → Matrix₂ ⟨ R ⟩ → ⟨ R ⟩
  diagonalCost c₀ c₁ ρ = c₀ · m00 ρ + c₁ · m11 ρ

  diagonal-cost-dephasing-invariant :
    (c₀ c₁ : ⟨ R ⟩) (ρ : Matrix₂ ⟨ R ⟩)
    → diagonalCost c₀ c₁ ρ ≡ diagonalCost c₀ c₁ (dephase ρ)
  diagonal-cost-dephasing-invariant c₀ c₁ ρ = refl

  same-diagonal→same-cost :
    (c₀ c₁ : ⟨ R ⟩) (ρ σ : Matrix₂ ⟨ R ⟩)
    → SameDiagonal ρ σ
    → diagonalCost c₀ c₁ ρ ≡ diagonalCost c₀ c₁ σ
  same-diagonal→same-cost c₀ c₁ ρ σ (h₀ , h₁) =
    cong₂ _+_ (cong (c₀ ·_) h₀) (cong (c₁ ·_) h₁)

------------------------------------------------------------------------
-- 2. Hostile control: equal survival masses, opposite coherent phases
------------------------------------------------------------------------

-- These are twice the normalized pure-state density matrices for
-- (|0⟩ + |1⟩)/√2 and (|0⟩ - |1⟩)/√2.  The common positive scalar is
-- irrelevant to both equality and separation, so the checked carrier stays
-- in the exact integer ring.
phasePlus phaseMinus : Matrix₂ ℤ
phasePlus  = matrix₂ (pos 1) (pos 1)    (pos 1)    (pos 1)
phaseMinus = matrix₂ (pos 1) (negsuc 0) (negsuc 0) (pos 1)

phase-pair-same-diagonal : SameDiagonal phasePlus phaseMinus
phase-pair-same-diagonal = refl , refl

dephaseℤ : Matrix₂ ℤ → Matrix₂ ℤ
dephaseℤ ρ = matrix₂ (m00 ρ) (pos 0) (pos 0) (m11 ρ)

phase-pair-same-after-dephasing : dephaseℤ phasePlus ≡ dephaseℤ phaseMinus
phase-pair-same-after-dephasing = refl

diagonalCostℤ : ℤ → ℤ → Matrix₂ ℤ → ℤ
diagonalCostℤ c₀ c₁ ρ = c₀ ·ℤ m00 ρ +ℤ c₁ ·ℤ m11 ρ

phase-pair-all-diagonal-costs-agree :
  (c₀ c₁ : ℤ) → diagonalCostℤ c₀ c₁ phasePlus
                ≡ diagonalCostℤ c₀ c₁ phaseMinus
phase-pair-all-diagonal-costs-agree c₀ c₁ = refl

-- The Pauli-X / sum-difference port reads the off-diagonal entries.
offDiagonalPort : Matrix₂ ℤ → ℤ
offDiagonalPort ρ = m01 ρ +ℤ m10 ρ

plus-port-value : offDiagonalPort phasePlus ≡ pos 2
plus-port-value = refl

minus-port-value : offDiagonalPort phaseMinus ≡ negsuc 1
minus-port-value = refl

off-diagonal-port-separates :
  ¬ (offDiagonalPort phasePlus ≡ offDiagonalPort phaseMinus)
off-diagonal-port-separates equality =
  posNotnegsuc 2 1 (sym plus-port-value ∙ equality ∙ minus-port-value)

