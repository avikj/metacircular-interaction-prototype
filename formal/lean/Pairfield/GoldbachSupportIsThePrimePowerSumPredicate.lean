/-
Copyright (c) 2026 Avik Jain and the mathematics collaboration.
Released under Apache 2.0 license.

The support of the ζ-complete Goldbach field is exactly the two-prime-power
sum predicate.

`GoldbachDeterminesZeta` proves the quantitative field `mangoldtGoldbachCoeff`
is LOSSLESS upward: it determines the von Mangoldt sequence, hence
`-ζ'/ζ` on `re s > 1`.  This module prices the field's own Boolean shadow
exactly: the coefficient at `N` is positive **iff** `N` is a sum of two prime
powers.  Identification, not estimate, on both sides of the field:

  * upward  (kept)  — the field carries the zeta logarithmic derivative;
  * downward (shadow) — its support is the prime-power Goldbach predicate.

So the binary Goldbach-type question for prime powers is, verbatim, a
support question about a field already known to carry the whole of
`-ζ'/ζ`.  Nothing here proves any case of it; what is proved is the exact
identity of the question with a projection of a ζ-complete object.

SYĀT — THE CLAIM, EXACTLY.  Not Goldbach for primes: `Λ` is supported on all
prime powers, so the predicate here is `IsPrimePow p ∧ IsPrimePow q`, not
primality — the classical strong Goldbach statement is strictly finer and
is untouched.  Nothing about `re s ≤ 1`, zeros, or continuation.
-/
import Pairfield.GoldbachDeterminesZeta

namespace Pairfield.GoldbachSupportIsThePrimePowerSumPredicate

open ArithmeticFunction
open scoped ArithmeticFunction

/-- Positivity of one quantitative Goldbach coefficient of the von Mangoldt
field is exactly the statement that `N` is a sum of two prime powers. -/
theorem mangoldtGoldbachCoeff_pos_iff (N : ℕ) :
    0 < Pairfield.GoldbachDeterminesZeta.mangoldtGoldbachCoeff N ↔
      ∃ p q : ℕ, p + q = N ∧ IsPrimePow p ∧ IsPrimePow q := by
  unfold Pairfield.GoldbachDeterminesZeta.mangoldtGoldbachCoeff
  unfold Pairfield.additiveSquareCoeff
  constructor
  · intro hpos
    by_contra hno
    push_neg at hno
    have hzero : ∑ pq ∈ Finset.HasAntidiagonal.antidiagonal N,
        Λ pq.1 * Λ pq.2 = 0 := by
      apply Finset.sum_eq_zero
      intro pq hpq
      have hsum : pq.1 + pq.2 = N :=
        Finset.HasAntidiagonal.mem_antidiagonal.mp hpq
      by_cases hp : IsPrimePow pq.1
      · have hq : ¬ IsPrimePow pq.2 := fun hq => hno pq.1 pq.2 hsum hp hq
        have : Λ pq.2 = 0 := by
          by_contra hne
          exact hq (vonMangoldt_pos_iff.mp
            (lt_of_le_of_ne vonMangoldt_nonneg (Ne.symm hne)))
        simp [this]
      · have : Λ pq.1 = 0 := by
          by_contra hne
          exact hp (vonMangoldt_pos_iff.mp
            (lt_of_le_of_ne vonMangoldt_nonneg (Ne.symm hne)))
        simp [this]
    rw [hzero] at hpos
    exact lt_irrefl 0 hpos
  · rintro ⟨p, q, hsum, hp, hq⟩
    have hmem : (p, q) ∈ Finset.HasAntidiagonal.antidiagonal N :=
      Finset.HasAntidiagonal.mem_antidiagonal.mpr hsum
    have hterm : 0 < Λ p * Λ q :=
      mul_pos (vonMangoldt_pos_iff.mpr hp) (vonMangoldt_pos_iff.mpr hq)
    apply Finset.sum_pos'
    · intro pq _
      exact mul_nonneg vonMangoldt_nonneg vonMangoldt_nonneg
    · exact ⟨(p, q), hmem, hterm⟩

/-- The package, stated once: the field whose values determine `-ζ'/ζ`
(`GoldbachDeterminesZeta.mangoldtGoldbachCoeff_determines_zetaLogDerivative`)
has Boolean support exactly the two-prime-power sum predicate.  The
prime-power Goldbach question IS a projection of a ζ-complete object. -/
theorem support_of_zetaComplete_field (N : ℕ) :
    (∃ p q : ℕ, p + q = N ∧ IsPrimePow p ∧ IsPrimePow q) ↔
      0 < Pairfield.GoldbachDeterminesZeta.mangoldtGoldbachCoeff N :=
  (mangoldtGoldbachCoeff_pos_iff N).symm

end Pairfield.GoldbachSupportIsThePrimePowerSumPredicate
