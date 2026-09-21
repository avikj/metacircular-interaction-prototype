{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- EveryTripleIsARotation
--
-- The capstone of the conic thread, and a repair of something Â§5 of
--
-- â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”
-- THE OVERSELL
--
-- Â§5 says norm-one rotations give "a family of structured identifications
-- of the circle", contrasting with the line, which has none.  True â” but
-- over â the norm-one elements are the four units, so "family" meant
-- four, and four is a thin thing to set against the line's zero.
--
-- The family is infinite, and it is indexed by the Pythagorean triples.
-- That is what this module proves, and it needs no â machinery: one ring
-- identity does it.
--
-- â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”
-- THE STATEMENT
--
--     tripleâ’rotation :  IsTriple u z  â’  (c Â z) Â (c Â z) â‰¡ 1r
--                     â’  N (c âŠ™ u) â‰¡ 1r
--
-- A Pythagorean triple, scaled by the inverse of its hypotenuse, is a
-- point of norm one.  So over any ring in which hypotenuses are
-- invertible â” â, for one â” **every triple is a rotation of the circle**,
-- and by `PythagoreanTransition.rotEquiv` and `ua`, an identification of
-- the circle with itself carrying the norm.
--
-- Composed with `euclid` (every pair squares to a triple) this reads:
--
--     pairâ’rotation :  (c Â N t) Â (c Â N t) â‰¡ 1r
--                   â’  N (c âŠ™ gen t) â‰¡ 1r
--
-- â” every pair t whatsoever, once its norm is invertible, names a
-- rotation.  The parametrisation that produces triples produces the
-- identifications.
--
-- â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”
-- AND IT IS A HOMOMORPHISM ALL THE WAY DOWN
--
--     gen-hom  :  gen (s âŠ— t) â‰¡ gen s âŠ— gen t     (PythagoreanTransition)
--     rot-hom  :  rot (g âŠ— h) â‰¡ rot h âˆ˜ rot g     (here)
--
-- So the chain
--
--     pairs  â”â”genâ”â”â–  triples  â”â”rotâ”â”â–  rotations  â”â”uaâ”â”â–  paths
--
-- is a chain of monoid maps.  Composition of pairs by Brahmagupta's
-- 628 CE law becomes composition of identifications of the circle.  That
-- is what the conic has and the line does not, said at full strength and
-- with the right cardinality this time.
------------------------------------------------------------------------

module EveryTripleIsARotation where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Sigma
open import Cubical.Algebra.CommRing
open import Cubical.Tactics.CommRingSolver.Reflection

open import PythagoreanTransition using (module Circle)
open import DescentIsNotInversion using (module Descent)

private
  variable
    â„“ : Level

module Rotations (R : CommRing â„“) where

  open CommRingStr (snd R)
  open Circle R
  open Descent R using (_âŠ™_ ; N-âŠ™)

  private
    regroup : (c z : A) â†’ (c Â· c) Â· (z Â· z) â‰¡ (c Â· z) Â· (c Â· z)
    regroup c z = solve! R

  ----------------------------------------------------------------------
  -- 1.  A triple, scaled by the inverse of its hypotenuse, is a rotation
  ----------------------------------------------------------------------

  tripleâ†’rotation :
    (c : A) (u : Pair) (z : A)
    â†’ IsTriple u z â†’ (c Â· z) Â· (c Â· z) â‰¡ 1r
    â†’ N (c âŠ™ u) â‰¡ 1r
  tripleâ†’rotation c u z tri unit =
    N-âŠ™ c u âˆ™ cong ((c Â· c) Â·_) tri âˆ™ regroup c z âˆ™ unit

  -- and every pair produces a triple (`euclid`), hence a rotation
  pairâ†’rotation :
    (c : A) (t : Pair)
    â†’ (c Â· N t) Â· (c Â· N t) â‰¡ 1r
    â†’ N (c âŠ™ gen t) â‰¡ 1r
  pairâ†’rotation c t unit = tripleâ†’rotation c (gen t) (N t) (euclid t) unit

  ----------------------------------------------------------------------
  -- 2.  Rotation is a monoid map into endomorphisms
  ----------------------------------------------------------------------

  rot-hom : (g h u : Pair) â†’ rot (g âŠ— h) u â‰¡ rot h (rot g u)
  rot-hom g h u = sym (âŠ—-assoc u g h)

  rot-unit : (u : Pair) â†’ rot one u â‰¡ u
  rot-unit = âŠ—-idÊ³

  ----------------------------------------------------------------------
  -- 3.  The composite: pairs compose into rotations that compose
  --
  -- `gen-hom` says squaring is a monoid map from pairs to triples;
  -- `rot-hom` says rotation is a monoid map from triples to
  -- endomorphisms.  Chaining them:
  ----------------------------------------------------------------------

  gen-rot-hom : (s t u : Pair)
              â†’ rot (gen (s âŠ— t)) u â‰¡ rot (gen t) (rot (gen s) u)
  gen-rot-hom s t u =
    cong (Î» g â†’ rot g u) (gen-hom s t) âˆ™ rot-hom (gen s) (gen t) u

------------------------------------------------------------------------
-- 4.  The sentence, at full strength.
--
--     pairs â”â”genâ”â”â– triples â”â”rotâ”â”â– rotations â”â”uaâ”â”â– paths,
--
-- every arrow a monoid map, every rotation an identification of the
-- circle carrying its norm (`PythagoreanTransition.defect-vanishes`), and
-- the family indexed by every pair whose norm inverts.  Over â that is
-- four; over a ring with ratios it is all of them.
--
-- The line has none of this, and `SuccessorIsNotTropical.disjoint-support`
-- is the proof that it has none.
------------------------------------------------------------------------
