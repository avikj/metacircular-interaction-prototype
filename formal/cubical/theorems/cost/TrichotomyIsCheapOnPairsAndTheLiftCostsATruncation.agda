{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- TrichotomyIsCheapOnPairsAndTheLiftCostsATruncation
--
-- Trichotomy is proved AT THE PAIR LEVEL, and only what is cheap is
-- lifted to the quotient.
--
-- ‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î
-- WHAT IS PROVED
--
--   TriP a b            the three-way disjunction on PAIRS
--   pairTrichotomy      it holds, by `_‚âü_` on the two cross products ‚î
--                       and it COMPUTES: no quotient, no eliminator
--   triPExcludesEquality / triPExcludesReverse
--                       the two exclusivity facts, also at the pair
--                       level: `a ‚ä b` rules out `a ‚âà b` and rules out
--                       `b ‚ä a`
--   TriR x y            the trichotomy on rates, TRUNCATED
--   rateTrichotomyTruncated
--                       it holds, by `elimProp2` into `‚à_‚à‚`
--
-- **WHAT THE TRUNCATION COSTS, EXACTLY.**  `‚à_‚à‚` is a proposition for
-- free, so `elimProp2` applies without any `isProp` obligation, where the
-- untruncated sum would first have to be proved a proposition.
-- The price is that `TriR` carries no computation: from `TriR x y` one
-- may conclude anything that is itself a proposition, but one cannot
-- READ OFF which of the three cases holds, so this is not a decision
-- procedure and does not make `Rate` a decidable order.
--
-- ‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î
-- NO NOVELTY.  Trichotomy of the rationals is classical, and `_‚âü_` on
-- ‚ï is library.  The one thing worth recording is the shape: an
-- untruncated statement over a set-quotient costs its own `isProp`
-- proof, and the truncated one does not.
------------------------------------------------------------------------

module TrichotomyIsCheapOnPairsAndTheLiftCostsATruncation where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Structure using (‚ü®_‚ü©)
open import Cubical.Foundations.HLevels using (isPropŒ†)
open import Cubical.HITs.SetQuotients as SQ using (_/_ ; [_] ; eq/ ; elimProp2)
open import Cubical.HITs.PropositionalTruncation as PT
  using (‚à•_‚à•‚ÇÅ ; ‚à£_‚à£‚ÇÅ ; isPropPropTrunc)
open import Cubical.Data.Nat using (‚Ñï ; suc ; _¬∑_)
open import Cubical.Data.Nat.Order using (_‚âü_ ; lt ; eq ; gt ; ‚â§-trans ; ¬¨m<m)
open import Cubical.Data.Sum using (_‚äé_ ; inl ; inr)
open import Cubical.Data.Sigma using (_√ó_ ; _,_ ; fst ; snd)
open import Cubical.Relation.Nullary using (¬¨_)

open import WhichThresholdStatementsDescendToTheRate using (_‚âà_)
open import TheThresholdChainIsDenseAndTheMediantWitnessesIt
  using (_‚äè_)
open import TheStrictRateOrderIsAnOrderAndTheClaimIsAntitoneOnIt
  using (‚äè-irrefl-pair ; ‚äè-trans-pair)
open import TheRateQuotientExistsAndMinimalityCannotLiveOnIt
  using (Rate)
open import TheRatesAreDenseAndTheMediantSurvivesTheQuotient
  using (_‚äèR_)

------------------------------------------------------------------------
-- 1.  On pairs, where it computes
------------------------------------------------------------------------

TriP : ‚Ñï √ó ‚Ñï ‚Üí ‚Ñï √ó ‚Ñï ‚Üí Type
TriP a b = (a ‚äè b) ‚äé ((a ‚âà b) ‚äé (b ‚äè a))

pairTrichotomy : (a b : ‚Ñï √ó ‚Ñï) ‚Üí TriP a b
pairTrichotomy (p , q) (p' , q') with (p ¬∑ suc q') ‚âü (p' ¬∑ suc q)
... | lt h = inl h
... | eq e = inr (inl ((0 , e) , (0 , sym e)))
... | gt h = inr (inr h)

------------------------------------------------------------------------
-- 2.  ‚¶and the three cases exclude each other, at the pair level
------------------------------------------------------------------------

triPExcludesEquality : (a b : ‚Ñï √ó ‚Ñï) ‚Üí a ‚äè b ‚Üí ¬¨ (a ‚âà b)
triPExcludesEquality a b h r = ¬¨m<m (‚â§-trans h (snd r))

triPExcludesReverse : (a b : ‚Ñï √ó ‚Ñï) ‚Üí a ‚äè b ‚Üí ¬¨ (b ‚äè a)
triPExcludesReverse a b h k = ‚äè-irrefl-pair a (‚äè-trans-pair a b a h k)

------------------------------------------------------------------------
-- 3.  On the rates, truncated ‚î the eliminator is free
------------------------------------------------------------------------

TriR : Rate ‚Üí Rate ‚Üí Type
TriR x y = ‚à• ‚ü® x ‚äèR y ‚ü© ‚äé ((x ‚â° y) ‚äé ‚ü® y ‚äèR x ‚ü©) ‚à•‚ÇÅ

rateTrichotomyTruncated : (x y : Rate) ‚Üí TriR x y
rateTrichotomyTruncated =
  elimProp2 (Œª x y ‚Üí isPropPropTrunc) step
  where
    step : (a b : ‚Ñï √ó ‚Ñï) ‚Üí TriR [ a ] [ b ]
    step a b with pairTrichotomy a b
    ... | inl h        = ‚à£ inl h ‚à£‚ÇÅ
    ... | inr (inl r)  = ‚à£ inr (inl (eq/ a b r)) ‚à£‚ÇÅ
    ... | inr (inr k)  = ‚à£ inr (inr k) ‚à£‚ÇÅ
