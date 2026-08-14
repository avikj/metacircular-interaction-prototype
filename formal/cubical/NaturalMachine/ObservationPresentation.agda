{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- NaturalMachine.ObservationPresentation
--
-- A lossless change of the CODOMAIN PRESENTATION of an observation does
-- not change which set-valued targets can be executed from it.
--
-- The fixed random anchor was compressed PNG payload.  Its decoded image
-- suggested the presentation question but supplies no hypothesis below.
-- This module does not formalise PNG, visual meaning, or any relation
-- between one byte window and the image.  It isolates the exact reusable
-- core statement: postcomposition by an equivalence preserves the kernel
-- pair, hence preserves `FactorsThrough` in both directions.
--
-- The equivalence hypothesis is load-bearing.  The final Bool control
-- exhibits a non-injective postprocess that merges `true` and `false` and
-- thereby destroys descent of the identity target.
------------------------------------------------------------------------

module NaturalMachine.ObservationPresentation where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Function using (_∘_)
open import Cubical.Foundations.Equiv
  using (_≃_ ; equivFun ; invEq ; retEq)
open import Cubical.Foundations.Isomorphism using (Iso ; iso)
open import Cubical.Data.Bool
  using (Bool ; true ; false ; true≢false ; isSetBool)
open import Cubical.Data.Unit using (Unit ; tt)
open import Cubical.Relation.Nullary using (¬_)

open import NaturalMachine.FiniteInformation
  using ( FactorsThrough
        ; FiberConstant
        ; factorsThrough→fiberConstant
        ; fiberConstant→factorsThrough
        ; factorsThrough-postprocess
        ; isPropFactorsThrough
        )

private
  variable
    ℓx ℓy ℓz ℓt : Level

------------------------------------------------------------------------
-- 1.  An equivalence does not change the kernel pair
------------------------------------------------------------------------

equiv-injective :
  {Y : Type ℓy} {Z : Type ℓz}
  (e : Y ≃ Z) {y y' : Y}
  → equivFun e y ≡ equivFun e y' → y ≡ y'
equiv-injective e {y} {y'} p =
  sym (retEq e y) ∙∙ cong (invEq e) p ∙∙ retEq e y'

fiberConstant-postEquiv :
  {X : Type ℓx} {Y : Type ℓy} {Z : Type ℓz} {T : Type ℓt}
  (q : X → Y) (t : X → T) (e : Y ≃ Z)
  → FiberConstant q t
  → FiberConstant (equivFun e ∘ q) t
fiberConstant-postEquiv q t e constant x x' same =
  constant x x' (equiv-injective e same)

------------------------------------------------------------------------
-- 2.  Executable descent is invariant under the presentation change
------------------------------------------------------------------------

factorsThrough-postEquiv :
  {X : Type ℓx} {Y : Type ℓy} {Z : Type ℓz} {T : Type ℓt}
  (isSetT : isSet T) (q : X → Y) (t : X → T) (e : Y ≃ Z)
  → FactorsThrough q t
  → FactorsThrough (equivFun e ∘ q) t
factorsThrough-postEquiv isSetT q t e through =
  fiberConstant→factorsThrough isSetT (equivFun e ∘ q) t
    (fiberConstant-postEquiv q t e
      (factorsThrough→fiberConstant q t through))

factorsThrough-unpostEquiv :
  {X : Type ℓx} {Y : Type ℓy} {Z : Type ℓz} {T : Type ℓt}
  (isSetT : isSet T) (q : X → Y) (t : X → T) (e : Y ≃ Z)
  → FactorsThrough (equivFun e ∘ q) t
  → FactorsThrough q t
factorsThrough-unpostEquiv isSetT q t e =
  factorsThrough-postprocess isSetT q (equivFun e) t

factorsThrough-postEquivIso :
  {X : Type ℓx} {Y : Type ℓy} {Z : Type ℓz} {T : Type ℓt}
  (isSetT : isSet T) (q : X → Y) (t : X → T) (e : Y ≃ Z)
  → Iso (FactorsThrough q t)
        (FactorsThrough (equivFun e ∘ q) t)
factorsThrough-postEquivIso isSetT q t e = iso
  (factorsThrough-postEquiv isSetT q t e)
  (factorsThrough-unpostEquiv isSetT q t e)
  (λ h → isPropFactorsThrough isSetT (equivFun e ∘ q) t _ h)
  (λ h → isPropFactorsThrough isSetT q t _ h)

------------------------------------------------------------------------
-- 3.  Control: a lossy postprocess can destroy descent
------------------------------------------------------------------------

collapse : Bool → Unit
collapse _ = tt

boolIdentity-factors : FactorsThrough (λ b → b) (λ b → b)
boolIdentity-factors =
  fiberConstant→factorsThrough isSetBool (λ b → b) (λ b → b)
    (λ _ _ p → p)

collapse-obstructs-identity : ¬ FactorsThrough collapse (λ b → b)
collapse-obstructs-identity through =
  true≢false
    (factorsThrough→fiberConstant collapse (λ b → b) through
      true false refl)
