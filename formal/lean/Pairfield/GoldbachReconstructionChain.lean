/-
Copyright (c) 2026 Avik Jain and the mathematics collaboration.
Released under Apache 2.0 license.

A headline composition of the checked Goldbach reconstruction chain.  This
module deliberately stops in the half-plane `re s > 1`; it makes no claim
about constructing or determining an analytic continuation.
-/
import Pairfield.GoldbachTailLossless
import Pairfield.VonMangoldtTriangularReconstruction

namespace Pairfield.GoldbachReconstructionChain

open LSeries Nat Complex ArithmeticFunction
open scoped ArithmeticFunction

noncomputable section

abbrev R : ℕ → ℝ :=
  Pairfield.GoldbachDeterminesZeta.mangoldtGoldbachCoeff

/-- The exact checked T1--T3 chain.  A normalized real sequence whose
quantitative Goldbach coefficients agree with the von Mangoldt coefficients
from `N = 4` onward, with positivity fixing the square-root sign, is the von
Mangoldt sequence.  It consequently obeys the exceptional base reconstruction
at index two, the triangular formula from index three onward, and has the
zeta logarithmic derivative as its L-series on `re s > 1`.

The conclusion is reconstruction from data known to lie in the Goldbach
map's image; no surjectivity onto arbitrary tail sequences is asserted. -/
theorem goldbachTail_reconstruction_chain
    (b : ℕ → ℝ)
    (bzero : b 0 = 0) (bone : b 1 = 0) (btwo : 0 < b 2)
    (htail : ∀ N, 4 ≤ N → Pairfield.additiveSquareCoeff b N = R N)
    {s : ℂ} (hs : 1 < s.re) :
    b = (fun n ↦ Λ n) ∧
    b 2 = Real.sqrt (R 4) ∧
    (∀ n, 3 ≤ n →
      b n =
        (R (n + 2) - Pairfield.additiveSquareInterior b n) /
          (2 * Real.log 2)) ∧
    LSeries (fun n ↦ (b n : ℂ)) s =
      -deriv riemannZeta s / riemannZeta s := by
  have hsequence : b = fun n ↦ Λ n :=
    Pairfield.GoldbachDeterminesZeta.mangoldtGoldbachTail_determines_sequence
      b bzero bone btwo htail
  have hspec :
      Pairfield.VonMangoldtTriangularReconstruction.SatisfiesTriangularSpecification b := by
    rw [hsequence]
    exact Pairfield.VonMangoldtTriangularReconstruction.vonMangoldt_satisfiesTriangularSpecification
  have hlseries :
      LSeries (fun n ↦ (b n : ℂ)) s =
        -deriv riemannZeta s / riemannZeta s :=
    Pairfield.GoldbachDeterminesZeta.mangoldtGoldbachTail_determines_zetaLogDerivative
      b bzero bone btwo htail hs
  exact ⟨hsequence, hspec.two, hspec.step, hlseries⟩

end

end Pairfield.GoldbachReconstructionChain
