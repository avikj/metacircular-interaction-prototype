/-
Lemma 1.3 — no arithmetic Lorentz group (V3 target 2).

the form q(S,D) = S² − D² and orientation is {±I}. Concretely: an integer
2×2 matrix M with Mᵀ · diag(1,−1) · M = diag(1,−1) and det M = 1 is ±I.

Proof: the (0,0) entry of the isometry equation gives a² − c² = 1, i.e.
(a−c)(a+c) = 1 over ℤ, forcing c = 0, a = ±1; the (1,1) entry gives
d² − b² = 1, forcing b = 0, d = ±1; det M = ad = 1 then rules out the mixed
signs, leaving exactly I and −I. (Conversely both are isometries of the form.)
-/
import Mathlib

namespace Pairfield

open Matrix

/-- The 2×2 Minkowski form diag(1, −1) over ℤ. -/
def J : Matrix (Fin 2) (Fin 2) ℤ := !![1, 0; 0, -1]

/-- **Lemma 1.3.** An integral isometry of the form S² − D² with determinant 1
is ±I: SO(1,1)(ℤ) = {±I}. -/
theorem so11_int_eq_pm_one (M : Matrix (Fin 2) (Fin 2) ℤ)
    (hJ : Mᵀ * J * M = J) (hdet : M.det = 1) : M = 1 ∨ M = -1 := by
  -- entry equations of the isometry condition
  have e00 : M 0 0 * M 0 0 - M 1 0 * M 1 0 = 1 := by
    have h0 := congrFun (congrFun hJ 0) 0
    simp [J, Matrix.mul_apply, Fin.sum_univ_two] at h0
    linear_combination h0
  have e11 : M 1 1 * M 1 1 - M 0 1 * M 0 1 = 1 := by
    have h1 := congrFun (congrFun hJ 1) 1
    simp [J, Matrix.mul_apply, Fin.sum_univ_two] at h1
    linear_combination -h1
  have edet : M 0 0 * M 1 1 - M 0 1 * M 1 0 = 1 := by
    rw [Matrix.det_fin_two] at hdet
    linear_combination hdet
  -- factor the two Pell-type equations over ℤ
  have hac : (M 0 0 - M 1 0) * (M 0 0 + M 1 0) = 1 := by linear_combination e00
  have hdb : (M 1 1 - M 0 1) * (M 1 1 + M 0 1) = 1 := by linear_combination e11
  have ha : (M 0 0 = 1 ∧ M 1 0 = 0) ∨ (M 0 0 = -1 ∧ M 1 0 = 0) := by
    rcases Int.mul_eq_one_iff_eq_one_or_neg_one.mp hac with ⟨h1, h2⟩ | ⟨h1, h2⟩
    · left; omega
    · right; omega
  have hd : (M 1 1 = 1 ∧ M 0 1 = 0) ∨ (M 1 1 = -1 ∧ M 0 1 = 0) := by
    rcases Int.mul_eq_one_iff_eq_one_or_neg_one.mp hdb with ⟨h1, h2⟩ | ⟨h1, h2⟩
    · left; omega
    · right; omega
  -- determinant selects the two coherent sign choices
  rcases ha with ⟨ha1, ha2⟩ | ⟨ha1, ha2⟩ <;> rcases hd with ⟨hd1, hd2⟩ | ⟨hd1, hd2⟩
  · left
    rw [Matrix.eta_fin_two M, ha1, ha2, hd1, hd2, Matrix.one_fin_two]
  · exfalso; rw [ha1, ha2, hd1, hd2] at edet; norm_num at edet
  · exfalso; rw [ha1, ha2, hd1, hd2] at edet; norm_num at edet
  · right
    have hneg : (-1 : Matrix (Fin 2) (Fin 2) ℤ) = !![-1, 0; 0, -1] := by
      rw [Matrix.one_fin_two]
      ext i j
      fin_cases i <;> fin_cases j <;> simp
    rw [Matrix.eta_fin_two M, ha1, ha2, hd1, hd2, hneg]

/-- Sanity converse: both I and −I are orientation-preserving isometries of the
form, so the classification is exact. -/
theorem pm_one_mem_so11 :
    ((1 : Matrix (Fin 2) (Fin 2) ℤ)ᵀ * J * 1 = J ∧ (1 : Matrix (Fin 2) (Fin 2) ℤ).det = 1)
    ∧ ((-1 : Matrix (Fin 2) (Fin 2) ℤ)ᵀ * J * (-1) = J
        ∧ (-1 : Matrix (Fin 2) (Fin 2) ℤ).det = 1) := by
  refine ⟨⟨by simp, by simp⟩, ⟨by simp, ?_⟩⟩
  rw [Matrix.det_fin_two]
  norm_num

end Pairfield
