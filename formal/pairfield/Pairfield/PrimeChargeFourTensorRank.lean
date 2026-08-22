import Pairfield.PrimeChargeThreeTensorRank

/-!
# Four-place prime charge has tensor rank four

This module carries the squarefree prime-charge mechanism one step beyond the
first `W₃` obstruction.  A reusable substitution lemma says that a nonzero
slice of a four-mode tensor with three pure summands can be used to eliminate
one summand from a suitable linear combination of the other slice.  Applied to
`W₄`, that combination is a first-mode shear of `W₃`, whose rank-two
obstruction is already checked.

The final local zeta change of basis transfers exact rank four from `W₄` to
the four-place restriction of `q₁ = μ * 1_P`.  Everything here is over `ℚ` and
concerns four-way CP tensor rank.  It is unrelated to the bipartite CRT matrix
rank of a residue-class weight.
-/

namespace Pairfield.PrimeChargeFourTensorRank

open Pairfield.PrimeChargeThreeTensorRank

/-- A four-bit tensor is a sum of at most three pure local products. -/
def RankAtMostThree (weight : Bool → Bool → Bool → Bool → ℚ) : Prop :=
  ∃ a₁ b₁ c₁ d₁ a₂ b₂ c₂ d₂ a₃ b₃ c₃ d₃ : Bool → ℚ,
    ∀ i j k l,
      weight i j k l =
        a₁ i * b₁ j * c₁ k * d₁ l +
        a₂ i * b₂ j * c₂ k * d₂ l +
        a₃ i * b₃ j * c₃ k * d₃ l

/-- Substitution in the last mode.  If a three-summand four-mode tensor has a
nonzero `true` slice, one summand can be cancelled from a linear combination
of its two slices.  The resulting three-mode tensor has at most two pure
summands. -/
theorem rankAtMostThree_substitution
    {weight : Bool → Bool → Bool → Bool → ℚ}
    (rankThree : RankAtMostThree weight)
    (nonzeroTrueSlice : ∃ i j k, weight i j k true ≠ 0) :
    ∃ lambda : ℚ,
      RankAtMostTwo
        (fun i j k ↦ weight i j k false - lambda * weight i j k true) := by
  rcases rankThree with
    ⟨a₁, b₁, c₁, d₁, a₂, b₂, c₂, d₂, a₃, b₃, c₃, d₃, realizes⟩
  rcases nonzeroTrueSlice with ⟨i₀, j₀, k₀, slice_ne⟩
  have oneLastFactor : d₁ true ≠ 0 ∨ d₂ true ≠ 0 ∨ d₃ true ≠ 0 := by
    by_cases h₁ : d₁ true = 0
    · by_cases h₂ : d₂ true = 0
      · right
        right
        intro h₃
        have slice_zero : weight i₀ j₀ k₀ true = 0 := by
          rw [realizes]
          simp [h₁, h₂, h₃]
        exact slice_ne slice_zero
      · exact Or.inr (Or.inl h₂)
    · exact Or.inl h₁
  rcases oneLastFactor with h₁ | h₂ | h₃
  · refine ⟨d₁ false / d₁ true, ?_⟩
    refine ⟨a₂, b₂,
      (fun k ↦ c₂ k * (d₂ false - (d₁ false / d₁ true) * d₂ true)),
      a₃, b₃,
      (fun k ↦ c₃ k * (d₃ false - (d₁ false / d₁ true) * d₃ true)), ?_⟩
    intro i j k
    change weight i j k false - (d₁ false / d₁ true) * weight i j k true = _
    rw [realizes i j k false, realizes i j k true]
    field_simp [h₁]
    ring
  · refine ⟨d₂ false / d₂ true, ?_⟩
    refine ⟨a₁, b₁,
      (fun k ↦ c₁ k * (d₁ false - (d₂ false / d₂ true) * d₁ true)),
      a₃, b₃,
      (fun k ↦ c₃ k * (d₃ false - (d₂ false / d₂ true) * d₃ true)), ?_⟩
    intro i j k
    change weight i j k false - (d₂ false / d₂ true) * weight i j k true = _
    rw [realizes i j k false, realizes i j k true]
    field_simp [h₂]
    ring
  · refine ⟨d₃ false / d₃ true, ?_⟩
    refine ⟨a₁, b₁,
      (fun k ↦ c₁ k * (d₁ false - (d₃ false / d₃ true) * d₁ true)),
      a₂, b₂,
      (fun k ↦ c₂ k * (d₂ false - (d₃ false / d₃ true) * d₂ true)), ?_⟩
    intro i j k
    change weight i j k false - (d₃ false / d₃ true) * weight i j k true = _
    rw [realizes i j k false, realizes i j k true]
    field_simp [h₃]
    ring

