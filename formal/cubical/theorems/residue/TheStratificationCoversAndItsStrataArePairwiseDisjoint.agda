{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- TheStratificationCoversAndItsStrataArePairwiseDisjoint
--
-- `OneStepCoverageAndDisjointnessOfTheLayer` proved the two output
-- properties of the DARWIN §5.2 stratification AT ONE STEP — the layer
-- and the remainder cover the archive and do not overlap — and closed
-- by naming the remainder of the line:
--
--   "the ITERATED coverage/disjointness (thread the one-step facts
--    through the recursion alongside `theStratificationTerminates`)"
--
-- That is done here.  The one-step facts are threaded through `strata`,
-- and the termination theorem is what turns the induction's leftover
-- branch into nothing.
--
-- ────────────────────────────────────────────────────────────────────
-- WHAT IS PROVED
--
--   MemSome v sss        v is a member of SOME list in sss
--   filterDecSubset      a member of a filtered list was a member
--   filterOutSubset      likewise for the complement
--   strataSound          a member of ANY stratum of `strata n xs` was a
--                        member of xs — the stratification invents
--                        nothing
--   coverageStep         `Mem v xs → MemSome v (strata n xs) ⊎
--                         Mem v (leftover n xs)` for every fuel n
--   theStratificationCovers
--                        at fuel `lengthL xs` the leftover is empty
--                        (`theStratificationTerminates`), so EVERY
--                        member of the archive lies in some stratum
--   Disjoint / AllDisjointFrom / Pairwise
--                        recursive families, no Fin, no indices
--   theStrataArePairwiseDisjoint
--                        `Pairwise (strata n xs)` for every n and xs
--
-- **THE TWO HALVES ARE NOT SYMMETRIC, and that is the content.**
-- Coverage needs the MEASURE: the induction leaves a leftover at every
-- fuel, and only `theStratificationTerminates` — proved separately,
-- for its own reasons — kills it.  Disjointness needs NO measure: it
-- holds at every fuel, including fuels too small to exhaust the
-- archive, because it is inherited step by step from
-- `layerIsDisjoint` plus `strataSound`.  So a truncated stratification
-- is still a partition of what it has reached; it is only COVERAGE
-- that can fail for want of fuel.
--
-- The joint is `strataSound`: pairwise disjointness of the head from
-- ALL later strata is not a one-step fact, and becomes one only once
-- every later stratum is known to sit inside the remainder.
--
-- ────────────────────────────────────────────────────────────────────
-- NO NOVELTY.  That iterated non-dominated sorting partitions its
-- input is the property it is named for (Goldberg 1989; the
-- fast-non-dominated-sort of Deb et al. 2002 is the standard
-- reference).  What is here is only the checked version of it over
-- this corpus's own `stratum`/`remainder`.
--
-- SYĀT — THE CLAIM, EXACTLY.  Nothing says the strata are NON-EMPTY (they
-- are, by `stratumIsNonEmpty`, but that is not threaded through here),
-- nor that their lengths sum to the archive's, nor that the number of
-- strata is minimal, nor anything ORDERING the strata — that every
-- member of a later stratum is dominated by some member of an earlier
-- one is the SECOND HALF OF ORDER and is still open; it needs a
-- well-founded measure on ⊏ over a finite list.  `Mem` is a truncation-
-- free `Any`, so a value listed twice is two members and nothing here
-- deduplicates.  Coverage is stated at fuel `lengthL xs` only.
--
-- CHECKED on the CONTAINER (Agda 2.6.3, cubical v0.5 — NOT the declared
-- pin, Agda 2.8.0 + cubical v0.9).  --safe, no postulates, no holes.
------------------------------------------------------------------------

module TheStratificationCoversAndItsStrataArePairwiseDisjoint where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (ℕ ; zero ; suc)
open import Cubical.Data.List using (List ; [] ; _∷_)
open import Cubical.Data.Sum using (_⊎_ ; inl ; inr)
open import Cubical.Data.Sigma using (_×_ ; _,_)
open import Cubical.Data.Unit using (Unit ; tt)
open import Cubical.Data.Empty as ⊥ using (⊥)
open import Cubical.Relation.Nullary using (¬_ ; Dec ; yes ; no)

open import KramaAstiNasti_TheFourthCornerCannotLiveOverAnEnumerableDecidableInstanceSet
  using (Any)
open import TheParetoStratumIsDecidableAndTheFilterIsExact
  using (filterDec ; stratum)
open import TheRemainderIsStrictlyShorterSoTheStratificationHasAMeasure
  using (filterOut ; remainder ; lengthL)
open import TheStratificationTerminatesOnItsOwnLength
  using (leftover ; strata ; theStratificationTerminates)
open import OneStepCoverageAndDisjointnessOfTheLayer
  using (Mem ; layerCovers ; layerIsDisjoint)

private
  variable
    A : Type

------------------------------------------------------------------------
-- 0.  Membership in one of a list of lists
------------------------------------------------------------------------

MemSome : A → List (List A) → Type
MemSome a sss = Any (λ ys → Mem a ys) sss

------------------------------------------------------------------------
-- 1.  Filtering invents nothing
------------------------------------------------------------------------

