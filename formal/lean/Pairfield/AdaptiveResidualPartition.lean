/-
Copyright (c) 2026 Avik Jain and the mathematics collaboration.
Released under Apache 2.0 license.

The recursive live-cell invariant for residual-labelled adaptive
distinguishing trees.  A live cell contains exactly those reached prefixes
whose observations so far agree.  A query must be safe on that cell and its
two continuation trees must recursively split the response-selected advanced
cells.
-/
import Pairfield.AdaptiveResidualSplitting
import Pairfield.LinearAdaptiveGap

namespace Pairfield

universe u v

variable {A : Type u} {X : Type v}

/-- All prefixes in a live cell have the same currently visible output. -/
def ResidualCell.CurrentConstant
    (M : DFA A X) [DecidablePred (fun state : X => state ∈ M.accept)]
    (cell : Set (List A)) : Prop :=
  ∀ ⦃left right : List A⦄,
    cell left → cell right →
    acceptsBool M (M.eval left) = acceptsBool M (M.eval right)

/-- A leaf is valid exactly when every prefix still live there has the same
Mathlib residual language. -/
def ResidualCell.Homogeneous (M : DFA A X) (cell : Set (List A)) : Prop :=
  ∀ ⦃left right : List A⦄,
    cell left → cell right →
    BranchResidual M left = BranchResidual M right

/-- Apply one action to every prefix in a live cell and retain precisely the
advanced prefixes producing the declared response. -/
def ResidualCell.advance
    (M : DFA A X) [DecidablePred (fun state : X => state ∈ M.accept)]
    (cell : Set (List A)) (action : A) (response : Bool) :
    Set (List A) :=
  { next | ∃ pre, cell pre ∧ next = pre ++ [action] ∧
      acceptsBool M (M.eval next) = response }

/-- Every advanced response cell is again constant at its current output. -/
theorem ResidualCell.advance_currentConstant
    (M : DFA A X) [DecidablePred (fun state : X => state ∈ M.accept)]
    (cell : Set (List A)) (action : A) (response : Bool) :
    ResidualCell.CurrentConstant M
      (ResidualCell.advance M cell action response) := by
  intro left right hleft hright
  rcases hleft with ⟨leftPre, _hleftPre, rfl, hleftResponse⟩
  rcases hright with ⟨rightPre, _hrightPre, rfl, hrightResponse⟩
  exact hleftResponse.trans hrightResponse.symm

/-- A root action is safe on one live cell when equality after the action
cannot merge two distinct residuals in that cell.  Current-output equality is
not repeated here because `CurrentConstant` is the live-cell invariant. -/
def ResidualCell.SafeAction
    (M : DFA A X) (cell : Set (List A)) (action : A) : Prop :=
  ∀ ⦃left right : List A⦄,
    cell left → cell right →
    BranchResidual M (left ++ [action]) =
      BranchResidual M (right ++ [action]) →
    BranchResidual M left = BranchResidual M right

/-- A tree separates residuals on a declared live cell. -/
def BoolExperimentTree.SeparatesPrefixResidualsOn
    (M : DFA A X) [DecidablePred (fun state : X => state ∈ M.accept)]
    (tree : BoolExperimentTree A) (cell : Set (List A)) : Prop :=
  ∀ ⦃left right : List A⦄,
    cell left → cell right →
    BranchTrace M tree left = BranchTrace M tree right →
    BranchResidual M left = BranchResidual M right

/-- A root query trace is the free current bit followed by the chosen child's
trace at the advanced prefix. -/
theorem branchTrace_query
    (M : DFA A X) [DecidablePred (fun state : X => state ∈ M.accept)]
    (action : A) (onFalse onTrue : BoolExperimentTree A) (pre : List A) :
    BranchTrace M (.query action onFalse onTrue) pre =
      acceptsBool M (M.eval pre) ::
        BranchTrace M
          (if acceptsBool M (M.eval (pre ++ [action]))
            then onTrue else onFalse)
          (pre ++ [action]) := by
  simp only [BranchTrace, BoolExperimentTree.trace,
    BoolExperimentTree.responses, DFA.eval_append_singleton]
  cases acceptsBool M (M.step (M.eval pre) action) <;> rfl

/-- The recursive certificate carried by a residual-labelled adaptive tree. -/
def BoolExperimentTree.ResidualSplitting
    (M : DFA A X) [DecidablePred (fun state : X => state ∈ M.accept)] :
    BoolExperimentTree A → Set (List A) → Prop
  | .done, cell => ResidualCell.Homogeneous M cell
  | .query action onFalse onTrue, cell =>
      ResidualCell.SafeAction M cell action ∧
        onFalse.ResidualSplitting M
          (ResidualCell.advance M cell action false) ∧
        onTrue.ResidualSplitting M
          (ResidualCell.advance M cell action true)

