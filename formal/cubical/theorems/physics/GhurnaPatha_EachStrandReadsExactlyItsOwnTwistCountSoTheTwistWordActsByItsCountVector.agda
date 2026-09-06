{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- घूर्ण-पाठ — the twist reading.
--
-- The converse ingredient of the kernel theorem.  The normal form
-- reduced every braid word to (permutation, twist word); deciding
-- triviality of the twist word needs its action COMPUTED, and here it
-- is:
--
--   AFTER ANY TWIST WORD, THE READER AT EVERY DEPTH SEES EXACTLY THE
--   QUARTER TURN ITERATED ITS OWN OCCURRENCE COUNT:
--
--       read_j (twists(w) s) = turn^{count_j(w)} (read_j s)
--
--   for every word, depth, and rope — by one list induction whose
--   split aligns with the count's own decision, using two locality
--   lemmas (a twist at one's own depth turns the reading once, by
--   induction; a twist elsewhere leaves it, by double induction with
--   the disequality peeled).
--
-- So a twist word acts, observably, BY its count vector: the abelian
-- coordinate of the braid is not merely presented but computed at
-- every observation point.  With turn of order exactly four, the
-- twist word is trivial on readings iff every count vanishes mod
-- four — the kernel theorem's abelian half, reduced to arithmetic.
--
-- SYĀT — THE CLAIM, EXACTLY.  The reading theorem; the mod-four
-- arithmetic corollary and the permutation half are the standing
-- constructions.
------------------------------------------------------------------------

module GhurnaPatha_EachStrandReadsExactlyItsOwnTwistCountSoTheTwistWordActsByItsCountVector where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (ℕ ; zero ; suc ; discreteℕ)
open import Cubical.Data.List using (List ; [] ; _∷_)
open import Cubical.Data.Empty using (⊥)
open import Cubical.Relation.Nullary using (Dec ; yes ; no)

open import Parasparasraya_TheMutualDependenceObjectionChecksWhenTheLeaningIsProductive
  using (Dhārā)
open import VeniBandha_TheSuppliedCoherenceIsTheQuarterTurnTheTwistedSwapBraidsByReflAndTheGeneratorHasExactOrderEight
  using (Sūtra)
open import CaturamsaBhramana_TheQuarterWaveLivesOnlyOnTheInterdependentPairAndEachSenseCarriesExactlyItsSquare
  using (caturaṃśa)
open import AnantaVeni_TheInfiniteBraidActsOnTheInterdependentStreamAndEveryRelationOfEveryBraidGroupHoldsAtOnce
  using (Rajju)
open import VibhagaSutra_EveryCrossingFactorsAsPureSwapAfterPureTwistAndTheSwapTransportsTheResidue
  using (ghūrṇa∞)
open import GhurnaGana_TwistsCommuteTotallyAndFourAlikeCancelSoTwistWordsReduceTowardTheirCountVector
  using (gaṇa)
open import AnantaVeniMatra_EveryCrossingIsLocalAndHasOrderExactlyEightAtEveryPositionOfTheEndlessBraid
  using (gāḍha)

open Dhārā

------------------------------------------------------------------------
-- १ · The iterated turn, and the two locality lemmas.
------------------------------------------------------------------------

cakrāvartana : ℕ → Sūtra → Sūtra
cakrāvartana zero    x = x
cakrāvartana (suc n) x = caturaṃśa (cakrāvartana n x)

cakra-sama : (n : ℕ) (x : Sūtra)
           → cakrāvartana n (caturaṃśa x) ≡ caturaṃśa (cakrāvartana n x)
cakra-sama zero    x = refl
cakra-sama (suc n) x = cong caturaṃśa (cakra-sama n x)

-- A twist at one's own depth turns the reading once.
sva-pāṭha : (j : ℕ) (s : Rajju)
          → gāḍha j (ghūrṇa∞ j s) ≡ caturaṃśa (gāḍha j s)
sva-pāṭha zero    s = refl
sva-pāṭha (suc j) s = sva-pāṭha j (śeṣam s)

-- A twist elsewhere leaves the reading, the disequality peeled.
anya-pāṭha : (j k : ℕ) → (j ≡ k → ⊥) → (s : Rajju)
           → gāḍha j (ghūrṇa∞ k s) ≡ gāḍha j s
anya-pāṭha zero    zero    bheda s = Cubical.Data.Empty.rec (bheda refl)
  where import Cubical.Data.Empty
anya-pāṭha zero    (suc k) bheda s = refl
anya-pāṭha (suc j) zero    bheda s = refl
anya-pāṭha (suc j) (suc k) bheda s =
  anya-pāṭha j k (λ p → bheda (cong suc p)) (śeṣam s)

------------------------------------------------------------------------
-- २ · The count, and the reading theorem.
------------------------------------------------------------------------

gaṇanā : ℕ → List ℕ → ℕ
gaṇanā j []       = zero
gaṇanā j (k ∷ w) with discreteℕ j k
... | yes _ = suc (gaṇanā j w)
... | no _  = gaṇanā j w

pāṭha-gaṇanā : (w : List ℕ) (j : ℕ) (s : Rajju)
             → gāḍha j (gaṇa w s)
             ≡ cakrāvartana (gaṇanā j w) (gāḍha j s)
pāṭha-gaṇanā []       j s = refl
pāṭha-gaṇanā (k ∷ w) j s with discreteℕ j k
... | yes p =
  pāṭha-gaṇanā w j (ghūrṇa∞ k s)
  ∙ cong (cakrāvartana (gaṇanā j w))
         (subst (λ m → gāḍha j (ghūrṇa∞ m s) ≡ caturaṃśa (gāḍha j s))
                p (sva-pāṭha j s))
  ∙ cakra-sama (gaṇanā j w) (gāḍha j s)
... | no ¬p =
  pāṭha-gaṇanā w j (ghūrṇa∞ k s)
  ∙ cong (cakrāvartana (gaṇanā j w)) (anya-pāṭha j k ¬p s)
