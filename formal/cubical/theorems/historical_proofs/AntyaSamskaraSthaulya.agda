{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- AntyaSamskaraSthaulya
--
-- अन्त्यसंस्कार and its स्थौल्य — Mādhava's end-correction, and the exact
-- coarseness of each one.
--
-- Renamed 2026-08-20 from `AntyaSamskaraIsSquares`, whose §6 retracted
-- the claim the file was named after while the name and this header went
-- on asserting it.  A retraction under a title that still says the thing
-- is not a retraction.  The old title said the residues were 1, 4, 9;
-- §6 now exhibits how that list was assembled, and §7 gives the
-- invariant that replaces it.
--
-- ────────────────────────────────────────────────────────────────────
-- THE SERIES AND ITS REMAINDER
--
--     π/4 = 1 − 1/3 + 1/5 − 1/7 + …
--
-- Truncating after the term 1/(2n−1) leaves a remainder, and the Kerala
-- texts do not merely bound it — they CORRECT it, adding a closed-form
-- अन्त्यसंस्कार whose successive refinements are
--
--     f₁(n) = 1/(4n)     f₂(n) = n/(4n²+1)     f₃(n) = (n²+1)/(4n³+5n)
--
-- What makes a correction exact is a functional equation.  Writing R(n)
-- for the true remainder, the alternating series gives
--
--     R(n) + R(n+1) = 1/(2n+1)
--
-- because the terms telescope.  So a correction is exact to the extent
-- that it SOLVES that equation, and the whole hierarchy is successive
-- solutions of one recurrence — not successive numerical accidents.
--
-- ────────────────────────────────────────────────────────────────────
-- WHAT IS PROVED HERE, AND WHY IT NEEDS NO ANALYSIS
--
-- Substituting fₖ into f(n) + f(n+1) = 1/(2n+1) and clearing
-- denominators turns each correction into a POLYNOMIAL IDENTITY over any
-- commutative ring, with an integer discrepancy that DOES NOT DEPEND ON
-- n.  No ℝ, no ℚ, no limits, no bound — an equation:
--
--     f₁    num · (2n+1)  ≡  den  +    4        (or + 1, rescaled)
--     f₂    num · (2n+1)  ≡  den  −    4
--     f₃    num · (2n+1)  ≡  den  +    9
--     f₄    num · (2n+1)  ≡  den  −  576
--
-- Constant in n is the content.  It is what makes these corrections
-- rather than estimates, and it is why they were findable without the
-- analytic apparatus: the Kerala mathematicians were solving a
-- difference equation in closed form.
--
-- The constants themselves are NOT invariant — they change when P and Q
-- are rescaled — so no sequence of them carries a law.  §6.  What is
-- invariant is the स्थौल्य's order, and it drops by two at each step.  §7.
--
-- ────────────────────────────────────────────────────────────────────
-- THE REMAINDER IS A FIBRE
--
-- `TheFibreIsTheSubject` observed that a collision read as an obstruction
-- is, from the other नय, an orbit that the composition law generates.
-- The same reversal is here.  A truncated series UNDERDETERMINES π: the
-- prefix does not decide the sum, which by the obstruction reading is a
-- failure.  The अन्त्यसंस्कार is the other reading — the underdetermination
-- given as a usable object, corrected rather than bounded.
--
-- ────────────────────────────────────────────────────────────────────
-- SOURCES, AND WHAT I DID NOT CHECK
--
-- The three corrections are transmitted in the Kerala texts — the
-- *Yuktibhāṣā* (Jyeṣṭhadeva, c. 1530) and the *Tantrasaṅgraha* tradition
-- (Nīlakaṇṭha, 1501) — and attributed there to Mādhava (c. 1340–1425).
-- I have NOT read the सूत्रs and am not asserting their wording; what I
-- assert is that the three forms above are the ones standardly reported,
-- and that GIVEN those forms the identities below hold, which is what is
-- checked.  f₄ is not transmitted; it is the next convergent of the
-- continued fraction the three are convergents of, and it is derived
-- here, in §3b, as a checked term.
--
-- CHECKED: Agda 2.6.3, cubical v0.5 — the container, not the repository
-- pin.  No postulates, no holes.
------------------------------------------------------------------------

module AntyaSamskaraSthaulya where

open import Cubical.Foundations.Prelude
open import Cubical.Algebra.CommRing
open import Cubical.Tactics.CommRingSolver.Reflection using (solve!)

private
  variable
    ℓ : Level

module Correction (R : CommRing ℓ) where

  open CommRingStr (snd R)

  A : Type ℓ
  A = fst R

  ----------------------------------------------------------------------
  -- 1.  f₁(n) = 1/(4n)
  --
  --   f₁(n) + f₁(n+1) = (2n+1) / (4n(n+1))
  --   and (2n+1)·(2n+1) = 4n(n+1) + 1.
  ----------------------------------------------------------------------

  residue₁ :
    (n : A) →
      (((1r + 1r) · n) + 1r) · (((1r + 1r) · n) + 1r)
    ≡ (((1r + 1r) · (1r + 1r)) · (n · (n + 1r))) + 1r
  residue₁ n = solve! R

  ----------------------------------------------------------------------
  -- 2.  f₂(n) = n/(4n²+1)
  --
  --   numerator of f₂(n) + f₂(n+1) is (2n+1)³ …
  ----------------------------------------------------------------------

  numerator₂ :
    (n : A) →
      (n · ((((1r + 1r) · (1r + 1r)) · ((n + 1r) · (n + 1r))) + 1r))
      + ((n + 1r) · ((((1r + 1r) · (1r + 1r)) · (n · n)) + 1r))
    ≡ (((1r + 1r) · n) + 1r) · ((((1r + 1r) · n) + 1r) · (((1r + 1r) · n) + 1r))
  numerator₂ n = solve! R

  --   … and its denominator is (2n+1)⁴ + 4.
  residue₂ :
    (n : A) →
      ((((1r + 1r) · (1r + 1r)) · (n · n)) + 1r)
      · ((((1r + 1r) · (1r + 1r)) · ((n + 1r) · (n + 1r))) + 1r)
    ≡ ( (((1r + 1r) · n) + 1r)
      · ( (((1r + 1r) · n) + 1r)
        · ( (((1r + 1r) · n) + 1r) · (((1r + 1r) · n) + 1r) ) ) )
      + ((1r + 1r) · (1r + 1r))
  residue₂ n = solve! R

  ----------------------------------------------------------------------
  -- 3.  f₃(n) = (n²+1)/(4n³+5n) = (n²+1) / (n·(4n²+5))
  --
  -- The same cross-multiplication, one degree up.  The residue is 9.
  ----------------------------------------------------------------------

  residue₃ :
    (n : A) →
      ( ( ((n · n) + 1r)
          · ((n + 1r) · ((((1r + 1r) · (1r + 1r)) · ((n + 1r) · (n + 1r)))
                          + (1r + ((1r + 1r) · (1r + 1r))))) )
        + ( (((n + 1r) · (n + 1r)) + 1r)
          · (n · ((((1r + 1r) · (1r + 1r)) · (n · n))
                   + (1r + ((1r + 1r) · (1r + 1r))))) ) )
      · (((1r + 1r) · n) + 1r)
    ≡ ( (n · ((((1r + 1r) · (1r + 1r)) · (n · n))
               + (1r + ((1r + 1r) · (1r + 1r)))))
      · ((n + 1r) · ((((1r + 1r) · (1r + 1r)) · ((n + 1r) · (n + 1r)))
                      + (1r + ((1r + 1r) · (1r + 1r))))) )
      + ((1r + 1r + 1r) · (1r + 1r + 1r))
  residue₃ n = solve! R

  ----------------------------------------------------------------------
  -- 3a.  f₁ again, WITHOUT the rescaling.
  --
  -- `residue₁` above is the identity divided through by 4.  In the same
  -- lowest-terms P/Q form the other corrections are stated in — f₁ = 1/(4n),
  -- so P = 1 and Q = 4n — the cross-multiplied identity reads
  --
  --     (P(n)Q(n+1) + P(n+1)Q(n)) · (2n+1)  ≡  Q(n)Q(n+1) + 4
  --
  -- and the residue is 4, not 1.  Both are checked; they are the same
  -- identity at two scalings, and §6 is about which of them was quoted.
  ----------------------------------------------------------------------

  residue₁-unreduced :
    (n : A) →
      ((((1r + 1r) · (1r + 1r)) · (n + 1r)) + (((1r + 1r) · (1r + 1r)) · n))
      · (((1r + 1r) · n) + 1r)
    ≡ ((((1r + 1r) · (1r + 1r)) · n) · (((1r + 1r) · (1r + 1r)) · (n + 1r)))
      + ((1r + 1r) · (1r + 1r))
  residue₁-unreduced n = solve! R

  ----------------------------------------------------------------------
  -- 3b.  f₄, the fourth अन्त्यसंस्कार, derived rather than penciled.
  --
  -- The continued fraction is NOT mine and is not the tradition's either.
  -- It is K. Krishna's (arXiv:2405.11134), who extends the Kerala method
  -- past the third correction — for which, he reports, the Kerala texts
  -- give no rationale — and finds that the three transmitted corrections
  -- are the first three convergents of
  --
  --     1/(4n + 2²/(4n + 4²/(4n + 6²/(4n + …))))
  --
  -- and the fourth convergent is
  --
  --     f₄(n) = (4n³ + 13n) / (16n⁴ + 56n² + 9).
  --
  -- Cross-multiplied against f(n) + f(n+1) = 1/(2n+1) its residue is
  -- −576, constant in n, over any commutative ring.
  ----------------------------------------------------------------------

  two three four nine thirteen sixteen fiftysix twentyfour : A
  two        = 1r + 1r
  three      = two + 1r
  four       = two · two
  nine       = three · three
  thirteen   = (four · three) + 1r
  sixteen    = four · four
  fiftysix   = (sixteen · three) + (four · two)
  twentyfour = four · (two · three)

  P₄ Q₄ : A → A
  P₄ n = (four · (n · (n · n))) + (thirteen · n)
  Q₄ n = (sixteen · ((n · n) · (n · n))) + ((fiftysix · (n · n)) + nine)

  residue₄ :
    (n : A) →
      (Q₄ n · Q₄ (n + 1r))
    ≡ ((((P₄ n) · Q₄ (n + 1r)) + ((P₄ (n + 1r)) · Q₄ n)) · ((two · n) + 1r))
      + (twentyfour · twentyfour)
  residue₄ n = solve! R

------------------------------------------------------------------------
-- 4.  The four residues, and the same statement over ℤ
--
--   f₁ = 1/(4n)              num · (2n+1)  ≡  den  +    4    residue₁-unreduced
--        …rescaled by 4                    ≡  den  +    1    residue₁
--   f₂ = n/(4n²+1)                         ≡  den  −    4    residue₂
--   f₃ = (n²+1)/(4n³+5n)                   ≡  den  +    9    residue₃
--   f₄ = (4n³+13n)/(16n⁴+56n²+9)           ≡  den  −  576    residue₄
--
-- What every one of these says, and it is the substantive content: the
-- discrepancy is CONSTANT IN n.  Each अन्त्यसंस्कार is an exact closed-form
-- solution of the difference equation f(n) + f(n+1) = 1/(2n+1) up to a
-- fixed integer, over any commutative ring, with no limits anywhere.
-- That is why the corrections were findable without analysis.
--
-- What the constants do across k is NOT a square pattern; see §6.
------------------------------------------------------------------------

open import Cubical.Algebra.CommRing.Instances.Int using (ℤCommRing)

open Correction ℤCommRing
  using (residue₁ ; residue₁-unreduced ; numerator₂ ; residue₂ ; residue₃ ; residue₄)


------------------------------------------------------------------------
-- 5.  What this joins
--
-- The Kerala corrections have been read as a numerical achievement —
-- three centuries of head start on a convergence-acceleration technique.
-- Cross-multiplied they are not numerical at all.  They are closed-form
-- solutions of a difference equation over a commutative ring, and the
-- defect of each solution is an integer.  That is why they could be
-- found without limits, and it is why they can be checked here, in a
-- lane with neither ℝ nor ℚ.
--
-- And it is the `TheFibreIsTheSubject` reversal again, in the tradition
-- that produced both.  A truncated series underdetermines its sum; read
-- as an obstruction that is a failure to be bounded.  The अन्त्यसंस्कार
-- reads it as an object to be corrected, and the residue says exactly
-- how much of the fibre the correction has not absorbed.
--
-- Brahmagupta's fibres compose by भावना; Mādhava's remainder telescopes
-- by a recurrence.  In both the thing that "cannot be recovered" is the
-- thing the method operates on.
------------------------------------------------------------------------


------------------------------------------------------------------------
-- 6.  RETRACTION of the square pattern, and the mechanism of the error.
--
-- An earlier §4 read:
--
--   > 1, 4, 9 — the squares, alternating.  The k-th correction's error
--   > is a fixed square, not a function of n, and that is the
--   > acceleration.
--
-- Withdrawn.  The identities were and are checked; the pattern read off
-- them was a fit over three points, which is the defect CLAUDE.md names,
-- produced inside a module arguing for exact algebra over fitted numbers.
--
-- The mechanism is now exhibited rather than confessed, which is the
-- point of this section.  Written in the lowest-terms P/Q form that f₂,
-- f₃ and f₄ are all written in, the residues are
--
--     4,  −4,  9,  −576.
--
-- The "1" was 4, divided through by 4 at k = 1 only —
-- `residue₁-unreduced` is that same identity unscaled, and both are
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
--     1/(4n + 2²/(4n + 4²/(4n + 6²/(4n + …))))
--
-- and the fourth is (4n³+13n)/(16n⁴+56n²+9).  Its residue is −576.  It
-- was hand-computed at two values of n when the retraction was first
-- written and recorded there as pencil arithmetic, explicitly not as a
-- result.  `residue₄` above is that statement as a checked term, over an
-- arbitrary commutative ring rather than at two integers, which is what
-- the earlier note said it was not.
--
-- 576 = 24², so a square is still in the list, and that is precisely why
-- the fit was reachable and why it is worthless: 4, −4, 9, −576 has a
-- square at every position and no law relating them, because the
-- quantity is not invariant.
------------------------------------------------------------------------


------------------------------------------------------------------------
-- 7.  What replaces it: the स्थौल्य, and a statement that is invariant.
--
-- The Yuktibhāṣā does not evaluate a correction by cross-multiplying.
-- It defines the correction's स्थौल्य — its coarseness, its inaccuracy —
-- as what is left over when the correction is required to be consistent
-- with itself one step later, and it selects corrections by making the
-- स्थौल्य small.  The error term is the primary object and the correction
-- is derived from it.  That is the same sentence as this repository's
-- own protocol — *a correlation coefficient has no content; the content
-- is the error term* — arrived at around 1530 and used as a method
-- rather than as a warning.
--
-- Written out, the स्थौल्य of a correction f is
--
--     E(n)  =  f(n) + f(n+1) − 1/(2n+1)
--
-- and it depends on f alone, not on how f is written.  The identities
-- above give it in closed form:
--
--     E₁(n) =     1 / ( 4n(n+1)(2n+1) )                  degree 3
--     E₂(n) =    −4 / ( (2n+1)(4n²+1)(4n²+8n+5) )        degree 5
--     E₃(n) =     9 / ( (2n+1)·Q₃(n)·Q₃(n+1) )           degree 7
--     E₄(n) =  −576 / ( (2n+1)·Q₄(n)·Q₄(n+1) )           degree 9
--
-- The numerators are the residues and are not invariant.  The DEGREE of
-- the denominator is invariant — rescaling P and Q by a unit changes
-- neither — and for these four, whose denominators are written out
-- above, it is 3, 5, 7, 9.  Read off, not extrapolated: what happens at
-- k ≥ 5 is a statement about deg k_k, which is elementary and which this
-- lane cannot check, for the reason given at the end of
-- `SthaulyaIsTheOmittedTerm`.  The exact statement that does hold for
-- every k is the step law D_{k+1} = −a_{k+2}·D_k, proved there.
--
-- The four identities above are for k ≤ 4.  The general claim — that for
-- EVERY convergent of that continued fraction the स्थौल्य numerator is
-- constant in n — was left open here, as what the four cases make worth
-- proving, with the note that a proof would have to come from the
-- continued fraction's determinant recurrence and not from the list.
--
-- It is now proved, in `SthaulyaIsTheOmittedTerm`, from
-- that recurrence.  For every k and every n in every commutative ring,
-- the unreduced convergents satisfy
--
--     num · (2n+1) − den  =  (−1)^(k−1) · a_(k+1) · (a₁a₂⋯a_k)
--                          =  (−1)^(k−1) · 4^k · (k!)²,
--
-- with no n on the right: the स्थौल्य numerator is the product of every
-- partial numerator the correction USES, times the first one it OMITS.
-- The step form is D_{k+1} = −a_{k+2}·D_k.
--
-- Generating a fifth instance was the wrong move and the checker said
-- so: the degree-10 identity for k = 5 does not get past the solver in
-- twenty minutes.  The four cases here stay because they are the ones
-- that name the transmitted corrections; the law is next door.
--
-- CHECKED: Agda 2.6.3, cubical v0.5 — the container, not the repository
-- pin.  No postulates, no holes.
------------------------------------------------------------------------
