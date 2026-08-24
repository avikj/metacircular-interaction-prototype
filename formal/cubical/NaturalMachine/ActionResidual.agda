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
  using (ℤ ; pos ; negsuc ; posNotnegsuc ; injPos ; sucℤ· ; ·lCancel)
open import Cubical.Data.Nat using (ℕ ; zero ; suc ; snotz)
open import Cubical.Algebra.AbGroup.Base
  using (AbGroup ; AbGroupStr ; AbGroup→Group)
open import Cubical.Algebra.Group.Properties using (module GroupTheory)
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
  open GroupTheory (AbGroup→Group A) using (·CancelL)

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

  ----------------------------------------------------------------------
  -- Composition: exactly when the one-shot residual becomes an update
  ----------------------------------------------------------------------

  after² residual² : X → ⟨ A ⟩
  after² x = q (step (step x))
  residual² x = after² x - predict (predict (q x))

  -- The only predictor law needed by the two-step calculation.  Global
  -- additivity is sufficient but stronger: this law asks preservation only
  -- on the subtraction pair actually realized at x.
  PreservesRealizedResidual : X → Type ℓa
  PreservesRealizedResidual x =
    predict (residual x)
      ≡ predict (after x) - predict (predict (q x))

  TwoStepCocycle : X → Type ℓa
  TwoStepCocycle x =
    residual² x ≡ residual (step x) + predict (residual x)

  private
    telescope : (a b c : ⟨ A ⟩) → (a - b) + (b - c) ≡ a - c
    telescope a b c =
        +Assoc (a - b) b (- c)
      ∙ cong (_+ (- c)) (subAddRight a b)

    residual²-expansion : (x : X)
      → residual² x
        ≡ residual (step x)
          + (predict (after x) - predict (predict (q x)))
    residual²-expansion x =
      sym (telescope (after² x)
                     (predict (after x))
                     (predict (predict (q x))))

  -- Sufficiency: a local residual emitted at each encounter updates the
  -- two-step defect without reopening the original hidden state.
  preservation→two-step-cocycle :
    (x : X) → PreservesRealizedResidual x → TwoStepCocycle x
  preservation→two-step-cocycle x preserves =
      residual²-expansion x
    ∙ cong (residual (step x) +_) (sym preserves)

  -- Necessity: the cocycle update cannot hold accidentally.  Comparing it
  -- with the unconditional telescoping expansion and cancelling the common
  -- next residual forces precisely the realized preservation equation.
  two-step-cocycle→preservation :
    (x : X) → TwoStepCocycle x → PreservesRealizedResidual x
  two-step-cocycle→preservation x cocycle =
    ·CancelL (residual (step x))
      (sym cocycle ∙ residual²-expansion x)

  -- Exact boundary: no global homomorphism, surjectivity, or state recovery
  -- is hidden in the statement.
  two-step-cocycle-iff-realized-preservation : (x : X)
    → (PreservesRealizedResidual x → TwoStepCocycle x)
      × (TwoStepCocycle x → PreservesRealizedResidual x)
  two-step-cocycle-iff-realized-preservation x =
    preservation→two-step-cocycle x , two-step-cocycle→preservation x

  -- A global subtraction law is stronger than the exact two-step boundary,
  -- but it is precisely what compiles every finite iterate into a streaming
  -- fold of local residuals.
  module CompiledIteration
    (predict-sub : (a b : ⟨ A ⟩)
                 → predict (a - b) ≡ predict a - predict b)
    where

    iterate : ℕ → X → X
    iterate zero    x = x
    iterate (suc n) x = step (iterate n x)

    predictIterate : ℕ → ⟨ A ⟩ → ⟨ A ⟩
    predictIterate zero    y = y
    predictIterate (suc n) y = predict (predictIterate n y)

    globalResidual : ℕ → X → ⟨ A ⟩
    globalResidual n x =
      q (iterate n x) - predictIterate n (q x)

    -- Executable update: receive the next local residual, then update the
    -- accumulated defect entirely in the old observable codomain.
    compiledResidual : ℕ → X → ⟨ A ⟩
    compiledResidual zero    x = 0g
    compiledResidual (suc n) x =
      residual (iterate n x) + predict (compiledResidual n x)

    globalResidual-step : (n : ℕ) (x : X)
      → globalResidual (suc n) x
        ≡ residual (iterate n x) + predict (globalResidual n x)
    globalResidual-step n x =
        sym (telescope (q (step (iterate n x)))
                       (predict (q (iterate n x)))
                       (predict (predictIterate n (q x))))
      ∙ cong (residual (iterate n x) +_)
          (sym (predict-sub (q (iterate n x))
                            (predictIterate n (q x))))

    -- Proof compilation: the streaming fold is extensionally the exact
    -- n-step failure of equivariance for every finite n.
    compiledResidual-sound :
      (n : ℕ) (x : X) → globalResidual n x ≡ compiledResidual n x
    compiledResidual-sound zero x = +InvR (q x)
    compiledResidual-sound (suc n) x =
        globalResidual-step n x
      ∙ cong (residual (iterate n x) +_)
          (cong predict (compiledResidual-sound n x))

