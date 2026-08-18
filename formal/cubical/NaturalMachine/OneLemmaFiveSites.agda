{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- NaturalMachine.OneLemmaFiveSites
--
-- `notes/THE_BARRIER_PROBLEM_IS_A_COLLISION.md` records that the same
-- lemma has been independently reinvented five times in this repository.
-- Reinvention is cheap to describe and cheap to keep describing; this
-- file removes it, by deriving the instances FROM
-- `TranscriptDescent.collisionObstructsDecoder` instead of beside it.
--
-- ────────────────────────────────────────────────────────────────────
-- AND A DISTINCTION THE "ONE LEMMA" STORY WAS HIDING
--
-- Not all five sites are collisions.  Two routes reach the same
-- conclusion, and which one is available depends on the DECODER SPACE:
--
--   COLLISION   — when the decoders are unconstrained, exhibit two points
--                 the coarse map identifies and the fine map separates.
--                 One pair kills every decoder at once.  `Laghava`,
--                 `Anuvrtti`, `CarryBorrowObservation`.
--
--   EXHAUSTION  — when the decoders form a small finite set, refute each
--                 in turn.  `Saptabhangi.no-single-vacana` does this over
--                 six utterances, and it must: no single pair of profiles
--                 separates the joint content from every utterance,
--                 because different utterances fail on different profiles.
--
-- The conclusion `¬ FactorsThrough` is shared; the route is not, and
-- reading five sites as "one lemma" would have flattened that.
--
-- CHECKED: Agda 2.6.3, cubical v0.5 — the container, not the repository
-- pin.  No postulates, no holes.
------------------------------------------------------------------------

module NaturalMachine.OneLemmaFiveSites where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Sigma
open import Cubical.Relation.Nullary using (¬_)

open import NaturalMachine.FiniteInformation using (FactorsThrough)
open import NaturalMachine.TranscriptDescent using (collisionObstructsDecoder)

open import NaturalMachine.Laghava using (eval ; size ; laghava-collision)
open import NaturalMachine.Anuvrtti using (asSet ; cost ; anuvrtti-collision)

------------------------------------------------------------------------
-- 1.  लाघव, derived from the general lemma
------------------------------------------------------------------------

laghava-noFactor : ¬ FactorsThrough eval size
laghava-noFactor =
  collisionObstructsDecoder eval size
    {x = laghava-collision .fst} {x' = laghava-collision .snd .fst}
    (laghava-collision .snd .snd .fst)
    (laghava-collision .snd .snd .snd)

------------------------------------------------------------------------
-- 2.  अनुवृत्ति, likewise
------------------------------------------------------------------------

anuvrtti-noFactor : ¬ FactorsThrough asSet cost
anuvrtti-noFactor =
  collisionObstructsDecoder asSet cost
    {x = anuvrtti-collision .fst} {x' = anuvrtti-collision .snd .fst}
    (anuvrtti-collision .snd .snd .fst)
    (anuvrtti-collision .snd .snd .snd)

------------------------------------------------------------------------
-- 3.  What this leaves.
--
-- `Laghava` and `Anuvrtti` no longer need private copies of the argument:
-- their collisions are the data, and the corpus's own lemma is the proof.
-- `CarryBorrowObservation` already did it this way, which is why it is
-- the one of the five that got it right first.
--
-- `AvaktavyaDoesNotFactor` stays as it is, and the header says why: its
-- route is exhaustion, not collision, because its decoder space is six
-- utterances and no single pair of profiles separates the joint content
-- from all of them.  Filing it under "the same lemma" would have been
-- tidier and wrong.
------------------------------------------------------------------------
