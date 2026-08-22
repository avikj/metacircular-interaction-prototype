/-
Copyright (c) 2026 Avik Jain and the mathematics collaboration.
Released under Apache 2.0 license.

An executable behavioral quotient of a supplied finite DFA.  Exact row
equality comes from `ChartStateBFS`; Mathlib's finite quotient instance turns
that decision into a native finite state carrier.
-/
-- TRUSTS-COMPILER: `ChartQuotientWitness.quotientCard_eq_three` is proved by
-- `native_decide` and therefore rests on a compiler-generated axiom
-- (`…quotientCard_eq_three._native.native_decide.ax_1_1`, Lean 4.33's
-- per-declaration form of `Lean.ofReduceBool`), i.e. on the Lean compiler
-- rather than the kernel.  It is the ONLY such declaration in the
-- lane; see `formal/pairfield/axiom-allowlist.txt` for the observed reason and
-- the removal path.  Nothing else in this file uses it, and no other module in
-- `Pairfield/` carries this header.  `lake exe yogyanupalabdhi` is what keeps that
-- true, and `scripts/check-lean-example-oracles.sh` is what keeps the
-- declaration named, so the gate can see it at all.
import Pairfield.ChartStateBFS

namespace Pairfield

universe u v

variable {A : Type u} {X : Type v}

/-- The complete-future setoid for executable Boolean acceptance. -/
abbrev dfaFutureSetoid (M : DFA A X)
    [DecidablePred (fun state : X => state ∈ M.accept)] : Setoid X :=
  futureSetoid M.step (acceptsBool M)

/-- Merge every pair of behaviorally equal DFA rows.  This construction does
not remove unreachable classes; reachability is a separate property below. -/
def behavioralQuotientDFA (M : DFA A X)
    [DecidablePred (fun state : X => state ∈ M.accept)] :
    DFA A (Quotient (dfaFutureSetoid M)) where
  step meaning action := quotientStep M.step (acceptsBool M) action meaning
  start := Quotient.mk _ M.start
  accept := { meaning |
    quotientObserve M.step (acceptsBool M) meaning = true }

instance behavioralQuotientDFA_accept_decidable
    (M : DFA A X) [DecidablePred (fun state : X => state ∈ M.accept)] :
    DecidablePred (fun meaning : Quotient (dfaFutureSetoid M) =>
      meaning ∈ (behavioralQuotientDFA M).accept) :=
  fun meaning => by
    change Decidable (quotientObserve M.step (acceptsBool M) meaning = true)
    infer_instance

theorem behavioralQuotientDFA_evalFrom_mk
    (M : DFA A X) [DecidablePred (fun state : X => state ∈ M.accept)]
    (state : X) (word : List A) :
    (behavioralQuotientDFA M).evalFrom (Quotient.mk _ state) word =
      Quotient.mk _ (M.evalFrom state word) := by
  induction word generalizing state with
  | nil => rfl
  | cons action word ih =>
      exact ih (M.step state action)

theorem behavioralQuotientDFA_eval_mk
    (M : DFA A X) [DecidablePred (fun state : X => state ∈ M.accept)]
    (word : List A) :
    (behavioralQuotientDFA M).eval word = Quotient.mk _ (M.eval word) := by
  exact behavioralQuotientDFA_evalFrom_mk M M.start word

/-- The quotient DFA's ordinary executable acceptance bit is exactly the
observation descended through the future quotient. -/
@[simp]
theorem acceptsBool_behavioralQuotientDFA
    (M : DFA A X) [DecidablePred (fun state : X => state ∈ M.accept)]
    (meaning : Quotient (dfaFutureSetoid M)) :
    acceptsBool (behavioralQuotientDFA M) meaning =
      quotientObserve M.step (acceptsBool M) meaning := by
  refine Quotient.inductionOn meaning ?_
  intro state
  rw [quotientObserve_mk]
  unfold acceptsBool
  change decide (acceptsBool M state = true) = acceptsBool M state
  cases acceptsBool M state <;> rfl

/-- Quotienting preserves the recognized language exactly. -/
theorem behavioralQuotientDFA_accepts_eq
    (M : DFA A X) [DecidablePred (fun state : X => state ∈ M.accept)] :
    (behavioralQuotientDFA M).accepts = M.accepts := by
  ext word
  rw [DFA.mem_accepts, behavioralQuotientDFA_eval_mk]
  change quotientObserve M.step (acceptsBool M)
      (Quotient.mk _ (M.eval word)) = true ↔ M.eval word ∈ M.accept
  rw [quotientObserve_mk]
  simp [acceptsBool]

