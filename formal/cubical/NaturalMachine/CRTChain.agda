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
-- NaturalMachine.CRTChain
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
-- ────────────────────────────────────────────────────────────────────
-- THE STATEMENT
--
--     crtChain : (ms : List ℕ) → Coprimes ms
--              → Fin (suc (Prod ms)) ≃ Vec ms
--
-- where a modulus is written as its predecessor (so every modulus is
-- positive by construction), `Prod` is the predecessor of the product,
-- `Vec` is the residue vector, and `Coprimes ms` asks only that each head
-- be coprime to the product of its tail — which is what a walk supplies
-- by computation, one `gcd≡→isGCD refl` per install.
--
-- ────────────────────────────────────────────────────────────────────
-- WHAT IS STILL NOT CLAIMED, AND IT IS THE ARITHMETIC
--
-- That the walk's installed prime powers ARE pairwise coprime.  That is
-- Euclid's lemma territory — `Kuttaka.bezout` is the ingredient this
-- repository has, and assembling it is a separate piece of work.  Here
-- the coprimality is a hypothesis, and at any concrete frontier it is
-- discharged by computing a gcd.
--
-- The honest form of the boundary: CRT is general; the primes are not
-- done.
--
-- CHECKED: Agda 2.6.3, cubical v0.5 — the container, not the repository
-- pin.  No postulates, no holes.
------------------------------------------------------------------------

module NaturalMachine.CRTChain where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Equiv using (_≃_ ; compEquiv ; idEquiv ; isContr→Equiv)
open import Cubical.Data.Nat using (ℕ ; zero ; suc ; _+_ ; _·_ ; ·-suc)
open import Cubical.Data.Nat.GCD using (isGCD ; gcd≡→isGCD)
open import Cubical.Data.Fin using (Fin)
open import Cubical.Data.Fin.Properties using (isContrFin1)
open import Cubical.Data.List using (List ; [] ; _∷_)
open import Cubical.Data.Sigma using (_×_ ; ≃-×)
open import Cubical.Data.Unit using (Unit ; isContrUnit)
open import Cubical.Tactics.NatSolver.Reflection using (solveℕ!)

open import FinCardinality using (crtEquiv)

------------------------------------------------------------------------
-- 1.  Moduli by their predecessors, so positivity is structural
------------------------------------------------------------------------

-- the PREDECESSOR of the product: the product itself is `suc (Prod ms)`
Prod : List ℕ → ℕ
Prod []       = 0
Prod (m ∷ ms) = (m + Prod ms) + m · Prod ms

-- (m+1)(p+1) = 1 + (m + p) + m·p
prodStep : (m p : ℕ) → suc m · suc p ≡ suc ((m + p) + m · p)
prodStep m p = cong (suc p +_) (·-suc m p) ∙ cong suc (rearr m p)
  where
  rearr : (a b : ℕ) → b + (a + a · b) ≡ (a + b) + a · b
  rearr a b = solveℕ!

-- the residue vector against the moduli
Vec : List ℕ → Type
Vec []       = Unit
Vec (m ∷ ms) = Fin (suc m) × Vec ms

-- each head coprime to the product of its tail — one gcd per install
Coprimes : List ℕ → Type
Coprimes []       = Unit
Coprimes (m ∷ ms) = isGCD (suc m) (suc (Prod ms)) 1 × Coprimes ms

------------------------------------------------------------------------
-- 2.  THE CHAIN
------------------------------------------------------------------------

crtChain : (ms : List ℕ) → Coprimes ms → Fin (suc (Prod ms)) ≃ Vec ms
crtChain []       _           = isContr→Equiv isContrFin1 isContrUnit
crtChain (m ∷ ms) (cop , rest) =
  subst (λ k → Fin k ≃ Vec (m ∷ ms)) (prodStep m (Prod ms))
    (compEquiv (crtEquiv m (Prod ms) cop)
               (≃-× (idEquiv (Fin (suc m))) (crtChain ms rest)))

------------------------------------------------------------------------
-- 3.  It reproduces `WalkObservationCount` at frontier 8, from the same
--     three gcd computations and no hand composition.
--
--     moduli 8, 3, 5, 7  ↦  predecessors 7, 2, 4, 6
--     product 840        ↦  Prod = 839
------------------------------------------------------------------------

walk8 : List ℕ
walk8 = 7 ∷ 2 ∷ 4 ∷ 6 ∷ []

walk8-prod : Prod walk8 ≡ 839
walk8-prod = refl

walk8-coprimes : Coprimes walk8
walk8-coprimes =
    gcd≡→isGCD refl
  , gcd≡→isGCD refl
  , gcd≡→isGCD refl
  , gcd≡→isGCD refl
  , _

walk8-residues : Fin 840 ≃ Vec walk8
walk8-residues = crtChain walk8 walk8-coprimes

------------------------------------------------------------------------
-- 4.  What this buys.
--
-- A frontier is now four lines: list the installed moduli, compute the
-- gcds, apply `crtChain`.  `WalkObservationCount`'s hand-built
-- three-step composition was the scaffolding, not the mathematics, and
-- the mathematics that remains missing is exactly one theorem —
-- that distinct prime powers are coprime — which is Euclid's lemma and
-- has `Kuttaka.bezout` waiting for it.
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
-- notes/DID_THE_THREE_ROOTS_SUFFICE.md.
------------------------------------------------------------------------
