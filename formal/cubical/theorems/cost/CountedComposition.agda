{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- Sequential composition of counted execution.
--
-- `CountedExecution.run` iterates a step map under a tick count, but the
-- corpus so far only relates single ticks (`run-suc`) and whole executions
-- to other whole executions (`compile`).  The missing law is the one the
-- acceptance test actually needs: counted time composes additively along
-- sequential execution.  Running for m + n ticks is running for n ticks and
-- then resuming the machine, from the very state it reached, for m more.
-- This is what makes a tick count a *cost*: segments of work concatenate,
-- and no ticks are created or destroyed at a checkpoint.
--
-- `run-+` below is proved by induction on the resumed segment; it is not
-- definitional for a variable segment length.  `run-split²` derives the
-- three-segment coherence, and the `Odometer` section instantiates the law
-- on the already-checked positional-numeral machine: the digit encoder at
-- m + n is exactly the carry machine resumed from the checkpoint word
-- digitsC n, and decoding the resumed state restores the composed count.
------------------------------------------------------------------------

module CountedComposition where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (ℕ ; zero ; suc ; _+_)

open import CountedExecution using (run)

import Digits
import Transport
import CountedDigits

private
  variable
    S : Type₀

-- Counted time composes along sequential execution.  The n-tick prefix runs
-- first; the m-tick continuation resumes from the reached state.
run-+ : (seed : S) (step : S → S) (m n : ℕ)
      → run seed step (m + n) ≡ run (run seed step n) step m
run-+ seed step zero    n = refl
run-+ seed step (suc m) n = cong step (run-+ seed step m n)

-- Three sequential segments compose coherently: splitting (l + m) + n at the
-- first checkpoint and then splitting the continuation agrees with running
-- the two inner segments in order.  Both parenthesisations of the schedule
-- reach one and the same state, so a cost ledger kept per segment is sound.
run-split² : (seed : S) (step : S → S) (l m n : ℕ)
           → run seed step ((l + m) + n)
           ≡ run (run (run seed step n) step m) step l
run-split² seed step l m n =
    run-+ seed step (l + m) n
  ∙ run-+ (run seed step n) step l m

------------------------------------------------------------------------
-- Instantiation on the checked positional-numeral machine.  This closes the
-- resumption edge left open by `CountedDigits`: that module executes only
-- from the zero word, so nothing there says a computation may be suspended
-- at an arbitrary checkpoint and resumed without recounting the prefix.
------------------------------------------------------------------------

module Odometer (k : ℕ) where

  open Digits k
    using (CanWord ; digitsC ; valueC ; value-digits)
  open Transport k using (sucC)
  open CountedDigits k using (run-is-digitsC)

  -- Checkpoint/resume for the schoolbook carry machine: encoding m + n is
  -- the counted execution resumed from the checkpoint word digitsC n for m
  -- further carry transitions.  The prefix is never re-executed.
  digitsC-resume : (m n : ℕ) → digitsC (m + n) ≡ run (digitsC n) sucC m
  digitsC-resume m n =
      sym (run-is-digitsC (m + n))
    ∙ run-+ (digitsC zero) sucC m n
    ∙ cong (λ state → run state sucC m) (run-is-digitsC n)

  -- Decoding the resumed execution restores the composed count: across a
  -- checkpoint the machine neither loses nor manufactures ticks.
  observe-resume : (m n : ℕ) → valueC (run (digitsC n) sucC m) ≡ m + n
  observe-resume m n =
    cong valueC (sym (digitsC-resume m n)) ∙ value-digits (m + n)
