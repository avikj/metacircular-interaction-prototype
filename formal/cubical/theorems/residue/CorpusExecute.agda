{-# OPTIONS --cubical --safe --no-import-sorts #-}

module CorpusExecute where

open import Agda.Builtin.Reflection
open import Agda.Builtin.List
open import Agda.Builtin.Unit
open import Agda.Builtin.Bool
open import Agda.Builtin.Nat

vArg : Term → Arg Term
vArg t = arg (arg-info visible (modality relevant quantity-ω)) t

termOf : Name → TC Term
termOf n = bindTC (getDefinition n) λ where
  (data-cons _ _) → returnTC (con n [])
  _               → returnTC (def n [])

applyNamed : Name → Term → TC Term
applyNamed f x =
  bindTC (getDefinition f) λ where
    (data-cons _ _) → returnTC (con f (vArg x ∷ []))
    _               → returnTC (def f (vArg x ∷ []))

mutual
  explore : Nat → List Name → Term → TC ⊤
  explore zero    fs x = returnTC tt
  explore (suc d) fs x = eachFunction d fs fs x

  eachFunction : Nat → List Name → List Name → Term → TC ⊤
  eachFunction d all []       x = returnTC tt
  eachFunction d all (f ∷ fs) x =
    bindTC (tryApply d all f x) λ _ → eachFunction d all fs x

  tryApply : Nat → List Name → Name → Term → TC ⊤
  tryApply d all f x =
    bindTC (applyNamed f x) λ app →
    catchTC
      (withReconstructed true
        (noConstraints
          (bindTC (inferType app) λ ty →
           bindTC (normalise ty) λ nty →
           bindTC
             (debugPrint "corpus.edge" 1
               (strErr "EDGE " ∷ termErr x ∷ strErr "  --" ∷ nameErr f ∷
                strErr "→  " ∷ termErr app ∷ strErr "  :  " ∷ termErr nty ∷ []))
             λ _ → explore d all app)))
      (returnTC tt)

seedLoop : Nat → List Name → List Name → TC ⊤
seedLoop d all []       = returnTC tt
seedLoop d all (n ∷ ns) =
  bindTC (termOf n) λ t →
  bindTC (explore d all t) λ _ → seedLoop d all ns

-- A depth-d finite observation of the coinductive unfolding.  Every state is
-- a raw checked Agda term.  Every action is a raw checked named Agda term.
-- Agda itself accepts or rejects application; successful results are fed back
-- as the next state with no semantic classification in between.
runCorpus : Nat → List Name → TC ⊤
runCorpus d ns = seedLoop d ns ns
