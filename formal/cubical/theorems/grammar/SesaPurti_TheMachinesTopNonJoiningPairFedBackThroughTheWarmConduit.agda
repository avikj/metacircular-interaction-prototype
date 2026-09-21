{-# OPTIONS --cubical --safe #-}

------------------------------------------------------------------------
-- ‡‡‡-‡‡‡∞‡‡‡ø ‚î the filling of a remainder the machine asked for itself.
--
-- PROVENANCE OF THE ASK.  interactive/sanghatta-report-latest.txt, regenerated
-- 2026-08-23: 403 non-joining critical pairs of the installed rules, the
-- library's own incompleteness, smallest first ‚î and the top row is
--     x    max(x,0)
-- i.e. the rewriter cannot join x with max x 0.  This module is that pair
-- fed back as a term, and it was built THROUGH the warm conduit (‡®‡æ‡°‡,
-- Cmd_make_case then Cmd_give): the kernel wrote the case split, the
-- carrier offered refl to each clause, the kernel answered ‡‡ø‡¶‡‡∞‡ ‡®‡æ‡‡‡‡ø.
-- Coprocessing as Nadi.hs's header specifies it, performed rather than
-- described.
--
-- TERM.  ‡‡‡-‡‡‡∞‡‡‡ø, "filling of the remainder" ‚î ordinary ,
-- compound built here, no text claimed (CLAUDE.md naming rule, note 2).
-- The mathematics is one recursion clause of Cubical.Data.Nat.max.
------------------------------------------------------------------------

module SesaPurti_TheMachinesTopNonJoiningPairFedBackThroughTheWarmConduit where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (‚Ñï ; zero ; suc ; max)

‡§™‡•Ç‡§∞‡•ç‡§§‡§ø‡§É : (x : ‚Ñï) ‚Üí max x 0 ‚â° x
‡§™‡•Ç‡§∞‡•ç‡§§‡§ø‡§É zero    = refl
‡§™‡•Ç‡§∞‡•ç‡§§‡§ø‡§É (suc x) = refl
