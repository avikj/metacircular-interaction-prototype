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
  ∑ pair ∈ Finset.antidiagonal N, Λ pair.1 * Λ pair.2

/-- The additive prime-log convolution coefficient at centre `N`. -/
def primeLogGoldbachCoeff (N : ℕ) : ℝ :=
  ∑ pair ∈ Finset.antidiagonal N,
    primeLogWeight pair.1 * primeLogWeight pair.2

/-- The exact contribution admitted by von Mangoldt but not by prime support. -/
def primePowerContamination (N : ℕ) : ℝ :=
  mangoldtGoldbachCoeff N - primeLogGoldbachCoeff N

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
  · simpa [primeLogWeight, hn] using
      (ArithmeticFunction.vonMangoldt_nonneg (n := n))

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
      Finset.mem_antidiagonal.mp hpair⟩
  · intro hGoldbach
    rcases (goldbachAt_iff_representation N).1 hGoldbach with
      ⟨p, q, hp, hq, hsum⟩
    exact ⟨(p, q), Finset.mem_antidiagonal.mpr hsum,
      mul_pos ((primeLogWeight_pos_iff p).2 hp)
        ((primeLogWeight_pos_iff q).2 hq)⟩

/-- Removing prime-power-only support can only decrease the coefficient. -/
theorem primeLogGoldbachCoeff_le_mangoldtGoldbachCoeff (N : ℕ) :
    primeLogGoldbachCoeff N ≤ mangoldtGoldbachCoeff N := by
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

/-- A von-Mangoldt lower bound proves Goldbach only after it exceeds the exact
prime-power contamination at the same centre. -/
theorem goldbachAt_of_contamination_lt_mangoldtGoldbachCoeff (N : ℕ)
    (h : primePowerContamination N < mangoldtGoldbachCoeff N) :
    GoldbachAt N := by
  apply (primeLogGoldbachCoeff_pos_iff N).1
  unfold primePowerContamination at h
  linarith

end

end Pairfield
