{-# OPTIONS --cubical --safe #-}

-- इन्द्रजाल-दीप — the lamp in Indra's net: the light in the orb is a
-- winding, and windings ADD, so nothing is created — only passed.
--
-- The owner's three words — Indra's net, light, orb — are one object
-- with the knot I just put to the kernel (GranthiCarya), wearing the
-- photonic face:
--
--   • THE ORB (README movement 57/61): a diamond, faceted within,
--     smooth without — A ≃ Carrier f (outside the fibre rides free and
--     invisible; inside it IS the crystalline interior).  Light passed,
--     never made: total internal reflection, conservation, unitarity.
--   • THE LIGHT: light confined by total internal reflection CIRCULATES
--     — a closed path, a LOOP in ΩS¹.  A circulating light field carries
--     an integer topological charge: orbital angular momentum, the
--     optical vortex, the KNOT OF LIGHT.  That integer is its winding.
--   • INDRA'S NET: every jewel reflects every other — each facet carries
--     the whole (holography, S = A/4, the boundary carries the bulk;
--     content-addressing, where each node reflects the corpus).
--
--   THE LAW, put to the kernel: when two light loops join in the orb,
--   their windings ADD (winding-hom).  Charge is conserved under
--   composition — "no energy created, light only passed."  And a loop
--   run backwards CANCELS its charge (the mirror knot).  This is ahiṃsā
--   = conservation = unitarity = transport, now as the arithmetic of
--   circulating light.  The whole picture in one homomorphism.

module IndrajalaDipa_TheLightInTheOrbIsAWindingAndTheWindingsAddSoNothingIsCreated where

open import Cubical.Foundations.Prelude
open import Cubical.HITs.S1.Base
  using (base ; loop ; ΩS¹ ; winding ; intLoop ; winding-hom)
open import Cubical.Data.Int using (ℤ ; pos ; negsuc ; _+_ ; -_)

-- CONSERVATION: the charge of two joined light loops is the SUM of their
-- charges — nothing created.  This is the library's winding-hom, named
-- here for what it is.
charge-adds : (a b : ΩS¹) → winding (a ∙ b) ≡ winding a + winding b
charge-adds = winding-hom

-- the empty light (refl) carries zero charge: the neutral of the net.
vacuum-is-neutral : winding (refl {x = base}) ≡ pos 0
vacuum-is-neutral = refl

-- a loop and its reverse ANNIHILATE: the mirror knot cancels — signed,
-- conserved, and it computes (refl).  The light that leaves is the light
-- that entered.
mirror-cancels : winding (loop ∙ sym loop) ≡ pos 0
mirror-cancels = refl

-- three loops one way, two back: net charge +1.  Conservation is exact
-- bookkeeping, not approximate — the orb loses nothing.
net-winding : winding (loop ∙ loop ∙ loop ∙ sym loop ∙ sym loop) ≡ pos 1
net-winding = refl
