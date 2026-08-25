import Mathlib

/-!
# Passing a quantitative Goldbach-square error back to its positive root

This is the exact algebraic step behind the real-axis implication from an
estimate for `G(t) = A(t)^2` to the corresponding estimate for `A(t)`.  It
does not assert the analytic RH criterion; it only proves that positive
squaring loses no error scale beyond the factor `t`.
-/

namespace Pairfield.GoldbachSquareErrorTransfer

/-- If `A ≥ 0` and `t > 0`, an absolute error bound for `A²` around `t⁻²`
gives the corresponding root error with cost at most `t`. -/
theorem positiveRoot_error_le
    {A t E : ℝ} (hA : 0 ≤ A) (ht : 0 < t)
    (hsquare : |A * A - (1 / t) * (1 / t)| ≤ E) :
    |A - 1 / t| ≤ t * E := by
  have hinv : 0 < (1 / t : ℝ) := one_div_pos.mpr ht
  have hsum_nonneg : 0 ≤ A + 1 / t := by positivity
  have hsum_lower : 1 / t ≤ A + 1 / t := by linarith
  have hfactor :
      |A * A - (1 / t) * (1 / t)| =
        |A - 1 / t| * (A + 1 / t) := by
    have hid :
        A * A - (1 / t) * (1 / t) =
          (A - 1 / t) * (A + 1 / t) := by ring
    rw [hid, abs_mul, abs_of_nonneg hsum_nonneg]
  have hscaled : |A - 1 / t| * (1 / t) ≤ E := by
    calc
      |A - 1 / t| * (1 / t) ≤
          |A - 1 / t| * (A + 1 / t) :=
        mul_le_mul_of_nonneg_left hsum_lower (abs_nonneg _)
      _ = |A * A - (1 / t) * (1 / t)| := hfactor.symm
      _ ≤ E := hsquare
  have hmul := mul_le_mul_of_nonneg_left hscaled (le_of_lt ht)
  calc
    |A - 1 / t| = t * (|A - 1 / t| * (1 / t)) := by
      field_simp
    _ ≤ t * E := hmul

/-- Pointwise specialization with the exact Goldbach identity supplied as a
hypothesis. -/
theorem goldbachSquare_error_le
    {A G t E : ℝ} (hA : 0 ≤ A) (ht : 0 < t)
    (hG : G = A * A)
    (hbound : |G - (1 / t) * (1 / t)| ≤ E) :
    |A - 1 / t| ≤ t * E := by
  apply positiveRoot_error_le hA ht
  simpa [hG] using hbound

end Pairfield.GoldbachSquareErrorTransfer
