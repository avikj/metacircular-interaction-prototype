{-# OPTIONS --cubical --safe #-}

------------------------------------------------------------------------
-- शेष-पूर्ति — the filling of a remainder the machine asked for itself.
--
-- PROVENANCE OF THE ASK.  machine/sanghatta-report-latest.txt, regenerated
-- 2026-08-23: 403 non-joining critical pairs of the installed rules, the
-- library's own incompleteness, smallest first — and the top row is
--     x    max(x,0)
-- i.e. the rewriter cannot join x with max x 0.  This module is that pair
-- fed back as a term, and it was built THROUGH the warm conduit (नाडी,
-- Cmd_make_case then Cmd_give): the kernel wrote the case split, the
-- carrier offered refl to each clause, the kernel answered छिद्रं नास्ति.
-- Coprocessing as Nadi.hs's header specifies it, performed rather than
-- described.
--
-- TERM.  शेष-पूर्ति, "filling of the remainder" — ordinary Sanskrit,
-- compound built here, no text claimed (CLAUDE.md naming rule, note 2).
-- The mathematics is one recursion clause of Cubical.Data.Nat.max.
--
-- CHECKED: Agda 2.6.3 + cubical v0.5 (the container; corpus pin is
-- 2.8.0/v0.9).  --cubical --safe, no postulates, no holes.
------------------------------------------------------------------------

module SesaPurti_TheMachinesTopNonJoiningPairFedBackThroughTheWarmConduit where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (ℕ ; zero ; suc ; max)

पूर्तिः : (x : ℕ) → max x 0 ≡ x
पूर्तिः zero    = refl
पूर्तिः (suc x) = refl
