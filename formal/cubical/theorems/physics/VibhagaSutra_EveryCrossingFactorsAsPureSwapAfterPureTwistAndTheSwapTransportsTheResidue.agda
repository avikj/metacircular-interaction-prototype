{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- ������-����� � the factorization of the crossing.
--
-- THE FUSION the machine held as ea: the trilaw meets the braid.
-- SesaSamavaya proved the over-symmetries are exactly assembled
-- residue families, and that whatever moves the base is coherence
-- beyond the residue level.  Here the decomposition is exhibited on
-- the endless braid, position by position:
--
--   §2  EVERY CROSSING FACTORS AS PURE SWAP AFTER PURE TWIST:
--       ϵ = swap� ∘ twist��� � the vertical part (one strand's
--       quarter turn, an assembled residue family touching a single
--       fibre) followed by the base motion (the bare transposition).
--
--   §3  AND AS PURE TWIST AFTER PURE SWAP: ϵ = twist� ∘ swap�.
--
--   §4  Hence the EXCHANGE LAW: swap� ∘ twist��� = twist� ∘ swap� �
--       carrying the residue across the base motion relocates it to
--       the transported position.  The swap TRANSPORTS the residue:
--       base motion acts on vertical structure by conjugation, which
--       is the trilaw's generativity clause in dynamic form � the
--       level above does not merely sit on the residues, it carries
--       them.
--
-- Every braid is therefore a word in bare transpositions and
-- single-strand turns, with the entire braiding � everything beyond
-- the symmetric group � residing in HOW THE TWIST RIDES THE SWAP.
-- Coherence is base motion; the phase is cargo; the crossing is the
-- act of carrying.
--
------------------------------------------------------------------------

module VibhagaSutra_EveryCrossingFactorsAsPureSwapAfterPureTwistAndTheSwapTransportsTheResidue where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (ℕ ; zero ; suc)

open import Parasparasraya_TheMutualDependenceObjectionChecksWhenTheLeaningIsProductive
  using (Dhārā)
open import CaturamsaBhramana_TheQuarterWaveLivesOnlyOnTheInterdependentPairAndEachSenseCarriesExactlyItsSquare
  using (caturaṃśa)
open import AnantaVeni_TheInfiniteBraidActsOnTheInterdependentStreamAndEveryRelationOfEveryBraidGroupHoldsAtOnce
  using (Rajju ; saṃyoga ; veṇī∞)

open Dhārā

------------------------------------------------------------------------
-- � � The two pure moves: the bare swap, and the single-strand twist.
------------------------------------------------------------------------

svap∞ : ℕ → Rajju → Rajju
śiras (svap∞ zero s)    = śiras (śeṣam s)
śeṣam (svap∞ zero s)    = saṃyoga (śiras s) (śeṣam (śeṣam s))
śiras (svap∞ (suc i) s) = śiras s
śeṣam (svap∞ (suc i) s) = svap∞ i (śeṣam s)

ghūrṇa∞ : ℕ → Rajju → Rajju
śiras (ghūrṇa∞ zero s)    = caturaṃśa (śiras s)
śeṣam (ghūrṇa∞ zero s)    = śeṣam s
śiras (ghūrṇa∞ (suc j) s) = śiras s
śeṣam (ghūrṇa∞ (suc j) s) = ghūrṇa∞ j (śeṣam s)

------------------------------------------------------------------------
-- � � The crossing is swap-after-twist.
------------------------------------------------------------------------

vibhāga : (i : ℕ) (s : Rajju)
        → veṇī∞ i s ≡ svap∞ i (ghūrṇa∞ (suc i) s)
śiras (vibhāga zero s j) = caturaṃśa (śiras (śeṣam s))
śeṣam (vibhāga zero s j) = saṃyoga (śiras s) (śeṣam (śeṣam s))
śiras (vibhāga (suc i) s j) = śiras s
śeṣam (vibhāga (suc i) s j) = vibhāga i (śeṣam s) j

------------------------------------------------------------------------
-- � � And twist-after-swap.
------------------------------------------------------------------------

vibhāga' : (i : ℕ) (s : Rajju)
         → veṇī∞ i s ≡ ghūrṇa∞ i (svap∞ i s)
śiras (vibhāga' zero s j) = caturaṃśa (śiras (śeṣam s))
śeṣam (vibhāga' zero s j) = saṃyoga (śiras s) (śeṣam (śeṣam s))
śiras (vibhāga' (suc i) s j) = śiras s
śeṣam (vibhāga' (suc i) s j) = vibhāga' i (śeṣam s) j

------------------------------------------------------------------------
-- � � The exchange law: the swap transports the residue.
------------------------------------------------------------------------

vahana : (i : ℕ) (s : Rajju)
       → svap∞ i (ghūrṇa∞ (suc i) s) ≡ ghūrṇa∞ i (svap∞ i s)
vahana i s = sym (vibhāga i s) ∙ vibhāga' i s