/-- The vacuum tensor on three Boolean modes. -/
def vacuumThree (i j k : Bool) : ℚ := bitOff i * bitOff j * bitOff k

/-- Add a multiple of the `true` first slice to the `false` first slice. -/
def firstShear (lambda : ℚ) (weight : Bool → Bool → Bool → ℚ) :
    Bool → Bool → Bool → ℚ
  | false, j, k => weight false j k + lambda * weight true j k
  | true, j, k => weight true j k

/-- A local shear does not increase the number of pure summands. -/
theorem firstShear_preserves_rankAtMostTwo
    {weight : Bool → Bool → Bool → ℚ} {lambda : ℚ}
    (rankTwo : RankAtMostTwo weight) :
    RankAtMostTwo (firstShear lambda weight) := by
  rcases rankTwo with ⟨a, b, c, d, e, f, realizes⟩
  let shearFactor : (Bool → ℚ) → Bool → ℚ := fun g i ↦
    if i then g true else g false + lambda * g true
  refine ⟨shearFactor a, b, c, shearFactor d, e, f, ?_⟩
  intro i j k
  cases i <;> simp [firstShear, shearFactor, realizes]
  all_goals ring

/-- `W₃` with an arbitrary vacuum coefficient. -/
def shiftedWThree (lambda : ℚ) (i j k : Bool) : ℚ :=
  wThree i j k - lambda * vacuumThree i j k

/-- The vacuum shift is exactly an invertible shear of the first mode. -/
theorem firstShear_shiftedWThree (lambda : ℚ) :
    firstShear lambda (shiftedWThree lambda) = wThree := by
  funext i j k
  cases i <;> cases j <;> cases k <;>
    norm_num [firstShear, shiftedWThree, vacuumThree, wThree, bitOff]

/-- No vacuum shift of `W₃` can have only two pure summands. -/
theorem shiftedWThree_not_rankAtMostTwo (lambda : ℚ) :
    ¬ RankAtMostTwo (shiftedWThree lambda) := by
  intro rankTwo
  have sheared := firstShear_preserves_rankAtMostTwo (lambda := lambda) rankTwo
  rw [firstShear_shiftedWThree lambda] at sheared
  exact wThree_not_rankAtMostTwo sheared

/-- The four-party `W` tensor: exactly one active local place. -/
def wFour : Bool → Bool → Bool → Bool → ℚ
  | true, false, false, false => 1
  | false, true, false, false => 1
  | false, false, true, false => 1
  | false, false, false, true => 1
  | _, _, _, _ => 0

theorem wFour_falseSlice (i j k : Bool) :
    wFour i j k false = wThree i j k := by
  cases i <;> cases j <;> cases k <;> rfl

theorem wFour_trueSlice (i j k : Bool) :
    wFour i j k true = vacuumThree i j k := by
  cases i <;> cases j <;> cases k <;>
    norm_num [wFour, vacuumThree, bitOff]

