{-# OPTIONS --cubical --safe --guardedness #-}

------------------------------------------------------------------------
-- IdentityTower
--
-- The identification tower of the corpus, computed inside the kernel.
--
-- Identity here is not one relation but a tower of charts, each a
-- collapse that is blind exactly to what it identifies, each merge
-- carrying its witness:
--
--   alpha (α)        structural identity of the elaborated form
--                    (CorpusIdentity: de Bruijn serialization; names
--                    outside identity).  Witness: the serialization.
--
--   definitional (δ) statements identified up to the kernel's own
--                    normalization: two declarations share a δ-key when
--                    their TYPES normalize to α-equal forms.  Witness:
--                    the normalization, performed by the checker in
--                    this module's TC code — never by an external tool.
--                    Proof BODIES are deliberately left at α: at δ the
--                    comparable object is the statement, and at π
--                    proposition-valued proofs are identified by the
--                    corpus's own h-level results.
--
--   path (π)         identifications the corpus itself has PROVED:
--                    declarations whose (normalized) type is an
--                    equivalence or path between def-headed sides are
--                    harvested as edges  lhs ~ rhs  WITH the proving
--                    declaration as the witness.  Nothing is inferred;
--                    the π-chart is exactly the corpus's checked
--                    equivalence structure.
--
-- Per the corpus's own results this tower is presentation-relative by
-- design (Laghava: no function of the denotation computes presentation
-- size); no single level is "the" identity, and no scalar summarizes
-- the tower.  What is invariant is the family of collapses with their
-- fibres carried.
--
-- Exported line formats (driver ferries strings; kernel computes):
--   δ:   name \t <normalized-type serialization>
--   π:   name \t EQ|PATH \t lhsHead \t rhsHead
------------------------------------------------------------------------

module IdentityTower where

open import Agda.Builtin.Reflection
open import Agda.Builtin.String
open import Agda.Builtin.List
open import Agda.Builtin.Unit
open import Agda.Builtin.Sigma
open import Agda.Builtin.Nat
open import Agda.Builtin.Bool

open import Cubical.Foundations.Prelude using (PathP)
open import Cubical.Foundations.Equiv using (_≃_)
open import Cubical.Foundations.Isomorphism using (Iso)

open import CorpusIdentity using (sTerm ; qn ; _++_ ; tab ; nl)

------------------------------------------------------------------------
-- §1  The δ-chart: normalized statements, serialized.
------------------------------------------------------------------------

deltaKeyTC : Name → TC String
deltaKeyTC n =
  bindTC (getType n) λ ty →
  bindTC (catchTC (normalise ty) (returnTC ty)) λ nty →
  returnTC (sTerm nty)
-- catchTC: a statement whose normalization the kernel refuses (size,
-- termination fuel) falls back to its elaborated form — the merge that
-- would have needed that normalization simply does not happen, and the
-- fallback is visible because the emitted key equals the α-type.

------------------------------------------------------------------------
-- §2  The π-chart: proved identifications, with witnesses.
--     A declaration's normalized type with head _≃_, PathP, or Iso and
--     def/con-headed sides is an identification edge; the declaration
--     itself is the witness.
------------------------------------------------------------------------

headOf : Term → String
headOf (def f _) = qn f
headOf (con c _) = qn c
headOf (var x _) = "var"
headOf (lam _ _) = "lam"
headOf (pi _ _)  = "pi"
headOf (agda-sort _) = "sort"
headOf (lit _)   = "lit"
headOf (pat-lam _ _) = "patlam"
headOf (meta _ _) = "meta"
headOf unknown    = "?"

private
  last2 : List (Arg Term) → List Term
  last2 [] = []
  last2 (arg _ t ∷ []) = t ∷ []
  last2 (arg _ t ∷ ts) with last2 ts
  ... | []          = t ∷ []
  ... | (u ∷ [])    = t ∷ u ∷ []
  ... | (u ∷ v ∷ _) = u ∷ v ∷ []

piEdgeOf : Term → String
piEdgeOf (def h args) = go (primQNameEquality h (quote _≃_))
                            (primQNameEquality h (quote PathP))
                            (primQNameEquality h (quote Iso))
  where
  sides : String
  sides = walk (last2 args)
    where
    walk : List Term → String
    walk (x ∷ y ∷ []) = headOf x ++ tab ++ headOf y
    walk _            = "?" ++ tab ++ "?"
  go : Bool → Bool → Bool → String
  go true _ _ = "EQV" ++ tab ++ sides
  go _ true _ = "PATH" ++ tab ++ sides
  go _ _ true = "ISO" ++ tab ++ sides
  go _ _ _    = ""
piEdgeOf _ = ""

-- descend through binders: the identification claim lives in the codomain
codomainOf : Term → Term
codomainOf (pi _ (abs _ b)) = codomainOf b
codomainOf t = t

piEdgeTC : Name → TC String
piEdgeTC n =
  bindTC (getType n) λ ty →
  bindTC (catchTC (normalise ty) (returnTC ty)) λ nty →
  returnTC (piEdgeOf (codomainOf nty))

------------------------------------------------------------------------
-- §3  Export: one probe per module; the driver ferries the string.
------------------------------------------------------------------------

emitPi : Name → String → String
emitPi n s = go (primStringEquality s "")
  where
  go : Bool → String
  go true  = ""
  go false = "P" ++ tab ++ qn n ++ tab ++ s ++ nl

towerLinesTC : List Name → TC String
towerLinesTC [] = returnTC ""
towerLinesTC (n ∷ ns) =
  bindTC (deltaKeyTC n) λ dk →
  bindTC (piEdgeTC n) λ pe →
  bindTC (towerLinesTC ns) λ rest →
  returnTC
    ("D" ++ tab ++ qn n ++ tab ++ dk ++ nl ++
     emitPi n pe ++ rest)

macro
  towerOf : List Name → Term → TC ⊤
  towerOf ns hole =
    bindTC (towerLinesTC ns) λ s →
    bindTC (quoteTC s) (unify hole)
