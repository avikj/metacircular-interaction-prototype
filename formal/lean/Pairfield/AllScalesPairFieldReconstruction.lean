/-
Copyright (c) 2026 Avik Jain and the mathematics collaboration.
Released under Apache 2.0 license.

Algebraic reconstruction from the rank-one pair field and from its diagonal.
The analytic step recovering diagonal coefficients from an all-scale Laplace
field is retained as an explicit premise.
-/
import Mathlib

namespace Pairfield.AllScalesPairFieldReconstruction

/-- The uncompressed rank-one pair field of a sequence. -/
def rankOnePairField {R : Type*} [Mul R]
    (a : ℕ → R) (m n : ℕ) : R :=
  a m * a n

/-- Reconstruct a sequence from the column anchored at index two. -/
def anchoredReconstruction {K : Type*} [Field K]
    (pairField : ℕ → ℕ → K) (anchor : K) (n : ℕ) : K :=
  pairField n 2 / anchor

/-- The anchored column of the rank-one pair field recovers every coefficient
exactly whenever the distinguished coefficient `a 2` is nonzero. -/
theorem anchoredReconstruction_rankOnePairField
    {K : Type*} [Field K] (a : ℕ → K) (ha₂ : a 2 ≠ 0) (n : ℕ) :
    anchoredReconstruction (rankOnePairField a) (a 2) n = a n := by
  exact mul_div_cancel_right₀ (a n) ha₂

/-- The diagonal energy retained by the zero-gap pair field. -/
def diagonalEnergy (a : ℕ → ℝ) (n : ℕ) : ℝ :=
  rankOnePairField a n n

/-- For nonnegative sequences, diagonal energy has no pointwise sign
ambiguity and is therefore injective. -/
theorem diagonalEnergy_injectiveOn_nonnegative
    (a b : ℕ → ℝ) (ha : ∀ n, 0 ≤ a n) (hb : ∀ n, 0 ≤ b n)
    (henergy : diagonalEnergy a = diagonalEnergy b) :
    a = b := by
  funext n
  have hsquare := congrFun henergy n
  simp only [diagonalEnergy, rankOnePairField] at hsquare
  rcases mul_self_eq_mul_self_iff.mp hsquare with h | h
  · exact h
  · nlinarith [ha n, hb n]

/-- An abstract all-`t`, zero-gap field has coefficient uniqueness when
equality of its functions forces equality of every diagonal-energy
coefficient.  Establishing this premise for a concrete Laplace transform is
the analytic theorem deliberately left outside this algebraic module. -/
def HasDiagonalLaplaceCoefficientUniqueness
    (field : (ℕ → ℝ) → ℝ → ℝ) : Prop :=
  ∀ a b, field a = field b → diagonalEnergy a = diagonalEnergy b

/-- Once Laplace coefficient uniqueness is supplied explicitly, equality of
the all-scale zero-gap fields determines every nonnegative sequence. -/
theorem allScaleZeroGapField_injectiveOn_nonnegative
    (field : (ℕ → ℝ) → ℝ → ℝ)
    (coefficientUnique : HasDiagonalLaplaceCoefficientUniqueness field)
    (a b : ℕ → ℝ) (ha : ∀ n, 0 ≤ a n) (hb : ∀ n, 0 ≤ b n)
    (hfield : field a = field b) :
    a = b :=
  diagonalEnergy_injectiveOn_nonnegative a b ha hb
    (coefficientUnique a b hfield)

end Pairfield.AllScalesPairFieldReconstruction
