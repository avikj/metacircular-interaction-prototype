{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- PhysicalLearningQuotient
--
-- Exact behavioral-kernel refinement of PhysicalLearningCore.
--
-- The original module supplies a port-indexed compiler and proves its
-- one-step dynamics and readout squares.  Here the compiler is compared to
-- the repository's established complete finite-word behavior.  For each of
-- the two declared ports, equality after compilation is equivalent, including
-- proof level, to equality under every finite action word.  The coherent
-- kernel is a strict refinement of the population kernel.
--
-- This is a theorem about the deliberately chosen Bool/Unit compiler, not a
-- construction of a learner.  It adds no noisy update, memory, instrument,
-- matrix-to-response realization, Born rule, or empirical physical claim.
------------------------------------------------------------------------

module PhysicalLearningQuotient where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Equiv using (_≃_)
open import Cubical.Foundations.HLevels using (isPropΠ)
open import Cubical.Foundations.Isomorphism using (iso ; isoToEquiv)
open import Cubical.Data.Bool
  using (true ; false ; true≢false ; isSetBool)
open import Cubical.Data.List using ([])
open import Cubical.Data.Unit using (tt)
open import Cubical.Data.Unit.Properties using (isSetUnit)
open import Cubical.Relation.Nullary using (¬_)

import MyhillNerodeMinimalMachine as FB
open import PhysicalLearningCore

------------------------------------------------------------------------
-- 1. Complete finite-word futures for the declared physical actions
------------------------------------------------------------------------

-- MyhillNerodeMinimalMachine orders its arguments as state then action.
physicalStep : Phase → Action → Phase
physicalStep state action = evolve action state

PhysicalNerodeCongruence : (p : Port) → Phase → Phase → Type₀
PhysicalNerodeCongruence p = FB.NerodeCongruence physicalStep (observe p)

response-isSet : (p : Port) → isSet (Response p)
response-isSet population = isSetUnit
response-isSet coherent = isSetBool

compiled-isSet : (p : Port) → isSet (Compiled p)
compiled-isSet population = isSetUnit
compiled-isSet coherent = isSetBool

compiled-kernel-isProp : (p : Port) (left right : Phase)
  → isProp (compile p left ≡ compile p right)
compiled-kernel-isProp p left right = compiled-isSet p _ _

future-kernel-isProp : (p : Port) (left right : Phase)
  → isProp (PhysicalNerodeCongruence p left right)
future-kernel-isProp p left right =
  isPropΠ (λ word → response-isSet p _ _)

------------------------------------------------------------------------
-- 2. The chosen compiler presents exactly the complete behavior kernel
------------------------------------------------------------------------

compile-kernel→future-kernel : (p : Port) {left right : Phase}
  → compile p left ≡ compile p right
  → PhysicalNerodeCongruence p left right
compile-kernel→future-kernel population same word = refl
compile-kernel→future-kernel coherent same word =
  cong (λ state → FB.behavior physicalStep (observe coherent) state word) same

-- The empty word recovers the coherent state; at the population port every
-- compiled value is definitionally the unique Unit value.
future-kernel→compile-kernel : (p : Port) {left right : Phase}
  → PhysicalNerodeCongruence p left right
  → compile p left ≡ compile p right
future-kernel→compile-kernel population same = refl
future-kernel→compile-kernel coherent same = same []

-- Both inverse laws are explicit.  They use only that the relevant equality
-- families are propositions, as established immediately above.
compiled-kernel≃future-kernel : (p : Port) (left right : Phase)
  → (compile p left ≡ compile p right)
    ≃ PhysicalNerodeCongruence p left right
compiled-kernel≃future-kernel p left right =
  isoToEquiv (iso
    (compile-kernel→future-kernel p)
    (future-kernel→compile-kernel p)
    (λ future-equal → future-kernel-isProp p left right _ future-equal)
    (λ compiled-equal → compiled-kernel-isProp p left right _ compiled-equal))

------------------------------------------------------------------------
-- 3. The admitted coherent port strictly refines the population port
------------------------------------------------------------------------

coherent-future→population-future : {left right : Phase}
  → PhysicalNerodeCongruence coherent left right
  → PhysicalNerodeCongruence population left right
coherent-future→population-future =
  FB.nerodeCongruence-of-finer physicalStep
    (observe population) (observe coherent) (λ _ → tt) (λ _ → refl)

population-future-collision : PhysicalNerodeCongruence population true false
population-future-collision word = refl

coherent-future-separator : ¬ PhysicalNerodeCongruence coherent true false
coherent-future-separator equal = true≢false (equal [])

record StrictFutureRefinement : Type₀ where
  field
    kernel-inclusion : {left right : Phase}
      → PhysicalNerodeCongruence coherent left right
      → PhysicalNerodeCongruence population left right
    oldCollision : PhysicalNerodeCongruence population true false
    newSeparator : ¬ PhysicalNerodeCongruence coherent true false

interaction-future-refinement-strict : StrictFutureRefinement
interaction-future-refinement-strict .StrictFutureRefinement.kernel-inclusion =
  coherent-future→population-future
interaction-future-refinement-strict .StrictFutureRefinement.oldCollision =
  population-future-collision
interaction-future-refinement-strict .StrictFutureRefinement.newSeparator =
  coherent-future-separator