------------------------------------------------------------------------
-- 2.  Translation supplies a predictor without an external choice
------------------------------------------------------------------------

-- For a pointed additive action language, the standard reduced cross-effect
-- chooses the predictor from q itself.  Translation by u should contribute
-- the already measurable increment q(u)-q(0); whatever remains is the mixed
-- term.  This is the Eilenberg--Mac Lane cross-effect in residual coordinates.
module TranslationCrossEffect
  {ℓb ℓa : Level}
  (B : AbGroup ℓb)
  (A : AbGroup ℓa)
  (q : ⟨ B ⟩ → ⟨ A ⟩)
  where

  open AbGroupStr (snd B)
    renaming (_+_ to _+B_ ; 0g to 0B)
    using ()
  open AbGroupStr (snd A)
    renaming (_+_ to _+A_ ; _-_ to _-A_)
    using ()

  translate : ⟨ B ⟩ → ⟨ B ⟩ → ⟨ B ⟩
  translate u x = x +B u

  translationPredict : ⟨ B ⟩ → ⟨ A ⟩ → ⟨ A ⟩
  translationPredict u y = y +A (q u -A q 0B)

  crossEffect : ⟨ B ⟩ → ⟨ B ⟩ → ⟨ A ⟩
  crossEffect u x = q (translate u x) -A translationPredict u (q x)

  module Coordinate (u : ⟨ B ⟩) =
    DefectCoordinate A q (translate u) (translationPredict u)

  -- Hence every decoder, zero criterion, and strict-formation theorem in §1
  -- applies to the cross-effect with no separately chosen predictor.
  crossEffect-is-coordinate :
    (u x : ⟨ B ⟩) → crossEffect u x ≡ Coordinate.residual u x
  crossEffect-is-coordinate u x = refl

------------------------------------------------------------------------
-- 3.  Elementary arithmetic: square under successor forms `2x`
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

  private
    translation-residual-direct :
      (u x : fst Rng)
      → ((x + u) · (x + u)) - ((x · x) + (u · u))
        ≡ (x · u) + (x · u)
    translation-residual-direct u x = solve! Rng

  translation-residual :
    (u x : fst Rng) → residual u x ≡ (x · u) + (x · u)
  translation-residual u x = translation-residual-direct u x

  square-forgets-sign : (x : fst Rng) → square (- x) ≡ square x
  square-forgets-sign x = square-forgets-sign-direct x
    where
    square-forgets-sign-direct : (x : fst Rng) → (- x) · (- x) ≡ x · x
    square-forgets-sign-direct x = solve! Rng

  residual-reverses-sign :
    (u x : fst Rng) → residual u (- x) ≡ - (residual u x)
  residual-reverses-sign u x = residual-reverses-sign-direct u x
    where
    residual-reverses-sign-direct :
      (u x : fst Rng)
      → (((- x) + u) · ((- x) + u))
          - (((- x) · (- x)) + (u · u))
        ≡ - (((x + u) · (x + u)) - ((x · x) + (u · u)))
    residual-reverses-sign-direct u x = solve! Rng

------------------------------------------------------------------------
-- 4.  Checked one-shot event over the integers
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
  same-old-reading = sym (S.square-forgets-sign plusOne)

  plus-residual : squareResidual plusOne ≡ pos 2
  plus-residual =
      S.translation-residual 1r plusOne
    ∙ cong₂ _+_ (·IdR plusOne) (·IdR plusOne)

  minus-residual : squareResidual minusOne ≡ negsuc 1
  minus-residual =
      S.translation-residual 1r minusOne
    ∙ cong₂ _+_ (·IdR minusOne) (·IdR minusOne)

  residual-is-double : (x : ℤ) → squareResidual x ≡ pos 2 · x
  residual-is-double x =
      S.translation-residual 1r x
    ∙ cong₂ _+_ (·IdR x) (·IdR x)
    ∙ sym (sucℤ· plusOne x)

  two≢zero : ¬ (pos 2 ≡ pos 0)
  two≢zero h = snotz (injPos h)

  -- The changed frontier is stronger than splitting one sign orbit: over ℤ
  -- the formed residual alone is faithful.  The proof uses torsion-freeness
  -- exactly once, as cancellation of multiplication by 2.
  residual-injective :
    (x y : ℤ) → squareResidual x ≡ squareResidual y → x ≡ y
  residual-injective x y h =
    ·lCancel (pos 2) x y
      (sym (residual-is-double x) ∙ h ∙ residual-is-double y)
      two≢zero

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
