{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- NaturalMachine.NormalizedFiniteInstrument
--
-- The smallest normalized readout supported by the current exact scalar
-- lane.  A nonzero-total witness turns the two natural weights into a common-
-- denominator BornDistribution₂; the selected outcome and basis posterior
-- remain explicit.  This is finite rational data, not an analytic measure.
------------------------------------------------------------------------

module NaturalMachine.NormalizedFiniteInstrument where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Bool using (Bool)
open import Cubical.Data.Sigma using (Σ-syntax ; _×_ ; _,_ ; fst ; snd)

import NaturalMachine.ConstructiveBornNormalization as Born
import NaturalMachine.ExactTwoStateAmplitudes as Amp
import NaturalMachine.ExactTwoStateInstrument as Readout
import NaturalMachine.RelativeInstrument as RI

------------------------------------------------------------------------
-- Witnessed-nonzero selected events and normalized posteriors
------------------------------------------------------------------------

NonzeroSelectedEvent : Type₀
NonzeroSelectedEvent =
  Σ[ state ∈ Amp.State₂ ] (Born.NonzeroState state × Bool)

NormalizedPosterior : Bool → Type₀
NormalizedPosterior outcome = Born.BornDistribution₂ × Amp.State₂

normalizedReadout :
  RI.Instrument NonzeroSelectedEvent Bool NormalizedPosterior
normalizedReadout (state , nonzero , outcome) =
  outcome , Born.bornState state nonzero , Readout.basisState outcome

-- The normalized posterior retains exactly the original two branch weights
-- as numerators and their total as its witnessed-positive denominator.
normalized-readout-data :
  (state : Amp.State₂) (nonzero : Born.NonzeroState state) (outcome : Bool)
  → (Born.denominator (fst (snd (normalizedReadout (state , nonzero , outcome))))
        ≡ Amp.norm² state)
    × ((Born.numerator₀
          (fst (snd (normalizedReadout (state , nonzero , outcome))))
          ≡ Amp.weight₀ state)
       × (Born.numerator₁
          (fst (snd (normalizedReadout (state , nonzero , outcome))))
          ≡ Amp.weight₁ state))
normalized-readout-data state nonzero outcome = refl , (refl , refl)

-- Its `Born.sums-to-one` field is therefore the checked normalization law;
-- no second arithmetic assertion or division operation is introduced here.