filterDecSubset :
  (P : A → Type) (d : (a : A) → Dec (P a)) (xs : List A) (a : A)
  → Mem a (filterDec P d xs) → Mem a xs
filterDecSubset P d []       a e = ⊥.rec e
filterDecSubset P d (x ∷ xs) a m with d x
filterDecSubset P d (x ∷ xs) a (inl q) | yes _ = inl q
filterDecSubset P d (x ∷ xs) a (inr r) | yes _ =
  inr (filterDecSubset P d xs a r)
filterDecSubset P d (x ∷ xs) a m       | no  _ =
  inr (filterDecSubset P d xs a m)

filterOutSubset :
  (P : A → Type) (d : (a : A) → Dec (P a)) (xs : List A) (a : A)
  → Mem a (filterOut P d xs) → Mem a xs
filterOutSubset P d []       a e = ⊥.rec e
filterOutSubset P d (x ∷ xs) a m with d x
filterOutSubset P d (x ∷ xs) a m       | yes _ =
  inr (filterOutSubset P d xs a m)
filterOutSubset P d (x ∷ xs) a (inl q) | no  _ = inl q
filterOutSubset P d (x ∷ xs) a (inr r) | no  _ =
  inr (filterOutSubset P d xs a r)

stratumSubset :
  (xs : List (List ℕ)) (v : List ℕ) → Mem v (stratum xs) → Mem v xs
stratumSubset xs v = filterDecSubset _ _ xs v

remainderSubset :
  (xs : List (List ℕ)) (v : List ℕ) → Mem v (remainder xs) → Mem v xs
remainderSubset xs v = filterOutSubset _ _ xs v

------------------------------------------------------------------------
-- 2.  The stratification invents nothing either
------------------------------------------------------------------------

strataSound :
  (n : ℕ) (xs : List (List ℕ)) (v : List ℕ)
  → MemSome v (strata n xs) → Mem v xs
strataSound zero    xs       v e = ⊥.rec e
strataSound (suc n) []       v e = ⊥.rec e
strataSound (suc n) (x ∷ xs) v (inl h) = stratumSubset (x ∷ xs) v h
strataSound (suc n) (x ∷ xs) v (inr k) =
  remainderSubset (x ∷ xs) v (strataSound n (remainder (x ∷ xs)) v k)

------------------------------------------------------------------------
-- 3.  Coverage, with the leftover, at every fuel
------------------------------------------------------------------------

coverageStep :
  (n : ℕ) (xs : List (List ℕ)) (v : List ℕ)
  → Mem v xs → MemSome v (strata n xs) ⊎ Mem v (leftover n xs)
coverageStep zero    xs       v m = inr m
coverageStep (suc n) []       v e = ⊥.rec e
coverageStep (suc n) (x ∷ xs) v m with layerCovers (x ∷ xs) v m
... | inl h = inl (inl h)
... | inr r with coverageStep n (remainder (x ∷ xs)) v r
...   | inl k = inl (inr k)
...   | inr l = inr l

------------------------------------------------------------------------
-- 4.  …and the measure removes the leftover
------------------------------------------------------------------------

theStratificationCovers :
  (xs : List (List ℕ)) (v : List ℕ)
  → Mem v xs → MemSome v (strata (lengthL xs) xs)
theStratificationCovers xs v m with coverageStep (lengthL xs) xs v m
... | inl k = k
... | inr l = ⊥.rec (subst (Mem v) (theStratificationTerminates xs) l)

------------------------------------------------------------------------
-- 5.  Pairwise disjointness — no measure needed
------------------------------------------------------------------------

Disjoint : List (List ℕ) → List (List ℕ) → Type
Disjoint ys zs = (v : List ℕ) → Mem v ys → Mem v zs → ⊥

AllDisjointFrom : List (List ℕ) → List (List (List ℕ)) → Type
AllDisjointFrom ys []         = Unit
AllDisjointFrom ys (zs ∷ sss) = Disjoint ys zs × AllDisjointFrom ys sss

Pairwise : List (List (List ℕ)) → Type
Pairwise []         = Unit
Pairwise (ys ∷ sss) = AllDisjointFrom ys sss × Pairwise sss

disjointFromTheUnion :
  (ys : List (List ℕ)) (sss : List (List (List ℕ)))
  → ((v : List ℕ) → Mem v ys → MemSome v sss → ⊥)
  → AllDisjointFrom ys sss
disjointFromTheUnion ys []         h = tt
disjointFromTheUnion ys (zs ∷ sss) h =
    (λ v mv mz → h v mv (inl mz))
  , disjointFromTheUnion ys sss (λ v mv k → h v mv (inr k))

theStrataArePairwiseDisjoint :
  (n : ℕ) (xs : List (List ℕ)) → Pairwise (strata n xs)
theStrataArePairwiseDisjoint zero    xs       = tt
theStrataArePairwiseDisjoint (suc n) []       = tt
theStrataArePairwiseDisjoint (suc n) (x ∷ xs) =
    disjointFromTheUnion (stratum (x ∷ xs)) (strata n (remainder (x ∷ xs)))
      (λ v h k →
        layerIsDisjoint (x ∷ xs) v h
          (strataSound n (remainder (x ∷ xs)) v k))
  , theStrataArePairwiseDisjoint n (remainder (x ∷ xs))
