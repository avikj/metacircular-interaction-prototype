{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}
module CorpusSelfPresentation where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Isomorphism using (Iso)
open import Cubical.Data.Sigma using (Σ-syntax ; _,_ ; fst ; snd)
open import Cubical.Relation.Nullary using (¬_)

open import Prashna_TheInteractiveMachineStrictlyContainsTheTuringMachineAndDeterminismIsExactlyTheCollapse
  using (ISC ; respond)

import CorpusCalculus as C
import CorpusLosslessPresentation as LP
import CorpusTraceCompression as TC

private
  variable
    ℓ ℓt : Level

Event : {ℓ : Level}
      → (s : C.Point ℓ)
      → C.Question s
      → C.Point ℓ
      → Type (ℓ-suc ℓ)
Event s q s' = (C.target s q ≡ s') × LP.Residual s q

SelfPresentation : {ℓ : Level} → C.Point ℓ → Type (ℓ-suc ℓ)
SelfPresentation {ℓ} = ISC (C.Point ℓ) C.Question Event

-- Infinite productive object.  No observation depth occurs here.
present : {ℓ : Level} (s : C.Point ℓ) → SelfPresentation s
respond (present s) q =
  C.target s q ,
  (refl , LP.current-residual s q) ,
  present (C.target s q)

next : {s : C.Point ℓ} → C.Question s → C.Point ℓ
next {s = s} q = fst (respond (present s) q)

residual : {s : C.Point ℓ} (q : C.Question s)
         → LP.Residual s q
residual {s = s} q = snd (fst (snd (respond (present s) q)))

continue : {s : C.Point ℓ} (q : C.Question s)
         → SelfPresentation (C.target s q)
continue {s = s} q = snd (snd (respond (present s) q))

Descends : (s : C.Point ℓ) (q : C.Question s)
         {T : Type ℓt} → (LP.Source s → T) → Type _
Descends = LP.Descends

NeedsRefinement : (s : C.Point ℓ) (q : C.Question s)
                {T : Type ℓt} → (LP.Source s → T) → Type _
NeedsRefinement s q t = ¬ Descends s q t

descends-iff-constant-on-residual :
    (s : C.Point ℓ) (q : C.Question s)
    {T : Type ℓt} (isSetT : isSet T) (t : LP.Source s → T)
  → Iso (Descends s q t) (LP.ConstantOnResidual s q t)
descends-iff-constant-on-residual = LP.descends-iff-constant-on-residual

Trace : C.Point ℓ → Type (ℓ-suc ℓ)
Trace = TC.Trace

endpoint : {s : C.Point ℓ} → Trace s → C.Point ℓ
endpoint = TC.endpoint

install : {s : C.Point ℓ} → Trace s → C.Question s
install = TC.compile

install-target : {s : C.Point ℓ} (trace : Trace s)
               → C.target s (install trace) ≡ endpoint trace
install-target = TC.compile-target

installed-lossless : {s : C.Point ℓ} (trace : Trace s)
                   → LP.Source s ≃ LP.Presentation s (install trace)
installed-lossless = TC.trace-lossless
