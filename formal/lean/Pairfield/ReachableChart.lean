/-
Copyright (c) 2026 Avik Jain and the mathematics collaboration.
Released under Apache 2.0 license.

Explicit finite behavioral presentations: the effective datum between
Mathlib's extensional finite left-quotient theorem and executable residual
minimization.
-/
import Pairfield.ResidualBFS

namespace Pairfield

universe u v w

variable {A : Type u} {X : Type v}

/--
An explicit finite presentation of the behavior reachable from a DFA start.
The representative of a chart transition need only be future-equivalent to
the concrete transition; demanding literal equality would reject legitimate
choices of one representative per behavioral class.
-/
structure FiniteBehavioralPresentation (M : DFA A X) where
  State : Type w
  fintypeState : Fintype State
  rep : State → X
  start : State
  step : State → A → State
  start_sound :
    FutureEq M.step (fun state => state ∈ M.accept) (rep start) M.start
  step_sound : ∀ state action,
    FutureEq M.step (fun x => x ∈ M.accept)
      (rep (step state action)) (M.step (rep state) action)

attribute [instance] FiniteBehavioralPresentation.fintypeState

namespace FiniteBehavioralPresentation

variable {M : DFA A X} (C : FiniteBehavioralPresentation M)

/-- The finite native DFA carried by the presentation. -/
def toDFA : DFA A C.State where
  step := C.step
  start := C.start
  accept := { state | C.rep state ∈ M.accept }

instance [DecidablePred (fun state : X => state ∈ M.accept)] :
    DecidablePred (fun state : C.State => state ∈ C.toDFA.accept) :=
  fun state => show Decidable (C.rep state ∈ M.accept) from inferInstance

/-- Future equality remains true after executing a common whole word. -/
theorem futureEq_run {Y : Type v} {O : Type w} {B : Type u}
    (step : Y → B → Y) (observe : Y → O) {left right : Y}
    (h : FutureEq step observe left right) (word : List B) :
    FutureEq step observe (run step left word) (run step right word) := by
  induction word generalizing left right with
  | nil => exact h
  | cons action word ih =>
      exact ih (futureEq_step step observe h action)

/-- Chart execution and concrete execution remain behaviorally equal. -/
theorem rep_run_futureEq (state : C.State) (word : List A) :
    FutureEq M.step (fun x => x ∈ M.accept)
      (C.rep (run C.step state word))
      (run M.step (C.rep state) word) := by
  induction word generalizing state with
  | nil => exact futureEq_refl M.step (fun x => x ∈ M.accept) (C.rep state)
  | cons action word ih =>
      exact futureEq_trans M.step (fun x => x ∈ M.accept)
        (ih (C.step state action))
        (futureEq_run M.step (fun x => x ∈ M.accept)
          (C.step_sound state action) word)

@[simp] theorem toDFA_evalFrom_eq_run (state : C.State) (word : List A) :
    C.toDFA.evalFrom state word = run C.step state word := by
  exact (run_eq_evalFrom C.toDFA state word).symm

@[simp] theorem toDFA_eval_eq_run (word : List A) :
    C.toDFA.eval word = run C.step C.start word := by
  exact (run_eq_evalFrom C.toDFA C.start word).symm

/-- Start and transition simulation already cover every reached meaning;
coverage is not an additional chart axiom. -/
theorem covers_eval (word : List A) :
    FutureEq M.step (fun x => x ∈ M.accept)
      (C.rep (C.toDFA.eval word)) (M.eval word) := by
  have hchart := C.rep_run_futureEq C.start word
  have hstart := futureEq_run M.step (fun x => x ∈ M.accept)
    C.start_sound word
  rw [C.toDFA_eval_eq_run]
  simpa [DFA.eval, run_eq_evalFrom] using
    futureEq_trans M.step (fun x => x ∈ M.accept) hchart hstart

/-- The chart started at a representative accepts exactly the concrete
residual language of that representative. -/
theorem mem_acceptsFrom_iff (state : C.State) (word : List A) :
    word ∈ C.toDFA.acceptsFrom state ↔ word ∈ M.acceptsFrom (C.rep state) := by
  have hnow := C.rep_run_futureEq state word []
  change C.rep (C.toDFA.evalFrom state word) ∈ M.accept ↔
    M.evalFrom (C.rep state) word ∈ M.accept
  rw [C.toDFA_evalFrom_eq_run]
  exact iff_of_eq (by simpa [behavior, run_eq_evalFrom] using hnow)

/-- The finite chart recognizes the original accepted language. -/
theorem accepts_eq : C.toDFA.accepts = M.accepts := by
  ext word
  rw [show word ∈ C.toDFA.accepts ↔
      word ∈ M.acceptsFrom (C.rep C.start) from
    C.mem_acceptsFrom_iff C.start word]
  change M.evalFrom (C.rep C.start) word ∈ M.accept ↔
    M.eval word ∈ M.accept
  simpa [behavior, DFA.eval, run_eq_evalFrom] using (C.start_sound word)

theorem leftQuotient_eq (pre : List A) :
    C.toDFA.accepts.leftQuotient pre = M.accepts.leftQuotient pre := by
  rw [C.accepts_eq]

/-- An explicitly supplied presentation proves regularity.  Conversely,
`NerodeChartAdapter` constructs such a presentation from regularity using
classical choice; the strengthening here is operational, not logical. -/
theorem accepts_isRegular (P : FiniteBehavioralPresentation M) :
    M.accepts.IsRegular := by
  apply Language.isRegular_iff.mpr
  refine ⟨_, P.fintypeState, P.toDFA, ?_⟩
  exact P.accepts_eq

