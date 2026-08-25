{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- NaturalMachine.ExactTwoStateInstrument
--
-- A two-outcome computational-basis readout for the exact Gaussian-integer
-- amplitude model.  Each branch carries its unnormalized natural-number
-- weight and a basis-state posterior.  Selection of a realized outcome is
-- explicit input data; this module does not manufacture a stochastic sample.
--
-- Pauli X changes the frame by exchanging amplitude coordinates, outcome
-- labels, weights, and posterior basis states.  The checked covariance law
-- says these transformations describe the same paired branch content.  It is
-- not a normalization theorem and makes no collapse-ontology claim.
------------------------------------------------------------------------

module NaturalMachine.ExactTwoStateInstrument where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Equiv using (_≃_)
open import Cubical.Foundations.Isomorphism using (iso ; isoToEquiv)
open import Cubical.Data.Bool using (Bool ; false ; true ; not ; notnot)
open import Cubical.Data.Nat using (ℕ)
open import Cubical.Data.Sigma using (Σ-syntax ; _×_ ; _,_)

import NaturalMachine.ExactTwoStateAmplitudes as Amp
import NaturalMachine.RelativeInstrument as RI

------------------------------------------------------------------------
-- 1. The complete finite branch family
------------------------------------------------------------------------

Outcome₂ : Type₀
Outcome₂ = Bool

basisState : Outcome₂ → Amp.State₂
basisState false = Amp.oneG  , Amp.zeroG
basisState true  = Amp.zeroG , Amp.oneG

branchWeight : Outcome₂ → Amp.State₂ → ℕ
branchWeight false = Amp.weight₀
branchWeight true  = Amp.weight₁

-- The posterior is indexed by its outcome even though both fibres currently
-- have the same carrier.  This leaves the outcome dependency available to
-- later refinements instead of truncating it away.
Posterior : Outcome₂ → Type₀
Posterior _ = ℕ × Amp.State₂

basisBranches : (state : Amp.State₂) (outcome : Outcome₂)
              → Posterior outcome
basisBranches state outcome =
  branchWeight outcome state , basisState outcome

-- An instrument returns an actual outcome, so a deterministic core cannot
-- honestly choose one according to an absent probability law.  The selected
-- event makes the realized branch explicit; `basisBranches` above retains
-- the complete two-branch readout before selection.
SelectedEvent : Type₀
SelectedEvent = Amp.State₂ × Outcome₂

computationalBasisReadout : RI.Instrument SelectedEvent Outcome₂ Posterior
computationalBasisReadout (state , outcome) =
  outcome , basisBranches state outcome

------------------------------------------------------------------------
-- 2. Pauli-X reference-frame change
------------------------------------------------------------------------

xEvent : SelectedEvent → SelectedEvent
xEvent (state , outcome) = Amp.X state , not outcome

xEvent-involutive : (event : SelectedEvent) → xEvent (xEvent event) ≡ event
xEvent-involutive ((α , β) , false) = refl
xEvent-involutive ((α , β) , true)  = refl

xEventEquiv : SelectedEvent ≃ SelectedEvent
xEventEquiv = isoToEquiv
  (iso xEvent xEvent xEvent-involutive xEvent-involutive)

-- Physical branch content transforms together: X swaps the outcome label and
-- sends the associated posterior basis state through the same X action.  The
-- numerical weight is retained, because its channel has already been swapped.
xResult : Σ[ outcome ∈ Outcome₂ ] Posterior outcome
        → Σ[ outcome ∈ Outcome₂ ] Posterior outcome
xResult (outcome , weight , posterior) =
  not outcome , weight , Amp.X posterior

xResult-involutive :
  (result : Σ[ outcome ∈ Outcome₂ ] Posterior outcome)
  → xResult (xResult result) ≡ result
xResult-involutive (false , weight , α , β) = refl
xResult-involutive (true  , weight , α , β) = refl

-- The operational covariance square.  In the X frame, channel 0 is channel
-- 1 and conversely; the corresponding exact weight and basis posterior move
-- with that relabeling.
x-frame-readout-covariant : (event : SelectedEvent)
  → computationalBasisReadout (xEvent event)
    ≡ xResult (computationalBasisReadout event)
x-frame-readout-covariant ((α , β) , false) = refl
x-frame-readout-covariant ((α , β) , true)  = refl

-- Weight-level projections make the inherited Born-weight swap explicit.
x-frame-swaps-branch-weight : (state : Amp.State₂) (outcome : Outcome₂)
  → branchWeight (not outcome) (Amp.X state)
    ≡ branchWeight outcome state
x-frame-swaps-branch-weight state false = refl
x-frame-swaps-branch-weight state true  = refl
