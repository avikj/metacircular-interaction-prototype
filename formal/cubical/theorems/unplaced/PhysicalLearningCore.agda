{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- PhysicalLearningCore
--
-- A smallest checked classical/quantum joint.
--
-- The physical state is one of the two exact coherent density matrices in
-- CoherentSurvivalDephasing.  They have identical diagonal populations and
-- opposite phase.  Which classical state is sufficient therefore depends on
-- the interaction port:
--
--   population port  : both states compile to Unit;
--   coherent port    : any exact compiler must retain a separating state.
--
-- Evolution and compilation commute.  Changing the admitted interaction
-- from population-only to coherent observation reopens the old quotient;
-- it does not declare the former quotient false.  This is the finite core
-- needed before importing larger quantum dynamics, RQM observers, or LQG
-- boundary graphs.
------------------------------------------------------------------------

module PhysicalLearningCore where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Bool
  using (Bool ; true ; false ; not ; true≢false)
open import Cubical.Data.Unit using (Unit ; tt)
open import Cubical.Data.Sigma using (_×_ ; _,_)
open import Cubical.Data.Int using (ℤ)
open import Cubical.Relation.Nullary using (¬_)

open import CoherentSurvivalDephasing
  using (Matrix₂ ; phasePlus ; phaseMinus ; dephaseℤ ; offDiagonalPort
        ; phase-pair-same-after-dephasing ; off-diagonal-port-separates)

------------------------------------------------------------------------
-- 1. Exact coherent microstate and reversible dynamics
------------------------------------------------------------------------

Phase : Type₀
Phase = Bool

density : Phase → Matrix₂ ℤ
density true  = phasePlus
density false = phaseMinus

data Action : Type₀ where
  stay flip : Action

evolve : Action → Phase → Phase
evolve stay s = s
evolve flip s = not s

flip-involutive : (s : Phase) → evolve flip (evolve flip s) ≡ s
flip-involutive false = refl
flip-involutive true  = refl

------------------------------------------------------------------------
-- 2. Interaction-relative observation
------------------------------------------------------------------------

data Port : Type₀ where
  population coherent : Port

Response : Port → Type₀
Response population = Unit
Response coherent   = Bool

observe : (p : Port) → Phase → Response p
observe population s = tt
observe coherent   s = s

-- Meaning is response under every currently admitted physical action.
Meaning : Port → Phase → Type₀
Meaning p s = Action → Response p

future : (p : Port) → (s : Phase) → Meaning p s
future p s a = observe p (evolve a s)

population-collapses-phase :
  (a : Action) → observe population (evolve a true)
             ≡ observe population (evolve a false)
population-collapses-phase stay = refl
population-collapses-phase flip = refl

coherent-port-separates-phase :
  ¬ (observe coherent true ≡ observe coherent false)
coherent-port-separates-phase = true≢false

-- The abstract port statement is physically realized by the exact matrices:
-- dephasing identifies them, while the off-diagonal port separates them.
matrix-population-collapses : dephaseℤ (density true) ≡ dephaseℤ (density false)
matrix-population-collapses = phase-pair-same-after-dephasing

matrix-coherent-port-separates :
  ¬ (offDiagonalPort (density true) ≡ offDiagonalPort (density false))
matrix-coherent-port-separates = off-diagonal-port-separates

------------------------------------------------------------------------
-- 3. The interaction compiles the exact classical state space
------------------------------------------------------------------------

Compiled : Port → Type₀
Compiled population = Unit
Compiled coherent   = Bool

compile : (p : Port) → Phase → Compiled p
compile population s = tt
compile coherent   s = s

compiledStep : (p : Port) → Action → Compiled p → Compiled p
compiledStep population a q = tt
compiledStep coherent   a q = evolve a q

compile-step :
  (p : Port) (a : Action) (s : Phase)
  → compile p (evolve a s) ≡ compiledStep p a (compile p s)
compile-step population a s = refl
compile-step coherent   a s = refl

readCompiled : (p : Port) → Compiled p → Response p
readCompiled population q = tt
readCompiled coherent   q = q

compile-read :
  (p : Port) (s : Phase) → readCompiled p (compile p s) ≡ observe p s
compile-read population s = refl
compile-read coherent   s = refl

population-one-state : compile population true ≡ compile population false
population-one-state = refl

coherent-two-states : ¬ (compile coherent true ≡ compile coherent false)
coherent-two-states = true≢false

-- This is the missing minimality direction.  It does not assume that the
-- intermediate compiler state is Bool: every exact factorization of the
-- coherent response through an arbitrary type C must keep the two phases
-- distinct.  Our Bool compiler attains that lower bound with its two points.
coherent-compiler-must-separate :
  {ℓ : Level} {C : Type ℓ}
  (encode : Phase → C)
  (decode : C → Bool)
  → ((s : Phase) → decode (encode s) ≡ observe coherent s)
  → ¬ (encode true ≡ encode false)
coherent-compiler-must-separate encode decode correct collision =
  true≢false
    (sym (correct true) ∙ cong decode collision ∙ correct false)

------------------------------------------------------------------------
-- 4. Learning is quotient reopening caused by a new interaction
------------------------------------------------------------------------

record Reopening : Type₀ where
  field
    oldCollision : compile population true ≡ compile population false
    newSeparator : ¬ (compile coherent true ≡ compile coherent false)

interaction-reopens-phase : Reopening
interaction-reopens-phase .Reopening.oldCollision = population-one-state
interaction-reopens-phase .Reopening.newSeparator = coherent-two-states

-- A classical CPU can therefore execute these exact effective dynamics with
-- one state when only population is relevant.  For the coherent port, every
-- exact compiler must retain a separating pair, and Bool attains that bound.
-- No measurement rule,
-- probability calculus, continuum Hilbert space, or claim about biological
-- evolution is smuggled into this finite theorem.
