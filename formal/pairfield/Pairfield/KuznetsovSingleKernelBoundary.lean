import Mathlib
import Pairfield.FiniteInformation

/-!
# The single-kernel boundary in a Kuznetsov completion

For fixed signs, the scalar Bessel weight in the classical `GL₂` Kuznetsov
geometric term is evaluated at a function of `sqrt (m * n) / c`.  In
particular, at a fixed modulus it cannot distinguish two mode pairs with the
same product.

This file records only that exact factorization requirement and its smallest
finite hostile control.  It does not claim that the arithmetic weights in the
Goldbach boundary equal the control below, nor does it obstruct a linear
combination of kernels, a matrix-valued test, or a nonfactorizable relative
trace distribution.
-/

namespace Pairfield.KuznetsovSingleKernelBoundary

/-- The discrete indices of one positive-sign Kloosterman term. -/
structure ModeIndex where
  first : ℕ
  second : ℕ
  modulus : ℕ
deriving DecidableEq

/-- The algebraic information visible to one scalar radial Bessel kernel.
Keeping `(m*n,c)` rather than introducing square roots is enough for the
collision theorem below. -/
def scalarKernelShape (index : ModeIndex) : ℕ × ℕ :=
  (index.first * index.second, index.modulus)

/-- A coefficient family is representable by one scalar radial kernel only if
it descends through the scalar Bessel shape. -/
def SingleScalarKernel {T : Type*} (weight : ModeIndex → T) : Prop :=
  Pairfield.FactorsThrough scalarKernelShape weight

/-- Every single-kernel coefficient family is constant when both the mode
product and modulus agree. -/
theorem singleScalarKernel_collisionLaw {T : Type*}
    (weight : ModeIndex → T) (realizes : SingleScalarKernel weight)
    {left right : ModeIndex}
    (productAgreement : left.first * left.second =
      right.first * right.second)
    (modulusAgreement : left.modulus = right.modulus) :
    weight left = weight right := by
  apply (Pairfield.factorsThrough_iff_fiberConstant
    scalarKernelShape weight).mp realizes
  exact Prod.ext productAgreement modulusAgreement

/-- Two different ordered mode pairs with the same product and modulus. -/
def modeOneSix : ModeIndex := ⟨1, 6, 5⟩

def modeTwoThree : ModeIndex := ⟨2, 3, 5⟩

theorem mode_collision :
    scalarKernelShape modeOneSix = scalarKernelShape modeTwoThree := by
  decide

/-- An independent direct-frequency weight, of exactly the kind that an
arbitrary finite Fourier completion is allowed to carry. -/
def directFrequencyWeight (index : ModeIndex) : ℕ := index.first

theorem directFrequencyWeight_separates_collision :
    directFrequencyWeight modeOneSix ≠ directFrequencyWeight modeTwoThree := by
  decide

/-- Arbitrary mode-dependent coefficients do not, in general, come from one
scalar Kuznetsov kernel. -/
theorem directFrequencyWeight_not_singleScalarKernel :
    ¬SingleScalarKernel directFrequencyWeight := by
  intro realizes
  exact directFrequencyWeight_separates_collision
    ((Pairfield.factorsThrough_iff_fiberConstant
      scalarKernelShape directFrequencyWeight).mp realizes mode_collision)

/-- The square of the classical Bessel argument, with the inessential factor
`(4 * pi)^2` removed.  This is the correct collision coordinate when the
modulus is also allowed to vary. -/
def besselArgumentSquared (index : ModeIndex) : ℚ :=
  ((index.first * index.second : ℕ) : ℚ) /
    ((index.modulus * index.modulus : ℕ) : ℚ)

/-- The coefficient architecture obtained from one radial kernel together
with one independent weight on each Whittaker index. -/
def OneFactorableBilinearKernel (weight : ModeIndex → ℚ) : Prop :=
  ∃ left right : ℕ → ℚ, ∃ radial : ℚ → ℚ,
    ∀ index, weight index =
      left index.first * right index.second *
        radial (besselArgumentSquared index)

def squareModeOneOne : ModeIndex := ⟨1, 1, 1⟩
def squareModeOneNine : ModeIndex := ⟨1, 9, 3⟩
def squareModeFourOne : ModeIndex := ⟨4, 1, 2⟩
def squareModeFourNine : ModeIndex := ⟨4, 9, 6⟩

/-- All four modes lie on the same Bessel radial coordinate. -/
theorem squareModes_same_besselArgument :
    besselArgumentSquared squareModeOneOne = 1 ∧
    besselArgumentSquared squareModeOneNine = 1 ∧
    besselArgumentSquared squareModeFourOne = 1 ∧
    besselArgumentSquared squareModeFourNine = 1 := by
  norm_num [besselArgumentSquared, squareModeOneOne, squareModeOneNine,
    squareModeFourOne, squareModeFourNine]

/-- On one radial fiber, a factorable bilinear kernel has a vanishing `2×2`
minor. -/
theorem oneFactorableKernel_minor
    (weight : ModeIndex → ℚ)
    (realizes : OneFactorableBilinearKernel weight) :
    weight squareModeOneOne * weight squareModeFourNine =
      weight squareModeOneNine * weight squareModeFourOne := by
  rcases realizes with ⟨left, right, radial, realizes⟩
  rw [realizes squareModeOneOne, realizes squareModeFourNine,
    realizes squareModeOneNine, realizes squareModeFourOne]
  norm_num [besselArgumentSquared, squareModeOneOne, squareModeOneNine,
    squareModeFourOne, squareModeFourNine]
  ring

/-- A smallest crossed coefficient family on the four-mode control. -/
def crossedModeWeight (index : ModeIndex) : ℚ :=
  if index = squareModeOneOne ∨ index = squareModeFourNine then 1 else 0

theorem crossedModeWeight_values :
    crossedModeWeight squareModeOneOne = 1 ∧
    crossedModeWeight squareModeOneNine = 0 ∧
    crossedModeWeight squareModeFourOne = 0 ∧
    crossedModeWeight squareModeFourNine = 1 := by
  native_decide

/-- Even after allowing separable weights on the two Whittaker indices, one
factorable scalar kernel cannot realize an arbitrary completed coefficient
tensor. -/
theorem crossedModeWeight_not_oneFactorableKernel :
    ¬OneFactorableBilinearKernel crossedModeWeight := by
  intro realizes
  have minor := oneFactorableKernel_minor crossedModeWeight realizes
  norm_num [crossedModeWeight, squareModeOneOne, squareModeOneNine,
    squareModeFourOne, squareModeFourNine] at minor

end Pairfield.KuznetsovSingleKernelBoundary
