import Mathlib.NumberTheory.DirichletCharacter.Orthogonality

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

/-- The unnormalised `(χ₁, χ₂)` component of a residue-pair signal. -/
def characterComponent (n : ℕ) [NeZero n] (F : CellGrid n)
    (χ₁ χ₂ : DirichletCharacter ℂ n) : ℂ :=
  ∑ a : UnitResidue n, ∑ b : UnitResidue n,
    χ₁ (a : ZMod n) * χ₂ (b : ZMod n) * F (a, b)

/-- Reconstruction from the complete character grid, using inverse
evaluations rather than writing complex conjugates. -/
def reconstruct (n : ℕ) [NeZero n]
    (H : DirichletCharacter ℂ n → DirichletCharacter ℂ n → ℂ) : CellGrid n :=
  fun pair ↦
    ((n.totient : ℂ) ^ 2)⁻¹ *
      ∑ χ₁ : DirichletCharacter ℂ n, ∑ χ₂ : DirichletCharacter ℂ n,
        χ₁ ((pair.1⁻¹ : UnitResidue n) : ZMod n) *
          χ₂ ((pair.2⁻¹ : UnitResidue n) : ZMod n) * H χ₁ χ₂

/-- Mathlib's character orthogonality theorem, stated directly on unit
representatives. -/
theorem character_delta (n : ℕ) [NeZero n] (a b : UnitResidue n) :
    (∑ χ : DirichletCharacter ℂ n,
      χ ((a⁻¹ : UnitResidue n) : ZMod n) * χ (b : ZMod n)) =
        if a = b then (n.totient : ℂ) else 0 := by
  simpa using
    (DirichletCharacter.sum_char_inv_mul_char_eq ℂ a.isUnit (b : ZMod n))

end

end Pairfield.IndraFourierNetAdapter
