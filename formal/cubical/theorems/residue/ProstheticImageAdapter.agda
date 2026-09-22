{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- ProstheticImageAdapter
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

module ProstheticImageAdapter where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Bool
  using (Bool ; false ; true ; false≢true)
open import Cubical.Data.Empty as Empty using (⊥ ; isProp⊥ ; rec)
open import Cubical.Data.Sigma using (Σ-syntax ; fst ; snd ; _,_ ; Σ≡Prop)
open import Cubical.Data.Unit using (Unit ; tt)
open import Cubical.Functions.Image
  using (Image ; isInImage ; isPropIsInImage ; restrictToImage)
open import Cubical.HITs.PropositionalTruncation as PT
  using (∥_∥₁ ; ∣_∣₁)
open import Cubical.Relation.Nullary using (¬_)

import AtomicSatisfaction as AS

private
  variable
    ℓX ℓX′ ℓQ ℓY ℓY′ ℓI : Level

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
-- 3. Localized preservation: only inherited revised states owe the square
------------------------------------------------------------------------

module InheritedResponseImage
  {X : Type ℓX} {X′ : Type ℓX′} {Q : Type ℓQ}
  (Y : Q → Type ℓY)
  (Y′ : Q → Type ℓY′)
  (r : (q : Q) → X → Y q)
  (r′ : (q : Q) → X′ → Y′ q)
  (Inherited : X′ → Type ℓI)
  (stateMap : (Σ[ state ∈ X′ ] Inherited state) → X)
  (compare : (q : Q) → Y q → Y′ q)
  where

  InheritedState : Type (ℓ-max ℓX′ ℓI)
  InheritedState = Σ[ state ∈ X′ ] Inherited state

  inheritedResponse : (q : Q) → InheritedState → Y′ q
  inheritedResponse q state = r′ q (fst state)

  -- This is deliberately the whole adapter: all previous theorems apply to
  -- the inherited subtype, and none quantifies over a non-inherited state.
  module Adapter =
    ChangedResponseImage Y Y′ r inheritedResponse stateMap compare

  open Adapter public

------------------------------------------------------------------------
-- 4. Maximal lawful inheritance relative to a declared translation
------------------------------------------------------------------------

module MaximalCompatibleResponseImage
  {X : Type ℓX} {X′ : Type ℓX′} {Q : Type ℓQ}
  (Y : Q → Type ℓY)
  (Y′ : Q → Type ℓY′)
  (r : (q : Q) → X → Y q)
  (r′ : (q : Q) → X′ → Y′ q)
  (stateMap : X′ → X)
  (compare : (q : Q) → Y q → Y′ q)
  where

  -- Compatibility is the response square evaluated at one revised state.
  -- It is canonical only relative to the supplied state and response maps.
  Compatible : X′ → Type _
  Compatible state =
    (q : Q) → r′ q state ≡ compare q (r q (stateMap state))

  compatibleStateMap :
    (Σ[ state ∈ X′ ] Compatible state) → X
  compatibleStateMap state = stateMap (fst state)

  module InheritedAdapter =
    InheritedResponseImage
      Y Y′ r r′ Compatible compatibleStateMap compare

  compatible-square : InheritedAdapter.Observation.ResponseSquare
  compatible-square q state = snd state q

  -- Any inherited predicate satisfying the same local square maps into the
  -- compatible predicate.  This is maximality as a dependent subpredicate.
  inheritance→compatible :
    (Inherited : X′ → Type ℓI)
    → ((q : Q) (state : Σ[ revised ∈ X′ ] Inherited revised)
       → r′ q (fst state) ≡
          compare q (r q (stateMap (fst state))))
    → (state : Σ[ revised ∈ X′ ] Inherited revised)
    → Compatible (fst state)
  inheritance→compatible Inherited square state q = square q state

  inheritedSubtype→compatibleSubtype :
    (Inherited : X′ → Type ℓI)
    → ((q : Q) (state : Σ[ revised ∈ X′ ] Inherited revised)
       → r′ q (fst state) ≡
          compare q (r q (stateMap (fst state))))
    → (Σ[ revised ∈ X′ ] Inherited revised)
    → (Σ[ revised ∈ X′ ] Compatible revised)
  inheritedSubtype→compatibleSubtype Inherited square state =
    fst state , inheritance→compatible Inherited square state

------------------------------------------------------------------------
-- 5. Bool controls: state splitting is conservative; novelty is not
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

------------------------------------------------------------------------
-- 6. Localized control: inherit false; leave the novel true state outside
------------------------------------------------------------------------

InheritedBoolState : Bool → Type₀
InheritedBoolState false = Unit
InheritedBoolState true  = ⊥

inheritedStateMap : (Σ[ state ∈ Bool ] InheritedBoolState state) → Unit
inheritedStateMap state = tt

module Localized =
  InheritedResponseImage
    (λ _ → Bool) (λ _ → Bool)
    oldResponse novelResponse
    InheritedBoolState inheritedStateMap
    (λ _ response → response)

localized-square : Localized.Observation.ResponseSquare
localized-square tt (false , inherited) = refl
localized-square tt (true  , impossible) = Empty.rec impossible

-- The inherited response image transports exactly as before.
localized-false-computes :
  Localized.revisedImage→comparisonImage localized-square tt
      (restrictToImage (Localized.inheritedResponse tt) (false , tt))
    ≡ restrictToImage (Localized.comparedOld tt) tt
localized-false-computes =
  Localized.map-restrict localized-square tt (false , tt)

true-not-inherited : ¬ InheritedBoolState true
true-not-inherited impossible = impossible

inherited-cannot-respond-true :
  (Σ[ state ∈ Localized.InheritedState ]
    (Localized.inheritedResponse tt state ≡ true)) → ⊥
inherited-cannot-respond-true ((false , inherited) , response) =
  false≢true response
inherited-cannot-respond-true ((true , impossible) , response) =
  Empty.rec impossible

-- The novel full-state response is not falsely imported into the inherited
-- response image.  It remains available as `true-is-revised` above, but the
-- localized square makes no assertion about that non-inherited state.
true-absent-from-inherited-image :
  ¬ isInImage (Localized.inheritedResponse tt) true
true-absent-from-inherited-image =
  PT.rec isProp⊥ inherited-cannot-respond-true

------------------------------------------------------------------------
-- 7. Maximality control: compatibility discovers exactly the false state
------------------------------------------------------------------------

module MaximalNovel =
  MaximalCompatibleResponseImage
    (λ _ → Bool) (λ _ → Bool)
    oldResponse novelResponse splitState
    (λ _ response → response)

false-is-compatible : MaximalNovel.Compatible false
false-is-compatible tt = refl

true-is-incompatible : ¬ MaximalNovel.Compatible true
true-is-incompatible compatible =
  false≢true (sym (compatible tt))

-- The maximal compatible subtype carries the same checked image map without
-- an independently supplied inheritance predicate.
maximal-false-computes :
  MaximalNovel.InheritedAdapter.revisedImage→comparisonImage
      MaximalNovel.compatible-square tt
      (restrictToImage
        (MaximalNovel.InheritedAdapter.inheritedResponse tt)
        (false , false-is-compatible))
    ≡ restrictToImage
        (MaximalNovel.InheritedAdapter.comparedOld tt) tt
maximal-false-computes =
  MaximalNovel.InheritedAdapter.map-restrict
    MaximalNovel.compatible-square tt (false , false-is-compatible)
