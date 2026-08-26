/-
Copyright (c) 2026 Avik Jain and the mathematics collaboration.
Released under Apache 2.0 license.

The endpoint fiber of a proof-relevant rooted history total is the dependent
sum of the rooted fibers over all compatible pasts.
-/
import Pairfield.FiniteHistoryTotalization

namespace Pairfield.DependentRootedHistoryFiber

open CategoryTheory
open FiniteHistoryTotalization

universe u v

variable {State : Type u}

/-- Forget the discrete wrapper in the category of elements, retaining both
the history and its proof-relevant rooted payload. -/
def rootedTotalEquivSigma (n : ℕ) (Root : History State n → Type v) :
    GrothendieckTotal n Root ≃ Σ history : History State n, Root history where
  toFun rooted := ⟨rooted.1.as, rooted.2⟩
  invFun rooted := ⟨Discrete.mk rooted.1, rooted.2⟩
  left_inv rooted := by
    rcases rooted with ⟨⟨history⟩, root⟩
    rfl
  right_inv _ := rfl

/-- A history in an endpoint fiber is reconstructed by its past and the fixed
endpoint.  The direction is chosen to transport a rooted payload forward. -/
theorem history_eq_assemble_of_endpoint (n : ℕ) (final : State)
    (history : History State n) (hfinal : endpoint n history = final) :
    history = assemble n final (pastProjection n history) := by
  funext i
  refine Fin.lastCases ?_ (fun j => ?_) i
  · change history (Fin.last n) = final at hfinal
    simpa only [assemble, Fin.lastCases_last] using hfinal
  · simp [assemble, pastProjection]

/--
The exact dependent fiber equation for the discrete rooted Grothendieck total:
an endpoint-fixed rooted history is a past together with the rooted payload
over the history assembled from that past and endpoint.
-/
def rootedEndpointFiberEquivDependentPrefix (n : ℕ)
    (Root : History State n → Type v) (final : State) :
    {rooted : GrothendieckTotal n Root //
        grothendieckEndpoint n Root rooted = final} ≃
      Σ past : Fin n → State, Root (assemble n final past) :=
  ((rootedTotalEquivSigma n Root).subtypeEquiv fun _ => Iff.rfl).trans <|
    (Equiv.subtypeSigmaEquiv Root (fun history => endpoint n history = final)).trans <|
      Equiv.sigmaCongr (endpointFiberEquivPrefix n final) fun history =>
        Equiv.cast <|
          congrArg Root <|
            history_eq_assemble_of_endpoint n final history.1 history.2

/--
For finite state and rooted fibers, endpoint ambiguity is the sum of the
rooted multiplicities over all compatible pasts.  No uniform-fiber assumption
or proof irrelevance is used.
-/
theorem rootedEndpointFiberCard [Fintype State]
    (n : ℕ) (Root : History State n → Type v)
    [∀ history, Finite (Root history)] (final : State) :
    Nat.card {rooted : GrothendieckTotal n Root //
        grothendieckEndpoint n Root rooted = final} =
      ∑ past : Fin n → State, Nat.card (Root (assemble n final past)) := by
  rw [Nat.card_congr (rootedEndpointFiberEquivDependentPrefix n Root final)]
  exact Nat.card_sigma

/-- At length zero the equation retains exactly the rooted payload over the
one history with the prescribed endpoint. -/
def zeroStepRootedEndpointFiberEquiv (Root : History State 0 → Type v)
    (final : State) :
    {rooted : GrothendieckTotal 0 Root //
        grothendieckEndpoint 0 Root rooted = final} ≃
      Root (assemble 0 final (default : Fin 0 → State)) :=
  (rootedEndpointFiberEquivDependentPrefix 0 Root final).trans <|
    Equiv.uniqueSigma _

end Pairfield.DependentRootedHistoryFiber
