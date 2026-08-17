/-
Copyright (c) 2026 Avik Jain and the mathematics collaboration.
Released under Apache 2.0 license.

Extract the first policy-relevant projection from the source-indexed queue's
checked causal traces: the last edge of every nonempty retained word really
targets the retained node.  This is strictly stronger than endpoint validity
and is exactly the fact falsified by `NativeIndexedPolicyBoundary` for an
arbitrary unchained word.
-/
import Pairfield.NativeIndexedPolicyBoundary

namespace Pairfield

universe u v

variable {A : Type u} {X : Type v}

namespace NativeIndexedParentExtraction

open NativeReverseEdgeInventory
open NativeIndexedReverseTraversal

variable [DecidableEq X]
variable (M : DFA A X)
variable [DecidablePred (fun state : X => state ∈ M.accept)]

/-- In a nonempty causal trace, the last edge targets the displayed endpoint.
This induction is independent of how the trace was discovered. -/
theorem chained_last_target {start finish : SourceState X}
    {edges : List (ReverseEdge M)} {edge : ReverseEdge M}
    (hchain : EdgeTrace.Chained M start edges finish)
    (hlast : edges.getLast? = some edge) :
    reverseEdgeTargetState M edge = finish := by
  induction hchain with
  | nil state => simp at hlast
  | @cons start finish rest first hsource tail ih =>
      cases rest with
      | nil =>
          simp at hlast
          subst edge
          cases tail
          rfl
      | cons second more =>
          apply ih
          simpa using hlast

/-- A chained retained node exposes a sound final parent edge. -/
theorem node_last_edge_targets
    {node : ReachNode (ReverseEdge M) (SourceState X)}
    {edge : ReverseEdge M} (hnode : NodeChained M node)
    (hlast : node.word.getLast? = some edge) :
    reverseEdgeTargetState M edge = node.state :=
  chained_last_target M hnode hlast

/-- Every nonempty node retained by the complete indexed traversal has a
sound final edge target.  This is the exact parent projection available before
queue completeness supplies a node for every unequal product pair. -/
theorem indexedTraversal_last_edge_targets [LinearOrder X] [Fintype X]
    (alphabet : List A)
    {node : ReachNode (ReverseEdge M) (SourceState X)}
    (hnode : node ∈ (indexedTraversal M alphabet).nodes)
    {edge : ReverseEdge M} (hlast : node.word.getLast? = some edge) :
    reverseEdgeTargetState M edge = node.state := by
  apply node_last_edge_targets M
    (show NodeChained M node from ?_) hlast
  simpa [indexedTraversal] using
    runQueue_nodes_chained M (edgeInventory M alphabet)
      (Fintype.card X * Fintype.card X + 1) node hnode

/-- The endpoint-valid but unchained hostile node can never be retained by
the source-indexed queue, for any inventory or fuel. -/
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

end NativeIndexedParentExtraction

end Pairfield
