{-# OPTIONS --cubical --guardedness --no-import-sorts #-}

------------------------------------------------------------------------
-- CorpusProbeLib — shared readout helpers, imported by each chunk module.
--
-- Emits one machine-parseable row per declaration:
--     ROW <Π-arity> <conclusion-head> <qualified-name>
-- via debugPrint on verbosity "row". A chunk module imports a slice of
-- the corpus and calls `emitRows (quote M.x ∷ … ∷ [])`; rows from all
-- chunks are aggregated and grouped OUTSIDE Agda into meaning-loci.
--
-- Chunking keeps each Agda process small (a few dozen imports, ~400 MB)
-- instead of the ~12 GB a whole-corpus import needs, and lets a red
-- module fail only its own chunk.
------------------------------------------------------------------------

module CorpusProbeLib where

open import Agda.Builtin.Unit using (⊤ ; tt)
open import Agda.Builtin.Nat using (Nat ; zero ; suc)
open import Agda.Builtin.String using (String ; primStringAppend ; primShowNat)
open import Agda.Builtin.List using (List ; [] ; _∷_)
open import Agda.Builtin.Reflection
  using ( Name ; Term ; Abs ; TC
        ; pi ; def ; con ; lam ; pat-lam ; agda-sort ; lit ; meta ; var ; unknown
        ; abs ; getType ; returnTC ; bindTC ; quoteTC ; unquoteTC ; unify
        ; debugPrint ; ErrorPart ; strErr ; primShowQName )

infixr 5 _<>_
_<>_ : String → String → String
_<>_ = primStringAppend

-- (dependent Π-arity, conclusion head) of an elaborated type.
headView : Nat → Term → String
headView n (pi _ (abs _ b)) = headView (suc n) b
headView n (def f _)         = primShowNat n <> "\t" <> primShowQName f
headView n (con c _)         = primShowNat n <> "\t" <> primShowQName c
headView n (agda-sort _)     = primShowNat n <> "\tSort"
headView n (var _ _)         = primShowNat n <> "\tvariable"
headView n (lam _ _)         = primShowNat n <> "\tlambda"
headView n (pat-lam _ _)     = primShowNat n <> "\tpattern-lambda"
headView n (lit _)           = primShowNat n <> "\tliteral"
headView n (meta _ _)        = primShowNat n <> "\tmeta"
headView n unknown           = primShowNat n <> "\tunknown"

emit1 : Name → TC ⊤
emit1 nm =
  bindTC (getType nm) λ ty →
  debugPrint "row" 1 (strErr ("ROW\t" <> headView 0 ty <> "\t" <> primShowQName nm) ∷ [])

emitAll : List Name → TC ⊤
emitAll []       = returnTC tt
emitAll (n ∷ ns) = bindTC (emit1 n) λ _ → emitAll ns

macro
  emitRows : Term → Term → TC ⊤
  emitRows namesTerm hole =
    bindTC (unquoteTC namesTerm) λ (ns : List Name) →
    bindTC (emitAll ns)          λ _ →
    bindTC (quoteTC tt)          λ q → unify hole q
