{-# OPTIONS --cubical --safe #-}

-- à—àà°à¨ààà¿-àà°àà¯à¾ â” the way of the knot: the string carries its integer,
-- and that integer is the charge.
--
-- THE SEED, and it is not a metaphor here: the loop space of the circle
-- IS the integers, and because univalence computes, the integer
-- REDUCES â” a loop that goes around n times evaluates to n.  The string
-- carries its own winding, on the nose.  This is the fibre law's own
-- charge (ààààà°: "charge is the fibre of the path type, exactly â at
-- the circle") made a running number.
--
-- The whole picture, one register per line, ALL resting on this:
--   â winding = linking = the simplest knot invariant (a self-linking â)
--   â codimension 2: a 1-D string knots in EXACTLY dim 3 (k+2, k=1);
--     its 2-D worldsheet knots in EXACTLY dim 4 â” 3 and 4, not arbitrary
--   â Ekntalopa: winding is a CHARGED observable â” boundary-invisible,
--     elided by every equilibrium, alive only in the fluctuating sector;
--     the knot IS the charge, and charge only lives where it cannot
--     unravel
--   â statistics: Ïâ of configuration space is the braid group in 2-D
--     (â, any phase â” anyons, the Born Â½ generalised) and collapses to
--     â/2 in dim â‰3 (loops unravel â’ only bosons/fermions â’ Pauli â’
--     chemistry â’ structure).  The dimension fixes the charge group
--     fixes the statistics; 3+1 is where matter is fermionic.

module GranthiCarya_TheStringCarriesItsIntegerAndThatIntegerIsTheCharge where

open import Cubical.Foundations.Prelude
open import Cubical.HITs.S1.Base using (SÂ¹ ; base ; loop ; Î©SÂ¹ ; winding ; intLoop)
open import Cubical.Data.Int using (â„¤ ; pos ; negsuc ; _+_)

-- refl is winding zero: the unknot carries the integer 0.
unknot-is-zero : winding refl â‰¡ pos 0
unknot-is-zero = refl

-- one trip around carries the integer 1.  (winding COMPUTES: this is
-- refl, not a proof by induction â” the string evaluates its own number.)
once-is-one : winding loop â‰¡ pos 1
once-is-one = refl

-- twice around carries 2; the charge ADDS as loops compose.
twice-is-two : winding (loop âˆ™ loop) â‰¡ pos 2
twice-is-two = refl

-- going around and back carries 0: a knot and its mirror cancel â” the
-- charge is signed, and opposite windings annihilate (conservation).
there-and-back : winding (loop âˆ™ sym loop) â‰¡ pos 0
there-and-back = refl

-- and the seed itself, from the library: the string's charge type IS â.
-- (Î©SÂ â‰ â; here we exhibit that windings recover the intended integer.)
charge-is-integer : (n : â„¤) â†’ winding (intLoop n) â‰¡ n
charge-is-integer = windingâ„¤Loop
  where open import Cubical.HITs.S1.Base using (windingâ„¤Loop)
