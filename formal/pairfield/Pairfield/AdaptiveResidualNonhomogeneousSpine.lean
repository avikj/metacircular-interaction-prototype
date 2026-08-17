/-
Copyright (c) 2026 Avik Jain and the mathematics collaboration.
Released under Apache 2.0 license.

Internal nodes of a node-minimal residual plan cannot already be
homogeneous.  This removes the empty and singleton subsets from the finite
Mathlib residual-position budget and strictly refines the coarse powerset
depth bound.
-/
import Pairfield.AdaptiveResidualNodeMinimalDepth

namespace Pairfield

universe u v

variable {A : Type u} {X : Type v}

namespace ResidualSplitPlan

/-- A node-minimal plan never queries a cell whose residuals are already
homogeneous: the certified leaf is a strictly cheaper replacement. -/
theorem not_homogeneous_of_nodeMinimal_query
    {M : DFA A X} [DecidablePred (fun state : X => state ∈ M.accept)]
    {cell : Set (List A)} (action : A)
    (safe : ResidualCell.SafeAction M cell action)
    (onFalse : ResidualSplitPlan M
      (ResidualCell.advance M cell action false))
    (onTrue : ResidualSplitPlan M
      (ResidualCell.advance M cell action true))
    (minimal : NodeMinimal (.query action safe onFalse onTrue)) :
    ¬ ResidualCell.Homogeneous M cell := by
  intro homogeneous
  have hle := minimal (.done homogeneous)
  simp [toTree] at hle

end ResidualSplitPlan

namespace ResidualPlanSpine

/-- A proof-relevant node whose certified plan performs a query. -/
def IsQuery
    (M : DFA A X) [DecidablePred (fun state : X => state ∈ M.accept)]
    (node : Node M) : Prop :=
  match node.plan with
  | .done _ => False
  | .query _ _ _ _ => True

/-- Finset presentation of a node's canonical position, using exactly the
Mathlib finite residual carrier supplied by regularity. -/
noncomputable def finitePositionFinset
    (M : DFA A X) [DecidablePred (fun state : X => state ∈ M.accept)]
    (regular : M.accepts.IsRegular) (node : Node M) :
    Finset (CanonicalResidualPosition.State M) := by
  classical
  letI : Fintype (CanonicalResidualPosition.State M) :=
    CanonicalResidualPosition.residualFintype M regular
  exact Finset.univ.filter fun state => state ∈ FinitePosition M node

@[simp] theorem mem_finitePositionFinset
    (M : DFA A X) [DecidablePred (fun state : X => state ∈ M.accept)]
    (regular : M.accepts.IsRegular) (node : Node M)
    (state : CanonicalResidualPosition.State M) :
    state ∈ finitePositionFinset M regular node ↔
      state ∈ FinitePosition M node := by
  classical
  letI : Fintype (CanonicalResidualPosition.State M) :=
    CanonicalResidualPosition.residualFintype M regular
  simp [finitePositionFinset]

