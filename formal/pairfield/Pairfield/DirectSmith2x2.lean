import Mathlib

namespace Pairfield.DirectSmith2x2

open Matrix

abbrev Mat2 := Matrix (Fin 2) (Fin 2) ℤ

/-- A direct Smith-identity capability for the unimodular 2×2 branch.
It contains the presentation transforms and replay equations, but invokes no
generic Smith normalization. -/
structure UnitDetCapability (A : Mat2) where
  left : Mat2
  right : Mat2
  normal : Mat2
  replay : normal = left * A * right
  leftInverse : left * A = 1
  rightInverse : A * left = 1

/-- Determinant one compiles directly: the adjugate is the integral inverse,
so the Smith endpoint is the identity. -/
def compileUnitDet (A : Mat2) (hdet : A.det = 1) : UnitDetCapability A where
  left := adjugate A
  right := 1
  normal := 1
  replay := by simp [adjugate_mul, hdet]
  leftInverse := by simpa [hdet] using adjugate_mul A
  rightInverse := by simpa [hdet] using mul_adjugate A

/-- The compiled capability executes the unique integral solution of `A x=b`. -/
def solve (A : Mat2) (hdet : A.det = 1) (b : Fin 2 → ℤ) : Fin 2 → ℤ :=
  (compileUnitDet A hdet).left *ᵥ b

theorem solve_spec (A : Mat2) (hdet : A.det = 1) (b : Fin 2 → ℤ) :
    A *ᵥ solve A hdet b = b := by
  rw [solve, ← mulVec_mulVec, (compileUnitDet A hdet).rightInverse]
  exact one_mulVec b

theorem solve_unique (A : Mat2) (hdet : A.det = 1) (b x : Fin 2 → ℤ)
    (hx : A *ᵥ x = b) : x = solve A hdet b := by
  rw [solve, ← hx, ← mulVec_mulVec, (compileUnitDet A hdet).leftInverse]
  exact one_mulVec x

end Pairfield.DirectSmith2x2
