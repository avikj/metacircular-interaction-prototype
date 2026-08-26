/-
# Apavartana — the price of an integer cut is a function on Spec ℤ

अपवर्तन · apavartana — reduction of a pair by a common divisor: the step that
divides out what both magnitudes share.  Stated in Brahmagupta,
*Brāhmasphuṭasiddhānta* 18 (628), worked in Bhāskara II, *Bījagaṇita* (1150),
serving the kuṭṭaka of Āryabhaṭa, *Āryabhaṭīya* 2.32–33 (499).  NOT "extended
Euclidean algorithm."

**What is claimed of the source.** Only the sense of the word: `apavartana` is
the common divisor removed from a pair, and in the matrix
`D = diag(d₁, q·d₁)` the entry `d₁` is exactly that — the content shared by
both diagonal entries, with `q` the level left over after it is removed.
**What is NOT claimed.** Brahmagupta did not state Smith normal form, did not
work over Spec ℤ, and proved nothing in this file.  The Smith divisors, the
prime-by-prime rank, and the cokernel are ours; the term names the split.

## The object

`D = diag(d₁, q·d₁)` is the diagonal endpoint of the Γ₀ stabilizer identity
`H · D · K ≡ D` in `formal/cubical/Gamma0Partner.agda` (which fixes exactly
this shape).  This file prices ONE instance of it, end to end:

    d₁ = 2,  q = 6      ⟹      D = diag(2, 12)

## The receipt

`D` is already in Smith order (`2 ∣ 12`), so the Smith divisors are

    d₁ = 2  |  d₂ = 12,      det D = 24 = 2³ · 3

and over a field of characteristic `p`, `rank_{𝔽_p}(D) = #{i : p ∤ d_i}`:

| point of Spec ℤ | rank | drop from rank_ℚ = 2 |
|---|---|---|
| `(0)`  — generic     | 2 | 0 |
| `(2)`  — apavartana  | 0 | 2 |
| `(3)`  — level       | 1 | 1 |
| `(p)`, `p ≥ 5`       | 2 | 0 |

**One line.** The receipt is the function `p ↦ rank_{𝔽_p}(D)` on Spec ℤ, equal
to 2 away from `V(24) = {(2), (3)}`, dropping by 2 at `(2)` — the apavartana,
which divides BOTH divisors — and by 1 at `(3)` — the level, which divides only
the second.  Cokernel `ℤ²/Dℤ² ≅ ℤ/2 ⊕ ℤ/12`, order 24, exponent 12.

**Why this instance and not the exemplar.** `YugmaPurāṇa`'s edge prices at
`ℤ/2`: one bad prime, constant drop, so a single number would have sufficed.
Here the drop is 2 at one bad prime and 1 at another.  A non-constant function
on the ramification locus is not a number, and that is the whole content of
"over ℤ the price of a cut is a function on Spec ℤ."

(the defect is a fibre dimension; and the fence — linear ranks satisfy
Ingleton, entropies do not, so this does not read as entropy),
`formal/cubical/Sesa_TheCompositesRemainderIsTheSecondRemainderSummedOverTheFirstAndTheAreasAdd.agda`.

## What is checked here and what is prose

CHECKED below: Smith order; the value of `rank_{𝔽_p}` at 2, 3, 5, 7 and its
generic value for every `p ∤ 24`; the bridge that `#{i : p ∤ d_i}` is really a
count of nonvanishing residues in `ZMod p`; the cokernel's order (24), its
exponent (12 kills it), and that 12 does NOT kill `ZMod 24`, hence the cokernel
is not cyclic and genuinely has two invariant factors.

PROSE, not checked here: that `diag(2,12)` is the Smith normal form of the Γ₀
endpoint under `GL₂(ℤ)` change of basis (it is diagonal with `2 ∣ 12`, so this
is immediate, but no term below says it), and that `ℤ²/Dℤ² ≅ ℤ/2 ⊕ ℤ/12` as an
explicit quotient of `ℤ²` — the order-and-exponent facts below pin the
isomorphism class among abelian groups of order 24 but are not that quotient.

No `sorry`, no `admit`, no `axiom`, no `native_decide`.
-/
import Mathlib.Data.ZMod.Basic
import Mathlib.Data.Nat.Prime.Basic

namespace Pairfield.Apavartana

/-! ## The divisors -/

