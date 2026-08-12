/-
Copyright (c) 2026 Avik Jain and the mathematics collaboration.
Released under Apache 2.0 license.

An adapter between the repository's observed-action semantics and Mathlib's
residual-language formulation of Myhill--Nerode equivalence.
-/
import Mathlib.Computability.MyhillNerode
import Pairfield.FutureBehavior

namespace Pairfield

universe u v

variable {A : Type u} {X : Type v}

/-- The residual language seen when a DFA is started at `x`. -/
def stateLanguage (M : DFA A X) (x : X) : Language A :=
  M.acceptsFrom x

/-- The two libraries use the same left-to-right word execution. -/
theorem run_eq_evalFrom (M : DFA A X) (x : X) (word : List A) :
    run M.step x word = M.evalFrom x word := by
  induction word generalizing x with
  | nil => rfl
  | cons action word ih =>
      exact ih (M.step x action)

/--
Two DFA states have equal residual languages exactly when no future input word
distinguishes their acceptance observations.

This is extensional: it quantifies over every word.  It does not by itself
supply a decision procedure or a shortest distinguishing word.
-/
theorem futureEq_iff_stateLanguage_eq (M : DFA A X) (x y : X) :
    FutureEq M.step (fun state => state ∈ M.accept) x y ↔
      stateLanguage M x = stateLanguage M y := by
  constructor
  · intro h
    apply Set.ext
    intro word
    apply iff_of_eq
    simpa [behavior, stateLanguage, DFA.acceptsFrom, run_eq_evalFrom] using h word
  · intro h word
    apply propext
    simpa [behavior, stateLanguage, DFA.acceptsFrom, run_eq_evalFrom] using Set.ext_iff.mp h word

/--
For a state reached by a prefix `x`, the predictive future is Mathlib's left
quotient of the accepted language by `x`.
-/
theorem leftQuotient_eq_stateLanguage_eval (M : DFA A X) (word : List A) :
    M.accepts.leftQuotient word = stateLanguage M (M.eval word) :=
  Language.leftQuotient_accepts_apply M word

/--
Reachable prefixes are Myhill--Nerode equivalent precisely when their reached
states are equal under all future acceptance experiments.
-/
theorem leftQuotient_eq_iff_futureEq_eval (M : DFA A X) (u v : List A) :
    M.accepts.leftQuotient u = M.accepts.leftQuotient v ↔
      FutureEq M.step (fun state => state ∈ M.accept) (M.eval u) (M.eval v) := by
  rw [leftQuotient_eq_stateLanguage_eval M u, leftQuotient_eq_stateLanguage_eval M v]
  exact (futureEq_iff_stateLanguage_eq M (M.eval u) (M.eval v)).symm

end Pairfield
