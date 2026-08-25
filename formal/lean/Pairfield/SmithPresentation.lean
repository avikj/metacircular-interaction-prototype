import Pairfield.SmithCertificate
import Mathlib.Tactic.Ring

/-!
# Compositional 2×2 integer presentations

A producer fragment need not return a final Smith certificate.  It may return
an exact change of presentation `A ⟶ B`; another fragment may continue from
`B`.  Composition multiplies the left transformations in reverse temporal
order and right transformations in temporal order:

`B = L₁ A R₁`, `D = L₂ B R₂`
implies `D = (L₂L₁) A (R₁R₂)`.

This file proves that replay and unimodularity compose.  Consequently every
new reducer stratum is additive: it can be installed as one more presentation
arrow without changing earlier producers or the final certificate gate.
-/

namespace Pairfield

namespace IntMat2

@[ext] theorem ext (A B : IntMat2)
    (h00 : A.a00 = B.a00) (h01 : A.a01 = B.a01)
    (h10 : A.a10 = B.a10) (h11 : A.a11 = B.a11) : A = B := by
  cases A
  cases B
  simp_all

theorem mul_assoc (A B C : IntMat2) : (A * B) * C = A * (B * C) := by
  ext <;> simp [mul_def, mul] <;> ring

theorem one_mul (A : IntMat2) : one * A = A := by
  ext <;> simp [mul_def, mul, one]

theorem mul_one (A : IntMat2) : A * one = A := by
  ext <;> simp [mul_def, mul, one]

theorem det_mul (A B : IntMat2) : det (A * B) = det A * det B := by
  simp [mul_def, mul, det]
  ring

theorem unimodular_mul {A B : IntMat2}
    (hA : A.unimodular) (hB : B.unimodular) : (A * B).unimodular := by
  unfold unimodular at hA hB ⊢
  rw [det_mul, Int.natAbs_mul, hA, hB]

end IntMat2

/-- One exact, invertible change of presentation. -/
structure SmithPresentation (source target : IntMat2) where
  left : IntMat2
  right : IntMat2
  replay : target = left * source * right
  left_unimodular : left.unimodular
  right_unimodular : right.unimodular

namespace SmithPresentation

def identity (A : IntMat2) : SmithPresentation A A where
  left := .one
  right := .one
  replay := by rw [IntMat2.one_mul, IntMat2.mul_one]
  left_unimodular := by decide
  right_unimodular := by decide

/-- Temporal composition.  Note the asymmetric multiplication order forced by
matrix action on the two sides. -/
def comp {A B D : IntMat2}
    (first : SmithPresentation A B) (second : SmithPresentation B D) :
    SmithPresentation A D where
  left := second.left * first.left
  right := first.right * second.right
  replay := by
    calc
      D = second.left * B * second.right := second.replay
      _ = second.left * (first.left * A * first.right) * second.right :=
        congrArg (fun X => second.left * X * second.right) first.replay
      _ = (second.left * first.left) * A * (first.right * second.right) := by
        simp only [IntMat2.mul_assoc]
  left_unimodular :=
    IntMat2.unimodular_mul second.left_unimodular first.left_unimodular
  right_unimodular :=
    IntMat2.unimodular_mul first.right_unimodular second.right_unimodular

theorem comp_replay {A B D : IntMat2}
    (first : SmithPresentation A B) (second : SmithPresentation B D) :
    D = (comp first second).left * A * (comp first second).right :=
  (comp first second).replay

/-- A final normal target promotes a presentation arrow to the common gate. -/
def toCertificate {A : IntMat2} (d₁ d₂ : Int)
    (presentation : SmithPresentation A (.diagonal d₁ d₂)) :
    SmithCertificate2 :=
  ⟨A, presentation.left, d₁, d₂, presentation.right⟩

theorem toCertificate_valid {A : IntMat2} {d₁ d₂ : Int}
    (presentation : SmithPresentation A (.diagonal d₁ d₂))
    (hd₁ : 0 ≤ d₁) (hd₂ : 0 ≤ d₂)
    (hzero : d₁ = 0 → d₂ = 0) (hdiv : d₁ ∣ d₂) :
    (toCertificate d₁ d₂ presentation).Valid := by
  exact ⟨presentation.replay,
    presentation.left_unimodular,
    presentation.right_unimodular,
    hd₁, hd₂, hzero, hdiv⟩

end SmithPresentation

end Pairfield
