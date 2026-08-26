/-
Copyright (c) 2026 Avik Jain and the mathematics collaboration.
Released under Apache 2.0 license.

A checked adapter from finite prefix-residual cells to the exact square
potential law.  The finite carrier contains one representative of each live
Mathlib residual; this hypothesis is essential because different prefixes
may reach the same residual language.
-/
import Pairfield.AdaptiveSplitPotential

namespace Pairfield

universe u v

variable {A : Type u} {X : Type v}

namespace ResidualPotentialAdapter

noncomputable section

variable [DecidableEq A]

local instance languageDecidableEq :
    DecidableEq (Language A) := Classical.decEq _

/-- The Boolean response obtained after applying the proposed action. -/
def postResponse
    (M : DFA A X) [DecidablePred (fun state : X => state ∈ M.accept)]
    (action : A) (pre : List A) : Bool :=
  acceptsBool M (M.eval (pre ++ [action]))

/-- The advanced candidate is the actual Mathlib residual language, not the
raw prefix that presents it. -/
def advanceResidual (M : DFA A X) (action : A) (pre : List A) : Language A :=
  BranchResidual M (pre ++ [action])

/-- A finite prefix cell is reduced when it contains at most one presenter of
each residual language. -/
def DistinctRepresentatives (M : DFA A X)
    (cell : Finset (List A)) : Prop :=
  ∀ {left right : List A},
    left ∈ cell → right ∈ cell →
    BranchResidual M left = BranchResidual M right → left = right

/-- Mathlib's exact `Language.leftQuotient_append` theorem is the update law
implemented by the native branch adapter. -/
theorem advanceResidual_eq_leftQuotient
    (M : DFA A X) (action : A) (pre : List A) :
    advanceResidual M action pre =
      (BranchResidual M pre).leftQuotient [action] := by
  exact Language.leftQuotient_append M.accepts pre [action]

/-- The native post-action bit is the empty-word acceptance bit of the
advanced Mathlib residual. -/
theorem postResponse_eq_true_iff_nil_mem
    (M : DFA A X) [DecidablePred (fun state : X => state ∈ M.accept)]
    (action : A) (pre : List A) :
    postResponse M action pre = true ↔
      [] ∈ advanceResidual M action pre := by
  simp [postResponse, advanceResidual, BranchResidual, acceptsBool,
    Language.mem_leftQuotient, DFA.mem_accepts]

/-- On a reduced finite representative cell, the recursive residual-safety
law is exactly strong enough for formation's fiberwise-injective advance. -/
theorem safeAdvance_of_residualSafe
    (M : DFA A X) [DecidablePred (fun state : X => state ∈ M.accept)]
    (cell : Finset (List A)) (action : A)
    (hdistinct : DistinctRepresentatives M cell)
    (hsafe : ResidualCell.SafeAction M (↑cell : Set (List A)) action) :
    FiniteLiveCell.SafeAdvance cell (postResponse M action)
      (advanceResidual M action) := by
  intro left right hleft hright _hresponse hadvanced
  apply hdistinct hleft hright
  exact hsafe hleft hright hadvanced

