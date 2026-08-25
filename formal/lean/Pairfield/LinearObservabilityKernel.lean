import Mathlib
import Pairfield.FutureBehavior

/-!
# The linear observability kernel is singleton-action future equality

This file checks one explicit transport between the repository's generic
`FutureEq` and the classical linear kernel

`Nobs = ⨅ n, ker (P ∘ T^n)`.

The iterate is defined recursively so its orientation agrees definitionally
with `Pairfield.run`, which applies an action word from left to right.
-/

namespace Pairfield.LinearObservabilityKernel

universe u v w

variable {R : Type u} {M : Type v} {O : Type w}
variable [Ring R]
variable [AddCommGroup M] [Module R M]
variable [AddCommGroup O] [Module R O]

/-- The linear iterate oriented exactly like `run`: the successor first takes
one `T` step and then performs the preceding iterate. -/
def iterateLinear (T : Module.End R M) : ℕ → Module.End R M
  | 0 => LinearMap.id
  | n + 1 => (iterateLinear T n).comp T

/-- Regard one linear endomorphism as an action system with one action. -/
def unitStep (T : Module.End R M) : M → Unit → M :=
  fun x _ => T x

/-- Regard a linear observation as the underlying observation function. -/
def linearObserve (P : M →ₗ[R] O) : M → O :=
  fun x => P x

/-- Running the singleton action system depends only on word length and is the
declared linear iterate. -/
theorem run_unitStep_eq_iterate (T : Module.End R M) (x : M)
    (word : List Unit) :
    run (unitStep T) x word = iterateLinear T word.length x := by
  induction word generalizing x with
  | nil => rfl
  | cons _ word induction =>
      simpa [run, unitStep, iterateLinear, LinearMap.comp_apply] using
        induction (T x)

/-- Equality under every natural-number iterate. -/
def LinearFutureEq (T : Module.End R M) (P : M →ₗ[R] O) (x y : M) : Prop :=
  ∀ n : ℕ, P (iterateLinear T n x) = P (iterateLinear T n y)

/-- The classical all-iterate observability submodule. -/
def observabilityKernel (T : Module.End R M) (P : M →ₗ[R] O) : Submodule R M :=
  ⨅ n : ℕ, LinearMap.ker (P.comp (iterateLinear T n))

/-- Singleton-action words and natural iterates present the same future
equality.  The forward direction probes with a length-`n` replicated word;
the reverse direction uses the length of the supplied word. -/
theorem futureEq_iff_linearFutureEq (T : Module.End R M) (P : M →ₗ[R] O)
    (x y : M) :
    FutureEq (unitStep T) (linearObserve P) x y ↔ LinearFutureEq T P x y := by
  constructor
  · intro future n
    have atReplicate := future (List.replicate n ())
    simpa [behavior, linearObserve, run_unitStep_eq_iterate] using atReplicate
  · intro iterates word
    change P (run (unitStep T) x word) = P (run (unitStep T) y word)
    simpa [run_unitStep_eq_iterate] using iterates word.length

/-- In a linear system, equality at every future iterate is exactly membership
of the state difference in the all-iterate kernel. -/
theorem linearFutureEq_iff_sub_mem (T : Module.End R M) (P : M →ₗ[R] O)
    (x y : M) :
    LinearFutureEq T P x y ↔ x - y ∈ observabilityKernel T P := by
  simp only [LinearFutureEq, observabilityKernel, Submodule.mem_iInf,
    LinearMap.mem_ker, LinearMap.comp_apply, LinearMap.map_sub, sub_eq_zero]

/-- The promised witnessed transport: generic future equality in the
singleton-action presentation is the linear observability-kernel relation. -/
theorem futureEq_iff_sub_mem_observabilityKernel
    (T : Module.End R M) (P : M →ₗ[R] O) (x y : M) :
    FutureEq (unitStep T) (linearObserve P) x y ↔
      x - y ∈ observabilityKernel T P :=
  (futureEq_iff_linearFutureEq T P x y).trans
    (linearFutureEq_iff_sub_mem T P x y)

/-- `Nobs` is `T`-invariant because it is the zero class of `FutureEq` and the
already-checked generic relation is preserved by every action.  This proof is
a transport of `futureEq_step`, not a second iterate calculation. -/
theorem observabilityKernel_invariant
    (T : Module.End R M) (P : M →ₗ[R] O) {x : M}
    (hidden : x ∈ observabilityKernel T P) :
    T x ∈ observabilityKernel T P := by
  have futureZero : FutureEq (unitStep T) (linearObserve P) x 0 :=
    (futureEq_iff_sub_mem_observabilityKernel T P x 0).2 (by simpa using hidden)
  have stepped := futureEq_step (unitStep T) (linearObserve P) futureZero ()
  have transported :=
    (futureEq_iff_sub_mem_observabilityKernel T P (T x) 0).1
      (by simpa [unitStep] using stepped)
  simpa using transported

/-! ## Killer control: the instantaneous kernel can be strictly larger -/

def swap : Module.End ℤ (ℤ × ℤ) where
  toFun pair := (pair.2, pair.1)
  map_add' left right := by ext <;> simp
  map_smul' scalar pair := by ext <;> simp

def first : (ℤ × ℤ) →ₗ[ℤ] ℤ where
  toFun pair := pair.1
  map_add' left right := by simp
  map_smul' scalar pair := by simp

def hiddenState : ℤ × ℤ := (0, 1)

theorem hiddenState_in_instantaneousKernel :
    hiddenState ∈ LinearMap.ker first := by
  simp [hiddenState, first]

/-- The hidden second coordinate becomes the observed first coordinate after
one swap, so present equality does not imply future equality. -/
theorem hiddenState_not_futureEq :
    ¬ FutureEq (unitStep swap) (linearObserve first) hiddenState 0 := by
  intro future
  have afterOne := future [()]
  norm_num [behavior, run, unitStep, linearObserve, swap, first, hiddenState]
    at afterOne

theorem hiddenState_not_in_observabilityKernel :
    hiddenState ∉ observabilityKernel swap first := by
  intro hidden
  apply hiddenState_not_futureEq
  apply (futureEq_iff_sub_mem_observabilityKernel swap first hiddenState 0).2
  simpa using hidden

end Pairfield.LinearObservabilityKernel
