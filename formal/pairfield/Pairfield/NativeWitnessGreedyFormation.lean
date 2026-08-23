/-
Copyright (c) 2026 Avik Jain and the mathematics collaboration.
Released under Apache 2.0 license.

Greedy installation of a finite native witness language.  A candidate word is
retained exactly when it separates two states which all installed words still
identify.  Redundancy is monotone under later refinement, so rejected words
never need to be reconsidered and the greedy language induces exactly the same
response equivalence as the whole candidate list.
-/
import Pairfield.NativeCompleteWitnessPartition

namespace Pairfield

universe u v

variable {A : Type u} {X : Type v}

namespace NativeWitnessGreedyFormation

open NativeCompleteWitnesses

variable [LinearOrder X] [Fintype X]
variable [DecidableEq A]

variable (M : DFA A X)
variable [DecidablePred (fun state : X => state ∈ M.accept)]

/-- Literal agreement of two response rows on a finite installed language. -/
def Agree (installed : Finset (List A)) (left right : X) : Prop :=
  ∀ word ∈ installed,
    behavior M.step (acceptsBool M) left word =
      behavior M.step (acceptsBool M) right word

instance agreeDecidable (installed : Finset (List A)) (left right : X) :
    Decidable (Agree M installed left right) := by
  unfold Agree
  exact Finset.decidableDforallFinset

/-- A candidate is informative precisely when it separates a pair which the
currently installed response vectors still identify. -/
def Useful (installed : Finset (List A)) (word : List A) : Prop :=
  ∃ left right : X,
    Agree M installed left right ∧
      behavior M.step (acceptsBool M) left word ≠
        behavior M.step (acceptsBool M) right word

instance usefulDecidable (installed : Finset (List A)) (word : List A) :
    Decidable (Useful M installed word) := by
  unfold Useful
  letI : DecidablePred (fun left : X => ∃ right : X,
      Agree M installed left right ∧
        behavior M.step (acceptsBool M) left word ≠
          behavior M.step (acceptsBool M) right word) :=
    fun _ => Fintype.decidableExistsFintype
  exact Fintype.decidableExistsFintype

/-- The executable formation event.  Candidate order may change which
representative word is retained, but not the final response equivalence. -/
def greedyInstall (installed : Finset (List A)) :
    List (List A) → Finset (List A)
  | [] => installed
  | word :: rest =>
      if Useful M installed word then
        greedyInstall (insert word installed) rest
      else
        greedyInstall installed rest

/-- Agreement on more tests implies agreement on any subfamily. -/
theorem response_rel_mono {smaller larger : Finset (List A)}
    (hsub : smaller ⊆ larger) {left right : X}
    (hagree : Agree M larger left right) :
    Agree M smaller left right := by
  intro word hword
  exact hagree word (hsub hword)

/-- Hostile order-dependence control, proved generally: once a word is
redundant, adding more observations cannot make it informative. -/
theorem not_useful_mono {smaller larger : Finset (List A)} {word : List A}
    (hredundant : ¬ Useful M smaller word) (hsub : smaller ⊆ larger) :
    ¬ Useful M larger word := by
  rintro ⟨left, right, hagree, hseparates⟩
  exact hredundant ⟨left, right,
    response_rel_mono M hsub hagree, hseparates⟩

/-- Greedy formation never removes an already installed observation. -/
theorem installed_subset_greedyInstall
    (installed : Finset (List A)) (candidates : List (List A)) :
    installed ⊆ greedyInstall M installed candidates := by
  induction candidates generalizing installed with
  | nil => simp [greedyInstall]
  | cons word rest ih =>
      simp only [greedyInstall]
      split
      · exact Finset.Subset.trans (Finset.subset_insert word installed)
          (ih (insert word installed))
      · exact ih installed

/-- Every retained word came either from the initial family or the candidate
list. -/
theorem greedyInstall_subset_union
    (installed : Finset (List A)) (candidates : List (List A)) :
    greedyInstall M installed candidates ⊆
      installed ∪ candidates.toFinset := by
  induction candidates generalizing installed with
  | nil => simp [greedyInstall]
  | cons word rest ih =>
      simp only [greedyInstall]
      split
      · simpa [List.toFinset_cons, Finset.insert_union,
          Finset.union_assoc, Finset.union_left_comm, Finset.union_comm] using
          (ih (insert word installed))
      · exact Finset.Subset.trans (ih installed) (by
          intro candidate hcandidate
          rcases Finset.mem_union.mp hcandidate with hinstalled | hrest
          · exact Finset.mem_union_left _ hinstalled
          · exact Finset.mem_union_right _ (by
              simp [List.toFinset_cons, hrest]))

/-- The nontrivial half of semantic preservation: agreement on the greedy
output implies agreement on every rejected candidate as well. -/
theorem response_rel_union_of_greedy
    (installed : Finset (List A)) (candidates : List (List A))
    {left right : X}
    (hagree : Agree M
      (greedyInstall M installed candidates) left right) :
    Agree M (installed ∪ candidates.toFinset) left right := by
  induction candidates generalizing installed with
  | nil => simpa [greedyInstall, Agree] using hagree
  | cons word rest ih =>
      by_cases huseful : Useful M installed word
      · have htail : Agree M
            (greedyInstall M (insert word installed) rest) left right := by
          simpa [greedyInstall, huseful, Agree] using hagree
        have hall := ih (installed := insert word installed) htail
        simpa [List.toFinset_cons, Finset.insert_union,
          Finset.union_assoc, Finset.union_left_comm, Finset.union_comm,
          Agree] using hall
      · have htail : Agree M
            (greedyInstall M installed rest) left right := by
          simpa [greedyInstall, huseful, Agree] using hagree
        have hall := ih (installed := installed) htail
        have hinstalled : Agree M installed left right :=
          response_rel_mono M (Finset.subset_union_left) hall
        have hword : behavior M.step (acceptsBool M) left word =
            behavior M.step (acceptsBool M) right word := by
          by_contra hseparates
          exact huseful ⟨left, right, hinstalled, hseparates⟩
        intro candidate hcandidate
        rcases Finset.mem_union.mp hcandidate with hinitial | hcandidates
        · exact hall candidate (Finset.mem_union_left _ hinitial)
        · simp only [List.toFinset_cons, Finset.mem_insert] at hcandidates
          rcases hcandidates with rfl | hrest
          · exact hword
          · exact hall candidate (Finset.mem_union_right _ hrest)

