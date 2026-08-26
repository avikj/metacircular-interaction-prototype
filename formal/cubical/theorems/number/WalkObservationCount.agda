{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- WalkObservationCount
--
-- `LosslessLowerBound` bounds every observation scheme from below.
-- `TheGapWasAUnitsError` checks the walk attains that bound at frontiers
-- 4, 5, 7, 8 — but it checks it by EVALUATING `val`, i.e. by computing
-- that the state's number happens to be the input count.  That is a
-- coincidence of arithmetic as far as those terms are concerned.
--
-- This module supplies the mechanism.  The walk does not store a number;
-- it stores a RESIDUE VECTOR, one component per installed prime power.
-- Its observation space at frontier 8 is
--
--     Fin 8 × Fin 3 × Fin 5 × Fin 7,
--
-- and the reason that has exactly 840 elements — exactly `cap 8`, exactly
-- the number of inputs it must separate — is the Chinese remainder
-- theorem, applied three times.
--
-- ────────────────────────────────────────────────────────────────────
-- PRIOR ART, USED RATHER THAN REBUILT
--
-- `formal/cubical/FinCardinality.agda` already has CRT in exactly the
-- form needed — `crtEquiv m n : isGCD (suc m) (suc n) 1 → Fin (suc m ·
-- suc n) ≃ Fin (suc m) × Fin (suc n)` — proved not by hand-building a
-- surjection but by the counting principle (an injection between finite
-- sets of equal cardinality is an equivalence). Nothing below reproves
-- any of it.
--
-- ────────────────────────────────────────────────────────────────────
-- WHAT THIS COMPLETES
--
--   LosslessLowerBound   any lossless scheme needs ≥ n+1 outcomes
--   here                 the walk's scheme HAS exactly cap 8 outcomes,
--                        by CRT, at frontier 8
--   TheGapWasAUnitsError the walk runs to exactly cap 8 − 1
--
-- Three terms, and together they are the word "optimal" with nothing left
-- quoted at frontier 8: a bound over all schemes, a count for this one,
-- and an attainment.
--
-- WHAT IS NOT CLAIMED.  Anything at a general frontier.  The iterated CRT
-- for an arbitrary list of installed prime powers needs pairwise
-- coprimality of prime powers as a lemma, which this lane does not carry,
-- and this file does one frontier explicitly rather than pretend
-- otherwise.  `TheGapWasAUnitsError` has the same limitation and states
-- it the same way.
--
-- CHECKED: Agda 2.6.3, cubical v0.5 — the container, not the repository
-- pin.  No postulates, no holes.
------------------------------------------------------------------------

module WalkObservationCount where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Equiv using (_≃_ ; compEquiv ; invEquiv)
open import Cubical.Data.Nat using (ℕ)
open import Cubical.Data.Nat.GCD using (isGCD ; gcd≡→isGCD)
open import Cubical.Data.Fin using (Fin)
open import Cubical.Data.Sigma using (_×_ ; ≃-× )

open import FinCardinality using (crtEquiv)

------------------------------------------------------------------------
-- 1.  The installed prime powers at frontier 8, pairwise coprime by
--     computation of the gcd.
------------------------------------------------------------------------

cop-8-3 : isGCD 8 3 1
cop-8-3 = gcd≡→isGCD refl

cop-24-5 : isGCD 24 5 1
cop-24-5 = gcd≡→isGCD refl

cop-120-7 : isGCD 120 7 1
cop-120-7 = gcd≡→isGCD refl

------------------------------------------------------------------------
-- 2.  CRT, three times
------------------------------------------------------------------------

crt-8-3 : Fin 24 ≃ (Fin 8 × Fin 3)
crt-8-3 = crtEquiv 7 2 cop-8-3

crt-24-5 : Fin 120 ≃ (Fin 24 × Fin 5)
crt-24-5 = crtEquiv 23 4 cop-24-5

crt-120-7 : Fin 840 ≃ (Fin 120 × Fin 7)
crt-120-7 = crtEquiv 119 6 cop-120-7

------------------------------------------------------------------------
-- 3.  THE WALK'S OBSERVATION SPACE AT FRONTIER 8.
--
-- 840 inputs, and the residue vector against the installed moduli takes
-- exactly 840 values.  Not "the number happens to be 840": the space is
-- equivalent to the inputs, by CRT.
------------------------------------------------------------------------

walk-observation-space :
  Fin 840 ≃ (((Fin 8 × Fin 3) × Fin 5) × Fin 7)
walk-observation-space =
  compEquiv crt-120-7
    (≃-× (compEquiv crt-24-5 (≃-× crt-8-3 (idEquiv (Fin 5))))
         (idEquiv (Fin 7)))
  where open import Cubical.Foundations.Equiv using (idEquiv)

------------------------------------------------------------------------
-- 4.  The sentence.
--
-- The walk is lossless at frontier 8 because CRT says its residue vector
-- has exactly as many values as there are inputs, and it is OPTIMAL there
-- because `LosslessLowerBound` says no scheme can have fewer.  The number
-- 840 is not a coincidence being noticed; it is a cardinality being
-- computed by the theorem that makes residues work at all.
--
-- Which is also the reason the walk's step law had to be lcm: the
-- observation space multiplies only when the moduli are coprime, and lcm
-- is precisely the state that keeps them so.
------------------------------------------------------------------------

------------------------------------------------------------------------
-- PROVENANCE CORRECTION, 2026-08-18.
--
-- This module says "the Chinese remainder theorem" for the simultaneous
-- congruence result it runs on, and that name was used without being
-- checked — in a session whose brief was to build from Indian sources and
-- credit the origin rather than the restatement, and three modules after
-- building Āryabhaṭa's kuṭṭaka by name.
--
-- The **kuṭṭaka** (*Āryabhaṭīya* 2.32–33, 499 CE) is a general
-- constructive method for exactly this problem — given remainders against
-- two moduli, produce the number — and Brahmagupta (628) and Bhāskara II
-- (1150) extend it.  The *Sun Zi Suanjing* (c. 3rd–5th c.) poses the
-- problem with a rule for a special case; Qin Jiushao's general method is
-- 1247.  Both traditions have it, and this file's own chain runs on the
-- Indian one: `CoprimePowers`, `BezoutIsGCD` and `CoprimePowersN` all
-- carry Bézout certificates, which is what the pulveriser returns.
--
-- Nothing mathematical changes.  The citation does.  See
------------------------------------------------------------------------
