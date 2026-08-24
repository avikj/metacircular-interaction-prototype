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
open import Cubical.Foundations.HLevels using (isPropΠ)
open import Cubical.Foundations.Isomorphism using (Iso ; iso)
open import Cubical.Data.Bool
  using (Bool ; false ; true ; false≢true ; isSetBool)
open import Cubical.Data.List using (List ; [] ; _∷_)
open import Cubical.Data.Sigma using (_×_ ; _,_ ; fst ; snd)
open import Cubical.Data.Sum using (_⊎_ ; inl ; inr)
open import Cubical.HITs.SetQuotients as SQ
  using (_/_ ; [_] ; eq/ ; squash/)
open import Cubical.Relation.Nullary using (¬_)

import NaturalMachine.FutureBehavior as FB

private
  variable
    ℓX ℓO ℓR ℓA ℓB ℓS ℓY : Level
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

-- The ordinary one-hole term grammar, written from the hole outwards.  The
-- continuation is the outer context still to be applied.
data OneHoleContext (X : Type ℓX) : Type ℓX where
  hole      : OneHoleContext X
  leftHole  : X → OneHoleContext X → OneHoleContext X
  rightHole : X → OneHoleContext X → OneHoleContext X

plug : (X → X → X) → OneHoleContext X → X → X
plug operation hole state = state
plug operation (leftHole fixed outer) state =
  plug operation outer (operation state fixed)
plug operation (rightHole fixed outer) state =
  plug operation outer (operation fixed state)

compileContext : OneHoleContext X → List (ContextAction X)
compileContext hole = []
compileContext (leftHole fixed outer) =
  (false , fixed) ∷ compileContext outer
compileContext (rightHole fixed outer) =
  (true , fixed) ∷ compileContext outer

plug-compile : (operation : X → X → X)
    (context : OneHoleContext X) (state : X)
  → plug operation context state
    ≡ applyContext operation state (compileContext context)
plug-compile operation hole state = refl
plug-compile operation (leftHole fixed outer) state =
  plug-compile operation outer (operation state fixed)
plug-compile operation (rightHole fixed outer) state =
  plug-compile operation outer (operation fixed state)

decodeContext : List (ContextAction X) → OneHoleContext X
decodeContext [] = hole
decodeContext ((false , fixed) ∷ word) = leftHole fixed (decodeContext word)
decodeContext ((true , fixed) ∷ word) = rightHole fixed (decodeContext word)

compile-decode : (word : List (ContextAction X))
  → compileContext (decodeContext word) ≡ word
compile-decode [] = refl
compile-decode ((false , fixed) ∷ word) =
  cong ((false , fixed) ∷_) (compile-decode word)
compile-decode ((true , fixed) ∷ word) =
  cong ((true , fixed) ∷_) (compile-decode word)

-- Equality under every generated unary context.  Keeping this as an exact
-- alias makes the adapter computational: no conversion theorem or choice of
-- representatives is hidden between contexts and future behavior.
ContextEq : (X → X → X) → (X → O) → X → X → Type _
ContextEq operation observe = FB.FutureEq (contextStep operation) observe

SyntacticContextEq : (X → X → X) → (X → O) → X → X → Type _
SyntacticContextEq {X = X} operation observe left right =
  (context : OneHoleContext X)
  → observe (plug operation context left)
    ≡ observe (plug operation context right)

contextEq→syntactic : (operation : X → X → X) (observe : X → O)
    {left right : X}
  → ContextEq operation observe left right
  → SyntacticContextEq operation observe left right
contextEq→syntactic operation observe {left} {right} related context =
  cong observe (plug-compile operation context left)
  ∙ related (compileContext context)
  ∙ sym (cong observe (plug-compile operation context right))

syntactic→contextEq : (operation : X → X → X) (observe : X → O)
    {left right : X}
  → SyntacticContextEq operation observe left right
  → ContextEq operation observe left right
syntactic→contextEq operation observe {left} {right} related word =
  sym (cong (λ actions → observe (applyContext operation left actions))
        (compile-decode word))
  ∙ sym (cong observe (plug-compile operation (decodeContext word) left))
  ∙ related (decodeContext word)
  ∙ cong observe (plug-compile operation (decodeContext word) right)
  ∙ cong (λ actions → observe (applyContext operation right actions))
      (compile-decode word)

-- The syntactic and machine presentations are not merely mutually usable:
-- for set-valued observations their proof spaces are isomorphic.
syntactic-futureIso : (operation : X → X → X) (setO : isSet O)
    (observe : X → O) (left right : X)
  → Iso (SyntacticContextEq operation observe left right)
      (ContextEq operation observe left right)
syntactic-futureIso operation setO observe left right =
  iso
    (syntactic→contextEq operation observe)
    (contextEq→syntactic operation observe)
    (λ future → isPropΠ (λ word → setO _ _) _ future)
    (λ syntactic → isPropΠ (λ context → setO _ _) _ syntactic)

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
magma-step-preserves :
    {S : X → X → Type ℓR}
    {operation : X → X → X} {observe : X → O}
  → isObservedMagmaCongruence operation observe S
  → {x y : X} (action : ContextAction X)
  → S x y
  → S (contextStep operation x action) (contextStep operation y action)
