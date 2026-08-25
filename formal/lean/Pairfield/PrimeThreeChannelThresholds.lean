/-
Copyright (c) 2026 Avik Jain and the mathematics collaboration.
Released under Apache 2.0 license.

Two different finite arithmetic objects give concrete exact-rank-three
controls.  The first is the three-mode rational tensor obtained by restricting
`q₁ = μ * 1_P` to three squarefree exponent bits.  The second is the two-mode
complex CRT matrix of standard-prime representatives modulo `15`.

The theorem below deliberately keeps the two rank notions separate.  It does
not identify their domains, coefficient fields, or tensor formats.  It also
attaches finite Kloosterman completion only to the residue-class object; the
completion is an arbitrary-weight Fourier identity, not a low-rank CRT
factorization.
-/
import Pairfield.PrimeChargeThreeTensorRank
import Pairfield.PrimeResidueKloostermanRankFifteen

namespace Pairfield.PrimeThreeChannelThresholds

open Pairfield.FiniteKloostermanCompletion
open Pairfield.PrimeChargeThreeTensorRank
open Pairfield.PrimeResidueTensorRankFifteen
open Pairfield.PrimeResidueKloostermanRankFifteen

/-- The two audited three-channel thresholds, stated without conflating their
rank notions:

* on the left, a three-way tensor `Bool → Bool → Bool → ℚ` for the squarefree
  three-place restriction of `q₁` has a three-term marked-prime decomposition
  and no two-term decomposition;
* on the right, the bipartite `ZMod 3 × ZMod 5` matrix of the standard-prime
  representative weight modulo `15` has CRT rank exactly three and, separately,
  its arbitrary-weight finite Kloosterman completion.
-/
theorem distinct_concrete_three_channel_thresholds (n : ZMod 15) :
    ((∀ i j k, squarefreeChargeThree i j k =
      bitOn i * signBit j * signBit k +
      signBit i * bitOn j * signBit k +
      signBit i * signBit j * bitOn k) ∧
      ¬ RankAtMostTwo squarefreeChargeThree) ∧
    ((inversePhaseSum primeResidueWeightFifteen n =
      (15 : ℂ)⁻¹ * ∑ m : ZMod 15,
        ZMod.dft primeResidueWeightFifteen m * kloostermanSum m n) ∧
      (¬ CRTTensorRankAtMostTwo primeResidueWeightFifteen) ∧
      CRTTensorRankAtMostThree primeResidueWeightFifteen) :=
  ⟨squarefreeChargeThree_has_exactly_three_pure_terms,
    finiteKloostermanCompletion_with_exact_CRT_rank_three n⟩

end Pairfield.PrimeThreeChannelThresholds
