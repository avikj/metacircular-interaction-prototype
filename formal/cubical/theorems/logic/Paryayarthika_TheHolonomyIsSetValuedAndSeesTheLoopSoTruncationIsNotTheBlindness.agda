{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- ‡‡∞‡‡Ø‡æ‡Ø‡æ‡∞‡‡‡ø‡ï‡®‡Ø ¬ paryyrthika-naya ‚î THE MODE-REGARDING STANDPOINT
-- ALSO LANDS IN A SET.
--
-- THE TERM, ITS TEXT AND ITS DATE.  ‡‡∞‡‡Ø‡æ‡Ø (paryya) is the Jaina term
-- for a MODE of a substance, paired against ‡¶‡‡∞‡µ‡‡Ø (dravya), the
-- substance itself: `‡ó‡‡‡‡∞‡‡Ø‡æ‡Ø‡µ‡¶‡ ‡¶‡‡∞‡µ‡‡Ø‡Æ‡` ‚î Umsvti,
-- *Tattvrthastra* 5.37, with 5.29 (~2nd‚ì5th c.).  The two ROOT
-- standpoints built on the pair ‚î ‡¶‡‡∞‡µ‡‡Ø‡æ‡∞‡‡‡ø‡ï‡®‡Ø (substance-regarding)
-- and ‡‡∞‡‡Ø‡æ‡Ø‡æ‡∞‡‡‡ø‡ï‡®‡Ø (mode-regarding) ‚î are Siddhasena Divkara,
-- *Sanmatitarka* 1.3‚ì1.6 (~5th c.); either one asserting itself by
-- DENYING the other is a ‡¶‡‡∞‡‡®‡Ø (Siddhasena; Akalaka, ~8th c.).
-- Jaina; the Naiyyikas reject anekntavda outright, and the school is
-- named because the dispute is the content.
--
-- ‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î
-- WHAT THIS REFUTES.
--
-- `Naya_TheSetValuedObservableAnnihilatesEveryLoopAndTheLoopIsStillThere`
-- proves (¬ß‡ß) that every SET-valued `F : A ‚í X` has `cong F p ‚â° refl`
-- for every loop `p`, and reads off (¬ß‡) the gloss
--
--       "Truncating to a set is THE WHOLE of the blindness."
--
-- further: set-truncation is offered as the type-theoretic form of
-- Theorem F's gauge-invariance, with the escape being an observable
-- that is not set-valued.
--
-- **The gloss is false, and this module is the counterexample.**  There
-- is a SET-VALUED observable that sees the loop:
--
--       ‡‡ã‡≤‡ã‡®‡ã‡Æ‡ p  =  transport p   :   Bool ‚í Bool
--
-- Its codomain `Bool ‚í Bool` is a set (¬ß‡ß), and it separates
-- `ua notEquiv` from `refl` (¬ß‡®).  So the proposition
--
--       every set-valued observable of the loop type is constant
--
-- is REFUTED (¬ß‡©), by a term.
--
-- WHY `Naya` ¬ß‡ß IS UNTOUCHED, which is the actual content.  `Naya`
-- quantifies over `F : A ‚í X`, observables of the CARRIER, and reports
-- `cong F`.  ‡‡ã‡≤‡ã‡®‡ã‡Æ‡ is an observable of the PATH TYPE, `(A ‚â° A) ‚í X`.
-- The blindness is a property of non-dependent post-composition, not of
-- the h-level of the answer.  ¬ß‡ shows the two live together: the same
-- loop is annihilated by every `cong F` and separated by ‡‡ã‡≤‡ã‡®‡ã‡Æ‡.
--
-- AND THE LOOP TYPE IS ITSELF A SET (¬ß‡).  `Bool ‚â° Bool` is a set ‚î so
-- there is no h-level obstruction whatever to observing the charged
-- sector.  A truncation argument cannot be what hides it, because the
-- thing being hidden is already 0-truncated.
--
-- THE PHYSICS READING, and it is why the correction matters.  A Wilson
-- loop is a complex number ‚î a set-valued observable ‚î obtained by
-- transporting around a loop, and it is the standard instrument that
-- DOES see gauge charge.  A theory on which "set-valued ‚í blind to the
-- gauge loop" would predict Aharonov‚ìBohm invisible.  ¬ß‡® is that
-- objection made into a term.
--
-- CHECKED: Agda 2.8.0 + agda/cubical, --cubical --safe, no postulates,
-- no holes.  Written 2026-08-22.
------------------------------------------------------------------------

module Paryayarthika_TheHolonomyIsSetValuedAndSeesTheLoopSoTruncationIsNotTheBlindness where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Univalence
open import Cubical.Foundations.Equiv using (_‚âÉ_; invEquiv)
open import Cubical.Foundations.HLevels using (isSetŒ†; isOfHLevel‚âÉ; isOfHLevelRespectEquiv)
open import Cubical.Data.Bool using (Bool; true; false; not; notEquiv; isSetBool; false‚â¢true)
open import Cubical.Data.Sigma using (_√ó_; _,_)
open import Cubical.Relation.Nullary using (¬¨_)

import Naya_TheSetValuedObservableAnnihilatesEveryLoopAndTheLoopIsStillThere as NAYA

------------------------------------------------------------------------
-- ‡ß ‚î‚î THE OBSERVABLE, AND THAT IT LANDS IN A SET.
------------------------------------------------------------------------

‡§π‡•ã‡§≤‡•ã‡§®‡•ã‡§Æ‡•Ä : (Bool ‚â° Bool) ‚Üí (Bool ‚Üí Bool)
‡§π‡•ã‡§≤‡•ã‡§®‡•ã‡§Æ‡•Ä p = transport p

‡§∏‡§Æ‡•Å‡§ö‡•ç‡§ö‡§Ø‡§É : isSet (Bool ‚Üí Bool)
‡§∏‡§Æ‡•Å‡§ö‡•ç‡§ö‡§Ø‡§É = isSetŒ† (Œª _ ‚Üí isSetBool)

------------------------------------------------------------------------
-- ‡® ‚î‚î AND IT SEES THE LOOP.
------------------------------------------------------------------------

‡§™‡§∂‡•ç‡§Ø‡§§‡§ø : ¬¨ (‡§π‡•ã‡§≤‡•ã‡§®‡•ã‡§Æ‡•Ä NAYA.‡§Ü‡§µ‡§∞‡•ç‡§§‡§É ‚â° ‡§π‡•ã‡§≤‡•ã‡§®‡•ã‡§Æ‡•Ä refl)
‡§™‡§∂‡•ç‡§Ø‡§§‡§ø q =
  false‚â¢true ( sym (uaŒ≤ notEquiv true)
             ‚àô funExt‚Åª q true
             ‚àô transportRefl true )

------------------------------------------------------------------------
-- ‡© ‚î‚î THE REFUTED PROPOSITION, NAMED AND KILLED.
------------------------------------------------------------------------

‡§õ‡•á‡§¶‡§É-‡§è‡§µ-‡§Ö‡§®‡•ç‡§ß‡§§‡•ç‡§µ‡§Æ‡•ç : Type‚ÇÅ
‡§õ‡•á‡§¶‡§É-‡§è‡§µ-‡§Ö‡§®‡•ç‡§ß‡§§‡•ç‡§µ‡§Æ‡•ç =
  (X : Type‚ÇÄ) ‚Üí isSet X ‚Üí (G : (Bool ‚â° Bool) ‚Üí X) ‚Üí G NAYA.‡§Ü‡§µ‡§∞‡•ç‡§§‡§É ‚â° G refl

‡§®-‡§õ‡•á‡§¶‡§É : ¬¨ ‡§õ‡•á‡§¶‡§É-‡§è‡§µ-‡§Ö‡§®‡•ç‡§ß‡§§‡•ç‡§µ‡§Æ‡•ç
‡§®-‡§õ‡•á‡§¶‡§É h = ‡§™‡§∂‡•ç‡§Ø‡§§‡§ø (h (Bool ‚Üí Bool) ‡§∏‡§Æ‡•Å‡§ö‡•ç‡§ö‡§Ø‡§É ‡§π‡•ã‡§≤‡•ã‡§®‡•ã‡§Æ‡•Ä)

------------------------------------------------------------------------
-- ‡ ‚î‚î ‡‡®‡‡ï‡æ‡®‡‡‡ ‚î both standpoints on the same loop, both set-valued.
--
-- LEFT: every set-valued observable of the CARRIER annihilates it
--       (`Naya` ¬ß‡ß, applied and not re-proved).
-- RIGHT: one set-valued observable of the PATH TYPE separates it.
------------------------------------------------------------------------

‡§â‡§≠‡§Ø‡§Æ‡•ç :
    ((X : Type‚ÇÄ) ‚Üí isSet X ‚Üí (F : Type‚ÇÄ ‚Üí X) ‚Üí cong F NAYA.‡§Ü‡§µ‡§∞‡•ç‡§§‡§É ‚â° refl)
  √ó (¬¨ (‡§π‡•ã‡§≤‡•ã‡§®‡•ã‡§Æ‡•Ä NAYA.‡§Ü‡§µ‡§∞‡•ç‡§§‡§É ‚â° ‡§π‡•ã‡§≤‡•ã‡§®‡•ã‡§Æ‡•Ä refl))
‡§â‡§≠‡§Ø‡§Æ‡•ç = (Œª X isSetX F ‚Üí NAYA.‡§®‡§Ø-‡§®‡§ø‡§∞‡•ã‡§ß‡§É isSetX F NAYA.‡§Ü‡§µ‡§∞‡•ç‡§§‡§É) , ‡§™‡§∂‡•ç‡§Ø‡§§‡§ø

------------------------------------------------------------------------
-- ‡ ‚î‚î THE CHARGED SECTOR IS ALREADY 0-TRUNCATED.
--
-- `Bool ‚â° Bool` is a set, so nothing about h-level can be what hides
-- the charge.  Whatever hides it is not truncation.
------------------------------------------------------------------------

‡§Ü‡§µ‡§∞‡•ç‡§§-‡§∏‡§Æ‡•Å‡§ö‡•ç‡§ö‡§Ø‡§É : isSet (Bool ‚â° Bool)
‡§Ü‡§µ‡§∞‡•ç‡§§-‡§∏‡§Æ‡•Å‡§ö‡•ç‡§ö‡§Ø‡§É =
  isOfHLevelRespectEquiv 2 (invEquiv univalence)
    (isOfHLevel‚âÉ 2 isSetBool isSetBool)
