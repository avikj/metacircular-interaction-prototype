/-
Copyright (c) 2026 Avik Jain and the mathematics collaboration.
Released under Apache 2.0 license.

Visited-state shortest distinguishing witnesses.  This applies the generic
queue to the synchronous pair DFA, so the native implementation expands each
reachable pair at most once while retaining a replayable shortest suffix.
-/
import Pairfield.VisitedReachCardinality

namespace Pairfield

universe u v

variable {A : Type u} {X : Type v}

/-- The visited pair-state queue at its exact finite cardinal horizon. -/
def visitedStatePairQueue [DecidableEq X] [Fintype X]
    (M : DFA A X) [DecidablePred (fun state : X => state ∈ M.accept)]
    (alphabet : List A) (left right : X) : ReachQueue A (X × X) :=
  visitedReachQueue (statePairDFA M left right) alphabet

/-- The first distinguishing pair node in breadth-first queue order. -/
def visitedStateWitnessNode? [DecidableEq X] [Fintype X]
    (M : DFA A X) [DecidablePred (fun state : X => state ∈ M.accept)]
    (alphabet : List A) (left right : X) : Option (ReachNode A (X × X)) :=
  let P := statePairDFA M left right
  (visitedStatePairQueue M alphabet left right).nodes.find?
    (fun node => decide (node.state ∈ P.accept))

/-- The executable suffix projection.  The node-valued query above retains
the terminal pair and therefore the complete replay certificate. -/
def visitedStateWitness? [DecidableEq X] [Fintype X]
    (M : DFA A X) [DecidablePred (fun state : X => state ∈ M.accept)]
    (alphabet : List A) (left right : X) : Option (List A) :=
  (visitedStateWitnessNode? M alphabet left right).map ReachNode.word

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
      · apply List.pairwise_of_forall
        intro left hleft right hright _
        have leftCandidate := mem_freshNodes_imp_mem hleft
        have rightCandidate := mem_freshNodes_imp_mem hright
        have leftLength := mem_expandFrontier_word_length_eq M alphabet
          queue.frontier n
          (runReachQueue_frontier_word_length M alphabet n)
          left leftCandidate
        have rightLength := mem_expandFrontier_word_length_eq M alphabet
          queue.frontier n
          (runReachQueue_frontier_word_length M alphabet n)
          right rightCandidate
        omega
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

/-- A returned visited node replays to a separating pair and is globally
shortest among all distinguishing suffixes. -/
theorem visitedStateWitnessNode?_sound
    [DecidableEq X] [Fintype X]
    (M : DFA A X) [DecidablePred (fun state : X => state ∈ M.accept)]
    (alphabet : List A) (complete : ∀ action : A, action ∈ alphabet)
    (left right : X) {node : ReachNode A (X × X)}
    (hnode : visitedStateWitnessNode? M alphabet left right = some node) :
    node.Valid (statePairDFA M left right) ∧
      behavior M.step (acceptsBool M) left node.word ≠
        behavior M.step (acceptsBool M) right node.word ∧
      ∀ candidate : List A,
        behavior M.step (acceptsBool M) left candidate ≠
          behavior M.step (acceptsBool M) right candidate →
        node.word.length ≤ candidate.length := by
  let P := statePairDFA M left right
  have hmem : node ∈ (visitedStatePairQueue M alphabet left right).nodes :=
    List.mem_of_find?_eq_some hnode
  have haccept : node.state ∈ P.accept := by
    have := List.find?_some hnode
    simpa [P] using this
  have hvalid : node.Valid P :=
    runReachQueue_valid P alphabet (Fintype.card (X × X)) node hmem
  have hseparates :
      behavior M.step (acceptsBool M) left node.word ≠
        behavior M.step (acceptsBool M) right node.word := by
    apply (mem_statePairDFA_accepts_iff M left right node.word).1
    rw [DFA.mem_accepts]
    exact hvalid ▸ haccept
  refine ⟨hvalid, hseparates, ?_⟩
  intro candidate hcandidate
  have hcandAccept : candidate ∈ P.accepts :=
    (mem_statePairDFA_accepts_iff M left right candidate).2 hcandidate
  have hcover := runReachQueue_covers_word P alphabet complete candidate
  simp only [ReachQueue.states, List.mem_map] at hcover
  obtain ⟨candidateNode, hcandNode, hcandState⟩ := hcover
  obtain ⟨short, hshortLength, hshortEval⟩ := exists_short_eval_eq P candidate
  have hshortCover := runReachQueue_covers_word P alphabet complete short
  simp only [ReachQueue.states, List.mem_map] at hshortCover
  obtain ⟨stored, hstored, hstoredState⟩ := hshortCover
  have hstoredFinal : stored ∈
      (visitedStatePairQueue M alphabet left right).nodes := by
    apply advanceReachQueue_nodes_mono_le P alphabet
      (Nat.le_of_lt hshortLength) hstored
  have hstoredAccept : stored.state ∈ P.accept := by
    rw [← hstoredState, hshortEval]
    exact (DFA.mem_accepts.mp hcandAccept)
  have hfirstMinimal := find?_word_length_minimal_of_pairwise
    (visitedStatePairQueue M alphabet left right).nodes
    (fun candidate => decide (candidate.state ∈ P.accept))
    (runReachQueue_nodes_pairwise_word_length P alphabet
      (Fintype.card (X × X))) hnode stored hstoredFinal
    (by simpa [hstoredAccept])
  have hstoredMinimal := runReachQueue_node_minimal P alphabet complete
    (Fintype.card (X × X)) hstoredFinal candidate
    (hshortEval.trans (hstoredState.trans hcandState.symm))
  exact Nat.le_trans hfirstMinimal hstoredMinimal