/-- Exact semantic theorem for the formation event.  Greedy pruning may alter
the syntax of the retained family, but it preserves the complete response
equivalence relation of the initial family plus all candidates. -/
theorem response_rel_greedy_iff_union
    (installed : Finset (List A)) (candidates : List (List A))
    (left right : X) :
    Agree M (greedyInstall M installed candidates) left right ↔
      Agree M (installed ∪ candidates.toFinset) left right := by
  constructor
  · exact response_rel_union_of_greedy M installed candidates
  · exact response_rel_mono M (greedyInstall_subset_union M installed candidates)

/-- Greedily prune an explicitly enumerated native witness schedule.  The list
is part of the executable input; no noncomputable ordering is chosen for the
finite witness set. -/
def greedyScheduledWords (schedule : List (List A)) : Finset (List A) :=
  greedyInstall M ∅ schedule

/-- Every retained native word belongs to the original complete pool. -/
theorem greedyScheduledWords_subset (alphabet : List A)
    (schedule : List (List A))
    (hschedule : schedule.toFinset = completeWords M alphabet) :
    greedyScheduledWords M schedule ⊆ completeWords M alphabet := by
  simpa [greedyScheduledWords, hschedule] using
    (greedyInstall_subset_union M (∅ : Finset (List A))
      schedule)

/-- The pruned native language still separates every pair in a reduced chart.
No backtracking or classical choice is hidden in the statement. -/
theorem eq_of_agree_greedyScheduledWords
    (alphabet : List A) (complete : ∀ action : A, action ∈ alphabet)
    (reduced : BehaviorallyReduced M) (schedule : List (List A))
    (hschedule : schedule.toFinset = completeWords M alphabet)
    (left right : X)
    (hagree : Agree M (greedyScheduledWords M schedule) left right) :
    left = right := by
  apply eq_of_agree_completeWords M alphabet complete reduced left right
  have hall := (response_rel_greedy_iff_union M
    (∅ : Finset (List A)) schedule left right).1
      (by simpa [greedyScheduledWords, Agree] using hagree)
  simpa [hschedule, Agree] using hall

/-- Checked formation theorem: greedy native installation remains discrete and
retains no more words than the original quadratic witness ceiling. -/
theorem greedyScheduledWords_card_le_and_partition_discrete
    (alphabet : List A) (complete : ∀ action : A, action ∈ alphabet)
    (reduced : BehaviorallyReduced M) (schedule : List (List A))
    (hschedule : schedule.toFinset = completeWords M alphabet) :
    (greedyScheduledWords M schedule).card ≤
        Nat.choose (Fintype.card X) 2 ∧
      ∀ left right : X,
        right ∈ (responsePartition M
          (greedyScheduledWords M schedule)).part left ↔ left = right := by
  constructor
  · exact (Finset.card_le_card
      (greedyScheduledWords_subset M alphabet schedule hschedule)).trans
      (card_completeWords_le_choose_two M alphabet)
  · intro left right
    rw [mem_part_responsePartition_iff]
    constructor
    · intro hagree
      exact eq_of_agree_greedyScheduledWords M alphabet complete reduced
        schedule hschedule left right (by simpa [Agree] using hagree)
    · rintro rfl word hword
      rfl

namespace Control

/-- The action label is intentionally ignored.  Both one-step words therefore
have identical responses, providing a planted redundant candidate.

`NativeDemandRestrictedFormation.Control` runs a different formation policy on
this same automaton and proves the identification by `rfl`
(`automaton_eq_greedy_control`); the two texts are kept separate so each
control stays readable where it stands, and the sameness is checked instead of
merged. -/
def step (state : Fin 3) (_action : Bool) : Fin 3 :=
  if state = 1 then 2 else state

def automaton : DFA Bool (Fin 3) where
  step := step
  start := 0
  accept := { state | state = 2 }

instance : DecidablePred
    (fun state : Fin 3 => state ∈ automaton.accept) :=
  fun state => inferInstanceAs (Decidable (state = 2))

/-- Executable positive and negative control in one event: `[]` first isolates
the accepting state, `[false]` then separates the two hidden states, and the
behaviorally identical `[true]` is rejected. -/
theorem duplicate_word_is_pruned :
    greedyInstall automaton ∅ [[], [false], [true]] =
      ({[], [false]} : Finset (List Bool)) := by
  decide

/-- Despite rejecting the planted duplicate, the resulting response partition
is discrete on all three states. -/
theorem duplicate_control_remains_discrete :
    ∀ left right : Fin 3,
      Agree automaton
        (greedyInstall automaton ∅ [[], [false], [true]]) left right →
        left = right := by
  decide

end Control

end NativeWitnessGreedyFormation

end Pairfield
