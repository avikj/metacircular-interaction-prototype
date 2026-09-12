{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}
module CorpusSelfPresentation where

open import Cubical.Foundations.Prelude

import Fibre.CorpusSamvada as C
import Fibre.Samvada_TheOrbitIsTheOneQueryCaseOfTheInteractiveCoalgebraAndTheDemandIsWhatDiffers as S
import CorpusLosslessPresentation as LP

private variable
  ℓ : Level

-- Keep CorpusSamvada's visible receipt.  The proof-relevant event at that
-- transition is exactly the fibre erased by the visible question.
Event : (s : C.Point ℓ) (q : C.Question s) (s' : C.Point ℓ)
      → C.Receipt s q s' → Type (ℓ-suc ℓ)
Event s q s' receipt = LP.Residual s q

SelfPresentation : C.Point ℓ → Type (ℓ-suc ℓ)
SelfPresentation = S.ISC C.Question C.Receipt Event

-- The entire object is guarded/coinductive.  There is no depth parameter.
-- Each demanded question yields its visible target, receipt, exact residual,
-- and the continuation of the same presentation at the target.
present : (s : C.Point ℓ) → SelfPresentation s
S.react (present s) q =
  C.target s q ,
  refl ,
  LP.current-residual s q ,
  present (C.target s q)

-- Forgetting the residual event recovers the same visible one-step target as
-- the corpus's native guarded coalgebra.
visible-step : (s : C.Point ℓ) (q : C.Question s)
             → fst (S.react (present s) q) ≡ C.target s q
visible-step s q = refl
