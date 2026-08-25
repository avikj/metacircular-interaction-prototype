/-
Copyright (c) 2026 Avik Jain and the mathematics collaboration.
Released under Apache 2.0 license.

An executable finite Goldbach solver with a proof-relevant boundary.  The
program searches the complete first-leg interval using Lean's decidable
`Nat.Prime`.  Every successful result decodes to the existing dependent
centre fiber, and success is proved equivalent to the ordinary Goldbach
existential at that centre.

This decides each fixed finite target.  It neither enumerates a large horizon
here nor proves the unbounded `StrongGoldbach` proposition.
-/
import Pairfield.GoldbachBoundary

namespace Pairfield

/-- The decidable predicate searched by the finite Goldbach solver. -/
def goldbachLegPredicate (N p : ℕ) : Bool :=
  decide (p.Prime ∧ (N - p).Prime)

/-- Search every possible first leg `0,…,N`. -/
def goldbachLeg? (N : ℕ) : Option ℕ :=
  (List.range (N + 1)).find? (goldbachLegPredicate N)

/-- The finite search succeeds exactly when the classical existential holds.
The reverse direction uses completeness of `List.range (N+1)`, not a sampled
or heuristic candidate set. -/
theorem goldbachLeg?_isSome_iff_representation (N : ℕ) :
    (goldbachLeg? N).isSome = true ↔ GoldbachRepresentation N := by
  rw [goldbachLeg?, List.find?_isSome]
  constructor
  · rintro ⟨p, hpRange, hpq⟩
    have hpN : p ≤ N := Nat.le_of_lt_succ (List.mem_range.mp hpRange)
    have hprime : p.Prime ∧ (N - p).Prime := by
      exact of_decide_eq_true hpq
    exact ⟨p, N - p, hprime.1, hprime.2, Nat.add_sub_of_le hpN⟩
  · rintro ⟨p, q, hp, hq, hsum⟩
    have hpN : p ≤ N := by omega
    refine ⟨p, List.mem_range.mpr (Nat.lt_succ_of_le hpN), ?_⟩
    apply decide_eq_true
    constructor
    · exact hp
    · have hsub : N - p = q := by omega
      simpa [hsub] using hq

/-- Proof-carrying decoding of every successful executable result. -/
def goldbachFiberOfLeg {N p : ℕ} (h : goldbachLeg? N = some p) :
    GoldbachFiber N := by
  have hfind :
      (List.range (N + 1)).find? (goldbachLegPredicate N) = some p := by
    simpa [goldbachLeg?] using h
  have hpN : p ≤ N :=
    Nat.le_of_lt_succ (List.mem_range.mp (List.mem_of_find?_eq_some hfind))
  have hpq : goldbachLegPredicate N p = true := List.find?_some hfind
  have hprime : p.Prime ∧ (N - p).Prime :=
    of_decide_eq_true (by simpa [goldbachLegPredicate] using hpq)
  exact ⟨
    mkBoundedPrimePair hprime.1 hprime.2 hpN (Nat.sub_le N p),
    by
      simpa [pairCenter, mkBoundedPrimePair, mkBoundedPrime] using
        (Nat.add_sub_of_le hpN)
  ⟩

/-- Success of the executable search is exactly inhabitation of the checked
dependent center fiber. -/
theorem goldbachLeg?_isSome_iff (N : ℕ) :
    (goldbachLeg? N).isSome = true ↔ GoldbachAt N := by
  exact (goldbachLeg?_isSome_iff_representation N).trans
    (goldbachAt_iff_representation N).symm

end Pairfield
