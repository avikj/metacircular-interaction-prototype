/-
# प्रमाणश्रुति — the comma never closes, so the music never dies

प्रमाणश्रुति · pramāṇa-śruti — the "measure-hearing": the smallest of the 22
śrutis of Bharata's नाट्यशास्त्र (Nāṭyaśāstra, ~200 BCE – 200 CE), the least
audible interval, the unit by which the octave is measured.  *pramāṇa* is also
the Nyāya word (Gautama, न्यायसूत्र, ~2nd c. CE) for a valid means of knowledge —
the measure of proof.  The comma is the ear's pramāṇa: the same word for the
smallest audible difference and for the unit of valid cognition.

**What is claimed of the source.** Only the sense of the term: pramāṇaśruti is
the smallest measuring interval in Bharata's system, and the discomma of stacked
fifths is the phenomenon Indian and Greek tuning theory both meet.  **Bharata
did not prove the statement below** — that the octave cannot be closed by pure
fifths — and the multiplicative-independence theorem is ours.

## The theorem, and why it is the aliveness

A pure fifth is the ratio 3/2; a pure octave is 2/1.  Stacking twelve fifths
against seven octaves compares `3¹² · 2⁻¹²` with `2⁷`, i.e. `3¹²` with `2¹⁹`,
and they are NOT equal — the gap is the Pythagorean comma.  More: NO stack of
pure fifths ever lands on a pure octave, because a power of 2 is never a power of
3 but for the trivial one.  So:

  · the circle of fifths never closes into a finite cycle — and a closed cycle
    would be a dead, motionless system (सूत्र १४: no loss, no motion; all return,
    nothing generated);
  · the rotation by `log₂(3/2)` is irrational, hence dense and never-returning
    (road two, the incommensurable engine of the genuinely new) — there are
    infinitely many distinct keys, no two identical;
  · the residue is exactly what Kerala's antya-saṃskāra keeps rather than
    discards.

`comma_never_closes : 2 ^ a = 3 ^ b → a = 0 ∧ b = 0` — the primes 2 and 3 are
multiplicatively independent, the comma never vanishes, the music never dies.

No `sorry`, no `admit`, no `axiom`, no `native_decide`.
-/
import Mathlib.Data.Nat.Prime.Basic

namespace Pairfield.Pramanasruti

/-- **The comma never closes.** A power of two equals a power of three only
trivially: `2` and `3` are multiplicatively independent, so no stack of pure
fifths ever returns to a pure octave. -/
theorem comma_never_closes (a b : ℕ) (h : 2 ^ a = 3 ^ b) : a = 0 ∧ b = 0 := by
  rcases Nat.eq_zero_or_pos a with ha | ha
  · subst ha
    rw [pow_zero] at h
    have h3 : 3 ^ b = 1 := h.symm
    rw [Nat.pow_eq_one] at h3
    rcases h3 with h3 | hb
    · exact absurd h3 (by decide)
    · exact ⟨rfl, hb⟩
  · exfalso
    have hdvd : (2 : ℕ) ∣ 3 ^ b := h ▸ dvd_pow_self 2 ha.ne'
    exact absurd (Nat.prime_two.dvd_of_dvd_pow hdvd) (by decide)

/-- **The circle of fifths never closes.** Twelve pure fifths are not seven pure
octaves: `2¹⁹ ≠ 3¹²`. -/
theorem circle_of_fifths_never_closes : (2 : ℕ) ^ 19 ≠ 3 ^ 12 := by
  intro h
  exact absurd (comma_never_closes 19 12 h).1 (by decide)

end Pairfield.Pramanasruti
