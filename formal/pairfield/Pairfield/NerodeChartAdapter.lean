/-
Copyright (c) 2026 Avik Jain and the mathematics collaboration.
Released under Apache 2.0 license.

Mathlib's canonical left-quotient DFA as a native finite behavioral
presentation.  The construction is deliberately noncomputable: regularity
proves finite residual range but does not supply an executable chart.
-/
import Pairfield.ReachableChart

namespace Pairfield

universe u v

variable {A : Type u} {X : Type v}

universe w

variable {Y : Type w}

/-- A prefix witnessing that a Mathlib Nerode state is a left quotient. -/
noncomputable def residualPrefix (M : DFA A X)
    (state : Set.range M.accepts.leftQuotient) : List A :=
  Classical.choose state.property

theorem leftQuotient_residualPrefix (M : DFA A X)
    (state : Set.range M.accepts.leftQuotient) :
    M.accepts.leftQuotient (residualPrefix M state) = state.val :=
  Classical.choose_spec state.property

/-- A reached concrete state representing a residual-language state. -/
noncomputable def residualRepresentative (M : DFA A X)
    (state : Set.range M.accepts.leftQuotient) : X :=
  M.eval (residualPrefix M state)

/-- The chosen concrete representative has exactly the residual language it
represents.  This is the preservation boundary for the classical choice. -/
theorem stateLanguage_residualRepresentative (M : DFA A X)
    (state : Set.range M.accepts.leftQuotient) :
    stateLanguage M (residualRepresentative M state) = state.val := by
  calc
    stateLanguage M (residualRepresentative M state) =
        M.accepts.leftQuotient (residualPrefix M state) :=
      (leftQuotient_eq_stateLanguage_eval M (residualPrefix M state)).symm
    _ = state.val := leftQuotient_residualPrefix M state

/-- Mathlib regularity supplies a finite *classical* presentation whose states
are exactly the left quotients.  Its start and step are Mathlib's `toDFA`
operations; only the concrete representative map uses choice. -/
noncomputable def nerodePresentation (M : DFA A X)
    (regular : M.accepts.IsRegular) : FiniteBehavioralPresentation M where
  State := Set.range M.accepts.leftQuotient
  fintypeState := regular.finite_range_leftQuotient.fintype
  rep := residualRepresentative M
  start := M.accepts.toDFA.start
  step := M.accepts.toDFA.step
  start_sound := by
    apply (futureEq_iff_stateLanguage_eq M _ _).mpr
    rw [stateLanguage_residualRepresentative]
    rfl
  step_sound := by
    intro state action
    apply (futureEq_iff_stateLanguage_eq M _ _).mpr
    calc
      stateLanguage M
          (residualRepresentative M (M.accepts.toDFA.step state action)) =
          (M.accepts.toDFA.step state action).val :=
        stateLanguage_residualRepresentative M _
      _ = state.val.leftQuotient [action] :=
        Language.step_toDFA state action
      _ = (stateLanguage M (residualRepresentative M state)).leftQuotient [action] := by
        rw [stateLanguage_residualRepresentative]
      _ = stateLanguage M (M.step (residualRepresentative M state) action) :=
        stateLanguage_step M _ action

@[simp]
theorem nerodePresentation_start (M : DFA A X)
    (regular : M.accepts.IsRegular) :
    (nerodePresentation M regular).toDFA.start = M.accepts.toDFA.start := rfl

@[simp]
theorem nerodePresentation_step (M : DFA A X)
    (regular : M.accepts.IsRegular)
    (state : Set.range M.accepts.leftQuotient) (action : A) :
    (nerodePresentation M regular).toDFA.step state action =
      M.accepts.toDFA.step state action := rfl

/-- The native chart and Mathlib's canonical residual automaton have the same
accepting states. -/
theorem mem_nerodePresentation_accept_iff (M : DFA A X)
    (regular : M.accepts.IsRegular)
    (state : Set.range M.accepts.leftQuotient) :
    state ∈ (nerodePresentation M regular).toDFA.accept ↔
      state ∈ M.accepts.toDFA.accept := by
  change residualRepresentative M state ∈ M.accept ↔ [] ∈ state.val
  rw [← stateLanguage_residualRepresentative M state]
  rfl

/-- The state language inside the native chart is the residual carried by that
state.  Thus the chart has no behavioral duplicates. -/
theorem stateLanguage_nerodePresentation (M : DFA A X)
    (regular : M.accepts.IsRegular)
    (state : Set.range M.accepts.leftQuotient) :
    stateLanguage (nerodePresentation M regular).toDFA state = state.val := by
  ext word
  rw [show word ∈ stateLanguage (nerodePresentation M regular).toDFA state ↔
      word ∈ M.acceptsFrom (residualRepresentative M state) from
    (nerodePresentation M regular).mem_acceptsFrom_iff state word]
  exact Set.ext_iff.mp (stateLanguage_residualRepresentative M state) word

/-- The canonical residual presentation is reduced: equality of every future
acceptance observation forces literal equality of chart states. -/
theorem nerodePresentation_isReduced (M : DFA A X)
    (regular : M.accepts.IsRegular) :
    (nerodePresentation M regular).IsReduced := by
  intro left right h
  apply Subtype.ext
  have hlanguage :=
    (futureEq_iff_stateLanguage_eq (nerodePresentation M regular).toDFA left right).mp h
  rw [stateLanguage_nerodePresentation M regular left,
    stateLanguage_nerodePresentation M regular right] at hlanguage
  exact hlanguage

