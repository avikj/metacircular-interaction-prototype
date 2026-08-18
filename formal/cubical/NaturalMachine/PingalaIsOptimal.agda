{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- NaturalMachine.PingalaIsOptimal
--
-- The same two theorems that make the walk optimal make Piṅgala's
-- naṣṭa/uddiṣṭa optimal, and they were separated by about 2300 years.
--
-- ────────────────────────────────────────────────────────────────────
-- WHAT IS ALREADY HERE
--
-- `formal/cubical/Pingala.agda` carries the Chandaḥśāstra's pratyaya as
-- checked types, including
--
--     uddistaIso : (n : ℕ) → Iso (Vak n) (Fin (sankhya n))
--
-- whose forward map is the explicit uddiṣṭa algorithm (pattern ↦ row
-- number), whose inverse is the explicit naṣṭa halving algorithm (row
-- number ↦ pattern), and whose round trips are both proved.  That is a
-- LOSSLESS OBSERVATION WITH AN EXPLICIT DECODE — the positive pole of
-- the idiom `notes/THE_BARRIER_PROBLEM_IS_A_COLLISION.md` identifies,
-- written down around 300 BCE.
--
-- `NaturalMachine.LosslessLowerBound` carries the other half: any lossless
-- observation needs at least as many outcomes as it has inputs.
--
-- Neither module knows about the other.  This one is the sentence.
--
-- ────────────────────────────────────────────────────────────────────
-- THE STATEMENT
--
--     pingala-optimal :
--       (n : ℕ) (Y : FinSet ℓ-zero) (obs : Vak n → Y .fst)
--       → Injective obs → sankhya n ≤ card Y
--
-- No scheme whatever — not uddiṣṭa, not a cleverer one, not one nobody
-- has thought of — observes the metres of n syllables losslessly with
-- fewer than saṅkhyā n = 2ⁿ outcomes.  And `uddistaIso` has exactly that
-- many.  Piṅgala's algorithm is optimal, and the proof of optimality is
-- one instantiation of a bound proved for every observation scheme.
--
-- ────────────────────────────────────────────────────────────────────
-- WHY THIS IS NOT A DECORATIVE PAIRING
--
-- The walk and the pratyaya are the same problem: enumerate a finite
-- family losslessly, in an order, with an index you can convert back and
-- forth.  The walk's state is a residue vector and its count is CRT
-- (`WalkObservationCount`); Piṅgala's state is a binary pattern and his
-- count is saṅkhyā.  Both are optimal, both for the same reason, and the
-- reason is pigeonhole plus an explicit decode.
--
-- The difference is that Piṅgala SUPPLIED the decode.  naṣṭa is not a
-- proof that the enumeration is invertible; it is the inverse, as an
-- algorithm, with its own name.  That is the standard this corpus's
-- `FactorsThrough` results have mostly not met — they establish that a
-- decode exists or does not, and `Pingala.agda` exhibits one.
--
-- WHAT IS NOT CLAIMED.  That uddiṣṭa is the unique optimal scheme (it is
-- not — any bijection to `Fin (sankhya n)` attains the bound); that
-- Piṅgala stated an optimality claim (he did not, and nothing in the
-- Chandaḥśāstra is read here as one); or anything about mātrā-vṛtta,
-- where the count is the mātrāmeru and the same argument would apply
-- verbatim via `matraCount` but is not run.
--
-- CHECKED: Agda 2.6.3, cubical v0.5 — the container, not the repository
-- pin.  No postulates, no holes.
------------------------------------------------------------------------

module NaturalMachine.PingalaIsOptimal where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Isomorphism using (isoToEquiv)
open import Cubical.Foundations.Equiv using (compEquiv ; invEquiv)
open import Cubical.Functions.Embedding using (injEmbedding)
open import Cubical.Data.Nat using (ℕ)
open import Cubical.Data.Nat.Order using (_≤_)
open import Cubical.Data.Fin using (Fin)
open import Cubical.Data.FinSet using (FinSet ; card ; isFinSet→isSet)
open import Cubical.Data.FinSet.Cardinality using (card↪Inequality')
open import Cubical.HITs.PropositionalTruncation using (∣_∣₁)
open import Cubical.Data.SumFin using () renaming (SumFin≃Fin to sumFin≃Fin)

open import Pingala using (Vak ; sankhya ; uddistaIso)

------------------------------------------------------------------------
-- 1.  The metres of n syllables, as a finite set of size saṅkhyā n
------------------------------------------------------------------------

Injective : {A B : Type} → (A → B) → Type
Injective {A = A} f = {x y : A} → f x ≡ f y → x ≡ y

VakFinSet : (n : ℕ) → FinSet ℓ-zero
VakFinSet n =
  Vak n , sankhya n ,
  ∣ compEquiv (isoToEquiv (uddistaIso n)) (invEquiv (sumFin≃Fin (sankhya n))) ∣₁

card-Vak : (n : ℕ) → card (VakFinSet n) ≡ sankhya n
card-Vak n = refl

------------------------------------------------------------------------
-- 2.  THE BOUND, at Piṅgala's problem
------------------------------------------------------------------------

pingala-optimal :
  (n : ℕ) (Y : FinSet ℓ-zero) (obs : Vak n → Y .fst)
  → Injective obs
  → sankhya n ≤ card Y
pingala-optimal n Y obs inj =
  card↪Inequality' (VakFinSet n) Y obs
    (injEmbedding (isFinSet→isSet (Y .snd)) inj)

------------------------------------------------------------------------
-- 3.  And uddiṣṭa attains it, because it is an equivalence.
--
-- `uddistaIso n : Iso (Vak n) (Fin (sankhya n))` — the target has
-- saṅkhyā n elements, which by §2 is the minimum.  Bound and attainment,
-- both terms.
--
-- The saṅkhyā recurrence saṅkhyā (n+1) = saṅkhyā n + saṅkhyā n is
-- `Pingala.sankhya` by definition, so the count is the doubling Piṅgala
-- states, not a translation of it.
------------------------------------------------------------------------
