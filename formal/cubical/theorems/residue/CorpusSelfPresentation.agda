{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}
module CorpusSelfPresentation where

open import Cubical.Foundations.Prelude

import Fibre.CorpusSamvada as C
import Fibre.Samvada_TheOrbitIsTheOneQueryCaseOfTheInteractiveCoalgebraAndTheDemandIsWhatDiffers as S
import CorpusLosslessPresentation as LP

private variable
  ℓ : Level

-- CorpusSamvada lives in Type (ℓ-suc ℓ); the exact residual fibre itself is
-- in Type ℓ, so lift it without changing its information.
Event : (s : C.Point ℓ) (q : C.Question s) (s' : C.Point ℓ)
      → C.Receipt s q s' → Type (ℓ-suc ℓ)
Event s q s' receipt = Lift {j = ℓ-suc ℓ} (LP.Residual s q)

SelfPresentation : C.Point ℓ → Type (ℓ-suc ℓ)
SelfPresentation = S.ISC C.Question C.Receipt Event

-- Entire guarded/coinductive presentation; no observation-depth parameter.
present : (s : C.Point ℓ) → SelfPresentation s
S.react (present s) q =
  C.target s q ,
  refl ,
  lift (LP.current-residual s q) ,
  present (C.target s q)

visible-step : (s : C.Point ℓ) (q : C.Question s)
             → fst (S.react (present s) q) ≡ C.target s q
visible-step s q = refl
