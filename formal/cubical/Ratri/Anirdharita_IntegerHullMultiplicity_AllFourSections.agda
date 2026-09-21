{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- अनिर्धारित — hull is a 6-to-1-per-tile compression and none of the
-- four probed pairings inverts it.  The queue's four remaining rows
-- (notes/SADHYA_OPEN_OBLIGATIONS.md: Qs ⇄ hull, Xs ⇄ hull at rung ५,
-- and the two खण्डितम् self-refuted rows N ⇄ hull, SQ ⇄ hull) all guess
-- that a scalar census of a configuration determines the configuration,
-- or that hull's output censuses back to its input.  The host's own
-- theorems price the tile: hullN says N (hull t) = t · 6, hullSQ says
-- SQ (hull t) = t · 8 — the hull of t is five cells per unit, never one,
-- so every section guess dies at t = 1.  Four verdicts, one witness
-- each, all by refl + a decidable discriminator.  Road two, four times.
--
-- (The two खण्डितम् rows had already refuted themselves — the probe's
-- induction reached x ≡ suc⁵ x and x ≡ suc⁷ x, which ℕ forbids; this
-- module states the same fact positively, as the smallest witnesses.)
--
-- Toolchain: the PIN (Agda 2.8.0 + cubical v0.9); the host uses the
-- v0.9 ℕ ring solver.
------------------------------------------------------------------------

module Ratri.Anirdharita_IntegerHullMultiplicity_AllFourSections where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (ℕ; suc; snotz; znots)
open import Cubical.Data.List using (List; []; _∷_)
open import Cubical.Data.Bool using (Bool; true; false; true≢false)
open import Cubical.Data.Empty as Empty using (⊥)
open import IntegerHullMultiplicity using (Config; hull; N; SQ; Xs; Qs)

singleton1 : Config
singleton1 = 1 ∷ []

-- A discriminator: is the configuration the single cell [1]?
isSingleton1 : Config → Bool
isSingleton1 (1 ∷ []) = true
isSingleton1 _        = false

-- hull ∘ Xs misses [1]: Xs [1] = 1 and hull 1 is the five-cell tile.
Xs-NOT-DETERMINED : hull (Xs singleton1) ≡ singleton1 → ⊥
Xs-NOT-DETERMINED p = true≢false (cong isSingleton1 (sym p))

-- hull ∘ Qs misses [1]: Qs [1] = 1 likewise.
Qs-NOT-DETERMINED : hull (Qs singleton1) ≡ singleton1 → ⊥
Qs-NOT-DETERMINED p = true≢false (cong isSingleton1 (sym p))

-- N ∘ hull is ·6, never the identity: N (hull 1) = 6 ≢ 1.
N-NOT-DETERMINED : N (hull 1) ≡ 1 → ⊥
N-NOT-DETERMINED p = snotz (cong predℕ p)
  where
  predℕ : ℕ → ℕ
  predℕ 0 = 0
  predℕ (suc n) = n

-- SQ ∘ hull is ·8, never the identity: SQ (hull 1) = 8 ≢ 1.
SQ-NOT-DETERMINED : SQ (hull 1) ≡ 1 → ⊥
SQ-NOT-DETERMINED p = snotz (cong predℕ p)
  where
  predℕ : ℕ → ℕ
  predℕ 0 = 0
  predℕ (suc n) = n
