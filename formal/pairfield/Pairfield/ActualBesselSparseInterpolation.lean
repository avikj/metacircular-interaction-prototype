import Pairfield.FiniteSmoothBesselInterpolation

/-!
# Sparse interpolation at the actual Kuznetsov Bessel arguments

This removes the squared-coordinate reparametrization from the finite sparse
compiler.  The interpolation points are exactly

`4 * π * sqrt (m * n) / c`

for the six canonical positive lifts of the actual modulus-six
divisor-boundary stratum.

The theorem constructs the geometric scalar test `g`.  It does not assert
that a prescribed spectral test `h` has Bessel transform `g`; that further
transport requires an appropriate Kuznetsov/Whittaker inversion theorem and
its admissibility hypotheses.
-/

namespace Pairfield.ActualBesselSparseInterpolation

open FiniteSmoothBesselInterpolation
open SparseLiftScalarKernelCompiler
open KuznetsovSingleKernelBoundary
open scoped Distributions

noncomputable section

/-- The positive-sign scalar argument in the classical Kuznetsov geometric
kernel. -/
def kuznetsovBesselArgument (index : ModeIndex) : ℝ :=
  4 * Real.pi * Real.sqrt (index.first * index.second : ℝ) /
    index.modulus

/-- The actual Bessel arguments of the six canonical sparse lifts. -/
def canonicalSparseBesselPoint (residue : Fin 6) : ℝ :=
  kuznetsovBesselArgument (canonicalSparseMode residue)

theorem canonicalSparseBesselPoint_positive (residue : Fin 6) :
    0 < canonicalSparseBesselPoint residue := by
  unfold canonicalSparseBesselPoint kuznetsovBesselArgument
  simp only [canonicalSparseMode]
  positivity

theorem canonicalSparseBesselPoint_injective :
    Function.Injective canonicalSparseBesselPoint := by
  intro left right pointAgreement
  have normalizedAgreement :
      (4 * Real.pi / 6) *
          Real.sqrt (((canonicalSparseMode left).first *
            (canonicalSparseMode left).second : ℕ) : ℝ) =
        (4 * Real.pi / 6) *
          Real.sqrt (((canonicalSparseMode right).first *
            (canonicalSparseMode right).second : ℕ) : ℝ) := by
    unfold canonicalSparseBesselPoint kuznetsovBesselArgument at pointAgreement
    simp only [canonicalSparseMode] at pointAgreement
    simp only [canonicalSparseMode]
    convert pointAgreement using 1 <;> push_cast <;> ring
  have constant_ne : (4 * Real.pi / 6 : ℝ) ≠ 0 := by
    positivity
  have sqrtAgreement :
      Real.sqrt (((canonicalSparseMode left).first *
          (canonicalSparseMode left).second : ℕ) : ℝ) =
        Real.sqrt (((canonicalSparseMode right).first *
          (canonicalSparseMode right).second : ℕ) : ℝ) :=
    mul_left_cancel₀ constant_ne normalizedAgreement
  have productAgreementReal :
      (((canonicalSparseMode left).first *
          (canonicalSparseMode left).second : ℕ) : ℝ) =
        (((canonicalSparseMode right).first *
          (canonicalSparseMode right).second : ℕ) : ℝ) :=
    (Real.sqrt_inj (by positivity) (by positivity)).mp sqrtAgreement
  have productAgreement :
      (canonicalSparseMode left).first *
          (canonicalSparseMode left).second =
        (canonicalSparseMode right).first *
          (canonicalSparseMode right).second := by
    exact_mod_cast productAgreementReal
  apply Fin.ext
  simpa [canonicalSparseMode] using productAgreement

/-- **Actual-argument analytic compiler.**  One smooth compactly supported
geometric scalar test takes the six completed boundary coefficients at the
six genuine positive Kuznetsov Bessel arguments. -/
theorem actual_gcd_stratum_has_smooth_sparse_geometric_test :
    ∃ g : 𝓓(positiveHalfLine, ℂ), ∀ residue : Fin 6,
      g (canonicalSparseBesselPoint residue) =
        sparseBoundaryCoefficient residue :=
  exists_testFunction_interpolating_finite_positive_set
    canonicalSparseBesselPoint canonicalSparseBesselPoint_injective
    canonicalSparseBesselPoint_positive sparseBoundaryCoefficient

end

end Pairfield.ActualBesselSparseInterpolation
