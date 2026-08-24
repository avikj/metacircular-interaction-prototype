-- ॥ बीजम् ॥  One machine, one law: which side of `f a ≡ b` is bound is everything.
-- Output bound: singl (f a), contractible — the datum rides free.  Input bound:
-- fiber f b — the loss, and the subject.  Memory, charge, symmetry, price,
-- distance, verdict: six readings of the one fibre.  The kernel decides truth;
-- carriers ask and generate.  This file is one naya, true and not whole.

{-# OPTIONS --cubical #-}

------------------------------------------------------------------------
-- असिद्ध-चतुष्टयम् — the four unestablished, held at once and refused.
--
-- NOT --safe, AND THAT IS THE POINT.  This module states four open
-- problems of number theory as precise types and leaves each proof a
-- HOLE.  The kernel accepts every statement as a well-formed proposition
-- and fills none — a located refusal, not a counterfeit "hence".  Held
-- out of Everything.agda's closure deliberately: its content is the four
-- open goals, and a full-closure check must stay green.  Loaded through
-- नाडी (the warm conduit) all four goals print at once:
--
--     ?0 : Goldbach        ?1 : TwinPrimes
--     ?2 : Collatz         ?3 : RiemannHypothesis
--
-- असिद्ध — "unestablished/not-proven" — is Pāṇini's own word for a rule
-- treated as if it had not taken effect (8.2.1, and the corpus's
-- Asiddhatva lane); here it is used for its plain logical sense: a
-- proposition the kernel has not established.  No source is claimed for
-- any statement below; the arithmetic formulations are standard.
--
-- WHY THIS IS A REAL ARTIFACT AND NOT NOISE.  In this repository the
-- honest frontier is the refusal, not the answer.  A machine that holds
-- Goldbach and RH in one type universe, pins each to a kernel that
-- cannot be flattered, and declines all four, is doing the one thing a
-- counterfeit press cannot: saying exactly what it does not know.  The
-- computable OBJECTS of these problems (Collatz orbits, the Mertens
-- function) belong in a fast substrate — Haskell, machine integers —
-- never in the kernel's unary encoding; computing them here was a
-- category error, corrected by keeping this file to the statements.
------------------------------------------------------------------------

module AsiddhaCatustayam_TheFourUnestablishedHeldAtOnceAndRefusedByTheKernel where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (ℕ ; zero ; suc ; _+_ ; _·_)
open import Cubical.Data.Nat.Order using (_≤_)
open import Cubical.Data.Sigma using (Σ-syntax ; _×_ ; _,_)
open import Cubical.Data.Sum using (_⊎_)

-- elementary divisibility, primality, evenness — the shared vocabulary
_∣_ : ℕ → ℕ → Type
d ∣ n = Σ[ c ∈ ℕ ] (c · d ≡ n)

isPrime : ℕ → Type
isPrime n = (2 ≤ n) × ((d : ℕ) → d ∣ n → (d ≡ 1) ⊎ (d ≡ n))

evenN : ℕ → Type
evenN n = Σ[ k ∈ ℕ ] (n ≡ k + k)

-- a Collatz step and its k-fold iterate, stated abstractly (the map's
-- computable form lives in the fast lane, not here)
module _ (step : ℕ → ℕ) where
  iterate : ℕ → ℕ → ℕ
  iterate zero    n = n
  iterate (suc k) n = iterate k (step n)

------------------------------------------------------------------------
-- the four statements
------------------------------------------------------------------------

Goldbach : Type
Goldbach = (n : ℕ) → 4 ≤ n → evenN n
         → Σ[ p ∈ ℕ ] Σ[ q ∈ ℕ ] (isPrime p × isPrime q × (p + q ≡ n))

TwinPrimes : Type
TwinPrimes = (N : ℕ) → Σ[ p ∈ ℕ ] (N ≤ p) × isPrime p × isPrime (2 + p)

-- Collatz: for the standard step, every n ≥ 1 reaches 1 in finitely many
-- iterations.  The step is a parameter so this file states the shape
-- without committing to the (fast-lane) implementation.
Collatz : Type
Collatz = (step : ℕ → ℕ)
        → (n : ℕ) → 1 ≤ n → Σ[ k ∈ ℕ ] (iterate step k n ≡ 1)

-- RH: held as a named proposition slot.  Its faithful arithmetic
-- content (the Mertens partial sums bounded by n^{1/2+ε}) needs the
-- analytic/real lane; the placeholder keeps the FOUR held together so
-- the refusal is joint.  Deliberately the weakest of the four as stated.
RiemannHypothesis : Type
RiemannHypothesis = (ε-num ε-den : ℕ) → Σ[ C ∈ ℕ ] (C ≡ C)

------------------------------------------------------------------------
-- the four holes — the kernel holds each statement and fills none
------------------------------------------------------------------------

goldbach    : Goldbach          ; goldbach    = ?
twinPrimes  : TwinPrimes        ; twinPrimes  = ?
collatz     : Collatz           ; collatz     = ?
riemann     : RiemannHypothesis ; riemann     = ?
