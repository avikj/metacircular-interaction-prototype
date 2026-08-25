{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- DescentRequiresTheObserverToRetainHolonomyProbe
--
-- The positive face of the higher descent obstruction.
--
-- If F descends through q and transport around p moves an inhabitant, then
-- q is required to retain p as a nontrivial observed loop.  A sufficient
-- observer is therefore not merely one with enough labels or cardinality;
-- it must possess the path structure on which the hidden transport acts.
------------------------------------------------------------------------

module DescentRequiresTheObserverToRetainHolonomyProbe where

open import Cubical.Foundations.Prelude
open import Cubical.Relation.Nullary using (¬_)

open import HolonomyDescentObstructionCorrectedProbe
  using (HolonomyWitness ; descent-kills-kernel-holonomy)
open import AvataranaBhanga_TheQuotientCannotHostTheTypeOfWitnessesAndTheProofIsOneTransport
  using (DependentFactorsThrough)

private
  variable
    ℓ ℓ' ℓ'' : Level

ObservedLoopSurvives :
  {X : Type ℓ} {O : Type ℓ'}
  (q : X → O) {x : X} (p : x ≡ x)
  → Type ℓ'
ObservedLoopSurvives q p = ¬ (cong q p ≡ refl)

descent-requires-observed-holonomy :
  {X : Type ℓ} {O : Type ℓ'}
  (q : X → O) (F : X → Type ℓ'')
  (x : X) (p : x ≡ x)
  → DependentFactorsThrough q F
  → HolonomyWitness F x p
  → ObservedLoopSurvives q p
descent-requires-observed-holonomy q F x p descent (a , moves) killed =
  moves (descent-kills-kernel-holonomy q F x p a killed descent)
