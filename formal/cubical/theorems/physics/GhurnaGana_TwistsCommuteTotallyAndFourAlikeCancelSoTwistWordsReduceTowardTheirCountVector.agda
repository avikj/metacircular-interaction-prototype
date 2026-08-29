{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- घूर्ण-गण — the twist calculus.
--
-- The kernel conjecture's toolkit.  SuddhaVeni separated every braid
-- word into base motion and twist cargo; deciding triviality of the
-- cargo needs exactly two rewriting moves on twist words, and both
-- are proved here at every position:
--
--   §1  TOTAL COMMUTATION: twists at ANY two depths commute — equal,
--       adjacent, or distant — by one double induction with copattern
--       peel and no comparison function anywhere.  A twist word's
--       action is invariant under adjacent transposition, hence under
--       reordering.
--
--   §2  FOUR ALIKE CANCEL: four consecutive twists of the same strand
--       vanish from any word, by the four-cycle.
--
-- Together: every twist word reduces, move by checked move, toward
-- the normal form its count vector names — sort by commutation,
-- cancel by fours — so the conjecture "trivial iff counts vanish mod
-- four" has its rewriting system, with soundness of each rewrite a
-- theorem.  What remains is termination bookkeeping and the converse
-- (a nonvanishing count acts nontrivially — the per-strand witness of
-- SuddhaVeni §4 is its seed).
--
-- SYĀT — THE CLAIM, EXACTLY.  The two rewrite moves and their
-- soundness; the normal-form theorem assembled from them is the
-- standing construction.
------------------------------------------------------------------------

module GhurnaGana_TwistsCommuteTotallyAndFourAlikeCancelSoTwistWordsReduceTowardTheirCountVector where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (ℕ ; zero ; suc)
open import Cubical.Data.List using (List ; [] ; _∷_)

open import Parasparasraya_TheMutualDependenceObjectionChecksWhenTheLeaningIsProductive
  using (Dhārā)
open import CaturamsaBhramana_TheQuarterWaveLivesOnlyOnTheInterdependentPairAndEachSenseCarriesExactlyItsSquare
  using (caturaṃśa)
open import AnantaVeni_TheInfiniteBraidActsOnTheInterdependentStreamAndEveryRelationOfEveryBraidGroupHoldsAtOnce
  using (Rajju ; veṇī∞ ; saṃyoga)
open import VibhagaSutra_EveryCrossingFactorsAsPureSwapAfterPureTwistAndTheSwapTransportsTheResidue
  using (ghūrṇa∞)
open import SuddhaVeni_TheSquareOfEveryCrossingIsPureResidueSoThePureBraidsActVerticallyAndTheTwistsCommute
  using (catur-ghūrṇa)

open Dhārā

------------------------------------------------------------------------
-- १ · Total commutation, by double induction.
------------------------------------------------------------------------

pūrṇa-vinimaya : (j k : ℕ) (s : Rajju)
               → ghūrṇa∞ j (ghūrṇa∞ k s) ≡ ghūrṇa∞ k (ghūrṇa∞ j s)
pūrṇa-vinimaya zero zero s = refl
śiras (pūrṇa-vinimaya zero (suc k) s i) = caturaṃśa (śiras s)
śeṣam (pūrṇa-vinimaya zero (suc k) s i) = ghūrṇa∞ k (śeṣam s)
śiras (pūrṇa-vinimaya (suc j) zero s i) = caturaṃśa (śiras s)
śeṣam (pūrṇa-vinimaya (suc j) zero s i) = ghūrṇa∞ j (śeṣam s)
śiras (pūrṇa-vinimaya (suc j) (suc k) s i) = śiras s
śeṣam (pūrṇa-vinimaya (suc j) (suc k) s i) = pūrṇa-vinimaya j k (śeṣam s) i

------------------------------------------------------------------------
-- २ · Twist words, and the two sound rewrites.
------------------------------------------------------------------------

gaṇa : List ℕ → Rajju → Rajju
gaṇa []       s = s
gaṇa (j ∷ w) s = gaṇa w (ghūrṇa∞ j s)

-- Adjacent transposition is invisible to the action.
vinimaya-gaṇa : (j k : ℕ) (w : List ℕ) (s : Rajju)
              → gaṇa (j ∷ k ∷ w) s ≡ gaṇa (k ∷ j ∷ w) s
vinimaya-gaṇa j k w s = cong (gaṇa w) (pūrṇa-vinimaya k j s)

-- Four alike at the head vanish.
catuṣka-lopa : (j : ℕ) (w : List ℕ) (s : Rajju)
             → gaṇa (j ∷ j ∷ j ∷ j ∷ w) s ≡ gaṇa w s
catuṣka-lopa j w s = cong (gaṇa w) (catur-ghūrṇa j s)
