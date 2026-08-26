/-
Copyright (c) 2026 Avik Jain and the mathematics collaboration.
Released under Apache 2.0 license.

The exact certificate carrier required by a future shared reverse pair search:
one rank and one outgoing action backpointer at each current product state.
The policy reconstructs suffixes; root replay remains an explicit append
adapter and is not identified with the shared product state.
-/
import Pairfield.NativeCompleteWitnessCost

namespace Pairfield

universe u v

variable {A : Type u} {X : Type v}

namespace NativeReverseSeparatorPolicy

/-- Synchronous transition of a current state pair. -/
def pairStep (M : DFA A X) (pair : X × X) (action : A) : X × X :=
  (M.step pair.1 action, M.step pair.2 action)

/-- A supplied reverse separator policy.  At each unequal current pair it
either stops at an already separating Moore response or chooses one action
which preserves inequality and strictly decreases a natural rank.  This is the
backpointer table a reverse multi-source search must produce; no constructor is
assumed here. -/
structure Policy (M : DFA A X)
    [DecidablePred (fun state : X => state ∈ M.accept)] where
  rank : X × X → Nat
  action? : X × X → Option A
  terminal_separates : ∀ pair : X × X, pair.1 ≠ pair.2 →
    action? pair = none →
      behavior M.step (acceptsBool M) pair.1 [] ≠
        behavior M.step (acceptsBool M) pair.2 []
  step_preserves_ne : ∀ pair : X × X, pair.1 ≠ pair.2 →
    ∀ action : A, action? pair = some action →
      (pairStep M pair action).1 ≠ (pairStep M pair action).2
  rank_decreases : ∀ pair : X × X, pair.1 ≠ pair.2 →
    ∀ action : A, action? pair = some action →
      rank (pairStep M pair action) < rank pair

variable (M : DFA A X)
variable [DecidablePred (fun state : X => state ∈ M.accept)]

/-- Follow shared product-state backpointers for at most `fuel` actions.  The
rank theorem below supplies sufficient fuel natively as `rank pair + 1`. -/
def Policy.suffixFuel (policy : Policy M) : Nat → X × X → List A
  | 0, _ => []
  | fuel + 1, pair =>
      match policy.action? pair with
      | none => []
      | some action => action :: suffixFuel policy fuel (pairStep M pair action)

/-- Rank descent guarantees that `rank pair + 1` fuel reaches a terminal
separating response for every unequal pair. -/
theorem Policy.suffixFuel_separates_of_rank_lt
    (policy : Policy M) :
    ∀ fuel pair, policy.rank pair < fuel → pair.1 ≠ pair.2 →
      behavior M.step (acceptsBool M) pair.1
          (policy.suffixFuel M fuel pair) ≠
        behavior M.step (acceptsBool M) pair.2
          (policy.suffixFuel M fuel pair) := by
  intro fuel
  induction fuel with
  | zero =>
      intro pair hlt
      omega
  | succ fuel ih =>
      intro pair hlt hne
      cases haction : policy.action? pair with
      | none =>
          simpa [Policy.suffixFuel, haction] using
            policy.terminal_separates pair hne haction
      | some action =>
          have hnextNe := policy.step_preserves_ne pair hne action haction
          have hdecrease := policy.rank_decreases pair hne action haction
          have hnextRank : policy.rank (pairStep M pair action) < fuel := by
            omega
          have hnext := ih (pairStep M pair action) hnextRank hnextNe
          simpa [Policy.suffixFuel, haction, behavior, run, pairStep] using hnext

/-- The reconstructed suffix never uses more actions than the supplied rank. -/
theorem Policy.suffixFuel_length_le_rank_of_rank_lt
    (policy : Policy M) :
    ∀ fuel pair, policy.rank pair < fuel → pair.1 ≠ pair.2 →
      (policy.suffixFuel M fuel pair).length ≤ policy.rank pair := by
  intro fuel
  induction fuel with
  | zero =>
      intro pair hlt
      omega
  | succ fuel ih =>
      intro pair hlt hne
      cases haction : policy.action? pair with
      | none => simp [Policy.suffixFuel, haction]
      | some action =>
          have hnextNe := policy.step_preserves_ne pair hne action haction
          have hdecrease := policy.rank_decreases pair hne action haction
          have hnextRank : policy.rank (pairStep M pair action) < fuel := by
            omega
          have hnext := ih (pairStep M pair action) hnextRank hnextNe
          simp only [Policy.suffixFuel, haction, List.length_cons]
          omega

/-- The native suffix stored/reconstructed for one current pair. -/
def Policy.sharedSuffix (policy : Policy M) (pair : X × X) : List A :=
  policy.suffixFuel M (policy.rank pair + 1) pair

theorem Policy.sharedSuffix_separates
    (policy : Policy M) (pair : X × X) (hne : pair.1 ≠ pair.2) :
    behavior M.step (acceptsBool M) pair.1 (policy.sharedSuffix M pair) ≠
      behavior M.step (acceptsBool M) pair.2 (policy.sharedSuffix M pair) := by
  exact policy.suffixFuel_separates_of_rank_lt M
    (policy.rank pair + 1) pair (by omega) hne

theorem Policy.sharedSuffix_length_le_rank
    (policy : Policy M) (pair : X × X) (hne : pair.1 ≠ pair.2) :
    (policy.sharedSuffix M pair).length ≤ policy.rank pair := by
  exact policy.suffixFuel_length_le_rank_of_rank_lt M
    (policy.rank pair + 1) pair (by omega) hne

/-- Root reconstruction remains explicit.  If one replay prefix reaches the
pair governed by the shared policy, Mathlib's append composition adapter lifts
the shared suffix back to a separator of the declared roots. -/
theorem Policy.append_sharedSuffix_separates_roots
    (policy : Policy M) (left right : X) (replayPrefix : List A)
    (pair : X × X)
    (hleft : M.evalFrom left replayPrefix = pair.1)
    (hright : M.evalFrom right replayPrefix = pair.2)
    (hne : pair.1 ≠ pair.2) :
    behavior M.step (acceptsBool M) left
        (replayPrefix ++ policy.sharedSuffix M pair) ≠
      behavior M.step (acceptsBool M) right
        (replayPrefix ++ policy.sharedSuffix M pair) := by
  simpa [behavior, run_eq_evalFrom, DFA.evalFrom_of_append, hleft, hright] using
    policy.sharedSuffix_separates M pair hne

end NativeReverseSeparatorPolicy

end Pairfield
