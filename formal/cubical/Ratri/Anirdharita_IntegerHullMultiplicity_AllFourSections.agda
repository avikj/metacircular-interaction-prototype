{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- àà¨à¿à°àà§à¾à°à¿à â” hull is a 6-to-1-per-tile compression and none of the
-- four probed pairings inverts it.  The queue's four remaining rows
-- (notes/SADHYA_OPEN_OBLIGATIONS.md: Qs â hull, Xs â hull at rung à,
-- and the two à–ààà¡à¿àà®à self-refuted rows N â hull, SQ â hull) all guess
-- that a scalar census of a configuration determines the configuration,
-- or that hull's output censuses back to its input.  The host's own
-- theorems price the tile: hullN says N (hull t) = t Â 6, hullSQ says
-- SQ (hull t) = t Â 8 â” the hull of t is five cells per unit, never one,
-- so every section guess dies at t = 1.  Four verdicts, one witness
-- each, all by refl + a decidable discriminator.  Road two, four times.
--
-- (The two à–ààà¡à¿àà®à rows had already refuted themselves â” the probe's
-- induction reached x â‰¡ sucâµ x and x â‰¡ sucâ x, which â• forbids; this
-- module states the same fact positively, as the smallest witnesses.)
--
-- Toolchain: the PIN (Agda 2.8.0 + cubical v0.9); the host uses the
-- v0.9 â• ring solver.
------------------------------------------------------------------------

module Ratri.Anirdharita_IntegerHullMultiplicity_AllFourSections where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (â„•; suc; snotz; znots)
open import Cubical.Data.List using (List; []; _âˆ·_)
open import Cubical.Data.Bool using (Bool; true; false; trueâ‰¢false)
open import Cubical.Data.Empty as Empty using (âŠ¥)
open import IntegerHullMultiplicity using (Config; hull; N; SQ; Xs; Qs)

singleton1 : Config
singleton1 = 1 âˆ· []

-- A discriminator: is the configuration the single cell [1]?
isSingleton1 : Config â†’ Bool
isSingleton1 (1 âˆ· []) = true
isSingleton1 _        = false

-- hull âˆ˜ Xs misses [1]: Xs [1] = 1 and hull 1 is the five-cell tile.
Xs-NOT-DETERMINED : hull (Xs singleton1) â‰¡ singleton1 â†’ âŠ¥
Xs-NOT-DETERMINED p = trueâ‰¢false (cong isSingleton1 (sym p))

-- hull âˆ˜ Qs misses [1]: Qs [1] = 1 likewise.
Qs-NOT-DETERMINED : hull (Qs singleton1) â‰¡ singleton1 â†’ âŠ¥
Qs-NOT-DETERMINED p = trueâ‰¢false (cong isSingleton1 (sym p))

-- N âˆ˜ hull is Â6, never the identity: N (hull 1) = 6 â‰ 1.
N-NOT-DETERMINED : N (hull 1) â‰¡ 1 â†’ âŠ¥
N-NOT-DETERMINED p = snotz (cong predâ„• p)
  where
  predâ„• : â„• â†’ â„•
  predâ„• 0 = 0
  predâ„• (suc n) = n

-- SQ âˆ˜ hull is Â8, never the identity: SQ (hull 1) = 8 â‰ 1.
SQ-NOT-DETERMINED : SQ (hull 1) â‰¡ 1 â†’ âŠ¥
SQ-NOT-DETERMINED p = snotz (cong predâ„• p)
  where
  predâ„• : â„• â†’ â„•
  predâ„• 0 = 0
  predâ„• (suc n) = n
