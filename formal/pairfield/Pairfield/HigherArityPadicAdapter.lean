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

/-- The native hierarchy tuple, reindexed as `Fin (n+1)`: `n` unit
coordinates followed by the moving coordinate `p^r-n`. -/
def nativeTuple (p r n : ℕ) : Fin (n + 1) → ℕ := fun i ↦
  if i = Fin.last n then p ^ r - n else 1

/-- A labeled subset omitting the moving coordinate sums to its cardinality. -/
theorem nativeTuple_sum_without_last
    {p r n : ℕ} {S : Finset (Fin (n + 1))}
    (hlast : Fin.last n ∉ S) :
    (∑ i ∈ S, nativeTuple p r n i) = S.card := by
  rw [Finset.card_eq_sum_ones]
  apply Finset.sum_congr rfl
  intro i hi
  simp only [nativeTuple, if_neg (ne_of_mem_of_not_mem hi hlast)]

/-- A labeled subset containing the moving coordinate has the native normal
form `p^r-k`, where `k` is the number of omitted unit coordinates. -/
theorem nativeTuple_sum_with_last
    {p r n : ℕ} {S : Finset (Fin (n + 1))}
    (hlast : Fin.last n ∈ S) (hbound : n < p ^ r) :
    (∑ i ∈ S, nativeTuple p r n i) = p ^ r - (n + 1 - S.card) := by
  calc
    (∑ i ∈ S, nativeTuple p r n i) =
        (∑ i ∈ S.erase (Fin.last n), nativeTuple p r n i) +
          nativeTuple p r n (Fin.last n) := by
      exact (Finset.sum_erase_add S (nativeTuple p r n) hlast).symm
    _ = (S.erase (Fin.last n)).card + (p ^ r - n) := by
      rw [nativeTuple_sum_without_last (S := S.erase (Fin.last n)) (by simp)]
      simp [nativeTuple]
    _ = p ^ r - (n + 1 - S.card) := by
      have hcard : S.card ≤ n + 1 := by
        simpa using Finset.card_le_card (Finset.subset_univ S)
      have hcardpos : 0 < S.card := Finset.card_pos.mpr ⟨Fin.last n, hlast⟩
      rw [Finset.card_erase_of_mem hlast]
      omega

/-- A positive natural strictly below `p^r` has `p`-adic valuation strictly
below `r`.  Thus the native hierarchy's explicit maximum-valuation threshold
is forced by its positivity bound. -/
theorem padicValNat_lt_exponent_of_pos_of_lt
    {p r k : ℕ} [Fact p.Prime] (hkpos : 0 < k) (hklt : k < p ^ r) :
    padicValNat p k < r := by
  by_contra hnot
  have hle : r ≤ padicValNat p k := Nat.le_of_not_gt hnot
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

/-- Every nonempty proper labeled subset has the native valuation normal
form.  The branch records whether the subset contains the moving coordinate;
it does not quotient away the subset label. -/
theorem nativeTuple_properSubset_valuation
    {p r n : ℕ} [Fact p.Prime] {S : Finset (Fin (n + 1))}
    (_hne : S.Nonempty) (hproper : S ≠ Finset.univ) (hbound : n < p ^ r) :
    padicValNat p (∑ i ∈ S, nativeTuple p r n i) =
      if Fin.last n ∈ S then
        padicValNat p (n + 1 - S.card)
      else
        padicValNat p S.card := by
  by_cases hlast : Fin.last n ∈ S
  · rw [if_pos hlast, nativeTuple_sum_with_last hlast hbound]
    have hcardlt : S.card < n + 1 := by
      simpa using
        Finset.card_lt_card (Finset.ssubset_univ_iff.mpr hproper)
    have hkpos : 0 < n + 1 - S.card := Nat.sub_pos_of_lt hcardlt
    have hcardpos : 0 < S.card := Finset.card_pos.mpr ⟨Fin.last n, hlast⟩
    apply padicValNat_prime_pow_sub_of_pos_of_lt hkpos
    omega
  · rw [if_neg hlast, nativeTuple_sum_without_last hlast]

/-- Proper-subset valuation profiles of two sufficiently positive native
tuples coincide label by label. -/
theorem nativeTuple_properSubset_profile_eq
    {p r s n : ℕ} [Fact p.Prime]
    (hrbound : n < p ^ r) (hsbound : n < p ^ s)
    {S : Finset (Fin (n + 1))} (hne : S.Nonempty)
    (hproper : S ≠ Finset.univ) :
    padicValNat p (∑ i ∈ S, nativeTuple p r n i) =
      padicValNat p (∑ i ∈ S, nativeTuple p s n i) := by
  rw [nativeTuple_properSubset_valuation hne hproper hrbound,
    nativeTuple_properSubset_valuation hne hproper hsbound]

/-- The full labeled tuple sums to `p^r`. -/
theorem nativeTuple_full_sum {p r n : ℕ} (hbound : n < p ^ r) :
    (∑ i, nativeTuple p r n i) = p ^ r := by
  simpa using nativeTuple_sum_with_last
    (p := p) (r := r) (n := n) (S := Finset.univ) (by simp) hbound

/-- Exact checked collision at the corrected scope: two native tuples agree
on every nonempty proper labeled-subset valuation and disagree on the full
sum.  This is not a claim about the addition-closed language, where prefix
sums provide a binary flag decomposition. -/
theorem nativeTuple_labeled_profile_collision
    {p r s n : ℕ} [Fact p.Prime]
    (hrbound : n < p ^ r) (hsbound : n < p ^ s) (hrs : r ≠ s) :
    (∀ S : Finset (Fin (n + 1)), S.Nonempty → S ≠ Finset.univ →
      padicValNat p (∑ i ∈ S, nativeTuple p r n i) =
        padicValNat p (∑ i ∈ S, nativeTuple p s n i)) ∧
      padicValNat p (∑ i, nativeTuple p r n i) ≠
        padicValNat p (∑ i, nativeTuple p s n i) := by
  constructor
  · intro S hne hproper
    exact nativeTuple_properSubset_profile_eq hrbound hsbound hne hproper
  · rw [nativeTuple_full_sum hrbound, nativeTuple_full_sum hsbound,
      padicValNat.prime_pow, padicValNat.prime_pow]
    exact hrs

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
