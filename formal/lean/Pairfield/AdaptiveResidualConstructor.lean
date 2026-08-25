/-
Copyright (c) 2026 Avik Jain and the mathematics collaboration.
Released under Apache 2.0 license.

An exact conditional constructor for adaptive residual separators.  A plan is
the recursively splittable witness; compiling it produces the native tree.
The theorem does not assert that every reduced automaton has such a plan.
-/
import Pairfield.AdaptiveResidualPotentialAdapter

namespace Pairfield

universe u v

variable {A : Type u} {X : Type v}

/-- An explicit recursively splittable live-cell witness, independent of the
native experiment-tree syntax that will execute it. -/
inductive ResidualSplitPlan
    (M : DFA A X) [DecidablePred (fun state : X => state ∈ M.accept)] :
    Set (List A) → Type (max u v)
  | done {cell : Set (List A)}
      (homogeneous : ResidualCell.Homogeneous M cell) :
      ResidualSplitPlan M cell
  | query {cell : Set (List A)}
      (action : A)
      (safe : ResidualCell.SafeAction M cell action)
      (onFalse : ResidualSplitPlan M
        (ResidualCell.advance M cell action false))
      (onTrue : ResidualSplitPlan M
        (ResidualCell.advance M cell action true)) :
      ResidualSplitPlan M cell

namespace ResidualSplitPlan

/-- Compile a recursive residual plan to the repository's native adaptive
experiment tree. -/
def toTree
    {M : DFA A X} [DecidablePred (fun state : X => state ∈ M.accept)]
    {cell : Set (List A)} :
    ResidualSplitPlan M cell → BoolExperimentTree A
  | .done _ => .done
  | .query action _ onFalse onTrue =>
      .query action onFalse.toTree onTrue.toTree

/-- Compilation preserves the complete recursive live-cell certificate. -/
theorem toTree_residualSplitting
    {M : DFA A X} [DecidablePred (fun state : X => state ∈ M.accept)]
    {cell : Set (List A)} (plan : ResidualSplitPlan M cell) :
    plan.toTree.ResidualSplitting M cell := by
  induction plan with
  | done homogeneous => exact homogeneous
  | query action safe onFalse onTrue ihFalse ihTrue =>
      exact ⟨safe, ihFalse, ihTrue⟩

/-- Decompile a native tree carrying the recursive certificate back to the
structural plan that justifies it. -/
def ofTree
    (M : DFA A X) [DecidablePred (fun state : X => state ∈ M.accept)] :
    (tree : BoolExperimentTree A) → (cell : Set (List A)) →
      tree.ResidualSplitting M cell → ResidualSplitPlan M cell
  | .done, _cell, homogeneous => .done homogeneous
  | .query action onFalse onTrue, cell, splitting =>
      .query action splitting.1
        (ofTree M onFalse
          (ResidualCell.advance M cell action false) splitting.2.1)
        (ofTree M onTrue
          (ResidualCell.advance M cell action true) splitting.2.2)

/-- Decompiling and recompiling preserves the native tree exactly. -/
theorem toTree_ofTree
    (M : DFA A X) [DecidablePred (fun state : X => state ∈ M.accept)]
    (tree : BoolExperimentTree A) (cell : Set (List A))
    (splitting : tree.ResidualSplitting M cell) :
    (ofTree M tree cell splitting).toTree = tree := by
  induction tree generalizing cell with
  | done => rfl
  | query action onFalse onTrue ihFalse ihTrue =>
      simp only [ofTree, toTree]
      rw [ihFalse, ihTrue]

/-- Exact conditional ADS existence on one live cell: a recursive splitting
plan exists if and only if a native residual-separating tree exists.  The
current-constant premise is precisely the live-cell invariant needed by the
previous characterization theorem. -/
theorem nonempty_iff_exists_separatingTree
    (M : DFA A X) [DecidablePred (fun state : X => state ∈ M.accept)]
    (cell : Set (List A)) (constant : ResidualCell.CurrentConstant M cell) :
    Nonempty (ResidualSplitPlan M cell) ↔
      ∃ tree : BoolExperimentTree A,
        tree.SeparatesPrefixResidualsOn M cell := by
  constructor
  · rintro ⟨plan⟩
    exact ⟨plan.toTree,
      (BoolExperimentTree.residualSplitting_iff_separatesOn
        M plan.toTree cell constant).1 plan.toTree_residualSplitting⟩
  · rintro ⟨tree, separates⟩
    have splitting : tree.ResidualSplitting M cell :=
      (BoolExperimentTree.residualSplitting_iff_separatesOn
        M tree cell constant).2 separates
    exact ⟨ofTree M tree cell splitting⟩

end ResidualSplitPlan

end Pairfield
