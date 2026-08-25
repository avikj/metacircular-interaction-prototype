import Pairfield.SparseLiftScalarKernelCompiler
import Mathlib.Analysis.Calculus.BumpFunction.FiniteDimension
import Mathlib.Analysis.Distribution.TestFunction

/-!
# Smooth compactly supported interpolation at finite Bessel coordinates

Distinct positive real coordinates admit arbitrary complex interpolation by a
smooth compactly supported function whose topological support stays in the
positive half-line.  The proof uses one smooth bump for each point, supported
away from all the other interpolation points.

We then apply the theorem to the six distinct squared Bessel coordinates of
the sparse modulus-six lifts of the actual divisor-boundary stratum.  Squaring
is an injective smooth reparametrization on the positive half-line, so this is
the finite admissible scalar test required by the sparse-lift compiler.
-/

namespace Pairfield.FiniteSmoothBesselInterpolation

open Set TopologicalSpace
open scoped Distributions ContDiff
open SparseLiftScalarKernelCompiler
open KuznetsovSingleKernelBoundary

noncomputable section

/-- The positive half-line as the domain of scalar Kuznetsov test functions. -/
def positiveHalfLine : Opens ℝ := ⟨Set.Ioi 0, isOpen_Ioi⟩

/-- Finite smooth interpolation on the positive half-line, with compact
support. -/
theorem exists_testFunction_interpolating_finite_positive_set
    {Index : Type*} [Fintype Index] [DecidableEq Index]
    (point : Index → ℝ) (pointInjective : Function.Injective point)
    (pointPositive : ∀ index, 0 < point index) (target : Index → ℂ) :
    ∃ test : 𝓓(positiveHalfLine, ℂ), ∀ index, test (point index) = target index := by
  classical
  let forbidden (index : Index) : Set ℝ :=
    point '' {other | other ≠ index}
  let safe (index : Index) : Set ℝ :=
    Set.Ioi 0 ∩ (forbidden index)ᶜ
  have safe_open (index : Index) : IsOpen (safe index) := by
    apply isOpen_Ioi.inter
    exact (Set.toFinite (forbidden index)).isClosed.isOpen_compl
  have point_mem_safe (index : Index) : point index ∈ safe index := by
    refine ⟨pointPositive index, ?_⟩
    intro point_forbidden
    rcases point_forbidden with ⟨other, other_ne, point_eq⟩
    exact other_ne (pointInjective point_eq)
  have safe_nhds (index : Index) : safe index ∈ nhds (point index) :=
    (safe_open index).mem_nhds (point_mem_safe index)
  choose bump bump_tsupport bump_compact bump_smooth bump_range bump_at using
    fun index ↦ exists_contDiff_tsupport_subset (n := ⊤) (safe_nhds index)
  let complexBump (index : Index) : 𝓓(positiveHalfLine, ℂ) :=
    TestFunction.mk (Complex.ofRealCLM ∘ bump index)
      (Complex.ofRealCLM.contDiff.comp (bump_smooth index))
      ((bump_compact index).comp_left (map_zero Complex.ofRealCLM))
      ((tsupport_comp_subset (map_zero Complex.ofRealCLM) _).trans
        (bump_tsupport index |>.trans (inter_subset_left)))
  have complexBump_apply (index : Index) (x : ℝ) :
      complexBump index x = (bump index x : ℂ) := by
    rfl
  have complexBump_smul_apply (coefficient : ℂ) (index : Index) (x : ℝ) :
      (coefficient • complexBump index) x =
        coefficient * complexBump index x := by
    rfl
  have bump_other_zero {index other : Index} (different : index ≠ other) :
      bump index (point other) = 0 := by
    by_contra nonzero
    have in_tsupport : point other ∈ tsupport (bump index) :=
      subset_tsupport (bump index) (Function.mem_support.mpr nonzero)
    have in_safe := bump_tsupport index in_tsupport
    have not_forbidden := in_safe.2
    apply not_forbidden
    exact ⟨other, different.symm, rfl⟩
  refine ⟨∑ index, target index • complexBump index, ?_⟩
  intro index
  have sum_apply :
      (∑ other, target other • complexBump other) (point index) =
        ∑ other, (target other • complexBump other) (point index) := by
    induction (Finset.univ : Finset Index) using Finset.induction_on with
    | empty => rfl
    | @insert other rest not_mem induction =>
        rw [Finset.sum_insert not_mem, Finset.sum_insert not_mem]
        change
          (target other • complexBump other) (point index) +
              (∑ member ∈ rest, target member • complexBump member) (point index) =
            (target other • complexBump other) (point index) +
              ∑ member ∈ rest,
                (target member • complexBump member) (point index)
        rw [induction]
  rw [sum_apply]
  simp_rw [complexBump_smul_apply, complexBump_apply]
  rw [Fintype.sum_eq_single index]
  · simp [bump_at]
  · intro other different
    rw [bump_other_zero different]
    simp

/-- The six squared Bessel coordinates, with the inessential factor `(4π)²`
removed and coerced to the real line. -/
def sparseSquaredBesselPoint (residue : Fin 6) : ℝ :=
  (besselArgumentSquared (canonicalSparseMode residue) : ℚ)

theorem sparseSquaredBesselPoint_injective :
    Function.Injective sparseSquaredBesselPoint := by
  intro left right pointAgreement
  fin_cases left <;> fin_cases right <;>
    norm_num [sparseSquaredBesselPoint, besselArgumentSquared,
      canonicalSparseMode] at pointAgreement
  all_goals rfl

theorem sparseSquaredBesselPoint_positive (residue : Fin 6) :
    0 < sparseSquaredBesselPoint residue := by
  fin_cases residue <;>
    norm_num [sparseSquaredBesselPoint, besselArgumentSquared,
      canonicalSparseMode]

/-- **Analytic sparse-lift compiler.**  The six actual divisor-boundary DFT
coefficients are values of one smooth compactly supported complex scalar test
on their distinct positive squared Bessel coordinates. -/
theorem actual_gcd_stratum_has_smooth_compactlySupported_sparse_interpolant :
    ∃ test : 𝓓(positiveHalfLine, ℂ), ∀ residue : Fin 6,
      test (sparseSquaredBesselPoint residue) =
        sparseBoundaryCoefficient residue :=
  exists_testFunction_interpolating_finite_positive_set
    sparseSquaredBesselPoint sparseSquaredBesselPoint_injective
    sparseSquaredBesselPoint_positive sparseBoundaryCoefficient

end

end Pairfield.FiniteSmoothBesselInterpolation
