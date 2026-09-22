{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- साक्षिन् — the witness.  RECEIPTED ANSWERS COLLAPSE EVERY QUESTION
-- ALPHABET: FREEDOM LIVES ONLY IN THE UNWITNESSED EVENT.
--
-- Prashna proved the deterministic collapse for the trivial question
-- and showed a free event opens the space.  This file proves the
-- sharp general form of the collapse: for ANY question alphabet Q and
-- ANY answer function act : Machine → Q → Machine, the interactive
-- machine whose events are receipts,
--
--     E s q s'  =  (act s q ≡ s'),
--
-- has a contractible behavior space at every state
-- (`receipts-collapse`).  The environment may ask anything — steer
-- the head, choose among finitely or infinitely many probes — and
-- the space of everything the machine could be remains a single
-- point, because every answer carries the witness that it is THE
-- answer.  Interactivity of questions creates no indeterminacy;
-- Prashna's free-event countermodel shows indeterminacy the moment
-- the witness is dropped.  Together they characterize the boundary
-- exactly:
--
--     the behavior space is a point  ⟺  the event is a receipt,
--
-- with the forward direction proved here for every alphabet and the
-- failure exhibited in Prashna for the alphabet that needs only one
-- question.  Determinism is not the absence of questions; it is the
-- presence of witnesses.
------------------------------------------------------------------------

module Sakshin_ReceiptedAnswersCollapseEveryQuestionAlphabetSoFreedomLivesOnlyInTheUnwitnessedEvent where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Sigma
open import Cubical.Data.Unit using (Unit ; tt)

open import Vishvayantra_TheTuringStepIsTheVisibleProjectionOfTheLosslessStepAndTheKeptFibreIsTheSource
  using (Machine ; uStep)
open import Prashna_TheInteractiveMachineStrictlyContainsTheTuringMachineAndDeterminismIsExactlyTheCollapse
  using (ISC ; isSetMachine ; DetISC)
open ISC

------------------------------------------------------------------------
-- §1  The receipted machine over an arbitrary alphabet.
------------------------------------------------------------------------

module _ (Q : Type) (act : Machine → Q → Machine) where

  RecISC : Machine → Type
  RecISC = ISC Machine (λ _ → Q) (λ s q s' → act s q ≡ s')

  -- The canonical behavior: answer every question with the prescribed
  -- successor and the receipt refl.
  canonical : (s : Machine) → RecISC s
  respond (canonical s) q = act s q , refl , canonical (act s q)

  -- The coinductive spine: along any receipt, the canonical behavior
  -- deforms onto any behavior, question by question.
  uniqueP : (x s₁ : Machine) (p : x ≡ s₁) (e : RecISC s₁) →
    PathP (λ i → RecISC (p i)) (canonical x) e
  respond (uniqueP x s₁ p e i) q =
    σ i , sq i , uniqueP (act x q) b σ r i
    where
    b : Machine
    b = fst (respond e q)

    pe : act s₁ q ≡ b
    pe = fst (snd (respond e q))

    r : RecISC b
    r = snd (snd (respond e q))

    σ : act x q ≡ b
    σ = cong (λ y → act y q) p ∙ pe

    sq : PathP (λ i → act (p i) q ≡ σ i) refl pe
    sq = isSet→isSet' isSetMachine refl pe (cong (λ y → act y q) p) σ

  -- THE THEOREM.  Whatever the alphabet, receipted answers leave one
  -- behavior: the space is a point at every state.
  receipts-collapse : (s : Machine) → isContr (RecISC s)
  receipts-collapse s = canonical s , contract
    where
    contract : (e : RecISC s) → canonical s ≡ e
    respond (contract e i) q =
      pe i , (λ j → pe (i ∧ j)) , uniqueP (act s q) b pe r i
      where
      b : Machine
      b = fst (respond e q)

      pe : act s q ≡ b
      pe = fst (snd (respond e q))

      r : RecISC b
      r = snd (snd (respond e q))

------------------------------------------------------------------------
-- §2  Prashna's deterministic instance is the one-letter alphabet.
------------------------------------------------------------------------

det-is-one-letter : DetISC ≡ RecISC Unit (λ s _ → uStep s)
det-is-one-letter = refl
