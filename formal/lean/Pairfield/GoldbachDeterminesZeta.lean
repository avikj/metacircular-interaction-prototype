import Pairfield.GoldbachPowerSeriesLosslessBridge
import Mathlib.NumberTheory.LSeries.Dirichlet

/-!
# Quantitative Goldbach data determines the zeta logarithmic derivative

The new ingredient here is only the checked composition of two inherited
facts:

* arbitrary real sequences with positive coefficient at `2` are determined
  by all coefficients of their additive convolution square;
* Mathlib's von Mangoldt L-series is `-ζ'/ζ` on `re s > 1`.

No Boolean Goldbach-positivity statement is used or claimed sufficient.
-/

namespace Pairfield.GoldbachDeterminesZeta

open LSeries Nat Complex ArithmeticFunction
open scoped ArithmeticFunction

noncomputable section

/-- The complete quantitative Goldbach convolution of the von Mangoldt
sequence. -/
def mangoldtGoldbachCoeff (N : ℕ) : ℝ :=
  Pairfield.additiveSquareCoeff (fun n ↦ Λ n) N

theorem vonMangoldt_two_pos : 0 < Λ 2 := by
  exact ArithmeticFunction.vonMangoldt_pos_iff.mpr
    (Nat.prime_two.isPrimePow)

/-- Any positive-at-two real sequence with the same complete quantitative
Goldbach field is the von Mangoldt sequence itself. -/
theorem mangoldtGoldbachCoeff_determines_sequence
    (b : ℕ → ℝ) (hb : 0 < b 2)
    (hcoeff : ∀ N, Pairfield.additiveSquareCoeff b N =
      mangoldtGoldbachCoeff N) :
    b = fun n ↦ Λ n := by
  apply
    Pairfield.GoldbachPowerSeriesLosslessBridge.sequence_eq_of_all_additiveSquareCoeff_eq_of_positive_two
      b (fun n ↦ Λ n) hb vonMangoldt_two_pos
  intro N
  exact hcoeff N

/-- Exact tail form of the theorem: because the coefficients at indices zero
and one are known to vanish, Goldbach data beginning at `N = 4` suffice. -/
theorem mangoldtGoldbachTail_determines_sequence
    (b : ℕ → ℝ) (bzero : b 0 = 0) (bone : b 1 = 0) (hb : 0 < b 2)
    (htail : ∀ N, 4 ≤ N → Pairfield.additiveSquareCoeff b N =
      mangoldtGoldbachCoeff N) :
    b = fun n ↦ Λ n := by
  have smallCoeff (a : ℕ → ℝ) (azero : a 0 = 0) (aone : a 1 = 0)
      (N : ℕ) (small : N ≤ 3) :
      Pairfield.additiveSquareCoeff a N = 0 := by
    unfold Pairfield.additiveSquareCoeff
    rw [Finset.Nat.sum_antidiagonal_eq_sum_range_succ
      (fun i j ↦ a i * a j) N]
    interval_cases N <;> norm_num [Finset.sum_range_succ, azero, aone]
  have lambdaZero : Λ 0 = 0 := by
    simp
  have lambdaOne : Λ 1 = 0 :=
    ArithmeticFunction.vonMangoldt_apply_one
  apply mangoldtGoldbachCoeff_determines_sequence b hb
  intro N
  by_cases large : 4 ≤ N
  · exact htail N large
  · have small : N ≤ 3 := by omega
    rw [smallCoeff b bzero bone N small]
    unfold mangoldtGoldbachCoeff
    rw [smallCoeff (fun n ↦ Λ n) lambdaZero lambdaOne N small]

/-- The same data therefore recovers the prime-power support detected by the
von Mangoldt sequence. -/
theorem mangoldtGoldbachCoeff_determines_primePowerSupport
    (b : ℕ → ℝ) (hb : 0 < b 2)
    (hcoeff : ∀ N, Pairfield.additiveSquareCoeff b N =
      mangoldtGoldbachCoeff N) (n : ℕ) :
    0 < b n ↔ IsPrimePow n := by
  rw [mangoldtGoldbachCoeff_determines_sequence b hb hcoeff]
  exact ArithmeticFunction.vonMangoldt_pos_iff

theorem mangoldtGoldbachTail_determines_primePowerSupport
    (b : ℕ → ℝ) (bzero : b 0 = 0) (bone : b 1 = 0) (hb : 0 < b 2)
    (htail : ∀ N, 4 ≤ N → Pairfield.additiveSquareCoeff b N =
      mangoldtGoldbachCoeff N) (n : ℕ) :
    0 < b n ↔ IsPrimePow n := by
  rw [mangoldtGoldbachTail_determines_sequence b bzero bone hb htail]
  exact ArithmeticFunction.vonMangoldt_pos_iff

/-- Consequently, the L-series reconstructed from any such sequence is the
negative logarithmic derivative of Riemann zeta on `re s > 1`. -/
theorem mangoldtGoldbachCoeff_determines_zetaLogDerivative
    (b : ℕ → ℝ) (hb : 0 < b 2)
    (hcoeff : ∀ N, Pairfield.additiveSquareCoeff b N =
      mangoldtGoldbachCoeff N)
    {s : ℂ} (hs : 1 < s.re) :
    LSeries (fun n ↦ (b n : ℂ)) s =
      -deriv riemannZeta s / riemannZeta s := by
  have hsequence := mangoldtGoldbachCoeff_determines_sequence b hb hcoeff
  subst b
  simpa using
    (ArithmeticFunction.LSeries_vonMangoldt_eq_deriv_riemannZeta_div hs)

/-- Tail-data version matching the coefficient list `R(4), R(5), …`. -/
theorem mangoldtGoldbachTail_determines_zetaLogDerivative
    (b : ℕ → ℝ) (bzero : b 0 = 0) (bone : b 1 = 0) (hb : 0 < b 2)
    (htail : ∀ N, 4 ≤ N → Pairfield.additiveSquareCoeff b N =
      mangoldtGoldbachCoeff N)
    {s : ℂ} (hs : 1 < s.re) :
    LSeries (fun n ↦ (b n : ℂ)) s =
      -deriv riemannZeta s / riemannZeta s := by
  have hsequence :=
    mangoldtGoldbachTail_determines_sequence b bzero bone hb htail
  subst b
  simpa using
    (ArithmeticFunction.LSeries_vonMangoldt_eq_deriv_riemannZeta_div hs)

end

end Pairfield.GoldbachDeterminesZeta
