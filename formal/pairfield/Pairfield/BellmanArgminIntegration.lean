/-
Copyright (c) 2026 Avik Jain and the mathematics collaboration.
Released under Apache 2.0 license.

The finite Bellman control has two intermediate witnesses.  Its
continuation-adjusted costs are presented to the proof-relevant
`argmin_decompose` theorem: the selected witness is a `Bool`, not merely the
scalar optimum value.
-/
import Pairfield.ArgminDecomposition

namespace Pairfield

private def routeCost : Bool → Nat
  | false => 2
  | true  => 1

private def routes : Finset Bool := {false, true}

private def block : Bool → Finset Bool
  | false => {false}
  | true  => {true}

private def witness : Bool → Bool := id

theorem bellman_argmin_witness :
    IsArgmin routeCost routes (witness true) := by
  apply argmin_decompose routeCost routes routes block witness true
  · intro x hx
    exact ⟨x, hx, by simp [block]⟩
  · intro i hi x hx
    simp only [routes, Finset.mem_insert, Finset.mem_singleton] at hi
    rcases hi with rfl | rfl <;> simp [block] at hx ⊢
  · intro i hi
    simp only [witness]
    simp only [routes, Finset.mem_insert, Finset.mem_singleton] at hi
    rcases hi with rfl | rfl <;> simp [block]
  · intro i hi x hx
    simp only [routes, Finset.mem_insert, Finset.mem_singleton] at hi
    rcases hi with rfl | rfl <;> simp [block] at hx ⊢
  · simp [routes]
  · intro i hi
    simp only [routes, Finset.mem_insert, Finset.mem_singleton] at hi
    rcases hi with rfl | rfl <;> decide

theorem bellman_argmin_value : routeCost (witness true) = 1 := rfl

end Pairfield
