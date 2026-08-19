{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- NaturalMachine.TheStratificationTerminatesOnItsOwnLength
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
-- WHAT IS STILL NOT CLAIMED — the same three, and they are now the
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

module NaturalMachine.TheStratificationTerminatesOnItsOwnLength where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (ℕ ; zero ; suc)
open import Cubical.Data.Nat.Order
  using (_≤_ ; _<_ ; ≤-refl ; ≤-trans ; pred-≤-pred ; ¬-<-zero)
open import Cubical.Data.List using (List ; [] ; _∷_)
open import Cubical.Data.Empty as ⊥ using (⊥)

open import NaturalMachine.TheParetoStratumIsDecidableAndTheFilterIsExact
  using (stratum)
open import NaturalMachine.TheRemainderIsStrictlyShorterSoTheStratificationHasAMeasure
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
