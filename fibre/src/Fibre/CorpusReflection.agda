{-# OPTIONS --cubical --safe --guardedness #-}

module Fibre.CorpusReflection where

open import Agda.Builtin.Reflection
open import Agda.Builtin.List
open import Agda.Builtin.Sigma
open import Agda.Builtin.Unit

RawDeclaration : Set
RawDeclaration = Σ Name (λ _ → Σ Term (λ _ → Definition))

RawCorpus : Set
RawCorpus = List RawDeclaration

reflectOne : Name → TC RawDeclaration
reflectOne n =
  bindTC (getType n) λ ty →
  bindTC (getDefinition n) λ d →
  returnTC (n , ty , d)

reflectAll : List Name → TC RawCorpus
reflectAll [] = returnTC []
reflectAll (n ∷ ns) =
  bindTC (reflectOne n) λ d →
  bindTC (reflectAll ns) λ ds →
  returnTC (d ∷ ds)

materializeTerm : List Name → TC Term
materializeTerm ns = bindTC (reflectAll ns) quoteTC

macro
  materialize : List Name → Term → TC ⊤
  materialize ns hole = bindTC (materializeTerm ns) (unify hole)
