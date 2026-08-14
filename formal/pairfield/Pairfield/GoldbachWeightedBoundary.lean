/-
Copyright (c) 2026 Avik Jain and the mathematics collaboration.
Released under Apache 2.0 license.

An exact boundary between two finite additive convolutions at a fixed natural
centre.  The prime-log coefficient has precisely Goldbach support.  The
von-Mangoldt coefficient also sees prime powers, so its excess over the
prime-log coefficient is retained explicitly as contamination.

No lower bound for either coefficient is asserted here.
-/
import Pairfield.GoldbachBoundary
import Mathlib.NumberTheory.Chebyshev
import Mathlib.Data.Finset.NatAntidiagonal

namespace Pairfield

open scoped ArithmeticFunction

noncomputable section

/-- The logarithmic prime weight, extended by zero away from primes. -/
def primeLogWeight (n : ℕ) : ℝ :=
  if n.Prime then Real.log n else 0

/-- The additive von-Mangoldt convolution coefficient at centre `N`. -/
def mangoldtGoldbachCoeff (N : ℕ) : ℝ :=
  ∑ pair ∈ Finset.HasAntidiagonal.antidiagonal N, Λ pair.1 * Λ pair.2

/-- The additive prime-log convolution coefficient at centre `N`. -/
def primeLogGoldbachCoeff (N : ℕ) : ℝ :=
  ∑ pair ∈ Finset.HasAntidiagonal.antidiagonal N,
    primeLogWeight pair.1 * primeLogWeight pair.2

/-- The exact contribution admitted by von Mangoldt but not by prime support. -/
def primePowerContamination (N : ℕ) : ℝ :=
  mangoldtGoldbachCoeff N - primeLogGoldbachCoeff N

/-- The pointwise von-Mangoldt mass not carried by primes. -/
def primePowerError (n : ℕ) : ℝ :=
  Λ n - primeLogWeight n

theorem primeLogWeight_nonneg (n : ℕ) : 0 ≤ primeLogWeight n := by
  by_cases hn : n.Prime
  · simp [primeLogWeight, hn, hn.log_pos.le]
  · simp [primeLogWeight, hn]

theorem primeLogWeight_pos_iff (n : ℕ) :
    0 < primeLogWeight n ↔ n.Prime := by
  by_cases hn : n.Prime
  · simp [primeLogWeight, hn, hn.log_pos]
  · simp [primeLogWeight, hn]

theorem primeLogWeight_le_vonMangoldt (n : ℕ) :
    primeLogWeight n ≤ Λ n := by
  by_cases hn : n.Prime
  · simp [primeLogWeight, hn, ArithmeticFunction.vonMangoldt_apply_prime hn]
  · simp [primeLogWeight, hn]

theorem primePowerError_nonneg (n : ℕ) : 0 ≤ primePowerError n := by
  exact sub_nonneg.mpr (primeLogWeight_le_vonMangoldt n)

theorem sum_primeLogWeight_Icc (N : ℕ) :
    (∑ n ∈ Finset.Icc 0 N, primeLogWeight n) = Chebyshev.theta N := by
  rw [Chebyshev.theta_eq_sum_Icc, Finset.sum_filter]
  simp [primeLogWeight]

theorem sum_vonMangoldt_Icc (N : ℕ) :
    (∑ n ∈ Finset.Icc 0 N, Λ n) = Chebyshev.psi N := by
  simpa using (Chebyshev.psi_eq_sum_Icc (N : ℝ)).symm

/-- The total pointwise error through `N` is exactly `ψ(N) - θ(N)`. -/
theorem sum_primePowerError_Icc (N : ℕ) :
    (∑ n ∈ Finset.Icc 0 N, primePowerError n) =
      Chebyshev.psi N - Chebyshev.theta N := by
  simp_rw [primePowerError, Finset.sum_sub_distrib]
  rw [sum_vonMangoldt_Icc, sum_primeLogWeight_Icc]

/-- A nonnegative antidiagonal convolution is bounded by its full square. -/
theorem sum_antidiagonal_mul_le_square (N : ℕ) (f g : ℕ → ℝ)
    (hf : ∀ n, 0 ≤ f n) (hg : ∀ n, 0 ≤ g n) :
    (∑ pair ∈ Finset.HasAntidiagonal.antidiagonal N, f pair.1 * g pair.2) ≤
      (∑ n ∈ Finset.Icc 0 N, f n) * (∑ n ∈ Finset.Icc 0 N, g n) := by
  have hsubset :
      Finset.HasAntidiagonal.antidiagonal N ⊆
        Finset.Icc 0 N ×ˢ Finset.Icc 0 N := by
    intro pair hpair
    have hsum : pair.1 + pair.2 = N :=
      Finset.HasAntidiagonal.mem_antidiagonal.mp hpair
    rw [Finset.mem_product]
    constructor <;> simp only [Finset.mem_Icc, Nat.zero_le, true_and] <;> omega
  calc
    (∑ pair ∈ Finset.HasAntidiagonal.antidiagonal N,
      f pair.1 * g pair.2) ≤
        ∑ pair ∈ Finset.Icc 0 N ×ˢ Finset.Icc 0 N,
          f pair.1 * g pair.2 := by
      exact Finset.sum_le_sum_of_subset_of_nonneg hsubset
        (fun pair _ _ ↦ mul_nonneg (hf pair.1) (hg pair.2))
    _ = ∑ i ∈ Finset.Icc 0 N, ∑ j ∈ Finset.Icc 0 N, f i * g j := by
      rw [Finset.sum_product]
    _ = (∑ n ∈ Finset.Icc 0 N, f n) *
        (∑ n ∈ Finset.Icc 0 N, g n) := by
      rw [Finset.sum_mul_sum]

