{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- TheStrictRateOrderIsAnOrderAndTheClaimIsAntitoneOnIt
--
-- `TheRatesAreDenseAndTheMediantSurvivesTheQuotient` lifted the strict
-- threshold order to `Rate` and closed with:
--
--   "`⊏R` is a relation into `hProp`, not an order: irreflexivity,
--    transitivity, and the relation to `AtLeastOnRate` / `AboveOnRate`
--    are not proved on `Rate`."
--
-- All three are proved here, and none of them needs a new idea — which
-- is the point of having lifted along `rec2` in the first place.  Every
-- statement is a PROPOSITION, so `elimProp` reduces each to
-- representatives, where the pair-level facts are one line apiece.
--
-- ────────────────────────────────────────────────────────────────────
-- WHAT IS PROVED
--
--   ⊏-irrefl-pair / ⊏-trans-pair
--                  irreflexivity and transitivity at the PAIR level;
--                  transitivity is `⊑⊏-trans` composed with `<-weaken`,
--                  so the mixed transitivity proved for the lifting is
--                  what makes the plain one free
--   ⊏R-irrefl / ⊏R-trans
--                  the same on `Rate`, by `elimProp` and `elimProp3`
--   aboveIsAntitoneOnRates
--                  a claim at a HIGHER rate implies the claim at a
--                  LOWER one, stated entirely on `Rate`
--
-- **So the density result now sits on an order rather than a relation**,
-- and `Rate` carries a strict order with the two claim families antitone
-- along it — the whole threshold apparatus, at the level where 2/4 and
-- 1/2 are one object.
--
-- ────────────────────────────────────────────────────────────────────
-- NO NOVELTY.  Irreflexivity and transitivity of a strict order defined
-- by cross multiplication are elementary; lifting propositional
-- statements through a set-quotient by `elimProp` is standard.
--
-- WHAT IS STILL NOT CLAIMED.  ASYMMETRY and TRICHOTOMY are not proved:
-- `⊏-total`-style comparability was proved for `⊑` on PAIRS and is not
-- transported here, so nothing says two rates are always comparable.
-- No claim relates `⊏R` to `AtLeastOnRate` — only to `AboveOnRate`;
-- the non-strict claim's antitonicity along the STRICT order is a
-- different statement and is not made.  `Rate` still has no
-- arithmetic, no lowest-terms section, no decidability of `≈`, and no
-- relation to any library type of rationals.  Whether `mediant`
-- descends remains open, so the density witness is still truncated.
--
-- CHECKED on the CONTAINER (Agda 2.6.3, cubical v0.5 — NOT the declared
-- pin, Agda 2.8.0 + cubical v0.9).  --safe, no postulates, no holes.
------------------------------------------------------------------------

module TheStrictRateOrderIsAnOrderAndTheClaimIsAntitoneOnIt where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Structure using (⟨_⟩ ; str)
open import Cubical.Foundations.HLevels using (isPropΠ ; isProp→)
open import Cubical.HITs.SetQuotients as SQ using (_/_ ; [_] ; elimProp ; elimProp3)
open import Cubical.Data.Nat using (ℕ ; suc ; _·_)
open import Cubical.Data.Nat.Order using (_<_ ; ¬m<m ; <-weaken)
open import Cubical.Data.Bool using (Bool)
open import Cubical.Data.List using (List)
open import Cubical.Data.Sigma using (_×_ ; _,_)
open import Cubical.Relation.Nullary using (¬_ ; isProp¬)

open import TheStrictThresholdsAreTheSameChainAndDifferOnlyAtTheBoundary
  using (aboveAntitone)
open import WhichThresholdStatementsDescendToTheRate using (_≈_)
open import TheThresholdChainIsDenseAndTheMediantWitnessesIt
  using (_⊏_)
open import TheRateQuotientExistsAndMinimalityCannotLiveOnIt
  using (Rate ; AboveOnRate)
open import TheRatesAreDenseAndTheMediantSurvivesTheQuotient
  using (_⊏R_ ; ⊑⊏-trans)

------------------------------------------------------------------------
-- 1.  At the pair level
------------------------------------------------------------------------

⊏-irrefl-pair : (a : ℕ × ℕ) → ¬ (a ⊏ a)
⊏-irrefl-pair (p , q) = ¬m<m

⊏-trans-pair : (a b c : ℕ × ℕ) → a ⊏ b → b ⊏ c → a ⊏ c
⊏-trans-pair a b c h1 h2 = ⊑⊏-trans a b c (<-weaken h1) h2

------------------------------------------------------------------------
-- 2.  On the rates
--
-- Each statement is a proposition, so `elimProp` puts it at
-- representatives and §1 finishes it.
------------------------------------------------------------------------

⊏R-irrefl : (x : Rate) → ¬ ⟨ x ⊏R x ⟩
⊏R-irrefl =
  elimProp (λ x → isProp¬ ⟨ x ⊏R x ⟩) ⊏-irrefl-pair

⊏R-trans :
  (x y z : Rate) → ⟨ x ⊏R y ⟩ → ⟨ y ⊏R z ⟩ → ⟨ x ⊏R z ⟩
⊏R-trans =
  elimProp3 (λ x y z → isProp→ (isProp→ (str (x ⊏R z)))) ⊏-trans-pair

------------------------------------------------------------------------
-- 3.  And the strict claim is antitone along it
------------------------------------------------------------------------

aboveIsAntitoneOnRates :
  (x y : Rate) → ⟨ x ⊏R y ⟩
  → (bs : List Bool) → ⟨ AboveOnRate y bs ⟩ → ⟨ AboveOnRate x bs ⟩
aboveIsAntitoneOnRates =
  SQ.elimProp2
    (λ x y → isProp→ (isPropΠ (λ bs → isProp→ (str (AboveOnRate x bs)))))
    (λ where (p , q) (p' , q') h bs →
               aboveAntitone p q p' q' bs (<-weaken h))
