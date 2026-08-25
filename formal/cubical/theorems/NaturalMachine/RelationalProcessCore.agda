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
open import Cubical.Foundations.GroupoidLaws using (assoc ; lUnit ; rUnit)
open import Cubical.Foundations.Transport using (substComposite)
open import Cubical.Data.Bool
  using (Bool ; true ; false ; notEq ; true≢false ; isSetBool)
open import Cubical.Data.Unit using (Unit ; tt ; isSetUnit)
open import Cubical.Data.Sigma using (Σ-syntax ; _×_ ; _,_ ; fst ; snd)
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

------------------------------------------------------------------------
-- Path groupoid and compositional interaction semantics
------------------------------------------------------------------------

ProcessArrow : (P : RelativeProcess { ℓ} { ℓ'})
             → Locus P → Locus P → Type ℓ
ProcessArrow P source target = source ≡ target

identityArrow : (P : RelativeProcess { ℓ} { ℓ'}) {o : Locus P}
              → ProcessArrow P o o
identityArrow P = refl

composeArrow : (P : RelativeProcess { ℓ} { ℓ'})
             {a b c : Locus P}
             → ProcessArrow P a b → ProcessArrow P b c
             → ProcessArrow P a c
composeArrow P p q = p ∙ q

reverseArrow : (P : RelativeProcess { ℓ} { ℓ'})
             {a b : Locus P} → ProcessArrow P a b → ProcessArrow P b a
reverseArrow P = sym

transportFact : (P : RelativeProcess { ℓ} { ℓ'})
              {a b : Locus P} → ProcessArrow P a b
              → Fact P a → Fact P b
transportFact P p = subst (Fact P) p

transport-identity : (P : RelativeProcess { ℓ} { ℓ'})
                   {a : Locus P} (x : Fact P a)
                   → transportFact P (identityArrow P) x ≡ x
transport-identity P x = substRefl {B = Fact P} x

transport-composition : (P : RelativeProcess { ℓ} { ℓ'})
  {a b c : Locus P} (p : ProcessArrow P a b) (q : ProcessArrow P b c)
  (x : Fact P a)
  → transportFact P (composeArrow P p q) x
    ≡ transportFact P q (transportFact P p x)
transport-composition P p q x = substComposite (Fact P) p q x

arrow-left-unit : (P : RelativeProcess { ℓ} { ℓ'})
                {a b : Locus P} (p : ProcessArrow P a b)
                → composeArrow P (identityArrow P) p ≡ p
arrow-left-unit P p = sym (lUnit p)

arrow-right-unit : (P : RelativeProcess { ℓ} { ℓ'})
                 {a b : Locus P} (p : ProcessArrow P a b)
                 → composeArrow P p (identityArrow P) ≡ p
arrow-right-unit P p = sym (rUnit p)

arrow-associativity : (P : RelativeProcess { ℓ} { ℓ'})
  {a b c d : Locus P}
  (p : ProcessArrow P a b) (q : ProcessArrow P b c)
  (r : ProcessArrow P c d)
  → composeArrow P p (composeArrow P q r)
    ≡ composeArrow P (composeArrow P p q) r
arrow-associativity P = assoc

identityInteraction : (P : RelativeProcess { ℓ} { ℓ'})
                    {o : Locus P} (x : Fact P o)
                    → Interaction P o o
identityInteraction P x = follow P refl x

composeInteraction : (P : RelativeProcess { ℓ} { ℓ'})
  {a b c : Locus P}
  (first : Interaction P a b) (second : Interaction P b c)
  → after first ≡ before second → Interaction P a c
path   (composeInteraction P first second seam) = path first ∙ path second
before (composeInteraction P first second seam) = before first
after  (composeInteraction P first second seam) = after second
lawful (composeInteraction P first second seam) =
    substComposite (Fact P) (path first) (path second) (before first)
  ∙ cong (subst (Fact P) (path second)) (lawful first)
  ∙ cong (subst (Fact P) (path second)) seam
  ∙ lawful second

interaction-path-associativity : (P : RelativeProcess { ℓ} { ℓ'})
  {a b c d : Locus P}
  (first : Interaction P a b) (second : Interaction P b c)
  (third : Interaction P c d)
  → path first ∙ (path second ∙ path third)
    ≡ (path first ∙ path second) ∙ path third
interaction-path-associativity P first second third =
  assoc (path first) (path second) (path third)

-- Every dependent assignment is automatically natural under interaction.
-- This is the exact comparison law: no external viewpoint is inserted.
section-naturality : {B : Type ℓ} (F : B → Type ℓ')
                   (s : (b : B) → F b)
                   {x y : B} (p : x ≡ y)
                   → subst F p (s x) ≡ s y
section-naturality F s {x} {y} p =
  J (λ y p → subst F p (s x) ≡ s y)
    (substRefl {B = F} (s x)) p

-- A loop whose transport has no fixed fact rules out an unrooted global
-- section.  This is the reusable process-groupoid obstruction; concrete
-- theories need only supply the loop and its fixed-point refutation.
loop-obstructs-global : (P : RelativeProcess { ℓ} { ℓ'})
  {o : Locus P} (p : ProcessArrow P o o)
  → ((x : Fact P o) → ¬ (transportFact P p x ≡ x))
  → ¬ ((locus : Locus P) → Fact P locus)
loop-obstructs-global P p noFixed section =
  noFixed (section _) (section-naturality (Fact P) section p)

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
  → (D.Factors forgetBaseFact (Physical.observe p)
      → D.ConstantOnFibres forgetBaseFact (Physical.observe p))
  × (D.ConstantOnFibres forgetBaseFact (Physical.observe p)
      → D.Factors forgetBaseFact (Physical.observe p))
port-descent-criterion p =
  D.factors→constant forgetBaseFact (Physical.observe p) ,
  D.constant→factors (response-is-set p) forgetBaseFact base-surjective
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
