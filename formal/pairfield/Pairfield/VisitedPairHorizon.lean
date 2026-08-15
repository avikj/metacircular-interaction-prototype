/-
Copyright (c) 2026 Avik Jain and the mathematics collaboration.
Released under Apache 2.0 license.

Compile finite observable formation through the visited traversal of the
synchronous state-pair monitor.  The retained queue records the actual
reachable pair count rather than identifying it with the ambient square.
-/
import Pairfield.ObservableHorizon
import Pairfield.VisitedReach

namespace Pairfield

universe u v

variable {A : Type u} {X : Type v}

/-- The exact visited queue of pairs reachable from two declared rows. -/
def visitedStatePairQueue [DecidableEq X] [Fintype X]
    (M : DFA A X) [DecidablePred (fun state : X => state ∈ M.accept)]
    (alphabet : List A) (left right : X) : ReachQueue A (X × X) :=
  visitedReachQueue (statePairDFA M left right) alphabet

/-- The implementation-level cost carrier: the number of pairs actually
expanded, not the cardinality of the ambient product. -/
def reachableStatePairCount [DecidableEq X] [Fintype X]
    (M : DFA A X) [DecidablePred (fun state : X => state ∈ M.accept)]
    (alphabet : List A) (left right : X) : Nat :=
  (visitedStatePairQueue M alphabet left right).closed.length

theorem reachableStatePairCount_le_card_sq [DecidableEq X] [Fintype X]
    (M : DFA A X) [DecidablePred (fun state : X => state ∈ M.accept)]
    (alphabet : List A) (left right : X) :
    reachableStatePairCount M alphabet left right ≤
      Fintype.card X * Fintype.card X := by
  simpa [reachableStatePairCount, visitedStatePairQueue,
    Fintype.card_prod] using
    (visitedReachQueue_expansion_bound
      (statePairDFA M left right) alphabet)

/-- Completeness of the alphabet empties the reachable pair frontier. -/
theorem visitedStatePairQueue_frontier_eq_nil
    [DecidableEq X] [Fintype X]
    (M : DFA A X) [DecidablePred (fun state : X => state ∈ M.accept)]
    (alphabet : List A) (complete : ∀ action : A, action ∈ alphabet)
    (left right : X) :
    (visitedStatePairQueue M alphabet left right).frontier = [] := by
  exact visitedReachQueue_frontier_eq_nil
    (statePairDFA M left right) alphabet complete

/-- Every semantic separator is represented by a valid retained pair node.
Its replay word is still strictly shorter than the ambient pair cardinality. -/
theorem exists_visited_pair_separator
    [DecidableEq X] [Fintype X]
    (M : DFA A X) [DecidablePred (fun state : X => state ∈ M.accept)]
    (alphabet : List A) (complete : ∀ action : A, action ∈ alphabet)
    (left right : X) {word : List A}
    (hword : behavior M.step (acceptsBool M) left word ≠
      behavior M.step (acceptsBool M) right word) :
    ∃ node ∈ (visitedStatePairQueue M alphabet left right).closed,
      node.Valid (statePairDFA M left right) ∧
        node.word.length < Fintype.card X * Fintype.card X ∧
          behavior M.step (acceptsBool M) left node.word ≠
            behavior M.step (acceptsBool M) right node.word := by
  let P := statePairDFA M left right
  obtain ⟨short, hshortLength, hshortSep⟩ :=
    exists_state_separator_lt_card_sq M left right hword
  have hcover := runReachQueue_covers_word P alphabet complete short
  simp only [ReachQueue.states, List.mem_map] at hcover
  obtain ⟨node, hnode, hstate⟩ := hcover
  have hnodeFinal :
      node ∈ (visitedReachQueue P alphabet).nodes := by
    apply advanceReachQueue_nodes_mono_le P alphabet
      (Nat.le_of_lt (by simpa [P, Fintype.card_prod] using hshortLength))
    exact hnode
  have hfrontier : (visitedReachQueue P alphabet).frontier = [] :=
    visitedReachQueue_frontier_eq_nil P alphabet complete
  have hclosed : node ∈ (visitedReachQueue P alphabet).closed := by
    simpa [ReachQueue.nodes, hfrontier] using hnodeFinal
  have hvalid : node.Valid P :=
    runReachQueue_valid P alphabet (Fintype.card (X × X)) node hnodeFinal
  have hminimal := runReachQueue_node_minimal P alphabet complete
    (Fintype.card (X × X)) hnodeFinal short hstate.symm
  have hlength : node.word.length < Fintype.card X * Fintype.card X :=
    Nat.lt_of_le_of_lt hminimal hshortLength
  have hshortAccept : short ∈ P.accepts :=
    (mem_statePairDFA_accepts_iff M left right short).2 hshortSep
  have hnodeAccept : node.word ∈ P.accepts := by
    rw [DFA.mem_accepts] at hshortAccept ⊢
    rw [hvalid, hstate]
    exact hshortAccept
  have hnodeSep :=
    (mem_statePairDFA_accepts_iff M left right node.word).1 hnodeAccept
  exact ⟨node, by simpa [visitedStatePairQueue, P] using hclosed,
    by simpa [P] using hvalid, hlength, hnodeSep⟩

