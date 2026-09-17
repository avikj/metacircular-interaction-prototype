{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- ‡‡®‡‡µ‡‡‡‡Æ‡ ‚î ‡‡ó‡‡∞‡ ‡ó‡Æ‡®‡ ‡Æ‡‡ï‡‡‡Æ‡; ‡µ‡‡Ø‡Ø‡ ‡‡æ‡¶‡æ‡‡‡Æ‡‡Ø‡, ‡® ‡‡¶‡ ‡
--
-- (going forward is free; the cost is at identification, not at the step.)
--
-- ‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î
-- THE ROUTING CONSEQUENCE OF THE OTHER FILES, ASSEMBLED.  A search over a
-- graph of maps normally pays per EDGE.  Here it does not, and the three
-- facts that say so are already terms:
--
--   ¬ `Lekha_‚¶agda` ¬ß‡© ‚î the full trail of `n` steps, every intermediate
--     and every witness, is CONTRACTIBLE at every `n`.  Depth is free.
--   ¬ `LosslessReturn_‚¶agda` ¬ß‡® ‚î out and back in the CODOMAIN is free at
--     any loss: take a lossy edge, pick any preimage, return, and you are
--     exactly where you started.
--   ¬ `LosslessReturn_‚¶agda` ¬ß‡© ‚î out and back in the DOMAIN is not
--     available at all when a bit is destroyed.
--
-- ¬ß‡® below is the statement those three make together: **an arbitrarily
-- deep forward exploration, carrying its whole trail, costs nothing; and
-- what costs is a demanded return to the THING.**  So the frontier of a
-- search here is not the set of nodes reached.  It is the set of
-- identifications owed.
--
-- AND THE ROUTER'S CORRECTNESS CONDITION, which is `Anupalabdhi_‚¶agda`
-- read at a search: a router that reports "unreachable" because it did
-- not find a route has produced no term.  Absence of a route is a Œ† over
-- the whole field, not a failed traversal, so the only verdicts a search
-- may return are a route, a written defect, or UNDECIDED.  That is what
-- `interactive/Lopa_‚¶hs` already does by counting UNDECIDED separately rather
-- than guessing, on the stated ground that a verdict guessed is worse
-- than a verdict withheld.
--
-- CHECKED: Agda 2.6.3 + agda/cubical v0.5, --cubical --safe, no
-- postulates, no holes, exit 0.
------------------------------------------------------------------------

module Anvesanam_ForwardSearchIsFreeAtAnyDepthAndCostIsIncurredPerIdentificationDemandedNotPerEdgeTraversed where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.HLevels using (isContrŒ£)
open import Cubical.Data.Nat using (‚Ñï ; zero ; suc)
open import Cubical.Data.Sigma using (Œ£-syntax ; _,_ ; fst ; snd)
open import Cubical.Data.Unit using (Unit* ; isContrUnit*)

private variable ‚Ñì : Level

module _ {A : Type ‚Ñì} (step : A ‚Üí A) where

------------------------------------------------------------------------
-- ‡ß ¬ ‡‡®‡‡µ‡‡‡‡Æ‡ ‚î a forward exploration of depth n from a, carrying every
--     intermediate and every witness that it IS the intermediate.
------------------------------------------------------------------------

  ‡§Ö‡§®‡•ç‡§µ‡•á‡§∑‡§£‡§Æ‡•ç : ‚Ñï ‚Üí A ‚Üí Type ‚Ñì
  ‡§Ö‡§®‡•ç‡§µ‡•á‡§∑‡§£‡§Æ‡•ç zero    a = Unit*
  ‡§Ö‡§®‡•ç‡§µ‡•á‡§∑‡§£‡§Æ‡•ç (suc n) a = Œ£[ p ‚àà singl (step a) ] ‡§Ö‡§®‡•ç‡§µ‡•á‡§∑‡§£‡§Æ‡•ç n (p .fst)

------------------------------------------------------------------------
-- ‡® ¬ ‡‡ó‡‡∞‡-‡ó‡Æ‡®‡-‡Æ‡‡ï‡‡‡Æ‡ ‚î AND IT IS FREE AT EVERY DEPTH.
--
-- Not cheap, not amortized: contractible.  The exploration and its
-- entire audit trail contribute zero degrees of freedom, for every `n`,
-- with no hypothesis on `A` or on `step` ‚î however much `step` destroys.
--
-- So depth is not what a search here pays for.  What it pays for is
-- named in the header and is the other binding entirely.
------------------------------------------------------------------------

  ‡§Ö‡§ó‡•ç‡§∞‡•á-‡§ó‡§Æ‡§®‡§Ç-‡§Æ‡•Å‡§ï‡•ç‡§§‡§Æ‡•ç : (n : ‚Ñï) (a : A) ‚Üí isContr (‡§Ö‡§®‡•ç‡§µ‡•á‡§∑‡§£‡§Æ‡•ç n a)
  ‡§Ö‡§ó‡•ç‡§∞‡•á-‡§ó‡§Æ‡§®‡§Ç-‡§Æ‡•Å‡§ï‡•ç‡§§‡§Æ‡•ç zero    a = isContrUnit*
  ‡§Ö‡§ó‡•ç‡§∞‡•á-‡§ó‡§Æ‡§®‡§Ç-‡§Æ‡•Å‡§ï‡•ç‡§§‡§Æ‡•ç (suc n) a =
    isContrŒ£ (isContrSingl (step a)) (Œª p ‚Üí ‡§Ö‡§ó‡•ç‡§∞‡•á-‡§ó‡§Æ‡§®‡§Ç-‡§Æ‡•Å‡§ï‡•ç‡§§‡§Æ‡•ç n (p .fst))

------------------------------------------------------------------------
-- ‡© ¬ ‡‡‡‡ ‚î what a search still owes.
--
-- ¬ß‡® says nothing about whether any particular target is REACHED; it
-- prices the exploration, not the answer.  Reachability is a fibre
-- question, its three verdicts are `Tantutrayam_‚¶agda`'s, and its empty
-- case is `Anupalabdhi_‚¶agda`'s Œ† over the whole field.  A search that
-- conflates "I explored and did not arrive" with "there is no route" has
-- produced the one verdict this corpus has no witness for.
------------------------------------------------------------------------
