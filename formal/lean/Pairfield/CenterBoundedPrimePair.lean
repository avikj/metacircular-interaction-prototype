/-
Copyright (c) 2026 Avik Jain and the mathematics collaboration.
Released under Apache 2.0 license.

A finite source-centred sector inside `BoundedPrimePair`: ordered prime legs,
an integral midpoint, and a cutoff on that midpoint rather than on each leg.
Enlargement is covariant on total carriers but an equivalence on every old
complete centre fiber.

No inhabitation theorem for any centre is asserted here.
-/
import Pairfield.BoundedPrimePair

namespace Pairfield

/-- The source-coordinate sector at centre horizon `X`: retain ordered legs,
but require an integral midpoint and require that midpoint to be at most `X`.
The ambient leg bound `2*X` makes the subtype definitionally finite. -/
abbrev CenterBoundedPrimePair (X : ℕ) :=
  {pair : BoundedPrimePair (2 * X) //
    Even (pairCenter pair) ∧ pairCenter pair ≤ 2 * X}

instance (X : ℕ) : Fintype (CenterBoundedPrimePair X) := inferInstance

/-- Exchange stays inside the integral centre cutoff. -/
def swapCenterPair {X : ℕ} (point : CenterBoundedPrimePair X) :
    CenterBoundedPrimePair X :=
  ⟨swapPair point.1, by simpa using point.2⟩

@[simp] theorem swapCenterPair_involutive {X : ℕ}
    (point : CenterBoundedPrimePair X) :
    swapCenterPair (swapCenterPair point) = point := by
  apply Subtype.ext
  exact swapPair_involutive point.1

@[simp] theorem pairGap_swapCenter {X : ℕ}
    (point : CenterBoundedPrimePair X) :
    pairGap (swapCenterPair point).1 = -pairGap point.1 := by
  exact pairGap_swap point.1

/-- Even sum forces an integral signed half-gap; exchange negates it. -/
theorem pairGap_even {X : ℕ} (point : CenterBoundedPrimePair X) :
    Even (pairGap point.1) := by
  rcases point.2.1 with ⟨w, hw⟩
  refine ⟨(w : ℤ) - point.1.1.1.val, ?_⟩
  simp only [pairCenter, pairGap] at hw ⊢
  omega

/-- Centre-cutoff enlargement; no new prime is decided. -/
def weakenCenterPair {X Y : ℕ} (hXY : X ≤ Y)
    (point : CenterBoundedPrimePair X) : CenterBoundedPrimePair Y :=
  ⟨weakenPrimePair (Nat.mul_le_mul_left 2 hXY) point.1,
    by
      constructor
      · simpa using point.2.1
      · calc
          pairCenter (weakenPrimePair (Nat.mul_le_mul_left 2 hXY) point.1) =
              pairCenter point.1 := pairCenter_weaken _ _
          _ ≤ 2 * X := point.2.2
          _ ≤ 2 * Y := Nat.mul_le_mul_left 2 hXY⟩

@[simp] theorem weakenCenterPair_id {X : ℕ}
    (point : CenterBoundedPrimePair X) :
    weakenCenterPair (le_refl X) point = point := by
  apply Subtype.ext
  exact weakenPrimePair_id point.1

@[simp] theorem weakenCenterPair_trans {X Y Z : ℕ}
    (hXY : X ≤ Y) (hYZ : Y ≤ Z) (point : CenterBoundedPrimePair X) :
    weakenCenterPair hYZ (weakenCenterPair hXY point) =
      weakenCenterPair (hXY.trans hYZ) point := by
  apply Subtype.ext
  exact weakenPrimePair_trans
    (Nat.mul_le_mul_left 2 hXY) (Nat.mul_le_mul_left 2 hYZ) point.1

