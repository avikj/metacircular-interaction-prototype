{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- NaturalMachine.FormationDirectionIncidence
--
-- A tangent or direction calculation becomes operational only when the
-- direction is realized by a point of the formed world.  This module is the
-- exact adapter from a supplied critical-direction criterion to the formed
-- counterexample interface of FormationRelativeMinimality.  It deliberately
-- assumes the mathematical calculation identifying critical directions with
-- task separation; it does not manufacture a Taylor theorem or complete a
-- formed world under hypothetical moves.
--
-- World inclusion is covariant for counterexamples and contravariant for
-- sufficiency.  The final two-bit control makes the absent converses visible:
-- the diagonal world is sufficient at its false/false point, while ambient
-- completion adds an off-diagonal critical direction and is insufficient.
------------------------------------------------------------------------

module NaturalMachine.FormationDirectionIncidence where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Bool
  using (Bool ; false ; true ; true≢false ; _⊕_)
open import Cubical.Data.Empty as Empty using (⊥ ; rec)
open import Cubical.Data.Sigma
  using (Σ-syntax ; _×_ ; _,_ ; fst ; snd)
open import Cubical.Data.Unit using (Unit ; tt)
open import Cubical.Relation.Nullary using (¬_)
import NaturalMachine.FormationRelativeMinimality as FR

private
  variable
    ℓX ℓC ℓV ℓD ℓF ℓK ℓN ℓW : Level

------------------------------------------------------------------------
-- 1. A supplied mathematical direction criterion compiles to the already
--    checked formed-counterexample interface.  No action presentation or
--    groupoid is needed: only directions actually realized by formed points
--    occur in DirectionHit.
------------------------------------------------------------------------

module DirectionCriterion
  {X : Type ℓX} {C : Type ℓC} {V : Type ℓV} {D : Type ℓD}
  (Formed : X → Type ℓF)
  (chart : X → C)
  (value : X → V)
  (base : X)
  (direction : (y : X) → chart y ≡ chart base → D)
  (Critical : D → Type ℓK)
  (critical→different :
    (y : X) (same-chart : chart y ≡ chart base)
    → Critical (direction y same-chart)
    → ¬ (value y ≡ value base))
  (different→critical :
    (y : X) (same-chart : chart y ≡ chart base)
    → ¬ (value y ≡ value base)
    → Critical (direction y same-chart))
  where

  module World = FR.AtPoint Formed chart value

  DirectionHit : Type _
  DirectionHit =
    Σ[ y ∈ X ]
      (Formed y ×
        (Σ[ same-chart ∈ chart y ≡ chart base ]
          Critical (direction y same-chart)))

  hit→counterexample : DirectionHit → World.FormedCounterexampleAt base
  hit→counterexample hit =
    fst hit ,
      (fst (snd hit) ,
        (fst (snd (snd hit)) ,
          critical→different
            (fst hit)
            (fst (snd (snd hit)))
            (snd (snd (snd hit)))))

  counterexample→hit : World.FormedCounterexampleAt base → DirectionHit
  counterexample→hit counterexample =
    fst counterexample ,
      (fst (snd counterexample) ,
        (fst (snd (snd counterexample)) ,
          different→critical
            (fst counterexample)
            (fst (snd (snd counterexample)))
            (snd (snd (snd counterexample)))))

  hit→not-sufficient : DirectionHit → ¬ World.FormedSufficientAt base
  hit→not-sufficient hit =
    World.counterexample→not-sufficient base (hit→counterexample hit)

------------------------------------------------------------------------
-- 2. Inclusion variance.  A realized separator remains realized in a wider
--    world, while a universal sufficiency proof restricts to a narrower one.
--    Neither construction runs in the opposite direction.
------------------------------------------------------------------------

module WorldInclusion
  {X : Type ℓX} {C : Type ℓC} {V : Type ℓV}
  (Narrow : X → Type ℓN)
  (Wide : X → Type ℓW)
  (include : (x : X) → Narrow x → Wide x)
  (chart : X → C)
  (value : X → V)
  where

  module N = FR.AtPoint Narrow chart value
  module W = FR.AtPoint Wide chart value

  narrow-counterexample→wide :
      (x : X)
    → N.FormedCounterexampleAt x
    → W.FormedCounterexampleAt x
  narrow-counterexample→wide x counterexample =
    fst counterexample ,
      (include (fst counterexample) (fst (snd counterexample)) ,
        snd (snd counterexample))

  wide-sufficient→narrow :
      (x : X)
    → W.FormedSufficientAt x
    → N.FormedSufficientAt x
  wide-sufficient→narrow x sufficient y narrow same-chart =
    sufficient y (include y narrow) same-chart

------------------------------------------------------------------------
-- 3. Executable completion control
------------------------------------------------------------------------

Pair : Type₀
Pair = Bool × Bool

basePair : Pair
basePair = false , false

constantChart : Pair → Unit
constantChart pair = tt

parity : Pair → Bool
parity (left , right) = left ⊕ right

AmbientFormed : Pair → Type₀
AmbientFormed pair = Unit

Diagonal : Pair → Type₀
Diagonal (false , false) = Unit
Diagonal (false , true)  = ⊥
Diagonal (true , false)  = ⊥
Diagonal (true , true)   = Unit

pairDirection :
  (pair : Pair) → constantChart pair ≡ constantChart basePair → Pair
pairDirection pair same-chart = pair

CriticalPair : Pair → Type₀
CriticalPair pair = parity pair ≡ true

critical-pair→different :
  (pair : Pair) (same-chart : constantChart pair ≡ constantChart basePair)
  → CriticalPair (pairDirection pair same-chart)
  → ¬ (parity pair ≡ parity basePair)
critical-pair→different pair same-chart critical same-value =
  true≢false (sym critical ∙ same-value)

different→critical-pair :
  (pair : Pair) (same-chart : constantChart pair ≡ constantChart basePair)
  → ¬ (parity pair ≡ parity basePair)
  → CriticalPair (pairDirection pair same-chart)
different→critical-pair (false , false) same-chart different =
  Empty.rec (different refl)
different→critical-pair (false , true) same-chart different = refl
different→critical-pair (true , false) same-chart different = refl
different→critical-pair (true , true) same-chart different =
  Empty.rec (different refl)

module AmbientDirections =
  DirectionCriterion
    AmbientFormed constantChart parity basePair pairDirection CriticalPair
    critical-pair→different different→critical-pair

module DiagonalDirections =
  DirectionCriterion
    Diagonal constantChart parity basePair pairDirection CriticalPair
    critical-pair→different different→critical-pair

ambient-critical-hit : AmbientDirections.DirectionHit
ambient-critical-hit =
  (false , true) , (tt , (refl , refl))

ambient-completion-insufficient :
  ¬ AmbientDirections.World.FormedSufficientAt basePair
ambient-completion-insufficient =
  AmbientDirections.hit→not-sufficient ambient-critical-hit

diagonal-sufficient :
  DiagonalDirections.World.FormedSufficientAt basePair
diagonal-sufficient (false , false) formed same-chart = refl
diagonal-sufficient (false , true) formed same-chart = Empty.rec formed
diagonal-sufficient (true , false) formed same-chart = Empty.rec formed
diagonal-sufficient (true , true) formed same-chart = refl

no-diagonal-critical-hit : ¬ DiagonalDirections.DirectionHit
no-diagonal-critical-hit hit =
  DiagonalDirections.World.formed-sufficient→no-counterexample
    basePair diagonal-sufficient
    (DiagonalDirections.hit→counterexample hit)

diagonal-inclusion : (pair : Pair) → Diagonal pair → AmbientFormed pair
diagonal-inclusion pair diagonal = tt

module DiagonalCompletion =
  WorldInclusion
    Diagonal AmbientFormed diagonal-inclusion constantChart parity

-- The generic inclusion map is exercised on the diagonal base point.  It
-- transports any separator that is actually present; ambient-critical-hit
-- is intentionally not in its image because its off-diagonal point carries
-- no Diagonal witness.
diagonal-counterexample-widens :
    DiagonalDirections.World.FormedCounterexampleAt basePair
  → AmbientDirections.World.FormedCounterexampleAt basePair
diagonal-counterexample-widens =
  DiagonalCompletion.narrow-counterexample→wide basePair

------------------------------------------------------------------------
-- 4. Intensional exposure boundary
--
-- Inclusion exposes every stage hit to the final world.  Stabilization at a
-- stage is exactly the missing reverse realization operation.  This packages
-- what a budget theorem must deliver without pretending to derive the budget
-- from an arbitrary generator presentation.
------------------------------------------------------------------------

module DirectionExposure
  {X : Type ℓX} {C : Type ℓC} {V : Type ℓV} {D : Type ℓD}
  (Stage : X → Type ℓN)
  (Final : X → Type ℓW)
  (include : (x : X) → Stage x → Final x)
  (chart : X → C)
  (value : X → V)
  (base : X)
  (direction : (y : X) → chart y ≡ chart base → D)
  (Critical : D → Type ℓK)
  (critical→different :
    (y : X) (same-chart : chart y ≡ chart base)
    → Critical (direction y same-chart)
    → ¬ (value y ≡ value base))
  (different→critical :
    (y : X) (same-chart : chart y ≡ chart base)
    → ¬ (value y ≡ value base)
    → Critical (direction y same-chart))
  where

  module StageDirections =
    DirectionCriterion
      Stage chart value base direction Critical
      critical→different different→critical

  module FinalDirections =
    DirectionCriterion
      Final chart value base direction Critical
      critical→different different→critical

  stage-hit→final-hit :
    StageDirections.DirectionHit → FinalDirections.DirectionHit
  stage-hit→final-hit hit =
    fst hit ,
      (include (fst hit) (fst (snd hit)) ,
        snd (snd hit))

  -- This is the exact certificate owed by a finite exposure or stabilization
  -- theorem.  It is positive data, not the negation of a missed search.
  ExposureBound : Type _
  ExposureBound =
    FinalDirections.DirectionHit → StageDirections.DirectionHit

  StableIncidence : Type _
  StableIncidence =
    (StageDirections.DirectionHit → FinalDirections.DirectionHit)
    × (FinalDirections.DirectionHit → StageDirections.DirectionHit)

  exposure→stable-incidence : ExposureBound → StableIncidence
  exposure→stable-incidence expose = stage-hit→final-hit , expose

  final-no-hit→stage-no-hit :
    ¬ FinalDirections.DirectionHit → ¬ StageDirections.DirectionHit
  final-no-hit→stage-no-hit no-final stage-hit =
    no-final (stage-hit→final-hit stage-hit)

  stage-no-hit→final-no-hit :
    ExposureBound
    → ¬ StageDirections.DirectionHit
    → ¬ FinalDirections.DirectionHit
  stage-no-hit→final-no-hit expose no-stage final-hit =
    no-stage (expose final-hit)

module DiagonalExposure =
  DirectionExposure
    Diagonal AmbientFormed diagonal-inclusion constantChart parity basePair
    pairDirection CriticalPair
    critical-pair→different different→critical-pair

-- The diagonal/ambient inclusion is the hostile control: inclusion alone
-- cannot expose the final off-diagonal separator at the diagonal stage.
no-diagonal-exposure-bound : ¬ DiagonalExposure.ExposureBound
no-diagonal-exposure-bound expose =
  no-diagonal-critical-hit (expose ambient-critical-hit)
