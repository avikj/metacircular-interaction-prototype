{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- TheStratificationTerminatesOnItsOwnLength
--
-- `TheRemainderIsStrictlyShorterSoTheStratificationHasAMeasure` built
-- the decreasing measure and closed with:
--
--   "THE ITERATION IS NOT WRITTEN.  No `strata` function exists,
--    fuelled or well-founded, and nothing claims the layers it would
--    produce cover the archive, are pairwise disjoint, or are ordered
--    by domination.  What was missing for a stratification was never
--    the recursion — it was the measure the recursion decreases."
--
-- That sentence is now testable, and it holds: with the measure in
-- hand the recursion is four lines and its termination is one
-- induction.  The iteration is written here; the three claims about
-- the LAYERS are still not made, and are still the honest remainder.
--
-- ────────────────────────────────────────────────────────────────────
-- WHAT IS PROVED
--
--   leftover / strata     the fuelled iteration: peel the maximal
--                         layer, recurse on the remainder
--   lengthZeroGivesNil    a list of length ≤ 0 is empty
--   fuelSuffices          if the fuel is at least the length, the
--                         iteration exhausts the archive
--   theStratificationTerminates
--                         hence `leftover (lengthL xs) xs ≡ []` — the
--                         archive's OWN LENGTH is enough fuel
--
-- The induction is the previous cycle's measure applied once per step:
-- `theRemainderIsStrictlyShorter` turns `lengthL (x ∷ xs) ≤ suc n` into
-- `lengthL (remainder (x ∷ xs)) ≤ n`, which is exactly the recursive
-- call's obligation.  Nothing else is needed, which is what "the
-- measure was the missing piece" meant.
--
-- ────────────────────────────────────────────────────────────────────
-- NO NOVELTY.  Fuelled recursion with the fuel bounded by a decreasing
-- measure is the standard way to write a well-founded loop without
-- well-founded machinery.
--
-- THE SCOPE, EXACTLY — the same three, and they are now the
-- WHOLE remainder for this line.  (1) COVERAGE: nothing says every
-- member of the archive appears in some layer of `strata`.  (2)
-- DISJOINTNESS: nothing says the layers share no member; `filterDec`
-- and `filterOut` preserve duplicates, so a repeated vector appears
-- wherever its copies land.  (3) ORDER: nothing says a member of an
-- earlier layer dominates, or is not dominated by, a member of a later
-- one — which is the property that would make "stratification" mean
-- what §5.2 wants.  All three are statements about the OUTPUT, and the
-- termination proved here says nothing about them.  Also: `strata`
-- takes the fuel as an argument, so a caller may under-fuel it; only
-- `lengthL xs` is proved sufficient, and nothing forces a caller to
-- pass it.  Costs remain unflipped on this line.
--
-- CHECKED on the CONTAINER (Agda 2.6.3, cubical v0.5 — NOT the declared
-- pin, Agda 2.8.0 + cubical v0.9).  --safe, no postulates, no holes.
------------------------------------------------------------------------

module TheStratificationTerminatesOnItsOwnLength where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (ℕ ; zero ; suc)
open import Cubical.Data.Nat.Order
  using (_≤_ ; _<_ ; ≤-refl ; ≤-trans ; pred-≤-pred ; ¬-<-zero)
open import Cubical.Data.List using (List ; [] ; _∷_)
open import Cubical.Data.Empty as ⊥ using (⊥)

open import TheParetoStratumIsDecidableAndTheFilterIsExact
  using (stratum)
open import TheRemainderIsStrictlyShorterSoTheStratificationHasAMeasure
  using (lengthL ; remainder ; theRemainderIsStrictlyShorter)

------------------------------------------------------------------------
-- 1.  The iteration
------------------------------------------------------------------------

leftover : ℕ → List (List ℕ) → List (List ℕ)
leftover zero    xs       = xs
leftover (suc n) []       = []
leftover (suc n) (x ∷ xs) = leftover n (remainder (x ∷ xs))

strata : ℕ → List (List ℕ) → List (List (List ℕ))
strata zero    xs       = []
strata (suc n) []       = []
strata (suc n) (x ∷ xs) = stratum (x ∷ xs) ∷ strata n (remainder (x ∷ xs))

------------------------------------------------------------------------
-- 2.  Its own length is enough fuel
------------------------------------------------------------------------

lengthZeroGivesNil : (xs : List (List ℕ)) → lengthL xs ≤ 0 → xs ≡ []
lengthZeroGivesNil []       _ = refl
lengthZeroGivesNil (x ∷ xs) h = ⊥.rec (¬-<-zero h)

fuelSuffices :
  (n : ℕ) (xs : List (List ℕ)) → lengthL xs ≤ n → leftover n xs ≡ []
fuelSuffices zero    xs       h = lengthZeroGivesNil xs h
fuelSuffices (suc n) []       _ = refl
fuelSuffices (suc n) (x ∷ xs) h =
  fuelSuffices n (remainder (x ∷ xs))
    (pred-≤-pred (≤-trans (theRemainderIsStrictlyShorter x xs) h))

theStratificationTerminates :
  (xs : List (List ℕ)) → leftover (lengthL xs) xs ≡ []
theStratificationTerminates xs = fuelSuffices (lengthL xs) xs ≤-refl

------------------------------------------------------------------------
-- APPENDED 2026-08-19, by the same identity, at the end, altering no
-- line above.  §"WHAT IS STILL NOT CLAIMED" reduces this line to three
-- properties of the output and names (3) ORDER as the one that would
-- make "stratification" mean what §5.2 wants.  Its FIRST HALF is now
-- proved, in
-- `EveryRemainderMemberIsStrictlyDominated`
-- (--safe, no postulates, no holes; container green under Agda 2.6.3 +
-- cubical v0.5, NOT the declared pin — check.sh returns 1 and says so):
--
--   filterOutOnlyKeepsNonSatisfiers   the complement keeps exactly what
--                                     fails the predicate
--   anyToMember                       an `Any` yields its witness WITH
--                                     the membership `anyToΣ` discards
--   everyRemainderMemberIsStrictlyDominated
--                                     every member of `remainder xs` is
--                                     strictly dominated by a member OF
--                                     `xs`
--
-- THE DOUBLE NEGATION IS THE WHOLE DIFFICULTY AND IT IS DECIDED AWAY.
-- `IsParetoMaximal v xs` is `¬ Any (StrictlyDominates v) xs`, so failing
-- it gives `¬ ¬ Any …`.  The dominator is recovered only because
-- `decAny decStrictlyDominates` makes that `Any` decidable, hence
-- stable — the fourth cycle on this line to turn on the same decision.
--
-- STILL NOT CLAIMED, and the SECOND half of (3) is the real one: the
-- dominator lies in `xs`, NOT necessarily in `stratum xs`.
-- Strengthening it needs a RELATIVISED maximality lemma — for any `v`
-- in `xs` there is a maximal `m` in `xs` with `v ≼ m` — which is
-- `maximalExists` threaded through an extra parameter and is not
-- proved.  Until then, what holds is: nothing dropped from a layer was
-- undominated in the archive it was dropped from.  (1) COVERAGE and
-- (2) DISJOINTNESS remain untouched.
------------------------------------------------------------------------

------------------------------------------------------------------------
-- APPENDED 2026-08-19, by the same identity, at the end, altering no
-- line above.  §"WHAT IS STILL NOT CLAIMED" names three output
-- properties; the appended note above closed the first half of (3)
-- ORDER, and this closes (1) COVERAGE and (2) DISJOINTNESS AT ONE STEP,
-- in `OneStepCoverageAndDisjointnessOfTheLayer`
-- (--safe, no postulates, no holes; container green under Agda 2.6.3 +
-- cubical v0.5, NOT the declared pin — check.sh returns 1 and says so):
--
--   memberOfFilterSatisfies / memberOfFilterOutFails
--   memberSplits       every member of `xs` is in the filter or its
--                      complement
--   noMemberInBoth     and never in both
--   layerCovers / layerIsDisjoint   the same at `stratum` / `remainder`
--
-- One step is the right unit here, because `strata` peels a layer and
-- recurses on EXACTLY the complement these two are about.  Both are
-- proved for an arbitrary decidable predicate and instantiated once —
-- nothing about Pareto maximality is used, only that the two filters
-- are complementary, which is why each is three lines.
--
-- STILL NOT CLAIMED: THE ITERATED VERSIONS.  Nothing says a member of
-- the archive appears in some layer of `strata n xs`, nor that two
-- DIFFERENT layers share no member; both need these facts threaded
-- through the recursion alongside `theStratificationTerminates`, and
-- that threading is not written.  One-step disjointness is between a
-- layer and ITS OWN remainder — weaker than pairwise disjointness of
-- the layers.  Duplicates are untouched: the filters preserve
-- multiplicity and these are statements about membership, not counts.
------------------------------------------------------------------------
