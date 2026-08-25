/-
Copyright (c) 2026 Avik Jain and the mathematics collaboration.
Released under Apache 2.0 license.

Finite algebraic rank for coefficient tensors built from separable Whittaker
weights and a scalar radial Kuznetsov kernel.  This file makes no analytic
claim that a radial factor is a Bessel transform of an admissible test.
-/
import Pairfield.KuznetsovSingleKernelBoundary
import Pairfield.PrimeResidueTensorRank

namespace Pairfield.FiniteKuznetsovFactorizationRank

/-- Numeric coordinates on three finite index sets. -/
structure Coordinates (M N C : Type*) where
  first : M → ℕ
  second : N → ℕ
  modulus : C → ℕ

variable {M N C : Type*}

/-- The square of the scalar Bessel argument, with `(4π)²` omitted. -/
def radialCoordinate (coordinates : Coordinates M N C)
    (m : M) (n : N) (c : C) : ℚ :=
  ((coordinates.first m * coordinates.second n : ℕ) : ℚ) /
    ((coordinates.modulus c * coordinates.modulus c : ℕ) : ℚ)

/-- A finite coefficient tensor is a sum of at most `r` terms
`α(m) β(n) Φ(mn/c²)`. -/
def RankAtMost (coordinates : Coordinates M N C) (r : ℕ)
    (weight : M → N → C → ℚ) : Prop :=
  ∃ alpha : Fin r → M → ℚ, ∃ beta : Fin r → N → ℚ,
    ∃ radial : Fin r → ℚ → ℚ,
      ∀ m n c, weight m n c =
        ∑ j : Fin r,
          alpha j m * beta j n * radial j (radialCoordinate coordinates m n c)

