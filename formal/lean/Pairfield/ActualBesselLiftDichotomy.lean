import Pairfield.ActualDivisorBoundaryKuznetsovNoGo
import Pairfield.ActualBesselSparseInterpolation

/-!
# Headline dichotomy at the genuine Kuznetsov Bessel arguments

For the concrete modulus-six divisor-boundary stratum, periodic repetition on
all integer lifts cannot be encoded by one scalar geometric function: the
lifts `(4,2,6)` and `(1,8,6)` have the same genuine argument
`4π√(mn)/c` but unequal completed DFT coefficients.

After selecting the canonical six sparse lifts `(r+1,2,6)`, the arguments are
distinct and one smooth compactly supported geometric test on `(0,∞)` takes
all six prescribed values.  No claim about a spectral preimage under a Bessel
transform is added here.
-/

namespace Pairfield.ActualBesselLiftDichotomy

open ActualDivisorBoundaryKuznetsovNoGo
open ActualBesselSparseInterpolation
open FiniteSmoothBesselInterpolation
open SparseLiftScalarKernelCompiler
open scoped Distributions

noncomputable section

/-- A single ambient scalar geometric function realizes every mode in the
full-lift residue family. -/
def OneScalarGeometricFullLiftFunction : Prop :=
  ∃ g : ℝ → ℂ, ∀ index : FullLiftMode,
    g (kuznetsovBesselArgument index.1) = fullLiftCoefficient index

/-- The two hostile full lifts have exactly the same genuine Kuznetsov Bessel
argument. -/
theorem hostile_full_lifts_same_actual_bessel_argument :
    kuznetsovBesselArgument fullLiftFourTwo.1 =
      kuznetsovBesselArgument fullLiftOneEight.1 := by
  norm_num [kuznetsovBesselArgument, fullLiftFourTwo, fullLiftOneEight,
    DivisorBoundaryBesselCollision.collisionFourTwo,
    DivisorBoundaryBesselCollision.collisionOneEight]

/-- The concrete completed boundary coefficient is therefore not the value of
one scalar geometric function on every integer lift. -/
theorem actual_gcd_stratum_full_lifts_have_no_scalar_geometric_function :
    ¬OneScalarGeometricFullLiftFunction := by
  rintro ⟨g, realizes⟩
  have sameValue := congrArg g hostile_full_lifts_same_actual_bessel_argument
  exact specified_full_lifts_have_unequal_boundary_coefficients
    ((realizes fullLiftFourTwo).symm.trans
      (sameValue.trans (realizes fullLiftOneEight)))

/-- **Genuine-argument lift dichotomy.**  The full periodic lift family has no
single scalar geometric realization, whereas the canonical sparse six-lift
section has a `C∞` compactly supported geometric test with all prescribed
boundary values. -/
theorem actual_gcd_stratum_full_sparse_geometric_dichotomy :
    (¬OneScalarGeometricFullLiftFunction) ∧
      (∃ g : 𝓓(positiveHalfLine, ℂ), ∀ residue : Fin 6,
        g (canonicalSparseBesselPoint residue) =
          sparseBoundaryCoefficient residue) :=
  ⟨actual_gcd_stratum_full_lifts_have_no_scalar_geometric_function,
    actual_gcd_stratum_has_smooth_sparse_geometric_test⟩

end

end Pairfield.ActualBesselLiftDichotomy
