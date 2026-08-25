{-# OPTIONS --cubical --safe #-}

------------------------------------------------------------------------
-- वक्र-वलयम् — the twisted ring.  KramaSaha's doctrine — the order of
-- standpoints IS the charge — arriving at the fundamental group.
--
-- THE QUESTION, asked because its answer was not known to the asker.
-- ArpanaSopana showed the charge is whatever the space holds.  The
-- torus's stratum-3 charge is ℤ × ℤ.  The KLEIN BOTTLE's loop space has
-- the SAME carrier (ΩKlein≡ℤ², library) — so the charge AS A TYPE
-- cannot tell the orientable surface from the non-orientable one.  Is
-- the difference then invisible at the stratum — or does it live
-- somewhere the type does not reach?
--
-- ANSWERED HERE: it lives in the KRAMA — the law of succession.  Both
-- spaces are generated at π₁ by two lines and a square; the two squares
-- differ by one interval reversal (torus: PathP (λ i → line1 i ≡
-- line1 i) line2 line2; Klein: PathP (λ i → line1 (~ i) ≡ line1 i)
-- line2 line2), and that single ~ decides everything:
--
--   समः    in the TORUS the two orders of succession are EQUAL —
--          line1 ∙ line2 ≡ line2 ∙ line1, one term (Square→compPath on
--          the torus's own square).
--   भेदः   in the KLEIN BOTTLE they are DISTINCT — ¬ (line1 ∙ line2 ≡
--          line2 ∙ line1), and the witness is COMPUTED: windingKlein
--          sends the two composites to (−1, −1) and (−1, +1), and
--          negsuc ≠ pos by constructor.  Nonabelianness of π₁(K),
--          exhibited by normalization, not asserted.
--   वक्रवलयम्  and the stratum-3 carrier is nonetheless ℤ × ℤ, the
--          torus's exactly (same three terms as ArpanaSopana's वलयम्).
--
-- So two spaces share one charge-type at the stratum and are separated
-- by the composition law alone.  The saptabhaṅgī reading (per KramaSaha,
-- and it is a reading, not a claim about the sources): what krama
-- distinguishes, no profile of presences can — the succession is not
-- recoverable from the carrier, exactly as the record lane is not
-- recoverable from the label lane (Arpitanarpita's retract).
--
-- The winding pairs were computed against the warm kernel through नाडी
-- (milliseconds per answer) before this file was written; the check
-- below re-derives them definitionally — cong under a function turns
-- the computed disagreement into the inequality.
--
-- SOURCES: ΩKlein≡ℤ² and windingKlein, Cubical.HITs.KleinBottle
-- .Properties; Square→compPath, Cubical.Foundations.Path;
-- negsucNotpos, Cubical.Data.Int.Properties.  वक्र (twisted), वलय
-- (ring), सम/भेद (same/distinct) are ordinary Sanskrit labels; no
-- source is claimed for the mathematics, which is the library's,
-- composed.
------------------------------------------------------------------------

module VakraValaya_TheSameCarrierTwoLawsOfSuccessionTheKramaDistinguishesWhatTheTypeCannot where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Equiv
open import Cubical.Foundations.Isomorphism using (isoToEquiv ; invIso)
open import Cubical.Foundations.Univalence using (pathToEquiv)
open import Cubical.Foundations.Pointed using (typ)
open import Cubical.Foundations.Path using (Square→compPath)
open import Cubical.Foundations.HLevels using (isSet×)
open import Cubical.Relation.Nullary using (¬_)
open import Cubical.Data.Int using (ℤ ; isSetℤ ; negsucNotpos)
open import Cubical.Data.Sigma using (_×_)
open import Cubical.HITs.Truncation using (hLevelTrunc∙)
open import Cubical.HITs.SetTruncation using (setTruncIdempotentIso)
open import Cubical.Homotopy.Loopspace using (Ω)
open import Cubical.Homotopy.Group.Base using (isSetΩTrunc)

import Cubical.HITs.Torus.Base as T
import Cubical.HITs.KleinBottle as K
open import Cubical.HITs.KleinBottle.Properties
  using (ΩKlein≡ℤ² ; windingKlein)

open import ArpanaSopana_EveryStratumUttersANewChargeAndTheChargeIsWhateverTheSpaceHolds
  using (सामान्यम्)

------------------------------------------------------------------------
-- समः — in the torus, succession commutes, and the proof is the
-- torus's own square read as a composition identity.
------------------------------------------------------------------------

समः : T.line1 ∙ T.line2 ≡ T.line2 ∙ T.line1
समः = Square→compPath T.square

------------------------------------------------------------------------
-- भेदः — in the Klein bottle, the two orders are DISTINCT.  The
-- windings of the composites disagree in the second coordinate
-- ((−1,−1) against (−1,+1), computed), and a function cannot separate
-- equal paths.
------------------------------------------------------------------------

भेदः : ¬ (K.line1 ∙ K.line2 ≡ K.line2 ∙ K.line1)
भेदः h = negsucNotpos 0 1 (cong (λ p → snd (windingKlein p)) h)

------------------------------------------------------------------------
-- वक्रवलयम् — and yet the stratum-3 carrier is the torus's exactly:
-- ℤ × ℤ.  The type cannot tell the two spaces apart; the krama can.
------------------------------------------------------------------------

वक्रवलयम् : typ (Ω (hLevelTrunc∙ 3 (K.KleinBottle , K.point))) ≃ (ℤ × ℤ)
वक्रवलयम् =
  compEquiv (सामान्यम् 0 (K.KleinBottle , K.point))
    (compEquiv
      (isoToEquiv (setTruncIdempotentIso
        (subst isSet (sym ΩKlein≡ℤ²) (isSet× isSetℤ isSetℤ))))
      (pathToEquiv ΩKlein≡ℤ²))
