{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- चतुःशेष-सिद्धान्त — the mod-four theorem.
--
-- THE ABELIAN KERNEL, COMPLETE.  A twist word acts trivially on every
-- rope EXACTLY when every strand's occurrence count vanishes modulo
-- four.  Both directions:
--
--   §3  SUFFICIENCY: counts ≡ 0 (mod 4) force triviality on EVERY
--       rope — the reading theorem sends each reader through its
--       count, the four-step reduction collapses it, and READER
--       EXTENSIONALITY (a corecursive path built from pointwise
--       readings — streams that agree at every depth are equal) lifts
--       pointwise triviality to the rope itself.
--
--   §4  NECESSITY: triviality on ONE rope — the constant one —
--       already forces every count to vanish mod four, by the
--       enumeration of residues and the three named refutations (the
--       quarter, half, and three-quarter turns each move the constant
--       strand).
--
-- One rope suffices to detect; every rope is then clean.  With the
-- normal form (every word = permutation then twist word) this closes
-- the abelian coordinate of the kernel of B∞ entirely; what remains
-- is the permutation coordinate's faithfulness, whose witness rope
-- will need distinct strands rather than the constant one.
--
-- SYĀT — THE CLAIM, EXACTLY.  The biconditional for twist words; the
-- permutation half and their conjunction for full braid words are the
-- standing construction.
------------------------------------------------------------------------

module CatuhSesaSiddhanta_ATwistWordActsTriviallyExactlyWhenEveryCountVanishesModFour where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (ℕ ; zero ; suc)
open import Cubical.Data.Bool using (true ; false ; true≢false)
open import Cubical.Data.List using (List)
open import Cubical.Data.Sigma using (_,_ ; fst ; snd)
open import Cubical.Data.Sum using (_⊎_ ; inl ; inr)
open import Cubical.Data.Empty using (⊥ ; rec)

open import Parasparasraya_TheMutualDependenceObjectionChecksWhenTheLeaningIsProductive
  using (Dhārā)
open import VeniBandha_TheSuppliedCoherenceIsTheQuarterTurnTheTwistedSwapBraidsByReflAndTheGeneratorHasExactOrderEight
  using (Sūtra)
open import CaturamsaBhramana_TheQuarterWaveLivesOnlyOnTheInterdependentPairAndEachSenseCarriesExactlyItsSquare
  using (catur-cakra)
open import AnantaVeni_TheInfiniteBraidActsOnTheInterdependentStreamAndEveryRelationOfEveryBraidGroupHoldsAtOnce
  using (Rajju)
open import GhurnaGana_TwistsCommuteTotallyAndFourAlikeCancelSoTwistWordsReduceTowardTheirCountVector
  using (gaṇa)
open import AnantaVeniMatra_EveryCrossingIsLocalAndHasOrderExactlyEightAtEveryPositionOfTheEndlessBraid
  using (gāḍha ; sthira ; sthira-pāṭha)
open import GhurnaPatha_EachStrandReadsExactlyItsOwnTwistCountSoTheTwistWordActsByItsCountVector
  using (cakrāvartana ; gaṇanā ; pāṭha-gaṇanā)

open Dhārā

------------------------------------------------------------------------
-- १ · The residue mod four, its range, and the four-step reduction.
------------------------------------------------------------------------

catuḥśeṣa : ℕ → ℕ
catuḥśeṣa zero                            = 0
catuḥśeṣa (suc zero)                      = 1
catuḥśeṣa (suc (suc zero))                = 2
catuḥśeṣa (suc (suc (suc zero)))          = 3
catuḥśeṣa (suc (suc (suc (suc n))))       = catuḥśeṣa n

śeṣa-cakra : (n : ℕ) (x : Sūtra)
           → cakrāvartana n x ≡ cakrāvartana (catuḥśeṣa n) x
śeṣa-cakra zero                      x = refl
śeṣa-cakra (suc zero)                x = refl
śeṣa-cakra (suc (suc zero))          x = refl
śeṣa-cakra (suc (suc (suc zero)))    x = refl
śeṣa-cakra (suc (suc (suc (suc n)))) x =
  catur-cakra (cakrāvartana n x) ∙ śeṣa-cakra n x

parimita : (n : ℕ)
         → (catuḥśeṣa n ≡ 0) ⊎ ((catuḥśeṣa n ≡ 1) ⊎ ((catuḥśeṣa n ≡ 2) ⊎ (catuḥśeṣa n ≡ 3)))
parimita zero                      = inl refl
parimita (suc zero)                = inr (inl refl)
parimita (suc (suc zero))          = inr (inr (inl refl))
parimita (suc (suc (suc zero)))    = inr (inr (inr refl))
parimita (suc (suc (suc (suc n)))) = parimita n

------------------------------------------------------------------------
-- २ · Reader extensionality: streams agreeing at every depth are equal.
------------------------------------------------------------------------

pāṭha-sāmya : {s t : Rajju} → ((j : ℕ) → gāḍha j s ≡ gāḍha j t) → s ≡ t
śiras (pāṭha-sāmya h i) = h 0 i
śeṣam (pāṭha-sāmya h i) = pāṭha-sāmya (λ j → h (suc j)) i

------------------------------------------------------------------------
-- ३ · Sufficiency: vanishing counts force triviality on every rope.
------------------------------------------------------------------------

nirvāha : (w : List ℕ)
        → ((j : ℕ) → catuḥśeṣa (gaṇanā j w) ≡ 0)
        → (s : Rajju) → gaṇa w s ≡ s
nirvāha w h s = pāṭha-sāmya λ j →
  pāṭha-gaṇanā w j s
  ∙ śeṣa-cakra (gaṇanā j w) (gāḍha j s)
  ∙ cong (λ m → cakrāvartana m (gāḍha j s)) (h j)

------------------------------------------------------------------------
-- ४ · Necessity: fixing the constant rope forces every count to
-- vanish mod four.
------------------------------------------------------------------------

catuṣka-vibhājya : (n : ℕ)
                 → cakrāvartana n (true , true) ≡ (true , true)
                 → catuḥśeṣa n ≡ 0
catuṣka-vibhājya n fix with parimita n
... | inl e             = e
... | inr (inl e)       =
  rec (true≢false (sym (cong fst
    (sym (subst (λ m → cakrāvartana n (true , true)
                      ≡ cakrāvartana m (true , true)) e
                (śeṣa-cakra n (true , true))) ∙ fix))))
... | inr (inr (inl e)) =
  rec (true≢false (sym (cong fst
    (sym (subst (λ m → cakrāvartana n (true , true)
                      ≡ cakrāvartana m (true , true)) e
                (śeṣa-cakra n (true , true))) ∙ fix))))
... | inr (inr (inr e)) =
  rec (true≢false (sym (cong snd
    (sym (subst (λ m → cakrāvartana n (true , true)
                      ≡ cakrāvartana m (true , true)) e
                (śeṣa-cakra n (true , true))) ∙ fix))))

vipakṣa : (w : List ℕ)
        → gaṇa w sthira ≡ sthira
        → (j : ℕ) → catuḥśeṣa (gaṇanā j w) ≡ 0
vipakṣa w fix j =
  catuṣka-vibhājya (gaṇanā j w)
    (cong (cakrāvartana (gaṇanā j w)) (sym (sthira-pāṭha j))
     ∙ sym (pāṭha-gaṇanā w j sthira)
     ∙ cong (gāḍha j) fix
     ∙ sthira-pāṭha j)
