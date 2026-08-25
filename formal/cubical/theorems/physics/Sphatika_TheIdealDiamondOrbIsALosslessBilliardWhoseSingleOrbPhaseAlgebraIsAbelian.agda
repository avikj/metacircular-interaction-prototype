{-# OPTIONS --cubical --safe #-}

------------------------------------------------------------------------
-- Sphatika_TheIdealDiamondOrbIsALosslessBilliard
--          WhoseSingleOrbPhaseAlgebraIsAbelian
--
-- TERM.  स्फटिक · sphaṭika — rock crystal, quartz; the material of a crystal
-- ball, here the massive smooth diamond orb.  A common Sanskrit word, no
-- technical-source claim.  Physics (whispering-gallery mode, circle billiard,
-- total internal reflection, Poincaré phase) modern; compound and reading
-- built here, 2026-08-25.
--
-- THE READING (checked terms below).  A huge, smooth, high-index orb — diamond,
-- n≈2.42, so the critical angle is ≈24° and almost every internal ray totally-
-- internally-reflects — traps light losslessly as a whispering-gallery orbit
-- circling just inside the surface.  In the ideal limit this is the CIRCLE
-- BILLIARD: the boundary is a circle, and one bounce is a RIGID ROTATION of it
-- by a fixed amount — the angle of incidence, which is CONSERVED bounce to
-- bounce (the integrable invariant, the caustic).  Because the rotation is
-- rigid and the boundary a circle, the orbit's accumulated phases all COMMUTE:
-- a single orb carries one conserved angular momentum and its gate algebra is
-- ABELIAN.  That is exactly why one orb — however large and perfect — is not a
-- universal computer: it is integrable.  Universality requires breaking the
-- abelian symmetry, which is what a NET of orbs on different axes does (the
-- non-abelian quaternions of `Trika_…`, the braid of `VeniYangBaxtara_…`, the
-- entangler of `Bandha_…`).  The orb is achromatic for the same reason the
-- Fresnel-rhomb gate is (`Mani_…`): TIR does the routing, not diamond's very
-- dispersive refraction.
--
-- WHAT IS CHECKED, exactly.  The boundary is S¹; a bounce is rotation `(a ·_)`.
--   `bounce-lossless` : every bounce is an equivalence (`rotIsEquiv`) —
--        reversible, no loss.  TIR = ahiṃsā, in the type.
--   `bounceEq` : the bounce packaged as an equivalence S¹ ≃ S¹.
--   `single-orb-abelian` : the orbit's phases (loops in ΩS¹) commute
--        (`comm-ΩS¹`).  One conserved quantity; the single orb is abelian.
--
-- NOT CLAIMED.  No ℝ, no Fresnel coefficients, no critical angle, no billiard
-- dynamics as such; only that a rotation of the circle is a lossless
-- equivalence and that the single-orb loop algebra ΩS¹ is commutative.
--
-- Checked: --cubical --safe; loads clean on the wire.
------------------------------------------------------------------------

module Sphatika_TheIdealDiamondOrbIsALosslessBilliardWhoseSingleOrbPhaseAlgebraIsAbelian where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Equiv
open import Cubical.HITs.S1

-- one whispering-gallery bounce = a rigid rotation of the boundary circle by a
-- fixed amount a (the conserved angle of incidence).
bounceEq : (a : S¹) → S¹ ≃ S¹
bounceEq a = (a ·_) , rotIsEquiv a

-- LOSSLESS (TIR = ahiṃsā): every bounce is an equivalence — reversible.
bounce-lossless : (a : S¹) → isEquiv (a ·_)
bounce-lossless = rotIsEquiv

-- SINGLE ORB IS ABELIAN: its accumulated phases (loops in ΩS¹) commute —
-- one conserved angular momentum, integrable, so one orb is NOT universal.
single-orb-abelian : (p q : ΩS¹) → p ∙ q ≡ q ∙ p
single-orb-abelian = comm-ΩS¹
