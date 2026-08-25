{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- TheStrataAreOrderedByDominationAndTheProofNeedsNoNewLemma
--
-- DARWIN §5.2's ORDER property, in full: every member of a later
-- stratum is strictly dominated by a member of an earlier one.
--
-- ────────────────────────────────────────────────────────────────────
-- THE CORRECTION FIRST, AND IT IS THE THIRD OF ITS KIND ON THIS LINE.
--
-- `EveryRemainderMemberIsBeatenByAStratumMember` recorded this as the
-- honest remaining gap and said it
--
--   "does NOT follow from the one-step fact by the coverage argument,
--    because `IsParetoMaximal` is relative to the list it is computed
--    in and later strata are maximal in the PEELED archive, not the
--    original.  Closing it needs a statement relating maximality in
--    `remainder xs` to domination in `xs`; that is a real object, not
--    a rearrangement."
--
-- **That was wrong, and the error is precise: the argument never needs
-- the later strata's MAXIMALITY.**  It needs only their MEMBERSHIP in
-- the remainder, and `strataSound` — proved two cycles earlier for
-- coverage — already gives exactly that.  Membership in the peeled
-- archive is all the one-step theorem asks of its input.  So no new
-- lemma exists in this module: the whole content is `strataSound`
-- composed with `everyRemainderMemberIsBeatenByAStratumMember`, plus
-- the same recursive bookkeeping already used for pairwise
-- disjointness.
--
-- The pattern is now unmistakable.  On this line I have called a step
-- cheap when it was not (a9b354d7), then called the same step's
-- successor expensive when it needed no measure at all (164a9b17),
-- then recorded a two-line consequence as an obligation (asymmetry,
-- fa435c69), and now recorded a composition of two existing theorems
-- as "a real object, not a rearrangement".  **Every one of the four
-- was a guess about difficulty made instead of an attempt at the
-- proof, and all four were wrong.**  The rule that follows is not
-- "estimate better": it is to spend the first minutes of a cycle
-- trying the proof, because on this evidence the estimate carries no
-- information.
--
-- ────────────────────────────────────────────────────────────────────
-- WHAT IS PROVED
--
--   Beats ys zs        every member of zs is strictly dominated by
--                      some member of ys
--   AllBeaten / Ordered
--                      recursive families over the list of strata, no
--                      indices, matching the shape of `Pairwise`
--   headBeatsEveryLaterStratum
--                      the head stratum beats every member of every
--                      later one
--   theStrataAreOrdered
--                      `Ordered (strata n xs)` for every fuel and
--                      archive
--
-- With `theStratificationCovers` and `theStrataArePairwiseDisjoint`,
-- DARWIN §5.2's three output properties — COVERAGE, DISJOINTNESS,
-- ORDER — are now all checked over this corpus's own
-- `stratum`/`remainder`.
--
-- NO NOVELTY.  This is the defining property of non-dominated sorting
-- (Goldberg 1989; Deb et al. 2002's fast-non-dominated-sort).
--
-- WHAT IS NOT CLAIMED.  `Beats` is an EXISTENCE statement per member
-- and picks no canonical dominator — `maximalExists` chooses one and
-- the choice is not stable under permuting the archive.  Nothing here
-- says a member of stratum j is beaten by a member of stratum j−1
-- specifically; the statement is "some earlier stratum", which for
-- adjacent layers is the same thing but for distant ones is weaker
-- than a rank function would be.  Nothing about lengths, the number of
-- strata, or non-emptiness of later strata.  `Mem` is a
-- truncation-free `Any`, so duplicates count twice.
--
-- CHECKED on the CONTAINER (Agda 2.6.3, cubical v0.5 — NOT the declared
-- pin, Agda 2.8.0 + cubical v0.9).  --safe, no postulates, no holes.
------------------------------------------------------------------------

module TheStrataAreOrderedByDominationAndTheProofNeedsNoNewLemma where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (ℕ ; zero ; suc)
open import Cubical.Data.List using (List ; [] ; _∷_)
open import Cubical.Data.Sum using (inl ; inr)
open import Cubical.Data.Sigma using (Σ-syntax ; _×_ ; _,_)
open import Cubical.Data.Unit using (Unit ; tt)

open import TheParetoStratumIsDecidableAndTheFilterIsExact
  using (StrictlyDominates ; stratum)
open import TheRemainderIsStrictlyShorterSoTheStratificationHasAMeasure
  using (remainder)
open import TheStratificationTerminatesOnItsOwnLength
  using (strata)
open import OneStepCoverageAndDisjointnessOfTheLayer
  using (Mem)
open import TheStratificationCoversAndItsStrataArePairwiseDisjoint
  using (MemSome ; strataSound)
open import EveryRemainderMemberIsBeatenByAStratumMember
  using (everyRemainderMemberIsBeatenByAStratumMember)

------------------------------------------------------------------------
-- 1.  The families
------------------------------------------------------------------------

Beats : List (List ℕ) → List (List ℕ) → Type
Beats ys zs =
  (v : List ℕ) → Mem v zs
  → Σ[ w ∈ List ℕ ] (Mem w ys × StrictlyDominates v w)

AllBeaten : List (List ℕ) → List (List (List ℕ)) → Type
AllBeaten ys []         = Unit
AllBeaten ys (zs ∷ sss) = Beats ys zs × AllBeaten ys sss

Ordered : List (List (List ℕ)) → Type
Ordered []         = Unit
Ordered (ys ∷ sss) = AllBeaten ys sss × Ordered sss

------------------------------------------------------------------------
-- 2.  The head stratum beats every member of every later one
------------------------------------------------------------------------

headBeatsEveryLaterStratum :
  (n : ℕ) (xs : List (List ℕ)) (v : List ℕ)
  → MemSome v (strata n (remainder xs))
  → Σ[ w ∈ List ℕ ] (Mem w (stratum xs) × StrictlyDominates v w)
headBeatsEveryLaterStratum n xs v k =
  everyRemainderMemberIsBeatenByAStratumMember xs v
    (strataSound n (remainder xs) v k)

beatsFromTheUnion :
  (ys : List (List ℕ)) (sss : List (List (List ℕ)))
  → ((v : List ℕ) → MemSome v sss
       → Σ[ w ∈ List ℕ ] (Mem w ys × StrictlyDominates v w))
  → AllBeaten ys sss
beatsFromTheUnion ys []         h = tt
beatsFromTheUnion ys (zs ∷ sss) h =
    (λ v m → h v (inl m))
  , beatsFromTheUnion ys sss (λ v k → h v (inr k))

------------------------------------------------------------------------
-- 3.  ORDER, over the whole stratification
------------------------------------------------------------------------

theStrataAreOrdered : (n : ℕ) (xs : List (List ℕ)) → Ordered (strata n xs)
theStrataAreOrdered zero    xs       = tt
theStrataAreOrdered (suc n) []       = tt
theStrataAreOrdered (suc n) (x ∷ xs) =
    beatsFromTheUnion (stratum (x ∷ xs)) (strata n (remainder (x ∷ xs)))
      (headBeatsEveryLaterStratum n (x ∷ xs))
  , theStrataAreOrdered n (remainder (x ∷ xs))
