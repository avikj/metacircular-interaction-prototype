{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- NaturalMachine.RelationalProcessCore
--
-- A small interaction-relative process calculus in dependent type theory.
--
-- This is RQM-adjacent mathematics, not a formalization of Relational
-- Quantum Mechanics and not a metaphysical identification.  Its exact scope
-- is narrower:
--
--   * a fact is indexed by the locus at which it is available;
--   * comparison between loci is transport along an explicit interaction;
--   * local facts may exist even when no observer-independent global choice
--     exists;
--   * retaining the rooted/sheet datum repairs that particular obstruction.
--
-- The control is the Bool double cover of S¹.  Its loop exchanges sheets,
-- so a global section would give a fixed point of Bool negation.  Pulling the
-- family back to its own total space has the canonical rooted section.
------------------------------------------------------------------------

module NaturalMachine.RelationalProcessCore where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Bool
  using (Bool ; true ; false ; notEq ; true≢false ; isSetBool)
open import Cubical.Data.Unit using (Unit ; tt ; isSetUnit)
open import Cubical.Data.Sigma using (Σ-syntax ; _,_ ; fst ; snd)
open import Cubical.Functions.Surjection using (isSurjection)
open import Cubical.HITs.S1 using (S¹ ; base ; loop)
open import Cubical.HITs.PropositionalTruncation using (∣_∣₁)
open import Cubical.Relation.Nullary using (¬_)

import NaturalMachine.Descent as D
import NaturalMachine.PhysicalLearningCore as Physical

private
  variable
    ℓ ℓ' : Level

------------------------------------------------------------------------
-- 1. Relative facts and interactions
------------------------------------------------------------------------

record RelativeProcess : Type (ℓ-suc (ℓ-max ℓ ℓ')) where
  field
    Locus : Type ℓ
    Fact  : Locus → Type ℓ'

open RelativeProcess public

-- An interaction is not an untyped edge.  It contains a path between
-- loci, a fact before the interaction, a fact after it, and the statement
-- that the latter is exactly transport of the former.
record Interaction (P : RelativeProcess { ℓ} { ℓ'})
    (source target : Locus P) : Type (ℓ-max ℓ ℓ') where
  field
    path   : source ≡ target
    before : Fact P source
    after  : Fact P target
    lawful : subst (Fact P) path before ≡ after

open Interaction public

follow : (P : RelativeProcess { ℓ} { ℓ'})
       {source target : Locus P}
       (p : source ≡ target) (x : Fact P source)
       → Interaction P source target
path   (follow P p x) = p
before (follow P p x) = x
after  (follow P p x) = subst (Fact P) p x
lawful (follow P p x) = refl

-- Every dependent assignment is automatically natural under interaction.
-- This is the exact comparison law: no external viewpoint is inserted.
section-naturality : {B : Type ℓ} (F : B → Type ℓ')
                   (s : (b : B) → F b)
                   {x y : B} (p : x ≡ y)
                   → subst F p (s x) ≡ s y
section-naturality F s {x} {y} p =
  J (λ y p → subst F p (s x) ≡ s y)
    (substRefl {B = F} (s x)) p

------------------------------------------------------------------------
-- 2. A genuine finite-fibre gluing obstruction
------------------------------------------------------------------------

Observer : Type₀
Observer = S¹

-- The fact family has Bool at the named root, but its generating
-- interaction exchanges the two values.  This is dependent data, not a
-- set-level table of observers and labels.
RelativeFact : Observer → Type₀
RelativeFact base     = Bool
RelativeFact (loop i) = notEq i

relationalProcess : RelativeProcess
Locus relationalProcess = Observer
Fact  relationalProcess = RelativeFact

-- Local observer-relative facts exist.
base-true : RelativeFact base
base-true = true

base-false : RelativeFact base
base-false = false

-- The explicit generating interaction carries true to false.
loop-carries-true-to-false : subst RelativeFact loop true ≡ false
loop-carries-true-to-false = refl

loop-carries-false-to-true : subst RelativeFact loop false ≡ true
loop-carries-false-to-true = refl

loop-interaction : Interaction relationalProcess base base
path   loop-interaction = loop
before loop-interaction = true
after  loop-interaction = false
lawful loop-interaction = loop-carries-true-to-false

-- A global observer-independent fact would be a dependent section.
GlobalFact : Type₀
GlobalFact = (o : Observer) → RelativeFact o

-- Local inhabitation does not imply such a global fact: naturality around
-- the physical comparison loop would make negation fix the selected Bool.
no-global-fact : ¬ GlobalFact
no-loop-fixed-point : (b : Bool) → ¬ (subst RelativeFact loop b ≡ b)
no-loop-fixed-point true  p = true≢false (sym p)
no-loop-fixed-point false p = true≢false p

no-global-fact s = no-loop-fixed-point (s base) fixed
  where
  fixed : subst RelativeFact loop (s base) ≡ s base
  fixed = section-naturality RelativeFact s loop

------------------------------------------------------------------------
-- 3. Rooted repair by retaining the interaction-relative sheet
------------------------------------------------------------------------

-- The total space remembers both a locus and the fact available there.
-- It is the smallest canonical refinement supplied by the family itself.
RootedLocus : Type₀
RootedLocus = Σ[ o ∈ Observer ] RelativeFact o

root : RootedLocus → Observer
root = fst

rooted-lift : (o : Observer) → RelativeFact o → RootedLocus
rooted-lift o x = o , x

-- Refinement retains the original observer locus on the nose; the repair
-- adds the situated fact rather than replacing or quotienting the observer.
root-after-lift : (o : Observer) (x : RelativeFact o)
                → root (rooted-lift o x) ≡ o
root-after-lift o x = refl

RootedFact : RootedLocus → Type₀
RootedFact r = RelativeFact (root r)

rootedProcess : RelativeProcess
Locus rootedProcess = RootedLocus
Fact  rootedProcess = RootedFact

-- After the missing sheet coordinate is retained, the pulled-back family
-- has a canonical section.  This does not manufacture an absolute fact on
-- Observer; it changes the base to rooted interaction contexts.
rooted-global-fact : (r : RootedLocus) → RootedFact r
rooted-global-fact = snd

rooted-comparison : {r r' : RootedLocus} (p : r ≡ r')
                  → subst RootedFact p (rooted-global-fact r)
                    ≡ rooted-global-fact r'
rooted-comparison = section-naturality RootedFact rooted-global-fact

record RootedRepair : Type₀ where
  field
    localFactSurvives : RelativeFact base
    oldGlobalBlocked  : ¬ GlobalFact
    refinedGlobal     : (r : RootedLocus) → RootedFact r
    refinedCoherent   : {r r' : RootedLocus} (p : r ≡ r')
                      → subst RootedFact p (refinedGlobal r)
                        ≡ refinedGlobal r'

rooted-repair : RootedRepair
RootedRepair.localFactSurvives rooted-repair = base-true
RootedRepair.oldGlobalBlocked  rooted-repair = no-global-fact
RootedRepair.refinedGlobal     rooted-repair = rooted-global-fact
RootedRepair.refinedCoherent   rooted-repair = rooted-comparison

------------------------------------------------------------------------
-- 4. Which local interaction ports forget the root-relative sheet?
------------------------------------------------------------------------

-- At the named interaction locus, forgetting the situated fact is the same
-- one-state compilation used by PhysicalLearningCore's population port.
forgetBaseFact : RelativeFact base → Unit
forgetBaseFact _ = tt

response-is-set : (p : Physical.Port) → isSet (Physical.Response p)
response-is-set Physical.population = isSetUnit
response-is-set Physical.coherent   = isSetBool

-- The general descent theorem becomes a criterion for each physical port:
-- its response can be computed after forgetting the relative sheet iff it
-- is constant on the facts that forgetting identifies.
port-descent-criterion : (p : Physical.Port)
  → D.Factors forgetBaseFact (Physical.observe p)
    ≣ D.ConstantOnFibres forgetBaseFact (Physical.observe p)
port-descent-criterion p =
  D.descent (response-is-set p) forgetBaseFact base-surjective
    (Physical.observe p)
  where
  base-surjective : isSurjection forgetBaseFact
  base-surjective tt = ∣ true , refl ∣₁

-- Population observation is genuinely unrooted: it factors through the
-- one-state compiler.
population-descends :
  D.Factors forgetBaseFact (Physical.observe Physical.population)
population-descends = (λ _ → tt) , λ _ → refl

-- Coherent observation is essentially situated: the two local facts have
-- the same unrooted image and different coherent responses.
coherent-does-not-descend :
  ¬ D.Factors forgetBaseFact (Physical.observe Physical.coherent)
coherent-does-not-descend through =
  true≢false
    (D.factors→constant forgetBaseFact
      (Physical.observe Physical.coherent) through true false refl)

-- Rigor boundary: this module contains no amplitudes, Born rule, Hilbert
-- space, dynamics, spacetime interpretation, or empirical claim.  It gives
-- one checked dependent-process joint on which those structures can later
-- be installed without first postulating an observer-independent state.
