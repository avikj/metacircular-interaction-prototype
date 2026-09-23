{-# OPTIONS --cubical --safe #-}

------------------------------------------------------------------------
-- ‡‡∞‡‡µ-‡Æ‡‡®‡Æ‡ ‚î the silence, universal.  Mauna's descent proved more than
-- Mauna stated, and this module states it.
--
-- THE QUESTION, asked because its answer was not known to the asker.
-- Mauna: a GROUPOID falls silent above the order's stratum.  But ‡‡µ‡∞‡ã‡‡
-- (k loops peel k levels) never used level three specifically.  What is
-- the actual law?  And does the torus ‚î the UNTWISTED ring, whose
-- stratum-3 charge ‚ ó ‚ ArpanaSopana already uttered ‚î also fall
-- silent forever above it, so that BOTH rings are bells struck once and
-- the two surfaces differ only in what the single strike says?
--
-- ANSWERED HERE.
--
--   ‡‡∞‡‡µ‡Æ‡‡®‡Æ‡  : a space of h-level (3+n) has EVERY stratum above its own
--              level silent: Œ©¬≤‚∫‚ø‚∫µê(‚àA‚à‚‚ä‚ô‚ä‚ò) is contractible for all m.
--              The ladder of a truncated space ends exactly at its own
--              level; only untruncated spaces (the spheres) speak
--              forever.  Mauna's ‡Æ‡‡®‡Æ‡ is the n = 0 face.
--   ‡‡Æ‡µ‡≤‡Ø‡    : the torus is a groupoid ‚î carried across Torus‚â°S¬óS¬
--              from isGroupoidS¬ twice, by isOfHLeveló.
--   ‡‡Æ‡Æ‡‡®‡Æ‡    : therefore the untwisted ring is ALSO a bell struck once:
--              every stratum above 3 is a point.
--
-- THE PICTURE, now closed on both sides.  Torus and Klein bottle: one
-- stratum-3 carrier ‚ ó ‚ (ArpanaSopana, CurvedLoop), one strike each,
-- silence above (this module) ‚î and the entire difference between the
-- orientable and non-orientable surface is what the strike SAYS: whether
-- the two successions agree (‡‡Æ‡) or differ (‡‡‡¶‡).  The order is not
-- one voice among strata; for both rings it is the whole voice, said
-- once.  The sphere ladder (ArpanaSopana) stands alone as the shape
-- that never finishes speaking ‚î and ‡‡∞‡‡µ‡Æ‡‡®‡Æ‡ says why: it is not
-- truncated at any level.
--
-- SOURCES AND SCOPE.  ‡‡µ‡∞‡ã‡‡ is imported from Mauna (this corpus,
-- 2026-08-23); isGroupoidS¬ (Cubical.HITs.S1.Properties), Torus‚â°S¬óS¬
-- (Cubical.HITs.Torus.Base), isOfHLeveló, isOfHLevelPlus',
-- isOfHLevelRespectEquiv, truncIdempotentIso are the library's.  This
-- module's content is the generalisation and the two torus terms.
-- ‡‡∞‡‡µ (all), ‡‡Æ (even/level, for the untwisted), ‡µ‡≤‡Ø (ring) are
-- ordinary  labels; no source is claimed for the mathematics,
-- and, as in StaraArpana, arpita/anarpita as a READING of strata is
-- Umsvti (Tattvrthastra 5.31) with no claim that any source grades
-- truncations.
------------------------------------------------------------------------

module SarvaMauna_TheLadderOfATruncatedSpaceEndsExactlyAtItsOwnLevelAndTheUntwistedRingJoinsTheBell where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Equiv
open import Cubical.Foundations.Isomorphism using (isoToEquiv ; invIso)
open import Cubical.Foundations.Pointed using (Pointed ; typ ; pt)
open import Cubical.Foundations.HLevels
open import Cubical.Data.Nat using (‚Ñï ; zero ; suc ; _+_)
open import Cubical.Data.Sigma using (_√ó_)
open import Cubical.HITs.Truncation using (hLevelTrunc‚àô ; truncIdempotentIso)
open import Cubical.Homotopy.Loopspace using (Œ©^_)
open import Cubical.HITs.S1 using (S¬π)
open import Cubical.HITs.S1.Properties using (isGroupoidS¬π)
open import Cubical.HITs.Torus.Base using (Torus ; point ; Torus‚â°S¬π√óS¬π)

open import Mauna_TheTwistedRingUttersOnceAndAboveTheOrderEveryStratumIsSilent
  using (‡§Ö‡§µ‡§∞‡•ã‡§π‡§É)

private
  variable
    ‚Ñì : Level

------------------------------------------------------------------------
-- ‡‡∞‡‡µ‡Æ‡‡®‡Æ‡ ‚î the ladder of a (3+n)-truncated space ends at its own
-- level: every stratum above it, at every depth, is a point.
------------------------------------------------------------------------

‡§∏‡§∞‡•ç‡§µ‡§Æ‡•å‡§®‡§Æ‡•ç : {‚Ñì : Level} (n m : ‚Ñï) (A : Pointed ‚Ñì) ‚Üí isOfHLevel (3 + n) (typ A)
  ‚Üí isContr (typ ((Œ©^ (2 + (n + m))) (hLevelTrunc‚àô (4 + (n + m)) A)))
‡§∏‡§∞‡•ç‡§µ‡§Æ‡•å‡§®‡§Æ‡•ç {‚Ñì} n m A h =
  inhProp‚ÜíisContr (pt ((Œ©^ (2 + (n + m))) X)) silent
  where
    X : Pointed ‚Ñì
    X = hLevelTrunc‚àô (4 + (n + m)) A

    -- (3+n)+m is definitionally 3+(n+m), so the lift is one term
    levelA : isOfHLevel (3 + (n + m)) (typ A)
    levelA = isOfHLevelPlus' (3 + n) h

    silent : isProp (typ ((Œ©^ (2 + (n + m))) X))
    silent =
      ‡§Ö‡§µ‡§∞‡•ã‡§π‡§É 1 (2 + (n + m)) X
        (isOfHLevelRespectEquiv (3 + (n + m))
          (isoToEquiv (invIso (truncIdempotentIso (4 + (n + m))
            (isOfHLevelSuc (3 + (n + m)) levelA))))
          levelA)

------------------------------------------------------------------------
-- ‡‡Æ‡µ‡≤‡Ø‡ ‚î the untwisted ring is a groupoid, carried across its own
-- splitting into two circles.
------------------------------------------------------------------------

‡§∏‡§Æ‡§µ‡§≤‡§Ø‡§É : isGroupoid Torus
‡§∏‡§Æ‡§µ‡§≤‡§Ø‡§É = subst isGroupoid (sym Torus‚â°S¬π√óS¬π)
           (isOfHLevel√ó 3 isGroupoidS¬π isGroupoidS¬π)

------------------------------------------------------------------------
-- ‡‡Æ‡Æ‡‡®‡Æ‡ ‚î and therefore also a bell struck once: silence at every
-- stratum above the order's.
------------------------------------------------------------------------

‡§∏‡§Æ‡§Æ‡•å‡§®‡§Æ‡•ç : (m : ‚Ñï)
  ‚Üí isContr (typ ((Œ©^ (2 + m)) (hLevelTrunc‚àô (4 + m) (Torus , point))))
‡§∏‡§Æ‡§Æ‡•å‡§®‡§Æ‡•ç m = ‡§∏‡§∞‡•ç‡§µ‡§Æ‡•å‡§®‡§Æ‡•ç zero m (Torus , point) ‡§∏‡§Æ‡§µ‡§≤‡§Ø‡§É
