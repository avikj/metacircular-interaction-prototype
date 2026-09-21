{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- CRTChain
--
-- `WalkObservationCount` counts the walk's residue space at frontier 8 by
-- composing `FinCardinality.crtEquiv` three times, by hand, and its
-- "not claimed" says the general frontier is out of reach because
-- pairwise coprimality of prime powers is not available in this lane.
--
-- Half of that was true and half was scaffolding.  The CRT chain itself
-- generalises to any list of moduli; what is missing is only the number
-- theory that supplies the coprimality data.  This module separates the
-- two, so that a general frontier costs exactly one gcd computation per
-- installed modulus and no new CRT reasoning at all.
--
-- â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”
-- THE STATEMENT
--
--     crtChain : (ms : List â•) â’ Coprimes ms
--              â’ Fin (suc (Prod ms)) â‰ Vec ms
--
-- where a modulus is written as its predecessor (so every modulus is
-- positive by construction), `Prod` is the predecessor of the product,
-- `Vec` is the residue vector, and `Coprimes ms` asks only that each head
-- be coprime to the product of its tail â” which is what a walk supplies
-- by computation, one `gcdâ‰¡â’isGCD refl` per install.
--
-- â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”
--
-- Here the coprimality is a hypothesis, and at any concrete frontier it is
-- discharged by computing a gcd.
------------------------------------------------------------------------

module CRTChain where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Equiv using (_â‰ƒ_ ; compEquiv ; idEquiv ; isContrâ†’Equiv)
open import Cubical.Data.Nat using (â„• ; zero ; suc ; _+_ ; _Â·_ ; Â·-suc)
open import Cubical.Data.Nat.GCD using (isGCD ; gcdâ‰¡â†’isGCD)
open import Cubical.Data.Fin using (Fin)
open import Cubical.Data.Fin.Properties using (isContrFin1)
open import Cubical.Data.List using (List ; [] ; _âˆ·_)
open import Cubical.Data.Sigma using (_Ã—_ ; â‰ƒ-Ã—)
open import Cubical.Data.Unit using (Unit ; isContrUnit)
open import Cubical.Tactics.NatSolver.Reflection using (solveâ„•!)

open import FinCardinality using (crtEquiv)

------------------------------------------------------------------------
-- 1.  Moduli by their predecessors, so positivity is structural
------------------------------------------------------------------------

-- the PREDECESSOR of the product: the product itself is `suc (Prod ms)`
Prod : List â„• â†’ â„•
Prod []       = 0
Prod (m âˆ· ms) = (m + Prod ms) + m Â· Prod ms

-- (m+1)(p+1) = 1 + (m + p) + mÂp
prodStep : (m p : â„•) â†’ suc m Â· suc p â‰¡ suc ((m + p) + m Â· p)
prodStep m p = cong (suc p +_) (Â·-suc m p) âˆ™ cong suc (rearr m p)
  where
  rearr : (a b : â„•) â†’ b + (a + a Â· b) â‰¡ (a + b) + a Â· b
  rearr a b = solveâ„•!

-- the residue vector against the moduli
Vec : List â„• â†’ Type
Vec []       = Unit
Vec (m âˆ· ms) = Fin (suc m) Ã— Vec ms

-- each head coprime to the product of its tail â” one gcd per install
Coprimes : List â„• â†’ Type
Coprimes []       = Unit
Coprimes (m âˆ· ms) = isGCD (suc m) (suc (Prod ms)) 1 Ã— Coprimes ms

------------------------------------------------------------------------
-- 2.  THE CHAIN
------------------------------------------------------------------------

crtChain : (ms : List â„•) â†’ Coprimes ms â†’ Fin (suc (Prod ms)) â‰ƒ Vec ms
crtChain []       _           = isContrâ†’Equiv isContrFin1 isContrUnit
crtChain (m âˆ· ms) (cop , rest) =
  subst (Î» k â†’ Fin k â‰ƒ Vec (m âˆ· ms)) (prodStep m (Prod ms))
    (compEquiv (crtEquiv m (Prod ms) cop)
               (â‰ƒ-Ã— (idEquiv (Fin (suc m))) (crtChain ms rest)))

------------------------------------------------------------------------
-- 3.  It reproduces `WalkObservationCount` at frontier 8, from the same
--     three gcd computations and no hand composition.
--
--     moduli 8, 3, 5, 7  â¦  predecessors 7, 2, 4, 6
--     product 840        â¦  Prod = 839
------------------------------------------------------------------------

walk8 : List â„•
walk8 = 7 âˆ· 2 âˆ· 4 âˆ· 6 âˆ· []

walk8-prod : Prod walk8 â‰¡ 839
walk8-prod = refl

walk8-coprimes : Coprimes walk8
walk8-coprimes =
    gcdâ‰¡â†’isGCD refl
  , gcdâ‰¡â†’isGCD refl
  , gcdâ‰¡â†’isGCD refl
  , gcdâ‰¡â†’isGCD refl
  , _

walk8-residues : Fin 840 â‰ƒ Vec walk8
walk8-residues = crtChain walk8 walk8-coprimes

------------------------------------------------------------------------
-- 4.  What this buys.
--
-- A frontier is now four lines: list the installed moduli, compute the
-- gcds, apply `crtChain`.  `WalkObservationCount`'s hand-built
-- three-step composition was the scaffolding, not the mathematics, and
-- the mathematics that remains missing is exactly one theorem â”
-- that distinct prime powers are coprime â” which is Euclid's lemma and
-- has `Kuttaka.bezout` waiting for it.
------------------------------------------------------------------------

------------------------------------------------------------------------
-- PROVENANCE CORRECTION, 2026-08-18.
--
-- This module says "the Chinese remainder theorem" for the simultaneous
-- congruence result it runs on, and that name was used without being
-- checked â” in a session whose brief was to build from Indian sources and
-- credit the origin rather than the restatement, and three modules after
-- building ryabhaa's kuaka by name.
--
-- The **kuaka** (*ryabhaya* 2.32â“33, 499 CE) is a general
-- constructive method for exactly this problem â” given remainders against
-- two moduli, produce the number â” and Brahmagupta (628) and Bhskara II
-- (1150) extend it.  The *Sun Zi Suanjing* (c. 3rdâ“5th c.) poses the
-- problem with a rule for a special case; Qin Jiushao's general method is
-- 1247.  Both traditions have it, and this file's own chain runs on the
-- Indian one: `CoprimePowers`, `BezoutIsGCD` and `CoprimePowersN` all
-- carry B©zout certificates, which is what the pulveriser returns.
--
-- Nothing mathematical changes.  The citation does.  See
------------------------------------------------------------------------
