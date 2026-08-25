import Mathlib

/-!
# The first genuinely higher-order charge tensor

The three-party `W` tensor is the local-basis normal form of the charge-one
Möbius insertion on three squarefree prime places.  This module proves its
tensor rank is not at most two by the matrix-pencil substitution argument.

The statement is finite and algebraic over `ℚ`.  No asymptotic tensor-rank or
automorphic conclusion is asserted here.
-/

namespace Pairfield.PrimeChargeThreeTensorRank

/-- The three-party `W` tensor: exactly one active local place. -/
def wThree : Bool → Bool → Bool → ℚ
  | true, false, false => 1
  | false, true, false => 1
  | false, false, true => 1
  | _, _, _ => 0

/-- A function on the three-bit cube is a sum of at most two pure tensors. -/
def RankAtMostTwo (weight : Bool → Bool → Bool → ℚ) : Prop :=
  ∃ a b c d e f : Bool → ℚ, ∀ i j k,
    weight i j k = a i * b j * c k + d i * e j * f k

def bitOff : Bool → ℚ
  | false => 1
  | true => 0

def bitOn : Bool → ℚ
  | false => 0
  | true => 1

/-- The squarefree restriction of `q₁` on three distinct prime places. -/
def squarefreeChargeThree : Bool → Bool → Bool → ℚ
  | false, false, false => 0
  | true, false, false => 1
  | false, true, false => 1
  | false, false, true => 1
  | true, true, false => -2
  | true, false, true => -2
  | false, true, true => -2
  | true, true, true => 3

def signBit : Bool → ℚ
  | false => 1
  | true => -1

/-- The marked-prime decomposition of the actual three-place charge tensor. -/
theorem squarefreeChargeThree_threeTermDecomposition (i j k : Bool) :
    squarefreeChargeThree i j k =
      bitOn i * signBit j * signBit k +
      signBit i * bitOn j * signBit k +
      signBit i * signBit j * bitOn k := by
  cases i <;> cases j <;> cases k <;>
    norm_num [squarefreeChargeThree, bitOn, signBit]

/-- Invertible local change of basis sending `(1,-1)` to the inactive basis
vector while retaining `(0,1)` as the active vector. -/
def zetaBit (f : Bool → ℚ) : Bool → ℚ
  | false => f false
  | true => f false + f true

/-- Apply `zetaBit` independently in the three local modes. -/
def localZeta (weight : Bool → Bool → Bool → ℚ) :
    Bool → Bool → Bool → ℚ
  | false, false, false => weight false false false
  | true, false, false => weight false false false + weight true false false
  | false, true, false => weight false false false + weight false true false
  | false, false, true => weight false false false + weight false false true
  | true, true, false =>
      weight false false false + weight true false false +
      weight false true false + weight true true false
  | true, false, true =>
      weight false false false + weight true false false +
      weight false false true + weight true false true
  | false, true, true =>
      weight false false false + weight false true false +
      weight false false true + weight false true true
  | true, true, true =>
      weight false false false + weight true false false +
      weight false true false + weight true true false +
      weight false false true + weight true false true +
      weight false true true + weight true true true

theorem localZeta_pure (a b c : Bool → ℚ) (i j k : Bool) :
    localZeta (fun x y z ↦ a x * b y * c z) i j k =
      zetaBit a i * zetaBit b j * zetaBit c k := by
  cases i <;> cases j <;> cases k <;> simp [localZeta, zetaBit] <;> ring

/-- A local invertible basis change cannot increase the number of pure
summands. -/
theorem localZeta_preserves_rankAtMostTwo
    {weight : Bool → Bool → Bool → ℚ}
    (rankTwo : RankAtMostTwo weight) :
    RankAtMostTwo (localZeta weight) := by
  rcases rankTwo with ⟨a, b, c, d, e, f, realizes⟩
  refine ⟨zetaBit a, zetaBit b, zetaBit c,
    zetaBit d, zetaBit e, zetaBit f, ?_⟩
  intro i j k
  cases i <;> cases j <;> cases k <;>
    simp [localZeta, zetaBit, realizes] <;> ring

/-- The charge tensor becomes the `W` tensor under the checked local basis
change. -/
theorem localZeta_squarefreeChargeThree :
    localZeta squarefreeChargeThree = wThree := by
  funext i j k
  cases i <;> cases j <;> cases k <;>
    norm_num [localZeta, squarefreeChargeThree, wThree]

/-- The evident three-term pure decomposition. -/
theorem wThree_threeTermDecomposition (i j k : Bool) :
    wThree i j k =
      bitOn i * bitOff j * bitOff k +
      bitOff i * bitOn j * bitOff k +
      bitOff i * bitOff j * bitOn k := by
  cases i <;> cases j <;> cases k <;> norm_num [wThree, bitOn, bitOff]

/-- Determinant of the matrix slice `false + t * true` in the first mode. -/
def pencilDet (weight : Bool → Bool → Bool → ℚ) (t : ℚ) : ℚ :=
  (weight false false false + t * weight true false false) *
      (weight false true true + t * weight true true true) -
    (weight false false true + t * weight true false true) *
      (weight false true false + t * weight true true false)

/-- The `W` pencil has constant nonzero determinant. -/
theorem wThree_pencilDet (t : ℚ) : pencilDet wThree t = -1 := by
  simp [pencilDet, wThree]

