{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- ExposureStabilizationAdapter
--
-- A causal exposure certificate turns a critical hit in the final world into
-- the stage separator consumed by SingletonWitnessStabilization.  The
-- composition is positive: no separator search, closure, or choice is used.
------------------------------------------------------------------------

module ExposureStabilizationAdapter where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Bool
  using (Bool ; false ; true ; true≢false)
open import Cubical.Data.Empty as Empty using (⊥ ; rec)
open import Cubical.Data.Nat using (ℕ ; zero ; suc)
open import Cubical.Data.Nat.Order using (_≤_)
open import Cubical.Data.Sigma using (_×_ ; _,_ ; fst ; snd)
open import Cubical.Data.Unit using (Unit ; tt)
open import Cubical.Relation.Nullary using (¬_)
import FormationDirectionIncidence as DI
import SingletonWitnessStabilization as SW

private
  variable
    ℓX ℓC ℓV ℓD ℓK ℓS ℓF : Level

------------------------------------------------------------------------
-- 1. Exact composition
------------------------------------------------------------------------

module Adapter
  {X : Type ℓX} {V : Type ℓV} {D : Type ℓD}
  (Stage : X → Type ℓS)
  (Final : X → Type ℓF)
  (include : (x : X) → Stage x → Final x)
  (Chart : ℕ → Type ℓC)
  (chart : (depth : ℕ) → X → Chart depth)
  (value : X → V)
  (base : X)
  (predecessor : ℕ)
  (nested-to-predecessor :
    (depth : ℕ) → depth ≤ predecessor → (y : X)
    → chart predecessor y ≡ chart predecessor base
    → chart depth y ≡ chart depth base)
  (direction :
    (y : X) → chart predecessor y ≡ chart predecessor base → D)
  (Critical : D → Type ℓK)
  (critical→different :
    (y : X) (same-chart :
      chart predecessor y ≡ chart predecessor base)
    → Critical (direction y same-chart)
    → ¬ (value y ≡ value base))
  (different→critical :
    (y : X) (same-chart :
      chart predecessor y ≡ chart predecessor base)
    → ¬ (value y ≡ value base)
    → Critical (direction y same-chart))
  where

  module Basis =
    SW.SingletonBasis
      Stage Final include Chart chart value base predecessor
      nested-to-predecessor

  module Exposure =
    DI.DirectionExposure
      Stage Final include (chart predecessor) value base direction Critical
      critical→different different→critical

  -- The final hit is mathematical incidence.  `expose` is the causal theorem
  -- that the hit has actually arrived.  Only after that theorem is applied do
  -- we convert the realized direction into the separator expected by Basis.
  exposed-final-hit→stabilized :
      Basis.FinalWorld.FormedSufficientAt (suc predecessor) base
    → Exposure.ExposureBound
    → Exposure.FinalDirections.DirectionHit
    → Basis.StageStabilized
  exposed-final-hit→stabilized final-sufficient expose final-hit =
    Basis.singleton-arrival-stabilizes final-sufficient
      (Exposure.StageDirections.hit→counterexample (expose final-hit))

------------------------------------------------------------------------
-- 2. Positive control: exposure is identity when stage and final worlds agree
------------------------------------------------------------------------

goodDirection :
  (state : Bool)
  → SW.nestedChart (suc zero) state
      ≡ SW.nestedChart (suc zero) false
  → Bool
goodDirection state same-chart = state

GoodCritical : Bool → Type₀
GoodCritical state = state ≡ true

good-critical→different :
  (state : Bool)
  (same-chart :
    SW.nestedChart (suc zero) state
      ≡ SW.nestedChart (suc zero) false)
  → GoodCritical (goodDirection state same-chart)
  → ¬ (SW.boolValue state ≡ SW.boolValue false)
good-critical→different state same-chart critical same-value =
  true≢false (sym critical ∙ same-value)

good-different→critical :
  (state : Bool)
  (same-chart :
    SW.nestedChart (suc zero) state
      ≡ SW.nestedChart (suc zero) false)
  → ¬ (SW.boolValue state ≡ SW.boolValue false)
  → GoodCritical (goodDirection state same-chart)
good-different→critical false same-chart different =
  Empty.rec (different refl)
good-different→critical true same-chart different = refl

module GoodAdapter =
  Adapter
    SW.AllFormed SW.AllFormed SW.includeAll
    SW.NestedChart SW.nestedChart SW.boolValue false (suc zero)
    SW.nested-to-one goodDirection GoodCritical
    good-critical→different good-different→critical

good-final-critical-hit :
  GoodAdapter.Exposure.FinalDirections.DirectionHit
good-final-critical-hit = true , (tt , (refl , refl))

good-exposure : GoodAdapter.Exposure.ExposureBound
good-exposure hit =
  fst hit , (tt , snd (snd hit))

good-exposure-stabilizes : GoodAdapter.Basis.StageStabilized
good-exposure-stabilizes =
  GoodAdapter.exposed-final-hit→stabilized
    SW.good-final-depth-two-sufficient
    good-exposure
    good-final-critical-hit

------------------------------------------------------------------------
-- 3. Hostile control: inclusion without reverse exposure cannot feed Adapter
------------------------------------------------------------------------

diagonal-cannot-supply-exposure :
  ¬ DI.DiagonalExposure.ExposureBound
diagonal-cannot-supply-exposure = DI.no-diagonal-exposure-bound
