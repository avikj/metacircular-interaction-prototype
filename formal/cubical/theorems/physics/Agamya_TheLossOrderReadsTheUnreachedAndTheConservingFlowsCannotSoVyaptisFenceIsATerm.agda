{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- ‡‡ó‡Æ‡‡Ø ‚î ‡‡ó‡Æ‡‡Ø‡ ‡‡¶‡ ‡‡‡∞‡ï‡‡‡ï‡æ‡ ‡® ‡‡‡‡Ø‡®‡‡‡ø, ‡µ‡‡Ø‡æ‡‡‡‡ø‡ ‡‡‡‡Ø‡‡ø ‡
--
-- (the unreached point: the conserving flows cannot see it; the loss
--  order can.)
--
-- ‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î
-- WHAT THIS FILLS.  `Vyapti_TheLossOrderIsCoarsening‚¶agda`'s fence says,
-- verbatim:
--
--     "**¬ß‡© and ¬ß‡ are one direction only.**  That `‡‡‡∞‡ï‡‡‡‡Æ‡ f ‚ä
--      ‡‡‡∞‡ï‡‡‡‡Æ‡ g` implies `f ‡µ‡‡Ø‡æ‡‡‡®‡ã‡‡ø g` is FALSE in general and no
--      weakened converse is offered."
--
-- The sentence stands in that file with no witness.  Per the corpus's own
-- discipline (an absence without a command is a rumor; a fence without a
-- counterexample is an estimate), this module makes it a term ‚î and the
-- witness turns out to say more than the fence asked for.
--
-- THE THEOREM.  There are observables f, g on one domain whose entire
-- conserving apparatus is IDENTICAL ‚î each conserving-flow space
-- `Œ[ Œ¶ ] ‡‡‡∞‡ï‡‡‡‡Æ‡` is contractible, so no invariant of the symmetry
-- data whatsoever separates them ‚î while the loss order still does:
-- `g ‡µ‡‡Ø‡æ‡‡‡®‡ã‡‡ø f` holds and `f ‡µ‡‡Ø‡æ‡‡‡®‡ã‡‡ø g` is refutable.  So ‡µ‡‡Ø‡æ‡‡‡‡ø is
-- NOT a function of the conserving flows: the order carries strictly
-- more than the symmetries, and ¬ß‡© of Vyapti (order ‚ü flows) cannot be
-- reversed even up to any weakening that factors through the flow space.
--
-- WHY, in the census's own vocabulary, which is the point of writing it:
-- a conserving flow is a section of the fibre family AT REACHED POINTS
-- (`SvaFiberVasa`: flows ‚â (a : A) ‚í fiber f (f a) ‚î every index is an
-- f a).  The mediator h of `f ‡µ‡‡Ø‡æ‡‡‡®‡ã‡‡ø g` is typed on the WHOLE
-- codomain.  A point of B outside f's image ‚î a ‡∞‡ø‡ï‡‡‡Æ‡ fibre, the
-- census's ‡‡µ‡ï‡‡‡µ‡‡Ø‡Æ‡ ‚î is invisible to every flow and every conservation
-- witness, and it is exactly where h can die.  Here it does: B = Bool
-- with the whole codomain unreached, C = ‚ä, and the mediator would be a
-- map Bool ‚í ‚ä.  The symmetry standpoint reads motion; the order reads
-- the map's whole codomain, silence included.  ‡Æ‡‡®‡ ‡® ‡®‡ø‡‡‡ß‡ cuts both
-- ways: the flows' silence about the unreached sector is not evidence
-- there is nothing there to owe.
--
-- ‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î
--
-- TERM.  ‡‡ó‡Æ‡‡Ø ‚î "not to be gone to", unreachable; ordinary 
-- (‡ó‡Æ‡ with negative prefix, gerundive).  The compound and its use here
-- for a codomain point outside the image are THIS FILE's; no text is
-- claimed for the term or for any statement below, per CLAUDE.md's
-- naming rule note 2.  The mathematics is cubical type theory
-- (Voevodsky), this repository's one admitted non-Indian frame.
------------------------------------------------------------------------

module Agamya_TheLossOrderReadsTheUnreachedAndTheConservingFlowsCannotSoVyaptisFenceIsATerm where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Function using (idfun)
open import Cubical.Foundations.HLevels using (isPropŒ£ ; inhProp‚ÜíisContr)
open import Cubical.Data.Empty using (‚ä•) renaming (rec to ‚ä•-rec)
open import Cubical.Data.Bool using (Bool ; true)
open import Cubical.Data.Sigma
open import Cubical.Relation.Nullary using (¬¨_)

open import Dhruva_TheSymmetryLivesInTheFibreAndWithoutALossThereIsNoSymmetry
  using (‡§∏‡§Ç‡§∞‡§ï‡•ç‡§∑‡§£‡§Æ‡•ç)
open import Vyapti_TheLossOrderIsCoarseningAndTheSymmetryMonoidGrowsMonotonicallyAlongIt
  using (_‡§µ‡•ç‡§Ø‡§æ‡§™‡•ç‡§®‡•ã‡§§‡§ø_)

------------------------------------------------------------------------
-- ‡ß ¬ The pair.  One domain (‚ä), two codomains: g reaches everything it
--     names (‚ä ‚î nothing), f names two points and reaches neither.
------------------------------------------------------------------------

f : ‚ä• ‚Üí Bool
f x = ‚ä•-rec x

g : ‚ä• ‚Üí ‚ä•
g = idfun ‚ä•

------------------------------------------------------------------------
-- ‡® ¬ The conserving apparatus is identical: both flow spaces are
--     contractible, so NO invariant of the symmetries separates f from g.
--     (Everything out of ‚ä is a proposition; the identity flow inhabits.)
------------------------------------------------------------------------

private
  -- any two functions out of ‚ä are equal
  ‡§∂‡•Ç‡§®‡•ç‡§Ø-Œ†-prop : {‚Ñì : Level} {P : ‚ä• ‚Üí Type ‚Ñì} ‚Üí isProp ((x : ‚ä•) ‚Üí P x)
  ‡§∂‡•Ç‡§®‡•ç‡§Ø-Œ†-prop u v = funExt (Œª x ‚Üí ‚ä•-rec x)

‡§™‡•ç‡§∞‡§µ‡§æ‡§π-‡§ï‡•ç‡§∑‡•á‡§§‡•ç‡§∞‡§Æ‡•ç : (h : ‚ä• ‚Üí Bool) ‚Üí Type
‡§™‡•ç‡§∞‡§µ‡§æ‡§π-‡§ï‡•ç‡§∑‡•á‡§§‡•ç‡§∞‡§Æ‡•ç h = Œ£[ Œ¶ ‚àà (‚ä• ‚Üí ‚ä•) ] ‡§∏‡§Ç‡§∞‡§ï‡•ç‡§∑‡§£‡§Æ‡•ç h Œ¶

f-‡§™‡•ç‡§∞‡§µ‡§æ‡§π-‡§∏‡§Ç‡§ï‡•ã‡§ö‡§É : isContr (Œ£[ Œ¶ ‚àà (‚ä• ‚Üí ‚ä•) ] ‡§∏‡§Ç‡§∞‡§ï‡•ç‡§∑‡§£‡§Æ‡•ç f Œ¶)
f-‡§™‡•ç‡§∞‡§µ‡§æ‡§π-‡§∏‡§Ç‡§ï‡•ã‡§ö‡§É =
  inhProp‚ÜíisContr (idfun ‚ä• , Œª a ‚Üí ‚ä•-rec a)
    (isPropŒ£ ‡§∂‡•Ç‡§®‡•ç‡§Ø-Œ†-prop (Œª Œ¶ ‚Üí ‡§∂‡•Ç‡§®‡•ç‡§Ø-Œ†-prop))

g-‡§™‡•ç‡§∞‡§µ‡§æ‡§π-‡§∏‡§Ç‡§ï‡•ã‡§ö‡§É : isContr (Œ£[ Œ¶ ‚àà (‚ä• ‚Üí ‚ä•) ] ‡§∏‡§Ç‡§∞‡§ï‡•ç‡§∑‡§£‡§Æ‡•ç g Œ¶)
g-‡§™‡•ç‡§∞‡§µ‡§æ‡§π-‡§∏‡§Ç‡§ï‡•ã‡§ö‡§É =
  inhProp‚ÜíisContr (idfun ‚ä• , Œª a ‚Üí ‚ä•-rec a)
    (isPropŒ£ ‡§∂‡•Ç‡§®‡•ç‡§Ø-Œ†-prop (Œª Œ¶ ‚Üí ‡§∂‡•Ç‡§®‡•ç‡§Ø-Œ†-prop))

-- and conservation-inclusion holds in BOTH directions, vacuously ‚î
-- the hypothesis of the hoped-for converse is as strong as it can be.
‡§∏‡§Ç‡§∞‡§ï‡•ç‡§∑‡§£-‡§Ö‡§®‡•ç‡§§‡§∞‡•ç‡§≠‡§æ‡§µ‡§É : (Œ¶ : ‚ä• ‚Üí ‚ä•) ‚Üí ‡§∏‡§Ç‡§∞‡§ï‡•ç‡§∑‡§£‡§Æ‡•ç f Œ¶ ‚Üí ‡§∏‡§Ç‡§∞‡§ï‡•ç‡§∑‡§£‡§Æ‡•ç g Œ¶
‡§∏‡§Ç‡§∞‡§ï‡•ç‡§∑‡§£-‡§Ö‡§®‡•ç‡§§‡§∞‡•ç‡§≠‡§æ‡§µ‡§É Œ¶ _ a = ‚ä•-rec a

‡§∏‡§Ç‡§∞‡§ï‡•ç‡§∑‡§£-‡§™‡•ç‡§∞‡§§‡•ç‡§Ø‡§®‡•ç‡§§‡§∞‡•ç‡§≠‡§æ‡§µ‡§É : (Œ¶ : ‚ä• ‚Üí ‚ä•) ‚Üí ‡§∏‡§Ç‡§∞‡§ï‡•ç‡§∑‡§£‡§Æ‡•ç g Œ¶ ‚Üí ‡§∏‡§Ç‡§∞‡§ï‡•ç‡§∑‡§£‡§Æ‡•ç f Œ¶
‡§∏‡§Ç‡§∞‡§ï‡•ç‡§∑‡§£-‡§™‡•ç‡§∞‡§§‡•ç‡§Ø‡§®‡•ç‡§§‡§∞‡•ç‡§≠‡§æ‡§µ‡§É Œ¶ _ a = ‚ä•-rec a

------------------------------------------------------------------------
-- ‡© ¬ The order still separates them ‚î asymmetrically.
--     g ‡µ‡‡Ø‡æ‡‡‡®‡ã‡‡ø f holds; f ‡µ‡‡Ø‡æ‡‡‡®‡ã‡‡ø g is refutable, and the refuting
--     move is exactly an unreached point of f's codomain meeting a
--     mediator with nowhere to send it.
------------------------------------------------------------------------

‡§ó‡§Æ‡•ç‡§Ø‡§§‡•á : g ‡§µ‡•ç‡§Ø‡§æ‡§™‡•ç‡§®‡•ã‡§§‡§ø f
‡§ó‡§Æ‡•ç‡§Ø‡§§‡•á = (Œª x ‚Üí ‚ä•-rec x) , (Œª a ‚Üí ‚ä•-rec a)

‡§Ö‡§ó‡§Æ‡•ç‡§Ø‡§Æ‡•ç : ¬¨ (f ‡§µ‡•ç‡§Ø‡§æ‡§™‡•ç‡§®‡•ã‡§§‡§ø g)
‡§Ö‡§ó‡§Æ‡•ç‡§Ø‡§Æ‡•ç (h , _) = h true

------------------------------------------------------------------------
-- ‡ ¬ THE FENCE, AS A TERM.  Vyapti's "no weakened converse" holds
--     against the strongest possible hypothesis: even full two-way
--     conservation-inclusion PLUS equivalence of the entire conserving-
--     flow data (both contractible) does not yield the order.
------------------------------------------------------------------------

‡§µ‡•ç‡§Ø‡§æ‡§™‡•ç‡§§‡§ø-‡§®-‡§∏‡§Ç‡§∞‡§ï‡•ç‡§∑‡§£‡§∏‡•ç‡§Ø-‡§ï‡§æ‡§∞‡•ç‡§Ø‡§Æ‡•ç :
    ((Œ¶ : ‚ä• ‚Üí ‚ä•) ‚Üí ‡§∏‡§Ç‡§∞‡§ï‡•ç‡§∑‡§£‡§Æ‡•ç f Œ¶ ‚Üí ‡§∏‡§Ç‡§∞‡§ï‡•ç‡§∑‡§£‡§Æ‡•ç g Œ¶)
  √ó ((Œ¶ : ‚ä• ‚Üí ‚ä•) ‚Üí ‡§∏‡§Ç‡§∞‡§ï‡•ç‡§∑‡§£‡§Æ‡•ç g Œ¶ ‚Üí ‡§∏‡§Ç‡§∞‡§ï‡•ç‡§∑‡§£‡§Æ‡•ç f Œ¶)
  √ó isContr (Œ£[ Œ¶ ‚àà (‚ä• ‚Üí ‚ä•) ] ‡§∏‡§Ç‡§∞‡§ï‡•ç‡§∑‡§£‡§Æ‡•ç f Œ¶)
  √ó isContr (Œ£[ Œ¶ ‚àà (‚ä• ‚Üí ‚ä•) ] ‡§∏‡§Ç‡§∞‡§ï‡•ç‡§∑‡§£‡§Æ‡•ç g Œ¶)
  √ó (¬¨ (f ‡§µ‡•ç‡§Ø‡§æ‡§™‡•ç‡§®‡•ã‡§§‡§ø g))
‡§µ‡•ç‡§Ø‡§æ‡§™‡•ç‡§§‡§ø-‡§®-‡§∏‡§Ç‡§∞‡§ï‡•ç‡§∑‡§£‡§∏‡•ç‡§Ø-‡§ï‡§æ‡§∞‡•ç‡§Ø‡§Æ‡•ç =
    ‡§∏‡§Ç‡§∞‡§ï‡•ç‡§∑‡§£-‡§Ö‡§®‡•ç‡§§‡§∞‡•ç‡§≠‡§æ‡§µ‡§É
  , ‡§∏‡§Ç‡§∞‡§ï‡•ç‡§∑‡§£-‡§™‡•ç‡§∞‡§§‡•ç‡§Ø‡§®‡•ç‡§§‡§∞‡•ç‡§≠‡§æ‡§µ‡§É
  , f-‡§™‡•ç‡§∞‡§µ‡§æ‡§π-‡§∏‡§Ç‡§ï‡•ã‡§ö‡§É
  , g-‡§™‡•ç‡§∞‡§µ‡§æ‡§π-‡§∏‡§Ç‡§ï‡•ã‡§ö‡§É
  , ‡§Ö‡§ó‡§Æ‡•ç‡§Ø‡§Æ‡•ç
