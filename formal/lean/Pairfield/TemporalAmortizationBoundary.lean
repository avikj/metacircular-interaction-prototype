/-
Copyright (c) 2026 Avik Jain and the mathematics collaboration.
Released under Apache 2.0 license.

Exact natural-number amortization and the smallest horizon-free decision
obstruction.  These are cost-accounting theorems, not wall-clock claims.
-/
import Mathlib

namespace Pairfield.TemporalAmortizationBoundary

/-- Replaying an old route for a declared number of uses. -/
def oldCost (oldPerUse uses : ℕ) : ℕ :=
  uses * oldPerUse

/-- Paying formation once, then using the installed route. -/
def installedCost (formation installedPerUse uses : ℕ) : ℕ :=
  formation + uses * installedPerUse

/-- With an explicit per-use gap, cancellation reduces total profitability to
formation cost being strictly below accumulated savings. -/
theorem installed_lt_old_iff_gap
    (formation installedPerUse oldPerUse uses gap : ℕ)
    (hgap : installedPerUse + gap = oldPerUse) :
    installedCost formation installedPerUse uses < oldCost oldPerUse uses ↔
      formation < uses * gap := by
  simp only [installedCost, oldCost, ← hgap, Nat.mul_add]
  rw [Nat.add_comm formation (uses * installedPerUse)]
  exact Nat.add_lt_add_iff_left

/-- Exact natural-number form of the strict amortization threshold. -/
theorem installed_lt_old_iff
    (formation installedPerUse oldPerUse uses : ℕ)
    (hfast : installedPerUse < oldPerUse) :
    installedCost formation installedPerUse uses < oldCost oldPerUse uses ↔
      formation / (oldPerUse - installedPerUse) < uses := by
  rw [installed_lt_old_iff_gap formation installedPerUse oldPerUse uses
    (oldPerUse - installedPerUse)
    (Nat.add_sub_of_le (Nat.le_of_lt hfast))]
  exact (Nat.div_lt_iff_lt_mul (Nat.sub_pos_of_lt hfast)).symm

/-- The first integer horizon at which installation is strictly profitable. -/
def leastProfitableReuse
    (formation installedPerUse oldPerUse : ℕ) : ℕ :=
  formation / (oldPerUse - installedPerUse) + 1

/-- The declared least horizon really is profitable when the installed route
is strictly cheaper per use. -/
theorem leastProfitableReuse_profitable
    (formation installedPerUse oldPerUse : ℕ)
    (hfast : installedPerUse < oldPerUse) :
    installedCost formation installedPerUse
        (leastProfitableReuse formation installedPerUse oldPerUse) <
      oldCost oldPerUse
        (leastProfitableReuse formation installedPerUse oldPerUse) := by
  rw [installed_lt_old_iff formation installedPerUse oldPerUse _ hfast]
  simp [leastProfitableReuse]

/-- No smaller natural-number horizon is strictly profitable.  Equality at
the break-even boundary is deliberately not counted as a gain. -/
theorem not_profitable_below_least
    (formation installedPerUse oldPerUse uses : ℕ)
    (hfast : installedPerUse < oldPerUse)
    (huses : uses < leastProfitableReuse formation installedPerUse oldPerUse) :
    ¬ installedCost formation installedPerUse uses < oldCost oldPerUse uses := by
  rw [installed_lt_old_iff formation installedPerUse oldPerUse uses hfast]
  have hle : uses ≤ formation / (oldPerUse - installedPerUse) := by
    simpa [leastProfitableReuse] using huses
  exact Nat.not_lt_of_ge hle

/-- If installation does not lower per-use cost, no reuse horizon repays even
a zero formation bill in the strict metric. -/
theorem no_profit_when_old_le_installed
    (formation installedPerUse oldPerUse uses : ℕ)
    (hslow : oldPerUse ≤ installedPerUse) :
    ¬ installedCost formation installedPerUse uses < oldCost oldPerUse uses := by
  apply Nat.not_lt_of_ge
  exact (Nat.mul_le_mul_left uses hslow).trans
    (Nat.le_add_left (uses * installedPerUse) formation)

------------------------------------------------------------------------
-- Horizon-free decision boundary
------------------------------------------------------------------------

inductive InstallDecision where
  | keep
  | install
  deriving DecidableEq

def decisionCost (formation oldPerUse installedPerUse uses : ℕ) :
    InstallDecision → ℕ
  | .keep => oldCost oldPerUse uses
  | .install => installedCost formation installedPerUse uses

def OptimalAt (formation oldPerUse installedPerUse uses : ℕ)
    (decision : InstallDecision) : Prop :=
  decisionCost formation oldPerUse installedPerUse uses decision =
    min (oldCost oldPerUse uses)
      (installedCost formation installedPerUse uses)

/-- At three uses the old route is strictly cheaper for the declared control. -/
theorem keep_strictly_better_at_three :
    oldCost 30 3 < installedCost 72 8 3 := by
  norm_num [oldCost, installedCost]

/-- At four uses installation is strictly cheaper for the same control. -/
theorem install_strictly_better_at_four :
    installedCost 72 8 4 < oldCost 30 4 := by
  norm_num [oldCost, installedCost]

/-- No one pre-horizon decision is offline-optimal in both continuations. -/
theorem no_fixed_decision_optimal_at_three_and_four :
    ¬ ∃ decision,
      OptimalAt 72 30 8 3 decision ∧ OptimalAt 72 30 8 4 decision := by
  rintro ⟨decision, optimalThree, optimalFour⟩
  cases decision with
  | keep =>
      norm_num [OptimalAt, decisionCost, oldCost, installedCost] at optimalFour
  | install =>
      norm_num [OptimalAt, decisionCost, oldCost, installedCost] at optimalThree

/-- In particular, a deterministic choice that sees only the three cost
parameters, and not the future horizon, fails on one of the two futures. -/
theorem no_horizon_free_decision
    (choose : ℕ → ℕ → ℕ → InstallDecision) :
    ¬ (OptimalAt 72 30 8 3 (choose 72 30 8) ∧
       OptimalAt 72 30 8 4 (choose 72 30 8)) := by
  intro both
  exact no_fixed_decision_optimal_at_three_and_four
    ⟨choose 72 30 8, both⟩

end Pairfield.TemporalAmortizationBoundary
