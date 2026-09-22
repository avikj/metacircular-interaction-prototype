{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- EveryTripleIsARotation
--
-- The capstone of the conic line.
--
-- The family is infinite, and it is indexed by the Pythagorean triples.
-- That is what this module proves, and it needs no ℚ machinery: one ring
-- identity does it.
--
-- ────────────────────────────────────────────────────────────────────
-- THE STATEMENT
--
--     triple→rotation :  IsTriple u z  →  (c · z) · (c · z) ≡ 1r
--                     →  N (c ⊙ u) ≡ 1r
--
-- A Pythagorean triple, scaled by the inverse of its hypotenuse, is a
-- point of norm one.  So over any ring in which hypotenuses are
-- invertible — ℚ, for one — **every triple is a rotation of the circle**,
-- and by `PythagoreanTransition.rotEquiv` and `ua`, an identification of
-- the circle with itself carrying the norm.
--
-- Composed with `euclid` (every pair squares to a triple) this reads:
--
--     pair→rotation :  (c · N t) · (c · N t) ≡ 1r
--                   →  N (c ⊙ gen t) ≡ 1r
--
-- — every pair t whatsoever, once its norm is invertible, names a
-- rotation.  The parametrisation that produces triples produces the
-- identifications.
--
-- ────────────────────────────────────────────────────────────────────
-- AND IT IS A HOMOMORPHISM ALL THE WAY DOWN
--
--     gen-hom  :  gen (s ⊗ t) ≡ gen s ⊗ gen t     (PythagoreanTransition)
--     rot-hom  :  rot (g ⊗ h) ≡ rot h ∘ rot g     (here)
--
-- So the chain
--
--     pairs  ──gen──▶  triples  ──rot──▶  rotations  ──ua──▶  paths
--
-- is a chain of monoid maps.  Composition of pairs by Brahmagupta's
-- 628 CE law becomes composition of identifications of the circle.  That
-- is what the conic has and the line does not, said at full strength.
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
    ℓ : Level

module Rotations (R : CommRing ℓ) where

  open CommRingStr (snd R)
  open Circle R
  open Descent R using (_⊙_ ; N-⊙)

  private
    regroup : (c z : A) → (c · c) · (z · z) ≡ (c · z) · (c · z)
    regroup c z = solve! R

  ----------------------------------------------------------------------
  -- 1.  A triple, scaled by the inverse of its hypotenuse, is a rotation
  ----------------------------------------------------------------------

  triple→rotation :
    (c : A) (u : Pair) (z : A)
    → IsTriple u z → (c · z) · (c · z) ≡ 1r
    → N (c ⊙ u) ≡ 1r
  triple→rotation c u z tri unit =
    N-⊙ c u ∙ cong ((c · c) ·_) tri ∙ regroup c z ∙ unit

  -- and every pair produces a triple (`euclid`), hence a rotation
  pair→rotation :
    (c : A) (t : Pair)
    → (c · N t) · (c · N t) ≡ 1r
    → N (c ⊙ gen t) ≡ 1r
  pair→rotation c t unit = triple→rotation c (gen t) (N t) (euclid t) unit

  ----------------------------------------------------------------------
  -- 2.  Rotation is a monoid map into endomorphisms
  ----------------------------------------------------------------------

  rot-hom : (g h u : Pair) → rot (g ⊗ h) u ≡ rot h (rot g u)
  rot-hom g h u = sym (⊗-assoc u g h)

  rot-unit : (u : Pair) → rot one u ≡ u
  rot-unit = ⊗-idʳ

  ----------------------------------------------------------------------
  -- 3.  The composite: pairs compose into rotations that compose
  --
  -- `gen-hom` says squaring is a monoid map from pairs to triples;
  -- `rot-hom` says rotation is a monoid map from triples to
  -- endomorphisms.  Chaining them:
  ----------------------------------------------------------------------

  gen-rot-hom : (s t u : Pair)
              → rot (gen (s ⊗ t)) u ≡ rot (gen t) (rot (gen s) u)
  gen-rot-hom s t u =
    cong (λ g → rot g u) (gen-hom s t) ∙ rot-hom (gen s) (gen t) u

------------------------------------------------------------------------
-- 4.  The sentence, at full strength.
--
--     pairs ──gen──▶ triples ──rot──▶ rotations ──ua──▶ paths,
--
-- every arrow a monoid map, every rotation an identification of the
-- circle carrying its norm (`PythagoreanTransition.defect-vanishes`), and
-- the family indexed by every pair whose norm inverts.  Over ℤ that is
-- four; over a ring with ratios it is all of them.
--
-- The line has none of this, and `SuccessorIsNotTropical.disjoint-support`
-- is the proof that it has none.
------------------------------------------------------------------------
