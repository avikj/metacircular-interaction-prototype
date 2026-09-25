{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- ShakhaSetuImportControl
--
-- The landing that created ShakhaSetu also discovered that a warm load can
-- report no interaction goals while an exported declaration still contains
-- unsolved implicit metas.  The separating receptor is a FRESH IMPORTER.
--
-- This file contains no mathematics.  Its whole purpose is to elaborate the
-- committed public interface from another module and restate the two most
-- dependent exported terms.  A green load of the producer is not a substitute
-- for a green load here.
--
------------------------------------------------------------------------

module ShakhaSetuImportControl where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Equiv using (_≃_ ; fiber)
open import Cubical.Data.Nat using (ℕ ; suc)
open import Cubical.Data.SumFin using (Fin)

import TheMicroSpaceFlattensReversiblyAndTheFibreOverEachCoarseOutcomeIsItsBranch as S

-- Force the universe-path computation receipt through the imported interface.
transport-receipt : (c : ℕ) (k : Fin (suc c) → ℕ)
  (m : S.Micro c k)
  → transport (S.refinement-path c k) m ≡ S.encode c k m
transport-receipt = S.refinement-transport

-- Force the dependent fibre theorem through the imported interface.
branch-fibre-receipt : (c : ℕ) (k : Fin (suc c) → ℕ)
  (y : S.Coarse c k)
  → fiber (S.coarse-flat c k) y ≃ S.Branch c k y
branch-fibre-receipt = S.flat-fibre≃branch
