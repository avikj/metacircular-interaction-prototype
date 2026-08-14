{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- NaturalMachine.ProstheticImageAdapter
--
-- A commuting observer-revision square maps the revised response image into
-- the old response image.  With a changed codomain, the target is instead
-- the image of the declared comparison j ∘ r.  A response outside that image
-- therefore refutes total preservation of the old interface.
--
-- The image is Cubical.Functions.Image: its fiber witness is propositionally
-- truncated.  The adapter maps that witness directly, so it uses neither
-- finiteness nor decidable equality nor a chosen representative.
------------------------------------------------------------------------

module NaturalMachine.ProstheticImageAdapter where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Bool
  using (Bool ; false ; true ; false≢true)
open import Cubical.Data.Empty using (isProp⊥)
open import Cubical.Data.Sigma using (Σ-syntax ; fst ; snd ; _,_ ; Σ≡Prop)
open import Cubical.Data.Unit using (Unit ; tt)
open import Cubical.Functions.Image
  using (Image ; isInImage ; isPropIsInImage ; restrictToImage)
open import Cubical.HITs.PropositionalTruncation as PT
  using (∥_∥₁ ; ∣_∣₁)
open import Cubical.Relation.Nullary using (¬_)

import NaturalMachine.AtomicSatisfaction as AS

private
  variable
    ℓX ℓX′ ℓQ ℓY ℓY′ : Level

------------------------------------------------------------------------
-- 1. Same response family: conservative revision gives image containment
------------------------------------------------------------------------

module SameResponseImage
  {X : Type ℓX} {X′ : Type ℓX′} {Q : Type ℓQ}
  (Y : Q → Type ℓY)
  (r : (q : Q) → X → Y q)
  (r′ : (q : Q) → X′ → Y q)
  (stateMap : X′ → X)
  where

  module Observation = AS.SameResponses Y r r′ stateMap

  -- Pointwise form of q′(X′) ⊆ q(X).  Mapping a truncated fiber witness is
  -- enough; no state representative escapes the truncation.
  preserves-image-membership :
    Observation.ResponseSquare → (q : Q) (y : Y q)
    → isInImage (r′ q) y → isInImage (r q) y
  preserves-image-membership square q y =
    PT.map (λ witness →
      stateMap (fst witness) ,
      (sym (square q (fst witness)) ∙ snd witness))

  revisedImage→oldImage :
    Observation.ResponseSquare → (q : Q)
    → Image (r′ q) → Image (r q)
  revisedImage→oldImage square q (y , realized) =
    y , preserves-image-membership square q y realized

  -- The image adapter preserves the visible response coordinate.  On a
  -- concrete revised state its first coordinate changes only along the
  -- supplied response-square path.
  map-restrict :
    (square : Observation.ResponseSquare) (q : Q) (state : X′)
    → revisedImage→oldImage square q (restrictToImage (r′ q) state)
      ≡ restrictToImage (r q) (stateMap state)
  map-restrict square q state =
    Σ≡Prop (isPropIsInImage (r q)) (square q state)

  -- An outcome realized after revision but absent before revision forces
  -- failure of the total response square.
  novel-outcome→no-square :
    (q : Q) (y : Y q)
    → isInImage (r′ q) y
    → ¬ isInImage (r q) y
    → ¬ Observation.ResponseSquare
  novel-outcome→no-square q y revised old-absent square =
    old-absent (preserves-image-membership square q y revised)

------------------------------------------------------------------------
-- 2. Changed response family: novelty is relative to the declared comparison
------------------------------------------------------------------------

module ChangedResponseImage
  {X : Type ℓX} {X′ : Type ℓX′} {Q : Type ℓQ}
  (Y : Q → Type ℓY)
  (Y′ : Q → Type ℓY′)
  (r : (q : Q) → X → Y q)
  (r′ : (q : Q) → X′ → Y′ q)
  (stateMap : X′ → X)
  (compare : (q : Q) → Y q → Y′ q)
  where

  module Observation =
    AS.ChangedResponses Y Y′ r r′ stateMap compare

  comparedOld : (q : Q) → X → Y′ q
  comparedOld q state = compare q (r q state)

  preserves-comparison-image :
    Observation.ResponseSquare → (q : Q) (y : Y′ q)
    → isInImage (r′ q) y → isInImage (comparedOld q) y
  preserves-comparison-image square q y =
    PT.map (λ witness →
      stateMap (fst witness) ,
      (sym (square q (fst witness)) ∙ snd witness))

  revisedImage→comparisonImage :
    Observation.ResponseSquare → (q : Q)
    → Image (r′ q) → Image (comparedOld q)
  revisedImage→comparisonImage square q (y , realized) =
    y , preserves-comparison-image square q y realized

  map-restrict :
    (square : Observation.ResponseSquare) (q : Q) (state : X′)
    → revisedImage→comparisonImage square q
        (restrictToImage (r′ q) state)
      ≡ restrictToImage (comparedOld q) (stateMap state)
  map-restrict square q state =
    Σ≡Prop (isPropIsInImage (comparedOld q)) (square q state)

  outside-comparison→no-square :
    (q : Q) (y : Y′ q)
    → isInImage (r′ q) y
    → ¬ isInImage (comparedOld q) y
    → ¬ Observation.ResponseSquare
  outside-comparison→no-square q y revised old-absent square =
    old-absent (preserves-comparison-image square q y revised)

------------------------------------------------------------------------
-- 3. Bool controls: state splitting is conservative; novelty is not
------------------------------------------------------------------------

oldResponse : Unit → Unit → Bool
oldResponse tt tt = false

splitState : Bool → Unit
splitState state = tt

conservativeResponse : Unit → Bool → Bool
conservativeResponse tt state = false

novelResponse : Unit → Bool → Bool
novelResponse tt false = false
novelResponse tt true  = true

module Conservative =
  SameResponseImage (λ _ → Bool)
    oldResponse conservativeResponse splitState

conservative-square : Conservative.Observation.ResponseSquare
conservative-square tt state = refl

-- The positive control really uses the image adapter on the new `true` state;
-- state splitting alone does not create a new old-probe response.
conservative-true-state-computes :
  Conservative.revisedImage→oldImage conservative-square tt
      (restrictToImage (conservativeResponse tt) true)
    ≡ restrictToImage (oldResponse tt) tt
conservative-true-state-computes =
  Conservative.map-restrict conservative-square tt true

module Novel =
  SameResponseImage (λ _ → Bool)
    oldResponse novelResponse splitState

true-is-revised : isInImage (novelResponse tt) true
true-is-revised = ∣ true , refl ∣₁

true-is-absent-before : ¬ isInImage (oldResponse tt) true
true-is-absent-before = PT.rec isProp⊥ (λ witness →
  false≢true (snd witness))

-- Exact negative control: the newly realized `true` outcome rules out a total
-- conservative response square.
novel-square-impossible : ¬ Novel.Observation.ResponseSquare
novel-square-impossible =
  Novel.novel-outcome→no-square tt true
    true-is-revised true-is-absent-before
