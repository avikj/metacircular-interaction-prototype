import Pairfield.DivisorBoundaryBesselCollision

/-!
# A finite sparse-lift scalar-kernel compiler

An injective scalar-kernel shape has no collision fibers.  Consequently every
coefficient family on such a chosen mode family descends through one scalar
kernel.  The algebraic statement does not require finiteness; finiteness is
what later permits interpolation by an admissible smooth test function at the
finitely many distinct arguments.

For the actual modulus-six divisor-boundary stratum, we choose one positive
first-index lift for each residue and keep the second lift equal to two.  The
six products are distinct, so the completed DFT coefficients compile through
one scalar shape on this sparse section.  This complements the full-lift
collision: sparse choice survives, while periodic repetition over every lift
does not descend radially.
-/

namespace Pairfield.SparseLiftScalarKernelCompiler

open DivisorBoundaryBesselCollision
open KuznetsovSingleKernelBoundary

noncomputable section

/-- A coefficient family on a selected mode family is represented by one
scalar kernel when it descends through the restricted scalar shape. -/
def SparseScalarKernel {Index Coefficient : Type*}
    (modes : Index → ModeIndex) (weight : Index → Coefficient) : Prop :=
  Pairfield.FactorsThrough (scalarKernelShape ∘ modes) weight

/-- Injectivity of the restricted scalar shape is the exact algebraic
compiler: every coefficient assignment descends through that shape. -/
theorem every_weight_sparseScalarKernel_of_shape_injective
    {Index Coefficient : Type*} (modes : Index → ModeIndex)
    (shapeInjective : Function.Injective (scalarKernelShape ∘ modes))
    (weight : Index → Coefficient) :
    SparseScalarKernel modes weight := by
  rw [SparseScalarKernel, Pairfield.factorsThrough_iff_fiberConstant]
  intro left right shapeAgreement
  exact congrArg weight (shapeInjective shapeAgreement)

/-- One positive first-index lift for each of the six residue frequencies;
the second lift and modulus are fixed at `2` and `6`. -/
def canonicalSparseMode (residue : Fin 6) : ModeIndex :=
  ⟨residue.1 + 1, 2, 6⟩

/-- The selected positive first indices represent every residue modulo six
exactly once. -/
theorem canonicalSparseMode_residues_bijective :
    Function.Bijective
      (fun residue : Fin 6 ↦
        ((canonicalSparseMode residue).first : ZMod 6)) := by
  decide

/-- Every selected mode belongs to the same second-residue family used in the
full-lift no-go. -/
theorem canonicalSparseMode_second_residue (residue : Fin 6) :
    ((canonicalSparseMode residue).second : ZMod 6) = 2 := by
  rfl

/-- The six selected scalar shapes are pairwise distinct. -/
theorem canonicalSparseMode_shape_injective :
    Function.Injective (scalarKernelShape ∘ canonicalSparseMode) := by
  intro left right shapeAgreement
  apply Fin.ext
  have productAgreement := congrArg Prod.fst shapeAgreement
  simp [scalarKernelShape, canonicalSparseMode] at productAgreement
  omega

/-- The actual completed DFT coefficient of the gcd stratum
`(B,g,b,k) = (6,1,6,7)`, restricted to the sparse lift section. -/
def sparseBoundaryCoefficient (residue : Fin 6) : ℂ :=
  liftedBoundaryCoefficient (canonicalSparseMode residue)

/-- **Sparse-lift compiler.**  One scalar shape represents all six DFT
coefficients of the actual divisor-boundary stratum on this sparse section. -/
theorem actual_gcd_stratum_has_sparse_scalar_kernel :
    SparseScalarKernel canonicalSparseMode sparseBoundaryCoefficient :=
  every_weight_sparseScalarKernel_of_shape_injective
    canonicalSparseMode canonicalSparseMode_shape_injective
    sparseBoundaryCoefficient

end

end Pairfield.SparseLiftScalarKernelCompiler
