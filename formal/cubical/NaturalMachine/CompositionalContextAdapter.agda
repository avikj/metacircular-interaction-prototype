{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- NaturalMachine.CompositionalContextAdapter
--
-- Exact adapter for the finite compositional-crystal theorem.  For one
-- binary operation, the elementary one-hole translations
--
--     x ↦ x ∙ fixed          x ↦ fixed ∙ x
--
-- are actions.  Their finite words are precisely the generated unary
-- contexts.  Equality under every such context is therefore an instance of
-- FutureBehavior.FutureEq.  The nontrivial direction checked here is that
-- this unary-action relation is a congruence for the original *binary*
-- operation, and is greatest among all observation-compatible magma
-- congruences.  Consequently the operation descends to the behavioral
-- quotient.
--
-- The final four-state control kills the unsound shortcut “quotient by the
-- current observation kernel”.  Equal observations need not survive even
-- one elementary context; contextual closure is load-bearing.
------------------------------------------------------------------------

module NaturalMachine.CompositionalContextAdapter where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Bool
  using (Bool ; false ; true ; false≢true ; isSetBool)
open import Cubical.Data.List using (List ; [] ; _∷_)
open import Cubical.Data.Sigma using (_×_ ; _,_ ; fst ; snd)
open import Cubical.HITs.SetQuotients as SQ
  using (_/_ ; [_] ; eq/ ; squash/)
open import Cubical.Relation.Nullary using (¬_)

import NaturalMachine.FutureBehavior as FB

private
  variable
    ℓX ℓO ℓR : Level
    X : Type ℓX
    O : Type ℓO

------------------------------------------------------------------------
-- 1.  Binary operations generate unary contexts
------------------------------------------------------------------------

-- `false` leaves the hole on the left; `true` leaves it on the right.
ContextAction : Type ℓX → Type ℓX
ContextAction X = Bool × X

contextStep : (X → X → X) → X → ContextAction X → X
contextStep operation state (false , fixed) = operation state fixed
contextStep operation state (true  , fixed) = operation fixed state

applyContext : (X → X → X) → X → List (ContextAction X) → X
applyContext operation = FB.run (contextStep operation)

-- Equality under every generated unary context.  Keeping this as an exact
-- alias makes the adapter computational: no conversion theorem or choice of
-- representatives is hidden between contexts and future behavior.
ContextEq : (X → X → X) → (X → O) → X → X → Type _
ContextEq operation observe = FB.FutureEq (contextStep operation) observe

contextEq-at : (operation : X → X → X) (observe : X → O)
    {left right : X}
  → ContextEq operation observe left right
  → (context : List (ContextAction X))
  → observe (applyContext operation left context)
    ≡ observe (applyContext operation right context)
contextEq-at operation observe related context = related context

------------------------------------------------------------------------
-- 2.  The algebraic congruence interface
------------------------------------------------------------------------

record isObservedMagmaCongruence
    {X : Type ℓX} {O : Type ℓO}
    (operation : X → X → X) (observe : X → O)
    (S : X → X → Type ℓR)
    : Type (ℓ-max (ℓ-max ℓX ℓO) ℓR) where
  field
    reflexive        : (x : X) → S x x
    symmetric        : {x y : X} → S x y → S y x
    transitive       : {x y z : X} → S x y → S y z → S x z
    respects-observe : {x y : X} → S x y → observe x ≡ observe y
    respects-operation : {x x′ y y′ : X}
      → S x x′ → S y y′ → S (operation x y) (operation x′ y′)

open isObservedMagmaCongruence

-- A magma congruence is stable under each elementary one-hole translation,
-- hence supplies the exact behavioral-congruence interface already checked
-- by FutureBehavior.
magma→behavioral :
    {S : X → X → Type ℓR}
    {operation : X → X → X} {observe : X → O}
  → isObservedMagmaCongruence operation observe S
  → FB.isBehavioralCongruence (contextStep operation) observe S
magma→behavioral congruence = record
  { respects-observe = respects-observe congruence
  ; respects-step = step-preserves
  }
  where
  step-preserves : {x y : X} (action : ContextAction X)
    → _ → _
  step-preserves (false , fixed) related =
    respects-operation congruence related (reflexive congruence fixed)
  step-preserves (true , fixed) related =
    respects-operation congruence (reflexive congruence fixed) related

-- Change the left input, then the right input, using the two elementary
-- contexts; transitivity joins the two checked paths.
contextEq-respects-operation :
    (operation : X → X → X) (observe : X → O)
    {x x′ y y′ : X}
  → ContextEq operation observe x x′
  → ContextEq operation observe y y′
  → ContextEq operation observe (operation x y) (operation x′ y′)
contextEq-respects-operation operation observe {x′ = x′} {y = y} left right =
  FB.futureEq-trans (contextStep operation) observe
    (FB.futureEq-step (contextStep operation) observe left (false , y))
    (FB.futureEq-step (contextStep operation) observe right (true , x′))

-- The contextual relation is itself a congruence for the original binary
-- operation.
contextEq-isMagmaCongruence :
    (operation : X → X → X) (observe : X → O)
  → isObservedMagmaCongruence operation observe
      (ContextEq operation observe)
contextEq-isMagmaCongruence operation observe = record
  { reflexive = FB.futureEq-refl (contextStep operation) observe
  ; symmetric = FB.futureEq-sym (contextStep operation) observe
  ; transitive = FB.futureEq-trans (contextStep operation) observe
  ; respects-observe = λ related → related []
  ; respects-operation = contextEq-respects-operation operation observe
  }

-- Greatestness: every observation-compatible magma congruence is contained
-- in contextual equality.  This is the exact universal-algebraic / Nerode
-- joint, obtained by adapting to FutureBehavior's greatest-congruence theorem.
magmaCongruence→contextEq :
    {S : X → X → Type ℓR}
    {operation : X → X → X} {observe : X → O}
  → isObservedMagmaCongruence operation observe S
  → {x y : X} → S x y → ContextEq operation observe x y
magmaCongruence→contextEq congruence =
  FB.congruence→futureEq (magma→behavioral congruence)

------------------------------------------------------------------------
-- 3.  The operation descends to the contextual quotient
------------------------------------------------------------------------

module ContextQuotient
    (operation : X → X → X) (setO : isSet O) (observe : X → O) where

  step : X → ContextAction X → X
  step = contextStep operation

  module Q = FB.FutureQuotient step setO observe

  Meaning : Type _
  Meaning = Q.Meaning

  _opQ_ : Meaning → Meaning → Meaning
  _opQ_ = SQ.rec2 squash/ (λ x y → [ operation x y ])
    (λ x x′ y related →
      eq/ _ _ (FB.futureEq-step step observe related (false , y)))
    (λ x y y′ related →
      eq/ _ _ (FB.futureEq-step step observe related (true , x)))

  operation-β : (x y : X) → [ x ] opQ [ y ] ≡ [ operation x y ]
  operation-β x y = refl

------------------------------------------------------------------------
-- 4.  Hostile control: the present observation kernel is not compositional
------------------------------------------------------------------------

ControlState : Type₀
ControlState = Bool × Bool

controlObserve : ControlState → Bool
controlObserve = fst

-- The hidden left coordinate becomes visible after one left-hole context.
leakingOperation : ControlState → ControlState → ControlState
leakingOperation left right = snd left , fst right

controlLeft controlRight controlFixed : ControlState
controlLeft  = false , false
controlRight = false , true
controlFixed = false , false

same-now : controlObserve controlLeft ≡ controlObserve controlRight
same-now = refl

not-contextually-equal :
  ¬ ContextEq leakingOperation controlObserve controlLeft controlRight
not-contextually-equal related =
  false≢true (related ((false , controlFixed) ∷ []))

NowEq : ControlState → ControlState → Type₀
NowEq left right = controlObserve left ≡ controlObserve right

-- So the raw observation kernel cannot be supplied to the compositional
-- quotient interface.  Closing under contexts is not optional bookkeeping.
now-kernel-not-magma-congruence :
  ¬ isObservedMagmaCongruence leakingOperation controlObserve NowEq
now-kernel-not-magma-congruence congruence =
  false≢true
    (respects-operation congruence same-now
      (reflexive congruence controlFixed))
