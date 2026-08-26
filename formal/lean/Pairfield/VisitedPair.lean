/-
Copyright (c) 2026 Avik Jain and the mathematics collaboration.
Released under Apache 2.0 license.

Global shortestness and proof-relevant fibers for the visited synchronous
pair traversal supplied by `VisitedPairHorizon`.
-/
import Pairfield.VisitedPairHorizon
import Pairfield.VisitedReachCardinality

namespace Pairfield

universe u v

variable {A : Type u} {X : Type v}

theorem pairwise_word_length_of_all_eq
    (nodes : List (ReachNode A X)) (round : Nat)
    (hlength : ∀ node ∈ nodes, node.word.length = round) :
    nodes.Pairwise (fun left right =>
      left.word.length ≤ right.word.length) := by
  induction nodes with
  | nil => simp
  | cons head tail ih =>
      simp only [List.pairwise_cons]
      constructor
      · intro node hnode
        rw [hlength head List.mem_cons_self,
          hlength node (List.mem_cons_of_mem head hnode)]
      · apply ih
        intro node hnode
        exact hlength node (List.mem_cons_of_mem head hnode)

/-- Queue insertion order is breadth-first: earlier retained nodes never have
longer replay words than later retained nodes. -/
theorem runReachQueue_nodes_pairwise_word_length [DecidableEq X]
    (M : DFA A X) (alphabet : List A) (round : Nat) :
    (runReachQueue M alphabet round).nodes.Pairwise
      (fun left right => left.word.length ≤ right.word.length) := by
  induction round with
  | zero => simp [runReachQueue, initialReachQueue, ReachQueue.nodes]
  | succ n ih =>
      let queue := runReachQueue M alphabet n
      let next := freshNodes queue.states
        (expandFrontier M alphabet queue.frontier)
      change (queue.nodes ++ next).Pairwise
        (fun left right => left.word.length ≤ right.word.length)
      rw [List.pairwise_append]
      refine ⟨ih, ?_, ?_⟩
      · apply pairwise_word_length_of_all_eq next (n + 1)
        intro node hnode
        apply mem_expandFrontier_word_length_eq M alphabet
          queue.frontier n
          (runReachQueue_frontier_word_length M alphabet n)
        exact mem_freshNodes_imp_mem hnode
      · intro old hold fresh hfresh
        have holdLength := runReachQueue_word_length M alphabet n old hold
        have freshCandidate := mem_freshNodes_imp_mem hfresh
        have hfreshLength := mem_expandFrontier_word_length_eq M alphabet
          queue.frontier n
          (runReachQueue_frontier_word_length M alphabet n)
          fresh freshCandidate
        omega

theorem find?_word_length_minimal_of_pairwise
    (nodes : List (ReachNode A X))
    (predicate : ReachNode A X → Bool)
    (hordered : nodes.Pairwise
      (fun left right => left.word.length ≤ right.word.length))
    {found : ReachNode A X} (hfound : nodes.find? predicate = some found) :
    ∀ candidate ∈ nodes, predicate candidate = true →
      found.word.length ≤ candidate.word.length := by
  induction nodes with
  | nil => simp at hfound
  | cons head tail ih =>
      simp only [List.pairwise_cons] at hordered
      rcases hordered with ⟨hhead, htail⟩
      by_cases hp : predicate head = true
      · simp [List.find?, hp] at hfound
        subst found
        intro candidate hcandidate _
        simp only [List.mem_cons] at hcandidate
        rcases hcandidate with rfl | hcandidate
        · exact Nat.le_refl _
        · exact hhead candidate hcandidate
      · have hpFalse : predicate head = false := by
          cases hvalue : predicate head <;> simp_all
        simp [List.find?, hpFalse] at hfound
        intro candidate hcandidate hpredicate
        simp only [List.mem_cons] at hcandidate
        rcases hcandidate with rfl | hcandidate
        · contradiction
        · exact ih htail hfound candidate hcandidate hpredicate

/-- The reachable-pair queue is saturated and therefore a fixed point. -/
theorem visitedStatePairQueue_stable
    [DecidableEq X] [Fintype X]
    (M : DFA A X) [DecidablePred (fun state : X => state ∈ M.accept)]
    (alphabet : List A) (complete : ∀ action : A, action ∈ alphabet)
    (left right : X) :
    advanceReachQueue (statePairDFA M left right) alphabet
        (visitedStatePairQueue M alphabet left right) =
      visitedStatePairQueue M alphabet left right :=
  advanceReachQueue_eq_self_of_frontier_eq_nil
    (statePairDFA M left right) alphabet _
    (visitedStatePairQueue_frontier_eq_nil M alphabet complete left right)

