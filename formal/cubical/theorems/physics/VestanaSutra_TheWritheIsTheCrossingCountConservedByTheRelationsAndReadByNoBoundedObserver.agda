{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- वेष्टन-सूत्र — the writhe.
--
-- A global charge emerges from the normal form:
--
--   §1  THE WRITHE IS THE CROSSING COUNT: every crossing deposits
--       exactly one twist, so the deposited twist word has the length
--       of the braid word — the total phase of a braid IS its number
--       of crossings, by one induction and the length of a
--       concatenation.
--
--   §2  THE RELATIONS CONSERVE IT: both sides of the braid relation
--       have three crossings, both sides of the distant commutation
--       two — each conservation a refl — so the writhe is well-defined
--       on the group, not merely on words.
--
--   §3  NO BOUNDED OBSERVER READS IT: for every depth n there is a
--       single crossing (at position beyond n) that agrees with the
--       identity on every reader below n — the locality theorem,
--       instantiated — while carrying writhe one.  Truncated
--       observation at any depth is compatible with every writhe.
--
-- A conserved global quantity invisible to every local observer: the
-- rope has a charge sector.  The light-cone theorem said information
-- moves at unit speed; the writhe says some information never
-- arrives anywhere in particular — it is carried by the word as a
-- whole, distributed beyond every horizon, exactly the shape of a
-- gauge charge.  Total phase is real, conserved, and everywhere
-- locally unreadable.
--
-- SYĀT — THE CLAIM, EXACTLY.  The count identity, the three
-- conservations, and the depth-n escape witness; the writhe as a
-- group homomorphism to ℤ/4 with its kernel computed is the standing
-- construction.
------------------------------------------------------------------------

module VestanaSutra_TheWritheIsTheCrossingCountConservedByTheRelationsAndReadByNoBoundedObserver where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (ℕ ; zero ; suc ; _+_ ; +-comm)
open import Cubical.Data.List using (List ; [] ; _∷_ ; _++_ ; length)
open import Cubical.Data.List.Properties using (length++)

open import Parasparasraya_TheMutualDependenceObjectionChecksWhenTheLeaningIsProductive
  using (Dhārā)
open import AnantaVeni_TheInfiniteBraidActsOnTheInterdependentStreamAndEveryRelationOfEveryBraidGroupHoldsAtOnce
  using (Rajju ; veṇī∞)
open import NirupaSutra_EveryBraidWordIsItsBarePermutationFollowedByAComputedTwistWord
  using (T)
open import AnantaVeniMatra_EveryCrossingIsLocalAndHasOrderExactlyEightAtEveryPositionOfTheEndlessBraid
  using (gāḍha ; adhaḥ-sthira)

open Dhārā

------------------------------------------------------------------------
-- १ · The writhe is the crossing count.
------------------------------------------------------------------------

veṣṭana : (w : List ℕ) → length (T w) ≡ length w
veṣṭana []       = refl
veṣṭana (i ∷ w) =
  length++ (T w) (_ ∷ [])
  ∙ +-comm (length (T w)) 1
  ∙ cong suc (veṣṭana w)

------------------------------------------------------------------------
-- २ · The relations conserve the count.
------------------------------------------------------------------------

sūtra-sama : (i : ℕ)
           → length (i ∷ suc i ∷ i ∷ [])
           ≡ length (suc i ∷ i ∷ suc i ∷ [])
sūtra-sama i = refl

dūra-sama : (i j : ℕ)
          → length (i ∷ j ∷ []) ≡ length (j ∷ i ∷ [])
dūra-sama i j = refl

------------------------------------------------------------------------
-- ३ · No bounded observer reads it: a far crossing has writhe one and
-- is invisible below its position.
------------------------------------------------------------------------

adṛśya-veṣṭana : (k i : ℕ) (s : Rajju)
               → gāḍha k (veṇī∞ (suc (k + i)) s) ≡ gāḍha k s
adṛśya-veṣṭana = adhaḥ-sthira
