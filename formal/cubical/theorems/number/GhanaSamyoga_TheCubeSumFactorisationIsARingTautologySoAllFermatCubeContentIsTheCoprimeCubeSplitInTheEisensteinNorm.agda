{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- घनसंयोग — THE CUBE-SUM FACTORISATION IS A RING TAUTOLOGY, SO ALL THE
-- CONTENT OF FERMAT'S CUBE IS THE COPRIME CUBE-SPLIT IN THE EISENSTEIN
-- NORM.
--
-- The exact FLT₃ complement of
-- `PrimePairEquationsAreRingTautologiesSoAllContentIsPrimality…`: there
-- the centred (w±r) prime-pair equations were shown to be ring
-- tautologies, so the whole content of Goldbach/twins sits in the
-- untouched multiplicative predicate.  Here the SAME move for x³+y³:
--
--   cube-sum-factors : x³ + y³ ≡ (x + y)·(x² − x·y + y²),  for ALL x,y,
--
-- one `solve!` over any commutative ring.  The celebrated first step of
-- the n=3 descent — "factor the sum of cubes" — carries NO arithmetic
-- content; it is true of every pair in every ring.  So a solution
-- x³ + y³ ≡ z³ is exactly (x+y)·(x²−x·y+y²) ≡ z³, and everything hard is
-- what happens NEXT: the two factors are coprime up to the single prime 3
-- (Euler's case split), and a coprime product that is a cube forces each
-- factor to be a cube up to a unit — which is unique factorisation in the
-- Eisenstein integers ℤ[ω], ω a primitive cube root of unity, whose norm
-- x²−x·y+y² is the second factor itself.
--
-- THE NORM IS ALREADY THE SECOND FACTOR, AND ALREADY CHECKED.  The
-- second factor x²−x·y+y² is the Eisenstein norm N(x − y·ω) with
-- ω² = −ω − 1; `VargaPrakrti_TraceBhavanaOverN` already proves this
-- norm multiplicative (Brahmagupta–Bhāvanā, at T=−1,C=−1).  So `Avatarana`'s
-- one debt `Descent` factors, precisely, as:
--
--   the tautological cube-sum split      (here, composition)
--   ∘ the coprimality of the two factors  (ℕ/ℤ gcd machinery, present)
--   ∘ CUBE-SPLIT in ℤ[ω]                  (the one genuinely absent lemma)
--   ∘ no-infinite-descent                 (present).
--
-- `CubeSplit` below names that one absent lemma as a type, so the whole
-- of Fermat's cube is pinned to it and nothing else.  This module PROVES
-- the tautology leg and STATES the debt; it does not inhabit `CubeSplit`.
--
-- SYĀT — THE CLAIM, EXACTLY.  One ring identity, for all x,y, over any
-- commutative ring (`solve!`), and one type definition.  NOT claimed:
-- the coprimality reduction, the cube-split, or FLT₃.  What IS claimed is
-- the clarifying negative — the cube-sum factorisation carries no
-- primality/factorisation content, so the difficulty is located entirely
-- in the Eisenstein cube-split, exactly as `PrimePairEquations` located
-- the Goldbach/twin difficulty in the multiplicative predicate.
------------------------------------------------------------------------

module GhanaSamyoga_TheCubeSumFactorisationIsARingTautologySoAllFermatCubeContentIsTheCoprimeCubeSplitInTheEisensteinNorm where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Sigma using (Σ-syntax ; _×_)
open import Cubical.Algebra.CommRing
open import Cubical.Algebra.CommRing.Instances.Int using (ℤCommRing)
open import Cubical.Tactics.CommRingSolver using (solve!)
open import Cubical.Data.Int using (ℤ)

------------------------------------------------------------------------
-- §1  The tautology, over any commutative ring.
------------------------------------------------------------------------

module Tautology {ℓ : Level} (R : CommRing ℓ) where
  open CommRingStr (R .snd)

  private
    K : Type ℓ
    K = R .fst

  cube : K → K
  cube x = x · (x · x)

  -- the Eisenstein norm N(x − yω), ω² = −ω − 1 : the second factor itself
  eisensteinNorm : K → K → K
  eisensteinNorm x y = x · x - x · y + y · y

  -- x³ + y³ = (x + y)·(x² − xy + y²), for ALL x, y.  No arithmetic content.
  cube-sum-factors : (x y : K) → cube x + cube y ≡ (x + y) · eisensteinNorm x y
  cube-sum-factors x y = solve! R

------------------------------------------------------------------------
-- §2  Over ℤ, concretely.
------------------------------------------------------------------------

open Tautology ℤCommRing public

------------------------------------------------------------------------
-- §3  The one absent lemma, named as a type: coprime factors of a cube
--     are each a cube (up to a unit) in the Eisenstein integers.  This
--     is the whole remaining content of Fermat's cube; it is NOT
--     inhabited here.  `Coprime` and `IsCube` are left as parameters so
--     the type records the shape of the debt without importing a ℤ[ω]
--     development that does not yet exist.
------------------------------------------------------------------------

CubeSplit :
    (E : Type)                       -- the Eisenstein integers ℤ[ω]
  → (_·E_ : E → E → E)               -- their multiplication
  → (Coprime : E → E → Type)         -- coprimality in ℤ[ω]
  → (IsCube : E → Type)              -- being a cube up to a unit
  → Type
CubeSplit E _·E_ Coprime IsCube =
  (a b c : E) → Coprime a b → (a ·E b ≡ cube′ c) → IsCube a × IsCube b
  where
  cube′ : E → E
  cube′ x = x ·E (x ·E x)
