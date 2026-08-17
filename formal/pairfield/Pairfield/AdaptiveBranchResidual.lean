/-
Copyright (c) 2026 Avik Jain and the mathematics collaboration.
Released under Apache 2.0 license.

The branch-conditioned carrier for an adaptive experiment is the prefix
left-quotient.  This is deliberately a small naming/transport layer: it does
not identify adaptive depth with a uniform word horizon.
-/
import Pairfield.AdaptiveResidualAdapter

namespace Pairfield

universe u v

variable {A : Type u} {X : Type v}

/-- The residual carried by the branch reached through `prefix`. -/
def BranchResidual (M : DFA A X) (pre : List A) :=
  M.accepts.leftQuotient pre

/-- The observation trace of a tree when entered at a reached prefix. -/
def BranchTrace (M : DFA A X) (tree : BoolExperimentTree A)
    [DecidablePred (fun state : X => state ∈ M.accept)]
    (pre : List A) : List Bool :=
  tree.trace M.step (acceptsBool M) (M.eval pre)

/-- Adaptive observation factors through the branch residual carrier. -/
theorem branchTrace_eq_of_branchResidual_eq
    (M : DFA A X) [DecidablePred (fun state : X => state ∈ M.accept)]
    (tree : BoolExperimentTree A) {left right : List A}
    (hresidual : BranchResidual M left = BranchResidual M right) :
    BranchTrace M tree left = BranchTrace M tree right := by
  simpa [BranchTrace] using
    (leftQuotient_eq_iff_all_adaptive_traces_eq M left right).1 hresidual tree

/-- Advancing a branch by an action is the residual left-quotient update. -/
theorem branchResidual_step
    (M : DFA A X) (pre : List A) (action : A) :
    BranchResidual M (pre ++ [action]) =
      (BranchResidual M pre).leftQuotient [action] := by
  exact prefixResidual_append_action M pre action

end Pairfield
