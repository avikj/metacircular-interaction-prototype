import Mathlib.LinearAlgebra.Matrix.Rank

/-!
# Exact rank defect at a finite process cut

The process-table lineage composes two finite-dimensional linear maps

`F --B--> M --A--> H`.

The composite only sees the boundary information actually transmitted by
`B`, namely `range B`.  Mathlib's
`LinearMap.finrank_range_add_finrank_ker`, applied to the restriction of `A`
to that subspace, gives the exact gluing defect.  This file identifies both
the restricted range and the restricted kernel with the native process-cut
objects before exposing the rank formula.

The theorem concerns ordinary linear rank only.  It does not identify
nonnegative rank, completely-positive memory, or a physical spacetime metric.
-/

namespace Pairfield.ProcessCutRankAdapter

open Module

noncomputable section

universe uK uH uM uF

variable {K : Type uK} [DivisionRing K]
variable {H : Type uH} [AddCommGroup H] [Module K H]
variable {M : Type uM} [AddCommGroup M] [Module K M]
variable {F : Type uF} [AddCommGroup F] [Module K F]

/-- Restrict the receiving process `A` to the boundary states that the
preceding process `B` can actually transmit. -/
def transmittedRestriction (A : M →ₗ[K] H) (B : F →ₗ[K] M) :
    LinearMap.range B →ₗ[K] H :=
  A.domRestrict (LinearMap.range B)

@[simp]
theorem transmittedRestriction_apply (A : M →ₗ[K] H) (B : F →ₗ[K] M)
    (x : LinearMap.range B) :
    transmittedRestriction A B x = A x :=
  rfl

/-- Restricting to the transmitted boundary loses no output of the composite.
This is the exact identification needed before rank-nullity can be consumed by
the process-table object. -/
theorem range_transmittedRestriction (A : M →ₗ[K] H) (B : F →ₗ[K] M) :
    LinearMap.range (transmittedRestriction A B) =
      LinearMap.range (A.comp B) := by
  rw [transmittedRestriction, LinearMap.range_domRestrict,
    LinearMap.range_comp]

/-- The invisible part of the transmitted boundary is precisely the
intersection of the transmitted states with the receiver's kernel. -/
theorem map_ker_transmittedRestriction (A : M →ₗ[K] H) (B : F →ₗ[K] M) :
    (LinearMap.ker (transmittedRestriction A B)).map
        (LinearMap.range B).subtype =
      LinearMap.range B ⊓ LinearMap.ker A := by
  ext x
  constructor
  · rintro ⟨⟨y, hy⟩, hker, rfl⟩
    constructor
    · simpa using hy
    · simpa [LinearMap.mem_ker] using hker
  · intro hx
    simp_rw [Submodule.mem_map, LinearMap.mem_ker]
    exact ⟨⟨x, hx.1⟩, hx.2, rfl⟩

variable [FiniteDimensional K M]

/-- The kernel of the restricted process and the native alignment defect have
the same finite dimension.  The subtype map is injective, so no scalarization
or quotient is hidden in this transport. -/
theorem finrank_ker_transmittedRestriction (A : M →ₗ[K] H) (B : F →ₗ[K] M) :
    finrank K (LinearMap.ker (transmittedRestriction A B)) =
      finrank K (LinearMap.range B ⊓ LinearMap.ker A) := by
  rw [← map_ker_transmittedRestriction]
  exact
    (Submodule.equivMapOfInjective (LinearMap.range B).subtype
      (LinearMap.range B).injective_subtype
      (LinearMap.ker (transmittedRestriction A B))).finrank_eq

/-- Exact process-cut gluing law in cancellation-free form.

The composite rank plus the dimension annihilated at the interface equals the
dimension actually transmitted by the first process. -/
theorem cutRank_add_alignmentDefect (A : M →ₗ[K] H) (B : F →ₗ[K] M) :
    finrank K (LinearMap.range (A.comp B)) +
        finrank K (LinearMap.range B ⊓ LinearMap.ker A) =
      finrank K (LinearMap.range B) := by
  rw [← range_transmittedRestriction,
    ← finrank_ker_transmittedRestriction]
  exact (transmittedRestriction A B).finrank_range_add_finrank_ker

/-- The subtraction form printed in the native process note.  The additive
form above is primary because it does not rely on truncated-subtraction
bookkeeping. -/
theorem cutRank_eq_sub_alignmentDefect (A : M →ₗ[K] H) (B : F →ₗ[K] M) :
    finrank K (LinearMap.range (A.comp B)) =
      finrank K (LinearMap.range B) -
        finrank K (LinearMap.range B ⊓ LinearMap.ker A) := by
  exact Nat.eq_sub_of_add_eq (cutRank_add_alignmentDefect A B)

/-- If the transmitted boundary is disjoint from the receiver's kernel, the
composite preserves all transmitted linear information. -/
theorem cutRank_eq_of_disjoint (A : M →ₗ[K] H) (B : F →ₗ[K] M)
    (h : Disjoint (LinearMap.range B) (LinearMap.ker A)) :
    finrank K (LinearMap.range (A.comp B)) =
      finrank K (LinearMap.range B) := by
  simpa [h.eq_bot] using cutRank_add_alignmentDefect A B

/-- Opposite control: if every transmitted state lies in the receiver's
kernel, the composite transmits no linear information. -/
theorem cutRank_eq_zero_of_range_le_ker (A : M →ₗ[K] H) (B : F →ₗ[K] M)
    (h : LinearMap.range B ≤ LinearMap.ker A) :
    finrank K (LinearMap.range (A.comp B)) = 0 := by
  have hcomp : A.comp B = 0 := by
    ext x
    have hx : B x ∈ LinearMap.ker A :=
      h (LinearMap.mem_range_self B x)
    simpa [LinearMap.mem_ker] using hx
  simp [hcomp]

section Matrix

variable {K : Type uK} [Field K]
variable {h : Type uH} {m : Type uM} {f : Type uF}
variable [Fintype h] [Fintype m] [Fintype f]

/-- Matrix-facing form for the repository's finite process tables. -/
theorem matrix_cutRank_add_alignmentDefect (A : Matrix h m K)
    (B : Matrix m f K) :
    (A * B).rank +
        finrank K (LinearMap.range B.mulVecLin ⊓ LinearMap.ker A.mulVecLin) =
      B.rank := by
  simpa only [Matrix.rank, Matrix.mulVecLin_mul] using
    cutRank_add_alignmentDefect A.mulVecLin B.mulVecLin

/-- Matrix subtraction form, matching the displayed identity in the native
process-table note. -/
theorem matrix_cutRank_eq_sub_alignmentDefect (A : Matrix h m K)
    (B : Matrix m f K) :
    (A * B).rank = B.rank -
      finrank K (LinearMap.range B.mulVecLin ⊓ LinearMap.ker A.mulVecLin) := by
  simpa only [Matrix.rank, Matrix.mulVecLin_mul] using
    cutRank_eq_sub_alignmentDefect A.mulVecLin B.mulVecLin

end Matrix

end

end Pairfield.ProcessCutRankAdapter