/-- The complete ordered source-centre fiber at midpoint `w`. -/
abbrev CenterPrimeFiber (X w : ℕ) :=
  {point : CenterBoundedPrimePair X // pairCenter point.1 = 2 * w}

def weakenCenterPrimeFiber {X Y w : ℕ} (hXY : X ≤ Y)
    (point : CenterPrimeFiber X w) : CenterPrimeFiber Y w :=
  ⟨weakenCenterPair hXY point.1, by
    change pairCenter (weakenPrimePair
      (Nat.mul_le_mul_left 2 hXY) point.1.1) = 2 * w
    simpa using point.2⟩

/-- Re-bind a complete old centre fiber to its old horizon. -/
def rebindCenterPrimeFiber {X Y w : ℕ} (hwX : w ≤ X)
    (point : CenterPrimeFiber Y w) : CenterPrimeFiber X w := by
  let p := point.1.1.1.1.val
  let q := point.1.1.2.1.val
  have hpX : p ≤ 2 * X := by
    calc
      p ≤ p + q := Nat.le_add_right p q
      _ = 2 * w := point.2
      _ ≤ 2 * X := Nat.mul_le_mul_left 2 hwX
  have hqX : q ≤ 2 * X := by
    calc
      q ≤ p + q := Nat.le_add_left q p
      _ = 2 * w := point.2
      _ ≤ 2 * X := Nat.mul_le_mul_left 2 hwX
  let pairX : BoundedPrimePair (2 * X) :=
    mkBoundedPrimePair point.1.1.1.2 point.1.1.2.2 hpX hqX
  have hcenter : pairCenter pairX = 2 * w := by
    simpa [pairX, p, q, pairCenter, mkBoundedPrimePair, mkBoundedPrime]
      using point.2
  exact
    ⟨⟨pairX,
        ⟨⟨w, by simpa [two_mul] using hcenter⟩,
          hcenter.trans_le (Nat.mul_le_mul_left 2 hwX)⟩⟩,
      hcenter⟩

/-- Once `w` is admitted, enlarging the horizon does not change its complete
ordered prime-pair fiber. -/
def centerPrimeFiberWeakenEquiv {X Y w : ℕ} (hXY : X ≤ Y) (hwX : w ≤ X) :
    CenterPrimeFiber X w ≃ CenterPrimeFiber Y w where
  toFun := weakenCenterPrimeFiber hXY
  invFun := rebindCenterPrimeFiber hwX
  left_inv point := by
    apply Subtype.ext
    apply Subtype.ext
    apply Prod.ext
    · apply Subtype.ext
      apply Fin.ext
      rfl
    · apply Subtype.ext
      apply Fin.ext
      rfl
  right_inv point := by
    apply Subtype.ext
    apply Subtype.ext
    apply Prod.ext
    · apply Subtype.ext
      apply Fin.ext
      rfl
    · apply Subtype.ext
      apply Fin.ext
      rfl

/-- Control: `(3,17)` occurs at source-centre horizon `10`. -/
def centerThreeSeventeen : CenterBoundedPrimePair 10 :=
  ⟨mkBoundedPrimePair (X := 20) (p := 3) (q := 17)
      (by norm_num) (by norm_num) (by norm_num) (by norm_num),
    by norm_num [pairCenter, mkBoundedPrimePair, mkBoundedPrime]⟩

/-- Control: the same ordered pair is absent from the leg box at horizon 10. -/
theorem threeSeventeen_absent_from_legBoxTen :
    ¬ ∃ pair : BoundedPrimePair 10,
      pair.1.1.val = 3 ∧ pair.2.1.val = 17 := by
  rintro ⟨pair, -, hq⟩
  have hlt := pair.2.1.isLt
  omega

/-- Control: retaining order makes exchange nontrivial on `(3,17)`. -/
theorem centerThreeSeventeen_swap_ne :
    swapCenterPair centerThreeSeventeen ≠ centerThreeSeventeen := by
  intro equal
  have legs := congrArg (fun point => point.1.1.1.val) equal
  change (17 : ℕ) = 3 at legs
  omega

/-- The mixed-parity pair `(2,3)` inhabits the leg box at horizon 3. -/
def legTwoThree : BoundedPrimePair 3 :=
  mkBoundedPrimePair (X := 3) (p := 2) (q := 3)
    (by norm_num) (by norm_num) (by norm_num) (by norm_num)

/-- Control: `(2,3)` has no integral source centre. -/
theorem legTwoThree_not_integral : ¬ Even (pairCenter legTwoThree) := by
  norm_num [legTwoThree, pairCenter, mkBoundedPrimePair, mkBoundedPrime]

end Pairfield
