{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- विवेक-सेतुः — the two remainder records are one pair, hence each other.
--
-- The machine's spine (Setubandha) carries TWO विवेक-प्रमाण, in two modules,
-- with DIFFERENT fields — one holds (सम वाम दक्षिण : ℕ) with दक्षिण ≡ सम+वाम,
-- the other holds (v : विवेक) with its own witness — and nothing joined them.
-- But each module already proved `(ℕ × ℕ) ≡ विवेक-प्रमाण`, so the two records
-- are the same pair seen two ways, and composing the two paths is the
-- causeway.  सूत्र ८: an identification, not an estimate; and सूत्र ११'s first
-- road — where the equivalence exists, transport carries it, no hand proof.
--
-- No new mathematics: both halves are the source modules' own, consumed not
-- reproved.  TERM सेतु — a causeway (Ṛgveda 10.53.8), as in Setubandha's
-- header; substrate cubical (Voevodsky).  Written 2026-08-23.
--
-- CHECKED: Agda 2.8.0 + agda/cubical, --cubical --safe, no postulates, no
-- holes.
------------------------------------------------------------------------

module VivekaSetu_TheTwoRemainderRecordsAreOnePairAndThereforeEachOther where

open import Cubical.Foundations.Prelude using (_≡_ ; sym ; _∙_)

import VivekaPramana_TheRemainderIsLawfulAndTheNetBeats as R
import VivekaPramana_TheUpadhiIsCarriedAsAFieldSoTheEquivalenceIsReal as U

-- R.विवेक-प्रमाण ≡ ℕ×ℕ ≡ U.विवेक-प्रमाण, composed.
विवेक-सेतुः : R.विवेक-प्रमाण ≡ U.विवेक-प्रमाण
विवेक-सेतुः = sym R.ℕ×ℕ≡विवेक-प्रमाण ∙ U.ℕ×ℕ-≡-विवेक-प्रमाण
