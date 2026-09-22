{-# OPTIONS --cubical --safe #-}

------------------------------------------------------------------------
-- ‡‡‡-‡‡‡∞‡‡‡ø ‚î the filling of a remainder the machine asked for itself.
--
-- interactive/sanghatta-report-latest.txt lists the non-joining critical
-- pairs of the installed rules, smallest first, and the top row is
--     x    max(x,0)
-- i.e. the rewriter cannot join x with max x 0.  This module is that pair
-- fed back as a term.
--
-- TERM.  ‡‡‡-‡‡‡∞‡‡‡ø, "filling of the remainder" ‚î ordinary ,
-- compound built here.
-- The mathematics is one recursion clause of Cubical.Data.Nat.max.
------------------------------------------------------------------------

module SesaPurti_TheMachinesTopNonJoiningPairFedBackThroughTheWarmConduit where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (‚Ñï ; zero ; suc ; max)

‡§™‡•Ç‡§∞‡•ç‡§§‡§ø‡§É : (x : ‚Ñï) ‚Üí max x 0 ‚â° x
‡§™‡•Ç‡§∞‡•ç‡§§‡§ø‡§É zero    = refl
‡§™‡•Ç‡§∞‡•ç‡§§‡§ø‡§É (suc x) = refl
