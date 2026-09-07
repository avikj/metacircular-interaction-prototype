{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- SetTruncationCannotCarryNontrivialHolonomyProbe
--
-- The canonical corollary of the corrected holonomy descent obstruction:
-- a family with nontrivial loop transport cannot descend to the set
-- truncation of its base.  The set truncation may preserve components and
-- every pointwise fibre type; what it destroys is the distinction between
-- the observed loop and refl, so it cannot carry the local system.
------------------------------------------------------------------------

module SetTruncationCannotCarryNontrivialHolonomyProbe where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Sigma using (Σ-syntax ; _,_)
open import Cubical.HITs.SetTruncation using (∥_∥₂ ; ∣_∣₂ ; squash₂)
open import Cubical.Relation.Nullary using (¬_)

open import HolonomyDescentObstructionCorrectedProbe
  using (HolonomyWitness ; kernel-holonomy-witness-obstructs-descent)
open import AvataranaBhanga_TheQuotientCannotHostTheTypeOfWitnessesAndTheProofIsOneTransport
  using (DependentFactorsThrough)

private
  variable
    ℓ ℓ' : Level

setTruncationKillsLoop :
  {X : Type ℓ} {x : X} (p : x ≡ x)
  → cong (∣_∣₂ {A = X}) p ≡ refl
setTruncationKillsLoop p =
  squash₂ _ _ (cong ∣_∣₂ p) refl

setTruncationCannotCarryHolonomy :
  {X : Type ℓ} (F : X → Type ℓ')
  (x : X) (p : x ≡ x)
  → HolonomyWitness F x p
  → ¬ DependentFactorsThrough (∣_∣₂ {A = X}) F
setTruncationCannotCarryHolonomy F x p witness =
  kernel-holonomy-witness-obstructs-descent
    ∣_∣₂ F x p (setTruncationKillsLoop p) witness
