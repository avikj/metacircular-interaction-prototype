{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- ExhaustionNotLengthIsWhatCoverageNeedsAndSafetyNeverNeededAnyFuelAtAll
--
-- ON THE NAME.  **No tradition term is claimed and none is invented.**
-- Pareto stratification and fuelled recursion are not objects I can
-- trace to an Indian source, and a fabricated Sanskrit label would
-- assert a provenance nobody checked.  Checked before naming:
-- `.claude/hooks/priority-ledger.txt` (CURRENT header) and
-- `.claude/hooks/european-frame.txt`; no row applies, and the frame
-- check's scope requires Indian material, of which this module has
-- none.  `formal/` and `notes/` grepped first.
--
-- ────────────────────────────────────────────────────────────────────
-- 0.  A CORRECTION OF MY OWN, FIRST
--
-- `TheCanonicalFuelIsTheArchivesOwnLengthAndOverFuellingIsInert`
-- (4e2a577d) says, in its NOT-CLAIMED section:
--
--   "**Disjointness is not transported here, only coverage;** the same
--    argument would do it and is not written."
--
-- That sentence is true word by word and it implies something false.
-- It reads as *disjointness is also stuck at one fuel and I left the
-- work undone*.  **It is not stuck.**  Reading the signature rather
-- than the header — the rule that cycle itself installed — gives
--
--   theStrataArePairwiseDisjoint : (n : ℕ) (xs : …) → Pairwise (strata n xs)
--
-- quantified over EVERY fuel already.  There was nothing to transport.
-- I asserted a symmetry between coverage and disjointness that the
-- types deny, in the very module whose finding was that a neighbouring
-- theorem's fuel quantifier had not been read.
--
-- ────────────────────────────────────────────────────────────────────
-- 1.  AND THE ASYMMETRY IS THE REAL STATEMENT
--
-- Quoting the three signatures on this line, all read from the source:
--
--   theStrataAreOrdered          : (n : ℕ) (xs …) → Ordered (strata n xs)
--   theStrataArePairwiseDisjoint : (n : ℕ) (xs …) → Pairwise (strata n xs)
--   theStratificationCovers      : (xs …) → Mem v xs
--                                  → MemSome v (strata (lengthL xs) xs)
--
-- **The two SAFETY properties — nothing in the output is wrong — hold
-- at every fuel.  The one COMPLETENESS property — nothing is missing
-- from the output — does not.**  That is not an accident of who proved
-- what: under-fuelling truncates the recursion, and a truncated list of
-- correct layers is still correct and still ordered.  It is only
-- shorter.  §4 of 4e2a577d exhibits the extreme case at fuel `0`, and
-- the classification says why that case is the only kind of damage
-- possible.
--
-- 2.  WHAT COVERAGE ACTUALLY DEPENDS ON
--
-- `theStratificationCovers` is proved from `coverageStep` — which is
-- itself stated at every fuel —
--
--   coverageStep : (n xs v) → Mem v xs
--                → MemSome v (strata n xs) ⊎ Mem v (leftover n xs)
--
-- by killing the right disjunct with `theStratificationTerminates`.
-- So the hypothesis coverage needs is not `lengthL xs ≤ n`; it is
-- **`leftover n xs ≡ []`** — that the fuel EXHAUSTED, not that it was
-- large.  §3 below states it that way, and 4e2a577d's
-- `theStratificationCoversAtEverySufficientFuel` becomes the corollary
-- at `fuelSuffices`.
--
-- **THIS IS STRICTLY MORE GENERAL, AND THE GAP IS NOT EMPTY.**
-- `lengthL xs ≤ n` is sufficient for exhaustion and NOT necessary: one
-- layer may remove many members, so an archive of length 2 whose whole
-- content is one antichain exhausts at fuel 1.  §4 exhibits exactly
-- that, by `refl`.
--
-- WHAT IS PROVED
--
--   coverageFromExhaustion   `leftover n xs ≡ []` → coverage at fuel `n`
--   coverageAtTheLength      the old statement, now a corollary
--   antichainOfTwo / exhaustsAtOne / lengthIsTwo
--                            a two-member archive that exhausts at fuel
--                            `1`, so the length bound is not necessary
--   coversAtOne              and coverage does hold there, at a fuel
--                            strictly below `lengthL`
--
-- WHAT IS NOT CLAIMED.  **No module is amended or retracted** — §0
-- corrects a NOT-CLAIMED remark of my own, and the theorem it sat next
-- to (`fuelIrrelevant`, `canonicalFuel`,
-- `theStratificationCoversAtEverySufficientFuel`) is untouched and
-- true.  It is NOT claimed that exhaustion is NECESSARY for coverage —
-- `coverageStep`'s right disjunct is a membership, not a refutation, so
-- a member could in principle sit in both the output and the leftover;
-- nothing here rules that out and nothing here needs to.  Nothing about
-- the NUMBER of strata, about duplicates (`filterDec`/`filterOut`
-- preserve multiplicity and order), or about the flip — costs remain
-- unflipped on this line.
--
-- CHECKED on the CONTAINER (Agda 2.6.3, cubical v0.5 — NOT the declared
-- pin, Agda 2.8.0 + cubical v0.9).  --safe, no postulates, no holes.
------------------------------------------------------------------------

module ExhaustionNotLengthIsWhatCoverageNeedsAndSafetyNeverNeededAnyFuelAtAll where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (ℕ ; zero ; suc)
open import Cubical.Data.List using (List ; [] ; _∷_)
open import Cubical.Data.Sum using (_⊎_ ; inl ; inr)
open import Cubical.Data.Empty as ⊥ using (⊥)

open import TheRemainderIsStrictlyShorterSoTheStratificationHasAMeasure
  using (lengthL)
open import TheStratificationTerminatesOnItsOwnLength
  using (strata ; leftover ; theStratificationTerminates)
open import OneStepCoverageAndDisjointnessOfTheLayer
  using (Mem)
open import TheStratificationCoversAndItsStrataArePairwiseDisjoint
  using (MemSome ; coverageStep)

------------------------------------------------------------------------
-- 3.  Coverage needs exhaustion, not length
------------------------------------------------------------------------

coverageFromExhaustion :
  (n : ℕ) (xs : List (List ℕ)) (v : List ℕ)
  → leftover n xs ≡ []
  → Mem v xs → MemSome v (strata n xs)
coverageFromExhaustion n xs v ex m with coverageStep n xs v m
... | inl k = k
... | inr l = ⊥.rec (subst (Mem v) ex l)

-- the line's original statement, now a corollary rather than a theorem
coverageAtTheLength :
  (xs : List (List ℕ)) (v : List ℕ)
  → Mem v xs → MemSome v (strata (lengthL xs) xs)
coverageAtTheLength xs v =
  coverageFromExhaustion (lengthL xs) xs v (theStratificationTerminates xs)

------------------------------------------------------------------------
-- 4.  And the length bound is not necessary
--
-- Two incomparable vectors: neither dominates the other, so the first
-- stratum is the whole archive and the remainder is empty.  The fuel
-- that exhausts is `1`; the length is `2`.  Both facts are `refl`, so
-- the separation costs no argument at all — which is the point, since
-- 4e2a577d's hypothesis would have demanded fuel `2`.
------------------------------------------------------------------------

antichainOfTwo : List (List ℕ)
antichainOfTwo = (1 ∷ 0 ∷ []) ∷ (0 ∷ 1 ∷ []) ∷ []

exhaustsAtOne : leftover 1 antichainOfTwo ≡ []
exhaustsAtOne = refl

lengthIsTwo : lengthL antichainOfTwo ≡ 2
lengthIsTwo = refl

coversAtOne :
  (v : List ℕ) → Mem v antichainOfTwo → MemSome v (strata 1 antichainOfTwo)
coversAtOne v = coverageFromExhaustion 1 antichainOfTwo v exhaustsAtOne
