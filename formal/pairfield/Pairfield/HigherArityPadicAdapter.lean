/-
Checked Mathlib adapter for the load-bearing valuation step in
`notes/HIGHER_ARITY_CANCELLATION_FORMATION.md` Theorem 2.

The native family has moving proper-subset sums `p^r - k`.  Mathlib's exact
unequal-depth ultrametric equality lives over `padicValRat`; this file
transports it back to the native natural-valued interface and shows that the
note's separate valuation threshold follows from its positivity bound.
-/
import Mathlib.NumberTheory.Padics.PadicVal.Basic
import Mathlib.Tactic

namespace Pairfield.HigherArityPadicAdapter

/-- A positive natural strictly below `p^r` has `p`-adic valuation strictly
below `r`.  Thus the native hierarchy's explicit maximum-valuation threshold
is forced by its positivity bound. -/
theorem padicValNat_lt_exponent_of_pos_of_lt
    {p r k : ℕ} [Fact p.Prime] (hkpos : 0 < k) (hklt : k < p ^ r) :
    padicValNat p k < r := by
  rw [Nat.lt_iff_not_le]
  intro hle
  have hdiv : p ^ r ∣ k :=
    (padicValNat_dvd_iff_le (p := p) (n := r) hkpos.ne').mpr hle
  exact (not_lt_of_ge (Nat.le_of_dvd hkpos hdiv)) hklt

/-- Exact native moving-sum identity.  It is Mathlib's
`padicValRat.add_eq_min` applied to `p^r + (-k)`, then transported back to
natural subtraction. -/
theorem padicValNat_prime_pow_sub_of_pos_of_lt
    {p r k : ℕ} [hp : Fact p.Prime] (hkpos : 0 < k) (hklt : k < p ^ r) :
    padicValNat p (p ^ r - k) = padicValNat p k := by
  have hval : padicValNat p k < r :=
    padicValNat_lt_exponent_of_pos_of_lt hkpos hklt
  have hpq : (p : ℚ) ≠ 0 := by
    exact_mod_cast hp.out.ne_zero
  have hkq : -(k : ℚ) ≠ 0 := by
    exact neg_ne_zero.mpr (Nat.cast_ne_zero.mpr hkpos.ne')
  have hcast : ((p ^ r - k : ℕ) : ℚ) = (p : ℚ) ^ r + -(k : ℚ) := by
    rw [Nat.cast_sub hklt.le, Nat.cast_pow]
    ring
  have hsum : (p : ℚ) ^ r + -(k : ℚ) ≠ 0 := by
    rw [← hcast]
    exact_mod_cast (Nat.sub_ne_zero_of_lt hklt)
  have hvpow : padicValRat p ((p : ℚ) ^ r) = (r : ℤ) := by
    rw [padicValRat.pow, padicValRat.self hp.out.one_lt]
    simp
  have hvneg : padicValRat p (-(k : ℚ)) = (padicValNat p k : ℤ) := by
    simp
  have hvne :
      padicValRat p ((p : ℚ) ^ r) ≠ padicValRat p (-(k : ℚ)) := by
    rw [hvpow, hvneg]
    exact_mod_cast (ne_of_gt hval)
  have hrat :
      padicValRat p ((p ^ r - k : ℕ) : ℚ) =
        (padicValNat p k : ℤ) := by
    rw [hcast, padicValRat.add_eq_min hsum (pow_ne_zero r hpq) hkq hvne,
      hvpow, hvneg, min_eq_right]
    exact_mod_cast hval.le
  have hnatCast :
      (padicValNat p (p ^ r - k) : ℤ) = (padicValNat p k : ℤ) := by
    simpa only [padicValRat.of_nat] using hrat
  exact_mod_cast hnatCast

/-- Equation (9) in the native strict-arity notation.  The single bound
`n-1 < p^r` supplies the valuation inequality for every omitted-unit count
`1 ≤ k ≤ n-1`; no separate maximum over valuations is required. -/
theorem native_moving_proper_subset_sum
    {p n r k : ℕ} [Fact p.Prime]
    (hkpos : 0 < k) (hkn : k ≤ n - 1) (hbound : n - 1 < p ^ r) :
    padicValNat p (p ^ r - k) = padicValNat p k := by
  exact padicValNat_prime_pow_sub_of_pos_of_lt hkpos
    (lt_of_le_of_lt hkn hbound)

/-- The full native sum is `p^r`, whose valuation is exactly the unbounded
parameter `r`. -/
theorem native_full_sum_valuation {p r : ℕ} [Fact p.Prime] :
    padicValNat p (p ^ r) = r := by
  exact padicValNat.prime_pow r

/-- Exact positive control: `v₃(27-6)=v₃(6)=1`. -/
theorem three_pow_three_sub_six_control :
    padicValNat 3 (3 ^ 3 - 6) = padicValNat 3 6 ∧
      padicValNat 3 6 = 1 := by
  let _ : Fact (Nat.Prime 3) := ⟨by decide⟩
  constructor
  · exact padicValNat_prime_pow_sub_of_pos_of_lt (by norm_num) (by norm_num)
  · rw [show 6 = 3 * 2 by norm_num,
      padicValNat.mul (by norm_num) (by norm_num), padicValNat_self,
      padicValNat.eq_zero_of_not_dvd (by norm_num)]
    norm_num

/-- Both strict endpoints are genuinely excluded.  At `k=0` and `k=p^r`,
Mathlib's convention `padicValNat p 0 = 0` makes the proposed equality false.
-/
theorem strict_endpoint_controls :
    padicValNat 2 (2 ^ 3 - 0) ≠ padicValNat 2 0 ∧
      padicValNat 2 (2 ^ 3 - 2 ^ 3) ≠ padicValNat 2 (2 ^ 3) := by
  let _ : Fact (Nat.Prime 2) := ⟨by decide⟩
  constructor <;>
    simp only [Nat.sub_zero, Nat.sub_self, padicValNat_zero_right,
      padicValNat.prime_pow] <;>
    norm_num

end Pairfield.HigherArityPadicAdapter
