/-
Copyright (c) 2026 Avik Jain and the mathematics collaboration.
Released under Apache 2.0 license.

The arbitrary-dimensional squarefree tensor theorem has an immediate uniform
consequence: no fixed finite number of pure local products represents
`q₁ = μ * 1_P` on every finite set of prime places.  At `n` places its exact
CP tensor rank over `ℚ` is `n`.

This statement concerns the valuation-bit tensor
`(Fin n → Bool) → ℚ`.  It makes no claim about the bipartite CRT rank of a
residue-class table or the three-factor scalar-radial rank in the finite
Kuznetsov API; those notions group local variables differently.
-/
import Pairfield.PrimeChargeArbitraryRank

namespace Pairfield.PrimeChargeUnboundedLocalRank

open Pairfield.PrimeChargeArbitraryRank

/-- The identically zero pure term, used to pad a decomposition by one
channel. -/
def zeroTerm (n : ℕ) : PureTerm n where
  coefficient := 0
  factor := fun _ _ ↦ 0

/-- Adding a zero channel preserves a rank bound. -/
theorem rankAtMost_succ {n r : ℕ} {weight : Cube n}
    (rankBound : RankAtMost r weight) :
    RankAtMost (r + 1) weight := by
  rcases rankBound with ⟨term, realizes⟩
  let padded : Fin (r + 1) → PureTerm n :=
    Fin.cases (zeroTerm n) term
  refine ⟨padded, ?_⟩
  intro x
  rw [Fin.sum_univ_succ]
  simp [padded, zeroTerm, pureEval, realizes]

/-- Indexed rank bounds are monotone in the number of allowed channels. -/
theorem rankAtMost_mono {n r s : ℕ} {weight : Cube n}
    (hrs : r ≤ s) (rankBound : RankAtMost r weight) :
    RankAtMost s weight := by
  induction s, hrs using Nat.le_induction with
  | base => exact rankBound
  | succ s _ ih => exact rankAtMost_succ ih

/-- Sharp threshold form: on `n` squarefree prime places, every pure-channel
bound strictly below `n` fails. -/
theorem squarefreeChargeCube_not_rankAtMost_of_lt {r n : ℕ}
    (hrn : r < n) :
    ¬ RankAtMost r (squarefreeChargeCube n) := by
  intro rankBound
  have n_ne : n ≠ 0 := by omega
  have hrs : r ≤ n - 1 := by omega
  have padded : RankAtMost (n - 1) (squarefreeChargeCube n) :=
    rankAtMost_mono hrs rankBound
  exact (squarefreeChargeCube_rankExactly n).2.resolve_left n_ne padded

/-- Minimal witness against any proposed fixed finite channel bound: `r+1`
prime places already require more than `r` pure local products. -/
theorem squarefreeChargeCube_exceeds_every_fixed_bound (r : ℕ) :
    ¬ RankAtMost r (squarefreeChargeCube (r + 1)) :=
  squarefreeChargeCube_not_rankAtMost_pred r

/-- Explicit unboundedness with a dimension witness above every proposed
bound. -/
theorem squarefreeChargeCube_rank_unbounded :
    ∀ r : ℕ, ∃ n : ℕ,
      r < n ∧ ¬ RankAtMost r (squarefreeChargeCube n) := by
  intro r
  exact ⟨r + 1, by omega, squarefreeChargeCube_exceeds_every_fixed_bound r⟩

/-- There is no single finite number of pure local tensor channels that works
uniformly over all finite sets of squarefree prime places. -/
theorem no_fixed_uniform_squarefreeChargeCube_rank :
    ¬ ∃ r : ℕ, ∀ n : ℕ, RankAtMost r (squarefreeChargeCube n) := by
  rintro ⟨r, uniform⟩
  exact squarefreeChargeCube_exceeds_every_fixed_bound r (uniform (r + 1))

end Pairfield.PrimeChargeUnboundedLocalRank
