{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- CorpusNames
--
-- A generated finite enumeration of declaration Names, and nothing
-- else.  This list carries ZERO semantic significance: it is not a
-- hierarchy, not a graph, not a taxonomy, and not a root set.  Names
-- survive here only as provenance / navigation pointers back to source.
-- Agda's reflection does not enumerate the whole global environment, so
-- some enumeration is unavoidable; this one is mechanical, and no
-- semantics anywhere depends on the file/module/import organization the
-- names happen to come from.
------------------------------------------------------------------------

module CorpusNames where

open import Cubical.Data.List using (List ; [] ; _∷_)
open import Agda.Builtin.Reflection using (Name)

import FutureBehavior as FB
import FiniteInformation as FI
import ObservationPresentation as OP
import TranscriptDescent as TD
import CompositionalContextAdapter as CCA
import LawfulContinuationCore as LCC
import ProductiveObservationFiber as POF
import ProductiveFiberQuotientAdapter as PFQ
import IntrinsicRewrite as IR
import RewriteCertificate as RC

corpusNames : List Name
corpusNames =
    -- future behavior / minimal meaning
    quote FB.Machine
  ∷ quote FB.run
  ∷ quote FB.behavior
  ∷ quote FB.FutureEq
  ∷ quote FB.congruence→futureEq
    -- finite information / descent
  ∷ quote FI.FactorsThrough
  ∷ quote FI.FiberConstant
  ∷ quote FI.factorsThroughIsoFiberConstant
    -- presentation invariance
  ∷ quote OP.factorsThrough-postEquivIso
    -- exact contraction
  ∷ quote TD.transcriptDecoder
  ∷ quote TD.collisionObstructsDecoder
  ∷ quote TD.sideRecordDecoder
  ∷ quote TD.eraseDeterminedRecord
    -- contextual closure
  ∷ quote CCA.contextStep
  ∷ quote CCA.plug
  ∷ quote CCA.syntactic-futureIso
    -- dependent lawful continuation
  ∷ quote LCC.CountedPath
  ∷ quote LCC.CoherentSection
    -- productive observation
  ∷ quote POF.futureView
  ∷ quote POF.bisimClass≃futureViewFiber
  ∷ quote PFQ.futureViewPath→futureEq
    -- intrinsic formed execution
  ∷ quote IR.Run
  ∷ quote IR.result
  ∷ quote IR.run-sound
  ∷ quote IR.reweave
  ∷ quote IR.install
    -- self-extension
  ∷ quote RC.Derivation
  ∷ quote RC.eval
  ∷ quote RC.step-sound
  ∷ quote RC.derivation-sound
  ∷ quote RC.induction-sound
  ∷ []
