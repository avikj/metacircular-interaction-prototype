{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- FormationRelativeMinimality
--
-- Sufficiency restricts from an ambient world to any formed subworld.  Exact
-- minimality does not: it additionally needs a formed point in the last
-- insufficient chart fibre whose task value differs.  This module packages
-- that explicit-witness adapter and checks the two-point control where
-- restriction makes the trivial chart sufficient.
--
-- The tempting converse is deliberately not compiled.  For an arbitrary
-- type-valued formation predicate, extracting such a witness from the mere
-- failure of formed sufficiency would imply double-negation elimination for
-- every type.  Finite/searchable formation predicates may add that search as
-- separate data; it is not furnished by restriction alone.
------------------------------------------------------------------------

module FormationRelativeMinimality where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Bool
  using (Bool ; false ; true ; true≢false ; _≟_)
open import Cubical.Data.Empty as Empty using (⊥ ; rec)
open import Cubical.Data.Nat using (ℕ ; zero ; suc)
open import Cubical.Data.Sigma
  using (Σ-syntax ; _×_ ; _,_ ; fst ; snd)
open import Cubical.Data.Unit using (Unit ; tt)
open import Cubical.Relation.Nullary using (¬_ ; Dec ; yes ; no)

private
  variable
    ℓX ℓC ℓV ℓF : Level

------------------------------------------------------------------------
-- 1. One chart at one point
------------------------------------------------------------------------

module AtPoint
  {X : Type ℓX} {C : Type ℓC} {V : Type ℓV}
  (Formed : X → Type ℓF)
  (chart : X → C)
  (value : X → V)
  where

  AmbientSufficientAt : X → Type _
  AmbientSufficientAt x =
    (y : X) → chart y ≡ chart x → value y ≡ value x

  FormedSufficientAt : X → Type _
  FormedSufficientAt x =
    (y : X) → Formed y → chart y ≡ chart x → value y ≡ value x

  FormedCounterexampleAt : X → Type _
  FormedCounterexampleAt x =
    Σ[ y ∈ X ]
      (Formed y ×
        ((chart y ≡ chart x) × (¬ (value y ≡ value x))))

  -- Universal ambient sufficiency only loses quantifiers under restriction.
  ambient→formed :
      (x : X)
    → AmbientSufficientAt x
    → FormedSufficientAt x
  ambient→formed x ambient y formed same-chart =
    ambient y same-chart

  -- A supplied formed separator is constructive evidence of insufficiency.
  counterexample→not-sufficient :
      (x : X)
    → FormedCounterexampleAt x
    → ¬ FormedSufficientAt x
  counterexample→not-sufficient x witness sufficient =
    snd (snd (snd witness))
      (sufficient
        (fst witness)
        (fst (snd witness))
        (fst (snd (snd witness))))

  formed-sufficient→no-counterexample :
      (x : X)
    → FormedSufficientAt x
    → ¬ FormedCounterexampleAt x
  formed-sufficient→no-counterexample x sufficient witness =
    counterexample→not-sufficient x witness sufficient

  -- The exact constructive repair for a searchable formed fibre.  Negative
  -- separator search becomes positive sufficiency only because equality of
  -- task values is itself decidable; chart equality is supplied as a premise
  -- and never needs to be decided.
  no-counterexample→formed-sufficient :
      (x : X)
    → ((y : X) → Dec (value y ≡ value x))
    → ¬ FormedCounterexampleAt x
    → FormedSufficientAt x
  no-counterexample→formed-sufficient x decide-value no-counterexample
      y formed same-chart
    with decide-value y
  ... | yes same-value = same-value
  ... | no different-value =
    Empty.rec
      (no-counterexample
        (y , (formed , (same-chart , different-value))))

  searchable-insufficiency→counterexample :
      (x : X)
    → ((y : X) → Dec (value y ≡ value x))
    → Dec (FormedCounterexampleAt x)
    → ¬ FormedSufficientAt x
    → FormedCounterexampleAt x
  searchable-insufficiency→counterexample
      x decide-value (yes counterexample) not-sufficient =
    counterexample
  searchable-insufficiency→counterexample
      x decide-value (no no-counterexample) not-sufficient =
    Empty.rec
      (not-sufficient
        (no-counterexample→formed-sufficient
          x decide-value no-counterexample))

------------------------------------------------------------------------
-- 2. A chain of charts: ambient next-depth sufficiency plus an explicit
--    previous-depth formed witness transports an exact step.
------------------------------------------------------------------------

module Chain
  {X : Type ℓX} {V : Type ℓV}
  (Formed : X → Type ℓF)
  (Chart : ℕ → Type ℓC)
  (chart : (depth : ℕ) → X → Chart depth)
  (value : X → V)
  where

  AmbientSufficientAt : ℕ → X → Type _
  AmbientSufficientAt depth x =
    (y : X) → chart depth y ≡ chart depth x → value y ≡ value x

  FormedSufficientAt : ℕ → X → Type _
  FormedSufficientAt depth x =
    (y : X) → Formed y
    → chart depth y ≡ chart depth x
    → value y ≡ value x

  FormedWitnessAt : ℕ → X → Type _
  FormedWitnessAt depth x =
    Σ[ y ∈ X ]
      (Formed y ×
        ((chart depth y ≡ chart depth x) × (¬ (value y ≡ value x))))

  AmbientExactStepAt : ℕ → X → Type _
  AmbientExactStepAt depth x =
    AmbientSufficientAt (suc depth) x
    × (¬ AmbientSufficientAt depth x)

  FormedExactStepAt : ℕ → X → Type _
  FormedExactStepAt depth x =
    FormedSufficientAt (suc depth) x
    × (¬ FormedSufficientAt depth x)

  ambient-sufficiency-restricts :
      (depth : ℕ) (x : X)
    → AmbientSufficientAt depth x
    → FormedSufficientAt depth x
  ambient-sufficiency-restricts depth x ambient y formed same-chart =
    ambient y same-chart

  witness-forces-formed-insufficiency :
      (depth : ℕ) (x : X)
    → FormedWitnessAt depth x
    → ¬ FormedSufficientAt depth x
  witness-forces-formed-insufficiency depth x witness sufficient =
    snd (snd (snd witness))
      (sufficient
        (fst witness)
        (fst (snd witness))
        (fst (snd (snd witness))))

  ambient-next+witness→formed-exact-step :
      (depth : ℕ) (x : X)
    → AmbientSufficientAt (suc depth) x
    → FormedWitnessAt depth x
    → FormedExactStepAt depth x
  ambient-next+witness→formed-exact-step depth x ambient-next witness =
    ambient-sufficiency-restricts (suc depth) x ambient-next
    , witness-forces-formed-insufficiency depth x witness

  ambient-exact+witness→formed-exact-step :
      (depth : ℕ) (x : X)
    → AmbientExactStepAt depth x
    → FormedWitnessAt depth x
    → FormedExactStepAt depth x
  ambient-exact+witness→formed-exact-step depth x ambient-exact witness =
    ambient-next+witness→formed-exact-step
      depth x (fst ambient-exact) witness

  -- A regenerative formed world supplies witnesses as an operation rather
  -- than as a finite catalogue.  This is the exact interface needed to
  -- transport every declared ambient exact step.
  WitnessRegeneratorAt : ℕ → Type _
  WitnessRegeneratorAt depth =
    (x : X) → Formed x → FormedWitnessAt depth x

  regeneration-transports-exact-step :
      (depth : ℕ)
    → WitnessRegeneratorAt depth
    → (x : X)
    → Formed x
    → AmbientExactStepAt depth x
    → FormedExactStepAt depth x
  regeneration-transports-exact-step depth regenerate x formed ambient =
    ambient-exact+witness→formed-exact-step
      depth x ambient (regenerate x formed)

------------------------------------------------------------------------
-- 3. Constructive boundary: a generic witness extractor entails DNE
------------------------------------------------------------------------

module DoubleNegationBoundary {P : Type ℓF} where

  controlFormed : Bool → Type ℓF
  controlFormed false = P → P
  controlFormed true  = P

  controlChart : Bool → Unit
  controlChart _ = tt

  controlValue : Bool → Bool
  controlValue b = b

  module Control = AtPoint controlFormed controlChart controlValue

  sufficient→¬P : Control.FormedSufficientAt false → ¬ P
  sufficient→¬P sufficient p =
    true≢false (sufficient true p refl)

  ¬¬P→¬sufficient : ¬ ¬ P → ¬ Control.FormedSufficientAt false
  ¬¬P→¬sufficient not-not-p sufficient =
    not-not-p (sufficient→¬P sufficient)

  local-extractor-implies-DNE :
      ( (¬ Control.FormedSufficientAt false)
        → Control.FormedCounterexampleAt false )
    → ¬ ¬ P
    → P
  local-extractor-implies-DNE extractor not-not-p
    with extractor (¬¬P→¬sufficient not-not-p)
  ... | false , rest =
    Empty.rec (snd (snd rest) refl)
  ... | true , rest =
    fst rest

------------------------------------------------------------------------
-- 4. Two-point controls
------------------------------------------------------------------------

ControlChart : ℕ → Type₀
ControlChart zero        = Unit
ControlChart (suc depth) = Bool

controlChart : (depth : ℕ) → Bool → ControlChart depth
controlChart zero        state = tt
controlChart (suc depth) state = state

controlValue : Bool → Bool
controlValue state = state

AllFormed : Bool → Type₀
AllFormed state = Unit

module AmbientControl = Chain AllFormed ControlChart controlChart controlValue

ambient-depth-one-sufficient :
  AmbientControl.AmbientSufficientAt (suc zero) false
ambient-depth-one-sufficient y same-chart = same-chart

ambient-depth-zero-insufficient :
  ¬ AmbientControl.AmbientSufficientAt zero false
ambient-depth-zero-insufficient sufficient =
  true≢false (sufficient true refl)

formed-depth-zero-witness :
  AmbientControl.FormedWitnessAt zero false
formed-depth-zero-witness =
  true , (tt , (refl , true≢false))

all-formed-exact-step :
  AmbientControl.FormedExactStepAt zero false
all-formed-exact-step =
  AmbientControl.ambient-exact+witness→formed-exact-step
    zero false
    (ambient-depth-one-sufficient , ambient-depth-zero-insufficient)
    formed-depth-zero-witness

OnlyFalse : Bool → Type₀
OnlyFalse false = Unit
OnlyFalse true  = ⊥

module SingletonControl =
  Chain OnlyFalse ControlChart controlChart controlValue

-- Restriction deletes the only separator, so the trivial chart becomes
-- sufficient even though it is ambiently insufficient above.
singleton-depth-zero-sufficient :
  SingletonControl.FormedSufficientAt zero false
singleton-depth-zero-sufficient false formed same-chart = refl
singleton-depth-zero-sufficient true formed same-chart = Empty.rec formed

-- Searchable repair control: the two-state formed fibre exposes the witness
-- through the exact interface.  The decision procedure is supplied data; the
-- theorem does not infer it from the carrier's name.
module AllAtDepthZero =
  AtPoint AllFormed (controlChart zero) controlValue

bool-value-decidable-at-false :
  (y : Bool) → Dec (controlValue y ≡ controlValue false)
bool-value-decidable-at-false y = y ≟ false

all-at-zero-counterexample :
  AllAtDepthZero.FormedCounterexampleAt false
all-at-zero-counterexample =
  true , (tt , (refl , true≢false))

all-at-zero-insufficient :
  ¬ AllAtDepthZero.FormedSufficientAt false
all-at-zero-insufficient sufficient =
  true≢false (sufficient true tt refl)

search-recovers-all-at-zero-counterexample :
  AllAtDepthZero.FormedCounterexampleAt false
search-recovers-all-at-zero-counterexample =
  AllAtDepthZero.searchable-insufficiency→counterexample
    false
    bool-value-decidable-at-false
    (yes all-at-zero-counterexample)
    all-at-zero-insufficient