/-- Install the chart cardinality as the sufficient search horizon. -/
def shortestLeftQuotientWitness
    [DecidablePred (fun state : X => state ∈ M.accept)]
    (alphabet : List A) (left right : List A) : Option (List A) :=
  Pairfield.shortestLeftQuotientWitness C.toDFA alphabet left right

theorem shortestLeftQuotientWitness_eq_none_iff
    [DecidableEq A] [DecidablePred (fun state : X => state ∈ M.accept)]
    (alphabet : List A) (complete : ∀ action : A, action ∈ alphabet)
    (left right : List A) :
    C.shortestLeftQuotientWitness alphabet left right = none ↔
      M.accepts.leftQuotient left = M.accepts.leftQuotient right := by
  rw [FiniteBehavioralPresentation.shortestLeftQuotientWitness,
    Pairfield.shortestLeftQuotientWitness_eq_none_iff C.toDFA alphabet complete,
    C.leftQuotient_eq, C.leftQuotient_eq]

theorem shortestLeftQuotientWitness_sound
    [DecidableEq A] [DecidablePred (fun state : X => state ∈ M.accept)]
    (alphabet : List A) (complete : ∀ action : A, action ∈ alphabet)
    (left right : List A) {word : List A}
    (h : C.shortestLeftQuotientWitness alphabet left right = some word) :
    ¬ (word ∈ M.accepts.leftQuotient left ↔
      word ∈ M.accepts.leftQuotient right) := by
  have hs := Pairfield.shortestLeftQuotientWitness_sound
    C.toDFA alphabet complete left right h
  simpa only [C.leftQuotient_eq] using hs

theorem shortestLeftQuotientWitness_minimal
    [DecidableEq A] [DecidablePred (fun state : X => state ∈ M.accept)]
    (alphabet : List A) (complete : ∀ action : A, action ∈ alphabet)
    (left right : List A) {word : List A}
    (h : C.shortestLeftQuotientWitness alphabet left right = some word) :
    ∀ candidate : List A,
      ¬ (candidate ∈ M.accepts.leftQuotient left ↔
        candidate ∈ M.accepts.leftQuotient right) →
      word.length ≤ candidate.length := by
  intro candidate hcandidate
  apply Pairfield.shortestLeftQuotientWitness_minimal
    C.toDFA alphabet complete left right h candidate
  simpa only [C.leftQuotient_eq] using hcandidate

/-- Proof-producing extensional equality obtained from the executable chart,
not from a classical `Set.Finite` witness. -/
def leftQuotientEqDecidable
    [DecidableEq A] [DecidablePred (fun state : X => state ∈ M.accept)]
    (alphabet : List A) (complete : ∀ action : A, action ∈ alphabet)
    (left right : List A) :
    Decidable (M.accepts.leftQuotient left = M.accepts.leftQuotient right) :=
  if h : C.shortestLeftQuotientWitness alphabet left right = none then
    isTrue ((C.shortestLeftQuotientWitness_eq_none_iff
      alphabet complete left right).1 h)
  else
    isFalse fun heq => h ((C.shortestLeftQuotientWitness_eq_none_iff
      alphabet complete left right).2 heq)

/-- Optional strengthening: no garbage rows in the finite presentation. -/
def AllStatesReachable : Prop :=
  ∀ state : C.State, ∃ word : List A, C.toDFA.eval word = state

/-- Optional strengthening: the presentation has no behavioral duplicates.
This, not mere finiteness or coverage, is the extra datum required before
calling the whole chart reduced. -/
def IsReduced : Prop :=
  ∀ ⦃left right : C.State⦄,
    FutureEq C.toDFA.step (fun state => state ∈ C.toDFA.accept) left right →
      left = right

end FiniteBehavioralPresentation

namespace ReachableChartWitness

/-- An infinite ambient presentation with a finite reachable behavioral
chart. States above `2` are unreachable from the declared start. -/
def ambientStep (state : Nat) (action : Bool) : Nat :=
  if state = 0 ∧ action = false then 1
  else if state = 1 ∧ action = true then 2
  else state

def ambient : DFA Bool Nat where
  step := ambientStep
  start := 0
  accept := { state | state = 2 }

instance : DecidablePred (fun state : Nat => state ∈ ambient.accept) :=
  fun state => by
    change Decidable (state = 2)
    infer_instance

/-- Identical in text to `ResidualBFSWitness.step` (census, 2026-08-22), and
kept separate.  That one is a DFA's transition; this one is the *chart's*, and
it exists only as the finite mirror of `ambientStep : Nat → Bool → Nat` five
lines above — the pair is what `chart.step_sound` is about.  Pointing this at
another module's witness automaton would leave the correspondence unreadable at
the site that proves it. -/
def chartStep (state : Fin 3) (action : Bool) : Fin 3 :=
  if state = 0 ∧ action = false then 1
  else if state = 1 ∧ action = true then 2
  else state

def chart : FiniteBehavioralPresentation ambient where
  State := Fin 3
  fintypeState := inferInstance
  rep state := state
  start := 0
  step := chartStep
  start_sound := futureEq_refl ambient.step (fun state => state ∈ ambient.accept) 0
  step_sound := by
    intro state action
    have heq : ((chartStep state action : Fin 3) : Nat) =
        ambientStep state action := by
      fin_cases state <;> cases action <;> simp [chartStep, ambientStep]
    rw [heq]
    exact futureEq_refl ambient.step (fun x => x ∈ ambient.accept)
      (ambient.step state action)

def alphabet : List Bool := [false, true]

theorem alphabet_complete (action : Bool) : action ∈ alphabet := by
  cases action <;> simp [alphabet]

/-- The chart search executes even though the ambient state type is `Nat`. -/
example :
    chart.shortestLeftQuotientWitness alphabet [] [false] = some [true] := by
  decide

example : ambient.accepts.IsRegular := chart.accepts_isRegular

end ReachableChartWitness

end Pairfield
