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
open import Cubical.Data.List using (List ; [] ; _∷_ ; length)
open import Cubical.Data.Nat using (ℕ)
open import Cubical.Data.Nat.Order using (_≤_ ; zero-≤)
open import Cubical.Data.Sigma using (_×_ ; _,_)
open import Cubical.Relation.Nullary using (¬_)

import NaturalMachine.FutureBehavior as FB

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