magma-step-preserves congruence (false , fixed) related =
  respects-operation congruence related (reflexive congruence fixed)
magma-step-preserves congruence (true , fixed) related =
  respects-operation congruence (reflexive congruence fixed) related

magma→behavioral :
    {S : X → X → Type ℓR}
    {operation : X → X → X} {observe : X → O}
  → isObservedMagmaCongruence operation observe S
  → FB.isBehavioralCongruence (contextStep operation) observe S
magma→behavioral congruence = record
  { respects-observe = respects-observe congruence
  ; respects-step = magma-step-preserves congruence
  }

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
    (respects-operation congruence
      {x = controlLeft} {x′ = controlRight}
      {y = controlFixed} {y′ = controlFixed}
      same-now
      (reflexive congruence controlFixed))

------------------------------------------------------------------------
-- 5.  Adding operations refines the residual; the converse is false
------------------------------------------------------------------------

-- Reindex an experiment word along an action embedding.
reindexWord : {A : Type ℓA} {B : Type ℓB}
  → (A → B) → List A → List B
reindexWord embed [] = []
reindexWord embed (action ∷ word) = embed action ∷ reindexWord embed word

-- Execution commutes with action reindexing whenever the large machine
-- realizes every embedded small action exactly.
run-reindex : {A : Type ℓA} {B : Type ℓB} {S : Type ℓS}
    (smallStep : S → A → S) (largeStep : S → B → S) (embed : A → B)
  → ((state : S) (action : A)
      → largeStep state (embed action) ≡ smallStep state action)
  → (state : S) (word : List A)
  → FB.run largeStep state (reindexWord embed word)
    ≡ FB.run smallStep state word
run-reindex smallStep largeStep embed realizes state [] = refl
run-reindex smallStep largeStep embed realizes state (action ∷ word) =
  cong (λ next → FB.run largeStep next (reindexWord embed word))
    (realizes state action)
  ∙ run-reindex smallStep largeStep embed realizes
      (smallStep state action) word

-- More available actions can only split future-equivalence classes.  This is
-- alphabet monotonicity, distinct from `futureEq-of-finer`, which refines the
-- observation rather than the interventions.
futureEq-restrict-actions :
    {A : Type ℓA} {B : Type ℓB} {S : Type ℓS} {Y : Type ℓY}
    (smallStep : S → A → S) (largeStep : S → B → S) (embed : A → B)
    (observe : S → Y)
  → ((state : S) (action : A)
      → largeStep state (embed action) ≡ smallStep state action)
  → {left right : S}
  → FB.FutureEq largeStep observe left right
  → FB.FutureEq smallStep observe left right
futureEq-restrict-actions smallStep largeStep embed observe realizes
    {left} {right} related word =
  cong observe (sym (run-reindex smallStep largeStep embed realizes left word))
  ∙ related (reindexWord embed word)
  ∙ cong observe (run-reindex smallStep largeStep embed realizes right word)

ExtendedAction : Type ℓX → Type ℓX
ExtendedAction X = ContextAction X ⊎ ContextAction X

extendedStep : (X → X → X) → (X → X → X)
  → X → ExtendedAction X → X
extendedStep old new state (inl action) = contextStep old state action
extendedStep old new state (inr action) = contextStep new state action

ExtendedContextEq : (X → X → X) → (X → X → X)
  → (X → O) → X → X → Type _
ExtendedContextEq old new observe = FB.FutureEq (extendedStep old new) observe

adding-operation-refines :
    (old new : X → X → X) (observe : X → O) {left right : X}
  → ExtendedContextEq old new observe left right
  → ContextEq old observe left right
adding-operation-refines old new observe =
  futureEq-restrict-actions
    (contextStep old) (extendedStep old new) inl observe (λ _ _ → refl)

-- Strictness control.  The old left-projection operation never exposes the
-- hidden bit, while adding `leakingOperation` supplies exactly the context
-- that does.  Therefore the converse of `adding-operation-refines` is false.
blindOperation : ControlState → ControlState → ControlState
blindOperation left _ = left

blind-context-equal :
  ContextEq blindOperation controlObserve controlLeft controlRight
blind-context-equal [] = same-now
blind-context-equal ((false , fixed) ∷ word) = blind-context-equal word
blind-context-equal ((true , fixed) ∷ word) = refl

extended-not-contextually-equal :
  ¬ ExtendedContextEq blindOperation leakingOperation controlObserve
      controlLeft controlRight
extended-not-contextually-equal related =
  false≢true (related (inr (false , controlFixed) ∷ []))

adding-operation-converse-fails :
  ContextEq blindOperation controlObserve controlLeft controlRight
  × (¬ ExtendedContextEq blindOperation leakingOperation controlObserve
      controlLeft controlRight)
adding-operation-converse-fails =
  blind-context-equal , extended-not-contextually-equal
