/-
Copyright (c) 2026 Avik Jain and the mathematics collaboration.
Released under Apache 2.0 license.

The visited-state traversal specialized to the live synchronous pair monitor.
Mathlib's `DFA.evalFrom_split`, exposed through `exists_short_eval_eq`, makes
the stable product queue an exact future-equivalence decision.  The product
cardinality theorem identifies its generic horizon with `|X|^2`.
-/
import Pairfield.ObservableHorizon
import Pairfield.VisitedReach

namespace Pairfield

universe u v

variable {A : Type u} {X : Type v}

/-- The generic visited traversal, installed on the synchronous monitor for
two native DFA rows. -/
def visitedStatePairQueue [DecidableEq X] [Fintype X]
    (M : DFA A X) [DecidablePred (fun state : X => state ∈ M.accept)]
    (alphabet : List A) (left right : X) : ReachQueue A (X × X) :=
  visitedReachQueue (statePairDFA M left right) alphabet

/-- Mathlib's product-cardinality theorem identifies the installed generic
horizon with the formation lane's quadratic pair horizon. -/
theorem visitedStatePairQueue_eq_run_card_sq [DecidableEq X] [Fintype X]
    (M : DFA A X) [DecidablePred (fun state : X => state ∈ M.accept)]
    (alphabet : List A) (left right : X) :
    visitedStatePairQueue M alphabet left right =
      runReachQueue (statePairDFA M left right) alphabet
        (Fintype.card X * Fintype.card X) := by
  simp [visitedStatePairQueue, visitedReachQueue, Fintype.card_prod]

/-- At most one synchronous pair is expanded per element of `X × X`. -/
theorem visitedStatePairQueue_expansion_bound [DecidableEq X] [Fintype X]
    (M : DFA A X) [DecidablePred (fun state : X => state ∈ M.accept)]
    (alphabet : List A) (left right : X) :
    (visitedStatePairQueue M alphabet left right).closed.length ≤
      Fintype.card X * Fintype.card X := by
  simpa [visitedStatePairQueue, Fintype.card_prod] using
    visitedReachQueue_expansion_bound (statePairDFA M left right) alphabet

/-- With a complete finite alphabet, the quadratic pair horizon has no
unexpanded discoveries. -/
theorem visitedStatePairQueue_frontier_eq_nil [DecidableEq X] [Fintype X]
    (M : DFA A X) [DecidablePred (fun state : X => state ∈ M.accept)]
    (alphabet : List A) (complete : ∀ action : A, action ∈ alphabet)
    (left right : X) :
    (visitedStatePairQueue M alphabet left right).frontier = [] := by
  exact visitedReachQueue_frontier_eq_nil
    (statePairDFA M left right) alphabet complete

/-- The exhausted pair queue is a literal fixed point of one more expansion. -/
theorem visitedStatePairQueue_stable [DecidableEq X] [Fintype X]
    (M : DFA A X) [DecidablePred (fun state : X => state ∈ M.accept)]
    (alphabet : List A) (complete : ∀ action : A, action ∈ alphabet)
    (left right : X) :
    advanceReachQueue (statePairDFA M left right) alphabet
        (visitedStatePairQueue M alphabet left right) =
      visitedStatePairQueue M alphabet left right := by
  exact visitedReachQueue_stable
    (statePairDFA M left right) alphabet complete

/-- Search the stable visited pair queue for a replayable separating node.
This chooses the first accepting retained node; no global shortestness claim
is attached to that choice here. -/
def visitedStatePairWitnessNode? [DecidableEq X] [Fintype X]
    (M : DFA A X) [DecidablePred (fun state : X => state ∈ M.accept)]
    (alphabet : List A) (left right : X) :
    Option (ReachNode A (X × X)) :=
  (visitedStatePairQueue M alphabet left right).nodes.find?
    (fun node => decide
      (node.state ∈ (statePairDFA M left right).accept))

/-- A returned pair node carries a valid word and really separates the two
original observations. -/
theorem visitedStatePairWitnessNode?_sound [DecidableEq X] [Fintype X]
    (M : DFA A X) [DecidablePred (fun state : X => state ∈ M.accept)]
    (alphabet : List A) (left right : X) {node : ReachNode A (X × X)}
    (hnode : visitedStatePairWitnessNode? M alphabet left right = some node) :
    node.Valid (statePairDFA M left right) ∧
      behavior M.step (acceptsBool M) left node.word ≠
        behavior M.step (acceptsBool M) right node.word := by
  have hmem : node ∈ (visitedStatePairQueue M alphabet left right).nodes :=
    List.mem_of_find?_eq_some hnode
  have hvalid : node.Valid (statePairDFA M left right) := by
    apply runReachQueue_valid (statePairDFA M left right) alphabet
      (Fintype.card (X × X))
    simpa [visitedStatePairQueue, visitedReachQueue] using hmem
  have haccept : node.state ∈ (statePairDFA M left right).accept := by
    have hpredicate := List.find?_some hnode
    simpa [visitedStatePairWitnessNode?] using hpredicate
  have hword : node.word ∈ (statePairDFA M left right).accepts := by
    rw [DFA.mem_accepts, hvalid]
    exact haccept
  exact ⟨hvalid,
    (mem_statePairDFA_accepts_iff M left right node.word).1 hword⟩