/-- Search the saturated reachable-pair queue for a replayable separator. -/
def visitedPairWitness? [DecidableEq X] [Fintype X]
    (M : DFA A X) [DecidablePred (fun state : X => state ∈ M.accept)]
    (alphabet : List A) (left right : X) : Option (ReachNode A (X × X)) :=
  (visitedStatePairQueue M alphabet left right).closed.find? fun node =>
    Distinguishes M.step (acceptsBool M) left right node.word

theorem visitedPairWitness?_sound [DecidableEq X] [Fintype X]
    (M : DFA A X) [DecidablePred (fun state : X => state ∈ M.accept)]
    (alphabet : List A) (left right : X) {node : ReachNode A (X × X)}
    (hnode : visitedPairWitness? M alphabet left right = some node) :
    node.Valid (statePairDFA M left right) ∧
      behavior M.step (acceptsBool M) left node.word ≠
        behavior M.step (acceptsBool M) right node.word := by
  have hnode' := hnode
  unfold visitedPairWitness? at hnode'
  have hmem : node ∈ (visitedStatePairQueue M alphabet left right).closed :=
    List.mem_of_find?_eq_some hnode'
  have hdist := List.find?_some hnode'
  change Distinguishes M.step (acceptsBool M) left right node.word = true
    at hdist
  have hnodes :
      node ∈ (visitedStatePairQueue M alphabet left right).nodes := by
    exact List.mem_append.mpr (Or.inl hmem)
  refine ⟨?_, (distinguishes_eq_true_iff M.step (acceptsBool M)
    left right node.word).1 hdist⟩
  exact runReachQueue_valid (statePairDFA M left right) alphabet
    (Fintype.card (X × X)) node
    (by simpa [visitedStatePairQueue, visitedReachQueue] using hnodes)

/-- `none` is now an executable certificate of complete future equivalence;
`some node` is a valid replayable separating experiment. -/
theorem visitedPairWitness?_eq_none_iff
    [DecidableEq X] [Fintype X]
    (M : DFA A X) [DecidablePred (fun state : X => state ∈ M.accept)]
    (alphabet : List A) (complete : ∀ action : A, action ∈ alphabet)
    (left right : X) :
    visitedPairWitness? M alphabet left right = none ↔
      FutureEq M.step (acceptsBool M) left right := by
  unfold visitedPairWitness?
  rw [List.find?_eq_none]
  constructor
  · intro hnone word
    by_contra hsep
    obtain ⟨node, hnode, _, _, hnodeSep⟩ :=
      exists_visited_pair_separator M alphabet complete left right hsep
    have hfalse := hnone node hnode
    simpa [Distinguishes, hnodeSep] using hfalse
  · intro hfuture node _
    have heq := hfuture node.word
    simp [Distinguishes, heq]

namespace VisitedPairHorizonWitness

open BehavioralBFSWitness

def automaton : DFA Bool (Fin 3) where
  step := step
  start := 0
  accept := { state | observe state = true }

instance : DecidablePred (fun state : Fin 3 => state ∈ automaton.accept) :=
  fun state => inferInstanceAs (Decidable (observe state = true))

example : reachableStatePairCount automaton alphabet (0 : Fin 3) 1 = 2 := by
  decide

example :
    (visitedPairWitness? automaton alphabet (0 : Fin 3) 1).map
      ReachNode.word = some [true] := by
  decide

example :
    visitedPairWitness? automaton alphabet (0 : Fin 3) 0 = none := by
  decide

end VisitedPairHorizonWitness

end Pairfield
