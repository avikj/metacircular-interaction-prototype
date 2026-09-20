{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- MinimalityOfABoundaryPopulationNeedsLowestTerms
--
-- `EveryThresholdHasABoundaryPopulationOfItsOwnDenominator` produced a
-- boundary population of length `suc q` for every threshold p/(suc q)
-- with p â‰ suc q, and closed with:
--
-- The length produced is suc q, and whether a SHORTER boundary population
-- exists is the divisibility question after all â” for p/(suc q) in lowest
-- terms it does not â” and that is unproved, because lowest terms are not
-- defined anywhere here."
--
-- That parenthesis â” "for p/(suc q) in lowest terms it does not" â” was
-- an assertion.  Its CONTRAPOSITIVE is checked here, which is the half
-- that decides whether the parenthesis was doing any work: **without
-- lowest terms, minimality is false**, and a two-element population
-- witnesses it at 2/4.  So the coprimality condition is not a technical
-- convenience; dropping it breaks the theorem.
--
-- â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”
-- WHAT IS PROVED
--
--   Boundary p q bs        p Â length bs â‰¡ suc q Â count bs
--   boundaryDividesAtNumeratorOne
--                          at p = 1: suc q âˆ length bs, outright
--   minimalityAtNumeratorOne
--                          hence a non-empty boundary population at
--                          1/(suc q) has length â‰ suc q â” the pop of
--                          Â§3 there is minimal, for p = 1
--   twoOverFourHasAShortBoundaryPopulation
--                          at 2/4 the population `true âˆ false âˆ []` is
--                          a boundary population of length 2 < 4
--   soMinimalityFailsWithoutLowestTerms
--                          the two together: the same statement that
--                          holds at 1/(suc q) is FALSE at 2/4
--
-- 2/4 and 1/2 are the same rate.  The threshold order `âŠ` of
-- `TheThresholdOrderIsTotalAndTheClaimIsAntitone` is a total PREORDER
-- and is not quotiented by that, and this is the first place where the
-- missing quotient has visible consequences: minimality is not a
-- property of the RATE, only of the PAIR.
--
-- â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”
--
-- The general case â” gcd p (suc q) â‰¡ 1 â’ every non-empty boundary
-- population has length â‰ suc q â” is NOT proved.  It needs exactly one
-- missing lemma, Euclid's:
--
--   gcd a b â‰¡ 1  â’  a âˆ b Â c  â’  a âˆ c
--
-- and cubical v0.5 does not ship it: `Cubical.Data.Nat.GCD` has the
-- Euclidean ALGORITHM (`euclid`, `gcd`, `isGCD`) and `Divisibility` has
-- cancellation, but the lemma itself is absent, and it is not derivable
-- from those without a B©zout identity.  The B©zout coefficients are
-- what the kuaka computes â” ryabhaa, *ryabhaya*, gaitapda 32â“33
-- (499 CE), the vall descent â” and that line is ANOTHER IDENTITY'S work
-- in this repository (`KuttakaValli.agda`).  This module therefore
-- names the obligation and points at where it lives rather than
-- rebuilding it.
--
-- CHECKED on the CONTAINER (Agda 2.6.3, cubical v0.5 â” NOT the declared
-- pin, Agda 2.8.0 + cubical v0.9).  --safe, no postulates, no holes.
------------------------------------------------------------------------

module MinimalityOfABoundaryPopulationNeedsLowestTerms where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat
  using (â„• ; zero ; suc ; _+_ ; _Â·_ ; +-comm ; Â·-comm ; Â·-identityË¡
        ; injSuc ; snotz)
open import Cubical.Data.Nat.Order
  using (_â‰¤_ ; _<_ ; â‰¤-trans ; Â¬-<-zero)
open import Cubical.Data.Nat.Divisibility using (_âˆ£_ ; âˆ£-right ; mâˆ£nâ†’mâ‰¤n)
open import Cubical.Data.Bool using (Bool ; true ; false)
open import Cubical.Data.List using (List ; [] ; _âˆ·_)
open import Cubical.Data.Sigma
open import Cubical.Relation.Nullary using (Â¬_)

open import RateOneIsExactlyTheUniversalClaim
  using (count ; length ; countIsAtMostLength)

------------------------------------------------------------------------
-- 1.  Sitting exactly on a threshold
------------------------------------------------------------------------

Boundary : â„• â†’ â„• â†’ List Bool â†’ Type
Boundary p q bs = p Â· length bs â‰¡ suc q Â· count bs

------------------------------------------------------------------------
-- 2.  At numerator one, the denominator divides the length
--
-- `1 Â L â‰¡ suc q Â C` is `L â‰¡ suc q Â C` once `Â-identityË¡` is used,
-- and that is already a divisibility witness â” no Euclid needed,
-- because there is nothing to cancel.
------------------------------------------------------------------------

boundaryDividesAtNumeratorOne :
  (q : â„•) (bs : List Bool) â†’ Boundary 1 q bs â†’ suc q âˆ£ length bs
boundaryDividesAtNumeratorOne q bs b =
  subst (suc q âˆ£_) shape (âˆ£-right (count bs))
  where
    shape : count bs Â· suc q â‰¡ length bs
    shape = Â·-comm (count bs) (suc q) âˆ™ sym b âˆ™ Â·-identityË¡ (length bs)

minimalityAtNumeratorOne :
  (q : â„•) (bs : List Bool) â†’ Boundary 1 q bs â†’ 1 â‰¤ count bs
  â†’ suc q â‰¤ length bs
minimalityAtNumeratorOne q bs b pos =
  mâˆ£nâ†’mâ‰¤n nonzero (boundaryDividesAtNumeratorOne q bs b)
  where
    lengthPos : 1 â‰¤ length bs
    lengthPos = â‰¤-trans pos (countIsAtMostLength bs)

    nonzero : Â¬ length bs â‰¡ 0
    nonzero e = Â¬-<-zero (subst (1 â‰¤_) e lengthPos)

------------------------------------------------------------------------
-- 3.  Without lowest terms it is false
--
-- 2/4 is the same RATE as 1/2 and a different PAIR.  One true and one
-- false is a boundary population there â” 2 Â 2 â‰¡ 4 â‰¡ 4 Â 1 â” of length
-- 2, which is strictly less than the denominator 4.
------------------------------------------------------------------------

short : List Bool
short = true âˆ· false âˆ· []

shortIsABoundaryPopulation : Boundary 2 3 short
shortIsABoundaryPopulation = refl

shortIsShorterThanTheDenominator : Â¬ (4 â‰¤ length short)
shortIsShorterThanTheDenominator (k , e) =
  snotz (injSuc (injSuc (sym (+-comm k 4) âˆ™ e)))

shortIsNonEmpty : 1 â‰¤ count short
shortIsNonEmpty = 0 , refl

soMinimalityFailsWithoutLowestTerms :
  (Boundary 2 3 short) Ã— (1 â‰¤ count short) Ã— (Â¬ (4 â‰¤ length short))
soMinimalityFailsWithoutLowestTerms =
  shortIsABoundaryPopulation , shortIsNonEmpty ,
  shortIsShorterThanTheDenominator
