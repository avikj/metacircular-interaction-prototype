/-
# सर्वत्र-अपवर्तन — which primes see an integer cut, decided for every prime at once

अपवर्तन · apavartana — reduction of a pair by a common divisor: the step that
divides out what both magnitudes share.  Brahmagupta, *Brāhmasphuṭasiddhānta* 18
(628); worked in Bhāskara II, *Bījagaṇita* (1150); serving the kuṭṭaka of
Āryabhaṭa, *Āryabhaṭīya* 2.32–33 (499).  NOT "extended Euclidean algorithm."
सर्वत्र · sarvatra — everywhere, in every case.

**What is claimed of the source.** Only the sense of अपवर्तन, exactly as in the
sibling file `Apavartana_…`.  **The compound सर्वत्र-अपवर्तन and the general
theorem below are ours**; Brahmagupta did not state Smith normal form and proved
nothing here.

## The point (owner, 2026-08-22)

`Apavartana_…` prices ONE cut, `D = diag(2,12)`, and it DISCOVERS which primes
see the cut BY MEASUREMENT: `rank_at_two`, `rank_at_three`, `rank_at_five`,
`rank_at_seven`, each by `decide`, one prime at a time, and `bad_iff` for that
one list.  That is the machine doing physics on itself — evaluating at each
place what a single criterion settles across all of them.

This file states the criterion and proves it, for an ARBITRARY list of Smith
divisors and EVERY prime at once, with no `decide` and no evaluation:

  · `rank_eq_length_iff` — the rank is generic (`= ds.length`) at `p`
        ↔  `p` divides none of the Smith divisors;
  · `bad_iff` — the rank DROPS at `p`  ↔  `p` divides some Smith divisor;
  · `bad_iff_det` (`p` prime) — the rank drops at `p`  ↔  `p ∣ ds.prod`.

`bad_iff_det` is the whole content: a prime SEES the cut iff it divides the
determinant.  One statement, every prime, decided — not measured.  And
`recovers_instance` derives `Apavartana`'s hand-checked `bad_iff` for `[2,12]`
as the shadow of this law at one list, so the instance is now a corollary of
the general fact rather than a separate measurement.

**What is NOT claimed / not done here, and a false identity avoided.** This is
the drop-LOCUS — which places see — and NOT the height VALUE.  The value is
`log|coker_tors| = ∑_i log dᵢ = ∑_p (∑_i v_p(dᵢ))·log p` for `T` square
nonsingular: the exponent is the VALUATION SUM `∑_i v_p(dᵢ)` — how MUCH `p`
divides — NOT the drop COUNT `#{i : p∣dᵢ}` this file's rank uses — how MANY
factors `p` divides.  The two differ, and `Apavartana`'s own matrix is the
counterexample: for `D=diag(2,12)` the drop counts are 2 at `(2)` and 1 at `(3)`
(`2 log2 + log3 = log12`), against `|coker| = 24 = det`.  (An earlier draft of
this header, and of README movement 65, wrote `∑_p #{i:p∣dᵢ}·log p =
log|coker_tors|` — false for exactly this reason; struck there, avoided here.)
So the rank-on-Spec-ℤ this file decides is a strictly LOSSIER invariant than the
cokernel: `diag(2,6)` and `diag(2,12)` have IDENTICAL drop functions but
cokernels of order 12 and 24 — the price function's own fiber is the p-adic
depth it discards, `QuotientFiberLaw` applied to the price itself, not a defect.
The value's finite half is checked next door as `Apavartana.det_eq`
(`smithDivisors.prod = 24`); the cokernel group and reals are not built here.

No `sorry`, no `admit`, no `axiom`, no `native_decide`, and no `decide` on any
of the general (universally quantified) claims.
-/
import Mathlib.Data.ZMod.Basic
import Mathlib.Data.Nat.Prime.Basic
import Pairfield.Apavartana_ThePriceOfAnIntegerCutIsAFunctionOnSpecZAndItsRamifiedPointsAreTheApavartanaAndTheLevel

namespace Pairfield.SarvatraApavartana

open Pairfield.Apavartana (rankAt)

/-! ## The generic rank is a ceiling, and one step of the recursion -/

