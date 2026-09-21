{-# OPTIONS --cubical --safe #-}

------------------------------------------------------------------------
-- ‡µ‡ï‡‡∞-‡µ‡≤‡Ø‡Æ‡ ‚î the twisted ring.  KramaSaha's doctrine ‚î the order of
-- standpoints IS the charge ‚î arriving at the fundamental group.
--
-- THE QUESTION.
-- ArpanaSopana showed the charge is whatever the space holds.  The
-- torus's stratum-3 charge is ‚ ó ‚.  The KLEIN BOTTLE's loop space has
-- the SAME carrier (Œ©Klein‚â°‚¬≤, library) ‚î so the charge AS A TYPE
-- cannot tell the orientable surface from the non-orientable one.  Is
-- the difference then invisible at the stratum ‚î or does it live
-- somewhere the type does not reach?
--
-- ANSWERED HERE: it lives in the KRAMA ‚î the law of succession.  Both
-- spaces are generated at œ‚ by two lines and a square; the two squares
-- differ by one interval reversal (torus: PathP (Œª i ‚í line1 i ‚â°
-- line1 i) line2 line2; Klein: PathP (Œª i ‚í line1 (~ i) ‚â° line1 i)
-- line2 line2), and that single ~ decides everything:
--
--   ‡‡Æ‡    in the TORUS the two orders of succession are EQUAL ‚î
--          line1 ‚àô line2 ‚â° line2 ‚àô line1, one term (Square‚ícompPath on
--          the torus's own square).
--   ‡‡‡¶‡   in the KLEIN BOTTLE they are DISTINCT ‚î ¬ (line1 ‚àô line2 ‚â°
--          line2 ‚àô line1), and the witness is COMPUTED: windingKlein
--          sends the two composites to (‚àí1, ‚àí1) and (‚àí1, +1), and
--          negsuc ‚â† pos by constructor.  Nonabelianness of œ‚(K),
--          exhibited by normalization, not asserted.
--   ‡µ‡ï‡‡∞‡µ‡≤‡Ø‡Æ‡  and the stratum-3 carrier is nonetheless ‚ ó ‚, the
--          torus's exactly (same three terms as ArpanaSopana's ‡µ‡≤‡Ø‡Æ‡).
--
-- So two spaces share one charge-type at the stratum and are separated
-- by the composition law alone.  The saptabhag reading (per KramaSaha):
-- what krama
-- distinguishes, no profile of presences can ‚î the succession is not
-- recoverable from the carrier, exactly as the record lane is not
-- recoverable from the label lane (Arpitanarpita's retract).
--
-- SOURCES: Œ©Klein‚â°‚¬≤ and windingKlein, Cubical.HITs.KleinBottle
-- .Properties; Square‚ícompPath, Cubical.Foundations.Path;
-- negsucNotpos, Cubical.Data.Int.Properties.  ‡µ‡ï‡‡∞ (twisted), ‡µ‡≤‡Ø
-- (ring), ‡‡Æ/‡‡‡¶ (same/distinct) are ordinary  labels;
-- the mathematics is the library's,
-- composed.
------------------------------------------------------------------------

module VakraValaya_TheSameCarrierTwoLawsOfSuccessionTheKramaDistinguishesWhatTheTypeCannot where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Equiv
open import Cubical.Foundations.Isomorphism using (isoToEquiv ; invIso)
open import Cubical.Foundations.Univalence using (pathToEquiv)
open import Cubical.Foundations.Pointed using (typ)
open import Cubical.Foundations.Path using (Square‚ÜícompPath)
open import Cubical.Foundations.HLevels using (isSet√ó)
open import Cubical.Relation.Nullary using (¬¨_)
open import Cubical.Data.Int using (‚Ñ§ ; isSet‚Ñ§ ; negsucNotpos)
open import Cubical.Data.Sigma using (_√ó_)
open import Cubical.HITs.Truncation using (hLevelTrunc‚àô)
open import Cubical.HITs.SetTruncation using (setTruncIdempotentIso)
open import Cubical.Homotopy.Loopspace using (Œ©)
open import Cubical.Homotopy.Group.Base using (isSetŒ©Trunc)

import Cubical.HITs.Torus.Base as T
import Cubical.HITs.KleinBottle as K
open import Cubical.HITs.KleinBottle.Properties
  using (Œ©Klein‚â°‚Ñ§¬≤ ; windingKlein)

open import ArpanaSopana_EveryStratumUttersANewChargeAndTheChargeIsWhateverTheSpaceHolds
  using (‡§∏‡§æ‡§Æ‡§æ‡§®‡•ç‡§Ø‡§Æ‡•ç)

------------------------------------------------------------------------
-- ‡‡Æ‡ ‚î in the torus, succession commutes, and the proof is the
-- torus's own square read as a composition identity.
------------------------------------------------------------------------

‡§∏‡§Æ‡§É : T.line1 ‚àô T.line2 ‚â° T.line2 ‚àô T.line1
‡§∏‡§Æ‡§É = Square‚ÜícompPath T.square

------------------------------------------------------------------------
-- ‡‡‡¶‡ ‚î in the Klein bottle, the two orders are DISTINCT.  The
-- windings of the composites disagree in the second coordinate
-- ((‚àí1,‚àí1) against (‚àí1,+1), computed), and a function cannot separate
-- equal paths.
------------------------------------------------------------------------

‡§≠‡•á‡§¶‡§É : ¬¨ (K.line1 ‚àô K.line2 ‚â° K.line2 ‚àô K.line1)
‡§≠‡•á‡§¶‡§É h = negsucNotpos 0 1 (cong (Œª p ‚Üí snd (windingKlein p)) h)

------------------------------------------------------------------------
-- ‡µ‡ï‡‡∞‡µ‡≤‡Ø‡Æ‡ ‚î and yet the stratum-3 carrier is the torus's exactly:
-- ‚ ó ‚.  The type cannot tell the two spaces apart; the krama can.
------------------------------------------------------------------------

‡§µ‡§ï‡•ç‡§∞‡§µ‡§≤‡§Ø‡§Æ‡•ç : typ (Œ© (hLevelTrunc‚àô 3 (K.KleinBottle , K.point))) ‚âÉ (‚Ñ§ √ó ‚Ñ§)
‡§µ‡§ï‡•ç‡§∞‡§µ‡§≤‡§Ø‡§Æ‡•ç =
  compEquiv (‡§∏‡§æ‡§Æ‡§æ‡§®‡•ç‡§Ø‡§Æ‡•ç 0 (K.KleinBottle , K.point))
    (compEquiv
      (isoToEquiv (setTruncIdempotentIso
        (subst isSet (sym Œ©Klein‚â°‚Ñ§¬≤) (isSet√ó isSet‚Ñ§ isSet‚Ñ§))))
      (pathToEquiv Œ©Klein‚â°‚Ñ§¬≤))
