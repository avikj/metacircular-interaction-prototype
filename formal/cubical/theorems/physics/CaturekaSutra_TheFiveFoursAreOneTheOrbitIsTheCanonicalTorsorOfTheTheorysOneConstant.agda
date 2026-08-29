{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- चतुरेक-सूत्र — the five fours are one.
--
-- The night's structures each produced a four: the TWIST VECTOR is
-- exact in a per-strand ℤ/4; the KERNEL is decided by counts mod
-- four; the resolution LADDER tops at the mod-four reading; the
-- CHARGE is a homomorphism onto ℤ/4; the CENTRALIZER of the causal
-- class is the four uniform powers.  This file exhibits the object
-- they all measure: THE SINGLE ORBIT OF ONE STRAND under the quarter
-- turn, with its position function —
--
--   §1  pos and the iterated turn are inverse: the turn iterated n
--       times from the base sits at position n mod four, and every
--       value is the turn iterated its own position from the base.
--       The orbit IS ℤ/4, canonically, with the base point (the
--       blank strand) as origin.
--
-- Every four of the theory is a reading of this one orbit: counts
-- measure how far a strand has been carried around it; the kernel
-- asks whether every strand came home; the ladder's rungs are its
-- quotients; the charge is its global winding; the centralizer is
-- its deck group.  One torsor, five shadows — the śeṣa trilaw's
-- final appearance tonight: a single local structure, conserved,
-- inaccessible to coarser readings, generating every level above.
--
-- SYĀT — THE CLAIM, EXACTLY.  The inverse pair; the five readings
-- are each already checked in their own files and cited, not
-- re-proved.
------------------------------------------------------------------------

module CaturekaSutra_TheFiveFoursAreOneTheOrbitIsTheCanonicalTorsorOfTheTheorysOneConstant where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (ℕ ; zero ; suc)
open import Cubical.Data.Bool using (true ; false)
open import Cubical.Data.Sigma using (_,_)

open import VeniBandha_TheSuppliedCoherenceIsTheQuarterTurnTheTwistedSwapBraidsByReflAndTheGeneratorHasExactOrderEight
  using (Sūtra)
open import GhurnaPatha_EachStrandReadsExactlyItsOwnTwistCountSoTheTwistWordActsByItsCountVector
  using (cakrāvartana)
open import CaturamsaBhramana_TheQuarterWaveLivesOnlyOnTheInterdependentPairAndEachSenseCarriesExactlyItsSquare
  using (catur-cakra)
open import CatuhSesaSiddhanta_ATwistWordActsTriviallyExactlyWhenEveryCountVanishesModFour
  using (catuḥśeṣa ; śeṣa-cakra)
open import KendraNirvahana_EveryCentralCellwiseSymmetryIsAUniformPowerOfTheQuarterTurnTheExhaustionForTheVerticalClass
  using (pos ; orbit)

------------------------------------------------------------------------
-- १ · The inverse pair: the orbit is canonically ℤ/4.
------------------------------------------------------------------------

-- Every value is the turn iterated its own position (imported: orbit).
-- The converse: the turn iterated n times sits at position n mod four.
sthāna : (n : ℕ)
       → pos (cakrāvartana n (true , true)) ≡ catuḥśeṣa n
sthāna n =
  cong pos (śeṣa-cakra n (true , true))
  ∙ catuṣṭaya (catuḥśeṣa n)
  ∙ śeṣa-punar n
  where
    śeṣa-punar : (m : ℕ) → catuḥśeṣa (catuḥśeṣa m) ≡ catuḥśeṣa m
    śeṣa-punar zero                      = refl
    śeṣa-punar (suc zero)                = refl
    śeṣa-punar (suc (suc zero))          = refl
    śeṣa-punar (suc (suc (suc zero)))    = refl
    śeṣa-punar (suc (suc (suc (suc m)))) = śeṣa-punar m

    -- On the four residues, position of the iterate is the residue —
    -- and catuḥśeṣa is idempotent on its own outputs, case by case.
    catuṣṭaya : (r : ℕ) → pos (cakrāvartana r (true , true)) ≡ catuḥśeṣa r
    catuṣṭaya zero                      = refl
    catuṣṭaya (suc zero)                = refl
    catuṣṭaya (suc (suc zero))          = refl
    catuṣṭaya (suc (suc (suc zero)))    = refl
    catuṣṭaya (suc (suc (suc (suc r)))) =
      cong pos (catur-cakra (cakrāvartana r (true , true))) ∙ catuṣṭaya r