/-- The quotient has no behavioral duplicates.  This is the reduction
theorem: equality under every future acceptance experiment is literal state
equality in the quotient. -/
theorem behavioralQuotientDFA_isReduced
    (M : DFA A X) [DecidablePred (fun state : X => state ∈ M.accept)] :
    ∀ {left right : Quotient (dfaFutureSetoid M)},
      FutureEq (behavioralQuotientDFA M).step
        (quotientObserve M.step (acceptsBool M)) left right →
      left = right := by
  intro left right
  refine Quotient.inductionOn₂ left right ?_
  intro x y hfuture
  apply Quotient.sound
  intro word
  have hword := hfuture word
  simp only [behavior, run_eq_evalFrom] at hword
  rw [behavioralQuotientDFA_evalFrom_mk,
    behavioralQuotientDFA_evalFrom_mk,
    quotientObserve_mk, quotientObserve_mk] at hword
  simpa only [behavior, run_eq_evalFrom] using hword

/-- Reducedness in the ordinary DFA interface, obtained by the exact
acceptance-bit comparison rather than by changing the observation language. -/
theorem behavioralQuotientDFA_isReduced_acceptsBool
    (M : DFA A X) [DecidablePred (fun state : X => state ∈ M.accept)] :
    ∀ {left right : Quotient (dfaFutureSetoid M)},
      FutureEq (behavioralQuotientDFA M).step
        (acceptsBool (behavioralQuotientDFA M)) left right →
      left = right := by
  intro left right hfuture
  apply behavioralQuotientDFA_isReduced M
  intro word
  have hword := hfuture word
  change acceptsBool (behavioralQuotientDFA M)
      (run (behavioralQuotientDFA M).step left word) =
    acceptsBool (behavioralQuotientDFA M)
      (run (behavioralQuotientDFA M).step right word) at hword
  rw [acceptsBool_behavioralQuotientDFA,
    acceptsBool_behavioralQuotientDFA] at hword
  exact hword

/-- If every input row is start-reachable, every quotient class remains
start-reachable.  Without this hypothesis the quotient merges garbage but
does not pretend to delete it. -/
theorem behavioralQuotientDFA_allStatesReachable
    (M : DFA A X) [DecidablePred (fun state : X => state ∈ M.accept)]
    (reachable : ∀ state : X, ∃ word : List A, M.eval word = state) :
    ∀ meaning : Quotient (dfaFutureSetoid M),
      ∃ word : List A, (behavioralQuotientDFA M).eval word = meaning := by
  intro meaning
  refine Quotient.inductionOn meaning ?_
  intro state
  obtain ⟨word, hword⟩ := reachable state
  refine ⟨word, ?_⟩
  rw [behavioralQuotientDFA_eval_mk, hword]

/-- Mathlib's `Quotient.fintype` becomes executable here because
`ChartStateBFS` supplies a decision procedure for the future setoid. -/
@[instance_reducible] def behavioralQuotientFintype
    [DecidableEq A] [Fintype X] (M : DFA A X)
    [DecidablePred (fun state : X => state ∈ M.accept)]
    (alphabet : List A) (complete : ∀ action : A, action ∈ alphabet) :
    Fintype (Quotient (dfaFutureSetoid M)) := by
  letI : DecidableRel (dfaFutureSetoid M).r :=
    fun left right => stateFutureEqDecidable M alphabet complete left right
  exact Quotient.fintype (dfaFutureSetoid M)

namespace FiniteBehavioralPresentation

variable {M : DFA A X} (C : FiniteBehavioralPresentation M)

/-- The executable merge quotient of the finite native chart. -/
def reducedDFA [DecidablePred (fun state : X => state ∈ M.accept)] :
    DFA A (Quotient (dfaFutureSetoid C.toDFA)) :=
  behavioralQuotientDFA C.toDFA

instance reducedDFA_accept_decidable
    [DecidablePred (fun state : X => state ∈ M.accept)] :
    DecidablePred (fun meaning : Quotient (dfaFutureSetoid C.toDFA) =>
      meaning ∈ C.reducedDFA.accept) :=
  fun meaning => by
    change Decidable
      (quotientObserve C.toDFA.step (acceptsBool C.toDFA) meaning = true)
    infer_instance

