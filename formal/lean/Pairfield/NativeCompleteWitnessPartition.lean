/-
Copyright (c) 2026 Avik Jain and the mathematics collaboration.
Released under Apache 2.0 license.

Install the executable visited-pair witness vocabulary as a global finite
partition on a supplied reduced DFA.  This is the native counterpart of the
classically chosen canonical residual partition: shortest replay words are
constructed first, then their simultaneous response vectors form a discrete
observable.
-/
import Mathlib.Order.Partition.Finpartition
import Pairfield.NativeCompleteWitnesses

namespace Pairfield

universe u v

variable {A : Type u} {X : Type v}

namespace NativeCompleteWitnesses

variable [LinearOrder X] [Fintype X]
variable [DecidableEq A]

variable (M : DFA A X)
variable [DecidablePred (fun state : X => state ∈ M.accept)]

/-- Two supplied chart states are equivalent for a finite native control
language when every installed replay word produces the same terminal Moore
response. -/
def responseSetoid (tests : Finset (List A)) : Setoid X where
  r left right :=
    ∀ word ∈ tests,
      behavior M.step (acceptsBool M) left word =
        behavior M.step (acceptsBool M) right word
  iseqv := {
    refl := fun _ _ _ => rfl
    symm := fun h word hword => (h word hword).symm
    trans := fun hleft hright word hword =>
      (hleft word hword).trans (hright word hword)
  }

/-- The simultaneous response-vector partition induced by executable native
words on the supplied finite chart. -/
noncomputable def responsePartition (tests : Finset (List A)) :
    Finpartition (Finset.univ : Finset X) := by
  classical
  exact Finpartition.ofSetoid (responseSetoid M tests)

/-- Membership in one native response block is literal agreement on all
installed replay words. -/
theorem mem_part_responsePartition_iff
    (tests : Finset (List A)) (left right : X) :
    right ∈ (responsePartition M tests).part left ↔
      ∀ word ∈ tests,
        behavior M.step (acceptsBool M) left word =
          behavior M.step (acceptsBool M) right word := by
  classical
  exact Finpartition.mem_part_ofSetoid_iff_rel

/-- Executable observable formation.  On a behaviorally reduced finite chart,
the visited-pair vocabulary constructs a discrete global response partition:
two states occupy one block exactly when they are equal. -/
theorem mem_completeWords_partition_part_iff_eq
    (alphabet : List A) (complete : ∀ action : A, action ∈ alphabet)
    (reduced : BehaviorallyReduced M) (left right : X) :
    right ∈ (responsePartition M (completeWords M alphabet)).part left ↔
      left = right := by
  constructor
  · intro hmem
    exact eq_of_agree_completeWords M alphabet complete reduced left right
      ((mem_part_responsePartition_iff M
        (completeWords M alphabet) left right).1 hmem)
  · rintro rfl
    classical
    exact (responsePartition M
      (completeWords M alphabet)).mem_part (Finset.mem_univ _)

/-- The full executable certificate keeps both prices visible: the native
word family has at most one entry per unordered pair, and the partition it
induces is discrete.  No word-length or pair-search expansion bound is folded
into this statement. -/
theorem completeWords_card_le_and_partition_discrete
    (alphabet : List A) (complete : ∀ action : A, action ∈ alphabet)
    (reduced : BehaviorallyReduced M) :
    (completeWords M alphabet).card ≤ Nat.choose (Fintype.card X) 2 ∧
      ∀ left right : X,
        right ∈ (responsePartition M
          (completeWords M alphabet)).part left ↔ left = right := by
  exact ⟨card_completeWords_le_choose_two M alphabet,
    mem_completeWords_partition_part_iff_eq M alphabet complete reduced⟩

end NativeCompleteWitnesses

end Pairfield
