{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- Laghutama_InLowestTermsEveryNonEmptyBoundaryPopulationIsAtLeastAsLongAsItsDenominator
--
-- `MinimalityOfABoundaryPopulationNeedsLowestTerms` proved minimality
-- of a boundary population at numerator one and refuted it at 2/4.
-- This module proves the general case.  Euclid's lemma comes from
-- `WalkJumps.coprime-cancel : isGCD a b 1 â’ a âˆ b Â c â’ a âˆ c`, proved
-- there from `gcd-factorÊ³` (gcd (aÂc) (bÂc) â‰¡ gcd a b Â c) and the
-- universal property of the gcd.
--
-- â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”
-- WHAT IS PROVED  (Boundary p q bs is `p Â length bs â‰¡ suc q Â count bs`,
-- imported from the earlier module, not restated)
--
--   isGCD-sym                isGCD m n d â’ isGCD n m d
--   boundaryGivesDivisibility
--                            Boundary p q bs â’ suc q âˆ p Â length bs
--   boundaryDividesInLowestTerms
--                            isGCD p (suc q) 1 â’ Boundary p q bs
--                            â’ suc q âˆ length bs            (Euclid)
--   minimalityInLowestTerms  isGCD p (suc q) 1 â’ Boundary p q bs
--                            â’ 1 â‰ length bs â’ suc q â‰ length bs
--   minimalityInLowestTermsGcd
--                            the same with the hypothesis in the
--                            form gcd p (suc q) â‰¡ 1
--   minimalityInLowestTermsCount
--                            the same with `1 â‰ count bs`, the
--                            non-emptiness hypothesis the earlier
--                            module used at p = 1
--   atLeastAndNotAboveIsBoundary
--                            AtLeast p q bs â’ Â Above p q bs
--                            â’ Boundary p q bs
--   minimalityOfABoundaryPopulation
--                            in the exact terms of
--                            `everyThresholdHasABoundaryPopulation`:
--                            gcd p (suc q) â‰¡ 1, 1 â‰ length bs,
--                            AtLeast p q bs, Â Above p q bs
--                            â’ suc q â‰ length bs
--   popIsMinimal             for p â‰ suc q with gcd p (suc q) â‰¡ 1, the
--                            population of the earlier module has length
--                            suc q AND no non-empty boundary population
--                            is shorter
--   twoOverFourIsNotInLowestTerms
--                            Â isGCD 2 4 1 â” so the counterexample of
--                            the earlier module does not meet the
--                            hypothesis, as it must not
--
-- Non-emptiness is `1 â‰ length bs` throughout, which is WEAKER than the
-- `1 â‰ count bs` of the earlier module (count â‰ length); the count form
-- is derived from it.  The empty population is a boundary population
-- of length 0 at every threshold and is excluded by exactly that
-- hypothesis, as before.
--
-- â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”
-- THE SCOPE, EXACTLY.  Nothing here says which lengths ARE achievable:
-- `popIsMinimal` says suc q is achieved and nothing non-empty is
-- shorter, not that every multiple of suc q is achieved or that only
-- multiples are (the latter is `boundaryDividesInLowestTerms`, and
-- the former is not claimed).  Nothing is quotiented: `gcd p (suc q)
-- â‰¡ 1` is a property of the PAIR, and 2/4 still fails where 1/2
-- succeeds â” that is `twoOverFourIsNotInLowestTerms` next to
-- `minimalityInLowestTermsGcd`, not a contradiction.  No B©zout
-- identity is used or proved; `coprime-cancel` does not need one.
--
------------------------------------------------------------------------

module Laghutama_InLowestTermsEveryNonEmptyBoundaryPopulationIsAtLeastAsLongAsItsDenominator where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat
  using (â„• ; zero ; suc ; _+_ ; _Â·_ ; Â·-comm ; snotz)
open import Cubical.Data.Nat.Order
  using (_â‰¤_ ; _<_ ; â‰¤-trans ; Â¬-<-zero ; â‰¤-split ; pred-â‰¤-pred)
open import Cubical.Data.Nat.Divisibility
  using (_âˆ£_ ; âˆ£-right ; âˆ£-left ; mâˆ£nâ†’mâ‰¤n)
open import Cubical.Data.Nat.GCD
  using (gcd ; isGCD ; symCD ; gcdâ‰¡â†’isGCD)
open import Cubical.Data.Bool using (Bool)
open import Cubical.Data.List using (List)
open import Cubical.Data.Sigma
open import Cubical.Data.Sum using (inl ; inr)
open import Cubical.Data.Empty as âŠ¥ using ()
open import Cubical.Relation.Nullary using (Â¬_)

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
-- gets cancelled through, i.e. `isGCD (suc q) p 1`; the theorem
-- statement has `gcd p (suc q)`.  `symCD` is in the library, the
-- greatest-part is one line on top of it.
------------------------------------------------------------------------

isGCD-sym : (m n d : â„•) â†’ isGCD m n d â†’ isGCD n m d
isGCD-sym m n d (cd , greatest) =
  symCD cd , Î» d' cd' â†’ greatest d' (symCD cd')

------------------------------------------------------------------------
-- 2.  A boundary population's length, scaled by p, is a multiple of
--     the denominator â” this is the equation read as a witness
------------------------------------------------------------------------

boundaryGivesDivisibility :
  (p q : â„•) (bs : List Bool) â†’ Boundary p q bs â†’ suc q âˆ£ (p Â· length bs)
boundaryGivesDivisibility p q bs b =
  subst (suc q âˆ£_) shape (âˆ£-right (count bs))
  where
    shape : count bs Â· suc q â‰¡ p Â· length bs
    shape = Â·-comm (count bs) (suc q) âˆ™ sym b

