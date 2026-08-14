/-
Copyright (c) 2026 Avik Jain and the mathematics collaboration.
Released under Apache 2.0 license.

Transport Mathlib's square-root Chebyshev bound onto the repository-native
prime-power error and its exact Goldbach contamination comparison.

This does not prove a Goldbach lower bound.  The second theorem retains the
factor `Chebyshev.psi N`, so its scale is still too coarse for positivity.
-/
import Pairfield.GoldbachWeightedBoundary
import Mathlib.Algebra.BigOperators.NatAntidiagonal

namespace Pairfield

open scoped ArithmeticFunction

noncomputable section

/-- Mathlib's `ψ - θ = O(√x)` theorem, transported to the exact native sum of
prime-power-only mass. -/
theorem exists_primePowerError_sum_le_mul_sqrt :
    ∃ C : ℝ, 0 ≤ C ∧ ∀ N : ℕ,
      (∑ n ∈ Finset.Icc 0 N, primePowerError n) ≤ C * Real.sqrt N := by
  obtain ⟨C, hC⟩ := Chebyshev.psi_sub_theta_le_mul_sqrt
  refine ⟨|C|, abs_nonneg C, fun N ↦ ?_⟩
  rw [sum_primePowerError_Icc]
  exact (hC N).trans <|
    mul_le_mul_of_nonneg_right (le_abs_self C) (Real.sqrt_nonneg N)

/-- The same Mathlib constant controls the live contamination after the
already-checked full-square comparison.  The retained `ψ(N)` factor records
why this adapter alone cannot separate a Goldbach main term of order `N`. -/
theorem exists_primePowerContamination_le_mul_psi_mul_sqrt :
    ∃ C : ℝ, 0 ≤ C ∧ ∀ N : ℕ,
      primePowerContamination N ≤ C * Chebyshev.psi N * Real.sqrt N := by
  obtain ⟨C, hCnonneg, hC⟩ := exists_primePowerError_sum_le_mul_sqrt
  refine ⟨2 * C, mul_nonneg (by positivity) hCnonneg, fun N ↦ ?_⟩
  have herror :
      Chebyshev.psi N - Chebyshev.theta N ≤ C * Real.sqrt N := by
    rw [← sum_primePowerError_Icc]
    exact hC N
  calc
    primePowerContamination N ≤
        2 * Chebyshev.psi N *
          (Chebyshev.psi N - Chebyshev.theta N) :=
      primePowerContamination_le_two_mul_psi_mul_sub_theta N
    _ ≤ 2 * Chebyshev.psi N * (C * Real.sqrt N) := by
      exact mul_le_mul_of_nonneg_left herror <|
        mul_nonneg (by positivity) (Chebyshev.psi_nonneg N)
    _ = (2 * C) * Chebyshev.psi N * Real.sqrt N := by ring

/-- Every von-Mangoldt weight on the fixed antidiagonal of `N` is at most
`log N`.  The endpoint `n = 0` is split because monotonicity of `log` needs a
positive left input. -/
theorem vonMangoldt_le_log_horizon {n N : ℕ} (hN : 1 ≤ N) (hn : n ≤ N) :
    Λ n ≤ Real.log N := by
  calc
    Λ n ≤ Real.log n := ArithmeticFunction.vonMangoldt_le_log
    _ ≤ Real.log N := by
      by_cases hnzero : n = 0
      · subst n
        simpa using Real.log_nonneg (show (1 : ℝ) ≤ N by exact_mod_cast hN)
      · exact Real.log_le_log (by positivity) (by exact_mod_cast hn)

theorem primePowerError_le_vonMangoldt (n : ℕ) :
    primePowerError n ≤ Λ n := by
  unfold primePowerError
  linarith [primeLogWeight_nonneg n]

/-- A one-dimensional antidiagonal estimate.  Unlike the generic full-square
bound, it spends only the maximum of the second factor on the declared fiber. -/
theorem sum_primePowerError_mul_antidiagonal_le
    (N : ℕ) (hN : 1 ≤ N) (g : ℕ → ℝ)
    (hg : ∀ n, n ≤ N → g n ≤ Real.log N) :
    (∑ pair ∈ Finset.HasAntidiagonal.antidiagonal N,
      primePowerError pair.1 * g pair.2) ≤
      Real.log N * (Chebyshev.psi N - Chebyshev.theta N) := by
  rw [Finset.Nat.sum_antidiagonal_eq_sum_range_succ
      (fun i j ↦ primePowerError i * g j) N,
    ← Finset.Nat.range_succ_eq_Icc_zero,
    ← sum_primePowerError_Icc, Finset.mul_sum]
  apply Finset.sum_le_sum
  intro n hnrange
  calc
    primePowerError n * g (N - n) ≤
        primePowerError n * Real.log N := by
      exact mul_le_mul_of_nonneg_left
        (hg (N - n) (Nat.sub_le N n)) (primePowerError_nonneg n)
    _ = Real.log N * primePowerError n := by ring

