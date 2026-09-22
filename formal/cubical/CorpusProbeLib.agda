{-# OPTIONS --cubical --guardedness --no-import-sorts #-}

------------------------------------------------------------------------
-- CorpusProbeLib — identity keys for the equivalence-class map.
--
-- For each declaration: getType, NORMALISE (βδι — unfold every definition
-- to normal form), then serialize the normal-form Term to a canonical
-- string. de Bruijn indices make the serialization α-invariant, and
-- normalisation makes it definitional-equality-invariant, so
--
--     ser(nf(type A)) ≡ ser(nf(type B))   ⟺   A and B have the SAME type
--                                              at LF definitional identity.
--
-- Grouping declarations by this key IS the equivalence-class map at the
-- level of mathematical (type) identity. Each row is
--
--     OBJ <key> <qualified-name>            the whole type as an object
--     SUB <key> <qualified-name>#<i>        each top-level Π-domain (sub-object)
--
-- so identities between sub-objects are covered too.
------------------------------------------------------------------------

module CorpusProbeLib where

open import Agda.Builtin.Unit using (⊤ ; tt)
open import Agda.Builtin.Nat using (Nat ; zero ; suc)
open import Agda.Builtin.String using (String ; primStringAppend ; primShowNat)
open import Agda.Builtin.List using (List ; [] ; _∷_)
open import Agda.Builtin.Reflection
  using ( Name ; Term ; Abs ; abs ; Arg ; arg ; ArgInfo ; arg-info
        ; Visibility ; visible ; hidden ; instance′
        ; Sort
        ; var ; con ; def ; lam ; pat-lam ; pi ; agda-sort ; lit ; meta ; unknown
        ; set ; prop ; propLit ; inf
        ; TC ; getType ; normalise ; returnTC ; bindTC ; catchTC
        ; quoteTC ; unquoteTC ; unify ; debugPrint ; ErrorPart ; strErr
        ; primShowQName )

infixr 5 _<>_
_<>_ : String → String → String
_<>_ = primStringAppend

vis : Visibility → String
vis visible   = "e"
vis hidden    = "i"
vis instance′ = "n"

------------------------------------------------------------------------
-- Canonical serialization of a normal-form Term.  Fully parenthesized,
-- constructor-tagged; equal strings ⟺ syntactically-equal normal forms.
------------------------------------------------------------------------

mutual
  serT : Term → String
  serT (var x as)          = "v" <> primShowNat x <> serArgs as
  serT (con c as)          = "c" <> primShowQName c <> serArgs as
  serT (def f as)          = "d" <> primShowQName f <> serArgs as
  serT (lam v (abs _ t))   = "l" <> vis v <> "(" <> serT t <> ")"
  serT (pat-lam _ as)      = "P" <> serArgs as
  serT (pi (arg (arg-info v _) a) (abs _ b)) =
    "p" <> vis v <> "(" <> serT a <> ")(" <> serT b <> ")"
  serT (agda-sort s)       = "s" <> serS s
  serT (lit _)             = "L"
  serT (meta _ as)         = "m" <> serArgs as
  serT unknown             = "?"

  serArgs : List (Arg Term) → String
  serArgs []                          = ""
  serArgs (arg (arg-info v _) t ∷ as) = "[" <> vis v <> serT t <> "]" <> serArgs as

  serS : Sort → String
  serS (set t)     = "S(" <> serT t <> ")"
  serS (lit n)     = "S" <> primShowNat n
  serS (prop t)    = "R(" <> serT t <> ")"
  serS (propLit n) = "R" <> primShowNat n
  serS (inf n)     = "I" <> primShowNat n
  serS unknown     = "?"

------------------------------------------------------------------------
-- Emit rows for one declaration: its whole type, and each Π-domain.
------------------------------------------------------------------------

emitLine : String → TC ⊤
emitLine s = debugPrint "row" 1 (strErr s ∷ [])

-- walk top-level Π, emitting each domain as a sub-object
emitDomains : String → Nat → Term → TC ⊤
emitDomains nm i (pi (arg _ a) (abs _ b)) =
  bindTC (emitLine ("SUB\t" <> serT a <> "\t" <> nm <> "#" <> primShowNat i))
         (λ _ → emitDomains nm (suc i) b)
emitDomains _ _ _ = returnTC tt

emit1 : Name → TC ⊤
emit1 nm =
  catchTC
    (bindTC (getType nm) λ ty →
     bindTC (normalise ty) λ nf →
     bindTC (emitLine ("OBJ\t" <> serT nf <> "\t" <> primShowQName nm)) λ _ →
     emitDomains (primShowQName nm) 0 nf)
    (returnTC tt)  -- normalise/getType failed on this one: skip, don't pollute

emitAll : List Name → TC ⊤
emitAll []       = returnTC tt
emitAll (n ∷ ns) = bindTC (emit1 n) λ _ → emitAll ns

macro
  emitRows : Term → Term → TC ⊤
  emitRows namesTerm hole =
    bindTC (unquoteTC namesTerm) λ (ns : List Name) →
    bindTC (emitAll ns)          λ _ →
    bindTC (quoteTC tt)          λ q → unify hole q

------------------------------------------------------------------------
-- Identity EDGES: the corpus's own equivalence witnesses.  A declaration
-- of type  A ≃ B  or  Iso A B  is a checked proof that objects A and B
-- are the same up to (coinductively-established) equivalence.  We read
-- the head off the UN-normalised type (normalise unfolds ≃ into Σ), take
-- the two endpoints, normalise THOSE so they match object keys, and emit
--     EDGE <key A> <key B>
-- Connected components of these edges are the equivalence classes at the
-- level of provable mathematical identity — resolved by the witnesses,
-- not decided by us.
------------------------------------------------------------------------

open import Agda.Builtin.Bool using (Bool ; true ; false)
open import Agda.Builtin.Reflection using (primQNameEquality)
open import Cubical.Foundations.Equiv using (_≃_)
open import Cubical.Foundations.Isomorphism using (Iso)

eqN isoN : Name
eqN  = quote _≃_
isoN = quote Iso

isEqHead : Name → Bool
isEqHead g with primQNameEquality g eqN
... | true  = true
... | false = primQNameEquality g isoN

visArgTerms : List (Arg Term) → List Term
visArgTerms []                                  = []
visArgTerms (arg (arg-info visible _) t ∷ as)   = t ∷ visArgTerms as
visArgTerms (arg (arg-info hidden _) _ ∷ as)    = visArgTerms as
visArgTerms (arg (arg-info instance′ _) _ ∷ as) = visArgTerms as

emitEdge : Term → Term → TC ⊤
emitEdge a b =
  catchTC
    (bindTC (normalise a) λ na →
     bindTC (normalise b) λ nb →
     emitLine ("EDGE\t" <> serT na <> "\t" <> serT nb))
    (returnTC tt)

twoOf : List Term → TC ⊤
twoOf (a ∷ b ∷ _) = emitEdge a b
twoOf _           = returnTC tt

edge1 : Name → TC ⊤
edge1 nm =
  catchTC
    (bindTC (getType nm) λ ty → goHead ty)
    (returnTC tt)
  where
    goHead : Term → TC ⊤
    goHead (def f as) with isEqHead f
    ... | true  = twoOf (visArgTerms as)
    ... | false = returnTC tt
    goHead _ = returnTC tt

emitEdgesAll : List Name → TC ⊤
emitEdgesAll []       = returnTC tt
emitEdgesAll (n ∷ ns) = bindTC (edge1 n) λ _ → emitEdgesAll ns

macro
  emitEdges : Term → Term → TC ⊤
  emitEdges namesTerm hole =
    bindTC (unquoteTC namesTerm) λ (ns : List Name) →
    bindTC (emitEdgesAll ns)     λ _ →
    bindTC (quoteTC tt)          λ q → unify hole q
