{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- ReachableActionRefinement
--
-- ActionRefinement uses a decoder on the whole declared observation
-- codomain.  FiniteInformation uses only the reachable univalent image.
-- This file compares the two notions exactly, transports the product repair
-- to the reachable-image interface, and gives a constructive counterexample
-- to the converse when the observation has unreachable codomain values.
------------------------------------------------------------------------

module ReachableActionRefinement where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Empty as Empty using (⊥ ; isProp⊥)
open import Cubical.Data.Sigma
  using (_×_ ; Σ-syntax ; _,_ ; fst ; snd ; ΣPathP)
open import Cubical.Data.Unit using (Unit ; tt)
open import Cubical.Functions.Image using (Image)
open import Cubical.HITs.PropositionalTruncation as PT using (rec)
open import Cubical.Relation.Nullary using (¬_)

import ActionRefinement as AR
import FiniteInformation as FI
import StructuredDefect as SD

private
  variable
    ℓ ℓ' : Level

------------------------------------------------------------------------
-- 1. Total descent restricts to the reachable image
------------------------------------------------------------------------

totalDescends→reachableFactors :
    {X : Type ℓ} {Y T : Type ℓ'} (q : X → Y) (t : X → T)
  → SD.Descent.Descends q t → FI.FactorsThrough q t
totalDescends→reachableFactors q t (decode , replay) =
  (λ image → decode (fst image)) , replay

-- A chosen section supplies exactly the missing values of a total decoder.
-- No choice, set truncation elimination into T, or arbitrary default is used.
reachableFactors→totalDescends-with-section :
    {X : Type ℓ} {Y T : Type ℓ'} (q : X → Y) (t : X → T)
  → (section : Y → X)
  → ((y : Y) → q (section y) ≡ y)
  → FI.FactorsThrough q t → SD.Descent.Descends q t
reachableFactors→totalDescends-with-section q t section retract through =
  (λ y → t (section y)) ,
  λ x → fiberConstant (section (q x)) x (retract (q x))
  where
    fiberConstant : FI.FiberConstant q t
    fiberConstant = FI.factorsThrough→fiberConstant q t through

------------------------------------------------------------------------
-- 2. The least-common-product repair survives on the reachable image
------------------------------------------------------------------------

ReachableRefines : {X : Type ℓ} {Fine Coarse : Type ℓ'}
  → (fine : X → Fine) (coarse : X → Coarse) → Type _
ReachableRefines fine coarse = FI.FactorsThrough fine coarse

module ReachableProductRefinement
  {X : Type ℓ} {Y Action : Type ℓ'}
  (q : X → Y) (action : X → Action) where

  joint : X → Y × Action
  joint x = q x , action x

  joint-refines-observation : ReachableRefines joint q
  joint-refines-observation =
    (λ image → fst (fst image)) , λ _ → refl

  joint-refines-action : ReachableRefines joint action
  joint-refines-action =
    (λ image → snd (fst image)) , λ _ → refl

  refines-joint→refines-observation :
    {R : Type ℓ'} (r : X → R)
    → ReachableRefines r joint → ReachableRefines r q
  refines-joint→refines-observation r (decode , replay) =
    (λ image → fst (decode image)) , λ x → cong fst (replay x)

  refines-joint→refines-action :
    {R : Type ℓ'} (r : X → R)
    → ReachableRefines r joint → ReachableRefines r action
  refines-joint→refines-action r (decode , replay) =
    (λ image → snd (decode image)) , λ x → cong snd (replay x)

  common-refinement→refines-joint :
    {R : Type ℓ'} (r : X → R)
    → ReachableRefines r q
    → ReachableRefines r action
    → ReachableRefines r joint
  common-refinement→refines-joint r
      (readQ , replayQ) (readAction , replayAction) =
    (λ image → readQ image , readAction image) ,
    λ x → ΣPathP (replayQ x , replayAction x)

  collision-obstructs-action-factors :
    AR.ActionCollision q action → ¬ ReachableRefines q action
  collision-obstructs-action-factors
      (x , x' , sameObservation , differentAction) factors =
    differentAction
      (FI.factorsThrough→fiberConstant q action factors
        x x' sameObservation)

  collision-obstructs-joint-factors :
    AR.ActionCollision q action → ¬ ReachableRefines q joint
  collision-obstructs-joint-factors collision jointFromQ =
    collision-obstructs-action-factors collision
      (refines-joint→refines-action q jointFromQ)

  collision-forces-strict-reachable-refinement :
    AR.ActionCollision q action
    → ReachableRefines joint q × (¬ ReachableRefines q joint)
  collision-forces-strict-reachable-refinement collision =
    joint-refines-observation ,
    collision-obstructs-joint-factors collision

------------------------------------------------------------------------
-- 3. Unreachable codomain values make total descent strictly stronger
------------------------------------------------------------------------

emptyObservation : ⊥ → Unit
emptyObservation = Empty.rec

emptyTarget : ⊥ → ⊥
emptyTarget = Empty.rec

emptyObservation-image-empty : Image emptyObservation → ⊥
emptyObservation-image-empty (tt , witness) =
  PT.rec isProp⊥ (λ point → fst point) witness

-- The reachable image is empty, so it has the unique decoder into Empty.
empty-reachable-factors : FI.FactorsThrough emptyObservation emptyTarget
empty-reachable-factors = emptyObservation-image-empty , λ ()

-- Total descent would additionally have to assign a target to the
-- unreachable declared observation `tt`, which is impossible.
empty-no-total-descent : ¬ SD.Descent.Descends emptyObservation emptyTarget
empty-no-total-descent (decode , _) = decode tt

empty-no-section :
  ¬ (Σ[ section ∈ (Unit → ⊥) ]
      ((y : Unit) → emptyObservation (section y) ≡ y))
empty-no-section (section , _) = section tt
