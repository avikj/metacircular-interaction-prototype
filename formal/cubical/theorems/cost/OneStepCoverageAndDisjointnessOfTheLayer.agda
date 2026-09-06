{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- OneStepCoverageAndDisjointnessOfTheLayer
--
-- `TheStratificationTerminatesOnItsOwnLength` reduced the Pareto line
-- to three properties of the output and this cycle takes the two that
-- were still untouched:
--
--   "(1) COVERAGE: nothing says every member of the archive appears in
--    some layer of `strata`.  (2) DISJOINTNESS: nothing says the layers
--    share no member."
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
--
-- THE SCOPE, EXACTLY.  THE ITERATED VERSIONS.  Nothing says a
-- member of the archive appears in some layer of `strata n xs` for any
-- particular `n`, nor that two DIFFERENT layers share no member — both
-- need the one-step facts threaded through the recursion together with
-- `theStratificationTerminates`, and that threading is not written.
-- The one-step disjointness is between a layer and ITS OWN remainder,
-- which is weaker than "the layers are pairwise disjoint".  Duplicates
-- are unaffected: `filterDec` and `filterOut` preserve multiplicity, so
-- a vector listed twice is listed twice wherever it lands — the
-- statements above are about membership, not counts.  ORDER's second
-- half remains open and, as recorded, is NOT cheap.
--
-- CHECKED on the CONTAINER (Agda 2.6.3, cubical v0.5 — NOT the declared
-- pin, Agda 2.8.0 + cubical v0.9).  --safe, no postulates, no holes.
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
-- APPENDED 2026-08-19, by the same identity, at the end, altering no
-- line above.  The first item of the remainder named above — "the
-- ITERATED coverage/disjointness (thread the one-step facts through the
-- recursion alongside `theStratificationTerminates`)" — is done in
-- `TheStratificationCoversAndItsStrataArePairwiseDisjoint`
-- (--safe, no postulates, no holes; container green under Agda 2.6.3 +
-- cubical v0.5, NOT the declared pin — check.sh returns 1 and says so):
-- `theStratificationCovers` and `theStrataArePairwiseDisjoint`.
--
-- The threading turned out ASYMMETRIC, which was not visible from one
-- step: coverage needs `theStratificationTerminates` to kill the
-- leftover branch, and disjointness needs no measure at all — it holds
-- at every fuel, so a stratification cut short is still a partition of
-- what it reached.  The joint is `strataSound` (every member of every
-- later stratum was already a member of the remainder), which is what
-- makes the head-vs-all-later case a consequence of `layerIsDisjoint`.
--
-- The second item — ORDER's second half — is untouched and still needs
-- a well-founded measure on ⊏ over a finite list.
------------------------------------------------------------------------
