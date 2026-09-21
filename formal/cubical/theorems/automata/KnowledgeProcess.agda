{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- KnowledgeProcess
--
-- A small dependent bridge between exact interaction histories, paired
-- past×future continuation observations, and the Factory IV mixed-corner
-- compiler.  Arithmetic capability and its ranked path are retained as
-- inputs; this module does not inhabit either one.
------------------------------------------------------------------------

module KnowledgeProcess where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Equiv using (_≃_ ; equivFun)
open import Cubical.Data.Nat using (ℕ)
open import Cubical.Data.Sigma using (Σ-syntax ; _×_ ; _,_)
open import Cubical.Data.Unit using (Unit ; tt)
open import Cubical.Relation.Nullary using (¬_)

import ExactExperimentFullAbstraction as Exp
import ExactTwoStateAmplitudes as Amp
import FiniteInformation as FI
import MixedCornerTransferCompiler as Mix
import PairedInterfaceMinimality as Minimal
import RelativeInstrument as RI
import TwoSidedExperimentInterface as Two

------------------------------------------------------------------------
-- 1. Exact full-history observation as a relative instrument
------------------------------------------------------------------------

HistoryPost : Unit → Type₀
HistoryPost tt = Exp.WeightedHistory

-- The singleton outcome says that this instrument returns the whole exact
-- two-branch table rather than stochastically selecting an event.
exactHistoryInstrument :
  RI.Instrument (Exp.Experiment × Amp.State₂) Unit HistoryPost
exactHistoryInstrument (experiment , state) =
  tt , Exp.runExperiment experiment state

exact-history-observation : (experiment : Exp.Experiment) (state : Amp.State₂)
  → exactHistoryInstrument (experiment , state)
    ≡ (tt , Exp.runExperiment experiment state)
exact-history-observation experiment state = refl

-- RelativeInstrument's transport theorem remains the observational change
-- law of this bridge; it transports inputs and dependent posteriors without
-- asserting that observer-relative facts were globally identical.
observational-transport : {A B O : Type₀}
  {Post Post′ : O → Type₀}
  (inputChange : A ≃ B) (postChange : (o : O) → Post o ≃ Post′ o)
  (instrument : RI.Instrument A O Post) (input : A)
  → RI.transportInstrument inputChange postChange instrument
      (equivFun inputChange input)
    ≡ RI.mapInstrumentResult postChange (instrument input)
observational-transport = RI.transportInstrument-covariant

------------------------------------------------------------------------
-- 2. A knowledge state retains observation, continuations, and transition
------------------------------------------------------------------------

module _ {n : ℕ}
  (Witness : ℕ → Mix.CornerState n → Type₀)
  (goal : Mix.CornerState n) where

  record KnowledgeProcess : Type₀ where
    constructor knowledge
    field
      experiment : Exp.Experiment
      middle : Amp.State₂

      -- Present exact interaction history and every declared two-sided
      -- continuation response are retained together.
      observedHistory : Exp.WeightedHistory
      observation-law :
        observedHistory ≡ Exp.runExperiment experiment middle
      continuationCapability : Two.PairedSignature
      continuation-law :
        continuationCapability ≡ Two.pairedSignature middle

      -- Factory IV capability is dependent on the chosen source corner.
      source : Mix.CornerState n
      sourceCapability : Mix.Cofinal Witness source
      certifiedTransition : Mix.RankedPath Witness source goal

  open KnowledgeProcess public

  -- An exact experiment observation enters the mixed-corner interface only
  -- when recurrence capability and a certified ranked path are supplied.
  observe→knowledge-process :
    (experiment : Exp.Experiment) (middle : Amp.State₂)
    (source : Mix.CornerState n)
    → Mix.Cofinal Witness source
    → Mix.RankedPath Witness source goal
    → KnowledgeProcess
  observe→knowledge-process experiment middle source capability route =
    knowledge experiment middle
      (Exp.runExperiment experiment middle) refl
      (Two.pairedSignature middle) refl
      source capability route

  -- The retained certified transition is executable at the type level: it
  -- transports cofinal source capability to the declared goal.
  compile-knowledge-transition : KnowledgeProcess → Mix.Cofinal Witness goal
  compile-knowledge-transition process =
    Mix.path-transports-cofinal Witness
      (certifiedTransition process) (sourceCapability process)

  -- The arithmetic transition cannot erase the independently checked
  -- experiment-interface obstruction: immediate readout still cannot decode
  -- the paired continuation signature.  This is preservation by retention,
  -- not a claim that the two domains are mathematically equivalent.
  transition-preserves-paired-no-go : KnowledgeProcess
    → ¬ FI.FactorsThrough
        Minimal.immediateInterface Minimal.phasePairedSignature
  transition-preserves-paired-no-go process =
    Minimal.immediate-interface-cannot-reconstruct-paired-signature

------------------------------------------------------------------------
-- Rigor boundary
--
-- `observe→knowledge-process` is the requested path from an exact experiment
-- observation into the mixed-corner compiler surface.  Its last two arguments
-- are precisely the uninhabited arithmetic capability and transition fabric;
-- no experiment result is being promoted into a prime theorem.
------------------------------------------------------------------------
