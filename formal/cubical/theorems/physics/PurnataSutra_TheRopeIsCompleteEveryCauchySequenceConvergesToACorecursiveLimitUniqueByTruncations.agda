{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- पूर्णता-सूत्र — the completeness thread.
--
-- The take-metric's fundamental theorem: THE ROPE IS COMPLETE.
--
--   §1  A Cauchy sequence of ropes — each approximant agreeing with
--       the next to its own depth — has a LIMIT, constructed by
--       corecursion: the head from the first approximant that has
--       one, the tail as the limit of the shifted tails.
--
--   §2  THE LIMIT THEOREM: the limit agrees with the n-th approximant
--       to depth n, for every n — heads stabilize along the Cauchy
--       chain, tails recurse into the shifted sequence.
--
--   §3  UNIQUENESS: ropes agreeing on all truncations are equal, by a
--       corecursive path — so the limit is THE limit, not a choice.
--
-- With SthairyaSutra this closes the metric story: the braid words
-- act uniformly continuously on a complete space, their pointwise
-- limits exist in it (SimaSutra's uniform turn is the exemplar), and
-- the completion in which finiteness converges is not adjoined but
-- ALREADY THERE — the coinductive rope was its own completion from
-- the first module of the campaign.  Coinduction is completeness;
-- the guarded circle that answered parasparāśraya is the same
-- structure that holds every limit.
--
-- SYĀT — THE CLAIM, EXACTLY.  Existence, the limit theorem, and
-- uniqueness; the closure of the braid image in this metric, computed
-- as a subgroup, is the standing construction.
------------------------------------------------------------------------

module PurnataSutra_TheRopeIsCompleteEveryCauchySequenceConvergesToACorecursiveLimitUniqueByTruncations where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (ℕ ; zero ; suc)
open import Cubical.Data.List using (List ; [] ; _∷_)
open import Cubical.Data.List.Properties using (cons-inj₁ ; cons-inj₂)

open import Parasparasraya_TheMutualDependenceObjectionChecksWhenTheLeaningIsProductive
  using (Dhārā)
open import AnantaVeni_TheInfiniteBraidActsOnTheInterdependentStreamAndEveryRelationOfEveryBraidGroupHoldsAtOnce
  using (Rajju)
open import SthairyaSutra_EveryCrossingIsOneLipschitzWithUnitLookaheadSoEveryWordIsUniformlyContinuousWithModulusItsLength
  using (kartana)

open Dhārā

------------------------------------------------------------------------
-- १ · Cauchy sequences, and the corecursive limit.
------------------------------------------------------------------------

Cauchy : (ℕ → Rajju) → Type₀
Cauchy r = (n : ℕ) → kartana n (r n) ≡ kartana n (r (suc n))

sīmā : (ℕ → Rajju) → Rajju
śiras (sīmā r) = śiras (r 1)
śeṣam (sīmā r) = sīmā (λ n → śeṣam (r (suc n)))

------------------------------------------------------------------------
-- २ · The limit theorem.
------------------------------------------------------------------------

-- Heads stabilize along the chain.
śiras-śreṇī : (r : ℕ → Rajju) → Cauchy r
            → (m : ℕ) → śiras (r 1) ≡ śiras (r (suc m))
śiras-śreṇī r c zero    = refl
śiras-śreṇī r c (suc m) =
  śiras-śreṇī r c m ∙ cons-inj₁ (c (suc m))

-- The shifted tails are Cauchy.
śeṣa-cauchy : (r : ℕ → Rajju) → Cauchy r
            → Cauchy (λ n → śeṣam (r (suc n)))
śeṣa-cauchy r c n = cons-inj₂ (c (suc n))

prāpti : (r : ℕ → Rajju) → Cauchy r
       → (n : ℕ) → kartana n (sīmā r) ≡ kartana n (r n)
prāpti r c zero    = refl
prāpti r c (suc n) =
  cong₂ _∷_ (śiras-śreṇī r c n)
            (prāpti (λ k → śeṣam (r (suc k))) (śeṣa-cauchy r c) n)

------------------------------------------------------------------------
-- ३ · Uniqueness: all-truncation agreement is equality.
------------------------------------------------------------------------

kartana-sāmya : {x y : Rajju}
              → ((n : ℕ) → kartana n x ≡ kartana n y)
              → x ≡ y
śiras (kartana-sāmya h i) = cons-inj₁ (h 1) i
śeṣam (kartana-sāmya h i) =
  kartana-sāmya (λ n → cons-inj₂ (h (suc n))) i
