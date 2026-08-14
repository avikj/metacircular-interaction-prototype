{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- NaturalMachine.ContextCloneEquivalence
--
-- Finite words, rather than raw action alphabets, are the executable unary
-- clone of an observed transition system.  A simulation sends each source
-- generator to a target word with the same state transformation.  Mutual
-- simulations identify complete-future equality and induce an
-- identity-on-states Iso of the corresponding Cubical set quotients.
--
-- The binary-algebra control uses the distinct operations
--
--     leftProjection  x y = x
--     rightProjection x y = y.
--
-- Their one-hole actions are the same identity/constant clone after swapping
-- hole polarity.  Their contextual quotients are therefore equivalent even
-- though the raw operations are provably unequal.
------------------------------------------------------------------------

module NaturalMachine.ContextCloneEquivalence where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.HLevels using (isPropΠ)
open import Cubical.Foundations.Isomorphism using (Iso ; iso)
open import Cubical.Data.Bool
  using (Bool ; false ; true ; false≢true ; isSetBool)
open import Cubical.Data.List using (List ; [] ; _∷_ ; _++_)
open import Cubical.Data.Unit using (Unit ; tt ; isSetUnit)
open import Cubical.HITs.SetQuotients as SQ
  using ([_] ; eq/ ; squash/)
open import Cubical.Relation.Nullary using (¬_)

import NaturalMachine.FutureBehavior as FB
import NaturalMachine.CompositionalContextAdapter as CCA

private
  variable
    ℓX ℓA ℓB ℓO : Level
    X : Type ℓX
    A : Type ℓA
    B : Type ℓB
    O : Type ℓO

------------------------------------------------------------------------
-- 1.  Generator-to-word simulation
------------------------------------------------------------------------

record ActionSimulation
    {X : Type ℓX} {A : Type ℓA} {B : Type ℓB}
    (sourceStep : X → A → X)
    (targetStep : X → B → X)
    : Type (ℓ-max ℓX (ℓ-max ℓA ℓB)) where
  field
    compileAction : A → List B
    realizesAction : (state : X) (action : A)
      → FB.run targetStep state (compileAction action)
        ≡ sourceStep state action

open ActionSimulation public

compileWord :
    {sourceStep : X → A → X} {targetStep : X → B → X}
  → ActionSimulation sourceStep targetStep → List A → List B
compileWord simulation [] = []
compileWord simulation (action ∷ word) =
  compileAction simulation action ++ compileWord simulation word

run-++ : (step : X → A → X) (state : X) (front back : List A)
  → FB.run step state (front ++ back)
    ≡ FB.run step (FB.run step state front) back
run-++ step state [] back = refl
run-++ step state (action ∷ front) back =
  run-++ step (step state action) front back

-- A generator realization extends to every finite source word.  The order of
-- concatenation matches `FutureBehavior.run`, which executes left to right.
run-compile :
    {sourceStep : X → A → X} {targetStep : X → B → X}
    (simulation : ActionSimulation sourceStep targetStep)
    (state : X) (word : List A)
  → FB.run targetStep state (compileWord simulation word)
    ≡ FB.run sourceStep state word
run-compile simulation state [] = refl
run-compile {sourceStep = sourceStep} {targetStep = targetStep}
    simulation state (action ∷ word) =
  run-++ targetStep state
    (compileAction simulation action) (compileWord simulation word)
  ∙ cong (λ next → FB.run targetStep next (compileWord simulation word))
      (realizesAction simulation state action)
  ∙ run-compile simulation (sourceStep state action) word

-- If every source action is executable as a target word, target-future
-- equality implies source-future equality.
futureEq-via-simulation :
    {sourceStep : X → A → X} {targetStep : X → B → X}
    (simulation : ActionSimulation sourceStep targetStep)
    (observe : X → O) {left right : X}
  → FB.FutureEq targetStep observe left right
  → FB.FutureEq sourceStep observe left right
futureEq-via-simulation simulation observe {left} {right} related word =
  cong observe (sym (run-compile simulation left word))
  ∙ related (compileWord simulation word)
  ∙ cong observe (run-compile simulation right word)

------------------------------------------------------------------------
-- 2.  Mutual simulation identifies relations and quotients
------------------------------------------------------------------------

record MutualSimulation
    {X : Type ℓX} {A : Type ℓA} {B : Type ℓB}
    (stepA : X → A → X) (stepB : X → B → X)
    : Type (ℓ-max ℓX (ℓ-max ℓA ℓB)) where
  field
    A-in-B : ActionSimulation stepA stepB
    B-in-A : ActionSimulation stepB stepA

open MutualSimulation public

futureEqIso :
    {stepA : X → A → X} {stepB : X → B → X}
    (setO : isSet O) (observe : X → O)
    (simulations : MutualSimulation stepA stepB) (left right : X)
  → Iso (FB.FutureEq stepA observe left right)
      (FB.FutureEq stepB observe left right)
futureEqIso setO observe simulations left right =
  iso
    (futureEq-via-simulation (B-in-A simulations) observe)
    (futureEq-via-simulation (A-in-B simulations) observe)
    (λ targetEq → isPropΠ (λ word → setO _ _) _ targetEq)
    (λ sourceEq → isPropΠ (λ word → setO _ _) _ sourceEq)

module MutualQuotient
    {X : Type ℓX} {A : Type ℓA} {B : Type ℓB} {O : Type ℓO}
    (stepA : X → A → X) (stepB : X → B → X)
    (setO : isSet O) (observe : X → O)
    (simulations : MutualSimulation stepA stepB) where

  module QA = FB.FutureQuotient stepA setO observe
  module QB = FB.FutureQuotient stepB setO observe

  relationA→B : {left right : X}
    → FB.FutureEq stepA observe left right
    → FB.FutureEq stepB observe left right
  relationA→B = futureEq-via-simulation (B-in-A simulations) observe

  relationB→A : {left right : X}
    → FB.FutureEq stepB observe left right
    → FB.FutureEq stepA observe left right
  relationB→A = futureEq-via-simulation (A-in-B simulations) observe

  toMeaning : QA.Meaning → QB.Meaning
  toMeaning = SQ.rec QB.isSetMeaning
    (λ state → [ state ])
    (λ left right related → eq/ left right (relationA→B related))

  fromMeaning : QB.Meaning → QA.Meaning
  fromMeaning = SQ.rec QA.isSetMeaning
    (λ state → [ state ])
    (λ left right related → eq/ left right (relationB→A related))

  to-from : (meaning : QB.Meaning)
    → toMeaning (fromMeaning meaning) ≡ meaning
  to-from = SQ.elimProp (λ meaning → QB.isSetMeaning _ _) (λ _ → refl)

  from-to : (meaning : QA.Meaning)
    → fromMeaning (toMeaning meaning) ≡ meaning
  from-to = SQ.elimProp (λ meaning → QA.isSetMeaning _ _) (λ _ → refl)

  meaningIso : Iso QA.Meaning QB.Meaning
  meaningIso = iso toMeaning fromMeaning to-from from-to

  -- The equivalence is literally identity on named state representatives.
  meaningIso-β : (state : X)
    → Iso.fun meaningIso [ state ] ≡ [ state ]
  meaningIso-β state = refl

------------------------------------------------------------------------
-- 3.  Binary contextual clone adapter
------------------------------------------------------------------------

ContextSimulation : (X → X → X) → (X → X → X) → Type _
ContextSimulation source target =
  ActionSimulation (CCA.contextStep source) (CCA.contextStep target)

ContextMutualSimulation :
  (X → X → X) → (X → X → X) → Type _
ContextMutualSimulation first second =
  MutualSimulation (CCA.contextStep first) (CCA.contextStep second)

module ContextualQuotientEquivalence
    {X : Type ℓX} {O : Type ℓO}
    (first second : X → X → X)
    (setO : isSet O) (observe : X → O)
    (simulations : ContextMutualSimulation first second) where

  module Equivalence = MutualQuotient
    (CCA.contextStep first) (CCA.contextStep second)
    setO observe simulations

  contextualMeaningIso :
    Iso Equivalence.QA.Meaning Equivalence.QB.Meaning
  contextualMeaningIso = Equivalence.meaningIso

------------------------------------------------------------------------
-- 4.  Control: unequal projections generate the same unary clone
------------------------------------------------------------------------

leftProjection : Bool → Bool → Bool
leftProjection left right = left

rightProjection : Bool → Bool → Bool
rightProjection left right = right

projections-differ : ¬ (leftProjection ≡ rightProjection)
projections-differ equality =
  false≢true (cong (λ operation → operation false true) equality)

swapContextAction : CCA.ContextAction Bool → List (CCA.ContextAction Bool)
swapContextAction (false , fixed) = (true , fixed) ∷ []
swapContextAction (true  , fixed) = (false , fixed) ∷ []

left-in-right : ContextSimulation leftProjection rightProjection
left-in-right = record
  { compileAction = swapContextAction
  ; realizesAction = λ
      { state (false , fixed) → refl
      ; state (true  , fixed) → refl
      }
  }

right-in-left : ContextSimulation rightProjection leftProjection
right-in-left = record
  { compileAction = swapContextAction
  ; realizesAction = λ
      { state (false , fixed) → refl
      ; state (true  , fixed) → refl
      }
  }

projection-clones-mutually-simulate :
  ContextMutualSimulation leftProjection rightProjection
projection-clones-mutually-simulate = record
  { A-in-B = left-in-right
  ; B-in-A = right-in-left
  }

projection-contextEqIso : (left right : Bool)
  → Iso (CCA.ContextEq leftProjection (λ state → state) left right)
      (CCA.ContextEq rightProjection (λ state → state) left right)
projection-contextEqIso =
  futureEqIso isSetBool (λ state → state)
    projection-clones-mutually-simulate

module ProjectionQuotientEquivalence =
  ContextualQuotientEquivalence
    leftProjection rightProjection isSetBool (λ state → state)
    projection-clones-mutually-simulate

projection-contextual-meaningIso :
  Iso ProjectionQuotientEquivalence.Equivalence.QA.Meaning
      ProjectionQuotientEquivalence.Equivalence.QB.Meaning
projection-contextual-meaningIso =
  ProjectionQuotientEquivalence.contextualMeaningIso

------------------------------------------------------------------------
-- 5.  Necessity fails after observation collapses the action difference
------------------------------------------------------------------------

identityStep : Bool → Unit → Bool
identityStep state tt = state

flipStep : Bool → Unit → Bool
flipStep false tt = true
flipStep true  tt = false

constantObserve : Bool → Unit
constantObserve state = tt

identity-words-do-nothing : (state : Bool) (word : List Unit)
  → FB.run identityStep state word ≡ state
identity-words-do-nothing state [] = refl
identity-words-do-nothing state (tt ∷ word) =
  identity-words-do-nothing state word

-- No finite identity word realizes the flip generator.  This is a statement
-- about state transformations before observation.
flip-not-simulable-by-identity :
  ¬ ActionSimulation flipStep identityStep
flip-not-simulable-by-identity simulation =
  false≢true
    (sym (identity-words-do-nothing false (compileAction simulation tt))
    ∙ realizesAction simulation false tt)

no-mutual-simulation-after-collapse :
  ¬ MutualSimulation identityStep flipStep
no-mutual-simulation-after-collapse simulations =
  flip-not-simulable-by-identity (B-in-A simulations)

-- The constant observer nevertheless identifies every pair of states under
-- every word, for either action system (indeed for any Unit-action system).
constant-futureEq : (step : Bool → Unit → Bool) (left right : Bool)
  → FB.FutureEq step constantObserve left right
constant-futureEq step left right word = refl

collapsed-futureEqIso : (left right : Bool)
  → Iso (FB.FutureEq identityStep constantObserve left right)
      (FB.FutureEq flipStep constantObserve left right)
collapsed-futureEqIso left right = iso
  (λ _ → constant-futureEq flipStep left right)
  (λ _ → constant-futureEq identityStep left right)
  (λ targetEq → isPropΠ (λ word → isSetUnit _ _) _ targetEq)
  (λ sourceEq → isPropΠ (λ word → isSetUnit _ _) _ sourceEq)

module IdentityCollapsedQuotient =
  FB.FutureQuotient identityStep isSetUnit constantObserve

module FlipCollapsedQuotient =
  FB.FutureQuotient flipStep isSetUnit constantObserve

identityToFlipMeaning :
  IdentityCollapsedQuotient.Meaning → FlipCollapsedQuotient.Meaning
identityToFlipMeaning = SQ.rec FlipCollapsedQuotient.isSetMeaning
  (λ state → [ state ])
  (λ left right related →
    eq/ left right (constant-futureEq flipStep left right))

flipToIdentityMeaning :
  FlipCollapsedQuotient.Meaning → IdentityCollapsedQuotient.Meaning
flipToIdentityMeaning = SQ.rec IdentityCollapsedQuotient.isSetMeaning
  (λ state → [ state ])
  (λ left right related →
    eq/ left right (constant-futureEq identityStep left right))

collapsed-to-from : (meaning : FlipCollapsedQuotient.Meaning)
  → identityToFlipMeaning (flipToIdentityMeaning meaning) ≡ meaning
collapsed-to-from = SQ.elimProp
  (λ meaning → FlipCollapsedQuotient.isSetMeaning _ _) (λ _ → refl)

collapsed-from-to : (meaning : IdentityCollapsedQuotient.Meaning)
  → flipToIdentityMeaning (identityToFlipMeaning meaning) ≡ meaning
collapsed-from-to = SQ.elimProp
  (λ meaning → IdentityCollapsedQuotient.isSetMeaning _ _) (λ _ → refl)

collapsed-meaningIso :
  Iso IdentityCollapsedQuotient.Meaning FlipCollapsedQuotient.Meaning
collapsed-meaningIso =
  iso identityToFlipMeaning flipToIdentityMeaning
    collapsed-to-from collapsed-from-to
