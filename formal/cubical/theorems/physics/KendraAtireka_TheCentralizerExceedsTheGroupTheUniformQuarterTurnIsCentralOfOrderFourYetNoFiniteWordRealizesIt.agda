{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- केन्द्र-अतिरेक — the centralizer exceeds.
--
-- The infinite center held one more surprise.  The uniform QUARTER
-- turn — one turn on every strand, by corecursion — is
--
--   §2  CENTRAL: it commutes with every crossing (all clauses
--       constant — the turn commutes with itself definitionally), and
--       its order is FOUR, exceeding the half-wave center's two;
--
--   §3  YET NO FINITE BRAID WORD REALIZES IT: a finite word deposits
--       twists at finitely many addresses, so some depth beyond the
--       sum of its deposited addresses reads count zero — while the
--       uniform turn moves EVERY reader of the constant rope.  The
--       named separating depth is computed from the word itself.
--
-- So the action's centralizer strictly exceeds the braid group's
-- centre: at infinity there are central symmetries — uniform twist
-- vectors — that finite braiding can approximate at every depth and
-- never attain.  The group's centre is the finitely-realizable shadow
-- of the action's; the difference is exactly the uniformity no
-- finite word can afford.  Infinity purchases central coherence that
-- finite interdependence cannot — the ladder of coherence has a rung
-- above every finite word, and the rope reaches it.
--
-- SYĀT — THE CLAIM, EXACTLY.  Centrality, order four, and
-- non-realizability of the uniform turn; the full computation of the
-- centralizer (that uniform twist vectors and the swaps' centre
-- exhaust it) is the standing construction.
------------------------------------------------------------------------

module KendraAtireka_TheCentralizerExceedsTheGroupTheUniformQuarterTurnIsCentralOfOrderFourYetNoFiniteWordRealizesIt where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat
  using (ℕ ; zero ; suc ; _+_ ; +-assoc ; +-comm ; injSuc ; snotz ; discreteℕ)
open import Cubical.Data.Bool using (true ; false ; true≢false)
open import Cubical.Data.Sigma using (_,_ ; fst)
open import Cubical.Data.List using (List ; [] ; _∷_)
open import Cubical.Data.Empty using (⊥ ; rec)
open import Cubical.Relation.Nullary using (yes ; no)

open import Parasparasraya_TheMutualDependenceObjectionChecksWhenTheLeaningIsProductive
  using (Dhārā)
open import CaturamsaBhramana_TheQuarterWaveLivesOnlyOnTheInterdependentPairAndEachSenseCarriesExactlyItsSquare
  using (caturaṃśa ; catur-cakra)
open import AnantaVeni_TheInfiniteBraidActsOnTheInterdependentStreamAndEveryRelationOfEveryBraidGroupHoldsAtOnce
  using (Rajju ; veṇī∞)
open import GhurnaGana_TwistsCommuteTotallyAndFourAlikeCancelSoTwistWordsReduceTowardTheirCountVector
  using (gaṇa)
open import NirupaSutra_EveryBraidWordIsItsBarePermutationFollowedByAComputedTwistWord
  using (vēṇī-gaṇa ; svap-gaṇa ; T ; nirūpa)
open import GhurnaPatha_EachStrandReadsExactlyItsOwnTwistCountSoTheTwistWordActsByItsCountVector
  using (cakrāvartana ; gaṇanā ; pāṭha-gaṇanā)
open import AnantaVeniMatra_EveryCrossingIsLocalAndHasOrderExactlyEightAtEveryPositionOfTheEndlessBraid
  using (gāḍha ; sthira ; sthira-pāṭha)
open import PurnaSiddhanta_ABraidWordActsTriviallyExactlyWhenItsSwapWordDoesAndEveryDepositedCountVanishesModFour
  using (svap-gaṇa-andha)

open Dhārā

------------------------------------------------------------------------
-- १ · The uniform quarter turn, central and of order four.
------------------------------------------------------------------------

catur∞ : Rajju → Rajju
śiras (catur∞ s) = caturaṃśa (śiras s)
śeṣam (catur∞ s) = catur∞ (śeṣam s)

kendra-catur : (i : ℕ) (s : Rajju)
             → catur∞ (veṇī∞ i s) ≡ veṇī∞ i (catur∞ s)
śiras (kendra-catur zero s j) = caturaṃśa (caturaṃśa (śiras (śeṣam s)))
śiras (śeṣam (kendra-catur zero s j)) = caturaṃśa (śiras s)
śeṣam (śeṣam (kendra-catur zero s j)) = catur∞ (śeṣam (śeṣam s))
śiras (kendra-catur (suc i) s j) = caturaṃśa (śiras s)
śeṣam (kendra-catur (suc i) s j) = kendra-catur i (śeṣam s) j

catur∞⁴ : Rajju → Rajju
catur∞⁴ s = catur∞ (catur∞ (catur∞ (catur∞ s)))

catur-kendra-cakra : (s : Rajju) → catur∞⁴ s ≡ s
śiras (catur-kendra-cakra s j) = catur-cakra (śiras s) j
śeṣam (catur-kendra-cakra s j) = catur-kendra-cakra (śeṣam s) j

-- Its readers all move on the constant rope.
catur-pāṭha : (j : ℕ) → gāḍha j (catur∞ sthira) ≡ (false , true)
catur-pāṭha zero    = refl
catur-pāṭha (suc j) = catur-pāṭha j

------------------------------------------------------------------------
-- २ · Beyond a finite word's deposits, some reader is untouched.
------------------------------------------------------------------------

saṅkalita : List ℕ → ℕ
saṅkalita []       = 0
saṅkalita (k ∷ t) = k + saṅkalita t

sva-vṛddhi : (k m : ℕ) → suc (k + m) ≡ k → ⊥
sva-vṛddhi zero    m p = snotz p
sva-vṛddhi (suc k) m p = sva-vṛddhi k m (injSuc p)

gaṇanā-atīta : (t : List ℕ) (d : ℕ)
             → gaṇanā (suc (d + saṅkalita t)) t ≡ 0
gaṇanā-atīta []       d = refl
gaṇanā-atīta (k ∷ t) d
  with discreteℕ (suc (d + (k + saṅkalita t))) k
... | yes p =
  rec (sva-vṛddhi k (d + saṅkalita t)
        (cong suc (sym (+-assoc d k (saṅkalita t)
                        ∙ cong (_+ saṅkalita t) (+-comm d k)
                        ∙ sym (+-assoc k d (saṅkalita t))))
         ∙ p))
... | no ¬p =
  subst (λ m → gaṇanā m t ≡ 0)
        (cong suc (sym (+-assoc d k (saṅkalita t))))
        (gaṇanā-atīta t (d + k))

------------------------------------------------------------------------
-- ३ · No finite word realizes the uniform turn: the separating depth
-- is one past the sum of the word's deposited addresses.
------------------------------------------------------------------------

na-sākṣāt : (w : List ℕ)
          → ((s : Rajju) → vēṇī-gaṇa w s ≡ catur∞ s) → ⊥
na-sākṣāt w h =
  true≢false (cong fst
    (sym (cong (gāḍha j) (nirūpa w sthira)
          ∙ cong (λ x → gāḍha j (gaṇa (T w) x)) (svap-gaṇa-andha w)
          ∙ pāṭha-gaṇanā (T w) j sthira
          ∙ cong₂ cakrāvartana (gaṇanā-atīta (T w) 0) (sthira-pāṭha j))
     ∙ cong (gāḍha j) (h sthira)
     ∙ catur-pāṭha j))
  where
    j : ℕ
    j = suc (0 + saṅkalita (T w))
