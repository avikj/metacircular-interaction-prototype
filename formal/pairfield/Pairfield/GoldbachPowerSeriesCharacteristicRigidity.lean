/-
Copyright (c) 2026 Avik Jain and the mathematics collaboration.
Released under Apache 2.0 license.

Square-root rigidity for formal power series over an arbitrary integral domain
of characteristic different from two, and its coefficientwise Goldbach
convolution consequence over the complex numbers.
-/
import Pairfield.GoldbachPowerSeriesLosslessBridge

namespace Pairfield.GoldbachPowerSeriesCharacteristicRigidity

/-- In an integral domain of characteristic different from two, equality of
formal-series squares and one common nonzero coefficient fix the sign of the
square root.  The distinguished coefficient may occur at any index. -/
theorem square_injective_of_same_nonzero_coeff
    {R : Type*} [CommRing R] [IsDomain R] [NeZero (2 : R)]
    (k : ℕ) (A B : PowerSeries R)
    (hcoeff : PowerSeries.coeff k A = PowerSeries.coeff k B)
    (hne : PowerSeries.coeff k A ≠ 0)
    (hsquare : A * A = B * B) :
    A = B := by
  rcases mul_self_eq_mul_self_iff.mp hsquare with equal | opposite
  · exact equal
  · have hneg := congrArg (PowerSeries.coeff k) opposite
    simp only [map_neg] at hneg
    rw [← hcoeff] at hneg
    have htwo : (2 : R) * PowerSeries.coeff k A = 0 := by
      rw [two_mul, add_eq_zero_iff_eq_neg]
      exact hneg
    exact False.elim (hne ((mul_eq_zero.mp htwo).resolve_left two_ne_zero))

/-- Equality of all additive convolution-square coefficients determines two
arbitrary complex sequences as soon as their coefficients at index two agree
and this common coefficient is nonzero.  No support, convergence, positivity,
or vanishing-at-small-indices hypothesis is required. -/
theorem complex_sequence_eq_of_all_additiveSquareCoeff_eq_of_same_nonzero_two
    (a b : ℕ → ℂ)
    (htwo : a 2 = b 2)
    (hne : a 2 ≠ 0)
    (hcoeff : ∀ N, Pairfield.additiveSquareCoeff a N =
      Pairfield.additiveSquareCoeff b N) :
    a = b := by
  have hsquare :
      PowerSeries.mk a * PowerSeries.mk a =
        PowerSeries.mk b * PowerSeries.mk b := by
    ext N
    rw [Pairfield.GoldbachPowerSeriesLosslessBridge.coeff_mk_square_eq_additiveSquareCoeff,
      Pairfield.GoldbachPowerSeriesLosslessBridge.coeff_mk_square_eq_additiveSquareCoeff]
    exact hcoeff N
  have hseries : PowerSeries.mk a = PowerSeries.mk b :=
    square_injective_of_same_nonzero_coeff 2 (PowerSeries.mk a) (PowerSeries.mk b)
      (by simpa only [PowerSeries.coeff_mk] using htwo)
      (by simpa only [PowerSeries.coeff_mk] using hne)
      hsquare
  funext N
  have hN := congrArg (PowerSeries.coeff N) hseries
  simpa only [PowerSeries.coeff_mk] using hN

end Pairfield.GoldbachPowerSeriesCharacteristicRigidity
