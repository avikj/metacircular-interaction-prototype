import Mathlib.LinearAlgebra.Vandermonde
import Mathlib.LinearAlgebra.Lagrange
import Pairfield.FiniteInformation

/-!
# Cyclic closure for a diagonal action

A nowhere-zero vector is cyclic for multiplication by an injective coordinate
function.  This is the exact finite-dimensional mechanism by which admitting
the position operator destroys every nonempty character-sector compression.
-/

namespace Pairfield

open Matrix

variable {K : Type*} [Field K] {n : ℕ}

/-- A target is realizable by the polynomial functional calculus of a
diagonal multiplier when one polynomial evaluates to that target at every
coordinate.  This is the executable/action half missing from bare descent
through the multiplier observable. -/
def PolynomialActionRealizes {X : Type*} (m t : X → K) : Prop :=
  ∃ p : Polynomial K, ∀ x, p.eval (m x) = t x

/-- On a finite coordinate type, descent through a scalar multiplier is
exactly realizability by its polynomial functional calculus.  Mathlib's
finite Lagrange theorem constructs the polynomial on the reached multiplier
values only; no arbitrary values outside `Set.range m` enter the statement. -/
theorem polynomialActionRealizes_iff_factorsThrough
    {X : Type*} [Finite X] (m t : X → K) :
    PolynomialActionRealizes m t ↔ FactorsThrough m t := by
  rw [PolynomialActionRealizes, Polynomial.exists_eval_eq_iff,
    factorsThrough_iff_fiberConstant]

/-- The requested action compiler: a finite decoder through `m` produces a
polynomial whose diagonal action sends any starting vector `v` to the
pointwise product `v * t`.  No nonvanishing premise is needed in this forward
direction. -/
theorem compile_factorsThrough_to_diagonalAction
    {X : Type*} [Finite X] (m t v : X → K)
    (h : FactorsThrough m t) :
    ∃ p : Polynomial K, ∀ x, v x * p.eval (m x) = v x * t x := by
  obtain ⟨p, hp⟩ :=
    (polynomialActionRealizes_iff_factorsThrough m t).2 h
  exact ⟨p, fun x ↦ congrArg (v x * ·) (hp x)⟩

/-- Pointwise nonvanishing is precisely the premise needed to reverse the
transport by `v`.  Without it, zero coordinates erase decoder information. -/
theorem diagonalAction_realizes_iff_factorsThrough
    {X : Type*} [Finite X] (m t v : X → K)
    (hv : ∀ x, v x ≠ 0) :
    (∃ p : Polynomial K, ∀ x, v x * p.eval (m x) = v x * t x) ↔
      FactorsThrough m t := by
  constructor
  · rintro ⟨p, hp⟩
    apply (polynomialActionRealizes_iff_factorsThrough m t).1
    exact ⟨p, fun x ↦ mul_left_cancel₀ (hv x) (hp x)⟩
  · exact compile_factorsThrough_to_diagonalAction m t v

/-- The matrix whose `j`th column is the `j`th iterate of pointwise
multiplication by `m`, starting from `v`. -/
def diagonalOrbitMatrix (m v : Fin n → K) : Matrix (Fin n) (Fin n) K :=
  fun i j ↦ v i * m i ^ (j : ℕ)

theorem diagonalOrbitMatrix_eq
    (m v : Fin n → K) :
    diagonalOrbitMatrix m v = Matrix.diagonal v * Matrix.vandermonde m := by
  ext i j
  simp [diagonalOrbitMatrix, Matrix.vandermonde_apply]

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
  change (diagonalOrbitMatrix m v).det ≠ 0
  rw [det_diagonalOrbitMatrix]
  exact mul_ne_zero (Finset.prod_ne_zero_iff.mpr (fun i _ ↦ hv i))
    (Matrix.det_vandermonde_ne_zero_iff.mpr hm)

end Pairfield
