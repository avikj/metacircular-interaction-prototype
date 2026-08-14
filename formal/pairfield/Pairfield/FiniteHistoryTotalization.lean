/-
Copyright (c) 2026 Avik Jain and the mathematics collaboration.
Released under Apache 2.0 license.

Finite histories split exactly into a prefix and an endpoint.  The endpoint
projection forgets the entire prefix fibre.
-/
import Mathlib.SetTheory.Cardinal.Finite
import Mathlib.CategoryTheory.Elements
import Mathlib.CategoryTheory.Discrete.Basic

namespace Pairfield.FiniteHistoryTotalization

open CategoryTheory

universe u v

variable {State : Type u}

/-- A finite history with `n` past positions and one endpoint. -/
abbrev History (State : Type u) (n : ℕ) := Fin (n + 1) → State

/-- The ordinary endpoint observation. -/
def endpoint (n : ℕ) (history : History State n) : State :=
  history (Fin.last n)

/-- Everything before the endpoint. -/
def pastProjection (n : ℕ) (history : History State n) : Fin n → State :=
  fun i => history i.castSucc

/-- Assemble a complete finite history from its prefix and endpoint. -/
def assemble (n : ℕ) (final : State) (past : Fin n → State) :
    History State n :=
  Fin.lastCases final past

/-- History-totalized reporting retains both prefix and endpoint. -/
def totalize (n : ℕ) (history : History State n) :
    (Fin n → State) × State :=
  (pastProjection n history, endpoint n history)

/-- A finite history is exactly its totalized report. -/
def historyTotalizationEquiv (n : ℕ) :
    History State n ≃ (Fin n → State) × State where
  toFun := totalize n
  invFun parts := assemble n parts.2 parts.1
  left_inv history := by
    funext i
    refine Fin.lastCases ?_ (fun j => ?_) i
    · simp [totalize, endpoint, assemble]
    · simp [totalize, pastProjection, assemble]
  right_inv parts := by
    rcases parts with ⟨past, final⟩
    apply Prod.ext
    · funext i
      simp [totalize, pastProjection, assemble]
    · simp [totalize, endpoint, assemble]

/--
The category-of-elements (Grothendieck) total object for a type-valued rooted
diagram on the discrete finite-history category.  This is the exact
one-categorical bounded case; it does not supply higher Braid transitions.
-/
def rootedHistoryDiagram (n : ℕ) (Root : History State n → Type v) :
    Discrete (History State n) ⥤ Type v :=
  Discrete.functor Root

abbrev GrothendieckTotal (n : ℕ) (Root : History State n → Type v) :=
  (rootedHistoryDiagram n Root).Elements

/-- Forget a rooted total object to the endpoint of its history index. -/
def grothendieckEndpoint (n : ℕ) (Root : History State n → Type v)
    (rooted : GrothendieckTotal n Root) : State :=
  endpoint n rooted.1.as

/-- With a unit rooted fibre, the Grothendieck total carrier is the history. -/
def unitRootTotalEquivHistory (n : ℕ) :
    GrothendieckTotal n (fun _ : History State n => Unit) ≃ History State n where
  toFun rooted := rooted.1.as
  invFun history := ⟨Discrete.mk history, ()⟩
  left_inv rooted := by
    rcases rooted with ⟨⟨history⟩, root⟩
    cases root
    rfl
  right_inv _ := rfl

/-- Totalized histories admit exact reconstruction. -/
theorem totalize_hasDecoder (n : ℕ) :
    Function.HasLeftInverse (totalize (State := State) n) := by
  refine ⟨(historyTotalizationEquiv (State := State) n).symm, ?_⟩
  exact (historyTotalizationEquiv (State := State) n).symm_apply_apply

