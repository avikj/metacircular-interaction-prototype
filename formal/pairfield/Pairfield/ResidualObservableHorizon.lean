/-
Copyright (c) 2026 Avik Jain and the mathematics collaboration.
Released under Apache 2.0 license.

The exact checked transition from a native global observable horizon to
Mathlib prefix left quotients.  The semantic bridge is Mathlib's
`Language.leftQuotient_accepts_apply`; the executable witnesses remain those
of `GlobalObservableHorizon` and the stable visited pair queue.
-/
import Pairfield.GlobalObservableHorizon
import Pairfield.VisitedResidual

namespace Pairfield

universe u v

variable {A : Type u} {X : Type v}

/-- Two Mathlib prefix residuals agree on every suffix of length at most
`fuel`. -/
def BoundedLeftQuotientEq (M : DFA A X) (fuel : Nat)
    (left right : List A) : Prop :=
  ∀ word : List A, word.length ≤ fuel →
    (word ∈ M.accepts.leftQuotient left ↔
      word ∈ M.accepts.leftQuotient right)

/-- Every bounded collision between prefix residuals has already stabilized
to extensional equality. -/
def LeftQuotientsStabilizeAt (M : DFA A X) (fuel : Nat) : Prop :=
  ∀ left right : List A,
    BoundedLeftQuotientEq M fuel left right →
      M.accepts.leftQuotient left = M.accepts.leftQuotient right

/-- Bounded equality of Mathlib prefix left quotients is literally bounded
future equality of the reached native states.  The underlying unbounded
identity is `Language.leftQuotient_accepts_apply`. -/
theorem boundedLeftQuotientEq_iff_boundedFutureEq_eval
    (M : DFA A X) [DecidablePred (fun state : X => state ∈ M.accept)]
    (fuel : Nat) (left right : List A) :
    BoundedLeftQuotientEq M fuel left right ↔
      BoundedFutureEq M.step (acceptsBool M) fuel
        (M.eval left) (M.eval right) := by
  constructor
  · intro h word hlength
    exact (behavior_eval_eq_iff_leftQuotient_membership
      M left right word).2 (h word hlength)
  · intro h word hlength
    exact (behavior_eval_eq_iff_leftQuotient_membership
      M left right word).1 (h word hlength)

/-- If every native row is reached by a prefix, observable closure at a fuel
is exactly stabilization of Mathlib's prefix residuals at that fuel.  The
reachability premise is essential: unreachable deep rows may enlarge the
whole-state horizon without changing `M.accepts`. -/
theorem observableClosesAt_iff_leftQuotientsStabilizeAt_of_reachable
    (M : DFA A X) [DecidablePred (fun state : X => state ∈ M.accept)]
    (reachable : ∀ state : X, ∃ word : List A, M.eval word = state)
    (fuel : Nat) :
    ObservableClosesAt M.step (acceptsBool M) fuel ↔
      LeftQuotientsStabilizeAt M fuel := by
  constructor
  · intro hclose left right hbounded
    have hfuture : FutureEq M.step (acceptsBool M)
        (M.eval left) (M.eval right) :=
      (observableClosesAt_iff_bounded_implies_future
        M.step (acceptsBool M) fuel).1 hclose
        (M.eval left) (M.eval right)
        ((boundedLeftQuotientEq_iff_boundedFutureEq_eval
          M fuel left right).1 hbounded)
    apply Set.ext
    intro word
    exact (behavior_eval_eq_iff_leftQuotient_membership
      M left right word).1 (hfuture word)
  · intro hresidual
    apply (observableClosesAt_iff_bounded_implies_future
      M.step (acceptsBool M) fuel).2
    intro left right hbounded word
    obtain ⟨leftPrefix, hleft⟩ := reachable left
    obtain ⟨rightPrefix, hright⟩ := reachable right
    have hprefixBounded :
        BoundedLeftQuotientEq M fuel leftPrefix rightPrefix := by
      apply (boundedLeftQuotientEq_iff_boundedFutureEq_eval
        M fuel leftPrefix rightPrefix).2
      simpa [hleft, hright] using hbounded
    have heq := hresidual leftPrefix rightPrefix hprefixBounded
    have hprefixFuture : FutureEq M.step (acceptsBool M)
        (M.eval leftPrefix) (M.eval rightPrefix) := by
      intro candidate
      apply (behavior_eval_eq_iff_leftQuotient_membership
        M leftPrefix rightPrefix candidate).2
      exact Set.ext_iff.mp heq candidate
    simpa [hleft, hright] using hprefixFuture word

/-- Stabilization of prefix residuals is executable by the already checked
visited query; no second search is introduced by this adapter. -/
theorem leftQuotientsStabilizeAt_iff_visitedLeftQuotientWitness_none
    [DecidableEq X] [Fintype X]
    (M : DFA A X) [DecidablePred (fun state : X => state ∈ M.accept)]
    (alphabet : List A) (complete : ∀ action : A, action ∈ alphabet)
    (fuel : Nat) :
    LeftQuotientsStabilizeAt M fuel ↔
      ∀ left right : List A,
        BoundedLeftQuotientEq M fuel left right →
          visitedLeftQuotientWitness? M alphabet left right = none := by
  constructor
  · intro hstable left right hbounded
    exact (visitedLeftQuotientWitness?_eq_none_iff
      M alphabet complete left right).2
        (hstable left right hbounded)
  · intro hquery left right hbounded
    exact (visitedLeftQuotientWitness?_eq_none_iff
      M alphabet complete left right).1
        (hquery left right hbounded)

