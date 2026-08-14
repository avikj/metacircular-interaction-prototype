/-
Copyright (c) 2026 Avik Jain and the mathematics collaboration.
Released under Apache 2.0 license.

A global partition certificate for canonical Mathlib residual states.  A
finite suffix vocabulary partitions every residual simultaneously by its
response vector.  Choosing one suffix for every unordered unequal pair gives
a complete vocabulary of size at most `choose n 2`.

This is a global witness bound, not an adaptive-tree depth bound: different
suffixes may be used at different branches, and no Lee--Yannakakis recurrence
is inferred from the cardinality alone.
-/
import Mathlib.Data.Sym.Card
import Mathlib.Order.Partition.Finpartition
import Pairfield.AdaptiveResidualNonhomogeneousSpine

namespace Pairfield

universe u v

variable {A : Type u} {X : Type v}

namespace CanonicalResidualPartition

open CanonicalResidualPosition

/-- Two canonical residual states are equivalent for a finite control
language when every suffix in that language receives the same answer. -/
def suffixSetoid (M : DFA A X) (tests : Finset (List A)) :
    Setoid (State M) where
  r left right :=
    ∀ suffix ∈ tests, (suffix ∈ left.val ↔ suffix ∈ right.val)
  iseqv := {
    refl := fun _ _ _ => Iff.rfl
    symm := fun h suffix hsuffix => (h suffix hsuffix).symm
    trans := fun hleft hright suffix hsuffix =>
      (hleft suffix hsuffix).trans (hright suffix hsuffix)
  }

/-- Mathlib's `Finpartition` induced by a finite suffix control language on
the exact canonical left-quotient state carrier. -/
noncomputable def experimentPartition
    (M : DFA A X) (regular : M.accepts.IsRegular)
    (tests : Finset (List A)) :
    Finpartition (Finset.univ : Finset (State M)) := by
  classical
  letI : Fintype (State M) := residualFintype M regular
  exact Finpartition.ofSetoid (suffixSetoid M tests)

/-- Membership in a global experiment block is exactly agreement on every
suffix in the declared control language. -/
theorem mem_part_experimentPartition_iff
    (M : DFA A X) (regular : M.accepts.IsRegular)
    (tests : Finset (List A)) (left right : State M) :
    right ∈ (experimentPartition M regular tests).part left ↔
      ∀ suffix ∈ tests,
        (suffix ∈ left.val ↔ suffix ∈ right.val) := by
  classical
  letI : Fintype (State M) := residualFintype M regular
  exact Finpartition.mem_part_ofSetoid_iff_rel

/-- Adding a suffix refines the whole canonical partition simultaneously.
The order on `Finpartition` points from fine to coarse. -/
theorem insert_refines
    (M : DFA A X) (regular : M.accepts.IsRegular)
    (tests : Finset (List A)) (suffix : List A) :
    experimentPartition M regular (insert suffix tests) ≤
      experimentPartition M regular tests := by
  classical
  letI : Fintype (State M) := residualFintype M regular
  intro block hblock
  obtain ⟨representative, hrepresentative⟩ :=
    (experimentPartition M regular (insert suffix tests)).nonempty_of_mem_parts hblock
  have hrepresentativeUniv : representative ∈
      (Finset.univ : Finset (State M)) := Finset.mem_univ _
  refine ⟨(experimentPartition M regular tests).part representative,
    (experimentPartition M regular tests).part_mem.mpr hrepresentativeUniv, ?_⟩
  intro state hstate
  have hpart :
      (experimentPartition M regular (insert suffix tests)).part representative =
        block :=
    (experimentPartition M regular (insert suffix tests)).part_eq_of_mem
      hblock hrepresentative
  have hagreeNew : ∀ word ∈ insert suffix tests,
      (word ∈ representative.val ↔ word ∈ state.val) :=
    (mem_part_experimentPartition_iff M regular
      (insert suffix tests) representative state).mp (by
        rw [hpart]
        exact hstate)
  exact (mem_part_experimentPartition_iff M regular tests
    representative state).mpr fun word hword =>
      hagreeNew word (Finset.mem_insert_of_mem hword)

/-- A suffix separates an unordered pair when the two residual languages
disagree on membership of that suffix. -/
def Separates (pair : Sym2 (State M)) (suffix : List A) : Prop :=
  Sym2.lift
    ⟨fun left right => ¬(suffix ∈ left.val ↔ suffix ∈ right.val),
      fun left right => not_iff_not.mpr Iff.comm⟩ pair

