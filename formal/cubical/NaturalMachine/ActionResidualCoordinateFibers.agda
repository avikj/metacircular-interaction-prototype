-- ॥ बीजम् ॥  One machine, one law: which side of `f a ≡ b` is bound is everything.
-- Output bound: singl (f a), contractible — the datum rides free.  Input bound:
-- fiber f b — the loss, and the subject.  Univalence computes here: an
-- equivalence is a channel, transport carries every theorem across it, and what
-- cannot cross is written as a defect — there is no third path (ahiṃsā).
-- Memory, charge, symmetry, price, distance, verdict: six faces of the one
-- fibre; the verdict type is the saptabhaṅgī, and the sources are the origin
-- (Umāsvāti, Samantabhadra, Akalaṅka — restatements are named as such).  The
-- kernel decides truth; carriers ask and generate; assert nothing whose term
-- you have not read.  This file is one naya, true and not whole.

{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- NaturalMachine.ActionResidualCoordinateFibers
--
-- The behavior and residual carriers in ActionResidual are related by an
-- actual equivalence of their whole codomain, not only mutual replay on the
-- realized image.  Postcomposition with that equivalence preserves every
-- homotopy fibre proof-relevantly.
--
-- This is coordinate invariance, not state recovery: a constant Boolean
-- observation supplies an explicit noninjective control.
------------------------------------------------------------------------

module NaturalMachine.ActionResidualCoordinateFibers where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Equiv
  using (_≃_ ; fiber ; equivFun)
open import Cubical.Foundations.Equiv.Properties using (congEquiv)
open import Cubical.Foundations.Function using (_∘_)
open import Cubical.Foundations.Isomorphism
  using (Iso ; iso ; isoToEquiv)
open import Cubical.Data.Bool using (Bool ; false ; true ; false≢true)
open import Cubical.Data.Int using (ℤ ; pos)
open import Cubical.Data.Sigma using (_×_ ; _,_ ; fst ; snd ; ΣPathP)
open import Cubical.Data.Sigma.Properties using (Σ-cong-equiv-snd)
open import Cubical.Relation.Nullary using (¬_)
open import Cubical.Foundations.Structure using (⟨_⟩)
open import Cubical.Algebra.AbGroup.Base
  using (AbGroup ; AbGroupStr)
open import Cubical.Algebra.CommRing using (CommRing→AbGroup)
open import Cubical.Algebra.CommRing.Instances.Int using (ℤCommRing)

import NaturalMachine.ActionResidual as AR

------------------------------------------------------------------------
-- 1. Any equivalence of output coordinates preserves the exact fibres
------------------------------------------------------------------------

postcomposeEquiv-fiber :
  {ℓx ℓa ℓb : Level} {X : Type ℓx} {A : Type ℓa} {B : Type ℓb}
  (e : A ≃ B) (f : X → A) (output : A)
  → fiber f output
    ≃ fiber (equivFun e ∘ f) (equivFun e output)
postcomposeEquiv-fiber e f output =
  Σ-cong-equiv-snd (λ _ → congEquiv e)

------------------------------------------------------------------------
-- 2. The ActionResidual coordinate change is a global equivalence
------------------------------------------------------------------------

module CoordinateFibers
  {ℓx ℓa : Level} {X : Type ℓx}
  (A : AbGroup ℓa)
  (q : X → ⟨ A ⟩)
  (step : X → X)
  (predict : ⟨ A ⟩ → ⟨ A ⟩)
  where

  module D = AR.DefectCoordinate A q step predict

  open AbGroupStr (snd A)
    using (_+_ ; -_ ; _-_ ; +Assoc ; +IdR ; +InvR)

  private
    addSubRight : (a b : ⟨ A ⟩) → (a + b) - b ≡ a
    addSubRight a b =
        sym (+Assoc a b (- b))
      ∙ cong (a +_) (+InvR b)
      ∙ +IdR a

  behaviorDefectIso :
    Iso (⟨ A ⟩ × ⟨ A ⟩) (⟨ A ⟩ × ⟨ A ⟩)
  behaviorDefectIso =
    iso D.defectFromBehavior D.behaviorFromDefect rightRound leftRound
    where
    rightRound : (defect : ⟨ A ⟩ × ⟨ A ⟩)
      → D.defectFromBehavior (D.behaviorFromDefect defect) ≡ defect
    rightRound (y , d) =
      ΣPathP (refl , addSubRight d (predict y))

    leftRound : (behavior : ⟨ A ⟩ × ⟨ A ⟩)
      → D.behaviorFromDefect (D.defectFromBehavior behavior) ≡ behavior
    leftRound (y , after) =
      ΣPathP (refl , D.subAddRight after (predict y))

  behaviorDefectEquiv :
    (⟨ A ⟩ × ⟨ A ⟩) ≃ (⟨ A ⟩ × ⟨ A ⟩)
  behaviorDefectEquiv = isoToEquiv behaviorDefectIso

  -- The equivalence acts on the sampled carrier exactly, not merely up to a
  -- separately supplied refinement decoder.
  behavior-to-defect : (x : X)
    → equivFun behaviorDefectEquiv (D.behaviorCarrier x)
      ≡ D.defectCarrier x
  behavior-to-defect x = refl

  -- Therefore every output fibre is transported with all of its path data.
  -- No finiteness, set-truncation, or proof-irrelevance premise is used.
  behaviorFiber≃defectFiber : (output : ⟨ A ⟩ × ⟨ A ⟩)
    → fiber D.behaviorCarrier output
      ≃ fiber D.defectCarrier (D.defectFromBehavior output)
  behaviorFiber≃defectFiber output =
    postcomposeEquiv-fiber behaviorDefectEquiv D.behaviorCarrier output

------------------------------------------------------------------------
-- 3. Hostile control: coordinate equivalence does not recover state
------------------------------------------------------------------------

module ConstantObservationControl where

  constantObservation : Bool → ℤ
  constantObservation _ = pos 0

  identityStep : Bool → Bool
  identityStep x = x

  identityPredict : ℤ → ℤ
  identityPredict x = x

  module C = CoordinateFibers
    (CommRing→AbGroup ℤCommRing)
    constantObservation identityStep identityPredict

  behavior-not-injective :
    ¬ ((x y : Bool)
      → C.D.behaviorCarrier x ≡ C.D.behaviorCarrier y
      → x ≡ y)
  behavior-not-injective injective =
    false≢true (injective false true refl)

  defect-not-injective :
    ¬ ((x y : Bool)
      → C.D.defectCarrier x ≡ C.D.defectCarrier y
      → x ≡ y)
  defect-not-injective injective =
    false≢true (injective false true refl)
