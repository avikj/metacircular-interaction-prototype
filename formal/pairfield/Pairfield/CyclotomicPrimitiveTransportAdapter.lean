/-
Checked adapter for the held-prime transport operation in
`notes/CYCLOTOMIC_SENSOR.md` Theorem 11.

The native organ re-expresses an already held prime in the exponent
coordinates of a new base.  In the branch where the prime characteristic does
not divide the index, Mathlib's root/primitive-root equivalence proves that the
prime reappears in exactly the cyclotomic piece indexed by the base's
multiplicative order.
-/
import Pairfield.CyclotomicRoutingAdapter

namespace Pairfield.CyclotomicPrimitiveTransportAdapter

open Polynomial
open CyclotomicRoutingAdapter

/-- In the coprime-characteristic branch, divisibility of an evaluated
cyclotomic piece is equivalent to exact multiplicative order modulo the prime.
This is the checked extensional core of held-prime re-delivery. -/
theorem prime_dvd_piece_iff_orderOf_eq_index
    {m p : ℕ} [Fact p.Prime] {a : ℤ} (hpm : ¬p ∣ m) :
    (p : ℤ) ∣ piece a m ↔
      orderOf ((Int.castRingHom (ZMod p)) a) = m := by
  constructor
  · exact orderOf_mod_prime_eq_index_of_dvd_piece_of_not_dvd_index hpm
  · intro horder
    have hmcast : (m : ZMod p) ≠ 0 := by
      intro hmzero
      exact hpm ((ZMod.natCast_eq_zero_iff m p).mp hmzero)
    let _ : NeZero (m : ZMod p) := ⟨hmcast⟩
    have hprimitive :
        IsPrimitiveRoot ((Int.castRingHom (ZMod p)) a) m :=
      IsPrimitiveRoot.iff_orderOf.mpr horder
    have hroot :
        IsRoot (cyclotomic m (ZMod p))
          ((Int.castRingHom (ZMod p)) a) :=
      Polynomial.isRoot_cyclotomic_iff.mpr hprimitive
    rw [Polynomial.IsRoot.def] at hroot
    have heval :
        eval ((Int.castRingHom (ZMod p)) a) (cyclotomic m (ZMod p)) =
          ((piece a m : ℤ) : ZMod p) := by
      simpa only [piece, Int.coe_castRingHom] using
        (Polynomial.cyclotomic.eval_apply a m (Int.castRingHom (ZMod p)))
    exact (ZMod.intCast_zmod_eq_zero_iff_dvd _ _).mp
      (heval.symm.trans hroot)

/-- A held prime can be re-delivered at only one index in the primitive
branch.  This is uniqueness of the native exponent coordinate, not uniqueness
of a prime factor of the cyclotomic value. -/
theorem index_unique_of_prime_dvd_two_pieces
    {m n p : ℕ} [Fact p.Prime] {a : ℤ}
    (hpm : ¬p ∣ m) (hpn : ¬p ∣ n)
    (hm : (p : ℤ) ∣ piece a m) (hn : (p : ℤ) ∣ piece a n) :
    m = n := by
  have hom := (prime_dvd_piece_iff_orderOf_eq_index hpm).mp hm
  have hon := (prime_dvd_piece_iff_orderOf_eq_index hpn).mp hn
  exact hom.symm.trans hon

/-- Native cross-base control: the prime `5`, previously held from base `2`,
is re-delivered at exponent `4` for base `3`. -/
theorem cross_base_five_reappears_at_four :
    (5 : ℤ) ∣ piece 3 4 ∧
      orderOf ((Int.castRingHom (ZMod 5)) 3) = 4 := by
  let _ : Fact (Nat.Prime 5) := ⟨by decide⟩
  have horder : orderOf ((Int.castRingHom (ZMod 5)) 3) = 4 := by
    rw [orderOf_eq_iff (by norm_num : 0 < 4)]
    constructor
    · decide
    · intro k hk hkpos
      interval_cases k <;> decide
  exact ⟨(prime_dvd_piece_iff_orderOf_eq_index (by norm_num)).mpr horder,
    horder⟩

/-- Hostile boundary: without `p ∤ m`, the exact re-delivery equivalence is
false.  Here `3 ∣ Φ₆(2)` but the order of `2` modulo `3` is `2`. -/
theorem exceptional_branch_refutes_unqualified_iff :
    ¬((3 : ℤ) ∣ piece 2 6 ↔
      orderOf ((Int.castRingHom (ZMod 3)) 2) = 6) := by
  rcases exceptional_branch_control with ⟨hdiv, horder⟩
  intro hiff
  exact horder (hiff.mp hdiv)

/-!
## Continuation from the native return

The native lineage accepts the primitive-branch transport predicate and points
to Theorem 10 as the strongest exact residual: multiplicative order does not
compose from the two component orders.  The following theorem states the
no-go at the interface level, not only as a table of four computed values.
-/

/-- There is no binary function of component orders that recovers the order of
a product, already in `ZMod 7`.  The pairs `(2,4)` and `(2,2)` both have
component orders `(3,3)`, while their products have orders `1` and `3`. -/
theorem product_order_not_determined_by_component_orders :
    ¬∃ F : ℕ → ℕ → ℕ, ∀ a b : ZMod 7,
      orderOf (a * b) = F (orderOf a) (orderOf b) := by
  rintro ⟨F, hF⟩
  have htwo : orderOf (2 : ZMod 7) = 3 := by
    simpa using primitive_branch_two_three_seven
  let _ : Fact (Nat.Prime 3) := ⟨by decide⟩
  have hfour : orderOf (4 : ZMod 7) = 3 := by
    apply orderOf_eq_prime
    · decide
    · decide
  have htwoFour : orderOf ((2 : ZMod 7) * 4) = 1 := by
    rw [orderOf_eq_one_iff]
    decide
  have htwoTwo : orderOf ((2 : ZMod 7) * 2) = 3 := by
    rw [show (2 : ZMod 7) * 2 = 4 by decide]
    exact hfour
  have hleft := hF (2 : ZMod 7) 4
  have hright := hF (2 : ZMod 7) 2
  rw [htwo, hfour, htwoFour] at hleft
  rw [htwo, htwoTwo] at hright
  omega

end Pairfield.CyclotomicPrimitiveTransportAdapter
