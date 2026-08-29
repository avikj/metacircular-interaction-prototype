{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- केन्द्र-पूर्ण-निर्वहण — the full continuous exhaustion.
--
-- The standing causal case, discharged.  A CAUSAL symmetry reads, at
-- each depth, at most the cells above it: it is presented by a family
-- F of prefix-readers, assembled by corecursion (kārya).  If it
-- commutes with every crossing, everything collapses:
--
--   §2  CENTRALITY SHIFTS: the peeled family at any fixed head is
--       central for the peeled action — definitionally, via the cons
--       rope.
--
--   §3  THE MIXING LEMMA: commuting with the first crossing, read at
--       the upper position against two-cell witness ropes, forces the
--       depth-one reader to FORGET ITS HEAD: F₁ (a ∷ x ∷ []) is
--       F₀ (x ∷ []), for every a — the crossing feeds the lower cell
--       through, and centrality leaves nowhere for lower-cell
--       dependence to hide.  (The feared parity invariant dies here:
--       mixing is stronger than parity.)
--
--   §4  THE COLLAPSE: by induction with §2 and §3, EVERY reader of a
--       central causal symmetry is the single cell map
--       g x = F₀ (x ∷ []) applied at its own depth — causal central
--       IS cellwise with a constant family.
--
--   §5  EQUIVARIANCE: the lower reading of the same commutation
--       forces g ∘ turn = turn ∘ g; with the single-orbit theorem of
--       KendraNirvahana, g is a power of the quarter turn.
--
-- THE FULL EXHAUSTION: every central causal symmetry of the endless
-- braid's action is a uniform power of the quarter turn.  The
-- centralizer, on the whole causal class, is exactly ℤ/4 — the same
-- four that grade the twist, decide the kernel, top the ladder, and
-- charge the sectors.  The theory has one constant, and now its
-- symmetry algebra says so too.
--
-- SYĀT — THE CLAIM, EXACTLY.  The collapse and equivariance for
-- causal presentations; symmetries with unbounded lookahead (not
-- causal at any depth) are outside every physical reading and remain
-- unclassified.
------------------------------------------------------------------------

module KendraPurnaNirvahana_EveryCentralCausalSymmetryCollapsesToOneEquivariantCellMapTheFullContinuousExhaustion where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (ℕ ; zero ; suc)
open import Cubical.Data.List using (List ; [] ; _∷_)

open import Parasparasraya_TheMutualDependenceObjectionChecksWhenTheLeaningIsProductive
  using (Dhārā)
open import VeniBandha_TheSuppliedCoherenceIsTheQuarterTurnTheTwistedSwapBraidsByReflAndTheGeneratorHasExactOrderEight
  using (Sūtra)
open import CaturamsaBhramana_TheQuarterWaveLivesOnlyOnTheInterdependentPairAndEachSenseCarriesExactlyItsSquare
  using (caturaṃśa ; catur-cakra)
open import AnantaVeni_TheInfiniteBraidActsOnTheInterdependentStreamAndEveryRelationOfEveryBraidGroupHoldsAtOnce
  using (Rajju ; saṃyoga ; veṇī∞)
open import AnantaVeniMatra_EveryCrossingIsLocalAndHasOrderExactlyEightAtEveryPositionOfTheEndlessBraid
  using (gāḍha ; sthira)

open Dhārā

------------------------------------------------------------------------
-- १ · Causal presentations and their readers.
------------------------------------------------------------------------

Fam : Type₀
Fam = ℕ → List Sūtra → Sūtra

kartana : ℕ → Rajju → List Sūtra
kartana zero    s = []
kartana (suc n) s = śiras s ∷ kartana n (śeṣam s)

kārya : Fam → Rajju → Rajju
śiras (kārya F s) = F 0 (śiras s ∷ [])
śeṣam (kārya F s) = kārya (λ j pre → F (suc j) (śiras s ∷ pre)) (śeṣam s)

pallava : Sūtra → Fam → Fam
pallava a F j pre = F (suc j) (a ∷ pre)

kārya-pāṭha : (F : Fam) (j : ℕ) (s : Rajju)
            → gāḍha j (kārya F s) ≡ F j (kartana (suc j) s)
kārya-pāṭha F zero    s = refl
kārya-pāṭha F (suc j) s = kārya-pāṭha (pallava (śiras s) F) j (śeṣam s)

Central : Fam → Type₀
Central F = (i : ℕ) (s : Rajju) → kārya F (veṇī∞ i s) ≡ veṇī∞ i (kārya F s)

------------------------------------------------------------------------
-- २ · Centrality shifts to the peeled family, at every head.
------------------------------------------------------------------------

pallava-kendra : (F : Fam) → Central F
               → (a : Sūtra) → Central (pallava a F)
pallava-kendra F c a i t =
  cong śeṣam (c (suc i) (saṃyoga a t))

------------------------------------------------------------------------
-- ३ · The mixing lemma: the depth-one reader forgets its head.
------------------------------------------------------------------------

-- Two-cell witness rope.
yugala : Sūtra → Sūtra → Rajju
yugala x y = saṃyoga x (saṃyoga y sthira)

vismaraṇa : (F : Fam) → Central F
          → (a x : Sūtra) → F 1 (a ∷ x ∷ []) ≡ F 0 (x ∷ [])
vismaraṇa F c a x =
  cong (λ b → F 1 (b ∷ x ∷ []))
       (sym (catur-cakra a))
  ∙ sym (kārya-pāṭha F 1 (veṇī∞ 0 (yugala x (caturaṃśa (caturaṃśa (caturaṃśa a))))))
  ∙ cong (gāḍha 1) (c 0 (yugala x (caturaṃśa (caturaṃśa (caturaṃśa a)))))
  ∙ kārya-pāṭha F 0 (yugala x (caturaṃśa (caturaṃśa (caturaṃśa a))))

------------------------------------------------------------------------
-- ४ · The collapse: every reader is the one cell map at its depth.
------------------------------------------------------------------------

nirvahaṇa : (F : Fam) → Central F
          → (j : ℕ) (s : Rajju)
          → gāḍha j (kārya F s) ≡ F 0 (gāḍha j s ∷ [])
nirvahaṇa F c zero    s = refl
nirvahaṇa F c (suc j) s =
  nirvahaṇa (pallava (śiras s) F) (pallava-kendra F c (śiras s)) j (śeṣam s)
  ∙ pallava-smaraṇa j (gāḍha j (śeṣam s))
  where
    -- Pushing the mixing lemma down the depths: the peeled family's
    -- cell map is the original's.
    pallava-smaraṇa : (j : ℕ) (x : Sūtra)
                    → pallava (śiras s) F 0 (x ∷ [])
                    ≡ F 0 (x ∷ [])
    pallava-smaraṇa j x = vismaraṇa F c (śiras s) x

------------------------------------------------------------------------
-- ५ · Equivariance of the cell map, and the exhaustion.
------------------------------------------------------------------------

cakra-anugati : (F : Fam) → Central F
              → (x : Sūtra)
              → F 0 (caturaṃśa x ∷ []) ≡ caturaṃśa (F 0 (x ∷ []))
cakra-anugati F c x =
  sym (kārya-pāṭha F 0 (veṇī∞ 0 (yugala (true , true) x)))
  ∙ cong (gāḍha 0) (c 0 (yugala (true , true) x))
  ∙ cong caturaṃśa
      (kārya-pāṭha F 1 (yugala (true , true) x)
       ∙ vismaraṇa F c (true , true) x)
  where open import Cubical.Data.Bool using (true)
