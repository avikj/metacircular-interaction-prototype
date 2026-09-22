{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- AntyaSamskaraSthaulya
--
-- àà¨àààà¯ààààà•à¾à° and its ààààà²àà¯ â” Mdhava's end-correction, and the exact
-- coarseness of each one.
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
--     fâ(n) = 1/(4n)     fâ(n) = n/(4nÂ²+1)     fâ(n) = (nÂ²+1)/(4nÂ³+5n)
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
-- commutative ring, with an integer discrepancy that DOES NOT DEPEND ON
-- n.  No â, no â, no limits, no bound â” an equation:
--
--     fâ    num Â (2n+1)  â‰¡  den  +    4        (or + 1, rescaled)
--     fâ    num Â (2n+1)  â‰¡  den  âˆ’    4
--     fâ    num Â (2n+1)  â‰¡  den  +    9
--     fâ    num Â (2n+1)  â‰¡  den  âˆ’  576
--
-- Constant in n is the content.  It is what makes these corrections
-- rather than estimates, and it is why they were findable without the
-- analytic apparatus: the Kerala mathematicians were solving a
-- difference equation in closed form.
--
-- The constants themselves are NOT invariant â” they change when P and Q
-- are rescaled â” so no sequence of them carries a law.  Â§6.  What is
-- invariant is the ààààà²àà¯'s order, and it drops by two at each step.  Â§7.
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
-- â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”
-- SOURCES.
--
-- The three corrections are transmitted in the Kerala texts â” the
-- *Yuktibh* (Jyehadeva, c. 1530) and the *Tantrasagraha* tradition
-- (Nlakaha, 1501) â” and attributed there to Mdhava (c. 1340â“1425).
-- The three forms above are the ones standardly reported, and GIVEN
-- those forms the identities below hold.
-- fâ is not transmitted; it is the next convergent of the
-- continued fraction the three are convergents of, and it is derived
-- here, in Â§3b, as a checked term.
--
------------------------------------------------------------------------

module AntyaSamskaraSthaulya where

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

  ----------------------------------------------------------------------
  -- 3a.  fâ again, WITHOUT the rescaling.
  --
  -- `residueâ` above is the identity divided through by 4.  In the same
  -- lowest-terms P/Q form the other corrections are stated in â” fâ = 1/(4n),
  -- so P = 1 and Q = 4n â” the cross-multiplied identity reads
  --
  --     (P(n)Q(n+1) + P(n+1)Q(n)) Â (2n+1)  â‰¡  Q(n)Q(n+1) + 4
  --
  -- and the residue is 4, not 1.  Both are checked; they are the same
  -- identity at two scalings, and Â§6 is about which of them was quoted.
  ----------------------------------------------------------------------

  residueâ‚-unreduced :
    (n : A) â†’
      ((((1r + 1r) Â· (1r + 1r)) Â· (n + 1r)) + (((1r + 1r) Â· (1r + 1r)) Â· n))
      Â· (((1r + 1r) Â· n) + 1r)
    â‰¡ ((((1r + 1r) Â· (1r + 1r)) Â· n) Â· (((1r + 1r) Â· (1r + 1r)) Â· (n + 1r)))
      + ((1r + 1r) Â· (1r + 1r))
  residueâ‚-unreduced n = solve! R

  ----------------------------------------------------------------------
  -- 3b.  fâ, the fourth àà¨àààà¯ààààà•à¾à°, derived rather than penciled.
  --
  -- The continued fraction is NOT mine and is not the tradition's either.
  -- It is K. Krishna's (arXiv:2405.11134), who extends the Kerala method
  -- past the third correction â” for which, he reports, the Kerala texts
  -- give no rationale â” and finds that the three transmitted corrections
  -- are the first three convergents of
  --
  --     1/(4n + 2Â²/(4n + 4Â²/(4n + 6Â²/(4n + â¦))))
  --
  -- and the fourth convergent is
  --
  --     fâ(n) = (4nÂ³ + 13n) / (16nâ´ + 56nÂ² + 9).
  --
  -- Cross-multiplied against f(n) + f(n+1) = 1/(2n+1) its residue is
  -- âˆ’576, constant in n, over any commutative ring.
  ----------------------------------------------------------------------

  two three four nine thirteen sixteen fiftysix twentyfour : A
  two        = 1r + 1r
  three      = two + 1r
  four       = two Â· two
  nine       = three Â· three
  thirteen   = (four Â· three) + 1r
  sixteen    = four Â· four
  fiftysix   = (sixteen Â· three) + (four Â· two)
  twentyfour = four Â· (two Â· three)

  Pâ‚„ Qâ‚„ : A â†’ A
  Pâ‚„ n = (four Â· (n Â· (n Â· n))) + (thirteen Â· n)
  Qâ‚„ n = (sixteen Â· ((n Â· n) Â· (n Â· n))) + ((fiftysix Â· (n Â· n)) + nine)

  residueâ‚„ :
    (n : A) â†’
      (Qâ‚„ n Â· Qâ‚„ (n + 1r))
    â‰¡ ((((Pâ‚„ n) Â· Qâ‚„ (n + 1r)) + ((Pâ‚„ (n + 1r)) Â· Qâ‚„ n)) Â· ((two Â· n) + 1r))
      + (twentyfour Â· twentyfour)
  residueâ‚„ n = solve! R

------------------------------------------------------------------------
-- 4.  The four residues, and the same statement over â
--
--   fâ = 1/(4n)              num Â (2n+1)  â‰¡  den  +    4    residueâ-unreduced
--        â¦rescaled by 4                    â‰¡  den  +    1    residueâ
--   fâ = n/(4nÂ²+1)                         â‰¡  den  âˆ’    4    residueâ
--   fâ = (nÂ²+1)/(4nÂ³+5n)                   â‰¡  den  +    9    residueâ
--   fâ = (4nÂ³+13n)/(16nâ´+56nÂ²+9)           â‰¡  den  âˆ’  576    residueâ
--
-- What every one of these says, and it is the substantive content: the
-- discrepancy is CONSTANT IN n.  Each àà¨àààà¯ààààà•à¾à° is an exact closed-form
-- solution of the difference equation f(n) + f(n+1) = 1/(2n+1) up to a
-- fixed integer, over any commutative ring, with no limits anywhere.
-- That is why the corrections were findable without analysis.
--
-- What the constants do across k is NOT a square pattern; see Â§6.
------------------------------------------------------------------------

open import Cubical.Algebra.CommRing.Instances.Int using (â„¤CommRing)

open Correction â„¤CommRing
  using (residueâ‚ ; residueâ‚-unreduced ; numeratorâ‚‚ ; residueâ‚‚ ; residueâ‚ƒ ; residueâ‚„)


------------------------------------------------------------------------
-- 5.  What this joins
--
-- The Kerala corrections have been read as a numerical achievement â”
-- three centuries of head start on a convergence-acceleration technique.
-- Cross-multiplied they are not numerical at all.  They are closed-form
-- solutions of a difference equation over a commutative ring, and the
-- defect of each solution is an integer.  That is why they could be
-- found without limits, and it is why they can be checked here, in a
-- lane with neither â nor â.
--
-- And it is the `TheFibreIsTheSubject` reversal again, in the tradition
-- that produced both.  A truncated series underdetermines its sum; read
-- as an obstruction that is a failure to be bounded.  The àà¨àààà¯ààààà•à¾à°
-- reads it as an object to be corrected, and the residue says exactly
-- how much of the fibre the correction has not absorbed.
--
-- Brahmagupta's fibres compose by àà¾àµà¨à¾; Mdhava's remainder telescopes
-- by a recurrence.  In both the thing that "cannot be recovered" is the
-- thing the method operates on.
------------------------------------------------------------------------


------------------------------------------------------------------------
-- 6.  The residues carry no law.
--
-- Written in the lowest-terms P/Q form that fâ,
-- fâ and fâ are all written in, the residues are
--
--     4,  âˆ’4,  9,  âˆ’576.
--
-- The "1" was 4, divided through by 4 at k = 1 only â”
-- `residueâ-unreduced` is that same identity unscaled, and both are
-- checked above.  So the square pattern was not three points that
-- happened to line up.  It was two points and a rescaling chosen to make
-- a third, and the scaling factor is exactly the one that produces the
-- square.  A residue is a property of a REPRESENTATION P/Q, not of the
-- correction f = P/Q, and so no sequence of residues can carry a law.
--
-- The fourth residue settles it independently.  On K. Krishna's reading
-- (arXiv:2405.11134) the three transmitted corrections are the first
-- three convergents of
--
--     1/(4n + 2Â²/(4n + 4Â²/(4n + 6Â²/(4n + â¦))))
--
-- and the fourth is (4nÂ³+13n)/(16nâ´+56nÂ²+9).  Its residue is -576, checked above over an arbitrary commutative ring.
--
-- 576 = 24Â², so a square is still in the list, and that is precisely why
-- the fit was reachable and why it is worthless: 4, âˆ’4, 9, âˆ’576 has a
-- square at every position and no law relating them, because the
-- quantity is not invariant.
------------------------------------------------------------------------


------------------------------------------------------------------------
-- 7.  What replaces it: the ààààà²àà¯, and a statement that is invariant.
--
-- The Yuktibh does not evaluate a correction by cross-multiplying.
-- It defines the correction's ààààà²àà¯ â” its coarseness, its inaccuracy â”
-- as what is left over when the correction is required to be consistent
-- with itself one step later, and it selects corrections by making the
-- ààààà²àà¯ small.  The error term is the primary object and the correction
-- is derived from it.  That is the same sentence as this repository's
-- own protocol â” *a correlation coefficient has no content; the content
-- is the error term* â” arrived at around 1530 and used as a method
-- rather than as a warning.
--
-- Written out, the ààààà²àà¯ of a correction f is
--
--     E(n)  =  f(n) + f(n+1) âˆ’ 1/(2n+1)
--
-- and it depends on f alone, not on how f is written.  The identities
-- above give it in closed form:
--
--     Eâ(n) =     1 / ( 4n(n+1)(2n+1) )                  degree 3
--     Eâ(n) =    âˆ’4 / ( (2n+1)(4nÂ²+1)(4nÂ²+8n+5) )        degree 5
--     Eâ(n) =     9 / ( (2n+1)ÂQâ(n)ÂQâ(n+1) )           degree 7
--     Eâ(n) =  âˆ’576 / ( (2n+1)ÂQâ(n)ÂQâ(n+1) )           degree 9
--
-- The numerators are the residues and are not invariant.  The DEGREE of
-- the denominator is invariant â” rescaling P and Q by a unit changes
-- neither â” and for these four, whose denominators are written out
-- above, it is 3, 5, 7, 9.  Read off, not extrapolated: what happens at
-- k â‰ 5 is a statement about deg k_k, which is elementary and which this
-- lane cannot check, for the reason given at the end of
-- `SthaulyaIsTheOmittedTerm`.  The exact statement that does hold for
-- every k is the step law D_{k+1} = âˆ’a_{k+2}ÂD_k, proved there.
--
-- The four identities above are for k â‰ 4.  The general claim: for
-- EVERY convergent of that continued fraction the ààààà²àà¯ numerator is
-- constant in n.
-- It is proved in `SthaulyaIsTheOmittedTerm`, from
-- the continued fraction's determinant recurrence.  For every k and every n in every commutative ring,
-- the unreduced convergents satisfy
--
--     num Â (2n+1) âˆ’ den  =  (âˆ’1)^(kâˆ’1) Â a_(k+1) Â (aâaââ‹¯a_k)
--                          =  (âˆ’1)^(kâˆ’1) Â 4^k Â (k!)Â²,
--
-- with no n on the right: the ààààà²àà¯ numerator is the product of every
-- partial numerator the correction USES, times the first one it OMITS.
-- The step form is D_{k+1} = âˆ’a_{k+2}ÂD_k.
--
------------------------------------------------------------------------
