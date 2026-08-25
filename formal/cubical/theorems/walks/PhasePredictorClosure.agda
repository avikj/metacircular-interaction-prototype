{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- PhasePredictorClosure
--
-- R0045's residual-character test and the executability of its predicted
-- phase factor are independent obligations.
--
-- A predicted phase can be reconstructed from a retained phase carrier only
-- when it descends through that carrier.  The two-sign swap is the smallest
-- decisive example: the first character separates the realized diagonal
-- residuals, but predictor pullback sends it to the missing second character.
-- Adjoining that character closes the update exactly.  The product character
-- is retained as a positive control because it is swap-invariant.
--
-- Quotient descent and pullback of characters are standard.  The checked
-- contribution is their exact placement at ActionResidualPhase's load-bearing
-- O_predict interface; no novelty is claimed.
------------------------------------------------------------------------

module PhasePredictorClosure where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Function using (_∘_)
open import Cubical.Data.Sigma using (_×_ ; _,_ ; fst ; snd ; ΣPathP)
open import Cubical.Relation.Nullary using (¬_)

import ResponseCharacterKickback as RK
import ActionRefinement as AR
import StructuredDefect as SD

open RK using (Sign ; plus ; minus ; _·s_ ; plus≢minus ; ·s-comm)

private
  variable
    ℓx ℓa : Level

------------------------------------------------------------------------
-- 1. The missing operator interface is ordinary descent
------------------------------------------------------------------------

module PhasePullback
  {X : Type ℓx} {A : Type ℓa}
  (q : X → A) (predict : A → A) (χ : A → Sign) where

  currentPhase predictedPhase : X → Sign
  currentPhase = χ ∘ q
  predictedPhase = χ ∘ predict ∘ q

  -- This is the exact carrier-relative reading of "O_predict is
  -- executable": a decoder on the retained phase label replays the pulled-
  -- back phase on every realized state.
  PhasePredictorCompiler : Type _
  PhasePredictorCompiler = AR.Refines currentPhase predictedPhase

  PhasePredictorCollision : Type _
  PhasePredictorCollision =
    AR.ActionCollision currentPhase predictedPhase

  collision-obstructs-phase-compiler :
    PhasePredictorCollision → ¬ PhasePredictorCompiler
  collision-obstructs-phase-compiler =
    SD.separatedPair→reopens currentPhase predictedPhase

------------------------------------------------------------------------
-- 2. Two signs: residual separation passes while predictor closure fails
------------------------------------------------------------------------

module SwapBoundary where

  State : Type₀
  State = Sign × Sign

  swap : State → State
  swap (a , b) = b , a

  currentPhase predictedPhase : State → Sign
  currentPhase = fst
  predictedPhase = fst ∘ swap

  -- Identity state action versus the coordinate-swap response predictor.
  -- In the sign group inverse equals itself, so the relative phase and the
  -- first character of the response residual are both a·b.
  relativePhase : State → Sign
  relativePhase x = currentPhase x ·s predictedPhase x

  realizedResidual : State → State
  realizedResidual x = relativePhase x , relativePhase x

  residualCharacter : State → Sign
  residualCharacter = fst

  relative-phase-is-residual-character :
    (x : State) →
    relativePhase x ≡ residualCharacter (realizedResidual x)
  relative-phase-is-residual-character _ = refl

  -- R0045's kernel audit passes on the realized residual image: the first
  -- character determines every diagonal residual exactly.
  residual-character-separates-realized-image :
    (x y : State)
    → residualCharacter (realizedResidual x)
      ≡ residualCharacter (realizedResidual y)
    → realizedResidual x ≡ realizedResidual y
  residual-character-separates-realized-image x y h = ΣPathP (h , h)

  phase-predictor-collision :
    AR.ActionCollision currentPhase predictedPhase
  phase-predictor-collision =
    (plus , plus) , (plus , minus) , refl , plus≢minus

  -- Nevertheless the pulled-back/predicted phase is the missing second
  -- coordinate, so no postprocessing of the retained first phase can form it.
  no-current-phase-predictor :
    ¬ (AR.Refines currentPhase predictedPhase)
  no-current-phase-predictor =
    SD.separatedPair→reopens currentPhase predictedPhase
      phase-predictor-collision

  jointPhase : State → Sign × Sign
  jointPhase x = currentPhase x , predictedPhase x

  -- Adjoining the pulled-back character closes the response process: the
  -- next joint phase is obtained by swapping the two retained signs.
  joint-phase-predicts-swap :
    AR.Refines jointPhase (jointPhase ∘ swap)
  joint-phase-predicts-swap = swap , λ { (a , b) → refl }

  module Repair = AR.ProductRefinement currentPhase predictedPhase

  second-character-is-forced-repair :
    AR.Refines jointPhase currentPhase × SD.Reopens currentPhase jointPhase
  second-character-is-forced-repair =
    Repair.collision-forces-strict-refinement phase-predictor-collision

------------------------------------------------------------------------
-- 3. Positive control: an invariant quotient really does close
------------------------------------------------------------------------

  productPhase : State → Sign
  productPhase (a , b) = a ·s b

  product-phase-swap-invariant :
    (x : State) → productPhase x ≡ productPhase (swap x)
  product-phase-swap-invariant (a , b) = ·s-comm a b

  product-phase-predictor :
    AR.Refines productPhase (productPhase ∘ swap)
  product-phase-predictor =
    (λ z → z) , product-phase-swap-invariant

  -- The requested decisive conjunction: sensitivity of the residual phase
  -- does not imply executability of the predicted phase factor.
  residual-separates-but-predictor-does-not-close :
    ((x y : State)
      → residualCharacter (realizedResidual x)
        ≡ residualCharacter (realizedResidual y)
      → realizedResidual x ≡ realizedResidual y)
    × (¬ (AR.Refines currentPhase predictedPhase))
  residual-separates-but-predictor-does-not-close =
    residual-character-separates-realized-image ,
    no-current-phase-predictor
