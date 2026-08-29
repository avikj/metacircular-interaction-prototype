{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- अनन्त-विनिमय — the endless exchange.
--
-- The other coordinate.  VibhagaSutra split every crossing into base
-- motion and cargo; SuddhaVeni and GhurnaGana computed the cargo's
-- group (a per-strand ℤ/4, totally commuting).  This file computes
-- the base motion's: the bare swaps present the INFINITE SYMMETRIC
-- GROUP on the rope, every defining relation at every position —
--
--   §1  INVOLUTION: every swap squares to the identity (two-level
--       path, leaves definitional) — the coherence-free crossing is
--       order two, exactly the ceiling a single strand permits, which
--       is why base motion alone can never braid.
--
--   §2  THE BRAID RELATION for swaps at every position, and
--
--   §3  THE DISTANT COMMUTATION at every gap — same induction shapes
--       as the braid case, with untwisted leaves.
--
-- With this, both coordinates of the factorization are completely
-- presented: base motion is S∞ (involutive, memoryless of order),
-- cargo is ⊕ℤ/4 (abelian, exact), and the braid B∞ is precisely what
-- their exchange law weaves — the crossing remembers its sequence
-- exactly because the twist rides the swap, and forgets it the
-- moment either coordinate is taken alone.  Statistics live in the
-- carrying, not in the carried nor the carrier.
--
-- SYĀT — THE CLAIM, EXACTLY.  The relations of S∞ on this
-- representation; the semidirect assembly of the two presentations
-- into the kernel theorem for B∞ is the standing construction.
------------------------------------------------------------------------

module AnantaVinimaya_TheBareSwapsPresentTheInfiniteSymmetricGroupOnTheRopeSoBothCoordinatesAreComplete where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (ℕ ; zero ; suc ; _+_)

open import Parasparasraya_TheMutualDependenceObjectionChecksWhenTheLeaningIsProductive
  using (Dhārā)
open import AnantaVeni_TheInfiniteBraidActsOnTheInterdependentStreamAndEveryRelationOfEveryBraidGroupHoldsAtOnce
  using (Rajju ; saṃyoga)
open import VibhagaSutra_EveryCrossingFactorsAsPureSwapAfterPureTwistAndTheSwapTransportsTheResidue
  using (svap∞)

open Dhārā

------------------------------------------------------------------------
-- १ · Involution at every position.
------------------------------------------------------------------------

dvi-svap : (i : ℕ) (s : Rajju) → svap∞ i (svap∞ i s) ≡ s
śiras (dvi-svap zero s j) = śiras s
śiras (śeṣam (dvi-svap zero s j)) = śiras (śeṣam s)
śeṣam (śeṣam (dvi-svap zero s j)) = śeṣam (śeṣam s)
śiras (dvi-svap (suc i) s j) = śiras s
śeṣam (dvi-svap (suc i) s j) = dvi-svap i (śeṣam s) j

------------------------------------------------------------------------
-- २ · The braid relation for bare swaps, at every position.
------------------------------------------------------------------------

svap-mūla : (s : Rajju)
          → svap∞ 0 (svap∞ 1 (svap∞ 0 s)) ≡ svap∞ 1 (svap∞ 0 (svap∞ 1 s))
śiras (svap-mūla s j) = śiras (śeṣam (śeṣam s))
śiras (śeṣam (svap-mūla s j)) = śiras (śeṣam s)
śeṣam (śeṣam (svap-mūla s j)) = saṃyoga (śiras s) (śeṣam (śeṣam (śeṣam s)))

svap-sūtra : (i : ℕ) (s : Rajju)
           → svap∞ i (svap∞ (suc i) (svap∞ i s))
           ≡ svap∞ (suc i) (svap∞ i (svap∞ (suc i) s))
svap-sūtra zero    s = svap-mūla s
śiras (svap-sūtra (suc i) s j) = śiras s
śeṣam (svap-sūtra (suc i) s j) = svap-sūtra i (śeṣam s) j

------------------------------------------------------------------------
-- ३ · The distant commutation, at every gap.
------------------------------------------------------------------------

svap-dūra-mūla : (k : ℕ) (s : Rajju)
               → svap∞ 0 (svap∞ (suc (suc k)) s)
               ≡ svap∞ (suc (suc k)) (svap∞ 0 s)
śiras (svap-dūra-mūla k s j) = śiras (śeṣam s)
śiras (śeṣam (svap-dūra-mūla k s j)) = śiras s
śeṣam (śeṣam (svap-dūra-mūla k s j)) = svap∞ k (śeṣam (śeṣam s))

svap-dūra : (i k : ℕ) (s : Rajju)
          → svap∞ i (svap∞ (suc (suc (i + k))) s)
          ≡ svap∞ (suc (suc (i + k))) (svap∞ i s)
svap-dūra zero    k s = svap-dūra-mūla k s
śiras (svap-dūra (suc i) k s j) = śiras s
śeṣam (svap-dūra (suc i) k s j) = svap-dūra i k (śeṣam s) j
