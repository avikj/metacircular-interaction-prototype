/-
Copyright (c) 2026 Avik Jain and the mathematics collaboration.
Released under Apache 2.0 license.

Checked equality adapter between the finite canonical carrier and the
set-valued canonical position used by residual cycle deletion.
-/
import Pairfield.AdaptiveResidualPositionRank
import Pairfield.AdaptiveResidualCycleDeletion

namespace Pairfield

universe u v

variable {A : Type u} {X : Type v}

namespace CanonicalResidualPosition

/-- Membership in the finite canonical carrier is exactly membership of the
underlying language in formation's set-valued residual position. -/
theorem mem_cellOfPrefixes_iff_mem_position
    (M : DFA A X) (cell : Finset (List A)) (state : State M) :
    state ∈ cellOfPrefixes M cell ↔
      state.val ∈ ResidualCell.Position M (↑cell : Set (List A)) := by
  classical
  constructor
  · intro hstate
    rcases Finset.mem_image.mp hstate with ⟨pre, hpre, rfl⟩
    exact ⟨pre, hpre, rfl⟩
  · rintro ⟨pre, hpre, hresidual⟩
    apply Finset.mem_image.mpr
    refine ⟨pre, hpre, ?_⟩
    apply Subtype.ext
    exact hresidual

/-- Formation's equality of presented language sets and equality in R0058's
finite canonical state carrier are the same relation. -/
theorem samePosition_iff_cellOfPrefixes_eq
    (M : DFA A X) (left right : Finset (List A)) :
    ResidualCell.SamePosition M
        (↑left : Set (List A)) (↑right : Set (List A)) ↔
      cellOfPrefixes M left = cellOfPrefixes M right := by
  classical
  constructor
  · intro hposition
    ext state
    rw [mem_cellOfPrefixes_iff_mem_position,
      mem_cellOfPrefixes_iff_mem_position]
    exact Set.ext_iff.mp hposition state.val
  · intro hcells
    apply Set.ext
    intro language
    constructor
    · rintro ⟨pre, hpre, rfl⟩
      have hleft :
          CanonicalResidualAdapter.branchState M pre ∈
            cellOfPrefixes M left :=
        (mem_cellOfPrefixes_iff_mem_position M left _).2
          ⟨pre, hpre, rfl⟩
      have hright :
          CanonicalResidualAdapter.branchState M pre ∈
            cellOfPrefixes M right := by
        rw [← hcells]
        exact hleft
      exact (mem_cellOfPrefixes_iff_mem_position M right _).1 hright
    · rintro ⟨pre, hpre, rfl⟩
      have hright :
          CanonicalResidualAdapter.branchState M pre ∈
            cellOfPrefixes M right :=
        (mem_cellOfPrefixes_iff_mem_position M right _).2
          ⟨pre, hpre, rfl⟩
      have hleft :
          CanonicalResidualAdapter.branchState M pre ∈
            cellOfPrefixes M left := by
        rw [hcells]
        exact hright
      exact (mem_cellOfPrefixes_iff_mem_position M left _).1 hleft

/-- Finite-carrier equality now directly licenses formation's proof-relevant
cycle splice. -/
def transplantAtEqualFinitePosition
    (M : DFA A X) [DecidablePred (fun state : X => state ∈ M.accept)]
    (tree : BoolExperimentTree A) (earlier later : Finset (List A))
    (earlierConstant :
      ResidualCell.CurrentConstant M (↑earlier : Set (List A)))
    (laterConstant :
      ResidualCell.CurrentConstant M (↑later : Set (List A)))
    (sameFinitePosition :
      cellOfPrefixes M earlier = cellOfPrefixes M later)
    (laterSplitting :
      tree.ResidualSplitting M (↑later : Set (List A))) :
    ResidualSplitPlan M (↑earlier : Set (List A)) :=
  ResidualSplitPlan.transplantAtSamePosition M tree
    (↑earlier : Set (List A)) (↑later : Set (List A))
    earlierConstant laterConstant
    ((samePosition_iff_cellOfPrefixes_eq M earlier later).2
      sameFinitePosition)
    laterSplitting

theorem transplantAtEqualFinitePosition_toTree
    (M : DFA A X) [DecidablePred (fun state : X => state ∈ M.accept)]
    (tree : BoolExperimentTree A) (earlier later : Finset (List A))
    (earlierConstant :
      ResidualCell.CurrentConstant M (↑earlier : Set (List A)))
    (laterConstant :
      ResidualCell.CurrentConstant M (↑later : Set (List A)))
    (sameFinitePosition :
      cellOfPrefixes M earlier = cellOfPrefixes M later)
    (laterSplitting :
      tree.ResidualSplitting M (↑later : Set (List A))) :
    (transplantAtEqualFinitePosition M tree earlier later earlierConstant
      laterConstant sameFinitePosition laterSplitting).toTree = tree := by
  apply ResidualSplitPlan.transplantAtSamePosition_toTree

namespace Control

open AdaptiveConstantResponseSteering

/-- The finite raw prefix cell after R0057's mandatory false-response steer. -/
noncomputable def steeredRepresentatives : Finset (List (Fin 3)) := by
  classical
  exact representatives.image (fun pre => pre ++ [steer])

theorem coe_steeredRepresentatives_eq_advance :
    (↑steeredRepresentatives : Set (List (Fin 3))) =
      ResidualCell.advance automaton liveCell steer false := by
  classical
  ext next
  constructor
  · intro hnext
    rcases Finset.mem_image.mp hnext with ⟨pre, hpre, rfl⟩
    exact ⟨pre, hpre, rfl, by
      exact steer_response_constant pre hpre⟩
  · rintro ⟨pre, hpre, rfl, _hresponse⟩
    exact Finset.mem_image.mpr ⟨pre, hpre, rfl⟩

/-- The R0057 hostile control survives the adapter: its mandatory steer moves
to a genuinely different element of the finite position carrier. -/
theorem steer_changes_finite_position :
    cellOfPrefixes automaton representatives ≠
      cellOfPrefixes automaton steeredRepresentatives := by
  intro hequal
  apply AdaptiveResidualCycleDeletionControl.steer_changes_canonical_position
  change ResidualCell.SamePosition automaton
    (↑representatives : Set (List (Fin 3)))
    (ResidualCell.advance automaton liveCell steer false)
  rw [← coe_steeredRepresentatives_eq_advance]
  exact (samePosition_iff_cellOfPrefixes_eq automaton
    representatives steeredRepresentatives).2 hequal

/-- Different native singleton presenters of the one-state loop deliberately
coalesce to the same finite canonical position. -/
theorem loop_presenters_coalesce :
    cellOfPrefixes ResidualPotentialAdapter.Control.loopAutomaton
        ({[]} : Finset (List Unit)) =
      cellOfPrefixes ResidualPotentialAdapter.Control.loopAutomaton
        ({[()]} : Finset (List Unit)) := by
  classical
  apply (samePosition_iff_cellOfPrefixes_eq _ _ _).1
  apply Set.ext
  intro language
  simp only [ResidualCell.SamePosition, ResidualCell.Position,
    Set.mem_image, Finset.mem_coe, Finset.mem_singleton]
  constructor
  · rintro ⟨pre, rfl, rfl⟩
    exact ⟨[()], rfl,
      (ResidualPotentialAdapter.Control.loop_residual_eq [] [()]).symm⟩
  · rintro ⟨pre, rfl, rfl⟩
    exact ⟨[], rfl,
      ResidualPotentialAdapter.Control.loop_residual_eq [] [()]⟩

end Control

end CanonicalResidualPosition

end Pairfield
