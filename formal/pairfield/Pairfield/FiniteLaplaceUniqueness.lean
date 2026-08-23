import Mathlib.Algebra.Polynomial.Roots
import Mathlib.Analysis.SpecialFunctions.Log.Basic
import Mathlib.Order.Interval.Set.Infinite

/-!
# Finite Laplace uniqueness from infinite-root rigidity

A polynomial over `ℝ` or `ℂ` is determined by its values at every real
`q ∈ (0,1)`.  Reparametrizing `q = exp (-t)` shows that a finitely supported
coefficient sequence is determined by its Laplace values at every `t > 0`.

This is the finite-support analytic core of all-scale reconstruction; no
infinite-series convergence or measure-theoretic uniqueness theorem is used.
-/

namespace Pairfield.FiniteLaplaceUniqueness

open Set Polynomial

noncomputable section

/-- Real polynomials agreeing throughout `(0,1)` are equal. -/
theorem real_polynomial_eq_of_eq_on_open_unit_interval
    (left right : ℝ[X])
    (agreement : ∀ q : ℝ, q ∈ Set.Ioo 0 1 →
      left.eval q = right.eval q) :
    left = right := by
  apply Polynomial.eq_of_infinite_eval_eq left right
  exact (Set.Ioo_infinite (show (0 : ℝ) < 1 by norm_num)).mono
    (fun q hq ↦ agreement q hq)

/-- Complex polynomials are already determined by agreement on the real
subinterval `(0,1)`. -/
theorem complex_polynomial_eq_of_eq_on_open_unit_interval
    (left right : ℂ[X])
    (agreement : ∀ q : ℝ, q ∈ Set.Ioo 0 1 →
      left.eval (q : ℂ) = right.eval (q : ℂ)) :
    left = right := by
  apply Polynomial.eq_of_infinite_eval_eq left right
  have intervalInfinite : (Set.Ioo (0 : ℝ) 1).Infinite :=
    Set.Ioo_infinite (by norm_num)
  have imageInfinite :
      (((fun q : ℝ ↦ (q : ℂ)) '' Set.Ioo 0 1)).Infinite :=
    intervalInfinite.image Complex.ofReal_injective.injOn
  exact imageInfinite.mono (by
    rintro z ⟨q, hq, rfl⟩
    exact agreement q hq)

/-- Equality at every positive Laplace scale determines a real polynomial. -/
theorem real_polynomial_eq_of_eval_exp_neg_eq
    (left right : ℝ[X])
    (agreement : ∀ t : ℝ, 0 < t →
      left.eval (Real.exp (-t)) = right.eval (Real.exp (-t))) :
    left = right := by
  apply real_polynomial_eq_of_eq_on_open_unit_interval left right
  intro q hq
  have positiveScale : 0 < -Real.log q :=
    neg_pos.mpr (Real.log_neg hq.1 hq.2)
  simpa [Real.exp_log hq.1] using agreement (-Real.log q) positiveScale

/-- Equality at every positive Laplace scale determines a complex
polynomial. -/
theorem complex_polynomial_eq_of_eval_exp_neg_eq
    (left right : ℂ[X])
    (agreement : ∀ t : ℝ, 0 < t →
      left.eval (Real.exp (-t) : ℂ) =
        right.eval (Real.exp (-t) : ℂ)) :
    left = right := by
  apply complex_polynomial_eq_of_eq_on_open_unit_interval left right
  intro q hq
  have positiveScale : 0 < -Real.log q :=
    neg_pos.mpr (Real.log_neg hq.1 hq.2)
  simpa [Real.exp_log hq.1] using agreement (-Real.log q) positiveScale

/-- The polynomial associated with a finitely supported complex coefficient
sequence. -/
def coefficientPolynomial (coefficients : ℕ →₀ ℂ) : ℂ[X] :=
  (Polynomial.toFinsuppIso ℂ).symm
    (AddMonoidAlgebra.ofCoeff coefficients)

/-- The finite Laplace transform of a finitely supported complex coefficient
sequence, written as evaluation of its associated polynomial. -/
def finiteLaplace (coefficients : ℕ →₀ ℂ) (t : ℝ) : ℂ :=
  (coefficientPolynomial coefficients).eval (Real.exp (-t) : ℂ)

/-- **Finite Laplace uniqueness.**  A finitely supported complex coefficient
sequence is exactly reconstructed from all positive smoothing scales. -/
theorem finsupp_eq_of_finiteLaplace_eq
    (left right : ℕ →₀ ℂ)
    (agreement : ∀ t : ℝ, 0 < t →
      finiteLaplace left t = finiteLaplace right t) :
    left = right := by
  have polynomialAgreement :
      coefficientPolynomial left = coefficientPolynomial right := by
    apply complex_polynomial_eq_of_eval_exp_neg_eq
    intro t ht
    exact agreement t ht
  have algebraAgreement :
      AddMonoidAlgebra.ofCoeff left = AddMonoidAlgebra.ofCoeff right :=
    (Polynomial.toFinsuppIso ℂ).symm.injective polynomialAgreement
  simpa using congrArg AddMonoidAlgebra.coeff algebraAgreement

end

end Pairfield.FiniteLaplaceUniqueness
