{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- TheCanonicalFuelIsTheArchivesOwnLengthAndOverFuellingIsInert
--
-- ON THE NAME.  **No tradition term is claimed and none is invented.**
-- Pareto stratification and fuelled recursion are not objects I can
-- trace to an Indian source, and a fabricated Sanskrit label would
-- assert a provenance nobody checked.  Checked before naming:
-- `.claude/hooks/priority-ledger.txt` (CURRENT header) and
-- `.claude/hooks/european-frame.txt`; no row applies, and the frame
-- check's scope requires Indian material, of which this module has
-- none.  `formal/` and `notes/` grepped first — `fuelIrrelevant`,
-- `overFuel`, `over-fuel` and `moreFuel` return nothing anywhere.
--
-- ────────────────────────────────────────────────────────────────────
-- THE GAP, NAMED BY THE LINE ITSELF AND LEFT OPEN
--
-- `TheStratificationTerminatesOnItsOwnLength` closes with:
--
--   "`strata` takes the fuel as an argument, so **a caller may
--    under-fuel it**; only `lengthL xs` is proved sufficient, and
--    nothing forces a caller to pass it."
--
-- That is accurate and it is only one side.  `fuelSuffices` proves
-- `lengthL xs` is ENOUGH.  Nothing on the line proves it is not TOO
-- MUCH — i.e. that two callers passing different sufficient fuels get
-- the same stratification.  Until that is proved, `strata n xs` is a
-- FAMILY indexed by a caller's choice, and no theorem stated at one
-- fuel transfers to another.
--
-- **AND ONE THEOREM ON THIS LINE IS STATED AT EXACTLY ONE FUEL.**
-- Checked by reading the signatures, not the headers:
--
--   theStrataAreOrdered : (n : ℕ) (xs : …) → Ordered (strata n xs)
--        — every fuel.  Ordering is a property of the output's shape.
--   theStratificationCovers : (xs …) → Mem v xs
--        → MemSome v (strata (lengthL xs) xs)
--        — **`lengthL xs` and nothing else.**
--
-- So coverage was, until §2 below, a statement about one point of the
-- family.  §3 extends it to every sufficient fuel, and that extension
-- is the reason this module exists rather than being a tidying-up.
--
-- WHAT IS PROVED
--
--   strataNil        `strata n [] ≡ []` at every fuel
--   fuelIrrelevant   above the threshold the fuel does not matter:
--                    `lengthL xs ≤ n → n ≤ m → strata n xs ≡ strata m xs`
--   canonicalFuel    hence every sufficient fuel agrees with `lengthL xs`
--   theStratificationCoversAtEverySufficientFuel
--                    coverage, transported off its single point
--   underFuellingIsARealFailureMode
--                    and the caution the line raised is not hypothetical:
--                    at fuel `0` a NON-EMPTY archive produces NO layers
--                    and is left over entire.  Both halves are `refl` —
--                    the failure needs no arithmetic to exhibit, which
--                    is why "may under-fuel" deserved a witness
--
-- **WHAT THE TWO SIDES TOGETHER SAY, AND IT IS THE POINT.**  The fuel
-- has exactly one degree of freedom that matters: whether it reaches
-- `lengthL xs`.  Below the threshold the output is genuinely wrong (§4);
-- at or above it, every choice gives the same list (§2).  So
-- `strata (lengthL xs) xs` is not *a* stratification, it is *the* one,
-- and the fuel argument is an implementation detail rather than a
-- parameter of the object — which is what the line has been assuming in
-- prose since `strata` was written.
--
-- WHAT IS NOT CLAIMED.  **No module on this line is amended or
-- retracted**; `theStratificationCovers` is true as stated and §3 is a
-- corollary of it, not a replacement.  Nothing is said about the NUMBER
-- of strata, about duplicates (`filterDec` and `filterOut` preserve
-- multiplicity and order, so a repeated vector is repeated wherever its
-- copies land), or about the flip — costs remain unflipped on this
-- whole line.  Disjointness is not transported here, only coverage;
-- the same argument would do it and is not written.
--
-- CHECKED on the CONTAINER (Agda 2.6.3, cubical v0.5 — NOT the declared
-- pin, Agda 2.8.0 + cubical v0.9).  --safe, no postulates, no holes.
------------------------------------------------------------------------

module TheCanonicalFuelIsTheArchivesOwnLengthAndOverFuellingIsInert where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (ℕ ; zero ; suc)
open import Cubical.Data.Nat.Order
  using (_≤_ ; ≤-refl ; ≤-trans ; pred-≤-pred ; ¬-<-zero)
open import Cubical.Data.List using (List ; [] ; _∷_)
open import Cubical.Data.Empty as ⊥ using (⊥)

open import TheParetoStratumIsDecidableAndTheFilterIsExact
  using (stratum)
open import TheRemainderIsStrictlyShorterSoTheStratificationHasAMeasure
  using (lengthL ; remainder ; theRemainderIsStrictlyShorter)
open import TheStratificationTerminatesOnItsOwnLength
  using (strata ; leftover)
open import OneStepCoverageAndDisjointnessOfTheLayer
  using (Mem)
open import TheStratificationCoversAndItsStrataArePairwiseDisjoint
  using (MemSome ; theStratificationCovers)

------------------------------------------------------------------------
-- 1.  The empty archive, at any fuel
------------------------------------------------------------------------

strataNil : (n : ℕ) → strata n [] ≡ []
strataNil zero    = refl
strataNil (suc n) = refl

------------------------------------------------------------------------
-- 2.  Above the threshold, the fuel does not matter
--
-- The recursion consumes one unit of fuel per layer and the remainder
-- strictly shortens, so a sufficient fuel is exhausted exactly when the
-- archive is.  The two `⊥.rec`s are the cases a sufficient fuel makes
-- impossible: fuel `0` on a non-empty archive, and `m` below `n`.
------------------------------------------------------------------------

fuelIrrelevant :
  (n m : ℕ) (xs : List (List ℕ))
  → lengthL xs ≤ n → n ≤ m → strata n xs ≡ strata m xs
fuelIrrelevant n m [] _ _ = strataNil n ∙ sym (strataNil m)
fuelIrrelevant zero    m       (x ∷ xs) h _   = ⊥.rec (¬-<-zero h)
fuelIrrelevant (suc n) zero    (x ∷ xs) _ n≤m = ⊥.rec (¬-<-zero n≤m)
fuelIrrelevant (suc n) (suc m) (x ∷ xs) h n≤m =
  cong (stratum (x ∷ xs) ∷_)
    (fuelIrrelevant n m (remainder (x ∷ xs))
      (pred-≤-pred (≤-trans (theRemainderIsStrictlyShorter x xs) h))
      (pred-≤-pred n≤m))

canonicalFuel :
  (m : ℕ) (xs : List (List ℕ))
  → lengthL xs ≤ m → strata m xs ≡ strata (lengthL xs) xs
canonicalFuel m xs h = sym (fuelIrrelevant (lengthL xs) m xs ≤-refl h)

------------------------------------------------------------------------
-- 3.  Coverage, off its single point
------------------------------------------------------------------------

theStratificationCoversAtEverySufficientFuel :
  (m : ℕ) (xs : List (List ℕ)) (v : List ℕ)
  → lengthL xs ≤ m → Mem v xs → MemSome v (strata m xs)
theStratificationCoversAtEverySufficientFuel m xs v h mem =
  subst (MemSome v) (sym (canonicalFuel m xs h))
    (theStratificationCovers xs v mem)

------------------------------------------------------------------------
-- 4.  And under-fuelling is not hypothetical
--
-- Both are `refl`: `strata 0` returns no layers whatever it is given,
-- and `leftover 0` returns its input untouched.  So on any non-empty
-- archive the caller gets an empty stratification and the entire
-- archive as remainder, with no error and no indication.
------------------------------------------------------------------------

underFuellingProducesNoLayers :
  (x : List ℕ) (xs : List (List ℕ)) → strata 0 (x ∷ xs) ≡ []
underFuellingProducesNoLayers x xs = refl

underFuellingLeavesEverything :
  (x : List ℕ) (xs : List (List ℕ)) → leftover 0 (x ∷ xs) ≡ x ∷ xs
underFuellingLeavesEverything x xs = refl
