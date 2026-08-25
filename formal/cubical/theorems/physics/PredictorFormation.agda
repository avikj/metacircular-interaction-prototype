{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- PredictorFormation
--
-- The first exact closure question after forming a one-step action
-- residual.  For an observation q and installed action step, the residual
-- carrier is reversibly equivalent to the two-reading window
--
--                   window₁ x = (q x , q (step x)).
--
-- A predictor on this carrier exists exactly when the third reading
-- q(step(step x)) descends through window₁.  Hence a same-window/different-
-- third collision is an exact no-go certificate, and adjoining the third
-- reading is the minimal conservative repair.
--
-- The four-state cyclic successor clock makes the event executable.  The
-- first two readings of states one and two agree, while their third readings
-- differ, so no two-reading predictor exists.  The three-reading carrier
-- reconstructs every state by an explicit decoder and therefore carries an
-- exact next-state predictor.  The newly admitted reading changes what can
-- be executed next.
--
-- Finite observation windows and Moore/Nerode refinement are standard.  The
-- local complete future quotient is already checked in FutureBehavior.agda;
-- this module isolates the first stabilization obstruction and connects it
-- to ActionResidual.agda.  No novelty is claimed.
------------------------------------------------------------------------

module PredictorFormation where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Function using (_∘_)
open import Cubical.Data.Bool using (Bool ; false ; true ; false≢true)
open import Cubical.Data.Nat using (ℕ ; zero ; suc)
open import Cubical.Data.Sigma
  using (_×_ ; Σ-syntax ; _,_ ; fst ; snd ; ΣPathP)
open import Cubical.Relation.Nullary using (¬_)

import ActionRefinement as AR
import StructuredDefect as SD

private
  variable
    ℓx ℓo : Level

------------------------------------------------------------------------
-- 1. Closure is invariant under reversible observable re-coordination
------------------------------------------------------------------------

Closure : {X : Type ℓx} {O : Type ℓo}
        → (carrier : X → O) → (step : X → X) → Type _
Closure carrier step = AR.Refines carrier (carrier ∘ step)

-- If two carriers determine each other on their realized images, an action
-- predictor on either carrier transports to the other.  In particular the
-- behavior and residual coordinates of ActionResidual succeed or fail
-- together; choosing a defect origin cannot manufacture closure.
closure-under-mutual-refinement :
  {X : Type ℓx} {A B : Type ℓo}
  (a : X → A) (b : X → B) (step : X → X)
  → AR.Refines a b
  → AR.Refines b a
  → Closure a step
  → Closure b step
closure-under-mutual-refinement a b step
  (readB , replayB) (readA , replayA) (nextA , closeA) =
  (readB ∘ nextA ∘ readA) , λ x →
      cong (readB ∘ nextA) (replayA x)
    ∙ cong readB (closeA x)
    ∙ replayB (step x)

------------------------------------------------------------------------
-- 2. The third reading is exactly the two-window predictor obstruction
------------------------------------------------------------------------

module Window
  {X : Type ℓx} {O : Type ℓo}
  (q : X → O) (step : X → X) where

  after thirdReading : X → O
  after x = q (step x)
  firstWindow : X → O × O
  firstWindow x = q x , after x
  thirdReading x = q (step (step x))

  advancedWindow : X → O × O
  advancedWindow = firstWindow ∘ step

  Predictor : Type _
  Predictor = Closure firstWindow step

  ThirdDescent : Type _
  ThirdDescent = AR.Refines firstWindow thirdReading

  -- Reading the old window after one step needs no new first coordinate:
  -- it is already the second coordinate of the current window.  Therefore
  -- precisely one datum remains, the third reading.
  third-descent→predictor : ThirdDescent → Predictor
  third-descent→predictor (readThird , replayThird) =
    (λ z → snd z , readThird z) ,
    λ x → ΣPathP (refl , replayThird x)

  -- Conversely every predictor exposes the third reading by projecting its
  -- second output coordinate.  These maps prove the iff without any section,
  -- surjectivity, finiteness, or choice hypothesis.
  predictor→third-descent : Predictor → ThirdDescent
  predictor→third-descent (predict , replay) =
    (snd ∘ predict) , λ x → cong snd (replay x)

  predictor-iff-third-descent :
    (ThirdDescent → Predictor) × (Predictor → ThirdDescent)
  predictor-iff-third-descent =
    third-descent→predictor , predictor→third-descent

  ThirdCollision : Type _
  ThirdCollision = AR.ActionCollision firstWindow thirdReading

  -- A single collision is a proof that no predictor on the current carrier
  -- can close.  The obstruction is the unread response, not a failed search
  -- through a space of guessed predictors.
  collision-obstructs-predictor : ThirdCollision → ¬ Predictor
  collision-obstructs-predictor collision predictor =
    SD.separatedPair→reopens firstWindow thirdReading collision
      (predictor→third-descent predictor)

  -- The forced repair retains the old window and adjoins exactly the reading
  -- that failed to descend.
  repairedWindow : X → (O × O) × O
  repairedWindow x = firstWindow x , thirdReading x

  module Repair = AR.ProductRefinement firstWindow thirdReading

  collision-forces-repair :
    ThirdCollision
    → AR.Refines repairedWindow firstWindow
      × SD.Reopens firstWindow repairedWindow
  collision-forces-repair = Repair.collision-forces-strict-refinement

  -- Universally, the repair already predicts the previous two-reading
  -- window after one action.  Predicting the whole repaired window may need
  -- a fourth reading; the clock below is an exact finite stabilization where
  -- no fourth coordinate is needed.
  repaired-predicts-advanced-window :
    AR.Refines repairedWindow advancedWindow
  repaired-predicts-advanced-window =
    (λ z → snd (fst z) , snd z) , λ _ → refl

------------------------------------------------------------------------
-- 3. Every finite horizon has the same exact obstruction
------------------------------------------------------------------------

module FiniteWindows
  {X : Type ℓx} {O : Type ℓo}
  (q : X → O) (step : X → X) where

  iterate : ℕ → X → X
  iterate zero    x = x
  iterate (suc n) x = iterate n (step x)

  reading : ℕ → X → O
  reading n x = q (iterate n x)

  -- A left-associated exact prefix carrier:
  --
  --   WindowCode 0       = O
  --   WindowCode (n + 1) = WindowCode n × O.
  --
  -- Thus window n contains readings 0 through n, inclusive.
  WindowCode : ℕ → Type ℓo
  WindowCode zero    = O
  WindowCode (suc n) = WindowCode n × O

  window : (n : ℕ) → X → WindowCode n
  window zero    x = reading zero x
  window (suc n) x = window n x , reading (suc n) x

  nextReading : (n : ℕ) → X → O
  nextReading n = reading (suc n)

  -- Shift a prefix one action forward after supplying its single new final
  -- reading.  This operation is structural; it does not inspect X.
  shift : (n : ℕ) → WindowCode n → O → WindowCode n
  shift zero    _          next = next
  shift (suc n) (prefix , latest) next =
    shift n prefix latest , next

  last : (n : ℕ) → WindowCode n → O
  last zero    z       = z
  last (suc _) (_ , z) = z

  last-window :
    (n : ℕ) (x : X) → last n (window n x) ≡ reading n x
  last-window zero    x = refl
  last-window (suc n) x = refl

  shift-window :
    (n : ℕ) (x : X)
    → shift n (window n x) (nextReading n x) ≡ window n (step x)
  shift-window zero    x = refl
  shift-window (suc n) x =
    ΣPathP (shift-window n x , refl)

  PredictorAt : ℕ → Type _
  PredictorAt n = Closure (window n) step

  NextDescentAt : ℕ → Type _
  NextDescentAt n = AR.Refines (window n) (nextReading n)

  next-descent→predictor :
    (n : ℕ) → NextDescentAt n → PredictorAt n
  next-descent→predictor n (readNext , replayNext) =
    (λ z → shift n z (readNext z)) , λ x →
        cong (shift n (window n x)) (replayNext x)
      ∙ shift-window n x

  predictor→next-descent :
    (n : ℕ) → PredictorAt n → NextDescentAt n
  predictor→next-descent n (predict , replay) =
    (last n ∘ predict) , λ x →
        cong (last n) (replay x)
      ∙ last-window n (step x)

  predictor-iff-next-descent :
    (n : ℕ)
    → (NextDescentAt n → PredictorAt n)
      × (PredictorAt n → NextDescentAt n)
  predictor-iff-next-descent n =
    next-descent→predictor n , predictor→next-descent n

  -- Once one prefix predicts itself, every longer prefix does too.  The
  -- second application of the old predictor supplies the one new reading
  -- needed by the extended window.  Thus closure, once reached, persists;
  -- any least closing horizon is a genuine stabilization frontier.
  predictor-persists :
    (n : ℕ) → PredictorAt n → PredictorAt (suc n)
  predictor-persists n oldPredictor@(predict , replay) =
    next-descent→predictor (suc n)
      ( (λ z → last n (predict (predict (fst z))))
      , λ x →
          cong (last n ∘ predict) (replay x)
        ∙ cong (last n) (replay (step x))
        ∙ last-window n (step (step x)) )

  -- An explicit decoder of state from a window is sufficient to compile its
  -- action update.  This is the constructive datum used by the clock below;
  -- bare injectivity without a supplied decoder would not define a program.
  StateDecoderAt : (n : ℕ) → Type _
  StateDecoderAt n =
    Σ[ decode ∈ (WindowCode n → X) ]
      ((x : X) → decode (window n x) ≡ x)

  state-reconstruction→predictor :
    (n : ℕ) → StateDecoderAt n → PredictorAt n
  state-reconstruction→predictor n (decode , replay) =
    (window n ∘ step ∘ decode) , λ x →
      cong (window n ∘ step) (replay x)

  NextCollisionAt : ℕ → Type _
  NextCollisionAt n = AR.ActionCollision (window n) (nextReading n)

  collision-obstructs-predictor-at :
    (n : ℕ) → NextCollisionAt n → ¬ PredictorAt n
  collision-obstructs-predictor-at n collision predictor =
    SD.separatedPair→reopens (window n) (nextReading n) collision
      (predictor→next-descent n predictor)

  repairedWindow : (n : ℕ) → X → WindowCode n × O
  repairedWindow n x = window n x , nextReading n x

  -- This is definitionally the next prefix window.  The equality records
  -- that adjoining the obstruction does not create a parallel hierarchy.
  repair-is-next-window :
    (n : ℕ) (x : X) → repairedWindow n x ≡ window (suc n) x
  repair-is-next-window n x = refl

  module RepairAt (n : ℕ) =
    AR.ProductRefinement (window n) (nextReading n)

  collision-forces-next-window :
    (n : ℕ) → NextCollisionAt n
    → AR.Refines (window (suc n)) (window n)
      × SD.Reopens (window n) (window (suc n))
  collision-forces-next-window n =
    RepairAt.collision-forces-strict-refinement n

------------------------------------------------------------------------
-- 4. Exact formation event: cyclic successor modulo four
------------------------------------------------------------------------

data Four : Type₀ where
  zero₄ one₄ two₄ three₄ : Four

successor₄ : Four → Four
successor₄ zero₄  = one₄
successor₄ one₄   = two₄
successor₄ two₄   = three₄
successor₄ three₄ = zero₄

isZero₄ : Four → Bool
isZero₄ zero₄  = true
isZero₄ one₄   = false
isZero₄ two₄   = false
isZero₄ three₄ = false

module Clock = Window isZero₄ successor₄

-- State one reads 0,0,0 while state two reads 0,0,1.  Their current
-- two-reading windows coincide, but the next unread response separates them.
clock-third-collision : Clock.ThirdCollision
clock-third-collision = one₄ , two₄ , refl , false≢true

clock-two-reading-no-predictor : ¬ Clock.Predictor
clock-two-reading-no-predictor =
  Clock.collision-obstructs-predictor clock-third-collision

clock-repair-is-strict :
  AR.Refines Clock.repairedWindow Clock.firstWindow
  × SD.Reopens Clock.firstWindow Clock.repairedWindow
clock-repair-is-strict =
  Clock.collision-forces-repair clock-third-collision

-- Explicit reconstruction from the three observed bits.  Values off the
-- realized image are assigned harmless defaults; the replay proof below says
-- exactly that no hidden state oracle is used on any reachable reading.
decodeClock : (Bool × Bool) × Bool → Four
decodeClock ((true  , _)     , _)     = zero₄
decodeClock ((false , true)  , _)     = three₄
decodeClock ((false , false) , true)  = two₄
decodeClock ((false , false) , false) = one₄

decodeClock-replay :
  (x : Four) → decodeClock (Clock.repairedWindow x) ≡ x
decodeClock-replay zero₄  = refl
decodeClock-replay one₄   = refl
decodeClock-replay two₄   = refl
decodeClock-replay three₄ = refl

clock-three-readings-reconstruct-state :
  AR.Refines Clock.repairedWindow (λ x → x)
clock-three-readings-reconstruct-state = decodeClock , decodeClock-replay

-- The formation event changes the executable frontier.  Before adjoining
-- the third reading, every predictor is refuted above.  Afterwards this
-- concrete decoder compiles the next repaired reading exactly.
clock-three-reading-predictor : Closure Clock.repairedWindow successor₄
clock-three-reading-predictor =
  (Clock.repairedWindow ∘ successor₄ ∘ decodeClock) , λ x →
    cong (Clock.repairedWindow ∘ successor₄) (decodeClock-replay x)