/-- The recursive safety/partition certificate is exactly residual separation
on a live cell.  This is the checked global invariant missing from the local
safe-root theorem. -/
theorem BoolExperimentTree.residualSplitting_iff_separatesOn
    (M : DFA A X) [DecidablePred (fun state : X => state ∈ M.accept)]
    (tree : BoolExperimentTree A) (cell : Set (List A))
    (hconstant : ResidualCell.CurrentConstant M cell) :
    tree.ResidualSplitting M cell ↔
      tree.SeparatesPrefixResidualsOn M cell := by
  revert cell
  induction tree with
  | done =>
      intro cell hconstant
      constructor
      · intro hhomogeneous left right hleft hright _htrace
        exact hhomogeneous hleft hright
      · intro hseparates left right hleft hright
        apply hseparates hleft hright
        simpa [BranchTrace, BoolExperimentTree.trace,
          BoolExperimentTree.responses] using
          congrArg (fun response => [response])
            (hconstant hleft hright)
  | query action onFalse onTrue ihFalse ihTrue =>
      intro cell hconstant
      constructor
      · rintro ⟨hsafe, hfalseSplit, htrueSplit⟩
        have hfalseSeparates :=
          (ihFalse (ResidualCell.advance M cell action false)
            (ResidualCell.advance_currentConstant
              M cell action false)).1 hfalseSplit
        have htrueSeparates :=
          (ihTrue (ResidualCell.advance M cell action true)
            (ResidualCell.advance_currentConstant
              M cell action true)).1 htrueSplit
        intro left right hleft hright htrace
        rw [branchTrace_query, branchTrace_query] at htrace
        have hcurrent :
            acceptsBool M (M.eval left) =
              acceptsBool M (M.eval right) :=
          List.cons.inj htrace |>.1
        have hchild := List.cons.inj htrace |>.2
        have hresponse :
            acceptsBool M (M.eval (left ++ [action])) =
              acceptsBool M (M.eval (right ++ [action])) := by
          exact List.cons.inj hchild |>.1
        cases hleftResponse :
            acceptsBool M (M.eval (left ++ [action])) with
        | false =>
            have hrightResponse :
                acceptsBool M (M.eval (right ++ [action])) = false := by
              rw [← hresponse, hleftResponse]
            have hleftResponseStep :
                acceptsBool M (M.step (M.eval left) action) = false := by
              simpa [DFA.eval_append_singleton] using hleftResponse
            have hrightResponseStep :
                acceptsBool M (M.step (M.eval right) action) = false := by
              simpa [DFA.eval_append_singleton] using hrightResponse
            have hchildBranch :
                BranchTrace M onFalse (left ++ [action]) =
                  BranchTrace M onFalse (right ++ [action]) := by
              simpa [hleftResponseStep, hrightResponseStep] using hchild
            have hadvanced := hfalseSeparates
              ⟨left, hleft, rfl, hleftResponse⟩
              ⟨right, hright, rfl, hrightResponse⟩
              hchildBranch
            exact hsafe hleft hright hadvanced
        | true =>
            have hrightResponse :
                acceptsBool M (M.eval (right ++ [action])) = true := by
              rw [← hresponse, hleftResponse]
            have hleftResponseStep :
                acceptsBool M (M.step (M.eval left) action) = true := by
              simpa [DFA.eval_append_singleton] using hleftResponse
            have hrightResponseStep :
                acceptsBool M (M.step (M.eval right) action) = true := by
              simpa [DFA.eval_append_singleton] using hrightResponse
            have hchildBranch :
                BranchTrace M onTrue (left ++ [action]) =
                  BranchTrace M onTrue (right ++ [action]) := by
              simpa [hleftResponseStep, hrightResponseStep] using hchild
            have hadvanced := htrueSeparates
              ⟨left, hleft, rfl, hleftResponse⟩
              ⟨right, hright, rfl, hrightResponse⟩
              hchildBranch
            exact hsafe hleft hright hadvanced
      · intro hseparates
        have hsafe : ResidualCell.SafeAction M cell action := by
          intro left right hleft hright hadvanced
          apply hseparates hleft hright
          have hfalse :=
            branchTrace_eq_of_branchResidual_eq M onFalse hadvanced
          have htrue :=
            branchTrace_eq_of_branchResidual_eq M onTrue hadvanced
          have hnext :
              acceptsBool M (M.eval (left ++ [action])) =
                acceptsBool M (M.eval (right ++ [action])) := by
            simpa [BranchTrace, BoolExperimentTree.trace,
              BoolExperimentTree.responses] using
              List.cons.inj hfalse |>.1
          rw [branchTrace_query, branchTrace_query]
          rw [hconstant hleft hright]
          cases hleftResponse :
              acceptsBool M (M.eval (left ++ [action])) with
          | false =>
              have hrightResponse :
                  acceptsBool M (M.eval (right ++ [action])) = false := by
                rw [← hnext, hleftResponse]
              have hrightResponseStep :
                  acceptsBool M (M.step (M.eval right) action) = false := by
                simpa [DFA.eval_append_singleton] using hrightResponse
              simp [hrightResponseStep, hfalse]
          | true =>
              have hrightResponse :
                  acceptsBool M (M.eval (right ++ [action])) = true := by
                rw [← hnext, hleftResponse]
              have hrightResponseStep :
                  acceptsBool M (M.step (M.eval right) action) = true := by
                simpa [DFA.eval_append_singleton] using hrightResponse
              simp [hrightResponseStep, htrue]
        refine ⟨hsafe, ?_, ?_⟩
        · apply (ihFalse (ResidualCell.advance M cell action false)
            (ResidualCell.advance_currentConstant
              M cell action false)).2
          intro leftNext rightNext hleftNext hrightNext hchild
          rcases hleftNext with ⟨left, hleft, rfl, hleftResponse⟩
          rcases hrightNext with ⟨right, hright, rfl, hrightResponse⟩
          have horiginal :
              BranchResidual M left = BranchResidual M right := by
            apply hseparates hleft hright
            rw [branchTrace_query, branchTrace_query]
            rw [hconstant hleft hright]
            have hleftResponseStep :
                acceptsBool M (M.step (M.eval left) action) = false := by
              simpa [DFA.eval_append_singleton] using hleftResponse
            have hrightResponseStep :
                acceptsBool M (M.step (M.eval right) action) = false := by
              simpa [DFA.eval_append_singleton] using hrightResponse
            simp [hleftResponseStep, hrightResponseStep, hchild]
          exact prefixResidual_append_action_eq_of_eq
            M horiginal action
        · apply (ihTrue (ResidualCell.advance M cell action true)
            (ResidualCell.advance_currentConstant
              M cell action true)).2
          intro leftNext rightNext hleftNext hrightNext hchild
          rcases hleftNext with ⟨left, hleft, rfl, hleftResponse⟩
          rcases hrightNext with ⟨right, hright, rfl, hrightResponse⟩
          have horiginal :
              BranchResidual M left = BranchResidual M right := by
            apply hseparates hleft hright
            rw [branchTrace_query, branchTrace_query]
            rw [hconstant hleft hright]
            have hleftResponseStep :
                acceptsBool M (M.step (M.eval left) action) = true := by
              simpa [DFA.eval_append_singleton] using hleftResponse
            have hrightResponseStep :
                acceptsBool M (M.step (M.eval right) action) = true := by
              simpa [DFA.eval_append_singleton] using hrightResponse
            simp [hleftResponseStep, hrightResponseStep, hchild]
          exact prefixResidual_append_action_eq_of_eq
            M horiginal action

