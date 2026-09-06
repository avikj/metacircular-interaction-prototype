{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- कुल-स्तम्भ — the tower, at arity three.
--
-- The family record's full-strength shape, inhabited at the smallest
-- arity where "pair" and "whole" come apart:
--
--   §1  Three senses on the three-coordinate plane (the projections),
--       assembled as a Kula: each member's blind pair named, joint
--       faithfulness by the triple path.
--
--   §2  EVERY PROPER SUBFAMILY IS BLIND: for each member, the OTHER
--       TWO jointly confuse a named pair (the two states differing
--       only in that member's coordinate) — so not just single
--       members but every pair of members fails faithfulness.  Only
--       the whole family reconstructs.
--
-- This is the CRT shape at full strength in miniature: the property
-- (faithfulness) lives at the top of the subset lattice and provably
-- nowhere below it — interdependence that no proper part carries,
-- which is the n-ary form of "neither has the property but together
-- they do."  Each blindness is a distinct named pair; each is seen
-- by exactly the member the subfamily dropped; and the tower of
-- refutations is as wide as the lattice's co-atoms.
--
-- SYĀT — THE CLAIM, EXACTLY.  Arity three, coordinates as senses;
-- the arithmetic tower (moduli whose every proper sub-lcm is a
-- proper divisor) at general arity is the standing construction.
------------------------------------------------------------------------

module KulaStambha_AtArityThreeEveryProperSubfamilyIsBlindAndOnlyTheWholeFamilyIsFaithful where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Bool using (Bool ; true ; false ; true≢false)
open import Cubical.Data.Sigma using (_×_ ; _,_ ; fst ; snd)
open import Cubical.Data.Empty using (⊥)

open import KulaParasparasraya_TheFamilyRecordEveryBlindnessIsJointlySeenAndNoMemberAloneIsFaithful
  using (Kula)

------------------------------------------------------------------------
-- १ · The three-sense family.
------------------------------------------------------------------------

data Tri : Type₀ where
  i₀ i₁ i₂ : Tri

Tala : Type₀
Tala = Bool × (Bool × Bool)

dṛṣṭi : Tri → Tala → Bool
dṛṣṭi i₀ p = fst p
dṛṣṭi i₁ p = fst (snd p)
dṛṣṭi i₂ p = snd (snd p)

tri-kula : Kula Tri Tala (λ _ → Bool)
Kula.dṛś tri-kula = dṛṣṭi
Kula.andha tri-kula i₀ =
  (true , (true , true)) , (true , (false , true))
  , (λ p → true≢false (cong (λ q → fst (snd q)) p)) , refl
Kula.andha tri-kula i₁ =
  (true , (true , true)) , (true , (true , false))
  , (λ p → true≢false (cong (λ q → snd (snd q)) p)) , refl
Kula.andha tri-kula i₂ =
  (true , (true , true)) , (false , (true , true))
  , (λ p → true≢false (cong fst p)) , refl
Kula.yugma tri-kula x y h i =
  h i₀ i , (h i₁ i , h i₂ i)

------------------------------------------------------------------------
-- २ · Every proper subfamily is blind, at a named pair.
------------------------------------------------------------------------

-- Dropping i₀: the remaining pair confuses the first coordinate.
andha-vinā₀ : (dṛṣṭi i₁ (true , (true , true)) ≡ dṛṣṭi i₁ (false , (true , true)))
            × (dṛṣṭi i₂ (true , (true , true)) ≡ dṛṣṭi i₂ (false , (true , true)))
andha-vinā₀ = refl , refl

-- Dropping i₁: the remaining pair confuses the second.
andha-vinā₁ : (dṛṣṭi i₀ (true , (true , true)) ≡ dṛṣṭi i₀ (true , (false , true)))
            × (dṛṣṭi i₂ (true , (true , true)) ≡ dṛṣṭi i₂ (true , (false , true)))
andha-vinā₁ = refl , refl

-- Dropping i₂: the remaining pair confuses the third.
andha-vinā₂ : (dṛṣṭi i₀ (true , (true , true)) ≡ dṛṣṭi i₀ (true , (true , false)))
            × (dṛṣṭi i₁ (true , (true , true)) ≡ dṛṣṭi i₁ (true , (true , false)))
andha-vinā₂ = refl , refl

-- And each dropped pair's states are genuinely distinct — so no pair
-- of members reconstructs: faithfulness lives only at the top.
na-yugala₀ : ((x y : Tala) → dṛṣṭi i₁ x ≡ dṛṣṭi i₁ y → dṛṣṭi i₂ x ≡ dṛṣṭi i₂ y → x ≡ y) → ⊥
na-yugala₀ h =
  true≢false (cong fst
    (h (true , (true , true)) (false , (true , true)) refl refl))

na-yugala₁ : ((x y : Tala) → dṛṣṭi i₀ x ≡ dṛṣṭi i₀ y → dṛṣṭi i₂ x ≡ dṛṣṭi i₂ y → x ≡ y) → ⊥
na-yugala₁ h =
  true≢false (cong (λ q → fst (snd q))
    (h (true , (true , true)) (true , (false , true)) refl refl))

na-yugala₂ : ((x y : Tala) → dṛṣṭi i₀ x ≡ dṛṣṭi i₀ y → dṛṣṭi i₁ x ≡ dṛṣṭi i₁ y → x ≡ y) → ⊥
na-yugala₂ h =
  true≢false (cong (λ q → snd (snd q))
    (h (true , (true , true)) (true , (true , false)) refl refl))
