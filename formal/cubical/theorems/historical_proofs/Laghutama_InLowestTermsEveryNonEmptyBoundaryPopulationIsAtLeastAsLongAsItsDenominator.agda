{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- Laghutama_InLowestTermsEveryNonEmptyBoundaryPopulationIsAtLeastAsLongAsItsDenominator
--
-- `MinimalityOfABoundaryPopulationNeedsLowestTerms` proved minimality
-- of a boundary population at numerator one, refuted it at 2/4, and
-- said of the general case:
--
--   "The general case — gcd p (suc q) ≡ 1 ⇒ every non-empty boundary
--    population has length ≥ suc q — is NOT proved.  It needs exactly
--    one missing lemma, Euclid's:
--
--      gcd a b ≡ 1  →  a ∣ b · c  →  a ∣ c
--
--    and cubical v0.5 does not ship it: `Cubical.Data.Nat.GCD` has the
--    Euclidean ALGORITHM (`euclid`, `gcd`, `isGCD`) and `Divisibility`
--    has cancellation, but the lemma itself is absent, and it is not
--    derivable from those without a Bézout identity."
--
-- The lemma is now in this repository, and WITHOUT Bézout:
-- `WalkJumps.coprime-cancel : isGCD a b 1 → a ∣ b · c → a ∣ c`, proved
-- there from `gcd-factorʳ` (gcd (a·c) (b·c) ≡ gcd a b · c) and the
-- universal property of the gcd.  This module imports it and closes
-- the general case exactly as the quoted sentence states it.
--
-- ────────────────────────────────────────────────────────────────────
-- WHAT IS PROVED  (Boundary p q bs is `p · length bs ≡ suc q · count bs`,
-- imported from the earlier module, not restated)
--
--   isGCD-sym                isGCD m n d → isGCD n m d
--   boundaryGivesDivisibility
--                            Boundary p q bs → suc q ∣ p · length bs
--   boundaryDividesInLowestTerms
--                            isGCD p (suc q) 1 → Boundary p q bs
--                            → suc q ∣ length bs            (Euclid)
--   minimalityInLowestTerms  isGCD p (suc q) 1 → Boundary p q bs
--                            → 1 ≤ length bs → suc q ≤ length bs
--   minimalityInLowestTermsGcd
--                            the same with the hypothesis in the
--                            quoted form, gcd p (suc q) ≡ 1
--   minimalityInLowestTermsCount
--                            the same with `1 ≤ count bs`, the
--                            non-emptiness hypothesis the earlier
--                            module used at p = 1
--   atLeastAndNotAboveIsBoundary
--                            AtLeast p q bs → ¬ Above p q bs
--                            → Boundary p q bs
--   minimalityOfABoundaryPopulation
--                            in the exact terms of
--                            `everyThresholdHasABoundaryPopulation`:
--                            gcd p (suc q) ≡ 1, 1 ≤ length bs,
--                            AtLeast p q bs, ¬ Above p q bs
--                            ⇒ suc q ≤ length bs
--   popIsMinimal             for p ≤ suc q with gcd p (suc q) ≡ 1, the
--                            population of the earlier module has length
--                            suc q AND no non-empty boundary population
--                            is shorter
--   twoOverFourIsNotInLowestTerms
--                            ¬ isGCD 2 4 1 — so the counterexample of
--                            the earlier module does not meet the
--                            hypothesis, as it must not
--
-- Non-emptiness is `1 ≤ length bs` throughout, which is WEAKER than the
-- `1 ≤ count bs` of the earlier module (count ≤ length); the count form
-- is derived from it.  The empty population is a boundary population
-- of length 0 at every threshold and is excluded by exactly that
-- hypothesis, as before.
--
-- ────────────────────────────────────────────────────────────────────
-- THE SCOPE, EXACTLY.  Nothing here says which lengths ARE achievable:
-- `popIsMinimal` says suc q is achieved and nothing non-empty is
-- shorter, not that every multiple of suc q is achieved or that only
-- multiples are (the latter is `boundaryDividesInLowestTerms`, and
-- the former is not claimed).  Nothing is quotiented: `gcd p (suc q)
-- ≡ 1` is a property of the PAIR, and 2/4 still fails where 1/2
-- succeeds — that is `twoOverFourIsNotInLowestTerms` next to
-- `minimalityInLowestTermsGcd`, not a contradiction.  No Bézout
-- identity is used or proved; `coprime-cancel` does not need one.
--
-- CHECKED at the declared pin (Agda 2.8.0, cubical v0.9).  --safe, no
-- postulates, no holes, no TERMINATING pragmas.
------------------------------------------------------------------------

module Laghutama_InLowestTermsEveryNonEmptyBoundaryPopulationIsAtLeastAsLongAsItsDenominator where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat
  using (ℕ ; zero ; suc ; _+_ ; _·_ ; ·-comm ; snotz)
open import Cubical.Data.Nat.Order
  using (_≤_ ; _<_ ; ≤-trans ; ¬-<-zero ; ≤-split ; pred-≤-pred)
open import Cubical.Data.Nat.Divisibility
  using (_∣_ ; ∣-right ; ∣-left ; m∣n→m≤n)
open import Cubical.Data.Nat.GCD
  using (gcd ; isGCD ; symCD ; gcd≡→isGCD)
open import Cubical.Data.Bool using (Bool)
open import Cubical.Data.List using (List)
open import Cubical.Data.Sigma
open import Cubical.Data.Sum using (inl ; inr)
open import Cubical.Data.Empty as ⊥ using ()
open import Cubical.Relation.Nullary using (¬_)

open import RateOneIsExactlyTheUniversalClaim
  using (count ; length ; countIsAtMostLength)
open import TheThresholdOrderIsTotalAndTheClaimIsAntitone
  using (AtLeast)
open import TheStrictThresholdsAreTheSameChainAndDifferOnlyAtTheBoundary
  using (Above)
open import EveryThresholdHasABoundaryPopulationOfItsOwnDenominator
  using (everyThresholdHasABoundaryPopulation)
open import MinimalityOfABoundaryPopulationNeedsLowestTerms
  using (Boundary)
open import WalkJumps using (coprime-cancel)

------------------------------------------------------------------------
-- 1.  The gcd is symmetric
--
-- `coprime-cancel a b c` wants `isGCD a b 1` with a the divisor that
-- gets cancelled through, i.e. `isGCD (suc q) p 1`; the quoted
-- statement has `gcd p (suc q)`.  `symCD` is in the library, the
-- greatest-part is one line on top of it.
------------------------------------------------------------------------

isGCD-sym : (m n d : ℕ) → isGCD m n d → isGCD n m d
isGCD-sym m n d (cd , greatest) =
  symCD cd , λ d' cd' → greatest d' (symCD cd')

