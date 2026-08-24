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
--
-- THE REPAIR HAS BEEN BUILT (recorded 2026-08-15; the sentence above is
-- left standing because it is what the obstruction demands, and this
-- note says who paid it).  `NaturalMachine.FullSequentialTableNormalization`
-- retains exactly that: both outcome branches, each with its first
-- weighted posterior and its exact repeated basis posterior.  From that
-- carrier `normalizeFullTable` produces a `BornDistribution₂`,
-- `normalize-generated-table-correct` shows its denominator and two
-- numerators are the state's own `norm²`, `weight₀`, `weight₁`, and
-- `normalize-table-X-data` supplies the X-covariance law that was
-- vacuous here.
--
-- SCOPE OF THAT CLOSURE, stated so it is not over-read:
--
--   * SUFFICIENCY ONLY.  That module makes no minimality claim for its
--     carrier and says so in its own header.  Nothing yet shows the
--     complete branch table is the SMALLEST carrier admitting an exact
--     normalizer, so "must retain the complete branch table" above is
--     still an upper bound presented as a necessity.
--
--   * THIS FILE IS NOT SUPERSEDED.  The counterexample below is imported
--     back by the repair: `forgetSelected` maps the complete table onto
--     this file's `History`, `forgotten-false-branches-collide` shows the
--     collision reappears the moment a branch is forgotten, and
--     `complete-tables-separate` shows the complete tables do not
--     collide.  The obstruction is what locates the loss, so it is the
--     statement the repair is measured against.
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

HistoryNormalizer : Type₀
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
