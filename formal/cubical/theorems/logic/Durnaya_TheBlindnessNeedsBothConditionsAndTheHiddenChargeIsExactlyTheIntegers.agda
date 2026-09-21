{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- ‡Æ‡‡≤‡µ‡æ‡ï‡‡Ø‡Æ‡ ¬ PROVENANCE OF THE NAME.
--
-- ‡¶‡‡∞‡‡®‡Ø ¬ durnaya ‚î a naya (standpoint) that asserts itself by DENYING
-- the other standpoints, as against a ‡‡‡®‡Ø, which asserts itself while
-- leaving the others standing.  **Siddhasena Divkara, *Sanmatitarka*
-- (~5th c. CE); sharpened by Akalaka (~8th c.); Yaovijaya,
-- *Nayopadea* (~17th c.).**  Jaina.  The school is named because the
-- dispute is the content: the Naiyyikas reject anekntavda outright
-- and would not accept the diagnosis this module applies.
--
-- ‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î
-- A CORRECTION TO THIS REPOSITORY'S OWN FRONT DOOR.
--
-- `README.md` ¬ß‡‡∞‡ø‡‡ã‡ß‡®‡Æ‡ C2 (2026-08-22) strikes an earlier gloss and
-- puts this in its place, verbatim:
--
--     "The blindness is a property of non-dependent post-composition
--      (`cong F` for `F : A ‚í X`), NOT of the answer's h-level."
--
-- and, in the same document's law paragraph, the struck line is
-- annotated "the blindness ... belongs to the CONSTRUCTION and is not
-- [removable]".
--
-- **The second half of that sentence is false**, and the refuting term
-- was already checked in the repository, in the very module C2 was
-- written about.  `Naya_‚¶AnnihilatesEveryLoop‚¶` ¬ß‡ is
--
--     ‡‡‡‡æ‡®-‡‡‡Ø‡ã‡ó‡ : ¬ (cong (Œª (A : Type‚) ‚í A) ‡‡µ‡∞‡‡‡ ‚â° refl)
--
-- ‚î a `cong F` for a NON-DEPENDENT `F : Type‚ ‚í Type‚` that does NOT
-- annihilate the loop.  Its `F` is the identity on a universe, whose
-- codomain is not a set.  So non-dependence alone never sufficed: the
-- h-level of the answer is load-bearing, and it is written as an
-- explicit hypothesis `isSet X` in `Naya`'s own ¬ß‡ß, which C2 quotes
-- while dropping the hypothesis.
--
-- The pattern is this corpus's oldest one, arriving in its newest
-- document: the answer was in the file the claim was made about.  And
-- the diagnosis is exactly ‡¶‡‡∞‡‡®‡Ø ‚î C2's standpoint (non-dependence
-- matters) is TRUE, and it was asserted by denying a standpoint that
-- also holds (h-level matters).  Both are necessary; neither is
-- sufficient; that is ¬ß‡.
--
-- ‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î
-- WHAT IS PROVED HERE, AND WHAT IS NEW RATHER THAN ASSEMBLED.
--
-- ¬ß‡ß‚ì¬ß‡® move the whole question OFF the universe.  `Naya`'s loop is
-- `ua notEquiv`, so a reader may believe the phenomenon is about
-- univalence or about universes.  It is not.  `loop : base ‚â° base` is a
-- CONSTRUCTOR of `S¬ : Type‚`; carrier, loop and answer all sit in
-- Type‚; and the same three facts hold.
--
-- ¬ß‡® is the part that is a RECEIPT in this repository's sense ‚î an
-- identification of a fibre with a standard type, never a bound.  What
-- every set-valued observable of the carrier destroys is not "some
-- charge": it is exactly ‚, by `Œ©S¬Iso‚`, and the identifying map IS
-- `winding` on the nose (¬ß‡®‡, `refl`).  The earlier statement of the
-- gap ‚î `Paryayarthika_‚¶` ¬ß‡®, that ONE set-valued observable separates
-- ONE pair of loops ‚î is a separation.  This is the identification: the
-- mode-regarding standpoint loses nothing at all, because `winding` is
-- an equivalence and ‚ is a set.
--
-- So the two standpoints are measured against each other exactly:
--   ‡¶‡‡∞‡µ‡‡Ø‡æ‡∞‡‡‡ø‡ï (observables of the carrier, set-valued): sees 0 of ‚.
--   ‡‡∞‡‡Ø‡æ‡Ø‡æ‡∞‡‡‡ø‡ï (observables of the path type, set-valued): sees ‚.
-- Same loop, same h-level of answer, total blindness against total
-- sight.  Truncation was never what separated them, and neither was
-- non-dependence by itself.
--
-- ¬ß‡ is the counterexample restated where nothing can be blamed on a
-- universe: `cong (idfun S¬) loop ‚â refl`, with `idfun S¬ : S¬ ‚í S¬`
-- non-dependent and `S¬` merely not a set.
------------------------------------------------------------------------

