-- ॥ बीजम् ॥  One machine, one law: which side of `f a ≡ b` is bound is everything.
-- Output bound: singl (f a), contractible — the datum rides free.  Input bound:
-- fiber f b — the loss, and the subject.  Univalence computes here: an
-- equivalence is a channel, transport carries every theorem across it, and what
-- cannot cross is written as a defect — there is no third path (ahiṃsā).
-- Memory, charge, symmetry, price, distance, verdict: six faces of the one
-- fibre; the verdict type is the saptabhaṅgī, and the sources are the origin
-- (Umāsvāti, Samantabhadra, Akalaṅka — restatements are named as such).  The
-- kernel decides truth; carriers ask and generate; assert nothing whose term
-- you have not read.  This file is one naya, true and not whole.

{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- NaturalMachine.ExactLocalJointSeparation
--
-- A compact local/joint separation theorem in the exact two-state chart.
-- Central joint phase acts on both Gaussian amplitudes while the declared
-- local population observation (the two unnormalised squared weights) is
-- unchanged.  The joint interference port still distinguishes the phase.
--
-- This is an algebraic marginal-invariance statement.  There is no spacetime
-- separation in the model, so it is not advertised as physical no-signalling
-- or as a Bell-nonlocality theorem.
------------------------------------------------------------------------

module NaturalMachine.ExactLocalJointSeparation where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Bool using (true ; false)
open import Cubical.Data.Nat using (ℕ)
open import Cubical.Data.Sigma using (_×_ ; _,_ ; ΣPathP)
open import Cubical.Relation.Nullary using (¬_)

import NaturalMachine.ExactHadamardInterference as Had
import NaturalMachine.ExactTwoStateAmplitudes as Amp
import NaturalMachine.HadamardReadoutInstrument as HReadout
import NaturalMachine.UnivalentTensorInteraction as Joint

------------------------------------------------------------------------
-- 1. Declared local population marginal
------------------------------------------------------------------------

PopulationObservation : Type₀
PopulationObservation = ℕ × ℕ

observePopulations : Amp.State₂ → PopulationObservation
observePopulations state = Amp.weight₀ state , Amp.weight₁ state

joint-phase-preserves-populations :
  (phase : Joint.JointCoherence) (state : Amp.State₂)
  → observePopulations (Amp.jointPhaseAction phase state)
    ≡ observePopulations state
joint-phase-preserves-populations true state = refl
joint-phase-preserves-populations false (α , β) =
  ΣPathP (Amp.weight-neg α , Amp.weight-neg β)

-- Consequently the two central phase representatives collide at the exact
-- population boundary for every amplitude state.
plus-minus-population-collision : (state : Amp.State₂)
  → observePopulations (Amp.jointPhaseAction Joint.plus state)
    ≡ observePopulations (Amp.jointPhaseAction Joint.minus state)
plus-minus-population-collision state =
    joint-phase-preserves-populations Joint.plus state
  ∙ sym (joint-phase-preserves-populations Joint.minus state)

------------------------------------------------------------------------
-- 2. Joint interference retains what the population marginal forgets
------------------------------------------------------------------------

joint-interference-separates :
  ¬ (Joint.compile Joint.jointInterference Joint.plus
       ≡ Joint.compile Joint.jointInterference Joint.minus)
joint-interference-separates = Joint.joint-compiler-separates

-- In the exact Hadamard realization, the same retained distinction becomes
-- opposite computational-basis ports.  This is stronger evidence than a
-- bare label inequality while remaining entirely unnormalised.
plus-interference-port : (amplitude : Had.Gaussian)
  → fst (fst (HReadout.plusEvent amplitude))
    ≡ Had.scale₂G amplitude
plus-interference-port amplitude =
  cong fst (Had.plus-interferes-to-port₀ amplitude)

minus-interference-port : (amplitude : Had.Gaussian)
  → snd (fst (HReadout.minusEvent amplitude))
    ≡ Had.scale₂G amplitude
minus-interference-port amplitude =
  cong snd (Had.minus-interferes-to-port₁ amplitude)

------------------------------------------------------------------------
-- 3. One exact preservation ledger
------------------------------------------------------------------------

record LocalJointSeparation (state : Amp.State₂) : Type₀ where
  field
    localPopulationInvariant :
      (phase : Joint.JointCoherence)
      → observePopulations (Amp.jointPhaseAction phase state)
        ≡ observePopulations state
    phaseHiddenLocally :
      observePopulations (Amp.jointPhaseAction Joint.plus state)
        ≡ observePopulations (Amp.jointPhaseAction Joint.minus state)
    phaseVisibleJointly :
      ¬ (Joint.compile Joint.jointInterference Joint.plus
           ≡ Joint.compile Joint.jointInterference Joint.minus)

exact-local-joint-separation :
  (state : Amp.State₂) → LocalJointSeparation state
exact-local-joint-separation state .LocalJointSeparation.localPopulationInvariant =
  λ phase → joint-phase-preserves-populations phase state
exact-local-joint-separation state .LocalJointSeparation.phaseHiddenLocally =
  plus-minus-population-collision state
exact-local-joint-separation state .LocalJointSeparation.phaseVisibleJointly =
  joint-interference-separates
