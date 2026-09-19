{-# OPTIONS --cubical --safe #-}

-- Vestibulum_TheSameCircuitIsFlatForOneFamilyAndChargedForAnotherAndTheSensationCarriesItsWitness
--
-- ‡µ‡‡‡‡‡ø‡‡‡≤‡Æ‡ ‚î Latin vestibulum, the threshold: the inner ear's chamber.
-- The name is the OWNER'S, given in transmission U0021 (2026-08-23,
-- collab/upstream/raw/U0021.txt) for exactly this organ, so the Latin
-- lead is his utterance carried, not a departure from the naming rule.
--
-- THE SPECIFICATION BEING CHECKED (U0021 ¬ß1).  A sense is not a passive
-- map X ‚í O; it is a family carried through action.  The receptor takes
--     a circuit l, a carried family F, an inhabitant u over the base,
-- and returns the transported inhabitant together with a SENSATION that
-- CARRIES ITS WITNESS ‚î never "this circuit has curvature" without
-- qualification, because the same loop can be flat for one family and
-- charged for another.  That qualification is made a checked theorem
-- here: over the ONE loop of S¬, the constant ‚-bundle returns pos zero
-- identically (‡‡‡‡ø‡∞, with its path) and the helix moves it (‡‡≤‡ø‡, with
-- its refutation).  One circuit, two families, two inhabited sensations.
--
-- WHAT IS INHERITED, not restated: the charged pole's computation and
-- refutation are Pradakshina's ‡‡∞‡‡ø‡ and ‡-‡‡‡®‡∞‡æ‡ó‡Æ‡ (landed on this
-- head); the flat pole is its ‡ß‡‡∞‡‡µ-‡µ‡≤‡Ø‡.  This module contributes the
-- ORGAN ‚î the general Hol, the witness-carrying sensation type, and the
-- both-poles instance ‚î none of which Pradakshina states.
--

module Vestibulum_TheSameCircuitIsFlatForOneFamilyAndChargedForAnotherAndTheSensationCarriesItsWitness where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Int using (‚Ñ§ ; pos ; suc‚Ñ§)
open import Cubical.Data.Nat using (zero)
open import Cubical.Relation.Nullary using (¬¨_)
open import Cubical.HITs.S1 using (S¬π ; base ; loop ; helix)

open import Pradakshina_TheCircuitReturnsToTheBasePointWithTheFibreShiftedSoTheHolonomyIsInhabited
  using (‡§™‡•ç‡§∞‡§¶‡§ï‡•ç‡§∑‡§ø‡§£‡§æ ; ‡§∏‡§∞‡§£‡§ø‡§É ; ‡§Ö-‡§™‡•Å‡§®‡§∞‡§æ‡§ó‡§Æ‡§É ; ‡§ß‡•ç‡§∞‡•Å‡§µ-‡§µ‡§≤‡§Ø‡§É)

private
  variable
    ‚ÑìA ‚ÑìF : Level

-- ‚î‚î the receptor: transport of the carried family around the circuit ‚î‚î‚î‚î‚î

Hol : {A : Type ‚ÑìA} (F : A ‚Üí Type ‚ÑìF) {a : A} ‚Üí a ‚â° a ‚Üí F a ‚Üí F a
Hol F l = subst F l

-- ‚î‚î the sensation: a verdict that cannot exist without its witness ‚î‚î‚î‚î‚î‚î‚î

data Sensation {A : Type ‚ÑìA} (F : A ‚Üí Type ‚ÑìF) {a : A}
               (l : a ‚â° a) (u : F a) : Type (‚Ñì-max ‚ÑìA ‚ÑìF) where
  ‡§∏‡•ç‡§•‡§ø‡§∞ : Hol F l u ‚â° u     ‚Üí Sensation F l u   -- returned identically
  ‡§ö‡§≤‡§ø‡§§ : ¬¨ (Hol F l u ‚â° u) ‚Üí Sensation F l u   -- returned changed

-- ‚î‚î the both-poles instance: ONE circuit, two families ‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î
-- The same loop of S¬, the same carried point pos zero.

-- flat for the constant family, with the path as witness
‡§∏‡§Æ‡§µ‡§≤‡§Ø‡§É : Sensation (Œª _ ‚Üí ‚Ñ§) loop (pos zero)
‡§∏‡§Æ‡§µ‡§≤‡§Ø‡§É = ‡§∏‡•ç‡§•‡§ø‡§∞ (‡§ß‡•ç‡§∞‡•Å‡§µ-‡§µ‡§≤‡§Ø‡§É (pos zero))

-- charged for the helix, with the refutation as witness
‡§∏‡§ö‡§ï‡•ç‡§∞‡§µ‡§≤‡§Ø‡§É : Sensation helix loop (pos zero)
‡§∏‡§ö‡§ï‡•ç‡§∞‡§µ‡§≤‡§Ø‡§É = ‡§ö‡§≤‡§ø‡§§ ‡§Ö-‡§™‡•Å‡§®‡§∞‡§æ‡§ó‡§Æ‡§É

-- ‚î‚î the qualification as a statement about the ORGAN, not the loop ‚î‚î‚î‚î‚î‚î‚î
-- A reader holding both sensations above holds, for one and the same l,
-- an identity witness under one family and a movement witness under
-- another: curvature is a property of (F, l, u), and the organ's report
-- type makes the unqualified claim unwritable ‚î there is no constructor
-- of Sensation that mentions l alone.
