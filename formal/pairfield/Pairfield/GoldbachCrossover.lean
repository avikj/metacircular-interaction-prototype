/-
Copyright (c) 2026 Avik Jain and the mathematics collaboration.
Released under Apache 2.0 license.

The exact crossover contract between finite verification and an analytic
tail.  A finite `GoldbachUpTo N₀` certificate covers the initial interval;
a pointwise strict lower bound above prime-power contamination covers every
eligible later centre.

This file proves only that those two hypotheses compose to `StrongGoldbach`.
It supplies neither the finite certificate at a chosen large horizon nor the
tail lower bound for the von-Mangoldt coefficient.
-/
import Pairfield.GoldbachDecisionRange
import Pairfield.GoldbachFixedFiberContamination

namespace Pairfield

noncomputable section

/-- The exact-contamination inequality is itself equivalent to Goldbach at
one centre: after unfolding contamination it says precisely that the
prime-log coefficient is positive.  This prevents the abstract crossover
contract below from being misread as an analytic advance. -/
theorem contamination_lt_mangoldtGoldbachCoeff_iff (N : ℕ) :
    primePowerContamination N < mangoldtGoldbachCoeff N ↔ GoldbachAt N := by
  constructor
  · exact goldbachAt_of_contamination_lt_mangoldtGoldbachCoeff N
  · intro hGoldbach
    have hpositive : 0 < primeLogGoldbachCoeff N :=
      (primeLogGoldbachCoeff_pos_iff N).2 hGoldbach
    unfold primePowerContamination
    linarith

/-- A finite Goldbach certificate plus exact pointwise domination of the
prime-power contamination on the remaining tail proves strong Goldbach. -/
theorem strongGoldbach_of_upTo_of_contamination_tail
    (N₀ : ℕ) (hfinite : GoldbachUpTo N₀)
    (htail : ∀ N : ℕ, 4 ≤ N → Even N → N₀ < N →
      primePowerContamination N < mangoldtGoldbachCoeff N) :
    StrongGoldbach := by
  intro N hfour heven
  by_cases hinitial : N ≤ N₀
  · exact hfinite N hfour hinitial heven
  · apply goldbachAt_of_contamination_lt_mangoldtGoldbachCoeff N
    exact htail N hfour heven (lt_of_not_ge hinitial)

/-- The proof-relevant finite certificate emitted by the executable range
checker can be used directly in the same crossover contract. -/
theorem strongGoldbach_of_certificate_of_contamination_tail
    (N₀ : ℕ) (certificate : GoldbachUpToCertificate N₀)
    (htail : ∀ N : ℕ, 4 ≤ N → Even N → N₀ < N →
      primePowerContamination N < mangoldtGoldbachCoeff N) :
    StrongGoldbach := by
  exact strongGoldbach_of_upTo_of_contamination_tail N₀
    (goldbachUpTo_of_certificate certificate) htail

/-- Equivalently, a successful executable finite check can supply the initial
piece of the crossover without evaluating any particular horizon here. -/
theorem strongGoldbach_of_check_of_contamination_tail
    (N₀ : ℕ) (hcheck : goldbachUpToCheck N₀ = true)
    (htail : ∀ N : ℕ, 4 ≤ N → Even N → N₀ < N →
      primePowerContamination N < mangoldtGoldbachCoeff N) :
    StrongGoldbach := by
  apply strongGoldbach_of_certificate_of_contamination_tail N₀
    (goldbachUpToCertificateOfCheck hcheck)
  exact htail

/-- Sharper explicit-tail form.  The fixed-antidiagonal theorem reduces the
analytic tail obligation to beating `4 * sqrt N * log(N)^2`, rather than the
coarser full-square bound. -/
theorem strongGoldbach_of_upTo_of_four_sqrt_mul_log_sq_tail
    (N₀ : ℕ) (hfinite : GoldbachUpTo N₀)
    (htail : ∀ N : ℕ, 4 ≤ N → Even N → N₀ < N →
      4 * Real.sqrt (N : ℝ) * (Real.log (N : ℝ)) ^ 2 <
        mangoldtGoldbachCoeff N) :
    StrongGoldbach := by
  apply strongGoldbach_of_upTo_of_contamination_tail N₀ hfinite
  intro N hfour heven hN₀
  exact lt_of_le_of_lt
    (primePowerContamination_le_four_sqrt_mul_log_sq N (by omega))
    (htail N hfour heven hN₀)

/-- Executable finite-prefix version of the sharp explicit-tail contract. -/
theorem strongGoldbach_of_check_of_four_sqrt_mul_log_sq_tail
    (N₀ : ℕ) (hcheck : goldbachUpToCheck N₀ = true)
    (htail : ∀ N : ℕ, 4 ≤ N → Even N → N₀ < N →
      4 * Real.sqrt (N : ℝ) * (Real.log (N : ℝ)) ^ 2 <
        mangoldtGoldbachCoeff N) :
    StrongGoldbach := by
  apply strongGoldbach_of_upTo_of_four_sqrt_mul_log_sq_tail N₀
    ((goldbachUpToCheck_eq_true_iff N₀).1 hcheck)
  exact htail

end

end Pairfield
