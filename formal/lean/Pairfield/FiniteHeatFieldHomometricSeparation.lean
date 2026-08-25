import Pairfield.FiniteLaplaceUniqueness
import Pairfield.FixedScaleAutocorrelationAmbiguity

/-!
# Concrete finite all-scale heat-field reconstruction

For a finitely supported nonnegative real signal `a`, the zero-gap heat field
is the finite exponential sum

`H_a(t) = ∑ n, a(n)^2 exp(-2 n t)`.

Finite Laplace uniqueness proves directly that equality of these fields at
every positive scale forces equality of the signals.  Applying this to the
checked homometric pair gives an actual all-scale separation theorem with no
abstract coefficient-uniqueness premise.
-/

namespace Pairfield.FiniteHeatFieldHomometricSeparation

open FiniteLaplaceUniqueness
open FixedScaleAutocorrelationAmbiguity

noncomputable section

/-- The finitely supported complex diagonal-energy coefficients `a(n)^2`. -/
def squaredCoefficients (signal : ℕ →₀ ℝ) : ℕ →₀ ℂ :=
  Finsupp.mapRange (fun value : ℝ ↦ ((value * value : ℝ) : ℂ))
    (by norm_num) signal

@[simp] theorem squaredCoefficients_apply (signal : ℕ →₀ ℝ) (n : ℕ) :
    squaredCoefficients signal n = ((signal n * signal n : ℝ) : ℂ) := by
  simp [squaredCoefficients]

/-- The actual finite zero-gap heat field.  The parameter `2*t` in the
Laplace transform gives the weight `exp(-2*n*t)` at index `n`. -/
def finiteHeatField (signal : ℕ →₀ ℝ) (t : ℝ) : ℂ :=
  finiteLaplace (squaredCoefficients signal) (2 * t)

/-- The polynomial definition is exactly the expected finite exponential
sum. -/
theorem finiteHeatField_eq_finsupp_sum (signal : ℕ →₀ ℝ) (t : ℝ) :
    finiteHeatField signal t =
      signal.sum fun n value ↦
        ((value * value : ℝ) : ℂ) * (Real.exp (-2 * t) : ℂ) ^ n := by
  simp only [finiteHeatField, finiteLaplace, coefficientPolynomial,
    Polynomial.eval_eq_sum, Polynomial.sum_def,
    Polynomial.toFinsuppIso_symm_apply,
    Polynomial.support_ofFinsupp, Polynomial.coeff_ofFinsupp]
  change (squaredCoefficients signal).sum
      (fun n value ↦ value * (Real.exp (-(2 * t)) : ℂ) ^ n) = _
  rw [squaredCoefficients,
    Finsupp.sum_mapRange_index (fun _ ↦ by simp)]
  congr 1
  funext n value
  simp only [Complex.ofReal_mul]
  congr 2
  congr 1
  simp only [neg_mul]

/-- Equality of actual heat fields at every positive scale determines every
nonnegative finitely supported signal. -/
theorem finiteHeatField_injectiveOn_nonnegative
    (left right : ℕ →₀ ℝ)
    (leftNonnegative : ∀ n, 0 ≤ left n)
    (rightNonnegative : ∀ n, 0 ≤ right n)
    (fieldAgreement : ∀ t : ℝ, 0 < t →
      finiteHeatField left t = finiteHeatField right t) :
    left = right := by
  have squareAgreement : squaredCoefficients left = squaredCoefficients right := by
    apply finsupp_eq_of_finiteLaplace_eq
    intro scale scalePositive
    have halfPositive : 0 < scale / 2 := half_pos scalePositive
    have twiceHalf : 2 * (scale / 2) = scale := by ring
    simpa only [finiteHeatField, twiceHalf] using
      fieldAgreement (scale / 2) halfPositive
  apply Finsupp.ext
  intro n
  have coefficientAgreement := congrArg (fun coefficients : ℕ →₀ ℂ ↦
    coefficients n) squareAgreement
  simp only [squaredCoefficients_apply] at coefficientAgreement
  have realSquareAgreement : left n * left n = right n * right n :=
    Complex.ofReal_injective coefficientAgreement
  rcases mul_self_eq_mul_self_iff.mp realSquareAgreement with equal | opposite
  · exact equal
  · nlinarith [leftNonnegative n, rightNonnegative n]

/-- The first support `{0,1,2,6,8,11}` as a nonnegative real Finsupp. -/
def firstFiniteSignal : ℕ →₀ ℝ :=
  Finsupp.single 0 1 + Finsupp.single 1 1 + Finsupp.single 2 1 +
    Finsupp.single 6 1 + Finsupp.single 8 1 + Finsupp.single 11 1

/-- The second support `{0,1,6,7,9,11}` as a nonnegative real Finsupp. -/
def secondFiniteSignal : ℕ →₀ ℝ :=
  Finsupp.single 0 1 + Finsupp.single 1 1 + Finsupp.single 6 1 +
    Finsupp.single 7 1 + Finsupp.single 9 1 + Finsupp.single 11 1

theorem firstFiniteSignal_nonnegative (n : ℕ) : 0 ≤ firstFiniteSignal n := by
  simp only [firstFiniteSignal, Finsupp.add_apply, Finsupp.single_apply]
  split_ifs <;> norm_num

theorem secondFiniteSignal_nonnegative (n : ℕ) : 0 ≤ secondFiniteSignal n := by
  simp only [secondFiniteSignal, Finsupp.add_apply, Finsupp.single_apply]
  split_ifs <;> norm_num

theorem firstFiniteSignal_ne_secondFiniteSignal :
    firstFiniteSignal ≠ secondFiniteSignal := by
  intro equal
  have atTwo := congrArg (fun signal : ℕ →₀ ℝ ↦ signal 2) equal
  norm_num [firstFiniteSignal, secondFiniteSignal] at atTwo

/-- The explicit homometric pair has distinct actual all-scale heat fields. -/
theorem homometric_heatFields_ne :
    finiteHeatField firstFiniteSignal ≠ finiteHeatField secondFiniteSignal := by
  intro fieldsEqual
  apply firstFiniteSignal_ne_secondFiniteSignal
  apply finiteHeatField_injectiveOn_nonnegative
    firstFiniteSignal secondFiniteSignal
    firstFiniteSignal_nonnegative secondFiniteSignal_nonnegative
  intro t ht
  exact congrFun fieldsEqual t

/-- **Concrete fixed-scale/all-scale contrast.**  The pair has identical
complete fixed-scale cyclic autocorrelation, but its genuine finite heat
fields are different. -/
theorem homometric_fixedScale_equal_allScale_heatField_distinct :
    cyclicAutocorrelation firstSignal = cyclicAutocorrelation secondSignal ∧
      finiteHeatField firstFiniteSignal ≠
        finiteHeatField secondFiniteSignal :=
  ⟨first_second_same_cyclicAutocorrelation, homometric_heatFields_ne⟩

end

end Pairfield.FiniteHeatFieldHomometricSeparation
