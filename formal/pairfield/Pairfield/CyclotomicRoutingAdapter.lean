/-
Checked adapter for the cyclotomic routing operation in
`notes/CYCLOTOMIC_SENSOR.md`.

The native organ routes `a^n - 1` through every evaluated cyclotomic piece
whose index divides `n`.  Mathlib already proves the corresponding polynomial
identity.  This file transports it through evaluation and records the exact
integer divisibility interface used by the route.
-/
import Mathlib.RingTheory.Polynomial.Cyclotomic.Basic
import Mathlib.Tactic.NormNum

namespace Pairfield.CyclotomicRoutingAdapter

open scoped BigOperators
open Polynomial

/-- Evaluating Mathlib's cyclotomic product identity gives the exact route in
any commutative ring.  Positivity is load-bearing because `Nat.divisors 0` is
empty. -/
theorem eval_prod_cyclotomic_eq_pow_sub_one
    {R : Type*} [CommRing R] {n : ℕ} (hn : 0 < n) (a : R) :
    ∏ d ∈ n.divisors, (cyclotomic d R).eval a = a ^ n - 1 := by
  rw [← Polynomial.eval_prod]
  rw [Polynomial.prod_cyclotomic_eq_X_pow_sub_one hn R]
  simp only [Polynomial.eval_sub, Polynomial.eval_X_pow, Polynomial.eval_one]

/-- The integer value of one native cyclotomic routing piece. -/
noncomputable def piece (a : ℤ) (d : ℕ) : ℤ :=
  (cyclotomic d ℤ).eval a

/-- The native integer route retains the complete divisor index. -/
theorem integer_route {n : ℕ} (hn : 0 < n) (a : ℤ) :
    ∏ d ∈ n.divisors, piece a d = a ^ n - 1 := by
  simpa only [piece] using
    (eval_prod_cyclotomic_eq_pow_sub_one (R := ℤ) hn a)

/-- Every piece selected by the divisor route divides the original target. -/
theorem piece_dvd_target {d n : ℕ} (hn : 0 < n) (hd : d ∣ n) (a : ℤ) :
    piece a d ∣ a ^ n - 1 := by
  rw [← integer_route hn a]
  exact Finset.dvd_prod_of_mem _
    (Nat.mem_divisors.mpr ⟨hd, hn.ne'⟩)

/-- Native positive control: routing `2^6 - 1` reconstructs `63`. -/
theorem two_pow_six_route :
    ∏ d ∈ Nat.divisors 6, piece 2 d = 63 := by
  have h := integer_route (n := 6) (by norm_num) 2
  norm_num at h
  exact h

/-- The index-six piece is genuinely routed into the native target. -/
theorem sixth_piece_dvd_sixty_three :
    piece 2 6 ∣ 63 := by
  have h := piece_dvd_target (d := 6) (n := 6) (by norm_num) (by norm_num) 2
  norm_num at h
  exact h

/-- Hostile endpoint: extending the product route to `n = 0` is false. -/
theorem zero_index_control :
    (∏ d ∈ Nat.divisors 0, piece 2 d) ≠ (2 : ℤ) ^ 0 - 1 := by
  norm_num

end Pairfield.CyclotomicRoutingAdapter
