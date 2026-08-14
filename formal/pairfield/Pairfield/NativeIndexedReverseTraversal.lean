/-
Copyright (c) 2026 Avik Jain and the mathematics collaboration.
Released under Apache 2.0 license.

A source-indexed reverse traversal.  Mathlib's state-reindex theorem connects
the explicit native `source | pair` keys to the earlier `Option`-state edge
DFA.  The queue consumes each materialized source bucket when its state is
expanded, so its charged edge attempts are bounded by the genuine inventory
payload.  Index construction and key-comparison costs remain outside the
bound.
-/
import Pairfield.NativeReverseEdgeInventory

namespace Pairfield

universe u v

variable {A : Type u} {X : Type v}

namespace NativeIndexedReverseTraversal

open NativeReverseSeparatorPolicy
open NativeReversePairTraversal
open NativeReverseEdgeInventory

/-- An explicit native key for the synthetic source and product states. -/
inductive SourceState (X : Type v) where
  | source
  | pair (value : X × X)
deriving Repr, DecidableEq

/-- The state presentation change used by the source index. -/
def sourceStateEquiv : Option (X × X) ≃ SourceState X where
  toFun
    | none => .source
    | some pair => .pair pair
  invFun
    | .source => none
    | .pair pair => some pair
  left_inv state := by cases state <;> rfl
  right_inv state := by cases state <;> rfl

variable [DecidableEq X]
variable (M : DFA A X)
variable [DecidablePred (fun state : X => state ∈ M.accept)]

def ReverseEdge.sourceState (edge : ReverseEdge M) : SourceState X :=
  sourceStateEquiv edge.source

def ReverseEdge.targetState (edge : ReverseEdge M) : SourceState X :=
  sourceStateEquiv edge.target

/-- The proof-relevant edge DFA reindexed onto the native source keys. -/
def indexedEdgeDFA : DFA (ReverseEdge M) (SourceState X) :=
  DFA.reindex (sourceStateEquiv (X := X)) (edgeDFA M)

/-- Exact Mathlib adapter.  Reindexing changes the state presentation and no
edge-trace semantics. -/
theorem indexedEdgeDFA_evalFrom (state : SourceState X)
    (edges : List (ReverseEdge M)) :
    (indexedEdgeDFA M).evalFrom state edges =
      sourceStateEquiv
        ((edgeDFA M).evalFrom ((sourceStateEquiv (X := X)).symm state) edges) := by
  simpa [indexedEdgeDFA] using
    (DFA.evalFrom_reindex (M := edgeDFA M) (sourceStateEquiv (X := X)) state edges)

theorem indexedEdgeDFA_step_source (edge : ReverseEdge M) :
    (indexedEdgeDFA M).step edge.sourceState edge = edge.targetState := by
  change sourceStateEquiv
      ((edgeDFA M).step
        ((sourceStateEquiv (X := X)).symm edge.sourceState) edge) =
    edge.targetState
  simp only [ReverseEdge.sourceState, ReverseEdge.targetState,
    Equiv.symm_apply_apply]
  exact congrArg sourceStateEquiv (edgeDFA_step_source M edge)

/-- One materialized adjacency bucket.  Soundness is proved for the complete
index below instead of stored in this executable record. -/
structure SourceBucket where
  source : SourceState X
  edges : List (ReverseEdge M)

def indexPayload (index : List (SourceBucket M)) : Nat :=
  (index.flatMap SourceBucket.edges).length

/-- Insert one edge into its unique source bucket. -/
def insertEdge (edge : ReverseEdge M) :
    List (SourceBucket M) → List (SourceBucket M)
  | [] => [⟨edge.sourceState, [edge]⟩]
  | bucket :: rest =>
      if edge.sourceState = bucket.source then
        ⟨bucket.source, edge :: bucket.edges⟩ :: rest
      else
        bucket :: insertEdge edge rest

/-- Build the source index once from the genuine edge inventory. -/
def materializeIndex (edges : List (ReverseEdge M)) :
    List (SourceBucket M) :=
  edges.foldr (insertEdge M) []

