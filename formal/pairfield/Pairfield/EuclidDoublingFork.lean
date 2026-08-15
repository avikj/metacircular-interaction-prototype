import Pairfield.EuclidFiniteTargetFormation

/-!
# Doubling escapes the signed-unit interval law

Add exactly one constructor to coefficient formation: `double`, sending `z`
to `2*z` at unit replay cost.  The targets `{3,8}` then admit a proof-bearing
fork with shared prefix `0 → 1 → 2`, an increment branch to `3`, and a
two-doubling branch to `8`.

The fork costs five operations when its prefix is retained once.  Replaying
the two enriched traces independently costs seven, while the globally minimal
signed-unit formation costs eight by `EuclidFiniteTargetFormation`.  This is a
strict, checked separation from the unary interval theorem.  No global
minimality claim is made for the enriched five-edge fork.
-/

namespace Pairfield

/-- The signed-unit grammar with one new multiplicative constructor. -/
inductive DoublingCoefficientStep
  | inc
  | dec
  | double
  deriving DecidableEq, Repr

namespace DoublingCoefficientStep

def apply : DoublingCoefficientStep → Int → Int
  | .inc, z => z + 1
  | .dec, z => z - 1
  | .double, z => 2 * z

end DoublingCoefficientStep

/-- Replay an enriched coefficient trace, head first. -/
def runDoublingCoefficientTrace : Int → List DoublingCoefficientStep → Int
  | z, [] => z
  | z, step :: steps =>
      runDoublingCoefficientTrace (step.apply z) steps

theorem runDoublingCoefficientTrace_append
    (z : Int) (u v : List DoublingCoefficientStep) :
    runDoublingCoefficientTrace z (u ++ v) =
      runDoublingCoefficientTrace (runDoublingCoefficientTrace z u) v := by
  induction u generalizing z with
  | nil => rfl
  | cons step steps ih =>
      simp [runDoublingCoefficientTrace, ih]

/-- A proof-bearing edge in the enriched coefficient grammar. -/
structure DoublingCoefficientEdge (source target : Int) where
  trace : List DoublingCoefficientStep
  valid : runDoublingCoefficientTrace source trace = target

namespace DoublingCoefficientEdge

def cost {source target : Int}
    (edge : DoublingCoefficientEdge source target) : Nat :=
  edge.trace.length

def trans {source middle target : Int}
    (first : DoublingCoefficientEdge source middle)
    (second : DoublingCoefficientEdge middle target) :
    DoublingCoefficientEdge source target where
  trace := first.trace ++ second.trace
  valid := by
    rw [runDoublingCoefficientTrace_append, first.valid, second.valid]

theorem cost_trans {source middle target : Int}
    (first : DoublingCoefficientEdge source middle)
    (second : DoublingCoefficientEdge middle target) :
    (first.trans second).cost = first.cost + second.cost := by
  simp [trans, cost]

end DoublingCoefficientEdge

/-- A fork retains its prefix once and then forms both branches. -/
structure DoublingCoefficientFork (root split left right : Int) where
  prefixEdge : DoublingCoefficientEdge root split
  leftBranch : DoublingCoefficientEdge split left
  rightBranch : DoublingCoefficientEdge split right

namespace DoublingCoefficientFork

def leftEdge {root split left right : Int}
    (fork : DoublingCoefficientFork root split left right) :
    DoublingCoefficientEdge root left :=
  fork.prefixEdge.trans fork.leftBranch

def rightEdge {root split left right : Int}
    (fork : DoublingCoefficientFork root split left right) :
    DoublingCoefficientEdge root right :=
  fork.prefixEdge.trans fork.rightBranch

/-- Shared work charges the retained prefix once. -/
def sharedCost {root split left right : Int}
    (fork : DoublingCoefficientFork root split left right) : Nat :=
  fork.prefixEdge.cost + fork.leftBranch.cost + fork.rightBranch.cost

/-- Independent replay forgets that the two endpoint traces share a prefix. -/
def independentCost {root split left right : Int}
    (fork : DoublingCoefficientFork root split left right) : Nat :=
  fork.leftEdge.cost + fork.rightEdge.cost

end DoublingCoefficientFork

namespace KuttakaDoublingFork

def zeroToOne : DoublingCoefficientEdge 0 1 :=
  ⟨[.inc], by decide⟩

/-- The new operation first acts here: `1 ↦ 2`. -/
def oneToTwo : DoublingCoefficientEdge 1 2 :=
  ⟨[.double], by decide⟩

def zeroToTwo : DoublingCoefficientEdge 0 2 :=
  zeroToOne.trans oneToTwo

def twoToThree : DoublingCoefficientEdge 2 3 :=
  ⟨[.inc], by decide⟩

def twoToEight : DoublingCoefficientEdge 2 8 :=
  ⟨[.double, .double], by decide⟩

/-- A genuine enriched fork at coefficient two. -/
def threeEightFork : DoublingCoefficientFork 0 2 3 8 where
  prefixEdge := zeroToTwo
  leftBranch := twoToThree
  rightBranch := twoToEight

theorem endpoint_replay :
    runDoublingCoefficientTrace 0 threeEightFork.leftEdge.trace = 3 ∧
      runDoublingCoefficientTrace 0 threeEightFork.rightEdge.trace = 8 := by
  exact ⟨threeEightFork.leftEdge.valid, threeEightFork.rightEdge.valid⟩

theorem edge_costs :
    zeroToOne.cost = 1 ∧
      oneToTwo.cost = 1 ∧
      zeroToTwo.cost = 2 ∧
      twoToThree.cost = 1 ∧
      twoToEight.cost = 2 ∧
      threeEightFork.leftEdge.cost = 3 ∧
      threeEightFork.rightEdge.cost = 4 := by
  decide

/-- The new operation and retained prefix produce the exact cost ladder
`shared enriched < independent enriched < globally minimal unary`. -/
theorem doubling_strictly_escapes_unary_interval :
    threeEightFork.sharedCost = 5 ∧
      threeEightFork.independentCost = 7 ∧
      (FiniteTargetFormation.direct ({3, 8} : Finset Int)).cost = 8 ∧
      threeEightFork.sharedCost < threeEightFork.independentCost ∧
      threeEightFork.independentCost <
        (FiniteTargetFormation.direct ({3, 8} : Finset Int)).cost := by
  decide

/-- In particular, the displayed enriched fork beats every valid unary
formation of the same targets, using the earlier universal lower bound. -/
theorem sharedCost_lt_every_unary
    (formation : FiniteTargetFormation ({3, 8} : Finset Int)) :
    threeEightFork.sharedCost < formation.cost := by
  have hlower :
      (FiniteTargetFormation.upper ({3, 8} : Finset Int) -
        FiniteTargetFormation.lower ({3, 8} : Finset Int)).toNat ≤
        formation.cost :=
    FiniteTargetFormation.intervalWidth_le_cost formation
  have hshared : threeEightFork.sharedCost = 5 := by decide
  have hwidth :
      (FiniteTargetFormation.upper ({3, 8} : Finset Int) -
        FiniteTargetFormation.lower ({3, 8} : Finset Int)).toNat = 8 := by
    decide
  omega

end KuttakaDoublingFork

end Pairfield
