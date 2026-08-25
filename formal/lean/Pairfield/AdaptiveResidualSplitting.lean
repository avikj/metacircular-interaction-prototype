/-
Copyright (c) 2026 Avik Jain and the mathematics collaboration.
Released under Apache 2.0 license.

The local admissibility condition for a residual-labelled adaptive
distinguishing tree.  A query may be placed at the root only if equality of
the free current output and equality of the advanced Mathlib residual force
equality of the original residual.
-/
import Pairfield.AdaptiveDistinguishingTransport

namespace Pairfield

universe u v

variable {A : Type u} {X : Type v}

/-- A root action is safe on prefix residuals when it does not merge two
distinct residuals that have the same free current output. -/
def PrefixResidualSafeAction
    (M : DFA A X) [DecidablePred (fun state : X => state ∈ M.accept)]
    (action : A) : Prop :=
  ∀ left right : List A,
    acceptsBool M (M.eval left) = acceptsBool M (M.eval right) →
    BranchResidual M (left ++ [action]) =
      BranchResidual M (right ++ [action]) →
    BranchResidual M left = BranchResidual M right

/-- A native experiment separates prefix residuals when equal native traces
can occur only at equal Mathlib left quotients. -/
def BoolExperimentTree.SeparatesPrefixResiduals
    (M : DFA A X) [DecidablePred (fun state : X => state ∈ M.accept)]
    (tree : BoolExperimentTree A) : Prop :=
  ∀ left right : List A,
    BranchTrace M tree left = BranchTrace M tree right →
    BranchResidual M left = BranchResidual M right

/-- Every residual-separating query tree has a safe root action.

The proof is the checked splitting-tree obstruction.  If the two advanced
left quotients agree, `leftQuotient_eq_iff_all_adaptive_traces_eq` makes the
response-selected child traces agree.  Equal free current outputs then make
the complete root traces agree, so residual separation forces equality before
the action. -/
theorem prefixResidualSafeAction_of_query_separates
    (M : DFA A X) [DecidablePred (fun state : X => state ∈ M.accept)]
    (action : A) (onFalse onTrue : BoolExperimentTree A)
    (hseparates :
      (BoolExperimentTree.query action onFalse onTrue).SeparatesPrefixResiduals M) :
    PrefixResidualSafeAction M action := by
  intro left right hcurrent hadvanced
  apply hseparates left right
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
  cases hresponse : acceptsBool M (M.eval (left ++ [action])) with
  | false =>
      have hresponseRight :
          acceptsBool M (M.eval (right ++ [action])) = false := by
        rw [← hnext, hresponse]
      have hresponseStep :
          acceptsBool M (M.step (M.eval left) action) = false := by
        simpa [DFA.eval_append_singleton] using hresponse
      have hresponseRightStep :
          acceptsBool M (M.step (M.eval right) action) = false := by
        simpa [DFA.eval_append_singleton] using hresponseRight
      simpa [BranchTrace, BoolExperimentTree.trace,
        BoolExperimentTree.responses, DFA.eval_append_singleton,
        hcurrent, hresponseStep, hresponseRightStep] using hfalse
  | true =>
      have hresponseRight :
          acceptsBool M (M.eval (right ++ [action])) = true := by
        rw [← hnext, hresponse]
      have hresponseStep :
          acceptsBool M (M.step (M.eval left) action) = true := by
        simpa [DFA.eval_append_singleton] using hresponse
      have hresponseRightStep :
          acceptsBool M (M.step (M.eval right) action) = true := by
        simpa [DFA.eval_append_singleton] using hresponseRight
      simpa [BranchTrace, BoolExperimentTree.trace,
        BoolExperimentTree.responses, DFA.eval_append_singleton,
        hcurrent, hresponseStep, hresponseRightStep] using htrue

namespace AdaptiveResidualSplittingControl

/-! `reach`, `merge`, `reveal` are action labels of *this* witness's alphabet.
`AdaptiveConstantResponseSteering` names `reach`/`steer`/`reveal` with the same
three texts (`: Fin 3 := 0/1/2`, census 2026-08-22) and they are **not** the
same objects: there the actions drive a `DFA (Fin 3) (Fin 5)` in which `steer`
separates a pair `reveal` cannot, here a `DFA (Fin 3) (Fin 3)` in which `merge`
collapses one.  A label is an index into an alphabet, so identical text under
two alphabets denotes two things; sharing them would assert an identification
of the two experiments that nothing here proves. -/

/-- Three native actions: reach the second hidden state, merge both hidden
states, or reveal only the second hidden state. -/
def reach : Fin 3 := 0
def merge : Fin 3 := 1
def reveal : Fin 3 := 2

def step (state : Fin 3) (action : Fin 3) : Fin 3 :=
  if action = reach then
    if state = 0 then 1 else state
  else if action = merge then
    if state = 2 then 2 else 0
  else if state = 1 then 2 else state

def observe (state : Fin 3) : Bool := decide (state = 2)

def automaton : DFA (Fin 3) (Fin 3) where
  step := step
  start := 0
  accept := { state | observe state = true }

instance : DecidablePred (fun state : Fin 3 => state ∈ automaton.accept) :=
  fun state => inferInstanceAs (Decidable (observe state = true))

theorem eval_reach : automaton.eval [reach] = 1 := by decide

theorem eval_merge_start : automaton.eval [merge] = 0 := by decide

theorem eval_reach_merge : automaton.eval [reach, merge] = 0 := by decide

/-- The merge action is a planted-false root: it gives the same advanced
state from the two reachable hidden prefixes, although the original residuals
are separated by `reveal`. -/
theorem merge_not_safe : ¬ PrefixResidualSafeAction automaton merge := by
  intro hsafe
  have hcurrent :
      acceptsBool automaton (automaton.eval []) =
        acceptsBool automaton (automaton.eval [reach]) := by
    decide
  have hadvanced :
      BranchResidual automaton ([] ++ [merge]) =
        BranchResidual automaton ([reach] ++ [merge]) := by
    change
      stateLanguage automaton (automaton.eval ([] ++ [merge])) =
        stateLanguage automaton (automaton.eval ([reach] ++ [merge]))
    congr 1
  have hresidual := hsafe [] [reach] hcurrent hadvanced
  have hall :=
    (leftQuotient_eq_iff_all_adaptive_traces_eq
      automaton [] [reach]).1 hresidual
  have hseparates :
      (BoolExperimentTree.fixedWord [reveal]).trace automaton.step
          (acceptsBool automaton) (automaton.eval []) ≠
        (BoolExperimentTree.fixedWord [reveal]).trace automaton.step
          (acceptsBool automaton) (automaton.eval [reach]) := by
    decide
  exact hseparates (hall (BoolExperimentTree.fixedWord [reveal]))

/-- Therefore no tree rooted at the lossy merge action can separate all
reachable prefix residuals, regardless of the subtrees below it. -/
theorem no_residual_separator_rooted_at_merge
    (onFalse onTrue : BoolExperimentTree (Fin 3)) :
    ¬ (BoolExperimentTree.query merge onFalse onTrue).SeparatesPrefixResiduals
      automaton := by
  intro hseparates
  exact merge_not_safe
    (prefixResidualSafeAction_of_query_separates
      automaton merge onFalse onTrue hseparates)

end AdaptiveResidualSplittingControl

end Pairfield
