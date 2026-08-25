/-
Copyright (c) 2026 Avik Jain and the mathematics collaboration.
Released under Apache 2.0 license.

Finite additive Fourier completion of an inverse-residue phase.  This is an
exact identity on `ZMod N`; it does not assert that the resulting coefficients
are orbital integrals of an automorphic test function.
-/
import Mathlib.Analysis.Fourier.ZMod

namespace Pairfield

open scoped ZMod

noncomputable section

namespace FiniteKloostermanCompletion

variable {N : ℕ} [NeZero N]

/-- The classical two-phase Kloosterman sum over the units of `ZMod N`. -/
def kloostermanSum (m n : ZMod N) : ℂ :=
  ∑ x : (ZMod N)ˣ,
    ZMod.stdAddChar
      (m * (x : ZMod N) + n * ((x⁻¹ : (ZMod N)ˣ) : ZMod N))

/-- The Ramanujan sum in the same additive-character normalization. -/
def ramanujanSum (n : ZMod N) : ℂ :=
  ∑ x : (ZMod N)ˣ, ZMod.stdAddChar (n * (x : ZMod N))

/-- The zero-direct-frequency Kloosterman sum is exactly the Ramanujan sum;
inversion merely permutes the units. -/
theorem kloostermanSum_zero_left (n : ZMod N) :
    kloostermanSum 0 n = ramanujanSum n := by
  simp only [kloostermanSum, ramanujanSum, zero_mul, zero_add]
  exact Fintype.sum_equiv (Equiv.inv _) _ _ (fun _ ↦ rfl)

/-- A weighted incomplete inverse phase.  The weight is allowed on every
residue; only its values on units occur on this side of the identity. -/
def inversePhaseSum (A : ZMod N → ℂ) (n : ZMod N) : ℂ :=
  ∑ x : (ZMod N)ˣ,
    A (x : ZMod N) *
      ZMod.stdAddChar (n * ((x⁻¹ : (ZMod N)ˣ) : ZMod N))

/-- Exact finite Fourier completion: expanding the arbitrary residue weight
supplies the direct phase, and pairs its Fourier coefficient with a genuine
two-phase Kloosterman sum. -/
theorem inversePhaseSum_eq_dft_kloosterman
    (A : ZMod N → ℂ) (n : ZMod N) :
    inversePhaseSum A n =
      (N : ℂ)⁻¹ * ∑ m : ZMod N, ZMod.dft A m * kloostermanSum m n := by
  have hFourier (x : ZMod N) :
      A x = (N : ℂ)⁻¹ *
        ∑ m : ZMod N, ZMod.stdAddChar (m * x) * ZMod.dft A m := by
    have h := congrFun (ZMod.dft.symm_apply_apply A) x
    rw [ZMod.invDFT_apply] at h
    simpa only [smul_eq_mul] using h.symm
  unfold inversePhaseSum kloostermanSum
  calc
    (∑ x : (ZMod N)ˣ,
        A (x : ZMod N) *
          ZMod.stdAddChar (n * ((x⁻¹ : (ZMod N)ˣ) : ZMod N))) =
        (N : ℂ)⁻¹ *
          ∑ x : (ZMod N)ˣ, ∑ m : ZMod N,
            ZMod.dft A m *
              (ZMod.stdAddChar (m * (x : ZMod N)) *
                ZMod.stdAddChar
                  (n * ((x⁻¹ : (ZMod N)ˣ) : ZMod N))) := by
      rw [Finset.mul_sum]
      apply Finset.sum_congr rfl
      intro x _
      rw [hFourier, mul_assoc, Finset.sum_mul]
      apply congrArg ((N : ℂ)⁻¹ * ·)
      apply Finset.sum_congr rfl
      intro m _
      ring
    _ = (N : ℂ)⁻¹ *
          ∑ m : ZMod N, ∑ x : (ZMod N)ˣ,
            ZMod.dft A m *
              (ZMod.stdAddChar (m * (x : ZMod N)) *
                ZMod.stdAddChar
                  (n * ((x⁻¹ : (ZMod N)ˣ) : ZMod N))) := by
      rw [Finset.sum_comm]
    _ = (N : ℂ)⁻¹ *
          ∑ m : ZMod N, ZMod.dft A m *
            ∑ x : (ZMod N)ˣ,
              ZMod.stdAddChar
                (m * (x : ZMod N) +
                  n * ((x⁻¹ : (ZMod N)ˣ) : ZMod N)) := by
      apply congrArg ((N : ℂ)⁻¹ * ·)
      apply Finset.sum_congr rfl
      intro m _
      rw [Finset.mul_sum]
      apply Finset.sum_congr rfl
      intro x _
      rw [ZMod.stdAddChar.map_add_eq_mul]

/-- A weight constant on all residue classes has a degenerate completion:
the raw unit sum is the `m = 0` Kloosterman sum, i.e. a Ramanujan-type sum. -/
theorem constantWeight_inversePhaseSum
    (a : ℂ) (n : ZMod N) :
    inversePhaseSum (fun _ ↦ a) n = a * kloostermanSum 0 n := by
  simp only [inversePhaseSum, kloostermanSum, zero_mul, zero_add]
  exact (Finset.mul_sum _ _ _).symm

/-- Constant weight therefore leaves only the degenerate Ramanujan sum. -/
theorem constantWeight_inversePhaseSum_eq_ramanujan
    (a : ℂ) (n : ZMod N) :
    inversePhaseSum (fun _ ↦ a) n = a * ramanujanSum n := by
  rw [constantWeight_inversePhaseSum, kloostermanSum_zero_left]

end FiniteKloostermanCompletion

end

end Pairfield