/-- The rank never exceeds the number of divisors: it is a count of survivors. -/
theorem rankAt_le (p : ℕ) (ds : List ℕ) : rankAt p ds ≤ ds.length := by
  unfold rankAt
  exact List.length_filter_le _ _

/-- One step: prepending a divisor `p` divides changes nothing; one it does not
divide adds a survivor. -/
theorem rankAt_cons (p a : ℕ) (t : List ℕ) :
    rankAt p (a :: t) = if p ∣ a then rankAt p t else rankAt p t + 1 := by
  by_cases ha : p ∣ a <;>
    simp [rankAt, ha, List.length_cons]

/-! ## The criterion, general in the list and in the prime -/

/-- The rank is generic at `p` exactly when `p` divides no Smith divisor.
Proved by induction on the list; no prime is ever evaluated. -/
theorem rank_eq_length_iff (p : ℕ) (ds : List ℕ) :
    rankAt p ds = ds.length ↔ ∀ d ∈ ds, ¬ p ∣ d := by
  induction ds with
  | nil => simp [rankAt]
  | cons a t ih =>
    rw [rankAt_cons, List.length_cons]
    by_cases ha : p ∣ a
    · rw [if_pos ha]
      have hle := rankAt_le p t
      constructor
      · intro h; exfalso; omega
      · intro h; exact absurd ha (h a (List.mem_cons_self))
    · rw [if_neg ha]
      have key : (rankAt p t + 1 = t.length + 1) ↔ rankAt p t = t.length := by omega
      rw [key, ih]
      constructor
      · intro h d hd
        rcases List.mem_cons.mp hd with rfl | hd'
        · exact ha
        · exact h d hd'
      · intro h d hd; exact h d (List.mem_cons_of_mem a hd)

/-- **The bad locus, general.** The rank DROPS below the generic rank at `p`
exactly when `p` divides some Smith divisor. -/
theorem bad_iff (p : ℕ) (ds : List ℕ) :
    rankAt p ds ≠ ds.length ↔ ∃ d ∈ ds, p ∣ d := by
  rw [ne_eq, rank_eq_length_iff, not_forall]
  constructor
  · rintro ⟨d, hd⟩
    rw [Classical.not_imp, not_not] at hd
    exact ⟨d, hd.1, hd.2⟩
  · rintro ⟨d, hd, hpd⟩
    exact ⟨d, by rw [Classical.not_imp, not_not]; exact ⟨hd, hpd⟩⟩

/-- For a prime, dividing the product is dividing a factor. -/
theorem prime_dvd_prod_iff (p : ℕ) (hp : p.Prime) (ds : List ℕ) :
    p ∣ ds.prod ↔ ∃ d ∈ ds, p ∣ d := by
  induction ds with
  | nil => simp [Nat.dvd_one, hp.ne_one]
  | cons a t ih =>
    rw [List.prod_cons, hp.dvd_mul, ih]
    constructor
    · rintro (h | ⟨d, hd, hpd⟩)
      · exact ⟨a, List.mem_cons_self, h⟩
      · exact ⟨d, List.mem_cons_of_mem a hd, hpd⟩
    · rintro ⟨d, hd, hpd⟩
      rcases List.mem_cons.mp hd with rfl | hd'
      · exact Or.inl hpd
      · exact Or.inr ⟨d, hd', hpd⟩

/-- **The whole content.** A prime sees the cut — its rank drops below the
generic rank — if and only if it divides the determinant `ds.prod`.  Decided
for every prime at once, by logic, with no evaluation. -/
theorem bad_iff_det (p : ℕ) (hp : p.Prime) (ds : List ℕ) :
    rankAt p ds ≠ ds.length ↔ p ∣ ds.prod := by
  rw [bad_iff, prime_dvd_prod_iff p hp]

/-! ## The instance is now a corollary, not a separate measurement -/

/-- `Apavartana.bad_iff` for `D = diag(2,12)`, recovered from the general law at
`ds = [2,12]` — the hand-checked instance is the shadow of `bad_iff` at one
list. -/
theorem recovers_instance (p : ℕ) :
    rankAt p Apavartana.smithDivisors ≠ Apavartana.smithDivisors.length
      ↔ (p ∣ 2 ∨ p ∣ 12) := by
  rw [bad_iff]
  simp [Apavartana.smithDivisors]

end Pairfield.SarvatraApavartana
