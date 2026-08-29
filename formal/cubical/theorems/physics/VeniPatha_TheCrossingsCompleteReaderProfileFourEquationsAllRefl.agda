{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- वेणी-पथ — the crossing's reader profile, complete.
--
-- AnantaVeniMatra proved the two locality families (readers below and
-- readers above the crossing pair are unmoved).  This file adds the
-- two equations AT the pair, completing the profile:
--
--     reader i     of σᵢ s  =  turn (reader (i+1) s)
--     reader (i+1) of σᵢ s  =  reader i s
--
-- each by an induction whose base is refl.  With the two locality
-- families, every reader of a crossed rope is now a NAMED function of
-- at most one reader of the uncrossed rope — the crossing's full
-- causal signature: what it reads (the pair), what it writes (the
-- pair, swapped, one turned), what it cannot touch (everything else).
--
-- This is the continuity data of the coming topology in reader form,
-- modulus-free: output reader j depends on input reader j (off the
-- pair), on input reader i+1 (at i), on input reader i (at i+1), and
-- on nothing else — causality as four checked equations rather than a
-- bound.
--
-- SYĀT — THE CLAIM, EXACTLY.  The four-equation profile; the induced
-- uniform continuity of every braid word on the rope's take-metric is
-- the standing construction.
------------------------------------------------------------------------

module VeniPatha_TheCrossingsCompleteReaderProfileFourEquationsAllRefl where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (ℕ ; zero ; suc)

open import Parasparasraya_TheMutualDependenceObjectionChecksWhenTheLeaningIsProductive
  using (Dhārā)
open import CaturamsaBhramana_TheQuarterWaveLivesOnlyOnTheInterdependentPairAndEachSenseCarriesExactlyItsSquare
  using (caturaṃśa)
open import AnantaVeni_TheInfiniteBraidActsOnTheInterdependentStreamAndEveryRelationOfEveryBraidGroupHoldsAtOnce
  using (Rajju ; veṇī∞)
open import AnantaVeniMatra_EveryCrossingIsLocalAndHasOrderExactlyEightAtEveryPositionOfTheEndlessBraid
  using (gāḍha)

open Dhārā

-- At the crossing: the lower reader sees the turned upper strand.
pāra-pāṭha : (i : ℕ) (s : Rajju)
           → gāḍha i (veṇī∞ i s) ≡ caturaṃśa (gāḍha (suc i) s)
pāra-pāṭha zero    s = refl
pāra-pāṭha (suc i) s = pāra-pāṭha i (śeṣam s)

-- And the upper reader sees the untouched lower strand.
avara-pāṭha : (i : ℕ) (s : Rajju)
            → gāḍha (suc i) (veṇī∞ i s) ≡ gāḍha i s
avara-pāṭha zero    s = refl
avara-pāṭha (suc i) s = avara-pāṭha i (śeṣam s)
