{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- The transport word is a geodesic.
--
-- G3 of `research/PNP_GEODESIC_REDUCTION_20260916.md`, as terms.  The
-- ingredients were already checked and are imported, not restated:
--
--   AnantaVeni      veṇī∞      the crossing at every position
--   AnantaVeniMatra gāḍha      the reader
--   NirupaSutra     vēṇī-gaṇa  the word action, left to right
--   SthairyaSutra   kartana, śabda-sthairya
--                              every word is uniformly continuous with
--                              modulus its own length
--   VeniPatha       pāra-pāṭha the lower reader of a crossed rope sees
--                              the turned upper strand
--   CaturamsaBhramana catur-cakra
--                              the quarter turn has order four
--
-- §1  `bring n = [n-1, …, 0]`, of length exactly n.
-- §2  ρ = caturaṃśa is injective because it has order four, hence so is
--     every ρⁿ.
-- §3  THE HEAD EQUATION, by folding `pāra-pāṭha` down the word.
--     `bring n` brings cell n to the head, with n quarter turns on it:
--         gāḍha 0 (vēṇī-gaṇa (bring n) s) ≡ cakra n (gāḍha n s).
-- §4  The separating ropes: `sthāna N a` is `sthira` everywhere except
--     at position N, where it is a.  Two of them agree to every depth
--     m ≤ N and differ at N.
-- §5  THE LOWER BOUND.  A word of length < n cannot realise the head
--     observation: śabda-sthairya makes its head blind to cell n, while
--     the observation would have to read it.  Quantified over EVERY
--     word of the generator alphabet, not over one implementation.
-- §6  n ≤ |w| for every realising w, and `bring n` attains it, so the
--     minimum is exactly n.  The transformation is reversible and the
--     distance is positive: semantic invertibility and execution
--     distance are different structures.
------------------------------------------------------------------------

module BringGeodesic_BringingDepthNToTheHeadCostsExactlyNCrossingsSoTheTransportWordIsAGeodesic where

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

open import Parasparasraya_TheMutualDependenceObjectionChecksWhenTheLeaningIsProductive
  using (Dhārā)
open import VeniBandha_TheSuppliedCoherenceIsTheQuarterTurnTheTwistedSwapBraidsByReflAndTheGeneratorHasExactOrderEight
  using (Sūtra)
open import CaturamsaBhramana_TheQuarterWaveLivesOnlyOnTheInterdependentPairAndEachSenseCarriesExactlyItsSquare
  using (caturaṃśa ; catur-cakra)
open import AnantaVeni_TheInfiniteBraidActsOnTheInterdependentStreamAndEveryRelationOfEveryBraidGroupHoldsAtOnce
  using (Rajju ; veṇī∞)
open import AnantaVeniMatra_EveryCrossingIsLocalAndHasOrderExactlyEightAtEveryPositionOfTheEndlessBraid
  using (gāḍha ; sthira)
open import VeniPatha_TheCrossingsCompleteReaderProfileFourEquationsAllRefl
  using (pāra-pāṭha)
open import NirupaSutra_EveryBraidWordIsItsBarePermutationFollowedByAComputedTwistWord
  using (vēṇī-gaṇa)
open import SthairyaSutra_EveryCrossingIsOneLipschitzWithUnitLookaheadSoEveryWordIsUniformlyContinuousWithModulusItsLength
  using (kartana ; śabda-sthairya)

open Dhārā

------------------------------------------------------------------------
-- १ · The transport word and its exact length.
------------------------------------------------------------------------

bring : ℕ → List ℕ
bring zero    = []
bring (suc n) = n ∷ bring n

bring-dīrgha : (n : ℕ) → length (bring n) ≡ n
bring-dīrgha zero    = refl
bring-dīrgha (suc n) = cong suc (bring-dīrgha n)

------------------------------------------------------------------------
-- २ · ρⁿ is injective, because ρ has order four.
------------------------------------------------------------------------

cakra : ℕ → Sūtra → Sūtra
cakra zero    p = p
cakra (suc n) p = cakra n (caturaṃśa p)

caturaṃśa-eka : (p q : Sūtra) → caturaṃśa p ≡ caturaṃśa q → p ≡ q
caturaṃśa-eka p q h =
    sym (catur-cakra p)
  ∙ cong (λ z → caturaṃśa (caturaṃśa (caturaṃśa z))) h
  ∙ catur-cakra q

cakra-eka : (n : ℕ) (p q : Sūtra) → cakra n p ≡ cakra n q → p ≡ q
cakra-eka zero    p q h = h
cakra-eka (suc n) p q h = caturaṃśa-eka p q (cakra-eka n _ _ h)

------------------------------------------------------------------------
-- ३ · THE HEAD EQUATION.
--
-- One crossing at position m lifts cell m+1 to position m, quarter-turned.
------------------------------------------------------------------------

-- `pāra-pāṭha` (VeniPatha) is exactly that: the lower reader of a
-- crossed rope sees the turned upper strand.  Folding it down `bring`
-- brings cell n to the head with n turns on it.
mastaka : (n : ℕ) (s : Rajju)
        → gāḍha 0 (vēṇī-gaṇa (bring n) s) ≡ cakra n (gāḍha n s)
mastaka zero    s = refl
mastaka (suc n) s =
    mastaka n (veṇī∞ n s)
  ∙ cong (cakra n) (pāra-pāṭha n s)

------------------------------------------------------------------------
-- ४ · The separating ropes.
------------------------------------------------------------------------

-- `sthira` (AnantaVeniMatra) is the constant rope; its cell is the blank.
rikta : Sūtra
rikta = true , true

-- blank everywhere, `a` at position N
sthāna : ℕ → Sūtra → Rajju
śiras (sthāna zero    a) = a
śeṣam (sthāna zero    a) = sthira
śiras (sthāna (suc N) a) = rikta
śeṣam (sthāna (suc N) a) = sthāna N a

sthāna-gāḍha : (N : ℕ) (a : Sūtra) → gāḍha N (sthāna N a) ≡ a
sthāna-gāḍha zero    a = refl
sthāna-gāḍha (suc N) a = sthāna-gāḍha N a

-- agreement to every depth at or below the planted cell
sthāna-kartana : (m N : ℕ) → m ≤ N → (a b : Sūtra)
               → kartana m (sthāna N a) ≡ kartana m (sthāna N b)
sthāna-kartana zero    N       le      a b = refl
sthāna-kartana (suc m) zero    le      a b = Empty.rec (¬-<-zero le)
sthāna-kartana (suc m) (suc N) le      a b =
  cong (rikta ∷_) (sthāna-kartana m N (pred-≤-pred le) a b)

------------------------------------------------------------------------
-- ५ · THE LOWER BOUND, over every word of the generator alphabet.
------------------------------------------------------------------------

MastakaKarati : ℕ → List ℕ → Type₀
MastakaKarati n w = (s : Rajju) → gāḍha 0 (vēṇī-gaṇa w s) ≡ cakra n (gāḍha n s)

private
  eka+ : (m : ℕ) → m + 1 ≡ suc m
  eka+ m = +-suc m zero ∙ cong suc (+-zero m)

  varṇa-a varṇa-b : Sūtra
  varṇa-a = true  , false
  varṇa-b = false , false

  varṇa-bheda : ¬ (varṇa-a ≡ varṇa-b)
  varṇa-bheda p = true≢false (cong fst p)

na-laghutara : (n : ℕ) (w : List ℕ) → MastakaKarati n w → length w < n → ⊥
na-laghutara n w h lt = varṇa-bheda (cakra-eka n varṇa-a varṇa-b sama-cakra)
  where
  s t : Rajju
  s = sthāna n varṇa-a
  t = sthāna n varṇa-b

  -- the word's light cone reaches only depth |w|+1, and n is beyond it
  militam : kartana (length w + 1) s ≡ kartana (length w + 1) t
  militam = subst (λ m → kartana m s ≡ kartana m t) (sym (eka+ (length w)))
              (sthāna-kartana (suc (length w)) n lt varṇa-a varṇa-b)

  -- so the two heads after the word are equal …
  mastaka-samam : gāḍha 0 (vēṇī-gaṇa w s) ≡ gāḍha 0 (vēṇī-gaṇa w t)
  mastaka-samam = cons-inj₁ (śabda-sthairya w 1 s t militam)

  -- … while the observation says they are ρⁿa and ρⁿb.
  sama-cakra : cakra n varṇa-a ≡ cakra n varṇa-b
  sama-cakra =
      cong (cakra n) (sym (sthāna-gāḍha n varṇa-a))
    ∙ sym (h s)
    ∙ mastaka-samam
    ∙ h t
    ∙ cong (cakra n) (sthāna-gāḍha n varṇa-b)

------------------------------------------------------------------------
-- ६ · THE GEODESIC.  n crossings are necessary and `bring n` supplies
-- them, so the minimum is exactly n.
------------------------------------------------------------------------

na-hrasva-mastaka : (n : ℕ) (w : List ℕ) → MastakaKarati n w → n ≤ length w
na-hrasva-mastaka n w h with splitℕ-≤ n (length w)
... | inl le = le
... | inr lt = Empty.rec (na-laghutara n w h lt)

bring-mastaka : (n : ℕ) → MastakaKarati n (bring n)
bring-mastaka n = mastaka n

bring-geodesic : (n : ℕ)
               → MastakaKarati n (bring n)
               × (length (bring n) ≡ n)
               × ((w : List ℕ) → MastakaKarati n w → n ≤ length w)
bring-geodesic n = bring-mastaka n , bring-dīrgha n , na-hrasva-mastaka n
