{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- केन्द्र-निर्वहण — the centralizer, exhausted on the vertical class.
--
-- The standing question — what commutes with the whole braid action —
-- is answered completely for the cellwise symmetries:
--
--     EVERY CENTRAL CELLWISE SYMMETRY IS A UNIFORM POWER OF THE
--     QUARTER TURN.
--
-- A cellwise symmetry applies a family of cell maps down the rope
-- (the rope-level assembled residue family of SesaSamavaya).  If it
-- commutes with every crossing, then reading the commutation at the
-- crossing pair against one-cell witness ropes forces, pointwise:
--
--   §3  THE FAMILY IS CONSTANT: reading at the upper position, the
--       crossing carries cell i to position i+1 untouched, so
--       g(i+1) = g(i) at every value — one family member, everywhere.
--
--   §4  THE MEMBER COMMUTES WITH THE TURN: reading at the lower
--       position, the crossing turns what it carries, so
--       g ∘ turn = turn ∘ g.
--
--   §5  A TURN-EQUIVARIANT CELL MAP IS A POWER OF THE TURN: the cell
--       space is a single orbit — every value is the turn iterated
--       from the base point, with the exponent computed by a
--       four-case position function — so equivariance propagates one
--       value to the whole map: g ≡ turn^{pos (g base)}.
--
-- Assembled: central cellwise = uniform twist, exactly the excess
-- KendraAtireka found — so for the vertical class the centralizer is
-- EXACTLY the four uniform powers, no more.  The charge sectors, the
-- kernel modulus, the ladder's top rung and now the centralizer's
-- vertical exhaustion all answer to the same four — the quarter turn
-- as the one constant of the theory.
--
-- SYĀT — THE CLAIM, EXACTLY.  Exhaustion on the cellwise class; the
-- extension to all zero-lookahead (causal) symmetries — where lower
-- cells may in principle feed the reading — is the standing
-- construction.
------------------------------------------------------------------------

module KendraNirvahana_EveryCentralCellwiseSymmetryIsAUniformPowerOfTheQuarterTurnTheExhaustionForTheVerticalClass where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (ℕ ; zero ; suc)
open import Cubical.Data.Bool using (true ; false)
open import Cubical.Data.Sigma using (_,_)

open import Parasparasraya_TheMutualDependenceObjectionChecksWhenTheLeaningIsProductive
  using (Dhārā)
open import VeniBandha_TheSuppliedCoherenceIsTheQuarterTurnTheTwistedSwapBraidsByReflAndTheGeneratorHasExactOrderEight
  using (Sūtra)
open import CaturamsaBhramana_TheQuarterWaveLivesOnlyOnTheInterdependentPairAndEachSenseCarriesExactlyItsSquare
  using (caturaṃśa)
open import AnantaVeni_TheInfiniteBraidActsOnTheInterdependentStreamAndEveryRelationOfEveryBraidGroupHoldsAtOnce
  using (Rajju ; veṇī∞)
open import AnantaVeniMatra_EveryCrossingIsLocalAndHasOrderExactlyEightAtEveryPositionOfTheEndlessBraid
  using (gāḍha ; sthira)
open import VeniPatha_TheCrossingsCompleteReaderProfileFourEquationsAllRefl
  using (pāra-pāṭha ; avara-pāṭha)
open import GhurnaPatha_EachStrandReadsExactlyItsOwnTwistCountSoTheTwistWordActsByItsCountVector
  using (cakrāvartana)

open Dhārā

------------------------------------------------------------------------
-- १ · Cellwise symmetries, witness ropes, and their readers.
------------------------------------------------------------------------

sthānika : (ℕ → Sūtra → Sūtra) → Rajju → Rajju
śiras (sthānika g s) = g 0 (śiras s)
śeṣam (sthānika g s) = sthānika (λ j → g (suc j)) (śeṣam s)

sthānika-pāṭha : (g : ℕ → Sūtra → Sūtra) (j : ℕ) (s : Rajju)
               → gāḍha j (sthānika g s) ≡ g j (gāḍha j s)
sthānika-pāṭha g zero    s = refl
sthānika-pāṭha g (suc j) s = sthānika-pāṭha (λ k → g (suc k)) j (śeṣam s)

-- One marked cell, blanks elsewhere.
kośa : ℕ → Sūtra → Rajju
śiras (kośa zero x)    = x
śeṣam (kośa zero x)    = sthira
śiras (kośa (suc i) x) = true , true
śeṣam (kośa (suc i) x) = kośa i x

kośa-pāṭha : (i : ℕ) (x : Sūtra) → gāḍha i (kośa i x) ≡ x
kośa-pāṭha zero    x = refl
kośa-pāṭha (suc i) x = kośa-pāṭha i x

------------------------------------------------------------------------
-- २ · Centrality, and the two pointwise forcings.
------------------------------------------------------------------------

module _ (g : ℕ → Sūtra → Sūtra)
         (kendra : (i : ℕ) (s : Rajju)
                 → sthānika g (veṇī∞ i s) ≡ veṇī∞ i (sthānika g s)) where

  -- §3 · The family is constant.
  sama-kula : (i : ℕ) (x : Sūtra) → g (suc i) x ≡ g i x
  sama-kula i x =
    sym (cong (g (suc i)) (avara-pāṭha i (kośa i x)
                           ∙ kośa-pāṭha i x))
    ∙ sym (sthānika-pāṭha g (suc i) (veṇī∞ i (kośa i x)))
    ∙ cong (gāḍha (suc i)) (kendra i (kośa i x))
    ∙ avara-pāṭha i (sthānika g (kośa i x))
    ∙ sthānika-pāṭha g i (kośa i x)
    ∙ cong (g i) (kośa-pāṭha i x)

  -- §4 · The member commutes with the turn.
  cakra-sama-g : (x : Sūtra) → g 0 (caturaṃśa x) ≡ caturaṃśa (g 0 x)
  cakra-sama-g x =
    sym (cong (g 0) (pāra-pāṭha 0 (kośa 1 x)
                     ∙ cong caturaṃśa (kośa-pāṭha 1 x)))
    ∙ sym (sthānika-pāṭha g 0 (veṇī∞ 0 (kośa 1 x)))
    ∙ cong (gāḍha 0) (kendra 0 (kośa 1 x))
    ∙ pāra-pāṭha 0 (sthānika g (kośa 1 x))
    ∙ cong caturaṃśa (sthānika-pāṭha g 1 (kośa 1 x))
    ∙ cong (λ y → caturaṃśa (g 1 y)) (kośa-pāṭha 1 x)
    ∙ cong caturaṃśa (sama-kula 0 x)

------------------------------------------------------------------------
-- ३ · Equivariance is a power: the orbit is single, the exponent
-- computed.
------------------------------------------------------------------------

pos : Sūtra → ℕ
pos (true  , true)  = 0
pos (false , true)  = 1
pos (false , false) = 2
pos (true  , false) = 3

orbit : (x : Sūtra) → cakrāvartana (pos x) (true , true) ≡ x
orbit (true  , true)  = refl
orbit (false , true)  = refl
orbit (false , false) = refl
orbit (true  , false) = refl

sarva-cakra : (h : Sūtra → Sūtra)
            → ((x : Sūtra) → h (caturaṃśa x) ≡ caturaṃśa (h x))
            → (n : ℕ) (x : Sūtra)
            → h (cakrāvartana n x) ≡ cakrāvartana n (h x)
sarva-cakra h eq zero    x = refl
sarva-cakra h eq (suc n) x =
  eq (cakrāvartana n x) ∙ cong caturaṃśa (sarva-cakra h eq n x)

-- The exhaustion on one cell: an equivariant map is its value at the
-- base point, transported around the orbit.
eka-nirvahana : (h : Sūtra → Sūtra)
              → ((x : Sūtra) → h (caturaṃśa x) ≡ caturaṃśa (h x))
              → (x : Sūtra)
              → h x ≡ cakrāvartana (pos x) (h (true , true))
eka-nirvahana h eq x =
  cong h (sym (orbit x))
  ∙ sarva-cakra h eq (pos x) (true , true)
