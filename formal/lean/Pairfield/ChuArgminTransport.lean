/- Pairing-preserving Chu maps transport a proof-relevant local selection. -/
import Pairfield.FiniteChuCalibration
import Pairfield.ArgminDecomposition

namespace Pairfield.FiniteChu

open scoped Classical

noncomputable def pairCost (C : FiniteChu) (r : C.response) (x : C.state) : Nat :=
  if C.pair x r then 0 else 1

def IsPairArgmin (C : FiniteChu) (r : C.response) (x : C.state) : Prop :=
  ∀ y : C.state, pairCost C r x ≤ pairCost C r y

/-- A Chu pairing equivalence preserves the selected witness for its binary
cost.  Surjectivity is the exact condition needed to compare every target
state with a source representative; the witness itself is retained as
`stateMap x`, rather than only its scalar cost. -/
theorem Hom.isPairArgmin_transport (f : Hom C D)
    (hstate : Function.Surjective f.stateMap)
    (r : C.response) (x : C.state)
    (hx : IsPairArgmin C r x) :
    IsPairArgmin D (f.responseMap r) (f.stateMap x) := by
  classical
  intro y
  obtain ⟨y', rfl⟩ := hstate y
  have hcost (z : C.state) :
      pairCost D (f.responseMap r) (f.stateMap z) = pairCost C r z := by
    simp only [pairCost, f.pair_naturality]
  rw [hcost x, hcost y']
  exact hx y'

theorem bitIdentity_pairArgmin_transport (r x : bit.state)
    (hx : IsPairArgmin bit r x) :
    IsPairArgmin bit r x := by
  exact bitIdentity.isPairArgmin_transport
    Function.surjective_id r x hx

end Pairfield.FiniteChu
