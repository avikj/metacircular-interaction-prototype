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

-- One successful application is one literal CorpusCalculus interaction.
-- Generated targets are immediately fed back as next states, giving the
-- requested finite observation of the coinductive unfolding.
mutual
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
               (strErr "    REALIZATION  " ∷ termErr x ∷
                strErr "  ↦  " ∷ termErr app ∷
                strErr "  :  " ∷ termErr nty ∷
                strErr "\n      WITNESS  " ∷ termErr witness ∷
                strErr "  :  " ∷ termErr witnessTy ∷ []))
             λ _ → continue d all app)))
      (returnTC tt)

  continue : Nat → List Name → Term → TC ⊤
  continue zero    all x = returnTC tt
  continue (suc d) all x = continuationLoop d all all x

  continuationLoop : Nat → List Name → List Name → Term → TC ⊤
  continuationLoop d all []       x = returnTC tt
  continuationLoop d all (f ∷ fs) x =
    bindTC (tryContinuation d all f x) λ _ → continuationLoop d all fs x

  tryContinuation : Nat → List Name → Name → Term → TC ⊤
  tryContinuation d all f x =
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
               (strErr "      CONTINUE --" ∷ nameErr f ∷
                strErr "→  " ∷ termErr app ∷
                strErr "  :  " ∷ termErr nty ∷
                strErr "  WITNESS " ∷ termErr witness ∷ []))
             λ _ → continue d all app)))
      (returnTC tt)

-- Compact finite presentation: factor by the checked generator.  A generator
-- is printed once; all checked source realizations on which it acts are the
-- explicit dependent family beneath it.  Membership is exactly Agda accepting
-- the application -- never a lexical/import/embedding similarity judgement.
mutual
  emitLocus : Nat → List Name → Name → TC ⊤
  emitLocus d all f =
    bindTC (getType f) λ fty →
    bindTC (normalise fty) λ nfty →
    bindTC
      (debugPrint "corpus.edge" 1
        (strErr "\nLOCUS  " ∷ nameErr f ∷ strErr "  :  " ∷ termErr nfty ∷ []))
      λ _ → realizationLoop d all f all

  realizationLoop : Nat → List Name → Name → List Name → TC ⊤
  realizationLoop d all f []       = returnTC tt
  realizationLoop d all f (n ∷ ns) =
    bindTC (termOf n) λ x →
    bindTC (tryApply d all f x) λ _ →
    realizationLoop d all f ns

locusLoop : Nat → List Name → List Name → TC ⊤
locusLoop d all []       = returnTC tt
locusLoop d all (f ∷ fs) =
  bindTC (emitLocus d all f) λ _ → locusLoop d all fs

runCorpus : Nat → List Name → TC ⊤
runCorpus d ns =
  bindTC (expandAll ns) λ expanded →
  bindTC
    (debugPrint "corpus.edge" 1
      (strErr "════════ CORPUS FINITE SELF-PRESENTATION ════════\n" ∷
       strErr "LOCUS = one checked generator, printed once.\n" ∷
       strErr "REALIZATION = exact Agda-accepted action on a checked inhabitant.\n" ∷
       strErr "CONTINUE = recursively generated future interaction.\n" ∷
       strErr "Every emitted edge carries CorpusCalculus.step as its checked witness.\n" ∷ []))
    λ _ → locusLoop d expanded expanded
