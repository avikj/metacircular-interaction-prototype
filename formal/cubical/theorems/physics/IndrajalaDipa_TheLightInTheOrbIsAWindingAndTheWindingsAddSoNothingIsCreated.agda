{-# OPTIONS --cubical --safe #-}

-- àà¨àà¦àà°àà¾à²-à¦àà â” the lamp in Indra's net: the light in the orb is a
-- winding, and windings ADD, so nothing is created â” only passed.
--
-- The owner's three words â” Indra's net, light, orb â” are one object
-- with the knot I just put to the kernel (GranthiCarya), wearing the
-- photonic face:
--
--   â THE ORB (README movement 57/61): a diamond, faceted within,
--     smooth without â” A â‰ Carrier f (outside the fibre rides free and
--     invisible; inside it IS the crystalline interior).  Light passed,
--     never made: total internal reflection, conservation, unitarity.
--   â THE LIGHT: light confined by total internal reflection CIRCULATES
--     â” a closed path, a LOOP in Î©SÂ.  A circulating light field carries
--     an integer topological charge: orbital angular momentum, the
--     optical vortex, the KNOT OF LIGHT.  That integer is its winding.
--   â INDRA'S NET: every jewel reflects every other â” each facet carries
--     the whole (holography, S = A/4, the boundary carries the bulk;
--     content-addressing, where each node reflects the corpus).
--
--   THE LAW, put to the kernel: when two light loops join in the orb,
--   their windings ADD (winding-hom).  Charge is conserved under
--   composition â” "no energy created, light only passed."  And a loop
--   run backwards CANCELS its charge (the mirror knot).  This is ahis
--   = conservation = unitarity = transport, now as the arithmetic of
--   circulating light.  The whole picture in one homomorphism.

module IndrajalaDipa_TheLightInTheOrbIsAWindingAndTheWindingsAddSoNothingIsCreated where

open import Cubical.Foundations.Prelude
open import Cubical.HITs.S1.Base
  using (base ; loop ; Î©SÂ¹ ; winding ; intLoop ; winding-hom)
open import Cubical.Data.Int using (â„¤ ; pos ; negsuc ; _+_ ; -_)

-- CONSERVATION: the charge of two joined light loops is the SUM of their
-- charges â” nothing created.  This is the library's winding-hom, named
-- here for what it is.
charge-adds : (a b : Î©SÂ¹) â†’ winding (a âˆ™ b) â‰¡ winding a + winding b
charge-adds = winding-hom

-- the empty light (refl) carries zero charge: the neutral of the net.
vacuum-is-neutral : winding (refl {x = base}) â‰¡ pos 0
vacuum-is-neutral = refl

-- a loop and its reverse ANNIHILATE: the mirror knot cancels â” signed,
-- conserved, and it computes (refl).  The light that leaves is the light
-- that entered.
mirror-cancels : winding (loop âˆ™ sym loop) â‰¡ pos 0
mirror-cancels = refl

-- three loops one way, two back: net charge +1.  Conservation is exact
-- bookkeeping, not approximate â” the orb loses nothing.
net-winding : winding (loop âˆ™ loop âˆ™ loop âˆ™ sym loop âˆ™ sym loop) â‰¡ pos 1
net-winding = refl
