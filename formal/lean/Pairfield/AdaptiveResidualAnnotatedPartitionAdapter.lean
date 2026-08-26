/-
Copyright (c) 2026 Avik Jain and the mathematics collaboration.
Released under Apache 2.0 license.

The checked seam between provenance-retaining annotated splits and the global
Mathlib residual partition.  An appended annotated word is exactly one suffix
test on the canonical `Language.toDFA` carrier.  It is guaranteed to refine
the global partition strictly when some opposite-child pair was still together
before that test; informativeness of the local block alone is not enough.
-/
import Pairfield.AdaptiveResidualAnnotatedSplit

namespace Pairfield

universe u v

variable {A : Type u} {X : Type v}

namespace AnnotatedResidualPartitionAdapter

open AnnotatedResidualSplit
open CanonicalResidualPartition
open CanonicalResidualPosition

noncomputable section

variable [DecidableEq A]

local instance canonicalAcceptDecidable (M : DFA A X) :
    DecidablePred
      (fun state : State M => state ∈ M.accepts.toDFA.accept) :=
  Classical.decPred _

/-- Iterating the canonical residual automaton realizes left quotient by the
whole native word.  The one-step joint is Mathlib's exact
`Language.step_toDFA`; this is the adapter that makes an annotated word a
suffix-membership experiment rather than an unrelated native trace. -/
theorem evalFrom_toDFA_val (M : DFA A X) (state : State M) (word : List A) :
    (M.accepts.toDFA.evalFrom state word).val =
      state.val.leftQuotient word := by
  induction word using List.reverseRecOn with
  | nil => simp
  | append_singleton word action ih =>
      rw [DFA.evalFrom_append_singleton, Language.step_toDFA, ih]
      exact (Language.leftQuotient_append state.val word [action]).symm

/-- Executable Moore response in the canonical DFA is exactly membership of
the applied annotated word in the source residual language. -/
theorem acceptsBool_evalFrom_toDFA_eq_true_iff
    (M : DFA A X) (state : State M) (word : List A) :
    acceptsBool M.accepts.toDFA
        (M.accepts.toDFA.evalFrom state word) = true ↔
      word ∈ (state.val : Language A) := by
  simp [acceptsBool, evalFrom_toDFA_val, Language.mem_leftQuotient]

/-- Exact strictness criterion in witness form.  Adding a separating suffix
is a strict global refinement whenever it separates a pair that still agreed
on every previously installed test. -/
theorem insert_strictly_refines_of_agree_of_separates
    (M : DFA A X) [Fintype (State M)] [DecidableEq (State M)]
    (tests : Finset (List A)) (suffix : List A) (left right : State M)
    (hagree : ∀ test ∈ tests,
      (test ∈ (left.val : Language A) ↔
        test ∈ (right.val : Language A)))
    (hseparates :
      ¬(suffix ∈ (left.val : Language A) ↔
        suffix ∈ (right.val : Language A))) :
    experimentPartition M (insert suffix tests) <
      experimentPartition M tests := by
  classical
  have hle := insert_refines M tests suffix
  refine lt_of_le_of_ne hle ?_
  intro heq
  have hold : right ∈ (experimentPartition M tests).part left :=
    (mem_part_experimentPartition_iff M tests left right).2 hagree
  have hnew : right ∉
      (experimentPartition M (insert suffix tests)).part left := by
    intro hmem
    have hall :=
      (mem_part_experimentPartition_iff M (insert suffix tests)
        left right).1 hmem
    exact hseparates (hall suffix (Finset.mem_insert_self suffix tests))
  exact hnew (heq ▸ hold)

