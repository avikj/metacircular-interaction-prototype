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
-- NaturalMachine.EveryTripleIsARotation
--
-- The capstone of the conic thread, and a repair of something §5 of
-- `notes/THE_BARRIER_BELONGS_TO_THE_LINE.md` oversold.
--
-- ────────────────────────────────────────────────────────────────────
-- THE OVERSELL
--
-- §5 says norm-one rotations give "a family of structured identifications
-- of the circle", contrasting with the line, which has none.  True — but
-- over ℤ the norm-one elements are the four units, so "family" meant
-- four, and four is a thin thing to set against the line's zero.
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
-- is what the conic has and the line does not, said at full strength and
-- with the right cardinality this time.
--
-- WHAT IS NOT CLAIMED.  That ℚ's hypotenuses are invertible is a fact
-- about ℚ quoted from outside; no rational arithmetic is formalised here
-- and `Cubical.Algebra.CommRing.Instances.QuoQ` is not imported.  The
-- theorems below are conditional on the invertibility hypothesis, exactly
-- as stated, and over ℤ that hypothesis holds only for z = ±1 — which is
-- why over ℤ the family really is four, and why the interesting statement
-- needs ratios.  Same price as everywhere else in this thread.
--
-- CHECKED: Agda 2.6.3, cubical v0.5 — the container, not the repository
-- pin.  No postulates, no holes.
------------------------------------------------------------------------

module NaturalMachine.EveryTripleIsARotation where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Sigma
open import Cubical.Algebra.CommRing
open import Cubical.Tactics.CommRingSolver.Reflection

open import NaturalMachine.PythagoreanTransition using (module Circle)
open import NaturalMachine.DescentIsNotInversion using (module Descent)

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
