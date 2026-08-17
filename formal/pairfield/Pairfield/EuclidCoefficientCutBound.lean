import Pairfield.EuclidCoefficientForkNoGo
import Mathlib.Data.Finset.Card

/-!
# Exhaustive cut bound for the kuṭṭaka coefficient fork

The recipe comparison in `EuclidCoefficientForkNoGo` exhibits a cheaper pair
of traces, but by itself does not exclude an undiscovered third formation.
Here a reusable signed-unit transition is identified with the integer cut it
crosses: the cut labelled `k` joins `k` and `k + 1`.  A shared formation pays
once for the union of the cuts used by its two traces.

Every trace from `0` to `2` must cross cuts `0` and `1`; every trace from `0`
to `-1` must cross cut `-1`.  Hence every shared signed-unit formation of the
two required coefficients costs at least three distinct transitions.  The
direct pair attains three, closing the fixed no-go exhaustively in this
declared grammar.
-/

namespace Pairfield

namespace SignedUnitStep

/-- The undirected unit cut crossed by one step starting at `z`. -/
def cut : SignedUnitStep → Int → Int
  | .inc, z => z
  | .dec, z => z - 1

end SignedUnitStep

/-- The finite set of reusable integer cuts visited by a signed-unit trace. -/
def coefficientTraceCuts : Int → List SignedUnitStep → Finset Int
  | _, [] => ∅
  | z, step :: steps =>
      insert (step.cut z) (coefficientTraceCuts (step.apply z) steps)

/-- Without crossing cut `k`, a trace starting at or below `k` remains at or
below it. -/
theorem runCoefficientTrace_le_of_cut_not_mem
    (k z : Int) (trace : List SignedUnitStep)
    (hz : z ≤ k) (hcut : k ∉ coefficientTraceCuts z trace) :
    runCoefficientTrace z trace ≤ k := by
  induction trace generalizing z with
  | nil => simpa [runCoefficientTrace] using hz
  | cons step steps ih =>
      simp only [coefficientTraceCuts, Finset.mem_insert, not_or] at hcut
      rcases hcut with ⟨hhead, htail⟩
      have hnext : step.apply z ≤ k := by
        cases step with
        | inc =>
            simp [SignedUnitStep.apply, SignedUnitStep.cut] at hhead ⊢
            omega
        | dec =>
            simp [SignedUnitStep.apply]
            omega
      simpa [runCoefficientTrace] using ih (z := step.apply z) hnext htail

/-- Without crossing cut `k`, a trace starting at or above `k + 1` remains at
or above it. -/
theorem runCoefficientTrace_ge_of_cut_not_mem
    (k z : Int) (trace : List SignedUnitStep)
    (hz : k + 1 ≤ z) (hcut : k ∉ coefficientTraceCuts z trace) :
    k + 1 ≤ runCoefficientTrace z trace := by
  induction trace generalizing z with
  | nil => simpa [runCoefficientTrace] using hz
  | cons step steps ih =>
      simp only [coefficientTraceCuts, Finset.mem_insert, not_or] at hcut
      rcases hcut with ⟨hhead, htail⟩
      have hnext : k + 1 ≤ step.apply z := by
        cases step with
        | inc =>
            simp [SignedUnitStep.apply]
            omega
        | dec =>
            simp [SignedUnitStep.apply, SignedUnitStep.cut] at hhead ⊢
            omega
      simpa [runCoefficientTrace] using ih (z := step.apply z) hnext htail

namespace KuttakaCoefficientCutBound

/-- Any signed-unit trace from zero to two uses cut zero. -/
theorem zero_cut_mem_of_reaches_two
    (trace : List SignedUnitStep)
    (valid : runCoefficientTrace 0 trace = 2) :
    0 ∈ coefficientTraceCuts 0 trace := by
  by_contra hcut
  have hbound :=
    runCoefficientTrace_le_of_cut_not_mem 0 0 trace (by omega) hcut
  rw [valid] at hbound
  omega

/-- Any signed-unit trace from zero to two also uses cut one. -/
theorem one_cut_mem_of_reaches_two
    (trace : List SignedUnitStep)
    (valid : runCoefficientTrace 0 trace = 2) :
    1 ∈ coefficientTraceCuts 0 trace := by
  by_contra hcut
  have hbound :=
    runCoefficientTrace_le_of_cut_not_mem 1 0 trace (by omega) hcut
  rw [valid] at hbound
  omega

/-- Any signed-unit trace from zero to negative one uses cut negative one. -/
theorem negOne_cut_mem_of_reaches_negOne
    (trace : List SignedUnitStep)
    (valid : runCoefficientTrace 0 trace = -1) :
    -1 ∈ coefficientTraceCuts 0 trace := by
  by_contra hcut
  have hbound :=
    runCoefficientTrace_ge_of_cut_not_mem (-1) 0 trace (by omega) hcut
  rw [valid] at hbound
  omega

/-- Two replayable endpoint traces, with each reusable integer cut paid once. -/
structure SharedFormation where
  toTwo : List SignedUnitStep
  toNegOne : List SignedUnitStep
  toTwo_valid : runCoefficientTrace 0 toTwo = 2
  toNegOne_valid : runCoefficientTrace 0 toNegOne = -1

namespace SharedFormation

def cuts (formation : SharedFormation) : Finset Int :=
  coefficientTraceCuts 0 formation.toTwo ∪
    coefficientTraceCuts 0 formation.toNegOne

def cost (formation : SharedFormation) : Nat :=
  formation.cuts.card

/-- The direct pair of endpoint traces from the preceding no-go. -/
def direct : SharedFormation where
  toTwo := [.inc, .inc]
  toNegOne := [.dec]
  toTwo_valid := by decide
  toNegOne_valid := by decide

theorem requiredCuts_subset (formation : SharedFormation) :
    ({-1, 0, 1} : Finset Int) ⊆ formation.cuts := by
  intro k hk
  simp only [Finset.mem_insert, Finset.mem_singleton] at hk
  rcases hk with hneg | hzero | hone
  · subst k
    exact Finset.mem_union_right _
      (negOne_cut_mem_of_reaches_negOne
        formation.toNegOne formation.toNegOne_valid)
  · subst k
    exact Finset.mem_union_left _
      (zero_cut_mem_of_reaches_two formation.toTwo formation.toTwo_valid)
  · subst k
    exact Finset.mem_union_left _
      (one_cut_mem_of_reaches_two formation.toTwo formation.toTwo_valid)

/-- No pair of signed-unit traces reaches both targets using fewer than three
distinct reusable transitions. -/
theorem three_le_cost (formation : SharedFormation) :
    3 ≤ formation.cost := by
  calc
    3 = ({-1, 0, 1} : Finset Int).card := by decide
    _ ≤ formation.cuts.card := Finset.card_le_card (requiredCuts_subset formation)
    _ = formation.cost := rfl

/-- The direct pair attains the universal lower bound. -/
theorem direct_cost : direct.cost = 3 := by
  decide

/-- Exhaustive closure of the fixed false-fork result: the previously found
direct recipe is globally minimal among all shared signed-unit formations. -/
theorem direct_is_minimal :
    direct.cost = 3 ∧ ∀ formation : SharedFormation, 3 ≤ formation.cost :=
  ⟨direct_cost, three_le_cost⟩

end SharedFormation

end KuttakaCoefficientCutBound

end Pairfield
