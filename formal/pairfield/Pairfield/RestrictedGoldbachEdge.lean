/-
Copyright (c) 2026 Avik Jain and the mathematics collaboration.
Released under Apache 2.0 license.

The exact finite boundary for the lower-truncated prime-log carrier used in
the common-carrier Goldbach decomposition.  Positivity is precisely a pair of
primes above the declared lower cutoff.  A von-Mangoldt version sees proper
prime powers; its restricted contamination is bounded by the already checked
full-antidiagonal contamination.

No positivity or density estimate is asserted.
-/
import Pairfield.GoldbachFixedFiberContamination

namespace Pairfield

open scoped ArithmeticFunction

noncomputable section

/-- A Goldbach representation whose two primes both lie above `L`. -/
def RestrictedGoldbachAt (L N : ℕ) : Prop :=
  ∃ p q : ℕ, p.Prime ∧ q.Prime ∧ L < p ∧ L < q ∧ p + q = N

/-- The prime-log coefficient on the part of the antidiagonal above `L` in
both coordinates. -/
def restrictedPrimeLogGoldbachCoeff (L N : ℕ) : ℝ :=
  ∑ pair ∈ (Finset.HasAntidiagonal.antidiagonal N).filter
      (fun pair ↦ L < pair.1 ∧ L < pair.2),
    primeLogWeight pair.1 * primeLogWeight pair.2

/-- The matching lower-truncated von-Mangoldt coefficient. -/
def restrictedMangoldtGoldbachCoeff (L N : ℕ) : ℝ :=
  ∑ pair ∈ (Finset.HasAntidiagonal.antidiagonal N).filter
      (fun pair ↦ L < pair.1 ∧ L < pair.2),
    Λ pair.1 * Λ pair.2

/-- Proper-prime-power mass remaining on the restricted antidiagonal. -/
def restrictedPrimePowerContamination (L N : ℕ) : ℝ :=
  restrictedMangoldtGoldbachCoeff L N -
    restrictedPrimeLogGoldbachCoeff L N

theorem restrictedPrimeLogGoldbachCoeff_nonneg (L N : ℕ) :
    0 ≤ restrictedPrimeLogGoldbachCoeff L N := by
  unfold restrictedPrimeLogGoldbachCoeff
  exact Finset.sum_nonneg fun pair _ ↦
    mul_nonneg (primeLogWeight_nonneg pair.1)
      (primeLogWeight_nonneg pair.2)

/-- Exact support theorem for the lower-truncated carrier. -/
theorem restrictedPrimeLogGoldbachCoeff_pos_iff (L N : ℕ) :
    0 < restrictedPrimeLogGoldbachCoeff L N ↔ RestrictedGoldbachAt L N := by
  rw [restrictedPrimeLogGoldbachCoeff,
    Finset.sum_pos_iff_of_nonneg (fun pair _ ↦
      mul_nonneg (primeLogWeight_nonneg pair.1)
        (primeLogWeight_nonneg pair.2))]
  constructor
  · rintro ⟨pair, hpair, hpositive⟩
    rcases Finset.mem_filter.mp hpair with ⟨hanti, hlower⟩
    have hleft : 0 < primeLogWeight pair.1 := by
      exact lt_of_not_ge fun h ↦ by
        have hz : primeLogWeight pair.1 = 0 :=
          le_antisymm h (primeLogWeight_nonneg pair.1)
        simp [hz] at hpositive
    have hright : 0 < primeLogWeight pair.2 := by
      exact lt_of_not_ge fun h ↦ by
        have hz : primeLogWeight pair.2 = 0 :=
          le_antisymm h (primeLogWeight_nonneg pair.2)
        simp [hz] at hpositive
    exact ⟨pair.1, pair.2,
      (primeLogWeight_pos_iff pair.1).1 hleft,
      (primeLogWeight_pos_iff pair.2).1 hright,
      hlower.1, hlower.2,
      Finset.HasAntidiagonal.mem_antidiagonal.mp hanti⟩
  · rintro ⟨p, q, hp, hq, hpL, hqL, hsum⟩
    exact ⟨(p, q), Finset.mem_filter.mpr
      ⟨Finset.HasAntidiagonal.mem_antidiagonal.mpr hsum, hpL, hqL⟩,
      mul_pos ((primeLogWeight_pos_iff p).2 hp)
        ((primeLogWeight_pos_iff q).2 hq)⟩

/-- An abstract exact major/minor decomposition has positive edge precisely
when the restricted prime-pair fiber is inhabited. -/
theorem restrictedMinor_gt_neg_major_iff
    (L N : ℕ) (major minor : ℝ)
    (hdecomp : restrictedPrimeLogGoldbachCoeff L N = major + minor) :
    -major < minor ↔ RestrictedGoldbachAt L N := by
  rw [← restrictedPrimeLogGoldbachCoeff_pos_iff]
  rw [hdecomp]
  constructor <;> intro h <;> linarith

