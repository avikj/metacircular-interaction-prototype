/-
Copyright (c) 2026 Avik Jain and the mathematics collaboration.
Released under Apache 2.0 license.

An all-state-reachable strengthening of the adaptive/uniform horizon gap.  It
connects the ambient state theorem to Mathlib prefix left quotients through
the checked residual-horizon adapter.
-/
import Pairfield.AdaptiveObservableHorizon
import Pairfield.ResidualObservableHorizon

namespace Pairfield

namespace ReachableAdaptiveObservableHorizonWitness

open BoolExperimentTree

/-- The start row routes to both hidden test rows.  Thereafter `false` isolates
row `1`, `true` isolates row `2`, and row `3` is the observed sink. -/
def step (state : Fin 4) (action : Bool) : Fin 4 :=
  if decide (state = 0) then
    if action then 2 else 1
  else if ((!action && decide (state = 1)) ||
      (action && decide (state = 2))) then 3 else state

def observe (state : Fin 4) : Bool := decide (state = 3)

def automaton : DFA Bool (Fin 4) where
  step := step
  start := 0
  accept := { state | observe state = true }

instance : DecidablePred (fun state : Fin 4 => state ∈ automaton.accept) :=
  fun state => inferInstanceAs (Decidable (observe state = true))

def alphabet : List Bool := [false, true]

theorem alphabet_complete (action : Bool) : action ∈ alphabet := by
  cases action <;> simp [alphabet]

/-- Every ambient row is the image of a concrete Mathlib prefix. -/
theorem all_states_reachable (state : Fin 4) :
    ∃ word : List Bool, automaton.eval word = state := by
  fin_cases state
  · exact ⟨[], rfl⟩
  · exact ⟨[false], by decide⟩
  · exact ⟨[true], by decide⟩
  · exact ⟨[false, false], by decide⟩

/-- Use the same response-conditioned policy as the ambient witness. -/
def adaptiveTree : BoolExperimentTree Bool :=
  .query false (.query true .done .done) .done

theorem adaptiveTree_depth : adaptiveTree.depth = 2 := by
  decide

theorem adaptiveTree_identifies :
    adaptiveTree.IdentifiesAll step observe := by
  intro left right heq
  fin_cases left <;> fin_cases right <;>
    simp_all [BoolExperimentTree.IdentifiesAll,
      BoolExperimentTree.trace, BoolExperimentTree.responses,
      adaptiveTree, step, observe]

/-- A one-action policy still collides: `false` leaves rows `0,2`
observationally equal, while `true` leaves rows `0,1` equal. -/
theorem no_identifying_tree_of_depth_le_one
    (tree : BoolExperimentTree Bool) (hdepth : tree.depth ≤ 1) :
    ¬ tree.IdentifiesAll step observe := by
  cases tree with
  | done =>
      intro hinjective
      have heq : BoolExperimentTree.trace step observe .done (0 : Fin 4) =
          BoolExperimentTree.trace step observe .done 1 := by
        decide
      exact (by decide : (0 : Fin 4) ≠ 1) (hinjective heq)
  | query action onFalse onTrue =>
      have hfalseZero : onFalse.depth = 0 := by
        simp only [BoolExperimentTree.depth] at hdepth
        have hfalseMax : onFalse.depth ≤ max onFalse.depth onTrue.depth :=
          Nat.le_max_left _ _
        omega
      have htrueZero : onTrue.depth = 0 := by
        simp only [BoolExperimentTree.depth] at hdepth
        have htrueMax : onTrue.depth ≤ max onFalse.depth onTrue.depth :=
          Nat.le_max_right _ _
        omega
      have hfalseDone := eq_done_of_depth_eq_zero onFalse hfalseZero
      have htrueDone := eq_done_of_depth_eq_zero onTrue htrueZero
      subst onFalse
      subst onTrue
      cases action with
      | false =>
          intro hinjective
          have heq :
              BoolExperimentTree.trace step observe
                (.query false .done .done) (0 : Fin 4) =
              BoolExperimentTree.trace step observe
                (.query false .done .done) 2 := by
            decide
          exact (by decide : (0 : Fin 4) ≠ 2) (hinjective heq)
      | true =>
          intro hinjective
          have heq :
              BoolExperimentTree.trace step observe
                (.query true .done .done) (0 : Fin 4) =
              BoolExperimentTree.trace step observe
                (.query true .done .done) 1 := by
            decide
          exact (by decide : (0 : Fin 4) ≠ 1) (hinjective heq)

theorem adaptive_depth_isLeast :
    IsLeast { fuel : Nat |
      BoolExperimentTree.IdentifiesAtDepth step observe fuel } 2 := by
  constructor
  · exact ⟨adaptiveTree, by rw [adaptiveTree_depth],
      adaptiveTree_identifies⟩
  · intro fuel hidentifies
    by_contra hnot
    have hfuel : fuel ≤ 1 := by omega
    obtain ⟨tree, htreeDepth, htreeIdentifies⟩ := hidentifies
    exact (no_identifying_tree_of_depth_le_one tree
      (Nat.le_trans htreeDepth hfuel)) htreeIdentifies

theorem uniform_horizon_eq_one :
    globalObservableHorizon automaton alphabet = 1 := by
  decide

/-- Reachability transports the same exact native horizon to Mathlib prefix
left quotients; this was unavailable for the original ambient witness. -/
theorem residual_horizon_isLeast :
    IsLeast { fuel : Nat | LeftQuotientsStabilizeAt automaton fuel } 1 := by
  rw [← uniform_horizon_eq_one]
  exact globalObservableHorizon_isLeast_leftQuotientsStabilizeAt
    automaton alphabet alphabet_complete all_states_reachable

/-- The reciprocal checked package: native uniform words, Mathlib residuals,
and one response-dependent policy have distinct exact costs `1,1,2`. -/
theorem reachable_uniform_residual_one_adaptive_two :
    globalObservableHorizon automaton alphabet = 1 ∧
      IsLeast { fuel : Nat |
        LeftQuotientsStabilizeAt automaton fuel } 1 ∧
      IsLeast { fuel : Nat |
        BoolExperimentTree.IdentifiesAtDepth step observe fuel } 2 :=
  ⟨uniform_horizon_eq_one, residual_horizon_isLeast,
    adaptive_depth_isLeast⟩

end ReachableAdaptiveObservableHorizonWitness

end Pairfield
