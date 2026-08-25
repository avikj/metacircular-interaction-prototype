/-
Copyright (c) 2026 Avik Jain and the mathematics collaboration.
Released under Apache 2.0 license.

The exact finite bridge from one gcd-reduced divisor/CRT stratum to additive
Fourier completion.  No automorphic realization is asserted here.
-/
import Pairfield.FiniteKloostermanCompletion

namespace Pairfield

open scoped ZMod

noncomputable section

namespace DivisorBoundaryKloostermanBridge

open FiniteKloostermanCompletion

variable {c : ℕ} [NeZero c]

/-- Push an arbitrary finite family of weights forward along its unit residue
modulo `c`, extending the resulting function by zero on nonunit residues. -/
def unitResidueAggregate {ι : Type*} [Fintype ι]
    (u : ι → (ZMod c)ˣ) (w : ι → ℂ) (x : ZMod c) : ℂ :=
  ∑ i : ι, if (u i : ZMod c) = x then w i else 0

/-- Grouping a finite incomplete inverse-phase sum by its unit residue gives
the generic `inversePhaseSum` exactly, including repeated residues. -/
theorem sum_weight_inverse_eq_inversePhaseSum
    {ι : Type*} [Fintype ι] (u : ι → (ZMod c)ˣ) (w : ι → ℂ)
    (n : ZMod c) :
    (∑ i : ι, w i *
      ZMod.stdAddChar (n * (((u i)⁻¹ : (ZMod c)ˣ) : ZMod c))) =
      inversePhaseSum (unitResidueAggregate u w) n := by
  unfold inversePhaseSum unitResidueAggregate
  simp_rw [Finset.sum_mul]
  rw [Finset.sum_comm]
  apply Finset.sum_congr rfl
  intro i _
  simp only [ite_mul, zero_mul]
  simp only [Units.val_inj]
  simp only [eq_comm]
  rw [Finset.sum_ite_eq']
  simp

/-- The exact finite completion for a weighted family of unit residues. -/
theorem sum_weight_inverse_eq_dft_kloosterman
    {ι : Type*} [Fintype ι] (u : ι → (ZMod c)ˣ) (w : ι → ℂ)
    (n : ZMod c) :
    (∑ i : ι, w i *
      ZMod.stdAddChar (n * (((u i)⁻¹ : (ZMod c)ˣ) : ZMod c))) =
      (c : ℂ)⁻¹ * ∑ m : ZMod c,
        ZMod.dft (unitResidueAggregate u w) m * kloostermanSum m n := by
  rw [sum_weight_inverse_eq_inversePhaseSum]
  exact inversePhaseSum_eq_dft_kloosterman _ _

/-- The reduced `d₀` indices present in one gcd stratum of (5.4).

Here `B` is the original divisor cutoff, `g` is the gcd, `b=e₀` is
the reduced modulus, and `k` is the chosen integer representative of the
nonzero Fourier class modulo `g * d₀ * b`.  The condition `g*b ≤ B`
retains the original cutoff on `e=g*b`. -/
def reducedIndices (B g b k : ℕ) : Finset ℕ :=
  (Finset.Icc 1 B).filter fun a ↦
    0 < g ∧ g * b ≤ B ∧ g * a ≤ B ∧ Nat.Coprime a b ∧
      0 < k ∧ k < g * a * b

/-- A reduced divisor index, carrying all finite-range conditions. -/
abbrev ReducedIndex (B g b k : ℕ) :=
  {a : ℕ // a ∈ reducedIndices B g b k}

theorem reducedIndex_coprime {B g b k : ℕ}
    (a : ReducedIndex B g b k) : Nat.Coprime a.1 b := by
  exact (Finset.mem_filter.mp a.2).2.2.2.2.1

/-- The unit residue of the reduced divisor `d₀` modulo `e₀`. -/
def reducedUnit {B g b k : ℕ} (a : ReducedIndex B g b k) : (ZMod b)ˣ :=
  ZMod.unitOfCoprime a.1 (reducedIndex_coprime a)

/-- The inner weight left after pulling `c_w(g*b)/(g*b)` outside a gcd
stratum.  `endpoint a` is exactly the sharp factor
`D_I(k / (g*a*b))` (or its supplied smoothed replacement). -/
def reducedWeight (cz : ℕ → ℂ) (endpoint : ℕ → ℂ)
    {B g b k : ℕ} (a : ReducedIndex B g b k) : ℂ :=
  cz (g * a.1) / (a.1 : ℂ) * endpoint a.1

/-- The actual residue-class weight `A_{g,b,k}(x)` for one gcd-reduced
stratum of (5.4), with the right-hand charge and `1/(g*b)` held outside. -/
def gcdStratumWeight (B g b k : ℕ) [NeZero b] (cz : ℕ → ℂ)
    (endpoint : ℕ → ℂ) (x : ZMod b) : ℂ :=
  unitResidueAggregate
    (fun a : ReducedIndex B g b k ↦ reducedUnit a)
    (fun a ↦ reducedWeight cz endpoint a) x

/-- The post-CRT inverse-phase part of a single gcd stratum.  If the original
centre is `g*N₀`, its second Kloosterman index is `-k*N₀ (mod b)`. -/
def gcdStratumInversePhase (B g b k N₀ : ℕ) [NeZero b]
    (cz : ℕ → ℂ)
    (endpoint : ℕ → ℂ) : ℂ :=
  ∑ a : ReducedIndex B g b k,
    reducedWeight cz endpoint a *
      ZMod.stdAddChar
        ((-((k * N₀ : ℕ) : ZMod b)) *
          (((reducedUnit a)⁻¹ : (ZMod b)ˣ) : ZMod b))

/-- One exact gcd stratum completes to classical Kloosterman sums.  This is
the strongest finite statement: realizing the DFT coefficient as a GL₂
big-cell orbital/Bessel transform is a separate input, not a consequence. -/
theorem gcdStratumInversePhase_eq_dft_kloosterman
    (B g b k N₀ : ℕ) [NeZero b] (cz : ℕ → ℂ)
    (endpoint : ℕ → ℂ) :
    gcdStratumInversePhase B g b k N₀ cz endpoint =
      (b : ℂ)⁻¹ * ∑ m : ZMod b,
        ZMod.dft (gcdStratumWeight B g b k cz endpoint) m *
          kloostermanSum m (-((k * N₀ : ℕ) : ZMod b)) := by
  unfold gcdStratumInversePhase gcdStratumWeight
  exact sum_weight_inverse_eq_dft_kloosterman
    (fun a : ReducedIndex B g b k ↦ reducedUnit a)
    (fun a ↦ reducedWeight cz endpoint a)
    (-((k * N₀ : ℕ) : ZMod b))

end DivisorBoundaryKloostermanBridge

end

end Pairfield
