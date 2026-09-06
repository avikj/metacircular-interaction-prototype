{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- निरूप-सूत्र — the normal form, assembled.
--
-- THE STANDING CONSTRUCTION, discharged.  Every braid word acts as
-- its bare permutation followed by a twist word computed from the
-- word itself:
--
--   §1  Word-level conjugation: pushing one twist through a whole
--       word relocates it by the word's accumulated transposition
--       (τs, a fold of τ), by list induction over the
--       crossing-conjugation law.
--
--   §2  THE NORMAL FORM: for every word w,
--           act(w) = twists(T w) ∘ swaps(w)
--       where T w is computed by recursion — each crossing deposits
--       its quarter turn, relocated by the remainder of the word.
--       The proof is one list induction: factor the head crossing,
--       push its twist through the tail, recurse.
--
-- With both coordinate groups presented (S∞, ⊕ℤ/4) and this
-- factorization of arbitrary words, the braid's memory is fully
-- accounted: what a word does = where it sends the strands (its
-- symmetric shadow) + what phases it deposits (its twist word), and
-- the second is computed, not merely shown to exist.  The kernel
-- theorem is now a statement about the two coordinates separately.
--
-- SYĀT — THE CLAIM, EXACTLY.  The normal form as an equality of
-- actions at every state; injectivity of the coordinates (the kernel
-- theorem proper) is the standing construction.
------------------------------------------------------------------------

module NirupaSutra_EveryBraidWordIsItsBarePermutationFollowedByAComputedTwistWord where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (ℕ)
open import Cubical.Data.List using (List ; [] ; _∷_ ; _++_)

open import AnantaVeni_TheInfiniteBraidActsOnTheInterdependentStreamAndEveryRelationOfEveryBraidGroupHoldsAtOnce
  using (Rajju ; veṇī∞)
open import VibhagaSutra_EveryCrossingFactorsAsPureSwapAfterPureTwistAndTheSwapTransportsTheResidue
  using (svap∞ ; ghūrṇa∞ ; vibhāga')
open import GhurnaGana_TwistsCommuteTotallyAndFourAlikeCancelSoTwistWordsReduceTowardTheirCountVector
  using (gaṇa)
open import ArdhaSamasa_TheSwapConjugatesTheTwistByTheTranspositionSoTheTwoCoordinatesFormASemidirectWeave
  using (τ)
open import VeniSamvahana_TheCrossingItselfConjugatesTheTwistByTheSameTranspositionSoTwistsPushThroughWholeWords
  using (τ-nivartana ; veṇī-saṃvahana)

------------------------------------------------------------------------
-- १ · Word actions, the accumulated transposition, and word-level
-- conjugation.
------------------------------------------------------------------------

vēṇī-gaṇa svap-gaṇa : List ℕ → Rajju → Rajju
vēṇī-gaṇa []       s = s
vēṇī-gaṇa (i ∷ w) s = vēṇī-gaṇa w (veṇī∞ i s)
svap-gaṇa []       s = s
svap-gaṇa (i ∷ w) s = svap-gaṇa w (svap∞ i s)

τs : List ℕ → ℕ → ℕ
τs []       j = j
τs (i ∷ w) j = τs w (τ i j)

-- One crossing moves a leading twist to its relocated address…
eka-saṃvahana : (i j : ℕ) (s : Rajju)
              → veṇī∞ i (ghūrṇa∞ j s) ≡ ghūrṇa∞ (τ i j) (veṇī∞ i s)
eka-saṃvahana i j s =
  sym (subst (λ m → ghūrṇa∞ (τ i j) (veṇī∞ i s) ≡ veṇī∞ i (ghūrṇa∞ m s))
             (τ-nivartana i j)
             (veṇī-saṃvahana i (τ i j) s))

-- …and a whole word moves it by the accumulated transposition.
śabda-saṃvahana : (w : List ℕ) (j : ℕ) (s : Rajju)
                → vēṇī-gaṇa w (ghūrṇa∞ j s)
                ≡ ghūrṇa∞ (τs w j) (vēṇī-gaṇa w s)
śabda-saṃvahana []       j s = refl
śabda-saṃvahana (i ∷ w) j s =
  cong (vēṇī-gaṇa w) (eka-saṃvahana i j s)
  ∙ śabda-saṃvahana w (τ i j) (veṇī∞ i s)

------------------------------------------------------------------------
-- २ · The computed twist word, and the normal form.
------------------------------------------------------------------------

-- Applying a twist word at the outside is appending at its end.
gaṇa-anta : (t : List ℕ) (j : ℕ) (s : Rajju)
          → gaṇa (t ++ (j ∷ [])) s ≡ ghūrṇa∞ j (gaṇa t s)
gaṇa-anta []       j s = refl
gaṇa-anta (k ∷ t) j s = gaṇa-anta t j (ghūrṇa∞ k s)

-- Each crossing deposits its quarter turn, relocated by the rest.
T : List ℕ → List ℕ
T []       = []
T (i ∷ w) = T w ++ (τs w i ∷ [])

-- THE NORMAL FORM.
nirūpa : (w : List ℕ) (s : Rajju)
       → vēṇī-gaṇa w s ≡ gaṇa (T w) (svap-gaṇa w s)
nirūpa []       s = refl
nirūpa (i ∷ w) s =
  cong (vēṇī-gaṇa w) (vibhāga' i s)
  ∙ śabda-saṃvahana w i (svap∞ i s)
  ∙ cong (ghūrṇa∞ (τs w i)) (nirūpa w (svap∞ i s))
  ∙ sym (gaṇa-anta (T w) (τs w i) (svap-gaṇa w (svap∞ i s)))
