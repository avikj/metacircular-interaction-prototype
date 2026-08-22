/-
Copyright (c) 2026 Avik Jain and the mathematics collaboration.
Released under Apache 2.0 license.

The first fixed-charge divisor coefficient from `DIVISOR_HAHN_INCIDENCE`:
the Dirichlet convolution of the Möbius function with prime support.  The
small coefficients below are the exact finite obstruction to treating this
coefficient as multiplicative or as a logarithmic derivative of an Euler
product.
-/
import Mathlib.NumberTheory.ArithmeticFunction.Moebius
import Mathlib.Data.Finset.NatDivisors

namespace Pairfield

open scoped ArithmeticFunction.Moebius
open scoped ArithmeticFunction.zeta

/-- Prime support, with value one on primes and zero elsewhere. -/
def primeIndicator : ArithmeticFunction ℤ :=
  ⟨fun n ↦ if n.Prime then 1 else 0, if_neg Nat.not_prime_zero⟩

/-- The first fixed-charge coefficient `q₁ = μ * 1_ℙ`. -/
def primeMobiusInsertion : ArithmeticFunction ℤ :=
  ArithmeticFunction.moebius * primeIndicator

@[simp] theorem primeIndicator_apply (n : ℕ) :
    primeIndicator n = if n.Prime then 1 else 0 := rfl

@[simp] theorem primeIndicator_apply_prime {p : ℕ} (hp : p.Prime) :
    primeIndicator p = 1 := by simp [primeIndicator, hp]

@[simp] theorem primeIndicator_apply_not_prime {n : ℕ} (hn : ¬ n.Prime) :
    primeIndicator n = 0 := by simp [primeIndicator, hn]

/-- The convolution is a sum over a single marked prime divisor. -/
theorem primeMobiusInsertion_apply (n : ℕ) :
    primeMobiusInsertion n =
      ∑ d ∈ n.divisors, ArithmeticFunction.moebius (n / d) *
        (if d.Prime then 1 else 0) := by
  rw [primeMobiusInsertion, ArithmeticFunction.mul_apply]
  simpa only [primeIndicator_apply] using
    (Nat.sum_divisorsAntidiagonal'
      (fun x y ↦ ArithmeticFunction.moebius x * primeIndicator y) (n := n))

/-- Exact coefficient formula: choose the unique marked prime factor and put
Möbius weight on the complementary quotient. -/
theorem primeMobiusInsertion_apply_eq_sum_primeFactors (n : ℕ) :
    primeMobiusInsertion n =
      ∑ p ∈ n.primeFactors, ArithmeticFunction.moebius (n / p) := by
  rw [primeMobiusInsertion_apply, Nat.primeFactors_eq_to_filter_divisors_prime,
    Finset.sum_filter]
  apply Finset.sum_congr rfl
  intro d _
  by_cases hd : d.Prime <;> simp [hd]

/-- Möbius inversion: the divisor sum of `q₁` is exactly prime support. -/
theorem sum_primeMobiusInsertion_divisors (n : ℕ) :
    (∑ d ∈ n.divisors, primeMobiusInsertion d) = primeIndicator n := by
  rw [← ArithmeticFunction.coe_mul_zeta_apply]
  change (primeMobiusInsertion * (↑ArithmeticFunction.zeta :
    ArithmeticFunction ℤ)) n = primeIndicator n
  congr 1
  rw [primeMobiusInsertion]
  calc
    (ArithmeticFunction.moebius * primeIndicator) *
        (↑ArithmeticFunction.zeta : ArithmeticFunction ℤ) =
        primeIndicator * (ArithmeticFunction.moebius *
          (↑ArithmeticFunction.zeta : ArithmeticFunction ℤ)) := by
          ac_rfl
    _ = primeIndicator := by simp

@[simp] theorem primeMobiusInsertion_apply_one :
    primeMobiusInsertion 1 = 0 := by
  have h := sum_primeMobiusInsertion_divisors 1
  simpa [primeIndicator, Nat.not_prime_one] using h

@[simp] theorem primeMobiusInsertion_apply_prime {p : ℕ} (hp : p.Prime) :
    primeMobiusInsertion p = 1 := by
  have h := sum_primeMobiusInsertion_divisors p
  rw [hp.divisors] at h
  simpa [hp, hp.ne_one] using h

@[simp] theorem primeMobiusInsertion_apply_prime_sq {p : ℕ} (hp : p.Prime) :
    primeMobiusInsertion (p ^ 2) = -1 := by
  have h := sum_primeMobiusInsertion_divisors (p ^ 2)
  rw [Nat.Prime.divisors_sq hp] at h
  have hnotprime : ¬ (p ^ 2).Prime := Nat.Prime.not_prime_pow (by omega)
  have hp_sq_ne_p : p ^ 2 ≠ p := by nlinarith [hp.two_le]
  simp [hp, hp.ne_one, hnotprime, hp_sq_ne_p] at h
  linarith

@[simp] theorem primeMobiusInsertion_apply_mul_distinct_primes
    {p q : ℕ} (hp : p.Prime) (hq : q.Prime) (hpq : p ≠ q) :
    primeMobiusInsertion (p * q) = -2 := by
  have hcoprime : p.Coprime q := (Nat.coprime_primes hp hq).2 hpq
  have hdiv : (p * q).divisors = {1, p, q, p * q} := by
    rw [Nat.divisors_mul, hp.divisors, hq.divisors]
    ext n
    simp only [Finset.mem_mul, Finset.mem_insert, Finset.mem_singleton]
    aesop
  have h := sum_primeMobiusInsertion_divisors (p * q)
  rw [hdiv] at h
  have hnotprime : ¬ (p * q).Prime := Nat.not_prime_mul hp.ne_one hq.ne_one
  have hp_mul_q_ne_p : p * q ≠ p := by nlinarith [hp.two_le, hq.two_le]
  have hp_mul_q_ne_q : p * q ≠ q := by nlinarith [hp.two_le, hq.two_le]
  simp [hnotprime] at h
  have hp_notmem : p ∉ ({q, p * q} : Finset ℕ) := by
    simp [hpq, hp_mul_q_ne_p.symm]
  have hq_notmem : q ∉ ({p * q} : Finset ℕ) := by
    simp [hp_mul_q_ne_q.symm]
  rw [Finset.sum_insert hp_notmem, Finset.sum_insert hq_notmem,
    Finset.sum_singleton] at h
  simp only [primeMobiusInsertion_apply_prime hp,
    primeMobiusInsertion_apply_prime hq] at h
  linarith

/-- `q₁` is not multiplicative: its value on two coprime primes is `-2`,
not the product `1 * 1`. -/
theorem primeMobiusInsertion_not_multiplicative :
    ¬ ArithmeticFunction.IsMultiplicative primeMobiusInsertion := by
  intro h
  have hcoprime : Nat.Coprime 2 3 := (Nat.coprime_primes Nat.prime_two Nat.prime_three).2
    (by norm_num)
  have := h.map_mul_of_coprime hcoprime
  rw [primeMobiusInsertion_apply_mul_distinct_primes Nat.prime_two Nat.prime_three (by norm_num),
    primeMobiusInsertion_apply_prime Nat.prime_two,
    primeMobiusInsertion_apply_prime Nat.prime_three] at this
  norm_num at this

end Pairfield