/-- Prefixes with a declared current output form the initial live cells. -/
def ResidualCell.initial
    (M : DFA A X) [DecidablePred (fun state : X => state ∈ M.accept)]
    (response : Bool) : Set (List A) :=
  { pre | acceptsBool M (M.eval pre) = response }

theorem ResidualCell.initial_currentConstant
    (M : DFA A X) [DecidablePred (fun state : X => state ∈ M.accept)]
    (response : Bool) :
    ResidualCell.CurrentConstant M (ResidualCell.initial M response) := by
  intro left right hleft hright
  exact hleft.trans hright.symm

/-- Global prefix-residual separation is equivalent to carrying a recursive
splitting certificate on both free-current-output fibers. -/
theorem BoolExperimentTree.separatesPrefixResiduals_iff_initialSplitting
    (M : DFA A X) [DecidablePred (fun state : X => state ∈ M.accept)]
    (tree : BoolExperimentTree A) :
    tree.SeparatesPrefixResiduals M ↔
      ∀ response : Bool,
        tree.ResidualSplitting M (ResidualCell.initial M response) := by
  constructor
  · intro hseparates response
    apply (tree.residualSplitting_iff_separatesOn M
      (ResidualCell.initial M response)
      (ResidualCell.initial_currentConstant M response)).2
    intro left right hleft hright htrace
    exact hseparates left right htrace
  · intro hsplitting left right htrace
    have hcurrent :
        acceptsBool M (M.eval left) = acceptsBool M (M.eval right) := by
      exact List.cons.inj (by simpa [BranchTrace,
        BoolExperimentTree.trace] using htrace) |>.1
    let response := acceptsBool M (M.eval left)
    have hleft : ResidualCell.initial M response left := rfl
    have hright : ResidualCell.initial M response right := by
      exact hcurrent.symm
    have hseparates :=
      (tree.residualSplitting_iff_separatesOn M
        (ResidualCell.initial M response)
        (ResidualCell.initial_currentConstant M response)).1
        (hsplitting response)
    exact hseparates hleft hright htrace

