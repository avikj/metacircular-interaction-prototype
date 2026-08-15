/-
Copyright (c) 2026 Avik Jain and the mathematics collaboration.
Released under Apache 2.0 license.

A finite one-sided anti-spike lemma.  Only upward escape from a negative
center is charged; downward motion is free.  The budget is an explicit
hypothesis, and no arithmetic residual is asserted to satisfy it here.
-/
import Mathlib.Algebra.Order.BigOperators.Group.Finset
import Mathlib.Data.Finset.Card
import Mathlib.Data.Real.Basic
import Mathlib.Tactic

namespace Pairfield

open scoped BigOperators

/-- A one-sided first-moment budget bounds the number of points which escape
above half the depth of a negative center.  This is the finite Markov step in
the upward-escape anti-spike argument. -/
theorem upwardEscape_bad_card
    {ι : Type*} (a : ι → ℝ) (s : Finset ι) (i₀ : ι)
    {depth gamma : ℝ}
    (hdepth : 0 < depth)
    (hspike : a i₀ ≤ -depth)
    (hbudget :
      (∑ i ∈ s, max (a i - a i₀) 0) ≤
        gamma * depth * (s.card : ℝ)) :
    ((s.filter fun i ↦ -depth / 2 < a i).card : ℝ) ≤
      2 * gamma * (s.card : ℝ) := by
  classical
  let bad := s.filter fun i ↦ -depth / 2 < a i
  have hpoint : ∀ i ∈ bad, depth / 2 ≤ max (a i - a i₀) 0 := by
    intro i hi
    have hi' : -depth / 2 < a i := (Finset.mem_filter.mp hi).2
    have hdelta : depth / 2 ≤ a i - a i₀ := by linarith
    exact hdelta.trans (le_max_left _ _)
  have hbadSum :
      (bad.card : ℝ) * (depth / 2) ≤
        ∑ i ∈ bad, max (a i - a i₀) 0 := by
    calc
      (bad.card : ℝ) * (depth / 2) = ∑ _i ∈ bad, depth / 2 := by simp
      _ ≤ ∑ i ∈ bad, max (a i - a i₀) 0 := by
        exact Finset.sum_le_sum fun i hi ↦ hpoint i hi
  have hsubset : bad ⊆ s := Finset.filter_subset _ _
  have hbadToAll :
      (∑ i ∈ bad, max (a i - a i₀) 0) ≤
        ∑ i ∈ s, max (a i - a i₀) 0 := by
    exact Finset.sum_le_sum_of_subset_of_nonneg hsubset
      (fun i _ _ ↦ le_max_right _ _)
  have hcombined :
      (bad.card : ℝ) * (depth / 2) ≤
        gamma * depth * (s.card : ℝ) :=
    hbadSum.trans (hbadToAll.trans hbudget)
  have hscaled :
      ((bad.card : ℝ) / 2) * depth ≤
        (gamma * (s.card : ℝ)) * depth := by
    calc
      ((bad.card : ℝ) / 2) * depth =
          (bad.card : ℝ) * (depth / 2) := by ring
      _ ≤ gamma * depth * (s.card : ℝ) := hcombined
      _ = (gamma * (s.card : ℝ)) * depth := by ring
  have hhalf : (bad.card : ℝ) / 2 ≤ gamma * (s.card : ℝ) :=
    le_of_mul_le_mul_right hscaled hdepth
  change (bad.card : ℝ) ≤ 2 * gamma * (s.card : ℝ)
  linarith

/-- At least a `1 - 2 * gamma` proportion of the finite family remains below
half the spike depth.  The inequalities on `gamma` make the proportion
nonnegative; the cardinal estimate itself is valid without them. -/
theorem upwardEscape_good_card
    {ι : Type*} (a : ι → ℝ) (s : Finset ι) (i₀ : ι)
    {depth gamma : ℝ}
    (hdepth : 0 < depth)
    (_hgamma0 : 0 ≤ gamma)
    (_hgammaHalf : gamma < 1 / 2)
    (hspike : a i₀ ≤ -depth)
    (hbudget :
      (∑ i ∈ s, max (a i - a i₀) 0) ≤
        gamma * depth * (s.card : ℝ)) :
    (1 - 2 * gamma) * (s.card : ℝ) ≤
      ((s.filter fun i ↦ a i ≤ -depth / 2).card : ℝ) := by
  classical
  have hbad := upwardEscape_bad_card a s i₀ hdepth hspike hbudget
  have hpartitionNat :=
    Finset.card_filter_add_card_filter_not
      (s := s) (p := fun i ↦ a i ≤ -depth / 2)
  have hpartition :
      ((s.filter fun i ↦ a i ≤ -depth / 2).card : ℝ) +
          ((s.filter fun i ↦ -depth / 2 < a i).card : ℝ) =
        (s.card : ℝ) := by
    exact_mod_cast (by simpa only [not_le] using hpartitionNat)
  linarith

/-- The same one-sided budget forces an explicit square-energy lower bound.
This is the exact finite consequence used before comparison with any global
analytic norm. -/
theorem upwardEscape_energy_lower
    {ι : Type*} (a : ι → ℝ) (s : Finset ι) (i₀ : ι)
    {depth gamma : ℝ}
    (hdepth : 0 < depth)
    (hgamma0 : 0 ≤ gamma)
    (hgammaHalf : gamma < 1 / 2)
    (hspike : a i₀ ≤ -depth)
    (hbudget :
      (∑ i ∈ s, max (a i - a i₀) 0) ≤
        gamma * depth * (s.card : ℝ)) :
    (1 - 2 * gamma) * (s.card : ℝ) * (depth / 2) ^ 2 ≤
      ∑ i ∈ s, (a i) ^ 2 := by
  classical
  let good := s.filter fun i ↦ a i ≤ -depth / 2
  have hcard :=
    upwardEscape_good_card a s i₀ hdepth hgamma0 hgammaHalf hspike hbudget
  have hcardScaled :
      (1 - 2 * gamma) * (s.card : ℝ) * (depth / 2) ^ 2 ≤
        (good.card : ℝ) * (depth / 2) ^ 2 := by
    exact mul_le_mul_of_nonneg_right hcard (sq_nonneg (depth / 2))
  have hpoint : ∀ i ∈ good, (depth / 2) ^ 2 ≤ (a i) ^ 2 := by
    intro i hi
    have hi' : a i ≤ -depth / 2 := (Finset.mem_filter.mp hi).2
    nlinarith [hdepth]
  have hgoodToAll :
      (∑ i ∈ good, (a i) ^ 2) ≤ ∑ i ∈ s, (a i) ^ 2 := by
    exact Finset.sum_le_sum_of_subset_of_nonneg (Finset.filter_subset _ _)
      (fun i _ _ ↦ sq_nonneg (a i))
  calc
    (1 - 2 * gamma) * (s.card : ℝ) * (depth / 2) ^ 2 ≤
        (good.card : ℝ) * (depth / 2) ^ 2 := hcardScaled
    _ = ∑ _i ∈ good, (depth / 2) ^ 2 := by simp
    _ ≤ ∑ i ∈ good, (a i) ^ 2 := by
      exact Finset.sum_le_sum fun i hi ↦ hpoint i hi
    _ ≤ ∑ i ∈ s, (a i) ^ 2 := hgoodToAll

end Pairfield
