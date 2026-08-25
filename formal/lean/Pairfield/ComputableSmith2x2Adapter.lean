import Pairfield.ComputableSmith2x2
import Pairfield.SmithPresentation

/-!
# Direct proof-language adapter for the executable diagonal Smith join

There is no serialization boundary here.  The matrices produced by
`ComputableSmith2x2.reduceDiagonal` are translated field-for-field into the
independently defined executable checker surface, and the producer's proofs
establish the full `SmithCertificate2.Valid` proposition.
-/

namespace Pairfield.ComputableSmith2x2

/-- The representation map is data-only and therefore backend executable. -/
def toIntMat2 (A : Mat2) : Pairfield.IntMat2 :=
  ⟨A.a11, A.a12, A.a21, A.a22⟩

@[simp] theorem toIntMat2_diag (a b : Int) :
    toIntMat2 (diag a b) = Pairfield.IntMat2.diagonal a b := rfl

@[simp] theorem toIntMat2_mul (A B : Mat2) :
    toIntMat2 (mul A B) = toIntMat2 A * toIntMat2 B := rfl

@[simp] theorem det_toIntMat2 (A : Mat2) :
    Pairfield.IntMat2.det (toIntMat2 A) = det A := rfl

/-- The diagonal join is an exact compositional presentation arrow. -/
def toPresentation (f : CoprimeFactors) : Pairfield.SmithPresentation
    (toIntMat2 (diag (f.g * f.p) (f.g * f.q)))
    (Pairfield.IntMat2.diagonal f.g (f.g * f.p * f.q)) := by
  let c := reduceDiagonal f
  refine ⟨toIntMat2 c.L, toIntMat2 c.R, ?_, ?_, ?_⟩
  · have hreplay := congrArg toIntMat2 c.replay
    simpa [c, reduceDiagonal, toIntMat2_mul, toIntMat2_diag] using hreplay.symm
  · unfold Pairfield.IntMat2.unimodular
    rw [det_toIntMat2, c.detL]
    decide
  · unfold Pairfield.IntMat2.unimodular
    rw [det_toIntMat2, c.detR]
    decide

/-- Translate the presentation through the repository's common certificate
promotion, rather than introducing another terminal certificate API. -/
def toSmithCertificate (f : CoprimeFactors) : Pairfield.SmithCertificate2 :=
  Pairfield.SmithPresentation.toCertificate f.g (f.g * f.p * f.q)
    (toPresentation f)

/-- The executable diagonal join inhabits the full checker proposition, with
exact replay, both unimodularity checks, signs, zero semantics, and the Smith
divisibility chain. -/
theorem toSmithCertificate_valid (f : CoprimeFactors)
    (hg : 0 ≤ f.g) (hd : 0 ≤ f.g * f.p * f.q) :
    (toSmithCertificate f).Valid := by
  apply Pairfield.SmithPresentation.toCertificate_valid
      (toPresentation f) hg hd
  · intro hzero
    simp [hzero]
  · exact (reduceDiagonal f).smithChain

/-- The adapter feeds the native Boolean checker without an untrusted gap. -/
theorem toSmithCertificate_check (f : CoprimeFactors)
    (hg : 0 ≤ f.g) (hd : 0 ≤ f.g * f.p * f.q) :
    (toSmithCertificate f).check = true :=
  Pairfield.SmithCertificate2.check_complete _
    (toSmithCertificate_valid f hg hd)

example :
    (toSmithCertificate (fromNatGcdOne 2 1 3 (by decide))).check = true := by
  apply toSmithCertificate_check <;> norm_num [fromNatGcdOne]

example :
    (toSmithCertificate (fromNatGcdOne 0 0 1 (by decide))).check = true := by
  apply toSmithCertificate_check <;> norm_num [fromNatGcdOne]

end Pairfield.ComputableSmith2x2
