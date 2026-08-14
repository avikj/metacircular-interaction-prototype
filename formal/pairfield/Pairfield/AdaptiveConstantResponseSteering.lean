/-
Copyright (c) 2026 Avik Jain and the mathematics collaboration.
Released under Apache 2.0 license.

A reachable residual control in which every separating tree must begin with a
safe constant-response action.  This refutes normalization by deleting all
zero-potential steering steps.
-/
import Pairfield.AdaptiveResidualConstructor

namespace Pairfield

namespace AdaptiveConstantResponseSteering

/-- Three actions: reach the second live residual, steer both live residuals
without revealing them, and reveal only after steering. -/
def reach : Fin 3 := 0
def steer : Fin 3 := 1
def reveal : Fin 3 := 2

def x : Fin 5 := 0
def y : Fin 5 := 1
def u : Fin 5 := 2
def v : Fin 5 := 3
def sink : Fin 5 := 4

/-- `reach` and premature `reveal` merge the live pair.  `steer` sends it
injectively to `u,v`; only then can `reveal` distinguish the two. -/
def step (state : Fin 5) (action : Fin 3) : Fin 5 :=
  if action = reach then
    if state = x then y else state
  else if action = steer then
    if state = x then u else if state = y then v else state
  else if state = x ∨ state = y then
    x
  else if state = v then
    sink
  else
    state

def observe (state : Fin 5) : Bool := decide (state = sink)

def automaton : DFA (Fin 3) (Fin 5) where
  step := step
  start := x
  accept := { state | observe state = true }

instance : DecidablePred
    (fun state : Fin 5 => state ∈ automaton.accept) :=
  fun state => inferInstanceAs (Decidable (observe state = true))

/-- The machine is an honest reachable presentation, not an ambient-state
counterexample. -/
theorem all_states_reachable (state : Fin 5) :
    ∃ pre : List (Fin 3), automaton.eval pre = state := by
  fin_cases state
  · exact ⟨[], by native_decide⟩
  · exact ⟨[reach], by native_decide⟩
  · exact ⟨[steer], by native_decide⟩
  · exact ⟨[reach, steer], by native_decide⟩
  · exact ⟨[reach, steer, reveal], by native_decide⟩

/-- One presenter for each of the two initially live residuals. -/
def representatives : Finset (List (Fin 3)) := {[], [reach]}

def liveCell : Set (List (Fin 3)) := ↑representatives

/-- The required separator first steers on a constant response and then
reveals on the surviving false branch. -/
def steeringTree : BoolExperimentTree (Fin 3) :=
  .query steer (.query reveal .done .done) .done

theorem steering_traces_ne :
    BranchTrace automaton steeringTree [] ≠
      BranchTrace automaton steeringTree [reach] := by
  native_decide

/-- The two live prefixes really present different Mathlib residuals. -/
theorem live_residuals_ne :
    BranchResidual automaton [] ≠ BranchResidual automaton [reach] := by
  intro hresidual
  have hall :=
    (leftQuotient_eq_iff_all_adaptive_traces_eq
      automaton [] [reach]).1 hresidual
  exact steering_traces_ne (hall steeringTree)

theorem liveCell_currentConstant :
    ResidualCell.CurrentConstant automaton liveCell := by
  intro left right hleft hright
  have hleftCases : left = [] ∨ left = [reach] := by
    simpa [liveCell, representatives] using hleft
  have hrightCases : right = [] ∨ right = [reach] := by
    simpa [liveCell, representatives] using hright
  rcases hleftCases with rfl | rfl <;>
    rcases hrightCases with rfl | rfl <;> native_decide

/-- The advertised depth-two tree separates the live residual cell. -/
theorem steeringTree_separates :
    steeringTree.SeparatesPrefixResidualsOn automaton liveCell := by
  intro left right hleft hright htrace
  have hleftCases : left = [] ∨ left = [reach] := by
    simpa [liveCell, representatives] using hleft
  have hrightCases : right = [] ∨ right = [reach] := by
    simpa [liveCell, representatives] using hright
  rcases hleftCases with rfl | rfl <;>
    rcases hrightCases with rfl | rfl
  · rfl
  · exact False.elim (steering_traces_ne htrace)
  · exact False.elim (steering_traces_ne htrace.symm)
  · rfl

theorem reach_advanced_residuals_eq :
    BranchResidual automaton ([] ++ [reach]) =
      BranchResidual automaton ([reach] ++ [reach]) := by
  change stateLanguage automaton (automaton.eval ([] ++ [reach])) =
    stateLanguage automaton (automaton.eval ([reach] ++ [reach]))
  congr 1

theorem reveal_advanced_residuals_eq :
    BranchResidual automaton ([] ++ [reveal]) =
      BranchResidual automaton ([reach] ++ [reveal]) := by
  change stateLanguage automaton (automaton.eval ([] ++ [reveal])) =
    stateLanguage automaton (automaton.eval ([reach] ++ [reveal]))
  congr 1

