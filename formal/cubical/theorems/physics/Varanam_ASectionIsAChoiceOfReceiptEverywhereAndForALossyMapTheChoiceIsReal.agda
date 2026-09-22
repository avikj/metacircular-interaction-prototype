{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- ‡µ‡∞‡‡Æ‡ ‚î ‡Ø‡‡‡∞ ‡® ‡ï‡ø‡û‡‡‡ø‡‡ ‡ó‡‡‡ ‡‡‡‡∞ ‡µ‡∞‡‡ ‡® ‡‡‡‡‡ø ‡
--
-- (where nothing is hidden there is no choosing.)
--
-- ‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î
-- A SECTION IS A CHOICE OF RECEIPT AT EVERY POINT.  Given `f : A ‚í B`, a
-- section picks, for each `b`, an inhabitant of the fibre over it ‚î a
-- preimage together with the witness that it IS one.  That is exactly
-- "choose a receipt everywhere", and this file prices the space of such
-- choices.
--
-- ¬ß‡® ¬ WHEN NOTHING IS HIDDEN, THERE IS NOTHING TO CHOOSE.  If `f` is an
-- equivalence, every fibre is contractible, so the space of sections is
-- contractible: the choice exists and is unique, which is to say it is
-- not a choice.
--
-- ¬ß‡© ¬ WHEN SOMETHING IS HIDDEN, THE CHOICE IS REAL.  `Bool ‚í Unit` has
-- two sections and they are distinct.  Nothing decides between them and
-- nothing in the codomain can see which was taken.
--
-- READ AT MOVEMENT 22.  Spontaneous symmetry breaking is the vacuum
-- choosing a point in a formerly free fibre, and mass is the coupling to
-- that paid receipt.  ¬ß‡© is that at the smallest scale: a two-point
-- vacuum manifold, two sections, no ground for preferring either, and the
-- observable blind to the choice.  ¬ß‡® is the other half and it is
-- `Dhruva`'s sentence from the section side ‚î a lossless world has
-- nothing to choose, exactly as it has nothing to conserve and nowhere to
-- move.
------------------------------------------------------------------------

module Varanam_ASectionIsAChoiceOfReceiptEverywhereAndForALossyMapTheChoiceIsReal where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.HLevels using (isContrŒ†)
open import Cubical.Foundations.Equiv using (isEquiv ; fiber ; idIsEquiv ; equiv-proof)
open import Cubical.Data.Bool using (Bool ; true ; false ; false‚â¢true)
open import Cubical.Data.Unit using (Unit ; tt)
open import Cubical.Data.Sigma using (_,_ ; fst ; snd)
open import Cubical.Relation.Nullary using (¬¨_)

private variable ‚Ñì : Level

------------------------------------------------------------------------
-- ‡ß ¬ ‡µ‡∞‡‡Æ‡ ‚î a choice of receipt at every point of the codomain.
------------------------------------------------------------------------

‡§µ‡§∞‡§£‡§Æ‡•ç : {A B : Type ‚Ñì} ‚Üí (A ‚Üí B) ‚Üí Type ‚Ñì
‡§µ‡§∞‡§£‡§Æ‡•ç {B = B} f = (b : B) ‚Üí fiber f b

------------------------------------------------------------------------
-- ‡® ¬ ‡‡ï‡‡‡Ø‡ ‡µ‡∞‡‡ ‡® ‚î no loss, no choosing.
--
-- Every fibre contractible makes the whole space of sections
-- contractible: there is a choice, it is unique, and therefore it is not
-- a choice at all.
------------------------------------------------------------------------

‡§Ö‡§ï‡•ç‡§∑‡§Ø‡•á-‡§µ‡§∞‡§£‡§Ç-‡§® : {A B : Type ‚Ñì} (f : A ‚Üí B) ‚Üí isEquiv f ‚Üí isContr (‡§µ‡§∞‡§£‡§Æ‡•ç f)
‡§Ö‡§ï‡•ç‡§∑‡§Ø‡•á-‡§µ‡§∞‡§£‡§Ç-‡§® f e = isContrŒ† (Œª b ‚Üí equiv-proof e b)

------------------------------------------------------------------------
-- ‡© ¬ ‡ï‡‡‡Ø‡ ‡µ‡∞‡‡ ‡‡‡ ‚î where a bit is hidden, the choice is real.
--
-- Two sections of `Bool ‚í Unit`, distinct, with nothing to decide between
-- them and nothing downstream able to see which was taken.
------------------------------------------------------------------------

‡§≤‡•ã‡§™‡§É : Bool ‚Üí Unit
‡§≤‡•ã‡§™‡§É _ = tt

‡§∏‡§¶‡•ç-‡§µ‡§∞‡§£‡§Æ‡•ç ‡§Ö‡§∏‡§¶‡•ç-‡§µ‡§∞‡§£‡§Æ‡•ç : ‡§µ‡§∞‡§£‡§Æ‡•ç ‡§≤‡•ã‡§™‡§É
‡§∏‡§¶‡•ç-‡§µ‡§∞‡§£‡§Æ‡•ç  _ = true  , refl
‡§Ö‡§∏‡§¶‡•ç-‡§µ‡§∞‡§£‡§Æ‡•ç _ = false , refl

‡§µ‡§∞‡§£‡•á-‡§≠‡•á‡§¶‡§É : ¬¨ (‡§∏‡§¶‡•ç-‡§µ‡§∞‡§£‡§Æ‡•ç ‚â° ‡§Ö‡§∏‡§¶‡•ç-‡§µ‡§∞‡§£‡§Æ‡•ç)
‡§µ‡§∞‡§£‡•á-‡§≠‡•á‡§¶‡§É p = false‚â¢true (cong (Œª s ‚Üí s tt .fst) (sym p))

-- and therefore the space of choices is not a point: something was
-- genuinely selected, and the codomain cannot say what.
‡§µ‡§∞‡§£-‡§∏‡•ç‡§•‡§æ‡§®‡§Ç-‡§®-‡§è‡§ï‡§Æ‡•ç : ¬¨ (isContr (‡§µ‡§∞‡§£‡§Æ‡•ç ‡§≤‡•ã‡§™‡§É))
‡§µ‡§∞‡§£-‡§∏‡•ç‡§•‡§æ‡§®‡§Ç-‡§®-‡§è‡§ï‡§Æ‡•ç c = ‡§µ‡§∞‡§£‡•á-‡§≠‡•á‡§¶‡§É (sym (c .snd ‡§∏‡§¶‡•ç-‡§µ‡§∞‡§£‡§Æ‡•ç) ‚àô c .snd ‡§Ö‡§∏‡§¶‡•ç-‡§µ‡§∞‡§£‡§Æ‡•ç)