/-- The substitution lemma turns any hypothetical three-term expression for
`W₄` into a forbidden two-term expression for a vacuum shift of `W₃`. -/
theorem wFour_not_rankAtMostThree : ¬ RankAtMostThree wFour := by
  intro rankThree
  have nonzeroTrueSlice : ∃ i j k, wFour i j k true ≠ 0 := by
    refine ⟨false, false, false, ?_⟩
    norm_num [wFour]
  rcases rankAtMostThree_substitution rankThree nonzeroTrueSlice with
    ⟨lambda, rankTwo⟩
  have identifies :
      (fun i j k ↦ wFour i j k false - lambda * wFour i j k true) =
        shiftedWThree lambda := by
    funext i j k
    rw [wFour_falseSlice, wFour_trueSlice]
    rfl
  rw [identifies] at rankTwo
  exact shiftedWThree_not_rankAtMostTwo lambda rankTwo

/-- The evident four-term pure decomposition of `W₄`. -/
theorem wFour_fourTermDecomposition (i j k l : Bool) :
    wFour i j k l =
      bitOn i * bitOff j * bitOff k * bitOff l +
      bitOff i * bitOn j * bitOff k * bitOff l +
      bitOff i * bitOff j * bitOn k * bitOff l +
      bitOff i * bitOff j * bitOff k * bitOn l := by
  cases i <;> cases j <;> cases k <;> cases l <;>
    norm_num [wFour, bitOn, bitOff]

/-- Exact rank-four statement for `W₄` over `ℚ`. -/
theorem wFour_has_exactly_four_pure_terms :
    (∀ i j k l, wFour i j k l =
      bitOn i * bitOff j * bitOff k * bitOff l +
      bitOff i * bitOn j * bitOff k * bitOff l +
      bitOff i * bitOff j * bitOn k * bitOff l +
      bitOff i * bitOff j * bitOff k * bitOn l) ∧
      ¬ RankAtMostThree wFour :=
  ⟨wFour_fourTermDecomposition, wFour_not_rankAtMostThree⟩

/-- The marked-prime formula for `q₁` on four squarefree prime places. -/
def squarefreeChargeFour (i j k l : Bool) : ℚ :=
  bitOn i * signBit j * signBit k * signBit l +
  signBit i * bitOn j * signBit k * signBit l +
  signBit i * signBit j * bitOn k * signBit l +
  signBit i * signBit j * signBit k * bitOn l

def zetaFirst (weight : Bool → Bool → Bool → Bool → ℚ) :
    Bool → Bool → Bool → Bool → ℚ
  | false, j, k, l => weight false j k l
  | true, j, k, l => weight false j k l + weight true j k l

def zetaSecond (weight : Bool → Bool → Bool → Bool → ℚ) :
    Bool → Bool → Bool → Bool → ℚ
  | i, false, k, l => weight i false k l
  | i, true, k, l => weight i false k l + weight i true k l

def zetaThird (weight : Bool → Bool → Bool → Bool → ℚ) :
    Bool → Bool → Bool → Bool → ℚ
  | i, j, false, l => weight i j false l
  | i, j, true, l => weight i j false l + weight i j true l

def zetaFourth (weight : Bool → Bool → Bool → Bool → ℚ) :
    Bool → Bool → Bool → Bool → ℚ
  | i, j, k, false => weight i j k false
  | i, j, k, true => weight i j k false + weight i j k true

def localZetaFour (weight : Bool → Bool → Bool → Bool → ℚ) :
    Bool → Bool → Bool → Bool → ℚ :=
  zetaFourth (zetaThird (zetaSecond (zetaFirst weight)))

theorem zetaFirst_preserves_rankAtMostThree
    {weight : Bool → Bool → Bool → Bool → ℚ}
    (rankThree : RankAtMostThree weight) :
    RankAtMostThree (zetaFirst weight) := by
  rcases rankThree with
    ⟨a₁, b₁, c₁, d₁, a₂, b₂, c₂, d₂, a₃, b₃, c₃, d₃, realizes⟩
  refine ⟨zetaBit a₁, b₁, c₁, d₁, zetaBit a₂, b₂, c₂, d₂,
    zetaBit a₃, b₃, c₃, d₃, ?_⟩
  intro i j k l
  cases i <;> simp [zetaFirst, zetaBit, realizes]
  all_goals ring

