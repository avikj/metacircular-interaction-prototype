{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- à•àà¨àà¦àà° â” the center.  Goldbach and twins are ONE two-wall field once
-- centered: the substitution x = c + y sends a wall pair symmetric about
-- its midpoint c to the mirror pair Âh.  The complex phases disappear;
-- the object is real and symmetric.  (Owner's optical-centering message;
-- the exact arithmetic core as a term.  The Fourier crystal r_{p,a} and
-- its cosine amplitude are the stated reading, fenced below â” trig over
-- â is not checked here; the modular centering that MAKES the crystal
-- real is.)
--
-- THE UNIFICATION.  Both problems are S_{a,z}(y) = âˆ_{pâ‰z} 1[y â‰ Âa mod p]:
--   â Goldbach   x â‰ 0, N (mod p),  N = 2h,  x = h + y  âŸ  y â‰ Âh  (a=h=N/2)
--   â Twins      n â‰ 0, âˆ’2 (mod p),          y = n + 1  âŸ  y â‰ Â1  (a=1)
-- The single fact under both: a wall pair {u,v} with midpoint c
-- (u + v = 2c) becomes, after centering by âˆ’c, a MIRROR pair â” the two
-- centered walls are negatives of each other.  That is why centering
-- "reveals the organism is real and symmetric": symmetry about the
-- midpoint is exact, and it is what kills the phase.
--
-- Â§1  centered-symmetric â” the general centering (any â walls, any center).
-- Â§2  the two instances, Goldbach (N = 2h â’ Âh) and twins (â’ Â1), each a
--     specialization of Â§1, exhibited.
-- Â§3  FENCE â” the per-prime real crystal r_{p,a}(t) = âˆ’2cos(2Ïat/p)/(pâˆ’2)
--     and the survivor-count identity are the owner's spectral reading;
--     they need â and the DFT and are NOT checked here.  What is checked
--     is the centering that renders the two-wall indicator symmetric, on
--     which the reality of the crystal rests.
--
-- CHECKED under the pin (Agda 2.8.0 + cubical v0.9) for the â solver.
------------------------------------------------------------------------

module Kendra_CenteringUnifiesGoldbachAndTwinsIntoOneSymmetricTwoWallField where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Int using (â„¤; pos; _+_; _-_; -_; _Â·_)
open import Cubical.Algebra.CommRing.Instances.Int using (â„¤CommRing)
open import Cubical.Tactics.CommRingSolver using (solve!)

------------------------------------------------------------------------
-- Â§1 Â THE CENTERING.  A wall pair {u, v} symmetric about its midpoint c
-- (u + v = c + c) becomes a mirror pair when centered: the centered
-- walls u âˆ’ c and v âˆ’ c are negatives.  This is the whole optical fact â”
-- symmetry about the center is exact, hence the crystal is real.

centered-symmetric : (u v c : â„¤) â†’ u + v â‰¡ c + c â†’ (u - c) â‰¡ -(v - c)
centered-symmetric u v c hyp = step1 âˆ™ step2 âˆ™ step3
  where
  step1 : (u - c) â‰¡ ((u + v) - (c + c)) - (v - c)
  step1 = solve! â„¤CommRing
  step2 : ((u + v) - (c + c)) - (v - c) â‰¡ ((c + c) - (c + c)) - (v - c)
  step2 = cong (Î» w â†’ (w - (c + c)) - (v - c)) hyp
  step3 : ((c + c) - (c + c)) - (v - c) â‰¡ -(v - c)
  step3 = solve! â„¤CommRing

------------------------------------------------------------------------
-- Â§2 Â THE TWO INSTANCES, as specializations of Â§1.

-- GOLDBACH.  Walls 0 and N with N = 2h even; midpoint h; centered by âˆ’h
-- the walls become âˆ“h â” the symmetric pair Âh = Â(N/2).  (u,v,c) =
-- (0, 2h, h): 0 + 2h â‰¡ h + h.
goldbach-centered : (h : â„¤) â†’ (pos 0 - h) â‰¡ -((h + h) - h)
goldbach-centered h = centered-symmetric (pos 0) (h + h) h (solve! â„¤CommRing)

-- and the centered walls are literally âˆ“h:
goldbach-left  : (h : â„¤) â†’ (pos 0 - h) â‰¡ - h
goldbach-left  h = solve! â„¤CommRing
goldbach-right : (h : â„¤) â†’ ((h + h) - h) â‰¡ h
goldbach-right h = solve! â„¤CommRing

-- TWINS.  Walls 0 and âˆ’2, midpoint âˆ’1, centered by +1 (y = n + 1) the
-- walls become Â1.  (u,v,c) = (0, âˆ’2, âˆ’1): 0 + (âˆ’2) â‰¡ (âˆ’1) + (âˆ’1).
twin-centered : (pos 0 - (- pos 1)) â‰¡ -((- pos 2) - (- pos 1))
twin-centered = centered-symmetric (pos 0) (- pos 2) (- pos 1) (solve! â„¤CommRing)

-- and the centered walls are literally Â1:
twin-left  : (pos 0 - (- pos 1)) â‰¡ pos 1
twin-left  = refl
twin-right : ((- pos 2) - (- pos 1)) â‰¡ - pos 1
twin-right = refl

------------------------------------------------------------------------
-- Â§3 Â FENCE (the owner's spectral reading, stated, NOT checked here).
--
-- After centering, the per-prime normalized Fourier crystal is REAL and
-- signed: for p âˆ 2a,  r_{p,a}(0) = 1,  r_{p,a}(t) = âˆ’2cos(2Ïat/p)/(pâˆ’2)
-- (t â‰  0); for p âˆ a the walls coincide and r_{p,a}(t) = âˆ’1/(pâˆ’1).  The
-- survivor count over a centered interval I is
--   Î_{yâˆˆI} S_{a,z}(y) = Ï_{a,z} Î_t R_a(t) D_I(Î(t)),  R_a = âˆ r_{p,a},
--   Î(t) = Î t_p/p,  D_I(Î) = Î_{yâˆˆI} cos(2ÏÎ y),
-- the zero ray Ï_{a,z}|I| being the singular-series main term.  These
-- require â, cosine, and the finite DFT; they are the reading this
-- module's centering makes possible (the phase vanishes BECAUSE Â§1's
-- symmetry is exact) and are owed as separate terms in an â-carrying
-- lane.  Absolute values would discard the cosine signs â” that discard
-- is the parity loss; Â§1 is what keeps the angular information real.
------------------------------------------------------------------------
