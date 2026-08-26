/-
Copyright (c) 2026 Avik Jain and the mathematics collaboration.
Released under Apache 2.0 license.

Proof-relevant finite dynamic programming: a minimum assembled from branch
witnesses is itself a global minimum.  The witness is retained throughout;
this is stronger than an equality of scalar optimum values.
-/
import Mathlib.Data.Finset.Basic

namespace Pairfield

universe u v

/- A certificate that `x` is an argmin on a finite search space. -/
def IsArgmin {α : Type u} {κ : Type v} (cost : α → κ)
    [LE κ] (search : Finset α) (x : α) : Prop :=
  x ∈ search ∧ ∀ y ∈ search, cost x ≤ cost y

theorem argmin_decompose
    {α : Type u} {ι : Type v} {κ : Type*}
    [LinearOrder κ] [DecidableEq α] [DecidableEq ι]
    (cost : α → κ) (search : Finset α) (indices : Finset ι)
    (block : ι → Finset α) (witness : ι → α) (chosen : ι)
    (hcover : ∀ x ∈ search, ∃ i ∈ indices, x ∈ block i)
    (hblock : ∀ i ∈ indices, ∀ x ∈ block i, x ∈ search)
    (hwitness : ∀ i ∈ indices, witness i ∈ block i)
    (hlocal : ∀ i ∈ indices, ∀ x ∈ block i, cost (witness i) ≤ cost x)
    (hchosen : chosen ∈ indices)
    (houter : ∀ i ∈ indices, cost (witness chosen) ≤ cost (witness i)) :
    IsArgmin cost search (witness chosen) := by
  refine ⟨?_, ?_⟩
  · exact hblock chosen hchosen (witness chosen) (hwitness chosen hchosen)
  · intro x hx
    obtain ⟨i, hi, hxi⟩ := hcover x hx
    exact le_trans (houter i hi) (hlocal i hi x hxi)

end Pairfield