/-- If the major term is retained only as `main + error`, domination of the
absolute error is the sign-robust sufficient edge condition. -/
theorem restrictedGoldbachAt_of_abs_majorError_lt
    (L N : ℕ) (major minor main error : ℝ)
    (hdecomp : restrictedPrimeLogGoldbachCoeff L N = major + minor)
    (hmajor : major = main + error)
    (hmargin : |error| < minor + main) :
    RestrictedGoldbachAt L N := by
  apply (restrictedPrimeLogGoldbachCoeff_pos_iff L N).1
  rw [hdecomp, hmajor]
  have herr := neg_abs_le error
  linarith

theorem restrictedPrimeLogGoldbachCoeff_le_mangoldt
    (L N : ℕ) :
    restrictedPrimeLogGoldbachCoeff L N ≤
      restrictedMangoldtGoldbachCoeff L N := by
  unfold restrictedPrimeLogGoldbachCoeff restrictedMangoldtGoldbachCoeff
  apply Finset.sum_le_sum
  intro pair hpair
  exact mul_le_mul
    (primeLogWeight_le_vonMangoldt pair.1)
    (primeLogWeight_le_vonMangoldt pair.2)
    (primeLogWeight_nonneg pair.2)
    (ArithmeticFunction.vonMangoldt_nonneg (n := pair.1))

theorem restrictedPrimePowerContamination_nonneg (L N : ℕ) :
    0 ≤ restrictedPrimePowerContamination L N := by
  exact sub_nonneg.mpr (restrictedPrimeLogGoldbachCoeff_le_mangoldt L N)

/-- Restricting both legs can only remove nonnegative prime-power
contamination from the full antidiagonal. -/
theorem restrictedPrimePowerContamination_le
    (L N : ℕ) :
    restrictedPrimePowerContamination L N ≤
      primePowerContamination N := by
  rw [restrictedPrimePowerContamination, primePowerContamination,
    restrictedMangoldtGoldbachCoeff, restrictedPrimeLogGoldbachCoeff,
    mangoldtGoldbachCoeff, primeLogGoldbachCoeff,
    ← Finset.sum_sub_distrib, ← Finset.sum_sub_distrib]
  apply Finset.sum_le_sum_of_subset_of_nonneg (Finset.filter_subset _ _)
  intro pair hpair _
  exact sub_nonneg.mpr <| mul_le_mul
    (primeLogWeight_le_vonMangoldt pair.1)
    (primeLogWeight_le_vonMangoldt pair.2)
    (primeLogWeight_nonneg pair.2)
    (ArithmeticFunction.vonMangoldt_nonneg (n := pair.1))

theorem restrictedPrimePowerContamination_le_four_sqrt_mul_log_sq
    (L N : ℕ) (hN : 1 ≤ N) :
    restrictedPrimePowerContamination L N ≤
      4 * Real.sqrt (N : ℝ) * (Real.log (N : ℝ)) ^ 2 := by
  exact (restrictedPrimePowerContamination_le L N).trans
    (primePowerContamination_le_four_sqrt_mul_log_sq N hN)

/-- Exact restricted conversion: a lower bound for the Mangoldt coefficient
proves a lower-truncated prime pair only after exceeding the contamination on
that same restricted fiber. -/
theorem restrictedGoldbachAt_of_contamination_lt_mangoldt
    (L N : ℕ)
    (h : restrictedPrimePowerContamination L N <
      restrictedMangoldtGoldbachCoeff L N) :
    RestrictedGoldbachAt L N := by
  apply (restrictedPrimeLogGoldbachCoeff_pos_iff L N).1
  unfold restrictedPrimePowerContamination at h
  linarith

/-- The exact-contamination condition is again terminal semantics: it is
equivalent to positivity of the restricted prime-log coefficient. -/
theorem restricted_contamination_lt_mangoldt_iff (L N : ℕ) :
    restrictedPrimePowerContamination L N <
      restrictedMangoldtGoldbachCoeff L N ↔
        RestrictedGoldbachAt L N := by
  constructor
  · exact restrictedGoldbachAt_of_contamination_lt_mangoldt L N
  · intro hGoldbach
    have hpositive : 0 < restrictedPrimeLogGoldbachCoeff L N :=
      (restrictedPrimeLogGoldbachCoeff_pos_iff L N).2 hGoldbach
    unfold restrictedPrimePowerContamination
    linarith

end

end Pairfield
