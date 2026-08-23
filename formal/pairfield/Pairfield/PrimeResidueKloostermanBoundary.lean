/-
Copyright (c) 2026 Avik Jain and the mathematics collaboration.
Released under Apache 2.0 license.

The smallest finite separation between additive Kloosterman completion and a
CRT Euler-product ansatz.  The actual prime-indicator weight on the standard
residues `0, ..., 5` has an exact finite Kloosterman completion because every
residue weight does, but it is not a rank-one product of a mod-2 weight and a
mod-3 weight.

This only rejects the displayed scalar CRT-factorization ansatz.  The finite
Kloosterman expansion is retained, and no obstruction is asserted for a
nonfactorizable automorphic test function, kernel, orbital integral, period,
or relative trace distribution on `GL₂`.
-/
import Pairfield.FiniteKloostermanCompletion

namespace Pairfield

open FiniteKloostermanCompletion

namespace PrimeResidueKloostermanBoundary

/-- Reduction of a residue modulo `6` to its mod-`2` coordinate. -/
def modTwo : ZMod 6 → ZMod 2 :=
  ZMod.castHom (by norm_num : 2 ∣ 6) (ZMod 2)

/-- Reduction of a residue modulo `6` to its mod-`3` coordinate. -/
def modThree : ZMod 6 → ZMod 3 :=
  ZMod.castHom (by norm_num : 3 ∣ 6) (ZMod 3)

/-- The simplest Euler-factorizable ansatz at the coprime factorization
`6 = 2 * 3`: one scalar local factor at each CRT coordinate. -/
def CRTFactorable (weight : ZMod 6 → ℂ) : Prop :=
  ∃ localTwo : ZMod 2 → ℂ, ∃ localThree : ZMod 3 → ℂ,
    ∀ x, weight x = localTwo (modTwo x) * localThree (modThree x)

/-- The indicator of the actual prime representatives `2`, `3`, and `5`
among the standard representatives `0, ..., 5` of `ZMod 6`. -/
def primeResidueWeightSix (x : ZMod 6) : ℂ :=
  if x.val = 2 ∨ x.val = 3 ∨ x.val = 5 then 1 else 0

@[simp] theorem primeResidueWeightSix_zero :
    primeResidueWeightSix 0 = 0 := by
  have h : ¬((0 : ZMod 6).val = 2 ∨ (0 : ZMod 6).val = 3 ∨
      (0 : ZMod 6).val = 5) := by decide
  simp only [primeResidueWeightSix, h, if_false]

@[simp] theorem primeResidueWeightSix_two :
    primeResidueWeightSix 2 = 1 := by
  have h : (2 : ZMod 6).val = 2 ∨ (2 : ZMod 6).val = 3 ∨
      (2 : ZMod 6).val = 5 := Or.inl (by decide)
  simp only [primeResidueWeightSix, h, if_true]

@[simp] theorem primeResidueWeightSix_three :
    primeResidueWeightSix 3 = 1 := by
  have h : (3 : ZMod 6).val = 2 ∨ (3 : ZMod 6).val = 3 ∨
      (3 : ZMod 6).val = 5 := Or.inr (Or.inl (by decide))
  simp only [primeResidueWeightSix, h, if_true]

@[simp] theorem modTwo_zero : modTwo 0 = 0 := by
  decide

@[simp] theorem modTwo_two : modTwo 2 = 0 := by
  decide

@[simp] theorem modTwo_three : modTwo 3 = 1 := by
  decide

@[simp] theorem modThree_zero : modThree 0 = 0 := by
  decide

@[simp] theorem modThree_two : modThree 2 = 2 := by
  decide

@[simp] theorem modThree_three : modThree 3 = 0 := by
  decide

/-- The prime residue weight has a nonzero `2`-row/`2`-column value and a
nonzero `3`-row/`3`-column value while its shared CRT corner is zero.  Hence
it is not a rank-one product of local scalar weights. -/
theorem primeResidueWeightSix_not_CRTFactorable :
    ¬CRTFactorable primeResidueWeightSix := by
  rintro ⟨localTwo, localThree, hfactor⟩
  have hzero := hfactor 0
  have htwo := hfactor 2
  have hthree := hfactor 3
  simp only [primeResidueWeightSix_zero, primeResidueWeightSix_two,
    primeResidueWeightSix_three, modTwo_zero, modTwo_two, modTwo_three,
    modThree_zero, modThree_two, modThree_three] at hzero htwo hthree
  have hTwoZero : localTwo 0 ≠ 0 := by
    intro h
    simp [h] at htwo
  have hThreeZero : localThree 0 ≠ 0 := by
    intro h
    simp [h] at hthree
  rcases mul_eq_zero.mp hzero.symm with h | h
  · exact hTwoZero h
  · exact hThreeZero h

/-- Despite the failed CRT rank-one ansatz, the arbitrary-weight finite
Fourier identity gives this prime residue weight an exact Kloosterman
completion at modulus `6`. -/
theorem primeResidueWeightSix_has_finiteKloostermanCompletion (n : ZMod 6) :
    inversePhaseSum primeResidueWeightSix n =
      (6 : ℂ)⁻¹ * ∑ m : ZMod 6,
        ZMod.dft primeResidueWeightSix m * kloostermanSum m n :=
  inversePhaseSum_eq_dft_kloosterman primeResidueWeightSix n

/-- Headline separation: exact finite Kloosterman completion does not imply
the simplest Euler/CRT factorization of its residue weight. -/
theorem finiteKloostermanCompletion_without_CRTFactorization (n : ZMod 6) :
    (inversePhaseSum primeResidueWeightSix n =
      (6 : ℂ)⁻¹ * ∑ m : ZMod 6,
        ZMod.dft primeResidueWeightSix m * kloostermanSum m n) ∧
      ¬CRTFactorable primeResidueWeightSix :=
  ⟨primeResidueWeightSix_has_finiteKloostermanCompletion n,
    primeResidueWeightSix_not_CRTFactorable⟩

end PrimeResidueKloostermanBoundary

end Pairfield
