{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- TrichotomyIsCheapOnPairsAndTheLiftCostsATruncation
--
-- Trichotomy is proved AT THE PAIR LEVEL, and only what is cheap is
-- lifted to the quotient.
--
-- ────────────────────────────────────────────────────────────────────
-- WHAT IS PROVED
--
--   TriP a b            the three-way disjunction on PAIRS
--   pairTrichotomy      it holds, by `_≟_` on the two cross products —
--                       and it COMPUTES: no quotient, no eliminator
--   triPExcludesEquality / triPExcludesReverse
--                       the two exclusivity facts, also at the pair
--                       level: `a ⊏ b` rules out `a ≈ b` and rules out
--                       `b ⊏ a`
--   TriR x y            the trichotomy on rates, TRUNCATED
--   rateTrichotomyTruncated
--                       it holds, by `elimProp2` into `∥_∥₁`
--
-- **WHAT THE TRUNCATION COSTS, EXACTLY.**  `∥_∥₁` is a proposition for
-- free, so `elimProp2` applies without any `isProp` obligation, where the
-- untruncated sum would first have to be proved a proposition.
-- The price is that `TriR` carries no computation: from `TriR x y` one
-- may conclude anything that is itself a proposition, but one cannot
-- READ OFF which of the three cases holds, so this is not a decision
-- procedure and does not make `Rate` a decidable order.
--
-- ────────────────────────────────────────────────────────────────────
-- NO NOVELTY.  Trichotomy of the rationals is classical, and `_≟_` on
-- ℕ is library.  The one thing worth recording is the shape: an
-- untruncated statement over a set-quotient costs its own `isProp`
-- proof, and the truncated one does not.
------------------------------------------------------------------------

module TrichotomyIsCheapOnPairsAndTheLiftCostsATruncation where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Structure using (⟨_⟩)
open import Cubical.Foundations.HLevels using (isPropΠ)
open import Cubical.HITs.SetQuotients as SQ using (_/_ ; [_] ; eq/ ; elimProp2)
open import Cubical.HITs.PropositionalTruncation as PT
  using (∥_∥₁ ; ∣_∣₁ ; isPropPropTrunc)
open import Cubical.Data.Nat using (ℕ ; suc ; _·_)
open import Cubical.Data.Nat.Order using (_≟_ ; lt ; eq ; gt ; ≤-trans ; ¬m<m)
open import Cubical.Data.Sum using (_⊎_ ; inl ; inr)
open import Cubical.Data.Sigma using (_×_ ; _,_ ; fst ; snd)
open import Cubical.Relation.Nullary using (¬_)

open import WhichThresholdStatementsDescendToTheRate using (_≈_)
open import TheThresholdChainIsDenseAndTheMediantWitnessesIt
  using (_⊏_)
open import TheStrictRateOrderIsAnOrderAndTheClaimIsAntitoneOnIt
  using (⊏-irrefl-pair ; ⊏-trans-pair)
open import TheRateQuotientExistsAndMinimalityCannotLiveOnIt
  using (Rate)
open import TheRatesAreDenseAndTheMediantSurvivesTheQuotient
  using (_⊏R_)

------------------------------------------------------------------------
-- 1.  On pairs, where it computes
------------------------------------------------------------------------

TriP : ℕ × ℕ → ℕ × ℕ → Type
TriP a b = (a ⊏ b) ⊎ ((a ≈ b) ⊎ (b ⊏ a))

pairTrichotomy : (a b : ℕ × ℕ) → TriP a b
pairTrichotomy (p , q) (p' , q') with (p · suc q') ≟ (p' · suc q)
... | lt h = inl h
... | eq e = inr (inl ((0 , e) , (0 , sym e)))
... | gt h = inr (inr h)

------------------------------------------------------------------------
-- 2.  …and the three cases exclude each other, at the pair level
------------------------------------------------------------------------

triPExcludesEquality : (a b : ℕ × ℕ) → a ⊏ b → ¬ (a ≈ b)
triPExcludesEquality a b h r = ¬m<m (≤-trans h (snd r))

triPExcludesReverse : (a b : ℕ × ℕ) → a ⊏ b → ¬ (b ⊏ a)
triPExcludesReverse a b h k = ⊏-irrefl-pair a (⊏-trans-pair a b a h k)

------------------------------------------------------------------------
-- 3.  On the rates, truncated — the eliminator is free
------------------------------------------------------------------------

TriR : Rate → Rate → Type
TriR x y = ∥ ⟨ x ⊏R y ⟩ ⊎ ((x ≡ y) ⊎ ⟨ y ⊏R x ⟩) ∥₁

rateTrichotomyTruncated : (x y : Rate) → TriR x y
rateTrichotomyTruncated =
  elimProp2 (λ x y → isPropPropTrunc) step
  where
    step : (a b : ℕ × ℕ) → TriR [ a ] [ b ]
    step a b with pairTrichotomy a b
    ... | inl h        = ∣ inl h ∣₁
    ... | inr (inl r)  = ∣ inr (inl (eq/ a b r)) ∣₁
    ... | inr (inr k)  = ∣ inr (inr k) ∣₁
