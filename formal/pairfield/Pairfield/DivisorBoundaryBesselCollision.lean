import Pairfield.DivisorBoundaryKloostermanBridge
import Pairfield.KuznetsovSingleKernelBoundary

/-!
# An actual divisor-boundary collision at one scalar Bessel argument

The stratum `(B,g,b,k) = (6,1,6,7)` has just one reduced divisor, namely
`a = 5`.  With the elementary choice `cz(n) = n` and unit endpoint, its
residue weight is the point mass at `5 : ZMod 6`.  Its finite DFT therefore
takes different values at the residue frequencies `4` and `1`.

The integer mode pairs `(4,2,6)` and `(1,8,6)` have the same product and
modulus, while their second indices have the same residue modulo six.  Thus a
single scalar radial Bessel value cannot supply the two DFT coefficients.
This is only a no-go for putting the boundary coefficient into the radial
kernel itself: independent Whittaker-index weights or a nonfactorizable
relative distribution are not excluded.
-/

namespace Pairfield.DivisorBoundaryBesselCollision

open DivisorBoundaryKloostermanBridge
open KuznetsovSingleKernelBoundary

noncomputable section

def linearCharge (n : ℕ) : ℂ := n

def unitEndpoint (_ : ℕ) : ℂ := 1

def fiveIndex : ReducedIndex 6 1 6 7 := by
  refine ⟨5, ?_⟩
  norm_num [reducedIndices]

theorem reducedIndex_eq_five (a : ReducedIndex 6 1 6 7) : a = fiveIndex := by
  rcases a with ⟨a, ha⟩
  apply Subtype.ext
  change a = 5
  rcases Finset.mem_Icc.mp (Finset.mem_filter.mp ha).1 with ⟨lower, upper⟩
  interval_cases a <;> norm_num [reducedIndices] at ha
  rfl

theorem reducedUnit_five :
    ((reducedUnit fiveIndex : (ZMod 6)ˣ) : ZMod 6) = 5 := by
  rfl

theorem reducedWeight_five :
    reducedWeight linearCharge unitEndpoint fiveIndex = 1 := by
  norm_num [reducedWeight, linearCharge, unitEndpoint, fiveIndex]

def boundaryWeight : ZMod 6 → ℂ :=
  gcdStratumWeight 6 1 6 7 linearCharge unitEndpoint

def deltaFive (x : ZMod 6) : ℂ := if x = 5 then 1 else 0

theorem boundaryWeight_eq_deltaFive : boundaryWeight = deltaFive := by
  funext x
  unfold boundaryWeight gcdStratumWeight unitResidueAggregate
  rw [Fintype.sum_eq_single fiveIndex]
  change (if ((reducedUnit fiveIndex : (ZMod 6)ˣ) : ZMod 6) = x then
      reducedWeight linearCharge unitEndpoint fiveIndex else 0) = deltaFive x
  · rw [reducedWeight_five, reducedUnit_five]
    simp [deltaFive, eq_comm]
  · intro a ha
    exact (ha (reducedIndex_eq_five a)).elim

theorem dft_deltaFive (m : ZMod 6) :
    ZMod.dft deltaFive m = ZMod.stdAddChar (-(5 * m)) := by
  simp [ZMod.dft_apply, deltaFive]

theorem boundary_dft_four_ne_one :
    ZMod.dft boundaryWeight (4 : ZMod 6) ≠
      ZMod.dft boundaryWeight (1 : ZMod 6) := by
  rw [boundaryWeight_eq_deltaFive, dft_deltaFive, dft_deltaFive]
  apply ZMod.injective_stdAddChar.ne
  decide

def collisionFourTwo : ModeIndex := ⟨4, 2, 6⟩

def collisionOneEight : ModeIndex := ⟨1, 8, 6⟩

theorem collision_same_scalar_shape :
    scalarKernelShape collisionFourTwo =
      scalarKernelShape collisionOneEight := by
  decide

theorem collision_second_indices_alias : (2 : ZMod 6) = 8 := by
  decide

/-- The actual DFT coefficient supplied by this divisor-boundary stratum,
periodically repeated over nonnegative integer lifts. -/
def liftedBoundaryCoefficient (index : ModeIndex) : ℂ :=
  ZMod.dft boundaryWeight (index.first : ZMod 6)

theorem liftedBoundaryCoefficient_separates_collision :
    liftedBoundaryCoefficient collisionFourTwo ≠
      liftedBoundaryCoefficient collisionOneEight := by
  simpa [liftedBoundaryCoefficient, collisionFourTwo, collisionOneEight] using
    boundary_dft_four_ne_one

/-- A single scalar radial kernel cannot itself encode this completed
divisor-boundary coefficient family. -/
theorem liftedBoundaryCoefficient_not_singleScalarKernel :
    ¬SingleScalarKernel liftedBoundaryCoefficient := by
  intro realizes
  exact liftedBoundaryCoefficient_separates_collision
    ((Pairfield.factorsThrough_iff_fiberConstant
      scalarKernelShape liftedBoundaryCoefficient).mp realizes
      collision_same_scalar_shape)

end

end Pairfield.DivisorBoundaryBesselCollision