module Durnaya_TheBlindnessNeedsBothConditionsAndTheHiddenChargeIsExactlyTheIntegers where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Function using (idfun)
open import Cubical.Foundations.Isomorphism using (Iso ; isoToEquiv)
open import Cubical.Foundations.Equiv using (_‚âÉ_)
open import Cubical.HITs.S1.Base using (S¬π ; base ; loop ; Œ©S¬π ; winding ; Œ©S¬πIso‚Ñ§)
open import Cubical.Data.Int using (‚Ñ§ ; pos)
open import Cubical.Data.Int.Properties using (injPos ; isSet‚Ñ§)
open import Cubical.Data.Nat using (snotz)
open import Cubical.Data.Sigma using (_√ó_ ; _,_)
open import Cubical.Relation.Nullary using (¬¨_)

import Naya_TheSetValuedObservableAnnihilatesEveryLoopAndTheLoopIsStillThere as NAYA

------------------------------------------------------------------------
-- ‡ß ‚î‚î THE LOOP IS A CONSTRUCTOR, NOT A `ua`.
--
-- Carrier `S¬ : Type‚`, loop `loop : base ‚â° base`.  Nothing in this
-- section mentions a universe or an equivalence.
------------------------------------------------------------------------

‡§Ü‡§µ‡§∞‡•ç‡§§‡§É : Œ©S¬π
‡§Ü‡§µ‡§∞‡•ç‡§§‡§É = loop

------------------------------------------------------------------------
-- ‡® ‚î‚î ‡‡‡ø‡‡‡û‡æ‡®‡Æ‡ ‚î THE RECEIPT.  The hidden charge is IDENTIFIED with a
--      standard type, not bounded: Œ©S¬ ‚â ‚, and ‚ is a set.
------------------------------------------------------------------------

‡§Ö‡§≠‡§ø‡§ú‡•ç‡§û‡§æ‡§®‡§Æ‡•ç : Œ©S¬π ‚âÉ ‚Ñ§
‡§Ö‡§≠‡§ø‡§ú‡•ç‡§û‡§æ‡§®‡§Æ‡•ç = isoToEquiv Œ©S¬πIso‚Ñ§

-- ‡®‡ ‚î‚î and the identifying map is `winding` ON THE NOSE.  This is what
--       makes it a receipt rather than a bare cardinality remark: the
--       standard type comes with the observable that realises it.
‡§µ‡§æ‡§π‡§ï‡§É : fst ‡§Ö‡§≠‡§ø‡§ú‡•ç‡§û‡§æ‡§®‡§Æ‡•ç ‚â° winding
‡§µ‡§æ‡§π‡§ï‡§É = refl

-- ‡®‡ ‚î‚î the answer type is a SET.  So no h-level excuse is available to
--        either side of ¬ß‡: both standpoints below answer in sets.
‡§∏‡§Æ‡•Å‡§ö‡•ç‡§ö‡§Ø‡§É : isSet ‚Ñ§
‡§∏‡§Æ‡•Å‡§ö‡•ç‡§ö‡§Ø‡§É = isSet‚Ñ§

------------------------------------------------------------------------
-- ‡© ‚î‚î ‡¶‡‡∞‡µ‡‡Ø‡æ‡∞‡‡‡ø‡ï‡®‡Ø‡ ‚î the substance-regarding standpoint sees NOTHING.
--
-- Every set-valued observable of the CARRIER annihilates every loop.
-- `Naya` ¬ß‡ß applied unchanged; the whole of ‚ collapses to a point.
------------------------------------------------------------------------

