{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- NaturalMachine.TwoSidedExperimentInterface
--
-- A finite operational middle-interface theorem.  Immediate readout is a
-- one-sided summary: equal- and opposite-phase inputs collide there, but a
-- future Hadamard insertion separates them.  Closing the signature under a
-- declared preparation on the left and experiment on the right restores the
-- exact compositional equality appropriate to this finite language.
--
-- This is not general Isbell duality or an associativity theorem.
------------------------------------------------------------------------

module NaturalMachine.TwoSidedExperimentInterface where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Bool using (Bool ; false ; true)
open import Cubical.Data.Nat using (snotz)
open import Cubical.Data.Sigma using (_×_ ; _,_ ; fst)
open import Cubical.Relation.Nullary using (¬_)

import NaturalMachine.ExactExperimentFullAbstraction as Exp
import NaturalMachine.ExactHadamardInterference as Had
import NaturalMachine.ExactTwoStateAmplitudes as Amp

------------------------------------------------------------------------
-- 1. A one-sided summary fails under future insertion
------------------------------------------------------------------------

plusInput minusInput : Amp.State₂
plusInput  = Had.plusState Amp.oneG
minusInput = Had.minusState Amp.oneG

ImmediateEquivalent : Amp.State₂ → Amp.State₂ → Type₀
ImmediateEquivalent left right =
  (outcome : Bool)
  → Exp.runExperiment Exp.readout left outcome
    ≡ Exp.runExperiment Exp.readout right outcome

-- Current computational-basis readout sees the same two weights (1,1) and
-- installs the same outcome-indexed posterior basis states.
phase-inputs-collide-immediately : ImmediateEquivalent plusInput minusInput
phase-inputs-collide-immediately false = refl
phase-inputs-collide-immediately true  = refl

-- Inserting H on the omitted future side exposes the relative sign: the
-- false-port weights are respectively 4 and 0.
future-H-separates :
  ¬ (Exp.runExperiment Exp.h-readout plusInput false
       ≡ Exp.runExperiment Exp.h-readout minusInput false)
future-H-separates equalHistory = snotz (cong fst equalHistory)

immediate-equivalence-not-future-stable :
  ImmediateEquivalent plusInput minusInput
  × (¬ Exp.OperationallyEquivalent plusInput minusInput)
immediate-equivalence-not-future-stable =
  phase-inputs-collide-immediately ,
  Exp.distinguishing-history→separation
    Exp.h-readout false future-H-separates

------------------------------------------------------------------------
-- 2. Paired past×future contextual signature
------------------------------------------------------------------------

-- The same finite instruction language is used on the two sides of the
-- middle state.  On the left `prepare` is a declared state insertion; on the
-- right `runExperiment` performs its preparation and weighted readout.
PairedSignature : Type₀
PairedSignature = Exp.Experiment → Exp.Experiment → Exp.WeightedHistory

pairedSignature : Amp.State₂ → PairedSignature
pairedSignature middle past future outcome =
  Exp.runExperiment future (Exp.prepare past middle) outcome

TwoSidedEquivalent : Amp.State₂ → Amp.State₂ → Type₀
TwoSidedEquivalent left right =
  (past future : Exp.Experiment) (outcome : Bool)
  → pairedSignature left past future outcome
    ≡ pairedSignature right past future outcome

two-sided→signature : {left right : Amp.State₂}
  → TwoSidedEquivalent left right
  → pairedSignature left ≡ pairedSignature right
two-sided→signature related =
  funExt λ past → funExt λ future → funExt (related past future)

signature→two-sided : {left right : Amp.State₂}
  → pairedSignature left ≡ pairedSignature right
  → TwoSidedEquivalent left right
signature→two-sided equalSignature past future outcome =
  funExt⁻ (funExt⁻ (funExt⁻ equalSignature past) future) outcome

-- Equality of the paired signature is stable under either declared insertion:
-- fixing a past insertion leaves equality for every future, and fixing a
-- future observation leaves equality for every past.
stable-under-left-insertion : {left right : Amp.State₂}
  → TwoSidedEquivalent left right
  → (past : Exp.Experiment) (future : Exp.Experiment) (outcome : Bool)
  → Exp.runExperiment future (Exp.prepare past left) outcome
    ≡ Exp.runExperiment future (Exp.prepare past right) outcome
stable-under-left-insertion related past = related past

stable-under-right-insertion : {left right : Amp.State₂}
  → TwoSidedEquivalent left right
  → (future : Exp.Experiment) (past : Exp.Experiment) (outcome : Bool)
  → Exp.runExperiment future (Exp.prepare past left) outcome
    ≡ Exp.runExperiment future (Exp.prepare past right) outcome
stable-under-right-insertion related future past = related past future
