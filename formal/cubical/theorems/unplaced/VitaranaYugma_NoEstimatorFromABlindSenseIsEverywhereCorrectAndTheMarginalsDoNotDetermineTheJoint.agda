{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- वितरण-युग्म — the distribution pair.
--
-- RESOLUTION TOWARD ABSTRACT 18.  That abstract proved two blind
-- readings jointly faithful and scoped away the statistical
-- vocabulary: no probability distribution, no estimator.  Constructed
-- here, and each construction carries a theorem:
--
--   §1  ESTIMATORS EXIST, AND NONE FROM A BLIND SENSE IS EVERYWHERE
--       CORRECT — generically: in any interdependent pair, an
--       estimator reading states off either single sense alone has a
--       named failure point, manufactured from that sense's blind
--       pair.  Instantiated on the light-pair: no estimator from
--       intensity alone recovers the amplitude, failing at ±1.  The
--       identifiability reading's "must name two states" criterion is
--       now a theorem about estimators, not only about observables.
--
--   §2  DISTRIBUTIONS EXIST, AND THE MARGINALS DO NOT DETERMINE THE
--       JOINT.  Weight functions on the plane; the two marginals as
--       pushforwards along the pair's two senses.  The perfectly
--       correlated and perfectly anti-correlated distributions are
--       distinct — separated at a named point — and their marginals
--       agree along BOTH senses, every case by reduction.  Hence no
--       function of the two marginals recovers the joint.
--
-- THE STRUCTURAL POINT, and it is sharp: pointwise, the two senses
-- are jointly faithful — the pair reconstructs every state.  Lifted
-- to distributions, the pair of marginals is NOT jointly faithful —
-- what escapes it is exactly correlation.  Joint faithfulness does
-- not survive distributional lifting, and the new blind spot at the
-- higher level is precisely the information that lives BETWEEN the
-- senses rather than in either — the same lesson as the quarter-wave,
-- in mirror image: structure of the pair, invisible to the members,
-- reappearing at every level with a new name.
--
-- SYĀT — THE CLAIM, EXACTLY.  Weights are naturals, not normalised;
-- no sigma-algebra, no expectation, no independence formalism.  Those
-- are constructions; the distribution, the estimator, and their two
-- theorems are no longer among the absences.
------------------------------------------------------------------------

module VitaranaYugma_NoEstimatorFromABlindSenseIsEverywhereCorrectAndTheMarginalsDoNotDetermineTheJoint where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (ℕ ; _+_ ; snotz)
open import Cubical.Data.Bool using (Bool ; true ; false)
open import Cubical.Data.Sigma using (_×_ ; _,_ ; fst ; snd)
open import Cubical.Data.Int using (ℤ ; pos ; negsuc)
open import Cubical.Data.Empty using (⊥)

open import Parasparasraya_TheMutualDependenceObjectionChecksWhenTheLeaningIsProductive
  using (Parasparāśraya)
open import Jyotiryugma_IntensityIsBlindToPhaseAndPhaseToMagnitudeAndTheAmplitudeIsTheirInterdependentPair
  using (jyotiryugma ; tejas)

private
  variable
    ℓ ℓ' ℓ'' : Level

------------------------------------------------------------------------
-- १ · Estimators, and the generic failure theorem.
------------------------------------------------------------------------

open Parasparāśraya

na-anumātā₁ : {X : Type ℓ} {O₁ : Type ℓ'} {O₂ : Type ℓ''}
              (P : Parasparāśraya X O₁ O₂)
            → (est : O₁ → X) → ((x : X) → est (dṛś₁ P x) ≡ x) → ⊥
na-anumātā₁ P est h =
  fst (snd (snd (andha₁ P)))
      (sym (h (fst (andha₁ P)))
       ∙ cong est (snd (snd (snd (andha₁ P))))
       ∙ h (fst (snd (andha₁ P))))

na-anumātā₂ : {X : Type ℓ} {O₁ : Type ℓ'} {O₂ : Type ℓ''}
              (P : Parasparāśraya X O₁ O₂)
            → (est : O₂ → X) → ((x : X) → est (dṛś₂ P x) ≡ x) → ⊥
na-anumātā₂ P est h =
  fst (snd (snd (andha₂ P)))
      (sym (h (fst (andha₂ P)))
       ∙ cong est (snd (snd (snd (andha₂ P))))
       ∙ h (fst (snd (andha₂ P))))

-- The light instance: no estimator from intensity alone.
na-tejo-anumātā : (est : ℕ → ℤ) → ((x : ℤ) → est (tejas x) ≡ x) → ⊥
na-tejo-anumātā = na-anumātā₁ jyotiryugma

------------------------------------------------------------------------
-- २ · Distributions, marginals, and the correlation blind spot.
------------------------------------------------------------------------

Vitaraṇa : Type₀
Vitaraṇa = Bool × Bool → ℕ

-- Perfectly correlated, and perfectly anti-correlated.
sama-vitaraṇa viṣama-vitaraṇa : Vitaraṇa
sama-vitaraṇa (true  , true)  = 1
sama-vitaraṇa (false , false) = 1
sama-vitaraṇa (true  , false) = 0
sama-vitaraṇa (false , true)  = 0

viṣama-vitaraṇa (true  , false) = 1
viṣama-vitaraṇa (false , true)  = 1
viṣama-vitaraṇa (true  , true)  = 0
viṣama-vitaraṇa (false , false) = 0

-- Marginals: pushforward along each of the pair's senses.
mārgika₁ mārgika₂ : Vitaraṇa → Bool → ℕ
mārgika₁ w b = w (b , true) + w (b , false)
mārgika₂ w b = w (true , b) + w (false , b)

-- Both marginals agree, every case by reduction.
samāna-mārgika₁ : mārgika₁ sama-vitaraṇa ≡ mārgika₁ viṣama-vitaraṇa
samāna-mārgika₁ = funExt λ { true → refl ; false → refl }

samāna-mārgika₂ : mārgika₂ sama-vitaraṇa ≡ mārgika₂ viṣama-vitaraṇa
samāna-mārgika₂ = funExt λ { true → refl ; false → refl }

-- The joints are distinct, at a named point.
bhinna-yugma : sama-vitaraṇa ≡ viṣama-vitaraṇa → ⊥
bhinna-yugma p = snotz (funExt⁻ p (true , true))

-- Hence no function of the two marginals recovers the joint: every
-- reconstruction from marginal data agrees on the two distributions.
mārgika-andha : {A : Type₀}
                (rebuild : (Bool → ℕ) → (Bool → ℕ) → A)
              → rebuild (mārgika₁ sama-vitaraṇa) (mārgika₂ sama-vitaraṇa)
              ≡ rebuild (mārgika₁ viṣama-vitaraṇa) (mārgika₂ viṣama-vitaraṇa)
mārgika-andha rebuild =
  cong₂ rebuild samāna-mārgika₁ samāna-mārgika₂
