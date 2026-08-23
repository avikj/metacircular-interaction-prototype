import Pairfield.SmithPresentation
import Mathlib.Tactic.Linarith
import Mathlib.Tactic.Ring

/-!
# Constructive Smith presentation for rank-one 2-by-2 integer matrices

A rank-one matrix is supplied by an exact outer-product witness

`A = (g,k)ᵀ (p,q)`.

Two independent Bezout equations then normalize the row and column factors.
This formulation keeps every choice proof-relevant and makes the construction
composable with the repository's other Smith presentation arrows.
-/

namespace Pairfield.RankOneSmith2x2

open Pairfield

/-- The outer product `(g,k)ᵀ (p,q)`. -/
def outer (g k p q : Int) : IntMat2 :=
  ⟨g * p, g * q, k * p, k * q⟩

theorem det_outer (g k p q : Int) : (outer g k p q).det = 0 := by
  simp only [outer, IntMat2.det]
  ring

/-- Complete constructive data for reducing a rank-one matrix.  The row
factor `(p,q)` is primitive.  The column factor `(g,k)` has nonnegative gcd
`h`, with its normalized factors again accompanied by a Bezout witness.

The explicit equation `source_eq` makes this an interface for an arbitrary
matrix rather than a separate matrix representation. -/
structure Witness where
  source : IntMat2
  g : Int
  k : Int
  p : Int
  q : Int
  x : Int
  y : Int
  row_bezout : x * p + y * q = 1
  h : Int
  gp : Int
  kp : Int
  g_factor : g = h * gp
  k_factor : k = h * kp
  s : Int
  t : Int
  column_bezout : s * gp + t * kp = 1
  h_nonnegative : 0 ≤ h
  source_eq : source = outer g k p q

namespace Witness

theorem det_source (w : Witness) : w.source.det = 0 := by
  rw [w.source_eq]
  exact det_outer _ _ _ _

/-- The row operation sending `(g,k)ᵀ` to `(h,0)ᵀ`. -/
def left (w : Witness) : IntMat2 :=
  ⟨w.s, w.t, -w.kp, w.gp⟩

/-- The column operation sending `(p,q)` to `(1,0)`. -/
def right (w : Witness) : IntMat2 :=
  ⟨w.x, -w.q, w.y, w.p⟩

theorem det_left (w : Witness) : w.left.det = 1 := by
  simp only [left, IntMat2.det]
  linarith [w.column_bezout]

theorem det_right (w : Witness) : w.right.det = 1 := by
  simp only [right, IntMat2.det]
  linarith [w.row_bezout]

theorem replay (w : Witness) :
    IntMat2.diagonal w.h 0 = w.left * w.source * w.right := by
  rw [w.source_eq]
  apply IntMat2.ext <;>
    simp only [left, right, outer, IntMat2.diagonal, IntMat2.mul_def,
      IntMat2.mul]
  · calc
      w.h = w.h * (w.s * w.gp + w.t * w.kp) *
            (w.x * w.p + w.y * w.q) := by
            rw [w.column_bezout, w.row_bezout]
            ring
      _ = (w.s * (w.g * w.p) + w.t * (w.k * w.p)) * w.x +
          (w.s * (w.g * w.q) + w.t * (w.k * w.q)) * w.y := by
            rw [w.g_factor, w.k_factor]
            ring
  · rw [w.g_factor, w.k_factor]
    ring
  · rw [w.g_factor, w.k_factor]
    ring
  · rw [w.g_factor, w.k_factor]
    ring

/-- The rank-one reduction as a composable presentation arrow. -/
def presentation (w : Witness) :
    SmithPresentation w.source (IntMat2.diagonal w.h 0) where
  left := w.left
  right := w.right
  replay := w.replay
  left_unimodular := by
    unfold IntMat2.unimodular
    rw [w.det_left]
    decide
  right_unimodular := by
    unfold IntMat2.unimodular
    rw [w.det_right]
    decide

/-- Promotion through the common Smith certificate API. -/
def certificate (w : Witness) : SmithCertificate2 :=
  SmithPresentation.toCertificate w.h 0 w.presentation

theorem certificate_valid (w : Witness) :
    w.certificate.Valid := by
  apply SmithPresentation.toCertificate_valid w.presentation
  · exact w.h_nonnegative
  · exact le_rfl
  · intro _
    rfl
  · exact dvd_zero w.h

theorem certificate_check (w : Witness) :
    w.certificate.check = true :=
  SmithCertificate2.check_complete _ w.certificate_valid

end Witness

/-- The zero matrix is the rank-zero boundary of the construction. -/
def zeroPresentation :
    SmithPresentation (IntMat2.diagonal 0 0) (IntMat2.diagonal 0 0) :=
  SmithPresentation.identity _

def zeroCertificate : SmithCertificate2 :=
  SmithPresentation.toCertificate 0 0 zeroPresentation

theorem zeroCertificate_valid : zeroCertificate.Valid := by
  apply SmithPresentation.toCertificate_valid zeroPresentation <;> simp

/-! A sign-sensitive closed control.  The source has negative entries,
but the certified Smith diagonal is nonnegative. -/

def signedControl : Witness where
  source := ⟨-6, -9, 10, 15⟩
  g := -3
  k := 5
  p := 2
  q := 3
  x := -1
  y := 1
  row_bezout := by decide
  h := 1
  gp := -3
  kp := 5
  g_factor := by decide
  k_factor := by decide
  s := -2
  t := -1
  column_bezout := by decide
  h_nonnegative := by decide
  source_eq := by decide

example : signedControl.certificate.check = true := by
  exact signedControl.certificate_check

example : signedControl.certificate.diagonal = IntMat2.diagonal 1 0 := rfl

end Pairfield.RankOneSmith2x2
