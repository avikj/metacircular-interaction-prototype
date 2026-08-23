/-
Copyright (c) 2026 Avik Jain and the mathematics collaboration.
Released under Apache 2.0 license.

A finite one-sided anti-spike lemma for real sequences.  A depth `H` at one
index propagates forward as long as the accumulated step budget is at most
`H / 2`.  The derivative bound is an explicit hypothesis; no arithmetic or
prime-specific sequence is asserted to satisfy it here.
-/
import Mathlib.Data.Real.Basic
import Mathlib.Tactic

namespace Pairfield

/-- A bounded first difference controls forward growth up to the declared
finite horizon. -/
theorem forward_growth_le_of_abs_step
    (a : ℕ → ℝ) {X : ℕ} {D : ℝ}
    (hstep : ∀ i : ℕ, i < X → |a (i + 1) - a i| ≤ D) :
    ∀ (i j : ℕ), i + j ≤ X →
      a (i + j) ≤ a i + (j : ℝ) * D := by
  intro i j
  induction j with
  | zero => simp
  | succ j ih =>
      intro hij
      have hij' : i + j ≤ X := by omega
      have hlocal := hstep (i + j) (by omega)
      have hdifference : a ((i + j) + 1) - a (i + j) ≤ D :=
        (le_abs_self (a ((i + j) + 1) - a (i + j))).trans hlocal
      calc
        a (i + Nat.succ j) = a ((i + j) + 1) := by
          rw [Nat.add_succ, Nat.succ_eq_add_one]
        _ ≤ a (i + j) + D := by linarith
        _ ≤ (a i + (j : ℝ) * D) + D := by
          linarith [ih hij']
        _ = a i + (Nat.succ j : ℝ) * D := by
          push_cast
          ring

/-- A negative spike cannot recover more than half its depth before the
accumulated step budget reaches `H / 2`. -/
theorem forward_antiSpike_half
    (a : ℕ → ℝ) {X i₀ j : ℕ} {H D : ℝ}
    (hstep : ∀ i : ℕ, i < X → |a (i + 1) - a i| ≤ D)
    (hinRange : i₀ + j ≤ X)
    (hspike : a i₀ ≤ -H)
    (hbudget : (j : ℝ) * D ≤ H / 2) :
    a (i₀ + j) ≤ -H / 2 := by
  calc
    a (i₀ + j) ≤ a i₀ + (j : ℝ) * D :=
      forward_growth_le_of_abs_step a hstep i₀ j hinRange
    _ ≤ -H + H / 2 := add_le_add hspike hbudget
    _ = -H / 2 := by ring

/-- Uniform finite-window form: one endpoint budget controls every earlier
offset in the window. -/
theorem forward_antiSpike_half_on_window
    (a : ℕ → ℝ) {X i₀ J : ℕ} {H D : ℝ}
    (hD : 0 ≤ D)
    (hstep : ∀ i : ℕ, i < X → |a (i + 1) - a i| ≤ D)
    (hwindow : i₀ + J ≤ X)
    (hspike : a i₀ ≤ -H)
    (hbudget : (J : ℝ) * D ≤ H / 2) :
    ∀ j : ℕ, j ≤ J → a (i₀ + j) ≤ -H / 2 := by
  intro j hj
  apply forward_antiSpike_half a hstep (by omega) hspike
  exact (mul_le_mul_of_nonneg_right (by exact_mod_cast hj) hD).trans hbudget

end Pairfield
