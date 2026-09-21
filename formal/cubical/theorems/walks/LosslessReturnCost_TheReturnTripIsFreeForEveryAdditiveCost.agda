{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- LosslessReturnCost
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
-- The machine's step is a CONJUGATION and not an action:
--
--     ‡‡‡®‡ (‡‡‡® v) = ‡‡‡® (‡‡µ‡‡∞‡ (Œ¶ (‡â‡‡‡‡æ‡® v)))
--
-- descend, act below, ascend.  `LosslessReturn_TheStepIsAConjugation‚¶`
-- and `VivekaPramana_TheRemainderIsLawful‚¶` establish that the ascent
-- and descent are an equivalence and that a remainder carried through
-- the step survives ‚î `‡‡≤‡ã‡‡` there proves it for all n by structural
-- recursion on that particular machine.
--
-- `TransportPrice` already proved the general fact, and
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
-- `‡‡≤‡ã‡‡` is the semantic
-- shadow of `loop-is-free`, not an independent result.
------------------------------------------------------------------------

module LosslessReturnCost_TheReturnTripIsFreeForEveryAdditiveCost where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Int using (‚Ñ§ ; pos ; _+_ ; _-_ ; -_)

open import TransportPrice using (Additive ; self-is-free ; loop-is-free ; cocycle‚Üícoboundary ; reverse)

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
