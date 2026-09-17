{-# OPTIONS --cubical --safe --no-import-sorts #-}
------------------------------------------------------------------------
-- àà•-ààààà°à®à â” the one thread through the boxed correspondence.
--
-- Hieroglyphics I Â§F boxes a chain
--
--     Î´_â— â” [Î] â” Î´Ìc â” F_âˆ â” (Hol âˆ’ 1)      and      Î”_e , G_T
--
-- and its triage (J2) asks the only question that matters: "is the bridge
-- between the two halves a theorem, or a pun? â¦ not a correspondence until
-- the functor carrying one to the other is exhibited."
--
-- Exhibited.  The functor is the mapping torus.  For an automorphism
-- e : B â‰ B, the family  Torus e : SÂ â’ Type  with fibre B and monodromy e
-- around the loop is the geometric side (Hol = e).  Then, on the nose:
--
--   Section (Torus e)  â‰  FixedPoint (equivFun e)
--
-- â” a section of the cover IS a fixed point of the holonomy.  Lawvere's
-- theorem (in `Lawvere`, already checked) says a point-surjection
-- Ï : A â’ (A â’ B) forces a fixed point of EVERY endomap of B.  So:
--
--   PtSurj Ï  âŸ  every mapping torus over B has a section      (logic â’ geometry)
--   Hol has no fixed point  âŸ  no section, AND no point-surjection onto
--   B^A for any A                                              (geometry â’ logic)
--
-- The two halves are one theorem because Lawvere's fixed-point-free f and
-- the nontrivial holonomy are the same object: an automorphism of the
-- fibre that moves every point.  Cantor is the case e = not: the double
-- cover of the circle has no section (the Mbius band), and the same
-- `not` is the diagonal's flip.  Gdel's G_T is the same shape at the
-- level of provability, and is not re-proved here.
--
-- `CatuhSamskara` shows the case e = sucâ on the universal cover; here
-- `Î“^-monodromy-free` gives no section of the helix over SÂ â” which is the
-- statement that the loop does not close.
------------------------------------------------------------------------
module Ekasutra_TheGeometricAndLogicalHalvesOfTheCorrespondenceAreOneTheoremASectionOfTheMappingTorusIsAFixedPointOfTheMonodromySoLawvereGivesSectionsAndAFreeMonodromyRefutesEveryPointSurjection where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Equiv using (_â‰ƒ_ ; equivFun)
open import Cubical.Foundations.Isomorphism using (Iso ; iso ; isoToEquiv)
open import Cubical.Foundations.Univalence using (ua ; ua-ungluePath ; ua-gluePath)
open import Cubical.Data.Sigma using (Î£-syntax ; _Ã—_ ; _,_ ; fst ; snd)
open import Cubical.Data.Bool using (Bool ; not ; notEquiv)
open import Cubical.HITs.S1 using (SÂ¹ ; base ; loop)
open import Cubical.Relation.Nullary using (Â¬_)

open import Lawvere using (PtSurj ; FixedPoint ; lawvere ; noFixâ†’noPtSurj ; not-no-fix)

module _ {B : Typeâ‚€} (e : B â‰ƒ B) where

  -- à§ Â the mapping torus: fibre B over the circle, monodromy e
  Torus : SÂ¹ â†’ Typeâ‚€
  Torus base     = B
  Torus (loop i) = ua e i

  Section : Typeâ‚€
  Section = (x : SÂ¹) â†’ Torus x

  -- à¨ Â a section is a fixed point of the monodromy, and conversely
  toFix : Section â†’ FixedPoint (equivFun e)
  toFix s = s base , ua-ungluePath e (Î» i â†’ s (loop i))

  fromFix : FixedPoint (equivFun e) â†’ Section
  fromFix (b , p) base     = b
  fromFix (b , p) (loop i) = ua-gluePath e p i

  private
    ret : (s : Section) (x : SÂ¹) â†’ fromFix (toFix s) x â‰¡ s x
    ret s base     = refl
    ret s (loop i) = refl

  Sectionâ‰ƒFixedPoint : Section â‰ƒ FixedPoint (equivFun e)
  Sectionâ‰ƒFixedPoint = isoToEquiv (iso toFix fromFix (Î» _ â†’ refl) (Î» s â†’ funExt (ret s)))

  -- à© Â logic â’ geometry: a point-surjection onto B^A gives every torus a section
  ptSurjâ†’section : {A : Typeâ‚€} (Ï† : A â†’ (A â†’ B)) â†’ PtSurj Ï† â†’ Section
  ptSurjâ†’section Ï† surj = fromFix (lawvere Ï† surj (equivFun e))

  -- à Â geometry â’ logic: a monodromy that moves every point refutes both
  noFixâ†’noSection : ((b : B) â†’ Â¬ (equivFun e b â‰¡ b)) â†’ Â¬ Section
  noFixâ†’noSection nofix s = nofix (s base) (toFix s .snd)

  bridge : ((b : B) â†’ Â¬ (equivFun e b â‰¡ b))
         â†’ (Â¬ Section) Ã— ({A : Typeâ‚€} (Ï† : A â†’ (A â†’ B)) â†’ Â¬ PtSurj Ï†)
  bridge nofix = noFixâ†’noSection nofix , Î» Ï† â†’ noFixâ†’noPtSurj Ï† (equivFun e) nofix

------------------------------------------------------------------------
-- à Â Cantor is the double cover: `not` is the flip of the diagonal and
--     the monodromy of the Mbius band, and it moves every point.
------------------------------------------------------------------------

MÃ¶bius : Â¬ Section notEquiv
MÃ¶bius = noFixâ†’noSection notEquiv not-no-fix

cantor-and-mÃ¶bius :
    (Â¬ Section notEquiv) Ã— ({A : Typeâ‚€} (Ï† : A â†’ (A â†’ Bool)) â†’ Â¬ PtSurj Ï†)
cantor-and-mÃ¶bius = bridge notEquiv not-no-fix
