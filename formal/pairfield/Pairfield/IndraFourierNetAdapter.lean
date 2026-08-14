import Mathlib.NumberTheory.DirichletCharacter.Orthogonality
import Mathlib.Analysis.Complex.Polynomial.Basic
import Mathlib.RingTheory.RootsOfUnity.AlgebraicallyClosed

/-!
# Exact finite Fourier reconstruction for the Indra residue-pair net

`notes/INDRA_CROSS.md` Proposition N changes coordinates between a function on
two reduced residue classes and its complete grid of Dirichlet-character
components.  Mathlib already provides the one-leg delta kernel
`DirichletCharacter.sum_char_inv_mul_char_eq`.  This adapter applies that
kernel on both legs and checks the exact inverse transform.

The statement is deliberately independent of primes, zeros of `L`-functions,
and analytic estimates: the input is an arbitrary complex-valued function on
`((ZMod n)ˣ)²`.
-/

namespace Pairfield.IndraFourierNetAdapter

open scoped BigOperators

noncomputable section

/-- The reduced residue classes used by one leg of the finite net. -/
abbrev UnitResidue (n : ℕ) := (ZMod n)ˣ

/-- An arbitrary complex signal on ordered pairs of reduced residue classes. -/
abbrev CellGrid (n : ℕ) := UnitResidue n × UnitResidue n → ℂ

/-- One-leg unnormalised Dirichlet-character transform. -/
def fourierForward (n : ℕ) [NeZero n] (f : UnitResidue n → ℂ)
    (χ : DirichletCharacter ℂ n) : ℂ :=
  ∑ a : UnitResidue n, χ (a : ZMod n) * f a

/-- One-leg inverse transform, normalized by `φ(n)`. -/
def fourierInverse (n : ℕ) [NeZero n]
    (H : DirichletCharacter ℂ n → ℂ) (a : UnitResidue n) : ℂ :=
  (n.totient : ℂ)⁻¹ *
    ∑ χ : DirichletCharacter ℂ n, χ ((a : ZMod n)⁻¹) * H χ

/-- The unnormalised `(χ₁, χ₂)` component of a residue-pair signal. -/
def characterComponent (n : ℕ) [NeZero n] (F : CellGrid n)
    (χ₁ χ₂ : DirichletCharacter ℂ n) : ℂ :=
  fourierForward n (fun b ↦ fourierForward n (fun a ↦ F (a, b)) χ₁) χ₂

/-- Reconstruction from the complete character grid, using inverse
evaluations rather than writing complex conjugates. -/
def reconstruct (n : ℕ) [NeZero n]
    (H : DirichletCharacter ℂ n → DirichletCharacter ℂ n → ℂ) : CellGrid n :=
  fun pair ↦ fourierInverse n (fun χ₁ ↦ fourierInverse n (H χ₁) pair.2) pair.1

/-- Mathlib's character orthogonality theorem, stated directly on unit
representatives. -/
theorem character_delta (n : ℕ) [NeZero n] (a b : UnitResidue n) :
    (∑ χ : DirichletCharacter ℂ n,
      χ ((a : ZMod n)⁻¹) * χ (b : ZMod n)) =
        if a = b then (n.totient : ℂ) else 0 := by
  simpa only [Units.val_inj] using
    (DirichletCharacter.sum_char_inv_mul_char_eq ℂ a.isUnit (b : ZMod n))

/-- The one-leg transform is inverted exactly. -/
theorem fourierInverse_fourierForward (n : ℕ) [NeZero n]
    (f : UnitResidue n → ℂ) (a : UnitResidue n) :
    fourierInverse n (fourierForward n f) a = f a := by
  classical
  have hφ : (n.totient : ℂ) ≠ 0 := by
    exact_mod_cast (Nat.totient_pos.mpr (NeZero.pos n)).ne'
  simp only [fourierInverse, fourierForward]
  calc
    (n.totient : ℂ)⁻¹ *
        ∑ χ : DirichletCharacter ℂ n,
          χ ((a : ZMod n)⁻¹) *
            ∑ b : UnitResidue n, χ (b : ZMod n) * f b =
        (n.totient : ℂ)⁻¹ *
          ∑ b : UnitResidue n,
            (∑ χ : DirichletCharacter ℂ n,
              χ ((a : ZMod n)⁻¹) * χ (b : ZMod n)) * f b := by
          congr 1
          simp_rw [Finset.mul_sum]
          rw [Finset.sum_comm]
          apply Finset.sum_congr rfl
          intro b _
          rw [Finset.sum_mul]
          apply Finset.sum_congr rfl
          intro χ _
          ring
    _ = (n.totient : ℂ)⁻¹ * ((n.totient : ℂ) * f a) := by
      simp_rw [character_delta]
      simp
    _ = f a := by field_simp

/-- Proposition N's inverse finite Fourier square, for an arbitrary signal on
the two reduced-residue coordinates. -/
theorem reconstruct_characterComponent (n : ℕ) [NeZero n] (F : CellGrid n) :
    reconstruct n (characterComponent n F) = F := by
  funext pair
  simp only [reconstruct, characterComponent]
  rw [fourierInverse_fourierForward, fourierInverse_fourierForward]

end

end Pairfield.IndraFourierNetAdapter
