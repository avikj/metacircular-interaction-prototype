{-# OPTIONS --cubical --safe --guardedness --no-import-sorts #-}

------------------------------------------------------------------------
-- CorpusNF — the corpus as ONE mathematical object, collapsed by the
-- normal form of each declaration's TYPE, not by any file/import structure.
--
-- getType then normalise gives the definitional normal form of a
-- declaration's type.  Two declarations with the same normal-form type are
-- the SAME proposition (in a proof-irrelevant reading): the corpus proves
-- one theorem, however many modules restate or re-prove it.  Serialising
-- the normalised Term to a canonical de-Bruijn string (variable names carry
-- no information; indices are already alpha-canonical) gives a key on which
-- the equivalence classes are exactly equality of that key.
--
--     NF <canonical-normal-form-of-type> <qualified-name>
--
-- on verbosity "nf".  Grouping by the first field, outside Agda, IS the
-- quotient: |classes| distinct propositions among |rows| declarations, and
-- each class is a genuine mathematical identity across wherever it occurs.
-- This is the object to understand the corpus by; the (arity, head) readout
-- of CorpusProbe is only its coarsest projection.
------------------------------------------------------------------------

module Fibre.CorpusNF where

open import Agda.Builtin.Unit using (⊤ ; tt)
open import Agda.Builtin.Nat using (Nat ; zero ; suc)
open import Agda.Builtin.String using (String ; primStringAppend ; primShowNat)
open import Agda.Builtin.List using (List ; [] ; _∷_)
open import Agda.Builtin.Reflection
  using ( Name ; Term ; Arg ; Abs ; TC
        ; pi ; def ; con ; lam ; pat-lam ; agda-sort ; lit ; meta ; var ; unknown
        ; arg ; abs
        ; getType ; normalise ; returnTC ; bindTC ; quoteTC ; unquoteTC ; unify
        ; debugPrint ; strErr ; primShowQName )

open import Fibre.CorpusReflection using (expandAll)

infixr 5 _<>_
_<>_ : String → String → String
_<>_ = primStringAppend

-- Canonical linear serialisation of a normalised Term.  De-Bruijn indices
-- are alpha-invariant, so structurally equal (definitionally equal, after
-- normalise) types serialise identically.  Binder/argument names are
-- dropped on purpose; pattern-lambdas and metas are opaque leaves (they do
-- not occur in a normalised closed type in practice).
serT : Term → String
serArgs : List (Arg Term) → String

serT (var i args)         = "v" <> primShowNat i <> serArgs args
serT (con c args)         = "c" <> primShowQName c <> serArgs args
serT (def f args)         = "d" <> primShowQName f <> serArgs args
serT (lam _ (abs _ t))    = "l(" <> serT t <> ")"
serT (pat-lam _ _)        = "P"
serT (pi (arg _ a) (abs _ b)) = "Π(" <> serT a <> ";" <> serT b <> ")"
serT (agda-sort _)        = "s"   -- universe level is not a proposition-distinction here
serT (lit _)              = "L"
serT (meta _ _)           = "M"
serT unknown              = "?"

serArgs []               = ""
serArgs (arg _ t ∷ as)   = "[" <> serT t <> "]" <> serArgs as

nfKey : Name → TC String
nfKey n =
  bindTC (getType n) λ ty →
  bindTC (normalise ty) λ nf →
  returnTC (serT nf)

emitNF : Name → TC ⊤
emitNF n =
  bindTC (nfKey n) λ k →
  debugPrint "nf" 1 (strErr ("NF\t" <> k <> "\t" <> primShowQName n) ∷ [])

emitNFGo : List Name → TC ⊤
emitNFGo []       = returnTC tt
emitNFGo (n ∷ ns) = bindTC (emitNF n) λ _ → emitNFGo ns

macro
  -- emitNFs names : normalise each declaration's type and stream its
  -- canonical normal-form key.  Grouping by key IS the collapse-by-equivalence.
  emitNFs : Term → Term → TC ⊤
  emitNFs namesTerm hole =
    bindTC (unquoteTC namesTerm) λ (ns : List Name) →
    bindTC (expandAll ns)        λ expanded →
    bindTC (emitNFGo expanded)   λ _ →
    bindTC (quoteTC tt)          λ q → unify hole q
