/-
Copyright (c) 2026 Avik Jain and the mathematics collaboration.
Released under Apache 2.0 license.

Node-minimal residual plans have duplicate-free canonical-position spines.
This complements depth minimality: the secondary node count makes every
branch-local subplan minimal, including subtrees off a deepest branch.
-/
import Pairfield.AdaptiveResidualPositionCycleAdapter

namespace Pairfield

universe u v

variable {A : Type u} {X : Type v}

namespace BoolExperimentTree

def queryCount : BoolExperimentTree A → Nat
  | .done => 0
  | .query _ onFalse onTrue =>
      onFalse.queryCount + onTrue.queryCount + 1

@[simp] theorem queryCount_done :
    (BoolExperimentTree.done : BoolExperimentTree A).queryCount = 0 := rfl

@[simp] theorem queryCount_query
    (action : A) (onFalse onTrue : BoolExperimentTree A) :
    (BoolExperimentTree.query action onFalse onTrue).queryCount =
      onFalse.queryCount + onTrue.queryCount + 1 := rfl

end BoolExperimentTree

namespace ResidualSplitPlan

def NodeMinimal
    {M : DFA A X} [DecidablePred (fun state : X => state ∈ M.accept)]
    {cell : Set (List A)} (plan : ResidualSplitPlan M cell) : Prop :=
  ∀ candidate : ResidualSplitPlan M cell,
    plan.toTree.queryCount ≤ candidate.toTree.queryCount

/-- Minimizing a natural-valued native cost always produces a certified
node-minimal plan on the same cell. -/
theorem exists_nodeMinimal
    {M : DFA A X} [DecidablePred (fun state : X => state ∈ M.accept)]
    {cell : Set (List A)} (initial : ResidualSplitPlan M cell) :
    ∃ plan : ResidualSplitPlan M cell, NodeMinimal plan := by
  classical
  let existsCost : ∃ cost : Nat, ∃ plan : ResidualSplitPlan M cell,
      plan.toTree.queryCount = cost :=
    ⟨initial.toTree.queryCount, initial, rfl⟩
  obtain ⟨plan, hcost⟩ := Nat.find_spec existsCost
  refine ⟨plan, ?_⟩
  intro candidate
  rw [hcost]
  exact Nat.find_min' existsCost ⟨candidate, rfl⟩

/-- Proof-relevant strict descent through one or more children of a plan. -/
inductive StrictSubplan
    (M : DFA A X) [DecidablePred (fun state : X => state ∈ M.accept)] :
    {childCell rootCell : Set (List A)} →
      ResidualSplitPlan M childCell →
      ResidualSplitPlan M rootCell → Prop
  | onFalse {cell : Set (List A)}
      (action : A) (safe : ResidualCell.SafeAction M cell action)
      (left : ResidualSplitPlan M
        (ResidualCell.advance M cell action false))
      (right : ResidualSplitPlan M
        (ResidualCell.advance M cell action true)) :
      StrictSubplan M left (.query action safe left right)
  | onTrue {cell : Set (List A)}
      (action : A) (safe : ResidualCell.SafeAction M cell action)
      (left : ResidualSplitPlan M
        (ResidualCell.advance M cell action false))
      (right : ResidualSplitPlan M
        (ResidualCell.advance M cell action true)) :
      StrictSubplan M right (.query action safe left right)
  | trans {childCell middleCell rootCell : Set (List A)}
      {child : ResidualSplitPlan M childCell}
      {middle : ResidualSplitPlan M middleCell}
      {root : ResidualSplitPlan M rootCell} :
      StrictSubplan M child middle →
      StrictSubplan M middle root →
      StrictSubplan M child root

theorem queryCount_lt_of_strictSubplan
    {M : DFA A X} [DecidablePred (fun state : X => state ∈ M.accept)]
    {childCell rootCell : Set (List A)}
    {child : ResidualSplitPlan M childCell}
    {root : ResidualSplitPlan M rootCell}
    (hsub : StrictSubplan M child root) :
    child.toTree.queryCount < root.toTree.queryCount := by
  induction hsub with
  | onFalse => simp [toTree]
  | onTrue => simp [toTree]
  | trans hchild hroot ihChild ihRoot => exact ihChild.trans ihRoot

