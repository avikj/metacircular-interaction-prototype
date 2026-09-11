{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- CorpusTraceCompression
--
-- A finite interaction in CorpusCalculus is a dependent chain: after asking
-- q at s, the next question is formed at target s q.  This module compiles
-- the entire chain to ONE question at the original point by ordinary
-- function composition.  The compiled endpoint is propositionally the same
-- endpoint as the expanded chain, and CorpusLosslessPresentation immediately
-- supplies the exact source fibre of that compiled observation.
--
-- Thus expansion and compression are two presentations of one computation:
-- the finite trace is retained proof-relevantly, while its visible effect is
-- represented once as a composite map.
------------------------------------------------------------------------

module CorpusTraceCompression where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Sigma using (_,_ ; fst ; snd)

import CorpusCalculus as C
import CorpusLosslessPresentation as LP

private variable
  ℓ : Level

------------------------------------------------------------------------
-- Dependent finite interaction.
------------------------------------------------------------------------

data Trace {ℓ : Level} : (s : C.Point ℓ) → Type (ℓ-suc ℓ) where
  stop : {s : C.Point ℓ} → Trace s
  ask  : {s : C.Point ℓ}
       → (q : C.Question s)
       → Trace (C.target s q)
       → Trace s

endpoint : {s : C.Point ℓ} → Trace s → C.Point ℓ
endpoint {s = s} stop = s
endpoint (ask q rest) = endpoint rest

------------------------------------------------------------------------
-- Compile the whole interaction to one question.
------------------------------------------------------------------------

compile : {s : C.Point ℓ} → Trace s → C.Question s
compile {s = s} stop = fst s , (λ a → a)
compile {s = s} (ask q rest) with compile rest
... | B , f = B , λ a → f (snd q a)

-- The compressed question computes exactly the expanded trace endpoint.
compile-target : {s : C.Point ℓ} (trace : Trace s)
               → C.target s (compile trace) ≡ endpoint trace
compile-target stop = refl
compile-target (ask q rest) with compile rest
... | B , f = compile-target rest

------------------------------------------------------------------------
-- Lossless compression: the visible composite plus its exact source fibre.
------------------------------------------------------------------------

CompressedPresentation : {s : C.Point ℓ} → Trace s → Type ℓ
CompressedPresentation {s = s} trace = LP.Presentation s (compile trace)

compress : {s : C.Point ℓ} (trace : Trace s)
         → LP.Source s → CompressedPresentation trace
compress {s = s} trace = LP.encode s (compile trace)

current-compressed : {s : C.Point ℓ} (trace : Trace s)
                   → CompressedPresentation trace
current-compressed {s = s} trace = compress trace (LP.source s)

current-visible-is-endpoint : {s : C.Point ℓ} (trace : Trace s)
                            → fst (current-compressed trace)
                              ≡ fst (endpoint trace)
current-visible-is-endpoint {s = s} trace =
  cong fst (compile-target trace)

-- The entire original source type remains exactly recoverable from the
-- compiled visible observation and its fibre; no finite chain loses data.
trace-lossless : {s : C.Point ℓ} (trace : Trace s)
               → LP.Source s ≃ CompressedPresentation trace
trace-lossless {s = s} trace = LP.lossless s (compile trace)
