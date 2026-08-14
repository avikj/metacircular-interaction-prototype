/-
Copyright (c) 2026 Avik Jain and the mathematics collaboration.
Released under Apache 2.0 license.

The finite positional carrier for safe constant-response residual steering.
Cardinality alone is invariant; the live subset inside the canonical Nerode
automaton is the next exact state.
-/
import Pairfield.AdaptiveResidualSteering

namespace Pairfield

universe u v

variable {A : Type u} {X : Type v}

namespace CanonicalResidualPosition

/-- The canonical state type of the left-quotient automaton. -/
abbrev State (M : DFA A X) := Set.range M.accepts.leftQuotient

/-- Mathlib's exact automata theorem
`Language.IsRegular.finite_range_leftQuotient` supplies the finite positional
carrier.  This is a classical proof object, not an executable minimizer. -/
noncomputable def residualFintype (M : DFA A X)
    (regular : M.accepts.IsRegular) : Fintype (State M) :=
  regular.finite_range_leftQuotient.fintype

/-- The exact number of canonical residual positions. -/
noncomputable def stateCount (M : DFA A X)
    (regular : M.accepts.IsRegular) : Nat :=
  @Fintype.card (State M) (residualFintype M regular)

/-- Send a native finite prefix cell to the set of canonical residual states
that its prefixes present. -/
noncomputable def cellOfPrefixes (M : DFA A X)
    (cell : Finset (List A)) : Finset (State M) := by
  classical
  exact cell.image (CanonicalResidualAdapter.branchState M)

/-- A reduced native cell and its canonical residual-state image have exactly
the same cardinality. -/
theorem card_cellOfPrefixes_eq
    (M : DFA A X) (cell : Finset (List A))
    (hdistinct : ResidualPotentialAdapter.DistinctRepresentatives M cell) :
    (cellOfPrefixes M cell).card = cell.card := by
  classical
  apply Finset.card_image_of_injOn
  intro left hleft right hright heq
  apply hdistinct hleft hright
  exact congrArg Subtype.val heq

/-- Native prefix advance, represented directly as a canonical residual cell. -/
noncomputable def advanceCell (M : DFA A X)
    (cell : Finset (List A)) (action : A) : Finset (State M) := by
  classical
  exact cell.image fun pre =>
    CanonicalResidualAdapter.branchState M (pre ++ [action])

/-- Pointwise Mathlib-DFA advance of a canonical residual cell. -/
noncomputable def stepCell (M : DFA A X)
    (cell : Finset (State M)) (action : A) : Finset (State M) := by
  classical
  exact cell.image fun state => M.accepts.toDFA.step state action

/-- The native cell update is exactly pointwise stepping in Mathlib's
canonical left-quotient DFA. -/
theorem advanceCell_eq_toDFA_step_image
    (M : DFA A X) (cell : Finset (List A)) (action : A) :
    advanceCell M cell action =
      stepCell M (cellOfPrefixes M cell) action := by
  classical
  ext state
  simp only [advanceCell, stepCell, cellOfPrefixes, Finset.mem_image]
  constructor
  · rintro ⟨pre, hpre, rfl⟩
    refine ⟨CanonicalResidualAdapter.branchState M pre, ⟨pre, hpre, rfl⟩, ?_⟩
    exact CanonicalResidualAdapter.branchState_step M pre action
  · rintro ⟨source, ⟨pre, hpre, rfl⟩, rfl⟩
    refine ⟨pre, hpre, ?_⟩
    exact (CanonicalResidualAdapter.branchState_step M pre action).symm

/-- Residual safety makes canonical advance injective on a reduced live cell,
so a steering step preserves the exact position size.  Constant response is
needed to keep the whole image in one live branch, not for this injection. -/
theorem card_advanceCell_eq
    (M : DFA A X) (cell : Finset (List A)) (action : A)
    (hdistinct : ResidualPotentialAdapter.DistinctRepresentatives M cell)
    (hsafe : ResidualCell.SafeAction M (↑cell : Set (List A)) action) :
    (advanceCell M cell action).card = cell.card := by
  classical
  apply Finset.card_image_of_injOn
  intro left hleft right hright heq
  apply hdistinct hleft hright
  apply hsafe hleft hright
  exact congrArg Subtype.val heq

/-- All canonical live positions of a fixed residual cardinality. -/
noncomputable def fixedCellSpace (M : DFA A X)
    (regular : M.accepts.IsRegular) (k : Nat) : Finset (Finset (State M)) := by
  classical
  letI : Fintype (State M) := residualFintype M regular
  exact Finset.univ.powersetCard k

theorem mem_fixedCellSpace_iff
    (M : DFA A X) (regular : M.accepts.IsRegular)
    (k : Nat) (cell : Finset (State M)) :
    cell ∈ fixedCellSpace M regular k ↔ cell.card = k := by
  classical
  letI : Fintype (State M) := residualFintype M regular
  simp [fixedCellSpace]

/-- Exact size of the positional carrier. -/
theorem card_fixedCellSpace
    (M : DFA A X) (regular : M.accepts.IsRegular) (k : Nat) :
    (fixedCellSpace M regular k).card =
      Nat.choose (stateCount M regular) k := by
  classical
  letI : Fintype (State M) := residualFintype M regular
  simp [fixedCellSpace, stateCount]

/-- Conditional positional steering bound.  A duplicate-free history of
canonical live cells, all of size `k`, visits at most `choose n k` positions.
The still-open normalization joint is exactly the `Nodup` premise. -/
theorem nodup_fixedCellHistory_length_le_choose
    (M : DFA A X) (regular : M.accepts.IsRegular) (k : Nat)
    (history : List (Finset (State M)))
    (hnodup : history.Nodup)
    (hfixed : ∀ cell ∈ history, cell.card = k) :
    history.length ≤ Nat.choose (stateCount M regular) k := by
  classical
  letI : Fintype (State M) := residualFintype M regular
  have hsubset : history.toFinset ⊆ fixedCellSpace M regular k := by
    intro cell hcell
    apply (mem_fixedCellSpace_iff M regular k cell).2
    exact hfixed cell (by simpa using hcell)
  calc
    history.length = history.toFinset.card :=
      (List.toFinset_card_of_nodup hnodup).symm
    _ ≤ (fixedCellSpace M regular k).card :=
      Finset.card_le_card hsubset
    _ = Nat.choose (stateCount M regular) k :=
      card_fixedCellSpace M regular k

namespace Control

/-- The duplicate-cell control kills the history premise exactly where it
should: revisiting a canonical position is not a duplicate-free run. -/
theorem repeatedCell_not_nodup (cell : Finset (State M)) :
    ¬ ([cell, cell] : List (Finset (State M))).Nodup := by
  simp

/-- The existing duplicate-prefix control also kills exact native-to-canonical
cardinality transport by violating its reduced-representative premise. -/
theorem duplicatePrefixCell_not_reduced :
    ¬ ResidualPotentialAdapter.DistinctRepresentatives
      ResidualPotentialAdapter.Control.loopAutomaton
      ResidualPotentialAdapter.Control.duplicateCell :=
  ResidualPotentialAdapter.Control.duplicateCell_not_distinct

end Control

end CanonicalResidualPosition

end Pairfield
