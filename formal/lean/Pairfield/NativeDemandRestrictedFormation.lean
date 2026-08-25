/-
Copyright (c) 2026 Avik Jain and the mathematics collaboration.
Released under Apache 2.0 license.

Demand-restricted observable formation from a supplied reverse separator
policy.  Only a pair still unresolved by the installed language requests a
suffix.  Its policy suffix is necessarily useful, installation strictly
decreases the unresolved-pair finset, and finite fuel forms a discrete global
observable.
-/
import Mathlib.Data.Finset.Max
import Pairfield.NativeReverseSeparatorPolicy
import Pairfield.NativeWitnessGreedyFormation

namespace Pairfield

universe u v

variable {A : Type u} {X : Type v}

namespace NativeDemandRestrictedFormation

open NativeCompleteWitnesses
open NativeReverseSeparatorPolicy
open NativeWitnessGreedyFormation

variable [LinearOrder X] [Fintype X]
variable [DecidableEq A]

variable (M : DFA A X)
variable [DecidablePred (fun state : X => state ∈ M.accept)]

/-- The remaining construction demand: one orientation of every unequal pair
which the installed response rows still identify. -/
def unresolvedPairs (installed : Finset (List A)) : Finset (X × X) :=
  (strictPairs (X := X)).filter fun pair =>
    Agree M installed pair.1 pair.2

theorem mem_unresolvedPairs_iff (installed : Finset (List A))
    (pair : X × X) :
    pair ∈ unresolvedPairs M installed ↔
      pair.1 < pair.2 ∧ Agree M installed pair.1 pair.2 := by
  simp [unresolvedPairs, strictPairs]

/-- Adding a test never creates a new unresolved pair. -/
theorem unresolvedPairs_insert_subset
    (installed : Finset (List A)) (word : List A) :
    unresolvedPairs M (insert word installed) ⊆
      unresolvedPairs M installed := by
  intro pair hpair
  rw [mem_unresolvedPairs_iff] at hpair ⊢
  exact ⟨hpair.1,
    response_rel_mono M (Finset.subset_insert word installed) hpair.2⟩

/-- Pre-construction strict gate: the shared policy suffix for a pair still
in demand is guaranteed useful before that suffix is installed. -/
theorem sharedSuffix_useful_of_mem
    (policy : Policy M) (installed : Finset (List A)) (pair : X × X)
    (hpair : pair ∈ unresolvedPairs M installed) :
    Useful M installed (policy.sharedSuffix M pair) := by
  have hdata := (mem_unresolvedPairs_iff M installed pair).1 hpair
  exact ⟨pair.1, pair.2, hdata.2,
    policy.sharedSuffix_separates M pair (ne_of_lt hdata.1)⟩

/-- The selected demand is discharged by installing its policy suffix. -/
theorem selected_pair_not_mem_after_sharedSuffix
    (policy : Policy M) (installed : Finset (List A)) (pair : X × X)
    (hpair : pair ∈ unresolvedPairs M installed) :
    pair ∉ unresolvedPairs M
      (insert (policy.sharedSuffix M pair) installed) := by
  intro hafter
  have hdata := (mem_unresolvedPairs_iff M installed pair).1 hpair
  have hagree := (mem_unresolvedPairs_iff M
    (insert (policy.sharedSuffix M pair) installed) pair).1 hafter |>.2
  exact policy.sharedSuffix_separates M pair (ne_of_lt hdata.1)
    (hagree (policy.sharedSuffix M pair) (Finset.mem_insert_self _ _))

/-- Every demanded policy installation strictly lowers the finite demand. -/
theorem unresolvedPairs_sharedSuffix_ssubset
    (policy : Policy M) (installed : Finset (List A)) (pair : X × X)
    (hpair : pair ∈ unresolvedPairs M installed) :
    unresolvedPairs M (insert (policy.sharedSuffix M pair) installed) ⊂
      unresolvedPairs M installed := by
  apply (Finset.ssubset_iff_of_subset
    (unresolvedPairs_insert_subset M installed
      (policy.sharedSuffix M pair))).2
  exact ⟨pair, hpair,
    selected_pair_not_mem_after_sharedSuffix M policy installed pair hpair⟩

theorem unresolvedPairs_sharedSuffix_card_lt
    (policy : Policy M) (installed : Finset (List A)) (pair : X × X)
    (hpair : pair ∈ unresolvedPairs M installed) :
    (unresolvedPairs M
      (insert (policy.sharedSuffix M pair) installed)).card <
        (unresolvedPairs M installed).card :=
  Finset.card_lt_card
    (unresolvedPairs_sharedSuffix_ssubset M policy installed pair hpair)

