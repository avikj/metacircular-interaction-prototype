{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- CorpusNames — a finite enumeration of declaration Names, and NOTHING
-- ELSE.
--
-- ZERO SEMANTIC SIGNIFICANCE.  This is not a hierarchy, graph, taxonomy,
-- or root set.  Agda reflection has no primitive that enumerates the
-- whole global environment, and reflection can only form names that are
-- IN SCOPE; so some enumeration is unavoidable, and it is placed here,
-- quarantined, so that no semantic construction depends on file/module/
-- import organisation.  The names survive ONLY as provenance/navigation
-- pointers back to source — `quote` requires each be in scope, which is
-- why the sample imports a few real modules.
--
-- Generation is mechanical (any name reachable at scope may be listed);
-- the list below is a representative, honestly-small sample spanning the
-- machinery the presentation calculus reuses.  Extending it is a
-- clerical act with no bearing on meaning: CorpusPresentation forms
-- whatever names it is handed.
------------------------------------------------------------------------

module CorpusNames where

open import Agda.Builtin.Reflection using (Name)
open import Agda.Builtin.List using (List ; [] ; _∷_)

-- Real modules, imported only so their names are in scope to `quote`.
open import FutureBehavior
open import FiniteInformation
open import RewriteCertificate

-- A finite, semantics-free list of addressable declaration names.
corpusNames : List Name
corpusNames =
    quote FutureBehavior.Machine
  ∷ quote FutureBehavior.FutureEq
  ∷ quote FutureBehavior.behavior
  ∷ quote FutureBehavior.congruence→futureEq
  ∷ quote FiniteInformation.FactorsThrough
  ∷ quote FiniteInformation.FiberConstant
  ∷ quote FiniteInformation.fiberConstant→factorsThrough
  ∷ quote RewriteCertificate.Tm
  ∷ quote RewriteCertificate.Step
  ∷ quote RewriteCertificate.Derivation
  ∷ quote RewriteCertificate.eval
  ∷ []
