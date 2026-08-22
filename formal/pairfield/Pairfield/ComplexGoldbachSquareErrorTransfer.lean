/-
Copyright (c) 2026 Avik Jain and the mathematics collaboration.
Released under Apache 2.0 license.

The complex difference-of-squares estimate needs a quantitative lower bound
on the complementary factor.  This is the precise noncancellation seam for
recovering a complex Goldbach transform from its square.
-/
import Pairfield.GoldbachSquareErrorTransfer

namespace Pairfield.ComplexGoldbachSquareErrorTransfer

/-- A complex square estimate recovers the selected root whenever the other
linear factor is bounded away from zero. -/
theorem complexRoot_error_le
    {A z : ℂ} {E L : ℝ} (hL : 0 < L)
    (hsum : L ≤ ‖A + z⁻¹‖)
    (hsquare : ‖A ^ 2 - (z⁻¹) ^ 2‖ ≤ E) :
    ‖A - z⁻¹‖ ≤ E / L := by
  have hfactor :
      ‖A - z⁻¹‖ * ‖A + z⁻¹‖ =
        ‖A ^ 2 - (z⁻¹) ^ 2‖ := by
    rw [← norm_mul]
    congr 1
    ring
  have hproduct : ‖A - z⁻¹‖ * L ≤ E := by
    calc
      ‖A - z⁻¹‖ * L ≤
          ‖A - z⁻¹‖ * ‖A + z⁻¹‖ :=
        mul_le_mul_of_nonneg_left hsum (norm_nonneg _)
      _ = ‖A ^ 2 - (z⁻¹) ^ 2‖ := hfactor
      _ ≤ E := hsquare
  exact (le_div_iff₀ hL).2 hproduct

/-- On the positive real axis the complementary-factor lower bound is
automatic with `L = t⁻¹`; specializing the complex theorem recovers the
existing real estimate exactly. -/
theorem positiveRealRoot_error_le_via_complex
    {A t E : ℝ} (hA : 0 ≤ A) (ht : 0 < t)
    (hsquare : |A * A - (1 / t) * (1 / t)| ≤ E) :
    |A - 1 / t| ≤ t * E := by
  have hinv_pos : 0 < (1 / t : ℝ) := one_div_pos.mpr ht
  have hsum_nonneg : 0 ≤ A + 1 / t := add_nonneg hA hinv_pos.le
  have hsum_nonneg' : 0 ≤ A + t⁻¹ := by
    simpa only [one_div] using hsum_nonneg
  have hsum_complex :
      1 / t ≤ ‖(A : ℂ) + (t : ℂ)⁻¹‖ := by
    rw [← Complex.ofReal_inv, ← Complex.ofReal_add, Complex.norm_real,
      Real.norm_eq_abs, abs_of_nonneg hsum_nonneg']
    simpa only [one_div] using (le_add_of_nonneg_left hA : t⁻¹ ≤ A + t⁻¹)
  have hsquare_complex :
      ‖(A : ℂ) ^ 2 - ((t : ℂ)⁻¹) ^ 2‖ ≤ E := by
    rw [← Complex.ofReal_inv, ← Complex.ofReal_pow,
      ← Complex.ofReal_pow, ← Complex.ofReal_sub, Complex.norm_real,
      Real.norm_eq_abs]
    simpa only [pow_two, one_div] using hsquare
  have hcomplex := complexRoot_error_le
    (A := (A : ℂ)) (z := (t : ℂ))
    (E := E) (L := 1 / t) hinv_pos hsum_complex hsquare_complex
  calc
    |A - 1 / t| = ‖(A : ℂ) - (t : ℂ)⁻¹‖ := by
      rw [← Complex.ofReal_inv, ← Complex.ofReal_sub,
        Complex.norm_real, Real.norm_eq_abs]
      simp only [one_div]
    _ ≤ E / (1 / t) := hcomplex
    _ = t * E := by field_simp

/-- Compatibility with the pre-existing real theorem: the complex
specialization and the direct positive-root argument have the same statement. -/
theorem positiveRealRoot_error_compatible
    {A t E : ℝ} (hA : 0 ≤ A) (ht : 0 < t)
    (hsquare : |A * A - (1 / t) * (1 / t)| ≤ E) :
    |A - 1 / t| ≤ t * E :=
  positiveRealRoot_error_le_via_complex hA ht hsquare

end Pairfield.ComplexGoldbachSquareErrorTransfer
