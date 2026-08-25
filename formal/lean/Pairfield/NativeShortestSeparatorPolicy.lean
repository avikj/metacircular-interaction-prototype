/-
Copyright (c) 2026 Avik Jain and the mathematics collaboration.
Released under Apache 2.0 license.

Compile the existing globally shortest native pair separators into the rank
and action-backpointer policy consumed by demand-restricted observable
formation.  This is an executable independent-search baseline.  It closes the
policy-supply seam but does not claim the aggregate work bound sought from the
shared reverse traversal.
-/
import Pairfield.NativeDemandRestrictedFormation

namespace Pairfield

universe u v

variable {A : Type u} {X : Type v}

namespace NativeShortestSeparatorPolicy

open NativeCompleteWitnesses
open NativeReverseSeparatorPolicy
open NativeDemandRestrictedFormation
open NativeWitnessGreedyFormation

variable [LinearOrder X] [Fintype X]
variable [DecidableEq A]

variable (M : DFA A X)
variable [DecidablePred (fun state : X => state ∈ M.accept)]

/-- Orient an unequal pair by the supplied finite-chart order and reuse the
same symmetric globally shortest separator.  The equal branch is total but is
never consulted by the policy laws. -/
def shortestSeparator (alphabet : List A) (pair : X × X) : List A :=
  if pair.1 < pair.2 then
    witnessWord M alphabet pair
  else if pair.2 < pair.1 then
    witnessWord M alphabet (pair.2, pair.1)
  else
    []

/-- The oriented word remains globally shortest for either orientation of an
unequal pair. -/
theorem shortestSeparator_globally_shortest_of_ne
    (alphabet : List A) (complete : ∀ action : A, action ∈ alphabet)
    (reduced : BehaviorallyReduced M) (pair : X × X)
    (hne : pair.1 ≠ pair.2) :
    behavior M.step (acceptsBool M) pair.1
        (shortestSeparator M alphabet pair) ≠
      behavior M.step (acceptsBool M) pair.2
        (shortestSeparator M alphabet pair) ∧
    ∀ candidate : List A,
      behavior M.step (acceptsBool M) pair.1 candidate ≠
        behavior M.step (acceptsBool M) pair.2 candidate →
      (shortestSeparator M alphabet pair).length ≤ candidate.length := by
  rcases lt_or_gt_of_ne hne with hlt | hgt
  · simpa [shortestSeparator, hlt] using
      (witnessWord_globally_shortest_of_lt
        M alphabet complete reduced hlt)
  · have hnot : ¬ pair.1 < pair.2 := not_lt_of_ge (le_of_lt hgt)
    have hshort := witnessWord_globally_shortest_of_lt
      M alphabet complete reduced hgt
    simp only [shortestSeparator, hnot, hgt, ↓reduceIte]
    constructor
    · exact fun heq => hshort.1 heq.symm
    · intro candidate hseparates
      exact hshort.2 candidate (fun heq => hseparates heq.symm)

/-- The first action of the canonical separator is the executable
backpointer.  An empty separator means the present Moore response already
separates the pair. -/
def separatorAction? (alphabet : List A) (pair : X × X) : Option A :=
  match shortestSeparator M alphabet pair with
  | [] => none
  | action :: _ => some action

/-- Compile independent globally shortest pair searches into the exact policy
interface.  Strict rank descent is the tail-optimality consequence of global
shortestness. -/
def shortestPolicy
    (alphabet : List A) (complete : ∀ action : A, action ∈ alphabet)
    (reduced : BehaviorallyReduced M) : Policy M where
  rank pair := (shortestSeparator M alphabet pair).length
  action? pair := separatorAction? M alphabet pair
  terminal_separates := by
    intro pair hne hnone
    have hshort := shortestSeparator_globally_shortest_of_ne
      M alphabet complete reduced pair hne
    cases hword : shortestSeparator M alphabet pair with
    | nil => simpa [hword] using hshort.1
    | cons action tail =>
        simp [separatorAction?, hword] at hnone
  step_preserves_ne := by
    intro pair hne action haction
    have hshort := shortestSeparator_globally_shortest_of_ne
      M alphabet complete reduced pair hne
    cases hword : shortestSeparator M alphabet pair with
    | nil =>
        simp [separatorAction?, hword] at haction
    | cons head tail =>
        have heq : head = action := by
          simpa [separatorAction?, hword] using haction
        subst head
        have htail :
            behavior M.step (acceptsBool M)
                (pairStep M pair action).1 tail ≠
              behavior M.step (acceptsBool M)
                (pairStep M pair action).2 tail := by
          simpa [hword, behavior, run, pairStep] using hshort.1
        intro hnext
        exact htail (congrArg
          (fun state => behavior M.step (acceptsBool M) state tail) hnext)
  rank_decreases := by
    intro pair hne action haction
    have hshort := shortestSeparator_globally_shortest_of_ne
      M alphabet complete reduced pair hne
    cases hword : shortestSeparator M alphabet pair with
    | nil =>
        simp [separatorAction?, hword] at haction
    | cons head tail =>
        have heq : head = action := by
          simpa [separatorAction?, hword] using haction
        subst head
        have htail :
            behavior M.step (acceptsBool M)
                (pairStep M pair action).1 tail ≠
              behavior M.step (acceptsBool M)
                (pairStep M pair action).2 tail := by
          simpa [hword, behavior, run, pairStep] using hshort.1
        have hnextNe :
            (pairStep M pair action).1 ≠
              (pairStep M pair action).2 := by
          intro hnext
          exact htail (congrArg
            (fun state => behavior M.step (acceptsBool M) state tail) hnext)
        have hnextShortest := shortestSeparator_globally_shortest_of_ne
          M alphabet complete reduced (pairStep M pair action) hnextNe
        simpa only [List.length_cons] using
          Nat.lt_succ_of_le (hnextShortest.2 tail htail)

/-- End-to-end observable formation with no supplied policy.  The remaining
explicit inputs are the complete alphabet, reducedness certificate, initial
tests, and a complete finite pair schedule. -/
theorem shortestPolicy_formObservable_partition_discrete
    (alphabet : List A) (complete : ∀ action : A, action ∈ alphabet)
    (reduced : BehaviorallyReduced M)
    (installed : Finset (List A)) (schedule : List (X × X))
    (hschedule : schedule.toFinset = strictPairs (X := X)) :
    ∀ left right : X,
      right ∈ (responsePartition M
        (formObservable M
          (shortestPolicy M alphabet complete reduced)
          installed schedule)).part left ↔ left = right :=
  formObservable_partition_discrete M
    (shortestPolicy M alphabet complete reduced)
    installed schedule hschedule

namespace Control

open NativeDemandRestrictedFormation.Control

theorem control_reduced : BehaviorallyReduced automaton := by
  intro left right hfuture
  apply formed_control_is_discrete left right
  intro word _hword
  exact hfuture word

/-- The compiled rather than hand-written policy drives the same exact native
formation event. -/
theorem compiled_policy_forms_exact_two_word_observable :
    formObservable automaton
      (shortestPolicy automaton [false, true] (by intro action; cases action <;> simp)
        control_reduced)
      ∅ schedule = ({[], [false]} : Finset (List Bool)) := by
  decide

theorem compiled_policy_control_is_discrete :
    ∀ left right : Fin 3,
      Agree automaton
        (formObservable automaton
          (shortestPolicy automaton [false, true]
            (by intro action; cases action <;> simp) control_reduced)
          ∅ schedule)
        left right → left = right := by
  decide

end Control

end NativeShortestSeparatorPolicy

end Pairfield
