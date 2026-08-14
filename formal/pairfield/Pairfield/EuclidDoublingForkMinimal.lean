import Pairfield.EuclidDoublingFork

/-!
# The doubling fork is globally minimal in its causal unary grammar

The displayed formation of `{3, 8}` uses five operations, but its first
certificate only compared it with independent replay and the signed-unit
subgrammar.  This module closes the remaining finite loophole.

An `AtMostFourFormation` is a causally ordered unary operation DAG with four
optional slots.  Every active slot applies `inc`, `dec`, or `double` to the
root zero or to an earlier slot.  An inactive slot emits zero, so formations
with fewer than four operations embed by padding.  Repeated values and reuse of
any earlier value are admitted.  Since every constructor is unary, any causal
formation DAG with at most four operation nodes has such a topological
presentation.

Exact finite decision proves that no such formation contains both `3` and `8`.
A five-slot schedule realizes the already checked fork, so five is the global
minimum in this declared grammar.  Binary operations, supplied nonzero
constants, bit complexity, and non-causal cyclic graphs are outside the model.
-/

namespace Pairfield
namespace KuttakaDoublingFork

local instance : Fintype DoublingCoefficientStep where
  elems := {.inc, .dec, .double}
  complete := by
    intro step
    cases step <;> simp

/-- A slot may be inactive or apply one enriched unary operation to one of the
already formed values. -/
abbrev CausalSlot (priorCount : Nat) :=
  Option (Fin priorCount × DoublingCoefficientStep)

private def runSlot {priorCount : Nat}
    (prior : Fin priorCount → Int) : CausalSlot priorCount → Int
  | none => 0
  | some (parent, step) => step.apply (prior parent)

/-- The complete finite type of causal `inc/dec/double` formations using at
most four operation nodes.  Slot `n` may read only the root or slots `< n`. -/
structure AtMostFourFormation where
  first : CausalSlot 1
  second : CausalSlot 2
  third : CausalSlot 3
  fourth : CausalSlot 4
  deriving DecidableEq, Fintype

namespace AtMostFourFormation

def valueOne (formation : AtMostFourFormation) : Int :=
  runSlot (fun _ => 0) formation.first

def valueTwo (formation : AtMostFourFormation) : Int :=
  runSlot ![0, formation.valueOne] formation.second

def valueThree (formation : AtMostFourFormation) : Int :=
  runSlot ![0, formation.valueOne, formation.valueTwo] formation.third

def valueFour (formation : AtMostFourFormation) : Int :=
  runSlot ![0, formation.valueOne, formation.valueTwo,
    formation.valueThree] formation.fourth

/-- The root and all four slot outputs.  Inactive padding contributes only the
already available root value zero. -/
def values (formation : AtMostFourFormation) : Finset Int :=
  {0, formation.valueOne, formation.valueTwo, formation.valueThree,
    formation.valueFour}

def formsBoth (formation : AtMostFourFormation) : Prop :=
  3 ∈ formation.values ∧ 8 ∈ formation.values

/-- No causal formation using at most four declared unary operations forms
both targets.  This decides the complete finite schedule type, not a sampled
collection of traces. -/
theorem not_formsBoth (formation : AtMostFourFormation) :
    ¬ formation.formsBoth := by
  native_decide

end AtMostFourFormation

/-- One additional causally ordered slot, used to place the known fork and the
lower bound inside the same formation model. -/
structure FiveFormation extends AtMostFourFormation where
  fifth : CausalSlot 5
  deriving DecidableEq

namespace FiveFormation

def valueFive (formation : FiveFormation) : Int :=
  runSlot ![0, formation.valueOne, formation.valueTwo, formation.valueThree,
    formation.valueFour] formation.fifth

def values (formation : FiveFormation) : Finset Int :=
  insert formation.valueFive formation.toAtMostFourFormation.values

def formsBoth (formation : FiveFormation) : Prop :=
  3 ∈ formation.values ∧ 8 ∈ formation.values

end FiveFormation

private def parent {n : Nat} (value : Nat) (bound : value < n) : Fin n :=
  ⟨value, bound⟩

/-- The causal schedule corresponding to
`0 → 1 → 2`, then `2 → 3` and `2 → 4 → 8`. -/
def minimalThreeEightFormation : FiveFormation where
  first := some (parent 0 (by decide), .inc)
  second := some (parent 1 (by decide), .double)
  third := some (parent 2 (by decide), .inc)
  fourth := some (parent 2 (by decide), .double)
  fifth := some (parent 4 (by decide), .double)

theorem minimalThreeEightFormation_values :
    minimalThreeEightFormation.valueOne = 1 ∧
      minimalThreeEightFormation.valueTwo = 2 ∧
      minimalThreeEightFormation.valueThree = 3 ∧
      minimalThreeEightFormation.valueFour = 4 ∧
      minimalThreeEightFormation.valueFive = 8 := by
  native_decide

theorem minimalThreeEightFormation_formsBoth :
    minimalThreeEightFormation.formsBoth := by
  native_decide

/-- Five operations suffice, while every causal formation with at most four
operations fails.  This is global minimality inside the exact
`inc/dec/double`, root-zero, unit-operation-cost grammar. -/
theorem threeEight_global_causal_minimum :
    minimalThreeEightFormation.formsBoth ∧
      threeEightFork.sharedCost = 5 ∧
      (∀ formation : AtMostFourFormation, ¬ formation.formsBoth) := by
  exact ⟨minimalThreeEightFormation_formsBoth, by native_decide,
    AtMostFourFormation.not_formsBoth⟩

end KuttakaDoublingFork
end Pairfield
