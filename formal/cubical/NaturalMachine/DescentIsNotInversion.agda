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
-- NaturalMachine.DescentIsNotInversion
--
-- A refutation of a conjecture this repository flagged in
-- `IdempotenceForbidsDescent` and did not leave standing for long.
--
-- ────────────────────────────────────────────────────────────────────
-- THE CONJECTURE, AND ITS DEATH
--
-- `IdempotenceForbidsDescent` proves that bhāvanā, unlike the walk's
-- join, has non-unit invertible elements, and closes by asking whether
-- the cakravāla's descent — its division by k — IS that inversion.  It
-- marks the identification as unproved.
--
-- It is false, and one line kills it:
--
--     invertible→norm-invertible :  u ⊗ v ≡ one  →  N u · N v ≡ 1r
--
-- Composition multiplies norms, and the unit has norm 1.  So a pair is
-- invertible in the bhāvanā monoid ONLY IF ITS NORM IS ALREADY A UNIT.
-- The cakravāla begins at a state of norm k with k not a unit — that is
-- the entire situation it exists to escape — and no composition step can
-- take it to norm 1, because composition can only multiply k by
-- something.  `no-composition-reaches-one` says exactly this.
--
-- So the descent is not inversion in the monoid.  Not "not obviously",
-- not "not in general": provably not, at every state the method actually
-- runs on.
--
-- ────────────────────────────────────────────────────────────────────
-- WHAT DESCENT ACTUALLY IS
--
-- The move is division by the SCALAR k, which is a different structure
-- entirely — the scaling action of the ring on pairs.  Two identities,
-- both exact:
--
--     N-⊙ :  N (c ⊙ u)      ≡ (c · c) · N u          homogeneity
--     ⊙-⊗ :  (c ⊙ u) ⊗ v    ≡ c ⊙ (u ⊗ v)            equivariance
--
-- The first is `Bhavana.normScale` at D = −1 and says the norm changes by
-- a SQUARE under scaling.  The second says bhāvanā commutes with scaling,
-- so it descends to the orbits.
--
-- Together they say what the cakravāla is doing, and it is not what the
-- previous module guessed:
--
--     **the invariant is not the norm, it is the norm modulo squares.**
--
-- Scaling cannot change that class; composition multiplies it; and
-- "solve x² − D y² = 1" is the statement that the class is trivial.
-- Dividing by k is not a step of the group law — it is the choice of a
-- canonical representative in the orbit, which is why it needs a
-- divisibility condition (`Bhavana.choiceToNumerator`) rather than an
-- inverse.  On the orbits — pairs up to scaling, i.e. the RATIONAL POINTS
-- of the conic — there is no dividing left to do.
--
-- ────────────────────────────────────────────────────────────────────
-- WHAT THIS COSTS THE PREVIOUS TWO MODULES.  Nothing that was proved.
-- `PythagoreanTransition` and `IdempotenceForbidsDescent` both stand; the
-- reversibility dichotomy is untouched.  What dies is the reading of
-- reversibility as cakravāla descent, which was labelled a conjecture
-- when written and is now labelled false.  The honest residue is smaller
-- and sharper: the walk has no inverses AND no scaling action, so it has
-- neither of the two mechanisms by which the conic's states come back
-- down.
--
-- CHECKED: Agda 2.6.3, cubical v0.5 — the container, not the repository
-- pin.  No postulates, no holes.
------------------------------------------------------------------------

module NaturalMachine.DescentIsNotInversion where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Sigma
open import Cubical.Algebra.CommRing
open import Cubical.Tactics.CommRingSolver.Reflection

open import NaturalMachine.PythagoreanTransition using (module Circle)

private
  variable
    ℓ : Level

