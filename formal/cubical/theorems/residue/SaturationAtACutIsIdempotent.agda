{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- SaturationAtACutIsIdempotent
--
-- nucleus at a cut") describes an elimination procedure:
--
--   "Nuc(K_e): saturated dual pairs (x, y) with y = Kâx, x = Kâ“y â”
--    exact burden profile and exact residual profile, a tight separable
--    majorant. â¦ Elimination via nucleus generators: compute, cover,
--    pass generator coefficients, compose by min-plus convolution,
--    re-saturate.  No tractability theorem claimed."
--
-- "Re-saturate" is stated as a step of an algorithm and nothing says it
-- terminates, or that it terminates in ONE application.  That is the
-- gap this module fills, at the level of generality where it is a
-- theorem rather than an assertion.
--
-- â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”
-- NO NOVELTY IS CLAIMED FOR ANY THEOREM BELOW.  This is the Galois
-- connection induced by a relation â” Birkhoff's polarities (`Lattice
-- Theory`, 1940, Â§V on polarities); the same adjunction is the basis of
-- formal concept analysis (Ganter & Wille, `Formale Begriffsanalyse`,
-- 1996 / `Formal Concept Analysis`, 1999), where the saturated pairs
-- are the *concepts* of a context and the closure below is the concept
-- closure; and Isbell's construction (`Adequate subcategories`, 1960;
-- the conjugation of 1966) is the enriched form the note's name points
-- at.  All that is contributed here is that the step Î” 28 Â§31â“32 calls
-- "re-saturate" is checked to be idempotent, so the procedure does not
-- loop.
--
-- â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”
-- WHAT IS PROVED, for an arbitrary K : X â’ Y â’ Type
--
--   â-antitone / â“-antitone   the two polarities reverse inclusion
--   unit / counit             A âŠ â“(â A) and B âŠ â(â“ B)
--   triangleâ / triangleâ'    â A and â(â“(â A)) contain each other â”
--                             saturating a profile that came from a
--                             saturation changes nothing
--   c-inflationary / c-monotone / c-idempotent
--                             so c = â“ âˆ˜ â is a closure operator, and
--                             re-saturation is idempotent
--   fixedGivesSaturated / saturatedGivesFixed
--                             the saturated dual pairs of Â§31 are
--                             EXACTLY the fixed points of c
--
-- The content for Â§31â“32 is the last two together with idempotence: an
-- implementation may re-saturate once after each composition and stop,
-- and "saturated pair" is not an extra condition to maintain â” it is
-- what being a fixed point of the closure means.
--
-- â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”
--
-- The note's â and â“ are min-plus RESIDUATIONS over a semiring-valued
-- kernel, taking burden profiles to residual profiles.  The â and â“
-- below are the two-valued polarities of a RELATION.  That the former
-- is an instance of the latter is NOT proved here and is not obvious:
-- it needs the kernel's values to form a quantale and the residuations
-- to be its adjoints, none of which is set up in this repository.  So
-- what is established is that the SATURATION discipline is sound
-- wherever the adjunction holds â” not that Î” 28's particular â/â“ satisfy
-- it.  Reading this as a theorem about min-plus convolution would be
-- exactly the error of quoting a figure without its input.
--
-- Inclusion is used, not equality: `A âŠ B` and `B âŠ A` are proved
-- separately and never combined into a path.  Turning them into `A â‰¡ B`
-- needs the predicates to be proposition-valued and funExt, neither of
-- which is assumed, and nothing below needs it.
--
-- No tractability theorem is claimed here either â” Â§31â“32 says it
-- claims none, and computing c is no cheaper for being idempotent.
--
-- On the two-slot shape: this repository already carries a distinct
-- two-slot structure in `formal/cubical/AbhavaAvacchedaka.agda` and
-- `NaturalMachine/TheAnuyogitaAvacchedakaIsADistinctSlot`, from
-- Nyya-Vaieika's treatment of absence, where the pratiyogin and the
-- anuyogin occupy separate delimitor slots.  It is NOT claimed that
-- that is a Galois connection or that these are the same structure â”
-- the Naiyyika slots are not required to be adjoint and nothing here
-- checks that they are.  The pointer is so a later reader compares them
-- rather than assuming either way.
--
-- CHECKED on the CONTAINER (Agda 2.6.3, cubical v0.5 â” NOT the declared
-- pin, Agda 2.8.0 + cubical v0.9).  --safe, no postulates, no holes.
------------------------------------------------------------------------

module SaturationAtACutIsIdempotent where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Sigma using (_Ã—_ ; _,_)

------------------------------------------------------------------------
-- 0.  Inclusion
------------------------------------------------------------------------

_âŠ†_ : {A : Type} â†’ (A â†’ Type) â†’ (A â†’ Type) â†’ Type
_âŠ†_ {A} P Q = (a : A) â†’ P a â†’ Q a

âŠ†-refl : {A : Type} (P : A â†’ Type) â†’ P âŠ† P
âŠ†-refl P a p = p

âŠ†-trans : {A : Type} (P Q R : A â†’ Type) â†’ P âŠ† Q â†’ Q âŠ† R â†’ P âŠ† R
âŠ†-trans P Q R f g a p = g a (f a p)

------------------------------------------------------------------------
-- 1.  The two polarities of a cut
--
-- K x y reads "burden x is discharged by residual y".  â A collects the
-- residuals discharging every burden in A; â“ B the burdens discharged
-- by every residual in B.
------------------------------------------------------------------------

module _ {X Y : Type} (K : X â†’ Y â†’ Type) where

  â†‘ : (X â†’ Type) â†’ (Y â†’ Type)
  â†‘ A y = (x : X) â†’ A x â†’ K x y

  â†“ : (Y â†’ Type) â†’ (X â†’ Type)
  â†“ B x = (y : Y) â†’ B y â†’ K x y

  â†‘-antitone : (A A' : X â†’ Type) â†’ A âŠ† A' â†’ â†‘ A' âŠ† â†‘ A
  â†‘-antitone A A' sub y f x a = f x (sub x a)

  â†“-antitone : (B B' : Y â†’ Type) â†’ B âŠ† B' â†’ â†“ B' âŠ† â†“ B
  â†“-antitone B B' sub x g y b = g y (sub y b)

  unit : (A : X â†’ Type) â†’ A âŠ† â†“ (â†‘ A)
  unit A x a y f = f x a

  counit : (B : Y â†’ Type) â†’ B âŠ† â†‘ (â†“ B)
  counit B y b x g = g y b

------------------------------------------------------------------------
-- 2.  Saturating a saturated profile changes nothing
------------------------------------------------------------------------

  triangleâ†‘ : (A : X â†’ Type) â†’ â†‘ A âŠ† â†‘ (â†“ (â†‘ A))
  triangleâ†‘ A = counit (â†‘ A)

  triangleâ†‘' : (A : X â†’ Type) â†’ â†‘ (â†“ (â†‘ A)) âŠ† â†‘ A
  triangleâ†‘' A = â†‘-antitone A (â†“ (â†‘ A)) (unit A)

------------------------------------------------------------------------
-- 3.  Hence re-saturation is idempotent
------------------------------------------------------------------------

  c : (X â†’ Type) â†’ (X â†’ Type)
  c A = â†“ (â†‘ A)

  c-inflationary : (A : X â†’ Type) â†’ A âŠ† c A
  c-inflationary = unit

  c-monotone : (A A' : X â†’ Type) â†’ A âŠ† A' â†’ c A âŠ† c A'
  c-monotone A A' sub = â†“-antitone (â†‘ A') (â†‘ A) (â†‘-antitone A A' sub)

  c-idempotent-in : (A : X â†’ Type) â†’ c (c A) âŠ† c A
  c-idempotent-in A = â†“-antitone (â†‘ A) (â†‘ (c A)) (triangleâ†‘ A)

  c-idempotent-out : (A : X â†’ Type) â†’ c A âŠ† c (c A)
  c-idempotent-out A = unit (c A)

------------------------------------------------------------------------
-- 4.  The saturated dual pairs are exactly the fixed points
------------------------------------------------------------------------

  Saturated : (X â†’ Type) â†’ (Y â†’ Type) â†’ Type
  Saturated A B = ((â†‘ A âŠ† B) Ã— (B âŠ† â†‘ A)) Ã— ((â†“ B âŠ† A) Ã— (A âŠ† â†“ B))

  fixedGivesSaturated : (A : X â†’ Type) â†’ c A âŠ† A â†’ Saturated A (â†‘ A)
  fixedGivesSaturated A fix =
    (âŠ†-refl (â†‘ A) , âŠ†-refl (â†‘ A)) , (fix , unit A)

  saturatedGivesFixed :
    (A : X â†’ Type) (B : Y â†’ Type) â†’ Saturated A B â†’ c A âŠ† A
  saturatedGivesFixed A B ((_ , ba) , (da , _)) =
    âŠ†-trans (c A) (â†“ B) A (â†“-antitone B (â†‘ A) ba) da

------------------------------------------------------------------------
-- APPENDED 2026-08-19, by the same identity, at the end, altering no
-- line above.  The NOT-CLAIMED section names a gap â”
--
--   "what is established is that the SATURATION discipline is sound
--    wherever the adjunction holds â” not that Î” 28's particular â/â“
--    satisfy it"
--
-- â” without saying what would close it.  Now said, in
-- `TheSaturationClosureNeedsOnlyAGaloisConnection`
-- (--safe, no postulates, no holes; container green under Agda 2.6.3 +
-- cubical v0.5, NOT the declared pin â” check.sh returns 1 and says so).
--
-- Everything above uses NOTHING about `Type`, `âŠ`, or the relation K.
-- It uses two preorders, two maps, and the two directions of a
-- contravariant Galois connection.  Antitonicity, unit, counit, the
-- triangles, idempotence, and the fixed-point characterisation are all
-- DERIVED from those, in `module Galois`.
--
-- The consequence for Î” 28 is that the residuation case requires no
-- re-proving of anything above.  It requires exactly:
--
--   a preorder on burden profiles, a preorder on residual profiles, and
--
--     galFwd : a â‰¼ d b â’ b âŠ u a
--     galBwd : b âŠ u a â’ a â‰¼ d b
--
--   for the min-plus â and â“ â” and nothing else.
--
-- Â§5 there checks that THIS module is one instance: `galFwdPred` and
-- `galBwdPred` are a line each, and the closure theory transports with
-- nothing re-proved.  That is what makes the size of the remaining
-- obligation credible rather than asserted.
--
------------------------------------------------------------------------
