{-# OPTIONS --cubical --safe --guardedness #-}

module Fibre.CorpusLoci where

open import Agda.Builtin.Reflection
open import Agda.Builtin.List
open import Agda.Builtin.Sigma
open import Agda.Builtin.Unit

open import Fibre.CorpusReflection using (expandAll)

infixr 5 _++_
_++_ : {A : Set} → List A → List A → List A
[] ++ ys = ys
(x ∷ xs) ++ ys = x ∷ (xs ++ ys)

-- One exact checked realization of a generator:
-- source declaration, accepted application term, normalized result type.
RawRealization : Set
RawRealization = Σ Name (λ _ → Σ Term (λ _ → Term))

-- A generator is stored once, with its exact Agda-accepted realization family.
RawLocus : Set
RawLocus = Σ Name (λ _ → List RawRealization)

RawLoci : Set
RawLoci = List RawLocus

vArg : Term → Arg Term
vArg t = arg (arg-info visible (modality relevant quantity-ω)) t

termOf : Name → TC Term
termOf n = bindTC (getDefinition n) λ where
  (data-cons _ _) → returnTC (con n [])
  _               → returnTC (def n [])

applyNamed : Name → Term → TC Term
applyNamed f x = bindTC (getDefinition f) λ where
  (data-cons _ _) → returnTC (con f (vArg x ∷ []))
  _               → returnTC (def f (vArg x ∷ []))

tryRealization : Name → Name → TC (List RawRealization)
tryRealization f n =
  bindTC (termOf n) λ x →
  bindTC (applyNamed f x) λ app →
  catchTC
    (withReconstructed true
      (noConstraints
        (bindTC (inferType app) λ ty →
         bindTC (normalise ty) λ nty →
         returnTC ((n , app , nty) ∷ []))))
    (returnTC [])

realizations : Name → List Name → TC (List RawRealization)
realizations f [] = returnTC []
realizations f (n ∷ ns) =
  bindTC (tryRealization f n) λ here →
  bindTC (realizations f ns) λ rest →
  returnTC (here ++ rest)

oneLocus : List Name → Name → TC RawLoci
oneLocus all f =
  bindTC (realizations f all) λ where
    []       → returnTC []
    (r ∷ rs) → returnTC ((f , r ∷ rs) ∷ [])

buildLoci : List Name → List Name → TC RawLoci
buildLoci all [] = returnTC []
buildLoci all (f ∷ fs) =
  bindTC (oneLocus all f) λ here →
  bindTC (buildLoci all fs) λ rest →
  returnTC (here ++ rest)

materializeLociTerm : List Name → TC Term
materializeLociTerm ns =
  bindTC (expandAll ns) λ expanded →
  bindTC (buildLoci expanded expanded) quoteTC

macro
  materializeLoci : List Name → Term → TC ⊤
  materializeLoci ns hole = bindTC (materializeLociTerm ns) (unify hole)
