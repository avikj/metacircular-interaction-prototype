{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- NaturalMachine.ObservableHorizon
--
-- Exact Cubical adapter for the semantic half of the concurrent Lean
-- `Pairfield.ObservableHorizon` result.  A bounded response kernel can enter
-- the existing future-behavior quotient exactly when every installed action
-- preserves it.  At that point it is a `FutureBehavior`
-- `isBehavioralCongruence`, so the already-checked greatest-congruence
-- theorem upgrades bounded equality to equality under every future word.
--
-- This module deliberately does not port the visited-pair implementation.
-- Reachable-pair counts, shortest retained witnesses, and queue exhaustion
-- remain Lean evidence.  The adapter below transports only the shared
-- semantic theorem, clause for clause, into the Cubical quotient surface.
------------------------------------------------------------------------

module NaturalMachine.ObservableHorizon where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.HLevels
  using (isSetΠ ; isSetΣ)
open import Cubical.Data.List using (List ; [] ; _∷_ ; length)
open import Cubical.Data.Nat using (ℕ)
open import Cubical.Data.Nat.Order using (_≤_ ; zero-≤)
open import Cubical.Data.Sigma using (_×_ ; Σ-syntax ; _,_ ; fst ; snd)
open import Cubical.Functions.Image
  using (Image ; isPropIsInImage ; restrictToImage)
open import Cubical.Relation.Nullary using (¬_)

import NaturalMachine.FutureBehavior as FB
import NaturalMachine.FiniteInformation as FI

private
  variable
    ℓX ℓA ℓO : Level
    X : Type ℓX
    A : Type ℓA
    O : Type ℓO

------------------------------------------------------------------------
-- Bounded equality and its action-closure obligation
------------------------------------------------------------------------

BoundedFutureEq : (X → A → X) → (X → O) → ℕ → X → X → Type _
BoundedFutureEq {A = A} step observe fuel x y =
  (word : List A) → length word ≤ fuel
  → FB.behavior step observe x word ≡ FB.behavior step observe y word

-- Package the bounded experiment and its length certificate as one input.
-- Equality of the resulting response functions is exactly BoundedFutureEq;
-- the two directions below make that interface conversion explicit.
WindowAt : {A : Type ℓA} → ℕ → Type ℓA
WindowAt {A = A} fuel = Σ[ word ∈ List A ] length word ≤ fuel

ResponseWindow : {A : Type ℓA} → Type ℓO → ℕ → Type _
ResponseWindow {A = A} O fuel = WindowAt {A = A} fuel → O

responseWindow :
    (step : X → A → X) (observe : X → O) (fuel : ℕ)
  → X → ResponseWindow {A = A} O fuel
responseWindow step observe fuel x (word , _) =
  FB.behavior step observe x word

bounded→responseWindow≡ :
    (step : X → A → X) (observe : X → O) (fuel : ℕ) {x y : X}
  → BoundedFutureEq step observe fuel x y
  → responseWindow step observe fuel x
    ≡ responseWindow step observe fuel y
bounded→responseWindow≡ step observe fuel bounded =
  funExt λ window → bounded (fst window) (snd window)

responseWindow≡→bounded :
    (step : X → A → X) (observe : X → O) (fuel : ℕ) {x y : X}
  → responseWindow step observe fuel x
    ≡ responseWindow step observe fuel y
  → BoundedFutureEq step observe fuel x y
responseWindow≡→bounded step observe fuel p word bound =
  funExt⁻ p (word , bound)

ObservableClosesAt : (X → A → X) → (X → O) → ℕ → Type _
ObservableClosesAt {X = X} {A = A} step observe fuel =
  (x y : X) → BoundedFutureEq step observe fuel x y → (action : A)
  → BoundedFutureEq step observe fuel (step x action) (step y action)

-- The empty word is always inside the bounded carrier.  Therefore action
-- closure supplies exactly the two fields demanded by FutureBehavior's
-- native congruence record; no quotient or decoder is constructed twice.
boundedClosure→congruence :
    (step : X → A → X) (observe : X → O) (fuel : ℕ)
  → ObservableClosesAt step observe fuel
  → FB.isBehavioralCongruence step observe
      (BoundedFutureEq step observe fuel)
boundedClosure→congruence step observe fuel closes = record
  { respects-observe = λ bounded → bounded [] zero-≤
  ; respects-step = λ action bounded → closes _ _ bounded action
  }

-- Conversely, the step field of such a congruence is literally bounded
-- closure.  This pins the adapter boundary in both directions.
boundedCongruence→closure :
    (step : X → A → X) (observe : X → O) (fuel : ℕ)
  → FB.isBehavioralCongruence step observe
      (BoundedFutureEq step observe fuel)
  → ObservableClosesAt step observe fuel
boundedCongruence→closure step observe fuel congruence x y bounded action =
  FB.isBehavioralCongruence.respects-step congruence action bounded

closure-iff-bounded-congruence :
    (step : X → A → X) (observe : X → O) (fuel : ℕ)
  → (ObservableClosesAt step observe fuel
      → FB.isBehavioralCongruence step observe
          (BoundedFutureEq step observe fuel))
    × (FB.isBehavioralCongruence step observe
          (BoundedFutureEq step observe fuel)
      → ObservableClosesAt step observe fuel)
closure-iff-bounded-congruence step observe fuel =
  boundedClosure→congruence step observe fuel ,
  boundedCongruence→closure step observe fuel

------------------------------------------------------------------------
-- Stabilization: the bounded kernel equals the complete future kernel
------------------------------------------------------------------------

boundedClosure→futureEq :
    (step : X → A → X) (observe : X → O) (fuel : ℕ)
  → ObservableClosesAt step observe fuel
  → {x y : X} → BoundedFutureEq step observe fuel x y
  → FB.FutureEq step observe x y
boundedClosure→futureEq step observe fuel closes =
  FB.congruence→futureEq
    (boundedClosure→congruence step observe fuel closes)

boundedFuture→closure :
    (step : X → A → X) (observe : X → O) (fuel : ℕ)
  → ((x y : X) → BoundedFutureEq step observe fuel x y
      → FB.FutureEq step observe x y)
  → ObservableClosesAt step observe fuel
boundedFuture→closure step observe fuel future x y bounded action word _ =
  FB.futureEq-step step observe (future x y bounded) action word

observableClosesAt-iff-bounded-implies-future :
    (step : X → A → X) (observe : X → O) (fuel : ℕ)
  → (ObservableClosesAt step observe fuel
      → (x y : X) → BoundedFutureEq step observe fuel x y
        → FB.FutureEq step observe x y)
    × (((x y : X) → BoundedFutureEq step observe fuel x y
          → FB.FutureEq step observe x y)
      → ObservableClosesAt step observe fuel)
observableClosesAt-iff-bounded-implies-future step observe fuel =
  (λ closes x y bounded →
    boundedClosure→futureEq step observe fuel closes {x} {y} bounded) ,
  boundedFuture→closure step observe fuel

-- Complete future equality always restricts to a bounded window.  Under
-- closure, the preceding theorem is its converse, so the two kernels agree
-- pointwise without any finite-state or decidable-equality hypothesis.
futureEq→bounded :
    (step : X → A → X) (observe : X → O) (fuel : ℕ) {x y : X}
  → FB.FutureEq step observe x y
  → BoundedFutureEq step observe fuel x y
futureEq→bounded step observe fuel future word _ = future word

stabilized-kernel :
    (step : X → A → X) (observe : X → O) (fuel : ℕ)
  → ObservableClosesAt step observe fuel
  → {x y : X}
  → (BoundedFutureEq step observe fuel x y
      → FB.FutureEq step observe x y)
    × (FB.FutureEq step observe x y
      → BoundedFutureEq step observe fuel x y)
stabilized-kernel step observe fuel closes =
  boundedClosure→futureEq step observe fuel closes ,
  futureEq→bounded step observe fuel

------------------------------------------------------------------------
-- The induced action exists constructively on the realized image
------------------------------------------------------------------------

-- This is the exact repair of the ambient-total-predictor obstruction.
-- The codomain is not every hypothetical response function: it is the
-- Cubical Image of responses realized by actual states.  FiniteInformation's
-- choice-free descent then constructs the induced action from fiber
-- constancy, with no representative or default value selected.
module RealizedWindow
    (step : X → A → X) (setO : isSet O) (observe : X → O) (fuel : ℕ)
    (closes : ObservableClosesAt step observe fuel) where

  window : X → ResponseWindow {A = A} O fuel
  window = responseWindow step observe fuel

  Carrier : Type _
  Carrier = Image window

  isSetResponseWindow : isSet (ResponseWindow {A = A} O fuel)
  isSetResponseWindow = isSetΠ λ _ → setO

  isSetCarrier : isSet Carrier
  isSetCarrier =
    isSetΣ isSetResponseWindow
      (λ response → isProp→isSet (isPropIsInImage window response))

  advanced : A → X → Carrier
  advanced action x = restrictToImage window (step x action)

  advanced-fiber-constant :
    (action : A) → FI.FiberConstant window (advanced action)
  advanced-fiber-constant action x y same-window =
    FI.sameObservation→samePoint window
      (bounded→responseWindow≡ step observe fuel
        (closes x y
          (responseWindow≡→bounded step observe fuel same-window)
          action))

  actionFactors :
    (action : A) → FI.FactorsThrough window (advanced action)
  actionFactors action =
    FI.fiberConstant→factorsThrough isSetCarrier window (advanced action)
      (advanced-fiber-constant action)

  imageStep : Carrier → A → Carrier
  imageStep carrier action = fst (actionFactors action) carrier

  -- Exact replay on every realized response class.  The proof is the
  -- computation rule of Image descent; it never opens the truncated witness.
  imageStep-restrict :
    (x : X) (action : A)
    → imageStep (restrictToImage window x) action
      ≡ restrictToImage window (step x action)
  imageStep-restrict x action = snd (actionFactors action) x

------------------------------------------------------------------------
-- Retained obstruction
------------------------------------------------------------------------

bounded-collision-obstructs-closure :
    (step : X → A → X) (observe : X → O) {fuel : ℕ} {x y : X}
  → BoundedFutureEq step observe fuel x y
  → (word : List A)
  → ¬ (FB.behavior step observe x word
      ≡ FB.behavior step observe y word)
  → ¬ ObservableClosesAt step observe fuel
bounded-collision-obstructs-closure step observe bounded word separates closes =
  separates (boundedClosure→futureEq step observe _ closes bounded word)
