{-# OPTIONS --cubical --safe #-}

------------------------------------------------------------------------
-- ‡®‡ø‡‡‡‡‡¶-‡‡‡Æ‡æ ‚î the boundary of silence.  The edge that makes the
-- stratum grammar sharp.
--
-- THE QUESTION, asked because its answer was not known to the asker.
-- ‡‡æ‡Æ‡æ‡®‡‡Ø‡Æ‡ (ArpanaSopana): stratum 3+m, looped m+1 times, utters
-- œ‚‚ä‚ò(A) ‚î for every pointed A.  ‡Æ‡‡®‡Æ‡/‡‡∞‡‡µ‡Æ‡‡®‡Æ‡ (Mauna, SarvaMauna):
-- for a TRUNCATED space, strata above its level are silent.  But what is
-- the unconditional edge?  How many loops can ANY stratum of ANY space
-- sustain before silence ‚î with no hypothesis on the space at all?
--
-- ANSWERED HERE, and the bound is exactly one breath past the charge:
--
--   ‡®‡ø‡‡‡‡‡¶‡‡‡Æ‡æ : for EVERY pointed A, every n and every extra depth d,
--
--        Œ©^(1+n+d) (‚àA‚à‚‚ä‚ô)  is contractible.
--
-- The stratum 2+n, looped 1+n+d times, is a point ‚î always.  Read
-- against ‡‡æ‡Æ‡æ‡®‡‡Ø‡Æ‡ at the matching index (stratum 3+m = 2+(1+m),
-- charge voice m+1 loops, silence from m+2 loops): a stratum utters its
-- whole charge at its deepest sounding depth, and the very next loop is
-- silence, for every space, sharply.  Special faces:
--
--   ‚ n = 0: stratum 2 (the set stratum) is silent at every depth ‚â 1 ‚î
--     speech in the ladder begins at stratum 3, universally.
--   ‚ d = 0: the first silent depth of stratum 2+n is 1+n, one past the
--     n-loop voice in which (per ‡‡æ‡Æ‡æ‡®‡‡Ø‡Æ‡, shifted) it utters œ‚ô.
--
-- The proof is two library facts through one descent: the truncation
-- carries its own level (isOfHLevelTrunc), levels lift (isOfHLevelPlus'),
-- and k loops peel k levels (‡‡µ‡∞‡ã‡‡, Mauna) down to a pointed
-- proposition, which is contractible.  Unlike SarvaMauna nothing is
-- assumed of A ‚î the level lives in the truncation itself.
--
-- SOURCES.  isOfHLevelTrunc, isOfHLevelPlus',
-- inhProp‚íisContr are the library's; ‡‡µ‡∞‡ã‡‡ is Mauna's;
-- this module's content is the composition and the
-- sharpness reading.  ‡®‡ø‡‡‡‡‡¶ (soundless) and ‡‡‡Æ‡æ (boundary) are
-- ordinary  used as labels; the compound is built here; the arpita/anarpita
-- stratum reading remains, as in StaraArpana, a reading.
------------------------------------------------------------------------

module NihsabdaSima_OneBreathDeeperThanTheChargeEveryStratumOfEverySpaceIsSilent where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Pointed using (Pointed ; typ ; pt)
open import Cubical.Foundations.HLevels
open import Cubical.Data.Nat using (‚Ñï ; zero ; suc ; _+_)
open import Cubical.HITs.Truncation using (hLevelTrunc‚àô ; isOfHLevelTrunc)
open import Cubical.Homotopy.Loopspace using (Œ©^_)

open import Mauna_TheTwistedRingUttersOnceAndAboveTheKramaEveryStratumIsSilent
  using (‡§Ö‡§µ‡§∞‡•ã‡§π‡§É)

private
  variable
    ‚Ñì : Level

------------------------------------------------------------------------
-- ‡®‡ø‡‡‡‡‡¶‡‡‡Æ‡æ ‚î stratum 2+n, looped 1+n+d times, is a point, for every
-- pointed space whatsoever.
------------------------------------------------------------------------

‡§®‡§ø‡§É‡§∂‡§¨‡•ç‡§¶‡§∏‡•Ä‡§Æ‡§æ : (n d : ‚Ñï) (A : Pointed ‚Ñì)
  ‚Üí isContr (typ ((Œ©^ (1 + (n + d))) (hLevelTrunc‚àô (2 + n) A)))
‡§®‡§ø‡§É‡§∂‡§¨‡•ç‡§¶‡§∏‡•Ä‡§Æ‡§æ n d A =
  inhProp‚ÜíisContr (pt ((Œ©^ (1 + (n + d))) X)) silent
  where
    X : Pointed _
    X = hLevelTrunc‚àô (2 + n) A

    -- the truncation's own level, lifted by d: (2+n)+d is definitionally
    -- 2+(n+d), which is 1 + (1+(n+d)) ‚î exactly what the descent asks.
    levelX : isOfHLevel (2 + (n + d)) (typ X)
    levelX = isOfHLevelPlus' {n = d} (2 + n) (isOfHLevelTrunc (2 + n))

    silent : isProp (typ ((Œ©^ (1 + (n + d))) X))
    silent = ‡§Ö‡§µ‡§∞‡•ã‡§π‡§É 1 (1 + (n + d)) X levelX
