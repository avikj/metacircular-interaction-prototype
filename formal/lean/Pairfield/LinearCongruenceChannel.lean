/-
Copyright (c) 2026 Avik Jain and the mathematics collaboration.
Released under Apache 2.0 license.

The exact finite-information boundary of multiplication on a cyclic additive
group.  This is a thin adapter around Mathlib's cyclic-group cardinality and
homomorphism-fiber theorems, motivated by the repository's nonunit linear
congruence descent.
-/
import Mathlib.GroupTheory.SpecificGroups.Cyclic

namespace Pairfield.LinearCongruenceChannel

universe u

variable (G : Type u) [AddCommGroup G]

/-- Multiplication by `d`, read as a deterministic channel on an additive group. -/
abbrev channel (d : ℕ) : G →+ G :=
  nsmulAddMonoidHom d

/-- Two inputs have the same output exactly when their difference is lost. -/
theorem sameOutput_iff_sub_mem_kernel (d : ℕ) (x y : G) :
    channel G d x = channel G d y ↔ x - y ∈ (channel G d).ker := by
  rw [AddMonoidHom.mem_ker, map_sub, sub_eq_zero]

variable [Fintype G] [IsAddCyclic G]

/-- The number of distinguishable outputs is `|G| / gcd(|G|, d)`. -/
theorem outputCard (d : ℕ) :
    Nat.card (channel G d).range = Nat.card G / (Nat.card G).gcd d :=
  IsAddCyclic.card_nsmulAddMonoidHom_range G d

/-- The ambiguity at zero has exactly `gcd(|G|, d)` alternatives. -/
theorem kernelCard (d : ℕ) :
    Nat.card (channel G d).ker = (Nat.card G).gcd d :=
  IsAddCyclic.card_nsmulAddMonoidHom_ker G d

/--
Every occupied fiber is a translate of the kernel.  This is stronger than a
cardinality statement: it identifies the alternatives that the output has
made indistinguishable.
-/
def occupiedFiberEquivKernel (d : ℕ) (a : G) :
    {x : G // channel G d x = channel G d a} ≃ (channel G d).ker := by
  exact ((Equiv.refl G).subtypeEquiv (fun x => by simp)).trans
    (AddMonoidHom.fiberEquivKer (channel G d) a)

/-- Every output that actually occurs has the same exact ambiguity. -/
theorem occupiedFiberCard (d : ℕ) (a : G) :
    Nat.card {x : G // channel G d x = channel G d a} =
      (Nat.card G).gcd d := by
  calc
    Nat.card {x : G // channel G d x = channel G d a} =
        Nat.card (channel G d).ker :=
      Nat.card_congr (occupiedFiberEquivKernel G d a)
    _ = (Nat.card G).gcd d := kernelCard G d

/--
The output canonically decodes the input *class modulo the kernel*.  It does
not choose or recover an original representative.
-/
noncomputable def observableClassesEquivOutputs (d : ℕ) :
    G ⧸ (channel G d).ker ≃+ (channel G d).range :=
  QuotientAddGroup.quotientKerEquivRange (channel G d)

/-- Exact finite information balance: ambiguity times output count is input count. -/
theorem ambiguity_mul_outputCard (d : ℕ) :
    Nat.card (channel G d).ker * Nat.card (channel G d).range = Nat.card G := by
  rw [kernelCard G d, outputCard G d]
  exact Nat.mul_div_cancel' (Nat.gcd_dvd_left (Nat.card G) d)

/--
A decoder that reconstructs every original input exists exactly in the unit
case `gcd(|G|, d) = 1`.  A choice of representative on the range is only a
right section and is deliberately not called a decoder here.
-/
theorem hasExactDecoder_iff (d : ℕ) :
    Function.HasLeftInverse (channel G d) ↔ (Nat.card G).gcd d = 1 := by
  constructor
  · intro h
    have hker : (channel G d).ker = ⊥ :=
      AddMonoidHom.ker_eq_bot (channel G d) h.injective
    have hcard : Nat.card (channel G d).ker = 1 := by simp [hker]
    rw [kernelCard G d] at hcard
    exact hcard
  · intro hgcd
    have hcard : Nat.card (channel G d).ker = 1 := by
      rw [kernelCard G d, hgcd]
    have hker : (channel G d).ker = ⊥ :=
      (channel G d).ker.eq_bot_of_card_eq hcard
    exact Function.injective_iff_hasLeftInverse.mp
      ((AddMonoidHom.ker_eq_bot_iff (channel G d)).mp hker)

/- The sampled congruence `12z = b mod 30`: five outputs, six inputs each. -/

theorem sampleKernelCard : Nat.card (channel (ZMod 30) 12).ker = 6 := by
  simpa using kernelCard (ZMod 30) 12

theorem sampleOutputCard : Nat.card (channel (ZMod 30) 12).range = 5 := by
  simpa using outputCard (ZMod 30) 12

theorem sampleBalance :
    Nat.card (channel (ZMod 30) 12).ker *
      Nat.card (channel (ZMod 30) 12).range = 30 := by
  simpa using ambiguity_mul_outputCard (ZMod 30) 12

/- Opposite controls: a unit loses nothing; zero forgets everything. -/

theorem unitKernelCard : Nat.card (channel (ZMod 30) 7).ker = 1 := by
  simpa using kernelCard (ZMod 30) 7

theorem unitOutputCard : Nat.card (channel (ZMod 30) 7).range = 30 := by
  simpa using outputCard (ZMod 30) 7

theorem unitHasExactDecoder : Function.HasLeftInverse (channel (ZMod 30) 7) := by
  apply (hasExactDecoder_iff (ZMod 30) 7).mpr
  simp

theorem zeroKernelCard : Nat.card (channel (ZMod 30) 0).ker = 30 := by
  simp

theorem zeroOutputCard : Nat.card (channel (ZMod 30) 0).range = 1 := by
  simp

end Pairfield.LinearCongruenceChannel
