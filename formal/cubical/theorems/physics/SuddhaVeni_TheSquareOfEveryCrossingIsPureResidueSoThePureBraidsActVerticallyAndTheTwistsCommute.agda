{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- शुद्ध-वेणी — the pure braid.
--
-- THE KERNEL QUESTION, opened by the factorization.  The pure braid
-- subgroup is what maps trivially to the symmetric group — the words
-- with no net base motion.  Its generators are the squares of the
-- crossings (and their conjugates).  Two theorems locate it:
--
--   §2  THE SQUARE OF EVERY CROSSING IS PURE RESIDUE:
--       σᵢ² = twistᵢ ∘ twistᵢ₊₁, at every position — the double
--       crossing swaps twice (no base motion) and deposits one
--       quarter turn on EACH of the two strands it crossed.  By
--       SesaSamavaya, this is an assembled residue family: the pure
--       braid generators act vertically, inside the fibre level.
--
--   §3  THE TWISTS COMMUTE ACROSS STRANDS, at every pair of distinct
--       depths — so the vertical image of the pure braid generators
--       is abelian: a TWIST VECTOR, one quarter-turn count per
--       strand.  With every single twist of order four
--       (CaturamsaBhramana), the vector lives in a per-strand ℤ/4.
--
-- The kernel conjecture now has its exact shape, and the machine
-- holds it as śeṣa: a word acts trivially iff its symmetric image is
-- trivial and its twist vector vanishes mod four per strand.  §2 and
-- §3 are the two lemmas that make the conjecture well-posed: base
-- motion and twist vector are independent coordinates, the first in
-- the symmetric group, the second in the abelian residue level —
-- coherence and cargo, separated by theorems.
--
-- SYĀT — THE CLAIM, EXACTLY.  The two lemmas; the full kernel
-- computation is the standing construction.
------------------------------------------------------------------------

module SuddhaVeni_TheSquareOfEveryCrossingIsPureResidueSoThePureBraidsActVerticallyAndTheTwistsCommute where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (ℕ ; zero ; suc ; _+_)

open import Parasparasraya_TheMutualDependenceObjectionChecksWhenTheLeaningIsProductive
  using (Dhārā)
open import CaturamsaBhramana_TheQuarterWaveLivesOnlyOnTheInterdependentPairAndEachSenseCarriesExactlyItsSquare
  using (caturaṃśa)
open import AnantaVeni_TheInfiniteBraidActsOnTheInterdependentStreamAndEveryRelationOfEveryBraidGroupHoldsAtOnce
  using (Rajju ; saṃyoga ; veṇī∞)
open import VibhagaSutra_EveryCrossingFactorsAsPureSwapAfterPureTwistAndTheSwapTransportsTheResidue
  using (ghūrṇa∞)

open Dhārā

------------------------------------------------------------------------
-- २ · The square of the crossing is the twist pair.
------------------------------------------------------------------------

śuddha : (i : ℕ) (s : Rajju)
       → veṇī∞ i (veṇī∞ i s) ≡ ghūrṇa∞ i (ghūrṇa∞ (suc i) s)
śiras (śuddha zero s j) = caturaṃśa (śiras s)
śiras (śeṣam (śuddha zero s j)) = caturaṃśa (śiras (śeṣam s))
śeṣam (śeṣam (śuddha zero s j)) = śeṣam (śeṣam s)
śiras (śuddha (suc i) s j) = śiras s
śeṣam (śuddha (suc i) s j) = śuddha i (śeṣam s) j

------------------------------------------------------------------------
-- ३ · Twists at distinct depths commute.
------------------------------------------------------------------------

ghūrṇa-vinimaya : (d : ℕ) (s : Rajju)
                → ghūrṇa∞ zero (ghūrṇa∞ (suc d) s)
                ≡ ghūrṇa∞ (suc d) (ghūrṇa∞ zero s)
śiras (ghūrṇa-vinimaya d s j) = caturaṃśa (śiras s)
śeṣam (ghūrṇa-vinimaya d s j) = ghūrṇa∞ d (śeṣam s)

ghūrṇa-sarva-vinimaya : (j d : ℕ) (s : Rajju)
                      → ghūrṇa∞ j (ghūrṇa∞ (suc (j + d)) s)
                      ≡ ghūrṇa∞ (suc (j + d)) (ghūrṇa∞ j s)
ghūrṇa-sarva-vinimaya zero    d s = ghūrṇa-vinimaya d s
śiras (ghūrṇa-sarva-vinimaya (suc j) d s k) = śiras s
śeṣam (ghūrṇa-sarva-vinimaya (suc j) d s k) =
  ghūrṇa-sarva-vinimaya j d (śeṣam s) k

------------------------------------------------------------------------
-- ४ · Each twist has order exactly four at every depth: the twist
-- vector lives in a per-strand ℤ/4, exactly.
------------------------------------------------------------------------

open import Cubical.Data.Bool using (true ; false ; true≢false)
open import Cubical.Data.Sigma using (_,_ ; fst)
open import Cubical.Data.Empty using (⊥)
open import CaturamsaBhramana_TheQuarterWaveLivesOnlyOnTheInterdependentPairAndEachSenseCarriesExactlyItsSquare
  using (catur-cakra)
open import AnantaVeniMatra_EveryCrossingIsLocalAndHasOrderExactlyEightAtEveryPositionOfTheEndlessBraid
  using (sthira ; gāḍha ; sthira-pāṭha)

ghūrṇa⁴ : ℕ → Rajju → Rajju
ghūrṇa⁴ j s = ghūrṇa∞ j (ghūrṇa∞ j (ghūrṇa∞ j (ghūrṇa∞ j s)))

catur-ghūrṇa : (j : ℕ) (s : Rajju) → ghūrṇa⁴ j s ≡ s
śiras (catur-ghūrṇa zero s k) = catur-cakra (śiras s) k
śeṣam (catur-ghūrṇa zero s k) = śeṣam s
śiras (catur-ghūrṇa (suc j) s k) = śiras s
śeṣam (catur-ghūrṇa (suc j) s k) = catur-ghūrṇa j (śeṣam s) k

-- Lower bound: the double twist moves the constant rope at its depth.
dvi-ghūrṇa-vikāra : (j : ℕ)
                  → gāḍha j (ghūrṇa∞ j (ghūrṇa∞ j sthira)) ≡ (false , false)
dvi-ghūrṇa-vikāra zero    = refl
dvi-ghūrṇa-vikāra (suc j) = dvi-ghūrṇa-vikāra j

na-dvi-ghūrṇa : (j : ℕ) → ((s : Rajju) → ghūrṇa∞ j (ghūrṇa∞ j s) ≡ s) → ⊥
na-dvi-ghūrṇa j h =
  true≢false
    (cong fst (sym (sthira-pāṭha j)
              ∙ sym (cong (gāḍha j) (h sthira))
              ∙ dvi-ghūrṇa-vikāra j))