/-- The return from the analytic lineage removes the spurious `psi(N)` factor:
on one fixed antidiagonal, each non-error weight costs only `log N`. -/
theorem primePowerContamination_le_two_mul_log_mul_sub_theta
    (N : ℕ) (hN : 1 ≤ N) :
    primePowerContamination N ≤
      2 * Real.log N * (Chebyshev.psi N - Chebyshev.theta N) := by
  have hleft :
      (∑ pair ∈ Finset.HasAntidiagonal.antidiagonal N,
        Λ pair.1 * primePowerError pair.2) ≤
        Real.log N * (Chebyshev.psi N - Chebyshev.theta N) := by
    calc
      (∑ pair ∈ Finset.HasAntidiagonal.antidiagonal N,
        Λ pair.1 * primePowerError pair.2) =
          ∑ pair ∈ Finset.HasAntidiagonal.antidiagonal N,
            primePowerError pair.1 * Λ pair.2 := by
        rw [← Finset.Nat.sum_antidiagonal_swap
          (n := N) (f := fun pair ↦
            primePowerError pair.1 * Λ pair.2)]
        apply Finset.sum_congr rfl
        intro pair _
        simp only [Prod.swap_prod_mk, Prod.fst, Prod.snd]
        ring
      _ ≤ Real.log N * (Chebyshev.psi N - Chebyshev.theta N) :=
        sum_primePowerError_mul_antidiagonal_le N hN
          (fun n ↦ Λ n) (fun n hn ↦ vonMangoldt_le_log_horizon hN hn)
  have hright :
      (∑ pair ∈ Finset.HasAntidiagonal.antidiagonal N,
        primePowerError pair.1 * primeLogWeight pair.2) ≤
        Real.log N * (Chebyshev.psi N - Chebyshev.theta N) := by
    exact sum_primePowerError_mul_antidiagonal_le N hN primeLogWeight
      (fun n hn ↦
        (primeLogWeight_le_vonMangoldt n).trans
          (vonMangoldt_le_log_horizon hN hn))
  rw [primePowerContamination_eq_error_convolutions,
    Finset.sum_add_distrib]
  calc
    _ ≤ Real.log N * (Chebyshev.psi N - Chebyshev.theta N) +
        Real.log N * (Chebyshev.psi N - Chebyshev.theta N) :=
      add_le_add hleft hright
    _ = 2 * Real.log N *
        (Chebyshev.psi N - Chebyshev.theta N) := by ring

/-- Final checked transport: proper-prime-power contamination on a fixed
Goldbach fiber is `O(√N log N)`. -/
theorem exists_primePowerContamination_le_mul_sqrt_mul_log :
    ∃ C : ℝ, 0 ≤ C ∧ ∀ N : ℕ, 1 ≤ N →
      primePowerContamination N ≤
        C * Real.sqrt N * Real.log N := by
  obtain ⟨C, hCnonneg, hC⟩ := exists_primePowerError_sum_le_mul_sqrt
  refine ⟨2 * C, mul_nonneg (by positivity) hCnonneg, fun N hN ↦ ?_⟩
  have herror :
      Chebyshev.psi N - Chebyshev.theta N ≤ C * Real.sqrt N := by
    rw [← sum_primePowerError_Icc]
    exact hC N
  calc
    primePowerContamination N ≤
        2 * Real.log N *
          (Chebyshev.psi N - Chebyshev.theta N) :=
      primePowerContamination_le_two_mul_log_mul_sub_theta N hN
    _ ≤ 2 * Real.log N * (C * Real.sqrt N) := by
      exact mul_le_mul_of_nonneg_left herror <|
        mul_nonneg (by positivity)
          (Real.log_nonneg (show (1 : ℝ) ≤ N by exact_mod_cast hN))
    _ = (2 * C) * Real.sqrt N * Real.log N := by ring

end

end Pairfield
