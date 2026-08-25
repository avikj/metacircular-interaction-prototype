/-
Copyright (c) 2026 Avik Jain and the mathematics collaboration.
Released under Apache 2.0 license.

Mathlib's finite-cardinality bound for duplicate-free lists, transported to
the native proof-relevant visited-state traversal.
-/
import Pairfield.VisitedReach

namespace Pairfield

universe u v

variable {A : Type u} {X : Type v}

/-- Mathlib's `List.Nodup.length_le_card` becomes the executable expansion
budget: at every round the native traversal retains at most `|X|` discovered
rows.  This bounds discoveries, not rounds or candidate-edge generation. -/
theorem runReachQueue_state_count_le [DecidableEq X] [Fintype X]
    (M : DFA A X) (alphabet : List A) (round : Nat) :
    (runReachQueue M alphabet round).states.length ≤ Fintype.card X := by
  exact (runReachQueue_states_nodup M alphabet round).length_le_card

namespace VisitedReachCardinalityWitness

open ChartQuotientWitness

example : (runReachQueue automaton alphabet 3).states.Nodup :=
  runReachQueue_states_nodup automaton alphabet 3

example : (runReachQueue automaton alphabet 3).states.length ≤ 4 := by
  simpa using runReachQueue_state_count_le automaton alphabet 3

end VisitedReachCardinalityWitness

end Pairfield
