{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- NaturalMachine.ActionResidual
--
-- A one-shot observable formed from an action already in the language.
-- Given
--
--   q       : X -> A        current observation,
--   step    : X -> X        installed state action,
--   predict : A -> A        declared action on the old observation,
--
-- the failed-commutation coordinate is
--
--   residual x = q (step x) - predict (q x).
--
-- The result below is deliberately relative to `predict`: without a
-- declared predictor there is behavior `(q x , q (step x))`, but no
-- preferred origin for its second coordinate.  Once the origin is
-- declared, the behavior carrier and the residual carrier are reversibly
-- interdecodable.  Zero residual is exactly pointwise commutation.
--
-- The arithmetic formation event is square under successor.  Predicting
-- that the square merely increments by one leaves residual
--
--   (x + 1)^2 - (x^2 + 1) = 2x.
--
-- Thus one execution of successor splits the old square fibre {1,-1}; the
-- new coordinate was calculated from the old sensor and action, not granted
-- as a cube/sign oracle.  The strict-refinement certificate is an instance
-- of the independently returned `ActionRefinement` product theorem.
--
-- The universal properties and equivariance-defect language are standard;
-- no novelty is claimed.  All statements checked; no holes or postulates.
------------------------------------------------------------------------

module NaturalMachine.ActionResidual where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Structure using (⟨_⟩)
open import Cubical.Data.Sigma
  using (_×_ ; Σ-syntax ; _,_ ; fst ; snd ; ΣPathP)
open import Cubical.Relation.Nullary using (¬_)
open import Cubical.Data.Int
  using (ℤ ; pos ; negsuc ; posNotnegsuc)
open import Cubical.Algebra.AbGroup.Base
  using (AbGroup ; AbGroupStr)
open import Cubical.Algebra.CommRing
open import Cubical.Algebra.CommRing.Instances.Int using (ℤCommRing)
open import Cubical.Tactics.CommRingSolver.Reflection

import NaturalMachine.ActionRefinement as AR
import NaturalMachine.StructuredDefect as SD

------------------------------------------------------------------------
-- 1.  The residual is an exact re-coordinate of one-step behavior
------------------------------------------------------------------------

module DefectCoordinate
  {ℓx ℓa : Level} {X : Type ℓx}
  (A : AbGroup ℓa)
  (q : X → ⟨ A ⟩)
  (step : X → X)
  (predict : ⟨ A ⟩ → ⟨ A ⟩)
  where

  open AbGroupStr (snd A)
    using (_+_ ; -_ ; _-_ ; 0g ; +Assoc ; +IdR ; +IdL ; +InvR ; +InvL)

  after : X → ⟨ A ⟩
  after x = q (step x)

  residual : X → ⟨ A ⟩
  residual x = after x - predict (q x)

  behaviorCarrier defectCarrier : X → ⟨ A ⟩ × ⟨ A ⟩
  behaviorCarrier x = q x , after x
  defectCarrier   x = q x , residual x

  -- The sole algebraic calculation: subtraction followed by restoring the
  -- declared prediction recovers the observed after-state.
  subAddRight : (a b : ⟨ A ⟩) → (a - b) + b ≡ a
  subAddRight a b =
      sym (+Assoc a (- b) b)
    ∙ cong (a +_) (+InvL b)
    ∙ +IdR a

  behaviorFromDefect : ⟨ A ⟩ × ⟨ A ⟩ → ⟨ A ⟩ × ⟨ A ⟩
  behaviorFromDefect (y , d) = y , d + predict y

  defectFromBehavior : ⟨ A ⟩ × ⟨ A ⟩ → ⟨ A ⟩ × ⟨ A ⟩
  defectFromBehavior (y , z) = y , z - predict y

  behaviorFromDefect-replay :
    (x : X) → behaviorFromDefect (defectCarrier x) ≡ behaviorCarrier x
  behaviorFromDefect-replay x =
    ΣPathP (refl , subAddRight (after x) (predict (q x)))

  defectFromBehavior-replay :
    (x : X) → defectFromBehavior (behaviorCarrier x) ≡ defectCarrier x
  defectFromBehavior-replay x = refl

  defect-refines-behavior : AR.Refines defectCarrier behaviorCarrier
  defect-refines-behavior = behaviorFromDefect , behaviorFromDefect-replay

  behavior-refines-defect : AR.Refines behaviorCarrier defectCarrier
  behavior-refines-defect = defectFromBehavior , defectFromBehavior-replay

  -- Vanishing is not an analogy: it is exactly commutation of the declared
  -- prediction square at the given state.
  zero-defect→commutes :
    (x : X) → residual x ≡ 0g → after x ≡ predict (q x)
  zero-defect→commutes x h =
      sym (subAddRight (after x) (predict (q x)))
    ∙ cong (_+ predict (q x)) h
    ∙ +IdL (predict (q x))

  commutes→zero-defect :
    (x : X) → after x ≡ predict (q x) → residual x ≡ 0g
  commutes→zero-defect x h =
      cong (_- predict (q x)) h
    ∙ +InvR (predict (q x))

  -- A behavior collision transports to a residual collision.  The proof
  -- reconstructs each after-value, so it does not appeal to cardinality.
  behavior-collision→defect-collision :
    AR.ActionCollision q after → AR.ActionCollision q residual
  behavior-collision→defect-collision (x , x' , qeq , after≢) =
    x , x' , qeq , λ residualEq → after≢
      ( sym (subAddRight (after x)  (predict (q x)))
      ∙ cong₂ _+_ residualEq (cong predict qeq)
      ∙ subAddRight (after x') (predict (q x')) )

  module ResidualProduct = AR.ProductRefinement q residual

  -- The executable formation certificate: if one action encounter exposes a
  -- difference inside an old q-fibre, `(q,residual)` strictly refines q.
  collision-forces-residual-formation :
    AR.ActionCollision q after
    → AR.Refines ResidualProduct.joint q
      × SD.Reopens q ResidualProduct.joint
  collision-forces-residual-formation collision =
    ResidualProduct.collision-forces-strict-refinement
      (behavior-collision→defect-collision collision)

------------------------------------------------------------------------
-- 2.  Elementary arithmetic: square under successor forms `2x`
------------------------------------------------------------------------

module SquareSuccessor {ℓ : Level} (Rng : CommRing ℓ) where

  open CommRingStr (snd Rng)

  square : fst Rng → fst Rng
  square x = x · x

  -- Prove the stronger translation identity first.  Besides exposing the
  -- bilinear cross-term, keeping the increment variable avoids a known
  -- Cubical v0.5 reflection failure for a literal unit under multiplication.
  step : fst Rng → fst Rng → fst Rng
  step u x = x + u

  predict : fst Rng → fst Rng → fst Rng
  predict u y = y + square u

  after residual : fst Rng → fst Rng → fst Rng
  after u x = square (step u x)
  residual u x = after u x - predict u (square x)

  translation-residual :
    (u x : fst Rng) → residual u x ≡ (x · u) + (x · u)
  translation-residual = solve! Rng

  square-forgets-sign : (x : fst Rng) → square (- x) ≡ square x
  square-forgets-sign = solve! Rng

  residual-reverses-sign :
    (u x : fst Rng) → residual u (- x) ≡ - (residual u x)
  residual-reverses-sign = solve! Rng

------------------------------------------------------------------------
-- 3.  Checked one-shot event over the integers
------------------------------------------------------------------------

module IntegerFormationEvent where

  module S = SquareSuccessor ℤCommRing
  open CommRingStr (snd ℤCommRing) using (1r ; _+_ ; _·_ ; ·IdR)

  successor squarePredict squareAfter squareResidual : ℤ → ℤ
  successor x = S.step 1r x
  squarePredict y = S.predict 1r y
  squareAfter x = S.after 1r x
  squareResidual x = S.residual 1r x

  plusOne minusOne : ℤ
  plusOne  = pos 1
  minusOne = negsuc 0

  same-old-reading : S.square plusOne ≡ S.square minusOne
  same-old-reading = solve! ℤCommRing

  plus-residual : squareResidual plusOne ≡ pos 2
  plus-residual =
      S.translation-residual 1r plusOne
    ∙ cong₂ _+_ (·IdR plusOne) (·IdR plusOne)

  minus-residual : squareResidual minusOne ≡ negsuc 1
  minus-residual =
      S.translation-residual 1r minusOne
    ∙ cong₂ _+_ (·IdR minusOne) (·IdR minusOne)

  residuals-differ : ¬ (squareResidual plusOne ≡ squareResidual minusOne)
  residuals-differ h =
    posNotnegsuc 2 1 (sym plus-residual ∙ h ∙ minus-residual)

  square-residual-collision : AR.ActionCollision S.square squareResidual
  square-residual-collision =
    plusOne , minusOne , same-old-reading , residuals-differ

  module Formed = AR.ProductRefinement S.square squareResidual

  -- Executing successor once and comparing the old square observation with
  -- its declared prediction forms a strict observable refinement.
  executable-formation-event :
    AR.Refines Formed.joint S.square × SD.Reopens S.square Formed.joint
  executable-formation-event =
    Formed.collision-forces-strict-refinement square-residual-collision
