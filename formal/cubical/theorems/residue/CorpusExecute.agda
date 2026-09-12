{-# OPTIONS --cubical --safe --no-import-sorts #-}

module CorpusExecute where

open import Agda.Builtin.Reflection
open import Agda.Builtin.List
open import Agda.Builtin.Unit
open import Agda.Builtin.Bool
open import Agda.Builtin.Nat
open import CorpusCalculus using (step)

infixr 5 _++_
_++_ : {A : Set} → List A → List A → List A
[]       ++ ys = ys
(x ∷ xs) ++ ys = x ∷ (xs ++ ys)

vArg : Term → Arg Term
vArg t = arg (arg-info visible (modality relevant quantity-ω)) t

fieldNames : List (Arg Name) → List Name
fieldNames [] = []
fieldNames (arg _ n ∷ fs) = n ∷ fieldNames fs

expandOne : Name → TC (List Name)
expandOne n = bindTC (getDefinition n) λ where
  (data-type _ cs)   → returnTC (n ∷ cs)
  (record-type c fs) → returnTC (n ∷ c ∷ fieldNames fs)
  _                  → returnTC (n ∷ [])

expandAll : List Name → TC (List Name)
expandAll []       = returnTC []
expandAll (n ∷ ns) =
  bindTC (expandOne n) λ here →
  bindTC (expandAll ns) λ rest →
  returnTC (here ++ rest)

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
    bindTC (termOf f) λ ft →
    bindTC (applyNamed f x) λ app →
    let witness = def (quote step) (vArg x ∷ vArg ft ∷ []) in
    catchTC
      (withReconstructed true
        (noConstraints
          (bindTC (inferType app) λ ty →
           bindTC (inferType witness) λ witnessTy →
           bindTC (normalise ty) λ nty →
           bindTC
             (debugPrint "corpus.edge" 1
               (strErr "EDGE " ∷ termErr x ∷ strErr "  --" ∷ nameErr f ∷
                strErr "→  " ∷ termErr app ∷ strErr "  :  " ∷ termErr nty ∷
                strErr "  WITNESS " ∷ termErr witness ∷ strErr "  :  " ∷ termErr witnessTy ∷ []))
             λ _ → explore d all app)))
      (returnTC tt)

seedLoop : Nat → List Name → List Name → TC ⊤
seedLoop d all []       = returnTC tt
seedLoop d all (n ∷ ns) =
  bindTC (termOf n) λ t →
  bindTC (explore d all t) λ _ → seedLoop d all ns

runCorpus : Nat → List Name → TC ⊤
runCorpus d ns =
  bindTC (expandAll ns) λ expanded → seedLoop d expanded expanded
