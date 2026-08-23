/-
Copyright (c) 2026 Avik Jain and the mathematics collaboration.
Released under Apache 2.0 license.

The scalar-radial finite Kuznetsov rank has only three local factors per
channel: a first-index factor, a second-index factor, and an arbitrary function
of one radial coordinate.  Consequently it does not retain the four local
prime-place factors of the squarefree four-bit charge tensor.

This module gives the exact finite correction.  In the natural extension of
the three-bit coordinate construction, independent `5`- and `7`-scales encode
the last two bits into a single radial label.  The actual four-place `q₁`
tensor then has at most three scalar-radial channels, while its ungrouped
four-way CP tensor rank is four.  A rank-greater-than-three transport therefore
requires either four independent local factors or an analytic restriction on
the radial function stronger than the arbitrary-function API used here.
-/
import Pairfield.FiniteKuznetsovFactorizationRank
import Pairfield.PrimeChargeFourTensorRank

namespace Pairfield.PrimeChargeFourKuznetsovGroupingNoGo

open Pairfield.FiniteKuznetsovFactorizationRank
open Pairfield.PrimeChargeThreeTensorRank
open Pairfield.PrimeChargeFourTensorRank

/-- A separate modulus label for every cell of the four-bit charge tensor. -/
structure ChargeFourCell where
  firstBit : Bool
  secondBit : Bool
  thirdBit : Bool
  fourthBit : Bool
deriving DecidableEq, Fintype

def firstIndex : Bool → ℕ
  | false => 1
  | true => 4

def secondIndex : Bool → ℕ
  | false => 1
  | true => 9

def firstRoot : Bool → ℕ
  | false => 1
  | true => 2

def secondRoot : Bool → ℕ
  | false => 1
  | true => 3

/-- The last two prime-place bits are grouped into one scalar radial scale. -/
def pairScale : Bool → Bool → ℕ
  | false, false => 1
  | true, false => 5
  | false, true => 7
  | true, true => 35

def cellModulus (cell : ChargeFourCell) : ℕ :=
  firstRoot cell.firstBit * secondRoot cell.secondBit *
    pairScale cell.thirdBit cell.fourthBit

def chargeFourCoordinates : Coordinates Bool Bool ChargeFourCell :=
  ⟨firstIndex, secondIndex, cellModulus⟩

def selectedCell (i j k l : Bool) : ChargeFourCell := ⟨i, j, k, l⟩

/-- On selected cells, square-index cancellation leaves four distinct radial
labels for the grouped last-bit pair. -/
theorem selectedCell_radialCoordinate (i j k l : Bool) :
    radialCoordinate chargeFourCoordinates i j (selectedCell i j k l) =
      if k then (if l then (1 / 1225 : ℚ) else 1 / 25)
      else (if l then (1 / 49 : ℚ) else 1) := by
  cases i <;> cases j <;> cases k <;> cases l <;>
    norm_num [radialCoordinate, chargeFourCoordinates, selectedCell,
      firstIndex, secondIndex, cellModulus, firstRoot, secondRoot, pairScale]

/-- Embed the four-place squarefree charge on matching selected cells and put
zero on the auxiliary mismatched cells. -/
def embeddedSquarefreeChargeFour
    (i j : Bool) (cell : ChargeFourCell) : ℚ :=
  if cell.firstBit = i ∧ cell.secondBit = j then
    squarefreeChargeFour i j cell.thirdBit cell.fourthBit
  else 0

@[simp] theorem embeddedSquarefreeChargeFour_selected (i j k l : Bool) :
    embeddedSquarefreeChargeFour i j (selectedCell i j k l) =
      squarefreeChargeFour i j k l := by
  simp [embeddedSquarefreeChargeFour, selectedCell]

/-- Radial factor for the product of the two inactive/charge signs.  It is
zero away from the four selected radial labels, which also kills all
mismatched auxiliary cells. -/
def groupedSignRadial (x : ℚ) : ℚ :=
  if x = 1 then 1
  else if x = 1 / 25 then -1
  else if x = 1 / 49 then -1
  else if x = 1 / 1225 then 1
  else 0

/-- Radial factor carrying the two possible marked-prime positions inside the
grouped last-bit pair. -/
def groupedMarkedRadial (x : ℚ) : ℚ :=
  if x = 1 then 0
  else if x = 1 / 25 then 1
  else if x = 1 / 49 then 1
  else if x = 1 / 1225 then -2
  else 0

def groupedAlpha (channel : Fin 3) (i : Bool) : ℚ :=
  if channel = 0 then bitOn i else signBit i

def groupedBeta (channel : Fin 3) (j : Bool) : ℚ :=
  if channel = 1 then bitOn j else signBit j

def groupedRadial (channel : Fin 3) (x : ℚ) : ℚ :=
  if channel = 2 then groupedMarkedRadial x else groupedSignRadial x

/-- The natural four-bit embedding has at most three scalar-separable radial
channels.  The last two local prime places have been absorbed into the single
arbitrary radial function. -/
theorem embeddedSquarefreeChargeFour_rankAtMostThree :
    RankAtMost chargeFourCoordinates 3 embeddedSquarefreeChargeFour := by
  refine ⟨groupedAlpha, groupedBeta, groupedRadial, ?_⟩
  intro i j cell
  rcases cell with ⟨iCell, jCell, k, l⟩
  cases i <;> cases j <;> cases iCell <;> cases jCell <;>
    cases k <;> cases l <;>
    norm_num [embeddedSquarefreeChargeFour, squarefreeChargeFour,
      groupedAlpha, groupedBeta, groupedRadial, groupedSignRadial,
      groupedMarkedRadial, radialCoordinate, chargeFourCoordinates,
      firstIndex, secondIndex, cellModulus, firstRoot, secondRoot, pairScale,
      bitOn, signBit, Fin.sum_univ_three,
      show (0 : Fin 3) ≠ 1 by decide, show (0 : Fin 3) ≠ 2 by decide,
      show (1 : Fin 3) ≠ 0 by decide, show (1 : Fin 3) ≠ 2 by decide,
      show (2 : Fin 3) ≠ 0 by decide, show (2 : Fin 3) ≠ 1 by decide]

/-- Checked separation of the two notions: scalar-radial rank at most three
coexists with ungrouped four-way CP rank exactly four for the same squarefree
charge table. -/
theorem scalarRadial_grouping_loses_four_way_rank :
    RankAtMost chargeFourCoordinates 3 embeddedSquarefreeChargeFour ∧
      ¬ RankAtMostThree squarefreeChargeFour :=
  ⟨embeddedSquarefreeChargeFour_rankAtMostThree,
    squarefreeChargeFour_has_exactly_four_pure_terms.2⟩

/-- In particular, no unconditional implication from this API's rank-three
bound to a three-term four-way local decomposition can hold for the natural
embedding. -/
theorem no_rankThree_scalarRadial_to_fourWay_transport :
    ¬ (RankAtMost chargeFourCoordinates 3 embeddedSquarefreeChargeFour →
      RankAtMostThree squarefreeChargeFour) := by
  intro transport
  exact squarefreeChargeFour_has_exactly_four_pure_terms.2
    (transport embeddedSquarefreeChargeFour_rankAtMostThree)

end Pairfield.PrimeChargeFourKuznetsovGroupingNoGo