/-- Conversely, fiberwise injectivity on the finite representatives implies
the repository's residual-safety law.  Equality of advanced residuals itself
supplies the response equality required by `SafeAdvance`. -/
theorem residualSafe_of_safeAdvance
    (M : DFA A X) [DecidablePred (fun state : X => state ∈ M.accept)]
    (cell : Finset (List A)) (action : A)
    (hsafe : FiniteLiveCell.SafeAdvance cell (postResponse M action)
      (advanceResidual M action)) :
    ResidualCell.SafeAction M (↑cell : Set (List A)) action := by
  intro left right hleft hright hadvanced
  have hresponse :
      postResponse M action left = postResponse M action right := by
    apply Bool.eq_iff_iff.mpr
    have hadvanced' :
        advanceResidual M action left =
          advanceResidual M action right := hadvanced
    rw [postResponse_eq_true_iff_nil_mem,
      postResponse_eq_true_iff_nil_mem, hadvanced']
  have hpresenters : left = right :=
    hsafe hleft hright hresponse hadvanced
  rw [hpresenters]

/-- The two safety formulations coincide exactly on a finite reduced
residual cell. -/
theorem safeAdvance_iff_residualSafe
    (M : DFA A X) [DecidablePred (fun state : X => state ∈ M.accept)]
    (cell : Finset (List A)) (action : A)
    (hdistinct : DistinctRepresentatives M cell) :
    FiniteLiveCell.SafeAdvance cell (postResponse M action)
        (advanceResidual M action) ↔
      ResidualCell.SafeAction M (↑cell : Set (List A)) action :=
  ⟨residualSafe_of_safeAdvance M cell action,
    safeAdvance_of_residualSafe M cell action hdistinct⟩

/-- The reciprocal quantitative result: every finite reduced residual-safe
cell consumes exactly the cross-branch term in formation's square potential. -/
theorem residualSquarePotential_split
    (M : DFA A X) [DecidablePred (fun state : X => state ∈ M.accept)]
    (cell : Finset (List A)) (action : A)
    (hdistinct : DistinctRepresentatives M cell)
    (hsafe : ResidualCell.SafeAction M (↑cell : Set (List A)) action) :
    FiniteLiveCell.squarePotential cell =
      FiniteLiveCell.squarePotential
        (FiniteLiveCell.advancedBranch cell (postResponse M action)
          (advanceResidual M action) false) +
      FiniteLiveCell.squarePotential
        (FiniteLiveCell.advancedBranch cell (postResponse M action)
          (advanceResidual M action) true) +
      2 *
        (FiniteLiveCell.advancedBranch cell (postResponse M action)
          (advanceResidual M action) false).card *
        (FiniteLiveCell.advancedBranch cell (postResponse M action)
          (advanceResidual M action) true).card := by
  classical
  exact FiniteLiveCell.squarePotential_split cell
    (postResponse M action) (advanceResidual M action)
    (safeAdvance_of_residualSafe M cell action hdistinct hsafe)

/-- Strict decrease has no extra automata hypothesis: after the checked
adapter, it occurs exactly when both Boolean residual branches are inhabited. -/
theorem residualBranchPotential_lt_iff_both_nonempty
    (M : DFA A X) [DecidablePred (fun state : X => state ∈ M.accept)]
    (cell : Finset (List A)) (action : A)
    (hdistinct : DistinctRepresentatives M cell)
    (hsafe : ResidualCell.SafeAction M (↑cell : Set (List A)) action) :
    FiniteLiveCell.squarePotential
          (FiniteLiveCell.advancedBranch cell (postResponse M action)
            (advanceResidual M action) false) +
        FiniteLiveCell.squarePotential
          (FiniteLiveCell.advancedBranch cell (postResponse M action)
            (advanceResidual M action) true) <
      FiniteLiveCell.squarePotential cell ↔
    (FiniteLiveCell.advancedBranch cell (postResponse M action)
          (advanceResidual M action) false).Nonempty ∧
      (FiniteLiveCell.advancedBranch cell (postResponse M action)
          (advanceResidual M action) true).Nonempty := by
  classical
  exact FiniteLiveCell.branchPotential_lt_iff_both_nonempty cell
    (postResponse M action) (advanceResidual M action)
    (safeAdvance_of_residualSafe M cell action hdistinct hsafe)

namespace Control

/-- One residual can have several prefix presenters even in the smallest DFA. -/
def loopAutomaton : DFA Unit Unit where
  step := fun _ _ => ()
  start := ()
  accept := ∅

instance : DecidablePred
    (fun state : Unit => state ∈ loopAutomaton.accept) :=
  fun state => inferInstanceAs (Decidable (state ∈ (∅ : Set Unit)))

def duplicateCell : Finset (List Unit) := {[], [()]}

theorem loop_residual_eq (left right : List Unit) :
    BranchResidual loopAutomaton left =
      BranchResidual loopAutomaton right := by
  calc
    BranchResidual loopAutomaton left =
        stateLanguage loopAutomaton (loopAutomaton.eval left) :=
      leftQuotient_eq_stateLanguage_eval loopAutomaton left
    _ = stateLanguage loopAutomaton (loopAutomaton.eval right) := by
      congr
    _ = BranchResidual loopAutomaton right :=
      (leftQuotient_eq_stateLanguage_eval loopAutomaton right).symm

/-- Residual safety alone is true on the duplicate-prefix cell. -/
theorem duplicateCell_residualSafe :
    ResidualCell.SafeAction loopAutomaton
      (↑duplicateCell : Set (List Unit)) () := by
  intro left right _hleft _hright _hadvanced
  exact loop_residual_eq left right

/-- The reduced-representative premise is load-bearing: the two distinct
prefixes in `duplicateCell` denote the same residual. -/
theorem duplicateCell_not_distinct :
    ¬ DistinctRepresentatives loopAutomaton duplicateCell := by
  intro hdistinct
  have hpresenters : ([] : List Unit) = [()] :=
    hdistinct (by simp [duplicateCell]) (by simp [duplicateCell])
      (loop_residual_eq [] [()])
  simp at hpresenters

end Control

end

end ResidualPotentialAdapter

end Pairfield
