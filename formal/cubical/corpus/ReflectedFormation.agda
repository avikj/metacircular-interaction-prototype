{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- ReflectedFormation
--
-- THE ONE GENUINELY MISSING BRIDGE, and nothing beyond it:
--
--     arbitrary checked declarations
--       ──reflection only──▶  formed states consumable by the calculus.
--
-- The corpus already contains the semantics (FutureBehavior), the
-- descent law (FiniteInformation), the presentation invariance
-- (ObservationPresentation), the contraction rule (TranscriptDescent),
-- and the execution object (IntrinsicRewrite).  What it did not contain
-- is a way for that mathematics to be pointed at the corpus's OWN
-- elaborated declarations.  This module is that adapter and introduces
-- NO semantic equivalence of its own: reflection is an addressable
-- carrier of elaborated declarations, not meaning.  Every judgement
-- about a formed declaration is made downstream, by the existing
-- machinery, through checked inhabitants.
--
-- PRECEDENT.  The safe-reflection pattern (getDefinition traversal,
-- macros discharging into `unify`, all under `--safe --cubical`) is the
-- one already demonstrated by theorems/primes/pair_field/
-- PairCompositionSeed…, which recovers a private kernel's Names from
-- the clauses of its public wrapper.  Nothing here exceeds that
-- pattern's power; this module only reads PUBLIC declarations.
--
-- WHAT IS HERE
--   Decl                 name + elaborated type + elaborated definition
--   decl                 Name → TC Decl        (getType + getDefinition)
--   refsTerm             structural Name census of a Term
--   refsDefinition       the same census over a Definition's clauses
--   rawView / reducedView / normalView
--                        views of a formed type; normalization is an
--                        OBSERVATION, never destructive ingestion —
--                        the Decl it was computed from is untouched
--   declAll              the bridge mapped over a finite enumeration
--
-- WHAT IS DELIBERATELY NOT HERE: no equality, no equivalence, no
-- quotient, no ranking, no similarity.  A Name census is provenance
-- bookkeeping (which declarations does this one mention), not a
-- semantic relation; the semantic relations live in
-- CorpusPresentation, each backed by a checked inhabitant.
------------------------------------------------------------------------

module ReflectedFormation where

open import Cubical.Foundations.Prelude using (Type₀)
open import Agda.Builtin.List using (List ; [] ; _∷_)
open import Agda.Builtin.Reflection
  using ( Name ; Term ; Definition ; Clause ; TC ; Arg ; arg ; Abs ; abs
        ; var ; con ; def ; lam ; pat-lam ; pi ; agda-sort ; lit ; meta
        ; unknown ; clause ; absurd-clause ; function
        ; bindTC ; returnTC ; getType ; getDefinition ; reduce ; normalise )

------------------------------------------------------------------------
-- §0.  List append, in the builtin vocabulary reflection speaks.
------------------------------------------------------------------------

infixr 5 _++ᵇ_
_++ᵇ_ : {A : Type₀} → List A → List A → List A
[]       ++ᵇ ys = ys
(x ∷ xs) ++ᵇ ys = x ∷ (xs ++ᵇ ys)

------------------------------------------------------------------------
-- §1.  A formed declaration: the elaborated object, with its provenance
--      pointer.  Everything semantic about it is decided elsewhere.
------------------------------------------------------------------------

record Decl : Type₀ where
  constructor mkDecl
  field
    name       : Name
    type       : Term
    definition : Definition

open Decl public

decl : Name → TC Decl
decl n =
  bindTC (getType n)       λ ty →
  bindTC (getDefinition n) λ df →
  returnTC (mkDecl n ty df)

declAll : List Name → TC (List Decl)
declAll []       = returnTC []
declAll (n ∷ ns) =
  bindTC (decl n)     λ d  →
  bindTC (declAll ns) λ ds →
  returnTC (d ∷ ds)

------------------------------------------------------------------------
-- §2.  The structural Name census.  Purely syntactic recursion over the
--      elaborated term: which declarations does this term mention.
--      Patterns are matched only where the census needs to descend;
--      every constructor this module does not care about falls to a
--      wildcard, so the census is total whatever the term's shape.
------------------------------------------------------------------------

refsTerm    : Term → List Name
refsArgs    : List (Arg Term) → List Name
refsClauses : List Clause → List Name

refsTerm (var _ args)          = refsArgs args
refsTerm (con c args)          = c ∷ refsArgs args
refsTerm (def f args)          = f ∷ refsArgs args
refsTerm (lam _ (abs _ t))     = refsTerm t
refsTerm (pat-lam cs args)     = refsClauses cs ++ᵇ refsArgs args
refsTerm (pi (arg _ a) (abs _ b)) = refsTerm a ++ᵇ refsTerm b
refsTerm (meta _ args)         = refsArgs args
refsTerm _                     = []

refsArgs []             = []
refsArgs (arg _ t ∷ as) = refsTerm t ++ᵇ refsArgs as

refsClauses []                        = []
refsClauses (clause _ _ t ∷ cs)       = refsTerm t ++ᵇ refsClauses cs
refsClauses (absurd-clause _ _ ∷ cs)  = refsClauses cs

refsDefinition : Definition → List Name
refsDefinition (function cs) = refsClauses cs
refsDefinition _             = []

refsDecl : Decl → List Name
refsDecl d = refsTerm (type d) ++ᵇ refsDefinition (definition d)

------------------------------------------------------------------------
-- §3.  Views.  The raw view is the formed type as elaborated; the
--      reduced and normal views are TC observations of the same object.
--      Observation, not ingestion: the Decl is a value and none of
--      these functions rewrites it.
------------------------------------------------------------------------

rawView : Decl → Term
rawView d = type d

reducedView : Decl → TC Term
reducedView d = reduce (type d)

normalView : Decl → TC Term
normalView d = normalise (type d)