theorem indexPayload_insertEdge (edge : ReverseEdge M)
    (index : List (SourceBucket M)) :
    indexPayload M (insertEdge M edge index) = indexPayload M index + 1 := by
  induction index with
  | nil => simp [insertEdge, indexPayload]
  | cons bucket rest ih =>
      by_cases hsource : edge.sourceState = bucket.source
      · simp [insertEdge, hsource, indexPayload, Nat.add_assoc, Nat.add_comm,
          Nat.add_left_comm]
      · simp [insertEdge, hsource, indexPayload, ih, Nat.add_assoc,
          Nat.add_comm, Nat.add_left_comm]

/-- Materialization neither duplicates nor discards edge payload. -/
theorem materializeIndex_payload (edges : List (ReverseEdge M)) :
    indexPayload M (materializeIndex M edges) = edges.length := by
  induction edges with
  | nil => simp [materializeIndex, indexPayload]
  | cons edge rest ih =>
      simp [materializeIndex, indexPayload_insertEdge, ih]

def BucketSound (bucket : SourceBucket M) : Prop :=
  ∀ edge ∈ bucket.edges, edge.sourceState = bucket.source

def IndexSound (index : List (SourceBucket M)) : Prop :=
  ∀ bucket ∈ index, BucketSound M bucket

theorem insertEdge_sound (edge : ReverseEdge M)
    (index : List (SourceBucket M)) (hsound : IndexSound M index) :
    IndexSound M (insertEdge M edge index) := by
  induction index with
  | nil =>
      intro bucket hbucket
      simp [insertEdge] at hbucket
      rcases hbucket with rfl
      intro candidate hcandidate
      simpa using hcandidate
  | cons bucket rest ih =>
      by_cases hsource : edge.sourceState = bucket.source
      · intro candidateBucket hcandidateBucket
        simp only [insertEdge, hsource, ↓reduceIte, List.mem_cons] at hcandidateBucket
        rcases hcandidateBucket with rfl | hrest
        · intro candidate hcandidate
          simp only [List.mem_cons] at hcandidate
          rcases hcandidate with rfl | hold
          · exact hsource
          · exact hsound bucket (List.mem_cons_self) candidate hold
        · exact hsound candidateBucket (List.mem_cons_of_mem bucket hrest)
      · intro candidateBucket hcandidateBucket
        simp only [insertEdge, hsource, ↓reduceIte, List.mem_cons] at hcandidateBucket
        rcases hcandidateBucket with rfl | hrest
        · exact hsound bucket List.mem_cons_self
        · exact ih (fun old hold => hsound old (List.mem_cons_of_mem bucket hold))
            candidateBucket hrest

theorem materializeIndex_sound (edges : List (ReverseEdge M)) :
    IndexSound M (materializeIndex M edges) := by
  induction edges with
  | nil => simp [materializeIndex, IndexSound]
  | cons edge rest ih =>
      simpa [materializeIndex] using insertEdge_sound M edge _ ih

/-- Remove and return the first bucket for one expanded source. -/
def takeBucket (state : SourceState X) :
    List (SourceBucket M) → List (ReverseEdge M) × List (SourceBucket M)
  | [] => ([], [])
  | bucket :: rest =>
      if bucket.source = state then
        (bucket.edges, rest)
      else
        let taken := takeBucket state rest
        (taken.1, bucket :: taken.2)

/-- Taking a bucket moves payload from the index to the charged attempt list
without creating or losing an edge. -/
theorem takeBucket_payload (state : SourceState X)
    (index : List (SourceBucket M)) :
    (takeBucket M state index).1.length +
        indexPayload M (takeBucket M state index).2 = indexPayload M index := by
  induction index with
  | nil => simp [takeBucket, indexPayload]
  | cons bucket rest ih =>
      by_cases hsource : bucket.source = state
      · simp [takeBucket, hsource, indexPayload, Nat.add_comm]
      · simp [takeBucket, hsource, indexPayload] at ih ⊢
        omega

