{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- SingletonWitnessStabilization
--
-- One separator in the last insufficient chart fibre defeats every coarser
-- chart when the charts are genuinely nested.  Final-world sufficiency at the
-- next depth restricts to the current stage, so that single arrived separator
-- is a complete positive certificate of terminal-depth stabilization.
--
-- The converse, needed to call the first separator arrival the exact first
-- stabilization time, is intentionally searchable: mere failure of
-- sufficiency does not construct a separator in Cubical type theory.  The
-- existing FormationRelativeMinimality decision interface supplies the
-- converse exactly when value equality and the stage separator type are
-- decidable.
------------------------------------------------------------------------

module SingletonWitnessStabilization where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Bool
  using (Bool ; false ; true ; true≢false ; _≟_)
open import Cubical.Data.Empty as Empty using (⊥ ; rec)
open import Cubical.Data.Nat using (ℕ ; zero ; suc)
open import Cubical.Data.Nat.Order
  using (_≤_ ; ≤-refl ; zero-≤ ; pred-≤-pred ; ¬-<-zero)
open import Cubical.Data.Sigma
  using (_×_ ; _,_ ; fst ; snd)
open import Cubical.Data.Unit using (Unit ; tt)
open import Cubical.Relation.Nullary using (¬_ ; Dec ; yes ; no)
import FormationRelativeMinimality as FR

private
  variable
    ℓX ℓC ℓV ℓS ℓF : Level

------------------------------------------------------------------------
-- 1. The positive singleton-basis adapter
------------------------------------------------------------------------

module SingletonBasis
  {X : Type ℓX} {V : Type ℓV}
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
  where

  module StageWorld = FR.Chain Stage Chart chart value
  module FinalWorld = FR.Chain Final Chart chart value
  module StageAtPredecessor = FR.AtPoint Stage (chart predecessor) value

  -- A positive certificate that the current stage has reached the declared
  -- terminal depth `predecessor + 1`: that depth suffices, and every coarser
  -- chart fails.
  StageStabilized : Type _
  StageStabilized =
    StageWorld.FormedSufficientAt (suc predecessor) base
    × ((depth : ℕ) → depth ≤ predecessor
       → ¬ StageWorld.FormedSufficientAt depth base)

  final-sufficiency-restricts :
      FinalWorld.FormedSufficientAt (suc predecessor) base
    → StageWorld.FormedSufficientAt (suc predecessor) base
  final-sufficiency-restricts sufficient y formed same-chart =
    sufficient y (include y formed) same-chart

  -- The same point and task separation witness every coarser failure.  Only
  -- its chart-equality proof changes, through the supplied nesting map.
  deepest-witness→coarser-witness :
      StageWorld.FormedWitnessAt predecessor base
    → (depth : ℕ) → depth ≤ predecessor
    → StageWorld.FormedWitnessAt depth base
  deepest-witness→coarser-witness witness depth depth≤predecessor =
    fst witness ,
      (fst (snd witness) ,
        (nested-to-predecessor
          depth depth≤predecessor (fst witness)
          (fst (snd (snd witness))) ,
         snd (snd (snd witness))))

  singleton-arrival-stabilizes :
      FinalWorld.FormedSufficientAt (suc predecessor) base
    → StageWorld.FormedWitnessAt predecessor base
    → StageStabilized
  singleton-arrival-stabilizes final-sufficient arrived =
    final-sufficiency-restricts final-sufficient ,
      λ depth depth≤predecessor →
        StageWorld.witness-forces-formed-insufficiency depth base
          (deepest-witness→coarser-witness
            arrived depth depth≤predecessor)

  -- The depth-zero branch needs no separator: final sufficiency simply
  -- restricts to every stage.
  zero-terminal-stabilizes :
      FinalWorld.FormedSufficientAt zero base
    → StageWorld.FormedSufficientAt zero base
  zero-terminal-stabilizes sufficient y formed same-chart =
    sufficient y (include y formed) same-chart

------------------------------------------------------------------------
-- 2. Exact first-arrival converse, with its constructive price exposed
------------------------------------------------------------------------

  stabilized→predecessor-insufficient :
    StageStabilized
    → ¬ StageWorld.FormedSufficientAt predecessor base
  stabilized→predecessor-insufficient stabilized =
    snd stabilized predecessor ≤-refl

  searchable-stabilized→witness :
      ((y : X) → Dec (value y ≡ value base))
    → Dec (StageWorld.FormedWitnessAt predecessor base)
    → StageStabilized
    → StageWorld.FormedWitnessAt predecessor base
  searchable-stabilized→witness decide-value decide-witness stabilized =
    StageAtPredecessor.searchable-insufficiency→counterexample
      base decide-value decide-witness
      (stabilized→predecessor-insufficient stabilized)

  no-arrival→not-stabilized :
      ((y : X) → Dec (value y ≡ value base))
    → ¬ StageWorld.FormedWitnessAt predecessor base
    → ¬ StageStabilized
  no-arrival→not-stabilized decide-value no-arrival stabilized =
    no-arrival
      (searchable-stabilized→witness
        decide-value (no no-arrival) stabilized)

------------------------------------------------------------------------
-- 3. Positive control: one depth-one separator kills depths one and zero
------------------------------------------------------------------------

NestedChart : ℕ → Type₀
NestedChart zero                = Unit
NestedChart (suc zero)          = Unit
NestedChart (suc (suc depth))   = Bool

nestedChart : (depth : ℕ) → Bool → NestedChart depth
nestedChart zero state              = tt
nestedChart (suc zero) state        = tt
nestedChart (suc (suc depth)) state = state

boolValue : Bool → Bool
boolValue state = state

AllFormed : Bool → Type₀
AllFormed state = Unit

includeAll : (state : Bool) → AllFormed state → AllFormed state
includeAll state formed = tt

nested-to-one :
  (depth : ℕ) → depth ≤ suc zero → (state : Bool)
  → nestedChart (suc zero) state ≡ nestedChart (suc zero) false
  → nestedChart depth state ≡ nestedChart depth false
nested-to-one zero depth≤one state same = refl
nested-to-one (suc zero) depth≤one state same = same
nested-to-one (suc (suc depth)) depth≤one state same =
  Empty.rec (¬-<-zero (pred-≤-pred depth≤one))

module GoodControl =
  SingletonBasis
    AllFormed AllFormed includeAll NestedChart nestedChart boolValue false
    (suc zero) nested-to-one

good-final-depth-two-sufficient :
  GoodControl.FinalWorld.FormedSufficientAt (suc (suc zero)) false
good-final-depth-two-sufficient state formed same-chart = same-chart

good-arrived-depth-one-witness :
  GoodControl.StageWorld.FormedWitnessAt (suc zero) false
good-arrived-depth-one-witness =
  true , (tt , (refl , true≢false))

good-stabilized : GoodControl.StageStabilized
good-stabilized =
  GoodControl.singleton-arrival-stabilizes
    good-final-depth-two-sufficient good-arrived-depth-one-witness

good-depth-one-insufficient :
  ¬ GoodControl.StageWorld.FormedSufficientAt (suc zero) false
good-depth-one-insufficient = snd good-stabilized (suc zero) ≤-refl

good-depth-zero-insufficient :
  ¬ GoodControl.StageWorld.FormedSufficientAt zero false
good-depth-zero-insufficient = snd good-stabilized zero zero-≤

good-search-recovers-witness :
  GoodControl.StageWorld.FormedWitnessAt (suc zero) false
good-search-recovers-witness =
  GoodControl.searchable-stabilized→witness
    (λ state → state ≟ false)
    (yes good-arrived-depth-one-witness)
    good-stabilized

------------------------------------------------------------------------
-- 4. Hostile control: without nesting the deepest witness is not a basis
------------------------------------------------------------------------

BadChart : ℕ → Type₀
BadChart zero                = Bool
BadChart (suc zero)          = Unit
BadChart (suc (suc depth))   = Bool

badChart : (depth : ℕ) → Bool → BadChart depth
badChart zero state              = state
badChart (suc zero) state        = tt
badChart (suc (suc depth)) state = state

module BadControl = FR.Chain AllFormed BadChart badChart boolValue

bad-deepest-witness :
  BadControl.FormedWitnessAt (suc zero) false
bad-deepest-witness = true , (tt , (refl , true≢false))

bad-depth-zero-sufficient :
  BadControl.FormedSufficientAt zero false
bad-depth-zero-sufficient state formed same-chart = same-chart

bad-no-nesting-to-zero :
  ¬ ((state : Bool)
     → badChart (suc zero) state ≡ badChart (suc zero) false
     → badChart zero state ≡ badChart zero false)
bad-no-nesting-to-zero nested = true≢false (nested true refl)

