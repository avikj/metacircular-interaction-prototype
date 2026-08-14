{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- NaturalMachine.SequentialNormalizationObstruction
--
-- A typed obstruction to normalizing a retained selected-event history.
-- Such a history records the selected branch weight and its repeated basis
-- posterior, but not the omitted branch weight.  Even when both underlying
-- states carry positive-total witnesses, identical retained histories can
-- require different normalized distributions.
--
-- Therefore no exact projection to BornDistribution₂ can be defined from
-- this history carrier alone, and an X-commutation law for such a projection
-- would be vacuous.  A future repair must retain the complete branch table.
------------------------------------------------------------------------

module NaturalMachine.SequentialNormalizationObstruction where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Bool using (false)
open import Cubical.Data.Nat using (znots ; injSuc)
open import Cubical.Data.Sigma using (Σ-syntax ; _×_ ; _,_)
open import Cubical.Relation.Nullary using (¬_)

import NaturalMachine.ConstructiveBornNormalization as Born
import NaturalMachine.ExactTwoStateAmplitudes as Amp
import NaturalMachine.ExactTwoStateInstrument as Readout
import NaturalMachine.SequentialHadamardReadout as Seq

------------------------------------------------------------------------
-- 1. Same selected history, different complete weight tables
------------------------------------------------------------------------

History : Type₀
History =
  Σ[ outcomes ∈ Readout.Outcome₂ × Readout.Outcome₂ ]
    Seq.HistoryPosterior (fst outcomes) (snd outcomes)

history₀ : Amp.State₂ → History
history₀ state = Seq.sequentialReadout (state , false)

onlyPort₀ bothPorts : Amp.State₂
onlyPort₀ = Amp.oneG , Amp.zeroG
bothPorts = Amp.oneG , Amp.oneG

-- Both selected-false histories record first weight one, then the repeated
-- basis-zero posterior of weight one.  The unselected channel is absent.
selected-histories-collide : history₀ onlyPort₀ ≡ history₀ bothPorts
selected-histories-collide = refl

onlyPort₀-nonzero : Born.NonzeroState onlyPort₀
onlyPort₀-nonzero = 0 , refl

bothPorts-nonzero : Born.NonzeroState bothPorts
bothPorts-nonzero = 1 , refl

onlyPort₀Born bothPortsBorn : Born.BornDistribution₂
onlyPort₀Born = Born.bornState onlyPort₀ onlyPort₀-nonzero
bothPortsBorn = Born.bornState bothPorts bothPorts-nonzero

normalized-distributions-differ : ¬ (onlyPort₀Born ≡ bothPortsBorn)
normalized-distributions-differ equalDistribution =
  znots (injSuc (cong Born.denominator equalDistribution))

------------------------------------------------------------------------
-- 2. No exact history-only normalizer
------------------------------------------------------------------------

HistoryNormalizer : Type₁
HistoryNormalizer =
  Σ[ normalize ∈ (History → Born.BornDistribution₂) ]
    ((state : Amp.State₂) (nonzero : Born.NonzeroState state)
      → normalize (history₀ state) ≡ Born.bornState state nonzero)

no-history-only-normalizer : ¬ HistoryNormalizer
no-history-only-normalizer (normalize , correct) =
  normalized-distributions-differ
    ( sym (correct onlyPort₀ onlyPort₀-nonzero)
    ∙ cong normalize selected-histories-collide
    ∙ correct bothPorts bothPorts-nonzero )

-- The obstruction persists despite positive-total witnesses on both sides.
-- Those witnesses certify 1>0 and 2>0 respectively; they do not reveal the
-- missing second numerator from the common retained history.