/-- The visited pair query is globally shortest among all distinguishing
suffixes, not merely among the retained nodes. -/
theorem visitedPairWitness?_globally_shortest
    [DecidableEq X] [Fintype X]
    (M : DFA A X) [DecidablePred (fun state : X => state ∈ M.accept)]
    (alphabet : List A) (complete : ∀ action : A, action ∈ alphabet)
    (left right : X) {node : ReachNode A (X × X)}
    (hnode : visitedPairWitness? M alphabet left right = some node) :
    node.Valid (statePairDFA M left right) ∧
      behavior M.step (acceptsBool M) left node.word ≠
        behavior M.step (acceptsBool M) right node.word ∧
      ∀ candidate : List A,
        behavior M.step (acceptsBool M) left candidate ≠
          behavior M.step (acceptsBool M) right candidate →
        node.word.length ≤ candidate.length := by
  let P := statePairDFA M left right
  have hsound := visitedPairWitness?_sound M alphabet left right hnode
  refine ⟨hsound.1, hsound.2, ?_⟩
  intro candidate hcandidate
  obtain ⟨short, hshortLength, hshortEval⟩ := exists_short_eval_eq P candidate
  have hshortCover := runReachQueue_covers_word P alphabet complete short
  simp only [ReachQueue.states, List.mem_map] at hshortCover
  obtain ⟨stored, hstored, hstoredState⟩ := hshortCover
  have hstoredNodes : stored ∈
      (visitedStatePairQueue M alphabet left right).nodes := by
    apply advanceReachQueue_nodes_mono_le P alphabet
      (Nat.le_of_lt hshortLength) hstored
  have hfrontier := visitedStatePairQueue_frontier_eq_nil
    M alphabet complete left right
  have hstoredClosed : stored ∈
      (visitedStatePairQueue M alphabet left right).closed := by
    simpa [ReachQueue.nodes, hfrontier] using hstoredNodes
  have hcandAccept : candidate ∈ P.accepts :=
    (mem_statePairDFA_accepts_iff M left right candidate).2 hcandidate
  have hstoredAccept : stored.state ∈ P.accept := by
    rw [hstoredState, hshortEval]
    rw [← DFA.mem_accepts]
    exact hcandAccept
  have hstoredValid := runReachQueue_valid P alphabet
    (Fintype.card (X × X)) stored hstoredNodes
  have hstoredWordAccept : stored.word ∈ P.accepts := by
    rw [DFA.mem_accepts, hstoredValid]
    exact hstoredAccept
  have hstoredSeparates :=
    (mem_statePairDFA_accepts_iff M left right stored.word).1
      hstoredWordAccept
  have hstoredPredicate :
      Distinguishes M.step (acceptsBool M) left right stored.word = true :=
    (distinguishes_eq_true_iff M.step (acceptsBool M)
      left right stored.word).2 hstoredSeparates
  have horderedNodes := runReachQueue_nodes_pairwise_word_length P alphabet
    (Fintype.card (X × X))
  rw [ReachQueue.nodes, List.pairwise_append] at horderedNodes
  have hfirstMinimal := find?_word_length_minimal_of_pairwise
    (visitedStatePairQueue M alphabet left right).closed
    (fun candidate =>
      Distinguishes M.step (acceptsBool M) left right candidate.word)
    horderedNodes.1 hnode stored hstoredClosed hstoredPredicate
  have hstoredMinimal := runReachQueue_node_minimal P alphabet complete
    (Fintype.card (X × X)) hstoredNodes candidate
    (hshortEval.symm.trans hstoredState.symm)
  exact Nat.le_trans hfirstMinimal hstoredMinimal

/-- The visited query and exhaustive specification can choose different ties,
but their minimum distinguishing lengths agree exactly. -/
theorem visitedPairWitness?_length_eq_shortestStateWitness
    [DecidableEq A] [DecidableEq X] [Fintype X]
    (M : DFA A X) [DecidablePred (fun state : X => state ∈ M.accept)]
    (alphabet : List A) (complete : ∀ action : A, action ∈ alphabet)
    (left right : X) {node : ReachNode A (X × X)} {word : List A}
    (hvisited : visitedPairWitness? M alphabet left right = some node)
    (hexhaustive : shortestStateWitness M alphabet left right = some word) :
    node.word.length = word.length := by
  have hvisitedSound := visitedPairWitness?_globally_shortest M alphabet
    complete left right hvisited
  have hexhaustiveSound := shortestStateWitness_sound M alphabet complete
    left right hexhaustive
  apply Nat.le_antisymm
  · exact hvisitedSound.2.2 word hexhaustiveSound
  · exact shortestStateWitness_minimal M alphabet complete left right
      hexhaustive node.word hvisitedSound.2.1

/-- The complete proof-history fiber of distinguishing suffixes. -/
def DistinguishingDerivationFiber
    (M : DFA A X) [DecidablePred (fun state : X => state ∈ M.accept)]
    (left right : X) :=
  { word : List A //
      behavior M.step (acceptsBool M) left word ≠
        behavior M.step (acceptsBool M) right word }

/-- Selecting one active shortest separator never identifies or deletes the
other inhabitants of the distinguishing derivation fiber. -/
theorem visitedPairWitness?_exists_iff_derivationFiber
    [DecidableEq X] [Fintype X]
    (M : DFA A X) [DecidablePred (fun state : X => state ∈ M.accept)]
    (alphabet : List A) (complete : ∀ action : A, action ∈ alphabet)
    (left right : X) :
    (∃ node, visitedPairWitness? M alphabet left right = some node) ↔
      Nonempty (DistinguishingDerivationFiber M left right) := by
  constructor
  · rintro ⟨node, hnode⟩
    exact ⟨⟨node.word,
      (visitedPairWitness?_sound M alphabet left right hnode).2⟩⟩
  · rintro ⟨⟨word, hword⟩⟩
    cases hresult : visitedPairWitness? M alphabet left right with
    | none =>
        exact False.elim
          (hword ((visitedPairWitness?_eq_none_iff M alphabet complete
            left right).1 hresult word))
    | some node => exact ⟨node, rfl⟩

namespace VisitedPairWitness

open VisitedPairHorizonWitness BehavioralBFSWitness

example :
    (visitedPairWitness? automaton alphabet (0 : Fin 3) 1).map
      ReachNode.word = some [true] := by
  decide

example : visitedPairWitness? automaton alphabet (0 : Fin 3) 0 = none := by
  decide

example :
    reachableStatePairCount automaton alphabet (0 : Fin 3) 1 ≤
      Fintype.card (Fin 3) * Fintype.card (Fin 3) :=
  reachableStatePairCount_le_card_sq automaton alphabet 0 1

end VisitedPairWitness

end Pairfield