/-- Every canonical residual state is reached by one of its witnessing
prefixes.  Together with `nerodePresentation_isReduced`, this separates
"finite presentation" from "minimal reachable presentation" explicitly. -/
theorem nerodePresentation_allStatesReachable (M : DFA A X)
    (regular : M.accepts.IsRegular) :
    (nerodePresentation M regular).AllStatesReachable := by
  intro state
  obtain ⟨word, hword⟩ := state.property
  refine ⟨word, ?_⟩
  apply nerodePresentation_isReduced M regular
  apply (futureEq_iff_stateLanguage_eq
    (nerodePresentation M regular).toDFA _ _).mpr
  calc
    stateLanguage (nerodePresentation M regular).toDFA
        ((nerodePresentation M regular).toDFA.eval word) =
        (nerodePresentation M regular).toDFA.accepts.leftQuotient word :=
      (leftQuotient_eq_stateLanguage_eval
        (nerodePresentation M regular).toDFA word).symm
    _ = M.accepts.leftQuotient word :=
      (nerodePresentation M regular).leftQuotient_eq word
    _ = state.val := hword
    _ = stateLanguage (nerodePresentation M regular).toDFA state :=
      (stateLanguage_nerodePresentation M regular state).symm

/-- Language preservation can be replayed from either side: the native chart
uses `FiniteBehavioralPresentation.accepts_eq`, while Mathlib uses
`Language.accepts_toDFA`. -/
theorem nerodePresentation_accepts_eq_toDFA (M : DFA A X)
    (regular : M.accepts.IsRegular) :
    (nerodePresentation M regular).toDFA.accepts =
      M.accepts.toDFA.accepts := by
  rw [(nerodePresentation M regular).accepts_eq, Language.accepts_toDFA]

/-- Mathlib regularity and existence of a finite behavioral presentation are
logically equivalent.  The forward construction is deliberately
noncomputable; this theorem must not be read as an extraction algorithm. -/
theorem accepts_isRegular_iff_nonempty_finiteBehavioralPresentation
    (M : DFA A X) :
    M.accepts.IsRegular ↔
      Nonempty (FiniteBehavioralPresentation.{u, v, u} M) := by
  constructor
  · intro regular
    exact ⟨nerodePresentation M regular⟩
  · rintro ⟨presentation⟩
    exact presentation.accepts_isRegular

/-- Send a residual state of `M` to the state reached by a chosen witnessing
prefix in another DFA.  This map uses the same classical representative
choice as `nerodePresentation`; it is a proof device, not an executable
minimization routine. -/
noncomputable def residualToState (M : DFA A X) (N : DFA A Y)
    (state : Set.range M.accepts.leftQuotient) : Y :=
  N.eval (residualPrefix M state)

/-- Any DFA recognizing the same language must distinguish all distinct
left quotients.  Thus the canonical residual states inject into its ambient
state type, even when that DFA contains unreachable or duplicate states. -/
theorem residualToState_injective (M : DFA A X) (N : DFA A Y)
    (accepts_eq : N.accepts = M.accepts) :
    Function.Injective (residualToState M N) := by
  intro left right heval
  change N.eval (residualPrefix M left) =
    N.eval (residualPrefix M right) at heval
  apply Subtype.ext
  rw [← leftQuotient_residualPrefix M left,
    ← leftQuotient_residualPrefix M right]
  calc
    M.accepts.leftQuotient (residualPrefix M left) =
        N.accepts.leftQuotient (residualPrefix M left) := by
      rw [accepts_eq]
    _ = stateLanguage N (N.eval (residualPrefix M left)) :=
      leftQuotient_eq_stateLanguage_eval N _
    _ = stateLanguage N (N.eval (residualPrefix M right)) := by
      rw [heval]
    _ = N.accepts.leftQuotient (residualPrefix M right) :=
      (leftQuotient_eq_stateLanguage_eval N _).symm
    _ = M.accepts.leftQuotient (residualPrefix M right) := by
      rw [accepts_eq]

/-- Myhill--Nerode cardinal minimality: the canonical reachable reduced chart
has no more states than any finite DFA accepting the same language.  The
comparison permits garbage and behavioral duplicates in the competitor, so
it is the global finite-DFA lower bound rather than a reduced-chart-only
statement. -/
theorem nerodePresentation_card_le (M : DFA A X)
    (regular : M.accepts.IsRegular) (N : DFA A Y) [Fintype Y]
    (accepts_eq : N.accepts = M.accepts) :
    Fintype.card (nerodePresentation M regular).State ≤ Fintype.card Y := by
  classical
  exact Fintype.card_le_of_injective (residualToState M N)
    (residualToState_injective M N accepts_eq)

/-- In particular, the canonical chart is cardinal-minimal among all explicit
finite behavioral presentations of the same original DFA. -/
theorem nerodePresentation_card_le_presentation (M : DFA A X)
    (regular : M.accepts.IsRegular) (presentation : FiniteBehavioralPresentation M) :
    Fintype.card (nerodePresentation M regular).State ≤
      Fintype.card presentation.State := by
  exact nerodePresentation_card_le M regular presentation.toDFA
    presentation.accepts_eq

end Pairfield