/-- No visited accepting pair is exactly complete-future equality. -/
theorem visitedStateWitnessNode?_eq_none_iff
    [DecidableEq X] [Fintype X]
    (M : DFA A X) [DecidablePred (fun state : X => state ∈ M.accept)]
    (alphabet : List A) (complete : ∀ action : A, action ∈ alphabet)
    (left right : X) :
    visitedStateWitnessNode? M alphabet left right = none ↔
      FutureEq M.step (acceptsBool M) left right := by
  constructor
  · intro hnone word
    by_contra hword
    let P := statePairDFA M left right
    have haccept : word ∈ P.accepts :=
      (mem_statePairDFA_accepts_iff M left right word).2 hword
    obtain ⟨short, hlength, hshort⟩ :=
      exists_state_separator_lt_card_sq M left right hword
    have hcover := runReachQueue_covers_word P alphabet complete short
    simp only [ReachQueue.states, List.mem_map] at hcover
    obtain ⟨node, hnode, hstate⟩ := hcover
    have hnodeFinal : node ∈
        (visitedStatePairQueue M alphabet left right).nodes := by
      apply advanceReachQueue_nodes_mono_le P alphabet
      · simpa [Fintype.card_prod] using Nat.le_of_lt hlength
      · exact hnode
    have hnodeAccept : node.state ∈ P.accept := by
      rw [← hstate]
      exact (DFA.mem_accepts.mp
        ((mem_statePairDFA_accepts_iff M left right short).2 hshort))
    have hnoneAll : ∀ candidate ∈
        (visitedStatePairQueue M alphabet left right).nodes,
        decide (candidate.state ∈ P.accept) = false := by
      simpa [visitedStateWitnessNode?, P,
        List.find?_eq_none] using hnone
    have := hnoneAll node hnodeFinal
    simpa [hnodeAccept] using this
  · intro heq
    unfold visitedStateWitnessNode?
    rw [List.find?_eq_none]
    intro node hnode
    have hvalid := runReachQueue_valid (statePairDFA M left right)
      alphabet (Fintype.card (X × X)) node hnode
    have hnotAccept : node.state ∉ (statePairDFA M left right).accept := by
      intro haccept
      have hwordAccept : node.word ∈
          (statePairDFA M left right).accepts := by
        rw [DFA.mem_accepts]
        exact hvalid ▸ haccept
      exact ((mem_statePairDFA_accepts_iff M left right node.word).1
        hwordAccept) (heq node.word)
    simp [hnotAccept]

