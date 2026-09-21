{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- DescentIsNotInversion
--
-- A refutation of a conjecture this repository flagged in
-- `IdempotenceForbidsDescent` and did not leave standing for long.
--
-- â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”
-- THE CONJECTURE, AND ITS DEATH
--
-- `IdempotenceForbidsDescent` proves that bhvan, unlike the walk's
-- join, has non-unit invertible elements, and closes by asking whether
-- the cakravla's descent â” its division by k â” IS that inversion.  It
-- marks the identification as unproved.
--
-- It is false, and one line kills it:
--
--     invertibleâ’norm-invertible :  u âŠ— v â‰¡ one  â’  N u Â N v â‰¡ 1r
--
-- Composition multiplies norms, and the unit has norm 1.  So a pair is
-- invertible in the bhvan monoid ONLY IF ITS NORM IS ALREADY A UNIT.
-- The cakravla begins at a state of norm k with k not a unit â” that is
-- the entire situation it exists to escape â” and no composition step can
-- take it to norm 1, because composition can only multiply k by
-- something.  `no-composition-reaches-one` says exactly this.
--
-- So the descent is not inversion in the monoid.  Not "not obviously",
-- not "not in general": provably not, at every state the method actually
-- runs on.
--
-- â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”
-- WHAT DESCENT ACTUALLY IS
--
-- The move is division by the SCALAR k, which is a different structure
-- entirely â” the scaling action of the ring on pairs.  Two identities,
-- both exact:
--
--     N-âŠ™ :  N (c âŠ™ u)      â‰¡ (c Â c) Â N u          homogeneity
--     âŠ™-âŠ— :  (c âŠ™ u) âŠ— v    â‰¡ c âŠ™ (u âŠ— v)            equivariance
--
-- The first is `Composition.normScale` at D = âˆ’1 and says the norm changes by
-- a SQUARE under scaling.  The second says bhvan commutes with scaling,
-- so it descends to the orbits.
--
-- Together they say what the cakravla is doing, and it is not what the
-- previous module guessed:
--
--     **the invariant is not the norm, it is the norm modulo squares.**
--
-- Scaling cannot change that class; composition multiplies it; and
-- "solve xÂ² âˆ’ D yÂ² = 1" is the statement that the class is trivial.
-- Dividing by k is not a step of the group law â” it is the choice of a
-- canonical representative in the orbit, which is why it needs a
-- divisibility condition (`Composition.choiceToNumerator`) rather than an
-- inverse.  On the orbits â” pairs up to scaling, i.e. the RATIONAL POINTS
-- of the conic â” there is no dividing left to do.
--
-- â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”
-- WHAT THIS COSTS THE PREVIOUS TWO MODULES.  Nothing that was proved.
-- `PythagoreanTransition` and `IdempotenceForbidsDescent` both stand; the
-- reversibility dichotomy is untouched.  What dies is the reading of
-- reversibility as cakravla descent, which was labelled a conjecture
-- when written and is now labelled false.  The honest residue is smaller
-- and sharper: the walk has no inverses AND no scaling action, so it has
-- neither of the two mechanisms by which the conic's states come back
-- down.
------------------------------------------------------------------------

module DescentIsNotInversion where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Sigma
open import Cubical.Algebra.CommRing
open import Cubical.Tactics.CommRingSolver.Reflection

open import PythagoreanTransition using (module Circle)

private
  variable
    â„“ : Level

module Descent (R : CommRing â„“) where

  open CommRingStr (snd R)
  open Circle R

  ----------------------------------------------------------------------
  -- 0.  The unit has norm one
  ----------------------------------------------------------------------

  private
    N-one-raw : (1r Â· 1r) + (0r Â· 0r) â‰¡ 1r
    N-one-raw = solve! R

    scale-raw : (c a b : A) â†’ (c Â· a) Â· (c Â· a) + (c Â· b) Â· (c Â· b)
                            â‰¡ (c Â· c) Â· (a Â· a + b Â· b)
    scale-raw c a b = solve! R

    equiv-fst : (c aâ‚ bâ‚ aâ‚‚ bâ‚‚ : A) â†’
        ((c Â· aâ‚) Â· aâ‚‚) - ((c Â· bâ‚) Â· bâ‚‚) â‰¡ c Â· ((aâ‚ Â· aâ‚‚) - (bâ‚ Â· bâ‚‚))
    equiv-fst c aâ‚ bâ‚ aâ‚‚ bâ‚‚ = solve! R

    equiv-snd : (c aâ‚ bâ‚ aâ‚‚ bâ‚‚ : A) â†’
        ((c Â· aâ‚) Â· bâ‚‚) + (aâ‚‚ Â· (c Â· bâ‚)) â‰¡ c Â· ((aâ‚ Â· bâ‚‚) + (aâ‚‚ Â· bâ‚))
    equiv-snd c aâ‚ bâ‚ aâ‚‚ bâ‚‚ = solve! R

  N-one : N one â‰¡ 1r
  N-one = N-one-raw

  ----------------------------------------------------------------------
  -- 1.  THE REFUTATION.  Invertible in the monoid â’ norm already a unit.
  ----------------------------------------------------------------------

  invertibleâ†’norm-invertible :
    (u v : Pair) â†’ u âŠ— v â‰¡ one â†’ N u Â· N v â‰¡ 1r
  invertibleâ†’norm-invertible u v eq = sym (N-âŠ— u v) âˆ™ cong N eq âˆ™ N-one

  -- read as the cakravla reads it: from a state of norm k, no single
  -- composition lands on norm one unless k was invertible to begin with.
  -- The method's whole difficulty is that k is not.
  no-composition-reaches-one :
    (u v : Pair) â†’ u âŠ— v â‰¡ one â†’ Î£[ w âˆˆ A ] N u Â· w â‰¡ 1r
  no-composition-reaches-one u v eq = N v , invertibleâ†’norm-invertible u v eq

  ----------------------------------------------------------------------
  -- 2.  What descent is instead: the scaling action
  ----------------------------------------------------------------------

  infixr 8 _âŠ™_

  _âŠ™_ : A â†’ Pair â†’ Pair
  c âŠ™ u = (c Â· fst u) , (c Â· snd u)

  -- homogeneity: the norm moves by a SQUARE.  (Composition.normScale, D = âˆ’1)
  N-âŠ™ : (c : A) (u : Pair) â†’ N (c âŠ™ u) â‰¡ (c Â· c) Â· N u
  N-âŠ™ c u = scale-raw c (fst u) (snd u)

  -- equivariance: bhvan commutes with scaling, so it descends to orbits
  âŠ™-âŠ— : (c : A) (u v : Pair) â†’ (c âŠ™ u) âŠ— v â‰¡ c âŠ™ (u âŠ— v)
  âŠ™-âŠ— c u v =
    Î£PathP ( equiv-fst c (fst u) (snd u) (fst v) (snd v)
           , equiv-snd c (fst u) (snd u) (fst v) (snd v) )

  ----------------------------------------------------------------------
  -- 3.  The invariant is the norm MODULO SQUARES
  --
  -- `SameClass` is the relation the scaling action can move within.  It
  -- is reflexive by c = 1 and multiplicative under bhvan, and those two
  -- facts are the whole reason the cakravla's k may be divided away.
  ----------------------------------------------------------------------

  SameClass : A â†’ A â†’ Type â„“
  SameClass k k' = Î£[ c âˆˆ A ] (k' â‰¡ (c Â· c) Â· k)

  class-refl : (k : A) â†’ SameClass k k
  class-refl k = 1r , sym (Â·-lid k) âˆ™ cong (_Â· k) (sym (Â·-lid 1r))
    where
    Â·-lid : (x : A) â†’ 1r Â· x â‰¡ x
    Â·-lid x = solve! R

  -- scaling never leaves the class: this is why the division step is
  -- legitimate at all, and it is the exact sense in which k is not data
  -- but a representative.
  scaling-stays-in-class : (c : A) (u : Pair) â†’ SameClass (N u) (N (c âŠ™ u))
  scaling-stays-in-class c u = c , N-âŠ™ c u

  -- and composition acts on classes by multiplying representatives
  class-âŠ— : (u v : Pair) â†’ N (u âŠ— v) â‰¡ N u Â· N v
  class-âŠ— = N-âŠ—