/-- On an all-state-reachable presentation, formation's native number is also
the least depth at which every Mathlib prefix residual has stabilized. -/
theorem globalObservableHorizon_isLeast_leftQuotientsStabilizeAt
    [DecidableEq X] [Fintype X]
    (M : DFA A X) [DecidablePred (fun state : X => state ∈ M.accept)]
    (alphabet : List A) (complete : ∀ action : A, action ∈ alphabet)
    (reachable : ∀ state : X, ∃ word : List A, M.eval word = state) :
    IsLeast { fuel : Nat | LeftQuotientsStabilizeAt M fuel }
      (globalObservableHorizon M alphabet) := by
  have hbridge :=
    observableClosesAt_iff_leftQuotientsStabilizeAt_of_reachable M reachable
  have hleast := globalObservableHorizon_isLeast M alphabet complete
  refine ⟨(hbridge _).1 hleast.1, ?_⟩
  intro fuel hstable
  exact hleast.2 ((hbridge fuel).2 hstable)

/-- Every earlier failed global horizon transports to two reaching prefixes
and the same retained globally shortest node.  Hence the reciprocal result is
pair-labelled in Mathlib's residual presentation rather than merely numeric. -/
theorem exists_prefix_residual_witness_of_lt_globalObservableHorizon
    [DecidableEq X] [Fintype X]
    (M : DFA A X) [DecidablePred (fun state : X => state ∈ M.accept)]
    (alphabet : List A) (complete : ∀ action : A, action ∈ alphabet)
    (reachable : ∀ state : X, ∃ word : List A, M.eval word = state)
    {fuel : Nat} (hfuel : fuel < globalObservableHorizon M alphabet) :
    ∃ leftPrefix rightPrefix : List A,
      ∃ node : ReachNode A (X × X),
        visitedLeftQuotientWitness? M alphabet leftPrefix rightPrefix =
            some node ∧
          node.word.length = globalObservableHorizon M alphabet ∧
            BoundedLeftQuotientEq M fuel leftPrefix rightPrefix ∧
              ¬ (node.word ∈ M.accepts.leftQuotient leftPrefix ↔
                node.word ∈ M.accepts.leftQuotient rightPrefix) := by
  obtain ⟨left, right, node, hnode, hlength, hbounded, hsep⟩ :=
    exists_pair_witness_of_lt_globalObservableHorizon
      M alphabet complete hfuel
  obtain ⟨leftPrefix, hleft⟩ := reachable left
  obtain ⟨rightPrefix, hright⟩ := reachable right
  refine ⟨leftPrefix, rightPrefix, node, ?_, hlength, ?_, ?_⟩
  · simpa [visitedLeftQuotientWitness?, hleft, hright] using hnode
  · apply (boundedLeftQuotientEq_iff_boundedFutureEq_eval
      M fuel leftPrefix rightPrefix).2
    simpa [hleft, hright] using hbounded
  · apply (behavior_eval_ne_iff_leftQuotient_separates
      M leftPrefix rightPrefix node.word).1
    simpa [hleft, hright] using hsep

namespace ResidualObservableHorizonWitness

open ReachableChartWitness

/-- The earlier pair witness deliberately contains unreachable rows: from its
start state, every word stays at zero. -/
theorem unreachableAutomaton_eval_eq_zero (word : List Bool) :
    VisitedPairHorizonWitness.automaton.eval word = 0 := by
  change VisitedPairHorizonWitness.automaton.evalFrom 0 word = 0
  induction word with
  | nil => rfl
  | cons action tail ih =>
      rw [DFA.evalFrom_cons]
      simpa [VisitedPairHorizonWitness.automaton,
        BehavioralBFSWitness.step] using ih

theorem unreachableAutomaton_not_mem_accepts (word : List Bool) :
    word ∉ VisitedPairHorizonWitness.automaton.accepts := by
  rw [DFA.mem_accepts, unreachableAutomaton_eval_eq_zero]
  decide

/-- Without all-state reachability, the whole-state horizon can strictly
exceed the horizon of Mathlib's reachable prefix residuals. -/
theorem reachability_is_essential :
    LeftQuotientsStabilizeAt VisitedPairHorizonWitness.automaton 0 ∧
      globalObservableHorizon VisitedPairHorizonWitness.automaton
        BehavioralBFSWitness.alphabet = 1 := by
  constructor
  · intro left right _
    apply Set.ext
    intro word
    constructor
    · intro hleft
      exact False.elim
        (unreachableAutomaton_not_mem_accepts (left ++ word) hleft)
    · intro hright
      exact False.elim
        (unreachableAutomaton_not_mem_accepts (right ++ word) hright)
  · decide

def automaton : DFA Bool (Fin 3) where
  step := chartStep
  start := 0
  accept := { state | state = 2 }

instance : DecidablePred (fun state : Fin 3 ↦ state ∈ automaton.accept) :=
  fun state ↦ inferInstanceAs (Decidable (state = 2))

theorem automaton_reachable (state : Fin 3) :
    ∃ word : List Bool, automaton.eval word = state := by
  fin_cases state
  · exact ⟨[], rfl⟩
  · exact ⟨[false], by decide⟩
  · exact ⟨[false, true], by decide⟩

example : IsLeast { fuel : Nat |
    LeftQuotientsStabilizeAt automaton fuel } 1 := by
  have hvalue : globalObservableHorizon automaton alphabet = 1 := by
    decide
  rw [← hvalue]
  exact globalObservableHorizon_isLeast_leftQuotientsStabilizeAt
    automaton alphabet alphabet_complete automaton_reachable

end ResidualObservableHorizonWitness

end Pairfield