/-- The Smith divisors of `D = diag(d₁, q·d₁)` with apavartana `d₁ = 2` and
level `q = 6`. -/
def smithDivisors : List Nat := [2, 12]

/-- `D` is already in Smith order: each divisor divides the next. -/
theorem smith_ordered : (2 : Nat) ∣ 12 := by decide

/-- `det D` is the product of the Smith divisors, and is the order of the
cokernel. -/
theorem det_eq : smithDivisors.prod = 24 := by decide

/-! ## The receipt as a function on Spec ℤ -/

/-- `rank_{𝔽_p}` of a diagonal integer matrix: the number of Smith divisors the
prime does not divide. -/
def rankAt (p : Nat) (ds : List Nat) : Nat :=
  (ds.filter (fun d => !decide (p ∣ d))).length

/-- The bridge to actual characteristic-`p` vanishing: a divisor survives in
`ZMod p` exactly when `p` does not divide it.  This is what makes `rankAt` a
rank and not a bookkeeping count. -/
theorem survives_iff (p d : Nat) : ((d : ZMod p) ≠ 0) ↔ ¬ (p ∣ d) := by
  simp [ZMod.natCast_eq_zero_iff]

/-- The generic point: `rank_ℚ = 2`, matched by every good prime. -/
theorem rank_generic (p : Nat) (h : ¬ p ∣ 24) : rankAt p smithDivisors = 2 := by
  have h2 : ¬ p ∣ 2 := fun hp => h (hp.trans (by decide))
  have h12 : ¬ p ∣ 12 := fun hp => h (hp.trans (by decide))
  simp [rankAt, smithDivisors, h2, h12]

/-- At `(2)`, the apavartana, the rank drops all the way to 0: the prime
divides BOTH divisors. -/
theorem rank_at_two : rankAt 2 smithDivisors = 0 := by decide

/-- At `(3)`, the level, the rank drops by exactly 1: the prime divides the
second divisor only. -/
theorem rank_at_three : rankAt 3 smithDivisors = 1 := by decide

theorem rank_at_five : rankAt 5 smithDivisors = 2 := by decide
theorem rank_at_seven : rankAt 7 smithDivisors = 2 := by decide

/-- **The receipt is not a number.**  The drop is 2 at one ramified point and
1 at the other, so no constant records it. -/
theorem drop_is_not_constant :
    rankAt 2 smithDivisors ≠ rankAt 3 smithDivisors := by decide

/-- The ramification locus is exactly `V(24) = {(2), (3)}`: a prime is bad iff
it divides some Smith divisor. -/
theorem bad_iff (p : Nat) : rankAt p smithDivisors ≠ 2 ↔ (p ∣ 2 ∨ p ∣ 12) := by
  by_cases h2 : p ∣ 2 <;> by_cases h12 : p ∣ 12 <;>
    simp [rankAt, smithDivisors, h2, h12]

/-! ## The cokernel as a group -/

/-- The cokernel `ℤ²/Dℤ²` of `D = diag(2,12)`, free rank 0 plus torsion. -/
abbrev Cok : Type := ZMod 2 × ZMod 12

theorem cok_card : Fintype.card Cok = 24 := by decide

/-- The exponent divides 12: adding any element to itself 12 times gives 0. -/
theorem cok_exponent_twelve : ∀ x : Cok, (12 : Nat) • x = 0 := by decide

/-- But 12 does not kill `ZMod 24`, which has an element of additive order 24. -/
theorem zmod24_exponent_not_twelve : ¬ (∀ x : ZMod 24, (12 : Nat) • x = 0) := by
  decide

/-- **Two invariant factors are genuinely needed.**  The cokernel has order 24
and exponent 12, so it is not `ℤ/24`: the torsion does not collapse to a single
cyclic summand, which is why the Smith form has two divisors and not one. -/
theorem cok_not_cyclic : ¬ Nonempty (Cok ≃+ ZMod 24) := by
  rintro ⟨e⟩
  refine zmod24_exponent_not_twelve (fun y => ?_)
  have h := cok_exponent_twelve (e.symm y)
  calc (12 : Nat) • y = (12 : Nat) • e (e.symm y) := by rw [e.apply_symm_apply]
    _ = e ((12 : Nat) • e.symm y) := by rw [map_nsmul]
    _ = e 0 := by rw [h]
    _ = 0 := map_zero e

end Pairfield.Apavartana
