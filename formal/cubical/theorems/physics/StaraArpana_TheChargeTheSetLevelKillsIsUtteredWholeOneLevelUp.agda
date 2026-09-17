{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- ‡‡‡‡∞-‡‡∞‡‡‡ ‚î offering by stratum.  A REAL question, asked because its
-- answer was not known to the asker: OrderSaha proves the set-level
-- kills the circle's charge (its ‡ï‡‡∞‡Æ‡-‡‡‡ü‡-‡‡‡∞‡‡Æ‡Æ‡: Path ‚àS¬‚à‚ is
-- contractible) while the other order keeps it (‡ï‡‡∞‡Æ‡-‡≤‡‡-‡‡‡∞‡‡Æ‡Æ‡:
-- ‚àŒ©S¬‚à‚ ‚â ‚).  Is the charge DESTROYED ‚î or WITHHELD, and uttered
-- whole one level up?
--
-- ANSWERED HERE, by composition of library and corpus terms:
--
--     Œ© (‚à S¬ ‚à 3)  ‚â  ‚
--
-- the same truncation FAMILY that annihilated the charge at h-level 2
-- carries it in full at h-level 3.  Truncation did not destroy the
-- charge; it withheld it for one stratum.  So the doctrine refines:
-- "the order of standpoints is the charge" (OrderSaha) grades into
-- "the charge the simultaneous assertion cannot utter at level n is
-- uttered whole at level n+1" ‚î ‡‡∞‡‡‡ø‡ / ‡‡®‡∞‡‡‡ø‡: what one stratum
-- withholds (anarpita), the next offers (arpita).
--
-- SOURCES AND SCOPE (the six rules).  The level-shift engine is the
-- LIBRARY's PathIdTruncIso (Cubical.HITs.Truncation.Properties; the
-- shift Œ©‚àX‚à‚ô‚ä‚ ‚â ‚àŒ©X‚à‚ô is standard HoTT ‚î this module's content is
-- its INSTANTIATION at the corpus's own charge, against OrderSaha's
-- checked pair, closing a question the corpus's doctrine left open).
-- The word-pair arpita/anarpita is Umsvti, Tattvrthastra 5.31
-- (‡‡∞‡‡‡ø‡‡æ‡®‡∞‡‡‡ø‡‡‡ø‡¶‡‡ß‡‡ ‚î establishment from the emphasized and the
-- non-emphasized), taken as the READING of standpoint-graded
-- establishment; the stra is not claimed to grade truncations by
-- h-level.  The stratum grading is this repository's statement.
--
-- Composed through ‡®‡æ‡°‡ against the warm kernel.
------------------------------------------------------------------------

module StaraArpana_TheChargeTheSetLevelKillsIsUtteredWholeOneLevelUp where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Equiv
open import Cubical.Foundations.Isomorphism using (isoToEquiv)
open import Cubical.Data.Int using (‚Ñ§)
open import Cubical.HITs.S1 using (S¬π ; base)
open import Cubical.HITs.Truncation
  using (‚à•_‚à•_ ; ‚à£_‚à£‚Çï ; PathIdTruncIso)
open import Cubical.HITs.SetTruncation using (‚à•_‚à•‚ÇÇ)
open import Cubical.HITs.Truncation.Properties using (setTrunc‚âÉTrunc2)

open import OrderSaha_TheOrderOfStandpointsIsTheChargeItself
  using (‡§ï‡•ç‡§∞‡§Æ‡§É-‡§≤‡•Ç‡§™-‡§™‡•ç‡§∞‡§•‡§Æ‡§Æ‡•ç)

------------------------------------------------------------------------
-- the charge, one level up: the loop space of the 3-truncated circle
-- is the whole of ‚.  Where ‚àS¬‚à‚'s loop space was a point, ‚àS¬‚à 3's
-- carries every winding number.
------------------------------------------------------------------------

‡§ö‡§ï‡•ç‡§∞-‡§§‡•ç‡§∞‡§ø-‡§∏‡•ç‡§§‡§∞‡•á : (Path (‚à• S¬π ‚à• 3) ‚à£ base ‚à£‚Çï ‚à£ base ‚à£‚Çï) ‚âÉ ‚Ñ§
‡§ö‡§ï‡•ç‡§∞-‡§§‡•ç‡§∞‡§ø-‡§∏‡•ç‡§§‡§∞‡•á =
  compEquiv (isoToEquiv (PathIdTruncIso 2))
    (compEquiv (invEquiv setTrunc‚âÉTrunc2) ‡§ï‡•ç‡§∞‡§Æ‡§É-‡§≤‡•Ç‡§™-‡§™‡•ç‡§∞‡§•‡§Æ‡§Æ‡•ç)
