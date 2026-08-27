{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- अविनिमय — no exchange.  THE MACHINE'S STEPS ARE ALL UNITARY WHEN
-- COMPLETED — AND STILL DO NOT EXCHANGE.
--
-- Abstract 01 (unitarity does not give braiding) proved on three
-- Boolean strands that invertibility of the local operators buys no
-- exchange coherence: the braid relations are independent data.  The
-- universal machine says the same sentence in its own dialect, and
-- the two halves are both computations.
--
-- UNITARITY, uniformly: for any table M, the visible step
-- stepOf M = π₂ ∘ uStep (M , _) admits a lossless completion that is
-- an equivalence — and by Ekatva it admits exactly one, so "certified
-- unitary" is not even a certificate here, it is a property every
-- step already has (`every-step-is-unitary`).
--
-- NO EXCHANGE: the successor machine and the eraser fail to commute
-- at a named configuration, one stroke under the head; both composite
-- evaluations are refl and the disagreement is in the control state
-- (`steps-do-not-exchange`).  The witness is shipped as a dependent
-- pair carrying both completions together with the refutation, so
-- what is refuted is the implication "completed-invertible operators
-- exchange", not a statement about bare functions.
--
-- An architecture whose steps are certified reversible-at-the-
-- completed-level has certified nothing about the order of its
-- operations.  Reversibility is free (Ekatva); coherence of exchange
-- is data; the machine exhibits the gap in four rules.
------------------------------------------------------------------------

module Avinimaya_TheMachinesStepsAreAllUnitaryWhenCompletedAndStillDoNotExchange where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Equiv using (_≃_ ; fiber)
open import Cubical.Data.Sigma
open import Cubical.Data.Nat using (ℕ ; znots)
open import Cubical.Data.List using (List ; [] ; _∷_)
open import Cubical.Relation.Nullary using (¬_)

open import Vishvayantra_TheTuringStepIsTheVisibleProjectionOfTheLosslessStepAndTheKeptFibreIsTheSource
open import Vrddhi_AVerifiedProgramTheSuccessorMachineAddsOneStrokeAndItsCertificateIsAFibrePoint
  using (incr)
open import Nasha_TheVisibleStepDestroysInformationAndTheCompletedStepCannotByConstruction
  using (eraser)

------------------------------------------------------------------------
-- §1  Every step is unitary, for free.
------------------------------------------------------------------------

stepOf : Code → Conf → Conf
stepOf M c = snd (uStep (M , c))

-- The completion of any table's step is an equivalence: reversibility
-- is not a design property of good machines but a theorem about all
-- of them.
every-step-is-unitary : (M : Code) → Conf ≃ Σ Conf (fiber (stepOf M))
every-step-is-unitary M = lossless (stepOf M)

------------------------------------------------------------------------
-- §2  And exchange fails, at a named point.
------------------------------------------------------------------------

-- One stroke under the head.
c₀ : Conf
c₀ = 0 , [] , 1 , []

-- Erase then increment: the stroke is gone, the increment writes into
-- the blank and retires — control reaches state 1.
erase-then-incr : stepOf incr (stepOf eraser c₀) ≡ (1 , [] , 1 , [])
erase-then-incr = refl

-- Increment then erase: the increment walks past the stroke, the
-- eraser finds a blank and stands still — control stays in state 0.
incr-then-erase : stepOf eraser (stepOf incr c₀) ≡ (0 , 1 ∷ [] , 0 , [])
incr-then-erase = refl

-- THE REFUTATION, carried with both unitarity certificates: completed
-- invertibility of each operator, and the failure of their exchange,
-- in one dependent pair.
steps-do-not-exchange :
  Σ[ M₁ ∈ Code ] Σ[ M₂ ∈ Code ]
    ( (Conf ≃ Σ Conf (fiber (stepOf M₁)))
    × (Conf ≃ Σ Conf (fiber (stepOf M₂)))
    × (¬ ((c : Conf) → stepOf M₁ (stepOf M₂ c) ≡ stepOf M₂ (stepOf M₁ c))) )
steps-do-not-exchange =
  incr , eraser ,
  every-step-is-unitary incr ,
  every-step-is-unitary eraser ,
  λ comm → znots (sym (cong fst (comm c₀)))
