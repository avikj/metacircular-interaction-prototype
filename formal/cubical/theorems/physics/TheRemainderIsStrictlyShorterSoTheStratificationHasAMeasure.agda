{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- TheRemainderIsStrictlyShorterSoTheStratificationHasAMeasure
--
-- Two modules on the Pareto line carry the same undischarged sentence.
-- `TheParetoStratumIsDecidableAndTheFilterIsExact` and
-- `ANonEmptyArchiveHasANonEmptyStratum` both say:
--
--   "one STRATUM is not a STRATIFICATION.  Removing the layer and
--    repeating needs a termination argument on the archive's length,
--    and nothing iterates anywhere yet."
--
-- The termination argument is the DECREASING MEASURE, and it is built
-- here.  The iteration itself is still not written, and this module
-- says so rather than implying otherwise — but the measure is the part
-- that was actually missing, since a fuelled or well-founded recursion
-- is mechanical once the measure exists and impossible before.
--
-- ────────────────────────────────────────────────────────────────────
-- WHAT IS PROVED
--
--   filterOut                 the complement of `filterDec`, keeping
--                             exactly what the filter drops
--   partitionLength           `length (filterDec …) + length
--                             (filterOut …) ≡ length xs` — the two
--                             halves partition, so nothing is lost or
--                             double-counted
--   memberMakesItNonEmpty     a list with a member has length ≥ 1
--   nonEmptyFilterShortensTheComplement
--                             hence if the kept part is non-empty the
--                             dropped part is STRICTLY shorter
--   theRemainderIsStrictlyShorter
--                             instantiated at the Pareto stratum, using
--                             `stratumIsNonEmpty` from the previous
--                             cycle: peeling the maximal layer off a
--                             non-empty archive strictly shrinks it
--
-- The dependency chain is worth naming because it is three cycles deep
-- and each step was needed by the next: DECIDABILITY of the order gave
-- a computable stratum; the computable stratum plus a decision gave
-- NON-EMPTINESS constructively; non-emptiness gives the STRICT
-- DECREASE.  None of the three could have been taken first.
--
-- ────────────────────────────────────────────────────────────────────
-- NO NOVELTY.  A filter and its complement partition a list, and a
-- non-empty part forces the other to be shorter; both are elementary.
-- They are proved because the missing piece for the stratification was
-- never the recursion — it was the measure the recursion decreases.
--
-- THE SCOPE, EXACTLY, and it is now a SMALLER remainder than
-- before.  THE ITERATION IS NOT WRITTEN: no `strata` function exists,
-- fuelled or well-founded, and no claim is made that the layers it
-- would produce cover the archive, are pairwise disjoint, or are
-- ordered by domination.  Only the measure is here.  Nothing is said
-- about the NUMBER of strata.  `filterOut` shares `filterDec`'s
-- behaviour on duplicates — multiplicity and order are preserved, so a
-- repeated vector is repeated in whichever part it lands in.  And the
-- costs are still unflipped on this whole line.
--
-- CHECKED on the CONTAINER (Agda 2.6.3, cubical v0.5 — NOT the declared
-- pin, Agda 2.8.0 + cubical v0.9).  --safe, no postulates, no holes.
------------------------------------------------------------------------

module TheRemainderIsStrictlyShorterSoTheStratificationHasAMeasure where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (ℕ ; zero ; suc ; _+_ ; +-suc ; +-comm)
open import Cubical.Data.Nat.Order using (_≤_ ; _<_ ; ≤-refl ; ≤-k+ ; suc-≤-suc ; zero-≤)
open import Cubical.Data.List using (List ; [] ; _∷_)
open import Cubical.Data.Sum using (inl ; inr)
open import Cubical.Data.Empty as ⊥ using (⊥)
open import Cubical.Relation.Nullary using (¬_ ; Dec ; yes ; no)

open import KramaAstiNasti_TheFourthCornerCannotLiveOverAnEnumerableDecidableInstanceSet
  using (Any)
open import TheParetoStratumIsDecidableAndTheFilterIsExact
  using (filterDec ; IsParetoMaximal ; decIsParetoMaximal ; stratum)
open import ANonEmptyArchiveHasANonEmptyStratum
  using (stratumIsNonEmpty)

private
  variable
    A : Type

------------------------------------------------------------------------
-- 1.  The complement of a decidable filter, and the partition
------------------------------------------------------------------------

lengthL : List A → ℕ
lengthL []       = zero
lengthL (_ ∷ xs) = suc (lengthL xs)

filterOut : (P : A → Type) → ((a : A) → Dec (P a)) → List A → List A
filterOut P d []       = []
filterOut P d (x ∷ xs) with d x
... | yes _ = filterOut P d xs
... | no  _ = x ∷ filterOut P d xs

partitionLength :
  (P : A → Type) (d : (a : A) → Dec (P a)) (xs : List A)
  → lengthL (filterDec P d xs) + lengthL (filterOut P d xs) ≡ lengthL xs
partitionLength P d []       = refl
partitionLength P d (x ∷ xs) with d x
... | yes _ = cong suc (partitionLength P d xs)
... | no  _ = +-suc (lengthL (filterDec P d xs)) (lengthL (filterOut P d xs))
            ∙ cong suc (partitionLength P d xs)

------------------------------------------------------------------------
-- 2.  A list with a member is non-empty
------------------------------------------------------------------------

memberMakesItNonEmpty :
  (xs : List A) (a : A) → Any (λ y → y ≡ a) xs → 1 ≤ lengthL xs
memberMakesItNonEmpty []       a e       = ⊥.rec e
memberMakesItNonEmpty (x ∷ xs) a (inl _) = suc-≤-suc zero-≤
memberMakesItNonEmpty (x ∷ xs) a (inr _) = suc-≤-suc zero-≤

------------------------------------------------------------------------
-- 3.  So a non-empty kept part shortens the dropped part
------------------------------------------------------------------------

nonEmptyFilterShortensTheComplement :
  (P : A → Type) (d : (a : A) → Dec (P a)) (xs : List A) (a : A)
  → Any (λ y → y ≡ a) (filterDec P d xs)
  → lengthL (filterOut P d xs) < lengthL xs
nonEmptyFilterShortensTheComplement P d xs a mem =
  subst (lengthL (filterOut P d xs) <_) (partitionLength P d xs) shifted
  where
    kept : 1 ≤ lengthL (filterDec P d xs)
    kept = memberMakesItNonEmpty (filterDec P d xs) a mem

    -- 1 + |out| ≤ |kept| + |out|
    shifted : lengthL (filterOut P d xs)
            < lengthL (filterDec P d xs) + lengthL (filterOut P d xs)
    shifted =
      subst2 _≤_
        (+-comm (lengthL (filterOut P d xs)) 1)
        (+-comm (lengthL (filterOut P d xs)) (lengthL (filterDec P d xs)))
        (≤-k+ {k = lengthL (filterOut P d xs)} kept)

------------------------------------------------------------------------
-- 4.  Instantiated: peeling the maximal layer strictly shrinks the archive
------------------------------------------------------------------------

remainder : List (List ℕ) → List (List ℕ)
remainder xs =
  filterOut (λ v → IsParetoMaximal v xs) (λ v → decIsParetoMaximal v xs) xs

theRemainderIsStrictlyShorter :
  (x : List ℕ) (xs : List (List ℕ))
  → lengthL (remainder (x ∷ xs)) < lengthL (x ∷ xs)
theRemainderIsStrictlyShorter x xs with stratumIsNonEmpty x xs
... | (m , mem) =
  nonEmptyFilterShortensTheComplement
    (λ v → IsParetoMaximal v (x ∷ xs))
    (λ v → decIsParetoMaximal v (x ∷ xs))
    (x ∷ xs) m mem

------------------------------------------------------------------------
-- APPENDED 2026-08-19, by the same identity, at the end, altering no
-- line above.  The NOT-CLAIMED section says:
--
--   "THE ITERATION IS NOT WRITTEN … What was missing for a
--    stratification was never the recursion — it was the measure the
--    recursion decreases."
--
-- That sentence was a claim about difficulty, and it is now testable.
-- It holds.  In
-- `TheStratificationTerminatesOnItsOwnLength`
-- (--safe, no postulates, no holes; container green under Agda 2.6.3 +
-- cubical v0.5, NOT the declared pin — check.sh returns 1 and says so)
-- the recursion is four lines and its termination is one induction:
--
--   leftover / strata     peel the maximal layer, recurse on the
--                         remainder, fuelled
--   fuelSuffices          fuel ≥ length ⇒ the iteration exhausts
--   theStratificationTerminates
--                         `leftover (lengthL xs) xs ≡ []` — the
--                         archive's OWN LENGTH is enough fuel
--
-- The induction applies `theRemainderIsStrictlyShorter` exactly once
-- per step, to turn `lengthL (x ∷ xs) ≤ suc n` into
-- `lengthL (remainder (x ∷ xs)) ≤ n`, which is precisely the recursive
-- call's obligation.  Nothing else is used — which is what "the measure
-- was the missing piece" meant, now demonstrated rather than asserted.
--
-- STILL NOT CLAIMED, and these are now the WHOLE remainder for this
-- line: COVERAGE (every archive member appears in some layer),
-- DISJOINTNESS (layers share no member — and `filterDec`/`filterOut`
-- preserve duplicates), and ORDER (a member of an earlier layer relates
-- to a member of a later one by domination).  All three are statements
-- about the OUTPUT; termination says nothing about them.  `strata` also
-- takes its fuel as an argument, so a caller may under-fuel it.
------------------------------------------------------------------------
