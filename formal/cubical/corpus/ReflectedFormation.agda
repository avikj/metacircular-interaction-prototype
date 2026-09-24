{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- ReflectedFormation — the reflection-to-formation bridge, and ONLY it.
--
-- This is the single genuinely missing piece named in the cold-start
-- handoff: the adapter that turns an ARBITRARY CHECKED DECLARATION into
-- a formed value the corpus's existing calculus can consume.  It
-- introduces no semantic equivalence, no minimiser, no MDL objective.
-- Reflection here is an addressable carrier of elaborated declarations,
-- NOT meaning: `Term`/`Definition` are first-class inert data once
-- elaborated, so a `Decl` is ordinary data and every downstream
-- construction (in CorpusPresentation) is a pure function of it.
--
-- WHAT IS AND IS NOT CLAIMED.
--   * `getType`/`getDefinition` typecheck under this repository's
--     --safe cubical library (verified empirically before writing).
--   * Reflection sees only NAMES IN SCOPE: a macro can form only the
--     declarations its module imports.  There is no primitive that
--     enumerates the whole global environment, which is exactly why the
--     handoff calls for a (semantics-free) name enumeration; see
--     CorpusNames.  This module makes no claim to reach "the whole
--     corpus" mechanically — it forms whatever names it is given.
--   * `normalView`/`reducedView` are OBSERVATIONS in the TC monad, never
--     destructive ingestion: the raw term is retained; normalisation is
--     something one may ask for, not something done to the stored datum.
--
-- No new semantic theory. Under --safe, exit 0 at the pin (Agda 2.8.0,
-- agda/cubical v0.9).  The reflection primitives run only at elaboration
-- time, through the demonstration macros in §4 and in CorpusPresentation.
------------------------------------------------------------------------

module ReflectedFormation where

open import Agda.Builtin.Reflection hiding (Type)  -- reflection's `Type = Term` alias would clash with Cubical's sort
open import Agda.Builtin.List
open import Agda.Builtin.Unit
open import Cubical.Foundations.Prelude using (Type)

------------------------------------------------------------------------
-- §0  small list plumbing on the reflection List (Agda.Builtin.List),
--     which is NOT Cubical.Data.List — reflected args use this one.
------------------------------------------------------------------------

private
  _++_ : {A : Type} → List A → List A → List A
  []       ++ ys = ys
  (x ∷ xs) ++ ys = x ∷ (xs ++ ys)

  mapArgName : List (Arg Name) → List Name
  mapArgName []              = []
  mapArgName (arg _ n ∷ fs)  = n ∷ mapArgName fs

------------------------------------------------------------------------
-- §1  The formed declaration.
--
-- A `Decl` is the addressable elaborated content of one name: its type
-- (a `Term`), its definition (clauses / data / record / constructor /
-- axiom / primitive), and the name itself as PROVENANCE ONLY.
------------------------------------------------------------------------

record Decl : Type where
  constructor mkDecl
  field
    declName : Name         -- provenance / navigation, no semantic role
    declType : Term         -- the elaborated type
    declDef  : Definition   -- the elaborated definition

open Decl public

-- The bridge.  getType + getDefinition, nothing else.
decl : Name → TC Decl
decl n =
  bindTC (getType n)       λ ty →
  bindTC (getDefinition n) λ df →
  returnTC (mkDecl n ty df)

------------------------------------------------------------------------
-- §2  Structural helpers — the reference graph, as pure data.
--
-- These are structural, not semantic: `refsTerm`/`refsDefinition` read
-- off which names a term/definition mentions.  Storage/provenance, the
-- raw import-style adjacency; it is deliberately NOT a taxonomy, and
-- nothing in the presentation calculus depends on it.
------------------------------------------------------------------------

mutual
  refsTerm : Term → List Name
  refsTerm (var _ args)      = refsArgs args
  refsTerm (con c args)      = c ∷ refsArgs args
  refsTerm (def f args)      = f ∷ refsArgs args
  refsTerm (lam _ (abs _ t)) = refsTerm t
  refsTerm (pat-lam cs args) = refsClauses cs ++ refsArgs args
  refsTerm (pi (arg _ a) (abs _ b)) = refsTerm a ++ refsTerm b
  refsTerm (agda-sort _)     = []
  refsTerm (lit _)           = []
  refsTerm (meta _ args)     = refsArgs args
  refsTerm unknown           = []

  refsArgs : List (Arg Term) → List Name
  refsArgs []              = []
  refsArgs (arg _ t ∷ as)  = refsTerm t ++ refsArgs as

  refsClauses : List Clause → List Name
  refsClauses []                          = []
  refsClauses (clause _ _ t ∷ cs)         = refsTerm t ++ refsClauses cs
  refsClauses (absurd-clause _ _ ∷ cs)    = refsClauses cs

refsDefinition : Definition → List Name
refsDefinition (function cs)      = refsClauses cs
refsDefinition (data-type _ cs)   = cs
refsDefinition (record-type c fs) = c ∷ mapArgName fs
refsDefinition (data-cons d _)    = d ∷ []
refsDefinition axiom              = []
refsDefinition prim-fun           = []

------------------------------------------------------------------------
-- §3  Views.  The raw view is the stored datum; the reduced/normal
--     views are OBSERVATIONS requested in TC, leaving the raw untouched.
------------------------------------------------------------------------

rawView : Decl → Term
rawView d = declType d

reducedView : Decl → TC Term
reducedView d = reduce (rawView d)

normalView : Decl → TC Term
normalView d = normalise (rawView d)

------------------------------------------------------------------------
-- §4  A demonstration that the bridge RUNS on real declarations.
--
-- `formsToDefKind` forms a name at elaboration time and reports which
-- definition kind it elaborated to (a small set-valued read: 0 function,
-- 1 data, 2 record, 3 constructor, 4 axiom, 5 primitive).  The `_ :`
-- tests below fix the outputs by refl, so a green here is proof the
-- getType/getDefinition path actually executed and produced data — on
-- the declarations of the very module doing the reflection.
------------------------------------------------------------------------

open import Agda.Builtin.Nat using (Nat)
open import Agda.Builtin.Equality using (_≡_ ; refl)

private
  defKind : Definition → Nat
  defKind (function _)      = 0
  defKind (data-type _ _)   = 1
  defKind (record-type _ _) = 2
  defKind (data-cons _ _)   = 3
  defKind axiom             = 4
  defKind prim-fun          = 5

-- A macro receives its arguments already reflected as `Term`s, so we
-- read the head name off the reference the caller writes.
private
  headName : Term → TC Name
  headName (def n _) = returnTC n
  headName (con n _) = returnTC n
  headName _         = typeError (strErr "expected a defined-name reference" ∷ [])

macro
  formsToDefKind : Term → Term → TC ⊤
  formsToDefKind ref hole =
    bindTC (headName ref)                   λ n →
    bindTC (decl n)                         λ d →
    bindTC (quoteTC (defKind (declDef d)))  λ r →
    unify hole r

-- Decl is a record; decl itself is a function.  Both formed by reflection
-- at elaboration time; the refl proofs pin the outputs, so a green is
-- evidence the getType/getDefinition path executed on real declarations.
decl-is-a-record : formsToDefKind Decl ≡ 2
decl-is-a-record = refl

decl-fn-is-a-function : formsToDefKind decl ≡ 0
decl-fn-is-a-function = refl
