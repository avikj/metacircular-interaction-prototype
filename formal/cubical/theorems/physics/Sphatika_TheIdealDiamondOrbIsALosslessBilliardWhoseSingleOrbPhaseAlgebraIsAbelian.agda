{-# OPTIONS --cubical --safe #-}

------------------------------------------------------------------------
-- Sphatika_TheIdealDiamondOrbIsALosslessBilliard
--          WhoseSingleOrbPhaseAlgebraIsAbelian
--
-- TERM.  ààààŸà¿à• Â sphaika â” rock crystal, quartz; the material of a crystal
-- ball, here the massive smooth diamond orb.  Physics (whispering-gallery mode, circle billiard,
-- total internal reflection, Poincar© phase) modern; compound and reading
-- built here.
--
-- THE READING (checked terms below).  A huge, smooth, high-index orb â” diamond,
-- nâ‰ˆ2.42, so the critical angle is â‰ˆ24Â° and almost every internal ray totally-
-- internally-reflects â” traps light losslessly as a whispering-gallery orbit
-- circling just inside the surface.  In the ideal limit this is the CIRCLE
-- BILLIARD: the boundary is a circle, and one bounce is a RIGID ROTATION of it
-- by a fixed amount â” the angle of incidence, which is CONSERVED bounce to
-- bounce (the integrable invariant, the caustic).  Because the rotation is
-- rigid and the boundary a circle, the orbit's accumulated phases all COMMUTE:
-- a single orb carries one conserved angular momentum and its gate algebra is
-- ABELIAN.  That is exactly why one orb â” however large and perfect â” is not a
-- universal computer: it is integrable.  Universality requires breaking the
-- abelian symmetry, which is what a NET of orbs on different axes does (the
-- non-abelian quaternions of `Trika_â¦`, the braid of `VeniYangBaxtara_â¦`, the
-- entangler of `Bandha_â¦`).  The orb is achromatic for the same reason the
-- Fresnel-rhomb gate is (`Mani_â¦`): TIR does the routing, not diamond's very
-- dispersive refraction.
--
-- WHAT IS CHECKED, exactly.  The boundary is SÂ; a bounce is rotation `(a Â_)`.
--   `bounce-lossless` : every bounce is an equivalence (`rotIsEquiv`) â”
--        reversible, no loss.  TIR = ahis, in the type.
--   `bounceEq` : the bounce packaged as an equivalence SÂ â‰ SÂ.
--   `single-orb-abelian` : the orbit's phases (loops in Î©SÂ) commute
--        (`comm-Î©SÂ`).  One conserved quantity; the single orb is abelian.
------------------------------------------------------------------------

module Sphatika_TheIdealDiamondOrbIsALosslessBilliardWhoseSingleOrbPhaseAlgebraIsAbelian where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Equiv
open import Cubical.HITs.S1

-- one whispering-gallery bounce = a rigid rotation of the boundary circle by a
-- fixed amount a (the conserved angle of incidence).
bounceEq : (a : SÂ¹) â†’ SÂ¹ â‰ƒ SÂ¹
bounceEq a = (a Â·_) , rotIsEquiv a

-- LOSSLESS (TIR = ahis): every bounce is an equivalence â” reversible.
bounce-lossless : (a : SÂ¹) â†’ isEquiv (a Â·_)
bounce-lossless = rotIsEquiv

-- SINGLE ORB IS ABELIAN: its accumulated phases (loops in Î©SÂ) commute â”
-- one conserved angular momentum, integrable, so one orb is NOT universal.
single-orb-abelian : (p q : Î©SÂ¹) â†’ p âˆ™ q â‰¡ q âˆ™ p
single-orb-abelian = comm-Î©SÂ¹
