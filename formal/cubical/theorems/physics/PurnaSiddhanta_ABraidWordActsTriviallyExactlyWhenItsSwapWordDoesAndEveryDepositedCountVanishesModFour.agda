{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- पूर्ण-सिद्धान्त — the kernel theorem, whole.
--
-- THE STANDING CONSTRUCTION SINCE THE ENDLESS BRAID WAS BUILT,
-- DISCHARGED.  For every braid word w:
--
--     w ACTS TRIVIALLY ON EVERY ROPE
--         ⟺
--     ITS BARE SWAP WORD ACTS TRIVIALLY, AND EVERY DEPOSITED TWIST
--     COUNT VANISHES MODULO FOUR.
--
-- Both directions, by assembly of the campaign's lemmas:
--
--   NECESSITY.  Triviality at the constant rope — which is blind to
--   the swap word entirely — already pins the twist word (the mod-four
--   theorem's one-rope detection); with the twist word then trivial
--   everywhere, the normal form transfers triviality to the swap word
--   on every rope.
--
--   SUFFICIENCY.  The normal form, the swap hypothesis, and the
--   mod-four sufficiency, composed.
--
-- The braid's memory is now exactly accounted: what a word remembers
-- = its permutation + its twist vector mod four, nothing more and
-- nothing less, and both coordinates are read off by the
-- interdependent pair of detector ropes.  The question the machine
-- has held since AnantaVeni — which words act trivially — is closed.
--
-- SYĀT — THE CLAIM, EXACTLY.  The biconditional at the level of
-- actions on ropes; faithfulness relative to abstract B∞ (that the
-- quotient IS the semidirect product and no smaller) is the next
-- naming of the same structure.
------------------------------------------------------------------------

module PurnaSiddhanta_ABraidWordActsTriviallyExactlyWhenItsSwapWordDoesAndEveryDepositedCountVanishesModFour where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (ℕ)
open import Cubical.Data.List using (List ; [] ; _∷_)
open import Cubical.Data.Sigma using (_×_ ; _,_ ; fst ; snd)

open import AnantaVeni_TheInfiniteBraidActsOnTheInterdependentStreamAndEveryRelationOfEveryBraidGroupHoldsAtOnce
  using (Rajju)
open import VibhagaSutra_EveryCrossingFactorsAsPureSwapAfterPureTwistAndTheSwapTransportsTheResidue
  using (svap∞)
open import GhurnaGana_TwistsCommuteTotallyAndFourAlikeCancelSoTwistWordsReduceTowardTheirCountVector
  using (gaṇa)
open import NirupaSutra_EveryBraidWordIsItsBarePermutationFollowedByAComputedTwistWord
  using (vēṇī-gaṇa ; svap-gaṇa ; T ; nirūpa)
open import GhurnaPatha_EachStrandReadsExactlyItsOwnTwistCountSoTheTwistWordActsByItsCountVector
  using (gaṇanā)
open import CatuhSesaSiddhanta_ATwistWordActsTriviallyExactlyWhenEveryCountVanishesModFour
  using (catuḥśeṣa ; nirvāha ; vipakṣa)
open import AnantaVeniMatra_EveryCrossingIsLocalAndHasOrderExactlyEightAtEveryPositionOfTheEndlessBraid
  using (sthira)
open import CihnaRajju_TheConstantRopeIsBlindToSwapsTheMarkedRopeSeesEachOneSoTheKernelsDetectorsAreAnInterdependentPair
  using (svap-andha)

------------------------------------------------------------------------
-- १ · The constant rope is blind to whole swap words.
------------------------------------------------------------------------

svap-gaṇa-andha : (w : List ℕ) → svap-gaṇa w sthira ≡ sthira
svap-gaṇa-andha []       = refl
svap-gaṇa-andha (i ∷ w) =
  cong (svap-gaṇa w) (svap-andha i) ∙ svap-gaṇa-andha w

------------------------------------------------------------------------
-- २ · Necessity: triviality forces both coordinates.
------------------------------------------------------------------------

module _ (w : List ℕ) (h : (s : Rajju) → vēṇī-gaṇa w s ≡ s) where

  -- The twist word already shows itself at the constant rope.
  gūḍha-sthira : gaṇa (T w) sthira ≡ sthira
  gūḍha-sthira =
    cong (gaṇa (T w)) (sym (svap-gaṇa-andha w))
    ∙ sym (nirūpa w sthira)
    ∙ h sthira

  gūḍha-śūnya : (j : ℕ) → catuḥśeṣa (gaṇanā j (T w)) ≡ 0
  gūḍha-śūnya = vipakṣa (T w) gūḍha-sthira

  -- With the twist word trivial everywhere, the swap word inherits
  -- triviality on every rope through the normal form.
  svap-tulya : (s : Rajju) → svap-gaṇa w s ≡ s
  svap-tulya s =
    sym (nirvāha (T w) gūḍha-śūnya (svap-gaṇa w s))
    ∙ sym (nirūpa w s)
    ∙ h s

------------------------------------------------------------------------
-- ३ · Sufficiency, and the theorem whole.
------------------------------------------------------------------------

paryāpti : (w : List ℕ)
         → ((s : Rajju) → svap-gaṇa w s ≡ s)
         → ((j : ℕ) → catuḥśeṣa (gaṇanā j (T w)) ≡ 0)
         → (s : Rajju) → vēṇī-gaṇa w s ≡ s
paryāpti w hsvap hśūnya s =
  nirūpa w s
  ∙ cong (gaṇa (T w)) (hsvap s)
  ∙ nirvāha (T w) hśūnya s

pūrṇa-siddhānta : (w : List ℕ)
  → ((s : Rajju) → vēṇī-gaṇa w s ≡ s)
  → ((s : Rajju) → svap-gaṇa w s ≡ s)
  × ((j : ℕ) → catuḥśeṣa (gaṇanā j (T w)) ≡ 0)
pūrṇa-siddhānta w h = svap-tulya w h , gūḍha-śūnya w h
