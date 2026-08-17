/-
Copyright (c) 2026 Avik Jain and the mathematics collaboration.
Released under Apache 2.0 license.

Aggregate the implementation costs left open by the native complete witness
language, and expose the exact prefix/suffix boundary for any future shared
pair-search implementation.
-/
import Pairfield.NativeCompleteWitnesses

namespace Pairfield

universe u v

variable {A : Type u} {X : Type v}

namespace NativeCompleteWitnesses

variable [LinearOrder X] [Fintype X]
variable [DecidableEq A]

variable (M : DFA A X)
variable [DecidablePred (fun state : X => state ∈ M.accept)]

/-- Sum the pair states actually retained by every independently scheduled
strict-pair query.  This is an executable baseline, not a shared traversal. -/
def aggregateVisitedPairExpansions (alphabet : List A) : Nat :=
  ∑ pair ∈ strictPairs (X := X),
    reachableStatePairCount M alphabet pair.1 pair.2

/-- The exact strict-pair schedule and the per-query product-state ceiling give
an aggregate independent-search ceiling.  No prefix sharing is credited. -/
theorem aggregateVisitedPairExpansions_le
    (alphabet : List A) :
    aggregateVisitedPairExpansions M alphabet ≤
      Nat.choose (Fintype.card X) 2 *
        (Fintype.card X * Fintype.card X) := by
  calc
    aggregateVisitedPairExpansions M alphabet =
        ∑ pair ∈ strictPairs (X := X),
          reachableStatePairCount M alphabet pair.1 pair.2 := rfl
    _ ≤ ∑ _pair ∈ strictPairs (X := X),
          (Fintype.card X * Fintype.card X) := by
      apply Finset.sum_le_sum
      intro pair _
      exact reachableStatePairCount_le_card_sq
        M alphabet pair.1 pair.2
    _ = (strictPairs (X := X)).card *
          (Fintype.card X * Fintype.card X) := by simp
    _ = Nat.choose (Fintype.card X) 2 *
          (Fintype.card X * Fintype.card X) := by
      rw [card_strictPairs]

/-- Every retained native control word is strictly shorter than the ambient
state-pair cardinality.  This combines the native shortest query with the
existing finite pair-monitor horizon. -/
theorem completeWord_length_lt_card_sq
    (alphabet : List A) (complete : ∀ action : A, action ∈ alphabet)
    (reduced : BehaviorallyReduced M) {word : List A}
    (hword : word ∈ completeWords M alphabet) :
    word.length < Fintype.card X * Fintype.card X := by
  obtain ⟨pair, hpair, rfl⟩ := Finset.mem_image.mp hword
  have hlt : pair.1 < pair.2 := by
    simpa [strictPairs] using hpair
  have hshortest := witnessWord_globally_shortest_of_lt
    M alphabet complete reduced hlt
  obtain ⟨node, _, _, hnodeLength, hnodeSeparates⟩ :=
    exists_visited_pair_separator M alphabet complete pair.1 pair.2
      hshortest.1
  exact Nat.lt_of_le_of_lt
    (hshortest.2 node.word hnodeSeparates) hnodeLength

/-- Total length of the deduplicated installed control language. -/
def totalCompleteWordLength (alphabet : List A) : Nat :=
  ∑ word ∈ completeWords M alphabet, word.length

/-- The deduplicated language's total retained length obeys the same
quadratic-schedule times product-state ceiling.  This is a storage ceiling,
not an adaptive decision-tree height. -/
theorem totalCompleteWordLength_le
    (alphabet : List A) (complete : ∀ action : A, action ∈ alphabet)
    (reduced : BehaviorallyReduced M) :
    totalCompleteWordLength M alphabet ≤
      Nat.choose (Fintype.card X) 2 *
        (Fintype.card X * Fintype.card X) := by
  calc
    totalCompleteWordLength M alphabet =
        ∑ word ∈ completeWords M alphabet, word.length := rfl
    _ ≤ ∑ _word ∈ completeWords M alphabet,
          (Fintype.card X * Fintype.card X) := by
      apply Finset.sum_le_sum
      intro word hword
      exact Nat.le_of_lt
        (completeWord_length_lt_card_sq
          M alphabet complete reduced hword)
    _ = (completeWords M alphabet).card *
          (Fintype.card X * Fintype.card X) := by simp
    _ ≤ Nat.choose (Fintype.card X) 2 *
          (Fintype.card X * Fintype.card X) := by
      exact Nat.mul_le_mul_right _
        (card_completeWords_le_choose_two M alphabet)

/-- Mathlib's exact `DFA.evalFrom_of_append` theorem, exposed at the native
Moore-observation interface.  A suffix may be reused at a reached state only
after its replay prefix has been restored. -/
theorem behavior_append_eq_behavior_reached
    {O : Type*} (observe : X → O) (left : X)
    (replayPrefix suffix : List A) :
    behavior M.step observe left (replayPrefix ++ suffix) =
      behavior M.step observe (M.evalFrom left replayPrefix) suffix := by
  simp [behavior, run_eq_evalFrom, DFA.evalFrom_of_append]

/-- Prefix/suffix splicing preserves and reflects pair separation exactly. -/
theorem append_suffix_separates_iff_reached
    {O : Type*} (observe : X → O) (left right : X)
    (replayPrefix suffix : List A) :
    behavior M.step observe left (replayPrefix ++ suffix) ≠
        behavior M.step observe right (replayPrefix ++ suffix) ↔
      behavior M.step observe (M.evalFrom left replayPrefix) suffix ≠
        behavior M.step observe (M.evalFrom right replayPrefix) suffix := by
  rw [behavior_append_eq_behavior_reached M observe left replayPrefix suffix,
    behavior_append_eq_behavior_reached M observe right replayPrefix suffix]

end NativeCompleteWitnesses

/- Hostile finite control for erasing replay roots.  Two different root pairs
reach the same current pair under different one-letter prefixes. -/
namespace PrefixErasureWitness

def step (state : Fin 6) (action : Bool) : Fin 6 :=
  match state.val, action with
  | 0, false => 4
  | 1, false => 5
  | 2, true => 4
  | 3, true => 5
  | _, _ => state

def observe (state : Fin 6) : Bool := decide (state = 4)

def automaton : DFA Bool (Fin 6) where
  step := step
  start := 0
  accept := { state | observe state = true }

instance : DecidablePred (fun state : Fin 6 => state ∈ automaton.accept) :=
  fun state => inferInstanceAs (Decidable (observe state = true))

/-- Merging the two searches at their common current pair preserves the empty
separating suffix, but erasing the different prefixes makes that suffix fail
on both root pairs.  The spliced words remain valid replay certificates. -/
theorem shared_suffix_is_not_root_free :
    (automaton.evalFrom 0 [false], automaton.evalFrom 1 [false]) =
        (automaton.evalFrom 2 [true], automaton.evalFrom 3 [true]) ∧
      behavior automaton.step observe 4 [] ≠
        behavior automaton.step observe 5 [] ∧
      behavior automaton.step observe 0 [] =
        behavior automaton.step observe 1 [] ∧
      behavior automaton.step observe 2 [] =
        behavior automaton.step observe 3 [] ∧
      behavior automaton.step observe 0 ([false] ++ []) ≠
        behavior automaton.step observe 1 ([false] ++ []) ∧
      behavior automaton.step observe 2 ([true] ++ []) ≠
        behavior automaton.step observe 3 ([true] ++ []) := by
  decide

end PrefixErasureWitness

end Pairfield
