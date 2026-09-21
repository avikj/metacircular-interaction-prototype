{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- ààà°àà¯ààà°-à¦à‹à â” the triadic defect.
--
-- A rotation-invariant quadratic functional built from a weight `F` on
-- the SIGNED frequency has, on a nondegenerate triad, a production
-- defect
--
--     ð’ŸF(x,y,z) = F x Â (y - z) + F y Â (z - x) + F z Â (x - y),
--
-- and `ð’ŸF â‰¡ 0` on every admissible triad is exactly the condition for
-- the functional to be produced by no triad â” i.e. to be an invariant.
-- This module proves the three algebraic facts that determine which
-- weights those are.
--
--   Â§1  ð’ŸF IS A COLLINEARITY DETERMINANT.  For every weight and every
--       triple,
--
--           ð’ŸF(x,y,z) + det â¡ x  F x  1 â
--                           â y  F y  1 â  â‰¡  0 .
--                           â z  F z  1 â¦
--
--       So "the defect vanishes" and "the three points (t , F t) are
--       collinear" are one statement, not an analogy.  This is what
--       lets the whole family be solved at once: on any interval where
--       every triple is admissible, F is affine because every three of
--       its points are collinear.
--
--   Â§2  AFFINE WEIGHTS ARE IN THE KERNEL.  For F t = A + B Â t the
--       defect vanishes identically â” for ALL x, y, z, with no
--       admissibility hypothesis at all.  (The two spanning weights are
--       the constant and the identity; on the signed frequency these
--       are the energy and the signed helicity.)
--
--   Â§3  THE MAGNITUDE WEIGHT IS NOT.  A weight that reads |Ï| takes the
--       values (a , b , c) at the mixed-sign triple (a , b , -c).  Its
--       defect there is
--
--           ð’Ÿ(a , b , -c) â‰¡ 2 Â c Â (a - b) ,
--
--       computed, and exhibited nonzero at a concrete triple by `refl`
--       (Â§3b).  Same-sign triads give zero because the magnitude is
--       affine on either half-line; it is the MIXED-sign triads that
--       obstruct, and this is the exact size of the obstruction.
--
-- Together: the kernel contains the affine weights (Â§2) and does not
-- contain the magnitude weight (Â§3), with Â§1 the reason the kernel is
-- no larger than affine wherever all triples are admissible.
--
-- SYT â” THE CLAIM, EXACTLY.  Â§Â§1â“3 over â, for all arguments, plus one
-- computed witness.
------------------------------------------------------------------------

module TryaSresthaDosa_TheTriadicProductionDefectIsACollinearityDeterminantSoAffineWeightsAreItsKernelAndTheMagnitudeWeightIsNotInIt where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Int using (â„¤ ; pos ; _+_ ; _Â·_ ; _-_)
open import Cubical.Algebra.CommRing.Instances.Int using (â„¤CommRing)
open import Cubical.Tactics.CommRingSolver.Reflection using (solve!)

------------------------------------------------------------------------
-- à¦ Â The defect of a weight on a triad, and the 3—3 determinant whose
--     vanishing says the three sampled points are collinear.
------------------------------------------------------------------------

defect : (â„¤ â†’ â„¤) â†’ â„¤ â†’ â„¤ â†’ â„¤ â†’ â„¤
defect F x y z = (F x Â· (y - z)) + ((F y Â· (z - x)) + (F z Â· (x - y)))

-- det â¡ x u 1 â
--     â y v 1 â   with u = F x, v = F y, w = F z, expanded.
--     â z w 1 â¦
det3 : â„¤ â†’ â„¤ â†’ â„¤ â†’ â„¤ â†’ â„¤ â†’ â„¤ â†’ â„¤
det3 x y z u v w = ((x Â· v) + ((z Â· u) + (y Â· w)))
                 - ((z Â· v) + ((y Â· u) + (x Â· w)))

------------------------------------------------------------------------
-- à§ Â THE DEFECT IS THE COLLINEARITY DETERMINANT (up to sign).
--
--     ð’ŸF(x,y,z) + det3 x y z (F x) (F y) (F z)  â‰¡  0 .
--
-- Stated for arbitrary values u v w at the three points, so it is a
-- fact about the shape of the expression and not about F.
------------------------------------------------------------------------

defect-is-collinearity :
    (x y z u v w : â„¤)
  â†’ (((u Â· (y - z)) + ((v Â· (z - x)) + (w Â· (x - y))))
      + det3 x y z u v w)
    â‰¡ pos 0
defect-is-collinearity x y z u v w = solve! â„¤CommRing

-- the same statement with the values supplied by a weight
defect-is-collinearity-at :
    (F : â„¤ â†’ â„¤) (x y z : â„¤)
  â†’ (defect F x y z + det3 x y z (F x) (F y) (F z)) â‰¡ pos 0
defect-is-collinearity-at F x y z =
  defect-is-collinearity x y z (F x) (F y) (F z)

------------------------------------------------------------------------
-- à¨ Â AFFINE WEIGHTS ARE IN THE KERNEL, with no hypothesis on the
--     triple.  A is the energy coefficient, B the signed-helicity one.
------------------------------------------------------------------------

affine : â„¤ â†’ â„¤ â†’ (â„¤ â†’ â„¤)
affine A B = Î» t â†’ A + (B Â· t)

affine-in-kernel :
    (A B x y z : â„¤) â†’ defect (affine A B) x y z â‰¡ pos 0
affine-in-kernel A B x y z = solve! â„¤CommRing

-- the two spanning cases, named
constant-in-kernel : (A x y z : â„¤) â†’ defect (Î» _ â†’ A) x y z â‰¡ pos 0
constant-in-kernel A x y z = solve! â„¤CommRing

identity-in-kernel : (x y z : â„¤) â†’ defect (Î» t â†’ t) x y z â‰¡ pos 0
identity-in-kernel x y z = solve! â„¤CommRing

------------------------------------------------------------------------
-- à© Â THE MAGNITUDE WEIGHT IS NOT IN THE KERNEL.
--
-- At the mixed-sign triad (a , b , -c) a weight reading |Ï| takes the
-- values (a , b , c).  Its defect is exactly 2ÂcÂ(a-b).
------------------------------------------------------------------------

magnitude-defect :
    (a b c : â„¤)
  â†’ ((a Â· (b - (pos 0 - c))) + ((b Â· ((pos 0 - c) - a)) + (c Â· (a - b))))
    â‰¡ ((c + c) Â· (a - b))
magnitude-defect a b c = solve! â„¤CommRing

-- à©b Â and it is nonzero: a computed witness at (2 , 1 , -1), where the
--       defect is 2.  Same-sign triads cannot do this â” the magnitude
--       is affine on either half-line, so Â§2 covers them.
magnitude-defect-witness :
    ((pos 2 Â· (pos 1 - (pos 0 - pos 1)))
      + ((pos 1 Â· ((pos 0 - pos 1) - pos 2)) + (pos 1 Â· (pos 2 - pos 1))))
    â‰¡ pos 2
magnitude-defect-witness = refl
