/-
Copyright (c) 2026 Avik Jain and the mathematics collaboration.
Released under Apache 2.0 license.

The exact affine-semigroup law for the W-trick restrictions sampled from
composition; retaining its order is load-bearing because the offsets need not
commute even though the scale factors do.
-/
import Mathlib.Data.Nat.Basic

namespace Pairfield

/-- The affine parametrization of the residue-class fiber `r + W * Nat`. -/
def sieveRestriction (W r : Nat) : Nat → Nat := fun m => W * m + r

/-- Right-to-left composition multiplies scales and lets the outer scale act
on the inner offset. -/
theorem sieveRestriction_comp
    (W₂ r₂ W₁ r₁ : Nat) :
    sieveRestriction W₂ r₂ ∘ sieveRestriction W₁ r₁ =
      sieveRestriction (W₂ * W₁) (W₂ * r₁ + r₂) := by
  funext m
  simp [Function.comp_apply, sieveRestriction, Nat.mul_add, Nat.mul_assoc,
    Nat.add_assoc]

/-- The offset printed in `LENS_CIRCUIT` Lemma R.3 belongs to the opposite
composite. -/
theorem sieveRestriction_comp_opposite
    (W₁ r₁ W₂ r₂ : Nat) :
    sieveRestriction W₁ r₁ ∘ sieveRestriction W₂ r₂ =
      sieveRestriction (W₁ * W₂) (r₁ + W₁ * r₂) := by
  funext m
  simp [Function.comp_apply, sieveRestriction, Nat.mul_add, Nat.mul_assoc,
    Nat.add_comm, Nat.add_assoc]

/-- Although the scale product is commutative, affine restrictions commute
exactly when their transported offsets agree. -/
theorem sieveRestriction_comp_comm_iff
    (W₁ r₁ W₂ r₂ : Nat) :
    sieveRestriction W₂ r₂ ∘ sieveRestriction W₁ r₁ =
        sieveRestriction W₁ r₁ ∘ sieveRestriction W₂ r₂ ↔
      W₂ * r₁ + r₂ = W₁ * r₂ + r₁ := by
  constructor
  · intro h
    have h0 := congrFun h 0
    simpa [sieveRestriction] using h0
  · intro h
    funext m
    calc
      (sieveRestriction W₂ r₂ ∘ sieveRestriction W₁ r₁) m =
          (W₂ * W₁) * m + (W₂ * r₁ + r₂) := by
            simp [Function.comp_apply, sieveRestriction, Nat.mul_add,
              Nat.mul_assoc, Nat.add_assoc]
      _ = (W₁ * W₂) * m + (W₁ * r₂ + r₁) := by
            rw [Nat.mul_comm W₂ W₁, h]
      _ = (sieveRestriction W₁ r₁ ∘ sieveRestriction W₂ r₂) m := by
            simp [Function.comp_apply, sieveRestriction, Nat.mul_add,
              Nat.mul_assoc, Nat.add_assoc]

/-- Smallest explicit witness separating the printed order from standard
composition: the actual composite sends zero to `1`, while the printed
flattening sends it to `2`. -/
theorem lensCircuit_composition_counterexample :
    sieveRestriction 3 1 ∘ sieveRestriction 2 0 ≠
      sieveRestriction 6 2 := by
  intro h
  have h0 := congrFun h 0
  simp [Function.comp_apply, sieveRestriction] at h0

end Pairfield