/-- The stable visited product queue is an exact decision surface: it has no
accepting node exactly when the two native rows have equal complete futures.

The hard direction uses Mathlib loop deletion (`DFA.evalFrom_split`, through
`exists_short_eval_eq`) to replace an arbitrary separating word by one shorter
than `|X × X|`, after which the visited-queue completeness theorem installs
its endpoint in the final queue. -/
theorem visitedStatePairWitnessNode?_eq_none_iff_futureEq
    [DecidableEq X] [Fintype X]
    (M : DFA A X) [DecidablePred (fun state : X => state ∈ M.accept)]
    (alphabet : List A) (complete : ∀ action : A, action ∈ alphabet)
    (left right : X) :
    visitedStatePairWitnessNode? M alphabet left right = none ↔
      FutureEq M.step (acceptsBool M) left right := by
  unfold visitedStatePairWitnessNode?
  rw [List.find?_eq_none]
  constructor
  · intro hnone word
    by_contra hsep
    let P := statePairDFA M left right
    have hwordAccept : word ∈ P.accepts :=
      (mem_statePairDFA_accepts_iff M left right word).2 hsep
    obtain ⟨short, hshort, heval⟩ := exists_short_eval_eq P word
    have hcover := runReachQueue_covers_word P alphabet complete short
    simp only [ReachQueue.states, List.mem_map] at hcover
    obtain ⟨node, hnode, hstate⟩ := hcover
    have hnodeFinal : node ∈
        (visitedStatePairQueue M alphabet left right).nodes := by
      have hlater := advanceReachQueue_nodes_mono_le P alphabet
        (Nat.le_of_lt hshort) hnode
      simpa [visitedStatePairQueue, visitedReachQueue, P] using hlater
    have hendpoint : P.eval word ∈ P.accept :=
      (DFA.mem_accepts).1 hwordAccept
    have hstateAccept : node.state ∈ P.accept := by
      rw [hstate, heval]
      exact hendpoint
    have hfalse := hnone node hnodeFinal
    simpa [P, hstateAccept] using hfalse
  · intro hfuture node hnode
    have hvalid : node.Valid (statePairDFA M left right) := by
      apply runReachQueue_valid (statePairDFA M left right) alphabet
        (Fintype.card (X × X))
      simpa [visitedStatePairQueue, visitedReachQueue] using hnode
    have hnotAccept : node.state ∉ (statePairDFA M left right).accept := by
      intro haccept
      have hwordAccept : node.word ∈
          (statePairDFA M left right).accepts := by
        rw [DFA.mem_accepts, hvalid]
        exact haccept
      exact (mem_statePairDFA_accepts_iff M left right node.word).1
        hwordAccept (hfuture node.word)
    simp [hnotAccept]

/-- Formation's semantic closure criterion can now be read directly on the
stable executable pair queues. -/
theorem observableClosesAt_iff_visitedPairQueue_none
    [DecidableEq X] [Fintype X]
    (M : DFA A X) [DecidablePred (fun state : X => state ∈ M.accept)]
    (alphabet : List A) (complete : ∀ action : A, action ∈ alphabet)
    (fuel : Nat) :
    ObservableClosesAt M.step (acceptsBool M) fuel ↔
      ∀ left right : X,
        BoundedFutureEq M.step (acceptsBool M) fuel left right →
          visitedStatePairWitnessNode? M alphabet left right = none := by
  rw [observableClosesAt_iff_bounded_implies_future]
  constructor
  · intro hclose left right hbounded
    exact (visitedStatePairWitnessNode?_eq_none_iff_futureEq
      M alphabet complete left right).2 (hclose left right hbounded)
  · intro hqueue left right hbounded
    exact (visitedStatePairWitnessNode?_eq_none_iff_futureEq
      M alphabet complete left right).1 (hqueue left right hbounded)

namespace VisitedPairHorizonWitness

open ChartStateBFSWitness

example :
    (visitedStatePairWitnessNode? chart.toDFA alphabet left right).map
      ReachNode.word = some [true] := by
  native_decide

example :
    visitedStatePairWitnessNode? chart.toDFA alphabet left left = none := by
  native_decide

example :
    (visitedStatePairQueue chart.toDFA alphabet left right).frontier = [] :=
  visitedStatePairQueue_frontier_eq_nil chart.toDFA alphabet
    ReachableChartWitness.alphabet_complete left right

end VisitedPairHorizonWitness

end Pairfield
