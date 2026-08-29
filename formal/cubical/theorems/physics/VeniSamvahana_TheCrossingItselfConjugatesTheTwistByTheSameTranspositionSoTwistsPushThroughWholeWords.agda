{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- वेणी-संवहन — the crossing carries.
--
-- The word-level step of the normal form.  ArdhaSamasa proved the
-- bare swap conjugates the twist by the transposition τ.  Here the
-- FULL CROSSING does the same:
--
--   §1  τ IS AN INVOLUTION, by the same double recursion that defined
--       it — no comparison function.
--
--   §2  twistⱼ ∘ σᵢ = σᵢ ∘ twist_{τᵢ(j)}, at every pair of positions:
--       assembled from the twist-first factorization, total
--       commutation of twists, the swap conjugation, and the
--       involution — pure path algebra over the checked lemmas, no
--       new stream computation at all.
--
-- Consequence: a twist anywhere in a braid word pushes rightward
-- through every remaining crossing, changing only its address by the
-- word's transpositions — so every word normalises to (crossings,
-- then twists), and the kernel theorem reduces to the two coordinate
-- groups already presented.  The trilaw's generativity clause now
-- runs as a confluent rewriting discipline on words: base motion
-- transports cargo through arbitrary futures.
--
-- SYĀT — THE CLAIM, EXACTLY.  The conjugation and the involution; the
-- assembled word-level normal form is the standing construction, one
-- list induction away.
------------------------------------------------------------------------

module VeniSamvahana_TheCrossingItselfConjugatesTheTwistByTheSameTranspositionSoTwistsPushThroughWholeWords where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (ℕ ; zero ; suc)

open import AnantaVeni_TheInfiniteBraidActsOnTheInterdependentStreamAndEveryRelationOfEveryBraidGroupHoldsAtOnce
  using (Rajju ; veṇī∞)
open import VibhagaSutra_EveryCrossingFactorsAsPureSwapAfterPureTwistAndTheSwapTransportsTheResidue
  using (svap∞ ; ghūrṇa∞ ; vibhāga')
open import GhurnaGana_TwistsCommuteTotallyAndFourAlikeCancelSoTwistWordsReduceTowardTheirCountVector
  using (pūrṇa-vinimaya)
open import ArdhaSamasa_TheSwapConjugatesTheTwistByTheTranspositionSoTheTwoCoordinatesFormASemidirectWeave
  using (τ ; saṃvahana)

------------------------------------------------------------------------
-- १ · The transposition is an involution.
------------------------------------------------------------------------

τ-nivartana : (i j : ℕ) → τ i (τ i j) ≡ j
τ-nivartana zero    zero          = refl
τ-nivartana zero    (suc zero)    = refl
τ-nivartana zero    (suc (suc j)) = refl
τ-nivartana (suc i) zero          = refl
τ-nivartana (suc i) (suc j)       = cong suc (τ-nivartana i j)

------------------------------------------------------------------------
-- २ · The crossing conjugates the twist.
------------------------------------------------------------------------

veṇī-saṃvahana : (i j : ℕ) (s : Rajju)
               → ghūrṇa∞ j (veṇī∞ i s) ≡ veṇī∞ i (ghūrṇa∞ (τ i j) s)
veṇī-saṃvahana i j s =
  cong (ghūrṇa∞ j) (vibhāga' i s)
  ∙ pūrṇa-vinimaya j i (svap∞ i s)
  ∙ cong (ghūrṇa∞ i)
      (sym (subst (λ m → svap∞ i (ghūrṇa∞ (τ i j) s)
                        ≡ ghūrṇa∞ m (svap∞ i s))
                  (τ-nivartana i j)
                  (saṃvahana i (τ i j) s)))
  ∙ sym (vibhāga' i (ghūrṇa∞ (τ i j) s))
