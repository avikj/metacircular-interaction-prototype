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
open NativeCompleteWitnesses

/-- An explicit native key for the synthetic source and product states. -/
inductive SourceState (X : Type v) where
  | source
  | pair (value : X × X)
deriving Repr, DecidableEq, Fintype

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

def reverseEdgeSourceState (edge : ReverseEdge M) : SourceState X :=
  sourceStateEquiv edge.source

def reverseEdgeTargetState (edge : ReverseEdge M) : SourceState X :=
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
    (indexedEdgeDFA M).step (reverseEdgeSourceState M edge) edge =
      reverseEdgeTargetState M edge := by
  change sourceStateEquiv
      ((edgeDFA M).step
        ((sourceStateEquiv (X := X)).symm
          (reverseEdgeSourceState M edge)) edge) =
    reverseEdgeTargetState M edge
  simp only [reverseEdgeSourceState, reverseEdgeTargetState,
    Equiv.symm_apply_apply]
  exact congrArg sourceStateEquiv (edgeDFA_step_source M edge)

namespace EdgeTrace

/-- A causal reverse-edge path.  Unlike endpoint DFA validity, every edge is
required to start exactly where the preceding prefix ends. -/
inductive Chained (M : DFA A X)
    [DecidablePred (fun state : X => state ∈ M.accept)] :
    SourceState X → List (ReverseEdge M) → SourceState X → Prop
  | nil (state : SourceState X) : Chained M state [] state
  | cons {start finish : SourceState X} {rest : List (ReverseEdge M)}
      (edge : ReverseEdge M)
      (source_eq : reverseEdgeSourceState M edge = start)
      (tail : Chained M (reverseEdgeTargetState M edge) rest finish) :
      Chained M start (edge :: rest) finish

/-- Extend a causal trace at its endpoint.  This is the snoc orientation used
by `ReachNode.child`. -/
theorem Chained.snoc {start finish : SourceState X}
    {edges : List (ReverseEdge M)}
    (hchain : Chained M start edges finish) (edge : ReverseEdge M)
    (hsource : reverseEdgeSourceState M edge = finish) :
    Chained M start (edges ++ [edge]) (reverseEdgeTargetState M edge) := by
  induction hchain with
  | nil state =>
      exact Chained.cons edge hsource (Chained.nil _)
  | cons first hfirst tail ih =>
      exact Chained.cons first hfirst (ih hsource)

theorem Chained.head_source {start finish : SourceState X}
    {edge : ReverseEdge M} {rest : List (ReverseEdge M)}
    (hchain : Chained M start (edge :: rest) finish) :
    reverseEdgeSourceState M edge = start := by
  cases hchain with
  | cons _ hsource _ => exact hsource

theorem Chained.tail {start finish : SourceState X}
    {edge : ReverseEdge M} {rest : List (ReverseEdge M)}
    (hchain : Chained M start (edge :: rest) finish) :
    Chained M (reverseEdgeTargetState M edge) rest finish := by
  cases hchain with
  | cons _ _ tail => exact tail

/-- A causal edge path evaluates to its declared endpoint in the reindexed
DFA.  The proof uses the exact source-to-target adapter at every edge. -/
theorem Chained.evalFrom_eq {start finish : SourceState X}
    {edges : List (ReverseEdge M)}
    (hchain : Chained M start edges finish) :
    (indexedEdgeDFA M).evalFrom start edges = finish := by
  induction hchain with
  | nil state => rfl
  | cons edge hsource tail ih =>
      simp only [DFA.evalFrom_cons]
      rw [← hsource, indexedEdgeDFA_step_source, ih]

end EdgeTrace

/-- The stronger node invariant needed for policy-parent extraction. -/
def NodeChained
    (node : ReachNode (ReverseEdge M) (SourceState X)) : Prop :=
  EdgeTrace.Chained M .source node.word node.state

/-- Causal validity strengthens the ordinary endpoint-only reachability
invariant consumed by the generic BFS layer. -/
theorem nodeChained_valid
    {node : ReachNode (ReverseEdge M) (SourceState X)}
    (hnode : NodeChained M node) : node.Valid (indexedEdgeDFA M) := by
  rw [ReachNode.Valid, DFA.eval]
  exact EdgeTrace.Chained.evalFrom_eq (M := M) hnode

theorem ReachNode.child_chained
    {node : ReachNode (ReverseEdge M) (SourceState X)}
    (hnode : NodeChained M node) (edge : ReverseEdge M)
    (hsource : reverseEdgeSourceState M edge = node.state) :
    NodeChained M (node.child (indexedEdgeDFA M) edge) := by
  have hstep :
      (indexedEdgeDFA M).step node.state edge =
        reverseEdgeTargetState M edge := by
    rw [← hsource]
    exact indexedEdgeDFA_step_source M edge
  change EdgeTrace.Chained M .source (node.word ++ [edge])
    ((indexedEdgeDFA M).step node.state edge)
  rw [hstep]
  exact EdgeTrace.Chained.snoc (M := M) hnode edge hsource

/-- Lift a forward separator to proof-relevant genuine reverse edges.  The
terminal proof is retained in the seed; predecessor edges retain the original
pair and action. -/
def reverseEdgeCertificate (pair : X × X) :
    (word : List A) →
      behavior M.step (acceptsBool M) pair.1 word ≠
        behavior M.step (acceptsBool M) pair.2 word →
      List (ReverseEdge M)
  | [], hseparates => [.seed ⟨pair, hseparates⟩]
  | action :: rest, hseparates =>
      have htail :
          behavior M.step (acceptsBool M)
              (pairStep M pair action).1 rest ≠
            behavior M.step (acceptsBool M)
              (pairStep M pair action).2 rest := by
        simpa [behavior, run, pairStep] using hseparates
      reverseEdgeCertificate (pairStep M pair action) rest htail ++
        [.predecessor pair action]

/-- Erasing proof-relevant edges recovers the earlier reverse certificate
exactly. -/
theorem reverseEdgeCertificate_map_toMove (pair : X × X) (word : List A)
    (hseparates :
      behavior M.step (acceptsBool M) pair.1 word ≠
        behavior M.step (acceptsBool M) pair.2 word) :
    (reverseEdgeCertificate M pair word hseparates).map
        (ReverseEdge.toMove M) =
      reverseCertificate M pair word := by
  induction word generalizing pair with
  | nil => simp [reverseEdgeCertificate, reverseCertificate,
      ReverseEdge.toMove]
  | cons action rest ih =>
      simp only [reverseEdgeCertificate, reverseCertificate, List.map_append,
        List.map_singleton, ReverseEdge.toMove]
      rw [ih]