namespace AdaptiveResidualPartitionControl

open ReachableAdaptiveObservableHorizonWitness

theorem acceptsBool_automaton :
    acceptsBool automaton = observe := by
  funext state
  fin_cases state <;> decide

/-- The all-reachable `1/1/2` witness is a positive control: its native
identifying tree separates every reached Mathlib prefix residual. -/
theorem adaptiveTree_separatesPrefixResiduals :
    adaptiveTree.SeparatesPrefixResiduals automaton := by
  intro left right htrace
  have heval : automaton.eval left = automaton.eval right := by
    apply adaptiveTree_identifies
    rw [← acceptsBool_automaton]
    change
      adaptiveTree.trace automaton.step (acceptsBool automaton)
          (automaton.eval left) =
        adaptiveTree.trace automaton.step (acceptsBool automaton)
          (automaton.eval right)
    simpa [BranchTrace] using htrace
  calc
    BranchResidual automaton left =
        stateLanguage automaton (automaton.eval left) :=
      leftQuotient_eq_stateLanguage_eval automaton left
    _ = stateLanguage automaton (automaton.eval right) := by rw [heval]
    _ = BranchResidual automaton right :=
      (leftQuotient_eq_stateLanguage_eval automaton right).symm

/-- Consequently the same depth-two tree carries the full recursive
safe-action/live-cell certificate on both free-current-output fibers. -/
theorem adaptiveTree_initialResidualSplitting :
    ∀ response : Bool,
      adaptiveTree.ResidualSplitting automaton
        (ResidualCell.initial automaton response) :=
  (BoolExperimentTree.separatesPrefixResiduals_iff_initialSplitting
    automaton adaptiveTree).1 adaptiveTree_separatesPrefixResiduals

end AdaptiveResidualPartitionControl

namespace LinearAdaptiveResidualPartitionControl

open LinearAdaptiveGap

/-- Every member of the reachable linear-gap family transports from native
state identification to separation of its reached Mathlib residuals. -/
theorem omitOneTree_separatesPrefixResiduals {n : Nat}
    (omitted : Fin n) :
    (omitOneTree omitted).SeparatesPrefixResiduals (automaton n) := by
  intro left right htrace
  have heval : (automaton n).eval left = (automaton n).eval right := by
    apply omitOneTree_identifies omitted
    rw [← acceptsBool_automaton n]
    change
      (omitOneTree omitted).trace (automaton n).step
          (acceptsBool (automaton n)) ((automaton n).eval left) =
        (omitOneTree omitted).trace (automaton n).step
          (acceptsBool (automaton n)) ((automaton n).eval right)
    simpa [BranchTrace] using htrace
  calc
    BranchResidual (automaton n) left =
        stateLanguage (automaton n) ((automaton n).eval left) :=
      leftQuotient_eq_stateLanguage_eval (automaton n) left
    _ = stateLanguage (automaton n) ((automaton n).eval right) := by
      rw [heval]
    _ = BranchResidual (automaton n) right :=
      (leftQuotient_eq_stateLanguage_eval (automaton n) right).symm

/-- The symbolic depth-`n-1` family therefore carries the same recursive
safe-action/live-cell certificate for every `n` and every omitted state. -/
theorem omitOneTree_initialResidualSplitting {n : Nat}
    (omitted : Fin n) :
    ∀ response : Bool,
      (omitOneTree omitted).ResidualSplitting (automaton n)
        (ResidualCell.initial (automaton n) response) :=
  (BoolExperimentTree.separatesPrefixResiduals_iff_initialSplitting
    (automaton n) (omitOneTree omitted)).1
      (omitOneTree_separatesPrefixResiduals omitted)

end LinearAdaptiveResidualPartitionControl

end Pairfield
