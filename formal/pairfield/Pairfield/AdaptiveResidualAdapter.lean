/-
Copyright (c) 2026 Avik Jain and the mathematics collaboration.
Released under Apache 2.0 license.

An exact adapter between Mathlib left quotients and finite
response-conditioned experiment trees.  It identifies the carrier of an
adaptive experiment without identifying its sequential cost with the parallel
uniform observation horizon.
-/
import Pairfield.ReachableAdaptiveObservableHorizon
import Pairfield.VisitedResidual

namespace Pairfield

universe u v w

variable {A : Type u} {X : Type v} {O : Type w}

/-- Mathlib's left-quotient composition law is exactly the residual update
after one more action is appended to a reached prefix. -/
theorem prefixResidual_append_action (M : DFA A X)
    (pre : List A) (action : A) :
    M.accepts.leftQuotient (pre ++ [action]) =
      (M.accepts.leftQuotient pre).leftQuotient [action] :=
  Language.leftQuotient_append M.accepts pre [action]

/-- Equality of prefix residuals is stable under every common next action. -/
theorem prefixResidual_append_action_eq_of_eq (M : DFA A X)
    {left right : List A}
    (h : M.accepts.leftQuotient left = M.accepts.leftQuotient right)
    (action : A) :
    M.accepts.leftQuotient (left ++ [action]) =
      M.accepts.leftQuotient (right ++ [action]) := by
  rw [prefixResidual_append_action, prefixResidual_append_action, h]

namespace BoolExperimentTree

/-- The nonadaptive experiment that executes `word`; both response branches
continue with the same remaining actions.  These trees are the reverse-
direction witnesses in the adaptive residual theorem. -/
def fixedWord : List A → BoolExperimentTree A
  | [] => .done
  | action :: word => .query action (fixedWord word) (fixedWord word)

@[simp]
theorem fixedWord_depth (word : List A) : (fixedWord word).depth = word.length := by
  induction word with
  | nil => rfl
  | cons action word ih => simp [fixedWord, depth, ih]

@[simp]
theorem responses_fixedWord_cons (step : X → A → X) (observe : X → Bool)
    (action : A) (word : List A) (state : X) :
    responses step observe (fixedWord (action :: word)) state =
      observe (step state action) ::
        responses step observe (fixedWord word) (step state action) := by
  simp only [fixedWord, responses]
  split <;> rfl

@[simp]
theorem trace_fixedWord_cons (step : X → A → X) (observe : X → Bool)
    (action : A) (word : List A) (state : X) :
    trace step observe (fixedWord (action :: word)) state =
      observe state :: trace step observe (fixedWord word)
        (step state action) := by
  simp [trace]

/-- Complete future equality survives every finite adaptive experiment. -/
theorem trace_eq_of_futureEq (step : X → A → X) (observe : X → Bool)
    (tree : BoolExperimentTree A) {left right : X}
    (hfuture : FutureEq step observe left right) :
    tree.trace step observe left = tree.trace step observe right := by
  induction tree generalizing left right with
  | done =>
      have hnow := hfuture []
      change observe left = observe right at hnow
      simpa [trace, responses] using congrArg (fun response => [response]) hnow
  | query action onFalse onTrue ihFalse ihTrue =>
      have hnow := hfuture []
      change observe left = observe right at hnow
      have hnext := futureEq_step step observe hfuture action
      have hresponse := hnext []
      change observe (step left action) = observe (step right action) at hresponse
      cases hleft : observe (step left action) with
      | false =>
          have hright : observe (step right action) = false := by
            rw [← hresponse, hleft]
          have hbranch := ihFalse hnext
          have htail :
              responses step observe onFalse (step left action) =
                responses step observe onFalse (step right action) := by
            simpa [trace] using congrArg List.tail hbranch
          simp [trace, responses, hnow, hleft, hright, htail]
      | true =>
          have hright : observe (step right action) = true := by
            rw [← hresponse, hleft]
          have hbranch := ihTrue hnext
          have htail :
              responses step observe onTrue (step left action) =
                responses step observe onTrue (step right action) := by
            simpa [trace] using congrArg List.tail hbranch
          simp [trace, responses, hnow, hleft, hright, htail]

/-- Equality of traces for the fixed-word tree exposes equality of the final
response, hence equality of the ordinary word behavior. -/
theorem behavior_eq_of_fixedWord_trace_eq
    (step : X → A → X) (observe : X → Bool)
    (word : List A) {left right : X}
    (htrace : (fixedWord word).trace step observe left =
      (fixedWord word).trace step observe right) :
    behavior step observe left word = behavior step observe right word := by
  induction word generalizing left right with
  | nil =>
      simpa [fixedWord, trace, responses, behavior, run] using htrace
  | cons action word ih =>
      have htail := congrArg List.tail htrace
      have hbranch :
          (fixedWord word).trace step observe (step left action) =
            (fixedWord word).trace step observe (step right action) := by
        simpa using htail
      simpa [behavior, run] using ih hbranch

end BoolExperimentTree

/-- Two prefix residuals are equal exactly when every finite adaptive
experiment returns the same Boolean trace from their reached states.

