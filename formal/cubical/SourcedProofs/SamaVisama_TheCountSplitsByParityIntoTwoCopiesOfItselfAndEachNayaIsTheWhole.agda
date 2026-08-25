{-# OPTIONS --cubical --safe --no-import-sorts #-}

-- सम-विषम — the count splits by parity into two copies of itself.
--
-- Source term: sama (सम, "even") / viṣama (विषम, "odd"). The even–odd
-- dichotomy is Piṅgala's own casing in the naṣṭa procedure of the
-- Chandaḥśāstra (~300 BCE, ed. Weber 1863; Halāyudha's Mṛtasañjīvanī on
-- 8.24–25): given a row-number, if it is sama (even) halve it and write one
-- syllable, if viṣama (odd) add one, halve, and write the other. The single
-- decision "sama or viṣama" is exactly a map ℕ → ℕ ⊎ ℕ, and it is reversible.
--
-- Scope of the claim. What is proved here is the type-level statement that
--   the even branch and the odd branch each carry a full copy of ℕ and
--   together exhaust it:  ℕ ≃ ℕ ⊎ ℕ,  hence (univalence)  ℕ ≡ ℕ ⊎ ℕ.
-- The forward map is split (Piṅgala's parity decision recursed), the inverse
-- is merge (inl k ↦ 2k, inr k ↦ 2k+1). No claim is made that Piṅgala stated
-- an equivalence of types; the naṣṭa rule is the source of the *dichotomy*,
-- and the equivalence is the standard Hilbert-hotel bijection built here to
-- carry that dichotomy as a channel (transport across it moves any theorem
-- about ℕ to one about its even and odd nayas, and back, on the nose).
--
-- Two nayas, one whole (nayavāda): "even" and "odd" are disjoint standpoints,
-- neither the whole, and asserting both at once (⊎) *is* the whole. The
-- equivalence is the proof they lose nothing between them — ahiṃsā: the
-- split forges neither a presence nor an absence.

module SourcedProofs.SamaVisama_TheCountSplitsByParityIntoTwoCopiesOfItselfAndEachNayaIsTheWhole where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Isomorphism using (Iso ; iso ; isoToEquiv ; isoToPath)
open import Cubical.Foundations.Equiv using (_≃_)
open import Cubical.Data.Nat using (ℕ ; zero ; suc)
open import Cubical.Data.Sum using (_⊎_ ; inl ; inr)

-- double : the even coordinate, defined so double (suc k) reduces to
-- suc (suc (double k)) definitionally (keeps the round-trips computational).
double : ℕ → ℕ
double zero    = zero
double (suc k) = suc (suc (double k))

-- The two branches of the inverse, packaged as one map out of ℕ ⊎ ℕ.
merge : ℕ ⊎ ℕ → ℕ
merge (inl k) = double k        -- sama:   2k
merge (inr k) = suc (double k)  -- viṣama: 2k+1

-- flip advances the parity decision by one step: an even-2k reading becomes
-- the odd-2k reading, an odd-2k reading becomes the even-2(k+1) reading.
flip : ℕ ⊎ ℕ → ℕ ⊎ ℕ
flip (inl k) = inr k
flip (inr k) = inl (suc k)

-- split : Piṅgala's parity decision, recursed the whole way down.
--   split 0 = inl 0,  split (suc n) = flip (split n).
split : ℕ → ℕ ⊎ ℕ
split zero    = inl zero
split (suc n) = flip (split n)

-- ── section: merge ∘ split ≡ id on ℕ ─────────────────────────────────────
-- direct induction; both cases close by refl after the IH is transported.
mergeSplit : (n : ℕ) → merge (split n) ≡ n
mergeSplit zero    = refl
mergeSplit (suc n) with split n | mergeSplit n
... | inl k | p = cong suc p        -- merge (flip (inl k)) = suc (double k) = suc n
... | inr k | p = cong suc p        -- merge (flip (inr k)) = double (suc k) = suc (suc (double k)) = suc n

-- ── retraction: split ∘ merge ≡ id on ℕ ⊎ ℕ ──────────────────────────────
-- incr is what flip∘flip does; split (merge _) rebuilds the branch by induction.
splitDouble : (k : ℕ) → split (double k) ≡ inl k
splitDouble zero    = refl
splitDouble (suc k) = cong (flip ∘f flip) (splitDouble k)
  where
    _∘f_ : {A B C : Type} → (B → C) → (A → B) → A → C
    (g ∘f h) x = g (h x)

splitSucDouble : (k : ℕ) → split (suc (double k)) ≡ inr k
splitSucDouble zero    = refl
splitSucDouble (suc k) = cong (flip ∘f flip) (splitSucDouble k)
  where
    _∘f_ : {A B C : Type} → (B → C) → (A → B) → A → C
    (g ∘f h) x = g (h x)

splitMerge : (s : ℕ ⊎ ℕ) → split (merge s) ≡ s
splitMerge (inl k) = splitDouble k
splitMerge (inr k) = splitSucDouble k

-- ── the equivalence and the univalence path ──────────────────────────────
sama-viṣama-Iso : Iso ℕ (ℕ ⊎ ℕ)
sama-viṣama-Iso = iso split merge splitMerge mergeSplit

ℕ≃ℕ⊎ℕ : ℕ ≃ (ℕ ⊎ ℕ)
ℕ≃ℕ⊎ℕ = isoToEquiv sama-viṣama-Iso

ℕ≡ℕ⊎ℕ : ℕ ≡ (ℕ ⊎ ℕ)
ℕ≡ℕ⊎ℕ = isoToPath sama-viṣama-Iso
