{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- ListKit_OneImportPointAndNoNewDefinitions
--
-- ON THE NAME.  CLAUDE.md's naming rule (owner, 2026-08-19) says lead
-- with the tradition's term, and its guard says do not attach one where
-- the material is not from that tradition.  **This file is plumbing** —
-- `Any`, `Mem`, filters over lists — with no source in any tradition
-- and no mathematical content of its own, so it takes an English name
-- and says why.  Checked `.claude/hooks/priority-ledger.txt` and
-- `.claude/hooks/european-frame.txt` before naming; neither applies.
--
-- ────────────────────────────────────────────────────────────────────
-- WHAT THIS IS, AND WHAT IT DELIBERATELY IS NOT.
--
-- Renaming the fourth-corner base module two cycles ago exposed a
-- factoring fact: eleven modules import a file named for a position in
-- the saptabhaṅgī, and most of them want only `Any`, `decAny` and
-- `memberToAny` — list plumbing that landed there because that is where
-- it was first needed.  The corpus also carries **`All` three times and
-- `Mem` four times**, in modules named for unrelated theorems.
--
-- This module is ONE IMPORT POINT for the canonical copies.  It
-- **defines nothing**: every name below is re-exported from where it
-- already lives, so importing it cannot create a fourth copy of
-- anything, and deleting it would break nothing but convenience.
--
-- **`All` IS DELIBERATELY ABSENT.**  There are three definitions —
-- `TheParetoStratumIsDecidableAndTheFilterIsExact.All`,
-- `KramaAstiNasti_AnEnumerableRemedySetKillsTheFourthCorner.All`
-- (identical), `EveryRemainderMemberIsStrictlyDominated.AllL` (same
-- again, different name), and `RateOneIsExactlyTheUniversalClaim.All`
-- (a different, `Bool`-specific thing).  Re-exporting one would pick a
-- winner, and the real consolidation edits files whose authorship I
-- cannot establish — every commit in this repository is authored
-- "Claude".  So the consolidation is an OFFER, posted to
-- `collab/messages`, not an edit.
--
-- SYĀT — THE CLAIM, EXACTLY.  No theorem.  No claim that these are the right
-- primitives — `Mem` is a truncation-free `Any`, so it counts
-- duplicates, and a corpus that wanted sets rather than lists would
-- want different ones.  No claim that the four `Mem`s are
-- interchangeable: three are generic, one
-- (`ADisjointValidatorMakesAFlagUnusableAndInvisible.Mem`) is `ℕ`-only.
--
-- CHECKED on the CONTAINER (Agda 2.6.3, cubical v0.5 — NOT the declared
-- pin, Agda 2.8.0 + cubical v0.9).  --safe, no postulates, no holes.
------------------------------------------------------------------------

module ListKit_OneImportPointAndNoNewDefinitions where

open import KramaAstiNasti_TheFourthCornerCannotLiveOverAnEnumerableDecidableInstanceSet public
  using (Any ; decAny ; memberToAny)
open import ANonEmptyArchiveHasANonEmptyStratum public
  using (anyMap)
open import EveryRemainderMemberIsStrictlyDominated public
  using (anyToMember)
open import OneStepCoverageAndDisjointnessOfTheLayer public
  using (Mem ; memberOfFilterSatisfies ; memberOfFilterOutFails
        ; memberSplits ; noMemberInBoth)
open import TheStratificationCoversAndItsStrataArePairwiseDisjoint public
  using (MemSome ; filterDecSubset ; filterOutSubset)
open import EveryRemainderMemberIsBeatenByAStratumMember public
  using (memberIntoFilter)
open import TheStratumRankExistsAndDominationStrictlyLowersIt public
  using (memberIntoFilterOut)
open import TheParetoStratumIsDecidableAndTheFilterIsExact public
  using (filterDec ; filterDecOnlyKeepsSatisfiers ; filterDecKeepsEverySatisfier)
open import TheRemainderIsStrictlyShorterSoTheStratificationHasAMeasure public
  using (filterOut ; lengthL ; partitionLength
        ; nonEmptyFilterShortensTheComplement)
