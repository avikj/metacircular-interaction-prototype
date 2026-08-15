/-
Copyright (c) 2026 Avik Jain and the mathematics collaboration.
Released under Apache 2.0 license.

Proper descendant spines of recursively splitting residual experiments, and
the exact theorem that depth minimality forbids canonical-position cycles.
-/
import Pairfield.AdaptiveResidualPositionCycleAdapter

namespace Pairfield

universe u v

variable {A : Type u} {X : Type v}

namespace BoolExperimentTree

/-- A proof-relevant descendant carries both the selected experiment subtree
and the response-conditioned live prefix cell on which it runs. -/
inductive ResidualCellDescendant
    (M : DFA A X) [DecidablePred (fun state : X => state ∈ M.accept)] :
    BoolExperimentTree A → Set (List A) →
      BoolExperimentTree A → Set (List A) → Prop
  | refl (tree : BoolExperimentTree A) (cell : Set (List A)) :
      ResidualCellDescendant M tree cell tree cell
  | false {action : A} {onFalse onTrue subtree : BoolExperimentTree A}
      {cell later : Set (List A)}
      (tail : ResidualCellDescendant M onFalse
        (ResidualCell.advance M cell action false) subtree later) :
      ResidualCellDescendant M (.query action onFalse onTrue)
        cell subtree later
  | true {action : A} {onFalse onTrue subtree : BoolExperimentTree A}
      {cell later : Set (List A)}
      (tail : ResidualCellDescendant M onTrue
        (ResidualCell.advance M cell action true) subtree later) :
      ResidualCellDescendant M (.query action onFalse onTrue)
        cell subtree later

/-- Proper descendants consume at least one query before reaching the
selected subtree and live cell. -/
inductive ProperResidualCellDescendant
    (M : DFA A X) [DecidablePred (fun state : X => state ∈ M.accept)] :
    BoolExperimentTree A → Set (List A) →
      BoolExperimentTree A → Set (List A) → Prop
  | false {action : A} {onFalse onTrue subtree : BoolExperimentTree A}
      {cell later : Set (List A)}
      (tail : ResidualCellDescendant M onFalse
        (ResidualCell.advance M cell action false) subtree later) :
      ProperResidualCellDescendant M (.query action onFalse onTrue)
        cell subtree later
  | true {action : A} {onFalse onTrue subtree : BoolExperimentTree A}
      {cell later : Set (List A)}
      (tail : ResidualCellDescendant M onTrue
        (ResidualCell.advance M cell action true) subtree later) :
      ProperResidualCellDescendant M (.query action onFalse onTrue)
        cell subtree later

theorem ResidualCellDescendant.depth_le
    {M : DFA A X} [DecidablePred (fun state : X => state ∈ M.accept)]
    {tree subtree : BoolExperimentTree A} {cell later : Set (List A)}
    (descendant : ResidualCellDescendant M tree cell subtree later) :
    subtree.depth ≤ tree.depth := by
  induction descendant with
  | refl => rfl
  | false tail ih =>
      simp only [depth]
      exact ih.trans ((Nat.le_max_left _ _).trans (Nat.le_succ _))
  | true tail ih =>
      simp only [depth]
      exact ih.trans ((Nat.le_max_right _ _).trans (Nat.le_succ _))

theorem ProperResidualCellDescendant.toDescendant
    {M : DFA A X} [DecidablePred (fun state : X => state ∈ M.accept)]
    {tree subtree : BoolExperimentTree A} {cell later : Set (List A)}
    (descendant : ProperResidualCellDescendant M tree cell subtree later) :
    ResidualCellDescendant M tree cell subtree later := by
  cases descendant with
  | false tail => exact .false tail
  | true tail => exact .true tail

theorem ProperResidualCellDescendant.depth_lt
    {M : DFA A X} [DecidablePred (fun state : X => state ∈ M.accept)]
    {tree subtree : BoolExperimentTree A} {cell later : Set (List A)}
    (descendant : ProperResidualCellDescendant M tree cell subtree later) :
    subtree.depth < tree.depth := by
  cases descendant with
  | false tail =>
      simp only [depth]
      exact Nat.lt_succ_of_le (tail.depth_le.trans (Nat.le_max_left _ _))
  | true tail =>
      simp only [depth]
      exact Nat.lt_succ_of_le (tail.depth_le.trans (Nat.le_max_right _ _))

/-- Recursive splitting certificates restrict to every selected descendant
subtree on its exact response-conditioned live cell. -/
theorem ResidualCellDescendant.residualSplitting
    {M : DFA A X} [DecidablePred (fun state : X => state ∈ M.accept)]
    {tree subtree : BoolExperimentTree A} {cell later : Set (List A)}
    (descendant : ResidualCellDescendant M tree cell subtree later)
    (splitting : tree.ResidualSplitting M cell) :
    subtree.ResidualSplitting M later := by
  induction descendant with
  | refl => exact splitting
  | false tail ih => exact ih splitting.2.1
  | true tail ih => exact ih splitting.2.2