‡§¶‡•ç‡§∞‡§µ‡•ç‡§Ø-‡§Ö‡§®‡•ç‡§ß‡§§‡•ç‡§µ‡§Æ‡•ç :
  (X : Type‚ÇÄ) ‚Üí isSet X ‚Üí (F : S¬π ‚Üí X) ‚Üí (p : Œ©S¬π) ‚Üí cong F p ‚â° refl
‡§¶‡•ç‡§∞‡§µ‡•ç‡§Ø-‡§Ö‡§®‡•ç‡§ß‡§§‡•ç‡§µ‡§Æ‡•ç X isSetX F p = NAYA.‡§®‡§Ø-‡§®‡§ø‡§∞‡•ã‡§ß‡§É isSetX F p

------------------------------------------------------------------------
-- ‡ ‚î‚î ‡‡∞‡‡Ø‡æ‡Ø‡æ‡∞‡‡‡ø‡ï‡®‡Ø‡ ‚î the mode-regarding standpoint sees EVERYTHING.
--
-- `winding : Œ©S¬ ‚í ‚` is an observable of the PATH TYPE, it lands in a
-- set, and it is an equivalence: no loop is lost, not merely two
-- separated.  This is the identification `Paryayarthika` ¬ß‡® stopped
-- short of.
------------------------------------------------------------------------

‡§™‡§∞‡•ç‡§Ø‡§æ‡§Ø-‡§¶‡§∞‡•ç‡§∂‡§®‡§Æ‡•ç : Œ©S¬π ‚âÉ ‚Ñ§
‡§™‡§∞‡•ç‡§Ø‡§æ‡§Ø-‡§¶‡§∞‡•ç‡§∂‡§®‡§Æ‡•ç = ‡§Ö‡§≠‡§ø‡§ú‡•ç‡§û‡§æ‡§®‡§Æ‡•ç

-- and it does not merely see: it is FAITHFUL, `intLoop ‚àò winding ‚â° id`.
‡§™‡§∞‡•ç‡§Ø‡§æ‡§Ø-‡§Ö‡§≤‡•ã‡§™‡§É : (p : Œ©S¬π) ‚Üí Iso.inv Œ©S¬πIso‚Ñ§ (winding p) ‚â° p
‡§™‡§∞‡•ç‡§Ø‡§æ‡§Ø-‡§Ö‡§≤‡•ã‡§™‡§É = Iso.leftInv Œ©S¬πIso‚Ñ§

------------------------------------------------------------------------
-- ‡ ‚î‚î THE COUNTEREXAMPLE TO README C2, OFF THE UNIVERSE.
--
-- `idfun S¬ : S¬ ‚í S¬` is non-dependent post-composition, its codomain
-- lives in Type‚, and `cong (idfun S¬) loop` is NOT refl ‚î because S¬
-- is not a set.  So "the blindness is a property of non-dependent
-- post-composition, not of the answer's h-level" is refuted by a term.
--
-- The witness of non-triviality is the receipt of ¬ß‡® used as a probe:
-- `winding loop = pos 1` and `winding refl = pos 0`, both definitional.
------------------------------------------------------------------------

‡§Ü‡§µ‡§∞‡•ç‡§§‡§É-‡§®-‡§≤‡•ã‡§™‡§É : ¬¨ (‡§Ü‡§µ‡§∞‡•ç‡§§‡§É ‚â° refl)
‡§Ü‡§µ‡§∞‡•ç‡§§‡§É-‡§®-‡§≤‡•ã‡§™‡§É p = snotz (injPos (cong winding p))

