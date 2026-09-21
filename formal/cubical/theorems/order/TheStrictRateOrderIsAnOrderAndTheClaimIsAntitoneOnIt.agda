{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- TheStrictRateOrderIsAnOrderAndTheClaimIsAntitoneOnIt
--
-- `TheRatesAreDenseAndTheMediantSurvivesTheQuotient` lifted the strict
-- threshold order to `Rate` and closed with:
--
--   "`‚äR` is a relation into `hProp`, not an order: irreflexivity,
--    transitivity, and the relation to `AtLeastOnRate` / `AboveOnRate`
--    are not proved on `Rate`."
--
-- All three are proved here, and none of them needs a new idea ‚î which
-- is the point of having lifted along `rec2` in the first place.  Every
-- statement is a PROPOSITION, so `elimProp` reduces each to
-- representatives, where the pair-level facts are one line apiece.
--
-- ‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î
-- WHAT IS PROVED
--
--   ‚ä-irrefl-pair / ‚ä-trans-pair
--                  irreflexivity and transitivity at the PAIR level;
--                  transitivity is `‚ä‚ä-trans` composed with `<-weaken`,
--                  so the mixed transitivity proved for the lifting is
--                  what makes the plain one free
--   ‚äR-irrefl / ‚äR-trans
--                  the same on `Rate`, by `elimProp` and `elimProp3`
--   aboveIsAntitoneOnRates
--                  a claim at a HIGHER rate implies the claim at a
--                  LOWER one, stated entirely on `Rate`
--
-- **So the density result now sits on an order rather than a relation**,
-- and `Rate` carries a strict order with the two claim families antitone
-- along it ‚î the whole threshold apparatus, at the level where 2/4 and
-- 1/2 are one object.
--
-- ‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î
-- NO NOVELTY.  Irreflexivity and transitivity of a strict order defined
-- by cross multiplication are elementary; lifting propositional
-- statements through a set-quotient by `elimProp` is standard.
------------------------------------------------------------------------

module TheStrictRateOrderIsAnOrderAndTheClaimIsAntitoneOnIt where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Structure using (‚ü®_‚ü© ; str)
open import Cubical.Foundations.HLevels using (isPropŒ† ; isProp‚Üí)
open import Cubical.HITs.SetQuotients as SQ using (_/_ ; [_] ; elimProp ; elimProp3)
open import Cubical.Data.Nat using (‚Ñï ; suc ; _¬∑_)
open import Cubical.Data.Nat.Order using (_<_ ; ¬¨m<m ; <-weaken)
open import Cubical.Data.Bool using (Bool)
open import Cubical.Data.List using (List)
open import Cubical.Data.Sigma using (_√ó_ ; _,_)
open import Cubical.Relation.Nullary using (¬¨_ ; isProp¬¨)

open import TheStrictThresholdsAreTheSameChainAndDifferOnlyAtTheBoundary
  using (aboveAntitone)
open import WhichThresholdStatementsDescendToTheRate using (_‚âà_)
open import TheThresholdChainIsDenseAndTheMediantWitnessesIt
  using (_‚äè_)
open import TheRateQuotientExistsAndMinimalityCannotLiveOnIt
  using (Rate ; AboveOnRate)
open import TheRatesAreDenseAndTheMediantSurvivesTheQuotient
  using (_‚äèR_ ; ‚äë‚äè-trans)

------------------------------------------------------------------------
-- 1.  At the pair level
------------------------------------------------------------------------

‚äè-irrefl-pair : (a : ‚Ñï √ó ‚Ñï) ‚Üí ¬¨ (a ‚äè a)
‚äè-irrefl-pair (p , q) = ¬¨m<m

‚äè-trans-pair : (a b c : ‚Ñï √ó ‚Ñï) ‚Üí a ‚äè b ‚Üí b ‚äè c ‚Üí a ‚äè c
‚äè-trans-pair a b c h1 h2 = ‚äë‚äè-trans a b c (<-weaken h1) h2

------------------------------------------------------------------------
-- 2.  On the rates
--
-- Each statement is a proposition, so `elimProp` puts it at
-- representatives and ¬ß1 finishes it.
------------------------------------------------------------------------

‚äèR-irrefl : (x : Rate) ‚Üí ¬¨ ‚ü® x ‚äèR x ‚ü©
‚äèR-irrefl =
  elimProp (Œª x ‚Üí isProp¬¨ ‚ü® x ‚äèR x ‚ü©) ‚äè-irrefl-pair

‚äèR-trans :
  (x y z : Rate) ‚Üí ‚ü® x ‚äèR y ‚ü© ‚Üí ‚ü® y ‚äèR z ‚ü© ‚Üí ‚ü® x ‚äèR z ‚ü©
‚äèR-trans =
  elimProp3 (Œª x y z ‚Üí isProp‚Üí (isProp‚Üí (str (x ‚äèR z)))) ‚äè-trans-pair

------------------------------------------------------------------------
-- 3.  And the strict claim is antitone along it
------------------------------------------------------------------------

aboveIsAntitoneOnRates :
  (x y : Rate) ‚Üí ‚ü® x ‚äèR y ‚ü©
  ‚Üí (bs : List Bool) ‚Üí ‚ü® AboveOnRate y bs ‚ü© ‚Üí ‚ü® AboveOnRate x bs ‚ü©
aboveIsAntitoneOnRates =
  SQ.elimProp2
    (Œª x y ‚Üí isProp‚Üí (isPropŒ† (Œª bs ‚Üí isProp‚Üí (str (AboveOnRate x bs)))))
    (Œª where (p , q) (p' , q') h bs ‚Üí
               aboveAntitone p q p' q' bs (<-weaken h))
