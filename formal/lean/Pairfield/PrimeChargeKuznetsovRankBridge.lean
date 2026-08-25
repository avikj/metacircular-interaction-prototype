/-
Copyright (c) 2026 Avik Jain and the mathematics collaboration.
Released under Apache 2.0 license.

An exact finite adapter from the squarefree three-prime `q₁` tensor to the
scalar-separable radial rank used by the finite Kuznetsov boundary.  This is
only a finite rank obstruction; it asserts no analytic trace-formula result.
-/
import Pairfield.FiniteKuznetsovFactorizationRank
import Pairfield.PrimeChargeThreeTensorRank

namespace Pairfield.PrimeChargeKuznetsovRankBridge

open Pairfield.FiniteKuznetsovFactorizationRank

/-- A separate modulus label for every cell of the three-bit charge tensor. -/
structure ChargeCell where
  firstBit : Bool
  secondBit : Bool
  thirdBit : Bool
deriving DecidableEq, Fintype

/-- Distinct square first indices. -/
def firstIndex : Bool → ℕ
  | false => 1
  | true => 4

/-- Distinct square second indices. -/
def secondIndex : Bool → ℕ
  | false => 1
  | true => 9

def firstRoot : Bool → ℕ
  | false => 1
  | true => 2

def secondRoot : Bool → ℕ
  | false => 1
  | true => 3

/-- The third prime-place bit chooses one of two radial fibers. -/
def thirdScale : Bool → ℕ
  | false => 1
  | true => 5

/-- The modulus is the product of the two square roots and the third-axis
scale.  Hence `m*n/c²` forgets the first two bits but retains the third. -/
def cellModulus (cell : ChargeCell) : ℕ :=
  firstRoot cell.firstBit * secondRoot cell.secondBit *
    thirdScale cell.thirdBit

def chargeCoordinates : Coordinates Bool Bool ChargeCell :=
  ⟨firstIndex, secondIndex, cellModulus⟩

def selectedCell (i j k : Bool) : ChargeCell := ⟨i, j, k⟩

/-- On selected charge cells the radial coordinate depends only on the third
prime-place bit: it is `1` off and `1/25` on. -/
theorem selectedCell_radialCoordinate (i j k : Bool) :
    radialCoordinate chargeCoordinates i j (selectedCell i j k) =
      if k then (1 / 25 : ℚ) else 1 := by
  cases i <;> cases j <;> cases k <;>
    norm_num [radialCoordinate, chargeCoordinates, selectedCell,
      firstIndex, secondIndex, cellModulus, firstRoot, secondRoot, thirdScale]

/-- Embed the actual squarefree `q₁` tensor into the selected modulus cell;
off that cell the coefficient is zero. -/
def embeddedSquarefreeCharge
    (i j : Bool) (cell : ChargeCell) : ℚ :=
  if cell.firstBit = i ∧ cell.secondBit = j then
    Pairfield.PrimeChargeThreeTensorRank.squarefreeChargeThree
      i j cell.thirdBit
  else 0

@[simp] theorem embeddedSquarefreeCharge_selected (i j k : Bool) :
    embeddedSquarefreeCharge i j (selectedCell i j k) =
      Pairfield.PrimeChargeThreeTensorRank.squarefreeChargeThree i j k := by
  simp [embeddedSquarefreeCharge, selectedCell]

/-- Any two scalar-separable radial Kuznetsov components on the embedded
coordinate family restrict to two pure local tensors on the actual three-bit
squarefree charge. -/
theorem rankAtMostTwo_implies_squarefreeCharge_rankAtMostTwo
    (realizes : RankAtMost chargeCoordinates 2
      embeddedSquarefreeCharge) :
    Pairfield.PrimeChargeThreeTensorRank.RankAtMostTwo
      Pairfield.PrimeChargeThreeTensorRank.squarefreeChargeThree := by
  rcases realizes with ⟨alpha, beta, radial, realizes⟩
  refine ⟨alpha 0, beta 0,
    (fun k ↦ radial 0 (if k then (1 / 25 : ℚ) else 1)),
    alpha 1, beta 1,
    (fun k ↦ radial 1 (if k then (1 / 25 : ℚ) else 1)), ?_⟩
  intro i j k
  rw [← embeddedSquarefreeCharge_selected i j k,
    realizes i j (selectedCell i j k),
    Fin.sum_univ_two, selectedCell_radialCoordinate]

/-- The actual squarefree three-prime charge cannot be realized by two scalar
separable radial components on this explicit finite Kuznetsov coordinate
family. -/
theorem embeddedSquarefreeCharge_not_rankAtMostTwo :
    ¬RankAtMost chargeCoordinates 2 embeddedSquarefreeCharge := by
  intro realizes
  exact Pairfield.PrimeChargeThreeTensorRank.squarefreeChargeThree_has_exactly_three_pure_terms.2
    (rankAtMostTwo_implies_squarefreeCharge_rankAtMostTwo realizes)

end Pairfield.PrimeChargeKuznetsovRankBridge
