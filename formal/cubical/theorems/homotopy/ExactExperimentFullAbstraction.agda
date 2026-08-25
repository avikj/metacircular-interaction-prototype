{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- ExactExperimentFullAbstraction
--
-- Probability-free operational equivalence for the current exact finite
-- experiment language.  Each experiment returns the complete two-branch
-- table of unnormalised natural weights and basis-state posteriors.
--
-- Full abstraction here reconstructs precisely that declared experimental
-- signature.  It does not reconstruct Gaussian amplitudes, normalize weights,
-- or claim a complete quantum/RQM observational language.
------------------------------------------------------------------------

module ExactExperimentFullAbstraction where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Bool using (Bool ; false ; true ; not)
open import Cubical.Data.Sigma using (_,_)
open import Cubical.Relation.Nullary using (¬_)

import ExactHadamardInterference as Had
import ExactTwoStateAmplitudes as Amp
import ExactTwoStateInstrument as Readout

------------------------------------------------------------------------
-- 1. The finite declared experiment language
------------------------------------------------------------------------

data Experiment : Type₀ where
  readout x-readout z-readout h-readout : Experiment

prepare : Experiment → Amp.State₂ → Amp.State₂
prepare readout   state = state
prepare x-readout state = Amp.X state
prepare z-readout state = Amp.Z state
prepare h-readout state = Had.H state

WeightedHistory : Type₀
WeightedHistory = (outcome : Bool) → Readout.Posterior outcome

runExperiment : Experiment → Amp.State₂ → WeightedHistory
runExperiment experiment state outcome =
  Readout.basisBranches (prepare experiment state) outcome

ExperimentSignature : Type₀
ExperimentSignature = Experiment → WeightedHistory

signature : Amp.State₂ → ExperimentSignature
signature state experiment = runExperiment experiment state

OperationallyEquivalent : Amp.State₂ → Amp.State₂ → Type₀
OperationallyEquivalent left right =
  (experiment : Experiment) (outcome : Bool)
  → runExperiment experiment left outcome
    ≡ runExperiment experiment right outcome

------------------------------------------------------------------------
-- 2. Full abstraction and exact separation
------------------------------------------------------------------------

-- Agreement in every declared weighted history reconstructs the whole
-- operational signature as a function.  No quotient or hidden extensionality
-- assumption is left outside the checked term.
operational→signature : {left right : Amp.State₂}
  → OperationallyEquivalent left right
  → signature left ≡ signature right
operational→signature agreement =
  funExt λ experiment → funExt (agreement experiment)

signature→operational : {left right : Amp.State₂}
  → signature left ≡ signature right
  → OperationallyEquivalent left right
signature→operational equalSignature experiment outcome =
  funExt⁻ (funExt⁻ equalSignature experiment) outcome

-- Any exact distinguishing experiment/outcome refutes operational
-- equivalence.  This is the executable separation direction.
distinguishing-history→separation : {left right : Amp.State₂}
  (experiment : Experiment) (outcome : Bool)
  → ¬ (runExperiment experiment left outcome
       ≡ runExperiment experiment right outcome)
  → ¬ OperationallyEquivalent left right
distinguishing-history→separation experiment outcome differs agreement =
  differs (agreement experiment outcome)

signature-separation : {left right : Amp.State₂}
  → ¬ (signature left ≡ signature right)
  → ¬ OperationallyEquivalent left right
signature-separation signaturesDiffer agreement =
  signaturesDiffer (operational→signature agreement)

------------------------------------------------------------------------
-- 3. X-frame covariance of the complete weighted readout table
------------------------------------------------------------------------

xHistory : WeightedHistory → WeightedHistory
xHistory history outcome with history (not outcome)
... | weight , posterior = weight , Amp.X posterior

-- X swaps which branch is queried, retains its exact weight, and transports
-- the basis posterior.  Thus covariance holds for the entire table, not only
-- for one externally selected event.
readout-table-X-covariant : (state : Amp.State₂)
  → runExperiment readout (Amp.X state)
    ≡ xHistory (runExperiment readout state)
readout-table-X-covariant state = funExt λ where
  false → refl
  true  → refl

------------------------------------------------------------------------
-- Rigor boundary
--
-- The available scalar system supplies exact natural weights but no lawful
-- total normalization operation: division requires a nonzero-total witness
-- and a rational codomain.  Accordingly this module stops at weighted
-- histories.  Full abstraction is relative to the four declared experiments
-- above and must not be read as state tomography or physical completeness.
------------------------------------------------------------------------
