{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- OneStepCoverageAndDisjointnessOfTheLayer
--
-- Two of the three output properties of the Pareto stratification:
--
--   (1) COVERAGE: every member of the archive appears in some layer of
--   `strata`.  (2) DISJOINTNESS: the layers share no member.
--
-- Both hold AT ONE STEP â” layer versus remainder â” and one step is what
-- the iterated statement needs, since `strata` peels a layer and
-- recurses on exactly the complement proved here.
--
-- â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”
-- WHAT IS PROVED
--
--   memberOfFilterSatisfies / memberOfFilterOutFails
--                     what membership in each half tells you, proved
--                     directly by induction rather than through an
--                     `All` â” this corpus now has THREE `All`s in three
--                     modules and routing through any of them would
--                     have meant a fourth
--   memberSplits      COVERAGE at one step: every member of `xs` is in
--                     `filterDec â¦ xs` or in `filterOut â¦ xs`
--   noMemberInBoth    DISJOINTNESS at one step: no member is in both
--   layerCovers / layerIsDisjoint
--                     the same at the Pareto stratum and its remainder
--
-- Both are stated for an ARBITRARY decidable predicate and instantiated
-- once, which is why they are three lines each: nothing about Pareto
-- maximality is used, only that the two filters are complementary.
--
-- â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”
-- NO NOVELTY.  A decidable filter and its complement partition a list;
-- the length version of this was already proved on this line
-- (`partitionLength`), and this is its membership counterpart.
------------------------------------------------------------------------

module OneStepCoverageAndDisjointnessOfTheLayer where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (â„•)
open import Cubical.Data.List using (List ; [] ; _âˆ·_)
open import Cubical.Data.Sum using (_âŠŽ_ ; inl ; inr)
open import Cubical.Data.Empty as âŠ¥ using (âŠ¥)
open import Cubical.Relation.Nullary using (Â¬_ ; Dec ; yes ; no)

open import KramaAstiNasti_TheFourthCornerCannotLiveOverAnEnumerableDecidableInstanceSet
  using (Any)
open import TheParetoStratumIsDecidableAndTheFilterIsExact
  using (filterDec ; IsParetoMaximal ; decIsParetoMaximal ; stratum)
open import TheRemainderIsStrictlyShorterSoTheStratificationHasAMeasure
  using (filterOut ; remainder)

private
  variable
    A : Type

Mem : {A : Type} â†’ A â†’ List A â†’ Type
Mem a xs = Any (Î» y â†’ y â‰¡ a) xs

------------------------------------------------------------------------
-- 1.  What membership in each half tells you
------------------------------------------------------------------------

memberOfFilterSatisfies :
  (P : A â†’ Type) (d : (a : A) â†’ Dec (P a)) (xs : List A) (a : A)
  â†’ Mem a (filterDec P d xs) â†’ P a
memberOfFilterSatisfies P d []       a e = âŠ¥.rec e
memberOfFilterSatisfies P d (x âˆ· xs) a m with d x
memberOfFilterSatisfies P d (x âˆ· xs) a (inl q) | yes p = subst P q p
memberOfFilterSatisfies P d (x âˆ· xs) a (inr r) | yes _ =
  memberOfFilterSatisfies P d xs a r
memberOfFilterSatisfies P d (x âˆ· xs) a m       | no  _ =
  memberOfFilterSatisfies P d xs a m

memberOfFilterOutFails :
  (P : A â†’ Type) (d : (a : A) â†’ Dec (P a)) (xs : List A) (a : A)
  â†’ Mem a (filterOut P d xs) â†’ Â¬ P a
memberOfFilterOutFails P d []       a e = âŠ¥.rec e
memberOfFilterOutFails P d (x âˆ· xs) a m with d x
memberOfFilterOutFails P d (x âˆ· xs) a m       | yes _ =
  memberOfFilterOutFails P d xs a m
memberOfFilterOutFails P d (x âˆ· xs) a (inl q) | no Â¬p =
  Î» pa â†’ Â¬p (subst P (sym q) pa)
memberOfFilterOutFails P d (x âˆ· xs) a (inr r) | no _ =
  memberOfFilterOutFails P d xs a r

------------------------------------------------------------------------
-- 2.  Coverage and disjointness, for any decidable predicate
------------------------------------------------------------------------

memberSplits :
  (P : A â†’ Type) (d : (a : A) â†’ Dec (P a)) (xs : List A) (a : A)
  â†’ Mem a xs â†’ Mem a (filterDec P d xs) âŠŽ Mem a (filterOut P d xs)
memberSplits P d []       a e = âŠ¥.rec e
memberSplits P d (x âˆ· xs) a m with d x
memberSplits P d (x âˆ· xs) a (inl q) | yes _ = inl (inl q)
memberSplits P d (x âˆ· xs) a (inr r) | yes _ with memberSplits P d xs a r
... | inl k = inl (inr k)
... | inr k = inr k
memberSplits P d (x âˆ· xs) a (inl q) | no  _ = inr (inl q)
memberSplits P d (x âˆ· xs) a (inr r) | no  _ with memberSplits P d xs a r
... | inl k = inl k
... | inr k = inr (inr k)

noMemberInBoth :
  (P : A â†’ Type) (d : (a : A) â†’ Dec (P a)) (xs : List A) (a : A)
  â†’ Mem a (filterDec P d xs) â†’ Mem a (filterOut P d xs) â†’ âŠ¥
noMemberInBoth P d xs a mk mo =
  memberOfFilterOutFails P d xs a mo (memberOfFilterSatisfies P d xs a mk)

------------------------------------------------------------------------
-- 3.  At the Pareto layer
------------------------------------------------------------------------

layerCovers :
  (xs : List (List â„•)) (v : List â„•)
  â†’ Mem v xs â†’ Mem v (stratum xs) âŠŽ Mem v (remainder xs)
layerCovers xs =
  memberSplits (Î» u â†’ IsParetoMaximal u xs) (Î» u â†’ decIsParetoMaximal u xs) xs

layerIsDisjoint :
  (xs : List (List â„•)) (v : List â„•)
  â†’ Mem v (stratum xs) â†’ Mem v (remainder xs) â†’ âŠ¥
layerIsDisjoint xs =
  noMemberInBoth (Î» u â†’ IsParetoMaximal u xs) (Î» u â†’ decIsParetoMaximal u xs) xs

------------------------------------------------------------------------
-- The ITERATED coverage and disjointness, threading the one-step facts
-- through the recursion alongside `theStratificationTerminates`, are
-- `theStratificationCovers` and `theStrataArePairwiseDisjoint` in
-- `TheStratificationCoversAndItsStrataArePairwiseDisjoint`.
--
-- The threading is ASYMMETRIC, which is not visible from one
-- step: coverage needs `theStratificationTerminates` to kill the
-- leftover branch, and disjointness needs no measure at all â” it holds
-- at every fuel, so a stratification cut short is still a partition of
-- what it reached.  The joint is `strataSound` (every member of every
-- later stratum was already a member of the remainder), which is what
-- makes the head-vs-all-later case a consequence of `layerIsDisjoint`.
------------------------------------------------------------------------
