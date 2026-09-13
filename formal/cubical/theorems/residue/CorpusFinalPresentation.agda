{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}
module CorpusFinalPresentation where

open import Cubical.Data.List using (List)
import CorpusRepository as R
import CorpusBehavioralMeaning as BM
import Fibre.CorpusRefs as CR
import CorpusSelfPresentation as SP

-- The proved minimal/full-future quotient of every formed declaration type,
-- paired with its exact realization fibre.
behavioralPresentation : List BM.Presented
behavioralPresentation = BM.presentCorpus R.corpus

-- The TOTAL reference relation between all expressions of the corpus:
-- exact, complete, computed by pure syntax over the one corpus value.
referenceRelation : CR.RefGraph
referenceRelation = R.refGraph

-- THE COINDUCTIVE CALCULUS IS THE PRESENTATION.  The corpus is one state
-- of the guarded interactive coalgebra; every question — every map out of
-- it — is answered on demand with its target, the EXACT residual fibre,
-- and a continuation.  Nothing is globally normalised and no relation is
-- enumerated eagerly: the finite description unfolds, under demand, to
-- the complete relation web.
interactivePresentation : SP.SelfPresentation R.corpusPoint
interactivePresentation = R.corpusPresentation
