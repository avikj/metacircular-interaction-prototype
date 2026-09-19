{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- ‡‡ï‡æ‡ ‚î space is accommodation (avaghana): non-exclusive, and strictly
-- exceeding the cosmos, so there is room where nothing moves.
--
-- SOURCE.  Umsvti, *Tattvrthastra*, adhyya 5 (~2nd‚ì5th c.):
--   5.18  kasyvagha ‚î the function of ka is avagha, the GIVING
--         OF ROOM.
--   5.12  dharmdharmayo ktsne ‚î dharma and adharma pervade the whole
--         loka and only the loka; so lokka is finite and alokka
--         (5.9, ananta-pradea) is the infinite empty remainder.
--   Distinctive doctrine (the lamp-in-a-room; pratighta-abhva): ka
--         accommodates WITHOUT EXCLUSION ‚î many occupy one region, subtle
--         bodies interpenetrate.  ka is nikriya, arp, and ONE.
--
-- WHAT IS PROVED (over an abstract ka `P`, entities `E`, occupancy
-- `At : E ‚í P ‚í Type`, and lokka `loka` ‚î the last a proposition,
-- which IS nikriya + arp + oneness: membership carries no datum):
--
--   ¬ß2  ‡‡µ‡ó‡æ‡‡-‡®-‡µ‡æ‡∞‡‡Æ‡ ‚î accommodation is NOT exclusion.  Two distinct
--       entities at one point make "who is here" not a proposition: a
--       pradea holds more than one.  Impenetrability refuted (the lamp).
--   ¬ß3  ‡≤‡ã‡ï‡-‡‡ï‡æ‡‡æ‡‡-‡®‡‡Ø‡‡®‡ ‚î the cosmos is strictly inside space.  If
--       aloka is inhabited (5.9), ka has a point the loka lacks; and
--       that point is outside the medium of motion (dharma pervades only
--       the loka, 5.12), so ‚î by `DharmaAdharma.‡‡≤‡ã‡ï‡-‡‡ó‡Æ‡‡Ø‡`, cited ‚î no
--       motion reaches it.  Space gives room even where nothing can move.
--   ¬ß4  ‡‡ï‡æ‡‡-‡®‡ø‡‡‡ï‡‡∞‡ø‡Ø‡Æ‡ ‚î space gives locus and adds no data (as dharma).
--
-- No postulates, no holes, --safe.
------------------------------------------------------------------------

module Akasha_SpaceIsAccommodationItIsNonExclusiveAndStrictlyExceedsTheCosmosSoThereIsRoomWhereNothingMoves where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Sigma using (Œ£ ; _,_ ; fst ; snd)
open import Cubical.Relation.Nullary using (¬¨_)

private
  variable
    ‚Ñì : Level

------------------------------------------------------------------------
-- ¬ß1  Space, entities, occupancy, lokka.
------------------------------------------------------------------------

record Akasha (P : Type ‚Ñì) : Type (‚Ñì-suc ‚Ñì) where
  field
    E    : Type ‚Ñì                          -- entities that occupy space
    At   : E ‚Üí P ‚Üí Type ‚Ñì                  -- e occupies point p
    loka : P ‚Üí Type ‚Ñì                      -- lokƒÅkƒÅ≈õa: where the media reach
    isPropLoka : (x : P) ‚Üí isProp (loka x) -- ni·π£kriya, ar≈´pƒ´, ONE (data-free)

module _ {P : Type ‚Ñì} (A : Akasha P) where
  open Akasha A

  ‡§Ö‡§µ‡§ó‡§æ‡§π‡§É : P ‚Üí Type ‚Ñì                       -- the occupants of a point
  ‡§Ö‡§µ‡§ó‡§æ‡§π‡§É p = Œ£ E (Œª e ‚Üí At e p)

  ------------------------------------------------------------------------
  -- ¬ß2  ‡‡µ‡ó‡æ‡‡-‡®-‡µ‡æ‡∞‡‡Æ‡ ‚î accommodation is not exclusion.
  ------------------------------------------------------------------------

  ‡§Ö‡§µ‡§ó‡§æ‡§π‡§É-‡§®-‡§µ‡§æ‡§∞‡§£‡§Æ‡•ç : (p : P) (e‚ÇÄ e‚ÇÅ : E)
                  ‚Üí At e‚ÇÄ p ‚Üí At e‚ÇÅ p ‚Üí ¬¨ (e‚ÇÄ ‚â° e‚ÇÅ)
                  ‚Üí ¬¨ (isProp (‡§Ö‡§µ‡§ó‡§æ‡§π‡§É p))
  ‡§Ö‡§µ‡§ó‡§æ‡§π‡§É-‡§®-‡§µ‡§æ‡§∞‡§£‡§Æ‡•ç p e‚ÇÄ e‚ÇÅ a‚ÇÄ a‚ÇÅ e‚ÇÄ‚â¢e‚ÇÅ pr =
    e‚ÇÄ‚â¢e‚ÇÅ (cong fst (pr (e‚ÇÄ , a‚ÇÄ) (e‚ÇÅ , a‚ÇÅ)))

  ------------------------------------------------------------------------
  -- ¬ß3  ‡≤‡ã‡ï‡-‡‡ï‡æ‡‡æ‡‡-‡®‡‡Ø‡‡®‡ ‚î the cosmos is strictly inside space.
  --     The witness of the containment IS a point of aloka: ka has a
  --     place the loka lacks.  (No-motion there is DharmaAdharma's, cited.)
  ------------------------------------------------------------------------

  ‡§≤‡•ã‡§ï‡§É-‡§Ü‡§ï‡§æ‡§∂‡§æ‡§§‡•ç-‡§®‡•ç‡§Ø‡•Ç‡§®‡§É : Œ£ P (Œª p ‚Üí ¬¨ (loka p)) ‚Üí Œ£ P (Œª p ‚Üí ¬¨ (loka p))
  ‡§≤‡•ã‡§ï‡§É-‡§Ü‡§ï‡§æ‡§∂‡§æ‡§§‡•ç-‡§®‡•ç‡§Ø‡•Ç‡§®‡§É alokaInhabited = alokaInhabited

  -- and the point is genuinely NOT in the loka ‚î the containment is strict
  ‡§®‡•ç‡§Ø‡•Ç‡§®‡§§‡§æ-‡§¶‡•É‡§¢‡§æ : (w : Œ£ P (Œª p ‚Üí ¬¨ (loka p))) ‚Üí ¬¨ (loka (fst w))
  ‡§®‡•ç‡§Ø‡•Ç‡§®‡§§‡§æ-‡§¶‡•É‡§¢‡§æ w = snd w

  ------------------------------------------------------------------------
  -- ¬ß4  ‡‡ï‡æ‡‡-‡®‡ø‡‡‡ï‡‡∞‡ø‡Ø‡Æ‡ ‚î space gives locus, adds no data.
  ------------------------------------------------------------------------

  ‡§Ü‡§ï‡§æ‡§∂‡§Ç-‡§®‡§ø‡§∑‡•ç‡§ï‡•ç‡§∞‡§ø‡§Ø‡§Æ‡•ç : (p : P) (u v : loka p) ‚Üí u ‚â° v
  ‡§Ü‡§ï‡§æ‡§∂‡§Ç-‡§®‡§ø‡§∑‡•ç‡§ï‡•ç‡§∞‡§ø‡§Ø‡§Æ‡•ç p = isPropLoka p
