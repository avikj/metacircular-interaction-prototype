/-

The note's first `N` matrices have one visible coarse Smith record and require
pairwise distinct next row coefficients.  This file exposes those two maps and
connects exact decoding to Mathlib's finite-cardinality order.
-/
import Pairfield.FiniteInformation
import Mathlib.Data.Fintype.Card

namespace Pairfield

/-- The constructor family selected at the cut in the Smith witness. -/
inductive SmithStepKind
  | columnResidual
  deriving DecidableEq

/-- The visible `(kind, pivot, remainder)` record from the note. -/
structure SmithCoarseRecord where
  kind : SmithStepKind
  pivot : Int
  remainder : Int
  deriving DecidableEq

/-- Every witness `A_q`, `q < N`, exposes the same coarse record. -/
def smithCoarse {N : Nat} (_q : Fin N) : SmithCoarseRecord :=
  ⟨.columnResidual, 2, 1⟩

/-- Exact continuation of the installed constructor must emit coefficient `-q`. -/
def smithResponse {N : Nat} (q : Fin N) : Int :=
  -(q : Int)

theorem smithResponse_injective {N : Nat} :
    Function.Injective (smithResponse (N := N)) := by
  intro q r h
  apply Fin.ext
  exact_mod_cast Int.neg_inj.mp h

/-- The general target-fiber theorem applies literally to the Smith cut. -/
theorem smithTargetFiber_injects_memory {N : Nat} {C : Type*}
    (memory : Fin N → C)
    (decode : SmithCoarseRecord → C → Int)
    (hdecode : ∀ q, decode (smithCoarse q) (memory q) = smithResponse q) :
    ∃ encode : TargetFiber (smithCoarse (N := N)) (smithResponse (N := N))
        ⟨.columnResidual, 2, 1⟩ → C,
      Function.Injective encode :=
  targetFiber_injects_side smithCoarse smithResponse memory decode hdecode
    ⟨.columnResidual, 2, 1⟩

/-- Exact decoding preserves the `N` distinct response classes in memory. -/
theorem smithMemory_injective {N : Nat} {C : Type*}
    (memory : Fin N → C)
    (decode : SmithCoarseRecord → C → Int)
    (hdecode : ∀ q, decode (smithCoarse q) (memory q) = smithResponse q) :
    Function.Injective memory := by
  intro q r hmemory
  apply smithResponse_injective
  calc
    smithResponse q = decode (smithCoarse q) (memory q) := (hdecode q).symm
    _ = decode (smithCoarse r) (memory r) := by
      rw [hmemory]
      simp [smithCoarse]
    _ = smithResponse r := hdecode r

/-- Mathlib cardinality transport gives the note's finite lower bound. -/
theorem smithMemory_card_lower_bound {N : Nat} {C : Type*}
    [Fintype C] (memory : Fin N → C)
    (decode : SmithCoarseRecord → C → Int)
    (hdecode : ∀ q, decode (smithCoarse q) (memory q) = smithResponse q) :
    N ≤ Fintype.card C := by
  simpa using Fintype.card_le_of_injective memory
    (smithMemory_injective memory decode hdecode)

/-- Retaining `q` itself attains the bound. -/
theorem smithQuotientMemory_attains {N : Nat} :
    ∃ memory : Fin N → Fin N,
      Function.Bijective memory ∧
      ∃ decode : SmithCoarseRecord → Fin N → Int,
        ∀ q, decode (smithCoarse q) (memory q) = smithResponse q := by
  refine ⟨id, Function.bijective_id, fun _ q => -(q : Int), ?_⟩
  intro q
  rfl

/-- False-model control: a constant response is decoded with one memory state. -/
theorem constantResponse_needs_no_side_state {N : Nat} (value : Int) :
    ∃ memory : Fin N → Unit,
      ∃ decode : SmithCoarseRecord → Unit → Int,
        ∀ q, decode (smithCoarse q) (memory q) = value := by
  exact ⟨fun _ => (), fun _ _ => value, fun _ => rfl⟩

end Pairfield
