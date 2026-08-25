{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- ConstructiveBornNormalization
--
-- Exact normalization without floating point.  A two-outcome distribution is
-- represented by natural numerators over one witnessed-positive denominator;
-- "probabilities sum to one" is the checked numerator equation n0+n1=d.
-- This is the constructive rational content needed by the finite amplitude
-- chart, without pretending Cubical's bare rational quotient is a field here.
------------------------------------------------------------------------

module ConstructiveBornNormalization where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Sigma using (_×_ ; _,_ ; Σ-syntax)
open import Cubical.Data.Nat
  using (ℕ ; zero ; suc ; snotz ; +-suc) renaming (_+_ to _+ℕ_)
open import Cubical.Relation.Nullary using (¬_)

import ExactTwoStateAmplitudes as Amp
import ExactProjectivePhase as Proj
import ExactProjectiveCircuits as Circuit

------------------------------------------------------------------------
-- 1. Common-denominator rational distributions
------------------------------------------------------------------------

Positive : ℕ → Type₀
Positive denominator = Σ[ predecessor ∈ ℕ ] denominator ≡ suc predecessor

record BornDistribution₂ : Type₀ where
  field
    denominator : ℕ
    positive : Positive denominator
    numerator₀ numerator₁ : ℕ
    sums-to-one : numerator₀ +ℕ numerator₁ ≡ denominator

open BornDistribution₂ public

Weights : Type₀
Weights = ℕ × ℕ

totalWeight : Weights → ℕ
totalWeight weights = fst weights +ℕ snd weights

NonzeroWeights : Weights → Type₀
NonzeroWeights weights = Positive (totalWeight weights)

normalizeWeights : (weights : Weights) → NonzeroWeights weights → BornDistribution₂
normalizeWeights weights witness = record
  { denominator = totalWeight weights
  ; positive = witness
  ; numerator₀ = fst weights
  ; numerator₁ = snd weights
  ; sums-to-one = refl
  }

stateWeights : Amp.State₂ → Weights
stateWeights state = Amp.weight₀ state , Amp.weight₁ state

NonzeroState : Amp.State₂ → Type₀
NonzeroState state = NonzeroWeights (stateWeights state)

bornState : (state : Amp.State₂) → NonzeroState state → BornDistribution₂
bornState state = normalizeWeights (stateWeights state)

-- The existing global-phase quotient already exposes representative-independent
-- weights.  Supplying only their nonzero witness yields a normalized result.
NonzeroProjective : Proj.ProjectiveState₂ → Type₀
NonzeroProjective state = NonzeroWeights (Circuit.projectiveWeights state)

projectiveBorn : (state : Proj.ProjectiveState₂)
  → NonzeroProjective state → BornDistribution₂
projectiveBorn state = normalizeWeights (Circuit.projectiveWeights state)

------------------------------------------------------------------------
-- 2. Exact circuit distributions
------------------------------------------------------------------------

xxPlusNonzero : NonzeroWeights (Circuit.observeCircuit₂ Circuit.XX Circuit.plusInput)
xxPlusNonzero = 1 , refl

zhPlusNonzero : NonzeroWeights (Circuit.observeCircuit₂ Circuit.ZH Circuit.plusInput)
zhPlusNonzero = 3 , refl

xxPlusBorn zhPlusBorn : BornDistribution₂
xxPlusBorn = normalizeWeights
  (Circuit.observeCircuit₂ Circuit.XX Circuit.plusInput) xxPlusNonzero
zhPlusBorn = normalizeWeights
  (Circuit.observeCircuit₂ Circuit.ZH Circuit.plusInput) zhPlusNonzero

-- X;X leaves the plus input at the exact distribution (1/2,1/2).
xx-born-data :
  (denominator xxPlusBorn ≡ 2)
  × ((numerator₀ xxPlusBorn ≡ 1) × (numerator₁ xxPlusBorn ≡ 1))
xx-born-data = refl , (refl , refl)

-- Z;H produces the deterministic second port (0/4,4/4).
zh-born-data :
  (denominator zhPlusBorn ≡ 4)
  × ((numerator₀ zhPlusBorn ≡ 0) × (numerator₁ zhPlusBorn ≡ 4))
zh-born-data = refl , (refl , refl)

------------------------------------------------------------------------
-- 3. Exact obstruction to Gaussian-integer unit normalization
------------------------------------------------------------------------

-- A Gaussian scalar multiple of the equal-phase ray (1,1) has the form
-- (lambda,lambda), hence has twice the amplitude weight of lambda.
scaledPlus : Amp.Gaussian → Amp.State₂
scaledPlus scalar = scalar , scalar

scaled-plus-norm-is-even : (scalar : Amp.Gaussian)
  → Amp.norm² (scaledPlus scalar)
    ≡ Amp.amplitudeWeight scalar +ℕ Amp.amplitudeWeight scalar
scaled-plus-norm-is-even scalar = refl

double-is-not-one : (n : ℕ) → ¬ (n +ℕ n ≡ 1)
double-is-not-one zero equality = snotz (sym equality)
double-is-not-one (suc n) equality =
  snotz (sym (+-suc n n) ∙ cong pred equality)
  where
  pred : ℕ → ℕ
  pred zero = zero
  pred (suc k) = k

no-gaussian-unit-normalizer-for-plus :
  (scalar : Amp.Gaussian) → ¬ (Amp.norm² (scaledPlus scalar) ≡ 1)
no-gaussian-unit-normalizer-for-plus scalar equality =
  double-is-not-one (Amp.amplitudeWeight scalar)
    (sym (scaled-plus-norm-is-even scalar) ∙ equality)

------------------------------------------------------------------------
-- Rigor boundary
--
-- Checked: exact two-outcome rational data with a positive denominator and
-- numerator sum equal to it; normalization of representative-independent
-- projective weights; concrete circuit distributions; and the impossibility
-- of unit-normalizing the equal-phase ray by a Gaussian-integer scalar.
--
-- Not claimed: a field-valued probability type, square-root normalization,
-- sigma-additivity, measurement dynamics, or analytic Hilbert space.  The
-- record is a finite rational distribution presentation, intentionally.
------------------------------------------------------------------------
