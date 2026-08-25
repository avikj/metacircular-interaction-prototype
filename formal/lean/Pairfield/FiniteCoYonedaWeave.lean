/-
Copyright (c) 2026 Avik Jain and the mathematics collaboration.
Released under Apache 2.0 license.

A bounded T25.C instance.  On the finite walking-arrow preorder `Fin 2`, the
presheaf represented by the target is a colimit of representables.  At the
source, the coend incidence quotient glues two distinct bare factorizations.
-/
import Mathlib.CategoryTheory.Limits.Presheaf
import Mathlib.CategoryTheory.Category.Preorder

namespace Pairfield.FiniteCoYonedaWeave

open CategoryTheory CategoryTheory.Limits

/-- The finite walking-arrow category, using the category attached to its order. -/
abbrev Jewel := Fin 2

/-- The source jewel. -/
def source : Jewel := 0

/-- The target jewel. -/
def target : Jewel := 1

/-- The unique nonidentity thread in the walking-arrow category. -/
def thread : source ⟶ target :=
  homOfLE (by decide)

/-- The chosen global field is the presheaf represented by the target jewel. -/
abbrev GlobalField : Jewelᵒᵖ ⥤ Type :=
  yoneda.obj target

/--
The chosen field is a colimit of representables.  This is a direct finite
instantiation of Mathlib's inherited density theorem, not a new general proof.
-/
def globalFieldIsColimitOfRepresentables :
    IsColimit (Presheaf.coconeOfRepresentable GlobalField) :=
  Presheaf.colimitOfRepresentable GlobalField

/--
Before incidence gluing, a source-observed profile chooses an intermediate
jewel and a factorization `source ⟶ jewel ⟶ target`.
-/
abbrev BareProfile :=
  Σ jewel : Jewel, (jewel ⟶ target) × (source ⟶ jewel)

/-- Composition evaluates a bare factorization in the chosen global field. -/
def bareEvaluation (profile : BareProfile) : source ⟶ target :=
  profile.2.2 ≫ profile.2.1

/--
The coend incidence generator: sliding a thread across the tensor sign changes
the chosen intermediate jewel but not the composite global-field element.
-/
inductive Incidence : BareProfile → BareProfile → Prop where
  | weave {left right : Jewel} (step : left ⟶ right)
      (outgoing : right ⟶ target) (incoming : source ⟶ left) :
      Incidence
        ⟨left, step ≫ outgoing, incoming⟩
        ⟨right, outgoing, incoming ≫ step⟩

/-- The woven source profile is the quotient by categorical incidence. -/
abbrev WovenProfile := Quot Incidence

theorem incidence_preserves_evaluation {left right : BareProfile}
    (related : Incidence left right) :
    bareEvaluation left = bareEvaluation right := by
  cases related
  simp [bareEvaluation, Category.assoc]

/-- Evaluate an incidence class in the chosen global field. -/
def wovenEvaluation : WovenProfile → (source ⟶ target) :=
  Quot.lift bareEvaluation fun _ _ related =>
    incidence_preserves_evaluation related

/-- Present a global-field element with the source jewel as intermediate. -/
def canonicalBare (global : source ⟶ target) : BareProfile :=
  ⟨source, global, 𝟙 source⟩

/-- Include a global-field element into the incidence quotient. -/
def canonicalWoven (global : source ⟶ target) : WovenProfile :=
  Quot.mk Incidence (canonicalBare global)

@[simp]
theorem wovenEvaluation_canonical (global : source ⟶ target) :
    wovenEvaluation (canonicalWoven global) = global := by
  simp [wovenEvaluation, canonicalWoven, canonicalBare, bareEvaluation]

theorem canonicalWoven_evaluation (woven : WovenProfile) :
    canonicalWoven (wovenEvaluation woven) = woven := by
  refine Quot.inductionOn woven ?_
  rintro ⟨jewel, outgoing, incoming⟩
  apply Quot.sound
  simpa [canonicalWoven, canonicalBare, wovenEvaluation, bareEvaluation] using
    (Incidence.weave incoming outgoing (𝟙 source))

/-- The finite coend component reconstructs exactly the chosen global field. -/
def wovenProfileEquivGlobalField :
    WovenProfile ≃ (source ⟶ target) where
  toFun := wovenEvaluation
  invFun := canonicalWoven
  left_inv := canonicalWoven_evaluation
  right_inv := wovenEvaluation_canonical

/-- The factorization through the source jewel. -/
def sourcePresentation : BareProfile :=
  ⟨source, thread, 𝟙 source⟩

/-- The factorization through the target jewel. -/
def targetPresentation : BareProfile :=
  ⟨target, 𝟙 target, thread⟩

/-- A bare union retains the choice of intermediate jewel. -/
theorem bare_presentations_distinct :
    sourcePresentation ≠ targetPresentation := by
  intro equality
  have : source = target := congrArg Sigma.fst equality
  exact Fin.zero_ne_one this

/-- Categorical incidence glues the two factorizations of the same thread. -/
theorem woven_presentations_equal :
    (Quot.mk Incidence sourcePresentation : WovenProfile) =
      Quot.mk Incidence targetPresentation := by
  apply Quot.sound
  simpa [sourcePresentation, targetPresentation, thread] using
    (Incidence.weave thread (𝟙 target) (𝟙 source))

/-- Therefore the quotient projection has no left decoder. -/
theorem no_bare_decoder
    (decode : WovenProfile → BareProfile) :
    ¬ Function.LeftInverse decode (Quot.mk Incidence) := by
  intro leftInverse
  apply bare_presentations_distinct
  rw [← leftInverse sourcePresentation, ← leftInverse targetPresentation,
    woven_presentations_equal]

end Pairfield.FiniteCoYonedaWeave