The reverse implication is not compactness or a search theorem: a suffix that
separates unequal residuals is itself a `fixedWord` experiment tree. -/
theorem leftQuotient_eq_iff_all_adaptive_traces_eq
    (M : DFA A X) [DecidablePred (fun state : X => state ∈ M.accept)]
    (left right : List A) :
    M.accepts.leftQuotient left = M.accepts.leftQuotient right ↔
      ∀ tree : BoolExperimentTree A,
        tree.trace M.step (acceptsBool M) (M.eval left) =
          tree.trace M.step (acceptsBool M) (M.eval right) := by
  constructor
  · intro hresidual tree
    apply tree.trace_eq_of_futureEq
    intro word
    apply (behavior_eval_eq_iff_leftQuotient_membership
      M left right word).2
    rw [hresidual]
  · intro htree
    apply Set.ext
    intro word
    apply (behavior_eval_eq_iff_leftQuotient_membership
      M left right word).1
    apply BoolExperimentTree.behavior_eq_of_fixedWord_trace_eq
    exact htree (BoolExperimentTree.fixedWord word)

/--
Two reached prefixes have the same residual exactly when no finite adaptive
test tree can tell them apart.  This is the test-facing spelling of the
residual/traces equivalence above: the forward direction is extensionality of
the residual, while the reverse direction is witnessed by the fixed-word
tree for any separating suffix.
-/
theorem leftQuotient_eq_iff_adaptive_test_equivalence
    (M : DFA A X) [DecidablePred (fun state : X => state ∈ M.accept)]
    (left right : List A) :
    M.accepts.leftQuotient left = M.accepts.leftQuotient right ↔
      ∀ tree : BoolExperimentTree A,
        tree.trace M.step (acceptsBool M) (M.eval left) =
          tree.trace M.step (acceptsBool M) (M.eval right) :=
  leftQuotient_eq_iff_all_adaptive_traces_eq M left right

namespace AdaptiveResidualAdapterControl

open ResidualBFSWitness

/-- The known separator `[true]` becomes a literal nonadaptive experiment
that distinguishes the two unequal residuals. -/
example :
    (BoolExperimentTree.fixedWord [true]).trace automaton.step
        (acceptsBool automaton) (automaton.eval []) ≠
      (BoolExperimentTree.fixedWord [true]).trace automaton.step
        (acceptsBool automaton) (automaton.eval [false]) := by
  decide

/-- The equal-residual control is invisible to every adaptive tree. -/
example : ∀ tree : BoolExperimentTree Bool,
    tree.trace automaton.step (acceptsBool automaton) (automaton.eval []) =
      tree.trace automaton.step (acceptsBool automaton)
        (automaton.eval [true]) := by
  apply (leftQuotient_eq_iff_all_adaptive_traces_eq
    automaton [] [true]).1
  exact (visitedLeftQuotientWitness?_eq_none_iff
    automaton alphabet alphabet_complete [] [true]).1 (by decide)

end AdaptiveResidualAdapterControl

namespace ReachableAdaptiveResidualControl

open ReachableAdaptiveObservableHorizonWitness

/-- In the repaired all-state-reachable witness, the ordinary one-action tree
already exposes a genuine unequal pair of reachable Mathlib residuals. -/
example :
    automaton.accepts.leftQuotient [] ≠
      automaton.accepts.leftQuotient [false] := by
  intro hresidual
  have hall := (leftQuotient_eq_iff_all_adaptive_traces_eq
    automaton [] [false]).1 hresidual
  have hseparates :
      (BoolExperimentTree.fixedWord [false]).trace automaton.step
          (acceptsBool automaton) (automaton.eval []) ≠
        (BoolExperimentTree.fixedWord [false]).trace automaton.step
          (acceptsBool automaton) (automaton.eval [false]) := by
    decide
  exact hseparates (hall (BoolExperimentTree.fixedWord [false]))

/-- The return's nontrivial positive control keeps all three exact costs in
one checked statement: uniform words `1`, prefix residuals `1`, adaptive
identification `2`. -/
example :
    globalObservableHorizon automaton alphabet = 1 ∧
      IsLeast { fuel : Nat |
        LeftQuotientsStabilizeAt automaton fuel } 1 ∧
      IsLeast { fuel : Nat |
        BoolExperimentTree.IdentifiesAtDepth step observe fuel } 2 :=
  reachable_uniform_residual_one_adaptive_two

end ReachableAdaptiveResidualControl

namespace AdaptiveObservableHorizonWitness

/-- The adaptive-gap witness has only one reachable prefix state.  Its strict
ambient-state identification gap therefore does not manufacture a nontrivial
accepted-language residual gap. -/
theorem eval_eq_start (word : List Bool) : automaton.eval word = 0 := by
  induction word using List.reverseRecOn with
  | nil => rfl
  | append_singleton word action ih =>
      rw [DFA.eval_append_singleton, ih]
      cases action <;> decide

theorem all_prefix_residuals_eq (left right : List Bool) :
    automaton.accepts.leftQuotient left =
      automaton.accepts.leftQuotient right := by
  rw [leftQuotient_eq_stateLanguage_eval,
    leftQuotient_eq_stateLanguage_eval, eval_eq_start, eval_eq_start]

end AdaptiveObservableHorizonWitness

end Pairfield
