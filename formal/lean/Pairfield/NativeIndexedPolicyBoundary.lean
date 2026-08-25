/-
Copyright (c) 2026 Avik Jain and the mathematics collaboration.
Released under Apache 2.0 license.

An exact boundary for extracting a separator policy from retained indexed
reverse traces.  Endpoint validity alone does not imply that the last edge is
the parent edge of the retained state: a predecessor label used at the wrong
source is a no-op in the underlying reverse DFA.  Policy extraction therefore
needs an edge-by-edge chaining invariant in addition to `ReachNode.Valid`.
-/
import Pairfield.NativeIndexedReverseTraversal

namespace Pairfield

namespace NativeIndexedPolicyBoundary

open NativeReversePairTraversal
open NativeReverseEdgeInventory
open NativeIndexedReverseTraversal

abbrev controlM : DFA Bool (Fin 3) :=
  VisitedPairHorizonWitness.automaton

/-- A genuine terminal seed for the response-separated pair `(0,2)`. -/
def seed02 : TerminalSeed controlM where
  pair := (0, 2)
  terminal := by decide

/-- This edge advertises target `(0,1)`, but its source is `(0,1)` under the
false action, so it is not enabled after `seed02` reaches `(0,2)`. -/
def wrongPredecessor : ReverseEdge controlM :=
  .predecessor (0, 1) false

/-- The second edge is ignored by reverse-DFA semantics.  The word therefore
remains endpoint-valid at `(0,2)` although its last edge targets `(0,1)`. -/
def validButUnchainedNode :
    ReachNode (ReverseEdge controlM) (SourceState (Fin 3)) :=
  ⟨.pair (0, 2), [.seed seed02, wrongPredecessor]⟩

theorem wrongPredecessor_source_mismatch :
    reverseEdgeSourceState controlM wrongPredecessor ≠
      SourceState.pair (0, 2) := by
  decide

theorem wrongPredecessor_is_noop_at_retained_state :
    (indexedEdgeDFA controlM).step (SourceState.pair (0, 2))
        wrongPredecessor = SourceState.pair (0, 2) := by
  decide

theorem validButUnchainedNode_valid :
    validButUnchainedNode.Valid (indexedEdgeDFA controlM) := by
  change (indexedEdgeDFA controlM).eval
      [.seed seed02, wrongPredecessor] = SourceState.pair (0, 2)
  decide

theorem validButUnchainedNode_last :
    validButUnchainedNode.word.getLast? = some wrongPredecessor := by
  rfl

theorem wrongPredecessor_target_ne_node :
    reverseEdgeTargetState controlM wrongPredecessor ≠
      validButUnchainedNode.state := by
  decide

/-- Executable counterexample: endpoint-validity of an edge trace does not
license reading its last edge as the retained state's policy backpointer. -/
theorem endpoint_valid_does_not_force_last_edge_target :
    ∃ node : ReachNode (ReverseEdge controlM) (SourceState (Fin 3)),
      ∃ edge : ReverseEdge controlM,
        node.Valid (indexedEdgeDFA controlM) ∧
        node.word.getLast? = some edge ∧
        reverseEdgeTargetState controlM edge ≠ node.state := by
  exact ⟨validButUnchainedNode, wrongPredecessor,
    validButUnchainedNode_valid, validButUnchainedNode_last,
    wrongPredecessor_target_ne_node⟩

end NativeIndexedPolicyBoundary

end Pairfield
