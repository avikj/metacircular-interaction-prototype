{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- सीमा-सूत्र — the limit thread.
--
-- KendraAtireka proved the uniform quarter turn central and finitely
-- unrealizable.  This file proves the other half of its strangeness:
-- it is the POINTWISE LIMIT of finite braiding, with the approximants
-- named —
--
--   §2  THE COUNT LEMMAS: the descending word [n, n−1, …, 0] twists
--       each depth ≤ its top exactly once (hit) and each depth beyond
--       exactly never (miss), by double inductions with no order
--       relation imported — the inequalities ride inside the
--       induction shapes.
--
--   §3  CONVERGENCE: for every depth n and every margin d, the word
--       [d+n, …, 0] agrees with the uniform turn at reader n, on
--       every rope.  Not "some word exists": THE word is written
--       down, and deeper readers are reached by longer words.
--
-- With na-sākṣāt this completes the picture: the uniform turn is
-- approximated by finite words at every single reader and attained
-- at none — a strict pointwise limit outside the image.  The braid
-- group is not closed in its own action; the rope carries the
-- completion, and the completion's new points are exactly the
-- uniform coherences.  Finiteness converges; only infinity arrives.
--
-- SYĀT — THE CLAIM, EXACTLY.  Pointwise convergence with named
-- approximants and the strictness; the topology proper (the inverse
-- limit structure on the action's closure) is the standing
-- construction.
------------------------------------------------------------------------

module SimaSutra_TheUniformTurnIsThePointwiseLimitOfNamedFiniteWordsAndLiesOutsideTheirImage where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat
  using (ℕ ; zero ; suc ; _+_ ; +-suc ; injSuc ; snotz ; discreteℕ)
open import Cubical.Data.List using (List ; [] ; _∷_)
open import Cubical.Data.Empty using (⊥ ; rec)
open import Cubical.Relation.Nullary using (yes ; no)

open import Parasparasraya_TheMutualDependenceObjectionChecksWhenTheLeaningIsProductive
  using (Dhārā)
open import CaturamsaBhramana_TheQuarterWaveLivesOnlyOnTheInterdependentPairAndEachSenseCarriesExactlyItsSquare
  using (caturaṃśa)
open import AnantaVeni_TheInfiniteBraidActsOnTheInterdependentStreamAndEveryRelationOfEveryBraidGroupHoldsAtOnce
  using (Rajju)
open import GhurnaGana_TwistsCommuteTotallyAndFourAlikeCancelSoTwistWordsReduceTowardTheirCountVector
  using (gaṇa)
open import AnantaVeniMatra_EveryCrossingIsLocalAndHasOrderExactlyEightAtEveryPositionOfTheEndlessBraid
  using (gāḍha)
open import GhurnaPatha_EachStrandReadsExactlyItsOwnTwistCountSoTheTwistWordActsByItsCountVector
  using (cakrāvartana ; gaṇanā ; pāṭha-gaṇanā)
open import KendraAtireka_TheCentralizerExceedsTheGroupTheUniformQuarterTurnIsCentralOfOrderFourYetNoFiniteWordRealizesIt
  using (catur∞)

open Dhārā

------------------------------------------------------------------------
-- १ · The descending words, and the two arithmetic refutations.
------------------------------------------------------------------------

avaroha : ℕ → List ℕ
avaroha zero    = zero ∷ []
avaroha (suc n) = suc n ∷ avaroha n

adhika-vāma : (d m : ℕ) → suc (d + m) ≡ m → ⊥
adhika-vāma d zero    p = snotz p
adhika-vāma d (suc m) p =
  adhika-vāma d m (sym (+-suc d m) ∙ injSuc p)

------------------------------------------------------------------------
-- २ · The count lemmas: miss beyond the top, hit up to it.
------------------------------------------------------------------------

miss : (d m : ℕ) → gaṇanā (suc (d + m)) (avaroha m) ≡ 0
miss d zero with discreteℕ (suc (d + zero)) zero
... | yes p = rec (snotz p)
... | no ¬p = refl
miss d (suc m) with discreteℕ (suc (d + suc m)) (suc m)
... | yes p = rec (adhika-vāma d (suc m) p)
... | no ¬p =
  subst (λ k → gaṇanā k (avaroha m) ≡ 0)
        (sym (cong suc (+-suc d m)))
        (miss (suc d) m)

hit : (d n : ℕ) → gaṇanā n (avaroha (d + n)) ≡ 1
hit zero zero with discreteℕ zero zero
... | yes _ = refl
... | no ¬p = rec (¬p refl)
hit zero (suc n) with discreteℕ (suc n) (suc n)
... | yes _ = cong suc (miss 0 n)
... | no ¬p = rec (¬p refl)
hit (suc d) n with discreteℕ n (suc (d + n))
... | yes p = rec (adhika-vāma d n (sym p))
... | no ¬p = hit d n

------------------------------------------------------------------------
-- ३ · Convergence at every reader, with the approximant named.
------------------------------------------------------------------------

catur-gāḍha : (n : ℕ) (s : Rajju)
            → gāḍha n (catur∞ s) ≡ caturaṃśa (gāḍha n s)
catur-gāḍha zero    s = refl
catur-gāḍha (suc n) s = catur-gāḍha n (śeṣam s)

prati-sīmā : (d n : ℕ) (s : Rajju)
           → gāḍha n (gaṇa (avaroha (d + n)) s) ≡ gāḍha n (catur∞ s)
prati-sīmā d n s =
  pāṭha-gaṇanā (avaroha (d + n)) n s
  ∙ cong (λ k → cakrāvartana k (gāḍha n s)) (hit d n)
  ∙ sym (catur-gāḍha n s)
