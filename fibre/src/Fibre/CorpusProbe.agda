{-# OPTIONS --cubical --safe --guardedness --no-import-sorts #-}

------------------------------------------------------------------------
-- CorpusProbe — a memory-safe, streaming readout of the corpus's OWN
-- factored semantics (Fibre.CorpusLoci), one chunk at a time.
--
-- The whole-corpus `materialize`/`materializeLoci` macros build one giant
-- reflected `RawCorpus`/`RawLoci` term via `quoteTC` and hold every
-- transitive interface in a single heap — ~12 GB, and dead on any red
-- module.  This probe keeps the SAME checked semantics (each generator's
-- exact Agda-accepted realization family: source declaration, accepted
-- application, normalized result type — from CorpusLoci) but never
-- aggregates: it FOLDS `debugPrint` over the realizations, emitting one
-- machine-parseable line per realization and quoting nothing.  Imported by
-- a chunk module that brings only its own slice into scope, so each Agda
-- process stays small and a red module fails only its own chunk.
--
--     LOCUS <Π-arity> <result-head> <generator> <realized-on>
--
-- surfaced on verbosity "loci" (agda -vloci:1).  Grouping into meaning-loci
-- happens outside Agda, exactly as in the chunked pipeline.
------------------------------------------------------------------------

module Fibre.CorpusProbe where

open import Agda.Builtin.Unit using (⊤ ; tt)
open import Agda.Builtin.Nat using (Nat ; zero ; suc)
open import Agda.Builtin.String using (String ; primStringAppend ; primShowNat)
open import Agda.Builtin.List using (List ; [] ; _∷_)
open import Agda.Builtin.Sigma using (Σ ; _,_ ; fst ; snd)
open import Agda.Builtin.Reflection
  using ( Name ; Term ; Abs ; TC
        ; pi ; def ; con ; lam ; pat-lam ; agda-sort ; lit ; meta ; var ; unknown
        ; abs ; returnTC ; bindTC ; quoteTC ; unquoteTC ; unify
        ; debugPrint ; ErrorPart ; strErr ; primShowQName )

open import Fibre.CorpusReflection using (expandAll)
open import Fibre.CorpusLoci using (RawRealization ; realizations)

infixr 5 _<>_
_<>_ : String → String → String
_<>_ = primStringAppend

-- (dependent Π-arity, conclusion head) of the normalized result type.
headView : Nat → Term → String
headView n (pi _ (abs _ b)) = headView (suc n) b
headView n (def f _)        = primShowNat n <> "\t" <> primShowQName f
headView n (con c _)        = primShowNat n <> "\t" <> primShowQName c
headView n (agda-sort _)    = primShowNat n <> "\tSort"
headView n (var _ _)        = primShowNat n <> "\tvariable"
headView n (lam _ _)        = primShowNat n <> "\tlambda"
headView n (pat-lam _ _)    = primShowNat n <> "\tpattern-lambda"
headView n (lit _)          = primShowNat n <> "\tliteral"
headView n (meta _ _)       = primShowNat n <> "\tmeta"
headView n unknown          = primShowNat n <> "\tunknown"

-- One realization of a generator f.
-- r = (realized-on , accepted-application , normalized-result-type);
-- the observation is the head of the normalized RESULT type.
emitReal : Name → RawRealization → TC ⊤
emitReal f r =
  debugPrint "loci" 1
    ( strErr ("LOCUS\t" <> headView 0 (snd (snd r)) <> "\t"
              <> primShowQName f <> "\t" <> primShowQName (fst r)) ∷ [] )

emitReals : Name → List RawRealization → TC ⊤
emitReals f []       = returnTC tt
emitReals f (r ∷ rs) = bindTC (emitReal f r) λ _ → emitReals f rs

-- For generator f, compute its exact realization family over `all` and emit it.
emitLocus : List Name → Name → TC ⊤
emitLocus all f = bindTC (realizations f all) (emitReals f)

emitEach : List Name → List Name → TC ⊤
emitEach all []       = returnTC tt
emitEach all (f ∷ fs) = bindTC (emitLocus all f) λ _ → emitEach all fs

macro
  -- emitLoci names : expand names to their constructors/fields, then stream
  -- the checked realization family of every generator.  Builds no aggregate.
  emitLoci : Term → Term → TC ⊤
  emitLoci namesTerm hole =
    bindTC (unquoteTC namesTerm) λ (ns : List Name) →
    bindTC (expandAll ns)        λ expanded →
    bindTC (emitEach expanded expanded) λ _ →
    bindTC (quoteTC tt)          λ q → unify hole q
