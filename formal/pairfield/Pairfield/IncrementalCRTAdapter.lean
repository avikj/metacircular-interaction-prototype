import Mathlib.Data.Nat.ModEq
import Mathlib.Tactic.NormNum

/-!
# Incremental generalized-CRT state adapter

The native arithmetic state `⟨r, M⟩` denotes the congruence
`x ≡ r [MOD M]`.  A new state `⟨a, m⟩` can be merged exactly when the two
residues agree modulo `gcd M m`.  Mathlib's `Nat.chineseRemainder'` already
accepts precisely that compatibility proof and returns a certified common
representative; `Nat.chineseRemainder'_lt_lcm` normalizes it below the new
modulus.

This file checks the complete state contract: compatibility is equivalent to
existence of a common state, `merge` denotes exactly the intersection of the
two congruence classes, and for positive moduli its residue is the unique
representative below `lcm M m`.

The adapter intentionally forgets the particular Bézout/vallī trace and does
not certify sensor provenance or historical attribution.
-/

namespace Pairfield.IncrementalCRTAdapter

/-- A residue together with its modulus, representing one congruence state. -/
structure CongruenceState where
  residue : ℕ
  modulus : ℕ
deriving DecidableEq, Repr

/-- An integer realizes a congruence state when it has the stored residue. -/
def Holds (state : CongruenceState) (x : ℕ) : Prop :=
  x ≡ state.residue [MOD state.modulus]

/-- The exact overlap condition for two congruence states. -/
def Compatible (left right : CongruenceState) : Prop :=
  left.residue ≡ right.residue [MOD Nat.gcd left.modulus right.modulus]

/-- Mathlib's normalized common representative. -/
def mergeResidue {left right : CongruenceState}
    (h : Compatible left right) : ℕ :=
  Nat.chineseRemainder' h

/-- The one-shot combined state. -/
def merge {left right : CongruenceState}
    (h : Compatible left right) : CongruenceState :=
  ⟨mergeResidue h, Nat.lcm left.modulus right.modulus⟩