theorem primeLogGoldbachCoeff_nonneg (N : ℕ) :
    0 ≤ primeLogGoldbachCoeff N := by
  exact Finset.sum_nonneg fun pair _ ↦
    mul_nonneg (primeLogWeight_nonneg pair.1) (primeLogWeight_nonneg pair.2)

/-- Positivity of the prime-log coefficient is exactly an actual prime-pair
witness.  The implication extracts a summand; it does not search for one. -/
theorem primeLogGoldbachCoeff_pos_iff (N : ℕ) :
    0 < primeLogGoldbachCoeff N ↔ GoldbachAt N := by
  rw [primeLogGoldbachCoeff,
    Finset.sum_pos_iff_of_nonneg (fun pair _ ↦
      mul_nonneg (primeLogWeight_nonneg pair.1) (primeLogWeight_nonneg pair.2))]
  constructor
  · rintro ⟨pair, hpair, hpositive⟩
    have hleft : 0 < primeLogWeight pair.1 := by
      exact lt_of_not_ge fun h ↦ by
        have : primeLogWeight pair.1 = 0 :=
          le_antisymm h (primeLogWeight_nonneg pair.1)
        simp [this] at hpositive
    have hright : 0 < primeLogWeight pair.2 := by
      exact lt_of_not_ge fun h ↦ by
        have : primeLogWeight pair.2 = 0 :=
          le_antisymm h (primeLogWeight_nonneg pair.2)
        simp [this] at hpositive
    apply (goldbachAt_iff_representation N).2
    exact ⟨pair.1, pair.2,
      (primeLogWeight_pos_iff pair.1).1 hleft,
      (primeLogWeight_pos_iff pair.2).1 hright,
      Finset.HasAntidiagonal.mem_antidiagonal.mp hpair⟩
  · intro hGoldbach
    rcases (goldbachAt_iff_representation N).1 hGoldbach with
      ⟨p, q, hp, hq, hsum⟩
    exact ⟨(p, q), Finset.HasAntidiagonal.mem_antidiagonal.mpr hsum,
      mul_pos ((primeLogWeight_pos_iff p).2 hp)
        ((primeLogWeight_pos_iff q).2 hq)⟩

/-- Removing prime-power-only support can only decrease the coefficient. -/
theorem primeLogGoldbachCoeff_le_mangoldtGoldbachCoeff (N : ℕ) :
    primeLogGoldbachCoeff N ≤ mangoldtGoldbachCoeff N := by
  unfold primeLogGoldbachCoeff mangoldtGoldbachCoeff
  apply Finset.sum_le_sum
  intro pair hpair
  exact mul_le_mul
    (primeLogWeight_le_vonMangoldt pair.1)
    (primeLogWeight_le_vonMangoldt pair.2)
    (primeLogWeight_nonneg pair.2)
    (ArithmeticFunction.vonMangoldt_nonneg (n := pair.1))

theorem primePowerContamination_nonneg (N : ℕ) :
    0 ≤ primePowerContamination N := by
  exact sub_nonneg.mpr (primeLogGoldbachCoeff_le_mangoldtGoldbachCoeff N)

/-- Exact decomposition of the contamination.  A pair is charged when its
right entry has prime-power error, or when its left entry has error while the
right entry has genuine prime support. -/
theorem primePowerContamination_eq_error_convolutions (N : ℕ) :
    primePowerContamination N =
      ∑ pair ∈ Finset.HasAntidiagonal.antidiagonal N,
        (Λ pair.1 * primePowerError pair.2 +
          primePowerError pair.1 * primeLogWeight pair.2) := by
  unfold primePowerContamination mangoldtGoldbachCoeff primeLogGoldbachCoeff
  rw [← Finset.sum_sub_distrib]
  apply Finset.sum_congr rfl
  intro pair _
  unfold primePowerError
  ring

