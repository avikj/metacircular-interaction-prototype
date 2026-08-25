import Mathlib.Data.Nat.ModEq
import Mathlib.Data.Int.ModEq
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

The adapter exposes Mathlib's Bézout coefficients and the signed failure
datum, but it does not reconstruct a stepwise vallī/pulverization trace,
retain the original affine equations, certify sensor provenance, or make a
historical attribution.
-/

namespace Pairfield.IncrementalCRTAdapter

/-- A residue together with its modulus, representing one congruence state. -/
structure CongruenceState where
  residue : ℕ
  modulus : ℕ
deriving DecidableEq, Repr

@[ext]
theorem CongruenceState.ext {left right : CongruenceState}
    (hresidue : left.residue = right.residue)
    (hmodulus : left.modulus = right.modulus) : left = right := by
  cases left
  cases right
  simp_all

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

/-- The explicit coefficients produced by Mathlib's extended Euclidean
algorithm.  This is a Bézout certificate, not a historical vallī trace. -/
structure BezoutCertificate (leftModulus rightModulus : ℕ) where
  leftCoefficient : ℤ
  rightCoefficient : ℤ
  identity :
    (Nat.gcd leftModulus rightModulus : ℤ) =
      leftModulus * leftCoefficient + rightModulus * rightCoefficient

/-- Expose the coefficient pair used by the generalized CRT constructor. -/
def mathlibBezoutCertificate (leftModulus rightModulus : ℕ) :
    BezoutCertificate leftModulus rightModulus :=
  ⟨Nat.gcdA leftModulus rightModulus,
    Nat.gcdB leftModulus rightModulus,
    Nat.gcd_eq_gcd_ab leftModulus rightModulus⟩

/-- A proof-relevant successful transition.  Erasing its coefficient witness
recovers the extensional `merge` state exactly. -/
structure MergeCertificate (left right : CongruenceState) where
  compatible : Compatible left right
  bezout : BezoutCertificate left.modulus right.modulus
  combined : CongruenceState
  combined_eq : combined = merge compatible

def certifiedMerge {left right : CongruenceState}
    (h : Compatible left right) : MergeCertificate left right :=
  ⟨h, mathlibBezoutCertificate left.modulus right.modulus, merge h, rfl⟩

/-- A signed failure certificate.  Unlike a bare negation, it retains the
actual gcd and integer residue difference named by the native note. -/
structure SignedObstruction (left right : CongruenceState) where
  gcd : ℕ
  delta : ℤ
  gcd_eq : gcd = Nat.gcd left.modulus right.modulus
  delta_eq : delta = (right.residue : ℤ) - left.residue
  not_dvd : ¬ (gcd : ℤ) ∣ delta

def signedObstructionOfNotCompatible {left right : CongruenceState}
    (h : ¬ Compatible left right) : SignedObstruction left right := by
  refine ⟨Nat.gcd left.modulus right.modulus,
    (right.residue : ℤ) - left.residue, rfl, rfl, ?_⟩
  intro hdvd
  exact h (Nat.modEq_iff_dvd.mpr hdvd)

/-- The total checked transition returns either the successful state together
with Bézout coefficients or the signed divisibility obstruction. -/
inductive CheckedOutcome (left right : CongruenceState) where
  | merged (certificate : MergeCertificate left right)
  | obstructed (certificate : SignedObstruction left right)

private def compatibleDecidable (left right : CongruenceState) :
    Decidable (Compatible left right) := by
  unfold Compatible Nat.ModEq
  infer_instance

def checkedOutcome (left right : CongruenceState) : CheckedOutcome left right := by
  letI := compatibleDecidable left right
  exact if h : Compatible left right then
    .merged (certifiedMerge h)
  else
    .obstructed (signedObstructionOfNotCompatible h)

