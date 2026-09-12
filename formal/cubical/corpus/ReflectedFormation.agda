{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- ReflectedFormation
--
-- The one genuinely missing bridge:
--
--     arbitrary checked declarations
--       → formed states consumable by the existing calculus.
--
-- Reflection is used ONLY here, and only as an addressable carrier of
-- elaborated declarations — never as meaning.  A `Decl` is a formed
-- reflected declaration: its checked type and its checked definition,
-- addressed by its Name.  The structural helpers expose reference lists
-- and head/child navigation on reflected syntax; normalization is an
-- observation (`reducedView` / `normalView` live in TC), never a
-- destructive ingestion.  NO semantic equivalence is introduced in this
-- module.  Every semantic identification happens downstream, backed by
-- a checked inhabitant, in CorpusPresentation.
------------------------------------------------------------------------

module ReflectedFormation where

open import Cubical.Foundations.Prelude using (Type)
open import Cubical.Data.List using (List ; [] ; _∷_ ; _++_)
open import Cubical.Data.Nat using (ℕ ; zero ; suc)
open import Cubical.Data.Sigma using (_,_)

open import Agda.Builtin.Reflection renaming (Type to Quoted)

------------------------------------------------------------------------
-- 1.  Formed reflected declarations
------------------------------------------------------------------------

record Decl : Type₀ where
  constructor formed
  field
    declName       : Name
    declType       : Term
    declDefinition : Definition

-- The bridge: a checked declaration becomes a formed state, by
-- reflection alone.
decl : Name → TC Decl
decl nm =
  bindTC (getType nm) λ ty →
  bindTC (getDefinition nm) λ df →
  returnTC (formed nm ty df)

declAll : List Name → TC (List Decl)
declAll []         = returnTC []
declAll (nm ∷ nms) =
  bindTC (decl nm) λ d →
  bindTC (declAll nms) λ ds →
  returnTC (d ∷ ds)

------------------------------------------------------------------------
-- 2.  Views: raw, reduced, normal.  Normalization is an observation.
------------------------------------------------------------------------

rawView : Decl → Term
rawView = Decl.declType

reducedView : Decl → TC Term
reducedView d = reduce (Decl.declType d)

normalView : Decl → TC Term
normalView d = normalise (Decl.declType d)

------------------------------------------------------------------------
-- 3.  Structural reference lists (provenance edges, not semantics)
------------------------------------------------------------------------

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

refsDefinition : Definition → List Name
refsDefinition (function cs)      = refsClauses cs
refsDefinition (data-type _ cs)   = cs
refsDefinition (record-type c fs) = c ∷ fieldNames fs
  where
    fieldNames : List (Arg Name) → List Name
    fieldNames []             = []
    fieldNames (arg _ f ∷ fs) = f ∷ fieldNames fs
refsDefinition _                  = []

refs : Decl → List Name
refs d = refsTerm (Decl.declType d) ++ refsDefinition (Decl.declDefinition d)

------------------------------------------------------------------------
-- 4.  Head observation and child navigation on reflected syntax.
--
-- These are pure structural maps: an observation into ℕ (the head
-- constructor code) and a deterministic navigation action (the n-th
-- immediate subterm, staying put when there is none).  Downstream they
-- are the `observe` and `step` of an ordinary FutureBehavior machine;
-- nothing about them depends on file/module organization.
------------------------------------------------------------------------

headCode : Term → ℕ
headCode (var _ _)     = 0
headCode (con _ _)     = 1
headCode (def _ _)     = 2
headCode (lam _ _)     = 3
headCode (pat-lam _ _) = 4
headCode (pi _ _)      = 5
headCode (agda-sort _) = 6
headCode (lit _)       = 7
headCode (meta _ _)    = 8
headCode unknown       = 9

argChildren : List (Arg Term) → List Term
argChildren []             = []
argChildren (arg _ t ∷ as) = t ∷ argChildren as

children : Term → List Term
children (var _ as)               = argChildren as
children (con _ as)               = argChildren as
children (def _ as)               = argChildren as
children (lam _ (abs _ t))        = t ∷ []
children (pat-lam _ as)           = argChildren as
children (pi (arg _ a) (abs _ b)) = a ∷ b ∷ []
children (agda-sort (set t))      = t ∷ []
children (agda-sort (prop t))     = t ∷ []
children (agda-sort _)            = []
children (lit _)                  = []
children (meta _ as)              = argChildren as
children unknown                  = []

nth : List Term → ℕ → Term → Term
nth []       _       fallback = fallback
nth (t ∷ _)  zero    _        = t
nth (_ ∷ ts) (suc n) fallback = nth ts n fallback

child : Term → ℕ → Term
child t n = nth (children t) n t
