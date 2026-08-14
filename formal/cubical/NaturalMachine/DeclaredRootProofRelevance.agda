{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- `Declared : Root → Type` is proof-relevant unless its fibres are known to
-- be propositions.  Consequently a `SeparatorFamily` can select different
-- separator data from two declarations of the same root.
--
-- This module isolates the exact condition under which the existing
-- declared-root interface behaves like an ordinary root subset.
------------------------------------------------------------------------

module NaturalMachine.DeclaredRootProofRelevance where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Bool
  using (Bool ; false ; true ; false≢true ; true≢false ; isSetBool)
open import Cubical.Data.Sigma using (fst)
open import Cubical.Data.Unit using (Unit ; tt)
open import Cubical.Relation.Nullary using (¬_)

import NaturalMachine.DeclaredRootedProfiles as DRP

private
  variable
    ℓR ℓX ℓO ℓD : Level

------------------------------------------------------------------------
-- When declaration fibres are propositions, separator choice is determined
-- by the root rather than by the declaration proof.
------------------------------------------------------------------------

DeclarationIsProp : {Root : Type ℓR} → (Root → Type ℓD)
  → Type (ℓ-max ℓR ℓD)
DeclarationIsProp Declared = (root : _) → isProp (Declared root)

RootDetermined :
    {Root : Type ℓR} {X : Type ℓX}
    {Observation : Root → Type ℓO} {Declared : Root → Type ℓD}
    {profile : DRP.RootedProfile Root X Observation}
  → DRP.SeparatorFamily Declared profile
  → Type (ℓ-max ℓR (ℓ-max ℓD (ℓ-max ℓX ℓO)))
RootDetermined family =
  (root : _) (left right : _) → family root left ≡ family root right

propositional-declarations-are-root-determined :
    {Root : Type ℓR} {X : Type ℓX}
    {Observation : Root → Type ℓO} {Declared : Root → Type ℓD}
    {profile : DRP.RootedProfile Root X Observation}
  → DeclarationIsProp Declared
  → (family : DRP.SeparatorFamily Declared profile)
  → RootDetermined family
propositional-declarations-are-root-determined declaredIsProp family
  root left right =
  cong (family root) (declaredIsProp root left right)

-- The sampled north-root declaration is genuinely predicate-like because
-- Bool is a set, so each equality fibre `root ≡ false` is a proposition.
northDeclared-isProp : DeclarationIsProp DRP.northDeclared
northDeclared-isProp root = isSetBool root false

northDeclared-root-determined : RootDetermined DRP.northDeclaredSeparators
northDeclared-root-determined =
  propositional-declarations-are-root-determined
    northDeclared-isProp DRP.northDeclaredSeparators

------------------------------------------------------------------------
-- Hostile control: a Type-valued declaration can carry modes, not just
-- membership.  Two witnesses at the same root select unequal separators.
------------------------------------------------------------------------

ModeObservation : Unit → Type₀
ModeObservation tt = Bool

modeProfile : DRP.RootedProfile Unit Bool ModeObservation
modeProfile tt state = state

ModeDeclared : Unit → Type₀
ModeDeclared tt = Bool

forwardSeparator : DRP.SeparatorAt modeProfile tt
forwardSeparator = false , true , false≢true

backwardSeparator : DRP.SeparatorAt modeProfile tt
backwardSeparator = true , false , true≢false

modeSeparatorFamily : DRP.SeparatorFamily ModeDeclared modeProfile
modeSeparatorFamily tt false = forwardSeparator
modeSeparatorFamily tt true  = backwardSeparator

modeDeclaration-not-propositional : ¬ DeclarationIsProp ModeDeclared
modeDeclaration-not-propositional declaredIsProp =
  false≢true (declaredIsProp tt false true)

mode-family-not-root-determined : ¬ RootDetermined modeSeparatorFamily
mode-family-not-root-determined rootDetermined =
  false≢true (cong fst (rootDetermined tt false true))