/-- Opposite response children of an annotated canonical block are separated
by the block's appended word. -/
theorem opposite_children_separated
    (M : DFA A X) (block : Block M.accepts.toDFA) (action : A)
    (left right : State M)
    (hleft : left ∈ block.childMembers M.accepts.toDFA action false)
    (hright : right ∈ block.childMembers M.accepts.toDFA action true) :
    ¬(block.word ++ [action] ∈ (left.val : Language A) ↔
      block.word ++ [action] ∈ (right.val : Language A)) := by
  have hleftResponse :
      block.postResponse M.accepts.toDFA action left = false :=
    (Finset.mem_filter.mp hleft).2
  have hrightResponse :
      block.postResponse M.accepts.toDFA action right = true :=
    (Finset.mem_filter.mp hright).2
  have hleftNotMem :
      block.word ++ [action] ∉ (left.val : Language A) := by
    intro hmem
    have htrue :=
      (acceptsBool_evalFrom_toDFA_eq_true_iff M left
        (block.word ++ [action])).2 hmem
    have htrue' :
        block.postResponse M.accepts.toDFA action left = true := by
      simpa [Block.postResponse, Block.nextState] using htrue
    exact Bool.false_ne_true (hleftResponse.symm.trans htrue')
  have hrightMem :
      block.word ++ [action] ∈ (right.val : Language A) :=
    (acceptsBool_evalFrom_toDFA_eq_true_iff M right
      (block.word ++ [action])).1 (by
        simpa [Block.postResponse, Block.nextState] using hrightResponse)
  exact fun hagree => hleftNotMem (hagree.mpr hrightMem)

/-- Checked reciprocal bridge.  A locally informative annotated split gives
a strict refinement of the global suffix partition exactly after supplying
the missing compatibility witness: one opposite-child pair must still occupy
the same old global experiment block. -/
theorem informativeSplit_strictly_refines_of_cross_agreement
    (M : DFA A X) [Fintype (State M)] [DecidableEq (State M)]
    (tests : Finset (List A)) (block : Block M.accepts.toDFA) (action : A)
    (left right : State M)
    (hleft : left ∈ block.childMembers M.accepts.toDFA action false)
    (hright : right ∈ block.childMembers M.accepts.toDFA action true)
    (hagree : ∀ test ∈ tests,
      (test ∈ (left.val : Language A) ↔
        test ∈ (right.val : Language A))) :
    experimentPartition M (insert (block.word ++ [action]) tests) <
      experimentPartition M tests :=
  insert_strictly_refines_of_agree_of_separates M tests
    (block.word ++ [action]) left right hagree
    (opposite_children_separated M block action left right hleft hright)

/-- Endpoint control: once the old suffix partition is discrete, no further
annotated word can refine it strictly.  Thus nonempty local response children
alone cannot imply strict global refinement; the cross-agreement premise above
is load-bearing. -/
theorem not_strictly_refines_completePartition
    (M : DFA A X) [Fintype (State M)] [DecidableEq (State M)]
    (suffix : List A) :
    ¬ experimentPartition M (insert suffix (completeWitnesses M)) <
        experimentPartition M (completeWitnesses M) := by
  intro hstrict
  have hleBottom :
      experimentPartition M (completeWitnesses M) ≤
        experimentPartition M (insert suffix (completeWitnesses M)) := by
    intro block hblock
    obtain ⟨representative, hrepresentative⟩ :=
      (experimentPartition M (completeWitnesses M)).nonempty_of_mem_parts
        hblock
    have hrepresentativeUniv : representative ∈
        (Finset.univ : Finset (State M)) := Finset.mem_univ _
    refine ⟨(experimentPartition M
      (insert suffix (completeWitnesses M))).part representative,
      (experimentPartition M
        (insert suffix (completeWitnesses M))).part_mem.mpr
          hrepresentativeUniv, ?_⟩
    intro state hstate
    have hpart :
        (experimentPartition M (completeWitnesses M)).part representative =
          block :=
      (experimentPartition M (completeWitnesses M)).part_eq_of_mem
        hblock hrepresentative
    have heq : representative = state :=
      (mem_completePartition_part_iff_eq M representative state).1 (by
        rw [hpart]
        exact hstate)
    subst state
    exact (experimentPartition M
      (insert suffix (completeWitnesses M))).mem_part (Finset.mem_univ _)
  exact (not_le_of_gt hstrict) hleBottom

end

end AnnotatedResidualPartitionAdapter

end Pairfield
