{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- स्मृति-बीज — the seed of memory.
--
-- THE TWO-SCALE MEMORY KERNEL IS STRICTLY POSITIVE, ITS RATIO BOUND IS
-- EXACT, AND THE TRUNCATED DOUBLE SUM THAT SUMS IT CLOSES AGAINST ANY
-- INVERSE OF THE SQUARED DEFECT.
--
-- The kernel that pairs two source radii is, after clearing the tenth
-- and the fourth power of the larger radius,
--
--     numerator(s,t)  =  min · ( 3·max³  -  2·min³ ) .
--
-- Its strict positivity — the whole reason a nonnegative shell profile
-- has strictly positive memory — is one inequality between two cubes,
-- and it holds over ℕ with no analysis whatsoever:
--
--   §1  0 < t  and  s ≤ t   ⟹   2·s³ < 3·t³ .
--
--       So the bracket never vanishes and never turns: at the extreme
--       s ≡ t it is still t³ > 0, and it only grows as the radii
--       separate.  No integral, no limit, no ordered field — the
--       positivity claimed for the kernel is a statement about two
--       natural numbers.
--
--   §2  AND THE RATIO BOUND IS EXACT, in the subtraction-free form:
--       writing the bracket as `d` with `2·s³ + d ≡ 3·t³`, the numerator
--       obeys  s·d ≤ s·(3·t³).  This is the bound the geometric shell
--       tower is summed against, and it is an equality up to exactly the
--       `2·s³` that was moved to the other side — nothing is discarded.
--
--   §3  THE TRUNCATED DOUBLE SUM CLOSES.  `SesaDvaya` proves
--
--         (1-x)² · Σ_{j≤N}(j+1)xʲ  ≡  1 - (N+2)x^{N+1} + (N+1)x^{N+2}
--
--       exactly, at every depth.  Whenever `(1-x)²` has an inverse `c`,
--       that identity IS the closed form:
--
--         Σ_{j≤N}(j+1)xʲ  ≡  c · ( 1 - (N+2)x^{N+1} + (N+1)x^{N+2} ) ,
--
--       with no numerals, no division, and no convergence.  The
--       geometric ratio and the resulting constant are then a
--       substitution the reader performs in whatever ring has them; the
--       theorem does not need them and does not name them.
--
-- WHAT THESE TWO HALVES ARE DOING TOGETHER.  §§1–2 say the memory
-- kernel is positive and controlled by the radius ratio; §3 says the
-- sum of a geometric tower against such a control has an exact closed
-- form at every truncation depth.  The finiteness conclusion drawn from
-- them is a bound on a limit and needs an ordered complete field; it is
-- not asserted here.  What is asserted is that neither the positivity
-- nor the closed form is where that analysis is needed — both are
-- algebra, and both are checked.
--
-- SYĀT — THE CLAIM, EXACTLY.  §§1–2 in ℕ, for every pair of radii.  §3
-- in any commutative ring, for every element, every inverse of its
-- squared defect, and every depth.  NOT claimed: that the kernel IS the
-- pairing of two radial profiles — that identification is an integral
-- and is taken as given; the polarised value of the kernel, likewise;
-- convergence or the value of any infinite sum — §3 is at finite N and
-- no limit is taken; that `(1-x)²` HAS an inverse, which is a hypothesis
-- carried in the open; and nothing about the sign or magnitude of any
-- strain, which needs the integrals this file does not have.
------------------------------------------------------------------------

module SmrtiBija_TheTwoScaleMemoryKernelIsStrictlyPositiveAndItsRatioBoundIsExactAndTheTruncatedDoubleSumClosesAgainstAnyInverse where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Structure using (⟨_⟩)
open import Cubical.Data.Nat using (ℕ ; zero ; suc ; ·-comm)
  renaming (_+_ to _+ℕ_ ; _·_ to _·ℕ_)
open import Cubical.Data.Nat.Order
  using (_<_ ; _≤_ ; ≤-refl ; ≤-trans ; ≤<-trans ; ≤-·k ; ¬-<-zero
        ; suc-≤-suc ; zero-≤)
open import Cubical.Data.Sigma using (Σ-syntax ; _,_ ; fst ; snd)
open import Cubical.Data.Empty using (⊥) renaming (rec to ⊥-rec)
open import Cubical.Algebra.CommRing
open import Cubical.Tactics.NatSolver using (solveℕ!)

import SesaDvaya_TheTruncatedInverseOfTheSquaredShiftDefectHasAResidualOfExactlyTwoTermsAtEveryDepth as SD

private
  variable
    ℓ : Level

------------------------------------------------------------------------
-- PART ONE · The kernel, in ℕ.
------------------------------------------------------------------------

private
  ·-positive : (a b : ℕ) → 0 < a → 0 < b → 0 < (a ·ℕ b)
  ·-positive zero    b       p q = ⊥-rec (¬-<-zero p)
  ·-positive (suc a) zero    p q = ⊥-rec (¬-<-zero q)
  ·-positive (suc a) (suc b) p q = suc-≤-suc zero-≤

  mul-mono : (a b c d : ℕ) → a ≤ b → c ≤ d → (a ·ℕ c) ≤ (b ·ℕ d)
  mul-mono a b c d p q =
    ≤-trans (≤-·k p)
            (subst2 _≤_ (·-comm c b) (·-comm d b) (≤-·k q))

  two<three : (m : ℕ) → 0 < m → (2 ·ℕ m) < (3 ·ℕ m)
  two<three zero    p = ⊥-rec (¬-<-zero p)
  two<three (suc j) _ = j , wit j
    where
      wit : (n : ℕ) → n +ℕ suc (2 ·ℕ suc n) ≡ 3 ·ℕ suc n
      wit n = solveℕ!

cube : ℕ → ℕ
cube n = n ·ℕ (n ·ℕ n)

cube-mono : (s t : ℕ) → s ≤ t → cube s ≤ cube t
cube-mono s t h = mul-mono s t (s ·ℕ s) (t ·ℕ t) h (mul-mono s t s t h h)

cube-positive : (t : ℕ) → 0 < t → 0 < cube t
cube-positive t p = ·-positive t (t ·ℕ t) p (·-positive t t p p)

------------------------------------------------------------------------
-- १ · THE KERNEL BRACKET IS STRICTLY POSITIVE.
------------------------------------------------------------------------

kernel-bracket-positive : (s t : ℕ) → 0 < t → s ≤ t
  → (2 ·ℕ cube s) < (3 ·ℕ cube t)
kernel-bracket-positive s t pt h =
  ≤<-trans (mul-mono 2 2 (cube s) (cube t) ≤-refl (cube-mono s t h))
           (two<three (cube t) (cube-positive t pt))

------------------------------------------------------------------------
-- २ · AND THE RATIO BOUND IS EXACT, WITHOUT SUBTRACTION.
------------------------------------------------------------------------

kernel-ratio-bound : (s t d : ℕ)
  → (2 ·ℕ cube s) +ℕ d ≡ 3 ·ℕ cube t
  → (s ·ℕ d) ≤ (s ·ℕ (3 ·ℕ cube t))
kernel-ratio-bound s t d e =
  mul-mono s s d (3 ·ℕ cube t) ≤-refl ((2 ·ℕ cube s) , e)

------------------------------------------------------------------------
-- PART TWO · The truncated double sum closes.
------------------------------------------------------------------------

module _ (R : CommRing ℓ) where
  open CommRingStr (snd R)

  private
    A : Type ℓ
    A = ⟨ R ⟩

  ------------------------------------------------------------------
  -- ३ · AGAINST ANY INVERSE OF THE SQUARED DEFECT.
  ------------------------------------------------------------------

  closed-form : (c x : A) (N : ℕ)
    → c · SD.sq R x ≡ 1r
    → SD.arith R x N ≡ c · SD.Res R x N
  closed-form c x N h =
      sym (·IdL (SD.arith R x N))
    ∙ cong (_· SD.arith R x N) (sym h)
    ∙ sym (·Assoc c (SD.sq R x) (SD.arith R x N))
    ∙ cong (c ·_) (SD.truncated-inverse R x N)
