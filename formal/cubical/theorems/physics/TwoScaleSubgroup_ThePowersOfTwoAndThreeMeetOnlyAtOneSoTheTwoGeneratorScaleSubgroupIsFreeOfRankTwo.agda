{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- TwoScaleSubgroup — 2ᵐ = 3ⁿ only when m = n = 0.  Hence the subgroup
-- {m log 2 + n log 3} of ℝ is free abelian of rank two, i.e. log 2/log 3
-- is irrational, which is the arithmetic input behind the density of
-- the two-generator sample set τ(m, n) in the C(𝕋²)-descent statement
-- of the RH line: a trace bounded on the samples is bounded everywhere.
--
--   §1  2ᵐ is even for m ≥ 1, 3ⁿ is odd for every n (a witness k with
--       3ⁿ = 1 + 2k, built by 3(1 + 2k) = 1 + 2(3k + 1));
--   §2  2ᵐ ≡ 3ⁿ → m ≡ 0 and n ≡ 0.
--
-- SYĀT.  Elementary parity over ℕ.  Density in ℝ, continuity of the
-- trace, and the Riesz representation on 𝕋² are NOT here; this is the
-- exact fact those use.
------------------------------------------------------------------------

module TwoScaleSubgroup_ThePowersOfTwoAndThreeMeetOnlyAtOneSoTheTwoGeneratorScaleSubgroupIsFreeOfRankTwo where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Sigma using (_×_ ; _,_ ; fst ; snd)
open import Cubical.Data.Nat using (ℕ ; zero ; suc ; _+_ ; _·_ ; +-suc ; +-zero ; isEven ; snotz ; injSuc)
open import Cubical.Data.Bool using (Bool ; true ; false ; true≢false)
open import Cubical.Data.Empty using (⊥) renaming (rec to ⊥-rec)
open import Cubical.Tactics.NatSolver

pow2 pow3 : ℕ → ℕ
pow2 zero = 1
pow2 (suc m) = 2 · pow2 m
pow3 zero = 1
pow3 (suc n) = 3 · pow3 n

------------------------------------------------------------------------
-- §1  parity
------------------------------------------------------------------------

isEven-double : (y : ℕ) → isEven (y + y) ≡ true
isEven-double zero = refl
isEven-double (suc y) = cong (λ z → isEven (suc z)) (+-suc y y) ∙ isEven-double y

isEven-suc-double : (k : ℕ) → isEven (suc (k + k)) ≡ false
isEven-suc-double zero = refl
isEven-suc-double (suc k) = cong (λ z → isEven (suc (suc z))) (+-suc k k) ∙ isEven-suc-double k

-- 2 · y = y + y
two· : (y : ℕ) → 2 · y ≡ y + y
two· y = solveℕ!

pow2-even : (m : ℕ) → isEven (pow2 (suc m)) ≡ true
pow2-even m = cong isEven (two· (pow2 m)) ∙ isEven-double (pow2 m)

-- 3ⁿ = 1 + 2k, with k built along n
odd-witness : (n : ℕ) → Σ[ k ∈ ℕ ] pow3 n ≡ suc (k + k)
odd-witness zero = 0 , refl
odd-witness (suc n) with odd-witness n
... | k , e = (3 · k + 1) , (cong (3 ·_) e ∙ step k)
  where
    step : (k : ℕ) → 3 · suc (k + k) ≡ suc ((3 · k + 1) + (3 · k + 1))
    step k = solveℕ!

pow3-odd : (n : ℕ) → isEven (pow3 n) ≡ false
pow3-odd n with odd-witness n
... | k , e = cong isEven e ∙ isEven-suc-double k

------------------------------------------------------------------------
-- §2  the powers meet only at one
------------------------------------------------------------------------

-- 3 · suc x is never 1
three·suc≢1 : (x : ℕ) → 3 · suc x ≡ 1 → ⊥
three·suc≢1 x e = snotz (injSuc (sym (unfold x) ∙ e))
  where
    unfold : (x : ℕ) → 3 · suc x ≡ suc (suc (suc (3 · x)))
    unfold x = solveℕ!

pow3-one : (n : ℕ) → pow3 n ≡ 1 → n ≡ 0
pow3-one zero _ = refl
pow3-one (suc n) e with odd-witness n
... | k , w = ⊥-rec (three·suc≢1 (k + k) (cong (3 ·_) (sym w) ∙ e))

powers-meet-only-at-one : (m n : ℕ) → pow2 m ≡ pow3 n → (m ≡ 0) × (n ≡ 0)
powers-meet-only-at-one zero n e = refl , pow3-one n (sym e)
powers-meet-only-at-one (suc m) n e =
  ⊥-rec (true≢false (sym (pow2-even m) ∙ cong isEven e ∙ pow3-odd n))
