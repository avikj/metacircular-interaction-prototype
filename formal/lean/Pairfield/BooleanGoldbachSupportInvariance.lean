/-
Copyright (c) 2026 Avik Jain and the mathematics collaboration.
Released under Apache 2.0 license.

For nonnegative real sequences, Boolean positivity of additive convolution
depends only on the pointwise positive support, not on coefficient magnitudes.
-/
import Pairfield.BooleanGoldbachInformationLoss

namespace Pairfield.BooleanGoldbachSupportInvariance

open Pairfield.BooleanGoldbachInformationLoss

/-- A nonnegative additive-square coefficient is positive exactly when its
finite antidiagonal contains a pair of positive endpoint coefficients. -/
theorem positivitySupport_iff_exists_positive_pair
    (a : ℕ → ℝ) (ha : ∀ n, 0 ≤ a n) (N : ℕ) :
    positivitySupport a N ↔
      ∃ pair ∈ Finset.HasAntidiagonal.antidiagonal N,
        0 < a pair.1 ∧ 0 < a pair.2 := by
  unfold positivitySupport Pairfield.additiveSquareCoeff
  rw [Finset.sum_pos_iff_of_nonneg
    (fun pair _ ↦ mul_nonneg (ha pair.1) (ha pair.2))]
  constructor
  · rintro ⟨pair, hpair, hproduct⟩
    exact ⟨pair, hpair,
      pos_of_mul_pos_left hproduct (ha pair.2),
      pos_of_mul_pos_right hproduct (ha pair.1)⟩
  · rintro ⟨pair, hpair, hleft, hright⟩
    exact ⟨pair, hpair, mul_pos hleft hright⟩

/-- Pointwise equality of positive supports forces equality of every Boolean
Goldbach coefficient.  No finite-support hypothesis is needed because each
antidiagonal is finite. -/
theorem positivitySupport_iff_of_pointwise_positiveSupport_iff
    (a b : ℕ → ℝ)
    (ha : ∀ n, 0 ≤ a n) (hb : ∀ n, 0 ≤ b n)
    (hsupport : ∀ n, 0 < a n ↔ 0 < b n) (N : ℕ) :
    positivitySupport a N ↔ positivitySupport b N := by
  rw [positivitySupport_iff_exists_positive_pair a ha N,
    positivitySupport_iff_exists_positive_pair b hb N]
  constructor
  · rintro ⟨pair, hpair, hleft, hright⟩
    exact ⟨pair, hpair, (hsupport pair.1).mp hleft,
      (hsupport pair.2).mp hright⟩
  · rintro ⟨pair, hpair, hleft, hright⟩
    exact ⟨pair, hpair, (hsupport pair.1).mpr hleft,
      (hsupport pair.2).mpr hright⟩

/-- Functional form: the entire Boolean convolution-support sequence factors
through the pointwise positive-support predicate. -/
theorem positivitySupport_eq_of_pointwise_positiveSupport_iff
    (a b : ℕ → ℝ)
    (ha : ∀ n, 0 ≤ a n) (hb : ∀ n, 0 ≤ b n)
    (hsupport : ∀ n, 0 < a n ↔ 0 < b n) :
    positivitySupport a = positivitySupport b := by
  funext N
  exact propext
    (positivitySupport_iff_of_pointwise_positiveSupport_iff
      a b ha hb hsupport N)

end Pairfield.BooleanGoldbachSupportInvariance
