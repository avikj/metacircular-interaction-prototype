{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- The transport word is a geodesic.
--
-- G3 of research/PNP_GEODESIC_REDUCTION_20260916.md, as terms.  Every
-- ingredient is imported, not restated:
--
--   AnantaVeni        the crossing at every position
--   AnantaVeniMatra   the reader, and the constant rope
--   VeniPatha         the lower reader of a crossed rope sees the
--                     turned upper strand -- the head equation's step
--   NirupaSutra       the word action, left to right
--   SthairyaSutra     truncation, and: every word is uniformly
--                     continuous with modulus its own length
--   CaturamsaBhramana the quarter turn has order four
--
-- 1  `bring n = [n-1, ..., 0]`, of length exactly n.
-- 2  The quarter turn is injective because it has order four, hence so
--    is every power of it.
-- 3  THE HEAD EQUATION, by folding the imported step lemma down the
--    word: `bring n` brings cell n to the head with n turns on it.
-- 4  The separating ropes: `plant N a` is the constant rope everywhere
--    except at position N, where it is a.  Two of them agree to every
--    depth at most N and differ at N.
-- 5  THE LOWER BOUND.  A word shorter than n cannot realise the head
--    observation: its light cone stops before cell n, so its head is
--    blind to the very cell the observation would have to read.
--    Quantified over EVERY word of the generator alphabet, not over
--    one implementation.
-- 6  n <= |w| for every realising w, and `bring n` attains it, so the
--    minimum is exactly n.  The transformation is reversible and the
--    distance is positive: semantic invertibility and execution
--    distance are different structures.
------------------------------------------------------------------------

module BringingDepthNToTheHeadCostsExactlyNCrossingsSoTheTransportWordIsAGeodesic where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (ℕ ; zero ; suc ; _+_ ; +-zero ; +-suc)
open import Cubical.Data.Nat.Order using (_≤_ ; _<_ ; pred-≤-pred ; splitℕ-≤ ; ¬-<-zero)
open import Cubical.Data.List using (List ; [] ; _∷_ ; length)
open import Cubical.Data.List.Properties using (cons-inj₁)
open import Cubical.Data.Bool using (Bool ; true ; false ; true≢false)
open import Cubical.Data.Sigma using (_×_ ; _,_ ; fst)
open import Cubical.Data.Sum using (_⊎_ ; inl ; inr)
open import Cubical.Data.Empty as Empty using (⊥)
open import Cubical.Relation.Nullary using (¬_)

open import TheMutualDependenceObjectionChecksWhenTheLeaningIsProductive
  using (Dhārā)
open import TheSuppliedCoherenceIsTheQuarterTurnTheTwistedSwapBraidsByReflAndTheGeneratorHasExactOrderEight
  using (Sūtra)
open import TheQuarterWaveLivesOnlyOnTheInterdependentPairAndEachSenseCarriesExactlyItsSquare
  using (caturaṃśa ; catur-cakra)
open import TheInfiniteBraidActsOnTheInterdependentStreamAndEveryRelationOfEveryBraidGroupHoldsAtOnce
  using (Rajju ; veṇī∞)
open import EveryCrossingIsLocalAndHasOrderExactlyEightAtEveryPositionOfTheEndlessBraid
  using (gāḍha ; sthira)
open import TheCrossingsCompleteReaderProfileFourEquationsAllRefl
  using (pāra-pāṭha)
open import EveryBraidWordIsItsBarePermutationFollowedByAComputedTwistWord
  using (vēṇī-gaṇa)
open import EveryCrossingIsOneLipschitzWithUnitLookaheadSoEveryWordIsUniformlyContinuousWithModulusItsLength
  using (kartana ; śabda-sthairya)

open Dhārā

------------------------------------------------------------------------
-- 1 · The transport word and its exact length.
------------------------------------------------------------------------

bring : ℕ → List ℕ
bring zero    = []
bring (suc n) = n ∷ bring n

bring-length : (n : ℕ) → length (bring n) ≡ n
bring-length zero    = refl
bring-length (suc n) = cong suc (bring-length n)

------------------------------------------------------------------------
-- 2 · Powers of the quarter turn are injective.
------------------------------------------------------------------------

turns : ℕ → Sūtra → Sūtra
turns zero    p = p
turns (suc n) p = turns n (caturaṃśa p)

turn-injective : (p q : Sūtra) → caturaṃśa p ≡ caturaṃśa q → p ≡ q
turn-injective p q h =
    sym (catur-cakra p)
  ∙ cong (λ z → caturaṃśa (caturaṃśa (caturaṃśa z))) h
  ∙ catur-cakra q

turns-injective : (n : ℕ) (p q : Sūtra) → turns n p ≡ turns n q → p ≡ q
turns-injective zero    p q h = h
turns-injective (suc n) p q h = turn-injective p q (turns-injective n _ _ h)

------------------------------------------------------------------------
-- 3 · THE HEAD EQUATION.
--
-- The imported step lemma says one crossing at position i lifts cell
-- i+1 to position i, quarter-turned.  Fold it down the word.
------------------------------------------------------------------------

head-equation : (n : ℕ) (s : Rajju)
              → gāḍha 0 (vēṇī-gaṇa (bring n) s) ≡ turns n (gāḍha n s)
head-equation zero    s = refl
head-equation (suc n) s =
    head-equation n (veṇī∞ n s)
  ∙ cong (turns n) (pāra-pāṭha n s)

------------------------------------------------------------------------
-- 4 · The separating ropes.
------------------------------------------------------------------------

-- the constant rope's cell, used as the blank
blank : Sūtra
blank = true , true

-- blank everywhere, `a` at position N
plant : ℕ → Sūtra → Rajju
śiras (plant zero    a) = a
śeṣam (plant zero    a) = sthira
śiras (plant (suc N) a) = blank
śeṣam (plant (suc N) a) = plant N a

plant-reads : (N : ℕ) (a : Sūtra) → gāḍha N (plant N a) ≡ a
plant-reads zero    a = refl
plant-reads (suc N) a = plant-reads N a

-- agreement to every depth at or below the planted cell
plant-agrees : (m N : ℕ) → m ≤ N → (a b : Sūtra)
             → kartana m (plant N a) ≡ kartana m (plant N b)
plant-agrees zero    N       le a b = refl
plant-agrees (suc m) zero    le a b = Empty.rec (¬-<-zero le)
plant-agrees (suc m) (suc N) le a b =
  cong (blank ∷_) (plant-agrees m N (pred-≤-pred le) a b)

------------------------------------------------------------------------
-- 5 · THE LOWER BOUND, over every word of the generator alphabet.
------------------------------------------------------------------------

RealisesHead : ℕ → List ℕ → Type₀
RealisesHead n w = (s : Rajju) → gāḍha 0 (vēṇī-gaṇa w s) ≡ turns n (gāḍha n s)

private
  plus-one : (m : ℕ) → m + 1 ≡ suc m
  plus-one m = +-suc m zero ∙ cong suc (+-zero m)

  mark-a mark-b : Sūtra
  mark-a = true  , false
  mark-b = false , false

  marks-differ : ¬ (mark-a ≡ mark-b)
  marks-differ p = true≢false (cong fst p)

no-short-word : (n : ℕ) (w : List ℕ) → RealisesHead n w → length w < n → ⊥
no-short-word n w h lt =
  marks-differ (turns-injective n mark-a mark-b turned-marks-agree)
  where
  s t : Rajju
  s = plant n mark-a
  t = plant n mark-b

  -- the word's light cone reaches only depth |w|+1, and n is beyond it
  prefixes-agree : kartana (length w + 1) s ≡ kartana (length w + 1) t
  prefixes-agree =
    subst (λ m → kartana m s ≡ kartana m t) (sym (plus-one (length w)))
      (plant-agrees (suc (length w)) n lt mark-a mark-b)

  -- so the two heads after the word are equal …
  heads-agree : gāḍha 0 (vēṇī-gaṇa w s) ≡ gāḍha 0 (vēṇī-gaṇa w t)
  heads-agree = cons-inj₁ (śabda-sthairya w 1 s t prefixes-agree)

  -- … while the observation says they are the two turned marks.
  turned-marks-agree : turns n mark-a ≡ turns n mark-b
  turned-marks-agree =
      cong (turns n) (sym (plant-reads n mark-a))
    ∙ sym (h s)
    ∙ heads-agree
    ∙ h t
    ∙ cong (turns n) (plant-reads n mark-b)

------------------------------------------------------------------------
-- 6 · THE GEODESIC.  n crossings are necessary and `bring n` supplies
-- them, so the minimum is exactly n.
------------------------------------------------------------------------

head-needs-n : (n : ℕ) (w : List ℕ) → RealisesHead n w → n ≤ length w
head-needs-n n w h with splitℕ-≤ n (length w)
... | inl le = le
... | inr lt = Empty.rec (no-short-word n w h lt)

bring-realises-head : (n : ℕ) → RealisesHead n (bring n)
bring-realises-head n = head-equation n

bring-geodesic : (n : ℕ)
               → RealisesHead n (bring n)
               × (length (bring n) ≡ n)
               × ((w : List ℕ) → RealisesHead n w → n ≤ length w)
bring-geodesic n = bring-realises-head n , bring-length n , head-needs-n n
