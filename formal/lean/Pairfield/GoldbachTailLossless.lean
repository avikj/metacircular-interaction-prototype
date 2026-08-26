/-
Copyright (c) 2026 Avik Jain and the mathematics collaboration.
Released under Apache 2.0 license.

The exact tail form of losslessness for Goldbach convolution data.  Once the
coefficients at indices zero and one vanish and the common coefficient at two
is fixed and nonzero, coefficients of the convolution square from index four
on determine the whole sequence.
-/
import Pairfield.GoldbachPowerSeriesCharacteristicRigidity

namespace Pairfield.GoldbachTailLossless

/-- The additive-square coefficients below four vanish when the underlying
sequence vanishes at indices zero and one. -/
lemma additiveSquareCoeff_eq_zero_of_lt_four
    (a : ℕ → ℂ) (hzero : a 0 = 0) (hone : a 1 = 0)
    (N : ℕ) (hN : N < 4) :
    Pairfield.additiveSquareCoeff a N = 0 := by
  interval_cases N <;>
    norm_num [Pairfield.additiveSquareCoeff,
      Finset.HasAntidiagonal.antidiagonal, hzero, hone]

/-- Exact tail theorem: equality of the Goldbach coefficients only for
`N ≥ 4` determines arbitrary complex sequences in the normalized nonzero
index-two fiber. -/
theorem sequence_eq_of_additiveSquareCoeff_tail_eq
    (a b : ℕ → ℂ)
    (ha_zero : a 0 = 0) (ha_one : a 1 = 0)
    (hb_zero : b 0 = 0) (hb_one : b 1 = 0)
    (htwo : a 2 = b 2) (hne : a 2 ≠ 0)
    (htail : ∀ N, 4 ≤ N → Pairfield.additiveSquareCoeff a N =
      Pairfield.additiveSquareCoeff b N) :
    a = b := by
  apply Pairfield.GoldbachPowerSeriesCharacteristicRigidity.complex_sequence_eq_of_all_additiveSquareCoeff_eq_of_same_nonzero_two
    a b htwo hne
  intro N
  by_cases hN : 4 ≤ N
  · exact htail N hN
  · rw [additiveSquareCoeff_eq_zero_of_lt_four a ha_zero ha_one N (by omega),
      additiveSquareCoeff_eq_zero_of_lt_four b hb_zero hb_one N (by omega)]

/-- Complex sequences with fixed index-two coefficient and vanishing
coefficients at zero and one. -/
def NormalizedFiber (c : ℂ) :=
  {a : ℕ → ℂ // a 0 = 0 ∧ a 1 = 0 ∧ a 2 = c}

/-- Goldbach convolution data indexed from its first potentially nonzero
coefficient: output index `n` stores the coefficient at `n + 4`. -/
def goldbachTail {c : ℂ} (a : NormalizedFiber c) : ℕ → ℂ :=
  fun n ↦ Pairfield.additiveSquareCoeff a.1 (n + 4)

/-- On every fiber with fixed nonzero index-two coefficient, the complete
Goldbach tail is injective. -/
theorem goldbachTail_injective {c : ℂ} (hc : c ≠ 0) :
    Function.Injective (@goldbachTail c) := by
  intro a b hab
  apply Subtype.ext
  apply sequence_eq_of_additiveSquareCoeff_tail_eq a.1 b.1
    a.2.1 a.2.2.1 b.2.1 b.2.2.1
  · exact a.2.2.2.trans b.2.2.2.symm
  · simpa only [a.2.2.2] using hc
  · intro N hN
    obtain ⟨n, rfl⟩ : ∃ n, N = n + 4 := ⟨N - 4, by omega⟩
    exact congrFun hab n

/-- Precise bijectivity-on-image form of T1: after fixing the common nonzero
coefficient at index two, normalized prime-weight signals are equivalent to
the Goldbach tails which actually arise from such signals. -/
noncomputable def goldbachTailEquivRange {c : ℂ} (hc : c ≠ 0) :
    NormalizedFiber c ≃ Set.range (@goldbachTail c) :=
  Equiv.ofInjective (@goldbachTail c) (goldbachTail_injective hc)

end Pairfield.GoldbachTailLossless
