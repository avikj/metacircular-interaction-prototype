/-
Copyright (c) 2026 Avik Jain and the mathematics collaboration.
Released under Apache 2.0 license.

The information boundary of a build gate: restricting a module-health vector
to a checked dependency closure loses exactly the unchecked coordinates.
-/
import Mathlib.Data.Finset.Card

namespace Pairfield.BuildCoverageChannel

universe u

variable {ι : Type u} [DecidableEq ι]

/-- One Boolean health coordinate for every module. -/
abbrev Health := ι → Bool

/-- The type of module indices visible to the declared gate. -/
abbrev Covered (checked : Finset ι) := {i : ι // i ∈ checked}

/-- The type of module indices omitted by the declared gate. -/
abbrev Hidden (checked : Finset ι) := {i : ι // i ∉ checked}

/-- The gate's output alphabet: health values on covered modules. -/
abbrev Observation (checked : Finset ι) := Covered checked → Bool

/-- Restrict a full health assignment to the checked dependency closure. -/
def observe (checked : Finset ι) (health : Health (ι := ι)) :
    Observation checked :=
  fun i => health i.1

/-- The complementary, deliberately unobserved coordinates. -/
def hidden (checked : Finset ι) (health : Health (ι := ι)) :
    Hidden checked → Bool :=
  fun i => health i.1

/-- Reassemble covered and hidden coordinates into a full health assignment. -/
def merge (checked : Finset ι) (seen : Observation checked)
    (unseen : Hidden checked → Bool) : Health (ι := ι) :=
  fun i => if hi : i ∈ checked then seen ⟨i, hi⟩ else unseen ⟨i, hi⟩

/-- A full health vector is exactly its observed and hidden coordinates. -/
def splitEquiv (checked : Finset ι) :
    Health (ι := ι) ≃ Observation checked × (Hidden checked → Bool) where
  toFun health := (observe checked health, hidden checked health)
  invFun parts := merge checked parts.1 parts.2
  left_inv health := by
    funext i
    by_cases hi : i ∈ checked <;> simp [merge, observe, hidden, hi]
  right_inv parts := by
    rcases parts with ⟨seen, unseen⟩
    apply Prod.ext
    · funext i
      simp [observe, merge, i.property]
    · funext i
      simp [hidden, merge, i.property]

/-- Every gate observation has exactly the hidden-assignment ambiguity. -/
def observationFiberEquivHidden (checked : Finset ι)
    (seen : Observation checked) :
    {health : Health (ι := ι) // observe checked health = seen} ≃
      (Hidden checked → Bool) where
  toFun health := hidden checked health.1
  invFun unseen :=
    ⟨merge checked seen unseen, by
      funext i
      simp [observe, merge, i.property]⟩
  left_inv health := by
    apply Subtype.ext
    funext i
    by_cases hi : i ∈ checked
    · simp only [merge, hi, dite_true]
      exact (congrFun health.property ⟨i, hi⟩).symm
    · simp [merge, hidden, hi]
  right_inv unseen := by
    funext i
    simp [hidden, merge, i.property]

omit [DecidableEq ι] in
/-- Equal gate outputs mean equality on exactly the covered coordinates. -/
theorem observe_eq_iff (checked : Finset ι) (left right : Health (ι := ι)) :
    observe checked left = observe checked right ↔
      ∀ i, i ∈ checked → left i = right i := by
  constructor
  · intro h i hi
    exact congrFun h ⟨i, hi⟩
  · intro h
    funext i
    exact h i.1 i.2

/-- Full input reconstruction is possible exactly under universal coverage. -/
theorem observe_injective_iff [Fintype ι] (checked : Finset ι) :
    Function.Injective (observe checked) ↔ checked = Finset.univ := by
  constructor
  · intro hinjective
    apply Finset.eq_univ_iff_forall.mpr
    intro omitted
    by_contra homitted
    let flat : Health (ι := ι) := fun _ => false
    let spike : Health (ι := ι) := fun i => if i = omitted then true else false
    have sameObservation : observe checked flat = observe checked spike := by
      apply (observe_eq_iff checked flat spike).mpr
      intro i hi
      have hine : i ≠ omitted := by
        intro hio
        subst omitted
        exact homitted hi
      simp [flat, spike, hine]
    have sameInput := congrFun (hinjective sameObservation) omitted
    simp [flat, spike] at sameInput
  · intro hcoverage left right sameObservation
    funext i
    apply (observe_eq_iff checked left right).mp sameObservation
    rw [hcoverage]
    exact Finset.mem_univ i

/-- A left decoder for full health exists iff the gate covers every module. -/
theorem hasFullDecoder_iff [Fintype ι] (checked : Finset ι) :
    Function.HasLeftInverse (observe checked) ↔ checked = Finset.univ := by
  constructor
  · intro hdecoder
    exact (observe_injective_iff checked).mp hdecoder.injective
  · intro hcoverage
    exact Function.injective_iff_hasLeftInverse.mp
      ((observe_injective_iff checked).mpr hcoverage)

/-- Terminal checker statuses relevant to the sampled audit. -/
inductive Verdict where
  | failed
  | passedWithWarning
  | passedClean
  deriving DecidableEq, Nonempty

/-- Exit-only reporting forgets whether a successful check warned. -/
def exitBit : Verdict → Bool
  | .failed => false
  | .passedWithWarning => true
  | .passedClean => true

theorem exitBit_warning_collision :
    exitBit .passedWithWarning = exitBit .passedClean := rfl

theorem exitBit_not_injective : ¬ Function.Injective exitBit := by
  intro hinjective
  have impossible := hinjective exitBit_warning_collision
  cases impossible

/-- Consequently, no exit-bit decoder reconstructs the declared verdict. -/
theorem noExitBitDecoder : ¬ Function.HasLeftInverse exitBit :=
  fun hdecoder => exitBit_not_injective hdecoder.injective

/-- Adding the warning bit separates the three declared terminal verdicts. -/
def report : Verdict → Bool × Bool
  | .failed => (false, false)
  | .passedWithWarning => (true, true)
  | .passedClean => (true, false)

theorem report_injective : Function.Injective report := by
  intro left right h
  cases left <;> cases right <;> simp_all [report]

theorem report_hasDecoder : Function.HasLeftInverse report :=
  Function.injective_iff_hasLeftInverse.mp report_injective

end Pairfield.BuildCoverageChannel
