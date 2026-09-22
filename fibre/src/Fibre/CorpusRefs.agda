{-# OPTIONS --cubical --safe --guardedness #-}

-- The TOTAL reference relation between all expressions of the corpus:
-- for every declaration, every name its checked type and definition
-- mention.  Pure syntax traversal over the already-materialized
-- RawCorpus value — no typechecker probing, hence exact, complete, and
-- linear in the corpus.

module Fibre.CorpusRefs where

open import Agda.Builtin.Reflection
open import Agda.Builtin.List
open import Agda.Builtin.Sigma

open import Fibre.CorpusReflection using (RawCorpus ; RawDeclaration ; _++_)

RefEntry : Set
RefEntry = Σ Name (λ _ → List Name)

RefGraph : Set
RefGraph = List RefEntry

mutual
  refsTerm : Term → List Name
  refsTerm (var _ as)               = refsArgs as
  refsTerm (con c as)               = c ∷ refsArgs as
  refsTerm (def f as)               = f ∷ refsArgs as
  refsTerm (lam _ (abs _ t))        = refsTerm t
  refsTerm (pat-lam cs as)          = refsClauses cs ++ refsArgs as
  refsTerm (pi (arg _ a) (abs _ b)) = refsTerm a ++ refsTerm b
  refsTerm (agda-sort s)            = refsSort s
  refsTerm (lit l)                  = refsLit l
  refsTerm (meta _ as)              = refsArgs as
  refsTerm unknown                  = []

  refsArgs : List (Arg Term) → List Name
  refsArgs []             = []
  refsArgs (arg _ t ∷ as) = refsTerm t ++ refsArgs as

  refsSort : Sort → List Name
  refsSort (set t)  = refsTerm t
  refsSort (prop t) = refsTerm t
  refsSort _        = []

  refsLit : Literal → List Name
  refsLit (name x) = x ∷ []
  refsLit _        = []

  refsPattern : Pattern → List Name
  refsPattern (con c ps) = c ∷ refsPatterns ps
  refsPattern (dot t)    = refsTerm t
  refsPattern (proj f)   = f ∷ []
  refsPattern _          = []

  refsPatterns : List (Arg Pattern) → List Name
  refsPatterns []             = []
  refsPatterns (arg _ p ∷ ps) = refsPattern p ++ refsPatterns ps

  refsTel : Telescope → List Name
  refsTel []                    = []
  refsTel ((_ , arg _ t) ∷ tel) = refsTerm t ++ refsTel tel

  refsClause : Clause → List Name
  refsClause (clause tel ps t)      = refsTel tel ++ refsPatterns ps ++ refsTerm t
  refsClause (absurd-clause tel ps) = refsTel tel ++ refsPatterns ps

  refsClauses : List Clause → List Name
  refsClauses []       = []
  refsClauses (c ∷ cs) = refsClause c ++ refsClauses cs

fieldRefs : List (Arg Name) → List Name
fieldRefs []             = []
fieldRefs (arg _ f ∷ fs) = f ∷ fieldRefs fs

refsDefinition : Definition → List Name
refsDefinition (function cs)      = refsClauses cs
refsDefinition (data-type _ cs)   = cs
refsDefinition (record-type c fs) = c ∷ fieldRefs fs
refsDefinition _                  = []

refsDecl : RawDeclaration → RefEntry
refsDecl (n , ty , df) = n , refsTerm ty ++ refsDefinition df

refGraph : RawCorpus → RefGraph
refGraph []       = []
refGraph (d ∷ ds) = refsDecl d ∷ refGraph ds