/-- Adding one identically-zero summand cannot increase the required rank. -/
theorem rankAtMost_succ {coordinates : Coordinates M N C} {r : ℕ}
    {weight : M → N → C → ℚ}
    (realizes : RankAtMost coordinates r weight) :
    RankAtMost coordinates (r + 1) weight := by
  rcases realizes with ⟨alpha, beta, radial, realizes⟩
  let alpha' : Fin (r + 1) → M → ℚ :=
    Fin.cases (fun _ ↦ 0) alpha
  let beta' : Fin (r + 1) → N → ℚ :=
    Fin.cases (fun _ ↦ 0) beta
  let radial' : Fin (r + 1) → ℚ → ℚ :=
    Fin.cases (fun _ ↦ 0) radial
  refine ⟨alpha', beta', radial', ?_⟩
  intro m n c
  rw [realizes]
  simp [alpha', beta', radial', Fin.sum_univ_succ]

/-- Factorization rank is monotone in the allowed number of summands. -/
theorem rankAtMost_mono {coordinates : Coordinates M N C} {r s : ℕ}
    {weight : M → N → C → ℚ} (hrs : r ≤ s)
    (realizes : RankAtMost coordinates r weight) :
    RankAtMost coordinates s weight := by
  induction s, hrs using Nat.le_induction with
  | base => exact realizes
  | succ s _ ih => exact rankAtMost_succ ih

/-- Rank zero is equivalent to the coefficient tensor being identically
zero. -/
theorem rankAtMost_zero_iff {coordinates : Coordinates M N C}
    {weight : M → N → C → ℚ} :
    RankAtMost coordinates 0 weight ↔ weight = 0 := by
  constructor
  · rintro ⟨alpha, beta, radial, realizes⟩
    funext m n c
    simpa using realizes m n c
  · intro hzero
    subst weight
    refine ⟨(fun j ↦ Fin.elim0 j), (fun j ↦ Fin.elim0 j),
      (fun j ↦ Fin.elim0 j), ?_⟩
    intro m n c
    simp

/-- On a common radial fiber, every rank-one tensor has a vanishing crossed
`2 × 2` minor.  The four modulus indices may be different. -/
theorem rankOne_minor_on_common_radialFiber
    (coordinates : Coordinates M N C) (weight : M → N → C → ℚ)
    (realizes : RankAtMost coordinates 1 weight)
    (m₀ m₁ : M) (n₀ n₁ : N) (c₀₀ c₀₁ c₁₀ c₁₁ : C)
    (h₀₁ : radialCoordinate coordinates m₀ n₀ c₀₀ =
      radialCoordinate coordinates m₀ n₁ c₀₁)
    (h₁₀ : radialCoordinate coordinates m₀ n₀ c₀₀ =
      radialCoordinate coordinates m₁ n₀ c₁₀)
    (h₁₁ : radialCoordinate coordinates m₀ n₀ c₀₀ =
      radialCoordinate coordinates m₁ n₁ c₁₁) :
    weight m₀ n₀ c₀₀ * weight m₁ n₁ c₁₁ =
      weight m₀ n₁ c₀₁ * weight m₁ n₀ c₁₀ := by
  rcases realizes with ⟨alpha, beta, radial, realizes⟩
  rw [realizes m₀ n₀ c₀₀, realizes m₁ n₁ c₁₁,
    realizes m₀ n₁ c₀₁, realizes m₁ n₀ c₁₀]
  simp only [Fin.sum_univ_one]
  rw [← h₀₁, ← h₁₀, ← h₁₁]
  ring

/-! ## Exact crossed rank-two control -/

/-- Two first-index values `1,4`. -/
def crossedFirst (m : Fin 2) : ℕ := if m = 0 then 1 else 4

/-- Two second-index values `1,9`. -/
def crossedSecond (n : Fin 2) : ℕ := if n = 0 then 1 else 9

/-- Four modulus values `1,3,2,6`, one for each crossed corner. -/
def crossedModulus (c : Fin 4) : ℕ :=
  if c = 0 then 1 else if c = 1 then 3 else if c = 2 then 2 else 6

@[simp] theorem crossedFirst_zero : crossedFirst 0 = 1 := by rfl
@[simp] theorem crossedFirst_one : crossedFirst 1 = 4 := by rfl
@[simp] theorem crossedSecond_zero : crossedSecond 0 = 1 := by rfl
@[simp] theorem crossedSecond_one : crossedSecond 1 = 9 := by rfl
@[simp] theorem crossedModulus_zero : crossedModulus 0 = 1 := by rfl
@[simp] theorem crossedModulus_one : crossedModulus 1 = 3 := by rfl
@[simp] theorem crossedModulus_two : crossedModulus 2 = 2 := by rfl
@[simp] theorem crossedModulus_three : crossedModulus 3 = 6 := by rfl

def crossedCoordinates : Coordinates (Fin 2) (Fin 2) (Fin 4) :=
  ⟨crossedFirst, crossedSecond, crossedModulus⟩

/-- The diagonal `2 × 2` tensor, repeated across all four modulus slots. -/
def crossedTensor (m : Fin 2) (n : Fin 2) (_ : Fin 4) : ℚ :=
  if m = n then 1 else 0

/-- The four selected corners all have radial coordinate one. -/
theorem crossedCorners_common_radialFiber :
    radialCoordinate crossedCoordinates 0 0 0 = 1 ∧
    radialCoordinate crossedCoordinates 0 1 1 = 1 ∧
    radialCoordinate crossedCoordinates 1 0 2 = 1 ∧
    radialCoordinate crossedCoordinates 1 1 3 = 1 := by
  norm_num [radialCoordinate, crossedCoordinates, crossedFirst,
    crossedSecond]

/-- Two pure radial tensors reconstruct the crossed control exactly. -/
theorem crossedTensor_rankAtMostTwo :
    RankAtMost crossedCoordinates 2 crossedTensor := by
  refine ⟨(fun j m ↦ if j = m then 1 else 0),
    (fun j n ↦ if j = n then 1 else 0),
    (fun _ _ ↦ 1), ?_⟩
  intro m n c
  fin_cases m <;> fin_cases n <;>
    norm_num [crossedTensor, Fin.sum_univ_two]

/-- The nonzero crossed minor rules out a rank-one realization. -/
theorem crossedTensor_not_rankAtMostOne :
    ¬RankAtMost crossedCoordinates 1 crossedTensor := by
  intro realizes
  have minor := rankOne_minor_on_common_radialFiber
    crossedCoordinates crossedTensor realizes
    (0 : Fin 2) (1 : Fin 2) (0 : Fin 2) (1 : Fin 2)
    (0 : Fin 4) (1 : Fin 4) (2 : Fin 4) (3 : Fin 4)
    (by norm_num [radialCoordinate, crossedCoordinates])
    (by norm_num [radialCoordinate, crossedCoordinates])
    (by norm_num [radialCoordinate, crossedCoordinates])
  norm_num [crossedTensor] at minor

/-- The crossed finite tensor has factorization rank exactly two. -/
theorem crossedTensor_rankExactlyTwo :
    RankAtMost crossedCoordinates 2 crossedTensor ∧
      ¬RankAtMost crossedCoordinates 1 crossedTensor :=
  ⟨crossedTensor_rankAtMostTwo, crossedTensor_not_rankAtMostOne⟩

end Pairfield.FiniteKuznetsovFactorizationRank