/-- Traverse an explicit strict-pair schedule.  A policy suffix is reconstructed
only when its pair remains unresolved at the moment of demand. -/
def resolveSchedule (policy : Policy M) :
    Finset (List A) → List (X × X) → Finset (List A)
  | installed, [] => installed
  | installed, pair :: rest =>
      if pair ∈ unresolvedPairs M installed then
        resolveSchedule policy
          (insert (policy.sharedSuffix M pair) installed) rest
      else
        resolveSchedule policy installed rest

/-- Processing later demands can only refine the current response relation. -/
theorem unresolvedPairs_resolveSchedule_subset
    (policy : Policy M) (installed : Finset (List A))
    (schedule : List (X × X)) :
    unresolvedPairs M (resolveSchedule M policy installed schedule) ⊆
      unresolvedPairs M installed := by
  induction schedule generalizing installed with
  | nil => simp [resolveSchedule]
  | cons pair rest ih =>
      by_cases hpair : pair ∈ unresolvedPairs M installed
      · exact Finset.Subset.trans
          (by simpa [resolveSchedule, hpair] using
            (ih (insert (policy.sharedSuffix M pair) installed)))
          (unresolvedPairs_insert_subset M installed
            (policy.sharedSuffix M pair))
      · simpa [resolveSchedule, hpair] using ih installed

/-- Every pair which appears in the explicit schedule is resolved after the
entire schedule, whether it was already resolved or triggered construction. -/
theorem mem_schedule_not_mem_unresolved_after
    (policy : Policy M) (installed : Finset (List A))
    (schedule : List (X × X)) (pair : X × X)
    (hmem : pair ∈ schedule) :
    pair ∉ unresolvedPairs M (resolveSchedule M policy installed schedule) := by
  induction schedule generalizing installed with
  | nil => simp at hmem
  | cons head rest ih =>
      simp only [List.mem_cons] at hmem
      rcases hmem with rfl | htail
      · by_cases hpair : pair ∈ unresolvedPairs M installed
        · intro hfinal
          simp only [resolveSchedule, if_pos hpair] at hfinal
          have hafter := (unresolvedPairs_resolveSchedule_subset M policy
            (insert (policy.sharedSuffix M pair) installed) rest) hfinal
          exact selected_pair_not_mem_after_sharedSuffix
            M policy installed pair hpair hafter
        · intro hfinal
          simp only [resolveSchedule, if_neg hpair] at hfinal
          exact hpair ((unresolvedPairs_resolveSchedule_subset M policy
            installed rest) hfinal)
      · by_cases hhead : head ∈ unresolvedPairs M installed
        · simp only [resolveSchedule, if_pos hhead]
          exact ih (insert (policy.sharedSuffix M head) installed) htail
        · simp only [resolveSchedule, if_neg hhead]
          exact ih installed htail

/-- An explicit enumeration of all strict pairs empties the demand.  This is
the honest executable scheduling boundary replacing a hidden order choice. -/
theorem unresolvedPairs_resolveSchedule_eq_empty
    (policy : Policy M) (installed : Finset (List A))
    (schedule : List (X × X))
    (hschedule : schedule.toFinset = strictPairs (X := X)) :
    unresolvedPairs M (resolveSchedule M policy installed schedule) = ∅ := by
  apply Finset.eq_empty_of_forall_notMem
  intro pair hpair
  have hstrict : pair ∈ strictPairs (X := X) :=
    (Finset.filter_subset _ _) hpair
  have hscheduleMem : pair ∈ schedule := by
    have : pair ∈ schedule.toFinset := by
      rw [hschedule]
      exact hstrict
    simpa using this
  exact mem_schedule_not_mem_unresolved_after M policy installed
    schedule pair hscheduleMem hpair

/-- Demand-restricted formation from an explicit complete pair schedule. -/
def formObservable (policy : Policy M) (installed : Finset (List A))
    (schedule : List (X × X)) : Finset (List A) :=
  resolveSchedule M policy installed schedule

theorem agree_symm {installed : Finset (List A)} {left right : X}
    (hagree : Agree M installed left right) :
    Agree M installed right left := by
  intro word hword
  exact (hagree word hword).symm