/-- Every endpoint fibre is explicitly the full space of length-`n` prefixes. -/
def endpointFiberEquivPrefix (n : ℕ) (final : State) :
    {history : History State n // endpoint n history = final} ≃
      (Fin n → State) where
  toFun history := pastProjection n history.1
  invFun past :=
    ⟨assemble n final past, by simp [endpoint, assemble]⟩
  left_inv history := by
    apply Subtype.ext
    funext i
    refine Fin.lastCases ?_ (fun j => ?_) i
    · simp only [assemble, Fin.lastCases_last]
      exact history.property.symm
    · simp [assemble, pastProjection]
  right_inv past := by
    funext i
    simp [pastProjection, assemble]

/--
The endpoint fibre of the unit-root Grothendieck total object is still the
entire prefix space.
-/
def unitRootEndpointFiberEquivPrefix (n : ℕ) (final : State) :
    {rooted : GrothendieckTotal n (fun _ : History State n => Unit) //
        grothendieckEndpoint n (fun _ : History State n => Unit) rooted = final} ≃
      (Fin n → State) :=
  ((unitRootTotalEquivHistory (State := State) n).subtypeEquiv fun _ => Iff.rfl).trans
    (endpointFiberEquivPrefix n final)

/-- The unit-root Grothendieck total has the same exact endpoint ambiguity. -/
theorem unitRootEndpointFiberCard [Finite State] (n : ℕ) (final : State) :
    Nat.card {rooted : GrothendieckTotal n (fun _ : History State n => Unit) //
        grothendieckEndpoint n (fun _ : History State n => Unit) rooted = final} =
      Nat.card State ^ n := by
  rw [Nat.card_congr (unitRootEndpointFiberEquivPrefix n final)]
  rw [Nat.card_fun, Nat.card_fin]

/-- Exact ambiguity: a finite endpoint erases `|State| ^ n` histories. -/
theorem endpointFiberCard [Finite State] (n : ℕ) (final : State) :
    Nat.card {history : History State n // endpoint n history = final} =
      Nat.card State ^ n := by
  rw [Nat.card_congr (endpointFiberEquivPrefix n final)]
  rw [Nat.card_fun, Nat.card_fin]

/-- Endpoint projection is injective exactly when the prefix type is trivial. -/
theorem endpoint_injective_iff_prefix_subsingleton [Nonempty State] (n : ℕ) :
    Function.Injective (endpoint (State := State) n) ↔
      Subsingleton (Fin n → State) := by
  constructor
  · intro hinjective
    constructor
    intro left right
    let final : State := Classical.choice (inferInstance : Nonempty State)
    have sameHistory : assemble n final left = assemble n final right :=
      hinjective (by simp [endpoint, assemble])
    funext i
    simpa [assemble] using congrFun sameHistory i.castSucc
  · intro hprefix left right sameEndpoint
    funext i
    refine Fin.lastCases ?_ (fun j => ?_) i
    · exact sameEndpoint
    · have samePrefix : pastProjection n left = pastProjection n right :=
        Subsingleton.elim _ _
      exact congrFun samePrefix j

/-- Exact input decoding from the endpoint has the same sharp boundary. -/
theorem endpoint_hasDecoder_iff_prefix_subsingleton [Nonempty State] (n : ℕ) :
    Function.HasLeftInverse (endpoint (State := State) n) ↔
      Subsingleton (Fin n → State) := by
  constructor
  · intro hdecoder
    exact (endpoint_injective_iff_prefix_subsingleton n).mp hdecoder.injective
  · intro hprefix
    exact Function.injective_iff_hasLeftInverse.mp
      ((endpoint_injective_iff_prefix_subsingleton n).mpr hprefix)

/-- With at least two states and one past position, no endpoint decoder exists. -/
theorem noEndpointDecoder [Nontrivial State] (n : ℕ) :
    ¬ Function.HasLeftInverse (endpoint (State := State) (n + 1)) := by
  intro hdecoder
  have hsub : Subsingleton (Fin (n + 1) → State) :=
    (endpoint_hasDecoder_iff_prefix_subsingleton (n + 1)).mp hdecoder
  obtain ⟨left, right, hne⟩ := exists_pair_ne State
  have sameConstant : (fun _ : Fin (n + 1) => left) = fun _ => right :=
    hsub.elim _ _
  exact hne (congrFun sameConstant 0)

/-- An observation is endpoint-only when all of its data factors through the endpoint. -/
def FactorsThroughEndpoint {Output : Type v} (n : ℕ)
    (observation : History State n → Output) : Prop :=
  ∃ postprocess : State → Output,
    observation = postprocess ∘ endpoint n

/--
Any proposed ordinary-colimit observation that is proved endpoint-only inherits
the endpoint no-decoder theorem.  The factorization premise is load-bearing.
-/
theorem noDecoder_of_factorsThroughEndpoint [Nontrivial State]
    {Output : Type v} (n : ℕ) (observation : History State (n + 1) → Output)
    (hendpoint : FactorsThroughEndpoint (n + 1) observation) :
    ¬ Function.HasLeftInverse observation := by
  intro hdecoder
  apply noEndpointDecoder (State := State) n
  apply Function.injective_iff_hasLeftInverse.mp
  intro left right sameEndpoint
  apply hdecoder.injective
  obtain ⟨postprocess, rfl⟩ := hendpoint
  exact congrArg postprocess sameEndpoint

/- Two Boolean past positions leave four histories above either endpoint. -/

theorem boolTwoStepFiberCard (final : Bool) :
    Nat.card {history : History Bool 2 // endpoint 2 history = final} = 4 := by
  simpa using endpointFiberCard 2 final

theorem boolTwoStepNoEndpointDecoder :
    ¬ Function.HasLeftInverse (endpoint (State := Bool) 2) := by
  simpa using noEndpointDecoder (State := Bool) 1

end Pairfield.FiniteHistoryTotalization
