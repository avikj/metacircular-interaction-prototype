import Mathlib

/-!
# A checked fixed-scale phase-retrieval ambiguity

The classical homometric pair

`{0,1,2,6,8,11}` and `{0,1,6,7,9,11}`

has the same complete difference autocorrelation but is related by neither a
translation nor a translated reflection.  We place it in `ZMod 23`; because
all ordinary differences lie in `[-11,11]`, this modulus does not identify
distinct differences from the displayed supports.

This finite exact control is the obstruction behind reconstructing a signal
from one fixed-scale modulus square.  It does not contradict reconstruction
after an additional scale variable separates coefficient pairs.
-/

namespace Pairfield.FixedScaleAutocorrelationAmbiguity

def firstSignal (x : ZMod 23) : ℕ :=
  if x.val = 0 ∨ x.val = 1 ∨ x.val = 2 ∨ x.val = 6 ∨
      x.val = 8 ∨ x.val = 11 then 1 else 0

def secondSignal (x : ZMod 23) : ℕ :=
  if x.val = 0 ∨ x.val = 1 ∨ x.val = 6 ∨ x.val = 7 ∨
      x.val = 9 ∨ x.val = 11 then 1 else 0

/-- Periodic difference autocorrelation. -/
def cyclicAutocorrelation (signal : ZMod 23 → ℕ) (shift : ZMod 23) : ℕ :=
  ∑ x : ZMod 23, signal x * signal (x + shift)

def translate (signal : ZMod 23 → ℕ) (shift : ZMod 23) : ZMod 23 → ℕ :=
  fun x ↦ signal (x + shift)

def reflectedTranslate
    (signal : ZMod 23 → ℕ) (shift : ZMod 23) : ZMod 23 → ℕ :=
  fun x ↦ signal (shift - x)

/-- The two signals have identical autocorrelation at every shift. -/
theorem first_second_same_cyclicAutocorrelation :
    cyclicAutocorrelation firstSignal = cyclicAutocorrelation secondSignal := by
  native_decide

theorem firstSignal_ne_secondSignal : firstSignal ≠ secondSignal := by
  intro equal
  have atTwo := congrFun equal (2 : ZMod 23)
  have firstAtTwo : firstSignal (2 : ZMod 23) = 1 := by native_decide
  have secondAtTwo : secondSignal (2 : ZMod 23) = 0 := by native_decide
  rw [firstAtTwo, secondAtTwo] at atTwo
  norm_num at atTwo

/-- The ambiguity survives quotienting by translations. -/
theorem first_not_translate_of_second :
    ∀ shift : ZMod 23, ∃ x : ZMod 23,
      firstSignal x ≠ translate secondSignal shift x := by
  native_decide

/-- It also survives quotienting by the usual reflection/translation
symmetry of one-dimensional phase retrieval. -/
theorem first_not_reflectedTranslate_of_second :
    ∀ shift : ZMod 23, ∃ x : ZMod 23,
      firstSignal x ≠ reflectedTranslate secondSignal shift x := by
  native_decide

/-- Packaged noninjectivity control modulo the standard trivial symmetries. -/
theorem fixedScale_phaseRetrieval_obstruction :
    cyclicAutocorrelation firstSignal = cyclicAutocorrelation secondSignal ∧
      (∀ shift : ZMod 23, ∃ x : ZMod 23,
        firstSignal x ≠ translate secondSignal shift x) ∧
      (∀ shift : ZMod 23, ∃ x : ZMod 23,
        firstSignal x ≠ reflectedTranslate secondSignal shift x) :=
  ⟨first_second_same_cyclicAutocorrelation,
    first_not_translate_of_second,
    first_not_reflectedTranslate_of_second⟩

end Pairfield.FixedScaleAutocorrelationAmbiguity
