{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- CostGeometry's Nat inequalities are sound for every declared Edge, but
-- the current Edge record contains only a function and a cost.  It does not
-- certify either that the function is an equivalence or that it preserves
-- the operation carried by the two presentations.  The two controls below
-- show that these are independent missing fields.
------------------------------------------------------------------------

module CostGeometryEdgeBoundary where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Equiv
  using (_≃_ ; isEquiv ; equivFun ; invEq ; retEq ; idIsEquiv)
open import Cubical.Data.Bool
  using (Bool ; false ; true ; _⊕_ ; _and_ ; false≢true)
open import Cubical.Data.Nat using (zero ; suc)
open import Cubical.Data.Sigma using (_×_ ; _,_)
open import Cubical.Data.Unit using (Unit ; tt ; isPropUnit)
open import Cubical.Relation.Nullary using (¬_)

open import CostGeometry

------------------------------------------------------------------------
-- 1. The two laws that the present Edge record does not contain
------------------------------------------------------------------------

MoveIsEquiv : {A B : Presentation} → Edge A B → Type₀
MoveIsEquiv e = isEquiv (move e)

PreservesOperation : {A B : Presentation} → Edge A B → Type₀
PreservesOperation {A} {B} e =
  (left right : Carrier A) →
  move e (op A left right) ≡ op B (move e left) (move e right)

LawfulRepresentationMove : {A B : Presentation} → Edge A B → Type₀
LawfulRepresentationMove e = MoveIsEquiv e × PreservesOperation e

------------------------------------------------------------------------
-- 2. An Edge need not even be an equivalence of carriers
------------------------------------------------------------------------

xorPresentation : Presentation
xorPresentation = pres Bool _⊕_

unitPresentation : Presentation
unitPresentation = pres Unit (λ _ _ → tt)

collapseEdge : Edge xorPresentation unitPresentation
collapseEdge = edge (λ _ → tt) zero

returnFalseEdge : Edge unitPresentation xorPresentation
returnFalseEdge = edge (λ _ → false) zero

collapse-move-not-equiv : ¬ MoveIsEquiv collapseEdge
collapse-move-not-equiv moveEquiv =
  false≢true
    (sym (retEq equivalence false)
      ∙ cong (invEq equivalence)
          (isPropUnit (equivFun equivalence false)
                      (equivFun equivalence true))
      ∙ retEq equivalence true)
  where
  equivalence : Bool ≃ Unit
  equivalence = move collapseEdge , moveEquiv

collapse-move-preserves : PreservesOperation collapseEdge
collapse-move-preserves _ _ = refl

preserving-move-need-not-be-equiv :
    PreservesOperation collapseEdge
  × (¬ MoveIsEquiv collapseEdge)
preserving-move-need-not-be-equiv =
  collapse-move-preserves , collapse-move-not-equiv

collapse-edge-is-not-lawful : ¬ LawfulRepresentationMove collapseEdge
collapse-edge-is-not-lawful lawful = collapse-move-not-equiv (lawful .fst)

-- The original arithmetic definition can even call a route through these
-- non-equivalent carriers a speedup.  This is not a false inequality: it is
-- evidence that Speedup by itself contains no correctness certificate.
collapse-route-speedup :
  Speedup collapseEdge returnFalseEdge (suc zero) zero
collapse-route-speedup = zero , refl

speedup-does-not-imply-equivalent-move :
    Speedup collapseEdge returnFalseEdge (suc zero) zero
  × (¬ MoveIsEquiv collapseEdge)
speedup-does-not-imply-equivalent-move =
  collapse-route-speedup , collapse-move-not-equiv

------------------------------------------------------------------------
-- 3. Even an equivalence-valued move need not preserve the operation
------------------------------------------------------------------------

andPresentation : Presentation
andPresentation = pres Bool _and_

identityXorToAnd : Edge xorPresentation andPresentation
identityXorToAnd = edge (λ bit → bit) zero

identity-move-is-equiv : MoveIsEquiv identityXorToAnd
identity-move-is-equiv = idIsEquiv Bool

identity-move-does-not-preserve :
  ¬ PreservesOperation identityXorToAnd
identity-move-does-not-preserve preserves =
  false≢true (preserves true true)

equivalent-move-is-not-enough :
    MoveIsEquiv identityXorToAnd
  × (¬ PreservesOperation identityXorToAnd)
equivalent-move-is-not-enough =
  identity-move-is-equiv , identity-move-does-not-preserve

------------------------------------------------------------------------
-- Scope: no theorem in CostGeometry is modified or refuted.  Its inequalities
-- depend only on Nat costs.  The checked correction is that the present graph
-- is a graph of costed functions; reading it as a graph of checked,
-- task-preserving representation equivalences requires both extra laws.
------------------------------------------------------------------------
