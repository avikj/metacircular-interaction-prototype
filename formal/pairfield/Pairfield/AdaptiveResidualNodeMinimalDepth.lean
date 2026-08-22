/-
Copyright (c) 2026 Avik Jain and the mathematics collaboration.
Released under Apache 2.0 license.

A depth-realizing proof-relevant spine for residual split plans, closing the
last interface between the duplicate-free spine theorem and native tree depth.
-/
import Pairfield.AdaptiveResidualNodeMinimalSpine

namespace Pairfield

universe u v

variable {A : Type u} {X : Type v}

namespace ResidualPlanSpine

/-- Every certified plan has a proof-relevant root-to-leaf spine whose number
of nodes is exactly native tree depth plus one. -/
theorem exists_depthRealizingSpine
    (M : DFA A X) [DecidablePred (fun state : X => state ∈ M.accept)]
    {cell : Set (List A)} (plan : ResidualSplitPlan M cell) :
    ∃ tail : List (Node M),
      ((⟨cell, plan⟩ : Node M) :: tail).Pairwise
        (fun earlier later => StrictDescendant M later earlier) ∧
      ((⟨cell, plan⟩ : Node M) :: tail).length =
        plan.toTree.depth + 1 := by
  induction plan with
  | done homogeneous =>
      exact ⟨[], by simp, by simp [ResidualSplitPlan.toTree,
        BoolExperimentTree.depth]⟩
  | @query cell action safe onFalse onTrue ihFalse ihTrue =>
      by_cases hdepth : onTrue.toTree.depth ≤ onFalse.toTree.depth
      · obtain ⟨tail, hchain, hlength⟩ := ihFalse
        let root : Node M :=
          ⟨cell, .query action safe onFalse onTrue⟩
        let child : Node M :=
          ⟨ResidualCell.advance M cell action false, onFalse⟩
        have hchildRoot : StrictDescendant M child root := by
          exact ResidualSplitPlan.StrictSubplan.onFalse
            action safe onFalse onTrue
        have hrootAll : ∀ node ∈ child :: tail,
            StrictDescendant M node root := by
          intro node hnode
          rcases List.mem_cons.mp hnode with rfl | htail
          · exact hchildRoot
          · exact ResidualSplitPlan.StrictSubplan.trans
              ((List.pairwise_cons.mp hchain).1 node htail) hchildRoot
        refine ⟨child :: tail, ?_, ?_⟩
        · exact List.pairwise_cons.mpr ⟨hrootAll, hchain⟩
        · change (root :: child :: tail).length = _
          simp only [List.length_cons]
          change (child :: tail).length + 1 = _
          rw [hlength]
          simp only [ResidualSplitPlan.toTree, BoolExperimentTree.depth]
          rw [max_eq_left hdepth]
      · have hdepth' : onFalse.toTree.depth ≤ onTrue.toTree.depth := by
          omega
        obtain ⟨tail, hchain, hlength⟩ := ihTrue
        let root : Node M :=
          ⟨cell, .query action safe onFalse onTrue⟩
        let child : Node M :=
          ⟨ResidualCell.advance M cell action true, onTrue⟩
        have hchildRoot : StrictDescendant M child root := by
          exact ResidualSplitPlan.StrictSubplan.onTrue
            action safe onFalse onTrue
        have hrootAll : ∀ node ∈ child :: tail,
            StrictDescendant M node root := by
          intro node hnode
          rcases List.mem_cons.mp hnode with rfl | htail
          · exact hchildRoot
          · exact ResidualSplitPlan.StrictSubplan.trans
              ((List.pairwise_cons.mp hchain).1 node htail) hchildRoot
        refine ⟨child :: tail, ?_, ?_⟩
        · exact List.pairwise_cons.mpr ⟨hrootAll, hchain⟩
        · change (root :: child :: tail).length = _
          simp only [List.length_cons]
          change (child :: tail).length + 1 = _
          rw [hlength]
          simp only [ResidualSplitPlan.toTree, BoolExperimentTree.depth]
          rw [max_eq_right hdepth']

/-- Native depth consequence of the finite Mathlib carrier.  For every
node-minimal residual split plan over a regular language, depth plus one is at
most the number of subsets of canonical residual states. -/
theorem nodeMinimal_depth_add_one_le_two_pow_stateCount
    (M : DFA A X) [DecidablePred (fun state : X => state ∈ M.accept)]
    (regular : M.accepts.IsRegular)
    {cell : Set (List A)} (plan : ResidualSplitPlan M cell)
    (constant : ResidualCell.CurrentConstant M cell)
    (minimal : ResidualSplitPlan.NodeMinimal plan) :
    plan.toTree.depth + 1 ≤
      2 ^ CanonicalResidualPosition.stateCount M regular := by
  obtain ⟨tail, hchain, hlength⟩ := exists_depthRealizingSpine M plan
  have hbound := rooted_spine_length_le_two_pow_stateCount M regular
    (⟨cell, plan⟩ : Node M) tail constant minimal hchain
  rw [hlength] at hbound
  exact hbound

end ResidualPlanSpine

end Pairfield
