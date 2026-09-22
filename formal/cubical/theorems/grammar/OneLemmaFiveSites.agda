{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- OneLemmaFiveSites
--
-- One lemma stands at five sites in this repository.  This
-- file derives the instances FROM
-- `TranscriptDescent.collisionObstructsDecoder`.
--
-- ‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î
-- A DISTINCTION BETWEEN TWO ROUTES
--
-- Not all five sites are collisions.  Two routes reach the same
-- conclusion, and which one is available depends on the DECODER SPACE:
--
--   COLLISION   ‚î when the decoders are unconstrained, exhibit two points
--                 the coarse map identifies and the fine map separates.
--                 One pair kills every decoder at once.  `Laghava`,
--                 `Anuvrtti`, `CarryBorrowObservation`.
--
--   EXHAUSTION  ‚î when the decoders form a small finite set, refute each
--                 in turn.  `Saptabhangi.no-single-vacana` does this over
--                 six utterances.
--
-- The conclusion is shared; the route is not.
------------------------------------------------------------------------

module OneLemmaFiveSites where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Sigma
open import Cubical.Relation.Nullary using (¬¨_)

open import FiniteInformation using (FactorsThrough)
open import TranscriptDescent using (collisionObstructsDecoder)

open import Laghava using (eval ; size ; laghava-collision)
open import Anuvrtti using (asSet ; cost ; anuvrtti-collision)

------------------------------------------------------------------------
-- 1.  ‡≤‡æ‡ò‡µ, derived from the general lemma
------------------------------------------------------------------------

laghava-noFactor : ¬¨ FactorsThrough eval size
laghava-noFactor =
  collisionObstructsDecoder eval size
    {x = laghava-collision .fst} {x' = laghava-collision .snd .fst}
    (laghava-collision .snd .snd .fst)
    (laghava-collision .snd .snd .snd)

------------------------------------------------------------------------
-- 2.  ‡‡®‡‡µ‡‡‡‡‡ø, likewise
------------------------------------------------------------------------

anuvrtti-noFactor : ¬¨ FactorsThrough asSet cost
anuvrtti-noFactor =
  collisionObstructsDecoder asSet cost
    {x = anuvrtti-collision .fst} {x' = anuvrtti-collision .snd .fst}
    (anuvrtti-collision .snd .snd .fst)
    (anuvrtti-collision .snd .snd .snd)

------------------------------------------------------------------------
-- 3.  What this leaves.
--
-- `Laghava` and `Anuvrtti` need no private copy of the argument:
-- their collisions are the data, and the corpus's own lemma is the proof.
-- `CarryBorrowObservation` is stated this way too.
------------------------------------------------------------------------

------------------------------------------------------------------------
-- 4.  TWO PROFILES SUFFICE.
--
-- `TwoProfilesSuffice` exhibits the pair:
--
--     œ‚ = (‚ä,‚ä,‚ä)   œ‚ = (‚ä,‚ä,‚ä)
--
-- The joint content is false on both, and the six utterances split
-- three-three by which profile they overshoot on ‚î agreement sets
-- disjoint and together exhaustive ‚î so the pair refutes every
-- utterance and avaktavya follows from two witnesses, not six cases.
--
-- As theorems:
--
--   * ONE profile never suffices (`every-profile-is-said`,
--     `no-single-separator`);
--   * TWO do (`pair-separates`).
--
-- The invariant is the
-- NUMBER OF WITNESSES: 1 for ‡≤‡æ‡ò‡µ, ‡‡®‡‡µ‡‡‡‡‡ø, carry/borrow and the fuel
-- obstructions; 2 for ‡‡µ‡ï‡‡‡µ‡‡Ø.  Six was the size of the decoder space,
-- which is an upper bound anyone can read off a finite type, not a
-- measure of the absence.
------------------------------------------------------------------------
