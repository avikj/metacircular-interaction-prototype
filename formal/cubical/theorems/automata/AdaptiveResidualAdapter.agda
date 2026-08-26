{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- AdaptiveResidualAdapter
--
-- Exact Cubical return for the adaptive-residual theorem.  A finite
-- response-conditioned experiment tree does not create a new behavioral
-- quotient: two states have equal traces for every such tree exactly when
-- they have equal behavior on every ordinary action word.  Cubical
-- effectivity then identifies this relation with the path space between the
-- corresponding named points of FutureQuotient.Meaning.
--
-- The carrier and the cost are intentionally kept separate.  Nothing below
-- identifies tree depth with a parallel response-window horizon; the checked
-- Lean witness with costs 1/1/2 therefore remains compatible with this file.
------------------------------------------------------------------------

module AdaptiveResidualAdapter where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Isomorphism
  using (Iso ; iso ; compIso)
open import Cubical.Foundations.HLevels
  using (isPropΠ ; isPropΣ ; isSetΣ)
open import Cubical.Data.Bool
  using (Bool ; false ; true ; isSetBool ; false≢true)
open import Cubical.Data.List
  using (List ; [] ; _∷_ ; isOfHLevelList)
open import Cubical.Data.Sigma
  using (_×_ ; _,_ ; fst ; snd)
open import Cubical.HITs.SetQuotients as SQ using ([_])
open import Cubical.Relation.Nullary using (¬_)

import FutureBehavior as FB

private
  variable
    ℓX ℓA : Level
    X : Type ℓX
    A : Type ℓA

------------------------------------------------------------------------
-- Finite response-conditioned experiments
------------------------------------------------------------------------

-- A query chooses its continuation from the Boolean observation returned
-- after the action.  The function presentation is the same data as a pair of
-- false/true subtrees, while making the branch transport explicit below.
data BoolExperimentTree (A : Type ℓA) : Type ℓA where
  done  : BoolExperimentTree A
  query : A → (Bool → BoolExperimentTree A) → BoolExperimentTree A

-- A trace is nonempty: its first coordinate is the observation available
-- before spending an action, and the list records later responses.
Trace : Type₀
Trace = Bool × List Bool

isSetTrace : isSet Trace
isSetTrace = isSetΣ isSetBool λ _ → isOfHLevelList 0 isSetBool

prepend : Bool → Trace → Trace
prepend current (next , later) = current , next ∷ later

terminalFrom : Bool → List Bool → Bool
terminalFrom current [] = current
terminalFrom _ (next ∷ later) = terminalFrom next later

terminal : Trace → Bool
terminal (current , later) = terminalFrom current later

trace : (X → A → X) → (X → Bool)
  → BoolExperimentTree A → X → Trace
trace step observe done state = observe state , []
trace step observe (query action continue) state =
  prepend (observe state)
    (trace step observe
      (continue (observe (step state action)))
      (step state action))

responses : (X → A → X) → (X → Bool)
  → BoolExperimentTree A → X → List Bool
responses step observe tree state = snd (trace step observe tree state)

trace-split :
    (step : X → A → X) (observe : X → Bool)
    (tree : BoolExperimentTree A) (state : X)
  → trace step observe tree state
    ≡ (observe state , responses step observe tree state)
trace-split step observe done state = refl
trace-split step observe (query action continue) state = refl

-- Every ordinary word is an adaptive experiment whose two response branches
-- are definitionally the same.  This is the reverse-direction witness, not a
-- compactness or search argument.
fixedWord : List A → BoolExperimentTree A
fixedWord [] = done
fixedWord (action ∷ word) = query action (λ _ → fixedWord word)

fixedWord-terminal :
    (step : X → A → X) (observe : X → Bool)
    (word : List A) (state : X)
  → terminal (trace step observe (fixedWord word) state)
    ≡ FB.behavior step observe state word
fixedWord-terminal step observe [] state = refl
fixedWord-terminal step observe (action ∷ word) state =
  fixedWord-terminal step observe word (step state action)

------------------------------------------------------------------------
-- The exact relation adapter
------------------------------------------------------------------------

AdaptiveEq : (X → A → X) → (X → Bool) → X → X → Type _
AdaptiveEq {A = A} step observe left right =
  (tree : BoolExperimentTree A)
  → trace step observe tree left ≡ trace step observe tree right

PostAdaptiveEq : (X → A → X) → (X → Bool) → X → X → Type _
PostAdaptiveEq {A = A} step observe left right =
  (tree : BoolExperimentTree A)
  → responses step observe tree left ≡ responses step observe tree right

CurrentAndPostEq : (X → A → X) → (X → Bool) → X → X → Type _
CurrentAndPostEq step observe left right =
  (observe left ≡ observe right)
  × PostAdaptiveEq step observe left right

futureEq→adaptiveEq :
    (step : X → A → X) (observe : X → Bool) {left right : X}
  → FB.FutureEq step observe left right
  → AdaptiveEq step observe left right
futureEq→adaptiveEq step observe future done =
  cong (λ response → response , []) (future [])
futureEq→adaptiveEq step observe {left} {right} future
    (query action continue) =
  cong₂ prepend (future [])
    ( futureEq→adaptiveEq step observe
        (FB.futureEq-step step observe future action)
        (continue (observe (step left action)))
    ∙ cong
        (λ response →
          trace step observe (continue response) (step right action))
        (future (action ∷ [])) )

adaptiveEq→futureEq :
    (step : X → A → X) (observe : X → Bool) {left right : X}
  → AdaptiveEq step observe left right
  → FB.FutureEq step observe left right
adaptiveEq→futureEq step observe {left} {right} adaptive word =
  sym (fixedWord-terminal step observe word left)
  ∙ cong terminal (adaptive (fixedWord word))
  ∙ fixedWord-terminal step observe word right

adaptiveEq→currentAndPost :
    (step : X → A → X) (observe : X → Bool) {left right : X}
  → AdaptiveEq step observe left right
  → CurrentAndPostEq step observe left right
adaptiveEq→currentAndPost step observe adaptive =
  cong fst (adaptive done) , λ tree → cong snd (adaptive tree)

currentAndPost→adaptiveEq :
    (step : X → A → X) (observe : X → Bool) {left right : X}
  → CurrentAndPostEq step observe left right
  → AdaptiveEq step observe left right
currentAndPost→adaptiveEq step observe {left} {right} (current , post) tree =
  trace-split step observe tree left
  ∙ (λ i → current i , post tree i)
  ∙ sym (trace-split step observe tree right)

isPropFutureEq :
    (step : X → A → X) (observe : X → Bool) (left right : X)
  → isProp (FB.FutureEq step observe left right)
isPropFutureEq step observe left right =
  isPropΠ λ word → isSetBool _ _

isPropAdaptiveEq :
    (step : X → A → X) (observe : X → Bool) (left right : X)
  → isProp (AdaptiveEq step observe left right)
isPropAdaptiveEq step observe left right =
  isPropΠ λ tree → isSetTrace _ _

isPropCurrentAndPostEq :
    (step : X → A → X) (observe : X → Bool) (left right : X)
  → isProp (CurrentAndPostEq step observe left right)
isPropCurrentAndPostEq step observe left right =
  isPropΣ (isSetBool _ _)
    λ _ → isPropΠ λ tree →
      isOfHLevelList 0 isSetBool _ _

-- Complete uniform behavior and all finite adaptive traces are the same
-- residual relation.  The proof uses propositionhood only for the inverse
-- laws; both computational directions are explicit above.
futureEq-adaptiveIso :
    (step : X → A → X) (observe : X → Bool) (left right : X)
  → Iso (FB.FutureEq step observe left right)
      (AdaptiveEq step observe left right)
futureEq-adaptiveIso step observe left right =
  iso
    (futureEq→adaptiveEq step observe)
    (adaptiveEq→futureEq step observe)
    (λ adaptive → isPropAdaptiveEq step observe left right _ adaptive)
    (λ future → isPropFutureEq step observe left right _ future)

-- The free Moore output is a fiber split, not a paid action.  Native trace
-- equality is exactly equality of that current bit together with equality of
-- every post-action response tree.
adaptive-currentAndPostIso :
    (step : X → A → X) (observe : X → Bool) (left right : X)
  → Iso (AdaptiveEq step observe left right)
      (CurrentAndPostEq step observe left right)
adaptive-currentAndPostIso step observe left right =
  iso
    (adaptiveEq→currentAndPost step observe)
    (currentAndPost→adaptiveEq step observe)
    (λ split → isPropCurrentAndPostEq step observe left right _ split)
    (λ adaptive → isPropAdaptiveEq step observe left right _ adaptive)

------------------------------------------------------------------------
-- Moore/Mealy identification boundary
------------------------------------------------------------------------

Injective : {X : Type ℓX} → (X → Trace) → Type ℓX
Injective {X = X} function =
  {left right : X} → function left ≡ function right → left ≡ right

IdentifiesAll : (X → A → X) → (X → Bool)
  → BoolExperimentTree A → Type _
IdentifiesAll step observe tree = Injective (trace step observe tree)

IdentifiesInitialFibers : (X → A → X) → (X → Bool)
  → BoolExperimentTree A → Type _
IdentifiesInitialFibers {X = X} step observe tree =
  {left right : X}
  → observe left ≡ observe right
  → responses step observe tree left ≡ responses step observe tree right
  → left ≡ right

identifiesAll→identifiesInitialFibers :
    (step : X → A → X) (observe : X → Bool)
    (tree : BoolExperimentTree A)
  → IdentifiesAll step observe tree
  → IdentifiesInitialFibers step observe tree
identifiesAll→identifiesInitialFibers step observe tree identifies
    {left} {right} current post =
  identifies
    ( trace-split step observe tree left
    ∙ (λ i → current i , post i)
    ∙ sym (trace-split step observe tree right) )

identifiesInitialFibers→identifiesAll :
    (step : X → A → X) (observe : X → Bool)
    (tree : BoolExperimentTree A)
  → IdentifiesInitialFibers step observe tree
  → IdentifiesAll step observe tree
identifiesInitialFibers→identifiesAll step observe tree identifies same =
  identifies
    ( sym (cong fst (trace-split step observe tree _))
    ∙ cong fst same
    ∙ cong fst (trace-split step observe tree _) )
    (cong snd same)

identifiesAll-iff-identifiesInitialFibers :
    (step : X → A → X) (observe : X → Bool)
    (tree : BoolExperimentTree A)
  → (IdentifiesAll step observe tree
      → IdentifiesInitialFibers step observe tree)
    × (IdentifiesInitialFibers step observe tree
      → IdentifiesAll step observe tree)
identifiesAll-iff-identifiesInitialFibers step observe tree =
  identifiesAll→identifiesInitialFibers step observe tree ,
  identifiesInitialFibers→identifiesAll step observe tree

-- A root action is safe on each free-output fiber only if two states taking
-- the same response cannot fall into the same complete future residual.
-- Otherwise no response-selected continuation can recover their identity.
SafeActionOnInitialFiber :
  (X → A → X) → (X → Bool) → A → Type _
SafeActionOnInitialFiber {X = X} step observe action =
  {left right : X}
  → observe left ≡ observe right
  → observe (step left action) ≡ observe (step right action)
  → FB.FutureEq step observe (step left action) (step right action)
  → left ≡ right

query-identifies→safeAction :
    (step : X → A → X) (observe : X → Bool)
    (action : A) (continue : Bool → BoolExperimentTree A)
  → IdentifiesAll step observe (query action continue)
  → SafeActionOnInitialFiber step observe action
query-identifies→safeAction step observe action continue identifies
    {left} {right} current response future =
  identifies
    (cong₂ prepend current
      ( futureEq→adaptiveEq step observe future
          (continue (observe (step left action)))
      ∙ cong
          (λ bit → trace step observe (continue bit) (step right action))
          response ))

unsafeAction-obstructs-query :
    (step : X → A → X) (observe : X → Bool)
    (action : A) {left right : X}
  → ¬ (left ≡ right)
  → observe left ≡ observe right
  → observe (step left action) ≡ observe (step right action)
  → FB.FutureEq step observe (step left action) (step right action)
  → (continue : Bool → BoolExperimentTree A)
  → ¬ IdentifiesAll step observe (query action continue)
unsafeAction-obstructs-query step observe action different
    current response future continue identifies =
  different
    (query-identifies→safeAction step observe action continue identifies
      current response future)

-- Hostile timing control.  The free current observation identifies Bool at
-- depth zero, while the post-action response of `done` is constantly empty.
freeOutputStep : Bool → Bool → Bool
freeOutputStep state _ = state

done-identifies-by-free-output :
  IdentifiesAll freeOutputStep (λ state → state) done
done-identifies-by-free-output same = cong fst same

done-postResponses-not-injective :
  ¬ ({left right : Bool}
      → responses freeOutputStep (λ state → state) done left
        ≡ responses freeOutputStep (λ state → state) done right
      → left ≡ right)
done-postResponses-not-injective injective =
  false≢true (injective {left = false} {right = true} refl)

-- Equality under all adaptive experiments is stable under a common next
-- action because it is the existing future congruence, not a new quotient.
adaptiveEq-step :
    (step : X → A → X) (observe : X → Bool) {left right : X}
  → AdaptiveEq step observe left right
  → (action : A)
  → AdaptiveEq step observe (step left action) (step right action)
adaptiveEq-step step observe adaptive action =
  futureEq→adaptiveEq step observe
    (FB.futureEq-step step observe
      (adaptiveEq→futureEq step observe adaptive) action)

------------------------------------------------------------------------
-- Cubical quotient surface
------------------------------------------------------------------------

module QuotientAdapter
    (step : X → A → X) (observe : X → Bool) where

  module FQ = FB.FutureQuotient step isSetBool observe

  -- A path between two named quotient meanings is exactly agreement under
  -- every finite adaptive experiment.  This is the Cubical strengthening of
  -- the left-quotient carrier theorem: the adapter exposes an actual path
  -- space, not only a logical iff.
  quotientPath-adaptiveIso : (left right : X)
    → Iso (Path FQ.Meaning [ left ] [ right ])
        (AdaptiveEq step observe left right)
  quotientPath-adaptiveIso left right =
    compIso (FQ.[]-effectiveIso left right)
      (futureEq-adaptiveIso step observe left right)

  quotientPath-currentAndPostIso : (left right : X)
    → Iso (Path FQ.Meaning [ left ] [ right ])
        (CurrentAndPostEq step observe left right)
  quotientPath-currentAndPostIso left right =
    compIso (quotientPath-adaptiveIso left right)
      (adaptive-currentAndPostIso step observe left right)

  -- Advancing a quotient path by one common action is the native quotient
  -- action.  The adaptive presentation of that transported path agrees with
  -- `adaptiveEq-step`; hence branch update is natural across the adapter,
  -- rather than merely available on its two sides.
  quotientPath-step : {left right : X}
    → Path FQ.Meaning [ left ] [ right ]
    → (action : A)
    → Path FQ.Meaning [ step left action ] [ step right action ]
  quotientPath-step path action =
    cong (λ meaning → FQ.quotStep meaning action) path

  adaptive-step-commutes : {left right : X}
    → (path : Path FQ.Meaning [ left ] [ right ])
    → (action : A)
    → Iso.fun (quotientPath-adaptiveIso
        (step left action) (step right action))
        (quotientPath-step path action)
      ≡ adaptiveEq-step step observe
          (Iso.fun (quotientPath-adaptiveIso left right) path) action
  adaptive-step-commutes {left} {right} path action =
    isPropAdaptiveEq step observe
      (step left action) (step right action) _ _