/-- The pair queue completes at most one expansion per pair state. -/
theorem visitedStatePairQueue_expansion_bound
    [DecidableEq X] [Fintype X]
    (M : DFA A X) [DecidablePred (fun state : X => state ∈ M.accept)]
    (alphabet : List A) (left right : X) :
    (visitedStatePairQueue M alphabet left right).closed.length ≤
      Fintype.card X * Fintype.card X := by
  simpa [visitedStatePairQueue, Fintype.card_prod] using
    visitedReachQueue_expansion_bound (statePairDFA M left right) alphabet

theorem visitedStatePairQueue_stable
    [DecidableEq X] [Fintype X]
    (M : DFA A X) [DecidablePred (fun state : X => state ∈ M.accept)]
    (alphabet : List A) (complete : ∀ action : A, action ∈ alphabet)
    (left right : X) :
    advanceReachQueue (statePairDFA M left right) alphabet
        (visitedStatePairQueue M alphabet left right) =
      visitedStatePairQueue M alphabet left right :=
  visitedReachQueue_stable (statePairDFA M left right) alphabet complete

/-- The visited implementation and exhaustive specification can differ only
by tie choice, never by existence or minimum suffix length. -/
theorem visitedStateWitness?_length_eq_shortestStateWitness
    [DecidableEq A] [DecidableEq X] [Fintype X]
    (M : DFA A X) [DecidablePred (fun state : X => state ∈ M.accept)]
    (alphabet : List A) (complete : ∀ action : A, action ∈ alphabet)
    (left right : X) {node : ReachNode A (X × X)} {word : List A}
    (hvisited : visitedStateWitnessNode? M alphabet left right = some node)
    (hexhaustive : shortestStateWitness M alphabet left right = some word) :
    node.word.length = word.length := by
  have hvisitedSound := visitedStateWitnessNode?_sound M alphabet complete
    left right hvisited
  have hexhaustiveSound := shortestStateWitness_sound M alphabet complete
    left right hexhaustive
  apply Nat.le_antisymm
  · exact hvisitedSound.2.2 word hexhaustiveSound
  · exact shortestStateWitness_minimal M alphabet complete left right
      hexhaustive node.word hvisitedSound.2.1

/-- All distinguishing derivations remain present even though the active
queue selects one globally shortest suffix. -/
def DistinguishingDerivationFiber
    (M : DFA A X) [DecidablePred (fun state : X => state ∈ M.accept)]
    (left right : X) :=
  { word : List A //
      behavior M.step (acceptsBool M) left word ≠
        behavior M.step (acceptsBool M) right word }

theorem visitedStateWitnessNode?_exists_iff_derivationFiber
    [DecidableEq X] [Fintype X]
    (M : DFA A X) [DecidablePred (fun state : X => state ∈ M.accept)]
    (alphabet : List A) (complete : ∀ action : A, action ∈ alphabet)
    (left right : X) :
    (∃ node, visitedStateWitnessNode? M alphabet left right = some node) ↔
      Nonempty (DistinguishingDerivationFiber M left right) := by
  constructor
  · rintro ⟨node, hnode⟩
    exact ⟨⟨node.word,
      (visitedStateWitnessNode?_sound M alphabet complete
        left right hnode).2.1⟩⟩
  · rintro ⟨⟨word, hword⟩⟩
    cases hresult : visitedStateWitnessNode? M alphabet left right with
    | none =>
        exact False.elim
          (((visitedStateWitnessNode?_eq_none_iff M alphabet complete
            left right).1 hresult word) hword)
    | some node => exact ⟨node, rfl⟩

namespace VisitedPairWitness

open ChartStateBFSWitness ReachableChartWitness

example :
    (visitedStateWitnessNode? chart.toDFA alphabet left right).map
      (fun node => node.word) = some [true] := by
  native_decide

example : visitedStateWitnessNode? chart.toDFA alphabet left left = none := by
  native_decide

example :
    (visitedStatePairQueue chart.toDFA alphabet left right).closed.length ≤
      Fintype.card chart.State * Fintype.card chart.State :=
  visitedStatePairQueue_expansion_bound chart.toDFA alphabet left right

end VisitedPairWitness

end Pairfield
