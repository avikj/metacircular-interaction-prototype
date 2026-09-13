{-# OPTIONS --cubical --safe --no-import-sorts #-}
------------------------------------------------------------------------
-- एक-सूत्रम् — the one thread through the boxed correspondence.
--
-- Hieroglyphics I §F boxes a chain
--
--     δ_◇ ↔ [α] ↔ δ̌c ↔ F_∇ ↔ (Hol − 1)      and      Δ_e , G_T
--
-- and its triage (J2) asks the only question that matters: "is the bridge
-- between the two halves a theorem, or a pun? … not a correspondence until
-- the functor carrying one to the other is exhibited."
--
-- Exhibited.  The functor is the mapping torus.  For an automorphism
-- e : B ≃ B, the family  Torus e : S¹ → Type  with fibre B and monodromy e
-- around the loop is the geometric side (Hol = e).  Then, on the nose:
--
--   Section (Torus e)  ≃  FixedPoint (equivFun e)
--
-- — a section of the cover IS a fixed point of the holonomy.  Lawvere's
-- theorem (in `Lawvere`, already checked) says a point-surjection
-- φ : A → (A → B) forces a fixed point of EVERY endomap of B.  So:
--
--   PtSurj φ  ⟹  every mapping torus over B has a section      (logic ⇒ geometry)
--   Hol has no fixed point  ⟹  no section, AND no point-surjection onto
--   B^A for any A                                              (geometry ⇒ logic)
--
-- The two halves are one theorem because Lawvere's fixed-point-free f and
-- the nontrivial holonomy are the same object: an automorphism of the
-- fibre that moves every point.  Cantor is the case e = not: the double
-- cover of the circle has no section (the Möbius band), and the same
-- `not` is the diagonal's flip.  Gödel's G_T is the same shape at the
-- level of provability, and is not re-proved here.
--
-- `CatuhSamskara` shows the case e = sucℤ on the universal cover; here
-- `Γ^-monodromy-free` gives no section of the helix over S¹ — which is the
-- statement that the loop does not close.
------------------------------------------------------------------------
module Ekasutra_TheGeometricAndLogicalHalvesOfTheCorrespondenceAreOneTheoremASectionOfTheMappingTorusIsAFixedPointOfTheMonodromySoLawvereGivesSectionsAndAFreeMonodromyRefutesEveryPointSurjection where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Equiv using (_≃_ ; equivFun)
open import Cubical.Foundations.Isomorphism using (Iso ; iso ; isoToEquiv)
open import Cubical.Foundations.Univalence using (ua ; ua-ungluePath ; ua-gluePath)
open import Cubical.Data.Sigma using (Σ-syntax ; _×_ ; _,_ ; fst ; snd)
open import Cubical.Data.Bool using (Bool ; not ; notEquiv)
open import Cubical.HITs.S1 using (S¹ ; base ; loop)
open import Cubical.Relation.Nullary using (¬_)

open import Lawvere using (PtSurj ; FixedPoint ; lawvere ; noFix→noPtSurj ; not-no-fix)

module _ {B : Type₀} (e : B ≃ B) where

  -- १ · the mapping torus: fibre B over the circle, monodromy e
  Torus : S¹ → Type₀
  Torus base     = B
  Torus (loop i) = ua e i

  Section : Type₀
  Section = (x : S¹) → Torus x

  -- २ · a section is a fixed point of the monodromy, and conversely
  toFix : Section → FixedPoint (equivFun e)
  toFix s = s base , ua-ungluePath e (λ i → s (loop i))

  fromFix : FixedPoint (equivFun e) → Section
  fromFix (b , p) base     = b
  fromFix (b , p) (loop i) = ua-gluePath e p i

  private
    ret : (s : Section) (x : S¹) → fromFix (toFix s) x ≡ s x
    ret s base     = refl
    ret s (loop i) = refl

  Section≃FixedPoint : Section ≃ FixedPoint (equivFun e)
  Section≃FixedPoint = isoToEquiv (iso toFix fromFix (λ _ → refl) (λ s → funExt (ret s)))

  -- ३ · logic ⇒ geometry: a point-surjection onto B^A gives every torus a section
  ptSurj→section : {A : Type₀} (φ : A → (A → B)) → PtSurj φ → Section
  ptSurj→section φ surj = fromFix (lawvere φ surj (equivFun e))

  -- ४ · geometry ⇒ logic: a monodromy that moves every point refutes both
  noFix→noSection : ((b : B) → ¬ (equivFun e b ≡ b)) → ¬ Section
  noFix→noSection nofix s = nofix (s base) (toFix s .snd)

  bridge : ((b : B) → ¬ (equivFun e b ≡ b))
         → (¬ Section) × ({A : Type₀} (φ : A → (A → B)) → ¬ PtSurj φ)
  bridge nofix = noFix→noSection nofix , λ φ → noFix→noPtSurj φ (equivFun e) nofix

------------------------------------------------------------------------
-- ५ · Cantor is the double cover: `not` is the flip of the diagonal and
--     the monodromy of the Möbius band, and it moves every point.
------------------------------------------------------------------------

Möbius : ¬ Section notEquiv
Möbius = noFix→noSection notEquiv not-no-fix

cantor-and-möbius :
    (¬ Section notEquiv) × ({A : Type₀} (φ : A → (A → Bool)) → ¬ PtSurj φ)
cantor-and-möbius = bridge notEquiv not-no-fix
