{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- OperationalCoverageCounterexample
--
-- A finite category plus declared singleton covers need not be a site.  In
-- the three-object poset e0 < e1 < e2, declare the two adjacent arrows to
-- cover but not their composite.  Identity covers hold; cover transitivity
-- fails.  The standard thin category structure of a finite chain is not the
-- point at issue, so only its singleton-cover predicate is encoded here.
------------------------------------------------------------------------

module OperationalCoverageCounterexample where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Bool
open import Cubical.Data.Empty as ⊥ using (⊥)
open import Cubical.Relation.Nullary using (¬_)

data Experiment : Type where
  e0 e1 e2 : Experiment

-- The true entries name the declared singleton covering arrows in the chain:
-- all identities and the two adjacent nonidentity arrows.  The composite
-- e0 → e2 exists in the chain category but is deliberately not declared a
-- cover.
coverCode : Experiment → Experiment → Bool
coverCode e0 e0 = true
coverCode e0 e1 = true
coverCode e0 e2 = false
coverCode e1 e0 = false
coverCode e1 e1 = true
coverCode e1 e2 = true
coverCode e2 e0 = false
coverCode e2 e1 = false
coverCode e2 e2 = true

DeclaredCover : Experiment → Experiment → Type
DeclaredCover source target = coverCode source target ≡ true

identityCovers : (e : Experiment) → DeclaredCover e e
identityCovers e0 = refl
identityCovers e1 = refl
identityCovers e2 = refl

CoverTransitive : Type
CoverTransitive = (a b c : Experiment)
  → DeclaredCover a b → DeclaredCover b c → DeclaredCover a c

falseNotTrue : ¬ (false ≡ true)
falseNotTrue p = subst (λ b → if b then ⊥ else Bool) p true

declared-covers-not-transitive : ¬ CoverTransitive
declared-covers-not-transitive transitive =
  falseNotTrue (transitive e0 e1 e2 refl refl)