/-- The exact contamination is at most twice the product of total Mangoldt
mass and total prime-power-only mass through the same horizon. -/
theorem primePowerContamination_le_two_mul_psi_mul_sub_theta (N : ℕ) :
    primePowerContamination N ≤
      2 * Chebyshev.psi N * (Chebyshev.psi N - Chebyshev.theta N) := by
  have hleft :
      (∑ pair ∈ Finset.HasAntidiagonal.antidiagonal N,
        Λ pair.1 * primePowerError pair.2) ≤
        Chebyshev.psi N * (Chebyshev.psi N - Chebyshev.theta N) := by
    simpa [sum_vonMangoldt_Icc, sum_primePowerError_Icc] using
      (sum_antidiagonal_mul_le_square N
        (fun n ↦ Λ n) primePowerError
        (fun n ↦ ArithmeticFunction.vonMangoldt_nonneg (n := n))
        primePowerError_nonneg)
  have hright :
      (∑ pair ∈ Finset.HasAntidiagonal.antidiagonal N,
        primePowerError pair.1 * primeLogWeight pair.2) ≤
        (Chebyshev.psi N - Chebyshev.theta N) * Chebyshev.theta N := by
    simpa [sum_primePowerError_Icc, sum_primeLogWeight_Icc] using
      (sum_antidiagonal_mul_le_square N
        primePowerError primeLogWeight
        primePowerError_nonneg primeLogWeight_nonneg)
  have herror : 0 ≤ Chebyshev.psi N - Chebyshev.theta N :=
    sub_nonneg.mpr (Chebyshev.theta_le_psi N)
  rw [primePowerContamination_eq_error_convolutions,
    Finset.sum_add_distrib]
  calc
    _ ≤ Chebyshev.psi N * (Chebyshev.psi N - Chebyshev.theta N) +
        (Chebyshev.psi N - Chebyshev.theta N) * Chebyshev.theta N :=
      add_le_add hleft hright
    _ ≤ Chebyshev.psi N * (Chebyshev.psi N - Chebyshev.theta N) +
        (Chebyshev.psi N - Chebyshev.theta N) * Chebyshev.psi N := by
      gcongr
      exact Chebyshev.theta_le_psi N
    _ = 2 * Chebyshev.psi N *
        (Chebyshev.psi N - Chebyshev.theta N) := by ring

/-- `psi_sub_theta_le` turns the exact obstruction into a checked but coarse
`O(psi(N) * sqrt(N) * log(N))` upper bound. -/
theorem primePowerContamination_le_four_mul_psi_mul_sqrt_mul_log
    (N : ℕ) (hN : 1 ≤ N) :
    primePowerContamination N ≤
      4 * Chebyshev.psi N * Real.sqrt N * Real.log N := by
  have hNreal : (1 : ℝ) ≤ N := by exact_mod_cast hN
  calc
    primePowerContamination N ≤
        2 * Chebyshev.psi N * (Chebyshev.psi N - Chebyshev.theta N) :=
      primePowerContamination_le_two_mul_psi_mul_sub_theta N
    _ ≤ 2 * Chebyshev.psi N * (2 * Real.sqrt N * Real.log N) := by
      gcongr
      exact Chebyshev.psi_sub_theta_le hNreal
    _ = 4 * Chebyshev.psi N * Real.sqrt N * Real.log N := by ring

/-- A completely explicit consequence of Chebyshev's linear upper bound for
`psi`.  Its `N^(3/2) log N` scale is too large to separate an expected
Goldbach main term of order `N`; the theorem records a rigorously checked
boundary, not progress on the missing lower bound. -/
theorem primePowerContamination_le_explicit (N : ℕ) (hN : 1 ≤ N) :
    primePowerContamination N ≤
      4 * (Real.log 4 + 4) * N * Real.sqrt N * Real.log N := by
  have hNreal : (1 : ℝ) ≤ N := by exact_mod_cast hN
  have hfactor : 0 ≤ 4 * Real.sqrt N * Real.log N := by
    positivity
  calc
    primePowerContamination N ≤
        4 * Chebyshev.psi N * Real.sqrt N * Real.log N :=
      primePowerContamination_le_four_mul_psi_mul_sqrt_mul_log N hN
    _ = Chebyshev.psi N * (4 * Real.sqrt N * Real.log N) := by ring
    _ ≤ ((Real.log 4 + 4) * N) *
        (4 * Real.sqrt N * Real.log N) := by
      exact mul_le_mul_of_nonneg_right
        (Chebyshev.psi_le_const_mul_self (by positivity)) hfactor
    _ = 4 * (Real.log 4 + 4) * N * Real.sqrt N * Real.log N := by ring

/-- A von-Mangoldt lower bound proves Goldbach only after it exceeds the exact
prime-power contamination at the same centre. -/
theorem goldbachAt_of_contamination_lt_mangoldtGoldbachCoeff (N : ℕ)
    (h : primePowerContamination N < mangoldtGoldbachCoeff N) :
    GoldbachAt N := by
  apply (primeLogGoldbachCoeff_pos_iff N).1
  unfold primePowerContamination at h
  linarith

/-- A fully explicit (but intentionally very demanding) sufficient condition:
if the Mangoldt coefficient exceeds the checked Chebyshev upper bound for all
prime-power contamination, then a genuine prime pair exists. -/
theorem goldbachAt_of_explicit_lt_mangoldtGoldbachCoeff
    (N : ℕ) (hN : 1 ≤ N)
    (h : 4 * (Real.log 4 + 4) * N * Real.sqrt N * Real.log N <
      mangoldtGoldbachCoeff N) :
    GoldbachAt N := by
  apply goldbachAt_of_contamination_lt_mangoldtGoldbachCoeff N
  exact lt_of_le_of_lt (primePowerContamination_le_explicit N hN) h

end

end Pairfield
