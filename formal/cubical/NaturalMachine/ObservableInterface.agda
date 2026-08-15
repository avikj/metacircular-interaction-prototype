{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- NaturalMachine.ObservableInterface
--
-- One path-valued seam shared by three deliberately different observation
-- systems.  An interface says which states are compared, what is observed,
-- and why the declared comparison preserves that observation.  The induced
-- path transports every predicate on observations.  It does not identify
-- states whose observations merely agree.
------------------------------------------------------------------------

module NaturalMachine.ObservableInterface where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Structure using (⟨_⟩)
open import Cubical.Data.Bool using (Bool)
open import Cubical.Data.Sigma using (Σ ; Σ-syntax ; _,_)
open import Cubical.Relation.Nullary using (¬_)

import NaturalMachine.DSOContinuationFullAbstract as DSO
import NaturalMachine.ExactProjectiveCircuits as Circuit
import NaturalMachine.ExactProjectivePhase as Projective
import NaturalMachine.FiniteNonabelianHolonomy as S3
import NaturalMachine.S3ConjugacyObservation as Character

------------------------------------------------------------------------
-- 1. Equality-native observable interfaces
------------------------------------------------------------------------

record ObservableInterface (ℓs ℓo ℓr : Level)
  : Type (ℓ-suc (ℓ-max ℓs (ℓ-max ℓo ℓr))) where
  field
    State       : Type ℓs
    Observation : Type ℓo
    observe     : State → Observation
    Related     : State → State → Type ℓr
    preserves   : {left right : State}
      → Related left right → observe left ≡ observe right

open ObservableInterface public

-- Preservation is operational: any property or dependent consumer of the
-- observation transports along the path supplied by the interface.
transportObservation : ∀ {ℓs ℓo ℓr ℓp}
  (I : ObservableInterface ℓs ℓo ℓr)
  {left right : State I}
  → Related I left right
  → (P : Observation I → Type ℓp)
  → P (observe I left) → P (observe I right)
transportObservation I related P = subst P (preserves I related)

transportObservation-refl : ∀ {ℓs ℓo ℓr ℓp}
  (I : ObservableInterface ℓs ℓo ℓr)
  {state : State I} (related : Related I state state)
  (same : preserves I related ≡ refl)
  (P : Observation I → Type ℓp) (evidence : P (observe I state))
  → transportObservation I related P evidence ≡ evidence
transportObservation-refl I related same P evidence =
  cong (λ path → subst P path evidence) same
  ∙ substRefl {B = P} evidence

------------------------------------------------------------------------
-- 2. S₃ holonomy character: comparison is gauge conjugacy
------------------------------------------------------------------------

Conjugate : ⟨ S3.S₃ ⟩ → ⟨ S3.S₃ ⟩ → Type₀
Conjugate left right =
  Σ[ gauge ∈ ⟨ S3.S₃ ⟩ ]
    ((gauge S3.S.· left) S3.S.· S3.S.inv gauge ≡ right)

character-preserves : {left right : ⟨ S3.S₃ ⟩}
  → Conjugate left right
  → Character.Fixed left ≡ Character.Fixed right
character-preserves {left} (gauge , equality) =
  sym (Character.fixedProfile-conjugation gauge left)
  ∙ cong Character.Fixed equality

s₃CharacterInterface : ObservableInterface ℓ-zero (ℓ-suc ℓ-zero) ℓ-zero
State s₃CharacterInterface = ⟨ S3.S₃ ⟩
Observation s₃CharacterInterface = Type₀
observe s₃CharacterInterface = Character.Fixed
Related s₃CharacterInterface = Conjugate
preserves s₃CharacterInterface = character-preserves

-- This Type-valued observation is genuinely nonconstant.
s₃-character-does-not-collapse-classes :
  ¬ (observe s₃CharacterInterface S3.S.1g
    ≡ observe s₃CharacterInterface S3.s₀₁)
s₃-character-does-not-collapse-classes = Character.identity-not-swap

------------------------------------------------------------------------
-- 3. Exact projective circuits: comparison is agreement on every ray
------------------------------------------------------------------------

CircuitSignature : Type₀
CircuitSignature = Projective.ProjectiveState₂ → Circuit.Weights

circuitSignature : Circuit.Circuit₂ → CircuitSignature
circuitSignature circuit state = Circuit.observeCircuit₂ circuit state

CircuitEquivalent : Circuit.Circuit₂ → Circuit.Circuit₂ → Type₀
CircuitEquivalent left right =
  (state : Projective.ProjectiveState₂)
  → Circuit.observeCircuit₂ left state ≡ Circuit.observeCircuit₂ right state

circuit-preserves : {left right : Circuit.Circuit₂}
  → CircuitEquivalent left right
  → circuitSignature left ≡ circuitSignature right
circuit-preserves agreement = funExt agreement

projectiveCircuitInterface : ObservableInterface ℓ-zero ℓ-zero ℓ-zero
State projectiveCircuitInterface = Circuit.Circuit₂
Observation projectiveCircuitInterface = CircuitSignature
observe projectiveCircuitInterface = circuitSignature
Related projectiveCircuitInterface = CircuitEquivalent
preserves projectiveCircuitInterface {left} {right} agreement =
  circuit-preserves {left = left} {right = right} agreement

-- The interface retains the checked separation of X;X from Z;H.
projective-interface-separates-XX-ZH :
  ¬ Related projectiveCircuitInterface Circuit.XX Circuit.ZH
projective-interface-separates-XX-ZH related =
  Circuit.XX-and-ZH-are-observationally-separated
    (related Circuit.plusInput)

------------------------------------------------------------------------
-- 4. DSO: comparison is equality in every continuation context
------------------------------------------------------------------------

BellmanSignature : Type₀
BellmanSignature = DSO.Continuation → DSO.Continuation

bellmanSignature : DSO.Relation → BellmanSignature
bellmanSignature relation continuation = DSO.bellman relation continuation

ContextuallyEquivalent : DSO.Relation → DSO.Relation → Type₀
ContextuallyEquivalent left right =
  (continuation : DSO.Continuation) (root : Bool)
  → DSO.bellman left continuation root
    ≡ DSO.bellman right continuation root

contextual-preserves : {left right : DSO.Relation}
  → ContextuallyEquivalent left right
  → bellmanSignature left ≡ bellmanSignature right
contextual-preserves agreement =
  funExt λ continuation → funExt (agreement continuation)

dsoContextualInterface : ObservableInterface ℓ-zero ℓ-zero ℓ-zero
State dsoContextualInterface = DSO.Relation
Observation dsoContextualInterface = BellmanSignature
observe dsoContextualInterface = bellmanSignature
Related dsoContextualInterface = ContextuallyEquivalent
preserves dsoContextualInterface {left} {right} agreement =
  contextual-preserves {left = left} {right = right} agreement

-- Unlike gauge conjugacy, the declared complete continuation signature is
-- fully abstract: agreement reflects equality of the finite cost relation.
dso-observation-reflects-state : {left right : DSO.Relation}
  → Related dsoContextualInterface left right
  → left ≡ right
dso-observation-reflects-state {left} {right} =
  DSO.transformer-full-abstraction left right

------------------------------------------------------------------------
-- Rigor boundary
--
-- Shared exactly: states, a possibly higher observation object, a declared
-- comparison, its observation path, and dependent transport along that path.
-- Distinct intentionally: S₃ uses gauge conjugacy and a Type-valued character;
-- circuits use equality of finite weight experiments on every projective ray;
-- DSO uses equality under every continuation and can reconstruct its relation.
-- No identification of gauge, quantum experiment, and optimization semantics
-- is asserted.
------------------------------------------------------------------------
