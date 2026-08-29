{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- अर्ध-समास — the semidirect weave.
--
-- THE CAPSTONE OF THE COORDINATES.  AnantaVinimaya presented the base
-- motion (S∞); GhurnaGana presented the cargo (⊕ℤ/4, totally
-- commuting).  What binds them into the braid is proved here:
--
--   THE SWAP CONJUGATES THE TWIST BY THE TRANSPOSITION —
--       swapᵢ ∘ twistⱼ = twist_{τᵢ(j)} ∘ swapᵢ
--   for every i and j, where τᵢ is the transposition i ↔ i+1, itself
--   DEFINED BY DOUBLE RECURSION (no comparison, no case split on
--   order), and the law proved by one double induction whose five
--   base shapes are one- and two-level stream paths with definitional
--   leaves.
--
-- This is the semidirect product structure exhibited on the rope: the
-- symmetric group acts on the twist lattice by permuting coordinates,
-- and the exchange law IS the action.  Every braid word now normalises
-- in principle to (swap word, twist word) by pushing twists rightward
-- with this law — base motion transports residue, position by
-- position, which is the trilaw's generativity clause running as a
-- rewriting system.  The braid group is the weave of a memoryless
-- carrier and an abelian cargo, and the weave itself — this
-- conjugation — is where the memory lives.
--
-- SYĀT — THE CLAIM, EXACTLY.  The conjugation law at every pair of
-- positions; the word-level normal form assembled from it, and the
-- kernel theorem it enables, are the standing constructions.
------------------------------------------------------------------------

module ArdhaSamasa_TheSwapConjugatesTheTwistByTheTranspositionSoTheTwoCoordinatesFormASemidirectWeave where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (ℕ ; zero ; suc)

open import Parasparasraya_TheMutualDependenceObjectionChecksWhenTheLeaningIsProductive
  using (Dhārā)
open import CaturamsaBhramana_TheQuarterWaveLivesOnlyOnTheInterdependentPairAndEachSenseCarriesExactlyItsSquare
  using (caturaṃśa)
open import AnantaVeni_TheInfiniteBraidActsOnTheInterdependentStreamAndEveryRelationOfEveryBraidGroupHoldsAtOnce
  using (Rajju ; saṃyoga)
open import VibhagaSutra_EveryCrossingFactorsAsPureSwapAfterPureTwistAndTheSwapTransportsTheResidue
  using (svap∞ ; ghūrṇa∞ ; vahana)

open Dhārā

------------------------------------------------------------------------
-- १ · The transposition, by double recursion.
------------------------------------------------------------------------

τ : ℕ → ℕ → ℕ
τ zero    zero          = suc zero
τ zero    (suc zero)    = zero
τ zero    (suc (suc j)) = suc (suc j)
τ (suc i) zero          = zero
τ (suc i) (suc j)       = suc (τ i j)

------------------------------------------------------------------------
-- २ · The conjugation law.
------------------------------------------------------------------------

saṃvahana : (i j : ℕ) (s : Rajju)
          → svap∞ i (ghūrṇa∞ j s) ≡ ghūrṇa∞ (τ i j) (svap∞ i s)

-- (0,0): the twist below the swap surfaces above it.
śiras (saṃvahana zero zero s k) = śiras (śeṣam s)
śiras (śeṣam (saṃvahana zero zero s k)) = caturaṃśa (śiras s)
śeṣam (śeṣam (saṃvahana zero zero s k)) = śeṣam (śeṣam s)

-- (0,1): the crossing-pair case is the exchange law already proved.
saṃvahana zero (suc zero) s = vahana zero s

-- (0, 2+j): the far twist rides under the near swap untouched.
śiras (saṃvahana zero (suc (suc j)) s k) = śiras (śeṣam s)
śiras (śeṣam (saṃvahana zero (suc (suc j)) s k)) = śiras s
śeṣam (śeṣam (saṃvahana zero (suc (suc j)) s k)) =
  ghūrṇa∞ j (śeṣam (śeṣam s))

-- (1+i, 0): the near twist rides under the far swap untouched.
śiras (saṃvahana (suc i) zero s k) = caturaṃśa (śiras s)
śeṣam (saṃvahana (suc i) zero s k) = svap∞ i (śeṣam s)

-- (1+i, 1+j): peel.
śiras (saṃvahana (suc i) (suc j) s k) = śiras s
śeṣam (saṃvahana (suc i) (suc j) s k) = saṃvahana i j (śeṣam s) k
