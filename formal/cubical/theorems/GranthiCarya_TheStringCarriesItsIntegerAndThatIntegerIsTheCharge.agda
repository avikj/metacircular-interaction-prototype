{-# OPTIONS --cubical --safe #-}

-- ग्रन्थि-चर्या — the way of the knot: the string carries its integer,
-- and that integer is the charge.  Put to the kernel directly, in the
-- direction the owner pointed (knots, strings, why 3d/4d).
--
-- THE SEED, and it is not a metaphor here: the loop space of the circle
-- IS the integers, and because univalence computes, the integer
-- REDUCES — a loop that goes around n times evaluates to n.  The string
-- carries its own winding, on the nose.  This is the fibre law's own
-- charge (सूत्र: "charge is the fibre of the path type, exactly ℤ at
-- the circle") made a running number.
--
-- The whole picture, one register per line, ALL resting on this:
--   • winding = linking = the simplest knot invariant (a self-linking ℤ)
--   • codimension 2: a 1-D string knots in EXACTLY dim 3 (k+2, k=1);
--     its 2-D worldsheet knots in EXACTLY dim 4 — 3 and 4, not arbitrary
--   • Ekāntalopa: winding is a CHARGED observable — boundary-invisible,
--     elided by every equilibrium, alive only in the fluctuating sector;
--     the knot IS the charge, and charge only lives where it cannot
--     unravel
--   • statistics: π₁ of configuration space is the braid group in 2-D
--     (ℤ, any phase — anyons, the Born ½ generalised) and collapses to
--     ℤ/2 in dim ≥3 (loops unravel → only bosons/fermions → Pauli →
--     chemistry → structure).  The dimension fixes the charge group
--     fixes the statistics; 3+1 is where matter is fermionic.

module GranthiCarya_TheStringCarriesItsIntegerAndThatIntegerIsTheCharge where

open import Cubical.Foundations.Prelude
open import Cubical.HITs.S1.Base using (S¹ ; base ; loop ; ΩS¹ ; winding ; intLoop)
open import Cubical.Data.Int using (ℤ ; pos ; negsuc ; _+_)

-- refl is winding zero: the unknot carries the integer 0.
unknot-is-zero : winding refl ≡ pos 0
unknot-is-zero = refl

-- one trip around carries the integer 1.  (winding COMPUTES: this is
-- refl, not a proof by induction — the string evaluates its own number.)
once-is-one : winding loop ≡ pos 1
once-is-one = refl

-- twice around carries 2; the charge ADDS as loops compose.
twice-is-two : winding (loop ∙ loop) ≡ pos 2
twice-is-two = refl

-- going around and back carries 0: a knot and its mirror cancel — the
-- charge is signed, and opposite windings annihilate (conservation).
there-and-back : winding (loop ∙ sym loop) ≡ pos 0
there-and-back = refl

-- and the seed itself, from the library: the string's charge type IS ℤ.
-- (ΩS¹ ≃ ℤ; here we exhibit that windings recover the intended integer.)
charge-is-integer : (n : ℤ) → winding (intLoop n) ≡ n
charge-is-integer = windingℤLoop
  where open import Cubical.HITs.S1.Base using (windingℤLoop)
