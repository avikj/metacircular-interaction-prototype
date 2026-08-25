/-
Copyright (c) 2026 Avik Jain and the mathematics collaboration.
Released under Apache 2.0 license.

The standard prime-representative weight modulo `15 = 3 * 5` has bipartite
CRT tensor rank at least three.  A nonzero `3 × 3` minor rules out two pure
tensors.  Since there are only three mod-`3` rows, ordinary matrix rank also
gives the matching elementary upper bound.
-/
import Pairfield.PrimeResidueTensorRank

namespace Pairfield.PrimeResidueTensorRankFifteen

/-- The CRT equivalence for `15 = 3 * 5`. -/
def crtFifteen : ZMod 15 ≃+* ZMod 3 × ZMod 5 :=
  ZMod.chineseRemainder (by norm_num : Nat.Coprime 3 5)

/-- Reduction of a residue modulo `15` to its mod-`3` coordinate. -/
def modThree (x : ZMod 15) : ZMod 3 := (crtFifteen x).1

/-- Reduction of a residue modulo `15` to its mod-`5` coordinate. -/
def modFive (x : ZMod 15) : ZMod 5 := (crtFifteen x).2

/-- The indicator of prime standard representatives below `15`. -/
def primeResidueWeightFifteen (x : ZMod 15) : ℂ :=
  if x.val = 2 ∨ x.val = 3 ∨ x.val = 5 ∨ x.val = 7 ∨
      x.val = 11 ∨ x.val = 13 then 1 else 0

/-- Representation by a sum of at most two pure mod-`3`/mod-`5` tensors. -/
def CRTTensorRankAtMostTwo (weight : ZMod 15 → ℂ) : Prop :=
  ∃ left₀ left₁ : ZMod 3 → ℂ, ∃ right₀ right₁ : ZMod 5 → ℂ,
    ∀ x, weight x =
      left₀ (modThree x) * right₀ (modFive x) +
      left₁ (modThree x) * right₁ (modFive x)

/-- Representation by a sum of at most three pure mod-`3`/mod-`5` tensors. -/
def CRTTensorRankAtMostThree (weight : ZMod 15 → ℂ) : Prop :=
  ∃ left₀ left₁ left₂ : ZMod 3 → ℂ,
    ∃ right₀ right₁ right₂ : ZMod 5 → ℂ,
    ∀ x, weight x =
      left₀ (modThree x) * right₀ (modFive x) +
      left₁ (modThree x) * right₁ (modFive x) +
      left₂ (modThree x) * right₂ (modFive x)

def rowZero (x : ZMod 3) : ℂ := if x = 0 then 1 else 0
def rowOne (x : ZMod 3) : ℂ := if x = 1 then 1 else 0
def rowTwo (x : ZMod 3) : ℂ := if x = 2 then 1 else 0

@[simp] theorem modThree_zero : modThree 0 = 0 := by decide
@[simp] theorem modThree_two : modThree 2 = 2 := by decide
@[simp] theorem modThree_three : modThree 3 = 0 := by decide
@[simp] theorem modThree_five : modThree 5 = 2 := by decide
@[simp] theorem modThree_seven : modThree 7 = 1 := by decide
@[simp] theorem modThree_eight : modThree 8 = 2 := by decide
@[simp] theorem modThree_ten : modThree 10 = 1 := by decide
@[simp] theorem modThree_twelve : modThree 12 = 0 := by decide
@[simp] theorem modThree_thirteen : modThree 13 = 1 := by decide

@[simp] theorem modFive_zero : modFive 0 = 0 := by decide
@[simp] theorem modFive_two : modFive 2 = 2 := by decide
@[simp] theorem modFive_three : modFive 3 = 3 := by decide
@[simp] theorem modFive_five : modFive 5 = 0 := by decide
@[simp] theorem modFive_seven : modFive 7 = 2 := by decide
@[simp] theorem modFive_eight : modFive 8 = 3 := by decide
@[simp] theorem modFive_ten : modFive 10 = 0 := by decide
@[simp] theorem modFive_twelve : modFive 12 = 2 := by decide
@[simp] theorem modFive_thirteen : modFive 13 = 3 := by decide