------------------------------------------------------------------------
-- 3.  Euclid cancels the numerator
------------------------------------------------------------------------

boundaryDividesInLowestTerms :
  (p q : â„•) (bs : List Bool) â†’ isGCD p (suc q) 1 â†’ Boundary p q bs
  â†’ suc q âˆ£ length bs
boundaryDividesInLowestTerms p q bs g b =
  coprime-cancel (suc q) p (length bs)
    (isGCD-sym p (suc q) 1 g)
    (boundaryGivesDivisibility p q bs b)

------------------------------------------------------------------------
-- 4.  Hence minimality: a divisor of a positive number is at most it
------------------------------------------------------------------------

minimalityInLowestTerms :
  (p q : â„•) (bs : List Bool) â†’ isGCD p (suc q) 1 â†’ Boundary p q bs
  â†’ 1 â‰¤ length bs â†’ suc q â‰¤ length bs
minimalityInLowestTerms p q bs g b pos =
  mâˆ£nâ†’mâ‰¤n nonzero (boundaryDividesInLowestTerms p q bs g b)
  where
    nonzero : Â¬ length bs â‰¡ 0
    nonzero e = Â¬-<-zero (subst (1 â‰¤_) e pos)

-- The hypothesis as an equation on the gcd.
minimalityInLowestTermsGcd :
  (p q : â„•) (bs : List Bool) â†’ gcd p (suc q) â‰¡ 1 â†’ Boundary p q bs
  â†’ 1 â‰¤ length bs â†’ suc q â‰¤ length bs
minimalityInLowestTermsGcd p q bs e =
  minimalityInLowestTerms p q bs (gcdâ‰¡â†’isGCD e)

-- Non-emptiness as the earlier module phrased it at p = 1.
minimalityInLowestTermsCount :
  (p q : â„•) (bs : List Bool) â†’ gcd p (suc q) â‰¡ 1 â†’ Boundary p q bs
  â†’ 1 â‰¤ count bs â†’ suc q â‰¤ length bs
minimalityInLowestTermsCount p q bs e b pos =
  minimalityInLowestTermsGcd p q bs e b
    (â‰¤-trans pos (countIsAtMostLength bs))

------------------------------------------------------------------------
-- 5.  In the terms of `everyThresholdHasABoundaryPopulation`
--
-- That theorem delivers `AtLeast p q bs — Â Above p q bs`, i.e.
-- `p Â length â‰ suc q Â count` and `Â (p Â length < suc q Â count)`.
-- `â‰-split` turns the pair into the equation.
------------------------------------------------------------------------

atLeastAndNotAboveIsBoundary :
  (p q : â„•) (bs : List Bool) â†’ AtLeast p q bs â†’ Â¬ Above p q bs
  â†’ Boundary p q bs
atLeastAndNotAboveIsBoundary p q bs atl nab with â‰¤-split atl
... | inl lt = âŠ¥.rec (nab lt)
... | inr eq = eq

minimalityOfABoundaryPopulation :
  (p q : â„•) â†’ gcd p (suc q) â‰¡ 1
  â†’ (bs : List Bool) â†’ 1 â‰¤ length bs â†’ AtLeast p q bs â†’ Â¬ Above p q bs
  â†’ suc q â‰¤ length bs
minimalityOfABoundaryPopulation p q e bs pos atl nab =
  minimalityInLowestTermsGcd p q bs e
    (atLeastAndNotAboveIsBoundary p q bs atl nab) pos

------------------------------------------------------------------------
-- 6.  So the population of the earlier module is minimal
--
-- Its length is suc q (that module), and every non-empty boundary
-- population has length at least suc q (Â§5), so its length is at most
-- theirs.
------------------------------------------------------------------------

popIsMinimal :
  (p q : â„•) â†’ p â‰¤ suc q â†’ gcd p (suc q) â‰¡ 1
  â†’ Î£[ bs âˆˆ List Bool ]
      ((length bs â‰¡ suc q) Ã— (AtLeast p q bs) Ã— (Â¬ Above p q bs)
       Ã— ((cs : List Bool) â†’ 1 â‰¤ length cs â†’ AtLeast p q cs â†’ Â¬ Above p q cs
          â†’ length bs â‰¤ length cs))
popIsMinimal p q pâ‰¤ e with everyThresholdHasABoundaryPopulation p q pâ‰¤
... | bs , len , atl , nab =
  bs , len , atl , nab ,
  Î» cs pos atl' nab' â†’
    subst (_â‰¤ length cs) (sym len)
      (minimalityOfABoundaryPopulation p q e cs pos atl' nab')

------------------------------------------------------------------------
-- 7.  The counterexample does not meet the hypothesis
--
-- 2 is a common divisor of 2 and 4, so if 1 were their gcd then 2 âˆ 1,
-- so 2 â‰ 1.  This is the pair (2 , 3) of the earlier module: suc 3 = 4.
------------------------------------------------------------------------

twoOverFourIsNotInLowestTerms : Â¬ isGCD 2 (suc 3) 1
twoOverFourIsNotInLowestTerms (_ , greatest) =
  Â¬-<-zero (pred-â‰¤-pred twoâ‰¤one)
  where
    twoâˆ£one : 2 âˆ£ 1
    twoâˆ£one = greatest 2 (âˆ£-left 1 , âˆ£-left 2)

    twoâ‰¤one : 2 â‰¤ 1
    twoâ‰¤one = mâˆ£nâ†’mâ‰¤n snotz twoâˆ£one
