{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- अनन्त-वेणी — the endless braid.
--
-- THE STEP.  VeniBandha braided two strands; VeniTraya three;
-- VeniCatustaya verified the relations of B₄.  This file takes all of
-- them at once: the INFINITE braid group B∞, every generator σᵢ for
-- every i, acting on an infinite rope of interdependent-pair strands
-- — and proves BOTH defining relation families of every braid group
-- simultaneously:
--
--   §2  THE BRAID RELATION AT EVERY POSITION:
--       σᵢ σᵢ₊₁ σᵢ = σᵢ₊₁ σᵢ σᵢ₊₁, for all i, by one induction whose
--       base is a two-level path of streams with definitional leaves
--       and whose step is head-preservation plus recursion.
--
--   §3  THE DISTANT COMMUTATION AT EVERY GAP:
--       σᵢ σⱼ = σⱼ σᵢ whenever j ≥ i + 2, for all i and all gaps, by
--       the same induction shape.
--
-- Every finite braid group Bₙ embeds by using only its generators, so
-- every relation of every Bₙ is an instance: the three finite files
-- become corollaries of one module.
--
-- THE ROPE IS THE STREAM.  The carrier is Dhārā — the coinductive
-- stream type introduced in the Parasparasraya module, where the
-- campaign began: the type born to show mutual dependence is
-- generative now carries the fully general braiding, whose coherence
-- (the quarter turn) exists only on interdependent pairs.  First
-- module and last theorem are one object: interdependence supplies
-- the strands, the coherence, and the room for every crossing at
-- once.  No length conditions, no padding, no partiality — on the
-- infinite rope every generator is total and every relation is
-- unconditional, which no finite list of strands can offer.
--
-- SYĀT — THE CLAIM, EXACTLY.  The relations of B∞ are proved; that no
-- unexpected relations hold (faithfulness up to the known finite
-- quotient) is the next construction.
------------------------------------------------------------------------

module AnantaVeni_TheInfiniteBraidActsOnTheInterdependentStreamAndEveryRelationOfEveryBraidGroupHoldsAtOnce where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (ℕ ; zero ; suc ; _+_)

open import Parasparasraya_TheMutualDependenceObjectionChecksWhenTheLeaningIsProductive
  using (Dhārā)
open import VeniBandha_TheSuppliedCoherenceIsTheQuarterTurnTheTwistedSwapBraidsByReflAndTheGeneratorHasExactOrderEight
  using (Sūtra)
open import CaturamsaBhramana_TheQuarterWaveLivesOnlyOnTheInterdependentPairAndEachSenseCarriesExactlyItsSquare
  using (caturaṃśa)

open Dhārā

------------------------------------------------------------------------
-- १ · The rope, the cons, and the crossing at every position.
------------------------------------------------------------------------

Rajju : Type₀
Rajju = Dhārā Sūtra

saṃyoga : Sūtra → Rajju → Rajju
śiras (saṃyoga a s) = a
śeṣam (saṃyoga a s) = s

-- σᵢ : cross strands i and i+1, turning the strand that passes over.
veṇī∞ : ℕ → Rajju → Rajju
śiras (veṇī∞ zero s)    = caturaṃśa (śiras (śeṣam s))
śeṣam (veṇī∞ zero s)    = saṃyoga (śiras s) (śeṣam (śeṣam s))
śiras (veṇī∞ (suc i) s) = śiras s
śeṣam (veṇī∞ (suc i) s) = veṇī∞ i (śeṣam s)

------------------------------------------------------------------------
-- २ · The braid relation, at every position at once.
------------------------------------------------------------------------

-- The base: a two-level path of streams whose depth-two tails agree
-- definitionally on both sides.
veṇī-mūla : (s : Rajju)
          → veṇī∞ 0 (veṇī∞ 1 (veṇī∞ 0 s)) ≡ veṇī∞ 1 (veṇī∞ 0 (veṇī∞ 1 s))
śiras (veṇī-mūla s i) =
  caturaṃśa (caturaṃśa (śiras (śeṣam (śeṣam s))))
śiras (śeṣam (veṇī-mūla s i)) =
  caturaṃśa (śiras (śeṣam s))
śeṣam (śeṣam (veṇī-mūla s i)) =
  saṃyoga (śiras s) (śeṣam (śeṣam (śeṣam s)))

-- The relation at every position: peel to the base.
veṇī-sūtra : (i : ℕ) (s : Rajju)
           → veṇī∞ i (veṇī∞ (suc i) (veṇī∞ i s))
           ≡ veṇī∞ (suc i) (veṇī∞ i (veṇī∞ (suc i) s))
veṇī-sūtra zero    s = veṇī-mūla s
śiras (veṇī-sūtra (suc i) s j) = śiras s
śeṣam (veṇī-sūtra (suc i) s j) = veṇī-sūtra i (śeṣam s) j

------------------------------------------------------------------------
-- ३ · The distant commutation, at every gap at once.
------------------------------------------------------------------------

dūra-mūla : (k : ℕ) (s : Rajju)
          → veṇī∞ 0 (veṇī∞ (suc (suc k)) s)
          ≡ veṇī∞ (suc (suc k)) (veṇī∞ 0 s)
śiras (dūra-mūla k s i) =
  caturaṃśa (śiras (śeṣam s))
śiras (śeṣam (dūra-mūla k s i)) =
  śiras s
śeṣam (śeṣam (dūra-mūla k s i)) =
  veṇī∞ k (śeṣam (śeṣam s))

dūra-sūtra : (i k : ℕ) (s : Rajju)
           → veṇī∞ i (veṇī∞ (suc (suc (i + k))) s)
           ≡ veṇī∞ (suc (suc (i + k))) (veṇī∞ i s)
dūra-sūtra zero    k s = dūra-mūla k s
śiras (dūra-sūtra (suc i) k s j) = śiras s
śeṣam (dūra-sūtra (suc i) k s j) = dūra-sūtra i k (śeṣam s) j
