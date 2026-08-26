{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- A sharply cancelling translation family plus an observation with one
-- distinguished singleton fiber makes one-step response profiles faithful.
-- Consequently the complete FutureBehavior relation is just state equality,
-- and every carrier through which all one-step responses factor is injective.
--
-- This is the abstract checked kernel of the sampled prime-power translation
-- argument.  No valuation, residue ring, or subgroup staircase is constructed
-- here.
------------------------------------------------------------------------

module TranslationPeakObservability where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Equiv using (_≃_)
open import Cubical.Foundations.HLevels using (isPropΠ)
open import Cubical.Foundations.Isomorphism using (iso ; isoToEquiv)
open import Cubical.Data.Bool
  using (Bool ; false ; true ; _⊕_ ; isSetBool ; false≢true)
open import Cubical.Data.List using ([] ; _∷_)
open import Cubical.Data.Sigma using (_×_ ; _,_)
open import Cubical.Data.Unit using (Unit ; tt ; isSetUnit)
open import Cubical.Relation.Nullary using (¬_)

import Descent as Descent
import FutureBehavior as FB

private
  variable
    ℓX ℓO ℓQ : Level

------------------------------------------------------------------------
-- 1. The exact cancellation structure, without an observation assumption
------------------------------------------------------------------------

record CancellationTranslations (ℓX : Level) : Type (ℓ-suc ℓX) where
  field
    State         : Type ℓX
    isSetState    : isSet State
    origin        : State
    translate     : State → State → State
    self-cancels  : (state : State) → translate state state ≡ origin
    cancel-reflects : (left right : State)
                    → translate left right ≡ origin → left ≡ right

open CancellationTranslations

------------------------------------------------------------------------
-- 2. A singleton peak makes every one-step profile faithful
------------------------------------------------------------------------

module PeakObservable
    (translations : CancellationTranslations ℓX)
    (Obs : Type ℓO)
    (isSetObs : isSet Obs)
    (observe : State translations → Obs)
    (peak : Obs)
    (origin-is-peak : observe (origin translations) ≡ peak)
    (peak-reflects-origin : (state : State translations)
                          → observe state ≡ peak
                          → state ≡ origin translations)
    where

  X : Type ℓX
  X = State translations

  step : X → X → X
  step = translate translations

  OneStepProfile : Type (ℓ-max ℓX ℓO)
  OneStepProfile = X → Obs

  oneStepProfile : X → OneStepProfile
  oneStepProfile state action = observe (step state action)

  one-step-profile-injective : {left right : X}
    → oneStepProfile left ≡ oneStepProfile right
    → left ≡ right
  one-step-profile-injective {left} {right} same =
    sym (cancel-reflects translations right left right-cancels)
    where
      same-at-left :
        observe (step left left) ≡ observe (step right left)
      same-at-left = funExt⁻ same left

      right-hits-peak : observe (step right left) ≡ peak
      right-hits-peak =
          sym same-at-left
        ∙ cong observe (self-cancels translations left)
        ∙ origin-is-peak

      right-cancels : step right left ≡ origin translations
      right-cancels = peak-reflects-origin (step right left) right-hits-peak

  ----------------------------------------------------------------------
  -- 3. State paths and complete future equality are equivalent
  ----------------------------------------------------------------------

  state-path→future-eq : {left right : X}
    → left ≡ right
    → FB.FutureEq step observe left right
  state-path→future-eq same word =
    cong (λ state → FB.behavior step observe state word) same

  future-eq→state-path : {left right : X}
    → FB.FutureEq step observe left right
    → left ≡ right
  future-eq→state-path future =
    one-step-profile-injective
      (funExt λ action → future (action ∷ []))

  isPropFutureEq : (left right : X)
    → isProp (FB.FutureEq step observe left right)
  isPropFutureEq left right =
    isPropΠ λ word → isSetObs _ _

  state-path-round : {left right : X} (same : left ≡ right)
    → future-eq→state-path (state-path→future-eq same) ≡ same
  state-path-round {left} {right} same =
    isSetState translations left right _ _

  future-eq-round : {left right : X}
    (future : FB.FutureEq step observe left right)
    → state-path→future-eq (future-eq→state-path future) ≡ future
  future-eq-round {left} {right} future =
    isPropFutureEq left right _ _

  statePath≃futureEq : (left right : X)
    → (left ≡ right) ≃ FB.FutureEq step observe left right
  statePath≃futureEq left right =
    isoToEquiv
      (iso state-path→future-eq future-eq→state-path
        future-eq-round state-path-round)

  ----------------------------------------------------------------------
  -- 4. Every carrier supporting all one-step responses is injective
  ----------------------------------------------------------------------

  AllOneStepResponsesFactor : {Q : Type ℓQ} → (X → Q) → Type _
  AllOneStepResponsesFactor q =
    (action : X) → Descent.Factors q (λ state → oneStepProfile state action)

  all-one-step-factors→injective :
      {Q : Type ℓQ} (q : X → Q)
    → AllOneStepResponsesFactor q
    → {left right : X} → q left ≡ q right → left ≡ right
  all-one-step-factors→injective q factors {left} {right} sameQ =
    one-step-profile-injective
      (funExt λ action →
        Descent.factors→constant
          q (λ state → oneStepProfile state action)
          (factors action) left right sameQ)

  identity-factors-all-one-step-responses :
    AllOneStepResponsesFactor (λ state → state)
  identity-factors-all-one-step-responses action =
    (λ state → oneStepProfile state action) , λ state → refl

------------------------------------------------------------------------
-- 5. Killer: cancellation alone does not make futures faithful
------------------------------------------------------------------------

xor-self-cancels : (state : Bool) → state ⊕ state ≡ false
xor-self-cancels false = refl
xor-self-cancels true  = refl

xor-cancel-reflects : (left right : Bool)
  → left ⊕ right ≡ false → left ≡ right
xor-cancel-reflects false false same = refl
xor-cancel-reflects false true  same = sym same
xor-cancel-reflects true  false same = same
xor-cancel-reflects true  true  same = refl

xorTranslations : CancellationTranslations ℓ-zero
xorTranslations = record
  { State = Bool
  ; isSetState = isSetBool
  ; origin = false
  ; translate = _⊕_
  ; self-cancels = xor-self-cancels
  ; cancel-reflects = xor-cancel-reflects
  }

constantObservation : Bool → Unit
constantObservation _ = tt

constant-future-collision :
  FB.FutureEq (_⊕_) constantObservation false true
constant-future-collision word = refl

constant-observation-does-not-detect-state :
  ¬ ({left right : Bool}
    → FB.FutureEq (_⊕_) constantObservation left right
    → left ≡ right)
constant-observation-does-not-detect-state detects =
  false≢true (detects constant-future-collision)

constant-peak-fiber-is-not-singleton :
  ¬ ((state : Bool) → constantObservation state ≡ tt → state ≡ false)
constant-peak-fiber-is-not-singleton unique =
  false≢true (sym (unique true refl))
