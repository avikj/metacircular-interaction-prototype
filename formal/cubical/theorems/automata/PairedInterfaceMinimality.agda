{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- PairedInterfaceMinimality
--
-- Minimality of the finite paired past×future experiment interface.  Its
-- kernel is the coarsest deterministic identification through which every
-- declared paired response can factor.  The immediate-readout interface is
-- concretely too coarse: it identifies the two phase controls which a future
-- Hadamard insertion separates.
------------------------------------------------------------------------

module PairedInterfaceMinimality where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Bool using (Bool ; true ; false)
open import Cubical.HITs.SetQuotients using (_/_)
open import Cubical.Relation.Nullary using (¬_)

import ExactExperimentFullAbstraction as Exp
import ExactTwoStateAmplitudes as Amp
import FiniteInformation as FI
import TwoSidedExperimentInterface as Two

------------------------------------------------------------------------
-- 1. The paired-signature kernel on the finite phase control set
------------------------------------------------------------------------

PhaseState : Type₀
PhaseState = Bool

phaseState : PhaseState → Amp.State₂
phaseState true  = Two.plusInput
phaseState false = Two.minusInput

phasePairedSignature : PhaseState → Two.PairedSignature
phasePairedSignature phase = Two.pairedSignature (phaseState phase)

PairedKernel : PhaseState → PhaseState → Type₀
PairedKernel left right =
  phasePairedSignature left ≡ phasePairedSignature right

-- The quotient is named explicitly; computation and minimality below use its
-- kernel rather than assuming a choice of quotient representatives.
PairedInterface : Type₀
PairedInterface = PhaseState / PairedKernel

------------------------------------------------------------------------
-- 2. Universal minimality among deterministic interfaces
------------------------------------------------------------------------

-- If every paired response can be reconstructed from q, then equality at q
-- implies equality in the paired kernel.  Thus q may retain more information,
-- but it cannot identify more phase states than the paired interface does.
every-interface-refines-paired-kernel : {I : Type₀}
  (q : PhaseState → I)
  → FI.FactorsThrough q phasePairedSignature
  → (left right : PhaseState)
  → q left ≡ q right → PairedKernel left right
every-interface-refines-paired-kernel q factors =
  FI.factorsThrough→fiberConstant q phasePairedSignature factors

------------------------------------------------------------------------
-- 3. Concrete lower bound: immediate readout is too coarse
------------------------------------------------------------------------

ImmediateInterface : Type₀
ImmediateInterface = Exp.WeightedHistory

immediateInterface : PhaseState → ImmediateInterface
immediateInterface phase =
  Exp.runExperiment Exp.readout (phaseState phase)

immediate-collides : immediateInterface true ≡ immediateInterface false
immediate-collides = funExt Two.phase-inputs-collide-immediately

-- Were every paired response reconstructible from immediate readout, kernel
-- minimality would force the phase pair into PairedKernel.  Evaluating that
-- purported equality at identity-past, future-H, false gives the already
-- checked 4-versus-0 contradiction.
immediate-interface-cannot-reconstruct-paired-signature :
  ¬ FI.FactorsThrough immediateInterface phasePairedSignature
immediate-interface-cannot-reconstruct-paired-signature factors =
  Two.future-H-separates separated
  where
  kernelEquality : PairedKernel true false
  kernelEquality = every-interface-refines-paired-kernel
    immediateInterface factors true false immediate-collides

  separated :
    Exp.runExperiment Exp.h-readout Two.plusInput false
      ≡ Exp.runExperiment Exp.h-readout Two.minusInput false
  separated =
    funExt⁻ (funExt⁻ (funExt⁻ kernelEquality Exp.readout)
      Exp.h-readout) false
