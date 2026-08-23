import Pairfield.GoldbachWeightedBoundary
import Mathlib.Algebra.BigOperators.NatAntidiagonal

/-!
# Fixed-fiber prime-power contamination

This file sharpens the contamination estimate in `GoldbachWeightedBoundary` by
keeping the convolution on the antidiagonal.  The key point is that each of the
two mixed error sums contains only one freely summed prime-power error factor;
the other factor is bounded by `log N` on the fixed fiber.

The proof follows the checked route recorded in
`collab/messages/workers/20260814T091333Z--codex--fixed-antidiagonal-contamination-route.md`.
That message supplied theorem shape and provenance, not a formal proof.
-/

namespace Pairfield

open scoped ArithmeticFunction

noncomputable section

open Finset

theorem sum_antidiagonal_fst_eq_sum_Icc (N : ℕ) (f : ℕ → ℝ) :
    (∑ pair ∈ Finset.HasAntidiagonal.antidiagonal N, f pair.1) =
      ∑ n ∈ Finset.Icc 0 N, f n := by
  simpa [Nat.range_succ_eq_Icc_zero] using
    (Finset.Nat.sum_antidiagonal_eq_sum_range_succ (fun a _ => f a) N)

theorem sum_antidiagonal_snd_eq_sum_Icc (N : ℕ) (f : ℕ → ℝ) :
    (∑ pair ∈ Finset.HasAntidiagonal.antidiagonal N, f pair.2) =
      ∑ n ∈ Finset.Icc 0 N, f n := by
  calc
    (∑ pair ∈ Finset.HasAntidiagonal.antidiagonal N, f pair.2) =
        ∑ k ∈ Finset.range N.succ, f (N - k) := by
          simpa using
            (Finset.Nat.sum_antidiagonal_eq_sum_range_succ (fun _ b => f b) N)
    _ =
        ∑ k ∈ Finset.range N.succ, f k := by
          simpa using (Finset.sum_range_reflect f N.succ)
    _ = ∑ k ∈ Finset.Icc 0 N, f k := by
          rw [Nat.range_succ_eq_Icc_zero]

theorem vonMangoldt_le_log_of_le_center {m N : ℕ}
    (hN : 1 ≤ N) (hmN : m ≤ N) :
    ArithmeticFunction.vonMangoldt m ≤ Real.log (N : ℝ) := by
  by_cases hm0 : m = 0
  · subst m
    simpa using Real.log_nonneg (by exact_mod_cast hN : (1 : ℝ) ≤ N)
  calc
    ArithmeticFunction.vonMangoldt m ≤ Real.log (m : ℝ) :=
      ArithmeticFunction.vonMangoldt_le_log
    _ ≤ Real.log (N : ℝ) := by
      apply Real.log_le_log
      · exact_mod_cast (Nat.pos_of_ne_zero hm0)
      · exact_mod_cast hmN

theorem primeLogWeight_le_log_of_le_center {m N : ℕ}
    (hN : 1 ≤ N) (hmN : m ≤ N) :
    primeLogWeight m ≤ Real.log (N : ℝ) :=
  (primeLogWeight_le_vonMangoldt m).trans
    (vonMangoldt_le_log_of_le_center hN hmN)

