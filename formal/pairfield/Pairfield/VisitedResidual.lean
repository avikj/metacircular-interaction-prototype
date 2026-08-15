/-
Copyright (c) 2026 Avik Jain and the mathematics collaboration.
Released under Apache 2.0 license.

The visited synchronous-pair traversal stated directly on Mathlib prefix left
quotients.  This is a checked transition map, not another search procedure.
-/
import Pairfield.VisitedPair

namespace Pairfield

universe u v

variable {A : Type u} {X : Type v}

theorem behavior_eval_eq_iff_leftQuotient_membership
    (M : DFA A X) [DecidablePred (fun state : X => state ∈ M.accept)]
    (left right word : List A) :
    behavior M.step (acceptsBool M) (M.eval left) word =
        behavior M.step (acceptsBool M) (M.eval right) word ↔
      (word ∈ M.accepts.leftQuotient left ↔
        word ∈ M.accepts.leftQuotient right) := by
  rw [behavior_acceptsBool_eval_eq_decide_accept M left word,
    behavior_acceptsBool_eval_eq_decide_accept M right word,
    mem_leftQuotient_iff_accept_evalFrom_eval,
    mem_leftQuotient_iff_accept_evalFrom_eval]
  by_cases hleft : M.evalFrom (M.eval left) word ∈ M.accept <;>
    by_cases hright : M.evalFrom (M.eval right) word ∈ M.accept <;>
    simp [hleft, hright]

theorem behavior_eval_ne_iff_leftQuotient_separates
    (M : DFA A X) [DecidablePred (fun state : X => state ∈ M.accept)]
    (left right word : List A) :
    behavior M.step (acceptsBool M) (M.eval left) word ≠
        behavior M.step (acceptsBool M) (M.eval right) word ↔
      ¬ (word ∈ M.accepts.leftQuotient left ↔
        word ∈ M.accepts.leftQuotient right) := by
  rw [ne_eq, behavior_eval_eq_iff_leftQuotient_membership]

/-- The native visited query for two Mathlib prefix residuals. -/
def visitedLeftQuotientWitness? [DecidableEq X] [Fintype X]
    (M : DFA A X) [DecidablePred (fun state : X => state ∈ M.accept)]
    (alphabet : List A) (left right : List A) :
    Option (ReachNode A (X × X)) :=
  visitedPairWitness? M alphabet (M.eval left) (M.eval right)

/-- `none` is exact equality of the two Mathlib left quotients. -/
theorem visitedLeftQuotientWitness?_eq_none_iff
    [DecidableEq X] [Fintype X]
    (M : DFA A X) [DecidablePred (fun state : X => state ∈ M.accept)]
    (alphabet : List A) (complete : ∀ action : A, action ∈ alphabet)
    (left right : List A) :
    visitedLeftQuotientWitness? M alphabet left right = none ↔
      M.accepts.leftQuotient left = M.accepts.leftQuotient right := by
  rw [visitedLeftQuotientWitness?,
    visitedPairWitness?_eq_none_iff M alphabet complete]
  constructor
  · intro hfuture
    apply Set.ext
    intro word
    exact (behavior_eval_eq_iff_leftQuotient_membership
      M left right word).1 (hfuture word)
  · intro heq word
    apply (behavior_eval_eq_iff_leftQuotient_membership
      M left right word).2
    rw [heq]

/-- A returned node is valid in the synchronous residual monitor, separates
the Mathlib left quotients, and has globally minimum suffix length. -/
theorem visitedLeftQuotientWitness?_globally_shortest
    [DecidableEq X] [Fintype X]
    (M : DFA A X) [DecidablePred (fun state : X => state ∈ M.accept)]
    (alphabet : List A) (complete : ∀ action : A, action ∈ alphabet)
    (left right : List A) {node : ReachNode A (X × X)}
    (hnode : visitedLeftQuotientWitness? M alphabet left right = some node) :
    node.Valid (statePairDFA M (M.eval left) (M.eval right)) ∧
      ¬ (node.word ∈ M.accepts.leftQuotient left ↔
        node.word ∈ M.accepts.leftQuotient right) ∧
      ∀ candidate : List A,
        ¬ (candidate ∈ M.accepts.leftQuotient left ↔
          candidate ∈ M.accepts.leftQuotient right) →
        node.word.length ≤ candidate.length := by
  have hpair := visitedPairWitness?_globally_shortest M alphabet complete
    (M.eval left) (M.eval right) hnode
  refine ⟨hpair.1,
    (behavior_eval_ne_iff_leftQuotient_separates
      M left right node.word).1 hpair.2.1, ?_⟩
  intro candidate hcandidate
  apply hpair.2.2 candidate
  exact (behavior_eval_ne_iff_leftQuotient_separates
    M left right candidate).2 hcandidate

/-- The visited and prior exhaustive residual queries agree exactly on their
minimum length, though alphabet order may choose different ties. -/
theorem visitedLeftQuotientWitness?_length_eq_shortestLeftQuotientWitness
    [DecidableEq A] [DecidableEq X] [Fintype X]
    (M : DFA A X) [DecidablePred (fun state : X => state ∈ M.accept)]
    (alphabet : List A) (complete : ∀ action : A, action ∈ alphabet)
    (left right : List A) {node : ReachNode A (X × X)} {word : List A}
    (hvisited : visitedLeftQuotientWitness? M alphabet left right = some node)
    (hexhaustive :
      shortestLeftQuotientWitness M alphabet left right = some word) :
    node.word.length = word.length := by
  have hvisitedSound := visitedLeftQuotientWitness?_globally_shortest
    M alphabet complete left right hvisited
  have hexhaustiveSound := shortestLeftQuotientWitness_sound
    M alphabet complete left right hexhaustive
  apply Nat.le_antisymm
  · exact hvisitedSound.2.2 word hexhaustiveSound
  · exact shortestLeftQuotientWitness_minimal M alphabet complete
      left right hexhaustive node.word hvisitedSound.2.1

/-- Every suffix separating the two Mathlib left quotients remains visible. -/
def ResidualSeparatorFiber
    (M : DFA A X) (left right : List A) :=
  { word : List A //
      ¬ (word ∈ M.accepts.leftQuotient left ↔
        word ∈ M.accepts.leftQuotient right) }

theorem visitedLeftQuotientWitness?_exists_iff_separatorFiber
    [DecidableEq X] [Fintype X]
    (M : DFA A X) [DecidablePred (fun state : X => state ∈ M.accept)]
    (alphabet : List A) (complete : ∀ action : A, action ∈ alphabet)
    (left right : List A) :
    (∃ node, visitedLeftQuotientWitness? M alphabet left right = some node) ↔
      Nonempty (ResidualSeparatorFiber M left right) := by
  constructor
  · rintro ⟨node, hnode⟩
    exact ⟨⟨node.word,
      (visitedLeftQuotientWitness?_globally_shortest
        M alphabet complete left right hnode).2.1⟩⟩
  · rintro ⟨⟨word, hword⟩⟩
    cases hresult : visitedLeftQuotientWitness? M alphabet left right with
    | none =>
        exact False.elim (hword (Set.ext_iff.mp
          ((visitedLeftQuotientWitness?_eq_none_iff
            M alphabet complete left right).1 hresult) word))
    | some node => exact ⟨node, rfl⟩

namespace VisitedResidualWitness

open ResidualBFSWitness

example :
    (visitedLeftQuotientWitness? automaton alphabet [] [false]).map
      ReachNode.word = some [true] := by
  decide

example : visitedLeftQuotientWitness? automaton alphabet [] [true] = none := by
  decide

end VisitedResidualWitness

end Pairfield
