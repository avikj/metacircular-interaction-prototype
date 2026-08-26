/-
Copyright (c) 2026 Avik Jain and the mathematics collaboration.
Released under Apache 2.0 license.

An executable complete checker for every even Goldbach target in a finite
horizon.  The target list and every first-leg search use explicit
`List.range`; no finite-set conversion or sampled enumeration is involved.

Success is equivalent to `GoldbachUpTo X`, and it decodes to a dependent
family of actual center-fiber elements.  This is a generic verified program,
not an evaluation of any horizon and not a proof of unbounded Goldbach.
-/
import Pairfield.GoldbachDecision

namespace Pairfield

/-- The complete ordered list of even targets `N` with `4 ≤ N ≤ X`. -/
def goldbachTargets (X : ℕ) : List ℕ :=
  (List.range (X + 1)).filter fun N ↦ decide (4 ≤ N ∧ Even N)

theorem mem_goldbachTargets_iff {X N : ℕ} :
    N ∈ goldbachTargets X ↔ 4 ≤ N ∧ N ≤ X ∧ Even N := by
  simp only [goldbachTargets, List.mem_filter, List.mem_range,
    decide_eq_true_eq]
  constructor
  · rintro ⟨hNX, hfour, heven⟩
    exact ⟨hfour, Nat.le_of_lt_succ hNX, heven⟩
  · rintro ⟨hfour, hNX, heven⟩
    exact ⟨Nat.lt_succ_of_le hNX, hfour, heven⟩

/-- Run the complete single-center solver at every declared target. -/
def goldbachUpToCheck (X : ℕ) : Bool :=
  (goldbachTargets X).all fun N ↦ (goldbachLeg? N).isSome

/-- The finite executable checker succeeds exactly when every declared
target has an inhabited center fiber. -/
theorem goldbachUpToCheck_eq_true_iff (X : ℕ) :
    goldbachUpToCheck X = true ↔ GoldbachUpTo X := by
  rw [goldbachUpToCheck, List.all_eq_true]
  constructor
  · intro hall N hfour hNX heven
    apply (goldbachLeg?_isSome_iff N).1
    exact hall N <| (mem_goldbachTargets_iff).2
      ⟨hfour, hNX, heven⟩
  · intro hGoldbach N hmem
    rcases (mem_goldbachTargets_iff).1 hmem with
      ⟨hfour, hNX, heven⟩
    exact (goldbachLeg?_isSome_iff N).2
      (hGoldbach N hfour hNX heven)

/-- The universal conjecture makes every finite check succeed.  Only this
restriction direction is provided: success at one fixed `X` contains no
targets above `X` and therefore does not yield `StrongGoldbach`. -/
theorem goldbachUpToCheck_eq_true_of_strongGoldbach
    (h : StrongGoldbach) (X : ℕ) : goldbachUpToCheck X = true := by
  exact (goldbachUpToCheck_eq_true_iff X).2 (h.upTo X)

/-- Decode Boolean success of the single-target program to the actual
dependent center fiber, retaining the first leg selected by `find?`. -/
def goldbachFiberOfIsSome {N : ℕ}
    (h : (goldbachLeg? N).isSome = true) : GoldbachFiber N := by
  cases hleg : goldbachLeg? N with
  | none => simp [hleg] at h
  | some p => exact goldbachFiberOfLeg hleg

/-- A proof-relevant certificate for an entire finite Goldbach horizon. -/
abbrev GoldbachUpToCertificate (X : ℕ) :=
  (N : ℕ) → 4 ≤ N → N ≤ X → Even N → GoldbachFiber N

/-- Decode a successful range check to one checked center-fiber witness for
every even target in the declared interval. -/
def goldbachUpToCertificateOfCheck {X : ℕ}
    (h : goldbachUpToCheck X = true) : GoldbachUpToCertificate X := by
  intro N hfour hNX heven
  apply goldbachFiberOfIsSome
  apply (List.all_eq_true.mp h)
  exact (mem_goldbachTargets_iff).2 ⟨hfour, hNX, heven⟩

/-- Forgetting the witnesses from the decoded family recovers the logical
finite-horizon statement. -/
theorem goldbachUpTo_of_certificate {X : ℕ}
    (certificate : GoldbachUpToCertificate X) : GoldbachUpTo X := by
  intro N hfour hNX heven
  exact ⟨certificate N hfour hNX heven⟩

end Pairfield
