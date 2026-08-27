{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- प्रत्यानयन — the bringing-back.  THE FIRST HALTING TIME COMES BACK
-- FROM THE TRUNCATION, BECAUSE MINIMALITY MAKES IT CANONICAL.
--
-- The corpus's wire doctrine says नास्ति-प्रत्यानयनम्: ∥A∥₁ has no
-- retraction in general — a collapse to "merely inhabited" cannot be
-- undone, which is why the wire carries no boolean.  This file proves
-- the exact boundary of that doctrine at the machine: the MERE fact
-- that a machine halts at some depth,  ∥ Σ n. HaltsAt n mc ∥₁,
-- already yields the first halting time with its minimality
-- certificate, untruncated:
--
--   the-clock-needs-no-choice :
--     ∥ Σ n. HaltsAt n mc ∥₁ → Σ n. FirstHalt mc n
--
-- No choice principle, no excluded middle.  Two earlier theorems make
-- it possible: each finite depth is DECIDED with evidence either way
-- (TrtiyoMargoNaVidyate), so a bounded search walks down from any
-- witness — the recursion stepping through the definitional equation
-- HaltsAt (suc m) mc = HaltsAt m (uStep mc) — and the pair (first
-- time, minimality) is a PROPOSITION (AnulomaViloma), so the
-- truncation eliminates into it.
--
-- Read with the doctrine, not against it: the collapse loses nothing
-- exactly when the content is canonical.  An arbitrary witness cannot
-- be brought back — WHICH depth someone observed is genuinely
-- forgotten — but the LEAST depth is not somebody's observation; it
-- is the machine's own, and it returns.  The truncation destroys
-- choices and preserves canons; minimality is a canon.
------------------------------------------------------------------------

module Pratyanayana_TheFirstHaltingTimeComesBackFromTheTruncationBecauseMinimalityMakesItCanonical where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Sigma
open import Cubical.Data.Nat using (ℕ ; zero ; suc)
open import Cubical.Data.Nat.Order using (zero-≤ ; suc-≤-suc ; _≤_)
open import Cubical.Data.Sum using (_⊎_ ; inl ; inr)
open import Cubical.Data.Empty as Empty using (⊥)
open import Cubical.Relation.Nullary using (¬_)
open import Cubical.HITs.PropositionalTruncation using (∥_∥₁ ; ∣_∣₁ ; rec)

open import Vishvayantra_TheTuringStepIsTheVisibleProjectionOfTheLosslessStepAndTheKeptFibreIsTheSource
open import AnulomaViloma_TheTraceComposesTheCompletedRunRunsBackwardsByReflAndWhenTheMachineHaltsIsAProposition
  using (HaltsAt ; FirstHalt ; halting-time-is-a-proposition)
open import TrtiyoMargoNaVidyate_EachStepIsATransportOrASilenceWithItsWitnessAndTheLimitIsNoThirdRoad
  using (each-depth-is-decided)

------------------------------------------------------------------------
-- §1  Bounded search: from any witness, the least one.
------------------------------------------------------------------------

-- Walking down from a halting witness at depth n.  The step is
-- definitional: HaltsAt (suc m) mc IS HaltsAt m (uStep mc).
search : (n : ℕ) (mc : Machine) → HaltsAt n mc → Σ[ k ∈ ℕ ] FirstHalt mc k
search zero    mc h = zero , h , (λ m _ → zero-≤)
search (suc n) mc h = go (each-depth-is-decided zero mc)
  where
  go : HaltsAt zero mc ⊎ (¬ HaltsAt zero mc) → Σ[ k ∈ ℕ ] FirstHalt mc k
  go (inl h₀)  = zero , h₀ , (λ m _ → zero-≤)
  go (inr nh₀) =
    suc (fst deeper) ,
    fst (snd deeper) ,
    least
    where
    deeper : Σ[ k ∈ ℕ ] FirstHalt (uStep mc) k
    deeper = search n (uStep mc) h

    least : (m : ℕ) → HaltsAt m mc → suc (fst deeper) ≤ m
    least zero    hm = Empty.rec (nh₀ hm)
    least (suc m) hm = suc-≤-suc (snd (snd deeper) m hm)

------------------------------------------------------------------------
-- §2  THE RETRACTION.
------------------------------------------------------------------------

-- Mere halting yields the first halting time, untruncated: the
-- truncation eliminates into the proposition (first time, minimality)
-- and the bounded search supplies the map.
the-clock-needs-no-choice : (mc : Machine) →
  ∥ Σ[ n ∈ ℕ ] HaltsAt n mc ∥₁ → Σ[ n ∈ ℕ ] FirstHalt mc n
the-clock-needs-no-choice mc =
  rec (halting-time-is-a-proposition mc)
      (λ w → search (fst w) mc (snd w))
