{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- FullSequentialTableNormalization
--
-- Constructive repair of the selected-history normalization obstruction.
-- The carrier retains both outcome branches, each with its first weighted
-- posterior and its exact repeated basis posterior.  Both first-stage weights
-- are therefore available for witnessed-positive normalization.
--
-- Sufficiency is proved.  No minimality claim is made for this carrier.
------------------------------------------------------------------------

module FullSequentialTableNormalization where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Bool using (Bool ; false ; true ; not)
open import Cubical.Data.Nat using (znots ; _+_ ; +-comm)
open import Cubical.Data.Sigma using (_×_ ; _,_ ; fst ; snd)
open import Cubical.Relation.Nullary using (¬_)

import ConstructiveBornNormalization as Born
import ExactTwoStateAmplitudes as Amp
import ExactTwoStateInstrument as Readout
import SequentialHadamardReadout as Seq
import SequentialNormalizationObstruction as Obstruction

------------------------------------------------------------------------
-- 1. Complete two-branch sequential carrier
------------------------------------------------------------------------

FullSequentialTable : Type₀
FullSequentialTable =
  (outcome : Bool) → Readout.Posterior outcome × Readout.Posterior outcome

fullSequentialTable : Amp.State₂ → FullSequentialTable
fullSequentialTable state outcome =
  Readout.basisBranches state outcome ,
  Readout.basisBranches (Readout.basisState outcome) outcome

tableWeights : FullSequentialTable → Born.Weights
tableWeights table =
  fst (fst (table false)) , fst (fst (table true))

NonzeroTable : FullSequentialTable → Type₀
NonzeroTable table = Born.NonzeroWeights (tableWeights table)

NormalizedFullTable : Type₀
NormalizedFullTable = Born.BornDistribution₂ × FullSequentialTable

normalizeFullTable : (table : FullSequentialTable)
  → NonzeroTable table → NormalizedFullTable
normalizeFullTable table nonzero =
  Born.normalizeWeights (tableWeights table) nonzero , table

state-nonzero→table-nonzero : (state : Amp.State₂)
  → Born.NonzeroState state → NonzeroTable (fullSequentialTable state)
state-nonzero→table-nonzero state nonzero = nonzero

-- Normalization of a generated table has exactly the state's total and two
-- branch weights as denominator/numerators.
normalize-generated-table-correct :
  (state : Amp.State₂) (nonzero : Born.NonzeroState state)
  → let distribution = fst (normalizeFullTable (fullSequentialTable state)
          (state-nonzero→table-nonzero state nonzero))
    in (Born.denominator distribution ≡ Amp.norm² state)
      × ((Born.numerator₀ distribution ≡ Amp.weight₀ state)
         × (Born.numerator₁ distribution ≡ Amp.weight₁ state))
normalize-generated-table-correct state nonzero = refl , (refl , refl)

------------------------------------------------------------------------
-- 2. X covariance of table and normalization data
------------------------------------------------------------------------

xPosterior : {outcome : Bool} → Readout.Posterior outcome
  → Readout.Posterior (not outcome)
xPosterior (weight , posterior) = weight , Amp.X posterior

xFullTable : FullSequentialTable → FullSequentialTable
xFullTable table outcome =
  xPosterior {outcome = not outcome} (fst (table (not outcome))) ,
  xPosterior {outcome = not outcome} (snd (table (not outcome)))

generated-table-X-covariant : (state : Amp.State₂)
  → fullSequentialTable (Amp.X state)
    ≡ xFullTable (fullSequentialTable state)
generated-table-X-covariant state = funExt λ where
  false → refl
  true  → refl

x-table-nonzero : (table : FullSequentialTable)
  → NonzeroTable table → NonzeroTable (xFullTable table)
x-table-nonzero table (predecessor , positive) =
  predecessor ,
    +-comm (fst (fst (table true))) (fst (fst (table false))) ∙ positive

normalize-table-X-data : (table : FullSequentialTable)
  (nonzero : NonzeroTable table)
  → let original = fst (normalizeFullTable table nonzero)
        transported = fst (normalizeFullTable (xFullTable table)
          (x-table-nonzero table nonzero))
    in (Born.denominator transported ≡ Born.denominator original)
      × ((Born.numerator₀ transported ≡ Born.numerator₁ original)
         × (Born.numerator₁ transported ≡ Born.numerator₀ original))
normalize-table-X-data table nonzero =
  +-comm (fst (fst (table true))) (fst (fst (table false))) ,
  (refl , refl)

------------------------------------------------------------------------
-- 3. Forgetting a branch recreates the obstruction
------------------------------------------------------------------------

forgetSelected : FullSequentialTable → (outcome : Bool) → Obstruction.History
forgetSelected table outcome = (outcome , outcome) , table outcome

forget-generated-is-selected-history :
  (state : Amp.State₂) (outcome : Bool)
  → forgetSelected (fullSequentialTable state) outcome
    ≡ Seq.sequentialReadout (state , outcome)
forget-generated-is-selected-history state false = refl
forget-generated-is-selected-history state true  = refl

forgotten-false-branches-collide :
  forgetSelected (fullSequentialTable Obstruction.onlyPort₀) false
    ≡ forgetSelected (fullSequentialTable Obstruction.bothPorts) false
forgotten-false-branches-collide = refl

-- The complete tables do not collide: their true-branch first weights are
-- zero and one.  Thus the loss occurs exactly at selected-branch forgetting.
complete-tables-separate :
  ¬ (fullSequentialTable Obstruction.onlyPort₀
       ≡ fullSequentialTable Obstruction.bothPorts)
complete-tables-separate equalTables =
  znots (cong (λ table → fst (fst (table true))) equalTables)
