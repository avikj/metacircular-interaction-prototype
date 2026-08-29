{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- चिह्न-रज्जु — the marked rope.
--
-- THE PERMUTATION HALF'S WITNESSES, and a return of the campaign's
-- signature shape at the detector level:
--
--   §1  THE CONSTANT ROPE IS BLIND TO EVERY SWAP: all strands equal,
--       so base motion is invisible — svapᵢ fixes it, at every
--       position, by a two-level path with definitional leaves.  The
--       rope that detected the twist vector exactly (mod four) cannot
--       see permutations at all.
--
--   §2  THE MARKED ROPE SEES EACH SWAP: mark one strand and the swap
--       moves the mark — the reader at the crossing position changes
--       value, by an induction whose base is refl — so no bare swap
--       acts trivially.
--
-- The two detectors are complementary blindnesses with joint
-- coverage: the constant rope reads only cargo, the marked rope reads
-- motion, and the kernel theorem's two coordinates are separated by
-- exactly this interdependent pair OF ROPES.  The record that opened
-- the campaign — two senses, a named blind pair each, jointly
-- faithful — reappears as the measurement apparatus of its deepest
-- theorem.  What detects everything alone does not exist; what
-- detects everything jointly is two blindnesses facing each other.
--
-- SYĀT — THE CLAIM, EXACTLY.  Blindness and detection as stated; the
-- full conjunction (a braid word trivial iff swap image trivial on
-- marked ropes and counts zero mod four) is the standing assembly.
------------------------------------------------------------------------

module CihnaRajju_TheConstantRopeIsBlindToSwapsTheMarkedRopeSeesEachOneSoTheKernelsDetectorsAreAnInterdependentPair where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (ℕ ; zero ; suc)
open import Cubical.Data.Bool using (true ; false ; true≢false)
open import Cubical.Data.Sigma using (_,_ ; fst)
open import Cubical.Data.Empty using (⊥)

open import Parasparasraya_TheMutualDependenceObjectionChecksWhenTheLeaningIsProductive
  using (Dhārā)
open import AnantaVeni_TheInfiniteBraidActsOnTheInterdependentStreamAndEveryRelationOfEveryBraidGroupHoldsAtOnce
  using (Rajju ; saṃyoga)
open import VibhagaSutra_EveryCrossingFactorsAsPureSwapAfterPureTwistAndTheSwapTransportsTheResidue
  using (svap∞)
open import AnantaVeniMatra_EveryCrossingIsLocalAndHasOrderExactlyEightAtEveryPositionOfTheEndlessBraid
  using (gāḍha ; sthira)

open Dhārā

------------------------------------------------------------------------
-- १ · The constant rope is blind to every swap.
------------------------------------------------------------------------

svap-andha : (i : ℕ) → svap∞ i sthira ≡ sthira
śiras (svap-andha zero k) = true , true
śiras (śeṣam (svap-andha zero k)) = true , true
śeṣam (śeṣam (svap-andha zero k)) = sthira
śiras (svap-andha (suc i) k) = true , true
śeṣam (svap-andha (suc i) k) = svap-andha i k

------------------------------------------------------------------------
-- २ · The marked rope, and detection.
------------------------------------------------------------------------

-- Mark (false , true) at one depth, (true , true) elsewhere.
aṅkita : ℕ → Rajju
śiras (aṅkita zero)    = false , true
śeṣam (aṅkita zero)    = sthira
śiras (aṅkita (suc k)) = true , true
śeṣam (aṅkita (suc k)) = aṅkita k

-- Before the swap, the reader at the crossing sees the blank…
aṅkita-pūrva : (i : ℕ) → gāḍha i (aṅkita (suc i)) ≡ (true , true)
aṅkita-pūrva zero    = refl
aṅkita-pūrva (suc i) = aṅkita-pūrva i

-- …after it, the mark: the swap moved it into view.
cihna-calana : (i : ℕ) → gāḍha i (svap∞ i (aṅkita (suc i))) ≡ (false , true)
cihna-calana zero    = refl
cihna-calana (suc i) = cihna-calana i

-- Hence no bare swap acts trivially.
na-svap-tulya : (i : ℕ) → ((s : Rajju) → svap∞ i s ≡ s) → ⊥
na-svap-tulya i h =
  true≢false
    (cong fst (sym (aṅkita-pūrva i)
              ∙ sym (cong (gāḍha i) (h (aṅkita (suc i))))
              ∙ cihna-calana i))
