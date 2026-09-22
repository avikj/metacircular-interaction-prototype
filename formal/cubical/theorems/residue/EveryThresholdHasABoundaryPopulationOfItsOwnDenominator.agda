{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- EveryThresholdHasABoundaryPopulationOfItsOwnDenominator
--
-- `TheStrictThresholdsAreTheSameChainAndDifferOnlyAtTheBoundary` showed
-- that the strict and non-strict families differ exactly at a
-- population sitting ON a threshold, exhibited ONE such population at
-- ONE threshold.  This module shows that EVERY threshold has such a
-- population.
--
-- It is a statement about â•, and there is no divisibility in it: the
-- denominator itself is the length.  For p â‰ suc q, the population of
-- p trues followed by (suc q âˆ p) falses has length exactly suc q and
-- count exactly p, so `p Â length â‰¡ suc q Â count` holds on the nose.
--
-- â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”
-- WHY THE STATEMENT CARRIES ITS LENGTH, and this is the whole care in
-- the module.  The EMPTY population satisfies `AtLeast p q` and refutes
-- `Above p q` for EVERY p and q, since `p Â 0 â‰¡ 0 â‰¡ suc q Â 0`.  So
-- "every threshold has a boundary population" is TRUE VACUOUSLY and
-- proving it that way would establish nothing about the gap between the
-- families.  The theorem below therefore returns the length as part of
-- the claim â” `length bs â‰¡ suc q`, hence at least one â” and the
-- vacuous witness does not satisfy it.  A Î whose interesting content
-- is omitted is the same defect as a figure quoted without its input.
--
-- â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”
-- WHAT IS PROVED
--
--   falses / pop           the population, by recursion on â•, never
--                          touching `Fin` or an index
--   countPop / lengthPop   count (pop p k) â‰¡ p, length (pop p k) â‰¡ p + k
--   boundaryEquation       p Â length â‰¡ suc q Â count, exactly
--   everyThresholdHasABoundaryPopulation
--                          for p â‰ suc q: a population of length suc q
--                          meeting the threshold and refuting the
--                          strict one
--
-- The hypothesis `p â‰ suc q` is what "a threshold" means here â” p/(suc
-- q) above 1 is not a rate any population can meet non-vacuously, since
-- `count â‰ length` is proved in `RateOneIsExactlyTheUniversalClaim`.
------------------------------------------------------------------------

module EveryThresholdHasABoundaryPopulationOfItsOwnDenominator where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat
  using (â„• ; zero ; suc ; _+_ ; _Â·_ ; +-comm ; Â·-comm ; 0â‰¡mÂ·0)
open import Cubical.Data.Nat.Order using (_â‰¤_ ; _<_ ; â‰¤-refl ; Â¬m<m)
open import Cubical.Data.Bool using (Bool ; true ; false)
open import Cubical.Data.List using (List ; [] ; _âˆ·_)
open import Cubical.Data.Sigma
open import Cubical.Relation.Nullary using (Â¬_)

open import RateOneIsExactlyTheUniversalClaim
  using (count ; length)
open import TheThresholdOrderIsTotalAndTheClaimIsAntitone
  using (AtLeast)
open import TheStrictThresholdsAreTheSameChainAndDifferOnlyAtTheBoundary
  using (Above)

------------------------------------------------------------------------
-- 1.  The population, by recursion on â•
------------------------------------------------------------------------

falses : â„• â†’ List Bool
falses zero    = []
falses (suc k) = false âˆ· falses k

pop : â„• â†’ â„• â†’ List Bool
pop zero    k = falses k
pop (suc p) k = true âˆ· pop p k

countFalses : (k : â„•) â†’ count (falses k) â‰¡ 0
countFalses zero    = refl
countFalses (suc k) = countFalses k

lengthFalses : (k : â„•) â†’ length (falses k) â‰¡ k
lengthFalses zero    = refl
lengthFalses (suc k) = cong suc (lengthFalses k)

countPop : (p k : â„•) â†’ count (pop p k) â‰¡ p
countPop zero    k = countFalses k
countPop (suc p) k = cong suc (countPop p k)

lengthPop : (p k : â„•) â†’ length (pop p k) â‰¡ p + k
lengthPop zero    k = lengthFalses k
lengthPop (suc p) k = cong suc (lengthPop p k)

------------------------------------------------------------------------
-- 2.  It sits exactly on the threshold
------------------------------------------------------------------------

boundaryEquation :
  (p q k : â„•) â†’ k + p â‰¡ suc q
  â†’ p Â· length (pop p k) â‰¡ suc q Â· count (pop p k)
boundaryEquation p q k eq =
    cong (p Â·_) (lengthPop p k)
  âˆ™ cong (p Â·_) (+-comm p k)
  âˆ™ cong (p Â·_) eq
  âˆ™ Â·-comm p (suc q)
  âˆ™ cong (suc q Â·_) (sym (countPop p k))

------------------------------------------------------------------------
-- 3.  Hence every threshold has one, of length its own denominator
--
-- cubical's `m â‰ n` IS `Î[ k ] k + m â‰¡ n`, so the hypothesis supplies
-- the number of falses directly â” no subtraction and no divisibility.
------------------------------------------------------------------------

everyThresholdHasABoundaryPopulation :
  (p q : â„•) â†’ p â‰¤ suc q
  â†’ Î£[ bs âˆˆ List Bool ]
      ((length bs â‰¡ suc q) Ã— (AtLeast p q bs) Ã— (Â¬ Above p q bs))
everyThresholdHasABoundaryPopulation p q (k , eq) =
  pop p k , (len , atl , nab)
  where
    eqn : p Â· length (pop p k) â‰¡ suc q Â· count (pop p k)
    eqn = boundaryEquation p q k eq

    len : length (pop p k) â‰¡ suc q
    len = lengthPop p k âˆ™ +-comm p k âˆ™ eq

    atl : AtLeast p q (pop p k)
    atl = subst (p Â· length (pop p k) â‰¤_) eqn â‰¤-refl

    nab : Â¬ Above p q (pop p k)
    nab h = Â¬m<m (subst (p Â· length (pop p k) <_) (sym eqn) h)

------------------------------------------------------------------------
-- 4.  The vacuous witness, stated so it cannot be mistaken for the
--     theorem
--
-- The empty population meets every threshold and refutes every strict
-- one.  Â§3 is not this, and the length component is what separates them.
------------------------------------------------------------------------

emptyMeetsEveryThreshold : (p q : â„•) â†’ AtLeast p q []
emptyMeetsEveryThreshold p q = subst2 _â‰¤_ (0â‰¡mÂ·0 p) (0â‰¡mÂ·0 (suc q)) â‰¤-refl

emptyIsAboveNoThreshold : (p q : â„•) â†’ Â¬ Above p q []
emptyIsAboveNoThreshold p q h =
  Â¬m<m (subst (p Â· 0 <_) (sym (0â‰¡mÂ·0 (suc q)) âˆ™ 0â‰¡mÂ·0 p) h)

------------------------------------------------------------------------
-- MINIMALITY.  Whether a boundary population SHORTER than suc q exists is the
-- divisibility question, settled in `MinimalityOfABoundaryPopulationNeedsLowestTerms`:
--   twoOverFourHasAShortBoundaryPopulation / soMinimalityFailsWithoutLowestTerms
--       at 2/4 the population `true âˆ false âˆ []` is a boundary
--       population â” 2 Â 2 â‰¡ 4 â‰¡ 4 Â 1 â” of length 2 < 4.
--
-- So "in lowest terms" is not a convenience.  Dropping it makes the
-- minimality statement FALSE, and `pop p k` above is then not minimal.
--
-- The positive half at numerator one:
--
--   boundaryDividesAtNumeratorOne   suc q âˆ length bs
--   minimalityAtNumeratorOne        hence suc q â‰ length bs, for a
--                                   non-empty boundary population
--
-- because at p = 1 there is nothing to cancel.
--
-- 2/4 and 1/2 are the same RATE and different PAIRS, and here the
-- quotient by rate has a visible consequence:
-- MINIMALITY IS NOT A PROPERTY OF THE RATE, only of the pair.
--
------------------------------------------------------------------------
