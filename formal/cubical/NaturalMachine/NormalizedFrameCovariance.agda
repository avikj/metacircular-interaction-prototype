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
-- NaturalMachine.NormalizedFrameCovariance
--
-- X-frame covariance for constructive two-outcome normalization, followed by
-- exact normalized Hadamard controls.  The common denominator is preserved
-- and the two numerators exchange.  Selected outcomes/posteriors remain
-- explicit; no stochastic selection or collapse interpretation is asserted.
------------------------------------------------------------------------

module NaturalMachine.NormalizedFrameCovariance where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Bool using (false ; true)
open import Cubical.Data.Sigma using (_×_ ; _,_)

import NaturalMachine.ConstructiveBornNormalization as Born
import NaturalMachine.ExactHadamardInterference as Had
import NaturalMachine.ExactTwoStateAmplitudes as Amp
import NaturalMachine.ExactTwoStateInstrument as Readout
import NaturalMachine.NormalizedFiniteInstrument as Normalized

------------------------------------------------------------------------
-- 1. Normalization commutes with X-frame transport
------------------------------------------------------------------------

xNonzero : (state : Amp.State₂)
  → Born.NonzeroState state → Born.NonzeroState (Amp.X state)
xNonzero state (predecessor , positive) =
  predecessor , Amp.X-preserves-norm² state ∙ positive

-- Equality of normalized distributions is stated in their observable data:
-- denominator and numerators.  This avoids making the chosen positivity proof
-- part of the physical comparison.
normalization-X-data :
  (state : Amp.State₂) (nonzero : Born.NonzeroState state)
  → let original = Born.bornState state nonzero
        transported = Born.bornState (Amp.X state) (xNonzero state nonzero)
    in (Born.denominator transported ≡ Born.denominator original)
      × ((Born.numerator₀ transported ≡ Born.numerator₁ original)
         × (Born.numerator₁ transported ≡ Born.numerator₀ original))
normalization-X-data state nonzero =
  Amp.X-preserves-norm² state , (refl , refl)

------------------------------------------------------------------------
-- 2. Exact normalized Hadamard controls
------------------------------------------------------------------------

plusH minusH : Amp.State₂
plusH  = Had.H (Had.plusState Amp.oneG)
minusH = Had.H (Had.minusState Amp.oneG)

plusH-nonzero : Born.NonzeroState plusH
plusH-nonzero = 3 , refl

minusH-nonzero : Born.NonzeroState minusH
minusH-nonzero = 3 , refl

plusNormalized minusNormalized : Born.BornDistribution₂
plusNormalized  = Born.bornState plusH plusH-nonzero
minusNormalized = Born.bornState minusH minusH-nonzero

-- Equal relative phase exits at port 0 with distribution (4/4,0/4).
plus-normalized-data :
  (Born.denominator plusNormalized ≡ 4)
  × ((Born.numerator₀ plusNormalized ≡ 4)
     × (Born.numerator₁ plusNormalized ≡ 0))
plus-normalized-data = refl , (refl , refl)

-- Opposite relative phase exits at port 1 with distribution (0/4,4/4).
minus-normalized-data :
  (Born.denominator minusNormalized ≡ 4)
  × ((Born.numerator₀ minusNormalized ≡ 0)
     × (Born.numerator₁ minusNormalized ≡ 4))
minus-normalized-data = refl , (refl , refl)

plus-normalized-readout :
  Normalized.normalizedReadout (plusH , plusH-nonzero , false)
    ≡ (false , plusNormalized , Readout.basisState false)
plus-normalized-readout = refl

minus-normalized-readout :
  Normalized.normalizedReadout (minusH , minusH-nonzero , true)
    ≡ (true , minusNormalized , Readout.basisState true)
minus-normalized-readout = refl

-- The two Hadamard controls are the X-related instance of the generic law.
hadamard-normalization-X-data :
  (Born.denominator minusNormalized ≡ Born.denominator plusNormalized)
  × ((Born.numerator₀ minusNormalized ≡ Born.numerator₁ plusNormalized)
     × (Born.numerator₁ minusNormalized ≡ Born.numerator₀ plusNormalized))
hadamard-normalization-X-data = normalization-X-data plusH plusH-nonzero

------------------------------------------------------------------------
-- Sequential-history boundary
--
-- `SequentialHadamardReadout` retains unnormalised first and second posterior
-- records, whereas `normalizedReadout` replaces one posterior by a complete
-- distribution.  They are intentionally different dependent codomains, so a
-- sequential normalized covariance theorem requires a dedicated history map;
-- no coercion between them is asserted here.
------------------------------------------------------------------------

