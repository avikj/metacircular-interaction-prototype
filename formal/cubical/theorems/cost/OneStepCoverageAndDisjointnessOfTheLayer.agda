{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- OneStepCoverageAndDisjointnessOfTheLayer
--
-- Two of the three output properties of the Pareto stratification:
--
--   (1) COVERAGE: every member of the archive appears in some layer of
--   `strata`.  (2) DISJOINTNESS: the layers share no member.
--
-- Both hold AT ONE STEP — layer versus remainder — and one step is what
-- the iterated statement needs, since `strata` peels a layer and
-- recurses on exactly the complement proved here.
--
-- ────────────────────────────────────────────────────────────────────
-- WHAT IS PROVED
--
--   memberOfFilterSatisfies / memberOfFilterOutFails
--                     what membership in each half tells you, proved
--                     directly by induction rather than through an
--                     `All` — this corpus now has THREE `All`s in three
--                     modules and routing through any of them would
--                     have meant a fourth
--   memberSplits      COVERAGE at one step: every member of `xs` is in
--                     `filterDec … xs` or in `filterOut … xs`
--   noMemberInBoth    DISJOINTNESS at one step: no member is in both
--   layerCovers / layerIsDisjoint
--                     the same at the Pareto stratum and its remainder
--
-- Both are stated for an ARBITRARY decidable predicate and instantiated
-- once, which is why they are three lines each: nothing about Pareto
-- maximality is used, only that the two filters are complementary.
--
-- ────────────────────────────────────────────────────────────────────
-- NO NOVELTY.  A decidable filter and its complement partition a list;
-- the length version of this was already proved on this line
-- (`partitionLength`), and this is its membership counterpart.
------------------------------------------------------------------------

module OneStepCoverageAndDisjointnessOfTheLayer where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (ℕ)
open import Cubical.Data.List using (List ; [] ; _∷_)
open import Cubical.Data.Sum using (_⊎_ ; inl ; inr)
open import Cubical.Data.Empty as ⊥ using (⊥)
open import Cubical.Relation.Nullary using (¬_ ; Dec ; yes ; no)

open import KramaAstiNasti_TheFourthCornerCannotLiveOverAnEnumerableDecidableInstanceSet
  using (Any)
open import TheParetoStratumIsDecidableAndTheFilterIsExact
  using (filterDec ; IsParetoMaximal ; decIsParetoMaximal ; stratum)
open import TheRemainderIsStrictlyShorterSoTheStratificationHasAMeasure
  using (filterOut ; remainder)

private
  variable
    A : Type

Mem : {A : Type} → A → List A → Type
Mem a xs = Any (λ y → y ≡ a) xs

------------------------------------------------------------------------
-- 1.  What membership in each half tells you
------------------------------------------------------------------------

memberOfFilterSatisfies :
  (P : A → Type) (d : (a : A) → Dec (P a)) (xs : List A) (a : A)
  → Mem a (filterDec P d xs) → P a
memberOfFilterSatisfies P d []       a e = ⊥.rec e
memberOfFilterSatisfies P d (x ∷ xs) a m with d x
memberOfFilterSatisfies P d (x ∷ xs) a (inl q) | yes p = subst P q p
memberOfFilterSatisfies P d (x ∷ xs) a (inr r) | yes _ =
  memberOfFilterSatisfies P d xs a r
memberOfFilterSatisfies P d (x ∷ xs) a m       | no  _ =
  memberOfFilterSatisfies P d xs a m

memberOfFilterOutFails :
  (P : A → Type) (d : (a : A) → Dec (P a)) (xs : List A) (a : A)
  → Mem a (filterOut P d xs) → ¬ P a
memberOfFilterOutFails P d []       a e = ⊥.rec e
memberOfFilterOutFails P d (x ∷ xs) a m with d x
memberOfFilterOutFails P d (x ∷ xs) a m       | yes _ =
  memberOfFilterOutFails P d xs a m
memberOfFilterOutFails P d (x ∷ xs) a (inl q) | no ¬p =
  λ pa → ¬p (subst P (sym q) pa)
memberOfFilterOutFails P d (x ∷ xs) a (inr r) | no _ =
  memberOfFilterOutFails P d xs a r

------------------------------------------------------------------------
-- 2.  Coverage and disjointness, for any decidable predicate
------------------------------------------------------------------------

memberSplits :
  (P : A → Type) (d : (a : A) → Dec (P a)) (xs : List A) (a : A)
  → Mem a xs → Mem a (filterDec P d xs) ⊎ Mem a (filterOut P d xs)
memberSplits P d []       a e = ⊥.rec e
memberSplits P d (x ∷ xs) a m with d x
memberSplits P d (x ∷ xs) a (inl q) | yes _ = inl (inl q)
memberSplits P d (x ∷ xs) a (inr r) | yes _ with memberSplits P d xs a r
... | inl k = inl (inr k)
... | inr k = inr k
memberSplits P d (x ∷ xs) a (inl q) | no  _ = inr (inl q)
memberSplits P d (x ∷ xs) a (inr r) | no  _ with memberSplits P d xs a r
... | inl k = inl k
... | inr k = inr (inr k)

noMemberInBoth :
  (P : A → Type) (d : (a : A) → Dec (P a)) (xs : List A) (a : A)
  → Mem a (filterDec P d xs) → Mem a (filterOut P d xs) → ⊥
noMemberInBoth P d xs a mk mo =
  memberOfFilterOutFails P d xs a mo (memberOfFilterSatisfies P d xs a mk)

------------------------------------------------------------------------
-- 3.  At the Pareto layer
------------------------------------------------------------------------

layerCovers :
  (xs : List (List ℕ)) (v : List ℕ)
  → Mem v xs → Mem v (stratum xs) ⊎ Mem v (remainder xs)
layerCovers xs =
  memberSplits (λ u → IsParetoMaximal u xs) (λ u → decIsParetoMaximal u xs) xs

layerIsDisjoint :
  (xs : List (List ℕ)) (v : List ℕ)
  → Mem v (stratum xs) → Mem v (remainder xs) → ⊥
layerIsDisjoint xs =
  noMemberInBoth (λ u → IsParetoMaximal u xs) (λ u → decIsParetoMaximal u xs) xs

------------------------------------------------------------------------
-- The ITERATED coverage and disjointness, threading the one-step facts
-- through the recursion alongside `theStratificationTerminates`, are
-- `theStratificationCovers` and `theStrataArePairwiseDisjoint` in
-- `TheStratificationCoversAndItsStrataArePairwiseDisjoint`.
--
-- The threading is ASYMMETRIC, which is not visible from one
-- step: coverage needs `theStratificationTerminates` to kill the
-- leftover branch, and disjointness needs no measure at all — it holds
-- at every fuel, so a stratification cut short is still a partition of
-- what it reached.  The joint is `strataSound` (every member of every
-- later stratum was already a member of the remainder), which is what
-- makes the head-vs-all-later case a consequence of `layerIsDisjoint`.
------------------------------------------------------------------------
