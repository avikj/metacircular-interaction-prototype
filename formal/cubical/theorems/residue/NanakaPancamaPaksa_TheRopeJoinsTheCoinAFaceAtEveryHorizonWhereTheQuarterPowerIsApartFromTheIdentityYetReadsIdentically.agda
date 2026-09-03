{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- नाणक, पञ्चम पक्ष — the rope joins the coin.
--
-- Nanaka minted the type: a face = a projection, two carried points,
-- apart upstairs, together downstairs.  The rope lane proved, months
-- apart from the others, that its charge is conserved and read by no
-- bounded observer.  Here that lane is minted into the same coin —
-- and it contributes something no earlier face had: A FACE AT EVERY
-- HORIZON.  The parameter k is the observer's depth, i the crossing's
-- excess beyond it, and for EVERY k and i the record inhabits:
--
--   Carried    the rope's endomaps (braid actions),
--   x          the fourth power of a crossing beyond the horizon —
--              a pure twist, charge-bearing,
--   y          the identity,
--   apart      na-catuṣka∞: the fourth power is NOT the identity
--              (the quarter turn has order exactly four on the pair),
--   proj       reading at depth k,
--   together   adhaḥ-sthira, four times: below the crossing the two
--              actions read identically, pointwise, hence as maps.
--
-- So the writhe sector is a Paksa family: the charge is real (apart),
-- locally unreadable (together), at every depth at once — and the one
-- no-retraction lemma of Nanaka applies uniformly: no reader at any
-- horizon reconstructs both the twist and the identity from what it
-- reads.  The topological memory of the rope and the P/NP gap of the
-- Turing step are, from the coin's side, the same face-shape held at
-- different lanes.
--
-- SYĀT — THE CLAIM, EXACTLY.  The family ropeFace : (k i : ℕ) → Paksa
-- and the no-retraction corollary at every horizon.  NOT claimed:
-- apartness of a SINGLE crossing from the identity (the fourth power
-- is used because na-catuṣka∞ is the checked apartness the lane
-- exports), nor anything about readers above the crossing.
------------------------------------------------------------------------

module NanakaPancamaPaksa_TheRopeJoinsTheCoinAFaceAtEveryHorizonWhereTheQuarterPowerIsApartFromTheIdentityYetReadsIdentically where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (ℕ ; suc ; _+_)
open import Cubical.Data.Empty as Empty using (⊥)

open import VeniBandha_TheSuppliedCoherenceIsTheQuarterTurnTheTwistedSwapBraidsByReflAndTheGeneratorHasExactOrderEight
  using (Sūtra)
open import AnantaVeni_TheInfiniteBraidActsOnTheInterdependentStreamAndEveryRelationOfEveryBraidGroupHoldsAtOnce
  using (Rajju ; veṇī∞)
open import AnantaVeniMatra_EveryCrossingIsLocalAndHasOrderExactlyEightAtEveryPositionOfTheEndlessBraid
  using (gāḍha ; adhaḥ-sthira ; veṇī⁴ ; na-catuṣka∞)
open import Nanaka_OneNoRetractionLemmaFourCheckedFacesTheGapTheRouteTheScheduleAndTheCountAreOneCoin
  using (Paksa ; noRetraction)

open Paksa

------------------------------------------------------------------------
-- १ · Below the crossing, the fourth power reads as the identity.
------------------------------------------------------------------------

adhaḥ-sthira⁴ : (k i : ℕ) (s : Rajju)
  → gāḍha k (veṇī⁴ (suc (k + i)) s) ≡ gāḍha k s
adhaḥ-sthira⁴ k i s =
  adhaḥ-sthira k i (veṇī∞ n (veṇī∞ n (veṇī∞ n s)))
  ∙ adhaḥ-sthira k i (veṇī∞ n (veṇī∞ n s))
  ∙ adhaḥ-sthira k i (veṇī∞ n s)
  ∙ adhaḥ-sthira k i s
  where n = suc (k + i)

------------------------------------------------------------------------
-- २ · The face, at every horizon.
------------------------------------------------------------------------

ropeFace : (k i : ℕ) → Paksa
ropeFace k i .Carried   = Rajju → Rajju
ropeFace k i .Forgotten = Rajju → Sūtra
ropeFace k i .proj F    = λ s → gāḍha k (F s)
ropeFace k i .x         = veṇī⁴ (suc (k + i))
ropeFace k i .y         = λ s → s
ropeFace k i .apart e   = na-catuṣka∞ (suc (k + i)) (λ s → cong (λ F → F s) e)
ropeFace k i .together  = funExt (adhaḥ-sthira⁴ k i)

------------------------------------------------------------------------
-- ३ · And the one lemma applies at every horizon: no reader at depth
--     k reconstructs both the twist and the identity from its reading.
------------------------------------------------------------------------

noReaderReconstructs : (k i : ℕ)
  (r : (Rajju → Sūtra) → (Rajju → Rajju))
  → r (proj (ropeFace k i) (x (ropeFace k i))) ≡ x (ropeFace k i)
  → r (proj (ropeFace k i) (y (ropeFace k i))) ≡ y (ropeFace k i)
  → ⊥
noReaderReconstructs k i = noRetraction (ropeFace k i)
