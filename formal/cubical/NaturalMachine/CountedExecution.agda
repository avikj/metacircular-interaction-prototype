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

module NaturalMachine.CountedExecution where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (ℕ ; zero ; suc)

-- The atomic execution law.  A program is its next-state map; time is ℕ;
-- running is iteration.  The successor equation computes by reduction.
run : {S : Type₀} → S → (S → S) → ℕ → S
run seed step zero    = seed
run seed step (suc n) = step (run seed step n)

-- Definitional sanity only: this re-states the second clause of `run`
-- (it is `refl`), pinning the reduction behavior by name.  It is not a
-- theorem beyond the definition.
run-suc : {S : Type₀} (seed : S) (step : S → S) (n : ℕ)
        → run seed step (suc n) ≡ step (run seed step n)
run-suc seed step n = refl

-- A map between executions is valid when it preserves the seed and
-- commutes with one step.  Then it commutes with every counted execution.
-- (Sufficient, not "exactly when": the converse would give the step
-- equation only on reachable states, and is not stated.)
compile : {S T : Type₀} (seedS : S) (stepS : S → S)
        → (seedT : T) (stepT : T → T) (f : S → T)
        → f seedS ≡ seedT
        → ((x : S) → f (stepS x) ≡ stepT (f x))
        → (n : ℕ) → f (run seedS stepS n) ≡ run seedT stepT n
compile seedS stepS seedT stepT f onSeed onStep zero = onSeed
compile seedS stepS seedT stepT f onSeed onStep (suc n) =
  onStep (run seedS stepS n) ∙ cong stepT
    (compile seedS stepS seedT stepT f onSeed onStep n)

