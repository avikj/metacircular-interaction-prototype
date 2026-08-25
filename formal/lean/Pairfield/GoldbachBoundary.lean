/-
Copyright (c) 2026 Avik Jain and the mathematics collaboration.
Released under Apache 2.0 license.

The exact boundary between the finite prime-pair carrier and the classical
binary Goldbach statement.  An inhabited centre fiber is equivalent to the
ordinary existential assertion, and positivity of its finite cardinality is
equivalent to inhabitation.

This file supplies no positivity estimate.  In particular, naming the count
and proving the support equivalences below is not a proof of Goldbach; it makes
the analytic obligation that would prove Goldbach explicit and type checked.
-/
import Pairfield.BoundedPrimePair

namespace Pairfield

/-- The ordinary witness-bearing binary Goldbach assertion at one centre. -/
def GoldbachRepresentation (N : ℕ) : Prop :=
  ∃ p q : ℕ, p.Prime ∧ q.Prime ∧ p + q = N

/-- The finite center fiber at `N`.  The bound `N` loses no witness because
both nonnegative summands of a representation of `N` are at most `N`. -/
abbrev GoldbachFiber (N : ℕ) := PrimeCenterFiber N N

/-- Goldbach at one centre, expressed as inhabitation of the finite fiber. -/
def GoldbachAt (N : ℕ) : Prop := Nonempty (GoldbachFiber N)

/-- The bounded carrier is extensionally exact for the classical existential
statement; neither direction invokes a search or a primality decision. -/
theorem goldbachAt_iff_representation (N : ℕ) :
    GoldbachAt N ↔ GoldbachRepresentation N := by
  constructor
  · rintro ⟨point⟩
    rcases point with ⟨pair, hcenter⟩
    exact ⟨pair.1.1.val, pair.2.1.val, pair.1.2, pair.2.2, hcenter⟩
  · rintro ⟨p, q, hp, hq, hsum⟩
    have hpN : p ≤ N := by omega
    have hqN : q ≤ N := by omega
    refine ⟨⟨mkBoundedPrimePair hp hq hpN hqN, ?_⟩⟩
    simpa [pairCenter, mkBoundedPrimePair, mkBoundedPrime] using hsum

/-- The ordered number of prime-pair witnesses at centre `N`. -/
def goldbachCount (N : ℕ) : ℕ := Fintype.card (GoldbachFiber N)

/-- The exact support bridge: a positive finite count is neither weaker nor
stronger than an actual Goldbach witness at the same centre. -/
theorem goldbachCount_pos_iff (N : ℕ) :
    0 < goldbachCount N ↔ GoldbachAt N := by
  exact Fintype.card_pos_iff

/-- The strong binary Goldbach conjecture in the finite-fiber language. -/
def StrongGoldbach : Prop :=
  ∀ N : ℕ, 4 ≤ N → Even N → GoldbachAt N

/-- No statement change is hidden by the finite carrier. -/
theorem strongGoldbach_iff_classical :
    StrongGoldbach ↔
      ∀ N : ℕ, 4 ≤ N → Even N → GoldbachRepresentation N := by
  constructor
  · intro h N hN heven
    exact (goldbachAt_iff_representation N).mp (h N hN heven)
  · intro h N hN heven
    exact (goldbachAt_iff_representation N).mpr (h N hN heven)

/-- Equivalently, the remaining theorem is uniform positivity of the exact
ordered representation count over every even centre at least four. -/
theorem strongGoldbach_iff_count_pos :
    StrongGoldbach ↔
      ∀ N : ℕ, 4 ≤ N → Even N → 0 < goldbachCount N := by
  constructor
  · intro h N hN heven
    exact (goldbachCount_pos_iff N).mpr (h N hN heven)
  · intro h N hN heven
    exact (goldbachCount_pos_iff N).mp (h N hN heven)

/-- A finite verification target, kept separate from the universal theorem. -/
def GoldbachUpTo (X : ℕ) : Prop :=
  ∀ N : ℕ, 4 ≤ N → N ≤ X → Even N → GoldbachAt N

/-- Universal coverage restricts to every finite horizon. -/
theorem StrongGoldbach.upTo (h : StrongGoldbach) (X : ℕ) : GoldbachUpTo X := by
  intro N hN _ heven
  exact h N hN heven

end Pairfield
