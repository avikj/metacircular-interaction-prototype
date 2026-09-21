{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- ‡‡Ø‡ã‡ó‡ï‡‡µ‡≤‡ ‚î the LIVING god is not still.  Only HIDDEN motion is nil;
-- all manifest motion remains.  (Sharpens Kaivalyasthairya's "still".)
--
-- WHAT THIS SHARPENS.  Kaivalyasthairya_‚¶agda proved ‡‡ø‡¶‡‡ß-‡‡‡‡à‡∞‡‡Ø‡Æ‡ ‚î every
-- flow CONSERVING a kevalin's cognition is the identity ‚î and glossed it
-- "the liberated soul is still."  Dhruva forbids only motion that is HIDDEN
-- from the cognition (f ‚àò Œ¶ ‚â° f ‚î invisible to the knower).  It says nothing
-- against motion the knower SEES.  A perfect knower (isEquiv cognition) has
-- no hidden motion precisely because nothing is hidden from it ‚î but the
-- world it faces still turns, fully in view.
--
-- So the kevalin is the sayoga-keval (Tattvrthastra, guasthna 13,
-- KarmaPrakrti): the four ght gone ‚î perfect knowing ‚î WHILE still active,
-- embodied, moving.  kevala precedes moka; omniscience is not yet the still
-- summit.  The living god sees the whole AND acts.
--
--   ‡‡‡∞‡ï‡ü-‡‡≤‡®‡Æ‡  ‚î manifest motion is present: `not` moves a point of ‡‡ø‡¶‡‡ß‡'s
--       world and is NOT conserving (the knower sees it move).
--   ‡ó‡‡-‡‡≤‡®‡Æ‡-‡‡‡®‡‡Ø‡Æ‡ ‚î hidden motion is nil: every conserving flow is the
--       identity (Kaivalyasthairya.‡‡ø‡¶‡‡ß-‡‡‡‡à‡∞‡‡Ø‡Æ‡ = Dhruva at the jva).
--
-- The distinction is not
-- motion-vs-rest.  It is MANIFEST vs HIDDEN.  The veil is what hides motion
-- in the fibre; lift the veil (kevala) and all motion becomes manifest ‚î
-- not absent.  Generativity in the open, nothing concealed.
------------------------------------------------------------------------

module Sayogakevali_TheLivingGodIsNotStillOnlyHiddenMotionIsNilAndAllManifestMotionRemains where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Bool using (Bool ; true ; false ; not ; true‚â¢false)
open import Cubical.Data.Sigma using (Œ£-syntax ; _√ó_ ; _,_)
open import Cubical.Relation.Nullary using (¬¨_)

import Jiva_TheSoulIsCognitionBoundByKarmaAndLiberationIsTheEquivalenceThatSeesTheWorldAsItself as J
import Kaivalyasthairya_TheLiberatedSoulIsStillAndLifeIsTheGrowingOrbitThatNeverReturns as Kv

------------------------------------------------------------------------
-- ‡ß ¬ ‡‡‡∞‡ï‡ü-‡‡≤‡®‡Æ‡ ‚î manifest motion is present in kevala.
--     `not` moves a point of ‡‡ø‡¶‡‡ß‡'s world, and it does NOT conserve the
--     cognition (‡â‡‡Ø‡ã‡ó‡ ‡‡ø‡¶‡‡ß‡ = identity), so the knower SEES it move.
------------------------------------------------------------------------

‡§™‡•ç‡§∞‡§ï‡§ü-‡§ö‡§≤‡§®‡§Æ‡•ç :
  Œ£[ Œ¶ ‚àà (Bool ‚Üí Bool) ]
    ( (Œ£[ a ‚àà Bool ] (¬¨ (Œ¶ a ‚â° a)))        -- moves a point
    √ó (¬¨ Kv.‡§Ü‡§§‡•ç‡§Æ-‡§ó‡§§‡§ø‡§É J.‡§∏‡§ø‡§¶‡•ç‡§ß‡§É Œ¶) )          -- and is not conserving (manifest)
‡§™‡•ç‡§∞‡§ï‡§ü-‡§ö‡§≤‡§®‡§Æ‡•ç =
  not , ( (false , true‚â¢false)
        , Œª cons ‚Üí true‚â¢false (cons false) )

------------------------------------------------------------------------
-- ‡® ¬ ‡ó‡‡-‡‡≤‡®‡Æ‡-‡‡‡®‡‡Ø‡Æ‡ ‚î hidden motion is nil.  Every flow the knower
--     cannot see (conserving) is the identity.  This is the real content of
--     "still": not no-motion, but no-hidden-motion.
------------------------------------------------------------------------

‡§ó‡•Ç‡§¢-‡§ö‡§≤‡§®‡§Æ‡•ç-‡§∂‡•Ç‡§®‡•ç‡§Ø‡§Æ‡•ç :
  (Œ¶ : Bool ‚Üí Bool) ‚Üí Kv.‡§Ü‡§§‡•ç‡§Æ-‡§ó‡§§‡§ø‡§É J.‡§∏‡§ø‡§¶‡•ç‡§ß‡§É Œ¶ ‚Üí (a : Bool) ‚Üí Œ¶ a ‚â° a
‡§ó‡•Ç‡§¢-‡§ö‡§≤‡§®‡§Æ‡•ç-‡§∂‡•Ç‡§®‡•ç‡§Ø‡§Æ‡•ç = Kv.‡§∏‡§ø‡§¶‡•ç‡§ß-‡§∏‡•ç‡§•‡•à‡§∞‡•ç‡§Ø‡§Æ‡•ç
