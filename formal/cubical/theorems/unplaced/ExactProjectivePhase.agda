{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- ExactProjectivePhase
--
-- The finite projective quotient earned by the exact amplitude chart:
-- Gaussian two-state vectors modulo the checked global Z4 phase action.
-- Norm and Hadamard output weights descend.  The equal/opposite relative
-- phases remain distinguishable after the quotient because interference sends
-- them to different output-weight pairs.
------------------------------------------------------------------------

module ExactProjectivePhase where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.HLevels using (isSet×)
open import Cubical.Data.Sigma using (_×_ ; _,_ ; Σ-syntax ; ΣPathP)
open import Cubical.Data.Nat using (ℕ ; isSetℕ ; snotz)
open import Cubical.Data.Int using (ℤ)
open import Cubical.Algebra.CommRing
open import Cubical.Algebra.CommRing.Instances.Int using (ℤCommRing)
open import Cubical.Tactics.CommRingSolver.Reflection using (solve!)
open import Cubical.HITs.SetQuotients as SQ using (_/_ ; [_] ; eq/)
open import Cubical.Relation.Nullary using (¬_)

open CommRingStr (ℤCommRing .snd)
  using (_+_ ; _-_ ; -_)

import PauliWeyl as Weyl
import ExactTwoStateAmplitudes as Amp
import ExactHadamardInterference as Had

State₂ : Type₀
State₂ = Amp.State₂

GlobalPhaseStep : State₂ → State₂ → Type₀
GlobalPhaseStep x y =
  Σ[ phase ∈ Weyl.Z4 ] (Amp.phaseAction phase x ≡ y)

ProjectiveState₂ : Type₀
ProjectiveState₂ = State₂ / GlobalPhaseStep

project : State₂ → ProjectiveState₂
project = [_]

global-phase-path : (phase : Weyl.Z4) (state : State₂)
  → project state ≡ project (Amp.phaseAction phase state)
global-phase-path phase state = eq/ _ _ (phase , refl)

------------------------------------------------------------------------
-- Observables factoring through global phase
------------------------------------------------------------------------

projectiveNorm² : ProjectiveState₂ → ℕ
projectiveNorm² = SQ.rec isSetℕ Amp.norm² respects
  where
  respects : (x y : State₂) → GlobalPhaseStep x y → Amp.norm² x ≡ Amp.norm² y
  respects x y (phase , equality) =
    sym (Amp.phaseAction-preserves-norm² phase x)
    ∙ cong Amp.norm² equality

PortWeights : Type₀
PortWeights = ℕ × ℕ

rawWeights : State₂ → PortWeights
rawWeights state = Amp.weight₀ state , Amp.weight₁ state

portWeights : State₂ → PortWeights
portWeights state = rawWeights (Had.H state)

-- H is complex-linear for each of the four exact phases.  The ring solver
-- proves the component equations; there is no numeric sampling.
H-commutes-global-phase : (phase : Weyl.Z4) (state : State₂)
  → Had.H (Amp.phaseAction phase state)
    ≡ Amp.phaseAction phase (Had.H state)
H-commutes-global-phase Weyl.ph0 state = refl
H-commutes-global-phase Weyl.ph1 ((a , b) , (c , d)) =
  Had.statePath
    (Had.gaussianPath (solve! ℤCommRing) (solve! ℤCommRing))
    (Had.gaussianPath (solve! ℤCommRing) (solve! ℤCommRing))
H-commutes-global-phase Weyl.ph2 ((a , b) , (c , d)) =
  Had.statePath
    (Had.gaussianPath (solve! ℤCommRing) (solve! ℤCommRing))
    (Had.gaussianPath (solve! ℤCommRing) (solve! ℤCommRing))
H-commutes-global-phase Weyl.ph3 ((a , b) , (c , d)) =
  Had.statePath
    (Had.gaussianPath (solve! ℤCommRing) (solve! ℤCommRing))
    (Had.gaussianPath (solve! ℤCommRing) (solve! ℤCommRing))

phase-preserves-component-weights : (phase : Weyl.Z4) (state : State₂)
  → (Amp.weight₀ (Amp.phaseAction phase state) ≡ Amp.weight₀ state)
    × (Amp.weight₁ (Amp.phaseAction phase state) ≡ Amp.weight₁ state)
phase-preserves-component-weights phase (α , β) =
  Amp.phaseActionG-preserves-weight phase α ,
  Amp.phaseActionG-preserves-weight phase β

global-phase-preserves-port-weights : (phase : Weyl.Z4) (state : State₂)
  → portWeights (Amp.phaseAction phase state) ≡ portWeights state
global-phase-preserves-port-weights phase state =
  cong rawWeights (H-commutes-global-phase phase state)
  ∙ cong₂ _,_
      (fst (phase-preserves-component-weights phase (Had.H state)))
      (snd (phase-preserves-component-weights phase (Had.H state)))

projectivePortWeights : ProjectiveState₂ → PortWeights
projectivePortWeights =
  SQ.rec (isSet× isSetℕ isSetℕ) portWeights respects
  where
  respects : (x y : State₂) → GlobalPhaseStep x y → portWeights x ≡ portWeights y
  respects x y (phase , equality) =
    sym (global-phase-preserves-port-weights phase x)
    ∙ cong portWeights equality

------------------------------------------------------------------------
-- Relative phase survives and is reopened by interference
------------------------------------------------------------------------

plusRay minusRay : ProjectiveState₂
plusRay = project (Had.plusState Amp.oneG)
minusRay = project (Had.minusState Amp.oneG)

plus-ray-ports : projectivePortWeights plusRay ≡ (4 , 0)
plus-ray-ports = refl

minus-ray-ports : projectivePortWeights minusRay ≡ (0 , 4)
minus-ray-ports = refl

four≢zero : ¬ (4 ≡ 0)
four≢zero = snotz

relative-phase-survives-projectivization : ¬ (plusRay ≡ minusRay)
relative-phase-survives-projectivization equality =
  four≢zero
    (cong fst
      (sym plus-ray-ports
      ∙ cong projectivePortWeights equality
      ∙ minus-ray-ports))

------------------------------------------------------------------------
-- Rigor boundary
--
-- Checked: the set quotient by the finite Z4 global-phase action, descent of
-- norm and interference-port weights, and separation of the two concrete
-- relative-phase rays by their descended output weights.
--
-- Not claimed: projective Hilbert space, quotient by every nonzero complex
-- scalar, analytic completion, normalized probabilities, or measurement.
------------------------------------------------------------------------
