/-
Copyright (c) 2026 Avik Jain and the mathematics collaboration.
Released under Apache 2.0 license.

The exact local-accounting boundary after node-minimal residual spines:
fixed-cardinality `Nodup` histories can saturate the full binomial carrier, so
those premises alone do not imply the classical quadratic ADS depth.
-/
import Pairfield.AdaptiveResidualNodeMinimalDepth

namespace Pairfield

universe u v

namespace FixedCellBudgetNoGo

variable {State : Type u} [Fintype State] [DecidableEq State]

/-- The complete fixed-cardinality carrier, read as a duplicate-free history.
No transition or realizability claim is included. -/
noncomputable def exhaustiveHistory (k : Nat) : List (Finset State) :=
  (Finset.univ.powersetCard k).toList

/-- Exactly the local premises consumed by R0058 after cycle deletion. -/
def LocallyAdmissible (k : Nat) (history : List (Finset State)) : Prop :=
  history.Nodup ∧ ∀ cell ∈ history, cell.card = k

theorem exhaustiveHistory_nodup (k : Nat) :
    (exhaustiveHistory (State := State) k).Nodup := by
  exact Finset.nodup_toList _

theorem exhaustiveHistory_fixed (k : Nat) :
    ∀ cell ∈ exhaustiveHistory (State := State) k, cell.card = k := by
  intro cell hcell
  simpa [exhaustiveHistory] using hcell

/-- The R0058 binomial budget is attained by its abstract carrier. -/
theorem exhaustiveHistory_length (k : Nat) :
    (exhaustiveHistory (State := State) k).length =
      Nat.choose (Fintype.card State) k := by
  simp [exhaustiveHistory]

theorem exists_locallyAdmissible_saturating (k : Nat) :
    ∃ history : List (Finset State),
      LocallyAdmissible k history ∧
      history.length = Nat.choose (Fintype.card State) k := by
  exact ⟨exhaustiveHistory (State := State) k,
    ⟨exhaustiveHistory_nodup k, exhaustiveHistory_fixed k⟩,
    exhaustiveHistory_length k⟩

variable {A : Type u} {X : Type v}

/-- The same exhaustive local history specialized to Mathlib's canonical
left-quotient state carrier. -/
noncomputable def canonicalExhaustiveHistory
    (M : DFA A X) (regular : M.accepts.IsRegular) (k : Nat) :
    List (Finset (CanonicalResidualPosition.State M)) := by
  classical
  letI : Fintype (CanonicalResidualPosition.State M) :=
    CanonicalResidualPosition.residualFintype M regular
  exact exhaustiveHistory k

theorem canonicalExhaustiveHistory_length
    (M : DFA A X) (regular : M.accepts.IsRegular) (k : Nat) :
    (canonicalExhaustiveHistory M regular k).length =
      Nat.choose (CanonicalResidualPosition.stateCount M regular) k := by
  classical
  letI : Fintype (CanonicalResidualPosition.State M) :=
    CanonicalResidualPosition.residualFintype M regular
  simpa [canonicalExhaustiveHistory,
    CanonicalResidualPosition.stateCount] using
    (exhaustiveHistory_length
      (State := CanonicalResidualPosition.State M) k)

/-- Executable method-class countermodel.  The local premises allow twenty
distinct three-state positions on a six-state carrier, already exceeding the
sharp ADS total target `6*5/2 = 15`. -/
theorem six_state_local_countermodel :
    ∃ history : List (Finset (Fin 6)),
      LocallyAdmissible 3 history ∧
      6 * 5 / 2 < history.length := by
  refine ⟨exhaustiveHistory (State := Fin 6) 3,
    ⟨exhaustiveHistory_nodup 3, exhaustiveHistory_fixed 3⟩, ?_⟩
  rw [exhaustiveHistory_length]
  norm_num [Nat.choose]

/-- Boundary control: the analogous strict overshoot is false one state
earlier at the two-subset layer; both quantities are exactly ten. -/
theorem five_state_two_subset_boundary :
    (exhaustiveHistory (State := Fin 5) 2).length = 5 * 4 / 2 := by
  rw [exhaustiveHistory_length]
  norm_num [Nat.choose]

end FixedCellBudgetNoGo

end Pairfield
