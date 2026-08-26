{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- SequentialHadamardReadout
--
-- Sequential histories for the exact two-state readout.  The second readout
-- consumes the first basis-state posterior, repeats its explicit selected
-- outcome, and retains both posterior records.  This is deterministic
-- selected-event semantics: no stochastic sampling and no collapse ontology.
------------------------------------------------------------------------

module SequentialHadamardReadout where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Bool using (Bool ; false ; true ; not)
open import Cubical.Data.Nat using (ℕ)
open import Cubical.Data.Sigma
  using (Σ-syntax ; _×_ ; _,_ ; fst ; snd)

import ExactHadamardInterference as Had
import ExactTwoStateAmplitudes as Amp
import ExactTwoStateInstrument as Readout
import HadamardReadoutInstrument as HReadout
import RelativeInstrument as RI

------------------------------------------------------------------------
-- 1. A repeat instrument retaining the complete first branch
------------------------------------------------------------------------

HistoryPosterior : Bool → Bool → Type₀
HistoryPosterior first second =
  Readout.Posterior first × Readout.Posterior second

repeatWithHistory : (first : Bool)
  → RI.Instrument (Readout.Posterior first) Bool
      (λ second → HistoryPosterior first second)
repeatWithHistory first prior =
  first , prior , Readout.basisBranches (snd prior) first

sequentialReadout :
  RI.Instrument Readout.SelectedEvent (Bool × Bool)
    (λ outcomes → HistoryPosterior (fst outcomes) (snd outcomes))
sequentialReadout =
  RI.sequential Readout.computationalBasisReadout repeatWithHistory

expectedHistory : Amp.State₂ → (outcome : Bool)
  → Σ[ outcomes ∈ Bool × Bool ]
      HistoryPosterior (fst outcomes) (snd outcomes)
expectedHistory state false =
  (false , false) ,
    (Readout.branchWeight false state , Readout.basisState false) ,
    (1 , Readout.basisState false)
expectedHistory state true =
  (true , true) ,
    (Readout.branchWeight true state , Readout.basisState true) ,
    (1 , Readout.basisState true)

-- Exact repeatability: after the first selected branch has installed its
-- basis posterior, the same selected basis readout returns the same outcome
-- with exact unnormalised weight one.
basis-readout-repeatable : (state : Amp.State₂) (outcome : Bool)
  → sequentialReadout (state , outcome) ≡ expectedHistory state outcome
basis-readout-repeatable state false = refl
basis-readout-repeatable state true  = refl

------------------------------------------------------------------------
-- 2. Exact Hadamard experiment histories
------------------------------------------------------------------------

plus-history : (α : Had.Gaussian)
  → sequentialReadout (HReadout.plusEvent α)
    ≡ ((false , false) ,
        (Amp.amplitudeWeight (Had.scale₂G α) , Readout.basisState false) ,
        (1 , Readout.basisState false))
plus-history α =
  cong (λ state → sequentialReadout (state , false))
    (Had.plus-interferes-to-port₀ α)

minus-history : (α : Had.Gaussian)
  → sequentialReadout (HReadout.minusEvent α)
    ≡ ((true , true) ,
        (Amp.amplitudeWeight (Had.scale₂G α) , Readout.basisState true) ,
        (1 , Readout.basisState true))
minus-history α =
  cong (λ state → sequentialReadout (state , true))
    (Had.minus-interferes-to-port₁ α)

------------------------------------------------------------------------
-- 3. Full-history X-frame covariance
------------------------------------------------------------------------

xPosterior : {outcome : Bool} → Readout.Posterior outcome
           → Readout.Posterior (not outcome)
xPosterior (weight , state) = weight , Amp.X state

xHistory :
  (Σ[ outcomes ∈ Bool × Bool ]
    HistoryPosterior (fst outcomes) (snd outcomes))
  → (Σ[ outcomes ∈ Bool × Bool ]
    HistoryPosterior (fst outcomes) (snd outcomes))
xHistory ((first , second) , prior , repeated) =
  (not first , not second) ,
    xPosterior {outcome = first} prior ,
    xPosterior {outcome = second} repeated

x-history-involutive :
  (history : Σ[ outcomes ∈ Bool × Bool ]
    HistoryPosterior (fst outcomes) (snd outcomes))
  → xHistory (xHistory history) ≡ history
x-history-involutive ((false , false) , (w₀ , α , β) , (w₁ , γ , δ)) = refl
x-history-involutive ((false , true)  , (w₀ , α , β) , (w₁ , γ , δ)) = refl
x-history-involutive ((true  , false) , (w₀ , α , β) , (w₁ , γ , δ)) = refl
x-history-involutive ((true  , true)  , (w₀ , α , β) , (w₁ , γ , δ)) = refl

-- Both outcome labels, both weights, and both posterior states transform as
-- one paired history.  This is stronger than covariance of the first readout
-- alone and preserves the operational record through sequential composition.
sequential-readout-X-covariant : (event : Readout.SelectedEvent)
  → sequentialReadout (Readout.xEvent event)
    ≡ xHistory (sequentialReadout event)
sequential-readout-X-covariant ((α , β) , false) = refl
sequential-readout-X-covariant ((α , β) , true)  = refl

phase-histories-are-X-frame-covariant : (α : Had.Gaussian)
  → sequentialReadout (HReadout.minusEvent α)
    ≡ xHistory (sequentialReadout (HReadout.plusEvent α))
phase-histories-are-X-frame-covariant α =
    sym (cong sequentialReadout (HReadout.x-carries-plus-event-to-minus α))
  ∙ sequential-readout-X-covariant (HReadout.plusEvent α)
