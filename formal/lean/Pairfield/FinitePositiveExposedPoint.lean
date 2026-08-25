import Mathlib

/-!
# Finite positive-functional exposed points

For finitely many complex coefficients in the closed unit disc, a positive
weighted aggregate exposes the all-ones point.  More quantitatively, a lower
bound on one coordinate's weight converts its distance from `1` into a lower
bound on the aggregate's real-part deficit.

This is the finite algebraic kernel of `notes/EXPOSED_POINT_RIGIDITY.md`.  It
does not formalize an infinite series, a Dirichlet series, complete
multiplicativity, or analytic continuation.
-/

namespace Pairfield.FinitePositiveExposedPoint

open scoped BigOperators

variable {ι : Type*} [Fintype ι]

/-- The amount by which the real part of a positive weighted aggregate falls
short of its all-ones value. -/
def realDeficit (weight : ι → ℝ) (coefficient : ι → ℂ) : ℝ :=
  ∑ i, weight i * (1 - (coefficient i).re)

/-- The termwise definition is exactly the deficit of the aggregate real
part.  No positivity assumption is needed for this identity. -/
theorem realDeficit_eq_aggregate (weight : ι → ℝ) (coefficient : ι → ℂ) :
    realDeficit weight coefficient =
      (∑ i, weight i) - (∑ i, (weight i : ℂ) * coefficient i).re := by
  simp [realDeficit, mul_sub, Finset.sum_sub_distrib]

/-- A unit-disc point's squared distance from `1` is at most twice its
real-part deficit.  The constant two is sharp at `-1`. -/
theorem norm_one_sub_sq_le_two_realDeficit (z : ℂ) (hz : ‖z‖ ≤ 1) :
    ‖1 - z‖ ^ 2 ≤ 2 * (1 - z.re) := by
  rw [← Complex.normSq_eq_norm_sq, Complex.normSq_sub]
  have hnormSq : Complex.normSq z ≤ 1 := by
    rw [Complex.normSq_eq_norm_sq]
    simpa using (pow_le_pow_left₀ (norm_nonneg z) hz 2)
  simp only [Complex.normSq_one, one_mul, Complex.conj_re]
  linarith

omit [Fintype ι] in
/-- Every summand in the real deficit is nonnegative under nonnegative
weights and unit-disc coefficients. -/
theorem realDeficit_term_nonneg
    (weight : ι → ℝ) (coefficient : ι → ℂ)
    (hweight : ∀ i, 0 ≤ weight i)
    (hcoefficient : ∀ i, ‖coefficient i‖ ≤ 1) (i : ι) :
    0 ≤ weight i * (1 - (coefficient i).re) := by
  have hre : (coefficient i).re ≤ 1 :=
    (Complex.re_le_norm _).trans (hcoefficient i)
  exact mul_nonneg (hweight i) (sub_nonneg.mpr hre)

/-- A declared lower bound `μ` on one weight turns displacement at that
coordinate into a quantitative aggregate deficit. -/
theorem coordinate_stability
    (weight : ι → ℝ) (coefficient : ι → ℂ)
    (hweight : ∀ i, 0 ≤ weight i)
    (hcoefficient : ∀ i, ‖coefficient i‖ ≤ 1)
    (j : ι) (μ : ℝ) (hμ : 0 ≤ μ) (hμj : μ ≤ weight j) :
    μ * ‖1 - coefficient j‖ ^ 2 ≤ 2 * realDeficit weight coefficient := by
  have hpoint := norm_one_sub_sq_le_two_realDeficit
    (coefficient j) (hcoefficient j)
  have hreal : 0 ≤ 1 - (coefficient j).re := by
    exact sub_nonneg.mpr ((Complex.re_le_norm _).trans (hcoefficient j))
  have hleft : μ * ‖1 - coefficient j‖ ^ 2 ≤
      2 * (weight j * (1 - (coefficient j).re)) := by
    calc
      μ * ‖1 - coefficient j‖ ^ 2
          ≤ μ * (2 * (1 - (coefficient j).re)) :=
            mul_le_mul_of_nonneg_left hpoint hμ
      _ ≤ weight j * (2 * (1 - (coefficient j).re)) := by
            exact mul_le_mul_of_nonneg_right hμj (mul_nonneg (by norm_num) hreal)
      _ = 2 * (weight j * (1 - (coefficient j).re)) := by ring
  have hterm : weight j * (1 - (coefficient j).re) ≤
      realDeficit weight coefficient := by
    exact Finset.single_le_sum
      (fun i _ ↦ realDeficit_term_nonneg weight coefficient hweight hcoefficient i)
      (Finset.mem_univ j)
  linarith

