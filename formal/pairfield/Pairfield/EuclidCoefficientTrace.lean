import Pairfield.DiagonalSmithRoute

/-!
# Replayable coefficient formation for Euclidean matrix words

`DiagonalSmithRoute` prices a first use of an integer quotient by one opaque
acquisition unit.  This module refines that boundary in one explicitly declared
grammar: start at zero; `inc` adds one and `dec` subtracts one.  A coefficient
witness retains both the resulting integer and a proof that its trace replays.

The grammar is intentionally unary.  Its length is replay work in this
alphabet, not bit complexity and not an optimal integer-construction cost.
-/

namespace Pairfield

/-- The signed unit-step alphabet used to form an integer coefficient. -/
inductive SignedUnitStep
  | inc
  | dec
  deriving DecidableEq, Repr

namespace SignedUnitStep

def apply : SignedUnitStep → Int → Int
  | .inc, z => z + 1
  | .dec, z => z - 1

end SignedUnitStep

/-- Replay a signed construction trace, with the head acting first. -/
def runCoefficientTrace : Int → List SignedUnitStep → Int
  | z, [] => z
  | z, step :: steps =>
      runCoefficientTrace (step.apply z) steps

/-- Trace replay composes by threading its intermediate integer. -/
theorem runCoefficientTrace_append
    (z : Int) (u v : List SignedUnitStep) :
    runCoefficientTrace z (u ++ v) =
      runCoefficientTrace (runCoefficientTrace z u) v := by
  induction u generalizing z with
  | nil => rfl
  | cons step steps ih =>
      simp [runCoefficientTrace, ih]

/-- An integer coefficient together with a replayable formation history. -/
structure CoefficientWitness where
  value : Int
  trace : List SignedUnitStep
  valid : runCoefficientTrace 0 trace = value

namespace CoefficientWitness

/-- Historical replay work in the declared signed-unit alphabet. -/
def cost (w : CoefficientWitness) : Nat :=
  w.trace.length

def zero : CoefficientWitness :=
  ⟨0, [], by decide⟩

def one : CoefficientWitness :=
  ⟨1, [.inc], by decide⟩

def two : CoefficientWitness :=
  ⟨2, [.inc, .inc], by decide⟩

def negOne : CoefficientWitness :=
  ⟨-1, [.dec], by decide⟩

def negFive : CoefficientWitness :=
  ⟨-5, [.dec, .dec, .dec, .dec, .dec], by decide⟩

/-- A causally longer but equally valid construction of coefficient one. -/
def paddedOne : CoefficientWitness :=
  ⟨1, [.inc, .inc, .dec], by decide⟩

theorem one_paddedOne_same_value_different_cost :
    one.value = paddedOne.value ∧
      one.cost = 1 ∧ paddedOne.cost = 3 := by
  decide

/-- Integer value does not determine the historical work of a valid
coefficient construction.

**The `+2` in `paddedOne` is forced, and this theorem is tight at the parity
quotient.**  `inc` adds one and `dec` subtracts one, so every step flips the
parity of the running integer and `value ≡ cost (mod 2)` identically.  `value`
is thus a *partial* decoder: it recovers `cost mod 2` exactly and nothing
further, so no counterexample can pad by an odd amount, and `3` against `1` is
the least gap available.

Proved in `Pairfield/YugmaPurana_TheEvenPaddingIsForcedAndTheDeterminantSaysWhy.lean`:
`runCoefficientTrace_emod_two`, `CoefficientWitness.value_emod_two`, and
`CoefficientWitness.value_forces_cost_parity`.  That module also shows this is
the same obstruction as `no_historical_actionCost_decoder`'s, which is proved
by determinants and mentions no arithmetic on `Int` at all — both are
length-graded sign homomorphisms, `(-1)^length` and `length mod 2`. -/
theorem no_value_cost_decoder :
    ¬ ∃ price : Int → Nat,
        ∀ w : CoefficientWitness, price w.value = w.cost := by
  rintro ⟨price, hprice⟩
  have hone := hprice one
  have hpadded := hprice paddedOne
  obtain ⟨hvalue, honeCost, hpaddedCost⟩ :=
    one_paddedOne_same_value_different_cost
  rw [← hvalue, hpaddedCost] at hpadded
  rw [honeCost] at hone
  omega

end CoefficientWitness

namespace WitnessedCoefficientWord

/-- Forget proof histories and retain only the quotient values. -/
def values (word : List CoefficientWitness) : List Int :=
  word.map CoefficientWitness.value

/-- Cache state after a word of proof-bearing quotient applications. -/
def finalCache : List Int → List CoefficientWitness → List Int
  | cache, [] => cache
  | cache, w :: word =>
      finalCache (QuotientCache.acquire cache w.value) word

/-- One unit per Euclidean action, plus the supplied construction-trace length
the first time its integer coefficient is acquired. -/
def cost : List Int → List CoefficientWitness → Nat
  | _, [] => 0
  | cache, w :: word =>
      1 + (if w.value ∈ cache then 0 else w.cost) +
        cost (QuotientCache.acquire cache w.value) word

/-- Erasing formation histories recovers exactly the old value-cache state. -/
theorem finalCache_eq_valueCache
    (cache : List Int) (word : List CoefficientWitness) :
    finalCache cache word =
      QuotientCache.finalCache cache (values word) := by
  induction word generalizing cache with
  | nil => rfl
  | cons w word ih =>
      simp [finalCache, values, QuotientCache.finalCache, ih]

/-- Proof-bearing cache evolution composes over concatenation. -/
theorem finalCache_append
    (cache : List Int) (u v : List CoefficientWitness) :
    finalCache cache (u ++ v) = finalCache (finalCache cache u) v := by
  induction u generalizing cache with
  | nil => rfl
  | cons w word ih =>
      simp [finalCache, ih]

/-- Witness-weighted formation cost retains the cache-threaded cocycle law. -/
theorem cost_append
    (cache : List Int) (u v : List CoefficientWitness) :
    cost cache (u ++ v) = cost cache u + cost (finalCache cache u) v := by
  induction u generalizing cache with
  | nil => simp [cost, finalCache]
  | cons w word ih =>
      simp [cost, finalCache, ih, Nat.add_assoc]

end WitnessedCoefficientWord

/-- Proof-bearing formation of the serialized `diag(6,10)` quotient word. -/
def kuttaka610WitnessedCoefficients : List CoefficientWitness :=
  [CoefficientWitness.zero,
   CoefficientWitness.one,
   CoefficientWitness.one,
   CoefficientWitness.two,
   CoefficientWitness.negOne,
   CoefficientWitness.negFive]

/-- Erasure returns the exact coefficient word already used by the checked
matrix transcript. -/
theorem kuttaka610WitnessedCoefficients_values :
    WitnessedCoefficientWord.values kuttaka610WitnessedCoefficients =
      kuttaka610Transcript.coefficientWord := by
  decide

/-- Six matrix applications plus signed-unary formation lengths
`0+1+2+1+5` cost fifteen from empty and six after retaining all values. -/
theorem kuttaka610WitnessedCoefficients_costs :
    WitnessedCoefficientWord.cost [] kuttaka610WitnessedCoefficients = 15 ∧
      WitnessedCoefficientWord.cost [0, 1, 2, -1, -5]
        kuttaka610WitnessedCoefficients = 6 := by
  decide

end Pairfield
