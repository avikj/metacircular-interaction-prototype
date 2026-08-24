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
-- NaturalMachine.NormalizationInterfaceMinimality
--
-- Two exact interfaces for two different continuation classes:
--
--   * normalization-minimal: the two first weights plus positivity;
--   * sequential-complete:   the full two-branch posterior/history table.
--
-- Born normalization factors through the first.  The second contains option
-- value for later sequential experiments and cannot be reconstructed from the
-- normalization interface alone.
------------------------------------------------------------------------

module NaturalMachine.NormalizationInterfaceMinimality where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Bool using (false ; true)
open import Cubical.Data.Nat using (snotz)
open import Cubical.Data.Sigma using (Σ-syntax ; _×_ ; _,_ ; fst ; snd)
open import Cubical.Relation.Nullary using (¬_)

import NaturalMachine.ConstructiveBornNormalization as Born
import NaturalMachine.ExactTwoStateAmplitudes as Amp
import NaturalMachine.ExactTwoStateInstrument as Readout
import NaturalMachine.FiniteInformation as FI
import NaturalMachine.FullSequentialTableNormalization as Full

------------------------------------------------------------------------
-- 1. The normalization interface and exact factorization
------------------------------------------------------------------------

SequentialCompleteInput : Type₀
SequentialCompleteInput =
  Σ[ table ∈ Full.FullSequentialTable ] Full.NonzeroTable table

NormalizationInterface : Type₀
NormalizationInterface =
  Σ[ weights ∈ Born.Weights ] Born.NonzeroWeights weights

forgetHistory : SequentialCompleteInput → NormalizationInterface
forgetHistory (table , nonzero) = Full.tableWeights table , nonzero

normalizationDecoder : NormalizationInterface → Born.BornDistribution₂
normalizationDecoder (weights , nonzero) =
  Born.normalizeWeights weights nonzero

normalizeComplete : SequentialCompleteInput → Born.BornDistribution₂
normalizeComplete input = normalizationDecoder (forgetHistory input)

-- The factorization is constructed directly on the image, so no default
-- table or choice of a hidden history is required.
normalization-factors-through-minimal-interface :
  FI.FactorsThrough forgetHistory normalizeComplete
normalization-factors-through-minimal-interface =
  (λ image → normalizationDecoder (fst image)) , (λ input → refl)

-- Existing finite-information machinery turns factorization into the exact
-- kernel statement: equality of normalization interfaces forces equality of
-- normalized results.
normalization-kernel-sufficient :
  FI.FiberConstant forgetHistory normalizeComplete
normalization-kernel-sufficient =
  FI.factorsThrough→fiberConstant forgetHistory normalizeComplete
    normalization-factors-through-minimal-interface

------------------------------------------------------------------------
-- 2. Posterior fields are option value, not normalization input
------------------------------------------------------------------------

tableA tableB : Full.FullSequentialTable
tableA = Full.fullSequentialTable (Amp.oneG , Amp.zeroG)
tableB false =
  fst (tableA false) , (fst (snd (tableA false)) , Readout.basisState true)
tableB true = tableA true

tableA-nonzero : Full.NonzeroTable tableA
tableA-nonzero = 0 , refl

tableB-nonzero : Full.NonzeroTable tableB
tableB-nonzero = 0 , refl

inputA inputB : SequentialCompleteInput
inputA = tableA , tableA-nonzero
inputB = tableB , tableB-nonzero

-- Changing only a repeated posterior leaves the normalization interface and
-- therefore the Born distribution unchanged.
posterior-change-invisible-to-normalization :
  forgetHistory inputA ≡ forgetHistory inputB
posterior-change-invisible-to-normalization = refl

posterior-change-preserves-normalized-result :
  normalizeComplete inputA ≡ normalizeComplete inputB
posterior-change-preserves-normalized-result =
  normalization-kernel-sufficient inputA inputB
    posterior-change-invisible-to-normalization

-- But the complete sequential tables are distinct: their repeated false-port
-- posterior states have first-channel weights one and zero.
posterior-change-visible-sequentially : ¬ (tableA ≡ tableB)
posterior-change-visible-sequentially equalTables =
  snotz (cong
    (λ table → Amp.weight₀ (snd (snd (table false)))) equalTables)

------------------------------------------------------------------------
-- 3. The smaller interface cannot reconstruct the larger one
------------------------------------------------------------------------

SequentialReconstructor : Type₀
SequentialReconstructor =
  Σ[ reconstruct ∈ (NormalizationInterface → Full.FullSequentialTable) ]
    ((input : SequentialCompleteInput)
      → reconstruct (forgetHistory input) ≡ fst input)

no-sequential-reconstruction-from-normalization :
  ¬ SequentialReconstructor
no-sequential-reconstruction-from-normalization (reconstruct , correct) =
  posterior-change-visible-sequentially
    ( sym (correct inputA)
    ∙ cong reconstruct posterior-change-invisible-to-normalization
    ∙ correct inputB )

-- This establishes task-relative minimality only in the kernel sense supplied
-- by FiniteInformation: all normalization behavior factors through weights +
-- positivity, while posterior history is necessary for the larger sequential
-- continuation class.  No claim is made that FullSequentialTable is minimal.
