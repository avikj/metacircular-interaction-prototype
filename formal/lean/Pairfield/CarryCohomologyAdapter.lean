/-
Copyright (c) 2026 Avik Jain and the mathematics collaboration.
Released under Apache 2.0 license.

Mathlib's finite-cyclic resolution specialized to the carry obstruction from
`NaturalMachine.CarryObstruction`.  This file constructs the degree-two
cohomology carrier deliberately left open by the Cubical proof.  It does not
yet identify the explicit digit-section carry cocycle with the class below.
-/
import Mathlib.GroupTheory.SpecificGroups.Cyclic
import Mathlib.RepresentationTheory.Homological.GroupCohomology.FiniteCyclic

namespace Pairfield

open CategoryTheory

noncomputable section

namespace CarryCohomology

/-- The additive cyclic group, presented multiplicatively for Mathlib's group
cohomology API. -/
abbrev CyclicGroup (N : ℕ) := Multiplicative (ZMod N)

/-- The canonical generator of the cyclic base. -/
def generator (N : ℕ) : CyclicGroup N := Multiplicative.ofAdd 1

/-- Every residue is an integral power of the canonical generator. -/
theorem mem_zpowers_generator (N : ℕ) [NeZero N] (x : CyclicGroup N) :
    x ∈ Subgroup.zpowers (generator N) := by
  rcases ZMod.intCast_surjective x.toAdd with ⟨z, hz⟩
  refine ⟨z, ?_⟩
  apply Multiplicative.toAdd.injective
  simpa [generator, hz]

/-- The coefficient module used by the carry extension: the cyclic base acts
trivially on `ZMod b`. -/
abbrev coefficients (N b : ℕ) : Rep ℤ (CyclicGroup N) :=
  Rep.trivial ℤ (CyclicGroup N) (ZMod b)

/-- Under the trivial action, `1` is an invariant and hence a legal periodic
degree-two representative. -/
def oneInvariant (N b : ℕ) :
    LinearMap.ker
      ((Rep.applyAsHom (coefficients N b) (generator N) - 𝟙 _).hom.toLinearMap) :=
  ⟨1, by
    change (coefficients N b).ρ (generator N) 1 - 1 = 0
    simp [coefficients]⟩

/-- When `b ∣ N`, the cyclic norm on `ZMod b` is identically zero. -/
theorem norm_eq_zero (N b : ℕ) [NeZero N] (hdiv : b ∣ N) :
    (coefficients N b).norm.hom.toLinearMap = 0 := by
  have hcast : (N : ZMod b) = 0 :=
    (ZMod.natCast_eq_zero_iff N b).2 hdiv
  ext x
  simp [coefficients, Rep.norm, Representation.norm, nsmul_eq_mul, hcast]

/-- The degree-two class represented by the invariant coefficient `1`. -/
def degreeTwoClass (N b : ℕ) [NeZero N] :
    groupCohomology (coefficients N b) 2 :=
  Rep.FiniteCyclicGroup.groupCohomologyπEven
    (coefficients N b) (generator N) (mem_zpowers_generator N) 2 (by norm_num)
    (oneInvariant N b)

/-- Mathlib's finite-cyclic even-cohomology quotient proves that the canonical
class survives whenever the coefficient modulus divides the base order.

This constructs a nonzero element of `H²(Z/N; Z/b)` on the exact carrier named
by `ATLAS_OF_N`.  Identifying it with the atlas's explicit carry cocycle is a
separate comparison theorem. -/
theorem degreeTwoClass_ne_zero (N b : ℕ) [NeZero N]
    (hb : 2 ≤ b) (hdiv : b ∣ N) :
    degreeTwoClass N b ≠ 0 := by
  letI : NeZero b := ⟨by omega⟩
  letI : Fact (1 < b) := ⟨by omega⟩
  intro hzero
  have hrange :
      (oneInvariant N b : ZMod b) ∈
        LinearMap.range (coefficients N b).norm.hom.toLinearMap :=
    (Rep.FiniteCyclicGroup.groupCohomologyπEven_eq_zero_iff
      (coefficients N b) (generator N) (mem_zpowers_generator N)
      2 (by norm_num) (oneInvariant N b)).1 hzero
  rw [norm_eq_zero N b hdiv, LinearMap.range_zero] at hrange
  have hone : (1 : ZMod b) ≠ 0 := one_ne_zero
  exact hone (by simpa [oneInvariant] using hrange)

/-- Small positive control: the first carry extension has a nonzero H²
carrier. -/
example : degreeTwoClass 2 2 ≠ 0 := by
  exact degreeTwoClass_ne_zero 2 2 (by norm_num) (by norm_num)

end CarryCohomology

end

end Pairfield