/-- The native edge certificate reaches its declared product pair in the
reindexed DFA. -/
theorem reverseEdgeCertificate_reaches (pair : X × X) (word : List A)
    (hseparates :
      behavior M.step (acceptsBool M) pair.1 word ≠
        behavior M.step (acceptsBool M) pair.2 word) :
    (indexedEdgeDFA M).eval
        (reverseEdgeCertificate M pair word hseparates) = .pair pair := by
  rw [DFA.eval, indexedEdgeDFA_evalFrom, edgeDFA_evalFrom,
    reverseEdgeCertificate_map_toMove]
  have hreach := NativeReversePairTraversal.reverseCertificate_reaches
    M pair word hseparates
  simpa [DFA.eval, indexedEdgeDFA, edgeDFA, reverseDFA, sourceStateEquiv] using
    congrArg (sourceStateEquiv (X := X)) hreach

/-- The lifted certificate is causal, not merely endpoint-valid. -/
theorem reverseEdgeCertificate_chained (pair : X × X) (word : List A)
    (hseparates :
      behavior M.step (acceptsBool M) pair.1 word ≠
        behavior M.step (acceptsBool M) pair.2 word) :
    EdgeTrace.Chained M .source
      (reverseEdgeCertificate M pair word hseparates) (.pair pair) := by
  induction word generalizing pair with
  | nil =>
      exact EdgeTrace.Chained.cons (.seed ⟨pair, hseparates⟩) rfl
        (EdgeTrace.Chained.nil _)
  | cons action rest ih =>
      have htail :
          behavior M.step (acceptsBool M)
              (pairStep M pair action).1 rest ≠
            behavior M.step (acceptsBool M)
              (pairStep M pair action).2 rest := by
        simpa [behavior, run, pairStep] using hseparates
      simpa [reverseEdgeCertificate, reverseEdgeSourceState,
        reverseEdgeTargetState, ReverseEdge.source, ReverseEdge.target,
        sourceStateEquiv] using
        EdgeTrace.Chained.snoc (M := M)
          (ih (pairStep M pair action) htail)
          (.predecessor pair action) rfl

/-- One materialized adjacency bucket.  Soundness is proved for the complete
index below instead of stored in this executable record. -/
structure SourceBucket where
  source : SourceState X
  edges : List (ReverseEdge M)

def indexEdges : List (SourceBucket M) → List (ReverseEdge M)
  | [] => []
  | bucket :: rest => bucket.edges ++ indexEdges rest

@[simp]
theorem indexEdges_nil : indexEdges M [] = [] := rfl

@[simp]
theorem indexEdges_cons (bucket : SourceBucket M)
    (rest : List (SourceBucket M)) :
    indexEdges M (bucket :: rest) = bucket.edges ++ indexEdges M rest := rfl

theorem mem_indexEdges_iff (edge : ReverseEdge M)
    (index : List (SourceBucket M)) :
    edge ∈ indexEdges M index ↔
      ∃ bucket ∈ index, edge ∈ bucket.edges := by
  induction index with
  | nil => simp
  | cons bucket rest ih =>
      simp only [indexEdges_cons, List.mem_append, List.mem_cons, ih]
      constructor
      · rintro (hbucket | ⟨old, hold, hedge⟩)
        · exact ⟨bucket, Or.inl rfl, hbucket⟩
        · exact ⟨old, Or.inr hold, hedge⟩
      · rintro ⟨old, (rfl | hold), hedge⟩
        · exact Or.inl hedge
        · exact Or.inr ⟨old, hold, hedge⟩

def indexPayload (index : List (SourceBucket M)) : Nat :=
  (indexEdges M index).length

def IndexKeysNodup (index : List (SourceBucket M)) : Prop :=
  (index.map SourceBucket.source).Nodup

/-- Insert one edge into its unique source bucket. -/
def insertEdge (edge : ReverseEdge M) :
    List (SourceBucket M) → List (SourceBucket M)
  | [] => [⟨reverseEdgeSourceState M edge, [edge]⟩]
  | bucket :: rest =>
      if reverseEdgeSourceState M edge = bucket.source then
        ⟨bucket.source, edge :: bucket.edges⟩ :: rest
      else
        bucket :: insertEdge edge rest

theorem mem_indexEdges_insertEdge (candidate edge : ReverseEdge M)
    (index : List (SourceBucket M)) :
    candidate ∈ indexEdges M (insertEdge M edge index) ↔
      candidate = edge ∨ candidate ∈ indexEdges M index := by
  induction index with
  | nil => simp [insertEdge, indexEdges]
  | cons bucket rest ih =>
      by_cases hsource : reverseEdgeSourceState M edge = bucket.source
      · simp [insertEdge, indexEdges, hsource, or_assoc]
      · simp only [insertEdge, hsource, ↓reduceIte, indexEdges_cons,
          List.mem_append]
        rw [ih]
        tauto

theorem mem_indexSources_insertEdge (state : SourceState X)
    (edge : ReverseEdge M) (index : List (SourceBucket M)) :
    state ∈ (insertEdge M edge index).map SourceBucket.source ↔
      state = reverseEdgeSourceState M edge ∨
        state ∈ index.map SourceBucket.source := by
  induction index with
  | nil => simp [insertEdge]
  | cons bucket rest ih =>
      by_cases hsource : reverseEdgeSourceState M edge = bucket.source
      · simp [insertEdge, hsource, or_assoc]
      · simp [insertEdge, hsource, ih, or_assoc, or_left_comm]

theorem insertEdge_keys_nodup (edge : ReverseEdge M)
    (index : List (SourceBucket M)) (hkeys : IndexKeysNodup M index) :
    IndexKeysNodup M (insertEdge M edge index) := by
  induction index with
  | nil => simp [insertEdge, IndexKeysNodup]
  | cons bucket rest ih =>
      rw [IndexKeysNodup] at hkeys ⊢
      simp only [List.map_cons, List.nodup_cons] at hkeys
      rcases hkeys with ⟨hhead, hrest⟩
      by_cases hsource : reverseEdgeSourceState M edge = bucket.source
      · simpa [insertEdge, hsource] using
          (List.nodup_cons.mpr ⟨hhead, hrest⟩)
      · simp only [insertEdge, hsource, ↓reduceIte, List.map_cons,
          List.nodup_cons]
        refine ⟨?_, ih hrest⟩
        intro hmem
        rw [mem_indexSources_insertEdge] at hmem
        rcases hmem with heq | hold
        · exact hsource heq.symm
        · exact hhead hold

