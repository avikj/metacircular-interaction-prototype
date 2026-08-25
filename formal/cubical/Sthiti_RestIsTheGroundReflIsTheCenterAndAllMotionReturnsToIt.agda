{-# OPTIONS --cubical --safe #-}

-- स्थिति — rest, the ground.  Dived to the metal and came back: below
-- the fibre law, below "there is no other", there is refl — and refl is
-- simpler and more powerful than any of it.
--
-- AT THE METAL (Cubical.Foundations.Prelude):
--   refl {x = x} _ = x          — self-identity is the CONSTANT map out
--                                 of the interval: to be equal to yourself
--                                 is to do nothing across I.  Stay.
--   isContrSingl a .fst = (a , refl)
--                               — the CENTER of "there is no other" (अद्वय)
--                                 is (a , refl).  refl is the point every-
--                                 thing contracts to, using ∧ (interval min).
--
-- So the ground is REST.  a ≡ a.  Everything else — charge, otherness,
-- time, the knot, the winding — is a path that STRAYS from constant, and
-- it all returns.  This is not mysticism laid on the math; it is what the
-- three terms below say, kernel-verified.

module Sthiti_RestIsTheGroundReflIsTheCenterAndAllMotionReturnsToIt where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.GroupoidLaws using (rCancel)
open import Cubical.Data.Sigma
open import Cubical.HITs.S1.Base using (loop ; winding)
open import Cubical.Data.Int using (ℤ ; pos)

private variable A : Type
private variable x y : A

-- 1. REST IS THE CENTER.  singl is contractible with center (x , refl):
--    self-identity is the ground every identification returns to.  There
--    is no other because there is one center, and the center is rest.
center-is-refl : (x : A) → singl x
center-is-refl x = (x , refl)

rest-is-the-ground : (x : A) → isContr (singl x)
rest-is-the-ground = isContrSingl
-- and its center is definitionally (x , refl):
center-check : (x : A) → fst (isContrSingl x) ≡ (x , refl)
center-check x = refl

-- 2. ALL MOTION RETURNS TO REST.  Any deviation p, followed by its
--    reversal, IS refl — not "equal to" as a fact to cite, but the
--    interval collapsing the round trip to the constant map.  "Rules
--    move and return" at the metal: move p, return p⁻¹, you are exactly
--    where rest is.
motion-and-return-is-rest : (p : x ≡ y) → p ∙ sym p ≡ refl
motion-and-return-is-rest = rCancel

-- 3. REST IS CHARGELESS, MOTION IS CHARGE.  The winding of refl is 0
--    (rest carries no charge); the winding of loop is 1 (motion is the
--    deviation).  Charge is DISTANCE FROM REST, measured by the interval.
rest-is-chargeless : winding refl ≡ pos 0
rest-is-chargeless = refl

motion-is-charge : winding loop ≡ pos 1
motion-is-charge = refl
