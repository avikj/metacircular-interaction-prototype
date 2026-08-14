/-
Copyright (c) 2026 Avik Jain and the mathematics collaboration.
Released under Apache 2.0 license.

The exact timing adapter between the repository's Moore-style adaptive trees
and the post-action output trees used by classical adaptive-distinguishing-
sequence theory.  The current observation is free, so post-action responses
need only identify each current-observation fibre.
-/
import Pairfield.AdaptiveBranchResidual

namespace Pairfield

universe u v

variable {A : Type u} {X : Type v}

namespace BoolExperimentTree

/-- The post-action response tree identifies every pair not already separated
by the free current observation.  This is the exact classical ADS obligation
for the repository's Moore-style observation convention. -/
def IdentifiesInitialFibers (step : X → A → X) (observe : X → Bool)
    (tree : BoolExperimentTree A) : Prop :=
  ∀ ⦃left right : X⦄,
    observe left = observe right →
    tree.responses step observe left = tree.responses step observe right →
    left = right

/-- Native trace injectivity is exactly post-action response injectivity on
each fibre of the free current observation.  No step is added to the cost. -/
theorem identifiesAll_iff_identifiesInitialFibers
    (step : X → A → X) (observe : X → Bool)
    (tree : BoolExperimentTree A) :
    tree.IdentifiesAll step observe ↔
      tree.IdentifiesInitialFibers step observe := by
  constructor
  · intro hinjective left right hnow hresponses
    apply hinjective
    simp only [trace, hnow, hresponses]
  · intro hfibres left right htrace
    have hnow : observe left = observe right := by
      exact List.cons.inj (by simpa [trace] using htrace) |>.1
    have hresponses :
        tree.responses step observe left =
          tree.responses step observe right := by
      exact List.cons.inj (by simpa [trace] using htrace) |>.2
    exact hfibres hnow hresponses

end BoolExperimentTree

/-- Prefix left quotients agree exactly when the free current acceptance bit
agrees and every post-action adaptive response tree agrees.  This is the
residual-language form of `identifiesAll_iff_identifiesInitialFibers`. -/
theorem leftQuotient_eq_iff_current_and_all_adaptive_responses_eq
    (M : DFA A X) [DecidablePred (fun state : X => state ∈ M.accept)]
    (left right : List A) :
    M.accepts.leftQuotient left = M.accepts.leftQuotient right ↔
      acceptsBool M (M.eval left) = acceptsBool M (M.eval right) ∧
        ∀ tree : BoolExperimentTree A,
          tree.responses M.step (acceptsBool M) (M.eval left) =
            tree.responses M.step (acceptsBool M) (M.eval right) := by
  constructor
  · intro hresidual
    have hall :=
      (leftQuotient_eq_iff_all_adaptive_traces_eq M left right).1 hresidual
    constructor
    · have hdone := hall (.done)
      simpa [BoolExperimentTree.trace, BoolExperimentTree.responses] using
        List.cons.inj hdone |>.1
    · intro tree
      have htrace := hall tree
      exact congrArg List.tail htrace
  · rintro ⟨hnow, hresponses⟩
    apply (leftQuotient_eq_iff_all_adaptive_traces_eq M left right).2
    intro tree
    simp only [BoolExperimentTree.trace, hnow, hresponses tree]

namespace AdaptiveDistinguishingTransportControl

/-- Two states can be identified for free by their current Moore output even
though the post-action response of the empty tree is identical.  This rejects
the naive translation requiring response-tree injectivity on the whole state
set. -/
def freeOutputStep (state : Bool) (_action : Unit) : Bool := state

def freeOutputObserve (state : Bool) : Bool := state

theorem done_identifies_by_free_output :
    BoolExperimentTree.done.IdentifiesAll
      freeOutputStep freeOutputObserve := by
  intro left right htrace
  cases left <;> cases right <;>
    simp_all [BoolExperimentTree.trace, BoolExperimentTree.responses,
      freeOutputObserve]

theorem done_postResponses_not_injective :
    ¬ Function.Injective
      (BoolExperimentTree.done.responses
        freeOutputStep freeOutputObserve) := by
  intro hinjective
  have heq :
      BoolExperimentTree.done.responses
          freeOutputStep freeOutputObserve false =
        BoolExperimentTree.done.responses
          freeOutputStep freeOutputObserve true := rfl
  exact Bool.false_ne_true (hinjective heq)

/-- The repaired all-reachable `1 < 2` witness satisfies the exact
initial-fibre ADS obligation, with no timing correction to its depth. -/
example :
    BoolExperimentTree.IdentifiesInitialFibers
      ReachableAdaptiveObservableHorizonWitness.step
      ReachableAdaptiveObservableHorizonWitness.observe
      ReachableAdaptiveObservableHorizonWitness.adaptiveTree := by
  exact
    (BoolExperimentTree.identifiesAll_iff_identifiesInitialFibers
      ReachableAdaptiveObservableHorizonWitness.step
      ReachableAdaptiveObservableHorizonWitness.observe
      ReachableAdaptiveObservableHorizonWitness.adaptiveTree).1
      ReachableAdaptiveObservableHorizonWitness.adaptiveTree_identifies

end AdaptiveDistinguishingTransportControl

end Pairfield
