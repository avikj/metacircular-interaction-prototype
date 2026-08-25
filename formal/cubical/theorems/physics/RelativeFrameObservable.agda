{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- RelativeFrameObservable
--
-- Observer-indexed observables and their exact frame-independence law.
-- A fact family changes covariantly, while its evaluator changes by inverse
-- precomposition.  Frame independence is conservation of the paired result,
-- not the assertion that observer-relative facts are literally equal.
--
-- This is structural input for relational reference-frame models.  It does
-- not assert that every physical observable is frame independent, nor does it
-- supply quantum dynamics or probabilities.
------------------------------------------------------------------------

module RelativeFrameObservable where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Bool using (Bool ; true ; false ; true≢false)
open import Cubical.Data.Sigma using (_×_ ; _,_)
open import Cubical.Data.Unit using (Unit ; tt)
open import Cubical.Relation.Nullary using (¬_)

import EvaluatorTransport as ET
import RelativeFrameChange as RFC

private
  variable
    ℓ ℓf ℓr : Level

------------------------------------------------------------------------
-- 1. Dependent evaluator families and their frame-change descent law
------------------------------------------------------------------------

EvaluatorFamily : (L : Type ℓ) (F : L → Type ℓf)
                → (R : Type ℓr) → Type _
EvaluatorFamily L F R = (o : L) → F o → R

transportEvaluatorFamily : {L : Type ℓ}
  {F G : L → Type ℓf} {R : Type ℓr}
  → RFC.FrameChange F G
  → EvaluatorFamily L F R → EvaluatorFamily L G R
transportEvaluatorFamily change score o =
  ET.transportEvaluator (RFC.at change o) (score o)

-- Two evaluator families express one frame-independent observable exactly
-- when every local frame equivalence conserves every paired evaluation.
FrameIndependent : {L : Type ℓ}
  {F G : L → Type ℓf} {R : Type ℓr}
  → RFC.FrameChange F G
  → EvaluatorFamily L F R → EvaluatorFamily L G R → Type _
FrameIndependent change scoreF scoreG =
  (o : _) → ET.PreservesAll (RFC.at change o) (scoreF o) (scoreG o)

transported-family-is-independent : {L : Type ℓ}
  {F G : L → Type ℓf} {R : Type ℓr}
  (change : RFC.FrameChange F G) (score : EvaluatorFamily L F R)
  → FrameIndependent change score (transportEvaluatorFamily change score)
transported-family-is-independent change score o =
  ET.transportEvaluator-preserves (RFC.at change o) (score o)

-- The descent law determines the evaluator after a frame change uniquely.
frame-independent-family-unique : {L : Type ℓ}
  {F G : L → Type ℓf} {R : Type ℓr}
  (change : RFC.FrameChange F G)
  (scoreF : EvaluatorFamily L F R) (scoreG : EvaluatorFamily L G R)
  → FrameIndependent change scoreF scoreG
  → scoreG ≡ transportEvaluatorFamily change scoreF
frame-independent-family-unique change scoreF scoreG preserves =
  funExt λ o →
    ET.transportEvaluator-unique
      (RFC.at change o) (scoreF o) (scoreG o) (preserves o)

------------------------------------------------------------------------
-- 2. Evaluation itself descends although the relative fact may change
------------------------------------------------------------------------

changeEvaluation : {L : Type ℓ}
  {F G : L → Type ℓf} {R : Type ℓr}
  → RFC.FrameChange F G → (o : L)
  → ET.EvaluationFrame (F o) R → ET.EvaluationFrame (G o) R
changeEvaluation change o = ET.transportEvaluation (RFC.at change o)

evaluation-is-frame-independent : {L : Type ℓ}
  {F G : L → Type ℓf} {R : Type ℓr}
  (change : RFC.FrameChange F G) (o : L)
  (frame : ET.EvaluationFrame (F o) R)
  → ET.runEvaluation (changeEvaluation change o frame)
    ≡ ET.runEvaluation frame
evaluation-is-frame-independent change o =
  ET.transportEvaluation-invariant (RFC.at change o)

------------------------------------------------------------------------
-- 3. Finite controls: paired invariance versus a frozen evaluator
------------------------------------------------------------------------

boolReadout : Bool → Bool
boolReadout b = b

boolFrame : ET.EvaluationFrame Bool Bool
boolFrame = boolReadout , true

-- The fact true becomes false under the checked flip frame change.  The
-- contravariantly transported evaluator becomes Boolean negation, so the
-- evaluated result is nevertheless conserved.
bool-paired-frame-invariant :
  ET.runEvaluation (changeEvaluation RFC.flipChange tt boolFrame)
    ≡ ET.runEvaluation boolFrame
bool-paired-frame-invariant =
  evaluation-is-frame-independent RFC.flipChange tt boolFrame

-- If the evaluator is frozen while only the relative fact changes, the same
-- result is not conserved.  This is the finite control separating covariance
-- of the paired observable from invariance of a bare observer-relative fact.
bool-frozen-evaluator-is-sensitive :
  ¬ (boolReadout (RFC.changeFact RFC.flipChange tt true)
       ≡ boolReadout true)
bool-frozen-evaluator-is-sensitive p = true≢false (sym p)

