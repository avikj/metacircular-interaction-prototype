{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- WalkObservationCount
--
-- `LosslessLowerBound` bounds every observation scheme from below.
-- `TheGapWasAUnitsError` checks the walk attains that bound at frontiers
-- 4, 5, 7, 8 â” but it checks it by EVALUATING `val`, i.e. by computing
-- that the state's number happens to be the input count.  That is a
-- coincidence of arithmetic as far as those terms are concerned.
--
-- This module supplies the mechanism.  The walk does not store a number;
-- it stores a RESIDUE VECTOR, one component per installed prime power.
-- Its observation space at frontier 8 is
--
--     Fin 8 — Fin 3 — Fin 5 — Fin 7,
--
-- and the reason that has exactly 840 elements â” exactly `cap 8`, exactly
-- the number of inputs it must separate â” is the Chinese remainder
-- theorem, applied three times.
--
-- â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”
-- PRIOR ART, USED RATHER THAN REBUILT
--
-- `formal/cubical/FinCardinality.agda` already has CRT in exactly the
-- form needed â” `crtEquiv m n : isGCD (suc m) (suc n) 1 â’ Fin (suc m Â
-- suc n) â‰ Fin (suc m) — Fin (suc n)` â” proved not by hand-building a
-- surjection but by the counting principle (an injection between finite
-- sets of equal cardinality is an equivalence). Nothing below reproves
-- any of it.
--
-- â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”
-- WHAT THIS COMPLETES
--
--   LosslessLowerBound   any lossless scheme needs â‰ n+1 outcomes
--   here                 the walk's scheme HAS exactly cap 8 outcomes,
--                        by CRT, at frontier 8
--   TheGapWasAUnitsError the walk runs to exactly cap 8 âˆ’ 1
--
-- Three terms, and together they are the word "optimal" with nothing left
-- quoted at frontier 8: a bound over all schemes, a count for this one,
-- and an attainment.
------------------------------------------------------------------------

module WalkObservationCount where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Equiv using (_â‰ƒ_ ; compEquiv ; invEquiv)
open import Cubical.Data.Nat using (â„•)
open import Cubical.Data.Nat.GCD using (isGCD ; gcdâ‰¡â†’isGCD)
open import Cubical.Data.Fin using (Fin)
open import Cubical.Data.Sigma using (_Ã—_ ; â‰ƒ-Ã— )

open import FinCardinality using (crtEquiv)

------------------------------------------------------------------------
-- 1.  The installed prime powers at frontier 8, pairwise coprime by
--     computation of the gcd.
------------------------------------------------------------------------

cop-8-3 : isGCD 8 3 1
cop-8-3 = gcdâ‰¡â†’isGCD refl

cop-24-5 : isGCD 24 5 1
cop-24-5 = gcdâ‰¡â†’isGCD refl

cop-120-7 : isGCD 120 7 1
cop-120-7 = gcdâ‰¡â†’isGCD refl

------------------------------------------------------------------------
-- 2.  CRT, three times
------------------------------------------------------------------------

crt-8-3 : Fin 24 â‰ƒ (Fin 8 Ã— Fin 3)
crt-8-3 = crtEquiv 7 2 cop-8-3

crt-24-5 : Fin 120 â‰ƒ (Fin 24 Ã— Fin 5)
crt-24-5 = crtEquiv 23 4 cop-24-5

crt-120-7 : Fin 840 â‰ƒ (Fin 120 Ã— Fin 7)
crt-120-7 = crtEquiv 119 6 cop-120-7

------------------------------------------------------------------------
-- 3.  THE WALK'S OBSERVATION SPACE AT FRONTIER 8.
--
-- 840 inputs, and the residue vector against the installed moduli takes
-- exactly 840 values.  Not "the number happens to be 840": the space is
-- equivalent to the inputs, by CRT.
------------------------------------------------------------------------

walk-observation-space :
  Fin 840 â‰ƒ (((Fin 8 Ã— Fin 3) Ã— Fin 5) Ã— Fin 7)
walk-observation-space =
  compEquiv crt-120-7
    (â‰ƒ-Ã— (compEquiv crt-24-5 (â‰ƒ-Ã— crt-8-3 (idEquiv (Fin 5))))
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
-- PROVENANCE.  The simultaneous-congruence result this module runs on:
--
-- The **kuaka** (*ryabhaya* 2.32â“33, 499 CE) is a general
-- constructive method for exactly this problem â” given remainders against
-- two moduli, produce the number â” and Brahmagupta (628) and Bhskara II
-- (1150) extend it.  The *Sun Zi Suanjing* (c. 3rdâ“5th c.) poses the
-- problem with a rule for a special case; Qin Jiushao's general method is
-- 1247.  Both traditions have it, and this file's own chain runs on the
-- Indian one: `CoprimePowers`, `BezoutIsGCD` and `CoprimePowersN` all
-- carry B©zout certificates, which is what the pulveriser returns.
------------------------------------------------------------------------
