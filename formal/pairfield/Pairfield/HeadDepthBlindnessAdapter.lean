/-
Checked adapter for `notes/HEAD_DEPTH_BLINDNESS.md` Theorem W3.

The native cyclotomic sensor calls

  v_q (b ^ order_q(b) - 1)

the head depth.  The Fermat organ instead reads the exponent `q - 1`.
Mathlib's exact odd-prime lifting-the-exponent theorem proves that these are
the same multiplicity: the quotient `(q - 1) / order_q(b)` is prime to `q`.
-/
import Mathlib.NumberTheory.Multiplicity
import Mathlib.FieldTheory.Finite.Basic

namespace Pairfield.HeadDepthBlindnessAdapter

/-- The actual multiplicative order used by the native cyclotomic sensor. -/
def headOrder (q : ℕ) (b : ℤ) : ℕ :=
  orderOf ((b : ℤ) : ZMod q)

/-- Mathlib LTE identifies the cyclotomic head multiplicity with the
Fermat-exponent multiplicity for every odd prime and every admissible integer
base.  No arbitrary divisor exponent is introduced: `headOrder q b` is the
actual order of `b` modulo `q`. -/
theorem emultiplicity_fermatExponent_eq_head
    {q : ℕ} (hq : q.Prime) (hqodd : Odd q) {b : ℤ}
    (hb : ¬(q : ℤ) ∣ b) :
    emultiplicity (q : ℤ) (b ^ (q - 1) - 1) =
      emultiplicity (q : ℤ) (b ^ headOrder q b - 1) := by
  let _ : Fact q.Prime := ⟨hq⟩
  let z : ZMod q := b
  have hz : z ≠ 0 := by
    rw [show z = (b : ZMod q) by rfl, ZMod.intCast_zmod_eq_zero_iff_dvd]
    exact hb
  have hdvd : headOrder q b ∣ q - 1 := by
    exact ZMod.orderOf_dvd_card_sub_one hz
  obtain ⟨k, hk⟩ := hdvd
  have hdpos : 0 < headOrder q b := by
    exact orderOf_pos z
  have hkpos : 0 < k := by
    by_contra hkzero
    have : k = 0 := Nat.eq_zero_of_not_pos hkzero
    simp [this] at hk
    exact hq.ne_one hk.symm
  have hkle : k ≤ headOrder q b * k := by
    exact Nat.le_mul_of_pos_left k hdpos
  have hklt : k < q := by
    calc
      k ≤ headOrder q b * k := hkle
      _ = q - 1 := hk.symm
      _ < q := Nat.sub_lt hq.pos zero_lt_one
  have hqnk : ¬q ∣ k := by
    intro hqk
    exact (not_lt_of_ge (Nat.le_of_dvd hkpos hqk)) hklt
  have hhead : (q : ℤ) ∣ b ^ headOrder q b - 1 := by
    rw [← ZMod.intCast_zmod_eq_zero_iff_dvd]
    change (z ^ headOrder q b - 1 : ZMod q) = 0
    rw [pow_orderOf_eq_one, sub_self]
  have hbpow : ¬(q : ℤ) ∣ b ^ headOrder q b := by
    intro h
    have hqInt : Prime (q : ℤ) := by
      exact_mod_cast hq
    exact hb (hqInt.dvd_of_dvd_pow h)
  have hlte :=
    Int.emultiplicity_pow_sub_pow hq hqodd hhead hbpow k
  have hkzero : emultiplicity q k = 0 :=
    emultiplicity_eq_zero.mpr hqnk
  simpa only [← pow_mul, one_pow, hkzero, add_zero, ← hk] using hlte

/-- Every prime-power divisibility threshold of the two native readings
agrees.  This is the threshold form of Theorem W3's LTE step. -/
theorem pow_dvd_fermatExponent_iff_pow_dvd_head
    {q : ℕ} (hq : q.Prime) (hqodd : Odd q) {b : ℤ}
    (hb : ¬(q : ℤ) ∣ b) (a : ℕ) :
    (q : ℤ) ^ a ∣ b ^ (q - 1) - 1 ↔
      (q : ℤ) ^ a ∣ b ^ headOrder q b - 1 := by
  rw [pow_dvd_iff_le_emultiplicity, pow_dvd_iff_le_emultiplicity,
    emultiplicity_fermatExponent_eq_head hq hqodd hb]

/-- Depth-two control with a proper order divisor: `30` has order `3` modulo
`7`, and its head is divisible by `7²` but not `7³`. -/
theorem depth_two_control :
    headOrder 7 30 = 3 ∧
      (7 : ℤ) ^ 2 ∣ 30 ^ headOrder 7 30 - 1 ∧
      ¬(7 : ℤ) ^ 3 ∣ 30 ^ headOrder 7 30 - 1 := by
  have horder : headOrder 7 30 = 3 := by
    rw [headOrder, orderOf_eq_iff (by norm_num : 0 < 3)]
    constructor
    · decide
    · intro k hk hkpos
      interval_cases k <;> decide
  rw [horder]
  norm_num

/-- Depth-one control with the same proper order divisor: `2` also has order
`3` modulo `7`, but its head is not divisible by `7²`. -/
theorem depth_one_control :
    headOrder 7 2 = 3 ∧
      (7 : ℤ) ∣ 2 ^ headOrder 7 2 - 1 ∧
      ¬(7 : ℤ) ^ 2 ∣ 2 ^ headOrder 7 2 - 1 := by
  have horder : headOrder 7 2 = 3 := by
    rw [headOrder, orderOf_eq_iff (by norm_num : 0 < 3)]
    constructor
    · decide
    · intro k hk hkpos
      interval_cases k <;> decide
  rw [horder]
  norm_num

end Pairfield.HeadDepthBlindnessAdapter
