{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- CorpusNames
--
-- A finite enumeration of declaration Names, and NOTHING else.
--
-- ZERO SEMANTIC SIGNIFICANCE, on purpose and by specification: this list
-- is not a hierarchy, not a graph, not a taxonomy, not a root set, and
-- no theorem anywhere may depend on which file or module a name came
-- from.  Repository files, modules and import edges are storage and
-- provenance; once declarations are elaborated, file organization
-- disappears except as a pointer back to source.  This module is that
-- pointer and only that.
--
-- Agda's reflection does not enumerate the global environment, so some
-- enumeration is unavoidable.  This one is written by hand and is
-- deliberately small: it seeds the bridge (ReflectedFormation) and the
-- presentation (CorpusPresentation) with declarations spanning the
-- machinery those modules themselves consume — the kernel's calculus,
-- the future-behavior quotient, the finite-information descent law, the
-- intrinsic rewrite loci, lawful continuation, and transcript descent.
-- Growing the list is mechanical and changes no semantics: every
-- downstream construction is uniform in the list.
------------------------------------------------------------------------

module CorpusNames where

open import Agda.Builtin.List using (List ; [] ; _∷_)
open import Agda.Builtin.Reflection using (Name)

import RewriteCertificate as RC
import ControlledGrammar as CG
import FutureBehavior as FB
import FiniteInformation as FI
import IntrinsicRewrite as IR
import LawfulContinuationCore as LCC
import TranscriptDescent as TD

corpus : List Name
corpus =
    quote RC.Tm
  ∷ quote RC.Step
  ∷ quote RC.Derivation
  ∷ quote RC.subVar
  ∷ quote RC.eval
  ∷ quote RC.derivation-sound
  ∷ quote CG.NativeOperation
  ∷ quote CG.install
  ∷ quote FB.run
  ∷ quote FB.behavior
  ∷ quote FB.FutureEq
  ∷ quote FB.Machine
  ∷ quote FI.FactorsThrough
  ∷ quote FI.FiberConstant
  ∷ quote IR.Locus
  ∷ quote IR.plug
  ∷ quote LCC.World
  ∷ quote LCC.CountedPath
  ∷ quote TD.transcriptDecoder
  ∷ quote TD.collisionObstructsDecoder
  ∷ []
