{-# OPTIONS --cubical --guardedness --no-import-sorts #-}

------------------------------------------------------------------------
-- CorpusReadout
--
-- A finite human readout of the already-wired coinductive corpus calculus.
-- `CorpusGeneratedIndex` is only a mechanical list of public checked Names.
-- This module asks AGDA ITSELF for each elaborated type and definition.
--
-- Initial finite observation q:
--   declaration ↦ (Π-arity , head of elaborated conclusion)
--
-- The fibre of q is printed explicitly as the declarations at that locus.
-- This is deliberately coarse: a demanded continuation can refine a locus;
-- the full source inhabitant/definition remains available by Name.  Direct
-- one-clause body heads are printed as exact checked generator links, exposing
-- specialisations/reuse without using files/imports as semantic edges.
------------------------------------------------------------------------

module CorpusReadout where

open import Agda.Builtin.Unit using (⊤ ; tt)
open import Agda.Builtin.Bool using (Bool ; true ; false)
open import Agda.Builtin.Nat using (Nat ; zero ; suc)
open import Agda.Builtin.String
  using (String ; primStringAppend ; primStringEquality ; primShowNat)
open import Agda.Builtin.List using (List ; [] ; _∷_)
open import Agda.Builtin.Maybe using (Maybe ; just ; nothing)
open import Agda.Builtin.Sigma using (Σ ; _,_ ; fst ; snd)
open import Agda.Builtin.Reflection
  using ( Name ; Term ; Abs ; Definition ; Clause ; TC
        ; pi ; def ; con ; lam ; pat-lam ; agda-sort ; lit ; meta ; var ; unknown
        ; abs ; function ; clause ; absurd-clause
        ; getType ; getDefinition ; reduce ; formatErrorParts ; debugPrint
        ; returnTC ; bindTC ; quoteTC ; unify
        ; ErrorPart ; strErr ; termErr ; primShowQName )

open import CorpusGeneratedIndex using (corpusNames)

infixr 5 _<>_
_<>_ : String → String → String
_<>_ = primStringAppend

------------------------------------------------------------------------
-- Small total helpers.
------------------------------------------------------------------------

lengthL : {A : Set} → List A → Nat
lengthL [] = zero
lengthL (_ ∷ xs) = suc (lengthL xs)

mapTC : {A B : Set} → (A → TC B) → List A → TC (List B)
mapTC f [] = returnTC []
mapTC f (x ∷ xs) =
  bindTC (f x) λ y →
  bindTC (mapTC f xs) λ ys →
  returnTC (y ∷ ys)

------------------------------------------------------------------------
-- The finite observation: dependent telescope arity + conclusion head.
------------------------------------------------------------------------

headView : Nat → Term → Σ Nat (λ _ → String)
headView n (pi _ (abs _ b)) = headView (suc n) b
headView n (def f _)         = n , primShowQName f
headView n (con c _)         = n , primShowQName c
headView n (agda-sort _)     = n , "Sort"
headView n (var _ _)         = n , "variable"
headView n (lam _ _)         = n , "lambda"
headView n (pat-lam _ _)     = n , "pattern-lambda"
headView n (lit _)           = n , "literal"
headView n (meta _ _)        = n , "meta"
headView n unknown           = n , "unknown"

viewKey : Term → String
viewKey t with headView zero t
... | n , h = "Π" <> primShowNat n <> " / " <> h

------------------------------------------------------------------------
-- Exact checked reuse edge: for a one-clause wrapper/specialisation, retain
-- the head definition actually present in the elaborated body.
------------------------------------------------------------------------

bodyHead : Term → Maybe String
bodyHead (def f _)             = just (primShowQName f)
bodyHead (con c _)             = just (primShowQName c)
bodyHead (lam _ (abs _ b))     = bodyHead b
bodyHead _                     = nothing

definitionHead : Definition → Maybe String
definitionHead (function (clause _ _ t ∷ [])) = bodyHead t
definitionHead _                              = nothing

record Row : Set where
  constructor row
  field
    locus     : String
    name      : String
    typeText  : String
    generator : Maybe String
open Row public

mkRow : Name → TC Row
mkRow n =
  bindTC (getType n) λ ty →
  bindTC (reduce ty) λ rty →
  bindTC (formatErrorParts (termErr ty ∷ [])) λ shown →
  bindTC (getDefinition n) λ d →
  returnTC (row (viewKey rty) (primShowQName n) shown (definitionHead d))

------------------------------------------------------------------------
-- Fibres of the finite observation.
------------------------------------------------------------------------

record Group : Set where
  constructor group
  field
    key     : String
    members : List Row
open Group public

insert : Row → List Group → List Group
insert r [] = group (locus r) (r ∷ []) ∷ []
insert r (g ∷ gs) with primStringEquality (locus r) (key g)
... | true  = group (key g) (r ∷ members g) ∷ gs
... | false = g ∷ insert r gs

groupRows : List Row → List Group
groupRows [] = []
groupRows (r ∷ rs) = insert r (groupRows rs)

------------------------------------------------------------------------
-- Readout.  The display itself is a projection; the Names remain the exact
-- handles back to the elaborated inhabitants and the coinductive calculus.
------------------------------------------------------------------------

emit : String → TC ⊤
emit s = debugPrint "corpus" 1 (strErr s ∷ [])

emitGenerator : Maybe String → TC ⊤
emitGenerator nothing  = returnTC tt
emitGenerator (just g) = emit ("      ↳ checked body head: " <> g)

emitRow : Row → TC ⊤
emitRow r =
  bindTC (emit ("    • " <> name r <> " : " <> typeText r)) λ _ →
  emitGenerator (generator r)

emitRows : List Row → TC ⊤
emitRows [] = returnTC tt
emitRows (r ∷ rs) = bindTC (emitRow r) λ _ → emitRows rs

emitGroup : Group → TC ⊤
emitGroup g =
  bindTC (emit ("\nLOCUS " <> key g <> "    residual=" <> primShowNat (lengthL (members g)))) λ _ →
  emitRows (members g)

emitGroups : List Group → TC ⊤
emitGroups [] = returnTC tt
emitGroups (g ∷ gs) = bindTC (emitGroup g) λ _ → emitGroups gs

buildAndEmit : TC ⊤
buildAndEmit =
  bindTC (mapTC mkRow corpusNames) λ rows →
  let groups = groupRows rows in
  bindTC (emit "════════ CORPUS SELF-PRESENTATION ════════") λ _ →
  bindTC (emit ("checked public declarations: " <> primShowNat (lengthL rows))) λ _ →
  bindTC (emit ("finite presentation loci:     " <> primShowNat (lengthL groups))) λ _ →
  bindTC (emit "q(declaration) = (dependent Π-arity, elaborated conclusion head)") λ _ →
  bindTC (emit "Each LOCUS prints its complete residual fibre; ↳ is an exact checked body-head reuse edge.") λ _ →
  emitGroups groups

macro
  corpusReadout : Term → TC ⊤
  corpusReadout hole =
    bindTC buildAndEmit λ _ →
    bindTC (quoteTC tt) λ qtt →
    unify hole qtt

readout : ⊤
readout = corpusReadout
