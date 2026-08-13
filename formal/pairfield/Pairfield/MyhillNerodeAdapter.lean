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

/-- A prefix residual is the language of the state reached by that prefix. -/
theorem leftQuotient_eq_stateLanguage_eval (M : DFA A X) (word : List A) :
    M.accepts.leftQuotient word = stateLanguage M (M.eval word) :=
  Language.leftQuotient_accepts_apply M word

/-- One DFA step becomes singleton left quotient on residual languages. -/
theorem stateLanguage_step (M : DFA A X) (x : X) (action : A) :
    (stateLanguage M x).leftQuotient [action] =
      stateLanguage M (M.step x action) := by
  ext word
  rfl

/--
Reachable prefixes are Myhill--Nerode equivalent precisely when their reached
states agree under all future acceptance experiments.
-/
theorem leftQuotient_eq_iff_futureEq_eval (M : DFA A X) (u v : List A) :
    M.accepts.leftQuotient u = M.accepts.leftQuotient v ↔
      FutureEq M.step (fun state => state ∈ M.accept) (M.eval u) (M.eval v) := by
  rw [leftQuotient_eq_stateLanguage_eval M u, leftQuotient_eq_stateLanguage_eval M v]
  exact (futureEq_iff_stateLanguage_eq M (M.eval u) (M.eval v)).symm

/-- The behavioral meaning type of a DFA state. -/
abbrev BehavioralState (M : DFA A X) :=
  Quotient (futureSetoid M.step (fun state => state ∈ M.accept))

/--
A next-action policy descends to behavioral meanings exactly when it refuses
to distinguish states with the same complete accepted future.
-/
def selectNext (M : DFA A X) (policy : X → A)
    (sound : ∀ ⦃x y⦄,
      FutureEq M.step (fun state => state ∈ M.accept) x y → policy x = policy y) :
    BehavioralState M → A :=
  quotientLift M.step (fun state => state ∈ M.accept) policy sound

theorem selectNext_mk (M : DFA A X) (policy : X → A)
    (sound : ∀ ⦃x y⦄,
      FutureEq M.step (fun state => state ∈ M.accept) x y → policy x = policy y)
    (x : X) :
    selectNext M policy sound (Quotient.mk _ x) = policy x := rfl

/-- The residual-language map and behavioral action form a commuting square. -/
theorem quotient_action_residual (M : DFA A X) (x : X) (action : A) :
    stateLanguage M (M.step x action) =
      (stateLanguage M x).leftQuotient [action] :=
  (stateLanguage_step M x action).symm

end Pairfield
