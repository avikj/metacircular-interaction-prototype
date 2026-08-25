import Mathlib.Data.Int.GCD

/-!
# An executable, independently checked 2×2 Smith certificate

The producer is deliberately absent from the trusted surface.  Any program may
propose `L,D,R`; this module computes whether the proposal is a valid Smith
presentation of the declared source.  `check_sound` turns Boolean acceptance
back into the exact proposition checked by Lean.
-/

namespace Pairfield

/-- A concrete row-major 2×2 integer matrix. -/
structure IntMat2 where
  a00 : Int
  a01 : Int
  a10 : Int
  a11 : Int
  deriving DecidableEq, Repr

namespace IntMat2

def one : IntMat2 := ⟨1, 0, 0, 1⟩

def diagonal (d₁ d₂ : Int) : IntMat2 := ⟨d₁, 0, 0, d₂⟩

def mul (A B : IntMat2) : IntMat2 :=
  ⟨A.a00 * B.a00 + A.a01 * B.a10,
   A.a00 * B.a01 + A.a01 * B.a11,
   A.a10 * B.a00 + A.a11 * B.a10,
   A.a10 * B.a01 + A.a11 * B.a11⟩

instance : Mul IntMat2 := ⟨mul⟩

def det (A : IntMat2) : Int := A.a00 * A.a11 - A.a01 * A.a10

def unimodular (A : IntMat2) : Prop := A.det.natAbs = 1

instance (A : IntMat2) : Decidable A.unimodular := by
  unfold unimodular
  infer_instance

@[simp] theorem mul_def (A B : IntMat2) : A * B = mul A B := rfl

end IntMat2

/-- Data emitted by an untrusted Smith producer. -/
structure SmithCertificate2 where
  source : IntMat2
  left : IntMat2
  d₁ : Int
  d₂ : Int
  right : IntMat2
  deriving DecidableEq, Repr

namespace SmithCertificate2

def diagonal (c : SmithCertificate2) : IntMat2 := .diagonal c.d₁ c.d₂

/-- Exact acceptance proposition.  This is intentionally stronger than merely
checking determinant/gcd invariants: it checks the whole transformation. -/
def Valid (c : SmithCertificate2) : Prop :=
  c.diagonal = c.left * c.source * c.right ∧
  c.left.unimodular ∧
  c.right.unimodular ∧
  0 ≤ c.d₁ ∧
  0 ≤ c.d₂ ∧
  (c.d₁ = 0 → c.d₂ = 0) ∧
  c.d₁ ∣ c.d₂

instance (c : SmithCertificate2) : Decidable c.Valid := by
  unfold Valid
  infer_instance

/-- Native executable checker. -/
def check (c : SmithCertificate2) : Bool := decide c.Valid

/-- Boolean acceptance cannot drift away from the proposition: they are the
same decision procedure. -/
theorem check_sound (c : SmithCertificate2) (h : c.check = true) : c.Valid := by
  exact of_decide_eq_true h

theorem check_complete (c : SmithCertificate2) (h : c.Valid) : c.check = true := by
  exact decide_eq_true h

/-- A zero matrix has a valid fully free Smith presentation. -/
def zeroCertificate : SmithCertificate2 :=
  ⟨⟨0, 0, 0, 0⟩, .one, 0, 0, .one⟩

example : zeroCertificate.check = true := by decide

/-- A nontrivial exact control: diag(2,6) is already Smith normal. -/
def diagonalCertificate : SmithCertificate2 :=
  ⟨.diagonal 2 6, .one, 2, 6, .one⟩

example : diagonalCertificate.check = true := by decide

/-- Divisibility is load-bearing: diag(6,2) is diagonal but not Smith normal. -/
def wrongOrderCertificate : SmithCertificate2 :=
  ⟨.diagonal 6 2, .one, 6, 2, .one⟩

example : wrongOrderCertificate.check = false := by decide

/-- Transformation replay is load-bearing: changing a source entry is refused. -/
def forgedReplayCertificate : SmithCertificate2 :=
  ⟨⟨2, 1, 0, 6⟩, .one, 2, 6, .one⟩

example : forgedReplayCertificate.check = false := by decide

end SmithCertificate2

end Pairfield
