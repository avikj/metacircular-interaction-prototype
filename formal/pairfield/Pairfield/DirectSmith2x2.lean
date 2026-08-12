import Mathlib
import Pairfield.SmithCertificate

namespace Pairfield.DirectSmith2x2

open Matrix

abbrev Mat2 := Matrix (Fin 2) (Fin 2) ℤ

def toIntMat2 (A : Mat2) : Pairfield.IntMat2 :=
  ⟨A 0 0, A 0 1, A 1 0, A 1 1⟩

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

/-- The direct determinant-one construction inhabits the shared executable
certificate contract; this is an adapter, not a second validity notion. -/
def unitDetCertificate (A : Mat2) (hdet : A.det = 1) : Pairfield.SmithCertificate2 :=
  { source := toIntMat2 A
    left := toIntMat2 (adjugate A)
    d₁ := 1
    d₂ := 1
    right := Pairfield.IntMat2.one }

theorem unitDetCertificate_valid (A : Mat2) (hdet : A.det = 1) :
    (unitDetCertificate A hdet).Valid := by
  unfold Pairfield.SmithCertificate2.Valid unitDetCertificate
  constructor
  · apply Pairfield.IntMat2.ext <;>
      simp [Pairfield.SmithCertificate2.diagonal, Pairfield.IntMat2.diagonal,
        Pairfield.IntMat2.one, Pairfield.IntMat2.mul, toIntMat2, Matrix.adjugate_fin_two,
        Matrix.det_fin_two] at hdet ⊢ <;> omega
  constructor
  · unfold Pairfield.IntMat2.unimodular
    simp [Pairfield.IntMat2.det, toIntMat2, Matrix.adjugate_fin_two,
      Matrix.det_fin_two] at hdet ⊢
    omega
  · norm_num [Pairfield.IntMat2.unimodular, Pairfield.IntMat2.one,
      Pairfield.IntMat2.det]

/-- Determinant minus one is the next closed stratum: negating the adjugate
normalizes both products from `-I` to `I`. -/
def compileNegUnitDet (A : Mat2) (hdet : A.det = -1) : UnitDetCapability A where
  left := -adjugate A
  right := 1
  normal := 1
  replay := by simp [adjugate_mul, hdet]
  leftInverse := by simp [adjugate_mul, hdet]
  rightInverse := by simp [mul_adjugate, hdet]

def negUnitDetCertificate (A : Mat2) (hdet : A.det = -1) :
    Pairfield.SmithCertificate2 :=
  { source := toIntMat2 A
    left := toIntMat2 (-adjugate A)
    d₁ := 1
    d₂ := 1
    right := Pairfield.IntMat2.one }

theorem negUnitDetCertificate_valid (A : Mat2) (hdet : A.det = -1) :
    (negUnitDetCertificate A hdet).Valid := by
  unfold Pairfield.SmithCertificate2.Valid negUnitDetCertificate
  constructor
  · apply Pairfield.IntMat2.ext <;>
      simp [Pairfield.SmithCertificate2.diagonal, Pairfield.IntMat2.diagonal,
        Pairfield.IntMat2.one, Pairfield.IntMat2.mul, toIntMat2, Matrix.adjugate_fin_two,
        Matrix.det_fin_two] at hdet ⊢ <;> omega
  constructor
  · unfold Pairfield.IntMat2.unimodular
    simp [Pairfield.IntMat2.det, toIntMat2, Matrix.adjugate_fin_two,
      Matrix.det_fin_two] at hdet ⊢
    omega
  · norm_num [Pairfield.IntMat2.unimodular, Pairfield.IntMat2.one,
      Pairfield.IntMat2.det]

def solveNegUnit (A : Mat2) (hdet : A.det = -1) (b : Fin 2 → ℤ) : Fin 2 → ℤ :=
  (compileNegUnitDet A hdet).left *ᵥ b

theorem solveNegUnit_spec (A : Mat2) (hdet : A.det = -1) (b : Fin 2 → ℤ) :
    A *ᵥ solveNegUnit A hdet b = b := by
  rw [solveNegUnit, ← mulVec_mulVec, (compileNegUnitDet A hdet).rightInverse]
  exact one_mulVec b

theorem solveNegUnit_unique (A : Mat2) (hdet : A.det = -1) (b x : Fin 2 → ℤ)
    (hx : A *ᵥ x = b) : x = solveNegUnit A hdet b := by
  rw [solveNegUnit, ← hx, ← mulVec_mulVec,
    (compileNegUnitDet A hdet).leftInverse]
  exact one_mulVec x

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
