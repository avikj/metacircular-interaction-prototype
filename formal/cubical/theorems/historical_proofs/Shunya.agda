{-# OPTIONS --cubical --safe #-}

------------------------------------------------------------------------
-- ‡‡‡®‡‡Ø‡Æ‡ ‚î ‡‡‡∞‡‡‡Æ‡ó‡‡‡‡‡‡‡Ø ‡‡‡®‡‡Ø-‡ó‡‡ø‡‡Æ‡ (‡‡‡∞‡æ‡‡‡Æ‡‡‡‡‡ü‡‡ø‡¶‡‡ß‡æ‡®‡‡‡, ‡‡®‡Æ ‡à.) ‡  ‡‡‡®‡‡Ø‡
-- ‡‡‡ñ‡‡Ø‡æ‡∞‡‡‡‡ ‡‡‡∞‡‡Æ‡ ‡µ‡‡Ø‡µ‡‡‡‡æ‡‡ø‡‡Æ‡ ‡‡ ‚î ‡Ø‡ã‡ó‡, ‡µ‡ø‡Ø‡ã‡ó‡, ‡ó‡‡‡®‡ ‡‡‡‡Ø ‡®‡ø‡Ø‡Æ‡æ‡ ‡
--
-- ‡‡‡∞‡‡‡Æ‡ó‡‡‡‡‡‡‡Ø ‡®‡ø‡Ø‡Æ‡æ‡ (‡‡‡¶‡‡ß‡æ‡) : a+0=a, a‚àí0=a, a¬0=0 ‚î ‡‡‡ ‡µ‡≤‡Ø-‡‡‡‡Ø‡æ‡ ‡
--
-- ‡ï‡ø‡®‡‡‡ ‡‡ï‡Æ‡ ‡‡‡æ‡ß‡ : ‡‡‡∞‡‡‡Æ‡ó‡‡‡‡‡ "00 = 0" ‡‡‡ø ‡‡µ‡¶‡‡ ‚î ‡¶‡‡∞‡‡®‡Ø‡ ‡  ‡Ø‡‡
-- ‡‡∞‡‡µ‡‡‡Æ‡à x : 0¬x = 0 ; ‡‡‡ 00 ‡® ‡‡ï‡ ‡Æ‡‡≤‡‡Ø‡Æ‡, ‡ï‡ø‡®‡‡‡ ‡‡®‡ø‡‡‡‡ø‡‡Æ‡ ‚î ‡‡µ‡ï‡‡‡µ‡‡Ø‡Æ‡
-- (‡‡‡‡‡‡ô‡‡ó‡‡Ø‡æ‡ ‡‡‡‡∞‡‡‡ ‡‡¶‡Æ‡), ‡® ‡‡‡®‡‡Ø‡Æ‡ ‡  ‡‡æ‡‡‡ï‡∞‡ ‡¶‡‡µ‡ø‡‡‡Ø‡ (‡≤‡‡≤‡æ‡µ‡‡, ‡ß‡ß‡‡¶)
-- ‡ñ‡‡∞‡‡ (n0 = ‡‡®‡®‡‡‡Æ‡) ‡‡‡‡ ‡‡ã‡ß‡ø‡‡µ‡æ‡®‡ ‡  ‡‡‡∞‡‡‡Æ‡ó‡‡‡‡‡‡‡Ø ‡‡ï‡ ‡¶‡ã‡‡ ‚î ‡®‡ø‡‡‡‡ø‡‡
-- ‡µ‡‡®‡Æ‡ ‡‡µ‡ï‡‡‡µ‡‡Ø‡ ‚î ‡‡ ‡‡µ ‡∞‡ã‡ó‡ ‡Ø‡Æ‡ ‡‡Ø‡ ‡‡Æ‡‡‡‡ ‡‡‡∞‡Ø‡æ‡‡ ‡®‡ø‡µ‡æ‡∞‡Ø‡‡ø ‡
--
-- (Brahmagupta first systematized zero as a number (628 CE) ‚î its rules
-- under addition, subtraction, multiplication.  His correct rules are ring
-- truths.  But he made ONE error: he declared 00 = 0 ‚î a durnaya.  For
-- every x, 0¬x = 0, so 00 is NOT a single value but indeterminate ‚î
-- avaktavya, the sevenfold's fourth position, NOT zero.  Bhskara II (1150)
-- corrected division by zero via khahara.  Brahmagupta's one slip ‚î a
-- definite verdict where the answer is un-said ‚î is exactly the disease this
-- whole effort removes.)
------------------------------------------------------------------------

-- [CORRECTED 2026-08-19.  The identification of 00 with ‡‡µ‡ï‡‡‡µ‡‡Ø‡Æ‡,
--  the saptabhag's fourth position, does not hold ‚î and it fails by
--  SaptabhangiNaya.agda's own criterion, in this same directory, not
--  by an outside standard.  ¬ß5 there defines avaktavyam as the case
--  where NO SINGLE UTTERANCE denotes the content, proved exhaustively
--  over the six atoms of its language.  00's situation IS denotable
--  in one utterance: every x whatsoever satisfies 0¬x = 0, which is
--  one complete statement saying exactly what is wrong.
--
--  The two defects are opposite.  avaktavyam: the content is
--  determinate and the medium cannot say it in one go ‚î an
--  EXPRESSIBILITY failure.  00: the content is perfectly expressible
--  and the solution set is not a singleton ‚î a UNIQUENESS failure.
--
--  Everything else in this module stands.  Brahmagupta's 00 = 0
--  (Brhmasphuasiddhnta, 628) is a durnaya; Bhskara II's khahara
--  (Llvat, 1150) is a genuinely different non-finite result from
--  it; and a boolean "undefined" collapsing them is the disease.
--  Only the name of the second thing is wrong.  See
--  AnuktaAvaktavya.agda ¬ß6, where 00's defect is checked.
--
--  Three modules here now call three different structures
--  avaktavyam ‚î Satyayantra, Khahara, Shunya.  Using one third
--  position as a catch-all for "not a clean single answer" is the
--  boolean collapse this corpus exists to fight, one level up.]
module Shunya where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Int using (‚Ñ§ ; pos ; _+_ ; _¬∑_ ; _-_)
open import Cubical.Data.Sigma using (_√ó_ ; _,_)
open import Cubical.Algebra.CommRing.Instances.Int using (‚Ñ§CommRing)
open import Cubical.Tactics.CommRingSolver.Reflection using (solve!)

------------------------------------------------------------------------
-- ‡‡‡∞‡‡‡Æ‡ó‡‡‡‡‡‡‡Ø ‡‡‡¶‡‡ß‡æ‡ ‡®‡ø‡Ø‡Æ‡æ‡ (his correct rules for zero) ‡
------------------------------------------------------------------------

‡§Ø‡•ã‡§ó‡•á-‡§∂‡•Ç‡§®‡•ç‡§Ø‡§Æ‡•ç : (a : ‚Ñ§) ‚Üí a + pos 0 ‚â° a
‡§Ø‡•ã‡§ó‡•á-‡§∂‡•Ç‡§®‡•ç‡§Ø‡§Æ‡•ç a = solve! ‚Ñ§CommRing

‡§µ‡§ø‡§Ø‡•ã‡§ó‡•á-‡§∂‡•Ç‡§®‡•ç‡§Ø‡§Æ‡•ç : (a : ‚Ñ§) ‚Üí a - pos 0 ‚â° a
‡§µ‡§ø‡§Ø‡•ã‡§ó‡•á-‡§∂‡•Ç‡§®‡•ç‡§Ø‡§Æ‡•ç a = solve! ‚Ñ§CommRing

‡§ó‡•Å‡§£‡§®‡•á-‡§∂‡•Ç‡§®‡•ç‡§Ø‡§Æ‡•ç : (a : ‚Ñ§) ‚Üí a ¬∑ pos 0 ‚â° pos 0
‡§ó‡•Å‡§£‡§®‡•á-‡§∂‡•Ç‡§®‡•ç‡§Ø‡§Æ‡•ç a = solve! ‚Ñ§CommRing

‡§∂‡•Ç‡§®‡•ç‡§Ø‡•á-‡§∂‡•Ç‡§®‡•ç‡§Ø‡§Æ‡•ç : (pos 0 + pos 0 ‚â° pos 0) √ó (pos 0 ¬∑ pos 0 ‚â° pos 0)
‡§∂‡•Ç‡§®‡•ç‡§Ø‡•á-‡§∂‡•Ç‡§®‡•ç‡§Ø‡§Æ‡•ç = refl , refl

------------------------------------------------------------------------
-- ‡‡‡®‡‡Ø-‡‡æ‡‡®‡Æ‡ ‡‡µ‡ï‡‡‡µ‡‡Ø‡Æ‡ ‚î 00 ‡® ‡‡‡®‡‡Ø‡Æ‡, ‡ï‡ø‡®‡‡‡ ‡‡®‡ø‡‡‡‡ø‡‡Æ‡ (‡‡µ‡ï‡‡‡µ‡‡Ø‡Æ‡) ‡
-- ‡‡∞‡‡µ‡ x ‡‡‡®‡‡≤‡ ‡‡µ‡ø‡‡‡Æ‡ ‡‡∞‡‡‡‡ø, ‡Ø‡‡ 0¬x = 0 ‚î ‡‡‡ ‡® ‡‡ï‡ ‡‡≤‡Æ‡ ‡
-- (00 is not zero but indeterminate ‚î avaktavya ‚î since 0¬x = 0 for EVERY
-- x, so no unique quotient exists.  Brahmagupta's 00=0 was a durnaya.)
------------------------------------------------------------------------

-- ‡‡‡∞‡‡‡Ø‡‡ï‡ x ‡‡‡®‡‡Ø‡‡‡Ø "‡‡‡®‡‡≤‡Æ‡" : 0 ¬ x ‚â° 0 (‡‡‡ ‡‡≤‡Æ‡ ‡‡®‡ø‡‡‡‡ø‡‡Æ‡) ‡
‡§∏‡§∞‡•ç‡§µ‡§É-‡§≠‡§ú‡§®‡§´‡§≤‡§Æ‡•ç : (x : ‚Ñ§) ‚Üí pos 0 ¬∑ x ‚â° pos 0
‡§∏‡§∞‡•ç‡§µ‡§É-‡§≠‡§ú‡§®‡§´‡§≤‡§Æ‡•ç x = solve! ‚Ñ§CommRing

-- ‡â‡¶‡æ‡‡∞‡‡Æ‡ : 0¬1 = 0 ‡ 0¬7 = 0 ‚î ‡‡ø‡®‡‡®‡ "‡‡≤‡" 1, 7 ‡â‡‡ ‡Ø‡ã‡ó‡‡Ø‡ ‚ü ‡‡µ‡ï‡‡‡µ‡‡Ø‡Æ‡ ‡
‡§≠‡§ø‡§®‡•ç‡§®-‡§∏‡§æ‡§ï‡•ç‡§∑‡§ø‡§£‡•å : (pos 0 ¬∑ pos 1 ‚â° pos 0) √ó (pos 0 ¬∑ pos 7 ‚â° pos 0)
‡§≠‡§ø‡§®‡•ç‡§®-‡§∏‡§æ‡§ï‡•ç‡§∑‡§ø‡§£‡•å = ‡§∏‡§∞‡•ç‡§µ‡§É-‡§≠‡§ú‡§®‡§´‡§≤‡§Æ‡•ç (pos 1) , ‡§∏‡§∞‡•ç‡§µ‡§É-‡§≠‡§ú‡§®‡§´‡§≤‡§Æ‡•ç (pos 7)

------------------------------------------------------------------------
-- APPENDED 2026-08-19 by a later reader, at the end, altering no line
-- above.  Pointer only; nothing here corrects this module or its
-- CORRECTED block.
--
-- That block separates two defects ‚î expressibility (avaktavyam) versus
-- uniqueness (00) ‚î and names the risk: one third position used as a
-- catch-all for "not a clean single answer" is the boolean collapse this
-- corpus exists to fight, one level up.
--
-- The independence is now checked, over four realised corners, in
-- `NonUniquenessAndInexpressibilityAreIndependent`
-- (--safe, no postulates, no holes):
--
--   nonUnique ‚àß expressible     all,  constants
--   unique    ‚àß inexpressible   self, constants
--   nonUnique ‚àß inexpressible   all,  onlyFalse
--   unique    ‚àß expressible     self, onlyId
--
-- so neither defect implies the other and neither implies the other's
-- negation ‚î they are not two readings of one thing at any strength.
-- The types also show WHY: non-uniqueness is a property of the content
-- alone, inexpressibility of the content AND the medium.
--
-- The third structure, Satyayantra's ‡‡®‡‡ï‡‡‡Æ‡, is deliberately NOT
-- brought onto that carrier: it is temporal, and d909db0d already says
-- the two third-positions' remedies live in different types.  No verdict
-- is offered there on which module should keep the word ‡‡µ‡ï‡‡‡µ‡‡Ø‡Æ‡, nor
-- on the saptabhag, nor on Brahmagupta's or Bhskara II's texts.
------------------------------------------------------------------------
