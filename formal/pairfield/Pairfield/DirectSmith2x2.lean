import Mathlib
import Pairfield.SmithCertificate
import Pairfield.SmithPresentation

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
  have h : A 0 0 * A 1 1 - A 0 1 * A 1 0 = 1 := by
    simpa [Matrix.det_fin_two] using hdet
  refine ⟨?_, ?_, ?_, ?_, ?_, ?_, ?_⟩
  · apply Pairfield.IntMat2.ext <;>
      simp [unitDetCertificate, Pairfield.SmithCertificate2.diagonal,
        Pairfield.IntMat2.diagonal, Pairfield.IntMat2.one, Pairfield.IntMat2.mul,
        toIntMat2, Matrix.adjugate_fin_two] <;> linarith [h]
  · show (Pairfield.IntMat2.det _).natAbs = 1
    simp only [unitDetCertificate, Pairfield.IntMat2.det, toIntMat2,
      Matrix.adjugate_fin_two, Matrix.of_apply, Matrix.cons_val', Matrix.cons_val_zero,
      Matrix.cons_val_one, Matrix.empty_val', Matrix.cons_val_fin_one, Matrix.head_cons,
      Matrix.head_fin_const, Matrix.head_val']
    rw [show A 1 1 * A 0 0 - -A 0 1 * -A 1 0 =
        A 0 0 * A 1 1 - A 0 1 * A 1 0 by ring, h]
    rfl
  · show (Pairfield.IntMat2.det _).natAbs = 1
    rfl
  · exact zero_le_one
  · exact zero_le_one
  · exact fun hz => absurd hz one_ne_zero
  · exact dvd_refl 1

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
  have h : A 0 0 * A 1 1 - A 0 1 * A 1 0 = -1 := by
    simpa [Matrix.det_fin_two] using hdet
  refine ⟨?_, ?_, ?_, ?_, ?_, ?_, ?_⟩
  · apply Pairfield.IntMat2.ext <;>
      simp [negUnitDetCertificate, Pairfield.SmithCertificate2.diagonal,
        Pairfield.IntMat2.diagonal, Pairfield.IntMat2.one, Pairfield.IntMat2.mul,
        toIntMat2, Matrix.adjugate_fin_two] <;> linarith [h]
  · show (Pairfield.IntMat2.det _).natAbs = 1
    simp only [negUnitDetCertificate, Pairfield.IntMat2.det, toIntMat2,
      Matrix.adjugate_fin_two, Matrix.neg_apply, Matrix.of_apply, Matrix.cons_val',
      Matrix.cons_val_zero, Matrix.cons_val_one, Matrix.empty_val',
      Matrix.cons_val_fin_one, Matrix.head_cons, Matrix.head_fin_const, Matrix.head_val']
    rw [show -A 1 1 * -A 0 0 - - -A 0 1 * - -A 1 0 =
        A 0 0 * A 1 1 - A 0 1 * A 1 0 by ring, h]
    rfl
  · show (Pairfield.IntMat2.det _).natAbs = 1
    rfl
  · exact zero_le_one
  · exact zero_le_one
  · exact fun hz => absurd hz one_ne_zero
  · exact dvd_refl 1

def solveNegUnit (A : Mat2) (hdet : A.det = -1) (b : Fin 2 → ℤ) : Fin 2 → ℤ :=
  (compileNegUnitDet A hdet).left *ᵥ b

theorem solveNegUnit_spec (A : Mat2) (hdet : A.det = -1) (b : Fin 2 → ℤ) :
    A *ᵥ solveNegUnit A hdet b = b := by
  calc
    A *ᵥ solveNegUnit A hdet b =
        (A * (compileNegUnitDet A hdet).left) *ᵥ b := by
          simpa [solveNegUnit] using
            (mulVec_mulVec b A (compileNegUnitDet A hdet).left)
    _ = b := by rw [(compileNegUnitDet A hdet).rightInverse]; exact one_mulVec b

theorem solveNegUnit_unique (A : Mat2) (hdet : A.det = -1) (b x : Fin 2 → ℤ)
    (hx : A *ᵥ x = b) : x = solveNegUnit A hdet b := by
  calc
    x = ((compileNegUnitDet A hdet).left * A) *ᵥ x := by
      rw [(compileNegUnitDet A hdet).leftInverse]
      exact (one_mulVec x).symm
    _ = (compileNegUnitDet A hdet).left *ᵥ (A *ᵥ x) :=
      (mulVec_mulVec x (compileNegUnitDet A hdet).left A).symm
    _ = solveNegUnit A hdet b := by rw [hx]; rfl

/-- The compiled capability executes the unique integral solution of `A x=b`. -/
def solve (A : Mat2) (hdet : A.det = 1) (b : Fin 2 → ℤ) : Fin 2 → ℤ :=
  (compileUnitDet A hdet).left *ᵥ b

theorem solve_spec (A : Mat2) (hdet : A.det = 1) (b : Fin 2 → ℤ) :
    A *ᵥ solve A hdet b = b := by
  calc
    A *ᵥ solve A hdet b =
        (A * (compileUnitDet A hdet).left) *ᵥ b := by
          simpa [solve] using
            (mulVec_mulVec b A (compileUnitDet A hdet).left)
    _ = b := by rw [(compileUnitDet A hdet).rightInverse]; exact one_mulVec b

theorem solve_unique (A : Mat2) (hdet : A.det = 1) (b x : Fin 2 → ℤ)
    (hx : A *ᵥ x = b) : x = solve A hdet b := by
  calc
    x = ((compileUnitDet A hdet).left * A) *ᵥ x := by
      rw [(compileUnitDet A hdet).leftInverse]
      exact (one_mulVec x).symm
    _ = (compileUnitDet A hdet).left *ᵥ (A *ᵥ x) :=
      (mulVec_mulVec x (compileUnitDet A hdet).left A).symm
    _ = solve A hdet b := by rw [hx]; rfl

end Pairfield.DirectSmith2x2
