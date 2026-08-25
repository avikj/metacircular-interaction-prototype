import Mathlib

/-!
# Triangular reconstruction from additive convolution data

`SumRigidity` proves global injectivity of the sum marginal.  This module
records the complementary finite inverse used by the von Mangoldt sequence.
The leading coefficient is a separate square-root base case; only subsequent
coefficients satisfy the formula with the factor `2 * a 2`.

For `n ≥ 3`, the coefficient at centre `n + 2` consists of the two boundary
terms `(2,n)` and `(n,2)`, plus pairs whose two indices are at least three.
Those interior indices are both strictly smaller than `n`, so the inverse is
genuinely triangular.
-/

namespace Pairfield

open Finset

noncomputable section

/-- The coefficient at `N` of the additive convolution square of `a`. -/
def additiveSquareCoeff {R : Type*} [CommSemiring R]
    (a : ℕ → R) (N : ℕ) : R :=
  ∑ pair ∈ Finset.HasAntidiagonal.antidiagonal N, a pair.1 * a pair.2

/-- At centre `n + 2`, the part not involving the distinguished index `2`. -/
def additiveSquareInterior {R : Type*} [CommSemiring R]
    (a : ℕ → R) (n : ℕ) : R :=
  ∑ pair ∈ (Finset.HasAntidiagonal.antidiagonal (n + 2)).filter
      (fun pair ↦ 3 ≤ pair.1 ∧ 3 ≤ pair.2),
    a pair.1 * a pair.2

/-- The coefficient at `4` is the exceptional base case: there is only one
nonzero pair, `(2,2)`, rather than two distinct boundary pairs. -/
theorem additiveSquareCoeff_four {R : Type*} [CommSemiring R]
    (a : ℕ → R) (hzero : a 0 = 0) (hone : a 1 = 0) :
    additiveSquareCoeff a 4 = a 2 * a 2 := by
  unfold additiveSquareCoeff
  rw [Finset.Nat.sum_antidiagonal_eq_sum_range_succ
    (fun i j ↦ a i * a j) 4]
  norm_num [Finset.sum_range_succ, hzero, hone]

/-- A nonnegative leading coefficient is recovered from the coefficient at
`4` by the positive square root. -/
theorem leadingCoefficient_eq_sqrt_squareCoeff
    (a : ℕ → ℝ) (hzero : a 0 = 0) (hone : a 1 = 0)
    (hlead : 0 ≤ a 2) :
    a 2 = Real.sqrt (additiveSquareCoeff a 4) := by
  rw [additiveSquareCoeff_four a hzero hone]
  calc
    a 2 = |a 2| := (abs_of_nonneg hlead).symm
    _ = Real.sqrt ((a 2) ^ 2) := (Real.sqrt_sq_eq_abs (a 2)).symm
    _ = Real.sqrt (a 2 * a 2) := by rw [pow_two]

/-- Version of the base case stated against an externally supplied sequence
of convolution coefficients. -/
theorem leadingCoefficient_reconstruct
    (a goldbach : ℕ → ℝ) (hzero : a 0 = 0) (hone : a 1 = 0)
    (hlead : 0 ≤ a 2)
    (hfour : goldbach 4 = additiveSquareCoeff a 4) :
    a 2 = Real.sqrt (goldbach 4) := by
  rw [hfour]
  exact leadingCoefficient_eq_sqrt_squareCoeff a hzero hone hlead

