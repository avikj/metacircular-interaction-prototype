-- ॥ बीजम् ॥  One machine, one law: which side of `f a ≡ b` is bound is everything.
-- Output bound: singl (f a), contractible — the datum rides free.  Input bound:
-- fiber f b — the loss, and the subject.  Univalence computes here: an
-- equivalence is a channel, transport carries every theorem across it, and what
-- cannot cross is written as a defect — there is no third path (ahiṃsā).
-- Memory, charge, symmetry, price, distance, verdict: six faces of the one
-- fibre; the verdict type is the saptabhaṅgī, and the sources are the origin
-- (Umāsvāti, Samantabhadra, Akalaṅka — restatements are named as such).  The
-- kernel decides truth; carriers ask and generate; assert nothing whose term
-- you have not read.  This file is one naya, true and not whole.

{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- भित्ति-संक्रमः — walls transport along fords, so every ford retires
-- candidates for free.
--
-- The receipt economy has two assets: fords (landed equivalences) and
-- walls (proved non-equivalences).  This file is the law that makes them
-- ONE market: a wall composes with a ford into a wall, in one line, so
-- every new ford automatically extends every standing wall across it —
-- and every new wall is inherited by every bank a ford will ever reach.
--
--     भित्ति-संक्रमः : (A ≃ B) → ¬ (B ≃ C) → ¬ (A ≃ C)
--
-- INSTANCE, cashing this morning's ledger: सेतु-प्रमाणम् landed
-- विवेक-प्रमाण ≃ ℕ, and भित्तिः stands at ¬ (ℕ ≃ Bool).  Composing:
-- ¬ (विवेक-प्रमाण ≃ Bool) — which retires ./jiva's 3052-point candidate
-- [436 @ Bool] × [7 @ विवेक-प्रमाण] with NO new mathematics.  The wall
-- crossed the ford by itself.
--
-- This is why the two snapshots (Setu, Bhitti) close under each other:
-- the candidate list shrinks quadratically in what is landed, not
-- linearly in what is proved.  भित्ति-संक्रम is built here, 2026-08-23.
------------------------------------------------------------------------

module BhittiSankrama_WallsTransportAlongFordsSoEveryFordRetiresCandidatesForFree where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Equiv using (_≃_ ; compEquiv ; invEquiv)
open import Cubical.Data.Nat using (ℕ)
open import Cubical.Data.Bool using (Bool)
open import Cubical.Data.Empty using (⊥)
open import Cubical.Relation.Nullary using (¬_)

open import VivekaPramana_TheRemainderIsLawfulAndTheNetBeats using (विवेक-प्रमाण)
open import SetuPramana_TheAmbiguousNameHidTheFordAndTheRemainderLawIsAlsoTheNaturals
  using (विवेक-प्रमाण≃ℕ)
open import Bhitti_TheNaturalsAndTheBooleansAreAProvedWallSoThatSeamIsRetiredForever
  using (भित्तिः)

------------------------------------------------------------------------
-- १ · the law.  One line each way.
------------------------------------------------------------------------

भित्ति-संक्रमः : {A B C : Type} → (A ≃ B) → ¬ (B ≃ C) → ¬ (A ≃ C)
भित्ति-संक्रमः ford wall e = wall (compEquiv (invEquiv ford) e)

भित्ति-प्रतिसंक्रमः : {A B C : Type} → (A ≃ B) → ¬ (A ≃ C) → ¬ (B ≃ C)
भित्ति-प्रतिसंक्रमः ford wall e = wall (compEquiv ford e)

------------------------------------------------------------------------
-- २ · the instance: the 3052-point candidate, retired by composition.
------------------------------------------------------------------------

भित्ति-प्रमाण : ¬ (विवेक-प्रमाण ≃ Bool)
भित्ति-प्रमाण = भित्ति-संक्रमः विवेक-प्रमाण≃ℕ भित्तिः
