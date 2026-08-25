/-
Copyright (c) 2026 Avik Jain and the mathematics collaboration.
Released under Apache 2.0 license.

Boolean positivity of the von Mangoldt additive square detects sums of prime
powers, rather than sums of primes.  The first centre where these predicates
differ is eleven.
-/
import Pairfield.BooleanGoldbachSupportInvariance
import Pairfield.GoldbachBoundary

namespace Pairfield.BooleanVonMangoldtPrimePowerSupport

open ArithmeticFunction
open scoped ArithmeticFunction
open Pairfield.BooleanGoldbachInformationLoss
open Pairfield.BooleanGoldbachSupportInvariance

/-- The Boolean von Mangoldt coefficient is positive exactly when its finite
antidiagonal contains two prime powers. -/
theorem vonMangoldt_positivitySupport_iff_primePower_antidiagonal (N : ℕ) :
    positivitySupport (fun n ↦ Λ n) N ↔
      ∃ pair ∈ Finset.HasAntidiagonal.antidiagonal N,
        IsPrimePow pair.1 ∧ IsPrimePow pair.2 := by
  rw [positivitySupport_iff_exists_positive_pair
    (fun n ↦ Λ n) (fun _ ↦ vonMangoldt_nonneg) N]
  simp only [vonMangoldt_pos_iff]

/-- Eleven has positive von Mangoldt convolution support, witnessed by
`4 + 7`, even though it has no representation as a sum of two primes. -/
theorem vonMangoldt_positivitySupport_eleven :
    positivitySupport (fun n ↦ Λ n) 11 := by
  rw [vonMangoldt_positivitySupport_iff_primePower_antidiagonal]
  refine ⟨(4, 7), ?_, ?_, ?_⟩
  · exact Finset.HasAntidiagonal.mem_antidiagonal.mpr (by norm_num)
  · native_decide
  · native_decide

theorem not_goldbachRepresentation_eleven :
    ¬ Pairfield.GoldbachRepresentation 11 := by
  rintro ⟨p, q, hp, hq, hsum⟩
  have hp_le : p ≤ 11 := by omega
  have hq_le : q ≤ 11 := by omega
  interval_cases p <;> interval_cases q <;> norm_num at *

/-- Below eleven, positive prime-power convolution support already implies a
literal prime-pair representation. -/
theorem goldbachRepresentation_of_vonMangoldt_positivitySupport_lt_eleven
    {N : ℕ} (hN : N < 11)
    (hpositive : positivitySupport (fun n ↦ Λ n) N) :
    Pairfield.GoldbachRepresentation N := by
  rw [vonMangoldt_positivitySupport_iff_primePower_antidiagonal] at hpositive
  rcases hpositive with ⟨pair, hpair, hleft, hright⟩
  have hsum : pair.1 + pair.2 = N :=
    Finset.HasAntidiagonal.mem_antidiagonal.mp hpair
  have hfour : 4 ≤ N := by
    have hleft_two : 2 ≤ pair.1 := IsPrimePow.two_le hleft
    have hright_two : 2 ≤ pair.2 := IsPrimePow.two_le hright
    omega
  have hten : N ≤ 10 := by omega
  interval_cases N
  · exact ⟨2, 2, by norm_num, by norm_num, by norm_num⟩
  · exact ⟨2, 3, by norm_num, by norm_num, by norm_num⟩
  · exact ⟨3, 3, by norm_num, by norm_num, by norm_num⟩
  · exact ⟨2, 5, by norm_num, by norm_num, by norm_num⟩
  · exact ⟨3, 5, by norm_num, by norm_num, by norm_num⟩
  · exact ⟨2, 7, by norm_num, by norm_num, by norm_num⟩
  · exact ⟨3, 7, by norm_num, by norm_num, by norm_num⟩

/-- Eleven is the least natural-number centre where Boolean von Mangoldt
positivity can hold without a literal prime-pair representation. -/
theorem eleven_is_least_primePower_only_center :
    positivitySupport (fun n ↦ Λ n) 11 ∧
      ¬ Pairfield.GoldbachRepresentation 11 ∧
      ∀ N, positivitySupport (fun n ↦ Λ n) N →
        ¬ Pairfield.GoldbachRepresentation N → 11 ≤ N := by
  refine ⟨vonMangoldt_positivitySupport_eleven,
    not_goldbachRepresentation_eleven, ?_⟩
  intro N hpositive hnot
  by_contra hN
  exact hnot
    (goldbachRepresentation_of_vonMangoldt_positivitySupport_lt_eleven
      (by omega) hpositive)

end Pairfield.BooleanVonMangoldtPrimePowerSupport
