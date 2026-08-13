{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- The acceptance test, as one checked term.
--
-- North Star (Vajra's proof-relevant compiler): adding ONE theorem makes
-- a task compile to a strictly better program, replayably — or the
-- theorem is an archive.  This module lands one complete instance.
--
-- Task.  Produce the canonical base-(2+k) digit word of m + n, given
-- that the checkpoint word `digitsC n` has already been computed.
--
-- Programs are DATA, not meta-level observations: `Plan` is a two-
-- constructor inductive type of execution plans, `cost` reads off the
-- number of carry-machine ticks a plan schedules, and `exec` runs it on
-- the already-checked positional-numeral machine.
--
--   restart m n : ignore the checkpoint; tick m + n times from the zero
--                 word.  Cost m + n.
--   resume  m n : resume the carry machine from the checkpoint word
--                 digitsC n for m further ticks.  Cost m.
--
-- The ONE theorem is T = `digitsC-resume` (CountedComposition, via
-- `run-+`): digitsC (m + n) ≡ run (digitsC n) sucC m.  Without T the
-- resumed plan is a perfectly well-formed program whose *correctness is
-- unprovable*: for variable m the equation is not definitional (`run`
-- computes on the count, and m + n does not reduce past m's variable
-- spine), and nothing else in the corpus relates an execution started at
-- an arbitrary checkpoint to one started at zero.  `replay` below is
-- exactly one application of T composed with the instantiation theorem
-- `run-is-digitsC`; delete T and `replay` has no proof, hence no
-- `betterProgram`.
--
-- The closing term packages the acceptance test:
--
--   betterProgram m n :
--       (exec (resume m (suc n)) ≡ exec (restart m (suc n)))
--     × (cost (resume m (suc n)) < cost (restart m (suc n)))
--
-- i.e. on the whole nonempty range { (m , n′) : n′ = suc n } — every
-- input whose checkpoint holds at least one tick of prior work — the
-- resumed plan computes the SAME answer (replay) at STRICTLY smaller
-- counted cost.  Both components are closed proofs; nothing is measured.
------------------------------------------------------------------------

open import Cubical.Data.Nat using (ℕ)

module NaturalMachine.AcceptanceTest (k : ℕ) where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (zero ; suc ; _+_ ; +-suc ; +-comm)
open import Cubical.Data.Nat.Order using (_<_)
open import Cubical.Data.Sigma using (_×_)

open import NaturalMachine.Digits k using (CanWord ; digitsC ; valueC)
open import NaturalMachine.Transport k using (sucC)
open import NaturalMachine.CountedExecution using (run)
open import NaturalMachine.CountedDigits k using (run-is-digitsC)
import NaturalMachine.CountedComposition
open NaturalMachine.CountedComposition.Odometer k
  using (digitsC-resume ; observe-resume)

------------------------------------------------------------------------
-- Programs as data.  Cost is intrinsic to the plan, not observed.
------------------------------------------------------------------------

data Plan : Type₀ where
  restart : (m n : ℕ) → Plan   -- naive: recount the full history from zero
  resume  : (m n : ℕ) → Plan   -- improved: resume from checkpoint digitsC n

-- The counted cost of a plan: how many sucC ticks it schedules.
cost : Plan → ℕ
cost (restart m n) = m + n
cost (resume  m n) = m

-- Executing a plan on the checked carry machine.
exec : Plan → CanWord
exec (restart m n) = run (digitsC zero) sucC (m + n)
exec (resume  m n) = run (digitsC n)    sucC m

------------------------------------------------------------------------
-- REPLAY.  The improved plan computes the same digit word.  The proof is
-- pinned to the one theorem T = digitsC-resume: it is the only edge in
-- the corpus from a checkpoint-seeded execution back to the zero-seeded
-- one.  `run-is-digitsC` merely renames the naive side.
------------------------------------------------------------------------

replay : (m n : ℕ) → exec (resume m n) ≡ exec (restart m n)
replay m n = sym (digitsC-resume m n)        -- T, the one added theorem
           ∙ sym (run-is-digitsC (m + n))

-- Sanity of the task itself: the shared answer decodes to m + n.
replay-observed : (m n : ℕ) → valueC (exec (resume m n)) ≡ m + n
replay-observed = observe-resume

------------------------------------------------------------------------
-- STRICTLY BETTER.  On every input with a nonempty checkpoint (n = suc
-- n′), the resumed plan is strictly cheaper: m < m + suc n′.  The
-- witness is closed-form — the gap is exactly the checkpointed prefix.
------------------------------------------------------------------------

resume-cheaper : (m n : ℕ) → cost (resume m (suc n)) < cost (restart m (suc n))
resume-cheaper m n =
  n , (+-suc n m ∙ cong suc (+-comm n m) ∙ sym (+-suc m n))

------------------------------------------------------------------------
-- The acceptance test as one term: same answer, strictly smaller cost,
-- for all m and all nonempty checkpoints suc n.
------------------------------------------------------------------------

betterProgram : (m n : ℕ)
  → (exec (resume m (suc n)) ≡ exec (restart m (suc n)))
  × (cost (resume m (suc n)) < cost (restart m (suc n)))
betterProgram m n = replay m (suc n) , resume-cheaper m n