theorem sum_vonMangoldt_mul_error_antidiagonal_le (N : ℕ) (hN : 1 ≤ N) :
    (∑ pair ∈ Finset.HasAntidiagonal.antidiagonal N,
        ArithmeticFunction.vonMangoldt pair.1 * primePowerError pair.2) ≤
      Real.log (N : ℝ) *
        (Chebyshev.psi (N : ℝ) - Chebyshev.theta (N : ℝ)) := by
  calc
    (∑ pair ∈ Finset.HasAntidiagonal.antidiagonal N,
        ArithmeticFunction.vonMangoldt pair.1 * primePowerError pair.2) ≤
        ∑ pair ∈ Finset.HasAntidiagonal.antidiagonal N,
          Real.log (N : ℝ) * primePowerError pair.2 := by
      apply Finset.sum_le_sum
      intro pair hpair
      have hsum : pair.1 + pair.2 = N :=
        Finset.HasAntidiagonal.mem_antidiagonal.mp hpair
      have hfst : pair.1 ≤ N := by omega
      exact mul_le_mul_of_nonneg_right
        (vonMangoldt_le_log_of_le_center hN hfst)
        (primePowerError_nonneg pair.2)
    _ = ∑ n ∈ Finset.Icc 0 N,
          Real.log (N : ℝ) * primePowerError n := by
      exact sum_antidiagonal_snd_eq_sum_Icc N
        (fun n => Real.log (N : ℝ) * primePowerError n)
    _ = Real.log (N : ℝ) *
        (∑ n ∈ Finset.Icc 0 N, primePowerError n) := by
      rw [Finset.mul_sum]
    _ = Real.log (N : ℝ) *
        (Chebyshev.psi (N : ℝ) - Chebyshev.theta (N : ℝ)) := by
      rw [sum_primePowerError_Icc]

theorem sum_error_mul_primeLog_antidiagonal_le (N : ℕ) (hN : 1 ≤ N) :
    (∑ pair ∈ Finset.HasAntidiagonal.antidiagonal N,
        primePowerError pair.1 * primeLogWeight pair.2) ≤
      Real.log (N : ℝ) *
        (Chebyshev.psi (N : ℝ) - Chebyshev.theta (N : ℝ)) := by
  calc
    (∑ pair ∈ Finset.HasAntidiagonal.antidiagonal N,
        primePowerError pair.1 * primeLogWeight pair.2) ≤
        ∑ pair ∈ Finset.HasAntidiagonal.antidiagonal N,
          primePowerError pair.1 * Real.log (N : ℝ) := by
      apply Finset.sum_le_sum
      intro pair hpair
      have hsum : pair.1 + pair.2 = N :=
        Finset.HasAntidiagonal.mem_antidiagonal.mp hpair
      have hsnd : pair.2 ≤ N := by omega
      exact mul_le_mul_of_nonneg_left
        (primeLogWeight_le_log_of_le_center hN hsnd)
        (primePowerError_nonneg pair.1)
    _ = ∑ n ∈ Finset.Icc 0 N,
          primePowerError n * Real.log (N : ℝ) := by
      exact sum_antidiagonal_fst_eq_sum_Icc N
        (fun n => primePowerError n * Real.log (N : ℝ))
    _ = Real.log (N : ℝ) *
        (∑ n ∈ Finset.Icc 0 N, primePowerError n) := by
      rw [Finset.mul_sum]
      apply Finset.sum_congr rfl
      intro n hn
      ring
    _ = Real.log (N : ℝ) *
        (Chebyshev.psi (N : ℝ) - Chebyshev.theta (N : ℝ)) := by
      rw [sum_primePowerError_Icc]

/-- The fixed-center contamination has only one summed error factor. -/
theorem primePowerContamination_le_two_log_mul_psi_sub_theta
    (N : ℕ) (hN : 1 ≤ N) :
    primePowerContamination N ≤
      2 * Real.log (N : ℝ) *
        (Chebyshev.psi (N : ℝ) - Chebyshev.theta (N : ℝ)) := by
  rw [primePowerContamination_eq_error_convolutions, Finset.sum_add_distrib]
  calc
    (∑ pair ∈ Finset.HasAntidiagonal.antidiagonal N,
        ArithmeticFunction.vonMangoldt pair.1 * primePowerError pair.2) +
        ∑ pair ∈ Finset.HasAntidiagonal.antidiagonal N,
          primePowerError pair.1 * primeLogWeight pair.2 ≤
        Real.log (N : ℝ) *
            (Chebyshev.psi (N : ℝ) - Chebyshev.theta (N : ℝ)) +
          Real.log (N : ℝ) *
            (Chebyshev.psi (N : ℝ) - Chebyshev.theta (N : ℝ)) :=
      add_le_add
        (sum_vonMangoldt_mul_error_antidiagonal_le N hN)
        (sum_error_mul_primeLog_antidiagonal_le N hN)
    _ = 2 * Real.log (N : ℝ) *
        (Chebyshev.psi (N : ℝ) - Chebyshev.theta (N : ℝ)) := by ring

