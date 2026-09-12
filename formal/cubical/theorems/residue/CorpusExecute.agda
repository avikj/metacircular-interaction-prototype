{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

module CorpusExecute where

open import Agda.Builtin.Reflection
open import Agda.Builtin.List
open import Agda.Builtin.Unit
open import CorpusCalculus using (point)
open import CorpusSelfPresentation using (present)

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

-- The reflection layer only exposes checked inhabitants.  Semantics begins at
-- `point x`; `present` is the already-checked infinite productive object over
-- every dependent Question admitted from that point.
coinductivePresentation : Term → Term
coinductivePresentation x =
  def (quote present)
    (vArg (def (quote point) (vArg x ∷ [])) ∷ [])

emitRoot : Name → Term → TC ⊤
emitRoot n x =
  let p = coinductivePresentation x in
  catchTC
    (withReconstructed true
      (noConstraints
        (bindTC (inferType x) λ xty →
         bindTC (inferType p) λ pty →
         debugPrint "corpus.presentation" 1
           (strErr "LOCUS " ∷ nameErr n ∷ strErr " = " ∷ termErr x ∷
            strErr " : " ∷ termErr xty ∷
            strErr "\n  INFINITE_PRESENTATION " ∷ termErr p ∷
            strErr " : " ∷ termErr pty ∷ []))))
    (returnTC tt)

seedLoop : List Name → TC ⊤
seedLoop []       = returnTC tt
seedLoop (n ∷ ns) =
  bindTC (termOf n) λ t →
  bindTC (emitRoot n t) λ _ → seedLoop ns

-- Whole checked corpus: finite enumeration supplies only the seed support.
-- No finite observation depth is taken.  Every seed is mapped directly to its
-- infinite coinductive SelfPresentation, whose response carries visible target,
-- exact residual fibre, and productive continuation.
runCorpus : List Name → TC ⊤
runCorpus ns = bindTC (expandAll ns) seedLoop