@[simp] theorem primeResidueWeightFifteen_zero :
    primeResidueWeightFifteen 0 = 0 := by
  have h : ¬ ((0 : ZMod 15).val = 2 ∨ (0 : ZMod 15).val = 3 ∨
      (0 : ZMod 15).val = 5 ∨ (0 : ZMod 15).val = 7 ∨
      (0 : ZMod 15).val = 11 ∨ (0 : ZMod 15).val = 13) := by decide
  simp only [primeResidueWeightFifteen, h, if_false]

@[simp] theorem primeResidueWeightFifteen_two :
    primeResidueWeightFifteen 2 = 1 := by
  have h : (2 : ZMod 15).val = 2 ∨ (2 : ZMod 15).val = 3 ∨
      (2 : ZMod 15).val = 5 ∨ (2 : ZMod 15).val = 7 ∨
      (2 : ZMod 15).val = 11 ∨ (2 : ZMod 15).val = 13 := by decide
  simp only [primeResidueWeightFifteen, h, if_true]

@[simp] theorem primeResidueWeightFifteen_three :
    primeResidueWeightFifteen 3 = 1 := by
  have h : (3 : ZMod 15).val = 2 ∨ (3 : ZMod 15).val = 3 ∨
      (3 : ZMod 15).val = 5 ∨ (3 : ZMod 15).val = 7 ∨
      (3 : ZMod 15).val = 11 ∨ (3 : ZMod 15).val = 13 := by decide
  simp only [primeResidueWeightFifteen, h, if_true]

@[simp] theorem primeResidueWeightFifteen_five :
    primeResidueWeightFifteen 5 = 1 := by
  have h : (5 : ZMod 15).val = 2 ∨ (5 : ZMod 15).val = 3 ∨
      (5 : ZMod 15).val = 5 ∨ (5 : ZMod 15).val = 7 ∨
      (5 : ZMod 15).val = 11 ∨ (5 : ZMod 15).val = 13 := by decide
  simp only [primeResidueWeightFifteen, h, if_true]

@[simp] theorem primeResidueWeightFifteen_seven :
    primeResidueWeightFifteen 7 = 1 := by
  have h : (7 : ZMod 15).val = 2 ∨ (7 : ZMod 15).val = 3 ∨
      (7 : ZMod 15).val = 5 ∨ (7 : ZMod 15).val = 7 ∨
      (7 : ZMod 15).val = 11 ∨ (7 : ZMod 15).val = 13 := by decide
  simp only [primeResidueWeightFifteen, h, if_true]

@[simp] theorem primeResidueWeightFifteen_eight :
    primeResidueWeightFifteen 8 = 0 := by
  have h : ¬ ((8 : ZMod 15).val = 2 ∨ (8 : ZMod 15).val = 3 ∨
      (8 : ZMod 15).val = 5 ∨ (8 : ZMod 15).val = 7 ∨
      (8 : ZMod 15).val = 11 ∨ (8 : ZMod 15).val = 13) := by decide
  simp only [primeResidueWeightFifteen, h, if_false]

@[simp] theorem primeResidueWeightFifteen_ten :
    primeResidueWeightFifteen 10 = 0 := by
  have h : ¬ ((10 : ZMod 15).val = 2 ∨ (10 : ZMod 15).val = 3 ∨
      (10 : ZMod 15).val = 5 ∨ (10 : ZMod 15).val = 7 ∨
      (10 : ZMod 15).val = 11 ∨ (10 : ZMod 15).val = 13) := by decide
  simp only [primeResidueWeightFifteen, h, if_false]

@[simp] theorem primeResidueWeightFifteen_twelve :
    primeResidueWeightFifteen 12 = 0 := by
  have h : ¬ ((12 : ZMod 15).val = 2 ∨ (12 : ZMod 15).val = 3 ∨
      (12 : ZMod 15).val = 5 ∨ (12 : ZMod 15).val = 7 ∨
      (12 : ZMod 15).val = 11 ∨ (12 : ZMod 15).val = 13) := by decide
  simp only [primeResidueWeightFifteen, h, if_false]

@[simp] theorem primeResidueWeightFifteen_thirteen :
    primeResidueWeightFifteen 13 = 1 := by
  have h : (13 : ZMod 15).val = 2 ∨ (13 : ZMod 15).val = 3 ∨
      (13 : ZMod 15).val = 5 ∨ (13 : ZMod 15).val = 7 ∨
      (13 : ZMod 15).val = 11 ∨ (13 : ZMod 15).val = 13 := by decide
  simp only [primeResidueWeightFifteen, h, if_true]

