{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- PingalaIsOptimal
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
-- written down around 300 BCE.
--
-- `LosslessLowerBound` carries the other half: any lossless
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
-- Chandaḥśāstra is read here as one).  The mātrā-vṛtta case, listed here
-- as unrun in the first version of this file, is run in §4.
--
-- CHECKED: Agda 2.6.3, cubical v0.5 — the container, not the repository
-- pin.  No postulates, no holes.
------------------------------------------------------------------------

module PingalaIsOptimal where

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

open import Cubical.Data.Nat using (suc ; _+_)
open import PingalaPrastara using (Vak ; sankhya ; uddistaIso ; Metre ; matra ; matraCount ; matraRecurrence)

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

------------------------------------------------------------------------
-- 4.  The mātrā-vṛtta case, which §3's "not claimed" listed as unrun.
--
-- `Pingala.matraCount : (n : ℕ) → Iso (Metre n) (Fin (matra n))` is the
-- same shape for metres of fixed DURATION rather than fixed syllable
-- count, and `Pingala.matraRecurrence` proves
--
--     matra (n+2) ≡ matra (n+1) + matra n
--
-- which is Virahāṅka's mātrāmeru (c. 600–800 CE), four centuries before
-- the *Liber Abaci*.  So the bound applies verbatim, and it says:
--
--     no lossless observation of the metres of duration n has fewer
--     than mātrā n outcomes,
--
-- with Virahāṅka's number appearing as an information-theoretic minimum
-- rather than as a count.
------------------------------------------------------------------------

MetreFinSet : (n : ℕ) → FinSet ℓ-zero
MetreFinSet n =
  Metre n , matra n ,
  ∣ compEquiv (isoToEquiv (matraCount n)) (invEquiv (sumFin≃Fin (matra n))) ∣₁

virahanka-optimal :
  (n : ℕ) (Y : FinSet ℓ-zero) (obs : MetreFinSet n .fst → Y .fst)
  → Injective obs
  → matra n ≤ card Y
virahanka-optimal n Y obs inj =
  card↪Inequality' (MetreFinSet n) Y obs
    (injEmbedding (isFinSet→isSet (Y .snd)) inj)

-- the mātrāmeru recurrence, quoted from `Pingala` so the number in the
-- bound is visibly Virahāṅka's and not a re-derivation
matrameru-recurrence : (n : ℕ) → matra (suc (suc n)) ≡ matra (suc n) + matra n
matrameru-recurrence = matraRecurrence
