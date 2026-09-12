{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

module CorpusExecute where

open import Agda.Builtin.Reflection
open import Agda.Builtin.List
open import Agda.Builtin.Unit

open import Fibre.CorpusSamvada using (point)
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

-- Reflection is only the bootstrap that exposes checked declarations.
-- The semantic object is `present (point x)`, the infinite guarded coalgebra
-- enriched with the exact residual fibre at every demanded question.
coinductivePresentation : Term → Term
coinductivePresentation x =
  def (quote present)
    (vArg (def (quote point) (vArg x ∷ [])) ∷ [])

emit : Name → TC ⊤
emit n =
  bindTC (termOf n) λ x →
  let p = coinductivePresentation x in
  catchTC
    (withReconstructed true
      (noConstraints
        (bindTC (inferType x) λ xty →
         bindTC (inferType p) λ pty →
         debugPrint "corpus.presentation" 1
           (strErr "LOCUS " ∷ nameErr n ∷ strErr " = " ∷ termErr x ∷
            strErr " : " ∷ termErr xty ∷
            strErr "\n  COINDUCTIVE " ∷ termErr p ∷
            strErr " : " ∷ termErr pty ∷ []))))
    (returnTC tt)

loop : List Name → TC ⊤
loop []       = returnTC tt
loop (n ∷ ns) = bindTC (emit n) λ _ → loop ns

-- No depth argument: finite enumeration only supplies the checked seed support.
-- Each seed is mapped directly to its complete guarded interaction object.
runCorpus : List Name → TC ⊤
runCorpus ns = bindTC (expandAll ns) loop
