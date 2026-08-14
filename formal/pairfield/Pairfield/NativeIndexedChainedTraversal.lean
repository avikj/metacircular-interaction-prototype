/-
Copyright (c) 2026 Avik Jain and the mathematics collaboration.
Released under Apache 2.0 license.

Construction-specific trace chaining for the source-indexed reverse queue.
Unlike endpoint validity, this invariant records that every retained edge was
actually consumed at its advertised source and ends at its advertised target.
It is the sound parent carrier required before indexed traces can be compiled
into a reverse separator policy.
-/
import Pairfield.NativeIndexedPolicyBoundary

namespace Pairfield

universe u v

variable {A : Type u} {X : Type v}

namespace NativeIndexedChainedTraversal

open NativeReverseEdgeInventory
open NativeIndexedReverseTraversal

variable [DecidableEq X]
variable (M : DFA A X)
variable [DecidablePred (fun state : X => state ∈ M.accept)]

/-- A trace chained from the synthetic source to its displayed endpoint.
The snoc constructor matches `ReachNode.child`, which appends one edge. -/
inductive ChainedTo :
    List (ReverseEdge M) → SourceState X → Prop where
  | nil : ChainedTo [] .source
  | snoc {edges : List (ReverseEdge M)} {state : SourceState X}
      (hprefix : ChainedTo edges state) (edge : ReverseEdge M)
      (source_eq : reverseEdgeSourceState M edge = state) :
      ChainedTo (edges ++ [edge]) (reverseEdgeTargetState M edge)

def NodeChained
    (node : ReachNode (ReverseEdge M) (SourceState X)) : Prop :=
  ChainedTo M node.word node.state

theorem node_child_chained
    (node : ReachNode (ReverseEdge M) (SourceState X))
    (edge : ReverseEdge M) (hnode : NodeChained M node)
    (hsource : reverseEdgeSourceState M edge = node.state) :
    NodeChained M (node.child (indexedEdgeDFA M) edge) := by
  have hstep :
      (indexedEdgeDFA M).step node.state edge =
        reverseEdgeTargetState M edge := by
    simpa [hsource] using indexedEdgeDFA_step_source M edge
  change ChainedTo M (node.word ++ [edge])
    ((indexedEdgeDFA M).step node.state edge)
  rw [hstep]
  exact ChainedTo.snoc hnode edge hsource

/-- Every candidate emitted by destructive bucket consumption is chained.
The residual-index soundness needed by the recursive tail is transported at
the same time. -/
theorem consumeFrontier_candidates_chained
    (frontier : List (ReachNode (ReverseEdge M) (SourceState X)))
    (index : List (SourceBucket M)) (hsound : IndexSound M index)
    (hchained : ∀ node ∈ frontier, NodeChained M node) :
    ∀ candidate ∈ (consumeFrontier M frontier index).candidates,
      NodeChained M candidate := by
  induction frontier generalizing index with
  | nil => simp [consumeFrontier]
  | cons node rest ih =>
      intro candidate hcandidate
      simp only [consumeFrontier, List.mem_append, List.mem_map] at hcandidate
      rcases hcandidate with ⟨edge, hedge, rfl⟩ | htail
      · apply node_child_chained M node edge
          (hchained node List.mem_cons_self)
        exact takeBucket_edges_source M node.state index hsound hedge
      · apply ih (takeBucket M node.state index).2
          (takeBucket_remaining_sound M node.state index hsound)
          (fun old hold => hchained old (List.mem_cons_of_mem node hold))
          candidate htail

/-- Freshness filters candidates but cannot erase their chaining proofs. -/
theorem advanceQueue_nodes_chained (queue : IndexedQueue M)
    (hsound : IndexSound M queue.remaining)
    (hchained : ∀ node ∈ queue.nodes, NodeChained M node) :
    ∀ node ∈ (advanceQueue M queue).nodes, NodeChained M node := by
  intro node hnode
  let expansion := consumeFrontier M queue.frontier queue.remaining
  let next := freshNodes queue.states expansion.candidates
  change node ∈ queue.nodes ++ next at hnode
  rcases List.mem_append.mp hnode with hold | hfresh
  · exact hchained node hold
  · apply consumeFrontier_candidates_chained M queue.frontier queue.remaining
      hsound
      (fun old hfrontier =>
        hchained old (List.mem_append.mpr (Or.inr hfrontier)))
      node
    exact mem_freshNodes_imp_mem hfresh

/-- Every node retained at every indexed queue round is edge-by-edge chained,
not merely endpoint-valid. -/
theorem runQueue_nodes_chained (edges : List (ReverseEdge M)) (fuel : Nat) :
    ∀ node ∈ (runQueue M edges fuel).nodes, NodeChained M node := by
  induction fuel with
  | zero =>
      intro node hnode
      simp [runQueue, initialQueue, IndexedQueue.nodes] at hnode
      rcases hnode with rfl
      exact ChainedTo.nil
  | succ fuel ih =>
      exact advanceQueue_nodes_chained M (runQueue M edges fuel)
        (runQueue_remaining_sound M edges fuel) ih

/-- In a nonempty chained trace, the last edge really targets the displayed
endpoint. -/
theorem ChainedTo.last_target {edges : List (ReverseEdge M)}
    {state : SourceState X} {edge : ReverseEdge M}
    (hchain : ChainedTo M edges state)
    (hlast : edges.getLast? = some edge) :
    reverseEdgeTargetState M edge = state := by
  cases hchain with
  | nil => simp at hlast
  | snoc hprefix last source_eq =>
      have hedge : last = edge := by simpa using hlast
      subst edge
      rfl

theorem node_last_edge_targets
    {node : ReachNode (ReverseEdge M) (SourceState X)}
    {edge : ReverseEdge M} (hnode : NodeChained M node)
    (hlast : node.word.getLast? = some edge) :
    reverseEdgeTargetState M edge = node.state :=
  hnode.last_target hlast

/-- The earlier endpoint-valid counterexample is excluded from every actual
indexed queue, for every edge inventory and every amount of fuel. -/
theorem boundary_node_not_in_runQueue
    (edges : List (ReverseEdge NativeIndexedPolicyBoundary.controlM))
    (fuel : Nat) :
    NativeIndexedPolicyBoundary.validButUnchainedNode ∉
      (runQueue NativeIndexedPolicyBoundary.controlM edges fuel).nodes := by
  intro hmem
  have hchain := runQueue_nodes_chained
    NativeIndexedPolicyBoundary.controlM edges fuel
    NativeIndexedPolicyBoundary.validButUnchainedNode hmem
  have htarget := node_last_edge_targets
    NativeIndexedPolicyBoundary.controlM hchain
    NativeIndexedPolicyBoundary.validButUnchainedNode_last
  exact NativeIndexedPolicyBoundary.wrongPredecessor_target_ne_node htarget

end NativeIndexedChainedTraversal

end Pairfield