/-- `reach` is a lossy root on the live cell. -/
theorem reach_not_safe :
    ¬ ResidualCell.SafeAction automaton liveCell reach := by
  intro hsafe
  exact live_residuals_ne
    (hsafe (by simp [liveCell, representatives])
      (by simp [liveCell, representatives]) reach_advanced_residuals_eq)

/-- Premature `reveal` is also a lossy root. -/
theorem reveal_not_safe :
    ¬ ResidualCell.SafeAction automaton liveCell reveal := by
  intro hsafe
  exact live_residuals_ne
    (hsafe (by simp [liveCell, representatives])
      (by simp [liveCell, representatives]) reveal_advanced_residuals_eq)

/-- The actual root is safe because the complete steering tree separates. -/
theorem steer_safe :
    ResidualCell.SafeAction automaton liveCell steer := by
  have hsplit :=
    (steeringTree.residualSplitting_iff_separatesOn automaton liveCell
      liveCell_currentConstant).2 steeringTree_separates
  exact hsplit.1

/-- No leaf separates the live residual pair. -/
theorem done_not_separates :
    ¬ (BoolExperimentTree.done : BoolExperimentTree (Fin 3)).
      SeparatesPrefixResidualsOn automaton liveCell := by
  intro hseparates
  apply live_residuals_ne
  apply hseparates
  · simp [liveCell, representatives]
  · simp [liveCell, representatives]
  · native_decide

/-- Any separating query must use `steer` at its root. -/
theorem separating_query_root_eq_steer
    (action : Fin 3) (onFalse onTrue : BoolExperimentTree (Fin 3))
    (hseparates :
      (BoolExperimentTree.query action onFalse onTrue).
        SeparatesPrefixResidualsOn automaton liveCell) :
    action = steer := by
  have hsafe : ResidualCell.SafeAction automaton liveCell action :=
    ((BoolExperimentTree.query action onFalse onTrue).
      residualSplitting_iff_separatesOn automaton liveCell
        liveCell_currentConstant).2 hseparates |>.1
  fin_cases action
  · exact False.elim (reach_not_safe hsafe)
  · rfl
  · exact False.elim (reveal_not_safe hsafe)

/-- Strong normalization counterexample: every separating tree begins with
the same steering query. -/
theorem every_separator_starts_with_steer
    (tree : BoolExperimentTree (Fin 3))
    (hseparates : tree.SeparatesPrefixResidualsOn automaton liveCell) :
    ∃ onFalse onTrue : BoolExperimentTree (Fin 3),
      tree = .query steer onFalse onTrue := by
  cases tree with
  | done => exact False.elim (done_not_separates hseparates)
  | query action onFalse onTrue =>
      have hroot := separating_query_root_eq_steer
        action onFalse onTrue hseparates
      subst action
      exact ⟨onFalse, onTrue, rfl⟩

/-- Yet the mandatory root returns false on the entire live cell. -/
theorem steer_response_constant
    (pre : List (Fin 3)) (hpre : pre ∈ representatives) :
    ResidualPotentialAdapter.postResponse automaton steer pre = false := by
  have hcases : pre = [] ∨ pre = [reach] := by
    simpa [representatives] using hpre
  rcases hcases with rfl | rfl <;> native_decide

theorem steer_true_responseFiber_empty :
    FiniteLiveCell.responseFiber representatives
      (ResidualPotentialAdapter.postResponse automaton steer) true = ∅ := by
  native_decide

/-- One representative really was chosen per residual. -/
theorem representatives_distinct :
    ResidualPotentialAdapter.DistinctRepresentatives
      automaton representatives := by
  intro ⟨left right⟩ hleft hright hresidual
  have hleftCases : left = [] ∨ left = [reach] := by
    simpa [representatives] using hleft
  have hrightCases : right = [] ∨ right = [reach] := by
    simpa [representatives] using hright
  rcases hleftCases with rfl | rfl <;>
    rcases hrightCases with rfl | rfl
  · rfl
  · exact False.elim (live_residuals_ne hresidual)
  · exact False.elim (live_residuals_ne hresidual.symm)
  · rfl

/-- R0056 assigns the mandatory root exactly zero square-potential decrease. -/
theorem steer_zero_potential_decrease :
    FiniteLiveCell.squarePotential
          (FiniteLiveCell.advancedBranch representatives
            (ResidualPotentialAdapter.postResponse automaton steer)
            (ResidualPotentialAdapter.advanceResidual automaton steer) false) +
        FiniteLiveCell.squarePotential
          (FiniteLiveCell.advancedBranch representatives
            (ResidualPotentialAdapter.postResponse automaton steer)
            (ResidualPotentialAdapter.advanceResidual automaton steer) true) =
      FiniteLiveCell.squarePotential representatives := by
  classical
  apply (FiniteLiveCell.branchPotential_eq_iff_empty_branch representatives
    (ResidualPotentialAdapter.postResponse automaton steer)
    (ResidualPotentialAdapter.advanceResidual automaton steer)
    (ResidualPotentialAdapter.safeAdvance_of_residualSafe automaton
      representatives steer representatives_distinct steer_safe)).2
  right
  simp [FiniteLiveCell.advancedBranch, steer_true_responseFiber_empty]

end AdaptiveConstantResponseSteering

end Pairfield
