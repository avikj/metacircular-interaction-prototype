/-
Copyright (c) 2026 Avik Jain and the mathematics collaboration.
Released under Apache 2.0 license.

The semantic observable-closure theorem compiled through the visited
synchronous-pair traversal.  Mathlib loop deletion (`DFA.evalFrom_split`) and
`Fintype.card_prod` enter through `VisitedPairHorizon`; the automata return in
`VisitedPair` additionally proves global shortestness and preserves the full
distinguishing derivation fibre.
-/
import Pairfield.ObservableHorizon
import Pairfield.VisitedPair

namespace Pairfield

universe u v

variable {A : Type u} {X : Type v}

/-- A bounded observation window is action-stable exactly when every pair it
currently identifies has an exhausted visited pair queue with no accepting
node.  Thus formation's semantic kernel criterion and the executable queue
criterion are the same proposition. -/
theorem observableClosesAt_iff_visitedPairWitness_none
    [DecidableEq X] [Fintype X]
    (M : DFA A X) [DecidablePred (fun state : X => state ∈ M.accept)]
    (alphabet : List A) (complete : ∀ action : A, action ∈ alphabet)
    (fuel : Nat) :
    ObservableClosesAt M.step (acceptsBool M) fuel ↔
      ∀ left right : X,
        BoundedFutureEq M.step (acceptsBool M) fuel left right →
          visitedPairWitness? M alphabet left right = none := by
  rw [observableClosesAt_iff_bounded_implies_future]
  constructor
  · intro hclose left right hbounded
    exact (visitedPairWitness?_eq_none_iff
      M alphabet complete left right).2 (hclose left right hbounded)
  · intro hqueue left right hbounded
    exact (visitedPairWitness?_eq_none_iff
      M alphabet complete left right).1 (hqueue left right hbounded)

/-- At the safe quadratic horizon, every bounded collision has already been
resolved by the stable executable pair queue.  This is a semantic horizon
statement plus an implementation certificate; the reachable pair count can
be strictly smaller than the ambient square. -/
theorem bounded_card_sq_implies_visitedPairWitness_none
    [DecidableEq X] [Fintype X]
    (M : DFA A X) [DecidablePred (fun state : X => state ∈ M.accept)]
    (alphabet : List A) (complete : ∀ action : A, action ∈ alphabet)
    (left right : X)
    (hbounded : BoundedFutureEq M.step (acceptsBool M)
      (Fintype.card X * Fintype.card X) left right) :
    visitedPairWitness? M alphabet left right = none := by
  exact (observableClosesAt_iff_visitedPairWitness_none
    M alphabet complete (Fintype.card X * Fintype.card X)).1
      (finiteDFA_observableClosesAt_card_sq M) left right hbounded

namespace ObservableVisitedPairAdapterWitness

open BehavioralBFSWitness VisitedPairHorizonWitness

/-- The known control closes at depth one, and the adapter presents that fact
as absence of a visited separator for every pair still equal at depth one. -/
example :
    ∀ left right : Fin 3,
      BoundedFutureEq automaton.step (acceptsBool automaton) 1 left right →
        visitedPairWitness? automaton alphabet left right = none :=
  (observableClosesAt_iff_visitedPairWitness_none
    automaton alphabet alphabet_complete 1).1 (by
      have hobserve : acceptsBool automaton = observe := by
        funext state
        fin_cases state <;> rfl
      rw [hobserve]
      exact ObservableHorizonWitness.closesAt_one)

end ObservableVisitedPairAdapterWitness

end Pairfield