theorem takeBucket_edges_source (state : SourceState X)
    (index : List (SourceBucket M)) (hsound : IndexSound M index)
    {edge : ReverseEdge M} (hedge : edge ∈ (takeBucket M state index).1) :
    edge.sourceState = state := by
  induction index with
  | nil => simp [takeBucket] at hedge
  | cons bucket rest ih =>
      by_cases hsource : bucket.source = state
      · simp only [takeBucket, hsource, ↓reduceIte] at hedge
        exact (hsound bucket List.mem_cons_self edge hedge).trans hsource
      · simp only [takeBucket, hsource, ↓reduceIte] at hedge
        exact ih (fun old hold => hsound old (List.mem_cons_of_mem bucket hold)) hedge

theorem takeBucket_remaining_sound (state : SourceState X)
    (index : List (SourceBucket M)) (hsound : IndexSound M index) :
    IndexSound M (takeBucket M state index).2 := by
  induction index with
  | nil => simp [takeBucket, IndexSound]
  | cons bucket rest ih =>
      by_cases hsource : bucket.source = state
      · simpa [takeBucket, hsource] using
          (fun old hold => hsound old (List.mem_cons_of_mem bucket hold))
      · intro old hold
        simp only [takeBucket, hsource, ↓reduceIte, List.mem_cons] at hold
        rcases hold with rfl | hrest
        · exact hsound bucket List.mem_cons_self
        · exact ih (fun item hitem =>
            hsound item (List.mem_cons_of_mem bucket hitem)) old hrest

/-- The candidates, residual index, and charged payload produced by expanding
one whole frontier. -/
structure Expansion where
  candidates : List (ReachNode (ReverseEdge M) (SourceState X))
  remaining : List (SourceBucket M)
  attempts : Nat

def consumeFrontier :
    List (ReachNode (ReverseEdge M) (SourceState X)) →
      List (SourceBucket M) → Expansion M
  | [], index => ⟨[], index, 0⟩
  | node :: rest, index =>
      let taken := takeBucket M node.state index
      let tail := consumeFrontier rest taken.2
      ⟨taken.1.map (node.child (indexedEdgeDFA M)) ++ tail.candidates,
        tail.remaining, taken.1.length + tail.attempts⟩

theorem consumeFrontier_payload
    (frontier : List (ReachNode (ReverseEdge M) (SourceState X)))
    (index : List (SourceBucket M)) :
    (consumeFrontier M frontier index).attempts +
        indexPayload M (consumeFrontier M frontier index).remaining =
      indexPayload M index := by
  induction frontier generalizing index with
  | nil => simp [consumeFrontier]
  | cons node rest ih =>
      simp only [consumeFrontier]
      have htake := takeBucket_payload M node.state index
      have htail := ih (takeBucket M node.state index).2
      omega

/-- The queue stores the unexpanded source index and an exact charged edge
attempt counter alongside the ordinary proof-relevant reachability nodes. -/
structure IndexedQueue where
  closed : List (ReachNode (ReverseEdge M) (SourceState X))
  frontier : List (ReachNode (ReverseEdge M) (SourceState X))
  remaining : List (SourceBucket M)
  attempts : Nat

def IndexedQueue.nodes (queue : IndexedQueue M) :=
  queue.closed ++ queue.frontier

def IndexedQueue.states (queue : IndexedQueue M) : List (SourceState X) :=
  queue.nodes.map ReachNode.state

def initialQueue (edges : List (ReverseEdge M)) : IndexedQueue M :=
  ⟨[], [⟨.source, []⟩], materializeIndex M edges, 0⟩

def advanceQueue (queue : IndexedQueue M) : IndexedQueue M :=
  let expansion := consumeFrontier M queue.frontier queue.remaining
  let next := freshNodes queue.states expansion.candidates
  ⟨queue.closed ++ queue.frontier, next, expansion.remaining,
    queue.attempts + expansion.attempts⟩

def runQueue (edges : List (ReverseEdge M)) : Nat → IndexedQueue M
  | 0 => initialQueue M edges
  | fuel + 1 => advanceQueue M (runQueue edges fuel)

theorem advanceQueue_total (queue : IndexedQueue M) :
    (advanceQueue M queue).attempts +
        indexPayload M (advanceQueue M queue).remaining =
      queue.attempts + indexPayload M queue.remaining := by
  simp only [advanceQueue]
  have hpayload := consumeFrontier_payload M queue.frontier queue.remaining
  omega

