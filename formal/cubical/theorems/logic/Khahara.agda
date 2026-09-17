{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- ‡ñ‡‡∞‡ ‚î ‡‡æ‡‡‡ï‡∞‡‡‡Ø ‡¶‡‡µ‡ø‡‡‡Ø‡‡‡Ø ‡‡‡®‡‡Ø-‡‡∞-‡∞‡æ‡‡ø‡ (‡≤‡‡≤‡æ‡µ‡‡, ‡‡‡‡ó‡‡ø‡‡Æ‡, ‡ß‡ß‡‡¶ ‡à.) ‡
-- ‡‡‡∞‡‡‡Æ‡ó‡‡‡‡‡‡‡Ø ‡‡ã‡ß‡®‡Æ‡ : n0 (n‚â†0) ‡® ‡‡‡®‡‡Ø‡Æ‡, ‡ï‡ø‡®‡‡‡ "‡ñ‡‡∞‡" ‚î ‡‡®‡®‡‡-‡∞‡æ‡‡ø‡,
-- ‡Ø‡ ‡‡‡‡Æ-‡Ø‡ã‡ó‡‡® ‡µ‡ø‡Ø‡ã‡ó‡‡® ‡ ‡‡µ‡ø‡ï‡‡‡ (‡ñ‡‡∞‡ ‡‡‡‡Æ‡ø‡®‡ ‡® ‡µ‡ø‡ï‡æ‡∞‡) ‡
--
-- ‡‡‡ï‡‡‡‡Æ-‡‡‡¶‡ (Shunya-‡‡Æ‡‡‡®‡‡ß‡) : n0 (n‚â†0) = ‡ñ‡‡∞‡ (‡‡®‡®‡‡‡, ‡®‡ø‡‡‡‡ø‡‡) ;
-- ‡ï‡ø‡®‡‡‡ 00 = ‡‡µ‡ï‡‡‡µ‡‡Ø‡Æ‡ (‡‡®‡ø‡‡‡‡ø‡‡Æ‡, ‡‡‡‡‡‡ô‡‡ó‡‡Ø‡æ‡ ‡‡∞‡‡‡ ‡‡¶‡Æ‡), ‡® ‡ñ‡‡∞‡ ‡
-- ‡¶‡‡µ‡ ‡‡ø‡®‡‡®‡ "‡‡‡‡®‡‡Ø-‡‡∞‡" : ‡‡ï‡ ‡‡®‡®‡‡‡, ‡‡‡∞‡ ‡‡µ‡ï‡‡‡µ‡‡Ø‡ ‡  ‡‡ ‡‡µ ‡‡‡ï‡‡‡‡Æ‡
-- ‡µ‡ø‡µ‡‡ï‡ ‡Ø‡Æ‡ ‡‡‡≤‡ø‡Ø‡®‡-‡ó‡‡ø‡‡ (‡‡ï‡ "undefined") ‡≤‡‡Æ‡‡‡‡ø ‡
--
-- (Bhskara II's khahara ‚î the zero-divided quantity (Llvat, 1150),
-- correcting Brahmagupta: n0 (n‚â†0) is not zero but khahara, an infinite
-- quantity UNCHANGED by adding or subtracting a finite amount.  And the
-- fine distinction with Shunya: n0 (n‚â†0) = khahara (determinate infinite),
-- whereas 00 = avaktavya (indeterminate, the un-said) ‚î two DIFFERENT
-- non-finite results that a boolean "undefined" collapses into one.)
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
module Khahara where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Int using (‚Ñ§ ; pos ; _+_ ; _-_)
open import Cubical.Data.Empty using (‚ä•)
open import Cubical.Data.Unit using (Unit ; tt)
open import Cubical.Relation.Nullary using (¬¨_)

------------------------------------------------------------------------
-- ‡ñ‡‡∞ ‚î ‡‡‡‡Æ‡ (finite ‚) ‡µ‡æ ‡‡®‡®‡‡‡ (khahara) ‡
------------------------------------------------------------------------

data ‡§ñ‡§π‡§∞ : Type where
  ‡§∏‡§∏‡•Ä‡§Æ : ‚Ñ§ ‚Üí ‡§ñ‡§π‡§∞
  ‡§Ö‡§®‡§®‡•ç‡§§ : ‡§ñ‡§π‡§∞          -- ‡§≠‡§æ‡§∏‡•ç‡§ï‡§∞‡§∏‡•ç‡§Ø ‡§ñ‡§π‡§∞‡§É

------------------------------------------------------------------------
-- ‚äï , ‚äñ ‚î ‡Ø‡ã‡ó‡ ‡µ‡ø‡Ø‡ã‡ó‡‡‡ ‡  ‡‡®‡®‡‡‡ ‡‡‡‡Æ‡‡® ‡‡µ‡ø‡ï‡‡‡ (Bhskara's law) ‡
------------------------------------------------------------------------

_‚äï_ : ‡§ñ‡§π‡§∞ ‚Üí ‡§ñ‡§π‡§∞ ‚Üí ‡§ñ‡§π‡§∞
‡§∏‡§∏‡•Ä‡§Æ a ‚äï ‡§∏‡§∏‡•Ä‡§Æ b = ‡§∏‡§∏‡•Ä‡§Æ (a + b)
‡§Ö‡§®‡§®‡•ç‡§§  ‚äï _       = ‡§Ö‡§®‡§®‡•ç‡§§
‡§∏‡§∏‡•Ä‡§Æ _ ‚äï ‡§Ö‡§®‡§®‡•ç‡§§   = ‡§Ö‡§®‡§®‡•ç‡§§

_‚äñ_ : ‡§ñ‡§π‡§∞ ‚Üí ‡§ñ‡§π‡§∞ ‚Üí ‡§ñ‡§π‡§∞
‡§∏‡§∏‡•Ä‡§Æ a ‚äñ ‡§∏‡§∏‡•Ä‡§Æ b = ‡§∏‡§∏‡•Ä‡§Æ (a - b)
‡§Ö‡§®‡§®‡•ç‡§§  ‚äñ _       = ‡§Ö‡§®‡§®‡•ç‡§§
‡§∏‡§∏‡•Ä‡§Æ _ ‚äñ ‡§Ö‡§®‡§®‡•ç‡§§   = ‡§Ö‡§®‡§®‡•ç‡§§

------------------------------------------------------------------------
-- ‡‡æ‡‡‡ï‡∞-‡®‡ø‡Ø‡Æ‡ ‚î ‡ñ‡‡∞‡ ‡® ‡µ‡ø‡ï‡æ‡∞‡ : ‡‡®‡®‡‡‡ ‡‡‡‡Æ-‡Ø‡ã‡ó‡‡® ‡µ‡ø‡Ø‡ã‡ó‡‡® ‡ ‡‡µ‡ø‡ï‡‡‡ ‡
-- (Bhskara's law: khahara is unchanged by adding or subtracting a finite.)
------------------------------------------------------------------------

‡§ñ‡§π‡§∞‡•á-‡§®-‡§µ‡§ø‡§ï‡§æ‡§∞‡§É-‡§Ø‡•ã‡§ó‡•á : (a : ‚Ñ§) ‚Üí (‡§Ö‡§®‡§®‡•ç‡§§ ‚äï ‡§∏‡§∏‡•Ä‡§Æ a) ‚â° ‡§Ö‡§®‡§®‡•ç‡§§
‡§ñ‡§π‡§∞‡•á-‡§®-‡§µ‡§ø‡§ï‡§æ‡§∞‡§É-‡§Ø‡•ã‡§ó‡•á a = refl

‡§ñ‡§π‡§∞‡•á-‡§®-‡§µ‡§ø‡§ï‡§æ‡§∞‡§É-‡§µ‡§ø‡§Ø‡•ã‡§ó‡•á : (a : ‚Ñ§) ‚Üí (‡§Ö‡§®‡§®‡•ç‡§§ ‚äñ ‡§∏‡§∏‡•Ä‡§Æ a) ‚â° ‡§Ö‡§®‡§®‡•ç‡§§
‡§ñ‡§π‡§∞‡•á-‡§®-‡§µ‡§ø‡§ï‡§æ‡§∞‡§É-‡§µ‡§ø‡§Ø‡•ã‡§ó‡•á a = refl

-- ‡ñ‡‡∞‡ ‡ñ‡‡∞‡‡ ‡‡ ‡‡‡ø ‡ñ‡‡∞‡ (khahara + khahara = khahara)
‡§ñ‡§π‡§∞-‡§ñ‡§π‡§∞ : (‡§Ö‡§®‡§®‡•ç‡§§ ‚äï ‡§Ö‡§®‡§®‡•ç‡§§) ‚â° ‡§Ö‡§®‡§®‡•ç‡§§
‡§ñ‡§π‡§∞-‡§ñ‡§π‡§∞ = refl

------------------------------------------------------------------------
-- ‡‡‡®‡Æ‡ ‚î n0 (n‚â†0) = ‡ñ‡‡∞‡ (‡‡®‡®‡‡‡) ; ‡‡‡ Shunya-‡‡µ‡ï‡‡‡µ‡‡Ø‡æ‡‡ (00) ‡‡ø‡®‡‡®‡Æ‡ ‡
-- ‡‡‡‡∞ ‡‡∞‡ ‡‡‡®‡‡Ø‡ ‡‡‡ø ‡®‡ø‡∞‡‡¶‡ø‡‡‡Ø ‡‡≤‡ ‡ñ‡‡∞‡Æ‡ ‡‡¶‡ø‡‡æ‡Æ‡ ‚î ‡‡æ‡‡‡ï‡∞‡‡‡Ø ‡¶‡‡‡‡ü‡ø‡ ‡
-- (dividing a nonzero by zero yields khahara ‚î distinct from Shunya's 00,
-- which is avaktavya.  Two non-finite outcomes, kept apart, not collapsed.)
------------------------------------------------------------------------

-- ‡‡‡®‡‡Ø-‡‡∞‡ (‡‡‡‡®‡‡Ø-‡‡‡‡) ‡‡≤‡Æ‡ ‡ñ‡‡∞‡, ‡® ‡‡‡‡Æ‡, ‡® ‡‡µ‡ï‡‡‡µ‡‡Ø‡ ‡
‡§∂‡•Ç‡§®‡•ç‡§Ø-‡§π‡§∞‡§É : ‚Ñ§ ‚Üí ‡§ñ‡§π‡§∞          -- ‡§Ö‡§Ç‡§∂‡§É n (‚â†0 ‡§Ö‡§≠‡§ø‡§™‡•ç‡§∞‡•á‡§§‡§É) ; ‡§π‡§∞‡§É 0 ‚üπ ‡§ñ‡§π‡§∞‡§É
‡§∂‡•Ç‡§®‡•ç‡§Ø-‡§π‡§∞‡§É _ = ‡§Ö‡§®‡§®‡•ç‡§§

-- ‡‡‡ ‡Ø‡‡ ‡ï‡ø‡û‡‡‡ø‡‡ ‡‡‡‡Æ‡ ‡‡‡® ‡Ø‡ã‡‡ø‡‡ ‡ñ‡‡∞‡ ‡® ‡‡‡‡Æ‡ ‡ï‡∞‡ã‡‡ø (‡‡®‡®‡‡‡‡‡µ‡ ‡‡‡‡ø‡∞‡Æ‡) ‡
‡§Ö‡§®‡§®‡•ç‡§§‡§§‡•ç‡§µ-‡§∏‡•ç‡§•‡•à‡§∞‡•ç‡§Ø‡§Æ‡•ç : (n a : ‚Ñ§) ‚Üí (‡§∂‡•Ç‡§®‡•ç‡§Ø-‡§π‡§∞‡§É n ‚äï ‡§∏‡§∏‡•Ä‡§Æ a) ‚â° ‡§∂‡•Ç‡§®‡•ç‡§Ø-‡§π‡§∞‡§É n
‡§Ö‡§®‡§®‡•ç‡§§‡§§‡•ç‡§µ-‡§∏‡•ç‡§•‡•à‡§∞‡•ç‡§Ø‡§Æ‡•ç n a = refl

------------------------------------------------------------------------
-- ‡ñ‡‡∞‡ ‡® ‡‡‡‡Æ‡ ‚î ‡‡æ‡‡‡ï‡∞‡‡‡Ø ‡‡‡∞‡‡‡Æ‡ó‡‡‡‡-‡‡ã‡ß‡®‡Æ‡, ‡‡¶‡-‡ï‡‡‡Æ‡ : n0 (‡‡®‡®‡‡‡) ‡ï‡‡‡Æ‡æ‡¶‡‡ø
-- ‡‡‡‡Æ‡æ‡‡ ‡‡ø‡®‡‡®‡ ‚î ‡µ‡ø‡‡‡‡‡ ‡‡‡®‡‡Ø‡æ‡‡ ‡® ‡  ‡‡‡∞‡‡‡Æ‡ó‡‡‡‡‡ 00=0 (‡¶‡‡∞‡‡®‡Ø‡) ‡‡ ;
-- ‡‡æ‡‡‡ï‡∞‡ ‡ñ‡‡∞‡Æ‡ ‡‡®‡®‡‡‡ ‡‡‡‡ï‡ ‡‡‡‡‡æ‡‡Ø‡‡ ‡  ‡µ‡ø‡µ‡‡‡ï‡‡® (‡‡®‡®‡‡?) ‡‡ø‡¶‡‡ß‡Æ‡ ‡
-- (Bhskara's correction of Brahmagupta, made a term: n0 (khahara) differs
--  from EVERY finite ‚î in particular it is not zero.  Brahmagupta's 00=0 is
--  a durnaya; Bhskara set the infinite khahara apart.  Via a discriminator.)
------------------------------------------------------------------------

‡§Ö‡§®‡§®‡•ç‡§§? : ‡§ñ‡§π‡§∞ ‚Üí Type
‡§Ö‡§®‡§®‡•ç‡§§? (‡§∏‡§∏‡•Ä‡§Æ _) = ‚ä•
‡§Ö‡§®‡§®‡•ç‡§§? ‡§Ö‡§®‡§®‡•ç‡§§     = Unit

‡§Ö‡§®‡§®‡•ç‡§§-‡§®-‡§∏‡§∏‡•Ä‡§Æ‡§É : (a : ‚Ñ§) ‚Üí ¬¨ (‡§Ö‡§®‡§®‡•ç‡§§ ‚â° ‡§∏‡§∏‡•Ä‡§Æ a)
‡§Ö‡§®‡§®‡•ç‡§§-‡§®-‡§∏‡§∏‡•Ä‡§Æ‡§É a eq = subst ‡§Ö‡§®‡§®‡•ç‡§§? eq tt

-- ‡‡‡∞‡‡‡Æ‡ó‡‡‡‡-‡¶‡ã‡‡ ‚î n0 ‚â† 0 : ‡ñ‡‡∞‡ ‡‡‡®‡‡Ø‡ ‡® (‡‡‡∞‡‡‡Æ‡ó‡‡‡‡‡‡‡Ø ‡¶‡‡∞‡‡®‡Ø‡‡‡Ø ‡®‡ø‡∞‡æ‡‡) ‡
‡§¨‡•ç‡§∞‡§π‡•ç‡§Æ‡§ó‡•Å‡§™‡•ç‡§§-‡§¶‡•ã‡§∑‡§É : (n : ‚Ñ§) ‚Üí ¬¨ (‡§∂‡•Ç‡§®‡•ç‡§Ø-‡§π‡§∞‡§É n ‚â° ‡§∏‡§∏‡•Ä‡§Æ (pos 0))
‡§¨‡•ç‡§∞‡§π‡•ç‡§Æ‡§ó‡•Å‡§™‡•ç‡§§-‡§¶‡•ã‡§∑‡§É n = ‡§Ö‡§®‡§®‡•ç‡§§-‡§®-‡§∏‡§∏‡•Ä‡§Æ‡§É (pos 0)

------------------------------------------------------------------------
-- APPENDED 2026-08-19 by a later reader, at the end, altering no line
-- above, including the CORRECTED block.  Pointer only.
--
-- THIS APPEND EXISTS BECAUSE A CHECK CAUGHT ITS ABSENCE.  b397fe48 made
-- correction-propagation a standing check: a module that corrects X is
-- unreachable from X unless X names it.  Run against my own pairs, 18 of
-- 20 carried the back-reference and this file was one of the two that
-- did not.
--
-- The CORRECTED block above separates two defects and warns that using
-- one third position as a catch-all is the boolean collapse this corpus
-- fights, one level up.  Their INDEPENDENCE is checked, over four
-- realised corners, in
-- `NonUniquenessAndInexpressibilityAreIndependent`
-- (--safe, no postulates, no holes; container green under Agda 2.6.3 +
-- cubical v0.5, NOT the declared pin):
--
--   nonUnique ‚àß expressible     all,  constants
--   unique    ‚àß inexpressible   self, constants
--   nonUnique ‚àß inexpressible   all,  onlyFalse
--   unique    ‚àß expressible     self, onlyId
--
-- so neither defect implies the other and neither implies the other's
-- negation.  The types say why: non-uniqueness is a property of the
-- CONTENT alone, inexpressibility of the content AND the MEDIUM ‚î which
-- is the asymmetry that makes one word for both lossy.
--
-- That module deliberately does NOT bring Satyayantra's ‡‡®‡‡ï‡‡‡Æ‡ onto
-- the same carrier: it is temporal, and d909db0d already says the two
-- third-positions' remedies live in different types.  And it offers no
-- verdict on which module should keep the word ‡‡µ‡ï‡‡‡µ‡‡Ø‡Æ‡ ‚î that is this
-- lane's dispute, untouched.
------------------------------------------------------------------------
