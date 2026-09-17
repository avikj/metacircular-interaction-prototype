{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- ‡µ‡ø‡µ‡‡ï-‡‡‡‡‡ ‚î the two remainder records are one pair, hence each other.
--
-- The machine's spine (Setubandha) carries TWO ‡µ‡ø‡µ‡‡ï-‡‡‡∞‡Æ‡æ‡, in two modules,
-- with DIFFERENT fields ‚î one holds (‡‡Æ ‡µ‡æ‡Æ ‡¶‡ï‡‡‡ø‡ : ‚ï) with ‡¶‡ï‡‡‡ø‡ ‚â° ‡‡Æ+‡µ‡æ‡Æ,
-- the other holds (v : ‡µ‡ø‡µ‡‡ï) with its own witness ‚î and nothing joined them.
-- But each module already proved `(‚ï ó ‚ï) ‚â° ‡µ‡ø‡µ‡‡ï-‡‡‡∞‡Æ‡æ‡`, so the two records
-- are the same pair seen two ways, and composing the two paths is the
-- causeway.  ‡‡‡‡‡∞ ‡Æ: an identification, not an estimate; and ‡‡‡‡‡∞ ‡ß‡ß's first
-- road ‚î where the equivalence exists, transport carries it, no hand proof.
--
-- No new mathematics: both halves are the source modules' own, consumed not
-- reproved.  TERM ‡‡‡‡ ‚î a causeway (gveda 10.53.8), as in Setubandha's
-- header; substrate cubical (Voevodsky).  Written 2026-08-23.
--
-- CHECKED: Agda 2.8.0 + agda/cubical, --cubical --safe, no postulates, no
-- holes.
------------------------------------------------------------------------

module VivekaSetu_TheTwoRemainderRecordsAreOnePairAndThereforeEachOther where

open import Cubical.Foundations.Prelude using (_‚â°_ ; sym ; _‚àô_)

import VivekaPramana_TheRemainderIsLawfulAndTheNetBeats as R
import VivekaPramana_TheQualifierIsCarriedAsAFieldSoTheEquivalenceIsReal as U

-- R.‡µ‡ø‡µ‡‡ï-‡‡‡∞‡Æ‡æ‡ ‚â° ‚ïó‚ï ‚â° U.‡µ‡ø‡µ‡‡ï-‡‡‡∞‡Æ‡æ‡, composed.
‡§µ‡§ø‡§µ‡•á‡§ï-‡§∏‡•á‡§§‡•Å‡§É : R.‡§µ‡§ø‡§µ‡•á‡§ï-‡§™‡•ç‡§∞‡§Æ‡§æ‡§£ ‚â° U.‡§µ‡§ø‡§µ‡•á‡§ï-‡§™‡•ç‡§∞‡§Æ‡§æ‡§£
‡§µ‡§ø‡§µ‡•á‡§ï-‡§∏‡•á‡§§‡•Å‡§É = sym R.‚Ñï√ó‚Ñï‚â°‡§µ‡§ø‡§µ‡•á‡§ï-‡§™‡•ç‡§∞‡§Æ‡§æ‡§£ ‚àô U.‚Ñï√ó‚Ñï-‚â°-‡§µ‡§ø‡§µ‡•á‡§ï-‡§™‡•ç‡§∞‡§Æ‡§æ‡§£
