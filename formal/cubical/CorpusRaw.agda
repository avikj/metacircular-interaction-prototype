{-# OPTIONS --cubical --safe --no-import-sorts #-}

module CorpusRaw where

open import Cubical.Foundations.Prelude
open import Cubical.Data.List using (List ; [] ; _∷_)
open import Cubical.Data.Sigma using (Σ-syntax ; _,_)
open import Agda.Builtin.Reflection
  using (Name ; Term ; Definition ; TC ; getType ; getDefinition ; bindTC ; returnTC)

-- No corpus ontology is introduced here.  A point is exactly Agda's own
-- reflected name, elaborated type, and elaborated definition.
record RawDeclaration : Type where
  constructor raw
  field
    name       : Name
    type       : Term
    definition : Definition

reflect : Name → TC RawDeclaration
reflect n =
  bindTC (getType n) λ A →
  bindTC (getDefinition n) λ d →
  returnTC (raw n A d)

reflectAll : List Name → TC (List RawDeclaration)
reflectAll []       = returnTC []
reflectAll (n ∷ ns) =
  bindTC (reflect n) λ d →
  bindTC (reflectAll ns) λ ds →
  returnTC (d ∷ ds)

-- Any structure used downstream must be computed from the reflected Term and
-- Definition values themselves.  In particular this module contains no
-- categories for claims, absences, topics, theorem roles, or hand-authored
-- relationships.