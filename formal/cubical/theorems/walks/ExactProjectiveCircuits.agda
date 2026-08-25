{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- ExactProjectiveCircuits
--
-- Finite exact circuit semantics for X, Z, and the unnormalised H on the
-- Gaussian/Z4 projective chart.  Gate equivariance is the descent condition;
-- consequently every observation defined on the quotient composes with every
-- circuit without recovering a representative.
------------------------------------------------------------------------

module ExactProjectiveCircuits where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.HLevels using (isSet×)
open import Cubical.Data.Sigma using (_×_ ; _,_)
open import Cubical.Data.Nat using (ℕ ; isSetℕ ; snotz)
open import Cubical.Data.Int using (ℤ)
open import Cubical.Algebra.CommRing
open import Cubical.Algebra.CommRing.Instances.Int using (ℤCommRing)
open import Cubical.Tactics.CommRingSolver.Reflection using (solve!)
open import Cubical.HITs.SetQuotients as SQ using (eq/ ; squash/)
open import Cubical.Relation.Nullary using (¬_)

open CommRingStr (ℤCommRing .snd)
  using (_+_ ; _-_ ; -_)

import PauliWeyl as Weyl
import ExactTwoStateAmplitudes as Amp
import ExactHadamardInterference as Had
import ExactProjectivePhase as Proj

data Gate : Type₀ where
  gateX gateZ gateH : Gate

runGate : Gate → Amp.State₂ → Amp.State₂
runGate gateX = Amp.X
runGate gateZ = Amp.Z
runGate gateH = Had.H

-- Each gate is equivariant for the exact global phase action.  X is a swap,
-- Z and H are Gaussian-linear; the finite Z4 cases close by ring identities.
gate-equivariant : (gate : Gate) (phase : Weyl.Z4) (state : Amp.State₂)
  → runGate gate (Amp.phaseAction phase state)
    ≡ Amp.phaseAction phase (runGate gate state)
gate-equivariant gateX phase state = refl
gate-equivariant gateZ Weyl.ph0 state = refl
gate-equivariant gateZ Weyl.ph1 ((a , b) , (c , d)) =
  Had.statePath refl
    (Had.gaussianPath (solve! ℤCommRing) (solve! ℤCommRing))
gate-equivariant gateZ Weyl.ph2 ((a , b) , (c , d)) =
  Had.statePath refl
    (Had.gaussianPath (solve! ℤCommRing) (solve! ℤCommRing))
gate-equivariant gateZ Weyl.ph3 ((a , b) , (c , d)) =
  Had.statePath refl
    (Had.gaussianPath (solve! ℤCommRing) (solve! ℤCommRing))
gate-equivariant gateH = Proj.H-commutes-global-phase

runProjectiveGate : Gate → Proj.ProjectiveState₂ → Proj.ProjectiveState₂
runProjectiveGate gate = SQ.rec squash/ (λ state → Proj.project (runGate gate state)) respects
  where
  respects : (x y : Amp.State₂) → Proj.GlobalPhaseStep x y
    → Proj.project (runGate gate x) ≡ Proj.project (runGate gate y)
  respects x y (phase , equality) =
    eq/ _ _
      (phase , sym (gate-equivariant gate phase x) ∙ cong (runGate gate) equality)

Circuit₂ : Type₀
Circuit₂ = Gate × Gate

runCircuit₂ : Circuit₂ → Proj.ProjectiveState₂ → Proj.ProjectiveState₂
runCircuit₂ (first , second) state =
  runProjectiveGate second (runProjectiveGate first state)

Weights : Type₀
Weights = ℕ × ℕ

rawWeights : Amp.State₂ → Weights
rawWeights state = Amp.weight₀ state , Amp.weight₁ state

projectiveWeights : Proj.ProjectiveState₂ → Weights
projectiveWeights = SQ.rec (isSet× isSetℕ isSetℕ) rawWeights respects
  where
  respects : (x y : Amp.State₂) → Proj.GlobalPhaseStep x y
    → rawWeights x ≡ rawWeights y
  respects x y (phase , equality) =
    sym (cong₂ _,_
      (Amp.phaseActionG-preserves-weight phase (fst x))
      (Amp.phaseActionG-preserves-weight phase (snd x)))
    ∙ cong rawWeights equality

observeCircuit₂ : Circuit₂ → Proj.ProjectiveState₂ → Weights
observeCircuit₂ circuit state = projectiveWeights (runCircuit₂ circuit state)

-- The observation of a circuit on a projected representative is definitionally
-- its raw execution followed by raw weights: descent composes without choosing
-- or inspecting a representative.
runRawCircuit₂ : Circuit₂ → Amp.State₂ → Amp.State₂
runRawCircuit₂ (first , second) state = runGate second (runGate first state)

observe-projected : (circuit : Circuit₂) (state : Amp.State₂)
  → observeCircuit₂ circuit (Proj.project state)
    ≡ rawWeights (runRawCircuit₂ circuit state)
observe-projected circuit state = refl

------------------------------------------------------------------------
-- One circuit equivalence and one observational separation
------------------------------------------------------------------------

XX : Circuit₂
XX = gateX , gateX

XX-raw-identity : (state : Amp.State₂) → runRawCircuit₂ XX state ≡ state
XX-raw-identity state = refl

XX-projective-identity : (state : Proj.ProjectiveState₂)
  → runCircuit₂ XX state ≡ state
XX-projective-identity = SQ.elimProp (λ _ → squash/ _ _) (λ _ → refl)

ZH : Circuit₂
ZH = gateZ , gateH

plusInput : Proj.ProjectiveState₂
plusInput = Proj.project (Had.plusState Amp.oneG)

XX-plus-weights : observeCircuit₂ XX plusInput ≡ (1 , 1)
XX-plus-weights = refl

ZH-plus-weights : observeCircuit₂ ZH plusInput ≡ (0 , 4)
ZH-plus-weights = refl

one≢zero : ¬ (1 ≡ 0)
one≢zero = snotz

XX-and-ZH-are-observationally-separated :
  ¬ (observeCircuit₂ XX plusInput ≡ observeCircuit₂ ZH plusInput)
XX-and-ZH-are-observationally-separated equality =
  one≢zero
    (cong fst (sym XX-plus-weights ∙ equality ∙ ZH-plus-weights))

------------------------------------------------------------------------
-- Rigor boundary
--
-- Checked: exact two-gate X/Z/H execution on the finite Z4 phase quotient,
-- compositional descent of component weights, X;X = identity, and a concrete
-- weight observation separating X;X from Z;H.
--
-- Not claimed: a universal gate set, normalized unitary semantics, projective
-- Hilbert space, measurement collapse, or hardware realization.
------------------------------------------------------------------------
