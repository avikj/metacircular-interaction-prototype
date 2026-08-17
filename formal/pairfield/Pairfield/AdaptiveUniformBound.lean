/-
Copyright (c) 2026 Avik Jain and the mathematics collaboration.
Released under Apache 2.0 license.

Every exact adaptive identification policy is at least as deep as the least
parallel uniform observable horizon.
-/
import Pairfield.AdaptiveObservableHorizon

namespace Pairfield

universe u v

variable {A : Type u} {X : Type v}

namespace BoolExperimentTree

/-- A response-conditioned experiment of depth `d` only consumes behavior
coordinates whose ordinary word length is at most `d`.  Thus bounded future
equality through the tree depth forces equal adaptive traces. -/
theorem trace_eq_of_boundedFutureEq
    (step : X → A → X) (observe : X → Bool)
    (tree : BoolExperimentTree A) {left right : X}
    (hbounded : BoundedFutureEq step observe tree.depth left right) :
    tree.trace step observe left = tree.trace step observe right := by
  induction tree generalizing left right with
  | done =>
      simpa [trace, responses, depth, behavior, run] using
        hbounded [] (by simp)
  | query action onFalse onTrue ihFalse ihTrue =>
      have hnow : observe left = observe right :=
        hbounded [] (by simp [depth])
      have hnext : observe (step left action) =
          observe (step right action) := by
        simpa [behavior, run] using
          hbounded [action] (by simp [depth])
      cases hresponse : observe (step left action) with
      | false =>
          have hright : observe (step right action) = false := by
            rw [← hnext, hresponse]
          have hbranch : BoundedFutureEq step observe onFalse.depth
              (step left action) (step right action) := by
            intro word hlength
            apply hbounded (action :: word)
            simp only [List.length_cons, depth]
            have hle : onFalse.depth ≤ max onFalse.depth onTrue.depth :=
              Nat.le_max_left _ _
            omega
          have ih := ihFalse hbranch
          simpa [trace, responses, hnow, hresponse, hright] using
            congrArg (List.cons (observe left)) ih
      | true =>
          have hright : observe (step right action) = true := by
            rw [← hnext, hresponse]
          have hbranch : BoundedFutureEq step observe onTrue.depth
              (step left action) (step right action) := by
            intro word hlength
            apply hbounded (action :: word)
            simp only [List.length_cons, depth]
            have hle : onTrue.depth ≤ max onFalse.depth onTrue.depth :=
              Nat.le_max_right _ _
            omega
          have ih := ihTrue hbranch
          simpa [trace, responses, hnow, hresponse, hright] using
            congrArg (List.cons (observe left)) ih

end BoolExperimentTree

/-- Any tree that identifies all ambient states makes the uniform observable
kernel close by its own depth.  No separate future-distinctness hypothesis is
needed: trace injectivity already supplies it. -/
theorem adaptiveIdentification_closesAt_depth
    (step : X → A → X) (observe : X → Bool)
    (tree : BoolExperimentTree A)
    (hidentifies : tree.IdentifiesAll step observe) :
    ObservableClosesAt step observe tree.depth := by
  rw [observableClosesAt_iff_bounded_implies_future]
  intro left right hbounded
  have htrace := tree.trace_eq_of_boundedFutureEq
    step observe hbounded
  have hstates : left = right := hidentifies htrace
  subst right
  exact futureEq_refl step observe left

/-- R0048's executable least uniform horizon is a lower bound on the depth of
every exact adaptive state-identification tree. -/
theorem globalObservableHorizon_le_adaptive_depth
    [DecidableEq X] [Fintype X]
    (M : DFA A X) [DecidablePred (fun state : X => state ∈ M.accept)]
    (alphabet : List A) (complete : ∀ action : A, action ∈ alphabet)
    (tree : BoolExperimentTree A)
    (hidentifies : tree.IdentifiesAll M.step (acceptsBool M)) :
    globalObservableHorizon M alphabet ≤ tree.depth := by
  exact (globalObservableHorizon_isLeast M alphabet complete).2
    (adaptiveIdentification_closesAt_depth
      M.step (acceptsBool M) tree hidentifies)

/-- The same lower bound holds for every fuel admitting an identifying tree,
even if the witness tree is shallower than the declared fuel. -/
theorem globalObservableHorizon_le_of_identifiesAtDepth
    [DecidableEq X] [Fintype X]
    (M : DFA A X) [DecidablePred (fun state : X => state ∈ M.accept)]
    (alphabet : List A) (complete : ∀ action : A, action ∈ alphabet)
    {fuel : Nat}
    (hidentifies : BoolExperimentTree.IdentifiesAtDepth
      M.step (acceptsBool M) fuel) :
    globalObservableHorizon M alphabet ≤ fuel := by
  obtain ⟨tree, hdepth, htree⟩ := hidentifies
  exact Nat.le_trans
    (globalObservableHorizon_le_adaptive_depth
      M alphabet complete tree htree) hdepth

namespace AdaptiveUniformBoundControl

open AdaptiveObservableHorizonWitness

/-- R0049 is a strict instance of the general lower bound: `1 ≤ 2`. -/
example : globalObservableHorizon automaton alphabet ≤ adaptiveTree.depth :=
  by
    have haccepts : acceptsBool automaton = observe := by
      funext state
      fin_cases state <;> decide
    have htree : adaptiveTree.IdentifiesAll
        automaton.step (acceptsBool automaton) := by
      rw [haccepts]
      change adaptiveTree.IdentifiesAll step observe
      exact adaptiveTree_identifies
    exact globalObservableHorizon_le_adaptive_depth
      automaton alphabet alphabet_complete adaptiveTree htree

example : globalObservableHorizon automaton alphabet < adaptiveTree.depth := by
  rw [uniform_horizon_eq_one, adaptiveTree_depth]
  decide

end AdaptiveUniformBoundControl

end Pairfield
