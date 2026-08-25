/-
Copyright (c) 2026 Avik Jain and the mathematics collaboration.
Released under Apache 2.0 license.

A smallest exact control showing that Boolean positivity of every additive
square coefficient loses quantitative information.  Both sequences are
nonnegative and supported only at index two.
-/
import Pairfield.GoldbachDeterminesZeta

namespace Pairfield.BooleanGoldbachInformationLoss

/-- Boolean support of the quantitative additive-square coefficient. -/
def positivitySupport (a : ℕ → ℝ) (N : ℕ) : Prop :=
  0 < Pairfield.additiveSquareCoeff a N

/-- A sequence with one coefficient, at index two. -/
def spikeAtTwo (weight : ℝ) (n : ℕ) : ℝ :=
  if n = 2 then weight else 0

/-- Its quantitative additive square has exactly one nonzero coefficient. -/
theorem additiveSquareCoeff_spikeAtTwo (weight : ℝ) (N : ℕ) :
    Pairfield.additiveSquareCoeff (spikeAtTwo weight) N =
      if N = 4 then weight * weight else 0 := by
  by_cases hN : N = 4
  · subst N
    simpa [spikeAtTwo] using
      (Pairfield.additiveSquareCoeff_four
        (spikeAtTwo weight) (by simp [spikeAtTwo]) (by simp [spikeAtTwo]))
  · rw [if_neg hN]
    unfold Pairfield.additiveSquareCoeff
    apply Finset.sum_eq_zero
    intro pair hpair
    have hsum := Finset.HasAntidiagonal.mem_antidiagonal.mp hpair
    by_cases hfirst : pair.1 = 2
    · have hsecond : pair.2 ≠ 2 := by
        intro hsecond
        apply hN
        omega
      simp [spikeAtTwo, hfirst, hsecond]
    · simp [spikeAtTwo, hfirst]

/-- Every positive spike has Boolean convolution support exactly at four. -/
theorem positivitySupport_spikeAtTwo_iff
    (weight : ℝ) (hweight : 0 < weight) (N : ℕ) :
    positivitySupport (spikeAtTwo weight) N ↔ N = 4 := by
  rw [positivitySupport, additiveSquareCoeff_spikeAtTwo]
  by_cases hN : N = 4
  · simp [hN, mul_pos hweight hweight]
  · simp [hN]

/-- The lighter singleton sequence. -/
def light : ℕ → ℝ := spikeAtTwo 1

/-- The heavier singleton sequence, with identical positive support. -/
def heavy : ℕ → ℝ := spikeAtTwo 2

theorem light_nonnegative : ∀ n, 0 ≤ light n := by
  intro n
  by_cases hn : n = 2 <;> simp [light, spikeAtTwo, hn]

theorem heavy_nonnegative : ∀ n, 0 ≤ heavy n := by
  intro n
  by_cases hn : n = 2 <;> simp [heavy, spikeAtTwo, hn]

theorem light_finiteSupport : Function.HasFiniteSupport light := by
  simp [Function.HasFiniteSupport, Function.support, light, spikeAtTwo]

theorem heavy_finiteSupport : Function.HasFiniteSupport heavy := by
  simp [Function.HasFiniteSupport, Function.support, heavy, spikeAtTwo]

theorem light_two_pos : 0 < light 2 := by norm_num [light, spikeAtTwo]

theorem heavy_two_pos : 0 < heavy 2 := by norm_num [heavy, spikeAtTwo]

theorem light_ne_heavy : light ≠ heavy := by
  intro h
  have htwo := congrFun h 2
  norm_num [light, heavy, spikeAtTwo] at htwo

/-- The complete Boolean Goldbach data agree at every centre. -/
theorem light_heavy_same_positivitySupport :
    positivitySupport light = positivitySupport heavy := by
  funext N
  apply propext
  unfold light heavy
  rw [positivitySupport_spikeAtTwo_iff 1 (by norm_num),
    positivitySupport_spikeAtTwo_iff 2 (by norm_num)]

/-- Their quantitative Goldbach coefficients already differ at centre four. -/
theorem light_heavy_quantitativeCoeff_four_ne :
    Pairfield.additiveSquareCoeff light 4 ≠
      Pairfield.additiveSquareCoeff heavy 4 := by
  norm_num [light, heavy, additiveSquareCoeff_spikeAtTwo]

/-- Packaged counterexample: finite support, nonnegativity, positive anchor,
identical Boolean data at every centre, but unequal quantitative data. -/
theorem booleanGoldbach_not_quantitatively_lossless :
    Function.HasFiniteSupport light ∧ Function.HasFiniteSupport heavy ∧
    (∀ n, 0 ≤ light n) ∧ (∀ n, 0 ≤ heavy n) ∧
    0 < light 2 ∧ 0 < heavy 2 ∧ light ≠ heavy ∧
    positivitySupport light = positivitySupport heavy ∧
    Pairfield.additiveSquareCoeff light 4 ≠
      Pairfield.additiveSquareCoeff heavy 4 :=
  ⟨light_finiteSupport, heavy_finiteSupport,
    light_nonnegative, heavy_nonnegative, light_two_pos, heavy_two_pos,
    light_ne_heavy, light_heavy_same_positivitySupport,
    light_heavy_quantitativeCoeff_four_ne⟩

end Pairfield.BooleanGoldbachInformationLoss
