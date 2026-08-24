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
-- संयोग-व्यतिकर — collision-interference.  The sum-spectrum "variance"
-- minus the diagonal is EXACTLY the interference produced when the sum
-- map identifies two genuinely different source pairs.  V∞ − D is not a
-- residual to be bounded; it is located, and its location is the
-- collision.  (Owner's zeta-lane message; the exact algebra as a term.)
--
-- THE OBJECTS (REPORT.md Theorem D, the sum-spectrum measure).  At a
-- zero-sum frequency s = γ_i + γ_j the Beta weights W_{ij} accumulate,
-- and two second moments are compared:
--
--   V∞ = Σ_s | Σ_{γ_i+γ_j = s} W_{ij} |²     (variance: group by
--                                             frequency, THEN square)
--   D  = Σ_{i,j} | W_{ij} |²                  (diagonal: the weight each
--                                             source carries alone)
--
-- The owner's sharpening: V∞ = D does NOT say "the zeros are random".
-- It says the sum observation has NO UNDECLARED SOURCE COLLISIONS in
-- the weighted sector.  V∞ − D is the cross term — the interference of
-- distinct pairs {γ_i,γ_j} ≠ {γ_k,γ_l} arriving at one frequency.
--
-- THE EXACT ALGEBRA, at the smallest inhabited collision (two sources
-- landing on ONE frequency), over ℤ (the structural identity needs a
-- ring, not the reals; conjugation is trivial on ℤ, W_{ij}² = |W_{ij}|²
-- for real weights):
--
--   COLLISION   both sources at the same s:  V∞ = (w₀ + w₁)²
--   NO COLLISION distinct s:                 V∞ = w₀² + w₁² = D
--
-- and the theorem:  V∞_collide − D = 2·w₀·w₁, EXACTLY — the located
-- interference — while V∞_distinct − D = 0.  So the difference is the
-- cross term, present precisely when the sum map collides two sources,
-- and it is nonzero whenever both collided weights are (witness at
-- w₀ = w₁ = 1: V∞ = 4, D = 2, interference = 2).
--
-- LEG SYMMETRY is a THIRD, separate multiplicity (the owner's point):
-- (γ_i,γ_j) ↔ (γ_j,γ_i) is reversible transport, declared, and does not
-- enter this cross term — it is the ordered-vs-unordered relabeling, not
-- a collision of distinct unordered pairs.  §3 records it and does not
-- conflate it with संयोग.
--
-- CHECKED under the pin (Agda 2.8.0 + cubical v0.9) for the ℤ ring
-- solver.  Exact, --safe.  No numerics, no bound — an identity.
------------------------------------------------------------------------

module SamyogaVyatikara_TheSumSpectrumVarianceMinusTheDiagonalIsExactlyTheCollisionInterference where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Int using (ℤ; pos; _+_; _·_; _-_; injPos)
open import Cubical.Data.Nat using (snotz)
open import Cubical.Data.Empty as Empty using (⊥)
open import Cubical.Algebra.CommRing using (CommRing)
open import Cubical.Relation.Nullary using (¬_)
open import Cubical.Algebra.CommRing.Instances.Int using (ℤCommRing)
open import Cubical.Tactics.CommRingSolver using (solve!)

private
  -- the diagonal: each source's own weight-square.
  D : ℤ → ℤ → ℤ
  D w₀ w₁ = w₀ · w₀ + w₁ · w₁

  -- the sum-spectrum second moment when BOTH sources land on one
  -- frequency (a collision): group first, then square.
  V∞-collide : ℤ → ℤ → ℤ
  V∞-collide w₀ w₁ = (w₀ + w₁) · (w₀ + w₁)

  -- …and when the two land on DISTINCT frequencies (no collision):
  -- each frequency's group is a singleton, so the square is the square.
  V∞-distinct : ℤ → ℤ → ℤ
  V∞-distinct w₀ w₁ = w₀ · w₀ + w₁ · w₁

------------------------------------------------------------------------
-- §1 · THE LOCATED INTERFERENCE.  V∞ − D = 2 w₀ w₁ exactly, at a
-- collision; the cross term the sum map introduces.

collision-interference : (w₀ w₁ : ℤ)
  → V∞-collide w₀ w₁ - D w₀ w₁ ≡ (pos 2 · w₀) · w₁
collision-interference w₀ w₁ = solve! ℤCommRing

-- §2 · NO COLLISION, NO INTERFERENCE.  Distinct frequencies ⇒ V∞ = D:
-- the difference is exactly zero, with nothing to bound.
no-collision-no-interference : (w₀ w₁ : ℤ)
  → V∞-distinct w₀ w₁ - D w₀ w₁ ≡ pos 0
no-collision-no-interference w₀ w₁ = solve! ℤCommRing

------------------------------------------------------------------------
-- §3 · THE INTERFERENCE IS REAL: nonzero whenever both collided weights
-- are.  At w₀ = w₁ = 1 (pos 1): V∞ = 4, D = 2, interference = 2 ≢ 0.
-- So V∞ = D is a genuine constraint — its failure LOCATES a collision.

interference-witness : V∞-collide (pos 1) (pos 1) - D (pos 1) (pos 1) ≡ pos 2
interference-witness = refl

interference-nonzero : ¬ (V∞-collide (pos 1) (pos 1) - D (pos 1) (pos 1) ≡ pos 0)
interference-nonzero p = snotz (injPos (sym interference-witness ∙ p))

------------------------------------------------------------------------
-- §4 · LEG SYMMETRY IS NOT COLLISION (owner's three-multiplicity point).
-- (γ_i,γ_j) ↔ (γ_j,γ_i) is the ordered relabeling — declared, reversible,
-- and orthogonal to §1.  Modeled: swapping the two source LABELS leaves
-- both D and every V∞ invariant, because both are symmetric in w₀,w₁.
-- This is why leg exchange never enters the cross term: it is transport,
-- not interference.

leg-symmetry-D : (w₀ w₁ : ℤ) → D w₀ w₁ ≡ D w₁ w₀
leg-symmetry-D w₀ w₁ = solve! ℤCommRing

leg-symmetry-V∞ : (w₀ w₁ : ℤ) → V∞-collide w₀ w₁ ≡ V∞-collide w₁ w₀
leg-symmetry-V∞ w₀ w₁ = solve! ℤCommRing
