-- ॥ बीजम् ॥  One machine, one law: which side of `f a ≡ b` is bound is everything.
-- Output bound: singl (f a), contractible — the datum rides free.  Input bound:
-- fiber f b — the loss, and the subject.  Univalence computes here: an
-- equivalence is a channel, transport carries every theorem across it, and what
-- cannot cross is written as a defect — there is no third path (ahiṃsā).
-- Memory, charge, symmetry, price, distance, verdict: six faces of the one
-- fibre; the verdict type is the saptabhaṅgī, and the sources are the origin
-- (Umāsvāti, Samantabhadra, Akalaṅka — restatements are named as such).  The
-- kernel decides truth; carriers ask and generate; assert nothing whose term
-- you have not read.  This file is one naya, true and not whole.

{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- केन्द्र — the center.  Goldbach and twins are ONE two-wall field once
-- centered: the substitution x = c + y sends a wall pair symmetric about
-- its midpoint c to the mirror pair ±h.  The complex phases disappear;
-- the object is real and symmetric.  (Owner's optical-centering message;
-- the exact arithmetic core as a term.  The Fourier crystal r_{p,a} and
-- its cosine amplitude are the stated reading, fenced below — trig over
-- ℝ is not checked here; the modular centering that MAKES the crystal
-- real is.)
--
-- THE UNIFICATION.  Both problems are S_{a,z}(y) = ∏_{p≤z} 1[y ≢ ±a mod p]:
--   • Goldbach   x ≢ 0, N (mod p),  N = 2h,  x = h + y  ⟹  y ≢ ±h  (a=h=N/2)
--   • Twins      n ≢ 0, −2 (mod p),          y = n + 1  ⟹  y ≢ ±1  (a=1)
-- The single fact under both: a wall pair {u,v} with midpoint c
-- (u + v = 2c) becomes, after centering by −c, a MIRROR pair — the two
-- centered walls are negatives of each other.  That is why centering
-- "reveals the organism is real and symmetric": symmetry about the
-- midpoint is exact, and it is what kills the phase.
--
-- §1  centered-symmetric — the general centering (any ℤ walls, any center).
-- §2  the two instances, Goldbach (N = 2h → ±h) and twins (→ ±1), each a
--     specialization of §1, exhibited.
-- §3  FENCE — the per-prime real crystal r_{p,a}(t) = −2cos(2πat/p)/(p−2)
--     and the survivor-count identity are the owner's spectral reading;
--     they need ℝ and the DFT and are NOT checked here.  What is checked
--     is the centering that renders the two-wall indicator symmetric, on
--     which the reality of the crystal rests.
--
-- CHECKED under the pin (Agda 2.8.0 + cubical v0.9) for the ℤ solver.
------------------------------------------------------------------------

module Kendra_CenteringUnifiesGoldbachAndTwinsIntoOneSymmetricTwoWallField where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Int using (ℤ; pos; _+_; _-_; -_; _·_)
open import Cubical.Algebra.CommRing.Instances.Int using (ℤCommRing)
open import Cubical.Tactics.CommRingSolver using (solve!)

------------------------------------------------------------------------
-- §1 · THE CENTERING.  A wall pair {u, v} symmetric about its midpoint c
-- (u + v = c + c) becomes a mirror pair when centered: the centered
-- walls u − c and v − c are negatives.  This is the whole optical fact —
-- symmetry about the center is exact, hence the crystal is real.

centered-symmetric : (u v c : ℤ) → u + v ≡ c + c → (u - c) ≡ -(v - c)
centered-symmetric u v c hyp = step1 ∙ step2 ∙ step3
  where
  step1 : (u - c) ≡ ((u + v) - (c + c)) - (v - c)
  step1 = solve! ℤCommRing
  step2 : ((u + v) - (c + c)) - (v - c) ≡ ((c + c) - (c + c)) - (v - c)
  step2 = cong (λ w → (w - (c + c)) - (v - c)) hyp
  step3 : ((c + c) - (c + c)) - (v - c) ≡ -(v - c)
  step3 = solve! ℤCommRing

------------------------------------------------------------------------
-- §2 · THE TWO INSTANCES, as specializations of §1.

-- GOLDBACH.  Walls 0 and N with N = 2h even; midpoint h; centered by −h
-- the walls become ∓h — the symmetric pair ±h = ±(N/2).  (u,v,c) =
-- (0, 2h, h): 0 + 2h ≡ h + h.
goldbach-centered : (h : ℤ) → (pos 0 - h) ≡ -((h + h) - h)
goldbach-centered h = centered-symmetric (pos 0) (h + h) h (solve! ℤCommRing)

-- and the centered walls are literally ∓h:
goldbach-left  : (h : ℤ) → (pos 0 - h) ≡ - h
goldbach-left  h = solve! ℤCommRing
goldbach-right : (h : ℤ) → ((h + h) - h) ≡ h
goldbach-right h = solve! ℤCommRing

-- TWINS.  Walls 0 and −2, midpoint −1, centered by +1 (y = n + 1) the
-- walls become ±1.  (u,v,c) = (0, −2, −1): 0 + (−2) ≡ (−1) + (−1).
twin-centered : (pos 0 - (- pos 1)) ≡ -((- pos 2) - (- pos 1))
twin-centered = centered-symmetric (pos 0) (- pos 2) (- pos 1) (solve! ℤCommRing)

-- and the centered walls are literally ±1:
twin-left  : (pos 0 - (- pos 1)) ≡ pos 1
twin-left  = refl
twin-right : ((- pos 2) - (- pos 1)) ≡ - pos 1
twin-right = refl

------------------------------------------------------------------------
-- §3 · FENCE (the owner's spectral reading, stated, NOT checked here).
--
-- After centering, the per-prime normalized Fourier crystal is REAL and
-- signed: for p ∤ 2a,  r_{p,a}(0) = 1,  r_{p,a}(t) = −2cos(2πat/p)/(p−2)
-- (t ≠ 0); for p ∣ a the walls coincide and r_{p,a}(t) = −1/(p−1).  The
-- survivor count over a centered interval I is
--   Σ_{y∈I} S_{a,z}(y) = ρ_{a,z} Σ_t R_a(t) D_I(α(t)),  R_a = ∏ r_{p,a},
--   α(t) = Σ t_p/p,  D_I(α) = Σ_{y∈I} cos(2πα y),
-- the zero ray ρ_{a,z}|I| being the singular-series main term.  These
-- require ℝ, cosine, and the finite DFT; they are the reading this
-- module's centering makes possible (the phase vanishes BECAUSE §1's
-- symmetry is exact) and are owed as separate terms in an ℝ-carrying
-- lane.  Absolute values would discard the cosine signs — that discard
-- is the parity loss; §1 is what keeps the angular information real.
------------------------------------------------------------------------
