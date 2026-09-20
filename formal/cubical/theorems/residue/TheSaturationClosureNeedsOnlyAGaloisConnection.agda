{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- TheSaturationClosureNeedsOnlyAGaloisConnection
--
-- `SaturationAtACutIsIdempotent` proved that Î” 28 Â§31â“32's "re-saturate"
-- is idempotent, and then said, as the load-bearing limitation:
--
--   "Â§31â“32's â and â“ are min-plus RESIDUATIONS over a semiring-valued
--    kernel â¦ That the former is an instance of the latter is NOT
--    proved here and is not obvious â¦ So what is established is that
--    the SATURATION discipline is sound wherever the adjunction holds â”
--    not that Î” 28's particular â/â“ satisfy it."
--
-- That sentence names a gap without saying what would close it.  This
-- module says exactly what would: the whole closure argument uses
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
--
-- CHECKED on the CONTAINER (Agda 2.6.3, cubical v0.5 â” NOT the declared
-- pin, Agda 2.8.0 + cubical v0.9).  --safe, no postulates, no holes.
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
-- being an instance, and it is what the min-plus residuations still owe.
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
-- APPENDED 2026-08-19, by the same identity, at the end, altering no
-- line above.  The NOT-CLAIMED section says:
--
--   "the min-plus instance itself: neither `galFwd` nor `galBwd` is
--    proved for a semiring-valued kernel here, and no quantale is
--    constructed anywhere in this repository."
--
-- Paid AT ONE CUT, with real min-plus data, in
-- `MinPlusResiduationIsAGaloisConnectionAtOneCut`
-- (--safe, no postulates, no holes; container green under Agda 2.6.3 +
-- cubical v0.5, NOT the declared pin â” check.sh returns 1 and says so).
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
--
------------------------------------------------------------------------

------------------------------------------------------------------------
-- APPENDED 2026-08-19, by the same identity, at the end, altering no
-- line above â” including the 2026-08-19 append above it, half of which
-- is what is being corrected.  TWO items, and they are of different
-- kinds.
--
-- â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”
-- (1)  THE TITLE IS EARNED, AND SAYING SO IS PART OF THE AUDIT.
--
-- All six of `module Galois`'s hypotheses are consumed: `â‰¼-refl` in
-- `counit`; `â‰¼-trans` in `u-antitone` and `saturatedGivesFixed`;
-- `âŠ-refl` in `unit` and `fixedGivesSaturated`; `âŠ-trans` in
-- `d-antitone`; both adjunction directions throughout.  Nothing is
-- assumed and unused.  This was checked by a sweep whose four previous
-- findings were all overclaims, and a sweep that only ever finds faults
-- is not auditing â” so the negative result is recorded here rather than
-- left silent.
--
-- **WHAT THIS MODULE DOES NOT SHOW is that its package is the ONLY sufficient
-- one**, which is what "needs only X" invites a reader to conclude. At commit
-- 10c5bca1, `TheAdjunctionAndTheUnitCounitPackageAreInterderivableAndTheyNeed
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
-- (2)  A CORRECTION THAT WAS RECORDED AT ONE SITE AND NOT AT THIS ONE.
--
-- The append above ends: *"its `â` takes a meet over all burdens â” that
-- needs `min` over a finite index and its universal property, not
-- built."*  **Both halves of that are now wrong.**
--
--   THE OPERATION.  The min-plus order is â•'s `â‰` REVERSED â” the same
--   append says so three lines earlier â” so a meet in it is a JOIN in
--   â•.  The operation is `max`, not `min`.  That correction was made in
--   `TheMeetIsMaxAndTheProfileCutIsAGaloisConnection`, whose header
--   states it as its own finding, and it was recorded THERE AND NOWHERE
--   ELSE.  The wrong word survived here, in a file that had already
--   written down the reversal that refutes it.
--
--   "NOT BUILT".  Built.  The meet with its universal property is in
--   that module; the two-sided profile cut is at 89c9b7f0 and then,
--   over an ARBITRARY residual index list with no `âˆž` and no
--   restriction, at 8f3acebb.  The intermediate claim that the empty
--   meet forced `â• âŠ âˆž` was mine and was itself wrong; retracted at
--   819e0a57.
--
-- **THIS IS A DIFFERENT FAILURE MODE FROM THE OTHERS THIS SWEEP HAS
-- FOUND, AND WORTH NAMING.**  Nothing here was ever an overclaim: the
-- sentence was true when written and was corrected elsewhere later.
-- What failed is PROPAGATION â” a correction recorded at one of the two
-- sites carrying the same wrong word.  Grepping for the word, not for
-- the module, is what catches it.
--
-- WHAT IS NOT RETRACTED.  Everything else above.  Â§1â“Â§5 are unaltered
-- and true; the reduction of Î” 28 Â§31â“32's obligation to two lines
-- stands; the reversal paragraph in the earlier append is correct and
-- is what convicts the sentence three lines below it.  CONVOLUTION is
-- still absent everywhere, so Î” 28's COMPOSITION step remains untouched
-- by any of this.
------------------------------------------------------------------------

------------------------------------------------------------------------
-- APPENDED 2026-08-19, by the same identity, at the end, altering no
-- line above.  Short, because this is the third append here and the
-- record must not outgrow the mathematics.
--
-- **RETRACTED, from the block immediately above: "and it was recorded
-- THERE AND NOWHERE ELSE."**  False.
-- `MinPlusResiduationIsAGaloisConnectionAtOneCut` also carries the
-- correction, in its own words, in its own earlier append.  The
-- correction had reached two of its three sites; one was missed â” this
-- one.  Recorded at 94054b52, with the reason I got it wrong: I grepped
-- for the wrong phrase and read the hit count instead of the files, and
-- a grep for a wrong word finds the corrections too, because a
-- correction must quote what it corrects.
--
-- The substantive half stands unchanged: the wrong word DID survive
-- here, unpropagated, and is corrected above.
------------------------------------------------------------------------
