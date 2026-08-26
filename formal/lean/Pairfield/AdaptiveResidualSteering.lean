/-
Copyright (c) 2026 Avik Jain and the mathematics collaboration.
Released under Apache 2.0 license.

The exact canonical-DFA adapter for prefix residuals, and the cardinality
no-go for safe constant-response steering.
-/
import Pairfield.AdaptiveResidualPotentialAdapter

namespace Pairfield

universe u v w

variable {A : Type u} {X : Type v}

namespace CanonicalResidualAdapter

/-- A native prefix residual packaged as an actual state of Mathlib's
canonical left-quotient automaton. -/
def branchState (M : DFA A X) (pre : List A) :
    Set.range M.accepts.leftQuotient :=
  ⟨BranchResidual M pre, ⟨pre, rfl⟩⟩

/-- Checked adapter square.  Advancing the native prefix and stepping
Mathlib's canonical residual DFA are literally the same state transition.
The load-bearing library theorem is `Language.step_toDFA`. -/
theorem branchState_step (M : DFA A X) (pre : List A) (action : A) :
    M.accepts.toDFA.step (branchState M pre) action =
      branchState M (pre ++ [action]) := by
  apply Subtype.ext
  calc
    (M.accepts.toDFA.step (branchState M pre) action).val =
        (BranchResidual M pre).leftQuotient [action] :=
      Language.step_toDFA (branchState M pre) action
    _ = BranchResidual M (pre ++ [action]) :=
      (branchResidual_step M pre action).symm

/-- The one-step square iterates to every native action word. -/
theorem branchState_evalFrom (M : DFA A X) (pre word : List A) :
    M.accepts.toDFA.evalFrom (branchState M pre) word =
      branchState M (pre ++ word) := by
  induction word generalizing pre with
  | nil => simp [branchState]
  | cons action rest ih =>
      rw [DFA.evalFrom_cons, branchState_step]
      simpa [List.append_assoc] using ih (pre := pre ++ [action])

/-- The native reached-state acceptance bit is exactly Mathlib's accepting
predicate on the packaged residual state. -/
theorem branchState_mem_accept_iff
    (M : DFA A X) (pre : List A) :
    branchState M pre ∈ M.accepts.toDFA.accept ↔
      M.eval pre ∈ M.accept := by
  rw [Language.mem_accept_toDFA]
  simp [branchState, BranchResidual, Language.mem_leftQuotient,
    DFA.mem_accepts]

end CanonicalResidualAdapter

namespace FiniteLiveCell

variable {Candidate : Type u} {Next : Type v} {Score : Type w}
variable [DecidableEq Candidate] [DecidableEq Next]

/-- If every live candidate returns the declared answer, that response fiber
is the whole live cell. -/
theorem responseFiber_eq_cell_of_constant
    (cell : Finset Candidate) (response : Candidate → Bool) (answer : Bool)
    (hconstant : ∀ candidate ∈ cell, response candidate = answer) :
    responseFiber cell response answer = cell := by
  ext candidate
  simp only [responseFiber, Finset.mem_filter]
  constructor
  · exact fun h => h.1
  · intro hcell
    exact ⟨hcell, hconstant candidate hcell⟩

/-- A safe constant-response action preserves the exact live cardinality even
when it moves every candidate. -/
theorem card_advancedBranch_eq_of_constant
    (cell : Finset Candidate) (response : Candidate → Bool)
    (advance : Candidate → Next) (answer : Bool)
    (hsafe : SafeAdvance cell response advance)
    (hconstant : ∀ candidate ∈ cell, response candidate = answer) :
    (advancedBranch cell response advance answer).card = cell.card := by
  rw [card_advancedBranch cell response advance answer hsafe,
    responseFiber_eq_cell_of_constant cell response answer hconstant]

/-- Universal no-go: every proposed progress measure that factors only
through live-cell cardinality is blind to safe constant-response steering. -/
theorem cardinalScore_invariant_of_constant
    (score : Nat → Score)
    (cell : Finset Candidate) (response : Candidate → Bool)
    (advance : Candidate → Next) (answer : Bool)
    (hsafe : SafeAdvance cell response advance)
    (hconstant : ∀ candidate ∈ cell, response candidate = answer) :
    score (advancedBranch cell response advance answer).card =
      score cell.card := by
  rw [card_advancedBranch_eq_of_constant cell response advance answer
    hsafe hconstant]

namespace Control

/-- Constant output with Boolean negation is safe and is not the identity
action: it moves both candidates while preserving cardinality. -/
theorem constantFalse_not_safe :
    SafeAdvance ({false, true} : Finset Bool) (fun _ => false) Bool.not := by
  intro left right _hleft _hright _hresponse hadvance
  have hback := congrArg Bool.not hadvance
  simpa using hback

theorem constantFalse_not_moves_every_candidate :
    ∀ candidate ∈ ({false, true} : Finset Bool),
      Bool.not candidate ≠ candidate := by
  decide

/-- The universal no-go fires on a genuinely moving action, for every
cardinality-indexed family of types. -/
theorem constantFalse_not_cardinalScore_invariant
    (score : Nat → Score) :
    score
        (advancedBranch ({false, true} : Finset Bool) (fun _ => false)
          Bool.not false).card =
      score ({false, true} : Finset Bool).card := by
  apply cardinalScore_invariant_of_constant score
      ({false, true} : Finset Bool) (fun _ => false) Bool.not false
      constantFalse_not_safe
  intro candidate hcandidate
  rfl

end Control

end FiniteLiveCell

namespace ResidualPotentialAdapter

noncomputable section

variable [DecidableEq A]

variable {Score : Type w}

/-- Same text as `AdaptiveResidualPotentialAdapter.languageDecidableEq`
(census, 2026-08-22), and kept separate on purpose: both are `local`, and the
whole content of `local` is that a classical decision procedure for language
equality is admitted inside one file and nowhere else.  Factoring it into a
shared module would promote it to a global instance — the one consequence the
`local` keyword is there to prevent.  The name differs only to keep the two
readable side by side in an `open`ed context. -/
local instance steeringLanguageDecidableEq :
    DecidableEq (Language A) := Classical.decEq _

/-- Reciprocal automata result.  On a reduced finite cell, a residual-safe
action with constant post-response preserves every cardinality-only score.
The advanced objects are native `BranchResidual`s, whose transition is the
canonical `Language.toDFA.step` by `CanonicalResidualAdapter.branchState_step`.
-/
theorem residualCardinalScore_invariant_of_constant
    (score : Nat → Score)
    (M : DFA A X) [DecidablePred (fun state : X => state ∈ M.accept)]
    (cell : Finset (List A)) (action : A) (answer : Bool)
    (hdistinct : DistinctRepresentatives M cell)
    (hsafe : ResidualCell.SafeAction M (↑cell : Set (List A)) action)
    (hconstant : ∀ pre ∈ cell, postResponse M action pre = answer) :
    score
        (FiniteLiveCell.advancedBranch cell (postResponse M action)
          (advanceResidual M action) answer).card =
      score cell.card := by
  classical
  exact FiniteLiveCell.cardinalScore_invariant_of_constant score cell
    (postResponse M action) (advanceResidual M action) answer
    (safeAdvance_of_residualSafe M cell action hdistinct hsafe) hconstant

end

end ResidualPotentialAdapter

end Pairfield