/-- For two pure tensors the pencil determinant splits into the product of
the two first-mode coefficients and two fixed `2×2` alternating factors. -/
theorem rankTwo_pencil_factor
    (weight : Bool → Bool → Bool → ℚ)
    (a b c d e f : Bool → ℚ)
    (realizes : ∀ i j k,
      weight i j k = a i * b j * c k + d i * e j * f k)
    (t : ℚ) :
    pencilDet weight t =
      (a false + t * a true) * (d false + t * d true) *
        ((b false * e true - b true * e false) *
          (c false * f true - c true * f false)) := by
  simp only [pencilDet]
  rw [realizes false false false, realizes true false false,
    realizes false true true, realizes true true true,
    realizes false false true, realizes true false true,
    realizes false true false, realizes true true false]
  ring

/-- The three-party `W` tensor cannot be compressed into two pure local
products. -/
theorem wThree_not_rankAtMostTwo : ¬RankAtMostTwo wThree := by
  rintro ⟨a, b, c, d, e, f, realizes⟩
  let cross : ℚ :=
    (b false * e true - b true * e false) *
      (c false * f true - c true * f false)
  have factor (t : ℚ) :
      pencilDet wThree t =
        (a false + t * a true) * (d false + t * d true) * cross := by
    simpa only [cross] using
      rankTwo_pencil_factor wThree a b c d e f realizes t
  have equationZero : a false * d false * cross = -1 := by
    calc
      a false * d false * cross = pencilDet wThree 0 := by
        simpa using (factor 0).symm
      _ = -1 := wThree_pencilDet 0
  have equationOne :
      (a false + a true) * (d false + d true) * cross = -1 := by
    calc
      (a false + a true) * (d false + d true) * cross =
          pencilDet wThree 1 := by simpa using (factor 1).symm
      _ = -1 := wThree_pencilDet 1
  have equationTwo :
      (a false + 2 * a true) * (d false + 2 * d true) * cross = -1 := by
    calc
      (a false + 2 * a true) * (d false + 2 * d true) * cross =
          pencilDet wThree 2 := by simpa [mul_comm] using (factor 2).symm
      _ = -1 := wThree_pencilDet 2
  have cross_ne : cross ≠ 0 := by
    intro h
    rw [h] at equationZero
    norm_num at equationZero
  have a_false_ne : a false ≠ 0 := by
    intro h
    rw [h] at equationZero
    norm_num at equationZero
  have d_false_ne : d false ≠ 0 := by
    intro h
    rw [h] at equationZero
    norm_num at equationZero
  have firstScaled :
      (a false * d true + a true * d false + a true * d true) *
        cross = 0 := by
    nlinarith [equationZero, equationOne]
  have secondScaled :
      (a false * d true + a true * d false + 2 * (a true * d true)) *
        cross = 0 := by
    nlinarith [equationZero, equationTwo]
  have firstEquation :
      a false * d true + a true * d false + a true * d true = 0 :=
    (mul_eq_zero.mp firstScaled).resolve_right cross_ne
  have secondEquation :
      a false * d true + a true * d false + 2 * (a true * d true) = 0 :=
    (mul_eq_zero.mp secondScaled).resolve_right cross_ne
  have productZero : a true * d true = 0 := by
    linarith
  have linearZero : a false * d true + a true * d false = 0 := by
    linarith
  have a_true_zero : a true = 0 := by
    rcases mul_eq_zero.mp productZero with ha | hd
    · exact ha
    · simp only [hd, mul_zero, zero_add] at linearZero
      exact (mul_eq_zero.mp linearZero).resolve_right d_false_ne
  have d_true_zero : d true = 0 := by
    rw [a_true_zero, zero_mul, add_zero] at linearZero
    exact (mul_eq_zero.mp linearZero).resolve_left a_false_ne
  have activeSlice := realizes true false false
  norm_num [wThree, a_true_zero, d_true_zero] at activeSlice

/-- Exact finite conclusion: three displayed pure terms suffice and two do
not. -/
theorem wThree_has_exactly_three_pure_terms :
    (∀ i j k, wThree i j k =
      bitOn i * bitOff j * bitOff k +
      bitOff i * bitOn j * bitOff k +
      bitOff i * bitOff j * bitOn k) ∧
      ¬RankAtMostTwo wThree :=
  ⟨wThree_threeTermDecomposition, wThree_not_rankAtMostTwo⟩

/-- The actual squarefree three-prime restriction of `q₁` has tensor rank
three: its marked-prime formula supplies three terms, while the local basis
change to `W₃` excludes two. -/
theorem squarefreeChargeThree_has_exactly_three_pure_terms :
    (∀ i j k, squarefreeChargeThree i j k =
      bitOn i * signBit j * signBit k +
      signBit i * bitOn j * signBit k +
      signBit i * signBit j * bitOn k) ∧
      ¬RankAtMostTwo squarefreeChargeThree := by
  refine ⟨squarefreeChargeThree_threeTermDecomposition, ?_⟩
  intro rankTwo
  have transformed := localZeta_preserves_rankAtMostTwo rankTwo
  rw [localZeta_squarefreeChargeThree] at transformed
  exact wThree_not_rankAtMostTwo transformed

end Pairfield.PrimeChargeThreeTensorRank
