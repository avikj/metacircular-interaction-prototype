{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- TheSaturationClosureNeedsOnlyAGaloisConnection
--
-- The whole closure argument uses
-- NOTHING about `Type`, `âŠ`, or the relation K.  It uses two preorders,
-- two maps, and the two directions of a contravariant Galois connection.
-- Everything else â” antitonicity, unit, counit, the triangles,
-- idempotence â” is derived.
--
-- So the residuation instance is not a matter of re-proving anything.
-- It is exactly this obligation and no more:
--
--   a preorder on burden profiles, a preorder on residual profiles, and
--
--     galFwd : a â‰¼ d b â’ b âŠ u a
--     galBwd : b âŠ u a â’ a â‰¼ d b
--
--   for the min-plus â and â“.
--
-- â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”
-- WHAT IS PROVED
--
--   u-antitone / d-antitone   derived, not assumed
--   unit / counit             a â‰¼ d (u a), b âŠ u (d b)
--   triangle-in / triangle-out
--   c-inflationary / c-monotone / c-idempotent-in / c-idempotent-out
--   fixedGivesSaturated / saturatedGivesFixed
--   Â§5: the previous module's Type-valued polarities ARE an instance â”
--   `galFwdPred` and `galBwdPred` are one line each, and
--   `saturationIsAnInstance` transports the closure back
--
-- NO NOVELTY.  Contravariant Galois connections and the fact that
-- `d âˆ˜ u` is a closure operator are Birkhoff (`Lattice Theory`, 1940,
-- Â§V); the general order-theoretic treatment is Ore's ("Galois
-- connexions", *Trans. AMS* 55, 1944), which is where the abstract form
-- used here â” two preorders, two antitone maps, one adjunction â” is
-- stated.  What is contributed is the reduction of Î” 28 Â§31â“32's
-- residuation obligation to those two lines.
------------------------------------------------------------------------

module TheSaturationClosureNeedsOnlyAGaloisConnection where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Sigma using (_Ã—_ ; _,_)

------------------------------------------------------------------------
-- 1.  The only assumptions: two preorders and one adjunction
------------------------------------------------------------------------

module Galois
  {â„“P â„“Q â„“â‰¼ â„“âŠ‘ : Level}
  {P : Type â„“P} {Q : Type â„“Q}
  (_â‰¼_ : P â†’ P â†’ Type â„“â‰¼)
  (_âŠ‘_ : Q â†’ Q â†’ Type â„“âŠ‘)
  (â‰¼-refl  : (a : P) â†’ a â‰¼ a)
  (â‰¼-trans : (a b c : P) â†’ a â‰¼ b â†’ b â‰¼ c â†’ a â‰¼ c)
  (âŠ‘-refl  : (b : Q) â†’ b âŠ‘ b)
  (âŠ‘-trans : (a b c : Q) â†’ a âŠ‘ b â†’ b âŠ‘ c â†’ a âŠ‘ c)
  (u : P â†’ Q) (d : Q â†’ P)
  (galFwd : (a : P) (b : Q) â†’ a â‰¼ d b â†’ b âŠ‘ u a)
  (galBwd : (a : P) (b : Q) â†’ b âŠ‘ u a â†’ a â‰¼ d b)
  where

  unit : (a : P) â†’ a â‰¼ d (u a)
  unit a = galBwd a (u a) (âŠ‘-refl (u a))

  counit : (b : Q) â†’ b âŠ‘ u (d b)
  counit b = galFwd (d b) b (â‰¼-refl (d b))

  u-antitone : (a a' : P) â†’ a â‰¼ a' â†’ u a' âŠ‘ u a
  u-antitone a a' le = galFwd a (u a') (â‰¼-trans a a' (d (u a')) le (unit a'))

  d-antitone : (b b' : Q) â†’ b âŠ‘ b' â†’ d b' â‰¼ d b
  d-antitone b b' le = galBwd (d b') b (âŠ‘-trans b b' (u (d b')) le (counit b'))

  ------------------------------------------------------------------
  -- 2.  Saturating a saturated profile changes nothing
  ------------------------------------------------------------------

  triangle-in : (a : P) â†’ u (d (u a)) âŠ‘ u a
  triangle-in a = u-antitone a (d (u a)) (unit a)

  triangle-out : (a : P) â†’ u a âŠ‘ u (d (u a))
  triangle-out a = counit (u a)

  ------------------------------------------------------------------
  -- 3.  Hence re-saturation is idempotent
  ------------------------------------------------------------------

  c : P â†’ P
  c a = d (u a)

  c-inflationary : (a : P) â†’ a â‰¼ c a
  c-inflationary = unit

  c-monotone : (a a' : P) â†’ a â‰¼ a' â†’ c a â‰¼ c a'
  c-monotone a a' le = d-antitone (u a') (u a) (u-antitone a a' le)

  c-idempotent-in : (a : P) â†’ c (c a) â‰¼ c a
  c-idempotent-in a = d-antitone (u a) (u (c a)) (counit (u a))

  c-idempotent-out : (a : P) â†’ c a â‰¼ c (c a)
  c-idempotent-out a = unit (c a)

  ------------------------------------------------------------------
  -- 4.  Saturated pairs are exactly the fixed points
  ------------------------------------------------------------------

  Saturated : P â†’ Q â†’ Type (â„“-max â„“â‰¼ â„“âŠ‘)
  Saturated a b = ((u a âŠ‘ b) Ã— (b âŠ‘ u a)) Ã— ((d b â‰¼ a) Ã— (a â‰¼ d b))

  fixedGivesSaturated : (a : P) â†’ c a â‰¼ a â†’ Saturated a (u a)
  fixedGivesSaturated a fix =
    (âŠ‘-refl (u a) , âŠ‘-refl (u a)) , (fix , unit a)

  saturatedGivesFixed : (a : P) (b : Q) â†’ Saturated a b â†’ c a â‰¼ a
  saturatedGivesFixed a b ((_ , bu) , (da , _)) =
    â‰¼-trans (c a) (d b) a (d-antitone b (u a) bu) da

------------------------------------------------------------------------
-- 5.  The previous module's polarities are an instance
--
-- Two one-line proofs, which is the point: this is the entire cost of
-- being an instance.
------------------------------------------------------------------------

_âŠ†_ : {â„“ : Level} {A : Type â„“} â†’ (A â†’ Type) â†’ (A â†’ Type) â†’ Type â„“
_âŠ†_ {A = A} S T = (a : A) â†’ S a â†’ T a

âŠ†-refl : {â„“ : Level} {A : Type â„“} (S : A â†’ Type) â†’ S âŠ† S
âŠ†-refl S a s = s

âŠ†-trans : {â„“ : Level} {A : Type â„“} (S T U : A â†’ Type) â†’ S âŠ† T â†’ T âŠ† U â†’ S âŠ† U
âŠ†-trans S T U f g a s = g a (f a s)

module Polarity {X Y : Type} (K : X â†’ Y â†’ Type) where

  up : (X â†’ Type) â†’ (Y â†’ Type)
  up A y = (x : X) â†’ A x â†’ K x y

  dn : (Y â†’ Type) â†’ (X â†’ Type)
  dn B x = (y : Y) â†’ B y â†’ K x y

  galFwdPred : (A : X â†’ Type) (B : Y â†’ Type) â†’ A âŠ† dn B â†’ B âŠ† up A
  galFwdPred A B h y b x a = h x a y b

  galBwdPred : (A : X â†’ Type) (B : Y â†’ Type) â†’ B âŠ† up A â†’ A âŠ† dn B
  galBwdPred A B h x a y b = h y b x a

  -- and the whole closure theory transports, with nothing re-proved
  open Galois {P = X â†’ Type} {Q = Y â†’ Type}
              _âŠ†_ _âŠ†_ âŠ†-refl âŠ†-trans âŠ†-refl âŠ†-trans
              up dn galFwdPred galBwdPred
    public

------------------------------------------------------------------------
-- THE MIN-PLUS INSTANCE.  `galFwd` and `galBwd` for a semiring-valued
-- kernel are paid AT ONE CUT, with real min-plus data, in
-- `MinPlusResiduationIsAGaloisConnectionAtOneCut`:
--
--   âˆ-adjË¡ / âˆ-adjÊ³   K âˆ Ïˆ â‰ Ï âŸº K â‰ Ï + Ïˆ, which v0.5 does not ship
--   galFwd / galBwd   both directions for `u = d = (K âˆ_)`, and they
--                     are the SAME statement once `+` is commuted
--   MinPlusCut        `module Galois` instantiated â” antitonicity,
--                     unit, counit, triangles, idempotence of
--                     `c a = K âˆ (K âˆ a)` and the fixed-point
--                     characterisation, with NOTHING re-proved
--
-- THE ORDER HAD TO BE REVERSED, and that is the content, not
-- bookkeeping.  In min-plus lower cost is better, so the quantale order
-- is â•'s `â‰` backwards.  Under â•'s own order the same maps are not a
-- Galois connection at all: `truncationBreaksTheNaiveOrder` exhibits
-- `K = 0, Ï = 0, Ïˆ = 5`, where one side holds and the other does not,
-- because `âˆ` truncates.  The obligation is dischargeable or false
-- depending on which way the order points.
------------------------------------------------------------------------

------------------------------------------------------------------------
-- â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”
-- THE TITLE IS EARNED.
--
-- All six of `module Galois`'s hypotheses are consumed: `â‰¼-refl` in
-- `counit`; `â‰¼-trans` in `u-antitone` and `saturatedGivesFixed`;
-- `âŠ-refl` in `unit` and `fixedGivesSaturated`; `âŠ-trans` in
-- `d-antitone`; both adjunction directions throughout.  Nothing is
-- assumed and unused.
--
-- The package is not the only sufficient one.  In
-- `TheAdjunctionAndTheUnitCounitPackageAreInterderivableAndTheyNeed
-- DifferentAxioms`: `FromUnitCounit` derives `galFwd`/`galBwd` from
-- `u-antitone`, `d-antitone`, `unit`, `counit` â” one line each â” and then
-- transports this entire module by `open Galois â¦ public`, nothing re-proved;
-- `RoundTrip` shows out-and-back is the identity when the order relations are
-- proposition-valued.
--
-- **AND THE TWO PACKAGES NEED DIFFERENT AXIOMS.**  unit/counit âŸ
-- adjunction uses ONLY the two transitivities.  Adjunction âŸ
-- unit/counit is exactly where reflexivity enters, above.  So they are
-- interderivable over a preorder and NOT interderivable over a bare
-- transitive relation.
--
-- â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”
-- THE MEET IS MAX.
-- The min-plus order is â„•'s `â‰¤` REVERSED, so a meet in it is a JOIN in â„•:
-- the operation is `max`, not `min`.  The meet with its universal property
-- is in `TheMeetIsMaxAndTheProfileCutIsAGaloisConnection`, and the
-- two-sided profile cut exists over an ARBITRARY residual index list with
-- no `âˆž` and no restriction.
------------------------------------------------------------------------