‡§Ö‡§®‡•ç‡§ß‡§§‡•ç‡§µ‡§Ç-‡§®-‡§ï‡•á‡§µ‡§≤‡§Æ‡•ç-‡§Ö‡§®‡§æ‡§∂‡•ç‡§∞‡§ø‡§§‡§§‡•ç‡§µ‡§Æ‡•ç : ¬¨ (cong (idfun S¬π) ‡§Ü‡§µ‡§∞‡•ç‡§§‡§É ‚â° refl)
‡§Ö‡§®‡•ç‡§ß‡§§‡•ç‡§µ‡§Ç-‡§®-‡§ï‡•á‡§µ‡§≤‡§Æ‡•ç-‡§Ö‡§®‡§æ‡§∂‡•ç‡§∞‡§ø‡§§‡§§‡•ç‡§µ‡§Æ‡•ç = ‡§Ü‡§µ‡§∞‡•ç‡§§‡§É-‡§®-‡§≤‡•ã‡§™‡§É

-- and the same refutation, with the quantifier the sentence carries:
-- there is no theorem "every non-dependent `cong F` annihilates".
‡§®-‡§∏‡§æ‡§Æ‡§æ‡§®‡•ç‡§Ø‡§Æ‡•ç :
  ¬¨ ((X : Type‚ÇÄ) ‚Üí (F : S¬π ‚Üí X) ‚Üí cong F ‡§Ü‡§µ‡§∞‡•ç‡§§‡§É ‚â° refl)
‡§®-‡§∏‡§æ‡§Æ‡§æ‡§®‡•ç‡§Ø‡§Æ‡•ç h = ‡§Ö‡§®‡•ç‡§ß‡§§‡•ç‡§µ‡§Ç-‡§®-‡§ï‡•á‡§µ‡§≤‡§Æ‡•ç-‡§Ö‡§®‡§æ‡§∂‡•ç‡§∞‡§ø‡§§‡§§‡•ç‡§µ‡§Æ‡•ç (h S¬π (idfun S¬π))

------------------------------------------------------------------------
-- ‡ ‚î‚î ‡‡®‡‡ï‡æ‡®‡‡‡ ‚î NEITHER CONDITION IS SUFFICIENT, BOTH TOGETHER ARE.
--
-- One term carrying the three cells that settle it, on ONE loop:
--
--   fst  set-valued AND non-dependent-on-the-carrier  ‚ü blind.
--   snd  non-dependent alone (drop `isSet X`)          ‚ü NOT blind.
--   thd  set-valued alone (observe the path type)      ‚ü NOT blind,
--        and not merely non-blind ‚î lossless, by ¬ß‡®.
--
-- `Naya` ¬ß‡ß's `isSet X` hypothesis is therefore not decoration, and
-- C2's denial of it is a ‡¶‡‡∞‡‡®‡Ø: a true standpoint asserted by denying
-- another that also holds.  The repair is the Jaina one ‚î index, do not
-- collapse.  Both conditions, named, neither discarded.
------------------------------------------------------------------------

‡§â‡§≠‡§Ø‡§Æ‡•ç-‡§Ü‡§µ‡§∂‡•ç‡§Ø‡§ï‡§Æ‡•ç :
    ((X : Type‚ÇÄ) ‚Üí isSet X ‚Üí (F : S¬π ‚Üí X) ‚Üí cong F ‡§Ü‡§µ‡§∞‡•ç‡§§‡§É ‚â° refl)
  √ó (¬¨ ((X : Type‚ÇÄ) ‚Üí (F : S¬π ‚Üí X) ‚Üí cong F ‡§Ü‡§µ‡§∞‡•ç‡§§‡§É ‚â° refl))
  √ó (Œ©S¬π ‚âÉ ‚Ñ§)
‡§â‡§≠‡§Ø‡§Æ‡•ç-‡§Ü‡§µ‡§∂‡•ç‡§Ø‡§ï‡§Æ‡•ç =
    (Œª X isSetX F ‚Üí ‡§¶‡•ç‡§∞‡§µ‡•ç‡§Ø-‡§Ö‡§®‡•ç‡§ß‡§§‡•ç‡§µ‡§Æ‡•ç X isSetX F ‡§Ü‡§µ‡§∞‡•ç‡§§‡§É)
  , ‡§®-‡§∏‡§æ‡§Æ‡§æ‡§®‡•ç‡§Ø‡§Æ‡•ç
  , ‡§™‡§∞‡•ç‡§Ø‡§æ‡§Ø-‡§¶‡§∞‡•ç‡§∂‡§®‡§Æ‡•ç
