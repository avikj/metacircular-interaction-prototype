{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- प्रश्न — the question.  THE MACHINE THAT ASKS: ITS RUN IS ITS ANSWER
-- STREAM, AND SILENCE OF QUESTIONS IS DETERMINISM.
--
-- Vishvayantra's śeṣa — the interactive generalisation — was
-- concluded once in Prashna, where the freedom lives in the EVENT
-- type: the ISC's respond chooses the successor, receipts collapse
-- the space, and the collapse's squares are filled by Machine being a
-- set.  This file is the śeṣa's other face, where the freedom lives
-- in the ANSWERS: the environment's answer determines the successor,
-- and the collapse comes out structural — no set-ness of the state
-- space is used anywhere, because of a theorem Prashna does not have:
--
-- An interaction on X is a family of questions Q : X → Type and an
-- answered step δ : (x : X) → Q x → X.  The guarded productive run
-- from x — a now, a receipt, an answer to x's question, a rest from
-- the answered successor — is `IExec`.  The environment's bare
-- contribution — an answer now, answers forever after — is `Answers`.
--
--   THEOREM (run-is-answers).   IExec I x ≃ Answers I x.
--
-- The history of an interactive run carries no information beyond the
-- answers the environment supplied: the state components are receipts,
-- and receipts are contractible.  This is the interactive face of
-- trace-is-fiber — what the run keeps beyond its answers is forced.
--
--   THEOREM (silence-is-determinism).  If every Q x is contractible,
--   IExec I x is contractible.
--
-- Determinism is not a side condition on steps; it is the statement
-- that the machine has nothing to ask.  The closed universal machine
-- is the interaction whose every question is trivial (`closed uStep`),
-- and Niyati's one-execution returns as an instance
-- (one-execution-again) — for the closed machine the whole space of
-- interactive runs is again a point.
--
-- The other direction — one genuine degree of freedom opens the
-- space — is already checked on the event flank, in Prashna's
-- interaction-is-strictly-wider, and is not repeated here.  What this
-- file adds is the measurement: in every case the space of histories
-- is exactly the space of answer streams — no more, no less.
------------------------------------------------------------------------

module Prasna_TheMachineThatAsksItsRunIsItsAnswerStreamAndSilenceOfQuestionsIsDeterminism where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Isomorphism
open import Cubical.Foundations.Equiv
open import Cubical.Foundations.HLevels using (isOfHLevelRespectEquiv)
open import Cubical.Data.Nat using (ℕ)
open import Cubical.Data.Unit using (Unit ; isContrUnit)

open import Vishvayantra_TheTuringStepIsTheVisibleProjectionOfTheLosslessStepAndTheKeptFibreIsTheSource
  using (Machine ; uStep)

private
  variable
    ℓ : Level

------------------------------------------------------------------------
-- §1  The machine that asks.
------------------------------------------------------------------------

-- An interaction: each state poses a question, and the step consumes
-- an answer.  The closed machine of Vishvayantra is the special case
-- where every question is trivial (§4).
record Interaction (X : Type ℓ) : Type (ℓ-suc ℓ) where
  field
    Q : X → Type ℓ
    δ : (x : X) → Q x → X
open Interaction

module _ {X : Type ℓ} (I : Interaction X) where

  -- The guarded productive run: a now, a receipt that now is the
  -- official state, an answer to its question, and a rest from the
  -- answered successor.  Total, guarded, --safe: an unbounded
  -- interaction is represented, never executed.
  record IExec (x : X) : Type ℓ where
    coinductive
    field
      now  : X
      here : now ≡ x
      ans  : Q I x
      next : IExec (δ I x ans)

  -- The environment's bare contribution: an answer now, and answers
  -- forever after.  No states, no receipts.
  record Answers (x : X) : Type ℓ where
    coinductive
    field
      ans  : Q I x
      more : Answers (δ I x ans)

------------------------------------------------------------------------
-- §2  THE THEOREM: the run is its answer stream.
--
-- Forgetting the states of a run leaves its answers; replaying the
-- answers rebuilds the run; and both round trips are paths, the run
-- side by the same ∨-square that collapses a receipt onto refl in
-- Niyati.  The state components of an interactive history are
-- receipts, and receipts weigh nothing.
------------------------------------------------------------------------

  forgetStates : {x : X} → IExec x → Answers x
  Answers.ans  (forgetStates e) = IExec.ans e
  Answers.more (forgetStates e) = forgetStates (IExec.next e)

  replay : (x : X) → Answers x → IExec x
  IExec.now  (replay x a) = x
  IExec.here (replay x a) = refl
  IExec.ans  (replay x a) = Answers.ans a
  IExec.next (replay x a) = replay (δ I x (Answers.ans a)) (Answers.more a)

  replay-forget : {x : X} (e : IExec x) → replay x (forgetStates e) ≡ e
  IExec.now  (replay-forget e i) = IExec.here e (~ i)
  IExec.here (replay-forget e i) = λ j → IExec.here e (~ i ∨ j)
  IExec.ans  (replay-forget e i) = IExec.ans e
  IExec.next (replay-forget e i) = replay-forget (IExec.next e) i

  forget-replay : {x : X} (a : Answers x) → forgetStates (replay x a) ≡ a
  Answers.ans  (forget-replay a i) = Answers.ans a
  Answers.more (forget-replay a i) = forget-replay (Answers.more a) i

  -- THE THEOREM.  The space of interactive histories from x is the
  -- space of answer streams from x.
  run-is-answers : (x : X) → IExec x ≃ Answers x
  run-is-answers x = isoToEquiv
    (iso forgetStates (replay x) forget-replay replay-forget)

------------------------------------------------------------------------
-- §3  Silence of questions is determinism.
--
-- If every question is contractible the environment has no real
-- choice, and the space of answer streams — hence of runs — is a
-- point.  The contraction is built coinductively OVER A PATH of
-- states: the answer components are collapsed by isProp→PathP, and
-- the tails follow along the line the answers draw.
------------------------------------------------------------------------

  module _ (Qc : (x : X) → isContr (Q I x)) where

    mute : (x : X) → Answers x
    Answers.ans  (mute x) = fst (Qc x)
    Answers.more (mute x) = mute (δ I x (fst (Qc x)))

    answers-unique : {x₀ x₁ : X} (p : x₀ ≡ x₁)
                     (a₀ : Answers x₀) (a₁ : Answers x₁)
                   → PathP (λ i → Answers (p i)) a₀ a₁
    Answers.ans  (answers-unique p a₀ a₁ i) =
      isProp→PathP (λ i → isContr→isProp (Qc (p i)))
                   (Answers.ans a₀) (Answers.ans a₁) i
    Answers.more (answers-unique p a₀ a₁ i) =
      answers-unique
        (λ i → δ I (p i)
                 (isProp→PathP (λ i → isContr→isProp (Qc (p i)))
                               (Answers.ans a₀) (Answers.ans a₁) i))
        (Answers.more a₀) (Answers.more a₁) i

    one-answer-stream : (x : X) → isContr (Answers x)
    one-answer-stream x = mute x , answers-unique refl (mute x)

    -- THE THEOREM.  Nothing to ask, nothing to choose: one history.
    silence-is-determinism : (x : X) → isContr (IExec x)
    silence-is-determinism x =
      isOfHLevelRespectEquiv 0 (invEquiv (run-is-answers x))
                             (one-answer-stream x)

------------------------------------------------------------------------
-- §4  The closed machine is the interaction with nothing to ask.
------------------------------------------------------------------------

closed : {X : Type} → (X → X) → Interaction X
closed f .Q _   = Unit
closed f .δ x _ = f x

-- The universal Turing machine, as the interaction whose every
-- question is trivial.
utm : Interaction Machine
utm = closed uStep

-- Niyati again, as an instance: the closed universal machine has
-- exactly one interactive execution.
one-execution-again : (mc : Machine) → isContr (IExec utm mc)
one-execution-again = silence-is-determinism utm (λ _ → isContrUnit)
