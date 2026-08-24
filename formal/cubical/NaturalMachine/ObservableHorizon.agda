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
open import Cubical.Foundations.Equiv using (_≃_)
open import Cubical.Foundations.Isomorphism using (Iso ; iso ; isoToEquiv)
open import Cubical.Foundations.HLevels
  using (isSetΠ ; isSetΣ)
open import Cubical.Data.List using (List ; [] ; _∷_ ; length)
open import Cubical.Data.Nat using (ℕ)
open import Cubical.Data.Nat.Order using (_≤_ ; zero-≤)
open import Cubical.Data.Sigma using (_×_ ; Σ-syntax ; _,_ ; fst ; snd)
open import Cubical.Functions.Image
  using (Image ; isPropIsInImage ; restrictToImage)
open import Cubical.HITs.SetQuotients as SQ using ([_] ; eq/)
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

  ----------------------------------------------------------------------
  -- The realized finite window is exactly the complete future quotient
  ----------------------------------------------------------------------

  -- Kernel equality alone does not identify these two types.  The maps
  -- below are constructed independently from the universal properties of
  -- Image and SetQuotient, and their inverse laws are proved before an
  -- equivalence is exposed.
  module FQ = FB.FutureQuotient step setO observe

  meaningOf : X → FQ.Meaning
  meaningOf x = [ x ]

  -- This is the only direction that uses bounded closure: equal realized
  -- windows must determine equal complete futures before quotient paths can
  -- be formed.
  meaning-fiber-constant : FI.FiberConstant window meaningOf
  meaning-fiber-constant x y same-window =
    eq/ x y
      (boundedClosure→futureEq step observe fuel closes
        (responseWindow≡→bounded step observe fuel same-window))

  meaningFactors : FI.FactorsThrough window meaningOf
  meaningFactors =
    FI.fiberConstant→factorsThrough FQ.isSetMeaning window meaningOf
      meaning-fiber-constant

  toMeaning : Carrier → FQ.Meaning
  toMeaning = fst meaningFactors

  toMeaning-restrict : (x : X) → toMeaning (restrictToImage window x) ≡ [ x ]
  toMeaning-restrict x = snd meaningFactors x

  -- The reverse direction needs no closure: complete future equality always
  -- restricts to equality of every bounded response window.
  imageOf : X → Carrier
  imageOf = restrictToImage window

  image-future-constant :
    {x y : X} → FB.FutureEq step observe x y → imageOf x ≡ imageOf y
  image-future-constant future =
    FI.sameObservation→samePoint window
      (bounded→responseWindow≡ step observe fuel
        (futureEq→bounded step observe fuel future))

  fromMeaning : FQ.Meaning → Carrier
  fromMeaning =
    FQ.factor isSetCarrier imageOf image-future-constant

  fromMeaning-[] : (x : X) → fromMeaning [ x ] ≡ imageOf x
  fromMeaning-[] x =
    FQ.factor-[] isSetCarrier imageOf image-future-constant x

  meaning-future-constant :
    {x y : X} → FB.FutureEq step observe x y → meaningOf x ≡ meaningOf y
  meaning-future-constant {x} {y} future = eq/ x y future

  to-from : (meaning : FQ.Meaning)
    → toMeaning (fromMeaning meaning) ≡ meaning
  to-from meaning =
    FQ.factor-unique FQ.isSetMeaning meaningOf meaning-future-constant
      (λ m → toMeaning (fromMeaning m))
      (λ x → cong toMeaning (fromMeaning-[] x) ∙ toMeaning-restrict x)
      meaning
    ∙ sym
      (FQ.factor-unique FQ.isSetMeaning meaningOf meaning-future-constant
        (λ m → m) (λ x → refl) meaning)

  roundTripFactors : FI.FactorsThrough window imageOf
  roundTripFactors =
    (λ carrier → fromMeaning (toMeaning carrier)) ,
    (λ x → cong fromMeaning (toMeaning-restrict x) ∙ fromMeaning-[] x)

  identityFactors : FI.FactorsThrough window imageOf
  identityFactors = (λ carrier → carrier) , (λ x → refl)

  from-to : (carrier : Carrier)
    → fromMeaning (toMeaning carrier) ≡ carrier
  from-to carrier =
    funExt⁻
      (cong fst
        (FI.isPropFactorsThrough isSetCarrier window imageOf
          roundTripFactors identityFactors))
      carrier

  realizedMeaningIso : Iso Carrier FQ.Meaning
  realizedMeaningIso = iso toMeaning fromMeaning to-from from-to

  realizedMeaningEquiv : Carrier ≃ FQ.Meaning
  realizedMeaningEquiv = isoToEquiv realizedMeaningIso

  -- The equivalence is an adapter of machines, not only of carriers: the
  -- realized-image action and the future-quotient action commute exactly.
  leftStepFactors : (action : A)
    → FI.FactorsThrough window (λ x → [ step x action ])
  leftStepFactors action =
    (λ carrier → toMeaning (imageStep carrier action)) ,
    (λ x →
      cong toMeaning (imageStep-restrict x action)
      ∙ toMeaning-restrict (step x action))

  rightStepFactors : (action : A)
    → FI.FactorsThrough window (λ x → [ step x action ])
  rightStepFactors action =
    (λ carrier → FQ.quotStep (toMeaning carrier) action) ,
    (λ x →
      cong (λ m → FQ.quotStep m action) (toMeaning-restrict x)
      ∙ FQ.quotStep-[] x action)

  toMeaning-step : (carrier : Carrier) (action : A)
    → toMeaning (imageStep carrier action)
      ≡ FQ.quotStep (toMeaning carrier) action
  toMeaning-step carrier action =
    funExt⁻
      (cong fst
        (FI.isPropFactorsThrough FQ.isSetMeaning window
          (λ x → [ step x action ])
          (leftStepFactors action) (rightStepFactors action)))
      carrier

  -- The present observation is already the empty coordinate of every
  -- response window.  Hence it descends on the image without any new data.
  imageObserve : Carrier → O
  imageObserve carrier = fst carrier ([] , zero-≤)

  imageObserveFactors : FI.FactorsThrough window observe
  imageObserveFactors = imageObserve , (λ x → refl)

  quotientObserveFactors : FI.FactorsThrough window observe
  quotientObserveFactors =
    (λ carrier → FQ.quotObserve (toMeaning carrier)) ,
    (λ x →
      cong FQ.quotObserve (toMeaning-restrict x)
      ∙ FQ.quotObserve-[] x)

  toMeaning-observe : (carrier : Carrier)
    → imageObserve carrier ≡ FQ.quotObserve (toMeaning carrier)
  toMeaning-observe carrier =
    funExt⁻
      (cong fst
        (FI.isPropFactorsThrough setO window observe
          imageObserveFactors quotientObserveFactors))
      carrier

  -- One-step naturality iterates to every finite action word.  This is a
  -- theorem about the installed machine language, not an enumeration of it.
  toMeaning-run : (carrier : Carrier) (word : List A)
    → toMeaning (FB.run imageStep carrier word)
      ≡ FB.run FQ.quotStep (toMeaning carrier) word
  toMeaning-run carrier [] = refl
  toMeaning-run carrier (action ∷ word) =
    toMeaning-run (imageStep carrier action) word
    ∙ cong (λ meaning → FB.run FQ.quotStep meaning word)
        (toMeaning-step carrier action)

  toMeaning-behavior : (carrier : Carrier) (word : List A)
    → FB.behavior imageStep imageObserve carrier word
      ≡ FB.behavior FQ.quotStep FQ.quotObserve (toMeaning carrier) word
  toMeaning-behavior carrier word =
    toMeaning-observe (FB.run imageStep carrier word)
    ∙ cong FQ.quotObserve (toMeaning-run carrier word)

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
