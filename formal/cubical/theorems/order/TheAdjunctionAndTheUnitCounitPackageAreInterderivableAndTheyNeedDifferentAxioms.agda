{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- TheAdjunctionAndTheUnitCounitPackageAreInterderivableAndTheyNeedDifferentAxioms
--
-- ON THE NAME.  Checked before naming: `.claude/hooks/priority-ledger.txt`
-- (CURRENT header) and `.claude/hooks/european-frame.txt`; `formal/` and
-- invented.**  The abstract order-theoretic form used here â” two
-- preorders, two antitone maps, one adjunction â” is Ore's ("Galois
-- connexions", *Trans. AMS* 55, 1944), after Birkhoff (*Lattice
-- Theory*, 1940, Â§V); the module being audited already cites both.  I
-- have not established an Indian source for it and will not attach a
-- label I cannot defend.
--
-- â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”
-- THE AUDIT, AND WHAT IT FOUND AND DID NOT FIND.
--
-- Target: `TheSaturationClosureNeedsOnlyAGaloisConnection`, whose title
-- is a MINIMALITY claim and whose Â§1 is headed "The only assumptions:
-- two preorders and one adjunction".
--
-- **THE TITLE IS EARNED IN THE DIRECTION IT ASSERTS.**  All six of
-- `module Galois`'s hypotheses are consumed: `â‰¼-refl` in `counit`,
-- `â‰¼-trans` in `u-antitone` and `saturatedGivesFixed`, `âŠ-refl` in
-- `unit` and `fixedGivesSaturated`, `âŠ-trans` in `d-antitone`, and both
-- adjunction directions throughout.  Nothing is assumed and unused.
-- That is worth recording because the sweep's other findings have all
-- been overclaims; this one is not.
--
-- **WHAT IT DOES NOT SHOW IS THAT ITS PACKAGE IS THE ONLY SUFFICIENT ONE**,
-- and "needs only X" invites exactly that reading. A reader who already has
-- antitone maps with a unit and a counit â” the other standard presentation,
-- and the one a construction usually hands you first â” has no statement to
-- appeal to.
--
-- â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”
-- WHAT IS PROVED
--
--   FromUnitCounit    from `u-antitone`, `d-antitone`, `unit`, `counit`
--                     over two preorders: `galFwd` and `galBwd`, one
--                     line each, and then the ENTIRE closure theory by
--                     `open Galois â¦ public` â” antitonicity, unit,
--                     counit, triangles, `c`, idempotence, the
--                     fixed-point characterisation, nothing re-proved
--   RoundTrip         going out and back is the identity when the order
--                     relations are PROPOSITION-VALUED, by `funExt`
--
-- **AND THE TWO PACKAGES DO NOT NEED THE SAME AXIOMS.  THAT IS THE
-- FINDING.**  `galFwd`/`galBwd` are derived from unit/counit using ONLY
-- the two TRANSITIVITIES; the two reflexivities are never touched.
-- Going the other way, reflexivity is exactly what is needed â”
-- `unit a = galBwd a (u a) (âŠ-refl (u a))` and `counit b = galFwd (d b)
-- b (â‰¼-refl (d b))`.  So the adjunction presentation needs refl to
-- produce unit/counit, and the unit/counit presentation needs neither
-- refl to produce the adjunction.  **The packages are interderivable
-- over a preorder and are NOT interderivable over a bare transitive
-- relation: one direction survives there and the other does not.**
-- `FromUnitCounit` still takes both reflexivities, because `Galois`
-- does and the point is to reuse it verbatim; the claim above is about
-- what its own two definitions consume, which is visible in their
-- bodies.
--
-- CHECKED on the CONTAINER (Agda 2.6.3, cubical v0.5 â” NOT the declared
-- pin, Agda 2.8.0 + cubical v0.9).  --safe, no postulates, no holes.
------------------------------------------------------------------------

module TheAdjunctionAndTheUnitCounitPackageAreInterderivableAndTheyNeedDifferentAxioms where

open import Cubical.Foundations.Prelude

open import TheSaturationClosureNeedsOnlyAGaloisConnection
  using (module Galois)

------------------------------------------------------------------------
-- 1.  The other presentation, and the whole closure theory from it
------------------------------------------------------------------------

module FromUnitCounit
  {â„“P â„“Q â„“â‰¼ â„“âŠ‘ : Level}
  {P : Type â„“P} {Q : Type â„“Q}
  (_â‰¼_ : P â†’ P â†’ Type â„“â‰¼)
  (_âŠ‘_ : Q â†’ Q â†’ Type â„“âŠ‘)
  (â‰¼-refl  : (a : P) â†’ a â‰¼ a)
  (â‰¼-trans : (a b c : P) â†’ a â‰¼ b â†’ b â‰¼ c â†’ a â‰¼ c)
  (âŠ‘-refl  : (b : Q) â†’ b âŠ‘ b)
  (âŠ‘-trans : (a b c : Q) â†’ a âŠ‘ b â†’ b âŠ‘ c â†’ a âŠ‘ c)
  (u : P â†’ Q) (d : Q â†’ P)
  (u-antitone : (a a' : P) â†’ a â‰¼ a' â†’ u a' âŠ‘ u a)
  (d-antitone : (b b' : Q) â†’ b âŠ‘ b' â†’ d b' â‰¼ d b)
  (unit   : (a : P) â†’ a â‰¼ d (u a))
  (counit : (b : Q) â†’ b âŠ‘ u (d b))
  where

  -- Only the TRANSITIVITIES are used here.  Neither reflexivity appears.
  galFwd : (a : P) (b : Q) â†’ a â‰¼ d b â†’ b âŠ‘ u a
  galFwd a b le = âŠ‘-trans b (u (d b)) (u a) (counit b) (u-antitone a (d b) le)

  galBwd : (a : P) (b : Q) â†’ b âŠ‘ u a â†’ a â‰¼ d b
  galBwd a b le = â‰¼-trans a (d (u a)) (d b) (unit a) (d-antitone b (u a) le)

  open Galois _â‰¼_ _âŠ‘_ â‰¼-refl â‰¼-trans âŠ‘-refl âŠ‘-trans u d galFwd galBwd
    public

------------------------------------------------------------------------
-- 2.  And the round trip is the identity on proposition-valued orders
------------------------------------------------------------------------

module RoundTrip
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
  (propâ‰¼ : (a : P) (b : Q) â†’ isProp (a â‰¼ d b))
  (propâŠ‘ : (a : P) (b : Q) â†’ isProp (b âŠ‘ u a))
  where

  open Galois _â‰¼_ _âŠ‘_ â‰¼-refl â‰¼-trans âŠ‘-refl âŠ‘-trans u d galFwd galBwd
    using (unit ; counit ; u-antitone ; d-antitone)

  open FromUnitCounit _â‰¼_ _âŠ‘_ â‰¼-refl â‰¼-trans âŠ‘-refl âŠ‘-trans u d
         u-antitone d-antitone unit counit
    using () renaming (galFwd to galFwdâ€² ; galBwd to galBwdâ€²)

  fwdRoundTrip : (a : P) (b : Q) â†’ galFwdâ€² a b â‰¡ galFwd a b
  fwdRoundTrip a b = funExt (Î» le â†’ propâŠ‘ a b (galFwdâ€² a b le) (galFwd a b le))

  bwdRoundTrip : (a : P) (b : Q) â†’ galBwdâ€² a b â‰¡ galBwd a b
  bwdRoundTrip a b = funExt (Î» le â†’ propâ‰¼ a b (galBwdâ€² a b le) (galBwd a b le))
