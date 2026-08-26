/-
Copyright (c) 2026 Avik Jain and the mathematics collaboration.
Released under Apache 2.0 license.

The exact least uniform response horizon of a finite observed action system,
with pair-labelled globally shortest obstruction certificates below it.
-/
import Pairfield.ObservableVisitedPairAdapter

namespace Pairfield

universe u v

variable {A : Type u} {X : Type v}

/-- The formation delay of one ordered pair: zero when it is already
future-equivalent, otherwise the length of its globally shortest retained
separator. -/
def pairObservableHorizon [DecidableEq X] [Fintype X]
    (M : DFA A X) [DecidablePred (fun state : X => state ∈ M.accept)]
    (alphabet : List A) (left right : X) : Nat :=
  match visitedPairWitness? M alphabet left right with
  | none => 0
  | some node => node.word.length

/-- The whole-presentation uniform formation horizon.  The finite supremum
retains its pairwise sources through `pairObservableHorizon`. -/
def globalObservableHorizon [DecidableEq X] [Fintype X]
    (M : DFA A X) [DecidablePred (fun state : X => state ∈ M.accept)]
    (alphabet : List A) : Nat :=
  (Finset.univ : Finset (X × X)).sup fun pair =>
    pairObservableHorizon M alphabet pair.1 pair.2

theorem pairObservableHorizon_le_global
    [DecidableEq X] [Fintype X]
    (M : DFA A X) [DecidablePred (fun state : X => state ∈ M.accept)]
    (alphabet : List A) (left right : X) :
    pairObservableHorizon M alphabet left right ≤
      globalObservableHorizon M alphabet := by
  exact Finset.le_sup (s := (Finset.univ : Finset (X × X)))
    (f := fun pair => pairObservableHorizon M alphabet pair.1 pair.2)
    (Finset.mem_univ (left, right))

/-- The finite observable kernel closes at the computed global horizon. -/
theorem observableClosesAt_globalObservableHorizon
    [DecidableEq X] [Fintype X]
    (M : DFA A X) [DecidablePred (fun state : X => state ∈ M.accept)]
    (alphabet : List A) (complete : ∀ action : A, action ∈ alphabet) :
    ObservableClosesAt M.step (acceptsBool M)
      (globalObservableHorizon M alphabet) := by
  apply (observableClosesAt_iff_visitedPairWitness_none
    M alphabet complete (globalObservableHorizon M alphabet)).2
  intro left right hbounded
  cases hresult : visitedPairWitness? M alphabet left right with
  | none => rfl
  | some node =>
      exfalso
      have hlength : node.word.length ≤
          globalObservableHorizon M alphabet := by
        simpa [pairObservableHorizon, hresult] using
          pairObservableHorizon_le_global M alphabet left right
      have hsep :=
        (visitedPairWitness?_sound M alphabet left right hresult).2
      exact hsep (hbounded node.word hlength)

/-- Every smaller depth carries an attaining ordered pair and a replayable
globally shortest separator.  The pair is still bounded-equal at the smaller
depth, so this is an exact formation obstruction rather than a bare maximum. -/
theorem exists_pair_witness_of_lt_globalObservableHorizon
    [DecidableEq X] [Fintype X]
    (M : DFA A X) [DecidablePred (fun state : X => state ∈ M.accept)]
    (alphabet : List A) (complete : ∀ action : A, action ∈ alphabet)
    {fuel : Nat} (hfuel : fuel < globalObservableHorizon M alphabet) :
    ∃ left right : X, ∃ node : ReachNode A (X × X),
      visitedPairWitness? M alphabet left right = some node ∧
        node.word.length = globalObservableHorizon M alphabet ∧
          BoundedFutureEq M.step (acceptsBool M) fuel left right ∧
            behavior M.step (acceptsBool M) left node.word ≠
              behavior M.step (acceptsBool M) right node.word := by
  have huniv : (Finset.univ : Finset (X × X)).Nonempty :=
    ⟨(M.start, M.start), Finset.mem_univ _⟩
  obtain ⟨pair, _, hpair⟩ := Finset.exists_mem_eq_sup
    (Finset.univ : Finset (X × X)) huniv
    (fun candidate =>
      pairObservableHorizon M alphabet candidate.1 candidate.2)
  rcases pair with ⟨left, right⟩
  have hpair' : globalObservableHorizon M alphabet =
      pairObservableHorizon M alphabet left right := by
    simpa [globalObservableHorizon] using hpair
  cases hresult : visitedPairWitness? M alphabet left right with
  | none =>
      have hzero : globalObservableHorizon M alphabet = 0 := by
        simpa [pairObservableHorizon, hresult] using hpair'
      omega
  | some node =>
      have hlength : node.word.length =
          globalObservableHorizon M alphabet := by
        have : globalObservableHorizon M alphabet = node.word.length := by
          simpa [pairObservableHorizon, hresult] using hpair'
        exact this.symm
      have hshortest := visitedPairWitness?_globally_shortest
        M alphabet complete left right hresult
      have hbounded :
          BoundedFutureEq M.step (acceptsBool M) fuel left right := by
        intro candidate hcandidateLength
        by_contra hcandidateSep
        have hminimal := hshortest.2.2 candidate hcandidateSep
        rw [hlength] at hminimal
        omega
      exact ⟨left, right, node, hresult, hlength, hbounded,
        hshortest.2.1⟩

theorem not_observableClosesAt_of_lt_globalObservableHorizon
    [DecidableEq X] [Fintype X]
    (M : DFA A X) [DecidablePred (fun state : X => state ∈ M.accept)]
    (alphabet : List A) (complete : ∀ action : A, action ∈ alphabet)
    {fuel : Nat} (hfuel : fuel < globalObservableHorizon M alphabet) :
    ¬ ObservableClosesAt M.step (acceptsBool M) fuel := by
  obtain ⟨left, right, node, _, _, hbounded, hsep⟩ :=
    exists_pair_witness_of_lt_globalObservableHorizon
      M alphabet complete hfuel
  exact bounded_collision_obstructs_closure M.step (acceptsBool M)
    hbounded node.word hsep

/-- The computed number is the least closing horizon, not merely a safe one. -/
theorem globalObservableHorizon_isLeast
    [DecidableEq X] [Fintype X]
    (M : DFA A X) [DecidablePred (fun state : X => state ∈ M.accept)]
    (alphabet : List A) (complete : ∀ action : A, action ∈ alphabet) :
    IsLeast { fuel : Nat |
      ObservableClosesAt M.step (acceptsBool M) fuel }
      (globalObservableHorizon M alphabet) := by
  refine ⟨observableClosesAt_globalObservableHorizon M alphabet complete, ?_⟩
  intro fuel hcloses
  by_contra hnot
  have hlt : fuel < globalObservableHorizon M alphabet :=
    Nat.lt_of_not_ge hnot
  exact (not_observableClosesAt_of_lt_globalObservableHorizon
    M alphabet complete hlt) hcloses

namespace GlobalObservableHorizonWitness

open BehavioralBFSWitness VisitedPairHorizonWitness

example : globalObservableHorizon automaton alphabet = 1 := by
  decide

example : IsLeast { fuel : Nat |
    ObservableClosesAt automaton.step (acceptsBool automaton) fuel }
    1 := by
  have hvalue : globalObservableHorizon automaton alphabet = 1 := by
    decide
  rw [← hvalue]
  exact globalObservableHorizon_isLeast
    automaton alphabet alphabet_complete

end GlobalObservableHorizonWitness

end Pairfield
