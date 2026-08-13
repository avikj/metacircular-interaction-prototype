import Mathlib.LinearAlgebra.Vandermonde

/-!
# Cyclic closure for a diagonal action

A nowhere-zero vector is cyclic for multiplication by an injective coordinate
function.  This is the exact finite-dimensional mechanism by which admitting
the position operator destroys every nonempty character-sector compression.
-/

namespace Pairfield

open Matrix

variable {K : Type*} [Field K] {n : ℕ}

/-- The matrix whose `j`th column is the `j`th iterate of pointwise
multiplication by `m`, starting from `v`. -/
def diagonalOrbitMatrix (m v : Fin n → K) : Matrix (Fin n) (Fin n) K :=
  fun i j ↦ v i * m i ^ (j : ℕ)

theorem diagonalOrbitMatrix_eq
    (m v : Fin n → K) :
    diagonalOrbitMatrix m v = Matrix.diagonal v * Matrix.vandermonde m := by
  ext i j
  simp [diagonalOrbitMatrix, Matrix.mul_apply, Matrix.vandermonde_apply]

/-- Exact determinant certificate for the diagonal orbit. -/
theorem det_diagonalOrbitMatrix
    (m v : Fin n → K) :
    (diagonalOrbitMatrix m v).det =
      (∏ i, v i) * (Matrix.vandermonde m).det := by
  rw [diagonalOrbitMatrix_eq, Matrix.det_mul, Matrix.det_diagonal]

/-- If the multiplier separates all coordinates and the starting vector has
full support, its first `n` iterates are linearly independent. -/
theorem diagonalOrbit_linearIndependent
    (m v : Fin n → K) (hm : Function.Injective m)
    (hv : ∀ i, v i ≠ 0) :
    LinearIndependent K (fun j : Fin n ↦ fun i ↦ v i * m i ^ (j : ℕ)) := by
  apply Matrix.linearIndependent_cols_of_det_ne_zero
  rw [det_diagonalOrbitMatrix]
  exact mul_ne_zero (Finset.prod_ne_zero_iff.mpr hv)
    (Matrix.det_vandermonde_ne_zero_iff.mpr hm)

end Pairfield
