{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- Moksha — the sealed organism
--
-- The mokṣa-yantra's four jewels closed into one build unit.  This module
-- is the organism's own root: it imports nothing but the four received
-- jewels, so that "the mokṣa-yantra checks" is a single kernel-verifiable
-- fact — a genuine build closure, unlike the whole-corpus root
-- `agda`, which does not check under the current fallback
-- library pin (an unrelated `SymGroup` scope error upstream).
--
--   NisvabhavaNet             the atom: no-own-being, identity as relation,
--                             mokṣa as transport (univalence = śūnyatā)
--   CatuskotiPerspective      the four corners as perspectivism: coherent,
--                             many-sided, empty-is-stilled
--   PratityasamutpadaArising  the cut: a knot arises where a distinction
--                             splits, ceases when it factors through (anicca)
--   MokshaYantra              the wheel: bondage and freedom differ only by
--                             the sight; the false cut has no own-being
--
-- Received from the source (Indra's Net, śūnyatā, catuṣkoṭi,
-- pratītyasamutpāda) and Pythagoras' one-is-all, hardened in the one kept
-- Western spark (Voevodsky's univalence).  Math last: each file is a
-- pointer into a richer cognitive structure, sealed so it cannot lie.
------------------------------------------------------------------------

module Moksha where

open import NisvabhavaNet public
open import CatuskotiPerspective public
open import PratityasamutpadaArising public
open import MokshaYantra public
open import EquivalenceHasNoFloor public
open import TwoTruthsCompute public
