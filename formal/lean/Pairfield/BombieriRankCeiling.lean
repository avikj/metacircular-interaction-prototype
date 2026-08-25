import Mathlib

/-!
# Finite spectral controls for the rank--trace ceiling

Exact diagonal examples isolating two facts used in the Bombieri-form audit:

* first and second moments do not determine positive inertia in dimension three;
* the flat-window two-thirds certificate is attained by the six-dimensional
  spectrum `(2, 1, 1, 1, 1, 0)`.
-/

namespace Pairfield.BombieriRankCeiling

open Finset Matrix
open scoped BigOperators Matrix

def moment (k : ℕ) {n : ℕ} (s : Fin n → ℚ) : ℚ :=
  ∑ i, (s i) ^ k

def twoPositive : Fin 3 → ℚ := ![1, 1, -1]

def onePositive : Fin 3 → ℚ := ![5 / 3, -1 / 3, -1 / 3]

theorem moment_one_collision :
    moment 1 twoPositive = 1 ∧ moment 1 onePositive = 1 := by
  norm_num [moment, twoPositive, onePositive, Fin.sum_univ_succ]

theorem moment_two_collision :
    moment 2 twoPositive = 3 ∧ moment 2 onePositive = 3 := by
  norm_num [moment, twoPositive, onePositive, Fin.sum_univ_succ]

theorem moment_three_separates :
    moment 3 twoPositive = 1 ∧ moment 3 onePositive = 41 / 9 := by
  norm_num [moment, twoPositive, onePositive, Fin.sum_univ_succ]

theorem inertia_patterns :
    0 < twoPositive 0 ∧ 0 < twoPositive 1 ∧ twoPositive 2 < 0 ∧
      0 < onePositive 0 ∧ onePositive 1 < 0 ∧ onePositive 2 < 0 := by
  norm_num [twoPositive, onePositive]

def flatCeiling : Fin 6 → ℚ := ![2, 1, 1, 1, 1, 0]

theorem flatCeiling_moments :
    moment 1 flatCeiling = 6 ∧ moment 2 flatCeiling = 8 := by
  norm_num [moment, flatCeiling, Fin.sum_univ_succ]

theorem flatCeiling_certificate :
    4 * moment 1 flatCeiling - moment 2 flatCeiling - 2 * 6 = 4 := by
  norm_num [flatCeiling_moments]

end Pairfield.BombieriRankCeiling