------------------------------------------------------------------------
-- 2.  A boundary population's length, scaled by p, is a multiple of
--     the denominator — this is the equation read as a witness
------------------------------------------------------------------------

boundaryGivesDivisibility :
  (p q : ℕ) (bs : List Bool) → Boundary p q bs → suc q ∣ (p · length bs)
boundaryGivesDivisibility p q bs b =
  subst (suc q ∣_) shape (∣-right (count bs))
  where
    shape : count bs · suc q ≡ p · length bs
    shape = ·-comm (count bs) (suc q) ∙ sym b

------------------------------------------------------------------------
-- 3.  Euclid cancels the numerator
------------------------------------------------------------------------

boundaryDividesInLowestTerms :
  (p q : ℕ) (bs : List Bool) → isGCD p (suc q) 1 → Boundary p q bs
  → suc q ∣ length bs
boundaryDividesInLowestTerms p q bs g b =
  coprime-cancel (suc q) p (length bs)
    (isGCD-sym p (suc q) 1 g)
    (boundaryGivesDivisibility p q bs b)

------------------------------------------------------------------------
-- 4.  Hence minimality: a divisor of a positive number is at most it
------------------------------------------------------------------------

minimalityInLowestTerms :
  (p q : ℕ) (bs : List Bool) → isGCD p (suc q) 1 → Boundary p q bs
  → 1 ≤ length bs → suc q ≤ length bs