/-- For `n ≥ 3`, the convolution coefficient splits into two distinct
boundary terms and the interior tail. -/
theorem additiveSquareCoeff_eq_two_mul_add_interior
    {R : Type*} [CommRing R] (a : ℕ → R) (n : ℕ) (hn : 3 ≤ n)
    (hzero : a 0 = 0) (hone : a 1 = 0) :
    additiveSquareCoeff a (n + 2) =
      2 * a 2 * a n + additiveSquareInterior a n := by
  let S := Finset.HasAntidiagonal.antidiagonal (n + 2)
  let supported := S.filter (fun pair ↦ 2 ≤ pair.1 ∧ 2 ≤ pair.2)
  let interior := S.filter (fun pair ↦ 3 ≤ pair.1 ∧ 3 ≤ pair.2)
  have hsupported :
      (∑ pair ∈ supported, a pair.1 * a pair.2) =
        ∑ pair ∈ S, a pair.1 * a pair.2 := by
    apply Finset.sum_subset (Finset.filter_subset _ _)
    intro pair hpair hnot
    simp only [Finset.mem_filter, not_and] at hnot
    have hnot' : ¬ (2 ≤ pair.1 ∧ 2 ≤ pair.2) := by
      intro hboth
      exact hnot hpair hboth.1 hboth.2
    by_cases hfst : 2 ≤ pair.1
    · have hsnd : pair.2 < 2 := by omega
      have hsnd_cases : pair.2 = 0 ∨ pair.2 = 1 := by omega
      rcases hsnd_cases with hsnd0 | hsnd1
      · rw [hsnd0, hzero, mul_zero]
      · rw [hsnd1, hone, mul_zero]
    · have hfst' : pair.1 < 2 := Nat.lt_of_not_ge hfst
      have hfst_cases : pair.1 = 0 ∨ pair.1 = 1 := by omega
      rcases hfst_cases with hfst0 | hfst1
      · rw [hfst0, hzero, zero_mul]
      · rw [hfst1, hone, zero_mul]
  have hpartition :
      supported = insert (2, n) (insert (n, 2) interior) := by
    ext pair
    simp only [supported, interior, Finset.mem_filter, Finset.mem_insert,
      S, Finset.HasAntidiagonal.mem_antidiagonal]
    constructor
    · rintro ⟨hsum, hfst, hsnd⟩
      by_cases hfst2 : pair.1 = 2
      · left
        apply Prod.ext
        · exact hfst2
        · omega
      by_cases hsnd2 : pair.2 = 2
      · right; left
        apply Prod.ext
        · omega
        · exact hsnd2
      · right; right
        exact ⟨hsum, by omega, by omega⟩
    · rintro (hpair | hpair | hpair)
      · subst pair
        exact ⟨by omega, by omega, by omega⟩
      · subst pair
        exact ⟨by omega, by omega, by omega⟩
      · exact ⟨hpair.1, by omega, by omega⟩
  calc
    additiveSquareCoeff a (n + 2) =
        ∑ pair ∈ S, a pair.1 * a pair.2 := rfl
    _ = ∑ pair ∈ supported, a pair.1 * a pair.2 := hsupported.symm
    _ = a 2 * a n + a n * a 2 +
        ∑ pair ∈ interior, a pair.1 * a pair.2 := by
      rw [hpartition]
      have hn2 : (n, 2) ∉ interior := by simp [interior]
      have h2n : (2, n) ∉ insert (n, 2) interior := by
        simp only [Finset.mem_insert, Prod.mk.injEq, not_or]
        constructor
        · omega
        · simp [interior]
      rw [Finset.sum_insert h2n, Finset.sum_insert hn2]
      ring
    _ = 2 * a 2 * a n + additiveSquareInterior a n := by
      simp only [additiveSquareInterior, interior, S]
      ring

/-- Every factor occurring in the interior tail was reconstructed earlier. -/
theorem additiveSquareInterior_indices_lt
    {n : ℕ} {pair : ℕ × ℕ}
    (hpair : pair ∈ (Finset.HasAntidiagonal.antidiagonal (n + 2)).filter
      (fun p ↦ 3 ≤ p.1 ∧ 3 ≤ p.2)) :
    pair.1 < n ∧ pair.2 < n := by
  simp only [Finset.mem_filter,
    Finset.HasAntidiagonal.mem_antidiagonal] at hpair
  omega

/-- The triangular inverse.  The hypothesis `3 ≤ n` is essential: at `n=2`
the pair `(2,2)` occurs once, so division by `2 * a 2` would be wrong. -/
theorem triangularCoefficient_reconstruct
    (a goldbach : ℕ → ℝ) (n : ℕ) (hn : 3 ≤ n)
    (hzero : a 0 = 0) (hone : a 1 = 0) (hlead : a 2 ≠ 0)
    (hcoeff : goldbach (n + 2) = additiveSquareCoeff a (n + 2)) :
    a n =
      (goldbach (n + 2) - additiveSquareInterior a n) / (2 * a 2) := by
  rw [hcoeff, additiveSquareCoeff_eq_two_mul_add_interior a n hn hzero hone]
  field_simp
  ring

end

end Pairfield
