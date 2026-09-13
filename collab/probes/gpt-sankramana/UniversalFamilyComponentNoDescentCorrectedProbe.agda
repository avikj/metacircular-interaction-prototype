{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- UniversalFamilyComponentNoDescentCorrectedProbe
--
-- Exact higher-descent control, pointed at the corrected generic probe.
-- The set truncation of the universe remembers type components and erases
-- automorphism loops.  Bool negation gives one such loop by univalence, and
-- transport around it moves true to false.  Hence the universal family
-- `T ↦ T` cannot descend to the set of components.
------------------------------------------------------------------------

module UniversalFamilyComponentNoDescentCorrectedProbe where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Equiv using (_≃_)
open import Cubical.Foundations.Isomorphism using (Iso ; isoToEquiv)
open import Cubical.Foundations.Univalence using (ua ; uaβ)
open import Cubical.Data.Bool
  using (Bool ; true ; false ; not ; false≢true)
open import Cubical.HITs.SetTruncation
  using (∥_∥₂ ; ∣_∣₂ ; squash₂)
open import Cubical.Relation.Nullary using (¬_)

open import HolonomyDescentObstructionCorrectedProbe
  using (kernel-holonomy-obstructs-descent)
open import AvataranaBhanga_TheQuotientCannotHostTheTypeOfWitnessesAndTheProofIsOneTransport
  using (DependentFactorsThrough)

notIso : Iso Bool Bool
Iso.fun notIso = not
Iso.inv notIso = not
Iso.rightInv notIso false = refl
Iso.rightInv notIso true  = refl
Iso.leftInv  notIso false = refl
Iso.leftInv  notIso true  = refl

notEquiv : Bool ≃ Bool
notEquiv = isoToEquiv notIso

boolAutomorphismLoop : Bool ≡ Bool
boolAutomorphismLoop = ua notEquiv

boolHolonomyMovesTrue :
  ¬ (transport (cong (λ T → T) boolAutomorphismLoop) true ≡ true)
boolHolonomyMovesTrue h =
  false≢true (sym (uaβ notEquiv true) ∙ h)

componentObservation : Type₀ → ∥ Type₀ ∥₂
componentObservation = ∣_∣₂

componentKillsBoolLoop :
  cong componentObservation boolAutomorphismLoop ≡ refl
componentKillsBoolLoop =
  squash₂ _ _ (cong componentObservation boolAutomorphismLoop) refl

universalFamilyDoesNotDescendToComponents :
  ¬ DependentFactorsThrough componentObservation (λ T → T)
universalFamilyDoesNotDescendToComponents =
  kernel-holonomy-obstructs-descent
    componentObservation (λ T → T)
    Bool boolAutomorphismLoop true
    componentKillsBoolLoop boolHolonomyMovesTrue
