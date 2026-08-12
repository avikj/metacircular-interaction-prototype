import Mathlib.Algebra.EuclideanDomain.Int
import Mathlib.Data.Int.GCD
import Mathlib.Tactic.Linarith
import Mathlib.Tactic.NormNum
import Mathlib.Tactic.Ring

/-!
A backend-executable 2-by-2 Smith join.

This is deliberately not a second implementation of a mutable Smith reducer.
It isolates the exact step used after two entries have been written as a
common factor times a coprime pair.  Extended Euclid supplies the coprimality
witness; the reduction itself is a closed formula, so its termination is
structural and transparent to Lean's code generator.
-/

namespace Pairfield.ComputableSmith2x2

/-- A small, code-generator-friendly representation of a 2-by-2 matrix. -/
structure Mat2 where
  a11 : Int
  a12 : Int
  a21 : Int
  a22 : Int
  deriving DecidableEq, Repr

@[ext] theorem Mat2.ext (A B : Mat2)
    (h11 : A.a11 = B.a11) (h12 : A.a12 = B.a12)
    (h21 : A.a21 = B.a21) (h22 : A.a22 = B.a22) : A = B := by
  cases A
  cases B
  simp_all

def mul (A B : Mat2) : Mat2 :=
  ⟨A.a11 * B.a11 + A.a12 * B.a21,
   A.a11 * B.a12 + A.a12 * B.a22,
   A.a21 * B.a11 + A.a22 * B.a21,
   A.a21 * B.a12 + A.a22 * B.a22⟩

def diag (a b : Int) : Mat2 := ⟨a, 0, 0, b⟩

def det (A : Mat2) : Int := A.a11 * A.a22 - A.a12 * A.a21

/-- The proof-relevant input to the diagonal join.  `p` and `q` are coprime,
with an explicit Bézout equation. -/
structure CoprimeFactors where
  (g p q x y : Int)
  bezout : x * p + y * q = 1

/-- The complete replay certificate.  Determinant one is stronger than merely
asking that the two change-of-basis matrices have determinant `±1`. -/
structure Certificate (A : Mat2) where
  L : Mat2
  D : Mat2
  R : Mat2
  replay : mul (mul L A) R = D
  detL : det L = 1
  detR : det R = 1
  smithChain : D.a11 ∣ D.a22

/-- Closed-form diagonal Smith join.  It sends
`diag (g*p) (g*q)` to `diag g (g*p*q)` whenever `xp+yq=1`.

No recursion or search occurs here.  Thus evaluation terminates by reduction;
the only iterative producer needed upstream is mathlib's terminating extended
Euclidean algorithm (`EuclideanDomain.gcdA/gcdB`). -/
def reduceDiagonal (f : CoprimeFactors) :
    Certificate (diag (f.g * f.p) (f.g * f.q)) := by
  let L : Mat2 := ⟨f.x, f.y, -f.q, f.p⟩
  let R : Mat2 := ⟨1, -(f.y * f.q), 1, f.x * f.p⟩
  let D := diag f.g (f.g * f.p * f.q)
  refine ⟨L, D, R, ?_, ?_, ?_, ?_⟩
  · apply Mat2.ext
    · dsimp [L, R, D, mul, diag]
      simp only [mul_zero, add_zero, zero_add, mul_one]
      calc
        f.x * (f.g * f.p) + f.y * (f.g * f.q) =
            f.g * (f.x * f.p + f.y * f.q) := by ring
        _ = f.g := by rw [f.bezout]; ring
    · dsimp [L, R, D, mul, diag]
      ring
    · dsimp [L, R, D, mul, diag]
      ring
    · dsimp [L, R, D, mul, diag]
      simp only [mul_zero, add_zero, zero_add, neg_mul, mul_neg, neg_neg]
      calc
        f.q * (f.g * f.p) * (f.y * f.q) +
            f.p * (f.g * f.q) * (f.x * f.p) =
            f.g * f.p * f.q * (f.x * f.p + f.y * f.q) := by ring
        _ = f.g * f.p * f.q := by rw [f.bezout]; ring
  · dsimp [L, det]
    nlinarith [f.bezout]
  · dsimp [R, det]
    nlinarith [f.bezout]
  · refine ⟨f.p * f.q, ?_⟩
    change f.g * f.p * f.q = f.g * (f.p * f.q)
    ring

/-- Mathlib's executable extended Euclidean algorithm supplies the coefficients
needed by `reduceDiagonal`.  The side condition says precisely that the
normalized factors have gcd one. -/
def fromNatGcdOne (g : Int) (p q : Nat) (h : Nat.gcd p q = 1) :
  CoprimeFactors :=
  ⟨g, p, q, Nat.gcdA p q, Nat.gcdB p q, by
    have hb := Nat.gcd_eq_gcd_ab p q
    rw [h] at hb
    exact (by simpa [mul_comm] using hb.symm)⟩

example :
    (reduceDiagonal (fromNatGcdOne 2 1 3 (by decide))).D = diag 2 6 := by
  rfl

/-- The zero-invariant case is not exceptional: `diag 0 g` is swapped to
`diag g 0`, and `diag 0 0` remains zero (choose the coprime pair `0,1` and
`g=0`). -/
example :
    (reduceDiagonal (fromNatGcdOne 7 0 1 (by decide))).D = diag 7 0 := by
  rfl

example :
    (reduceDiagonal (fromNatGcdOne 0 0 1 (by decide))).D = diag 0 0 := by
  rfl

-- Evaluated by Lean's compiled backend; proofs are erased.
#eval (reduceDiagonal (fromNatGcdOne 6 2 3 (by decide))).D

end Pairfield.ComputableSmith2x2
