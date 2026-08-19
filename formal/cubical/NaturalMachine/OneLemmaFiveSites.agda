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

------------------------------------------------------------------------
-- 4.  CORRECTION, appended 2026-08-18.
--
-- §3 above and the header say `AvaktavyaDoesNotFactor` "stays as it is,
-- and the header says why: its route is exhaustion, not collision,
-- because its decoder space is six utterances and no single pair of
-- profiles separates the joint content from all of them."
--
-- The DISTINCTION is real.  The REASON is false.
-- `NaturalMachine.TwoProfilesSuffice` exhibits the pair:
--
--     φ₁ = (⊤,⊤,⊥)   φ₂ = (⊥,⊥,⊤)
--
-- The joint content is false on both, and the six utterances split
-- three-three by which profile they overshoot on — agreement sets
-- disjoint and together exhaustive — so the pair refutes every
-- utterance and avaktavya follows from two witnesses, not six cases.
--
-- What survives, now as theorems rather than as a reading:
--
--   * ONE profile never suffices (`every-profile-is-said`,
--     `no-single-separator`) — that half of the prose was right;
--   * TWO do (`pair-separates`).
--
-- So the invariant is not collision-versus-exhaustion.  It is the
-- NUMBER OF WITNESSES: 1 for लाघव, अनुवृत्ति, carry/borrow and the fuel
-- obstructions; 2 for अवक्तव्य.  Six was the size of the decoder space,
-- which is an upper bound anyone can read off a finite type, not a
-- measure of the absence.
--
-- The error's shape is worth keeping: this file was written to remove a
-- reinvented lemma, noticed a genuine distinction the "one lemma" story
-- was flattening, and then asserted a LOWER BOUND on witness count
-- ("no single pair") by reading an upper bound off the decoder space.
-- A lower bound needs its own proof.  §2 of the new module is that
-- proof for the bound 1.
------------------------------------------------------------------------
