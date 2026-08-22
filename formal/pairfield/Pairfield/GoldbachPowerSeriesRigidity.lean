import Mathlib

/-!
# Goldbach convolution is lossless as a formal power series

This is the infinite-series counterpart of the finite-polynomial theorem in
`Pairfield.SumRigidity`.  A square in `ℝ⟦q⟧` has only the two algebraic square
roots `A` and `-A`; positivity of the known coefficient at `q²` fixes the
sign.  No convergence or finite-support hypothesis is used.
-/

namespace Pairfield.GoldbachPowerSeriesRigidity

open PowerSeries

/-- Equality of formal Goldbach convolution squares, together with a positive
`q²` coefficient on both candidate roots, determines the entire series. -/
theorem square_injective_of_positive_coeff_two
    (A B : PowerSeries ℝ)
    (hA : 0 < PowerSeries.coeff 2 A)
    (hB : 0 < PowerSeries.coeff 2 B)
    (hsq : A * A = B * B) :
    A = B := by
  rcases mul_self_eq_mul_self_iff.mp hsq with h | h
  · exact h
  · have hc := congrArg (PowerSeries.coeff 2) h
    simp only [map_neg] at hc
    linarith

/-- Equivalent sign-fixing form: a common nonzero `q²` coefficient rules out
the negative square root. -/
theorem square_injective_of_same_nonzero_coeff_two
    (A B : PowerSeries ℝ)
    (hlead : PowerSeries.coeff 2 A = PowerSeries.coeff 2 B)
    (hne : PowerSeries.coeff 2 A ≠ 0)
    (hsq : A * A = B * B) :
    A = B := by
  rcases mul_self_eq_mul_self_iff.mp hsq with h | h
  · exact h
  · have hc := congrArg (PowerSeries.coeff 2) h
    simp only [map_neg] at hc
    rw [← hlead] at hc
    exfalso
    apply hne
    linarith

/-- The precise losslessness statement: the squaring map is injective on the
formal-series region whose distinguished `q²` coefficient is positive. -/
theorem goldbach_square_lossless
    {A B : PowerSeries ℝ}
    (hA : 0 < PowerSeries.coeff 2 A)
    (hB : 0 < PowerSeries.coeff 2 B) :
    A * A = B * B ↔ A = B := by
  constructor
  · exact square_injective_of_positive_coeff_two A B hA hB
  · intro h
    rw [h]

end Pairfield.GoldbachPowerSeriesRigidity