module Descent (R : CommRing ℓ) where

  open CommRingStr (snd R)
  open Circle R

  ----------------------------------------------------------------------
  -- 0.  The unit has norm one
  ----------------------------------------------------------------------

  private
    N-one-raw : (1r · 1r) + (0r · 0r) ≡ 1r
    N-one-raw = solve! R

    scale-raw : (c a b : A) → (c · a) · (c · a) + (c · b) · (c · b)
                            ≡ (c · c) · (a · a + b · b)
    scale-raw c a b = solve! R

    equiv-fst : (c a₁ b₁ a₂ b₂ : A) →
        ((c · a₁) · a₂) - ((c · b₁) · b₂) ≡ c · ((a₁ · a₂) - (b₁ · b₂))
    equiv-fst c a₁ b₁ a₂ b₂ = solve! R

    equiv-snd : (c a₁ b₁ a₂ b₂ : A) →
        ((c · a₁) · b₂) + (a₂ · (c · b₁)) ≡ c · ((a₁ · b₂) + (a₂ · b₁))
    equiv-snd c a₁ b₁ a₂ b₂ = solve! R

  N-one : N one ≡ 1r
  N-one = N-one-raw

  ----------------------------------------------------------------------
  -- 1.  THE REFUTATION.  Invertible in the monoid ⇒ norm already a unit.
  ----------------------------------------------------------------------

  invertible→norm-invertible :
    (u v : Pair) → u ⊗ v ≡ one → N u · N v ≡ 1r
  invertible→norm-invertible u v eq = sym (N-⊗ u v) ∙ cong N eq ∙ N-one

  -- read as the cakravāla reads it: from a state of norm k, no single
  -- composition lands on norm one unless k was invertible to begin with.
  -- The method's whole difficulty is that k is not.
  no-composition-reaches-one :
    (u v : Pair) → u ⊗ v ≡ one → Σ[ w ∈ A ] N u · w ≡ 1r
  no-composition-reaches-one u v eq = N v , invertible→norm-invertible u v eq

  ----------------------------------------------------------------------
  -- 2.  What descent is instead: the scaling action
  ----------------------------------------------------------------------

  infixr 8 _⊙_

  _⊙_ : A → Pair → Pair
  c ⊙ u = (c · fst u) , (c · snd u)

  -- homogeneity: the norm moves by a SQUARE.  (Bhavana.normScale, D = −1)
  N-⊙ : (c : A) (u : Pair) → N (c ⊙ u) ≡ (c · c) · N u
  N-⊙ c u = scale-raw c (fst u) (snd u)

  -- equivariance: bhāvanā commutes with scaling, so it descends to orbits
  ⊙-⊗ : (c : A) (u v : Pair) → (c ⊙ u) ⊗ v ≡ c ⊙ (u ⊗ v)
  ⊙-⊗ c u v =
    ΣPathP ( equiv-fst c (fst u) (snd u) (fst v) (snd v)
           , equiv-snd c (fst u) (snd u) (fst v) (snd v) )

  ----------------------------------------------------------------------
  -- 3.  The invariant is the norm MODULO SQUARES
  --
  -- `SameClass` is the relation the scaling action can move within.  It
  -- is reflexive by c = 1 and multiplicative under bhāvanā, and those two
  -- facts are the whole reason the cakravāla's k may be divided away.
  ----------------------------------------------------------------------

  SameClass : A → A → Type ℓ
  SameClass k k' = Σ[ c ∈ A ] (k' ≡ (c · c) · k)

  class-refl : (k : A) → SameClass k k
  class-refl k = 1r , sym (·-lid k) ∙ cong (_· k) (sym (·-lid 1r))
    where
    ·-lid : (x : A) → 1r · x ≡ x
    ·-lid x = solve! R

  -- scaling never leaves the class: this is why the division step is
  -- legitimate at all, and it is the exact sense in which k is not data
  -- but a representative.
  scaling-stays-in-class : (c : A) (u : Pair) → SameClass (N u) (N (c ⊙ u))
  scaling-stays-in-class c u = c , N-⊙ c u

  -- and composition acts on classes by multiplying representatives
  class-⊗ : (u v : Pair) → N (u ⊗ v) ≡ N u · N v
  class-⊗ = N-⊗

------------------------------------------------------------------------
-- 4.  The residue, stated once.
--
-- Two mechanisms bring a conic state back down: inversion in the group of
-- norm-unit elements, and scaling within a norm class.  The cakravāla
-- uses the second, not the first — the conjecture in the previous module
-- named the first and is hereby withdrawn.
--
-- The walk has the first not at all: by `IdempotenceForbidsDescent` its
-- join law has no inverses but the trivial one.
--
-- The second is subtler, and the first draft of this paragraph got it
-- wrong.  The walk DOES have an equivariant scaling action — in the
-- tropical chart it is the shift, and its equivariance is already a
-- checked term in this lane:
--
--     SumProductTorus.⊔-+-distrib :  (x ⊔ y) + z ≡ (x + z) ⊔ (y + z)
--
-- which under `val` is lcm(a,b)·c = lcm(a·c, b·c).  Scaling is there.
--
-- What is missing is the thing scaling would act on.  Descent needs a
-- NORM: a quantity that composition multiplies and scaling moves by
-- squares, so that its class is an invariant and reaching the trivial
-- class is a goal.  The walk has no such quantity — its state is its own
-- only invariant.  So the honest statement is not "the walk lacks both
-- mechanisms" but:
--
--     the walk has scaling and no norm; it has no inverses at all; and a
--     scaling action with nothing to reduce is not a descent.
--
-- Whether the walk admits a norm is open, is the sharpest form of the
-- question these three modules have been circling, and is not touched
-- here.
------------------------------------------------------------------------
