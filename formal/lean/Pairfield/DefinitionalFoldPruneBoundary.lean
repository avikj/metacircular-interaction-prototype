/-
The finite cardinality kernel behind the concept-gate argument in
`notes/THE_CONCEPT_GATE_WAS_UNSATISFIABLE.md`.

This file deliberately does not model the repository's Haskell rewrite
engine.  Its load-bearing premise is an explicit decoder on the selected
finite probe: unfolding the fresh normal form must recover the old one.  Once
that map is supplied, finite-image monotonicity is pure data processing.
-/
import Mathlib

namespace Pairfield.DefinitionalFoldPruneBoundary

universe u v w

/-- On the selected probe, `unfold` decodes every after-view back to its
before-view.  This is the exact premise needed by the cardinality argument. -/
def UnfoldsOn {X : Type u} {Before : Type v} {After : Type w}
    (sample : Finset X) (before : X → Before) (after : X → After)
    (unfold : After → Before) : Prop :=
  ∀ x ∈ sample, unfold (after x) = before x

/-- The reverse coding equation, used only for the exact-equality theorem. -/
def RefoldsOn {X : Type u} {Before : Type v} {After : Type w}
    (sample : Finset X) (before : X → Before) (after : X → After)
    (refold : Before → After) : Prop :=
  ∀ x ∈ sample, refold (before x) = after x

/-- Number of distinct outputs actually realized on the finite probe. -/
def distinctCount {X : Type u} {Y : Type v} [DecidableEq Y]
    (sample : Finset X) (view : X → Y) : ℕ :=
  (sample.image view).card

/-- The natural-valued version of before-count minus after-count.  Since
natural subtraction truncates, a nonpositive mathematical margin becomes
exactly zero here. -/
def natMarginalPrune {X : Type u} {Before : Type v} {After : Type w}
    [DecidableEq Before] [DecidableEq After]
    (sample : Finset X) (before : X → Before) (after : X → After) : ℕ :=
  distinctCount sample before - distinctCount sample after

/-- The integer-valued margin matching the sign-sensitive statement
`beforeCount - afterCount ≤ 0`. -/
def intMarginalPrune {X : Type u} {Before : Type v} {After : Type w}
    [DecidableEq Before] [DecidableEq After]
    (sample : Finset X) (before : X → Before) (after : X → After) : ℤ :=
  (distinctCount sample before : ℤ) - distinctCount sample after

/-- A supplied decoder makes the realized before-image exactly the image of
the realized after-image under that decoder. -/
theorem image_before_eq_image_unfold_after
    {X : Type u} {Before : Type v} {After : Type w}
    [DecidableEq Before] [DecidableEq After]
    (sample : Finset X) (before : X → Before) (after : X → After)
    (unfold : After → Before) (h : UnfoldsOn sample before after unfold) :
    sample.image before = (sample.image after).image unfold := by
  ext value
  constructor
  · intro hvalue
    rcases Finset.mem_image.mp hvalue with ⟨x, hx, rfl⟩
    apply Finset.mem_image.mpr
    refine ⟨after x, Finset.mem_image.mpr ⟨x, hx, rfl⟩, ?_⟩
    exact h x hx
  · intro hvalue
    rcases Finset.mem_image.mp hvalue with ⟨fresh, hfresh, rfl⟩
    rcases Finset.mem_image.mp hfresh with ⟨x, hx, rfl⟩
    apply Finset.mem_image.mpr
    exact ⟨x, hx, (h x hx).symm⟩

/-- Data processing on a finite probe: if every after-output decodes to the
before-output, the after-view realizes at least as many distinct values. -/
theorem distinctCount_before_le_after
    {X : Type u} {Before : Type v} {After : Type w}
    [DecidableEq Before] [DecidableEq After]
    (sample : Finset X) (before : X → Before) (after : X → After)
    (unfold : After → Before) (h : UnfoldsOn sample before after unfold) :
    distinctCount sample before ≤ distinctCount sample after := by
  rw [distinctCount, distinctCount,
    image_before_eq_image_unfold_after sample before after unfold h]
  exact Finset.card_image_le

/-- In `ℕ`, the alleged positive prune is forced to the truncated value zero. -/
theorem natMarginalPrune_eq_zero
    {X : Type u} {Before : Type v} {After : Type w}
    [DecidableEq Before] [DecidableEq After]
    (sample : Finset X) (before : X → Before) (after : X → After)
    (unfold : After → Before) (h : UnfoldsOn sample before after unfold) :
    natMarginalPrune sample before after = 0 := by
  exact Nat.sub_eq_zero_of_le
    (distinctCount_before_le_after sample before after unfold h)

/-- In `ℤ`, where the sign is retained, the same result is nonpositivity. -/
theorem intMarginalPrune_nonpos
    {X : Type u} {Before : Type v} {After : Type w}
    [DecidableEq Before] [DecidableEq After]
    (sample : Finset X) (before : X → Before) (after : X → After)
    (unfold : After → Before) (h : UnfoldsOn sample before after unfold) :
    intMarginalPrune sample before after ≤ 0 := by
  rw [intMarginalPrune, sub_nonpos]
  exact_mod_cast distinctCount_before_le_after sample before after unfold h

/-- If both encodings decode each other on the probe, their numbers of
realized outputs are exactly equal.  No global inverse laws are required. -/
theorem distinctCount_eq_of_unfolds_refolds
    {X : Type u} {Before : Type v} {After : Type w}
    [DecidableEq Before] [DecidableEq After]
    (sample : Finset X) (before : X → Before) (after : X → After)
    (unfold : After → Before) (refold : Before → After)
    (hunfold : UnfoldsOn sample before after unfold)
    (hrefold : RefoldsOn sample before after refold) :
    distinctCount sample before = distinctCount sample after := by
  apply Nat.le_antisymm
  · exact distinctCount_before_le_after sample before after unfold hunfold
  · exact distinctCount_before_le_after sample after before refold hrefold

/-! ## Hostile control: remove the decoder and pruning can be positive. -/

def twoPointBefore : Bool → Bool := id

def twoPointCollapse : Bool → Bool := fun _ => false

theorem twoPoint_before_count :
    distinctCount Finset.univ twoPointBefore = 2 := by
  decide

theorem twoPoint_collapse_count :
    distinctCount Finset.univ twoPointCollapse = 1 := by
  decide

theorem twoPoint_positive_nat_prune :
    natMarginalPrune Finset.univ twoPointBefore twoPointCollapse = 1 := by
  decide

/-- No function out of the collapsed after-view can recover both old values. -/
theorem twoPoint_no_unfold :
    ¬∃ unfold : Bool → Bool,
      UnfoldsOn Finset.univ twoPointBefore twoPointCollapse unfold := by
  rintro ⟨unfold, h⟩
  have hfalse := h false (by simp)
  have htrue := h true (by simp)
  exact Bool.false_ne_true (hfalse.symm.trans htrue)

end Pairfield.DefinitionalFoldPruneBoundary
