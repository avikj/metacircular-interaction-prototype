{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- पूर्ण-अभेद — the complete identification.
--
-- From triviality to identity.  The kernel theorem said which words
-- act trivially; this file upgrades it to which words act THE SAME:
--
--   §1  TWIST WORDS WITH EQUAL COUNTS MOD FOUR ACT IDENTICALLY, on
--       every rope — the reading theorem routes both through their
--       residues, and reader extensionality closes the streams.
--
--   §2  BRAID WORDS WITH EQUAL PERMUTATION ACTIONS AND EQUAL DEPOSITED
--       COUNTS MOD FOUR ACT IDENTICALLY — the normal form on each
--       side, the swap hypothesis in the middle, §1 to finish.
--
-- The memory account is thereby COMPLETE as an upper bound: the pair
-- (permutation action, twist counts mod four) determines the braid's
-- action outright.  With the kernel theorem giving the lower bound —
-- distinct invariants are detected by the two ropes — the braid's
-- observational identity IS the pair of invariants: what a braid is,
-- to every possible observer, is where it sends the strands and what
-- it deposited on them, to the fourth turn.
--
-- SYĀT — THE CLAIM, EXACTLY.  The determination at the level of
-- actions; packaging invariant-distinctness as action-distinctness in
-- full generality (the converse direction word by word) and the
-- weighted second law remain standing.
------------------------------------------------------------------------

module PurnaAbheda_TwoBraidWordsActIdenticallyWhenTheirPermutationsAgreeAndTheirTwistCountsAgreeModFour where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (ℕ)
open import Cubical.Data.List using (List)

open import AnantaVeni_TheInfiniteBraidActsOnTheInterdependentStreamAndEveryRelationOfEveryBraidGroupHoldsAtOnce
  using (Rajju)
open import GhurnaGana_TwistsCommuteTotallyAndFourAlikeCancelSoTwistWordsReduceTowardTheirCountVector
  using (gaṇa)
open import NirupaSutra_EveryBraidWordIsItsBarePermutationFollowedByAComputedTwistWord
  using (vēṇī-gaṇa ; svap-gaṇa ; T ; nirūpa)
open import GhurnaPatha_EachStrandReadsExactlyItsOwnTwistCountSoTheTwistWordActsByItsCountVector
  using (cakrāvartana ; gaṇanā ; pāṭha-gaṇanā)
open import CatuhSesaSiddhanta_ATwistWordActsTriviallyExactlyWhenEveryCountVanishesModFour
  using (catuḥśeṣa ; śeṣa-cakra ; pāṭha-sāmya)
open import AnantaVeniMatra_EveryCrossingIsLocalAndHasOrderExactlyEightAtEveryPositionOfTheEndlessBraid
  using (gāḍha)

------------------------------------------------------------------------
-- १ · Equal counts mod four, equal twist actions.
------------------------------------------------------------------------

samāna-gaṇa : (t t' : List ℕ)
            → ((j : ℕ) → catuḥśeṣa (gaṇanā j t) ≡ catuḥśeṣa (gaṇanā j t'))
            → (x : Rajju) → gaṇa t x ≡ gaṇa t' x
samāna-gaṇa t t' h x = pāṭha-sāmya λ j →
  pāṭha-gaṇanā t j x
  ∙ śeṣa-cakra (gaṇanā j t) (gāḍha j x)
  ∙ cong (λ m → cakrāvartana m (gāḍha j x)) (h j)
  ∙ sym (śeṣa-cakra (gaṇanā j t') (gāḍha j x))
  ∙ sym (pāṭha-gaṇanā t' j x)

------------------------------------------------------------------------
-- २ · Equal invariants, equal braid actions.
------------------------------------------------------------------------

pūrṇa-abheda : (w v : List ℕ)
             → ((s : Rajju) → svap-gaṇa w s ≡ svap-gaṇa v s)
             → ((j : ℕ) → catuḥśeṣa (gaṇanā j (T w)) ≡ catuḥśeṣa (gaṇanā j (T v)))
             → (s : Rajju) → vēṇī-gaṇa w s ≡ vēṇī-gaṇa v s
pūrṇa-abheda w v hs hc s =
  nirūpa w s
  ∙ cong (gaṇa (T w)) (hs s)
  ∙ samāna-gaṇa (T w) (T v) hc (svap-gaṇa v s)
  ∙ sym (nirūpa v s)
