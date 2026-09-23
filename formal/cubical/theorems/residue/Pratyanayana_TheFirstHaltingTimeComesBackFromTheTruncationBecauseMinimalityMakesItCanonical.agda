{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- ‡‡‡∞‡‡‡Ø‡æ‡®‡Ø‡® ‚î the bringing-back.  THE FIRST HALTING TIME COMES BACK
-- FROM THE TRUNCATION, BECAUSE MINIMALITY MAKES IT CANONICAL.
--
-- The corpus's wire doctrine says ‡®‡æ‡‡‡‡ø-‡‡‡∞‡‡‡Ø‡æ‡®‡Ø‡®‡Æ‡: ‚àA‚à‚ has no
-- retraction in general ‚î a collapse to "merely inhabited" cannot be
-- undone, which is why the wire carries no boolean.  This file proves
-- the exact boundary of that doctrine at the machine: the MERE fact
-- that a machine halts at some depth,  ‚à Œ n. HaltsAt n mc ‚à‚,
-- already yields the first halting time with its minimality
-- certificate, untruncated:
--
--   the-clock-needs-no-choice :
--     ‚à Œ n. HaltsAt n mc ‚à‚ ‚í Œ n. FirstHalt mc n
--
-- No choice principle, no excluded middle.  Two earlier theorems make
-- it possible: each finite depth is DECIDED with evidence either way
-- (TrtiyoMargoNaVidyate), so a bounded search walks down from any
-- witness ‚î the recursion stepping through the definitional equation
-- HaltsAt (suc m) mc = HaltsAt m (uStep mc) ‚î and the pair (first
-- time, minimality) is a PROPOSITION (AnulomaViloma), so the
-- truncation eliminates into it.
--
-- Read with the doctrine, not against it: the collapse loses nothing
-- exactly when the content is canonical.  An arbitrary witness cannot
-- be brought back ‚î WHICH depth someone observed is genuinely
-- forgotten ‚î but the LEAST depth is not somebody's observation; it
-- is the machine's own, and it returns.  The truncation destroys
-- choices and preserves canons; minimality is a canon.
------------------------------------------------------------------------

module Pratyanayana_TheFirstHaltingTimeComesBackFromTheTruncationBecauseMinimalityMakesItCanonical where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Sigma
open import Cubical.Data.Nat using (‚Ñï ; zero ; suc)
open import Cubical.Data.Nat.Order using (zero-‚â§ ; suc-‚â§-suc ; _‚â§_)
open import Cubical.Data.Sum using (_‚äé_ ; inl ; inr)
open import Cubical.Data.Empty as Empty using (‚ä•)
open import Cubical.Relation.Nullary using (¬¨_)
open import Cubical.HITs.PropositionalTruncation using (‚à•_‚à•‚ÇÅ ; ‚à£_‚à£‚ÇÅ ; rec)

open import Vishvamachine_TheTuringStepIsTheVisibleProjectionOfTheLosslessStepAndTheKeptFibreIsTheSource
open import AnulomaViloma_TheTraceComposesTheCompletedRunRunsBackwardsByReflAndWhenTheMachineHaltsIsAProposition
  using (HaltsAt ; FirstHalt ; halting-time-is-a-proposition)
open import TrtiyoMargoNaVidyate_EachStepIsATransportOrASilenceWithItsWitnessAndTheLimitIsNoThirdRoad
  using (each-depth-is-decided)

------------------------------------------------------------------------
-- ¬ß1  Bounded search: from any witness, the least one.
------------------------------------------------------------------------

-- Walking down from a halting witness at depth n.  The step is
-- definitional: HaltsAt (suc m) mc IS HaltsAt m (uStep mc).
search : (n : ‚Ñï) (mc : Machine) ‚Üí HaltsAt n mc ‚Üí Œ£[ k ‚àà ‚Ñï ] FirstHalt mc k
search zero    mc h = zero , h , (Œª m _ ‚Üí zero-‚â§)
search (suc n) mc h = go (each-depth-is-decided zero mc)
  where
  go : HaltsAt zero mc ‚äé (¬¨ HaltsAt zero mc) ‚Üí Œ£[ k ‚àà ‚Ñï ] FirstHalt mc k
  go (inl h‚ÇÄ)  = zero , h‚ÇÄ , (Œª m _ ‚Üí zero-‚â§)
  go (inr nh‚ÇÄ) =
    suc (fst deeper) ,
    fst (snd deeper) ,
    least
    where
    deeper : Œ£[ k ‚àà ‚Ñï ] FirstHalt (uStep mc) k
    deeper = search n (uStep mc) h

    least : (m : ‚Ñï) ‚Üí HaltsAt m mc ‚Üí suc (fst deeper) ‚â§ m
    least zero    hm = Empty.rec (nh‚ÇÄ hm)
    least (suc m) hm = suc-‚â§-suc (snd (snd deeper) m hm)

------------------------------------------------------------------------
-- ¬ß2  THE RETRACTION.
------------------------------------------------------------------------

-- Mere halting yields the first halting time, untruncated: the
-- truncation eliminates into the proposition (first time, minimality)
-- and the bounded search supplies the map.
the-clock-needs-no-choice : (mc : Machine) ‚Üí
  ‚à• Œ£[ n ‚àà ‚Ñï ] HaltsAt n mc ‚à•‚ÇÅ ‚Üí Œ£[ n ‚àà ‚Ñï ] FirstHalt mc n
the-clock-needs-no-choice mc =
  rec (halting-time-is-a-proposition mc)
      (Œª w ‚Üí search (fst w) mc (snd w))
