{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- NaturalMachine.PunaragamanaMulyam
--
-- ‡‡‡®‡∞‡æ‡ó‡Æ‡®‡‡‡Ø ‡Æ‡‡≤‡‡Ø‡ ‡‡‡®‡‡Ø‡Æ‡ ‚î ‡® ‡ï‡‡µ‡≤‡Æ‡ ‡‡‡‡Æ‡ø‡®‡ ‡Ø‡®‡‡‡‡∞‡, ‡‡∞‡‡µ‡‡‡Æ‡ø‡®‡ ‡Ø‡ã‡ó‡‡Ø‡
-- ‡Æ‡‡≤‡‡Ø‡ ‡
--
-- (the price of the return is zero ‚î not for this machine, for EVERY
-- additive cost.)
--
-- ‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î
-- WHAT THIS CONNECTS
--
-- The owner's specification (2026-08-21) makes the machine's step a
-- CONJUGATION and not an action:
--
--     ‡‡‡®‡ (‡‡‡® v) = ‡‡‡® (‡‡µ‡‡∞‡ (Œ¶ (‡â‡‡‡‡æ‡® v)))
--
-- descend, act below, ascend.  `Punaragamanam_TheStepIsAConjugation‚¶`
-- and `VivekaPramana_TheRemainderIsLawful‚¶` establish that the ascent
-- and descent are an equivalence and that a remainder carried through
-- the step survives ‚î `‡‡≤‡ã‡‡` there proves it for all n by structural
-- recursion on that particular machine.
--
-- `NaturalMachine.TransportPrice` already proved the general fact, and
-- it is strictly stronger.  For ANY cost `c` on transports between
-- standpoints subject only to additivity,
--
--     loop-is-free : c p q + c q p ‚â° pos 0.
--
-- The descent-then-ascent of the owner's step is exactly such a round
-- trip.  So the step is free of charge under EVERY additive cost, and
-- the survival of the remainder is not a fact about ‚ï, about +, or
-- about this Œ¶ ‚î it is forced by the cost structure before any of those
-- are chosen.  ¬ß1 below is that instantiation.
--
-- The direction of the debt is worth stating: `‡‡≤‡ã‡‡` is the semantic
-- shadow of `loop-is-free`, not an independent result.  It was proved
-- second and it proves less.
--
-- ‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î
-- WHAT IS *NOT* CLAIMED
--
-- Not that the two standpoints below are the nayas TransportPrice was
-- written about; `Anekanta`'s standpoints are charts on a structure and
-- these are two presentations of one pair-type.  The theorem is
-- parametric in X and applies to both, which is the whole reason it can
-- be reused ‚î that is not an argument that the two are the same thing.
--
-- Not that Œ¶ is free: Œ¶ acts BELOW, and nothing here prices it.  Only
-- the descent and the ascent are round-tripped.  A machine whose Œ¶ is
-- expensive is expensive; the claim is that the CONJUGATION adds
-- nothing to it.
--
-- Not any verdict on `laghavaPrice` as the right potential for this
-- machine ‚î TransportPrice ¬ß2 supplies it for presentations and that is
-- its result, untouched here.
------------------------------------------------------------------------

module NaturalMachine.PunaragamanaMulyam_TheReturnTripIsFreeForEveryAdditiveCost where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Int using (‚Ñ§ ; pos ; _+_ ; _-_ ; -_)

open import NaturalMachine.TransportPrice using (Additive ; self-is-free ; loop-is-free ; cocycle‚Üícoboundary ; reverse)

------------------------------------------------------------------------
-- 1.  The two standpoints of the owner's machine, and the price of the
--     return trip between them.
------------------------------------------------------------------------

-- ‡Ø‡‡ó‡‡Æ is the pair presentation; ‡µ‡ø‡µ‡‡ï is the descended presentation.
data ‡§¶‡•É‡§∑‡•ç‡§ü‡§ø : Type where
  ‡§Ø‡•Å‡§ó‡•ç‡§Æ ‡§µ‡§ø‡§µ‡•á‡§ï : ‡§¶‡•É‡§∑‡•ç‡§ü‡§ø

module _ (‡§Æ‡•Ç‡§≤‡•ç‡§Ø : ‡§¶‡•É‡§∑‡•ç‡§ü‡§ø ‚Üí ‡§¶‡•É‡§∑‡•ç‡§ü‡§ø ‚Üí ‚Ñ§) (‡§Ø‡•ã‡§ó‡•ç‡§Ø : Additive ‡§Æ‡•Ç‡§≤‡•ç‡§Ø) where

  -- ‡‡µ‡‡∞‡‡Æ‡ then ‡â‡‡‡‡æ‡®‡Æ‡: the machine's conjugation, priced.
  ‡§™‡•Å‡§®‡§∞‡§æ‡§ó‡§Æ‡§®-‡§Æ‡•Ç‡§≤‡•ç‡§Ø‡§Æ‡•ç-‡§∂‡•Ç‡§®‡•ç‡§Ø‡§Æ‡•ç :
    ‡§Æ‡•Ç‡§≤‡•ç‡§Ø ‡§Ø‡•Å‡§ó‡•ç‡§Æ ‡§µ‡§ø‡§µ‡•á‡§ï + ‡§Æ‡•Ç‡§≤‡•ç‡§Ø ‡§µ‡§ø‡§µ‡•á‡§ï ‡§Ø‡•Å‡§ó‡•ç‡§Æ ‚â° pos 0
  ‡§™‡•Å‡§®‡§∞‡§æ‡§ó‡§Æ‡§®-‡§Æ‡•Ç‡§≤‡•ç‡§Ø‡§Æ‡•ç-‡§∂‡•Ç‡§®‡•ç‡§Ø‡§Æ‡•ç = loop-is-free ‡§Æ‡•Ç‡§≤‡•ç‡§Ø ‡§Ø‡•ã‡§ó‡•ç‡§Ø ‡§Ø‡•Å‡§ó‡•ç‡§Æ ‡§µ‡§ø‡§µ‡•á‡§ï

  -- and the ascent is exactly the negation of the descent, so the two
  -- are a bonded pair in the cost as well as in the types.
  ‡§â‡§§‡•ç‡§•‡§æ‡§®‡§Æ‡•ç-‡§™‡•ç‡§∞‡§§‡§ø‡§≤‡•ã‡§Æ‡§Æ‡•ç-‡§Ö‡§µ‡§§‡§∞‡§£‡§∏‡•ç‡§Ø :
    ‡§Æ‡•Ç‡§≤‡•ç‡§Ø ‡§µ‡§ø‡§µ‡•á‡§ï ‡§Ø‡•Å‡§ó‡•ç‡§Æ ‚â° - (‡§Æ‡•Ç‡§≤‡•ç‡§Ø ‡§Ø‡•Å‡§ó‡•ç‡§Æ ‡§µ‡§ø‡§µ‡•á‡§ï)
  ‡§â‡§§‡•ç‡§•‡§æ‡§®‡§Æ‡•ç-‡§™‡•ç‡§∞‡§§‡§ø‡§≤‡•ã‡§Æ‡§Æ‡•ç-‡§Ö‡§µ‡§§‡§∞‡§£‡§∏‡•ç‡§Ø = reverse ‡§Æ‡•Ç‡§≤‡•ç‡§Ø ‡§Ø‡•ã‡§ó‡•ç‡§Ø ‡§Ø‡•Å‡§ó‡•ç‡§Æ ‡§µ‡§ø‡§µ‡•á‡§ï

  -- staying in one presentation is free, and this is forced, not assumed
  ‡§∏‡•ç‡§•‡§ø‡§§‡§ø‡§É-‡§®‡§ø‡§∞‡•ç‡§Æ‡•Ç‡§≤‡•ç‡§Ø‡§æ : (d : ‡§¶‡•É‡§∑‡•ç‡§ü‡§ø) ‚Üí ‡§Æ‡•Ç‡§≤‡•ç‡§Ø d d ‚â° pos 0
  ‡§∏‡•ç‡§•‡§ø‡§§‡§ø‡§É-‡§®‡§ø‡§∞‡•ç‡§Æ‡•Ç‡§≤‡•ç‡§Ø‡§æ = self-is-free ‡§Æ‡•Ç‡§≤‡•ç‡§Ø ‡§Ø‡•ã‡§ó‡•ç‡§Ø

  -- all the content is in a potential on standpoints alone
  ‡§Æ‡•Ç‡§≤‡•ç‡§Ø‡§Ç-‡§™‡§¶‡§æ‡§∞‡•ç‡§•‡§≠‡•á‡§¶‡§É : (b p q : ‡§¶‡•É‡§∑‡•ç‡§ü‡§ø) ‚Üí ‡§Æ‡•Ç‡§≤‡•ç‡§Ø p q ‚â° (‡§Æ‡•Ç‡§≤‡•ç‡§Ø b q) - (‡§Æ‡•Ç‡§≤‡•ç‡§Ø b p)
  ‡§Æ‡•Ç‡§≤‡•ç‡§Ø‡§Ç-‡§™‡§¶‡§æ‡§∞‡•ç‡§•‡§≠‡•á‡§¶‡§É = cocycle‚Üícoboundary ‡§Æ‡•Ç‡§≤‡•ç‡§Ø ‡§Ø‡•ã‡§ó‡•ç‡§Ø