minimalityInLowestTerms p q bs g b pos =
  m∣n→m≤n nonzero (boundaryDividesInLowestTerms p q bs g b)
  where
    nonzero : ¬ length bs ≡ 0
    nonzero e = ¬-<-zero (subst (1 ≤_) e pos)

-- The hypothesis in the quoted form.
minimalityInLowestTermsGcd :
  (p q : ℕ) (bs : List Bool) → gcd p (suc q) ≡ 1 → Boundary p q bs
  → 1 ≤ length bs → suc q ≤ length bs
minimalityInLowestTermsGcd p q bs e =
  minimalityInLowestTerms p q bs (gcd≡→isGCD e)

-- Non-emptiness as the earlier module phrased it at p = 1.
minimalityInLowestTermsCount :
  (p q : ℕ) (bs : List Bool) → gcd p (suc q) ≡ 1 → Boundary p q bs
  → 1 ≤ count bs → suc q ≤ length bs
minimalityInLowestTermsCount p q bs e b pos =
  minimalityInLowestTermsGcd p q bs e b
    (≤-trans pos (countIsAtMostLength bs))

------------------------------------------------------------------------
-- 5.  In the terms of `everyThresholdHasABoundaryPopulation`
--
-- That theorem delivers `AtLeast p q bs × ¬ Above p q bs`, i.e.
-- `p · length ≤ suc q · count` and `¬ (p · length < suc q · count)`.
-- `≤-split` turns the pair into the equation.
------------------------------------------------------------------------

atLeastAndNotAboveIsBoundary :
  (p q : ℕ) (bs : List Bool) → AtLeast p q bs → ¬ Above p q bs
  → Boundary p q bs
atLeastAndNotAboveIsBoundary p q bs atl nab with ≤-split atl
... | inl lt = ⊥.rec (nab lt)
... | inr eq = eq

minimalityOfABoundaryPopulation :
  (p q : ℕ) → gcd p (suc q) ≡ 1
  → (bs : List Bool) → 1 ≤ length bs → AtLeast p q bs → ¬ Above p q bs
  → suc q ≤ length bs
minimalityOfABoundaryPopulation p q e bs pos atl nab =
  minimalityInLowestTermsGcd p q bs e
    (atLeastAndNotAboveIsBoundary p q bs atl nab) pos

------------------------------------------------------------------------
-- 6.  So the population of the earlier module is minimal
--
-- Its length is suc q (that module), and every non-empty boundary
-- population has length at least suc q (§5), so its length is at most
-- theirs.
------------------------------------------------------------------------

popIsMinimal :
  (p q : ℕ) → p ≤ suc q → gcd p (suc q) ≡ 1
  → Σ[ bs ∈ List Bool ]
      ((length bs ≡ suc q) × (AtLeast p q bs) × (¬ Above p q bs)
       × ((cs : List Bool) → 1 ≤ length cs → AtLeast p q cs → ¬ Above p q cs
          → length bs ≤ length cs))
popIsMinimal p q p≤ e with everyThresholdHasABoundaryPopulation p q p≤
... | bs , len , atl , nab =
  bs , len , atl , nab ,
  λ cs pos atl' nab' →
    subst (_≤ length cs) (sym len)
      (minimalityOfABoundaryPopulation p q e cs pos atl' nab')

------------------------------------------------------------------------
-- 7.  The counterexample does not meet the hypothesis
--
-- 2 is a common divisor of 2 and 4, so if 1 were their gcd then 2 ∣ 1,
-- so 2 ≤ 1.  This is the pair (2 , 3) of the earlier module: suc 3 = 4.
------------------------------------------------------------------------

twoOverFourIsNotInLowestTerms : ¬ isGCD 2 (suc 3) 1
twoOverFourIsNotInLowestTerms (_ , greatest) =
  ¬-<-zero (pred-≤-pred two≤one)
  where
    two∣one : 2 ∣ 1
    two∣one = greatest 2 (∣-left 1 , ∣-left 2)

    two≤one : 2 ≤ 1
    two≤one = m∣n→m≤n snotz two∣one
