{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}
module CorpusTraceCompression where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Sigma using (_,_ ; fst ; snd)

import Fibre.CorpusSamvada as C
import CorpusLosslessPresentation as LP

private variable
  ℓ : Level

data Trace {ℓ : Level} : (s : C.Point ℓ) → Type (ℓ-suc ℓ) where
  stop : {s : C.Point ℓ} → Trace s
  ask  : {s : C.Point ℓ}
       → (q : C.Question s)
       → Trace (C.target s q)
       → Trace s

endpoint : {s : C.Point ℓ} → Trace s → C.Point ℓ
endpoint {s = s} stop = s
endpoint (ask q rest) = endpoint rest

compile : {s : C.Point ℓ} → Trace s → C.Question s
compile {s = s} stop = fst s , (λ a → a)
compile {s = s} (ask q rest) with compile rest
... | B , f = B , λ a → f (snd q a)

compile-target : {s : C.Point ℓ} (trace : Trace s)
               → C.target s (compile trace) ≡ endpoint trace
compile-target stop = refl
compile-target (ask q rest) with compile rest
... | B , f = compile-target rest

CompressedPresentation : {s : C.Point ℓ} → Trace s → Type ℓ
CompressedPresentation {s = s} trace = LP.Presentation s (compile trace)

trace-lossless : {s : C.Point ℓ} (trace : Trace s)
               → LP.Source s ≃ CompressedPresentation trace
trace-lossless {s = s} trace = LP.lossless s (compile trace)
