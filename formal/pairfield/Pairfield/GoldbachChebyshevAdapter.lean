/-
Copyright (c) 2026 Avik Jain and the mathematics collaboration.
Released under Apache 2.0 license.

Transport Mathlib's square-root Chebyshev bound onto the repository-native
prime-power error and the returned fixed-fiber Goldbach contamination bound.

This does not prove a Goldbach lower bound.  It removes proper-prime-power
contamination only after a separate Mangoldt coefficient lower bound exists.
-/
import Pairfield.GoldbachFixedFiberContamination

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

/-- Final checked transport: Mathlib's sharp square-root theorem composes with
the lineage return on one fixed antidiagonal, so proper-prime-power
contamination is `O(√N log N)`. -/
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
      primePowerContamination_le_two_log_mul_psi_sub_theta N hN
    _ ≤ 2 * Real.log N * (C * Real.sqrt N) := by
      exact mul_le_mul_of_nonneg_left herror <|
        mul_nonneg (by positivity)
          (Real.log_nonneg (show (1 : ℝ) ≤ N by exact_mod_cast hN))
    _ = (2 * C) * Real.sqrt N * Real.log N := by ring

end

end Pairfield
