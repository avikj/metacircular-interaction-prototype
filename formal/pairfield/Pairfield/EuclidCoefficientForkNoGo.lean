import Pairfield.EuclidCoefficientTrace

/-!
# A false shared-prefix formation in the Euclidean coefficient grammar

The checked kuṭṭaka transcript needs coefficients `2` and `-1`.  One can force
both through coefficient `1`, apparently creating a shared prerequisite and a
supermodular cache gain.  This module retains that tempting factorization and
then rejects it: `-1` already has the one-step direct trace `[dec]`, so the
shared fork is never cheaper than the direct pair of formations.

This is a fixed arithmetic counterexample to premature DAG pricing.  It is not
a general classification of addition-chain or witness-DAG caches.
-/

namespace Pairfield

/-- A replayable signed-unit construction between two integer coefficients. -/
structure CoefficientEdge (source target : Int) where
  trace : List SignedUnitStep
  valid : runCoefficientTrace source trace = target

namespace CoefficientEdge

/-- Work in the declared signed-unit alphabet. -/
def cost {source target : Int} (edge : CoefficientEdge source target) : Nat :=
  edge.trace.length

/-- Compose coefficient constructions by replaying their traces in order. -/
def trans {source middle target : Int}
    (first : CoefficientEdge source middle)
    (second : CoefficientEdge middle target) :
    CoefficientEdge source target where
  trace := first.trace ++ second.trace
  valid := by
    rw [runCoefficientTrace_append, first.valid, second.valid]

/-- Composition adds replay work exactly. -/
theorem cost_then {source middle target : Int}
    (first : CoefficientEdge source middle)
    (second : CoefficientEdge middle target) :
    (first.trans second).cost = first.cost + second.cost := by
  simp [trans, cost]

end CoefficientEdge

namespace KuttakaCoefficientFork

def zeroToOne : CoefficientEdge 0 1 :=
  ⟨[.inc], by decide⟩

def oneToTwo : CoefficientEdge 1 2 :=
  ⟨[.inc], by decide⟩

/-- The tempting but nonminimal branch from the shared coefficient `1`. -/
def oneToNegOne : CoefficientEdge 1 (-1) :=
  ⟨[.dec, .dec], by decide⟩

def zeroToTwo : CoefficientEdge 0 2 :=
  zeroToOne.trans oneToTwo

def zeroToNegOneViaOne : CoefficientEdge 0 (-1) :=
  zeroToOne.trans oneToNegOne

/-- The admissible direct formation that destroys the proposed shared fork. -/
def zeroToNegOneDirect : CoefficientEdge 0 (-1) :=
  ⟨[.dec], by decide⟩

theorem edge_costs :
    zeroToOne.cost = 1 ∧
      oneToTwo.cost = 1 ∧
      oneToNegOne.cost = 2 ∧
      zeroToTwo.cost = 2 ∧
      zeroToNegOneViaOne.cost = 3 ∧
      zeroToNegOneDirect.cost = 1 := by
  decide

/-- Cost of forcing both required coefficients through the common node `1`.
The Boolean arguments say whether `2` and `-1` are already retained. -/
def forcedForkCost (retainTwo retainNegOne : Bool) : Nat :=
  (if retainTwo then 0 else oneToTwo.cost) +
    (if retainNegOne then 0 else oneToNegOne.cost) +
    (if retainTwo && retainNegOne then 0 else zeroToOne.cost)

/-- Cost when the direct admissible formations are also visible. -/
def directPairCost (retainTwo retainNegOne : Bool) : Nat :=
  (if retainTwo then 0 else zeroToTwo.cost) +
    (if retainNegOne then 0 else zeroToNegOneDirect.cost)

/-- The recipe chooser pays the cheaper of the forced fork and direct pair. -/
def optimalPairCost (retainTwo retainNegOne : Bool) : Nat :=
  min (forcedForkCost retainTwo retainNegOne)
    (directPairCost retainTwo retainNegOne)

/-- Cache work saved relative to the empty cache for a declared cost model. -/
def workSaved (buildCost : Bool → Bool → Nat)
    (retainTwo retainNegOne : Bool) : Nat :=
  buildCost false false - buildCost retainTwo retainNegOne

/-- The forced factorization does display the predicted increasing returns. -/
theorem forcedFork_workSaved_table :
    workSaved forcedForkCost false false = 0 ∧
      workSaved forcedForkCost true false = 1 ∧
      workSaved forcedForkCost false true = 2 ∧
      workSaved forcedForkCost true true = 4 := by
  decide

theorem forcedFork_increasing_returns :
    workSaved forcedForkCost false true -
        workSaved forcedForkCost false false <
      workSaved forcedForkCost true true -
        workSaved forcedForkCost true false := by
  decide

/-- But that effect was purchased by suppressing the shorter direct edge. -/
theorem forcedFork_not_minimal :
    directPairCost false false < forcedForkCost false false := by
  decide

/-- In every cache state, admitting the direct trace makes the fork inert. -/
theorem optimalPairCost_eq_directPairCost
    (retainTwo retainNegOne : Bool) :
    optimalPairCost retainTwo retainNegOne =
      directPairCost retainTwo retainNegOne := by
  cases retainTwo <;> cases retainNegOne <;> decide

theorem optimal_workSaved_table :
    workSaved optimalPairCost false false = 0 ∧
      workSaved optimalPairCost true false = 2 ∧
      workSaved optimalPairCost false true = 1 ∧
      workSaved optimalPairCost true true = 3 := by
  decide

/-- The apparent strict complementarity becomes equality after lawful recipe
minimization. -/
theorem optimal_pair_is_modular :
    workSaved optimalPairCost true false +
        workSaved optimalPairCost false true =
      workSaved optimalPairCost false false +
        workSaved optimalPairCost true true := by
  decide

end KuttakaCoefficientFork

end Pairfield