/-- The prime-residue matrix on rows `0,1,2 mod 3` and columns
`0,2,3 mod 5` has determinant `-1`; hence two outer products cannot produce
it. -/
theorem primeResidueWeightFifteen_not_rankAtMostTwo :
    ¬ CRTTensorRankAtMostTwo primeResidueWeightFifteen := by
  rintro ⟨left₀, left₁, right₀, right₁, hfactor⟩
  have hdet :
      primeResidueWeightFifteen 0 *
          (primeResidueWeightFifteen 7 * primeResidueWeightFifteen 8 -
            primeResidueWeightFifteen 13 * primeResidueWeightFifteen 2) -
        primeResidueWeightFifteen 12 *
          (primeResidueWeightFifteen 10 * primeResidueWeightFifteen 8 -
            primeResidueWeightFifteen 13 * primeResidueWeightFifteen 5) +
        primeResidueWeightFifteen 3 *
          (primeResidueWeightFifteen 10 * primeResidueWeightFifteen 2 -
            primeResidueWeightFifteen 7 * primeResidueWeightFifteen 5) = 0 := by
    rw [hfactor 0, hfactor 7, hfactor 8, hfactor 13, hfactor 2,
      hfactor 12, hfactor 10, hfactor 5, hfactor 3]
    simp only [modThree_zero, modThree_two, modThree_three, modThree_five,
      modThree_seven, modThree_eight, modThree_ten, modThree_twelve,
      modThree_thirteen, modFive_zero, modFive_two, modFive_three,
      modFive_five, modFive_seven, modFive_eight, modFive_ten,
      modFive_twelve, modFive_thirteen]
    ring
  simp only [primeResidueWeightFifteen_zero, primeResidueWeightFifteen_two,
    primeResidueWeightFifteen_three, primeResidueWeightFifteen_five,
    primeResidueWeightFifteen_seven, primeResidueWeightFifteen_eight,
    primeResidueWeightFifteen_ten, primeResidueWeightFifteen_twelve,
    primeResidueWeightFifteen_thirteen] at hdet
  norm_num at hdet

/-- Every mod-`3`/mod-`5` table is a sum of its three row tensors. -/
theorem anyWeight_rankAtMostThree (weight : ZMod 15 → ℂ) :
    CRTTensorRankAtMostThree weight := by
  refine ⟨rowZero, rowOne, rowTwo,
    (fun b ↦ weight (crtFifteen.symm (0, b))),
    (fun b ↦ weight (crtFifteen.symm (1, b))),
    (fun b ↦ weight (crtFifteen.symm (2, b))), ?_⟩
  intro x
  have hx : crtFifteen.symm (modThree x, modFive x) = x := by
    exact crtFifteen.symm_apply_apply x
  have hrow : modThree x = 0 ∨ modThree x = 1 ∨ modThree x = 2 := by
    have hmem : modThree x ∈ ({0, 1, 2} : Finset (ZMod 3)) := by
      have hu := Finset.mem_univ (modThree x)
      rw [show (Finset.univ : Finset (ZMod 3)) = {0, 1, 2} by decide] at hu
      exact hu
    simpa only [Finset.mem_insert, Finset.mem_singleton] using hmem
  rcases hrow with hrow | hrow | hrow
  · rw [hrow] at hx
    simp [rowZero, rowOne, rowTwo, hrow, show (0 : ZMod 3) ≠ 1 by decide,
      show (0 : ZMod 3) ≠ 2 by decide, hx]
  · rw [hrow] at hx
    simp [rowZero, rowOne, rowTwo, hrow, show (1 : ZMod 3) ≠ 0 by decide,
      show (1 : ZMod 3) ≠ 2 by decide, hx]
  · rw [hrow] at hx
    simp [rowZero, rowOne, rowTwo, hrow, show (2 : ZMod 3) ≠ 0 by decide,
      show (2 : ZMod 3) ≠ 1 by decide, hx]

/-- Exact bipartite CRT tensor rank three at modulus `15`. -/
theorem primeResidueWeightFifteen_rankExactlyThree :
    (¬ CRTTensorRankAtMostTwo primeResidueWeightFifteen) ∧
      CRTTensorRankAtMostThree primeResidueWeightFifteen :=
  ⟨primeResidueWeightFifteen_not_rankAtMostTwo,
    anyWeight_rankAtMostThree primeResidueWeightFifteen⟩

end Pairfield.PrimeResidueTensorRankFifteen
