/-
Copyright (c) 2026 Avik Jain and the mathematics collaboration.
Released under Apache 2.0 license.

The exact witness criterion for strict refinement of the global residual
experiment partition.  This closes the remaining logical direction of the
annotated/global adapter: inserting one suffix is strictly informative iff it
separates some pair which all previously installed suffixes still identify.
-/
import Pairfield.AdaptiveResidualAnnotatedPartitionAdapter

namespace Pairfield

universe u v

variable {A : Type u} {X : Type v}

namespace AnnotatedResidualPartitionAdapter

open CanonicalResidualPartition
open CanonicalResidualPosition

noncomputable section

variable [DecidableEq A]

/-- If a proposed suffix is constant on every old experiment block, then the
old partition also refines the partition after insertion.  Together with
`insert_refines`, this says that a redundant suffix changes nothing. -/
theorem experimentPartition_le_insert_of_not_exists_agree_separates
    (M : DFA A X) [Fintype (State M)] [DecidableEq (State M)]
    (tests : Finset (List A)) (suffix : List A)
    (hredundant : ∀ left right : State M,
      (∀ test ∈ tests,
        (test ∈ (left.val : Language A) ↔
          test ∈ (right.val : Language A))) →
      (suffix ∈ (left.val : Language A) ↔
        suffix ∈ (right.val : Language A))) :
    experimentPartition M tests ≤
      experimentPartition M (insert suffix tests) := by
  classical
  intro block hblock
  obtain ⟨representative, hrepresentative⟩ :=
    (experimentPartition M tests).nonempty_of_mem_parts hblock
  have hrepresentativeUniv : representative ∈
      (Finset.univ : Finset (State M)) := Finset.mem_univ _
  refine ⟨(experimentPartition M (insert suffix tests)).part representative,
    (experimentPartition M (insert suffix tests)).part_mem.mpr
      hrepresentativeUniv, ?_⟩
  intro state hstate
  have hpart :
      (experimentPartition M tests).part representative = block :=
    (experimentPartition M tests).part_eq_of_mem
      hblock hrepresentative
  have hagreeOld : ∀ test ∈ tests,
      (test ∈ (representative.val : Language A) ↔
        test ∈ (state.val : Language A)) :=
    (mem_part_experimentPartition_iff M tests representative state).1 (by
      rw [hpart]
      exact hstate)
  apply (mem_part_experimentPartition_iff M
    (insert suffix tests) representative state).2
  intro test htest
  rcases Finset.mem_insert.mp htest with rfl | hold
  · exact hredundant representative state hagreeOld
  · exact hagreeOld test hold

/-- Exact global observable-formation law.  Inserting one suffix strictly
refines the canonical residual partition exactly when it separates a pair
which agreed on every old suffix.  The cross-agreement port is therefore not
only sufficient: it is the complete witness for strictness. -/
theorem insert_strictly_refines_iff_exists_agree_separates
    (M : DFA A X) [Fintype (State M)] [DecidableEq (State M)]
    (tests : Finset (List A)) (suffix : List A) :
    experimentPartition M (insert suffix tests) <
        experimentPartition M tests ↔
      ∃ left right : State M,
        (∀ test ∈ tests,
          (test ∈ (left.val : Language A) ↔
            test ∈ (right.val : Language A))) ∧
        ¬(suffix ∈ (left.val : Language A) ↔
          suffix ∈ (right.val : Language A)) := by
  constructor
  · intro hstrict
    by_contra hnone
    push Not at hnone
    have hreverse : experimentPartition M tests ≤
        experimentPartition M (insert suffix tests) :=
      experimentPartition_le_insert_of_not_exists_agree_separates
        M tests suffix hnone
    exact (not_le_of_gt hstrict) hreverse
  · rintro ⟨left, right, hagree, hseparates⟩
    exact insert_strictly_refines_of_agree_of_separates
      M tests suffix left right hagree hseparates

end

end AnnotatedResidualPartitionAdapter

end Pairfield
