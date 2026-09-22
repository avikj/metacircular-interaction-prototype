{-# OPTIONS --cubical --safe #-}

------------------------------------------------------------------------
-- ‡Æ‡‡®‡Æ‡ ‚î silence.  The complement of the ladder of offerings.
--
-- THE QUESTION, asked because its answer was not known to the asker.
-- ArpanaSopana: every stratum of the sphere utters a NEW charge ‚î the
-- ladder never ends.  VakraValaya: the Klein bottle's one charge lives
-- in the krama, at stratum 3.  Does the twisted ring ever speak again
-- above that stratum ‚î or does it utter once and hold silence forever?
--
-- ANSWERED HERE: silence, at every depth, and the reason is an h-level.
-- The general law is about ANY groupoid-truncated space:
--
--   ‡Æ‡‡®‡Æ‡  :  a groupoid A has  Œ©µê‚∫¬≤(‚àA‚à‚‚ä‚ò)  contractible for every m ‚î
--            above the stratum where œ‚ speaks, no stratum utters
--            anything, because each loop peels one h-level and a
--            groupoid has only three to give.
--   ‡µ‡ï‡‡∞‡Æ‡‡®‡Æ‡ : the Klein bottle instance, on the library's
--            isGroupoidKleinBottle.
--
-- Read with ArpanaSopana's ‡‡æ‡Æ‡æ‡®‡‡Ø‡Æ‡ (Œ©µê‚∫¬(‚àA‚à‚‚ä‚ò) ‚â œ‚ò‚ä‚ A), this says
-- œ‚ò‚ä‚(K) is trivial for every m ‚î the surface is aspherical ‚î but that
-- composition is not re-proved here; this module is self-contained on
-- h-levels alone, so it loads light.  Together the three modules close
-- one picture: the sphere is a ladder that never ends; the twisted ring
-- is a bell struck once ‚î everything it will ever say is said at
-- stratum 3, and said in the ORDER of succession, not in the carrier.
--
-- SOURCES.  isGroupoidKleinBottle is the library's
-- (Cubical.HITs.KleinBottle.Properties); the h-level engines
-- (isOfHLevelPath', isOfHLevelPlus', isOfHLevelRespectEquiv,
-- truncIdempotentIso, isOfHLevelTrunc) are the library's; this module's
-- content is ‡‡µ‡∞‡ã‡‡ (the descent of levels through iterated Œ©) and the
-- composition.  ‡Æ‡‡® (silence) and ‡‡µ‡∞‡ã‡ (descent) are ordinary 
-- labels.  Umsvti's
-- arpita/anarpita reading of strata is inherited from StaraArpana and,
-- as there, is a reading.
------------------------------------------------------------------------

module Mauna_TheTwistedRingUttersOnceAndAboveTheKramaEveryStratumIsSilent where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Equiv
open import Cubical.Foundations.Isomorphism using (isoToEquiv ; invIso)
open import Cubical.Foundations.Pointed using (Pointed ; typ ; pt)
open import Cubical.Foundations.HLevels
open import Cubical.Data.Nat using (‚Ñï ; zero ; suc ; _+_)
open import Cubical.Data.Nat.Properties using (+-suc ; +-zero)
open import Cubical.HITs.Truncation
  using (hLevelTrunc‚àô ; truncIdempotentIso)
open import Cubical.Homotopy.Loopspace using (Œ©^_ ; Œ©)
open import Cubical.HITs.KleinBottle using (KleinBottle ; point)
open import Cubical.HITs.KleinBottle.Properties using (isGroupoidKleinBottle)

private
  variable
    ‚Ñì : Level

------------------------------------------------------------------------
-- ‡‡µ‡∞‡ã‡‡ ‚î the descent: k loops peel k h-levels.  Stated with the sum
-- on the left of the level so the instantiations below are definitional.
------------------------------------------------------------------------

‡§Ö‡§µ‡§∞‡•ã‡§π‡§É : (n k : ‚Ñï) (A : Pointed ‚Ñì)
  ‚Üí isOfHLevel (n + k) (typ A) ‚Üí isOfHLevel n (typ ((Œ©^ k) A))
‡§Ö‡§µ‡§∞‡•ã‡§π‡§É n zero    A h = subst (Œª x ‚Üí isOfHLevel x (typ A)) (+-zero n) h
‡§Ö‡§µ‡§∞‡•ã‡§π‡§É n (suc k) A h =
  isOfHLevelPath' n
    (‡§Ö‡§µ‡§∞‡•ã‡§π‡§É (suc n) k A
      (subst (Œª x ‚Üí isOfHLevel x (typ A)) (+-suc n k) h))
    (pt ((Œ©^ k) A)) (pt ((Œ©^ k) A))

------------------------------------------------------------------------
-- ‡Æ‡‡®‡Æ‡ ‚î a groupoid, truncated at any stratum above the krama's, is
-- silent there: the (4+m)-th stratum's (2+m)-fold loop space is a point.
------------------------------------------------------------------------

‡§Æ‡•å‡§®‡§Æ‡•ç : (m : ‚Ñï) (A : Pointed ‚Ñì) ‚Üí isGroupoid (typ A)
  ‚Üí isContr (typ ((Œ©^ (2 + m)) (hLevelTrunc‚àô (4 + m) A)))
‡§Æ‡•å‡§®‡§Æ‡•ç m A grpd =
  inhProp‚ÜíisContr (pt ((Œ©^ (2 + m)) (hLevelTrunc‚àô (4 + m) A))) silent
  where
    truncLevel : isOfHLevel (1 + (2 + m)) (typ (hLevelTrunc‚àô (4 + m) A))
    truncLevel =
      isOfHLevelRespectEquiv (3 + m)
        (isoToEquiv (invIso (truncIdempotentIso (4 + m)
          (isOfHLevelPlus' {n = suc m} 3 grpd))))
        (isOfHLevelPlus' {n = m} 3 grpd)
    silent : isProp (typ ((Œ©^ (2 + m)) (hLevelTrunc‚àô (4 + m) A)))
    silent = ‡§Ö‡§µ‡§∞‡•ã‡§π‡§É 1 (2 + m) (hLevelTrunc‚àô (4 + m) A) truncLevel

------------------------------------------------------------------------
-- ‡µ‡ï‡‡∞‡Æ‡‡®‡Æ‡ ‚î the twisted ring utters once.  Its stratum-3 charge is the
-- krama (VakraValaya); above that, every stratum is a point.
------------------------------------------------------------------------

‡§µ‡§ï‡•ç‡§∞‡§Æ‡•å‡§®‡§Æ‡•ç : (m : ‚Ñï)
  ‚Üí isContr (typ ((Œ©^ (2 + m)) (hLevelTrunc‚àô (4 + m) (KleinBottle , point))))
‡§µ‡§ï‡•ç‡§∞‡§Æ‡•å‡§®‡§Æ‡•ç m = ‡§Æ‡•å‡§®‡§Æ‡•ç m (KleinBottle , point) isGroupoidKleinBottle