/-- Build the source index once from the genuine edge inventory. -/
def materializeIndex : List (ReverseEdge M) → List (SourceBucket M)
  | [] => []
  | edge :: rest => insertEdge M edge (materializeIndex rest)

theorem indexPayload_insertEdge (edge : ReverseEdge M)
    (index : List (SourceBucket M)) :
    indexPayload M (insertEdge M edge index) = indexPayload M index + 1 := by
  induction index with
  | nil => simp [insertEdge, indexPayload]
  | cons bucket rest ih =>
      by_cases hsource : reverseEdgeSourceState M edge = bucket.source
      · simp [insertEdge, hsource, indexPayload, Nat.add_assoc, Nat.add_comm,
          Nat.add_left_comm]
      · simp only [insertEdge, hsource, ↓reduceIte]
        simp only [indexPayload, indexEdges_cons, List.length_append]
        have ih' : (indexEdges M (insertEdge M edge rest)).length =
            (indexEdges M rest).length + 1 := by
          simpa [indexPayload] using ih
        rw [ih']
        omega

/-- Materialization neither duplicates nor discards edge payload. -/
theorem materializeIndex_payload (edges : List (ReverseEdge M)) :
    indexPayload M (materializeIndex M edges) = edges.length := by
  induction edges with
  | nil => simp [materializeIndex, indexPayload]
  | cons edge rest ih =>
      rw [materializeIndex, indexPayload_insertEdge, ih]
      rfl

theorem mem_materializeIndex_iff (candidate : ReverseEdge M)
    (edges : List (ReverseEdge M)) :
    candidate ∈ indexEdges M (materializeIndex M edges) ↔
      candidate ∈ edges := by
  induction edges with
  | nil => simp [materializeIndex, indexEdges]
  | cons edge rest ih =>
      rw [materializeIndex, mem_indexEdges_insertEdge, ih]
      simp [eq_comm]

theorem materializeIndex_keys_nodup (edges : List (ReverseEdge M)) :
    IndexKeysNodup M (materializeIndex M edges) := by
  induction edges with
  | nil => simp [materializeIndex, IndexKeysNodup]
  | cons edge rest ih =>
      simpa [materializeIndex] using insertEdge_keys_nodup M edge _ ih

def BucketSound (bucket : SourceBucket M) : Prop :=
  ∀ edge ∈ bucket.edges, reverseEdgeSourceState M edge = bucket.source

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
      have heq : candidate = edge := by simpa using hcandidate
      cases heq
      rfl
  | cons bucket rest ih =>
      by_cases hsource : reverseEdgeSourceState M edge = bucket.source
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
        · exact hsound _ List.mem_cons_self
        · exact ih (fun old hold => hsound old (List.mem_cons_of_mem bucket hold))
            candidateBucket hrest

theorem materializeIndex_sound (edges : List (ReverseEdge M)) :
    IndexSound M (materializeIndex M edges) := by
  induction edges with
  | nil => simp [materializeIndex, IndexSound]
  | cons edge rest ih =>
      simpa [materializeIndex] using insertEdge_sound M edge _ ih

theorem seed_mem_terminalEdges [LinearOrder X] [Fintype X] (pair : X × X)
    (hterminal : TerminalPair M pair) :
    ReverseEdge.seed (M := M) ⟨pair, hterminal⟩ ∈ terminalEdges M := by
  simp [terminalEdges, terminalEdge?, hterminal]

theorem predecessor_mem_predecessorEdges [LinearOrder X] [Fintype X]
    (alphabet : List A) (pair : X × X) (action : A)
    (haction : action ∈ alphabet) :
    ReverseEdge.predecessor (M := M) pair action ∈
      predecessorEdges M alphabet := by
  simp [predecessorEdges, haction]

/-- Every edge used by a lifted certificate is present in the explicit
inventory whenever the supplied alphabet is complete. -/
theorem reverseEdgeCertificate_mem_inventory [LinearOrder X] [Fintype X]
    [DecidableEq A] (alphabet : List A)
    (complete : ∀ action : A, action ∈ alphabet)
    (pair : X × X) (word : List A)
    (hseparates :
      behavior M.step (acceptsBool M) pair.1 word ≠
        behavior M.step (acceptsBool M) pair.2 word) :
    ∀ edge ∈ reverseEdgeCertificate M pair word hseparates,
      edge ∈ edgeInventory M alphabet := by
  induction word generalizing pair with
  | nil =>
      intro edge hedge
      simp only [reverseEdgeCertificate, List.mem_singleton] at hedge
      subst edge
      exact List.mem_append_left _ (seed_mem_terminalEdges M pair hseparates)
  | cons action rest ih =>
      intro edge hedge
      have htail :
          behavior M.step (acceptsBool M)
              (pairStep M pair action).1 rest ≠
            behavior M.step (acceptsBool M)
              (pairStep M pair action).2 rest := by
        simpa [behavior, run, pairStep] using hseparates
      simp only [reverseEdgeCertificate, List.mem_append, List.mem_singleton] at hedge
      rcases hedge with hprefix | rfl
      · exact ih (pairStep M pair action) htail edge hprefix
      · exact List.mem_append_right _
          (predecessor_mem_predecessorEdges M alphabet pair action
            (complete action))

/-- Graph/path completeness at the exact effective boundary: every unequal
pair of a finite reduced chart has an inventory-resident native edge path from
the synthetic source.  Queue coverage is a separate theorem. -/
theorem exists_inventory_edge_path_of_ne [LinearOrder X] [Fintype X]
    [DecidableEq A] (alphabet : List A)
    (complete : ∀ action : A, action ∈ alphabet)
    (reduced : BehaviorallyReduced M) (pair : X × X)
    (hne : pair.1 ≠ pair.2) :
    ∃ edges : List (ReverseEdge M),
      (∀ edge ∈ edges, edge ∈ edgeInventory M alphabet) ∧
      (indexedEdgeDFA M).eval edges = .pair pair := by
  obtain ⟨word, _hword, hseparates⟩ :=
    exists_completeWord_separator M alphabet complete reduced hne
  exact ⟨reverseEdgeCertificate M pair word hseparates,
    reverseEdgeCertificate_mem_inventory M alphabet complete pair word hseparates,
    reverseEdgeCertificate_reaches M pair word hseparates⟩

/-- The same finite-reduced witness theorem with the causal path invariant
exposed rather than only its endpoint evaluation. -/
theorem exists_inventory_chained_path_of_ne [LinearOrder X] [Fintype X]
    [DecidableEq A] (alphabet : List A)
    (complete : ∀ action : A, action ∈ alphabet)
    (reduced : BehaviorallyReduced M) (pair : X × X)
    (hne : pair.1 ≠ pair.2) :
    ∃ edges : List (ReverseEdge M),
      (∀ edge ∈ edges, edge ∈ edgeInventory M alphabet) ∧
      EdgeTrace.Chained M .source edges (.pair pair) := by
  obtain ⟨word, _hword, hseparates⟩ :=
    exists_completeWord_separator M alphabet complete reduced hne
  exact ⟨reverseEdgeCertificate M pair word hseparates,
    reverseEdgeCertificate_mem_inventory M alphabet complete pair word hseparates,
    reverseEdgeCertificate_chained M pair word hseparates⟩

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

theorem mem_indexEdges_takeBucket (state : SourceState X)
    (index : List (SourceBucket M)) (edge : ReverseEdge M) :
    edge ∈ indexEdges M index ↔
      edge ∈ (takeBucket M state index).1 ∨
        edge ∈ indexEdges M (takeBucket M state index).2 := by
  induction index with
  | nil => simp [takeBucket]
  | cons bucket rest ih =>
      by_cases hsource : bucket.source = state
      · simp [takeBucket, hsource]
      · simp only [takeBucket, hsource, ↓reduceIte, indexEdges_cons,
          List.mem_append]
        rw [ih]
        tauto

theorem takeBucket_remaining_sublist (state : SourceState X)
    (index : List (SourceBucket M)) :
    List.Sublist (takeBucket M state index).2 index := by
  induction index with
  | nil => simp [takeBucket]
  | cons bucket rest ih =>
      by_cases hsource : bucket.source = state
      · simp only [takeBucket, hsource, ↓reduceIte]
        exact List.Sublist.cons bucket (List.Sublist.refl rest)
      · simp only [takeBucket, hsource, ↓reduceIte]
        exact List.Sublist.cons_cons bucket ih

theorem takeBucket_remaining_keys_nodup (state : SourceState X)
    (index : List (SourceBucket M)) (hkeys : IndexKeysNodup M index) :
    IndexKeysNodup M (takeBucket M state index).2 := by
  rw [IndexKeysNodup] at hkeys ⊢
  exact ((takeBucket_remaining_sublist M state index).map
    SourceBucket.source).nodup hkeys

theorem takeBucket_remaining_source_ne (state : SourceState X)
    (index : List (SourceBucket M)) (hkeys : IndexKeysNodup M index) :
    ∀ bucket ∈ (takeBucket M state index).2, bucket.source ≠ state := by
  induction index with
  | nil => simp [takeBucket]
  | cons bucket rest ih =>
      rw [IndexKeysNodup] at hkeys
      simp only [List.map_cons, List.nodup_cons] at hkeys
      rcases hkeys with ⟨hhead, hrest⟩
      by_cases hsource : bucket.source = state
      · intro candidate hcandidate heq
        simp only [takeBucket, hsource, ↓reduceIte] at hcandidate
        apply hhead
        exact List.mem_map.mpr
          ⟨candidate, hcandidate, heq.trans hsource.symm⟩
      · intro candidate hcandidate
        simp only [takeBucket, hsource, ↓reduceIte, List.mem_cons] at hcandidate
        rcases hcandidate with rfl | htail
        · exact hsource
        · exact ih hrest candidate htail

theorem takeBucket_edge_complete (state : SourceState X)
    (index : List (SourceBucket M)) (hsound : IndexSound M index)
    (hkeys : IndexKeysNodup M index) {edge : ReverseEdge M}
    (hedge : edge ∈ indexEdges M index)
    (hsource : reverseEdgeSourceState M edge = state) :
    edge ∈ (takeBucket M state index).1 := by
  rw [mem_indexEdges_takeBucket M state index edge] at hedge
  rcases hedge with htaken | hremaining
  · exact htaken
  · exfalso
    rw [mem_indexEdges_iff] at hremaining
    obtain ⟨bucket, hbucket, hedge⟩ := hremaining
    have hbucketSource :=
      takeBucket_remaining_source_ne M state index hkeys bucket hbucket
    have hbucketOld : bucket ∈ index :=
      (takeBucket_remaining_sublist M state index).subset hbucket
    have hedgeSource := hsound bucket hbucketOld edge hedge
    exact hbucketSource (hedgeSource.symm.trans hsource)

theorem takeBucket_edges_source (state : SourceState X)
    (index : List (SourceBucket M)) (hsound : IndexSound M index)
    {edge : ReverseEdge M} (hedge : edge ∈ (takeBucket M state index).1) :
    reverseEdgeSourceState M edge = state := by
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
      · simp only [takeBucket, hsource, ↓reduceIte]
        exact fun old hold => hsound old (List.mem_cons_of_mem bucket hold)
      · intro old hold
        simp only [takeBucket, hsource, ↓reduceIte, List.mem_cons] at hold
        rcases hold with rfl | hrest
        · exact hsound _ List.mem_cons_self
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

theorem consumeFrontier_remaining_sound
    (frontier : List (ReachNode (ReverseEdge M) (SourceState X)))
    (index : List (SourceBucket M)) (hsound : IndexSound M index) :
    IndexSound M (consumeFrontier M frontier index).remaining := by
  induction frontier generalizing index with
  | nil => simpa [consumeFrontier] using hsound
  | cons node rest ih =>
      simp only [consumeFrontier]
      exact ih _ (takeBucket_remaining_sound M node.state index hsound)

theorem consumeFrontier_remaining_keys_nodup
    (frontier : List (ReachNode (ReverseEdge M) (SourceState X)))
    (index : List (SourceBucket M)) (hkeys : IndexKeysNodup M index) :
    IndexKeysNodup M (consumeFrontier M frontier index).remaining := by
  induction frontier generalizing index with
  | nil => simpa [consumeFrontier] using hkeys
  | cons node rest ih =>
      simp only [consumeFrontier]
      exact ih _ (takeBucket_remaining_keys_nodup M node.state index hkeys)

/-- An edge whose source is outside the expanded frontier survives destructive
bucket consumption. -/
theorem consumeFrontier_remaining_covers_edge
    (frontier : List (ReachNode (ReverseEdge M) (SourceState X)))
    (index : List (SourceBucket M)) (hsound : IndexSound M index)
    {edge : ReverseEdge M} (hedge : edge ∈ indexEdges M index)
    (houtside : ∀ node ∈ frontier,
      reverseEdgeSourceState M edge ≠ node.state) :
    edge ∈ indexEdges M (consumeFrontier M frontier index).remaining := by
  induction frontier generalizing index with
  | nil => simpa [consumeFrontier] using hedge
  | cons node rest ih =>
      have hpartition :=
        (mem_indexEdges_takeBucket M node.state index edge).mp hedge
      rcases hpartition with htaken | hremaining
      · have hsource :=
          takeBucket_edges_source M node.state index hsound htaken
        exact False.elim
          (houtside node List.mem_cons_self hsource)
      · simp only [consumeFrontier]
        exact ih (takeBucket M node.state index).2
          (takeBucket_remaining_sound M node.state index hsound) hremaining
          (fun old hold =>
            houtside old (List.mem_cons_of_mem node hold))

/-- Every indexed edge whose source occurs in the frontier produces a
candidate representing its native target, even if an earlier equal source
already consumed the bucket. -/
theorem consumeFrontier_covers_edge
    (frontier : List (ReachNode (ReverseEdge M) (SourceState X)))
    (index : List (SourceBucket M)) (hsound : IndexSound M index)
    (hkeys : IndexKeysNodup M index) {edge : ReverseEdge M}
    (hedge : edge ∈ indexEdges M index)
    (hsource : ∃ node ∈ frontier,
      reverseEdgeSourceState M edge = node.state) :
    ∃ candidate ∈ (consumeFrontier M frontier index).candidates,
      candidate.state = reverseEdgeTargetState M edge := by
  induction frontier generalizing index with
  | nil => simp at hsource
  | cons node rest ih =>
      rcases hsource with ⟨sourceNode, hsourceNode, hsource⟩
      simp only [List.mem_cons] at hsourceNode
      rcases hsourceNode with heq | hsourceTail
      · have hsourceHead : reverseEdgeSourceState M edge = node.state :=
          hsource.trans (congrArg ReachNode.state heq)
        have htaken := takeBucket_edge_complete M node.state index hsound
          hkeys hedge hsourceHead
        refine ⟨node.child (indexedEdgeDFA M) edge, ?_, ?_⟩
        · simp only [consumeFrontier, List.mem_append, List.mem_map]
          exact Or.inl ⟨edge, htaken, rfl⟩
        · change (indexedEdgeDFA M).step node.state edge =
            reverseEdgeTargetState M edge
          rw [← hsourceHead]
          exact indexedEdgeDFA_step_source M edge
      · have hpartition :=
          (mem_indexEdges_takeBucket M node.state index edge).mp hedge
        rcases hpartition with htaken | hremaining
        · refine ⟨node.child (indexedEdgeDFA M) edge, ?_, ?_⟩
          · simp only [consumeFrontier, List.mem_append, List.mem_map]
            exact Or.inl ⟨edge, htaken, rfl⟩
          · change (indexedEdgeDFA M).step node.state edge =
              reverseEdgeTargetState M edge
            have hedgeSource :=
              takeBucket_edges_source M node.state index hsound htaken
            rw [← hedgeSource]
            exact indexedEdgeDFA_step_source M edge
        · obtain ⟨candidate, hcandidate, htarget⟩ :=
            ih (takeBucket M node.state index).2
              (takeBucket_remaining_sound M node.state index hsound)
              (takeBucket_remaining_keys_nodup M node.state index hkeys)
              hremaining ⟨sourceNode, hsourceTail, hsource⟩
          refine ⟨candidate, ?_, htarget⟩
          simp only [consumeFrontier, List.mem_append]
          exact Or.inr hcandidate

theorem consumeFrontier_candidates_valid
    (frontier : List (ReachNode (ReverseEdge M) (SourceState X)))
    (index : List (SourceBucket M))
    (hvalid : ∀ node ∈ frontier, node.Valid (indexedEdgeDFA M)) :
    ∀ candidate ∈ (consumeFrontier M frontier index).candidates,
      candidate.Valid (indexedEdgeDFA M) := by
  induction frontier generalizing index with
  | nil => simp [consumeFrontier]
  | cons node rest ih =>
      intro candidate hcandidate
      simp only [consumeFrontier, List.mem_append, List.mem_map] at hcandidate
      rcases hcandidate with ⟨edge, _hedge, rfl⟩ | htail
      · exact ReachNode.child_valid (indexedEdgeDFA M)
          (hvalid node List.mem_cons_self) edge
      · exact ih _ (fun old hold =>
          hvalid old (List.mem_cons_of_mem node hold)) candidate htail

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
      · exact ReachNode.child_chained M
          (hchained node List.mem_cons_self) edge
          (takeBucket_edges_source M node.state index hsound hedge)
      · exact ih (takeBucket M node.state index).2
          (takeBucket_remaining_sound M node.state index hsound)
          (fun old hold =>
            hchained old (List.mem_cons_of_mem node hold)) candidate htail

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

/-- Every edge whose source has already been closed has deposited its target
in the visited state set. -/
def IndexedQueue.ClosedExpanded (inventory : List (ReverseEdge M))
    (queue : IndexedQueue M) : Prop :=
  ∀ node ∈ queue.closed, ∀ edge ∈ inventory,
    reverseEdgeSourceState M edge = node.state →
      reverseEdgeTargetState M edge ∈ queue.states

/-- Until a source is closed, every one of its inventory edges remains in the
destructive source index. -/
def IndexedQueue.RemainingCovers (inventory : List (ReverseEdge M))
    (queue : IndexedQueue M) : Prop :=
  ∀ edge ∈ inventory,
    reverseEdgeSourceState M edge ∉ queue.closed.map ReachNode.state →
      edge ∈ indexEdges M queue.remaining

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

theorem advanceQueue_nodes_mono (queue : IndexedQueue M)
    {node : ReachNode (ReverseEdge M) (SourceState X)}
    (hnode : node ∈ queue.nodes) : node ∈ (advanceQueue M queue).nodes := by
  let expansion := consumeFrontier M queue.frontier queue.remaining
  let next := freshNodes queue.states expansion.candidates
  change node ∈ queue.nodes ++ next
  exact List.mem_append.mpr (Or.inl hnode)

theorem advanceQueue_states_mono (queue : IndexedQueue M)
    {state : SourceState X} (hstate : state ∈ queue.states) :
    state ∈ (advanceQueue M queue).states := by
  simp only [IndexedQueue.states, List.mem_map] at hstate ⊢
  obtain ⟨node, hnode, rfl⟩ := hstate
  exact ⟨node, advanceQueue_nodes_mono M queue hnode, rfl⟩

theorem advanceQueue_candidate_state (queue : IndexedQueue M)
    {candidate : ReachNode (ReverseEdge M) (SourceState X)}
    (hcandidate : candidate ∈
      (consumeFrontier M queue.frontier queue.remaining).candidates) :
    candidate.state ∈ (advanceQueue M queue).states := by
  let expansion := consumeFrontier M queue.frontier queue.remaining
  have hcover := freshNodes_covers_candidate queue.states
    expansion.candidates hcandidate
  rcases hcover with hold | hfresh
  · exact advanceQueue_states_mono M queue hold
  · obtain ⟨kept, hkept, heq⟩ := hfresh
    simp only [IndexedQueue.states, List.mem_map]
    refine ⟨kept, ?_, heq⟩
    change kept ∈ queue.nodes ++ freshNodes queue.states expansion.candidates
    exact List.mem_append.mpr (Or.inr hkept)

theorem advanceQueue_remaining_sound (queue : IndexedQueue M)
    (hsound : IndexSound M queue.remaining) :
    IndexSound M (advanceQueue M queue).remaining := by
  simpa [advanceQueue] using
    consumeFrontier_remaining_sound M queue.frontier queue.remaining hsound

theorem advanceQueue_remaining_keys_nodup (queue : IndexedQueue M)
    (hkeys : IndexKeysNodup M queue.remaining) :
    IndexKeysNodup M (advanceQueue M queue).remaining := by
  simpa [advanceQueue] using
    consumeFrontier_remaining_keys_nodup M queue.frontier queue.remaining hkeys

theorem advanceQueue_remaining_covers (inventory : List (ReverseEdge M))
    (queue : IndexedQueue M) (hsound : IndexSound M queue.remaining)
    (hcover : queue.RemainingCovers M inventory) :
    (advanceQueue M queue).RemainingCovers M inventory := by
  intro edge hedge hsource
  have holdClosed :
      reverseEdgeSourceState M edge ∉ queue.closed.map ReachNode.state := by
    intro hold
    apply hsource
    simp only [advanceQueue, List.map_append, List.mem_append]
    exact Or.inl hold
  apply consumeFrontier_remaining_covers_edge M queue.frontier queue.remaining
      hsound (hcover edge hedge holdClosed)
  intro node hnode heq
  apply hsource
  simp only [advanceQueue, List.map_append, List.mem_append, List.mem_map]
  exact Or.inr ⟨node, hnode, heq.symm⟩

theorem frontier_state_not_mem_closed (queue : IndexedQueue M)
    (hnodup : queue.states.Nodup)
    {node : ReachNode (ReverseEdge M) (SourceState X)}
    (hnode : node ∈ queue.frontier) :
    node.state ∉ queue.closed.map ReachNode.state := by
  change ((queue.closed ++ queue.frontier).map ReachNode.state).Nodup at hnodup
  rw [List.map_append, List.nodup_append'] at hnodup
  rw [List.disjoint_left] at hnodup
  intro hclosed
  exact hnodup.2.2 hclosed (List.mem_map.mpr ⟨node, hnode, rfl⟩)

theorem advanceQueue_closed_expanded (inventory : List (ReverseEdge M))
    (queue : IndexedQueue M) (hclosed : queue.ClosedExpanded M inventory)
    (hcover : queue.RemainingCovers M inventory)
    (hsound : IndexSound M queue.remaining)
    (hkeys : IndexKeysNodup M queue.remaining)
    (hnodup : queue.states.Nodup) :
    (advanceQueue M queue).ClosedExpanded M inventory := by
  intro node hnode edge hedge hsource
  change node ∈ queue.closed ++ queue.frontier at hnode
  rcases List.mem_append.mp hnode with hold | hfrontier
  · exact advanceQueue_states_mono M queue
      (hclosed node hold edge hedge hsource)
  · have hnotClosed :=
      frontier_state_not_mem_closed M queue hnodup hfrontier
    have hedgeRemaining := hcover edge hedge (fun hsourceClosed =>
      hnotClosed (hsource ▸ hsourceClosed))
    obtain ⟨candidate, hcandidate, htarget⟩ :=
      consumeFrontier_covers_edge M queue.frontier queue.remaining
        hsound hkeys hedgeRemaining ⟨node, hfrontier, hsource⟩
    rw [← htarget]
    exact advanceQueue_candidate_state M queue hcandidate

theorem advanceQueue_nodes_valid (queue : IndexedQueue M)
    (hvalid : ∀ node ∈ queue.nodes, node.Valid (indexedEdgeDFA M)) :
    ∀ node ∈ (advanceQueue M queue).nodes,
      node.Valid (indexedEdgeDFA M) := by
  intro node hnode
  let expansion := consumeFrontier M queue.frontier queue.remaining
  let next := freshNodes queue.states expansion.candidates
  change node ∈ queue.nodes ++ next at hnode
  rcases List.mem_append.mp hnode with hold | hfresh
  · exact hvalid node hold
  · apply consumeFrontier_candidates_valid M queue.frontier queue.remaining
    · intro old hfrontier
      exact hvalid old (List.mem_append.mpr (Or.inr hfrontier))
    · exact mem_freshNodes_imp_mem hfresh

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
    · intro old hfrontier
      exact hchained old (List.mem_append.mpr (Or.inr hfrontier))
    · exact mem_freshNodes_imp_mem hfresh

theorem runQueue_total (edges : List (ReverseEdge M)) (fuel : Nat) :
    (runQueue M edges fuel).attempts +
        indexPayload M (runQueue M edges fuel).remaining = edges.length := by
  induction fuel with
  | zero => simp [runQueue, initialQueue, materializeIndex_payload]
  | succ fuel ih =>
      rw [runQueue, advanceQueue_total]
      exact ih

theorem runQueue_remaining_sound (edges : List (ReverseEdge M)) (fuel : Nat) :
    IndexSound M (runQueue M edges fuel).remaining := by
  induction fuel with
  | zero => simpa [runQueue, initialQueue] using materializeIndex_sound M edges
  | succ fuel ih =>
      exact advanceQueue_remaining_sound M (runQueue M edges fuel) ih

theorem runQueue_remaining_keys_nodup (edges : List (ReverseEdge M))
    (fuel : Nat) :
    IndexKeysNodup M (runQueue M edges fuel).remaining := by
  induction fuel with
  | zero =>
      simpa [runQueue, initialQueue] using
        materializeIndex_keys_nodup M edges
  | succ fuel ih =>
      exact advanceQueue_remaining_keys_nodup M (runQueue M edges fuel) ih

theorem runQueue_remaining_covers (edges : List (ReverseEdge M)) (fuel : Nat) :
    (runQueue M edges fuel).RemainingCovers M edges := by
  induction fuel with
  | zero =>
      intro edge hedge _hsource
      simpa [runQueue, initialQueue] using
        (mem_materializeIndex_iff M edge edges).mpr hedge
  | succ fuel ih =>
      exact advanceQueue_remaining_covers M edges (runQueue M edges fuel)
        (runQueue_remaining_sound M edges fuel) ih

theorem runQueue_nodes_valid (edges : List (ReverseEdge M)) (fuel : Nat) :
    ∀ node ∈ (runQueue M edges fuel).nodes,
      node.Valid (indexedEdgeDFA M) := by
  induction fuel with
  | zero =>
      intro node hnode
      simp [runQueue, initialQueue, IndexedQueue.nodes] at hnode
      rcases hnode with rfl
      rfl
  | succ fuel ih =>
      exact advanceQueue_nodes_valid M (runQueue M edges fuel) ih

/-- Every node actually retained by the indexed traversal carries a causal
edge-by-edge path from the synthetic source to its stored state. -/
theorem runQueue_nodes_chained (edges : List (ReverseEdge M)) (fuel : Nat) :
    ∀ node ∈ (runQueue M edges fuel).nodes, NodeChained M node := by
  induction fuel with
  | zero =>
      intro node hnode
      simp [runQueue, initialQueue, IndexedQueue.nodes] at hnode
      rcases hnode with rfl
      exact EdgeTrace.Chained.nil _
  | succ fuel ih =>
      exact advanceQueue_nodes_chained M (runQueue M edges fuel)
        (runQueue_remaining_sound M edges fuel) ih

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

theorem runQueue_closed_expanded (edges : List (ReverseEdge M)) (fuel : Nat) :
    (runQueue M edges fuel).ClosedExpanded M edges := by
  induction fuel with
  | zero =>
      intro node hnode
      simp [runQueue, initialQueue] at hnode
  | succ fuel ih =>
      exact advanceQueue_closed_expanded M edges (runQueue M edges fuel) ih
        (runQueue_remaining_covers M edges fuel)
        (runQueue_remaining_sound M edges fuel)
        (runQueue_remaining_keys_nodup M edges fuel)
        (runQueue_states_nodup M edges fuel)

theorem advanceQueue_frontier_eq_nil_of_frontier_eq_nil
    (queue : IndexedQueue M) (hfrontier : queue.frontier = []) :
    (advanceQueue M queue).frontier = [] := by
  simp [advanceQueue, hfrontier, consumeFrontier, freshNodes]

/-- If work remains after `fuel` rounds, every preceding round expanded at
least one fresh state. -/
theorem runQueue_fuel_le_closed_length_of_frontier_ne_nil
    (edges : List (ReverseEdge M)) (fuel : Nat)
    (hfrontier : (runQueue M edges fuel).frontier ≠ []) :
    fuel ≤ (runQueue M edges fuel).closed.length := by
  induction fuel with
  | zero => simp
  | succ fuel ih =>
      have hprevious : (runQueue M edges fuel).frontier ≠ [] := by
        intro hempty
        apply hfrontier
        exact advanceQueue_frontier_eq_nil_of_frontier_eq_nil M _ hempty
      have hlength := ih hprevious
      have hpositive : 0 < (runQueue M edges fuel).frontier.length :=
        List.length_pos_iff.mpr hprevious
      change fuel + 1 ≤
        ((runQueue M edges fuel).closed ++
          (runQueue M edges fuel).frontier).length
      simp only [List.length_append]
      omega

theorem sourceState_card [Fintype X] :
    Fintype.card (SourceState X) =
      Fintype.card X * Fintype.card X + 1 := by
  rw [← Fintype.card_congr (sourceStateEquiv (X := X))]
  simp [Fintype.card_prod, Nat.add_comm]

/-- The product-state-plus-source horizon is saturated: after one round per
possible native state, no unexpanded fresh node remains. -/
theorem runQueue_frontier_eq_nil [Fintype X]
    (edges : List (ReverseEdge M)) :
    (runQueue M edges (Fintype.card X * Fintype.card X + 1)).frontier = [] := by
  by_contra hfrontier
  have hfuel := runQueue_fuel_le_closed_length_of_frontier_ne_nil M edges
    (Fintype.card X * Fintype.card X + 1) hfrontier
  have hstates :=
    (runQueue_states_nodup M edges
      (Fintype.card X * Fintype.card X + 1)).length_le_card
  simp only [IndexedQueue.states, IndexedQueue.nodes, List.length_map,
    List.length_append, sourceState_card] at hstates
  have hpositive :
      0 < (runQueue M edges
        (Fintype.card X * Fintype.card X + 1)).frontier.length :=
    List.length_pos_iff.mpr hfrontier
  omega

def IndexedQueue.Saturated (inventory : List (ReverseEdge M))
    (queue : IndexedQueue M) : Prop :=
  ∀ state ∈ queue.states, ∀ edge ∈ inventory,
    reverseEdgeSourceState M edge = state →
      reverseEdgeTargetState M edge ∈ queue.states

theorem closed_expanded_saturated_of_frontier_eq_nil
    (inventory : List (ReverseEdge M)) (queue : IndexedQueue M)
    (hclosed : queue.ClosedExpanded M inventory)
    (hfrontier : queue.frontier = []) :
    queue.Saturated M inventory := by
  intro state hstate edge hedge hsource
  simp only [IndexedQueue.states, IndexedQueue.nodes, hfrontier,
    List.append_nil, List.mem_map] at hstate
  obtain ⟨node, hnode, rfl⟩ := hstate
  exact hclosed node hnode edge hedge hsource

/-- Saturation turns a causal inventory trace into actual visited-state
coverage.  Endpoint DFA validity alone is deliberately not sufficient. -/
theorem saturated_covers_chained (inventory : List (ReverseEdge M))
    (queue : IndexedQueue M) (hsaturated : queue.Saturated M inventory)
    {start finish : SourceState X} {edges : List (ReverseEdge M)}
    (hstart : start ∈ queue.states)
    (hchain : EdgeTrace.Chained M start edges finish)
    (hinventory : ∀ edge ∈ edges, edge ∈ inventory) :
    finish ∈ queue.states := by
  induction hchain with
  | nil state => exact hstart
  | cons edge hsource tail ih =>
      apply ih
      · exact hsaturated _ hstart edge
          (hinventory edge List.mem_cons_self) hsource
      · intro next hnext
        exact hinventory next (List.mem_cons_of_mem edge hnext)

theorem runQueue_source_mem (edges : List (ReverseEdge M)) (fuel : Nat) :
    SourceState.source ∈ (runQueue M edges fuel).states := by
  induction fuel with
  | zero => simp [runQueue, initialQueue, IndexedQueue.states,
      IndexedQueue.nodes]
  | succ fuel ih =>
      exact advanceQueue_states_mono M (runQueue M edges fuel) ih

/-- One source-indexed traversal through the finite source/product state
space. -/
def indexedTraversal [LinearOrder X] [Fintype X]
    (alphabet : List A) : IndexedQueue M :=
  runQueue M (edgeInventory M alphabet)
    (Fintype.card X * Fintype.card X + 1)

theorem indexedTraversal_frontier_eq_nil [LinearOrder X] [Fintype X]
    (alphabet : List A) :
    (indexedTraversal M alphabet).frontier = [] := by
  simpa [indexedTraversal] using
    runQueue_frontier_eq_nil M (edgeInventory M alphabet)

theorem indexedTraversal_saturated [LinearOrder X] [Fintype X]
    (alphabet : List A) :
    (indexedTraversal M alphabet).Saturated M (edgeInventory M alphabet) := by
  apply closed_expanded_saturated_of_frontier_eq_nil M
  · simpa [indexedTraversal] using
      runQueue_closed_expanded M (edgeInventory M alphabet)
        (Fintype.card X * Fintype.card X + 1)
  · exact indexedTraversal_frontier_eq_nil M alphabet

/-- Every genuine causal path in the materialized inventory has its endpoint
retained by the native source-indexed traversal. -/
theorem indexedTraversal_covers_chained [LinearOrder X] [Fintype X]
    (alphabet : List A) {edges : List (ReverseEdge M)}
    {finish : SourceState X}
    (hchain : EdgeTrace.Chained M .source edges finish)
    (hinventory : ∀ edge ∈ edges,
      edge ∈ edgeInventory M alphabet) :
    finish ∈ (indexedTraversal M alphabet).states := by
  apply saturated_covers_chained M (edgeInventory M alphabet)
      (indexedTraversal M alphabet) (indexedTraversal_saturated M alphabet)
  · simpa [indexedTraversal] using
      runQueue_source_mem M (edgeInventory M alphabet)
        (Fintype.card X * Fintype.card X + 1)
  · exact hchain
  · exact hinventory

/-- The complete executable traversal exposes the causal invariant directly,
not only at the internal fuel-indexed queue. -/
theorem indexedTraversal_nodes_chained [LinearOrder X] [Fintype X]
    (alphabet : List A) :
    ∀ node ∈ (indexedTraversal M alphabet).nodes, NodeChained M node := by
  simpa [indexedTraversal] using
    runQueue_nodes_chained M (edgeInventory M alphabet)
      (Fintype.card X * Fintype.card X + 1)

/-- Exact completeness at the native policy boundary: every unequal pair in
a finite reduced chart has a retained, causal, inventory-resident witness
node in the closed queue. -/
theorem exists_closed_indexed_node_of_ne [LinearOrder X] [Fintype X]
    [DecidableEq A] (alphabet : List A)
    (complete : ∀ action : A, action ∈ alphabet)
    (reduced : BehaviorallyReduced M) (pair : X × X)
    (hne : pair.1 ≠ pair.2) :
    ∃ node ∈ (indexedTraversal M alphabet).closed,
      NodeChained M node ∧ node.state = .pair pair := by
  obtain ⟨edges, hinventory, hchain⟩ :=
    exists_inventory_chained_path_of_ne M alphabet complete reduced pair hne
  have hpair :
      SourceState.pair pair ∈ (indexedTraversal M alphabet).states :=
    indexedTraversal_covers_chained M alphabet hchain hinventory
  have hfrontier := indexedTraversal_frontier_eq_nil M alphabet
  simp only [IndexedQueue.states, IndexedQueue.nodes, hfrontier,
    List.append_nil, List.mem_map] at hpair
  obtain ⟨node, hclosed, hstate⟩ := hpair
  refine ⟨node, hclosed, ?_, hstate⟩
  apply indexedTraversal_nodes_chained M alphabet node
  change node ∈ (indexedTraversal M alphabet).closed ++
    (indexedTraversal M alphabet).frontier
  rw [hfrontier, List.append_nil]
  exact hclosed

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

/-- The source index charges fourteen genuine outgoing edges on the reached
seven-state subgraph, strictly below the 22-edge stored inventory. -/
theorem indexed_traversal_attempts_fourteen :
    (indexedTraversal automaton alphabet).attempts = 14 := by
  decide

theorem indexed_traversal_strictly_below_inventory :
    (indexedTraversal automaton alphabet).attempts <
      (edgeInventory automaton alphabet).length := by
  decide

/-- The state-presentation adapter executes natively on an actual predecessor
edge. -/
theorem native_reindex_adapter_control :
    let edge : ReverseEdge automaton :=
      ReverseEdge.predecessor (0, 1) false
    (indexedEdgeDFA automaton).evalFrom
        (reverseEdgeSourceState automaton edge) [edge] =
      reverseEdgeTargetState automaton edge := by
  decide

/-- Formation's hostile trace is endpoint-valid but fails the causal path
invariant at its wrong-source predecessor. -/
theorem wrong_source_trace_not_chained :
    let seed : TerminalSeed automaton :=
      ⟨(0, 2), by decide⟩
    let wrong : ReverseEdge automaton :=
      .predecessor (0, 1) false
    ¬ EdgeTrace.Chained automaton .source [ReverseEdge.seed seed, wrong]
        (.pair (0, 2)) := by
  dsimp
  intro hchain
  have hsource := EdgeTrace.Chained.head_source (M := automaton)
    (EdgeTrace.Chained.tail (M := automaton) hchain)
  exact (by decide :
    reverseEdgeSourceState automaton
        (ReverseEdge.predecessor (0, 1) false) ≠
      reverseEdgeTargetState automaton
        (ReverseEdge.seed ⟨(0, 2), by decide⟩)) hsource

/-- The indexed queue retains the same reached product-state set as the flat
reverse traversal on the planted control. -/
theorem indexed_and_flat_reach_same_states :
    ((indexedTraversal automaton alphabet).closed.map ReachNode.state).toFinset =
      (((reverseTraversal automaton alphabet).closed.map ReachNode.state).map
        (sourceStateEquiv (X := Fin 3))).toFinset := by
  decide

end Control

end NativeIndexedReverseTraversal

end Pairfield
