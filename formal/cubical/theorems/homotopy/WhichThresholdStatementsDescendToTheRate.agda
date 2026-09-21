{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- WhichThresholdStatementsDescendToTheRate
--
-- `MinimalityOfABoundaryPopulationNeedsLowestTerms` found that 2/4 and
-- 1/2 are the same RATE and different PAIRS, and that minimality holds
-- of one and fails of the other, and concluded:
--
--   "MINIMALITY IS NOT A PROPERTY OF THE RATE, only of the PAIR."
--
-- A separation without the other side is only half a result: it says
-- SOMETHING fails to descend, not WHICH things descend.  Both sides are
-- here.
--
-- â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”
-- `âŠ-trans` is
-- proved here, by the same multiplyâ“rearrangeâ“cancel that `âŠ`'s other
-- theorems use.
--
-- â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”
-- WHAT IS PROVED
--
--   âŠ-trans            transitivity
--   _â‰ˆ_                same rate = mutual âŠ; an equivalence relation
--   atLeastDescends    `AtLeast` is a property of the RATE
--   aboveDescends      so is `Above` â” both directions, both families
--   oneHalfIsTwoQuarters   (1,1) â‰ˆ (2,3), checked
--   minimalDoesNotDescend  and `den a â‰ length bs` is NOT, at that very
--                          pair
--
-- So the boundary is sharp and sits where the DENOMINATOR appears
-- alone.  `AtLeast` and `Above` mention p and suc q only inside a
-- product `p Â length â‰ suc q Â count`, which is exactly the shape âŠ
-- compares; minimality mentions `suc q` on its own, and `suc q` is not
-- a function of the rate.  That is the whole criterion, and it explains
-- rather than merely records the earlier separation.
------------------------------------------------------------------------

module WhichThresholdStatementsDescendToTheRate where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (â„• ; zero ; suc ; _Â·_)
open import Cubical.Data.Nat.Order using (_â‰¤_ ; â‰¤-refl ; â‰¤-trans ; â‰¤-Â·k)
open import Cubical.Data.Bool using (Bool ; true ; false)
open import Cubical.Data.List using (List ; [] ; _âˆ·_)
open import Cubical.Data.Sigma using (_Ã—_ ; _,_ ; fst ; snd)
open import Cubical.Relation.Nullary using (Â¬_)

open import RateOneIsExactlyTheUniversalClaim using (length)
open import TheThresholdOrderIsTotalAndTheClaimIsAntitone
  using (AtLeast ; _âŠ‘_ ; atLeastAntitone ; Â·sk-cancel-â‰¤ ; swapOuter)
open import TheStrictThresholdsAreTheSameChainAndDifferOnlyAtTheBoundary
  using (Above ; aboveAntitone)
open import MinimalityOfABoundaryPopulationNeedsLowestTerms
  using (short ; shortIsShorterThanTheDenominator)

------------------------------------------------------------------------
-- 1.  The law that was assumed and never proved
------------------------------------------------------------------------

âŠ‘-trans : (a b c : â„• Ã— â„•) â†’ a âŠ‘ b â†’ b âŠ‘ c â†’ a âŠ‘ c
âŠ‘-trans (p , q) (p' , q') (p'' , q'') h1 h2 = Â·sk-cancel-â‰¤ q' scaled
  where
    e1 : (p Â· suc q'') Â· suc q' â‰¡ (p Â· suc q') Â· suc q''
    e1 = swapOuter p (suc q'') (suc q')

    a2 : (p Â· suc q') Â· suc q'' â‰¤ (p' Â· suc q) Â· suc q''
    a2 = â‰¤-Â·k h1

    e3 : (p' Â· suc q) Â· suc q'' â‰¡ (p' Â· suc q'') Â· suc q
    e3 = swapOuter p' (suc q) (suc q'')

    a4 : (p' Â· suc q'') Â· suc q â‰¤ (p'' Â· suc q') Â· suc q
    a4 = â‰¤-Â·k h2

    e5 : (p'' Â· suc q') Â· suc q â‰¡ (p'' Â· suc q) Â· suc q'
    e5 = swapOuter p'' (suc q') (suc q)

    b2 : (p Â· suc q'') Â· suc q' â‰¤ (p' Â· suc q) Â· suc q''
    b2 = subst (_â‰¤ (p' Â· suc q) Â· suc q'') (sym e1) a2

    b3 : (p Â· suc q'') Â· suc q' â‰¤ (p' Â· suc q'') Â· suc q
    b3 = subst ((p Â· suc q'') Â· suc q' â‰¤_) e3 b2

    scaled : (p Â· suc q'') Â· suc q' â‰¤ (p'' Â· suc q) Â· suc q'
    scaled = subst ((p Â· suc q'') Â· suc q' â‰¤_) e5 (â‰¤-trans b3 a4)

------------------------------------------------------------------------
-- 2.  Same rate
------------------------------------------------------------------------

_â‰ˆ_ : â„• Ã— â„• â†’ â„• Ã— â„• â†’ Type
a â‰ˆ b = (a âŠ‘ b) Ã— (b âŠ‘ a)

â‰ˆ-refl : (a : â„• Ã— â„•) â†’ a â‰ˆ a
â‰ˆ-refl (p , q) = â‰¤-refl , â‰¤-refl

â‰ˆ-sym : (a b : â„• Ã— â„•) â†’ a â‰ˆ b â†’ b â‰ˆ a
â‰ˆ-sym a b (ab , ba) = ba , ab

â‰ˆ-trans : (a b c : â„• Ã— â„•) â†’ a â‰ˆ b â†’ b â‰ˆ c â†’ a â‰ˆ c
â‰ˆ-trans a b c (ab , ba) (bc , cb) =
  âŠ‘-trans a b c ab bc , âŠ‘-trans c b a cb ba

------------------------------------------------------------------------
-- 3.  Both claim families descend
--
-- Nothing new is needed: antitone in both directions IS descent.
------------------------------------------------------------------------

atLeastDescends :
  (a b : â„• Ã— â„•) â†’ a â‰ˆ b â†’ (bs : List Bool)
  â†’ (AtLeast (fst a) (snd a) bs â†’ AtLeast (fst b) (snd b) bs)
  Ã— (AtLeast (fst b) (snd b) bs â†’ AtLeast (fst a) (snd a) bs)
atLeastDescends (p , q) (p' , q') (ab , ba) bs =
    atLeastAntitone p' q' p q bs ba
  , atLeastAntitone p q p' q' bs ab

aboveDescends :
  (a b : â„• Ã— â„•) â†’ a â‰ˆ b â†’ (bs : List Bool)
  â†’ (Above (fst a) (snd a) bs â†’ Above (fst b) (snd b) bs)
  Ã— (Above (fst b) (snd b) bs â†’ Above (fst a) (snd a) bs)
aboveDescends (p , q) (p' , q') (ab , ba) bs =
    aboveAntitone p' q' p q bs ba
  , aboveAntitone p q p' q' bs ab

------------------------------------------------------------------------
-- 4.  And one statement that does not
--
-- `den` reads the denominator off the PAIR.  It is not a function of
-- the rate, and any statement mentioning it alone is not either.
------------------------------------------------------------------------

den : â„• Ã— â„• â†’ â„•
den (p , q) = suc q

Minimal : â„• Ã— â„• â†’ List Bool â†’ Type
Minimal a bs = den a â‰¤ length bs

oneHalf twoQuarters : â„• Ã— â„•
oneHalf     = 1 , 1
twoQuarters = 2 , 3

oneHalfIsTwoQuarters : oneHalf â‰ˆ twoQuarters
oneHalfIsTwoQuarters = â‰¤-refl , â‰¤-refl

shortIsMinimalAtOneHalf : Minimal oneHalf short
shortIsMinimalAtOneHalf = â‰¤-refl

shortIsNotMinimalAtTwoQuarters : Â¬ Minimal twoQuarters short
shortIsNotMinimalAtTwoQuarters = shortIsShorterThanTheDenominator

minimalDoesNotDescend :
  (oneHalf â‰ˆ twoQuarters)
  Ã— (Minimal oneHalf short)
  Ã— (Â¬ Minimal twoQuarters short)
minimalDoesNotDescend =
  oneHalfIsTwoQuarters , shortIsMinimalAtOneHalf ,
  shortIsNotMinimalAtTwoQuarters

------------------------------------------------------------------------
-- In `TheThresholdChainIsDenseAndTheMediantWitnessesIt`:
--
-- The chain is DENSE, and the witness is not found by a search: it is
-- the MEDIANT.  Between p/(suc q) and p'/(suc q') lies
--
--   (p + p') / (suc q + suc q')
--
-- and both halves of the betweenness reduce, after distributing, to the
-- SAME strict inequality that was assumed â” one is a left additive
-- shift of it and the other a right additive shift.  No case analysis.
-- The denominator needs no arithmetic either: `suc q + suc q'` IS
-- `suc (q + suc q')`, definitionally, so the mediant is visibly a
-- threshold pair.
--
-- `âŠ-gives-âŠ` is checked there too, so this is density OF THIS CHAIN
-- and not of a strict relation introduced for the occasion.
--
-- NO NOVELTY: the mediant's betweenness is classical â” the Farey
-- dissection (Haros 1802; Farey 1816) and the Sternâ“Brocot tree (Stern
-- 1858; Brocot 1861).
--
------------------------------------------------------------------------

------------------------------------------------------------------------
-- In `TheRateQuotientExistsAndMinimalityCannotLiveOnIt`:
--
--   Rate = (â• — â•) / _â‰ˆ_        the set-quotient
--   AtLeastOnRate / AboveOnRate both predicates LIFT, by
--                               `SetQuotients.rec`; Â§3 above is exactly
--                               the respectfulness the lift needs
--   atLeastOnRateComputes       the lift agrees with the old definition
--                               on representatives, by `refl`
--   noMinimalityOnTheRate       NO function on `Rate` agrees with
--                               `Minimal` on all representatives
--
-- THE LAST ONE IS STRONGER THAN Â§4 HERE.  Â§4 exhibits a pair where
-- minimality holds of one representative and fails of another, which
-- refutes ONE definition.  With the quotient, `[ oneHalf ] â‰¡
-- [ twoQuarters ]` is a PATH, `cong` transports along it, and no
-- definition whatsoever can agree with `Minimal` on both â” an
-- impossibility rather than an absence.
--
-- The univalence is in the lift's target: `hProp` is a set
-- (`isSetHProp`), and `â”toPath` turns the two-way implication Â§3 proves
-- into a PATH.  `AtLeast` is a proposition because cubical's `â‰` is, so
-- nothing needed truncating.
--
------------------------------------------------------------------------
