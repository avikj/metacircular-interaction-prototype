{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- स्थैर्य-सूत्र — the continuity thread.
--
-- The topology arrives, in take-metric form.  Truncate a rope at
-- depth n (kartana); call two ropes n-close when their truncations
-- agree.  Then:
--
--   §2  EVERY CROSSING IS 1-LIPSCHITZ WITH UNIT LOOKAHEAD: (n+1)-close
--       inputs give n-close outputs, at every position — the crossing
--       reads at most one cell beyond what it writes, exactly as its
--       four-equation reader profile dictates, and the proof is one
--       induction unfolding the truncations with the two cons
--       injections.
--
--   §3  EVERY WORD IS UNIFORMLY CONTINUOUS WITH MODULUS ITS LENGTH:
--       (|w|+n)-close inputs give n-close outputs, by folding §2 down
--       the word.  The modulus is not an existence claim: it is the
--       word's own length, read off its list.
--
-- Causality, quantified: finite braiding transmits information at
-- unit speed down the rope, so depth is time and the word's length
-- is its light cone.  This names the missing hypothesis of the
-- centralizer question — the uniform turn escapes finite words
-- because they are all uniformly continuous with finite lookahead,
-- while centrality plus CONTINUITY is what the exhaustion conjecture
-- should force to uniformity.  The completion of SimaSutra is a
-- completion in exactly this metric.
--
-- SYĀT — THE CLAIM, EXACTLY.  The Lipschitz bound and the word
-- modulus; the metric space proper and the continuous-centralizer
-- exhaustion are the standing constructions.
------------------------------------------------------------------------

module SthairyaSutra_EveryCrossingIsOneLipschitzWithUnitLookaheadSoEveryWordIsUniformlyContinuousWithModulusItsLength where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (ℕ ; zero ; suc ; _+_)
open import Cubical.Data.List using (List ; [] ; _∷_ ; length)
open import Cubical.Data.List.Properties using (cons-inj₁ ; cons-inj₂)

open import Parasparasraya_TheMutualDependenceObjectionChecksWhenTheLeaningIsProductive
  using (Dhārā)
open import VeniBandha_TheSuppliedCoherenceIsTheQuarterTurnTheTwistedSwapBraidsByReflAndTheGeneratorHasExactOrderEight
  using (Sūtra)
open import CaturamsaBhramana_TheQuarterWaveLivesOnlyOnTheInterdependentPairAndEachSenseCarriesExactlyItsSquare
  using (caturaṃśa)
open import AnantaVeni_TheInfiniteBraidActsOnTheInterdependentStreamAndEveryRelationOfEveryBraidGroupHoldsAtOnce
  using (Rajju ; veṇī∞)
open import NirupaSutra_EveryBraidWordIsItsBarePermutationFollowedByAComputedTwistWord
  using (vēṇī-gaṇa)

open Dhārā

------------------------------------------------------------------------
-- १ · The truncation.
------------------------------------------------------------------------

kartana : ℕ → Rajju → List Sūtra
kartana zero    s = []
kartana (suc n) s = śiras s ∷ kartana n (śeṣam s)

------------------------------------------------------------------------
-- २ · The crossing: (n+1)-close in, n-close out.
------------------------------------------------------------------------

-- Truncation equalities weaken: (m+1)-agreement gives m-agreement.
kartana-hrāsa : (m : ℕ) (a b : Rajju)
              → kartana (suc m) a ≡ kartana (suc m) b
              → kartana m a ≡ kartana m b
kartana-hrāsa zero    a b h = refl
kartana-hrāsa (suc m) a b h =
  cong₂ _∷_ (cons-inj₁ h)
            (kartana-hrāsa m (śeṣam a) (śeṣam b) (cons-inj₂ h))

veṇī-sthairya : (i n : ℕ) (s t : Rajju)
              → kartana (suc n) s ≡ kartana (suc n) t
              → kartana n (veṇī∞ i s) ≡ kartana n (veṇī∞ i t)
veṇī-sthairya i       zero    s t h = refl
veṇī-sthairya (suc i) (suc n) s t h =
  cong₂ _∷_ (cons-inj₁ h)
            (veṇī-sthairya i n (śeṣam s) (śeṣam t) (cons-inj₂ h))
veṇī-sthairya zero    (suc n) s t h =
  cong₂ _∷_ (cong caturaṃśa (cons-inj₁ (cons-inj₂ h))) (purva n s t h)
  where
    purva : (n : ℕ) (s t : Rajju)
          → kartana (suc (suc n)) s ≡ kartana (suc (suc n)) t
          → kartana n (śeṣam (veṇī∞ zero s))
          ≡ kartana n (śeṣam (veṇī∞ zero t))
    purva zero     s t h = refl
    purva (suc n') s t h =
      cong₂ _∷_ (cons-inj₁ h)
                (kartana-hrāsa n' (śeṣam (śeṣam s)) (śeṣam (śeṣam t))
                  (cons-inj₂ (cons-inj₂ h)))

------------------------------------------------------------------------
-- ३ · The word: (|w|+n)-close in, n-close out.
------------------------------------------------------------------------

śabda-sthairya : (w : List ℕ) (n : ℕ) (s t : Rajju)
               → kartana (length w + n) s ≡ kartana (length w + n) t
               → kartana n (vēṇī-gaṇa w s) ≡ kartana n (vēṇī-gaṇa w t)
śabda-sthairya []       n s t h = h
śabda-sthairya (i ∷ w) n s t h =
  śabda-sthairya w n (veṇī∞ i s) (veṇī∞ i t)
    (veṇī-sthairya i (length w + n) s t h)
