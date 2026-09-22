{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- TheFamiliesAgreeOffTheBoundarySoDifferOnlyIsNowBothDirections
--
-- ON THE NAME.  This is threshold arithmetic over ‚ï on this corpus's own
-- claim-families.
--
-- ‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î
-- THE AUDIT.  Target:
-- `TheStrictThresholdsAreTheSameChainAndDifferOnlyAtTheBoundary`.  Two
-- claim-words, so both were asked.
--
-- **`THE SAME CHAIN` IS EARNED, AND FOR THE REASON IT GIVES.**  `‚ä` is
-- stated on thresholds alone with no population in it, so a second
-- claim-family over the same thresholds inherits the order and its
-- totality with nothing re-proved; `aboveAntitone` is that inheritance.
-- The module says this itself and is right.
--
-- **`DIFFER ONLY AT THE BOUNDARY` WAS ONE INCLUSION AND ONE INSTANCE.**
-- Proved there: `aboveGivesAtLeast` (strict ‚í non-strict), and
-- `atLeastWithoutAbove`, a SINGLE population ‚î one true, one false ‚î where
-- the non-strict claim holds and the strict one fails. A single witness shows
-- the families differ SOMEWHERE.
--
-- **AND IT IS TWO LINES, BECAUSE ‚ï'S ORDER SPLITS.**  `‚â-split` gives
-- `m ‚â n ‚í (m < n) ‚ä (m ‚â° n)`, so `AtLeast` is exactly `Above` or
-- on-the-boundary, and the two alternatives exclude each other.
-- Diagnostic (1) called it in advance: what joins the two families is a
-- TRICHOTOMY ALREADY IN THE LIBRARY, so neither direction is a search.
--
-- ‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î
-- WHAT IS PROVED
--
--   OnTheBoundary        `p ¬ length bs ‚â° suc q ¬ count bs`, the
--                        equality case named
--   atLeastSplits        `AtLeast p q bs ‚í Above p q bs ‚ä OnTheBoundary p q bs`
--   aboveIsOffTheBoundary
--                        the disjuncts exclude each other
--   differOnlyAtTheBoundary
--                        off the boundary, non-strict ‚í strict ‚î the
--                        missing direction, which is what `ONLY` asserts
--   theFamiliesAgreeOffTheBoundary
--                        hence `AtLeast ‚ü∫ Above` at every population
--                        that does not meet the threshold exactly
------------------------------------------------------------------------

module TheFamiliesAgreeOffTheBoundarySoDifferOnlyIsNowBothDirections where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (‚Ñï ; suc ; _¬∑_)
open import Cubical.Data.Nat.Order using (_<_ ; ‚â§-split ; ¬¨m<m)
open import Cubical.Data.Bool using (Bool)
open import Cubical.Data.List using (List)
open import Cubical.Data.Sum using (_‚äé_ ; inl ; inr)
open import Cubical.Data.Sigma using (_√ó_ ; _,_)
open import Cubical.Data.Empty as ‚ä• using (‚ä•)
open import Cubical.Relation.Nullary using (¬¨_)

open import RateOneIsExactlyTheUniversalClaim
  using (count ; length)
open import TheThresholdOrderIsTotalAndTheClaimIsAntitone
  using (AtLeast)
open import TheStrictThresholdsAreTheSameChainAndDifferOnlyAtTheBoundary
  using (Above ; aboveGivesAtLeast)

------------------------------------------------------------------------
-- 1.  The boundary, named
------------------------------------------------------------------------

OnTheBoundary : ‚Ñï ‚Üí ‚Ñï ‚Üí List Bool ‚Üí Type
OnTheBoundary p q bs = p ¬∑ length bs ‚â° suc q ¬∑ count bs

------------------------------------------------------------------------
-- 2.  Non-strict is strict-or-boundary, and the two exclude each other
------------------------------------------------------------------------

atLeastSplits :
  (p q : ‚Ñï) (bs : List Bool)
  ‚Üí AtLeast p q bs ‚Üí Above p q bs ‚äé OnTheBoundary p q bs
atLeastSplits p q bs = ‚â§-split

aboveIsOffTheBoundary :
  (p q : ‚Ñï) (bs : List Bool)
  ‚Üí Above p q bs ‚Üí ¬¨ OnTheBoundary p q bs
aboveIsOffTheBoundary p q bs lt e =
  ¬¨m<m (subst (_< suc q ¬∑ count bs) e lt)

------------------------------------------------------------------------
-- 3.  So off the boundary the two families agree
------------------------------------------------------------------------

differOnlyAtTheBoundary :
  (p q : ‚Ñï) (bs : List Bool)
  ‚Üí AtLeast p q bs ‚Üí ¬¨ OnTheBoundary p q bs ‚Üí Above p q bs
differOnlyAtTheBoundary p q bs h ¬¨b with atLeastSplits p q bs h
... | inl lt = lt
... | inr e  = ‚ä•.rec (¬¨b e)

theFamiliesAgreeOffTheBoundary :
  (p q : ‚Ñï) (bs : List Bool)
  ‚Üí ¬¨ OnTheBoundary p q bs
  ‚Üí (AtLeast p q bs ‚Üí Above p q bs) √ó (Above p q bs ‚Üí AtLeast p q bs)
theFamiliesAgreeOffTheBoundary p q bs ¬¨b =
  (Œª h ‚Üí differOnlyAtTheBoundary p q bs h ¬¨b) , aboveGivesAtLeast p q bs