------------------------------------------------------------------------
-- 4.  The residue, stated once.
--
-- Two mechanisms bring a conic state back down: inversion in the group of
-- norm-unit elements, and scaling within a norm class.  The cakravla
-- uses the second, not the first.
--
-- The walk has the first not at all: by `IdempotenceForbidsDescent` its
-- join law has no inverses but the trivial one.
--
-- The second is subtler.  The walk DOES have an equivariant scaling
-- action â€” in the
-- tropical chart it is the shift, and its equivariance is already a
-- checked term in this lane:
--
--     SumProductTorus.âŠ”-+-distrib :  (x âŠ” y) + z â‰¡ (x + z) âŠ” (y + z)
--
-- which under `val` is lcm(a,b)Âc = lcm(aÂc, bÂc).  Scaling is there.
--
-- What is missing is the thing scaling would act on.  Descent needs a
-- NORM: a quantity that composition multiplies and scaling moves by
-- squares, so that its class is an invariant and reaching the trivial
-- class is a goal.  The walk has no such quantity â” its state is its own
-- only invariant.  So the honest statement is not "the walk lacks both
-- mechanisms" but:
--
--     the walk has scaling and no norm; it has no inverses at all; and a
--     scaling action with nothing to reduce is not a descent.
------------------------------------------------------------------------
