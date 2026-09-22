{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- प्रश्न — the question.  THE INTERACTIVE MACHINE STRICTLY CONTAINS THE
-- TURING MACHINE, AND DETERMINISM IS EXACTLY THE COLLAPSE.
--
-- The interactive symbolic computer, in its guarded coalgebraic form:
--
--   ISC S Q E s  has one field
--     respond : (q : Q s) → Σ s'. E s q s' × ISC S Q E s'
--
-- — at every state, for every question the environment can put, a
-- successor, a witness that the transition is the prescribed one, and
-- the rest of the unfolding.  This file places the universal Turing
-- machine inside it EXACTLY:
--
--  1. `turingISC` — the UTM is the instance with the trivial question
--     (Q s = Unit) and receipt events (E s q s' = uStep s ≡ s').  The
--     inclusion in the chain  UTM ⊆ deterministic ISC  is a
--     construction.
--
--  2. `deterministic-collapse` — at that instance the WHOLE SPACE of
--     interactive behaviors is contractible, at every state.  Not
--     merely "the machine is deterministic": the type of everything
--     the interactive machine could be, once questions are trivial
--     and events are receipts, is a point.  The contraction is built
--     coinductively; its side squares are filled by Machine being a
--     set.  Determinism is not a property added to the interactive
--     machine — it is what remains of interaction when the receipt
--     leaves the successor no room.
--
--  3. `interaction-is-strictly-wider` — with the same trivial
--     question but a FREE event (E s q s' = Unit: any successor,
--     trivially licensed), the behavior space is provably NOT
--     contractible: the machine that stands still and the machine
--     that steps are distinct inhabitants.  So the inclusion is
--     strict, and what makes it strict is measured exactly: the
--     event type.  Receipts collapse the space to a point; freedom
--     opens it.
--
--     UTM  =  deterministic ISC (a point)  ⊊  interactive ISC.
------------------------------------------------------------------------

module Prashna_TheInteractiveMachineStrictlyContainsTheTuringMachineAndDeterminismIsExactlyTheCollapse where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.HLevels using (isSetRetract ; isSet×)
open import Cubical.Data.Sigma
open import Cubical.Data.Nat using (ℕ ; zero ; suc ; isSetℕ ; znots)
open import Cubical.Data.List using (List ; [] ; _∷_)
open import Cubical.Data.List.Properties using (isOfHLevelList)
open import Cubical.Data.Unit using (Unit ; tt)
open import Cubical.Relation.Nullary using (¬_)
open import Cubical.Data.Empty as Empty using (⊥)

open import Vishvayantra_TheTuringStepIsTheVisibleProjectionOfTheLosslessStepAndTheKeptFibreIsTheSource
open import AnulomaViloma_TheTraceComposesTheCompletedRunRunsBackwardsByReflAndWhenTheMachineHaltsIsAProposition
  using (isSetConf)
open import Vrddhi_AVerifiedProgramTheSuccessorMachineAddsOneStrokeAndItsCertificateIsAFibrePoint
  using (incr ; unary)

------------------------------------------------------------------------
-- §0  Machine is a set (needed to fill the contraction's squares).
------------------------------------------------------------------------

private
  encodeMove : Move → ℕ
  encodeMove left  = 0
  encodeMove right = 1
  encodeMove stay  = 2

  decodeMove : ℕ → Move
  decodeMove zero             = left
  decodeMove (suc zero)       = right
  decodeMove (suc (suc _))    = stay

  isSetMove : isSet Move
  isSetMove = isSetRetract encodeMove decodeMove de isSetℕ
    where
    de : (m : Move) → decodeMove (encodeMove m) ≡ m
    de left  = refl
    de right = refl
    de stay  = refl

  isSetRule : isSet Rule
  isSetRule =
    isSet× isSetℕ (isSet× isSetℕ (isSet× isSetℕ (isSet× isSetℕ isSetMove)))

isSetMachine : isSet Machine
isSetMachine = isSet× (isOfHLevelList 0 isSetRule) isSetConf

------------------------------------------------------------------------
-- §1  The interactive machine.
------------------------------------------------------------------------

record ISC {ℓ : Level} (S : Type ℓ) (Q : S → Type ℓ)
           (E : (s : S) → Q s → S → Type ℓ) (s : S) : Type ℓ where
  coinductive
  field
    respond : (q : Q s) → Σ[ s' ∈ S ] (E s q s' × ISC S Q E s')
open ISC

------------------------------------------------------------------------
-- §2  The deterministic instance: trivial question, receipt event.
------------------------------------------------------------------------

DetISC : Machine → Type
DetISC = ISC Machine (λ _ → Unit) (λ s _ s' → uStep s ≡ s')

-- The UTM, as an interactive machine: answer the one question with
-- the stepped state and the receipt refl.
turingISC : (mc : Machine) → DetISC mc
respond (turingISC mc) _ = uStep mc , refl , turingISC (uStep mc)

-- The coinductive spine of the contraction: along any receipt out of
-- uStep s₀, the canonical behavior deforms onto any behavior.
uniqueP : (s₀ s₁ : Machine) (p : uStep s₀ ≡ s₁) (e : DetISC s₁) →
  PathP (λ i → DetISC (p i)) (turingISC (uStep s₀)) e
respond (uniqueP s₀ s₁ p e i) tt =
  σ i , sq i , uniqueP (uStep s₀) b σ r i
  where
  b : Machine
  b = fst (respond e tt)

  q : uStep s₁ ≡ b
  q = fst (snd (respond e tt))

  r : DetISC b
  r = snd (snd (respond e tt))

  σ : uStep (uStep s₀) ≡ b
  σ = cong uStep p ∙ q

  sq : PathP (λ i → uStep (p i) ≡ σ i) refl q
  sq = isSet→isSet' isSetMachine refl q (cong uStep p) σ

-- THE COLLAPSE.  Once the event is a receipt, the space of
-- interactive behaviors is a point, at every state: determinism is
-- contractibility of the whole instance, and the UTM is its centre.
deterministic-collapse : (mc : Machine) → isContr (DetISC mc)
deterministic-collapse mc = turingISC mc , contract
  where
  contract : (e : DetISC mc) → turingISC mc ≡ e
  respond (contract e i) tt =
    p i , (λ j → p (i ∧ j)) , uniqueP mc b p r i
    where
    b : Machine
    b = fst (respond e tt)

    p : uStep mc ≡ b
    p = fst (snd (respond e tt))

    r : DetISC b
    r = snd (snd (respond e tt))

------------------------------------------------------------------------
-- §3  Freedom opens the space: the inclusion is strict.
------------------------------------------------------------------------

-- The same trivial question, but any successor is licensed.
FreeISC : Machine → Type
FreeISC = ISC Machine (λ _ → Unit) (λ _ _ _ → Unit)

-- Two behaviors: stand still forever, or run the machine.
stayer : (mc : Machine) → FreeISC mc
respond (stayer mc) _ = mc , tt , stayer mc

stepper : (mc : Machine) → FreeISC mc
respond (stepper mc) _ = uStep mc , tt , stepper (uStep mc)

-- At a configuration the step genuinely moves, they differ — so the
-- free instance is NOT contractible, and the deterministic collapse
-- was the event type's doing, not the shape's.
interaction-is-strictly-wider : ¬ isContr (FreeISC (incr , unary 0))
interaction-is-strictly-wider c =
  znots (cong (λ e → fst (snd (fst (respond e tt))))
              (isContr→isProp c (stayer s₀) (stepper s₀)))
  where
  s₀ : Machine
  s₀ = incr , unary 0