@[simp] theorem separates_mk_iff
    (left right : State M) (suffix : List A) :
    Separates s(left, right) suffix ↔
      ¬(suffix ∈ left.val ↔ suffix ∈ right.val) := by
  rfl

/-- Distinct canonical residual states have a distinguishing suffix.  This is
the extensional witness content of their being distinct languages. -/
theorem exists_separator_of_not_isDiag
    (pair : Sym2 (State M)) (hpair : ¬pair.IsDiag) :
    ∃ suffix, Separates pair suffix := by
  induction pair using Sym2.ind with
  | _ left right =>
      have hne : left ≠ right := by
        simpa [Sym2.mk_isDiag_iff] using hpair
      by_contra hnone
      push_neg at hnone
      apply hne
      apply Subtype.ext
      ext suffix
      exact hnone suffix

/-- One chosen distinguishing suffix for an unordered unequal residual pair.
The choice is classical; the resulting theorem is checked but is not an
executable witness search. -/
noncomputable def chosenSeparator
    (pair : { pair : Sym2 (State M) // ¬pair.IsDiag }) : List A :=
  Classical.choose (exists_separator_of_not_isDiag pair.val pair.prop)

theorem chosenSeparator_separates
    (pair : { pair : Sym2 (State M) // ¬pair.IsDiag }) :
    Separates pair.val (chosenSeparator pair) :=
  Classical.choose_spec (exists_separator_of_not_isDiag pair.val pair.prop)

/-- The global control language containing one chosen witness for every
unordered pair of distinct canonical residual states. -/
noncomputable def completeWitnesses
    (M : DFA A X) (regular : M.accepts.IsRegular) : Finset (List A) := by
  classical
  letI : Fintype (State M) := residualFintype M regular
  exact Finset.univ.image chosenSeparator

/-- There are at most `choose n 2` globally chosen suffix witnesses.  Duplicate
suffixes for different pairs only make the control language smaller. -/
theorem card_completeWitnesses_le_choose_two
    (M : DFA A X) (regular : M.accepts.IsRegular) :
    (completeWitnesses M regular).card ≤
      Nat.choose (stateCount M regular) 2 := by
  classical
  letI : Fintype (State M) := residualFintype M regular
  calc
    (completeWitnesses M regular).card ≤
        Fintype.card { pair : Sym2 (State M) // ¬pair.IsDiag } := by
      simpa [completeWitnesses] using
        (Finset.card_image_le :
          (Finset.univ.image
            (chosenSeparator (M := M))).card ≤ Finset.univ.card)
    _ = Nat.choose (stateCount M regular) 2 := by
      simpa [stateCount] using
        (Sym2.card_subtype_not_diag (α := State M))

/-- Agreement on the complete global witness language forces equality of
canonical residual states. -/
theorem eq_of_agree_completeWitnesses
    (M : DFA A X) (regular : M.accepts.IsRegular)
    (left right : State M)
    (hagree : ∀ suffix ∈ completeWitnesses M regular,
      (suffix ∈ left.val ↔ suffix ∈ right.val)) :
    left = right := by
  classical
  letI : Fintype (State M) := residualFintype M regular
  by_contra hne
  have hnotDiag : ¬(s(left, right) : Sym2 (State M)).IsDiag := by
    simpa [Sym2.mk_isDiag_iff] using hne
  let pair : { pair : Sym2 (State M) // ¬pair.IsDiag } :=
    ⟨s(left, right), hnotDiag⟩
  have hwitness : chosenSeparator pair ∈ completeWitnesses M regular := by
    apply Finset.mem_image.mpr
    exact ⟨pair, Finset.mem_univ _, rfl⟩
  have hsame := hagree (chosenSeparator pair) hwitness
  have hseparates := chosenSeparator_separates pair
  exact (separates_mk_iff left right (chosenSeparator pair)).mp
    hseparates hsame

/-- The global witness partition is discrete: its block relation is equality.
This is the checked partition-level certificate missing from arbitrary
fixed-cardinality histories. -/
theorem mem_completePartition_part_iff_eq
    (M : DFA A X) (regular : M.accepts.IsRegular)
    (left right : State M) :
    right ∈ (experimentPartition M regular
      (completeWitnesses M regular)).part left ↔ left = right := by
  constructor
  · intro hmem
    exact eq_of_agree_completeWitnesses M regular left right
      ((mem_part_experimentPartition_iff M regular
        (completeWitnesses M regular) left right).mp hmem)
  · rintro rfl
    classical
    letI : Fintype (State M) := residualFintype M regular
    exact (experimentPartition M regular
      (completeWitnesses M regular)).mem_part (Finset.mem_univ _)

end CanonicalResidualPartition

end Pairfield
