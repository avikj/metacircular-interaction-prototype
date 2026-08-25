/-

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
noncomputable def headOrder (q : ℕ) (b : ℤ) : ℕ :=
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
    change (b : ZMod q) ≠ 0
    exact fun hzero ↦ hb ((ZMod.intCast_zmod_eq_zero_iff_dvd b q).mp hzero)
  have hdvd : headOrder q b ∣ q - 1 := by
    exact ZMod.orderOf_dvd_card_sub_one hz
  have hqsubpos : 0 < q - 1 := Nat.sub_pos_of_lt hq.one_lt
  have hdpos : 0 < headOrder q b := by
    exact Nat.pos_of_dvd_of_pos hdvd hqsubpos
  obtain ⟨k, hk⟩ := hdvd
  have hkpos : 0 < k := by
    rw [hk] at hqsubpos
    exact pos_of_mul_pos_right hqsubpos (Nat.zero_le _)
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
    simp only [Int.cast_sub, Int.cast_pow, Int.cast_one]
    change z ^ orderOf z - 1 = 0
    rw [pow_orderOf_eq_one, sub_self]
  have hbpow : ¬(q : ℤ) ∣ b ^ headOrder q b := by
    intro h
    have hqInt : Prime (q : ℤ) := by
      exact Nat.prime_iff_prime_int.mp hq
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

/-!
## Continuation from the native-lineage return

The first checked bridge stops at exponent `q - 1`.  The native Fermat test on
the actual input `q ^ a` uses exponent `q ^ a - 1`.  The return correctly
rejected an unqualified W3 label until this second exponent transport was
checked.  Its quotient is the geometric sum below, congruent to `1` modulo
`q`, so the same Mathlib LTE theorem applies once more.
-/

/-- The exponent quotient `(q^a - 1) / (q - 1)`, kept division-free. -/
def exponentQuotient (q a : ℕ) : ℕ :=
  ∑ i ∈ Finset.range a, q ^ i

/-- For positive depth, the geometric exponent quotient is `1` modulo `q`.
This is the load-bearing fact that permits the second LTE application. -/
theorem not_dvd_exponentQuotient
    {q a : ℕ} (hq : q.Prime) (ha : 0 < a) :
    ¬q ∣ exponentQuotient q a := by
  let _ : Fact q.Prime := ⟨hq⟩
  intro hdiv
  have hzero : ((exponentQuotient q a : ℕ) : ZMod q) = 0 :=
    (ZMod.natCast_eq_zero_iff _ _).mpr hdiv
  obtain ⟨a, rfl⟩ := Nat.exists_eq_succ_of_ne_zero ha.ne'
  simp [exponentQuotient] at hzero

/-- The geometric quotient gives the exact exponent factorization used by the
native Fermat test. -/
theorem primePower_sub_one_eq_mul_exponentQuotient
    {q a : ℕ} (hq : q.Prime) :
    q ^ a - 1 = (q - 1) * exponentQuotient q a := by
  have hgeom := _root_.geom_sum_mul_of_one_le hq.one_le a
  calc
    q ^ a - 1 = exponentQuotient q a * (q - 1) := by
      simpa [exponentQuotient] using hgeom.symm
    _ = (q - 1) * exponentQuotient q a := Nat.mul_comm _ _

/-- The actual prime-power Fermat exponent `q^a - 1` has the same
`q`-multiplicity as the usual Fermat exponent `q - 1`. -/
theorem emultiplicity_primePowerExponent_eq_fermatExponent
    {q a : ℕ} (hq : q.Prime) (hqodd : Odd q) (ha : 0 < a) {b : ℤ}
    (hb : ¬(q : ℤ) ∣ b) :
    emultiplicity (q : ℤ) (b ^ (q ^ a - 1) - 1) =
      emultiplicity (q : ℤ) (b ^ (q - 1) - 1) := by
  let _ : Fact q.Prime := ⟨hq⟩
  let z : ZMod q := b
  have hz : z ≠ 0 := by
    change (b : ZMod q) ≠ 0
    exact fun hzero ↦ hb ((ZMod.intCast_zmod_eq_zero_iff_dvd b q).mp hzero)
  have hfermat : (q : ℤ) ∣ b ^ (q - 1) - 1 := by
    rw [← ZMod.intCast_zmod_eq_zero_iff_dvd]
    simp only [Int.cast_sub, Int.cast_pow, Int.cast_one]
    change z ^ (q - 1) - 1 = 0
    rw [ZMod.pow_card_sub_one_eq_one hz, sub_self]
  have hbpow : ¬(q : ℤ) ∣ b ^ (q - 1) := by
    intro h
    exact hb ((Nat.prime_iff_prime_int.mp hq).dvd_of_dvd_pow h)
  have hlte := Int.emultiplicity_pow_sub_pow hq hqodd hfermat hbpow
    (exponentQuotient q a)
  have hquotientZero : emultiplicity q (exponentQuotient q a) = 0 :=
    emultiplicity_eq_zero.mpr (not_dvd_exponentQuotient hq ha)
  have hexponent := primePower_sub_one_eq_mul_exponentQuotient (a := a) hq
  simpa only [← pow_mul, one_pow, hquotientZero, add_zero, ← hexponent] using hlte

/-- Full native W3 multiplicity statement: Fermat blindness on the actual
input `q^a` and the cyclotomic head are two readings of one value. -/
theorem emultiplicity_primePowerFermat_eq_head
    {q a : ℕ} (hq : q.Prime) (hqodd : Odd q) (ha : 0 < a) {b : ℤ}
    (hb : ¬(q : ℤ) ∣ b) :
    emultiplicity (q : ℤ) (b ^ (q ^ a - 1) - 1) =
      emultiplicity (q : ℤ) (b ^ headOrder q b - 1) := by
  calc
    emultiplicity (q : ℤ) (b ^ (q ^ a - 1) - 1) =
        emultiplicity (q : ℤ) (b ^ (q - 1) - 1) :=
      emultiplicity_primePowerExponent_eq_fermatExponent hq hqodd ha hb
    _ = emultiplicity (q : ℤ) (b ^ headOrder q b - 1) :=
      emultiplicity_fermatExponent_eq_head hq hqodd hb

/-- Full native W3 threshold statement.  The left side is exactly the Fermat
test on `n = q^a`; the right side is exactly the cyclotomic head threshold. -/
theorem primePower_fermatBlind_iff_headThreshold
    {q a : ℕ} (hq : q.Prime) (hqodd : Odd q) (ha : 0 < a) {b : ℤ}
    (hb : ¬(q : ℤ) ∣ b) :
    (q : ℤ) ^ a ∣ b ^ (q ^ a - 1) - 1 ↔
      (q : ℤ) ^ a ∣ b ^ headOrder q b - 1 := by
  rw [pow_dvd_iff_le_emultiplicity, pow_dvd_iff_le_emultiplicity,
    emultiplicity_primePowerFermat_eq_head hq hqodd ha hb]

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
