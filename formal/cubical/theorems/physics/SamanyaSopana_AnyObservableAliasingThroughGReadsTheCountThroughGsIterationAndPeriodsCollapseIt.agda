{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- सामान्य-सोपान — the ladder, generalized.
--
-- The resolution ladder's rungs were instances.  Here is the ladder
-- itself, and it is the campaign's one factoring law pointed along
-- the twist:
--
--   §1  ANY observable O that aliases through some g — O ∘ turn =
--       g ∘ O, the coalgebra-homomorphism condition of the Nerode
--       collapse, now on the fibre — reads the twist count through
--       g's iteration: after any twist word, at every depth, on
--       every rope,
--
--           O (read_j (twists(w) s)) = g^{count_j(w)} (O (read_j s)),
--
--       by two lines over the reading theorem.
--
--   §2  ANY period of g collapses the reading by that period: if gᵈ
--       is pointwise the identity then counts differing by d read
--       identically — iteration is additive, the period cancels.
--
-- Corollaries by instantiation: the identity observable with g = the
-- quarter turn (period four — the mod-four reading); the xor
-- observable with g = not (period two); any constant observable with
-- g = id (period one).  The full ladder is one theorem: RESOLUTION IS
-- THE ORDER OF THE ALIAS, and every observable sits at the divisor
-- its own factoring dictates.  Factoring kills separation — across
-- instruments, across time, across value, and now across resolution.
--
-- SYĀT — THE CLAIM, EXACTLY.  The reading and collapse laws for every
-- aliasing observable; the converse (an observable that does NOT
-- factor reads more) is the standing construction.
------------------------------------------------------------------------

module SamanyaSopana_AnyObservableAliasingThroughGReadsTheCountThroughGsIterationAndPeriodsCollapseIt where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (ℕ ; zero ; suc ; _+_)
open import Cubical.Data.List using (List)

open import VeniBandha_TheSuppliedCoherenceIsTheQuarterTurnTheTwistedSwapBraidsByReflAndTheGeneratorHasExactOrderEight
  using (Sūtra)
open import CaturamsaBhramana_TheQuarterWaveLivesOnlyOnTheInterdependentPairAndEachSenseCarriesExactlyItsSquare
  using (caturaṃśa)
open import AnantaVeni_TheInfiniteBraidActsOnTheInterdependentStreamAndEveryRelationOfEveryBraidGroupHoldsAtOnce
  using (Rajju)
open import GhurnaGana_TwistsCommuteTotallyAndFourAlikeCancelSoTwistWordsReduceTowardTheirCountVector
  using (gaṇa)
open import AnantaVeniMatra_EveryCrossingIsLocalAndHasOrderExactlyEightAtEveryPositionOfTheEndlessBraid
  using (gāḍha)
open import GhurnaPatha_EachStrandReadsExactlyItsOwnTwistCountSoTheTwistWordActsByItsCountVector
  using (cakrāvartana ; gaṇanā ; pāṭha-gaṇanā)

private
  variable
    ℓ : Level

āvartana : {A : Type ℓ} → (A → A) → ℕ → A → A
āvartana g zero    a = a
āvartana g (suc n) a = g (āvartana g n a)

------------------------------------------------------------------------
-- १ · The general reading law.
------------------------------------------------------------------------

module _ {A : Type ℓ} (O : Sūtra → A) (g : A → A)
         (pravāha : (x : Sūtra) → O (caturaṃśa x) ≡ g (O x)) where

  cakra-pravāha : (n : ℕ) (x : Sūtra)
                → O (cakrāvartana n x) ≡ āvartana g n (O x)
  cakra-pravāha zero    x = refl
  cakra-pravāha (suc n) x =
    pravāha (cakrāvartana n x) ∙ cong g (cakra-pravāha n x)

  sopāna : (w : List ℕ) (j : ℕ) (s : Rajju)
         → O (gāḍha j (gaṇa w s))
         ≡ āvartana g (gaṇanā j w) (O (gāḍha j s))
  sopāna w j s =
    cong O (pāṭha-gaṇanā w j s)
    ∙ cakra-pravāha (gaṇanā j w) (gāḍha j s)

------------------------------------------------------------------------
-- २ · Periods collapse the reading.
------------------------------------------------------------------------

āvartana-yoga : {A : Type ℓ} (g : A → A) (m n : ℕ) (a : A)
              → āvartana g (m + n) a ≡ āvartana g m (āvartana g n a)
āvartana-yoga g zero    n a = refl
āvartana-yoga g (suc m) n a = cong g (āvartana-yoga g m n a)

kāla-lopa : {A : Type ℓ} (g : A → A) (d : ℕ)
          → ((a : A) → āvartana g d a ≡ a)
          → (n : ℕ) (a : A)
          → āvartana g (d + n) a ≡ āvartana g n a
kāla-lopa g d cakra n a =
  āvartana-yoga g d n a ∙ cakra (āvartana g n a)
