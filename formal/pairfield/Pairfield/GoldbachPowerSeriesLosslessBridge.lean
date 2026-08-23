/-
Copyright (c) 2026 Avik Jain and the mathematics collaboration.
Released under Apache 2.0 license.

The coefficientwise bridge between additive convolution squares of arbitrary
sequences and multiplication in formal power series.  No convergence or
finite-support hypothesis is used.
-/
import Pairfield.GoldbachPowerSeriesRigidity
import Pairfield.GoldbachTriangularReconstruction

namespace Pairfield.GoldbachPowerSeriesLosslessBridge

/-- Multiplication of two formal series created from arbitrary sequences is
exactly their finite additive convolution at every coefficient. -/
theorem coeff_mk_mul_mk {R : Type*} [CommSemiring R]
    (a b : ℕ → R) (N : ℕ) :
    PowerSeries.coeff N (PowerSeries.mk a * PowerSeries.mk b) =
      ∑ pair ∈ Finset.HasAntidiagonal.antidiagonal N,
        a pair.1 * b pair.2 := by
  simp only [PowerSeries.coeff_mul, PowerSeries.coeff_mk]

/-- In particular, the coefficient of the formal square is the existing
`additiveSquareCoeff` of the sequence. -/
theorem coeff_mk_square_eq_additiveSquareCoeff
    {R : Type*} [CommSemiring R] (a : ℕ → R) (N : ℕ) :
    PowerSeries.coeff N (PowerSeries.mk a * PowerSeries.mk a) =
      Pairfield.additiveSquareCoeff a N := by
  exact coeff_mk_mul_mk a a N

/-- Equality of every additive-square coefficient determines arbitrary real
sequences once both distinguished coefficients at index two are positive.
There is no finite-support, convergence, or vanishing-at-zero assumption. -/
theorem sequence_eq_of_all_additiveSquareCoeff_eq_of_positive_two
    (a b : ℕ → ℝ)
    (ha : 0 < a 2) (hb : 0 < b 2)
    (hcoeff : ∀ N, Pairfield.additiveSquareCoeff a N =
      Pairfield.additiveSquareCoeff b N) :
    a = b := by
  have hsquare :
      PowerSeries.mk a * PowerSeries.mk a =
        PowerSeries.mk b * PowerSeries.mk b := by
    ext N
    rw [coeff_mk_square_eq_additiveSquareCoeff,
      coeff_mk_square_eq_additiveSquareCoeff]
    exact hcoeff N
  have hseries : PowerSeries.mk a = PowerSeries.mk b :=
    Pairfield.GoldbachPowerSeriesRigidity.square_injective_of_positive_coeff_two
      (PowerSeries.mk a) (PowerSeries.mk b)
      (by simpa only [PowerSeries.coeff_mk] using ha)
      (by simpa only [PowerSeries.coeff_mk] using hb)
      hsquare
  funext N
  have hN := congrArg (PowerSeries.coeff N) hseries
  simpa only [PowerSeries.coeff_mk] using hN

/-- Losslessness stated as an equivalence on the positive-index-two region. -/
theorem all_additiveSquareCoeff_eq_iff
    (a b : ℕ → ℝ) (ha : 0 < a 2) (hb : 0 < b 2) :
    (∀ N, Pairfield.additiveSquareCoeff a N =
      Pairfield.additiveSquareCoeff b N) ↔ a = b := by
  constructor
  · exact sequence_eq_of_all_additiveSquareCoeff_eq_of_positive_two a b ha hb
  · rintro rfl
    exact fun _ ↦ rfl

end Pairfield.GoldbachPowerSeriesLosslessBridge