/-- An explicit `O(sqrt N log^2 N)` consequence of the fixed-fiber estimate. -/
theorem primePowerContamination_le_four_sqrt_mul_log_sq
    (N : ℕ) (hN : 1 ≤ N) :
    primePowerContamination N ≤
      4 * Real.sqrt (N : ℝ) * (Real.log (N : ℝ)) ^ 2 := by
  calc
    primePowerContamination N ≤
        2 * Real.log (N : ℝ) *
          (Chebyshev.psi (N : ℝ) - Chebyshev.theta (N : ℝ)) :=
      primePowerContamination_le_two_log_mul_psi_sub_theta N hN
    _ ≤ 2 * Real.log (N : ℝ) *
        (2 * Real.sqrt (N : ℝ) * Real.log (N : ℝ)) := by
      apply mul_le_mul_of_nonneg_left
      · exact Chebyshev.psi_sub_theta_le (by exact_mod_cast hN)
      · positivity
    _ = 4 * Real.sqrt (N : ℝ) * (Real.log (N : ℝ)) ^ 2 := by ring

/-- A fixed-center Mangoldt lower bound above the explicit contamination
bound forces a representation by two actual primes.  This isolates the still
missing analytic premise without replacing it by a prime-power statement. -/
theorem goldbachAt_of_four_sqrt_mul_log_sq_lt_mangoldtGoldbachCoeff
    (N : ℕ) (hN : 1 ≤ N)
    (h : 4 * Real.sqrt (N : ℝ) * (Real.log (N : ℝ)) ^ 2 <
      mangoldtGoldbachCoeff N) :
    GoldbachAt N := by
  apply goldbachAt_of_contamination_lt_mangoldtGoldbachCoeff N
  exact lt_of_le_of_lt
    (primePowerContamination_le_four_sqrt_mul_log_sq N hN) h

/-- At a Goldbach exception, the prime-only weighted coefficient vanishes. -/
theorem primeLogGoldbachCoeff_eq_zero_of_not_goldbachAt
    (N : ℕ) (hN : ¬ GoldbachAt N) :
    primeLogGoldbachCoeff N = 0 := by
  apply le_antisymm
  · exact not_lt.mp (fun hpos => hN ((primeLogGoldbachCoeff_pos_iff N).1 hpos))
  · exact primeLogGoldbachCoeff_nonneg N

/-- At a Goldbach exception, every unit of Mangoldt mass on the fiber is
prime-power contamination. -/
theorem mangoldtGoldbachCoeff_eq_primePowerContamination_of_not_goldbachAt
    (N : ℕ) (hN : ¬ GoldbachAt N) :
    mangoldtGoldbachCoeff N = primePowerContamination N := by
  rw [primePowerContamination,
    primeLogGoldbachCoeff_eq_zero_of_not_goldbachAt N hN, sub_zero]

/-- Checked exception signature: an exceptional center can carry at most the
explicit fixed-fiber prime-power error.  Calling this “near-total minor-arc
cancellation” requires a separate major-arc decomposition and lower bound;
this theorem records only the exact algebraic prerequisite. -/
theorem mangoldtGoldbachCoeff_le_four_sqrt_mul_log_sq_of_not_goldbachAt
    (N : ℕ) (hN : 1 ≤ N) (hException : ¬ GoldbachAt N) :
    mangoldtGoldbachCoeff N ≤
      4 * Real.sqrt (N : ℝ) * (Real.log (N : ℝ)) ^ 2 := by
  rw [mangoldtGoldbachCoeff_eq_primePowerContamination_of_not_goldbachAt
    N hException]
  exact primePowerContamination_le_four_sqrt_mul_log_sq N hN

end

end Pairfield