theorem zetaSecond_preserves_rankAtMostThree
    {weight : Bool → Bool → Bool → Bool → ℚ}
    (rankThree : RankAtMostThree weight) :
    RankAtMostThree (zetaSecond weight) := by
  rcases rankThree with
    ⟨a₁, b₁, c₁, d₁, a₂, b₂, c₂, d₂, a₃, b₃, c₃, d₃, realizes⟩
  refine ⟨a₁, zetaBit b₁, c₁, d₁, a₂, zetaBit b₂, c₂, d₂,
    a₃, zetaBit b₃, c₃, d₃, ?_⟩
  intro i j k l
  cases j <;> simp [zetaSecond, zetaBit, realizes]
  all_goals ring

theorem zetaThird_preserves_rankAtMostThree
    {weight : Bool → Bool → Bool → Bool → ℚ}
    (rankThree : RankAtMostThree weight) :
    RankAtMostThree (zetaThird weight) := by
  rcases rankThree with
    ⟨a₁, b₁, c₁, d₁, a₂, b₂, c₂, d₂, a₃, b₃, c₃, d₃, realizes⟩
  refine ⟨a₁, b₁, zetaBit c₁, d₁, a₂, b₂, zetaBit c₂, d₂,
    a₃, b₃, zetaBit c₃, d₃, ?_⟩
  intro i j k l
  cases k <;> simp [zetaThird, zetaBit, realizes]
  all_goals ring

theorem zetaFourth_preserves_rankAtMostThree
    {weight : Bool → Bool → Bool → Bool → ℚ}
    (rankThree : RankAtMostThree weight) :
    RankAtMostThree (zetaFourth weight) := by
  rcases rankThree with
    ⟨a₁, b₁, c₁, d₁, a₂, b₂, c₂, d₂, a₃, b₃, c₃, d₃, realizes⟩
  refine ⟨a₁, b₁, c₁, zetaBit d₁, a₂, b₂, c₂, zetaBit d₂,
    a₃, b₃, c₃, zetaBit d₃, ?_⟩
  intro i j k l
  cases l <;> simp [zetaFourth, zetaBit, realizes]
  all_goals ring

theorem localZetaFour_preserves_rankAtMostThree
    {weight : Bool → Bool → Bool → Bool → ℚ}
    (rankThree : RankAtMostThree weight) :
    RankAtMostThree (localZetaFour weight) :=
  zetaFourth_preserves_rankAtMostThree
    (zetaThird_preserves_rankAtMostThree
      (zetaSecond_preserves_rankAtMostThree
        (zetaFirst_preserves_rankAtMostThree rankThree)))

/-- The four-place charge becomes `W₄` under the local Boolean zeta basis
change. -/
theorem localZetaFour_squarefreeChargeFour :
    localZetaFour squarefreeChargeFour = wFour := by
  funext i j k l
  cases i <;> cases j <;> cases k <;> cases l <;>
    norm_num [localZetaFour, zetaFirst, zetaSecond, zetaThird, zetaFourth,
      squarefreeChargeFour, wFour, bitOn, signBit]

/-- Exact rank four for the actual four-place squarefree restriction of
`q₁`. -/
theorem squarefreeChargeFour_has_exactly_four_pure_terms :
    (∀ i j k l, squarefreeChargeFour i j k l =
      bitOn i * signBit j * signBit k * signBit l +
      signBit i * bitOn j * signBit k * signBit l +
      signBit i * signBit j * bitOn k * signBit l +
      signBit i * signBit j * signBit k * bitOn l) ∧
      ¬ RankAtMostThree squarefreeChargeFour := by
  refine ⟨fun _ _ _ _ ↦ rfl, ?_⟩
  intro rankThree
  have transformed := localZetaFour_preserves_rankAtMostThree rankThree
  rw [localZetaFour_squarefreeChargeFour] at transformed
  exact wFour_not_rankAtMostThree transformed

end Pairfield.PrimeChargeFourTensorRank
