/-
Copyright (c) 2026 Avik Jain and the mathematics collaboration.
Released under Apache 2.0 license.

A checked strict gap between the parallel uniform response-window horizon and
the depth of one response-dependent adaptive identification experiment.
-/
import Pairfield.GlobalObservableHorizon

namespace Pairfield

universe u v

variable {A : Type u} {X : Type v}

/-- A finite experiment policy.  After applying one action, the returned
Boolean observation alone chooses the continuation. -/
inductive BoolExperimentTree (A : Type u) where
  | done
  | query (action : A)
      (onFalse onTrue : BoolExperimentTree A)
deriving Repr

namespace BoolExperimentTree

def depth : BoolExperimentTree A → Nat
  | done => 0
  | query _ onFalse onTrue =>
      max onFalse.depth onTrue.depth + 1

/-- Responses after the current observation.  The state really advances
before the observation that selects the next subtree. -/
def responses (step : X → A → X) (observe : X → Bool) :
    BoolExperimentTree A → X → List Bool
  | done, _ => []
  | query action onFalse onTrue, state =>
      let next := step state action
      let response := observe next
      response :: match response with
        | false => responses step observe onFalse next
        | true => responses step observe onTrue next

/-- The current observation is available without spending an action. -/
def trace (step : X → A → X) (observe : X → Bool)
    (tree : BoolExperimentTree A) (state : X) : List Bool :=
  observe state :: tree.responses step observe state

def IdentifiesAll (step : X → A → X) (observe : X → Bool)
    (tree : BoolExperimentTree A) : Prop :=
  Function.Injective (tree.trace step observe)

def IdentifiesAtDepth (step : X → A → X) (observe : X → Bool)
    (fuel : Nat) : Prop :=
  ∃ tree : BoolExperimentTree A,
    tree.depth ≤ fuel ∧ tree.IdentifiesAll step observe

theorem eq_done_of_depth_eq_zero (tree : BoolExperimentTree A)
    (hdepth : tree.depth = 0) : tree = done := by
  cases tree with
  | done => rfl
  | query action onFalse onTrue =>
      simp [depth] at hdepth

end BoolExperimentTree

namespace AdaptiveObservableHorizonWitness

open BoolExperimentTree

/-- Three initially hidden states and one observed sink.  `false` isolates
state `1`; `true` isolates state `2`. -/
def step (state : Fin 4) (action : Bool) : Fin 4 :=
  if ((!action && decide (state = 1)) ||
      (action && decide (state = 2))) then 3 else state

def observe (state : Fin 4) : Bool := decide (state = 3)

def automaton : DFA Bool (Fin 4) where
  step := step
  start := 0
  accept := { state | observe state = true }

instance : DecidablePred (fun state : Fin 4 => state ∈ automaton.accept) :=
  fun state => inferInstanceAs (Decidable (observe state = true))

def alphabet : List Bool := [false, true]

theorem alphabet_complete (action : Bool) : action ∈ alphabet := by
  cases action <;> simp [alphabet]

/-- Apply `false`; only on the unresolved false branch apply `true`. -/
def adaptiveTree : BoolExperimentTree Bool :=
  .query false (.query true .done .done) .done

theorem adaptiveTree_depth : adaptiveTree.depth = 2 := by
  decide

theorem adaptiveTree_identifies :
    adaptiveTree.IdentifiesAll step observe := by
  intro left right heq
  fin_cases left <;> fin_cases right <;>
    simp_all [BoolExperimentTree.IdentifiesAll,
      BoolExperimentTree.trace, BoolExperimentTree.responses,
      adaptiveTree, step, observe]

/-- No one-action adaptive policy identifies the four states.  A `false`
root leaves states `0,2` colliding; a `true` root leaves `0,1` colliding. -/
theorem no_identifying_tree_of_depth_le_one
    (tree : BoolExperimentTree Bool) (hdepth : tree.depth ≤ 1) :
    ¬ tree.IdentifiesAll step observe := by
  cases tree with
  | done =>
      intro hinjective
      have heq : BoolExperimentTree.trace step observe .done (0 : Fin 4) =
          BoolExperimentTree.trace step observe .done 1 := by
        decide
      exact (by decide : (0 : Fin 4) ≠ 1) (hinjective heq)
  | query action onFalse onTrue =>
      have hfalseMax : onFalse.depth ≤ max onFalse.depth onTrue.depth :=
        Nat.le_max_left _ _
      have htrueMax : onTrue.depth ≤ max onFalse.depth onTrue.depth :=
        Nat.le_max_right _ _
      have hfalseZero : onFalse.depth = 0 := by
        simp only [BoolExperimentTree.depth] at hdepth
        omega
      have htrueZero : onTrue.depth = 0 := by
        simp only [BoolExperimentTree.depth] at hdepth
        omega
      have hfalseDone := eq_done_of_depth_eq_zero onFalse hfalseZero
      have htrueDone := eq_done_of_depth_eq_zero onTrue htrueZero
      subst onFalse
      subst onTrue
      cases action with
      | false =>
          intro hinjective
          have heq :
              BoolExperimentTree.trace step observe
                (.query false .done .done) (0 : Fin 4) =
              BoolExperimentTree.trace step observe
                (.query false .done .done) 2 := by
            decide
          exact (by decide : (0 : Fin 4) ≠ 2) (hinjective heq)
      | true =>
          intro hinjective
          have heq :
              BoolExperimentTree.trace step observe
                (.query true .done .done) (0 : Fin 4) =
              BoolExperimentTree.trace step observe
                (.query true .done .done) 1 := by
            decide
          exact (by decide : (0 : Fin 4) ≠ 1) (hinjective heq)

theorem adaptive_depth_isLeast :
    IsLeast { fuel : Nat |
      BoolExperimentTree.IdentifiesAtDepth step observe fuel } 2 := by
  constructor
  · exact ⟨adaptiveTree, by rw [adaptiveTree_depth], adaptiveTree_identifies⟩
  · intro fuel hidentifies
    by_contra hnot
    have hfuel : fuel ≤ 1 := by omega
    obtain ⟨tree, htreeDepth, htreeIdentifies⟩ := hidentifies
    exact (no_identifying_tree_of_depth_le_one tree
      (Nat.le_trans htreeDepth hfuel)) htreeIdentifies

theorem uniform_horizon_eq_one :
    globalObservableHorizon automaton alphabet = 1 := by
  decide

/-- The promised strict cost separation. -/
theorem uniform_one_adaptive_two :
    globalObservableHorizon automaton alphabet = 1 ∧
      IsLeast { fuel : Nat |
        BoolExperimentTree.IdentifiesAtDepth step observe fuel } 2 :=
  ⟨uniform_horizon_eq_one, adaptive_depth_isLeast⟩

end AdaptiveObservableHorizonWitness

end Pairfield
