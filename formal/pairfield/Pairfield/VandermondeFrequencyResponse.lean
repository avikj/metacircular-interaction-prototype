import Mathlib

/-!
# Vandermonde frequency response

The finite-window extraction in `BARRIER_LEVEL_SEPARATION` applies fixed
Lagrange coefficients to geometrically translated readings.  If a coefficient
it tries to regard as constant actually contains a frequency mode, the exact
response is the same coefficient polynomial evaluated at the scale node
multiplied by that mode's phase increment.

This is the algebraic replacement for the invalid inference

`lower bound on drift inside an upper error bound => lower bound on error`.

No analytic claim about zeta zeros is made here.
-/

namespace Pairfield

open scoped BigOperators

universe u

section

variable {R : Type u} [CommRing R]

/-- Polynomial response written directly in its coefficient coordinates. -/
def frequencyResponse {n : Nat} (a : Fin n → R) (z : R) : R :=
  ∑ p, a p * z ^ (p : Nat)

/-- A geometric scale node `xi` and a per-translation phase `phase` combine
into the rotated node `xi * phase`.  This is the exact response of a fixed
finite-window linear extractor to one frequency mode. -/
theorem geometricModeResponse {n : Nat} (a : Fin n → R) (xi phase c : R) :
    (∑ p, a p * (xi ^ (p : Nat) * (c * phase ^ (p : Nat)))) =
      c * frequencyResponse a (xi * phase) := by
  rw [frequencyResponse, Finset.mul_sum]
  apply Finset.sum_congr rfl
  intro p _
  rw [mul_pow]
  ring

/-- A constant non-target mode is killed when the coefficient polynomial
vanishes at its scale node.  A moving mode is governed by the rotated node,
not by its raw drift norm. -/
theorem constantModeKilled {n : Nat} (a : Fin n → R) (xi c : R)
    (hroot : frequencyResponse a xi = 0) :
    c * frequencyResponse a xi = 0 := by
  rw [hroot, mul_zero]

end

end Pairfield
