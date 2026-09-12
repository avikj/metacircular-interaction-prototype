{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}
module CorpusFinalPresentation where

open import Cubical.Data.List using (List)
import CorpusRepository as R
import CorpusBehavioralMeaning as BM
import Fibre.CorpusLoci as L
import CorpusSelfPresentation as SP

-- The proved minimal/full-future quotient of every formed declaration type,
-- paired with its exact realization fibre.
behavioralPresentation : List BM.Presented
behavioralPresentation = BM.presentCorpus R.corpus

-- The immediately legible relational readout: each checked generator once,
-- with the exact family of checked applications it accepts.
relationalLoci : L.RawLoci
relationalLoci = R.loci

-- The loci are not a dead finite graph: this is their complete guarded
-- continuation object, carrying the exact residual fibre at every demand.
interactivePresentation : SP.SelfPresentation R.lociPoint
interactivePresentation = R.lociPresentation
