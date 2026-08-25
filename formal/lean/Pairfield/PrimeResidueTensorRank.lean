import Pairfield.PrimeResidueKloostermanBoundary

/-!
# Exact CRT tensor rank of the prime representatives modulo six

`PrimeResidueKloostermanBoundary` proves that the prime-representative weight
on `ZMod 6 ≃ ZMod 2 × ZMod 3` is not one pure tensor.  Here we exhibit two
pure tensors whose sum is exactly that weight.  Thus the finite control does
not prohibit a sum of factorizable automorphic tests; it says that one local
Euler tensor is already insufficient.
-/

namespace Pairfield.PrimeResidueTensorRank

open PrimeResidueKloostermanBoundary

/-- Representation by a sum of at most two pure CRT tensors. -/
def CRTTensorRankAtMostTwo (weight : ZMod 6 → ℂ) : Prop :=
  ∃ left₀ left₁ : ZMod 2 → ℂ, ∃ right₀ right₁ : ZMod 3 → ℂ,
    ∀ x, weight x =
      left₀ (modTwo x) * right₀ (modThree x) +
      left₁ (modTwo x) * right₁ (modThree x)

/-- Select the even CRT row. -/
def evenRow (x : ZMod 2) : ℂ := if x = 0 then 1 else 0

/-- On the even row, only residue `2 mod 3` is prime-represented. -/
def evenPrimeColumns (x : ZMod 3) : ℂ := if x = 2 then 1 else 0

/-- Select the odd CRT row. -/
def oddRow (x : ZMod 2) : ℂ := if x = 1 then 1 else 0

/-- On the odd row, residues `0` and `2 mod 3` are represented by `3` and
`5`, respectively. -/
def oddPrimeColumns (x : ZMod 3) : ℂ :=
  if x = 0 ∨ x = 2 then 1 else 0

@[simp] theorem primeResidueWeightSix_one :
    primeResidueWeightSix 1 = 0 := by
  have h : ¬((1 : ZMod 6).val = 2 ∨ (1 : ZMod 6).val = 3 ∨
      (1 : ZMod 6).val = 5) := by decide
  simp only [primeResidueWeightSix, h, if_false]

@[simp] theorem primeResidueWeightSix_four :
    primeResidueWeightSix 4 = 0 := by
  have h : ¬((4 : ZMod 6).val = 2 ∨ (4 : ZMod 6).val = 3 ∨
      (4 : ZMod 6).val = 5) := by decide
  simp only [primeResidueWeightSix, h, if_false]

@[simp] theorem primeResidueWeightSix_five :
    primeResidueWeightSix 5 = 1 := by
  have h : (5 : ZMod 6).val = 2 ∨ (5 : ZMod 6).val = 3 ∨
      (5 : ZMod 6).val = 5 := Or.inr (Or.inr (by decide))
  simp only [primeResidueWeightSix, h, if_true]

@[simp] theorem modTwo_one : modTwo 1 = 1 := by decide
@[simp] theorem modTwo_four : modTwo 4 = 0 := by decide
@[simp] theorem modTwo_five : modTwo 5 = 1 := by decide

@[simp] theorem modThree_one : modThree 1 = 1 := by decide
@[simp] theorem modThree_four : modThree 4 = 1 := by decide
@[simp] theorem modThree_five : modThree 5 = 2 := by decide

/-- Two pure CRT tensors reconstruct the finite prime-residue weight. -/
theorem primeResidueWeightSix_rankAtMostTwo :
    CRTTensorRankAtMostTwo primeResidueWeightSix := by
  refine ⟨evenRow, oddRow, evenPrimeColumns, oddPrimeColumns, ?_⟩
  intro x
  rw [← ZMod.natCast_zmod_val x]
  have hlt := x.val_lt
  interval_cases hval : x.val <;>
    simp [evenRow, evenPrimeColumns, oddRow, oddPrimeColumns] <;> decide

/-- Exact finite statement: the prime-residue weight has CRT tensor rank two,
in the sense of “not one pure tensor, but a sum of two.” -/
theorem primeResidueWeightSix_CRTTensorRankExactlyTwo :
    (¬CRTFactorable primeResidueWeightSix) ∧
      CRTTensorRankAtMostTwo primeResidueWeightSix :=
  ⟨primeResidueWeightSix_not_CRTFactorable,
    primeResidueWeightSix_rankAtMostTwo⟩

end Pairfield.PrimeResidueTensorRank
