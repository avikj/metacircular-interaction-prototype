/-
Copyright (c) 2026 Avik Jain and the mathematics collaboration.
Released under Apache 2.0 license.

At modulus `15`, the actual standard-prime representative weight has exact
mod-`3`/mod-`5` CRT tensor rank three, while the arbitrary-weight finite
DFT/Kloosterman completion still applies.  Thus Kloosterman completion does
not imply a decomposition into one or two local CRT-factorizable components.
-/
import Pairfield.PrimeResidueTensorRankFifteen
import Pairfield.FiniteKloostermanCompletion

namespace Pairfield.PrimeResidueKloostermanRankFifteen

open Pairfield.FiniteKloostermanCompletion
open Pairfield.PrimeResidueTensorRankFifteen

/-- The arbitrary-weight finite Fourier identity supplies an exact
Kloosterman completion for the standard-prime representative weight modulo
`15`. -/
theorem primeResidueWeightFifteen_has_finiteKloostermanCompletion
    (n : ZMod 15) :
    inversePhaseSum primeResidueWeightFifteen n =
      (15 : ℂ)⁻¹ * ∑ m : ZMod 15,
        ZMod.dft primeResidueWeightFifteen m * kloostermanSum m n :=
  inversePhaseSum_eq_dft_kloosterman primeResidueWeightFifteen n

/-- Exact separation at modulus `15`: Kloosterman completion coexists with
CRT tensor rank exactly three. -/
theorem finiteKloostermanCompletion_with_exact_CRT_rank_three
    (n : ZMod 15) :
    (inversePhaseSum primeResidueWeightFifteen n =
      (15 : ℂ)⁻¹ * ∑ m : ZMod 15,
        ZMod.dft primeResidueWeightFifteen m * kloostermanSum m n) ∧
      (¬ CRTTensorRankAtMostTwo primeResidueWeightFifteen) ∧
      CRTTensorRankAtMostThree primeResidueWeightFifteen :=
  ⟨primeResidueWeightFifteen_has_finiteKloostermanCompletion n,
    primeResidueWeightFifteen_rankExactlyThree⟩

/-- In particular, the existence of the finite Kloosterman completion does
not force even a two-component local CRT factorization. -/
theorem finiteKloostermanCompletion_without_two_CRT_components
    (n : ZMod 15) :
    (inversePhaseSum primeResidueWeightFifteen n =
      (15 : ℂ)⁻¹ * ∑ m : ZMod 15,
        ZMod.dft primeResidueWeightFifteen m * kloostermanSum m n) ∧
      ¬ CRTTensorRankAtMostTwo primeResidueWeightFifteen :=
  ⟨primeResidueWeightFifteen_has_finiteKloostermanCompletion n,
    primeResidueWeightFifteen_not_rankAtMostTwo⟩

end Pairfield.PrimeResidueKloostermanRankFifteen
