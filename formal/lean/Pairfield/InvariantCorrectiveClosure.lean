import Mathlib.Algebra.Module.Submodule.Invariant

/-!
# Least corrective closure under a linear action

Let `U` be a submodule of available linear channels and let `a` be an
admitted linear action on those channels.  Failure of `a(U) ⊆ U` produces
the least one-step repair `U ⊔ a(U)`.  Intersecting all invariant submodules
which contain `U` produces the least carrier closed under every future use of
`a`.

On a primal state space this is a reachability/Krylov closure.  On a
finite-dimensional dual space, with the action given by pullback, it is the
corresponding observable-channel closure.  No finite-dimensional termination,
rank, stochastic lumpability, or partition-quotient theorem is asserted here.
-/

namespace Pairfield

variable {R M : Type*} [Semiring R] [AddCommMonoid M] [Module R M]

/-- The least invariant submodule containing `U`. -/
def invariantClosure (a : M →ₗ[R] M) (U : Submodule R M) : Submodule R M :=
  sInf {W : Submodule R M | U ≤ W ∧ Submodule.map a W ≤ W}

/-- Existing channels embed in their invariant closure. -/
theorem le_invariantClosure (a : M →ₗ[R] M) (U : Submodule R M) :
    U ≤ invariantClosure a U := by
  intro x hx
  refine Submodule.mem_sInf.mpr ?_
  intro W hW
  exact hW.1 hx

/-- The closure is closed under the admitted action. -/
theorem map_invariantClosure_le (a : M →ₗ[R] M) (U : Submodule R M) :
    Submodule.map a (invariantClosure a U) ≤ invariantClosure a U := by
  intro x hx
  rcases hx with ⟨y, hy, rfl⟩
  refine Submodule.mem_sInf.mpr ?_
  intro W hW
  exact hW.2 ⟨y, Submodule.mem_sInf.mp hy W hW, rfl⟩

/-- Every invariant carrier containing `U` contains its entire closure. -/
theorem invariantClosure_le
    (a : M →ₗ[R] M) (U W : Submodule R M)
    (hUW : U ≤ W) (hW : Submodule.map a W ≤ W) :
    invariantClosure a U ≤ W := by
  exact sInf_le ⟨hUW, hW⟩

/-- `U ⊔ a(U)` is the least submodule containing both the old channels and
their one-step images. -/
theorem oneStepCorrection_le_iff
    (a : M →ₗ[R] M) (U W : Submodule R M) :
    U ⊔ Submodule.map a U ≤ W ↔ U ≤ W ∧ Submodule.map a U ≤ W := by
  exact sup_le_iff

/-- Failure of invariance forces strict growth by the least correction. -/
theorem oneStepCorrection_strict
    (a : M →ₗ[R] M) (U : Submodule R M)
    (hfail : ¬ Submodule.map a U ≤ U) :
    U < U ⊔ Submodule.map a U := by
  refine lt_of_le_of_ne le_sup_left ?_
  intro heq
  apply hfail
  exact le_sup_right.trans_eq heq.symm

/-- Installing the least one-step correction does not alter the eventual
future-closed carrier. -/
theorem invariantClosure_oneStep
    (a : M →ₗ[R] M) (U : Submodule R M) :
    invariantClosure a (U ⊔ Submodule.map a U) = invariantClosure a U := by
  apply le_antisymm
  · apply invariantClosure_le
    · exact sup_le (le_invariantClosure a U)
        ((Submodule.map_mono (le_invariantClosure a U)).trans
          (map_invariantClosure_le a U))
    · exact map_invariantClosure_le a U
  · apply invariantClosure_le
    · exact le_trans le_sup_left
        (le_invariantClosure a (U ⊔ Submodule.map a U))
    · exact map_invariantClosure_le a (U ⊔ Submodule.map a U)

/-- For an idempotent action, one corrective step is already closed under all
future uses of the action. -/
theorem invariantClosure_eq_oneStep_of_idempotent
    (a : M →ₗ[R] M) (U : Submodule R M) (ha : a.comp a = a) :
    invariantClosure a U = U ⊔ Submodule.map a U := by
  apply le_antisymm
  · apply invariantClosure_le
    · exact le_sup_left
    · rw [Submodule.map_sup]
      apply sup_le
      · exact le_sup_right
      · intro x hx
        rcases hx with ⟨y, hy, rfl⟩
        rcases hy with ⟨z, hz, rfl⟩
        have haa : a (a z) = a z :=
          congrArg (fun f : M →ₗ[R] M ↦ f z) ha
        rw [haa]
        exact (le_sup_right : Submodule.map a U ≤ U ⊔ Submodule.map a U)
          ⟨z, hz, rfl⟩
  · exact sup_le (le_invariantClosure a U)
      ((Submodule.map_mono (le_invariantClosure a U)).trans
        (map_invariantClosure_le a U))

end Pairfield