/-- Current-output constancy is preserved along every selected live-cell
descendant. -/
theorem ResidualCellDescendant.currentConstant
    {M : DFA A X} [DecidablePred (fun state : X => state ∈ M.accept)]
    {tree subtree : BoolExperimentTree A} {cell later : Set (List A)}
    (descendant : ResidualCellDescendant M tree cell subtree later)
    (constant : ResidualCell.CurrentConstant M cell) :
    ResidualCell.CurrentConstant M later := by
  induction descendant with
  | refl => exact constant
  | false tail ih =>
      exact ih (ResidualCell.advance_currentConstant M _ _ Bool.false)
  | true tail ih =>
      exact ih (ResidualCell.advance_currentConstant M _ _ Bool.true)

/-- Minimality is intentionally quantified over recursive splitting
certificates on the same root cell, not merely over tree syntax. -/
def DepthMinimalResidualSplitting
    (M : DFA A X) [DecidablePred (fun state : X => state ∈ M.accept)]
    (tree : BoolExperimentTree A) (cell : Set (List A)) : Prop :=
  tree.ResidualSplitting M cell ∧
    ∀ candidate : BoolExperimentTree A,
      candidate.ResidualSplitting M cell → tree.depth ≤ candidate.depth

/-- Global no-cycle theorem.  A proper descendant of a depth-minimal
residual-splitting tree cannot revisit the root's canonical live position:
R0059 would transplant that strictly shallower subtree back to the root. -/
theorem DepthMinimalResidualSplitting.no_samePosition_properDescendant
    (M : DFA A X) [DecidablePred (fun state : X => state ∈ M.accept)]
    (tree subtree : BoolExperimentTree A) (cell later : Set (List A))
    (minimal : DepthMinimalResidualSplitting M tree cell)
    (constant : ResidualCell.CurrentConstant M cell)
    (descendant : ProperResidualCellDescendant M tree cell subtree later) :
    ¬ ResidualCell.SamePosition M cell later := by
  intro samePosition
  have descendantSplitting : subtree.ResidualSplitting M later :=
    descendant.toDescendant.residualSplitting minimal.1
  have laterConstant : ResidualCell.CurrentConstant M later :=
    descendant.toDescendant.currentConstant constant
  have laterSeparates : subtree.SeparatesPrefixResidualsOn M later :=
    (subtree.residualSplitting_iff_separatesOn
      M later laterConstant).1 descendantSplitting
  have rootSeparates : subtree.SeparatesPrefixResidualsOn M cell :=
    (subtree.separatesPrefixResidualsOn_congr_position
      M cell later samePosition).2 laterSeparates
  have rootSplitting : subtree.ResidualSplitting M cell :=
    (subtree.residualSplitting_iff_separatesOn
      M cell constant).2 rootSeparates
  have minimalDepth : tree.depth ≤ subtree.depth :=
    minimal.2 subtree rootSplitting
  exact (Nat.not_lt_of_ge minimalDepth) descendant.depth_lt

end BoolExperimentTree

namespace AdaptiveResidualMinimalSpineControl

open AdaptiveConstantResponseSteering

/-- Insert one redundant constant-response steering query before the useful
reveal.  It still separates, but its extra query makes it nonminimal. -/
def redundantSteeringTree : BoolExperimentTree (Fin 3) :=
  .query steer
    (.query steer (.query reveal .done .done) .done)
    .done

theorem redundantSteering_traces_ne :
    BranchTrace automaton redundantSteeringTree [] ≠
      BranchTrace automaton redundantSteeringTree [reach] := by
  decide

theorem redundantSteeringTree_separates :
    redundantSteeringTree.SeparatesPrefixResidualsOn automaton liveCell := by
  intro left right hleft hright htrace
  have hleft' : left ∈ representatives := hleft
  have hright' : right ∈ representatives := hright
  have hleftCases : left = [] ∨ left = [reach] :=
    (mem_representatives_iff left).mp hleft'
  have hrightCases : right = [] ∨ right = [reach] :=
    (mem_representatives_iff right).mp hright'
  rcases hleftCases with rfl | rfl <;>
    rcases hrightCases with rfl | rfl
  · rfl
  · exact False.elim (redundantSteering_traces_ne htrace)
  · exact False.elim (redundantSteering_traces_ne htrace.symm)
  · rfl

/-- The redundant separator is the planted-false control: separation alone
does not imply minimality. -/
theorem redundantSteeringTree_not_depthMinimal :
    ¬ redundantSteeringTree.DepthMinimalResidualSplitting
      automaton liveCell := by
  intro minimal
  have usefulSplitting :
      steeringTree.ResidualSplitting automaton liveCell :=
    (steeringTree.residualSplitting_iff_separatesOn automaton liveCell
      liveCell_currentConstant).2 steeringTree_separates
  have hdepth := minimal.2 steeringTree usefulSplitting
  have himpossible :
      ¬ redundantSteeringTree.depth ≤ steeringTree.depth := by
    decide
  exact himpossible hdepth

/-- The positive boundary control remains the exact R0057 result: its
mandatory first step changes position and therefore is not removed by the
minimal-spine theorem. -/
theorem mandatorySteer_survives :
    ¬ ResidualCell.SamePosition automaton liveCell
      (ResidualCell.advance automaton liveCell steer false) :=
  AdaptiveResidualCycleDeletionControl.steer_changes_canonical_position

end AdaptiveResidualMinimalSpineControl

end Pairfield