theorem runQueue_total (edges : List (ReverseEdge M)) (fuel : Nat) :
    (runQueue M edges fuel).attempts +
        indexPayload M (runQueue M edges fuel).remaining = edges.length := by
  induction fuel with
  | zero => simp [runQueue, initialQueue, materializeIndex_payload]
  | succ fuel ih =>
      rw [runQueue, advanceQueue_total]
      exact ih

theorem advanceQueue_states_nodup (queue : IndexedQueue M)
    (hnodup : queue.states.Nodup) :
    (advanceQueue M queue).states.Nodup := by
  let expansion := consumeFrontier M queue.frontier queue.remaining
  let next := freshNodes queue.states expansion.candidates
  change ((queue.nodes ++ next).map ReachNode.state).Nodup
  rw [List.map_append, List.nodup_append']
  refine ⟨hnodup, freshNodes_states_nodup queue.states expansion.candidates, ?_⟩
  simp only [List.disjoint_left]
  intro state hseen hfresh
  simp only [List.mem_map] at hfresh
  obtain ⟨node, hnode, rfl⟩ := hfresh
  exact (freshNodes_state_not_mem_seen queue.states expansion.candidates node hnode) hseen

theorem runQueue_states_nodup (edges : List (ReverseEdge M)) (fuel : Nat) :
    (runQueue M edges fuel).states.Nodup := by
  induction fuel with
  | zero => simp [runQueue, initialQueue, IndexedQueue.states, IndexedQueue.nodes]
  | succ fuel ih =>
      exact advanceQueue_states_nodup M (runQueue M edges fuel) ih

/-- One source-indexed traversal through the finite source/product state
space. -/
def indexedTraversal [LinearOrder X] [Fintype X]
    (alphabet : List A) : IndexedQueue M :=
  runQueue M (edgeInventory M alphabet)
    (Fintype.card X * Fintype.card X + 1)

/-- Charged edge attempts are at most the genuine inventory payload. -/
theorem indexedTraversal_attempts_le_inventory [LinearOrder X] [Fintype X]
    (alphabet : List A) :
    (indexedTraversal M alphabet).attempts ≤ (edgeInventory M alphabet).length := by
  have htotal := runQueue_total M (edgeInventory M alphabet)
    (Fintype.card X * Fintype.card X + 1)
  simp only [indexedTraversal] at htotal ⊢
  omega

theorem indexedTraversal_attempts_le [LinearOrder X] [Fintype X]
    (alphabet : List A) :
    (indexedTraversal M alphabet).attempts ≤
      Fintype.card X * Fintype.card X * (alphabet.length + 1) :=
  (indexedTraversal_attempts_le_inventory M alphabet).trans
    (edgeInventory_length_le M alphabet)

namespace Control

open BehavioralBFSWitness
open VisitedPairHorizonWitness

/-- The source index charges sixteen genuine outgoing edges on the reached
seven-state subgraph, strictly below the 22-edge stored inventory. -/
theorem indexed_traversal_attempts_sixteen :
    (indexedTraversal automaton alphabet).attempts = 16 := by
  native_decide

theorem indexed_traversal_strictly_below_inventory :
    (indexedTraversal automaton alphabet).attempts <
      (edgeInventory automaton alphabet).length := by
  native_decide

/-- The state-presentation adapter executes natively on an actual predecessor
edge. -/
theorem native_reindex_adapter_control :
    (indexedEdgeDFA automaton).evalFrom (.pair (0, 2))
        [ReverseEdge.predecessor (0, 1) false] = .pair (0, 1) := by
  native_decide

/-- The indexed queue retains the same reached product-state set as the flat
reverse traversal on the planted control. -/
theorem indexed_and_flat_reach_same_states :
    ((indexedTraversal automaton alphabet).closed.map ReachNode.state).toFinset =
      (((reverseTraversal automaton alphabet).closed.map ReachNode.state).map
        (sourceStateEquiv (X := Fin 3))).toFinset := by
  native_decide

end Control

end NativeIndexedReverseTraversal

end Pairfield
