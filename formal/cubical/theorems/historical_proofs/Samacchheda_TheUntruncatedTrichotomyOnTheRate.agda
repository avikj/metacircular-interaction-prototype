{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- Samacchheda_TheUntruncatedTrichotomyOnTheRate
--
-- ‡‡Æ‡‡‡‡‡¶ ¬ samacchheda ‚î "equal divisor": bringing two fractions to a
-- common denominator, which is how the  arithmetic tradition
-- compares and combines them (bhinna-parikarma ‚î Brahmagupta,
-- *Brhmasphuasiddhnta* 628; Bhskara II, *Llvat*, c. 1150).
-- Every comparison underneath this module is that operation:
-- `p ¬ suc q'` against `p' ¬ suc q` is the pair of numerators once the
-- divisors are equalised.  **No claim is made that trichotomy, or the
-- propositionality of a three-way sum, is stated in those texts** ‚î the
-- operation is theirs, the type theory is not.
--
-- ‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î
-- WHAT IS PROVED
--
--   isPropSum         `isProp` for a binary sum from the two component
--                     propositions and a separator, for ARBITRARY types
--   ‚äR-excludes-‚â°     `‚ü® x ‚äR y ‚ü© ‚í ¬ (x ‚â° y)`, on the quotient
--   isPropTriR        hence the three-way sum is a proposition
--   rateTrichotomy    `‚ü® x ‚äR y ‚ü© ‚ä ((x ‚â° y) ‚ä ‚ü® y ‚äR x ‚ü©)`,
--                     UNTRUNCATED
--
-- NO NOVELTY.  Trichotomy of the rationals is classical; `isPropSum` is
-- standard and cubical v0.5 happens not to export it.
--
------------------------------------------------------------------------

module Samacchheda_TheUntruncatedTrichotomyOnTheRate where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Structure using (‚ü®_‚ü© ; str)
open import Cubical.HITs.SetQuotients as SQ using (squash/)
open import Cubical.HITs.PropositionalTruncation as PT using (‚à•_‚à•‚ÇÅ)
open import Cubical.Data.Sum using (_‚äé_ ; inl ; inr)
open import Cubical.Data.Empty as ‚ä• using (‚ä•)
open import Cubical.Relation.Nullary using (¬¨_)

open import TheRateQuotientExistsAndMinimalityCannotLiveOnIt
  using (Rate)
open import TheRatesAreDenseAndTheMediantSurvivesTheQuotient
  using (_‚äèR_)
open import TheStrictRateOrderIsAnOrderAndTheClaimIsAntitoneOnIt
  using (‚äèR-irrefl)
open import AsymmetryOnTheRateIsFreeAndTheWeakClaimIsAntitoneToo
  using (‚äèR-asym)
open import TrichotomyIsCheapOnPairsAndTheLiftCostsATruncation
  using (rateTrichotomyTruncated)

------------------------------------------------------------------------
-- 1.  The generic lemma, where no quotient is in scope
------------------------------------------------------------------------

isPropSum :
  {A B : Type} ‚Üí isProp A ‚Üí isProp B ‚Üí (A ‚Üí B ‚Üí ‚ä•) ‚Üí isProp (A ‚äé B)
isPropSum pa pb sep (inl a) (inl a') = cong inl (pa a a')
isPropSum pa pb sep (inl a) (inr b)  = ‚ä•.rec (sep a b)
isPropSum pa pb sep (inr b) (inl a)  = ‚ä•.rec (sep a b)
isPropSum pa pb sep (inr b) (inr b') = cong inr (pb b b')

------------------------------------------------------------------------
-- 2.  The strict order excludes equality, on the quotient
------------------------------------------------------------------------

‚äèR-excludes-‚â° : (x y : Rate) ‚Üí ‚ü® x ‚äèR y ‚ü© ‚Üí ¬¨ (x ‚â° y)
‚äèR-excludes-‚â° x y h e = ‚äèR-irrefl y (subst (Œª z ‚Üí ‚ü® z ‚äèR y ‚ü©) e h)

------------------------------------------------------------------------
-- 3.  ‚¶so the sum is a proposition and the truncation comes off
------------------------------------------------------------------------

Tri : Rate ‚Üí Rate ‚Üí Type
Tri x y = ‚ü® x ‚äèR y ‚ü© ‚äé ((x ‚â° y) ‚äé ‚ü® y ‚äèR x ‚ü©)

isPropTriR : (x y : Rate) ‚Üí isProp (Tri x y)
isPropTriR x y =
  isPropSum (str (x ‚äèR y))
    (isPropSum (squash/ x y) (str (y ‚äèR x))
      (Œª e k ‚Üí ‚äèR-excludes-‚â° y x k (sym e)))
    (Œª h ‚Üí Œª { (inl e) ‚Üí ‚äèR-excludes-‚â° x y h e
             ; (inr k) ‚Üí ‚äèR-asym x y h k })

rateTrichotomy : (x y : Rate) ‚Üí Tri x y
rateTrichotomy x y =
  PT.rec (isPropTriR x y) (Œª t ‚Üí t) (rateTrichotomyTruncated x y)
