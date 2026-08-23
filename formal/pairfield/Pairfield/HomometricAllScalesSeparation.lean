/-
Copyright (c) 2026 Avik Jain and the mathematics collaboration.
Released under Apache 2.0 license.

The explicit fixed-scale homometric pair becomes distinguishable as soon as
its indexed diagonal-energy coefficients are retained.
-/
import Pairfield.FixedScaleAutocorrelationAmbiguity
import Pairfield.AllScalesPairFieldReconstruction

namespace Pairfield.HomometricAllScalesSeparation

open Pairfield.FixedScaleAutocorrelationAmbiguity
open Pairfield.AllScalesPairFieldReconstruction

/-- Embed a signal on `ZMod 23` into a real sequence using the canonical
representatives `0,…,22`, and extend it by zero outside that range. -/
def indexedRealSignal (signal : ZMod 23 → ℕ) (n : ℕ) : ℝ :=
  if n < 23 then (signal (n : ZMod 23) : ℝ) else 0

def firstIndexed : ℕ → ℝ := indexedRealSignal firstSignal

def secondIndexed : ℕ → ℝ := indexedRealSignal secondSignal

@[simp] theorem firstIndexed_two : firstIndexed 2 = 1 := by
  have h : firstSignal (2 : ZMod 23) = 1 := by native_decide
  norm_num [firstIndexed, indexedRealSignal, h]

@[simp] theorem secondIndexed_two : secondIndexed 2 = 0 := by
  have h : secondSignal (2 : ZMod 23) = 0 := by native_decide
  norm_num [secondIndexed, indexedRealSignal, h]

/-- The indexed diagonal-energy coefficient at two is `1` for the first
signal and `0` for the second. -/
theorem diagonalEnergy_two_values :
    diagonalEnergy firstIndexed 2 = 1 ∧
      diagonalEnergy secondIndexed 2 = 0 := by
  simp [diagonalEnergy, rankOnePairField]

theorem diagonalEnergy_two_ne :
    diagonalEnergy firstIndexed 2 ≠ diagonalEnergy secondIndexed 2 := by
  rw [diagonalEnergy_two_values.1, diagonalEnergy_two_values.2]
  norm_num

/-- Thus the complete indexed diagonal coefficient fields are unequal. -/
theorem diagonalEnergy_fields_ne :
    diagonalEnergy firstIndexed ≠ diagonalEnergy secondIndexed := by
  intro equal
  exact diagonalEnergy_two_ne (congrFun equal 2)

/-- Packaged exact contrast: complete fixed-scale autocorrelation agrees, the
signals remain inequivalent under translations and translated reflections,
but the all-scale diagonal coefficient field separates them at index two. -/
theorem fixedScale_homometric_but_diagonalEnergy_separates :
    cyclicAutocorrelation firstSignal = cyclicAutocorrelation secondSignal ∧
      (∀ shift : ZMod 23, ∃ x : ZMod 23,
        firstSignal x ≠ translate secondSignal shift x) ∧
      (∀ shift : ZMod 23, ∃ x : ZMod 23,
        firstSignal x ≠ reflectedTranslate secondSignal shift x) ∧
      diagonalEnergy firstIndexed 2 ≠ diagonalEnergy secondIndexed 2 :=
  ⟨first_second_same_cyclicAutocorrelation,
    first_not_translate_of_second,
    first_not_reflectedTranslate_of_second,
    diagonalEnergy_two_ne⟩

/-- Any concrete all-scale field for which Laplace coefficient uniqueness has
been supplied must also separate the embedded homometric signals. -/
theorem coefficientUnique_allScaleField_separates
    (field : (ℕ → ℝ) → ℝ → ℝ)
    (coefficientUnique : HasDiagonalLaplaceCoefficientUniqueness field) :
    field firstIndexed ≠ field secondIndexed := by
  intro equal
  have henergy := coefficientUnique firstIndexed secondIndexed equal
  exact diagonalEnergy_two_ne (congrFun henergy 2)

end Pairfield.HomometricAllScalesSeparation
