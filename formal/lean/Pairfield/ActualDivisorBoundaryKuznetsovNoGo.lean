import Pairfield.DivisorBoundaryBesselCollision

/-!
# Headline: an actual boundary stratum is not one scalar radial kernel

This module packages the concrete collision from
`DivisorBoundaryBesselCollision` on the full-lift family with modulus six and
second residue two.  The induced DFT coefficient does not descend through the
scalar Bessel coordinate `mn/c²`.

The conclusion is deliberately narrow.  It does not obstruct choosing a
sparse section of the residue lifts, taking several kernels, or putting the
coefficient into an independent Whittaker-index factor.  The final theorem
below checks the last survival mechanism explicitly.
-/

namespace Pairfield.ActualDivisorBoundaryKuznetsovNoGo

open DivisorBoundaryBesselCollision
open KuznetsovSingleKernelBoundary

noncomputable section

/-- All integer lifts at modulus six whose second index reduces to two. -/
abbrev FullLiftMode :=
  {index : ModeIndex // index.modulus = 6 ∧ (index.second : ZMod 6) = 2}

def fullLiftFourTwo : FullLiftMode := by
  refine ⟨collisionFourTwo, ?_⟩
  decide

def fullLiftOneEight : FullLiftMode := by
  refine ⟨collisionOneEight, ?_⟩
  decide

/-- The actual DFT coefficient of the gcd stratum `(6,1,6,7)`, read on all
integer lifts in the selected residue family. -/
def fullLiftCoefficient (index : FullLiftMode) : ℂ :=
  liftedBoundaryCoefficient index.1

/-- The square of the scalar Bessel argument, with `(4π)² omitted. -/
def fullLiftRadialCoordinate (index : FullLiftMode) : ℚ :=
  besselArgumentSquared index.1

/-- Pure scalar-radial realization, with no independent weight on either
Whittaker index. -/
def OneScalarRadialFullLiftKernel : Prop :=
  Pairfield.FactorsThrough fullLiftRadialCoordinate fullLiftCoefficient

theorem specified_full_lifts_have_equal_radial_coordinate :
    fullLiftRadialCoordinate fullLiftFourTwo =
      fullLiftRadialCoordinate fullLiftOneEight := by
  norm_num [fullLiftRadialCoordinate, besselArgumentSquared,
    fullLiftFourTwo, fullLiftOneEight, collisionFourTwo, collisionOneEight]

theorem specified_full_lifts_have_unequal_boundary_coefficients :
    fullLiftCoefficient fullLiftFourTwo ≠
      fullLiftCoefficient fullLiftOneEight := by
  simpa [fullLiftCoefficient, fullLiftFourTwo, fullLiftOneEight] using
    liftedBoundaryCoefficient_separates_collision

/-- **Actual scalar-kernel no-go.**  The DFT coefficient of the concrete gcd
stratum `(B,g,b,k) = (6,1,6,7)` is not representable by one scalar radial
Bessel kernel on all integer lifts with modulus six and second residue two. -/
theorem actual_gcd_stratum_not_one_scalar_radial_full_lift_kernel :
    ¬OneScalarRadialFullLiftKernel := by
  intro realizes
  exact specified_full_lifts_have_unequal_boundary_coefficients
    ((Pairfield.factorsThrough_iff_fiberConstant
      fullLiftRadialCoordinate fullLiftCoefficient).mp realizes
      specified_full_lifts_have_equal_radial_coordinate)

/-- A broader single channel with an independent first-Whittaker-index factor
still realizes the same coefficient exactly.  Thus the no-go above is radial,
not a no-go for separable Whittaker data or for higher factorization rank. -/
theorem actual_gcd_stratum_has_separable_whittaker_realization :
    ∃ left : ℕ → ℂ, ∃ right : ℕ → ℂ, ∃ radial : ℚ → ℂ,
      ∀ index : FullLiftMode,
        fullLiftCoefficient index =
          left index.1.first * right index.1.second *
            radial (fullLiftRadialCoordinate index) := by
  refine ⟨(fun m ↦ ZMod.dft boundaryWeight (m : ZMod 6)),
    (fun _ ↦ 1), (fun _ ↦ 1), ?_⟩
  intro index
  simp [fullLiftCoefficient, liftedBoundaryCoefficient]

end

end Pairfield.ActualDivisorBoundaryKuznetsovNoGo
