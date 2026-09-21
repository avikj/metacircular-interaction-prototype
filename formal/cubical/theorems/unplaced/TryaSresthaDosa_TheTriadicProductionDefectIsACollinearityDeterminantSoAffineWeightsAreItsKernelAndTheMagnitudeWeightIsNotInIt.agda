{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- त्र्यश्र-दोष — the triadic defect.
--
-- A rotation-invariant quadratic functional built from a weight `F` on
-- the SIGNED frequency has, on a nondegenerate triad, a production
-- defect
--
--     𝒟F(x,y,z) = F x · (y - z) + F y · (z - x) + F z · (x - y),
--
-- and `𝒟F ≡ 0` on every admissible triad is exactly the condition for
-- the functional to be produced by no triad — i.e. to be an invariant.
-- This module proves the three algebraic facts that determine which
-- weights those are.  Nothing analytic is claimed: the passage from a
-- field equation to this defect is where the analysis lives, and it is
-- not here.  What IS here is the whole of the algebra downstream.
--
--   §1  𝒟F IS A COLLINEARITY DETERMINANT.  For every weight and every
--       triple,
--
--           𝒟F(x,y,z) + det ⎡ x  F x  1 ⎤
--                           ⎢ y  F y  1 ⎥  ≡  0 .
--                           ⎣ z  F z  1 ⎦
--
--       So "the defect vanishes" and "the three points (t , F t) are
--       collinear" are one statement, not an analogy.  This is what
--       lets the whole family be solved at once: on any interval where
--       every triple is admissible, F is affine because every three of
--       its points are collinear.
--
--   §2  AFFINE WEIGHTS ARE IN THE KERNEL.  For F t = A + B · t the
--       defect vanishes identically — for ALL x, y, z, with no
--       admissibility hypothesis at all.  (The two spanning weights are
--       the constant and the identity; on the signed frequency these
--       are the energy and the signed helicity.)
--
--   §3  THE MAGNITUDE WEIGHT IS NOT.  A weight that reads |σ| takes the
--       values (a , b , c) at the mixed-sign triple (a , b , -c).  Its
--       defect there is
--
--           𝒟(a , b , -c) ≡ 2 · c · (a - b) ,
--
--       computed, and exhibited nonzero at a concrete triple by `refl`
--       (§3b).  Same-sign triads give zero because the magnitude is
--       affine on either half-line; it is the MIXED-sign triads that
--       obstruct, and this is the exact size of the obstruction.
--
-- Together: the kernel contains the affine weights (§2) and does not
-- contain the magnitude weight (§3), with §1 the reason the kernel is
-- no larger than affine wherever all triples are admissible.
--
-- SYĀT — THE CLAIM, EXACTLY.  §§1–3 over ℤ, for all arguments, plus one
-- computed witness.  NOT claimed: that 𝒟F ≡ 0 on admissible triples
-- FORCES F affine — that needs the admissibility geometry (every three
-- points of an interval (a,2a) form a strict triangle) and an overlap
-- argument, neither of which is formalised here; nor any statement
-- about positivity, which is an order fact and not a ring identity;
-- nor anything about the field equation the defect is extracted from.
------------------------------------------------------------------------

module TryaSresthaDosa_TheTriadicProductionDefectIsACollinearityDeterminantSoAffineWeightsAreItsKernelAndTheMagnitudeWeightIsNotInIt where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Int using (ℤ ; pos ; _+_ ; _·_ ; _-_)
open import Cubical.Algebra.CommRing.Instances.Int using (ℤCommRing)
open import Cubical.Tactics.CommRingSolver.Reflection using (solve!)

------------------------------------------------------------------------
-- ० · The defect of a weight on a triad, and the 3×3 determinant whose
--     vanishing says the three sampled points are collinear.
------------------------------------------------------------------------

defect : (ℤ → ℤ) → ℤ → ℤ → ℤ → ℤ
defect F x y z = (F x · (y - z)) + ((F y · (z - x)) + (F z · (x - y)))

-- det ⎡ x u 1 ⎤
--     ⎢ y v 1 ⎥   with u = F x, v = F y, w = F z, expanded.
--     ⎣ z w 1 ⎦
det3 : ℤ → ℤ → ℤ → ℤ → ℤ → ℤ → ℤ
det3 x y z u v w = ((x · v) + ((z · u) + (y · w)))
                 - ((z · v) + ((y · u) + (x · w)))

------------------------------------------------------------------------
-- १ · THE DEFECT IS THE COLLINEARITY DETERMINANT (up to sign).
--
--     𝒟F(x,y,z) + det3 x y z (F x) (F y) (F z)  ≡  0 .
--
-- Stated for arbitrary values u v w at the three points, so it is a
-- fact about the shape of the expression and not about F.
------------------------------------------------------------------------

defect-is-collinearity :
    (x y z u v w : ℤ)
  → (((u · (y - z)) + ((v · (z - x)) + (w · (x - y))))
      + det3 x y z u v w)
    ≡ pos 0
defect-is-collinearity x y z u v w = solve! ℤCommRing

-- the same statement with the values supplied by a weight
defect-is-collinearity-at :
    (F : ℤ → ℤ) (x y z : ℤ)
  → (defect F x y z + det3 x y z (F x) (F y) (F z)) ≡ pos 0
defect-is-collinearity-at F x y z =
  defect-is-collinearity x y z (F x) (F y) (F z)

------------------------------------------------------------------------
-- २ · AFFINE WEIGHTS ARE IN THE KERNEL, with no hypothesis on the
--     triple.  A is the energy coefficient, B the signed-helicity one.
------------------------------------------------------------------------

affine : ℤ → ℤ → (ℤ → ℤ)
affine A B = λ t → A + (B · t)

affine-in-kernel :
    (A B x y z : ℤ) → defect (affine A B) x y z ≡ pos 0
affine-in-kernel A B x y z = solve! ℤCommRing

-- the two spanning cases, named
constant-in-kernel : (A x y z : ℤ) → defect (λ _ → A) x y z ≡ pos 0
constant-in-kernel A x y z = solve! ℤCommRing

identity-in-kernel : (x y z : ℤ) → defect (λ t → t) x y z ≡ pos 0
identity-in-kernel x y z = solve! ℤCommRing

------------------------------------------------------------------------
-- ३ · THE MAGNITUDE WEIGHT IS NOT IN THE KERNEL.
--
-- At the mixed-sign triad (a , b , -c) a weight reading |σ| takes the
-- values (a , b , c).  Its defect is exactly 2·c·(a-b).
------------------------------------------------------------------------

magnitude-defect :
    (a b c : ℤ)
  → ((a · (b - (pos 0 - c))) + ((b · ((pos 0 - c) - a)) + (c · (a - b))))
    ≡ ((c + c) · (a - b))
magnitude-defect a b c = solve! ℤCommRing

-- ३b · and it is nonzero: a computed witness at (2 , 1 , -1), where the
--       defect is 2.  Same-sign triads cannot do this — the magnitude
--       is affine on either half-line, so §2 covers them.
magnitude-defect-witness :
    ((pos 2 · (pos 1 - (pos 0 - pos 1)))
      + ((pos 1 · ((pos 0 - pos 1) - pos 2)) + (pos 1 · (pos 2 - pos 1))))
    ≡ pos 2
magnitude-defect-witness = refl
