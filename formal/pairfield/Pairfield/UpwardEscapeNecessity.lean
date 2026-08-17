/-
Copyright (c) 2026 Avik Jain and the mathematics collaboration.
Released under Apache 2.0 license.

A converse pressure on one-sided anti-spike hypotheses.  If a finite family
has a deep negative center but only a small square-energy budget, then every
point of small absolute value must make an almost full upward escape from the
center.  Consequently an upper bound on total upward escape is already a
strong signed-correlation input; it is not supplied by an `L^2` bound alone.
-/
import Pairfield.UpwardEscape

namespace Pairfield

open scoped BigOperators

/-- The number of coordinates whose absolute value is at least `epsilon` is
controlled by the square-energy budget. -/
theorem largeValue_card_mul_sq_le_energy
    {ι : Type*} (a : ι → ℝ) (s : Finset ι) {epsilon : ℝ}
    (hepsilon : 0 ≤ epsilon) :
    (((s.filter fun i ↦ epsilon ≤ |a i|).card : ℝ) * epsilon ^ 2) ≤
      ∑ i ∈ s, (a i) ^ 2 := by
  classical
  let large := s.filter fun i ↦ epsilon ≤ |a i|
  have hpoint : ∀ i ∈ large, epsilon ^ 2 ≤ (a i) ^ 2 := by
    intro i hi
    have hi : epsilon ≤ |a i| := (Finset.mem_filter.mp hi).2
    calc
      epsilon ^ 2 ≤ |a i| ^ 2 :=
        (sq_le_sq₀ hepsilon (abs_nonneg (a i))).2 hi
      _ = (a i) ^ 2 := sq_abs (a i)
  have hlargeToAll :
      (∑ i ∈ large, (a i) ^ 2) ≤ ∑ i ∈ s, (a i) ^ 2 := by
    exact Finset.sum_le_sum_of_subset_of_nonneg (Finset.filter_subset _ _)
      (fun i _ _ ↦ sq_nonneg (a i))
  calc
    ((large.card : ℝ) * epsilon ^ 2) =
        ∑ _i ∈ large, epsilon ^ 2 := by simp
    _ ≤ ∑ i ∈ large, (a i) ^ 2 := by
      exact Finset.sum_le_sum fun i hi ↦ hpoint i hi
    _ ≤ ∑ i ∈ s, (a i) ^ 2 := hlargeToAll

/-- A negative spike and a square-energy bound force a lower bound on total
positive escape.  The right side counts all coordinates except the maximum
number which the energy budget allows to have magnitude at least `epsilon`.

For `depth = c * X`, this is the finite form of
`escape ≥ (c - epsilon/X) X * (|s| - budget/epsilon^2)`. -/
theorem upwardEscape_lower_of_energy
    {ι : Type*} (a : ι → ℝ) (s : Finset ι) (i₀ : ι)
    {depth epsilon budget : ℝ}
    (hepsilon : 0 < epsilon)
    (hepsilonDepth : epsilon < depth)
    (hspike : a i₀ ≤ -depth)
    (henergy : ∑ i ∈ s, (a i) ^ 2 ≤ budget) :
    (depth - epsilon) *
        ((s.card : ℝ) - budget / epsilon ^ 2) ≤
      ∑ i ∈ s, max (a i - a i₀) 0 := by
  classical
  let small := s.filter fun i ↦ |a i| < epsilon
  let large := s.filter fun i ↦ epsilon ≤ |a i|
  have hpartitionNat :=
    Finset.card_filter_add_card_filter_not
      (s := s) (p := fun i ↦ |a i| < epsilon)
  have hpartition :
      (small.card : ℝ) + (large.card : ℝ) = (s.card : ℝ) := by
    exact_mod_cast (by simpa only [not_lt] using hpartitionNat)
  have hlargeEnergy :=
    largeValue_card_mul_sq_le_energy a s (le_of_lt hepsilon)
  have hlargeBudget : (large.card : ℝ) ≤ budget / epsilon ^ 2 := by
    have hepsilonSq : 0 < epsilon ^ 2 := sq_pos_of_pos hepsilon
    apply (le_div_iff₀ hepsilonSq).2
    exact hlargeEnergy.trans henergy
  have hsmallCard :
      (s.card : ℝ) - budget / epsilon ^ 2 ≤ (small.card : ℝ) := by
    linarith
  have hfactor : 0 ≤ depth - epsilon := le_of_lt (sub_pos.mpr hepsilonDepth)
  have hcardScaled :
      (depth - epsilon) *
          ((s.card : ℝ) - budget / epsilon ^ 2) ≤
        (depth - epsilon) * (small.card : ℝ) := by
    exact mul_le_mul_of_nonneg_left hsmallCard hfactor
  have hpoint :
      ∀ i ∈ small, depth - epsilon ≤ max (a i - a i₀) 0 := by
    intro i hi
    have hiAbs : |a i| < epsilon := (Finset.mem_filter.mp hi).2
    have hiLower : -epsilon < a i := (abs_lt.mp hiAbs).1
    have hdelta : depth - epsilon ≤ a i - a i₀ := by linarith
    exact hdelta.trans (le_max_left _ _)
  have hsmallToAll :
      (∑ i ∈ small, max (a i - a i₀) 0) ≤
        ∑ i ∈ s, max (a i - a i₀) 0 := by
    exact Finset.sum_le_sum_of_subset_of_nonneg (Finset.filter_subset _ _)
      (fun i _ _ ↦ le_max_right _ _)
  calc
    (depth - epsilon) *
        ((s.card : ℝ) - budget / epsilon ^ 2) ≤
      (depth - epsilon) * (small.card : ℝ) := hcardScaled
    _ = (small.card : ℝ) * (depth - epsilon) := by ring
    _ = ∑ _i ∈ small, (depth - epsilon) := by
      simp
      ring
    _ ≤ ∑ i ∈ small, max (a i - a i₀) 0 := by
      exact Finset.sum_le_sum fun i hi ↦ hpoint i hi
    _ ≤ ∑ i ∈ s, max (a i - a i₀) 0 := hsmallToAll

end Pairfield