/-- The returned residue satisfies both input constraints. -/
theorem mergeResidue_spec {left right : CongruenceState}
    (h : Compatible left right) :
    Holds left (mergeResidue h) ∧ Holds right (mergeResidue h) := by
  exact (Nat.chineseRemainder' h).property

@[simp]
theorem merge_modulus {left right : CongruenceState}
    (h : Compatible left right) :
    (merge h).modulus = Nat.lcm left.modulus right.modulus :=
  rfl

/-- A number realizes the merged state exactly when it realizes both inputs.
Thus `merge` retains the complete solution intersection, not only one sample. -/
theorem holds_merge_iff {left right : CongruenceState}
    (h : Compatible left right) (x : ℕ) :
    Holds (merge h) x ↔ Holds left x ∧ Holds right x := by
  constructor
  · intro hx
    change x ≡ mergeResidue h [MOD Nat.lcm left.modulus right.modulus] at hx
    exact
      ⟨(hx.of_dvd (Nat.dvd_lcm_left left.modulus right.modulus)).trans
          (mergeResidue_spec h).1,
        (hx.of_dvd (Nat.dvd_lcm_right left.modulus right.modulus)).trans
          (mergeResidue_spec h).2⟩
  · intro hx
    exact Nat.mod_lcm
      (hx.1.trans (mergeResidue_spec h).1.symm)
      (hx.2.trans (mergeResidue_spec h).2.symm)

/-- The overlap condition is not merely sufficient: it is equivalent to the
existence of any common representative. -/
theorem compatible_iff_exists_common (left right : CongruenceState) :
    Compatible left right ↔ ∃ x, Holds left x ∧ Holds right x := by
  constructor
  · intro h
    exact ⟨mergeResidue h, mergeResidue_spec h⟩
  · rintro ⟨x, hxLeft, hxRight⟩
    exact
      (hxLeft.symm.of_dvd (Nat.gcd_dvd_left left.modulus right.modulus)).trans
        (hxRight.of_dvd (Nat.gcd_dvd_right left.modulus right.modulus))

/-- A failed overlap proof is a complete no-solution certificate. -/
theorem no_common_of_not_compatible (left right : CongruenceState)
    (h : ¬ Compatible left right) :
    ¬ ∃ x, Holds left x ∧ Holds right x := by
  exact fun hexists ↦ h ((compatible_iff_exists_common left right).2 hexists)

/-- For nonzero moduli, Mathlib's representative is normalized below the
least-common-multiple modulus of the combined state. -/
theorem mergeResidue_lt_lcm {left right : CongruenceState}
    (h : Compatible left right)
    (hleft : left.modulus ≠ 0) (hright : right.modulus ≠ 0) :
    mergeResidue h < Nat.lcm left.modulus right.modulus := by
  exact Nat.chineseRemainder'_lt_lcm h hleft hright

/-- The normalized common representative is unique. -/
theorem existsUnique_normalized_common (left right : CongruenceState)
    (hleft : left.modulus ≠ 0) (hright : right.modulus ≠ 0)
    (h : Compatible left right) :
    ∃! x, x < Nat.lcm left.modulus right.modulus ∧
      Holds left x ∧ Holds right x := by
  refine ⟨mergeResidue h, ?_, ?_⟩
  · exact ⟨mergeResidue_lt_lcm h hleft hright, mergeResidue_spec h⟩
  · rintro y ⟨hylt, hyLeft, hyRight⟩
    have hy : y ≡ mergeResidue h [MOD Nat.lcm left.modulus right.modulus] :=
      Nat.mod_lcm
        (hyLeft.trans (mergeResidue_spec h).1.symm)
        (hyRight.trans (mergeResidue_spec h).2.symm)
    exact hy.eq_of_lt_of_lt hylt (mergeResidue_lt_lcm h hleft hright)

/-- A bounded common representative must be the one returned by `merge`.
This packages normalized uniqueness in the orientation convenient for exact
controls and downstream state updates. -/
theorem mergeResidue_eq_of_common_lt {left right : CongruenceState}
    (h : Compatible left right)
    (hleft : left.modulus ≠ 0) (hright : right.modulus ≠ 0)
    {x : ℕ} (hxlt : x < Nat.lcm left.modulus right.modulus)
    (hxLeft : Holds left x) (hxRight : Holds right x) :
    mergeResidue h = x := by
  have hcong :
      mergeResidue h ≡ x [MOD Nat.lcm left.modulus right.modulus] :=
    Nat.mod_lcm
      ((mergeResidue_spec h).1.trans hxLeft.symm)
      ((mergeResidue_spec h).2.trans hxRight.symm)
  exact hcong.eq_of_lt_of_lt (mergeResidue_lt_lcm h hleft hright) hxlt

/-! ## Exact native controls -/

def overlapLeft : CongruenceState := ⟨2, 6⟩
def overlapRight : CongruenceState := ⟨8, 9⟩

theorem overlapCompatible : Compatible overlapLeft overlapRight := by
  norm_num [Compatible, overlapLeft, overlapRight, Nat.ModEq]

theorem overlapMerge : merge overlapCompatible = ⟨8, 18⟩ := by
  apply CongruenceState.ext
  · exact mergeResidue_eq_of_common_lt overlapCompatible (by norm_num [overlapLeft])
      (by norm_num [overlapRight]) (by norm_num [overlapLeft, overlapRight])
      (by norm_num [Holds, overlapLeft, Nat.ModEq])
      (by norm_num [Holds, overlapRight, Nat.ModEq])
  · norm_num [merge, overlapLeft, overlapRight]

def incompatibleLeft : CongruenceState := ⟨1, 4⟩
def incompatibleRight : CongruenceState := ⟨2, 6⟩

theorem incompatibleControl :
    ¬ Compatible incompatibleLeft incompatibleRight := by
  norm_num [Compatible, incompatibleLeft, incompatibleRight, Nat.ModEq]

theorem incompatibleControl_has_no_common_state :
    ¬ ∃ x, Holds incompatibleLeft x ∧ Holds incompatibleRight x :=
  no_common_of_not_compatible _ _ incompatibleControl

def modEight : CongruenceState := ⟨2, 8⟩
def modNine : CongruenceState := ⟨5, 9⟩
def modFive : CongruenceState := ⟨4, 5⟩

theorem eightNineCompatible : Compatible modEight modNine := by
  norm_num [Compatible, modEight, modNine, Nat.ModEq]

def eightNineState : CongruenceState := merge eightNineCompatible

theorem eightNineState_eq : eightNineState = ⟨50, 72⟩ := by
  apply CongruenceState.ext
  · exact mergeResidue_eq_of_common_lt eightNineCompatible (by norm_num [modEight])
      (by norm_num [modNine]) (by norm_num [modEight, modNine])
      (by norm_num [Holds, modEight, Nat.ModEq])
      (by norm_num [Holds, modNine, Nat.ModEq])
  · norm_num [eightNineState, merge, modEight, modNine]

theorem eightNineFiveCompatible : Compatible eightNineState modFive := by
  rw [eightNineState_eq]
  norm_num [Compatible, modFive, Nat.ModEq]

/-- The corrected native example: the three prime-power constraints normalize
to `194 mod 360`, not the retracted handwritten value `274`. -/
theorem primePowerMerge :
    merge eightNineFiveCompatible = ⟨194, 360⟩ := by
  apply CongruenceState.ext
  · exact mergeResidue_eq_of_common_lt eightNineFiveCompatible
      (by rw [eightNineState_eq]; norm_num)
      (by norm_num [modFive])
      (by rw [eightNineState_eq]; norm_num [modFive])
      (by rw [eightNineState_eq]; norm_num [Holds, Nat.ModEq])
      (by norm_num [Holds, modFive, Nat.ModEq])
  · rw [show (merge eightNineFiveCompatible).modulus =
      Nat.lcm eightNineState.modulus modFive.modulus from rfl,
      eightNineState_eq]
    norm_num [modFive]

end Pairfield.IncrementalCRTAdapter