/-- Empty demand is exactly enough for equality recovery on the supplied
linearly ordered finite chart. -/
theorem eq_of_agree_of_unresolvedPairs_eq_empty
    (installed : Finset (List A))
    (hempty : unresolvedPairs M installed = ∅)
    (left right : X) (hagree : Agree M installed left right) :
    left = right := by
  by_contra hne
  rcases lt_or_gt_of_ne hne with hlt | hgt
  · have hmem : (left, right) ∈ unresolvedPairs M installed :=
      (mem_unresolvedPairs_iff M installed (left, right)).2 ⟨hlt, hagree⟩
    simpa [hempty] using hmem
  · have hmem : (right, left) ∈ unresolvedPairs M installed :=
      (mem_unresolvedPairs_iff M installed (right, left)).2
        ⟨hgt, agree_symm M hagree⟩
    simpa [hempty] using hmem

/-- Demand-restricted formation theorem.  A supplied reverse separator policy
forms a discrete response partition from arbitrary initial tests in at most
`choose(n,2)` successful policy-suffix installations. -/
theorem formObservable_partition_discrete
    (policy : Policy M) (installed : Finset (List A))
    (schedule : List (X × X))
    (hschedule : schedule.toFinset = strictPairs (X := X)) :
    ∀ left right : X,
      right ∈ (responsePartition M
        (formObservable M policy installed schedule)).part left ↔ left = right := by
  intro left right
  rw [mem_part_responsePartition_iff]
  constructor
  · intro hagree
    exact eq_of_agree_of_unresolvedPairs_eq_empty M
      (formObservable M policy installed schedule)
      (unresolvedPairs_resolveSchedule_eq_empty M policy installed
        schedule hschedule)
      left right (by simpa [Agree] using hagree)
  · rintro rfl word hword
    rfl

namespace Control

/-! This control is the **same automaton** as
`NativeWitnessGreedyFormation.Control.automaton`, and that is deliberate: the
two modules run two different formation policies — greedy pruning of a planted
duplicate there, demand-restricted scheduling here — and both arrive at
`{[], [false]}`.  The comparison is only meaningful because the fixture is one
fixture, so the sameness is *checked* below rather than left to the reader (or
to a content-address census) to notice.

The two texts are kept separate rather than merged.  A control that reaches
into another module for its own subject is no longer a control, and this
module has to be readable where it stands; what the identification buys is
that the sameness cannot silently drift. -/

def step (state : Fin 3) (_action : Bool) : Fin 3 :=
  if state = 1 then 2 else state

def automaton : DFA Bool (Fin 3) where
  step := step
  start := 0
  accept := { state | state = 2 }

theorem step_eq_greedy_control_step :
    step = NativeWitnessGreedyFormation.Control.step := rfl

/-- The demand-restricted control and the greedy control are one automaton.
Hence `forms_exact_two_word_observable` below and
`NativeWitnessGreedyFormation.Control.duplicate_word_is_pruned` are two
policies' verdicts on a single object, not a coincidence of two fixtures. -/
theorem automaton_eq_greedy_control :
    automaton = NativeWitnessGreedyFormation.Control.automaton := rfl

instance : DecidablePred
    (fun state : Fin 3 => state ∈ automaton.accept) :=
  fun state => inferInstanceAs (Decidable (state = 2))

def needsStep (pair : Fin 3 × Fin 3) : Bool :=
  decide (pair = (0, 1) ∨ pair = (1, 0))

/-- One nonterminal product-state edge is sufficient; every other unequal pair
already has distinct empty-word responses. -/
def policy : Policy automaton where
  rank pair := if needsStep pair then 1 else 0
  action? pair := if needsStep pair then some false else none
  terminal_separates := by
    rintro ⟨left, right⟩ hne hnone
    fin_cases left <;> fin_cases right <;>
      simp_all [needsStep, automaton, step, behavior, run, acceptsBool]
  step_preserves_ne := by
    rintro ⟨left, right⟩ hne action haction
    fin_cases left <;> fin_cases right <;>
      cases action <;>
        simp_all [needsStep, automaton, step, pairStep]
  rank_decreases := by
    rintro ⟨left, right⟩ hne action haction
    fin_cases left <;> fin_cases right <;>
      cases action <;>
        simp_all [needsStep, automaton, step, pairStep]

def schedule : List (Fin 3 × Fin 3) :=
  [(0, 1), (0, 2), (1, 2)]

theorem schedule_complete :
    schedule.toFinset = strictPairs (X := Fin 3) := by
  decide

/-- Native formation event: demand restriction constructs `[false]` for the
hidden pair, then `[]` for the last visible distinction, and stops. -/
theorem forms_exact_two_word_observable :
    formObservable automaton policy ∅ schedule =
      ({[], [false]} : Finset (List Bool)) := by
  decide

theorem formed_control_is_discrete :
    ∀ left right : Fin 3,
      Agree automaton (formObservable automaton policy ∅ schedule) left right →
        left = right := by
  decide

end Control

end NativeDemandRestrictedFormation

end Pairfield
