/-
Copyright (c) 2026 Avik Jain and the mathematics collaboration.
Released under Apache 2.0 license.

Canonical-position transport for residual splitting plans.  Raw prefix cells
never literally repeat because actions lengthen their presenters; the exact
cycle notion is equality of the left quotients presented by the cells.
-/
import Pairfield.AdaptiveConstantResponseSteering

namespace Pairfield

universe u v

variable {A : Type u} {X : Type v}

namespace ResidualCell

/-- The canonical live position presented by a raw prefix cell. -/
def Position (M : DFA A X) (cell : Set (List A)) : Set (Language A) :=
  BranchResidual M '' cell

/-- Two raw cells occupy the same canonical position exactly when they
present the same set of Mathlib left quotients. -/
def SamePosition (M : DFA A X)
    (left right : Set (List A)) : Prop :=
  Position M left = Position M right

end ResidualCell

namespace BoolExperimentTree

/-- Residual separation depends only on the canonical residual position.
One-sided inclusion is enough in the useful direction: a tree that separates
the larger presented position also separates the smaller one. -/
theorem separatesPrefixResidualsOn_mono_position
    (M : DFA A X) [DecidablePred (fun state : X => state ∈ M.accept)]
    (tree : BoolExperimentTree A) (small large : Set (List A))
    (hposition : ResidualCell.Position M small ⊆
      ResidualCell.Position M large)
    (hseparates : tree.SeparatesPrefixResidualsOn M large) :
    tree.SeparatesPrefixResidualsOn M small := by
  intro left right hleft hright htrace
  have hleftPosition :
      BranchResidual M left ∈ ResidualCell.Position M small :=
    ⟨left, hleft, rfl⟩
  have hrightPosition :
      BranchResidual M right ∈ ResidualCell.Position M small :=
    ⟨right, hright, rfl⟩
  rcases hposition hleftPosition with
    ⟨leftLarge, hleftLarge, hleftResidual⟩
  rcases hposition hrightPosition with
    ⟨rightLarge, hrightLarge, hrightResidual⟩
  have hleftTrace :=
    branchTrace_eq_of_branchResidual_eq M tree hleftResidual
  have hrightTrace :=
    branchTrace_eq_of_branchResidual_eq M tree hrightResidual
  have hlargeTrace :
      BranchTrace M tree leftLarge = BranchTrace M tree rightLarge :=
    hleftTrace.trans (htrace.trans hrightTrace.symm)
  have hlargeResidual :=
    hseparates hleftLarge hrightLarge hlargeTrace
  exact hleftResidual.symm.trans (hlargeResidual.trans hrightResidual)

/-- Exact equality of canonical positions transports a fixed separating tree
in both directions. -/
theorem separatesPrefixResidualsOn_congr_position
    (M : DFA A X) [DecidablePred (fun state : X => state ∈ M.accept)]
    (tree : BoolExperimentTree A) (left right : Set (List A))
    (hposition : ResidualCell.SamePosition M left right) :
    tree.SeparatesPrefixResidualsOn M left ↔
      tree.SeparatesPrefixResidualsOn M right := by
  constructor
  · apply separatesPrefixResidualsOn_mono_position M tree right left
    · rw [hposition]
  · apply separatesPrefixResidualsOn_mono_position M tree left right
    · rw [hposition]

end BoolExperimentTree

namespace ResidualSplitPlan

/-- Delete a completed steering detour at the proof-relevant level.  If the
later raw cell presents the same canonical residual position as the earlier
one, its separating subtree recompiles unchanged as a plan at the earlier
cell.  The equality `toTree = tree` says no replacement experiment was
invented: the later subtree itself was transplanted. -/
def transplantAtSamePosition
    (M : DFA A X) [DecidablePred (fun state : X => state ∈ M.accept)]
    (tree : BoolExperimentTree A) (earlier later : Set (List A))
    (earlierConstant : ResidualCell.CurrentConstant M earlier)
    (laterConstant : ResidualCell.CurrentConstant M later)
    (samePosition : ResidualCell.SamePosition M earlier later)
    (laterSplitting : tree.ResidualSplitting M later) :
    ResidualSplitPlan M earlier := by
  have laterSeparates : tree.SeparatesPrefixResidualsOn M later :=
    (tree.residualSplitting_iff_separatesOn
      M later laterConstant).1 laterSplitting
  have earlierSeparates : tree.SeparatesPrefixResidualsOn M earlier :=
    (tree.separatesPrefixResidualsOn_congr_position
      M earlier later samePosition).2 laterSeparates
  exact ofTree M tree earlier
    ((tree.residualSplitting_iff_separatesOn
      M earlier earlierConstant).2 earlierSeparates)

theorem transplantAtSamePosition_toTree
    (M : DFA A X) [DecidablePred (fun state : X => state ∈ M.accept)]
    (tree : BoolExperimentTree A) (earlier later : Set (List A))
    (earlierConstant : ResidualCell.CurrentConstant M earlier)
    (laterConstant : ResidualCell.CurrentConstant M later)
    (samePosition : ResidualCell.SamePosition M earlier later)
    (laterSplitting : tree.ResidualSplitting M later) :
    (transplantAtSamePosition M tree earlier later earlierConstant
      laterConstant samePosition laterSplitting).toTree = tree := by
  apply toTree_ofTree

end ResidualSplitPlan

namespace AdaptiveResidualCycleDeletionControl

open AdaptiveConstantResponseSteering

def revealTree : BoolExperimentTree (Fin 3) :=
  .query reveal .done .done

/-- After the mandatory steering move, the short reveal subtree separates. -/
theorem revealTree_separates_after_steer :
    revealTree.SeparatesPrefixResidualsOn automaton
      (ResidualCell.advance automaton liveCell steer false) := by
  have hsplit :=
    (steeringTree.residualSplitting_iff_separatesOn automaton liveCell
      liveCell_currentConstant).2 steeringTree_separates
  exact (revealTree.residualSplitting_iff_separatesOn automaton
    (ResidualCell.advance automaton liveCell steer false)
    (ResidualCell.advance_currentConstant
      automaton liveCell steer false)).1 hsplit.2.1

/-- The same reveal subtree does not separate before steering. -/
theorem revealTree_not_separates_before_steer :
    ¬ revealTree.SeparatesPrefixResidualsOn automaton liveCell := by
  intro hseparates
  have hsplit :=
    (revealTree.residualSplitting_iff_separatesOn automaton liveCell
      liveCell_currentConstant).2 hseparates
  exact reveal_not_safe hsplit.1

/-- R0057 is not accidentally deleted: its mandatory steering action moves
the live pair to a genuinely different canonical residual position. -/
theorem steer_changes_canonical_position :
    ¬ ResidualCell.SamePosition automaton liveCell
      (ResidualCell.advance automaton liveCell steer false) := by
  intro hsame
  have htransport :=
    (revealTree.separatesPrefixResidualsOn_congr_position automaton
      liveCell (ResidualCell.advance automaton liveCell steer false) hsame).2
      revealTree_separates_after_steer
  exact revealTree_not_separates_before_steer htransport

end AdaptiveResidualCycleDeletionControl

end Pairfield