/-- Strict positivity of every weight makes zero aggregate deficit rigid:
every unit-disc coefficient is exactly `1`. -/
theorem eq_one_of_realDeficit_eq_zero
    (weight : ι → ℝ) (coefficient : ι → ℂ)
    (hweight : ∀ i, 0 < weight i)
    (hcoefficient : ∀ i, ‖coefficient i‖ ≤ 1)
    (hzero : realDeficit weight coefficient = 0) :
    coefficient = fun _ ↦ 1 := by
  funext j
  have hstable := coordinate_stability weight coefficient
    (fun i ↦ (hweight i).le) hcoefficient j (weight j) (hweight j).le le_rfl
  rw [hzero, mul_zero] at hstable
  have hdist : ‖1 - coefficient j‖ = 0 := by
    have hproduct : weight j * ‖1 - coefficient j‖ ^ 2 = 0 :=
      le_antisymm hstable
        (mul_nonneg (hweight j).le (sq_nonneg ‖1 - coefficient j‖))
    have hsquare : ‖1 - coefficient j‖ ^ 2 = 0 := by
      rcases mul_eq_zero.mp hproduct with hweightZero | hsquare
      · exact False.elim ((hweight j).ne' hweightZero)
      · exact hsquare
    exact (sq_eq_zero_iff).mp hsquare
  have : (1 : ℂ) - coefficient j = 0 := norm_eq_zero.mp hdist
  linear_combination -this

/-- Equality of the complex aggregate with its all-ones value is therefore
enough to expose every coordinate. -/
theorem eq_one_of_aggregate_eq
    (weight : ι → ℝ) (coefficient : ι → ℂ)
    (hweight : ∀ i, 0 < weight i)
    (hcoefficient : ∀ i, ‖coefficient i‖ ≤ 1)
    (haggregate : (∑ i, (weight i : ℂ) * coefficient i) =
      (∑ i, (weight i : ℂ))) :
    coefficient = fun _ ↦ 1 := by
  apply eq_one_of_realDeficit_eq_zero weight coefficient hweight hcoefficient
  rw [realDeficit_eq_aggregate]
  have hre : (∑ i, (weight i : ℂ) * coefficient i).re = ∑ i, weight i := by
    simpa using congrArg Complex.re haggregate
  exact sub_eq_zero.mpr hre.symm

/-! ## Exact controls -/

def controlWeight (ε : ℝ) : Bool → ℝ
  | false => 1
  | true => ε

def controlCoefficient : Bool → ℂ
  | false => 1
  | true => -1

theorem controlCoefficient_unitDisc (b : Bool) : ‖controlCoefficient b‖ ≤ 1 := by
  cases b <;> norm_num [controlCoefficient]

theorem control_deficit (ε : ℝ) :
    realDeficit (controlWeight ε) controlCoefficient = 2 * ε := by
  norm_num [realDeficit, controlWeight, controlCoefficient]
  ring

theorem control_displacement : ‖1 - controlCoefficient true‖ = 2 := by
  norm_num [controlCoefficient]

/-- With zero weight on the changed coordinate, even the full complex
aggregate is unchanged. -/
theorem zeroWeight_aggregate_eq :
    (∑ b, (controlWeight 0 b : ℂ) * controlCoefficient b) =
      ∑ b, (controlWeight 0 b : ℂ) := by
  norm_num [controlWeight, controlCoefficient]

/-- If a coordinate is allowed weight zero, aggregate equality does not force
that coordinate to equal one. -/
theorem zeroWeight_breaks_rigidity :
    (∀ b, 0 ≤ controlWeight 0 b) ∧
    (∀ b, ‖controlCoefficient b‖ ≤ 1) ∧
    realDeficit (controlWeight 0) controlCoefficient = 0 ∧
    (∑ b, (controlWeight 0 b : ℂ) * controlCoefficient b) =
      (∑ b, (controlWeight 0 b : ℂ)) ∧
    controlCoefficient true ≠ 1 := by
  constructor
  · intro b
    cases b <;> norm_num [controlWeight]
  refine ⟨controlCoefficient_unitDisc, ?_, zeroWeight_aggregate_eq, ?_⟩
  · simpa using control_deficit 0
  · norm_num [controlCoefficient]

/-- Even with every weight strictly positive, no positive uniform stability
constant exists without a declared lower weight bound: retain displacement
two while making the aggregate deficit smaller than any `η > 0`. -/
theorem arbitrarilySmall_deficit_fixed_displacement (η : ℝ) (hη : 0 < η) :
    ∃ weight : Bool → ℝ, ∃ coefficient : Bool → ℂ,
      (∀ b, 0 < weight b) ∧
      (∀ b, ‖coefficient b‖ ≤ 1) ∧
      realDeficit weight coefficient < η ∧
      ‖1 - coefficient true‖ = 2 := by
  refine ⟨controlWeight (η / 4), controlCoefficient, ?_,
    controlCoefficient_unitDisc, ?_, control_displacement⟩
  · intro b
    cases b <;> simp [controlWeight, hη]
  · rw [control_deficit]
    linarith

end Pairfield.FinitePositiveExposedPoint
