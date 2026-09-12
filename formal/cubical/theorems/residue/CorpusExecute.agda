{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

module CorpusExecute where

open import Agda.Primitive renaming (Set to UType)
open import Agda.Builtin.Reflection
open import Agda.Builtin.List
open import Agda.Builtin.Unit

import Fibre.CorpusSamvada as C
import CorpusSelfPresentation as SP
import CorpusLosslessPresentation as LP

infixr 5 _++_
_++_ : {A : UType} → List A → List A → List A
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

presentationOf : Term → Term
presentationOf x =
  def (quote SP.present)
    (vArg (def (quote C.point) (vArg x ∷ [])) ∷ [])

emitGenerator : TC ⊤
emitGenerator =
  bindTC (getType (quote SP.present)) λ pty →
  bindTC (getType (quote C.Question)) λ qty →
  bindTC (getType (quote LP.Residual)) λ rty →
  debugPrint "corpus.presentation" 1
    (strErr "════════ CORPUS COINDUCTIVE SELF-PRESENTATION ════════\n" ∷
     strErr "NUCLEUS  " ∷ nameErr (quote SP.present) ∷ strErr " : " ∷ termErr pty ∷
     strErr "\nQUESTION " ∷ nameErr (quote C.Question) ∷ strErr " : " ∷ termErr qty ∷
     strErr "\nRESIDUAL " ∷ nameErr (quote LP.Residual) ∷ strErr " : " ∷ termErr rty ∷
     strErr "\nOne guarded generator; every checked declaration below is a realization.\n" ∷
     strErr "A demanded question exposes its target + exact fibre + guarded continuation.\n" ∷ [])

-- Each declaration is checked as an actual realization of the ONE generator.
-- The coinductive term is typechecked but deliberately not reprinted, so the
-- common structure is factored once rather than duplicated per source term.
emitRealization : Name → TC ⊤
emitRealization n =
  bindTC (termOf n) λ x →
  let p = presentationOf x in
  catchTC
    (withReconstructed true
      (noConstraints
        (bindTC (inferType x) λ xty →
         bindTC (inferType p) λ _ →
         debugPrint "corpus.presentation" 1
           (strErr "REALIZATION  " ∷ nameErr n ∷ strErr " = " ∷ termErr x ∷
            strErr " : " ∷ termErr xty ∷ []))))
    (returnTC tt)

loop : List Name → TC ⊤
loop []       = returnTC tt
loop (n ∷ ns) = bindTC (emitRealization n) λ _ → loop ns

-- Finite enumeration is only the support of existing realizations.  The
-- semantic generator and every continuation are infinite guarded values.
runCorpus : List Name → TC ⊤
runCorpus ns =
  bindTC (expandAll ns) λ expanded →
  bindTC emitGenerator λ _ →
  loop expanded