theorem currentConstant_of_strictSubplan
    {M : DFA A X} [DecidablePred (fun state : X => state ∈ M.accept)]
    {childCell rootCell : Set (List A)}
    {child : ResidualSplitPlan M childCell}
    {root : ResidualSplitPlan M rootCell}
    (hsub : StrictSubplan M child root) :
    ResidualCell.CurrentConstant M childCell := by
  induction hsub with
  | onFalse action =>
      exact ResidualCell.advance_currentConstant M _ action false
  | onTrue action =>
      exact ResidualCell.advance_currentConstant M _ action true
  | trans hchild hroot ihChild ihRoot => exact ihChild

/-- This is the branch-local minimality joint: a node-minimal plan makes every
strict subplan node-minimal, even when that child is not depth-maximal. -/
theorem nodeMinimal_of_strictSubplan
    {M : DFA A X} [DecidablePred (fun state : X => state ∈ M.accept)]
    {childCell rootCell : Set (List A)}
    {child : ResidualSplitPlan M childCell}
    {root : ResidualSplitPlan M rootCell}
    (hminimal : NodeMinimal root)
    (hsub : StrictSubplan M child root) :
    NodeMinimal child := by
  induction hsub with
  | onFalse action safe left right =>
      intro candidate
      have hle := hminimal (.query action safe candidate right)
      simp only [toTree, BoolExperimentTree.queryCount] at hle
      omega
  | onTrue action safe left right =>
      intro candidate
      have hle := hminimal (.query action safe left candidate)
      simp only [toTree, BoolExperimentTree.queryCount] at hle
      omega
  | trans hchild hroot ihChild ihRoot =>
      exact ihChild (ihRoot hminimal)

/-- R0059 globalized: a node-minimal plan cannot revisit its root canonical
position at any strict descendant. -/
theorem position_ne_of_strictSubplan
    {M : DFA A X} [DecidablePred (fun state : X => state ∈ M.accept)]
    {childCell rootCell : Set (List A)}
    {child : ResidualSplitPlan M childCell}
    {root : ResidualSplitPlan M rootCell}
    (rootConstant : ResidualCell.CurrentConstant M rootCell)
    (rootMinimal : NodeMinimal root)
    (hsub : StrictSubplan M child root) :
    ¬ ResidualCell.SamePosition M rootCell childCell := by
  intro hsame
  let candidate : ResidualSplitPlan M rootCell :=
    transplantAtSamePosition M child.toTree rootCell childCell
      rootConstant (currentConstant_of_strictSubplan hsub) hsame
      child.toTree_residualSplitting
  have hle := rootMinimal candidate
  have htree : candidate.toTree = child.toTree :=
    transplantAtSamePosition_toTree M child.toTree rootCell childCell
      rootConstant (currentConstant_of_strictSubplan hsub) hsame
      child.toTree_residualSplitting
  rw [htree] at hle
  exact (Nat.not_le_of_lt (queryCount_lt_of_strictSubplan hsub)) hle

end ResidualSplitPlan

namespace ResidualPlanSpine

structure Node
    (M : DFA A X) [DecidablePred (fun state : X => state ∈ M.accept)] where
  cell : Set (List A)
  plan : ResidualSplitPlan M cell

def Position
    (M : DFA A X) [DecidablePred (fun state : X => state ∈ M.accept)]
    (node : Node M) : Set (Language A) :=
  ResidualCell.Position M node.cell

def StrictDescendant
    (M : DFA A X) [DecidablePred (fun state : X => state ∈ M.accept)]
    (child root : Node M) : Prop :=
  ResidualSplitPlan.StrictSubplan M child.plan root.plan

/-- Exact `Nodup` conclusion for any locally certified plan spine. -/
theorem positions_nodup
    (M : DFA A X) [DecidablePred (fun state : X => state ∈ M.accept)]
    (nodes : List (Node M))
    (hconstant : ∀ node ∈ nodes,
      ResidualCell.CurrentConstant M node.cell)
    (hminimal : ∀ node ∈ nodes,
      ResidualSplitPlan.NodeMinimal node.plan)
    (hchain : nodes.Pairwise fun earlier later =>
      StrictDescendant M later earlier) :
    (nodes.map (Position M)).Nodup := by
  induction nodes with
  | nil => simp
  | cons head tail ih =>
      rw [List.map_cons, List.nodup_cons]
      have hpair := List.pairwise_cons.mp hchain
      constructor
      · intro hmem
        rcases List.mem_map.mp hmem with ⟨later, hlater, heq⟩
        have hne := ResidualSplitPlan.position_ne_of_strictSubplan
          (hconstant head (by simp)) (hminimal head (by simp))
          (hpair.1 later hlater)
        exact hne heq.symm
      · apply ih
        · intro node hnode
          exact hconstant node (by simp [hnode])
        · intro node hnode
          exact hminimal node (by simp [hnode])
        · exact hpair.2

