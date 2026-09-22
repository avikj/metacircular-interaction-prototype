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
-- WHAT IS PROVED HERE.
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
-- `winding` on the nose (¬ß‡®‡, `refl`).
-- This is the identification: the
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
-- separated.
------------------------------------------------------------------------

‡§™‡§∞‡•ç‡§Ø‡§æ‡§Ø-‡§¶‡§∞‡•ç‡§∂‡§®‡§Æ‡•ç : Œ©S¬π ‚âÉ ‚Ñ§
‡§™‡§∞‡•ç‡§Ø‡§æ‡§Ø-‡§¶‡§∞‡•ç‡§∂‡§®‡§Æ‡•ç = ‡§Ö‡§≠‡§ø‡§ú‡•ç‡§û‡§æ‡§®‡§Æ‡•ç

-- and it does not merely see: it is FAITHFUL, `intLoop ‚àò winding ‚â° id`.
‡§™‡§∞‡•ç‡§Ø‡§æ‡§Ø-‡§Ö‡§≤‡•ã‡§™‡§É : (p : Œ©S¬π) ‚Üí Iso.inv Œ©S¬πIso‚Ñ§ (winding p) ‚â° p
‡§™‡§∞‡•ç‡§Ø‡§æ‡§Ø-‡§Ö‡§≤‡•ã‡§™‡§É = Iso.leftInv Œ©S¬πIso‚Ñ§

------------------------------------------------------------------------
-- ‡ ‚î‚î NON-DEPENDENCE ALONE IS NOT ENOUGH, OFF THE UNIVERSE.
--
-- `idfun S¬ : S¬ ‚í S¬` is non-dependent post-composition, its codomain
-- lives in Type‚, and `cong (idfun S¬) loop` is NOT refl ‚î because S¬
-- is not a set.
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
-- `Naya` ¬ß‡ß's `isSet X` hypothesis is therefore not decoration.
------------------------------------------------------------------------

‡§â‡§≠‡§Ø‡§Æ‡•ç-‡§Ü‡§µ‡§∂‡•ç‡§Ø‡§ï‡§Æ‡•ç :
    ((X : Type‚ÇÄ) ‚Üí isSet X ‚Üí (F : S¬π ‚Üí X) ‚Üí cong F ‡§Ü‡§µ‡§∞‡•ç‡§§‡§É ‚â° refl)
  √ó (¬¨ ((X : Type‚ÇÄ) ‚Üí (F : S¬π ‚Üí X) ‚Üí cong F ‡§Ü‡§µ‡§∞‡•ç‡§§‡§É ‚â° refl))
  √ó (Œ©S¬π ‚âÉ ‚Ñ§)
‡§â‡§≠‡§Ø‡§Æ‡•ç-‡§Ü‡§µ‡§∂‡•ç‡§Ø‡§ï‡§Æ‡•ç =
    (Œª X isSetX F ‚Üí ‡§¶‡•ç‡§∞‡§µ‡•ç‡§Ø-‡§Ö‡§®‡•ç‡§ß‡§§‡•ç‡§µ‡§Æ‡•ç X isSetX F ‡§Ü‡§µ‡§∞‡•ç‡§§‡§É)
  , ‡§®-‡§∏‡§æ‡§Æ‡§æ‡§®‡•ç‡§Ø‡§Æ‡•ç
  , ‡§™‡§∞‡•ç‡§Ø‡§æ‡§Ø-‡§¶‡§∞‡•ç‡§∂‡§®‡§Æ‡•ç
