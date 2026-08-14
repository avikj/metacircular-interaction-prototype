import Mathlib.Data.Finsupp.Basic
import Mathlib.Algebra.BigOperators.Group.Finset.Basic

namespace Pairfield

universe u v

noncomputable section

variable {Kind : Type u} [DecidableEq Kind]
variable {Action : Type v} [DecidableEq Action]

abbrev ResourceBalance (Kind : Type u) := Kind →₀ ℤ

def transactionBalance (balance : Action → ResourceBalance Kind)
    (actions : Finset Action) : ResourceBalance Kind :=
  ∑ action ∈ actions, balance action

theorem transactionBalance_union
    (balance : Action → ResourceBalance Kind)
    (left right : Finset Action) (h : Disjoint left right) :
    transactionBalance balance (left ∪ right) =
      transactionBalance balance left + transactionBalance balance right := by
  simp [transactionBalance, Finset.sum_union h]

def Balanced (balance : Action → ResourceBalance Kind)
    (actions : Finset Action) : Prop :=
  transactionBalance balance actions = 0

theorem balanced_union
    (balance : Action → ResourceBalance Kind)
    {left right : Finset Action} (hdisj : Disjoint left right)
    (hl : Balanced balance left) (hr : Balanced balance right) :
    Balanced balance (left ∪ right) := by
  rw [Balanced, transactionBalance_union balance left right hdisj, hl, hr]
  exact zero_add 0

theorem balanced_union_not_componentwise :
    ∃ (balance : Bool → ResourceBalance Unit)
      (left right : Finset Bool),
      Disjoint left right ∧
      ¬ Balanced balance left ∧ ¬ Balanced balance right ∧
      Balanced balance (left ∪ right) := by
  let p : ResourceBalance Unit := Finsupp.single () 1
  refine ⟨fun b => if b then p else -p, {true}, {false}, by decide, ?_⟩
  simp [Balanced, transactionBalance, p]

theorem transactionBalance_union_without_disjointness_fails :
    ∃ (balance : Unit → ResourceBalance Unit) (actions : Finset Unit),
      transactionBalance balance (actions ∪ actions) ≠
        transactionBalance balance actions + transactionBalance balance actions := by
  let p : ResourceBalance Unit := Finsupp.single () 1
  refine ⟨fun _ => p, {()}, ?_⟩
  simp [transactionBalance, p]

end

end Pairfield
