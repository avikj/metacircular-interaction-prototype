{-# OPTIONS --cubical --safe --no-import-sorts #-}

module CorpusExecute where

open import Agda.Builtin.Reflection
open import Agda.Builtin.List
open import Agda.Builtin.Unit
open import Agda.Builtin.Bool

vArg : Term → Arg Term
vArg t = arg (arg-info visible (modality relevant quantity-ω)) t

termOf : Name → TC Term
termOf n = bindTC (getDefinition n) λ where
  (data-cons _ _) → returnTC (con n [])
  _               → returnTC (def n [])

tryApply : Name → Name → TC ⊤
tryApply f a =
  bindTC (termOf f) λ ft →
  bindTC (termOf a) λ at →
  let app = def f (vArg at ∷ []) in
  catchTC
    (withReconstructed true
      (noConstraints
        (bindTC (inferType app) λ ty →
         bindTC (normalise ty) λ nty →
         debugPrint "corpus.edge" 1
           (strErr "EDGE " ∷ nameErr f ∷ strErr "  " ∷ nameErr a ∷
            strErr "  =>  " ∷ termErr app ∷ strErr "  :  " ∷ termErr nty ∷ [])))))
    (returnTC tt)

against : Name → List Name → TC ⊤
against f []       = returnTC tt
against f (a ∷ as) = bindTC (tryApply f a) λ _ → against f as

allPairs : List Name → List Name → TC ⊤
allPairs []       _  = returnTC tt
allPairs (f ∷ fs) ns = bindTC (against f ns) λ _ → allPairs fs ns

runCorpus : List Name → TC ⊤
runCorpus ns = allPairs ns ns