/-- Following a deepest child records exactly the query nodes on a
depth-realizing root-to-leaf route.  Unlike `exists_depthRealizingSpine`, the
terminal leaf is omitted, so every recorded position is nonhomogeneous in a
node-minimal plan. -/
theorem exists_depthRealizingQuerySpine
    (M : DFA A X) [DecidablePred (fun state : X => state ∈ M.accept)]
    {cell : Set (List A)} (plan : ResidualSplitPlan M cell) :
    ∃ nodes : List (Node M),
      nodes.length = plan.toTree.depth ∧
      nodes.Pairwise (fun earlier later =>
        StrictDescendant M later earlier) ∧
      (∀ node ∈ nodes, IsQuery M node) ∧
      (∀ node ∈ nodes,
        node = (⟨cell, plan⟩ : Node M) ∨
          StrictDescendant M node (⟨cell, plan⟩ : Node M)) := by
  induction plan with
  | done homogeneous =>
      exact ⟨[], by simp [ResidualSplitPlan.toTree,
        BoolExperimentTree.depth], by simp, by simp, by simp⟩
  | @query cell action safe onFalse onTrue ihFalse ihTrue =>
      let root : Node M :=
        ⟨cell, .query action safe onFalse onTrue⟩
      by_cases hdepth : onTrue.toTree.depth ≤ onFalse.toTree.depth
      · obtain ⟨nodes, hlength, hchain, hquery, hrooted⟩ := ihFalse
        let child : Node M :=
          ⟨ResidualCell.advance M cell action false, onFalse⟩
        have hchildRoot : StrictDescendant M child root := by
          exact ResidualSplitPlan.StrictSubplan.onFalse
            action safe onFalse onTrue
        have hrootAll : ∀ node ∈ nodes,
            StrictDescendant M node root := by
          intro node hnode
          rcases hrooted node hnode with rfl | hdesc
          · exact hchildRoot
          · exact ResidualSplitPlan.StrictSubplan.trans hdesc hchildRoot
        refine ⟨root :: nodes, ?_, ?_, ?_, ?_⟩
        · simp only [List.length_cons, ResidualSplitPlan.toTree,
            BoolExperimentTree.depth]
          rw [hlength, max_eq_left hdepth]
        · exact List.pairwise_cons.mpr ⟨hrootAll, hchain⟩
        · intro node hnode
          rcases List.mem_cons.mp hnode with rfl | htail
          · trivial
          · exact hquery node htail
        · intro node hnode
          rcases List.mem_cons.mp hnode with rfl | htail
          · exact Or.inl rfl
          · exact Or.inr (hrootAll node htail)
      · have hdepth' : onFalse.toTree.depth ≤ onTrue.toTree.depth := by
          omega
        obtain ⟨nodes, hlength, hchain, hquery, hrooted⟩ := ihTrue
        let child : Node M :=
          ⟨ResidualCell.advance M cell action true, onTrue⟩
        have hchildRoot : StrictDescendant M child root := by
          exact ResidualSplitPlan.StrictSubplan.onTrue
            action safe onFalse onTrue
        have hrootAll : ∀ node ∈ nodes,
            StrictDescendant M node root := by
          intro node hnode
          rcases hrooted node hnode with rfl | hdesc
          · exact hchildRoot
          · exact ResidualSplitPlan.StrictSubplan.trans hdesc hchildRoot
        refine ⟨root :: nodes, ?_, ?_, ?_, ?_⟩
        · simp only [List.length_cons, ResidualSplitPlan.toTree,
            BoolExperimentTree.depth]
          rw [hlength, max_eq_right hdepth']
        · exact List.pairwise_cons.mpr ⟨hrootAll, hchain⟩
        · intro node hnode
          rcases List.mem_cons.mp hnode with rfl | htail
          · trivial
          · exact hquery node htail
        · intro node hnode
          rcases List.mem_cons.mp hnode with rfl | htail
          · exact Or.inl rfl
          · exact Or.inr (hrootAll node htail)

/-- A finite canonical position with at most one residual makes its native
prefix cell homogeneous. -/
theorem homogeneous_of_finitePosition_card_le_one
    (M : DFA A X) [DecidablePred (fun state : X => state ∈ M.accept)]
    (regular : M.accepts.IsRegular) (node : Node M)
    (hcard : (finitePositionFinset M regular node).card ≤ 1) :
    ResidualCell.Homogeneous M node.cell := by
  classical
  letI : Fintype (CanonicalResidualPosition.State M) :=
    CanonicalResidualPosition.residualFintype M regular
  intro left right hleft hright
  have hleftMem : CanonicalResidualAdapter.branchState M left ∈
      finitePositionFinset M regular node := by
    rw [mem_finitePositionFinset]
    simp only [FinitePosition]
    exact ⟨left, hleft, rfl⟩
  have hrightMem : CanonicalResidualAdapter.branchState M right ∈
      finitePositionFinset M regular node := by
    rw [mem_finitePositionFinset]
    simp only [FinitePosition]
    exact ⟨right, hright, rfl⟩
  have heq := (Finset.card_le_one.mp hcard)
    _ hleftMem _ hrightMem
  exact congrArg Subtype.val heq

/-- Node minimality upgrades every query position from an arbitrary subset to
one containing at least two canonical residual states. -/
theorem two_le_finitePosition_card_of_query
    (M : DFA A X) [DecidablePred (fun state : X => state ∈ M.accept)]
    (regular : M.accepts.IsRegular) (node : Node M)
    (minimal : ResidualSplitPlan.NodeMinimal node.plan)
    (query : IsQuery M node) :
    2 ≤ (finitePositionFinset M regular node).card := by
  classical
  letI : Fintype (CanonicalResidualPosition.State M) :=
    CanonicalResidualPosition.residualFintype M regular
  by_contra hnot
  have hcard : (finitePositionFinset M regular node).card ≤ 1 := by omega
  have homogeneous := homogeneous_of_finitePosition_card_le_one
    M regular node hcard
  cases hplan : node.plan with
  | done doneHomogeneous =>
      simp [IsQuery, hplan] at query
  | query action safe onFalse onTrue =>
      have hminimal : ResidualSplitPlan.NodeMinimal
          (.query action safe onFalse onTrue) := by
        simpa [hplan] using minimal
      exact ResidualSplitPlan.not_homogeneous_of_nodeMinimal_query
        action safe onFalse onTrue hminimal homogeneous

/-- The empty canonical position followed by all singleton positions.  These
are precisely the finite subsets a node-minimal query spine cannot visit. -/
noncomputable def smallPositions
    (M : DFA A X) (regular : M.accepts.IsRegular) :
    List (Finset (CanonicalResidualPosition.State M)) := by
  classical
  letI : Fintype (CanonicalResidualPosition.State M) :=
    CanonicalResidualPosition.residualFintype M regular
  exact ∅ :: (Finset.univ.toList.map fun state => {state})

theorem smallPositions_nodup
    (M : DFA A X) (regular : M.accepts.IsRegular) :
    (smallPositions M regular).Nodup := by
  classical
  letI : Fintype (CanonicalResidualPosition.State M) :=
    CanonicalResidualPosition.residualFintype M regular
  rw [smallPositions, List.nodup_cons]
  constructor
  · intro hmem
    rcases List.mem_map.mp hmem with ⟨state, _hstate, hzero⟩
    simpa using hzero.symm
  · exact Finset.univ.nodup_toList.map fun left right heq => by
      simpa using heq

theorem smallPositions_length
    (M : DFA A X) (regular : M.accepts.IsRegular) :
    (smallPositions M regular).length =
      CanonicalResidualPosition.stateCount M regular + 1 := by
  classical
  letI : Fintype (CanonicalResidualPosition.State M) :=
    CanonicalResidualPosition.residualFintype M regular
  simp [smallPositions, CanonicalResidualPosition.stateCount,
    Nat.add_comm]

theorem card_le_one_of_mem_smallPositions
    (M : DFA A X) (regular : M.accepts.IsRegular)
    (position : Finset (CanonicalResidualPosition.State M))
    (hposition : position ∈ smallPositions M regular) :
    position.card ≤ 1 := by
  classical
  letI : Fintype (CanonicalResidualPosition.State M) :=
    CanonicalResidualPosition.residualFintype M regular
  simp [smallPositions] at hposition
  rcases hposition with rfl | ⟨state, _hstate, rfl⟩ <;> simp

/-- Strictly refined native depth bound.  Internal nodes occupy distinct
canonical residual subsets of size at least two, so the empty set and all `n`
singletons can be added to the history before applying Mathlib's finite
powerset count. -/
theorem nodeMinimal_depth_add_one_le_two_pow_sub_stateCount
    (M : DFA A X) [DecidablePred (fun state : X => state ∈ M.accept)]
    (regular : M.accepts.IsRegular)
    {cell : Set (List A)} (plan : ResidualSplitPlan M cell)
    (constant : ResidualCell.CurrentConstant M cell)
    (minimal : ResidualSplitPlan.NodeMinimal plan) :
    plan.toTree.depth + 1 ≤
      2 ^ CanonicalResidualPosition.stateCount M regular -
        CanonicalResidualPosition.stateCount M regular := by
  classical
  letI : Fintype (CanonicalResidualPosition.State M) :=
    CanonicalResidualPosition.residualFintype M regular
  obtain ⟨nodes, hlength, hchain, hquery, hrooted⟩ :=
    exists_depthRealizingQuerySpine M plan
  let positions : List (Finset (CanonicalResidualPosition.State M)) :=
    nodes.map fun node => finitePositionFinset M regular node
  have hconstant : ∀ node ∈ nodes,
      ResidualCell.CurrentConstant M node.cell := by
    intro node hnode
    rcases hrooted node hnode with rfl | hdesc
    · exact constant
    · exact ResidualSplitPlan.currentConstant_of_strictSubplan hdesc
  have hminimal : ∀ node ∈ nodes,
      ResidualSplitPlan.NodeMinimal node.plan := by
    intro node hnode
    rcases hrooted node hnode with rfl | hdesc
    · exact minimal
    · exact ResidualSplitPlan.nodeMinimal_of_strictSubplan minimal hdesc
  have hpositionNodup : (nodes.map (Position M)).Nodup :=
    positions_nodup M nodes hconstant hminimal hchain
  have hpositionsNodup : positions.Nodup := by
    have hnodesNodup : nodes.Nodup := hpositionNodup.of_map (Position M)
    apply hnodesNodup.map_on
    intro left hleft right hright heq
    have hset : FinitePosition M left = FinitePosition M right := by
      ext state
      have hmem := Finset.ext_iff.mp heq state
      simpa using hmem
    have hpositionEq :=
      (finitePosition_eq_iff_position_eq M left right).1 hset
    exact List.inj_on_of_nodup_map hpositionNodup
      hleft hright hpositionEq
  have hlarge : ∀ position ∈ positions, 2 ≤ position.card := by
    intro position hposition
    rcases List.mem_map.mp hposition with ⟨node, hnode, rfl⟩
    exact two_le_finitePosition_card_of_query M regular node
      (hminimal node hnode) (hquery node hnode)
  have hdisjoint : List.Disjoint positions (smallPositions M regular) := by
    rw [List.disjoint_left]
    intro position hposition hsmall
    have htwo := hlarge position hposition
    have hone := card_le_one_of_mem_smallPositions M regular position hsmall
    omega
  have happend : (positions ++ smallPositions M regular).Nodup :=
    List.nodup_append'.2
      ⟨hpositionsNodup, smallPositions_nodup M regular, hdisjoint⟩
  have hcarrier := happend.length_le_card
  have hpositionsLength : positions.length = plan.toTree.depth := by
    simp [positions, hlength]
  have hstateCard : Fintype.card (CanonicalResidualPosition.State M) =
      CanonicalResidualPosition.stateCount M regular := rfl
  have hfinsetCard :
      Fintype.card (Finset (CanonicalResidualPosition.State M)) =
        2 ^ CanonicalResidualPosition.stateCount M regular := by
    rw [Fintype.card_finset, hstateCard]
  have hbudget : plan.toTree.depth +
        (CanonicalResidualPosition.stateCount M regular + 1) ≤
      2 ^ CanonicalResidualPosition.stateCount M regular := by
    rw [List.length_append, hpositionsLength,
      smallPositions_length M regular, hfinsetCard] at hcarrier
    exact hcarrier
  omega

end ResidualPlanSpine

end Pairfield