/-- The returned residue satisfies both input constraints. -/
theorem mergeResidue_spec {left right : CongruenceState}
    (h : Compatible left right) :
    Holds left (mergeResidue h) ∧ Holds right (mergeResidue h) := by
  exact (Nat.chineseRemainder' h).property

/-- Integer realization of a natural congruence state. -/
def HoldsInt (state : CongruenceState) (x : ℤ) : Prop :=
  x ≡ state.residue [ZMOD state.modulus]

/-- The constructor's proof fields transport to the full integer cosets. -/
theorem mergeResidue_spec_int {left right : CongruenceState}
    (h : Compatible left right) :
    HoldsInt left (mergeResidue h) ∧ HoldsInt right (mergeResidue h) := by
  exact
    ⟨Int.natCast_modEq_iff.mpr (mergeResidue_spec h).1,
      Int.natCast_modEq_iff.mpr (mergeResidue_spec h).2⟩

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

/-- The same intersection theorem on the actual integer solution cosets. -/
theorem holdsInt_merge_iff {left right : CongruenceState}
    (h : Compatible left right) (x : ℤ) :
    HoldsInt (merge h) x ↔ HoldsInt left x ∧ HoldsInt right x := by
  constructor
  · intro hx
    change x ≡ (mergeResidue h : ℤ)
      [ZMOD (Nat.lcm left.modulus right.modulus : ℕ)] at hx
    have hleftDvd :
        (left.modulus : ℤ) ∣ (Nat.lcm left.modulus right.modulus : ℕ) := by
      exact_mod_cast Nat.dvd_lcm_left left.modulus right.modulus
    have hrightDvd :
        (right.modulus : ℤ) ∣ (Nat.lcm left.modulus right.modulus : ℕ) := by
      exact_mod_cast Nat.dvd_lcm_right left.modulus right.modulus
    exact
      ⟨(hx.of_dvd hleftDvd).trans (mergeResidue_spec_int h).1,
        (hx.of_dvd hrightDvd).trans (mergeResidue_spec_int h).2⟩
  · intro hx
    have hpair :
        x ≡ (mergeResidue h : ℤ) [ZMOD left.modulus] ∧
          x ≡ (mergeResidue h : ℤ) [ZMOD right.modulus] :=
      ⟨hx.1.trans (mergeResidue_spec_int h).1.symm,
        hx.2.trans (mergeResidue_spec_int h).2.symm⟩
    simpa [HoldsInt, merge] using
      (Int.modEq_and_modEq_iff_modEq_lcm.mp hpair)

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

/-- The signed obstruction still proves the complete extensional no-solution
statement after its proof-relevant data are retained. -/
theorem SignedObstruction.no_common {left right : CongruenceState}
    (obstruction : SignedObstruction left right) :
    ¬ ∃ x, Holds left x ∧ Holds right x := by
  apply no_common_of_not_compatible left right
  intro hcompat
  apply obstruction.not_dvd
  rw [obstruction.gcd_eq, obstruction.delta_eq]
  exact Nat.modEq_iff_dvd.mp hcompat

/-- Failure is complete on the integer cosets as well: the stored signed
nondivisibility certificate rules out every integer common representative. -/
theorem SignedObstruction.no_common_int {left right : CongruenceState}
    (obstruction : SignedObstruction left right) :
    ¬ ∃ x : ℤ, HoldsInt left x ∧ HoldsInt right x := by
  rintro ⟨x, hxLeft, hxRight⟩
  apply obstruction.not_dvd
  rw [obstruction.gcd_eq, obstruction.delta_eq]
  have hleftDvd :
      (Nat.gcd left.modulus right.modulus : ℤ) ∣ left.modulus := by
    exact_mod_cast Nat.gcd_dvd_left left.modulus right.modulus
  have hrightDvd :
      (Nat.gcd left.modulus right.modulus : ℤ) ∣ right.modulus := by
    exact_mod_cast Nat.gcd_dvd_right left.modulus right.modulus
  have hresidues :
      (left.residue : ℤ) ≡ right.residue
        [ZMOD Nat.gcd left.modulus right.modulus] :=
    (hxLeft.symm.of_dvd hleftDvd).trans (hxRight.of_dvd hrightDvd)
  exact Int.modEq_iff_dvd.mp hresidues

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
  norm_num [Compatible, overlapLeft, overlapRight, Nat.ModEq, Nat.gcd]

theorem overlapMerge : merge overlapCompatible = ⟨8, 18⟩ := by
  apply CongruenceState.ext
  · exact mergeResidue_eq_of_common_lt overlapCompatible (by norm_num [overlapLeft])
      (by norm_num [overlapRight])
      (by norm_num [overlapLeft, overlapRight, Nat.lcm, Nat.gcd])
      (by norm_num [Holds, overlapLeft, Nat.ModEq])
      (by norm_num [Holds, overlapRight, Nat.ModEq])
  · norm_num [merge, overlapLeft, overlapRight, Nat.lcm, Nat.gcd]

/-- `⟨2, 6⟩` again — `overlapLeft` above is the same state, and a
content-address census on 2026-08-22 flagged the two as identical text inside
one file.  **They are deliberately not shared.**  The point of the pair of
controls is that `⟨2, 6⟩` is compatible with `⟨8, 9⟩` and incompatible with
`⟨1, 4⟩`: compatibility is a property of a *pair*, never of a congruence
state, so naming one state twice under the two roles it plays is the
statement.  Giving both roles one name would make the two controls look like
one, which is exactly the inference the pair is built to block. -/
def incompatibleLeft : CongruenceState := ⟨1, 4⟩
def incompatibleRight : CongruenceState := ⟨2, 6⟩

theorem incompatibleControl :
    ¬ Compatible incompatibleLeft incompatibleRight := by
  norm_num [Compatible, incompatibleLeft, incompatibleRight, Nat.ModEq, Nat.gcd]

theorem incompatibleControl_has_no_common_state :
    ¬ ∃ x, Holds incompatibleLeft x ∧ Holds incompatibleRight x :=
  no_common_of_not_compatible _ _ incompatibleControl

def modEight : CongruenceState := ⟨2, 8⟩
def modNine : CongruenceState := ⟨5, 9⟩
def modFive : CongruenceState := ⟨4, 5⟩

theorem eightNineCompatible : Compatible modEight modNine := by
  norm_num [Compatible, modEight, modNine, Nat.ModEq, Nat.gcd]

def eightNineState : CongruenceState := merge eightNineCompatible

theorem eightNineState_eq : eightNineState = ⟨50, 72⟩ := by
  apply CongruenceState.ext
  · exact mergeResidue_eq_of_common_lt eightNineCompatible (by norm_num [modEight])
      (by norm_num [modNine])
      (by norm_num [modEight, modNine, Nat.lcm, Nat.gcd])
      (by norm_num [Holds, modEight, Nat.ModEq])
      (by norm_num [Holds, modNine, Nat.ModEq])
  · norm_num [eightNineState, merge, modEight, modNine, Nat.lcm, Nat.gcd]

theorem eightNineFiveCompatible : Compatible eightNineState modFive := by
  rw [eightNineState_eq]
  norm_num [Compatible, modFive, Nat.ModEq, Nat.gcd]

/-- The corrected native example: the three prime-power constraints normalize
to `194 mod 360`, not the retracted handwritten value `274`. -/
theorem primePowerMerge :
    merge eightNineFiveCompatible = ⟨194, 360⟩ := by
  apply CongruenceState.ext
  · exact mergeResidue_eq_of_common_lt eightNineFiveCompatible
      (by rw [eightNineState_eq]; norm_num)
      (by norm_num [modFive])
      (by rw [eightNineState_eq]; norm_num [modFive, Nat.lcm, Nat.gcd])
      (by rw [eightNineState_eq]; norm_num [Holds, Nat.ModEq])
      (by norm_num [Holds, modFive, Nat.ModEq])
  · rw [show (merge eightNineFiveCompatible).modulus =
      Nat.lcm eightNineState.modulus modFive.modulus from rfl,
      eightNineState_eq]
    norm_num [modFive, Nat.lcm, Nat.gcd]

end Pairfield.IncrementalCRTAdapter
