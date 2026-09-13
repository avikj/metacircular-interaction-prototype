{-# OPTIONS --cubical --safe --guardedness #-}

module Fibre.CorpusReflection where

open import Agda.Builtin.Reflection
open import Agda.Builtin.List
open import Agda.Builtin.Sigma
open import Agda.Builtin.Unit

infixr 5 _++_
_++_ : {A : Set} → List A → List A → List A
[] ++ ys = ys
(x ∷ xs) ++ ys = x ∷ (xs ++ ys)

RawDeclaration : Set
RawDeclaration = Σ Name (λ _ → Σ Term (λ _ → Definition))

RawCorpus : Set
RawCorpus = List RawDeclaration

fieldNames : List (Arg Name) → List Name
fieldNames [] = []
fieldNames (arg _ n ∷ fs) = n ∷ fieldNames fs

expandOne : Name → TC (List Name)
expandOne n = bindTC (getDefinition n) λ where
  (data-type _ cs)   → returnTC (n ∷ cs)
  (record-type c fs) → returnTC (n ∷ c ∷ fieldNames fs)
  _                  → returnTC (n ∷ [])

expandAll : List Name → TC (List Name)
expandAll [] = returnTC []
expandAll (n ∷ ns) =
  bindTC (expandOne n) λ here →
  bindTC (expandAll ns) λ rest →
  returnTC (here ++ rest)

reflectOne : Name → TC RawDeclaration
reflectOne n =
  bindTC (getType n) λ ty →
  bindTC (getDefinition n) λ d →
  returnTC (n , ty , d)

reflectExpanded : List Name → TC RawCorpus
reflectExpanded [] = returnTC []
reflectExpanded (n ∷ ns) =
  bindTC (reflectOne n) λ d →
  bindTC (reflectExpanded ns) λ ds →
  returnTC (d ∷ ds)

reflectAll : List Name → TC RawCorpus
reflectAll ns = bindTC (expandAll ns) reflectExpanded

materializeTerm : List Name → TC Term
materializeTerm ns = bindTC (reflectAll ns) quoteTC

macro
  materialize : List Name → Term → TC ⊤
  materialize ns hole = bindTC (materializeTerm ns) (unify hole)