@[instance_reducible] def reducedFintype
    [DecidableEq A] [DecidablePred (fun state : X => state ∈ M.accept)]
    (alphabet : List A) (complete : ∀ action : A, action ∈ alphabet) :
    Fintype (Quotient (dfaFutureSetoid C.toDFA)) :=
  behavioralQuotientFintype C.toDFA alphabet complete

theorem reducedDFA_accepts_eq
    [DecidablePred (fun state : X => state ∈ M.accept)] :
    C.reducedDFA.accepts = M.accepts := by
  rw [reducedDFA, behavioralQuotientDFA_accepts_eq, C.accepts_eq]

theorem reducedDFA_isReduced
    [DecidablePred (fun state : X => state ∈ M.accept)] :
    ∀ {left right : Quotient (dfaFutureSetoid C.toDFA)},
      FutureEq C.reducedDFA.step
        (quotientObserve C.toDFA.step (acceptsBool C.toDFA)) left right →
      left = right :=
  behavioralQuotientDFA_isReduced C.toDFA

theorem reducedDFA_isReduced_acceptsBool
    [DecidablePred (fun state : X => state ∈ M.accept)] :
    ∀ {left right : Quotient (dfaFutureSetoid C.toDFA)},
      FutureEq C.reducedDFA.step (acceptsBool C.reducedDFA) left right →
      left = right :=
  behavioralQuotientDFA_isReduced_acceptsBool C.toDFA

theorem reducedDFA_allStatesReachable
    [DecidablePred (fun state : X => state ∈ M.accept)]
    (reachable : C.AllStatesReachable) :
    ∀ meaning : Quotient (dfaFutureSetoid C.toDFA),
      ∃ word : List A, C.reducedDFA.eval word = meaning := by
  apply behavioralQuotientDFA_allStatesReachable C.toDFA
  exact reachable

end FiniteBehavioralPresentation

namespace ChartQuotientWitness

/-- Four rows present only three futures: row `3` is an unreachable duplicate
of start row `0`. -/
def step (state : Fin 4) (action : Bool) : Fin 4 :=
  if state = 0 ∧ action = false then 1
  else if state = 1 ∧ action = true then 2
  else if state = 3 ∧ action = false then 1
  else state

def automaton : DFA Bool (Fin 4) where
  step := step
  start := 0
  accept := { state | state = 2 }

instance : DecidablePred (fun state : Fin 4 => state ∈ automaton.accept) :=
  fun state => by
    change Decidable (state = 2)
    infer_instance

def alphabet : List Bool := [false, true]

theorem alphabet_complete (action : Bool) : action ∈ alphabet := by
  cases action <;> simp [alphabet]

@[instance_reducible] def quotientFintype :
    Fintype (Quotient (dfaFutureSetoid automaton)) :=
  behavioralQuotientFintype automaton alphabet alphabet_complete

local instance : Fintype (Quotient (dfaFutureSetoid automaton)) :=
  quotientFintype

/-- The executable quotient merges the duplicate row: four rows become three
future classes. -/
theorem quotientCard_eq_three :
    Fintype.card (Quotient (dfaFutureSetoid automaton)) = 3 := by
  -- NATIVE-BECAUSE: the kernel route was tried twice and MEASURED to fail,
  -- not assumed to.  `decide` with maxRecDepth 100000 / maxHeartbeats 4000000
  -- ran over 20 minutes without terminating and was killed
  -- (notes/NATIVE_DECIDE_AUDIT.md §4c); `decide +kernel` — the tactic that
  -- retired the five DiagonalSmithRoute sites — was substituted here on
  -- 2026-08-15 and the build was killed with exit 137 (OOM) after 123 s, so
  -- this is a genuine COST case and not the elaborator-irreducibility case
  -- `+kernel` fixes.  Deciding a `Fintype.card` of a quotient by a
  -- behavioural setoid materialises the quotient's `Fintype` instance.
  -- REMOVAL PATH: a proof that does not materialise the instance — exhibit
  -- the three classes and prove the canonical map to `Fin 3` a bijection, or
  -- give `Quotient (dfaFutureSetoid ·)` a `Fintype` computed from the
  -- ChartStateBFS row table rather than by quotienting the carrier.
  -- This theorem is therefore COMPILER-checked, not kernel-checked, and must
  -- not be described as "checked" without that qualification.
  native_decide

example : (behavioralQuotientDFA automaton).accepts = automaton.accepts :=
  behavioralQuotientDFA_accepts_eq automaton

end ChartQuotientWitness

end Pairfield
