{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- मात्रा-सोपान — the resolution ladder.
--
-- Abstract 17's law said an observable is moved by exactly what it is
-- not invariant under.  The kernel theorem computed the braid's
-- memory.  Their meet is a LADDER: each observable reads the twist
-- count modulo the order of its own blindness —
--
--   · the full strand reading is blind to nothing and reads the count
--     MOD FOUR (the mod-four theorem);
--   · the XOR reading — invariant under the half-wave, moved by the
--     quarter turn — reads the count MOD TWO: proved here, the parity
--     of the twists at each depth, on every rope (the quarter turn
--     flips the xor, four cases by refl; iteration collapses by
--     double-negation; the reading theorem routes the count in);
--   · the constant functional is blind to everything and reads MOD
--     ONE.
--
-- Resolution is invariance, quantified: choosing an observable
-- chooses which residue of the memory survives, and the modulus of
-- the surviving residue is exactly the order of the symmetry the
-- observable accepted as blindness.  The interferometric reading:
-- an intensity-like detector sees fringes at half the period of the
-- field's phase — coarser senses alias the memory at the divisor
-- their invariance dictates.
--
-- SYĀT — THE CLAIM, EXACTLY.  The mod-two reading for the xor
-- observable at every depth and rope; the general statement over all
-- observables and all divisors is the standing construction.
------------------------------------------------------------------------

module MatraSopana_EachObservableReadsTheTwistCountModuloTheOrderOfItsOwnBlindness where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (ℕ ; zero ; suc)
open import Cubical.Data.Bool using (Bool ; true ; false ; not ; notnot ; _⊕_)
open import Cubical.Data.Sigma using (_,_)
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

------------------------------------------------------------------------
-- १ · The xor observable, and how the quarter turn moves it.
------------------------------------------------------------------------

vyatyaya : Sūtra → Bool
vyatyaya (a , b) = a ⊕ b

vyatyaya-cala : (x : Sūtra) → vyatyaya (caturaṃśa x) ≡ not (vyatyaya x)
vyatyaya-cala (true  , true)  = refl
vyatyaya-cala (true  , false) = refl
vyatyaya-cala (false , true)  = refl
vyatyaya-cala (false , false) = refl

------------------------------------------------------------------------
-- २ · Iterated flips, and their collapse mod two.
------------------------------------------------------------------------

notāvartana : ℕ → Bool → Bool
notāvartana zero    b = b
notāvartana (suc n) b = not (notāvartana n b)

dviśeṣa : ℕ → ℕ
dviśeṣa zero          = 0
dviśeṣa (suc zero)    = 1
dviśeṣa (suc (suc n)) = dviśeṣa n

not-śeṣa : (n : ℕ) (b : Bool) → notāvartana n b ≡ notāvartana (dviśeṣa n) b
not-śeṣa zero          b = refl
not-śeṣa (suc zero)    b = refl
not-śeṣa (suc (suc n)) b = notnot (notāvartana n b) ∙ not-śeṣa n b

-- The xor of an iterated quarter turn is an iterated flip.
vyatyaya-cakra : (n : ℕ) (x : Sūtra)
               → vyatyaya (cakrāvartana n x) ≡ notāvartana n (vyatyaya x)
vyatyaya-cakra zero    x = refl
vyatyaya-cakra (suc n) x =
  vyatyaya-cala (cakrāvartana n x) ∙ cong not (vyatyaya-cakra n x)

------------------------------------------------------------------------
-- ३ · The ladder rung: the xor observable reads the count mod two,
-- at every depth, on every rope.
------------------------------------------------------------------------

dvi-pāṭha : (w : List ℕ) (j : ℕ) (s : Rajju)
          → vyatyaya (gāḍha j (gaṇa w s))
          ≡ notāvartana (dviśeṣa (gaṇanā j w)) (vyatyaya (gāḍha j s))
dvi-pāṭha w j s =
  cong vyatyaya (pāṭha-gaṇanā w j s)
  ∙ vyatyaya-cakra (gaṇanā j w) (gāḍha j s)
  ∙ not-śeṣa (gaṇanā j w) (vyatyaya (gāḍha j s))
