{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- UniversalFamilyComponentNoDescentProbe
--
-- A hostile control and first exact instance for
-- `HolonomyDescentObstructionProbe`.
--
-- Observe the universe only through its SET TRUNCATION:
--
--     componentObservation : Type₀ → ∥ Type₀ ∥₂.
--
-- This retains which connected component / equivalence class a type belongs
-- to and erases the higher identity inside that component.  The identity
-- family `T ↦ T` has a Bool automorphism loop, produced by univalence from
-- negation.  Transport around that loop swaps true and false.  Set truncation
-- kills the loop, so the universal family cannot descend to the set of type
-- components.
--
-- This isolates the higher obstruction.  The observation does not identify
-- Bool with a type from another connected component; it forgets only the
-- automorphism path inside Bool's own component.  Every pointwise fiber type
-- can remain in the same equivalence class while the family still refuses
-- descent because the quotient erased HOW identity acts.
--
-- STATUS.  Complete and hole-free; warm Nadi verdict owed.  Load beside
-- `HolonomyDescentObstructionProbe.agda` (stage both into one include root if
-- the daemon's absolute-load path does not add this directory).
------------------------------------------------------------------------

module UniversalFamilyComponentNoDescentProbe where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Equiv using (_≃_ ; equivFun)
open import Cubical.Foundations.Isomorphism using (Iso ; isoToEquiv)
open import Cubical.Foundations.Univalence using (ua ; uaβ)
open import Cubical.Data.Bool
  using (Bool ; true ; false ; not ; false≢true)
open import Cubical.HITs.SetTruncation
  using (∥_∥₂ ; ∣_∣₂ ; squash₂)
open import Cubical.Relation.Nullary using (¬_)

open import HolonomyDescentObstructionProbe
  using (kernel-holonomy-obstructs-descent)
open import AvataranaBhanga_TheQuotientCannotHostTheTypeOfWitnessesAndTheProofIsOneTransport
  using (DependentFactorsThrough)

------------------------------------------------------------------------
-- 1. The nontrivial automorphism loop of Bool.
------------------------------------------------------------------------

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

-- The identity family over the universe actually executes that loop:
-- true is transported to false.
boolHolonomyMovesTrue :
  ¬ (transport (cong (λ T → T) boolAutomorphismLoop) true ≡ true)
boolHolonomyMovesTrue h =
  false≢true (sym (uaβ notEquiv true) ∙ h)

------------------------------------------------------------------------
-- 2. The set of components kills the automorphism loop.
------------------------------------------------------------------------

componentObservation : Type₀ → ∥ Type₀ ∥₂
componentObservation = ∣_∣₂

componentKillsBoolLoop :
  cong componentObservation boolAutomorphismLoop ≡ refl
componentKillsBoolLoop =
  squash₂ _ _ (cong componentObservation boolAutomorphismLoop) refl

------------------------------------------------------------------------
-- 3. THE INSTANCE: the universal family does not descend to components.
------------------------------------------------------------------------

universalFamilyDoesNotDescendToComponents :
  ¬ DependentFactorsThrough componentObservation (λ T → T)
universalFamilyDoesNotDescendToComponents =
  kernel-holonomy-obstructs-descent
    componentObservation (λ T → T)
    Bool boolAutomorphismLoop true
    componentKillsBoolLoop boolHolonomyMovesTrue
