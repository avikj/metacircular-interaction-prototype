import Mathlib

/-!
# Residue blocks and the combinatorial Levi corank

For a finite map `h : ι → ρ`, the fibres of `h` are the blocks of the
residue partition.  A block of size `m` contributes rank `m - 1` to the
corresponding product of type-A factors.  This file checks the resulting
finite identity

`number of blocks = number of coordinates - combinatorial Levi rank`

and its local obstruction form for `h : Fin k → Fin p`.

The file does not construct root vectors or identify this combinatorial number
with the finrank of their linear span.  That standard linear-algebra bridge is
a separate theorem surface.
-/

namespace Pairfield.LeviResidueCorank

open Finset
open scoped BigOperators

variable {index residue : Type*}
  [Fintype index] [DecidableEq residue]

/-- Residue classes actually met by the finite family. -/
def residueImage (h : index → residue) : Finset residue :=
  Finset.univ.image h

/-- Number of distinct residue classes met by the family. -/
def residueCount (h : index → residue) : ℕ :=
  (residueImage h).card

/-- Cardinality of one residue block. -/
def fiberCard (h : index → residue) (r : residue) : ℕ :=
  (Finset.univ.filter fun i ↦ h i = r).card

/-- Sum of the type-`A_(m-1)` ranks contributed by all nonempty residue
blocks. -/
def leviRank (h : index → residue) : ℕ :=
  ∑ r ∈ residueImage h, (fiberCard h r - 1)

theorem one_le_fiberCard_of_mem {h : index → residue} {r : residue}
    (hr : r ∈ residueImage h) : 1 ≤ fiberCard h r := by
  rw [residueImage, Finset.mem_image] at hr
  obtain ⟨i, -, rfl⟩ := hr
  apply Finset.one_le_card.mpr
  exact ⟨i, by simp⟩

theorem sum_fiberCard (h : index → residue) :
    ∑ r ∈ residueImage h, fiberCard h r = Fintype.card index := by
  change (∑ r ∈ Finset.univ.image h,
    (Finset.univ.filter fun i ↦ h i = r).card) = Finset.univ.card
  simpa only using
    (Finset.card_eq_sum_card_image h (Finset.univ : Finset index)).symm

theorem residueCount_le_domain (h : index → residue) :
    residueCount h ≤ Fintype.card index := by
  change (Finset.univ.image h).card ≤ Finset.univ.card
  exact Finset.card_image_le

theorem residueCount_le_codomain [Fintype residue] (h : index → residue) :
    residueCount h ≤ Fintype.card residue := by
  change (Finset.univ.image h).card ≤ Finset.univ.card
  exact Finset.card_le_univ _

theorem leviRank_eq_card_sub_residueCount (h : index → residue) :
    leviRank h = Fintype.card index - residueCount h := by
  rw [leviRank, Finset.sum_tsub_distrib]
  · rw [sum_fiberCard]
    simp [residueCount]
  · exact fun r hr ↦ one_le_fiberCard_of_mem hr

/-- Exact block-rank decomposition. -/
theorem card_eq_residueCount_add_leviRank (h : index → residue) :
    Fintype.card index = residueCount h + leviRank h := by
  have hle := residueCount_le_domain h
  rw [leviRank_eq_card_sub_residueCount]
  omega

/-- The distinct-residue count is the corank of the blockwise type-A rank. -/
theorem residueCount_eq_card_sub_leviRank (h : index → residue) :
    residueCount h = Fintype.card index - leviRank h := by
  have hdecomp := card_eq_residueCount_add_leviRank h
  omega

/-- A local tuple is admissible at this residue alphabet when it does not
cover every residue. -/
def LocallyAdmissible {k p : ℕ} (h : Fin k → Fin p) : Prop :=
  residueCount h < p

/-- For `p ≤ k`, not covering all `p` residues is exactly the strict Levi-rank
inequality in the singular-series note.  Primality is not used: this is the
finite local combinatorics beneath that arithmetic specialization. -/
theorem locallyAdmissible_iff_rank_gt {k p : ℕ} (h : Fin k → Fin p)
    (hpk : p ≤ k) :
    LocallyAdmissible h ↔ k - p < leviRank h := by
  have hdecomp := card_eq_residueCount_add_leviRank h
  have hcodomain := residueCount_le_codomain h
  simp only [Fintype.card_fin] at hdecomp hcodomain
  unfold LocallyAdmissible
  omega

end Pairfield.LeviResidueCorank