/-- Root minimality supplies all local minimality premises along the spine. -/
theorem rooted_positions_nodup
    (M : DFA A X) [DecidablePred (fun state : X => state ∈ M.accept)]
    (root : Node M) (tail : List (Node M))
    (rootConstant : ResidualCell.CurrentConstant M root.cell)
    (rootMinimal : ResidualSplitPlan.NodeMinimal root.plan)
    (hchain : (root :: tail).Pairwise fun earlier later =>
      StrictDescendant M later earlier) :
    ((root :: tail).map (Position M)).Nodup := by
  apply positions_nodup M (root :: tail)
  · intro node hnode
    rcases List.mem_cons.mp hnode with rfl | htail
    · exact rootConstant
    · exact ResidualSplitPlan.currentConstant_of_strictSubplan
        ((List.pairwise_cons.mp hchain).1 node htail)
  · intro node hnode
    rcases List.mem_cons.mp hnode with rfl | htail
    · exact rootMinimal
    · exact ResidualSplitPlan.nodeMinimal_of_strictSubplan rootMinimal
        ((List.pairwise_cons.mp hchain).1 node htail)
  · exact hchain

/-- Formation's language-valued position as a subset of Mathlib's canonical
left-quotient state type. -/
def FinitePosition
    (M : DFA A X) [DecidablePred (fun state : X => state ∈ M.accept)]
    (node : Node M) : Set (CanonicalResidualPosition.State M) :=
  { state | state.val ∈ Position M node }

theorem finitePosition_eq_iff_position_eq
    (M : DFA A X) [DecidablePred (fun state : X => state ∈ M.accept)]
    (left right : Node M) :
    FinitePosition M left = FinitePosition M right ↔
      Position M left = Position M right := by
  constructor
  · intro hfinite
    apply Set.ext
    intro language
    constructor
    · rintro ⟨pre, hpre, rfl⟩
      have hleft : CanonicalResidualAdapter.branchState M pre ∈
          FinitePosition M left := ⟨pre, hpre, rfl⟩
      have hright : CanonicalResidualAdapter.branchState M pre ∈
          FinitePosition M right := by rw [← hfinite]; exact hleft
      exact hright
    · rintro ⟨pre, hpre, rfl⟩
      have hright : CanonicalResidualAdapter.branchState M pre ∈
          FinitePosition M right := ⟨pre, hpre, rfl⟩
      have hleft : CanonicalResidualAdapter.branchState M pre ∈
          FinitePosition M left := by rw [hfinite]; exact hright
      exact hleft
  · intro hposition
    ext state
    exact Set.ext_iff.mp hposition state.val

/-- Reciprocal finite-carrier result: every node-minimal spine has length at
most `2^n`, where `n` is the number of Mathlib left quotients.  No sharp ADS
bound is claimed. -/
theorem rooted_spine_length_le_two_pow_stateCount
    (M : DFA A X) [DecidablePred (fun state : X => state ∈ M.accept)]
    (regular : M.accepts.IsRegular)
    (root : Node M) (tail : List (Node M))
    (rootConstant : ResidualCell.CurrentConstant M root.cell)
    (rootMinimal : ResidualSplitPlan.NodeMinimal root.plan)
    (hchain : (root :: tail).Pairwise fun earlier later =>
      StrictDescendant M later earlier) :
    (root :: tail).length ≤
      2 ^ CanonicalResidualPosition.stateCount M regular := by
  classical
  letI : Fintype (CanonicalResidualPosition.State M) :=
    CanonicalResidualPosition.residualFintype M regular
  have hposition := rooted_positions_nodup M root tail
    rootConstant rootMinimal hchain
  have hnodes : (root :: tail).Nodup := hposition.of_map (Position M)
  have hfinite : ((root :: tail).map (FinitePosition M)).Nodup := by
    apply hnodes.map_on
    intro left hleft right hright heq
    have hposEq := (finitePosition_eq_iff_position_eq M left right).1 heq
    exact List.inj_on_of_nodup_map hposition hleft hright hposEq
  calc
    (root :: tail).length =
        ((root :: tail).map (FinitePosition M)).length := by simp
    _ ≤ Fintype.card (Set (CanonicalResidualPosition.State M)) :=
      hfinite.length_le_card
    _ = 2 ^ CanonicalResidualPosition.stateCount M regular := by
      simp [CanonicalResidualPosition.stateCount]

end ResidualPlanSpine

end Pairfield
