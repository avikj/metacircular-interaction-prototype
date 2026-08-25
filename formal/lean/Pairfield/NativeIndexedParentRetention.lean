/-
Copyright (c) 2026 Avik Jain and the mathematics collaboration.
Released under Apache 2.0 license.

Every non-seed node admitted by the source-indexed queue retains the exact
frontier node from which its final edge was appended.  This is the local
well-founded forest invariant needed after sound final-edge extraction and
before total policy compilation.
-/
import Pairfield.NativeIndexedParentExtraction

namespace Pairfield

universe u v

variable {A : Type u} {X : Type v}

namespace NativeIndexedParentRetention

open NativeReverseEdgeInventory
open NativeIndexedReverseTraversal

variable [DecidableEq X]
variable (M : DFA A X)
variable [DecidablePred (fun state : X => state ∈ M.accept)]

/-- Every candidate emitted by `consumeFrontier` is literally a child of a
node in that frontier, along an edge sourced at the parent state. -/
theorem consumeFrontier_candidate_parent
    (frontier : List (ReachNode (ReverseEdge M) (SourceState X)))
    (index : List (SourceBucket M)) (hsound : IndexSound M index)
    {candidate : ReachNode (ReverseEdge M) (SourceState X)}
    (hcandidate : candidate ∈ (consumeFrontier M frontier index).candidates) :
    ∃ parent ∈ frontier, ∃ edge : ReverseEdge M,
      candidate = parent.child (indexedEdgeDFA M) edge ∧
        reverseEdgeSourceState M edge = parent.state := by
  induction frontier generalizing index with
  | nil => simp [consumeFrontier] at hcandidate
  | cons parent rest ih =>
      simp only [consumeFrontier, List.mem_append, List.mem_map] at hcandidate
      rcases hcandidate with ⟨edge, hedge, rfl⟩ | htail
      · exact ⟨parent, List.mem_cons_self, edge, rfl,
          takeBucket_edges_source M parent.state index hsound hedge⟩
      · obtain ⟨old, hold, edge, hchild, hsource⟩ :=
          ih (takeBucket M parent.state index).2
            (takeBucket_remaining_sound M parent.state index hsound) htail
        exact ⟨old, List.mem_cons_of_mem parent hold, edge, hchild, hsource⟩

/-- Local forest invariant: every retained nonempty node has the exact parent
record from which its final edge was appended, still retained in the queue. -/
def ParentsRetained (queue : IndexedQueue M) : Prop :=
  ∀ node ∈ queue.nodes, node.word ≠ [] →
    ∃ parent ∈ queue.nodes, ∃ edge : ReverseEdge M,
      node = parent.child (indexedEdgeDFA M) edge ∧
        reverseEdgeSourceState M edge = parent.state

theorem initialQueue_parentsRetained (edges : List (ReverseEdge M)) :
    ParentsRetained M (initialQueue M edges) := by
  intro node hnode hnonempty
  simp [initialQueue, IndexedQueue.nodes] at hnode
  rcases hnode with rfl
  exact (hnonempty rfl).elim

/-- Advancing never deletes an admitted node: the old frontier moves into
`closed`, which is why an admitted child cannot become orphaned. -/
theorem advanceQueue_nodes_mono (queue : IndexedQueue M)
    {node : ReachNode (ReverseEdge M) (SourceState X)}
    (hnode : node ∈ queue.nodes) :
    node ∈ (advanceQueue M queue).nodes := by
  change node ∈ queue.nodes ++
    freshNodes queue.states
      (consumeFrontier M queue.frontier queue.remaining).candidates
  exact List.mem_append.mpr (Or.inl hnode)

theorem advanceQueue_parentsRetained (queue : IndexedQueue M)
    (hsound : IndexSound M queue.remaining)
    (hparents : ParentsRetained M queue) :
    ParentsRetained M (advanceQueue M queue) := by
  intro node hnode hnonempty
  change node ∈ queue.nodes ++
    freshNodes queue.states
      (consumeFrontier M queue.frontier queue.remaining).candidates at hnode
  rcases List.mem_append.mp hnode with hold | hfresh
  · obtain ⟨parent, hparent, edge, hchild, hsource⟩ :=
      hparents node hold hnonempty
    exact ⟨parent, advanceQueue_nodes_mono M queue hparent,
      edge, hchild, hsource⟩
  · have hcandidate := mem_freshNodes_imp_mem hfresh
    obtain ⟨parent, hparent, edge, hchild, hsource⟩ :=
      consumeFrontier_candidate_parent M queue.frontier queue.remaining
        hsound hcandidate
    have hparentNode : parent ∈ queue.nodes :=
      List.mem_append.mpr (Or.inr hparent)
    exact ⟨parent, advanceQueue_nodes_mono M queue hparentNode,
      edge, hchild, hsource⟩

/-- The local causal forest invariant holds at every fuel, independently of
whether the destructive queue has yet been proved complete. -/
theorem runQueue_parentsRetained
    (edges : List (ReverseEdge M)) (fuel : Nat) :
    ParentsRetained M (runQueue M edges fuel) := by
  induction fuel with
  | zero => exact initialQueue_parentsRetained M edges
  | succ fuel ih =>
      exact advanceQueue_parentsRetained M (runQueue M edges fuel)
        (runQueue_remaining_sound M edges fuel) ih

/-- Every retained non-seed node has a retained exact prefix parent and loses
one unit of word length along that parent edge. -/
theorem runQueue_nonempty_has_shorter_parent
    (edges : List (ReverseEdge M)) (fuel : Nat)
    {node : ReachNode (ReverseEdge M) (SourceState X)}
    (hnode : node ∈ (runQueue M edges fuel).nodes)
    (hnonempty : node.word ≠ []) :
    ∃ parent ∈ (runQueue M edges fuel).nodes, ∃ edge : ReverseEdge M,
      node = parent.child (indexedEdgeDFA M) edge ∧
        reverseEdgeSourceState M edge = parent.state ∧
        parent.word.length + 1 = node.word.length := by
  obtain ⟨parent, hparent, edge, hchild, hsource⟩ :=
    runQueue_parentsRetained M edges fuel node hnode hnonempty
  refine ⟨parent, hparent, edge, hchild, hsource, ?_⟩
  subst node
  simp [ReachNode.child]

/-- The complete indexed traversal exposes the same strict local rank step.
Coverage and global shortestness remain separate theorems. -/
theorem indexedTraversal_nonempty_has_shorter_parent
    [LinearOrder X] [Fintype X] (alphabet : List A)
    {node : ReachNode (ReverseEdge M) (SourceState X)}
    (hnode : node ∈ (indexedTraversal M alphabet).nodes)
    (hnonempty : node.word ≠ []) :
    ∃ parent ∈ (indexedTraversal M alphabet).nodes, ∃ edge : ReverseEdge M,
      node = parent.child (indexedEdgeDFA M) edge ∧
        reverseEdgeSourceState M edge = parent.state ∧
        parent.word.length + 1 = node.word.length := by
  simpa [indexedTraversal] using
    runQueue_nonempty_has_shorter_parent M (edgeInventory M alphabet)
      (Fintype.card X * Fintype.card X + 1) hnode hnonempty

end NativeIndexedParentRetention

end Pairfield
