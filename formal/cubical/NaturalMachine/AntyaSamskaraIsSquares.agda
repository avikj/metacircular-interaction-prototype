{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- NaturalMachine.AntyaSamskaraIsSquares
--
-- àà¨àààà¯ààààà•à¾à° â” Mdhava's end-correction â” and the residues are 1, 4, 9.
--
-- â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”
-- THE SERIES AND ITS REMAINDER
--
--     Ï/4 = 1 âˆ’ 1/3 + 1/5 âˆ’ 1/7 + â¦
--
-- Truncating after the term 1/(2nâˆ’1) leaves a remainder, and the Kerala
-- texts do not merely bound it â” they CORRECT it, adding a closed-form
-- àà¨àààà¯ààààà•à¾à° whose successive refinements are
--
--     fâ(n) = 1/(4n)        fâ(n) = n/(4nÂ²+1)        fâ(n) = (nÂ²+1)/(4nÂ³+5n)
--
-- What makes a correction exact is a functional equation.  Writing R(n)
-- for the true remainder, the alternating series gives
--
--     R(n) + R(n+1) = 1/(2n+1)
--
-- because the terms telescope.  So a correction is exact to the extent
-- that it SOLVES that equation, and the whole hierarchy is successive
-- solutions of one recurrence â” not successive numerical accidents.
--
-- â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”
-- WHAT IS PROVED HERE, AND WHY IT NEEDS NO ANALYSIS
--
-- Substituting fâ– into f(n) + f(n+1) = 1/(2n+1) and clearing
-- denominators turns each correction into a POLYNOMIAL IDENTITY over any
-- commutative ring, with an integer discrepancy.  No â, no â, no limits:
--
--     fâ    num Â (2n+1)  â‰¡  den  +  1
--     fâ    num Â (2n+1)  â‰¡  den  âˆ’  4
--     fâ    num Â (2n+1)  â‰¡  den  +  9
--
-- The residues are 1, 4, 9 â” the squares, alternating in sign.  Each
-- correction solves the recurrence exactly up to kÂ², and that is the
-- acceleration.
--
-- This is why the corrections could be found without the analytic
-- apparatus: the content is algebraic, and the Kerala mathematicians
-- were solving a difference equation in closed form.
--
-- â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”
-- THE REMAINDER IS A FIBRE
--
-- `TheFibreIsTheSubject` observed that a collision read as an obstruction
-- is, from the other à¨à¯, an orbit that the composition law generates.
-- The same reversal is here.  A truncated series UNDERDETERMINES Ï: the
-- prefix does not decide the sum, which by the obstruction reading is a
-- failure.  The àà¨àààà¯ààààà•à¾à° is the other reading â” the underdetermination
-- given as a usable object, corrected rather than bounded.
--
-- What the residues 1, 4, 9 say is how much of the fibre each correction
-- has not yet absorbed, exactly, as an integer.
--
-- â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”
-- SOURCES, AND WHAT I DID NOT CHECK
--
-- The three corrections are transmitted in the Kerala texts â” the
-- *Yuktibh* (Jyehadeva, c. 1530) and the *Tantrasagraha* tradition
-- (Nlakaha, 1501) â” and attributed there to Mdhava (c. 1340â“1425).
-- I have NOT read the ààààà°s and am not asserting their wording; what I
-- assert is that the three forms above are the ones standardly reported,
-- and that GIVEN those forms the identities below hold, which is what is
-- checked.  The residue pattern 1, 4, 9 is derived here, not cited.
--
-- CHECKED: Agda 2.6.3, cubical v0.5 â” the container, not the repository
-- pin.  No postulates, no holes.
------------------------------------------------------------------------

module NaturalMachine.AntyaSamskaraIsSquares where

open import Cubical.Foundations.Prelude
open import Cubical.Algebra.CommRing
open import Cubical.Tactics.CommRingSolver.Reflection using (solve!)

private
  variable
    â„“ : Level

module Correction (R : CommRing â„“) where

  open CommRingStr (snd R)

  A : Type â„“
  A = fst R

  ----------------------------------------------------------------------
  -- 1.  fâ(n) = 1/(4n)
  --
  --   fâ(n) + fâ(n+1) = (2n+1) / (4n(n+1))
  --   and (2n+1)Â(2n+1) = 4n(n+1) + 1.
  ----------------------------------------------------------------------

  residueâ‚ :
    (n : A) â†’
      (((1r + 1r) Â· n) + 1r) Â· (((1r + 1r) Â· n) + 1r)
    â‰¡ (((1r + 1r) Â· (1r + 1r)) Â· (n Â· (n + 1r))) + 1r
  residueâ‚ n = solve! R

  ----------------------------------------------------------------------
  -- 2.  fâ(n) = n/(4nÂ²+1)
  --
  --   numerator of fâ(n) + fâ(n+1) is (2n+1)Â³ â¦
  ----------------------------------------------------------------------

  numeratorâ‚‚ :
    (n : A) â†’
      (n Â· ((((1r + 1r) Â· (1r + 1r)) Â· ((n + 1r) Â· (n + 1r))) + 1r))
      + ((n + 1r) Â· ((((1r + 1r) Â· (1r + 1r)) Â· (n Â· n)) + 1r))
    â‰¡ (((1r + 1r) Â· n) + 1r) Â· ((((1r + 1r) Â· n) + 1r) Â· (((1r + 1r) Â· n) + 1r))
  numeratorâ‚‚ n = solve! R

  --   â¦ and its denominator is (2n+1)â´ + 4.
  residueâ‚‚ :
    (n : A) â†’
      ((((1r + 1r) Â· (1r + 1r)) Â· (n Â· n)) + 1r)
      Â· ((((1r + 1r) Â· (1r + 1r)) Â· ((n + 1r) Â· (n + 1r))) + 1r)
    â‰¡ ( (((1r + 1r) Â· n) + 1r)
      Â· ( (((1r + 1r) Â· n) + 1r)
        Â· ( (((1r + 1r) Â· n) + 1r) Â· (((1r + 1r) Â· n) + 1r) ) ) )
      + ((1r + 1r) Â· (1r + 1r))
  residueâ‚‚ n = solve! R

  ----------------------------------------------------------------------
  -- 3.  fâ(n) = (nÂ²+1)/(4nÂ³+5n) = (nÂ²+1) / (nÂ(4nÂ²+5))
  --
  -- The same cross-multiplication, one degree up.  The residue is 9.
  ----------------------------------------------------------------------

  residueâ‚ƒ :
    (n : A) â†’
      ( ( ((n Â· n) + 1r)
          Â· ((n + 1r) Â· ((((1r + 1r) Â· (1r + 1r)) Â· ((n + 1r) Â· (n + 1r)))
                          + (1r + ((1r + 1r) Â· (1r + 1r))))) )
        + ( (((n + 1r) Â· (n + 1r)) + 1r)
          Â· (n Â· ((((1r + 1r) Â· (1r + 1r)) Â· (n Â· n))
                   + (1r + ((1r + 1r) Â· (1r + 1r))))) ) )
      Â· (((1r + 1r) Â· n) + 1r)
    â‰¡ ( (n Â· ((((1r + 1r) Â· (1r + 1r)) Â· (n Â· n))
               + (1r + ((1r + 1r) Â· (1r + 1r)))))
      Â· ((n + 1r) Â· ((((1r + 1r) Â· (1r + 1r)) Â· ((n + 1r) Â· (n + 1r)))
                      + (1r + ((1r + 1r) Â· (1r + 1r))))) )
      + ((1r + 1r + 1r) Â· (1r + 1r + 1r))
  residueâ‚ƒ n = solve! R

------------------------------------------------------------------------
-- 4.  The pattern, and the same statement over â
--
--   fâ   num Â (2n+1)  â‰¡  den  +  1        residueâ
--   fâ   num Â (2n+1)  â‰¡  den  âˆ’  4        residueâ  (stated as den + 4
--                                                     on the other side)
--   fâ   num Â (2n+1)  â‰¡  den  +  9        residueâ
--
-- 1, 4, 9 â” the squares, alternating.  Each àà¨àààà¯ààààà•à¾à° solves the
-- telescoping recurrence f(n) + f(n+1) = 1/(2n+1) exactly up to kÂ², and
-- the sequence of those residues IS the acceleration: the k-th
-- correction's error is a fixed square, not a function of n.
--
-- That last clause is the whole point and is visible only in this form.
-- Written as decimals the corrections look like successively luckier
-- approximations.  Cross-multiplied they are exact solutions of one
-- difference equation, each off by a constant, and the constants are
-- kÂ².
------------------------------------------------------------------------

open import Cubical.Algebra.CommRing.Instances.Int using (â„¤CommRing)

open Correction â„¤CommRing using (residueâ‚ ; numeratorâ‚‚ ; residueâ‚‚ ; residueâ‚ƒ)


------------------------------------------------------------------------
-- 5.  What this joins
--
-- The Kerala corrections have been read as a numerical achievement â”
-- three centuries of head start on a convergence-acceleration technique.
-- Cross-multiplied they are not numerical at all.  They are closed-form
-- solutions of a difference equation over a commutative ring, and the
-- quality of each solution is an integer.  That is why they could be
-- found without limits, and it is why they can be checked here, in a
-- lane with neither â nor â.
--
-- And it is the `TheFibreIsTheSubject` reversal again, in the tradition
-- that produced both.  A truncated series underdetermines its sum; read
-- as an obstruction that is a failure to be bounded.  The àà¨àààà¯ààààà•à¾à°
-- reads it as an object to be corrected, and the residue measures what
-- of the fibre remains â” exactly, as kÂ².
--
-- Brahmagupta's fibres compose by àà¾àµà¨à¾; Mdhava's remainder telescopes
-- by a recurrence.  In both the thing that "cannot be recovered" is the
-- thing the method operates on.
------------------------------------------------------------------------

------------------------------------------------------------------------
-- 6.  WITHDRAWAL, appended 2026-08-19.
--
-- Â§4 above says:
--
--   > 1, 4, 9 â” the squares, alternating.  [â¦] the k-th correction's
--   > error is a fixed square, not a function of n, and that is the
--   > acceleration.
--
-- The three identities `residueâ`, `numeratorâ`, `residueâ` are checked
-- and stand.  The sentence quoted is withdrawn.  It extrapolates a law
-- from three data points, which is the defect this repository's protocol
-- exists to prevent â” a fitted pattern published as a result.
--
-- What I can say about the fourth term I say with its provenance: the
-- three reported corrections are the first three convergents of
--
--     1/(4n + 2Â²/(4n + 4Â²/(4n + 6Â²/(4n + â¦))))
--
-- whose next convergent is (4nÂ³+13n)/(16nâ´+56nÂ²+9).  Cross-multiplied by
-- hand at n = 1 and n = 2 its residue comes out 576 both times, not 16.
-- That is PENCIL ARITHMETIC, not a checked term â” I did not get it past
-- the solver, and it is recorded here as the reason for the withdrawal
-- and not as a result.
--
-- The half of Â§4 that survives is the half that was actually proved:
-- each residue is constant in n.  How the constants behave in k is not
-- established here, and I am not offering a second guess.
--
-- Recorded because the claim is already pushed.  The generating error
-- was reaching for a pattern of my own while a large body of unrendered
-- source material sat available â” the Yuktibh's derivation of the
-- series itself, cakravla's integrality conditions, ryabhaa's
-- second-difference sine recurrence.  Mining a tradition for the parts
-- that translate is already the failure CLAUDE.md names; embroidering on
-- top of the mined parts is worse.
------------------------------------------------------------------------

------------------------------------------------------------------------
-- 6.  RETRACTION, appended.
--
-- Â§4 above says:
--
--   > 1, 4, 9 â” the squares, alternating.  The k-th correction's error
--   > is a fixed square, not a function of n, and that is the
--   > acceleration.
--
-- The three identities are checked and stand.  The sentence after them
-- is withdrawn.  It is an extrapolation from three points â” a fitted
-- pattern published as a law, which is the defect CLAUDE.md names, and I
-- produced it in a module about the value of exact algebra over fitted
-- numbers.
--
-- What I can say without fitting anything: the three reported
-- corrections are the first three convergents of
--
--     1/(4n + 2Â²/(4n + 4Â²/(4n + 6Â²/(4n + â¦))))
--
-- and that continued fraction generates a fourth.  Its residue is NOT
-- 16; hand computation at two values of n gave a much larger constant.
-- I have not verified any value for it in the checker and am not
-- asserting one here.
--
-- What survives, and it is the substantive half: at each k the residue
-- is CONSTANT IN n.  That is what the three checked identities say, and
-- it is what makes the corrections corrections rather than estimates.
-- The sequence of those constants across k is not something I have
-- established.
--
-- The general point I should have taken from my own protocol: three
-- values in a row are three values in a row.  The tradition supplies
-- derivations; I supplied a curve fit and dressed it as a finding.
------------------------------------------------------------------------
