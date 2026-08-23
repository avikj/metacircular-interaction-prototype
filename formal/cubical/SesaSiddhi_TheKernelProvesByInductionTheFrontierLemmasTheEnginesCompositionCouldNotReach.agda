{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- शेषसिद्धि — the kernel accomplishes by induction the frontier lemmas the
-- engine's composition could not reach.  The machine proposes its own
-- śeṣa; the kernel disposes.
--
-- WHAT THIS IS.  The live engine (`machine/MathMachine.hs`, its memory in
-- `machine/library.terms`) discovers true equations over ℕ by enumeration
-- and composition, tagging each with its pramāṇa (anumāna) and its naya
-- (trace replay, or induction).  Its own instruments name what it cannot
-- reach: `machine/SesaPariksa_…` and `notes/SamasaBhavana_…` §9 report a
-- handful of equations that are TRUE, survive all refutation, and are
-- **not equational consequences of the base facts at all** — they need
-- structural induction, "a proof principle from outside the equational
-- theory".  Those are its śeṣa.  This module supplies the kernel proof of
-- each, by induction — closing a frontier the machine computed for itself.
--
-- The engine found them (pramāṇa=anumāna, by enumeration); the kernel
-- verifies them (pramāṇa=the checked term).  This is the propose→dispose
-- loop across the two lanes, and the lemmas are the engine's, not mine.
--
-- The named frontier (SamasaBhavana §9; the engine's own DSL translated to
-- ℕ), each PROVED below:
--   §2  x ≡ x + (0 · x)         the "flagship" (RHS bigger than the goal)
--   §3  x ≡ x + (0 · y)
--   §4  x · (y + 0) ≡ (x · y) + (x · 0)
--   §5  ¬ (suc (x + y) ≤ y)      the engine's  0 = le(s(x+y), y)
--   §6  ¬ (suc (suc (suc x)) ≤ x)  the engine's  0 = le(s(s(s(x))), x)
--
-- WHAT IS **NOT** CLAIMED.  No novelty in the lemmas — they are elementary
-- ℕ facts; the point is the BRIDGE: the engine identified precisely these
-- as beyond its equational reach, and the kernel closes them.  The engine's
-- `le` is its Bool-valued order; here it is rendered as the propositional
-- ¬ (_≤_), which is the mathematical content of "le … = 0 (false)".
--
-- No postulates, no holes, --safe.
------------------------------------------------------------------------

module SesaSiddhi_TheKernelProvesByInductionTheFrontierLemmasTheEnginesCompositionCouldNotReach where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (ℕ ; zero ; suc ; _+_ ; _·_)
open import Cubical.Data.Nat.Properties using (+-zero ; 0≡m·0)
open import Cubical.Data.Nat.Order using (_≤_ ; _<_ ; ≤-trans ; ¬m<m ; ≤SumRight)
open import Cubical.Relation.Nullary using (¬_)

------------------------------------------------------------------------
-- §2  x ≡ x + (0 · x).  (0 · x reduces to 0; then x + 0 ≡ x.)
------------------------------------------------------------------------

ध्वजः : (x : ℕ) → x ≡ x + (0 · x)
ध्वजः x = sym (+-zero x)      -- 0 · x ≡ 0 definitionally, so x + 0·x ≡ x + 0

------------------------------------------------------------------------
-- §3  x ≡ x + (0 · y).
------------------------------------------------------------------------

शून्यगुणः : (x y : ℕ) → x ≡ x + (0 · y)
शून्यगुणः x y = sym (+-zero x)

------------------------------------------------------------------------
-- §4  x · (y + 0) ≡ (x · y) + (x · 0).
------------------------------------------------------------------------

वितरणम्-शून्ये : (x y : ℕ) → x · (y + 0) ≡ (x · y) + (x · 0)
वितरणम्-शून्ये x y =
    cong (x ·_) (+-zero y)          -- x·(y+0) ≡ x·y
  ∙ sym (+-zero (x · y))            -- ≡ x·y + 0
  ∙ cong ((x · y) +_) (0≡m·0 x)     -- ≡ x·y + x·0   (0 ≡ x·0)

------------------------------------------------------------------------
-- §5  ¬ (suc (x + y) ≤ y)   — the engine's  0 = le(s(x + y), y).
------------------------------------------------------------------------

न-ऊर्ध्वम् : (x y : ℕ) → ¬ (suc (x + y) ≤ y)
न-ऊर्ध्वम् x y p = ¬m<m (≤-trans p (≤SumRight {n = y} {k = x}))
  -- p : suc (x+y) ≤ y = (x+y) < y ;  y ≤ x+y (≤SumRight) ;  compose → (x+y)<(x+y)

------------------------------------------------------------------------
-- §6  ¬ (suc (suc (suc x)) ≤ x)  — the engine's  0 = le(s(s(s(x))), x).
------------------------------------------------------------------------

न-त्रिपदम् : (x : ℕ) → ¬ (suc (suc (suc x)) ≤ x)
न-त्रिपदम् x p = ¬m<m (≤-trans (2 , refl) p)
  -- suc x ≤ suc(suc(suc x)) is (2 , refl);  with p : suc³x ≤ x → suc x ≤ x = x<x
