/-
Finite-information kernel for observer/quotient arguments.

The statements are deliberately distribution-free.  Shannon entropy may be
attached later after choosing a probability law; the algebraic core is simply
factorization through an observable and injectivity after adding side data.
-/
import Mathlib.Data.Set.Image

namespace Pairfield

universe u v w z

/-- A target `t` descends through an observable `q` when it is a function of
the observed value alone.  Using `Set.range q` avoids an arbitrary default on
unobservable values of the ambient codomain. -/
def FactorsThrough {X : Type u} {Y : Type v} {T : Type w}
    (q : X → Y) (t : X → T) : Prop :=
  ∃ decode : Set.range q → T,
    ∀ x, decode ⟨q x, ⟨x, rfl⟩⟩ = t x

/-- Descent through an observer is exactly constancy on every observer fiber. -/
theorem factorsThrough_iff_fiberConstant
    {X : Type u} {Y : Type v} {T : Type w}
    (q : X → Y) (t : X → T) :
    FactorsThrough q t ↔ ∀ ⦃x x'⦄, q x = q x' → t x = t x' := by
  constructor
  · rintro ⟨decode, hdecode⟩ x x' hq
    rw [← hdecode x, ← hdecode x']
    congr
  · intro hfiber
    classical
    let decode : Set.range q → T := fun y => t (Classical.choose y.property)
    refine ⟨decode, ?_⟩
    intro x
    apply hfiber
    exact Classical.choose_spec (show q x ∈ Set.range q from ⟨x, rfl⟩)

/-- Side information `c` completes an observable `q` when the pair `(q,c)`
recovers the original state without error. -/
def Completes {X : Type u} {Y : Type v} {C : Type w}
    (q : X → Y) (c : X → C) : Prop :=
  Function.Injective fun x => (q x, c x)

/-- Completion is exactly separation of distinct points inside each fiber. -/
theorem completes_iff_separatesFibers
    {X : Type u} {Y : Type v} {C : Type w}
    (q : X → Y) (c : X → C) :
    Completes q c ↔ ∀ ⦃x x'⦄, q x = q x' → c x = c x' → x = x' := by
  constructor
  · intro h x x' hq hc
    apply h
    exact Prod.ext hq hc
  · intro h x x' heq
    apply h
    · exact congrArg (fun p : Y × C => p.1) heq
    · exact congrArg (fun p : Y × C => p.2) heq

/-- If `q` is already injective, no side information is needed. -/
theorem completes_of_injective
    {X : Type u} {Y : Type v} {C : Type w}
    {q : X → Y} (hq : Function.Injective q) (c : X → C) :
    Completes q c := by
  intro x x' h
  exact hq (congrArg Prod.fst h)

/-- An observable postprocessing cannot create a target that did not already
descend through the finer observable.  This is the deterministic core of data
processing. -/
theorem factorsThrough_postprocess
    {X : Type u} {Y : Type v} {Z : Type z} {T : Type w}
    (q : X → Y) (r : Y → Z) (t : X → T)
    (h : FactorsThrough (r ∘ q) t) :
    FactorsThrough q t := by
  rw [factorsThrough_iff_fiberConstant] at h ⊢
  intro x x' hq
  apply h
  exact congrArg r hq

/-- Exact reconstruction is stable under adding more side information. -/
theorem completes_mono
    {X : Type u} {Y : Type v} {C : Type w} {D : Type z}
    (q : X → Y) (c : X → C) (d : X → D)
    (h : Completes q c) :
    Completes q (fun x => (c x, d x)) := by
  intro x x' heq
  apply h
  apply Prod.ext
  · exact congrArg (fun p : Y × (C × D) => p.1) heq
  · exact congrArg (fun p : Y × (C × D) => p.2.1) heq

end Pairfield
