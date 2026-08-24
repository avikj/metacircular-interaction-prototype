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
-- NaturalMachine.HadamardReadoutInstrument
--
-- Exact interference observed through the two-state instrument.  Equal and
-- opposite relative phases are sent by the unnormalised Hadamard map to
-- opposite computational-basis support channels.  The branch weights are
-- natural-number squared amplitudes and the posteriors are explicit basis
-- states.  No normalization or collapse interpretation is introduced.
------------------------------------------------------------------------

module NaturalMachine.HadamardReadoutInstrument where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Bool using (false ; true)
open import Cubical.Data.Sigma using (_,_)

import NaturalMachine.ExactHadamardInterference as Had
import NaturalMachine.ExactTwoStateAmplitudes as Amp
import NaturalMachine.ExactTwoStateInstrument as Readout

------------------------------------------------------------------------
-- 1. Exact supported and silent branches
------------------------------------------------------------------------

plusEvent minusEvent : Had.Gaussian → Readout.SelectedEvent
plusEvent α  = Had.H (Had.plusState α)  , false
minusEvent α = Had.H (Had.minusState α) , true

plus-supported-readout : (α : Had.Gaussian)
  → Readout.computationalBasisReadout (plusEvent α)
    ≡ (false , Amp.amplitudeWeight (Had.scale₂G α)
             , Readout.basisState false)
plus-supported-readout α =
  cong (λ state → Readout.computationalBasisReadout (state , false))
    (Had.plus-interferes-to-port₀ α)

minus-supported-readout : (α : Had.Gaussian)
  → Readout.computationalBasisReadout (minusEvent α)
    ≡ (true , Amp.amplitudeWeight (Had.scale₂G α)
            , Readout.basisState true)
minus-supported-readout α =
  cong (λ state → Readout.computationalBasisReadout (state , true))
    (Had.minus-interferes-to-port₁ α)

-- The opposite channel has exact zero weight.  Together with the supported
-- branch equations this is the precise, unnormalised meaning of
-- "deterministic port" used here.  If the input amplitude itself is zero,
-- the supported weight is also zero; no positivity claim is smuggled in.
plus-silent-port₁ : (α : Had.Gaussian)
  → Readout.branchWeight true (Had.H (Had.plusState α)) ≡ 0
plus-silent-port₁ α =
  cong (Readout.branchWeight true) (Had.plus-interferes-to-port₀ α)

minus-silent-port₀ : (α : Had.Gaussian)
  → Readout.branchWeight false (Had.H (Had.minusState α)) ≡ 0
minus-silent-port₀ α =
  cong (Readout.branchWeight false) (Had.minus-interferes-to-port₁ α)

------------------------------------------------------------------------
-- 2. The two interference readouts are one X-frame covariance pair
------------------------------------------------------------------------

x-carries-plus-event-to-minus : (α : Had.Gaussian)
  → Readout.xEvent (plusEvent α) ≡ minusEvent α
x-carries-plus-event-to-minus α =
  cong (λ state → state , true)
    ( cong Amp.X (Had.plus-interferes-to-port₀ α)
    ∙ sym (Had.minus-interferes-to-port₁ α) )

-- This is the relative-instrument statement: the opposite-phase readout is
-- obtained by transporting the entire plus-phase branch through the checked
-- X frame, not by identifying the two observer-relative outcomes.
phase-readouts-are-X-frame-covariant : (α : Had.Gaussian)
  → Readout.computationalBasisReadout (minusEvent α)
    ≡ Readout.xResult
        (Readout.computationalBasisReadout (plusEvent α))
phase-readouts-are-X-frame-covariant α =
    sym (cong Readout.computationalBasisReadout
      (x-carries-plus-event-to-minus α))
  ∙ Readout.x-frame-readout-covariant (plusEvent α)

