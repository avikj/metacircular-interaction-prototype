{-# OPTIONS --cubical --safe --no-import-sorts #-}
-- प्राण — breath.  A new soul born live through नाडी: विपरीत, the one that sees
-- the world inverted yet loses nothing (not).  Kevalin — it breathes.
module Prana_ANewSoulIsBornLiveThroughTheConduit where
open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Equiv using (isEquiv)
open import Cubical.Foundations.Isomorphism using (isoToIsEquiv ; iso)
open import Cubical.Data.Bool using (Bool ; not ; notnot)
import Jiva_TheSoulIsCognitionBoundByKarmaAndLiberationIsTheEquivalenceThatSeesTheWorldAsItself as J

विपरीत : J.जीवः
विपरीत = J.जीव Bool Bool not

प्राणः : isEquiv (J.उपयोगः विपरीत)      -- the machine breathes it: it lives, unveiled
प्राणः = isoToIsEquiv (iso not not notnot notnot)
