/-
Copyright (c) 2026 Avik Jain and the mathematics collaboration.
Released under Apache 2.0 license.

The exact triangular inverse of the complete quantitative Goldbach
convolution for Mathlib's von Mangoldt sequence.  Index two is an exceptional
square-root base case; the division formula starts at index three.
-/
import Pairfield.GoldbachDeterminesZeta

namespace Pairfield.VonMangoldtTriangularReconstruction

open scoped ArithmeticFunction

noncomputable section

abbrev R : ℕ → ℝ :=
  Pairfield.GoldbachDeterminesZeta.mangoldtGoldbachCoeff

theorem vonMangoldt_two_eq_log_two : Λ 2 = Real.log 2 :=
  ArithmeticFunction.vonMangoldt_apply_prime Nat.prime_two

/-- The exceptional base coefficient is recovered by the positive square
root, and both are exactly `log 2`. -/
theorem vonMangoldt_two_eq_sqrt_R_four_eq_log_two :
    Λ 2 = Real.sqrt (R 4) ∧ Real.sqrt (R 4) = Real.log 2 := by
  have hroot : Λ 2 = Real.sqrt (R 4) := by
    simpa only [R,
      Pairfield.GoldbachDeterminesZeta.mangoldtGoldbachCoeff] using
      (Pairfield.leadingCoefficient_eq_sqrt_squareCoeff
        (fun n ↦ Λ n) (by rfl)
        ArithmeticFunction.vonMangoldt_apply_one
        ArithmeticFunction.vonMangoldt_nonneg)
  exact ⟨hroot, hroot.symm.trans vonMangoldt_two_eq_log_two⟩

/-- From index three onward, the existing triangular inverse specializes to
the von Mangoldt sequence with denominator `2 log 2`. -/
theorem vonMangoldt_triangular_formula (n : ℕ) (hn : 3 ≤ n) :
    Λ n =
      (R (n + 2) -
        Pairfield.additiveSquareInterior (fun k ↦ Λ k) n) /
          (2 * Real.log 2) := by
  have h := Pairfield.triangularCoefficient_reconstruct
    (fun k ↦ Λ k) R n hn (by rfl)
    ArithmeticFunction.vonMangoldt_apply_one
    Pairfield.GoldbachDeterminesZeta.vonMangoldt_two_pos.ne'
    (by rfl)
  simpa only [vonMangoldt_two_eq_log_two] using h

/-- A candidate sequence satisfies the checked recursive specification when
it has the two zero initial values, the exceptional square-root value at two,
and the triangular equation at every later index. -/
structure SatisfiesTriangularSpecification (a : ℕ → ℝ) : Prop where
  zero : a 0 = 0
  one : a 1 = 0
  two : a 2 = Real.sqrt (R 4)
  step : ∀ n, 3 ≤ n →
    a n =
      (R (n + 2) - Pairfield.additiveSquareInterior a n) /
        (2 * Real.log 2)

/-- Mathlib's von Mangoldt sequence satisfies the recursive specification. -/
theorem vonMangoldt_satisfiesTriangularSpecification :
    SatisfiesTriangularSpecification (fun n ↦ Λ n) where
  zero := by rfl
  one := ArithmeticFunction.vonMangoldt_apply_one
  two := vonMangoldt_two_eq_sqrt_R_four_eq_log_two.1
  step := vonMangoldt_triangular_formula

/-- The specification is genuinely triangular: its initial values and later
equations determine at most one sequence. -/
theorem triangularSpecification_unique
    {a b : ℕ → ℝ}
    (ha : SatisfiesTriangularSpecification a)
    (hb : SatisfiesTriangularSpecification b) :
    a = b := by
  funext n
  induction n using Nat.strong_induction_on with
  | h n ih =>
      by_cases hn : 3 ≤ n
      · rw [ha.step n hn, hb.step n hn]
        have hinterior :
            Pairfield.additiveSquareInterior a n =
              Pairfield.additiveSquareInterior b n := by
          unfold Pairfield.additiveSquareInterior
          apply Finset.sum_congr rfl
          intro pair hpair
          have hlt := Pairfield.additiveSquareInterior_indices_lt hpair
          rw [ih pair.1 hlt.1, ih pair.2 hlt.2]
        rw [hinterior]
      · have hnlt : n < 3 := Nat.lt_of_not_ge hn
        interval_cases n
        · exact ha.zero.trans hb.zero.symm
        · exact ha.one.trans hb.one.symm
        · exact ha.two.trans hb.two.symm

/-- The checked recursive specification reconstructs exactly the von
Mangoldt sequence. -/
theorem eq_vonMangoldt_of_satisfiesTriangularSpecification
    {a : ℕ → ℝ} (ha : SatisfiesTriangularSpecification a) :
    a = fun n ↦ Λ n :=
  triangularSpecification_unique ha
    vonMangoldt_satisfiesTriangularSpecification

end

end Pairfield.VonMangoldtTriangularReconstruction
