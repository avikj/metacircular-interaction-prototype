import Mathlib.Data.Complex.Basic

/-!
# The bilinear/Hermitian boundary for a two-site reflection

bilinear coefficient product and warns that replacing it by absolute squares
is valid only for real diagonal signals.  This file checks the smallest hostile
control: the complex two-site signal `(1, i)`.

No Hahn eigenbasis, prime signal, heat kernel, or arithmetic estimate is
constructed here.  The result only prevents the real identity from being
silently extended to arbitrary complex signals.
-/

namespace Pairfield.HahnBilinearBoundary

open Complex

/-- A signal on two sites exchanged by reflection. -/
structure TwoSiteSignal where
  left : ℂ
  right : ℂ

/-- Unnormalised reflection-even coefficient. -/
def evenCoeff (signal : TwoSiteSignal) : ℂ :=
  signal.left + signal.right

/-- Unnormalised reflection-odd coefficient. -/
def oddCoeff (signal : TwoSiteSignal) : ℂ :=
  signal.left - signal.right

/-- Bilinear parity contrast: no conjugation. -/
def bilinearParity (signal : TwoSiteSignal) : ℂ :=
  evenCoeff signal ^ 2 - oddCoeff signal ^ 2

/-- Hermitian absolute-square parity contrast, embedded back into `ℂ`. -/
def absoluteSquareParity (signal : TwoSiteSignal) : ℂ :=
  ((normSq (evenCoeff signal) - normSq (oddCoeff signal) : ℝ) : ℂ)

/-- The smallest nonreal hostile control. -/
def imaginaryControl : TwoSiteSignal where
  left := 1
  right := I

theorem bilinearParity_imaginaryControl :
    bilinearParity imaginaryControl = 4 * I := by
  simp [bilinearParity, evenCoeff, oddCoeff, imaginaryControl]
  ring

theorem absoluteSquareParity_imaginaryControl :
    absoluteSquareParity imaginaryControl = 0 := by
  norm_num [absoluteSquareParity, evenCoeff, oddCoeff, imaginaryControl,
    Complex.normSq_apply]

/-- The bilinear reflection formula cannot be replaced by absolute squares
for arbitrary complex signals. -/
theorem bilinear_ne_absoluteSquare :
    bilinearParity imaginaryControl ≠ absoluteSquareParity imaginaryControl := by
  rw [bilinearParity_imaginaryControl, absoluteSquareParity_imaginaryControl]
  norm_num

end Pairfield.HahnBilinearBoundary
