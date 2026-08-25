/-
Theorem A(i) — Sum-marginal rigidity (V3 target 1).

sequences, the additive (sum) convolution square determines the sequence:
a ∗ a = b ∗ b ⟹ a = b.

Three formalizations, all machine-checked:

* `convSq_inj_nat`      — ℕ-coefficient polynomials (= finitely supported
                          ℕ → ℕ with convolution product): a² = b² ⟹ a = b.
* `sumMarginal_inj`     — the literal Goldbach-marginal statement for
                          finitely supported a b : ℕ →₀ ℕ:
                          (∀ N, ∑_{m+n=N} a m · a n = ∑_{m+n=N} b m · b n) ⟹ a = b.
* `convSq_inj_nonneg_ordered` — polynomials over any strictly ordered
                                 commutative ring, with nonnegative coefficients.
* `convSq_inj_nonneg`   — the real specialization.

Proof idea (as in REPORT): embed into the integral domain ℤ[X] (resp. work in
ℝ[X]); A² = B² forces A = B or A = −B, and nonnegativity of the coefficients
kills the second branch (both sides must then vanish identically).
-/
import Mathlib

namespace Pairfield

open Polynomial

/-- **Theorem A(i), ℕ-polynomial form.** A polynomial with natural-number
coefficients — equivalently a finitely supported sequence `ℕ → ℕ` under
additive convolution — is determined by its convolution square. -/
theorem convSq_inj_nat (a b : Polynomial ℕ) (h : a * a = b * b) : a = b := by
  -- push into ℤ[X], an integral domain
  have h2 : a.map (Nat.castRingHom ℤ) * a.map (Nat.castRingHom ℤ)
      = b.map (Nat.castRingHom ℤ) * b.map (Nat.castRingHom ℤ) := by
    rw [← Polynomial.map_mul, ← Polynomial.map_mul, h]
  rcases mul_self_eq_mul_self_iff.mp h2 with h3 | h3
  · exact Polynomial.map_injective _ Nat.cast_injective h3
  · -- A = −B: nonnegative coefficients force everything to vanish
    ext n
    have hc := congrArg (fun p => Polynomial.coeff p n) h3
    simp only [Polynomial.coeff_map, Polynomial.coeff_neg, Nat.coe_castRingHom] at hc
    omega

/-- The Goldbach sum marginal `r_a(N) = ∑_{m+n=N} a m · a n` of a finitely
supported sequence. -/
def sumMarginal (a : ℕ →₀ ℕ) (N : ℕ) : ℕ :=
  ∑ p ∈ Finset.HasAntidiagonal.antidiagonal N, a p.1 * a p.2

/-- **Theorem A(i), marginal form.** A finitely supported sequence `ℕ →₀ ℕ`
is determined by its sum marginal: if `∑_{m+n=N} a m · a n = ∑_{m+n=N} b m · b n`
for every `N`, then `a = b`. -/
theorem sumMarginal_inj (a b : ℕ →₀ ℕ) (h : ∀ N, sumMarginal a N = sumMarginal b N) :
    a = b := by
  have hpoly : (⟨⟨a⟩⟩ : Polynomial ℕ) * ⟨⟨a⟩⟩ = (⟨⟨b⟩⟩ : Polynomial ℕ) * ⟨⟨b⟩⟩ := by
    ext N
    have hN := h N
    simpa [sumMarginal, Polynomial.coeff_mul, Polynomial.coeff_ofFinsupp,
      AddMonoidAlgebra.coeff_ofCoeff] using hN
  have h2 := convSq_inj_nat ⟨⟨a⟩⟩ ⟨⟨b⟩⟩ hpoly
  exact congrArg (fun p : Polynomial ℕ => p.toFinsupp.coeff) h2

/-- **Theorem A(i), ordered-ring form.** Over any linear ordered ring, the
nonnegative-coefficient cone of the polynomial ring has injective squaring. -/
theorem convSq_inj_nonneg_ordered {R : Type*}
    [CommRing R] [LinearOrder R] [IsStrictOrderedRing R]
    (a b : Polynomial R)
    (ha : ∀ n, 0 ≤ a.coeff n) (hb : ∀ n, 0 ≤ b.coeff n)
    (h : a * a = b * b) : a = b := by
  rcases mul_self_eq_mul_self_iff.mp h with h3 | h3
  · exact h3
  · ext n
    have hc : a.coeff n = -(b.coeff n) := by rw [h3, Polynomial.coeff_neg]
    have h1 := ha n
    have h2 := hb n
    linarith

/-- **Theorem A(i), nonnegative-real form.** A real polynomial with nonnegative
coefficients is determined by its square. -/
theorem convSq_inj_nonneg (a b : Polynomial ℝ)
    (ha : ∀ n, 0 ≤ a.coeff n) (hb : ∀ n, 0 ≤ b.coeff n)
    (h : a * a = b * b) : a = b :=
  convSq_inj_nonneg_ordered a b ha hb h

end Pairfield
