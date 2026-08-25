/-
Copyright (c) 2026 Avik Jain and the mathematics collaboration.
Released under Apache 2.0 license.

Finite observable formation for generated action systems.  The bounded
response kernel closes under every action exactly when it has stabilized to
complete future equivalence.
-/
import Pairfield.ChartStateBFS

namespace Pairfield

universe u v w

variable {X : Type u} {A : Type v} {O : Type w}

/-- Equality under every experiment whose word length is at most `fuel`. -/
def BoundedFutureEq (step : X → A → X) (observe : X → O)
    (fuel : Nat) (x y : X) : Prop :=
  ∀ word : List A, word.length ≤ fuel →
    behavior step observe x word = behavior step observe y word

/-- The depth-`fuel` observable kernel admits every installed one-step action. -/
def ObservableClosesAt (step : X → A → X) (observe : X → O)
    (fuel : Nat) : Prop :=
  ∀ x y : X, BoundedFutureEq step observe fuel x y →
    ∀ action : A,
      BoundedFutureEq step observe fuel (step x action) (step y action)

/-- A finite response window is predictive precisely when its kernel has
already stabilized to the complete future kernel. -/
theorem observableClosesAt_iff_bounded_implies_future
    (step : X → A → X) (observe : X → O) (fuel : Nat) :
    ObservableClosesAt step observe fuel ↔
      ∀ x y : X, BoundedFutureEq step observe fuel x y →
        FutureEq step observe x y := by
  constructor
  · intro hclose x y hbounded word
    induction word generalizing x y with
    | nil =>
        exact hbounded [] (by simp)
    | cons action tail ih =>
        exact ih (step x action) (step y action)
          (hclose x y hbounded action)
  · intro hfuture x y hbounded action word _
    exact futureEq_step step observe (hfuture x y hbounded) action word

/-- An equal bounded window followed by any unequal later response is an
exact certificate that the bounded observable has not formed a congruence. -/
theorem bounded_collision_obstructs_closure
    (step : X → A → X) (observe : X → O) {fuel : Nat} {x y : X}
    (hbounded : BoundedFutureEq step observe fuel x y)
    (word : List A)
    (hsep : behavior step observe x word ≠
      behavior step observe y word) :
    ¬ ObservableClosesAt step observe fuel := by
  intro hclose
  exact hsep
    (((observableClosesAt_iff_bounded_implies_future step observe fuel).1
      hclose x y hbounded) word)

/-- Loop deletion in the finite pair monitor supplies a uniform semantic
formation horizon.  This does not claim a sharp queue-execution cost. -/
theorem finiteDFA_observableClosesAt_card_sq
    [Fintype X] (M : DFA A X)
    [DecidablePred (fun state : X => state ∈ M.accept)] :
    ObservableClosesAt M.step (acceptsBool M)
      (Fintype.card X * Fintype.card X) := by
  rw [observableClosesAt_iff_bounded_implies_future]
  intro x y hbounded word
  by_contra hsep
  obtain ⟨short, hlength, hshort⟩ :=
    exists_state_separator_lt_card_sq M x y hsep
  exact hshort (hbounded short (Nat.le_of_lt hlength))

/-- A returned globally shortest witness obstructs closure at every strictly
smaller horizon, not merely at the immediately preceding layer. -/
theorem shortestStateWitness_obstructs_before
    [DecidableEq A] [Fintype X] (M : DFA A X)
    [DecidablePred (fun state : X => state ∈ M.accept)]
    (alphabet : List A) (complete : ∀ action : A, action ∈ alphabet)
    (x y : X) {word : List A}
    (hword : shortestStateWitness M alphabet x y = some word)
    {fuel : Nat} (hfuel : fuel < word.length) :
    ¬ ObservableClosesAt M.step (acceptsBool M) fuel := by
  have hbounded :
      BoundedFutureEq M.step (acceptsBool M) fuel x y := by
    intro candidate hlength
    by_contra hsep
    have hminimal := shortestStateWitness_minimal
      M alphabet complete x y hword candidate hsep
    omega
  exact bounded_collision_obstructs_closure M.step (acceptsBool M)
    hbounded word
    (shortestStateWitness_sound M alphabet complete x y hword)

namespace ObservableHorizonWitness

open BehavioralBFSWitness

/-- In the three-state control, depth-zero observation is not a congruence. -/
theorem not_closesAt_zero :
    ¬ ObservableClosesAt step observe 0 := by
  have hbounded : BoundedFutureEq step observe 0 (0 : Fin 3) 1 := by
    intro word hlength
    cases word with
    | nil => rfl
    | cons action tail => simp at hlength
  apply bounded_collision_obstructs_closure step observe hbounded [true]
  decide

/-- One response coordinate already reconstructs every state in the control. -/
theorem bounded_one_injective (x y : Fin 3)
    (h : BoundedFutureEq step observe 1 x y) : x = y := by
  have hnow := h [] (by simp)
  have htrue := h [true] (by simp)
  fin_cases x <;> fin_cases y <;>
    simp_all [behavior, run, step, observe]

/-- Hence the control's exact first stable observable horizon is one. -/
theorem closesAt_one : ObservableClosesAt step observe 1 := by
  rw [observableClosesAt_iff_bounded_implies_future]
  intro x y hbounded
  rw [bounded_one_injective x y hbounded]
  exact futureEq_refl step observe y

theorem least_horizon_is_one :
    ¬ ObservableClosesAt step observe 0 ∧
      ObservableClosesAt step observe 1 :=
  ⟨not_closesAt_zero, closesAt_one⟩

end ObservableHorizonWitness

end Pairfield
