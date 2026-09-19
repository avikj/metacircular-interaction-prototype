{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- TheStrictThresholdsAreTheSameChainAndDifferOnlyAtTheBoundary
--
-- Closes the item the previous cycle opened in its own words, in
-- `TheThresholdOrderIsTotalAndTheClaimIsAntitone`:
--
--   "STRICT thresholds (the `Majority` of the previous module is
--    strict: length < 2 Â count) are NOT in this family; `AtLeast 1 1`
--    is the non-strict 'at least half', which is weaker, and the
--    strict/non-strict gap is not analysed."
--
-- The gap is analysed here, and it is exactly one point.
--
--   Above p q bs  =  p Â length bs < suc q Â count bs
--
-- â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”
-- WHAT IS PROVED
--
--   Âsk-cancel-<     the strict counterpart of last cycle's
--                    Âsk-cancel-â‰, from splitâ•-< + <-asym + â‰-Âk
--   aboveAntitone    the STRICT family is antitone along the SAME âŠ â”
--                    so `âŠ-total` orders it too, with no second order
--                    and no second totality proof
--   aboveGivesAtLeast     strict â’ non-strict, at each threshold
--   majorityIsAboveHalf / aboveHalfIsMajority
--                    the earlier module's `Majority` IS `Above 1 1`,
--                    definitionally up to `1 Â n â‰¡ n`
--   atLeastWithoutAbove   and the converse of the third fails, at a
--                    population sitting exactly ON the threshold
--
-- The shape of the answer is worth naming because it is not the shape
-- the question invited.  "Two families" would have needed a second
-- order, a second totality theorem, and a comparison between the two
-- orders.  There is one order: âŠ is stated on thresholds alone, with no
-- population in it, so a second claim-family over the same thresholds
-- inherits it for free.  What distinguishes the families is not their
-- ordering but their behaviour at a single population per threshold â”
-- the one that meets it exactly.
--
-- CHECKED on the CONTAINER (Agda 2.6.3, cubical v0.5 â” NOT the declared
-- pin, Agda 2.8.0 + cubical v0.9).  --safe, no postulates, no holes.
------------------------------------------------------------------------

module TheStrictThresholdsAreTheSameChainAndDifferOnlyAtTheBoundary where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat
  using (â„• ; zero ; suc ; _Â·_ ; Â·-comm ; Â·-assoc ; Â·-identityË¡)
open import Cubical.Data.Nat.Order
  using (_â‰¤_ ; _<_ ; â‰¤-refl ; â‰¤-Â·k ; <-Â·sk ; <-asym ; <-weaken
        ; â‰¤<-trans ; Â¬m<m ; splitâ„•-<)
open import Cubical.Data.Bool using (Bool ; true ; false)
open import Cubical.Data.List using (List ; [] ; _âˆ·_)
open import Cubical.Data.Sigma using (_Ã—_ ; _,_)
open import Cubical.Data.Sum using (_âŠŽ_ ; inl ; inr)
open import Cubical.Data.Empty as âŠ¥ using (âŠ¥)
open import Cubical.Relation.Nullary using (Â¬_)

open import RateOneIsExactlyTheUniversalClaim
  using (count ; length)
open import MajorityLiesStrictlyBetweenAllAndSome
  using (Majority)
open import TheThresholdOrderIsTotalAndTheClaimIsAntitone
  using (AtLeast ; _âŠ‘_ ; swapOuter ; swapEnds)

------------------------------------------------------------------------
-- 1.  Strict cancellation
--
-- Last cycle needed `m Â suc k â‰ n Â suc k â’ m â‰ n` and derived it,
-- cubical v0.5 having no such lemma.  The strict version is the same
-- argument with the branches exchanged: `splitâ•-<` supplies the case
-- split, and the wrong branch dies because â‰-Âk turns `n â‰ m` into a
-- contradiction with the strict hypothesis.
------------------------------------------------------------------------

Â·sk-cancel-< : {m n : â„•} (k : â„•) â†’ m Â· suc k < n Â· suc k â†’ m < n
Â·sk-cancel-< {m} {n} k h with splitâ„•-< m n
... | inl p = p
... | inr q = âŠ¥.rec (<-asym h (â‰¤-Â·k q))

------------------------------------------------------------------------
-- 2.  The strict claim family, on the SAME thresholds
------------------------------------------------------------------------

Above : â„• â†’ â„• â†’ List Bool â†’ Type
Above p q bs = p Â· length bs < suc q Â· count bs

aboveGivesAtLeast : (p q : â„•) (bs : List Bool) â†’ Above p q bs â†’ AtLeast p q bs
aboveGivesAtLeast p q bs = <-weaken

------------------------------------------------------------------------
-- 3.  Antitone along âŠ â” the same order, no second totality proof
--
-- Identical scaffolding to `atLeastAntitone`: multiply by the positive
-- denominator suc q', rearrange twice, cancel it again.  The only
-- change is that the second step is `<-Âsk` rather than `â‰-Âk`, and the
-- two are stitched with `â‰<-trans`.
------------------------------------------------------------------------

aboveAntitone :
  (p q p' q' : â„•) (bs : List Bool)
  â†’ (p , q) âŠ‘ (p' , q')
  â†’ Above p' q' bs â†’ Above p q bs
aboveAntitone p q p' q' bs cross high =
  Â·sk-cancel-< q' scaled
  where
    L C : â„•
    L = length bs
    C = count bs

    e1 : (p Â· L) Â· suc q' â‰¡ (p Â· suc q') Â· L
    e1 = swapOuter p L (suc q')

    a2 : (p Â· suc q') Â· L â‰¤ (p' Â· suc q) Â· L
    a2 = â‰¤-Â·k cross

    e3 : (p' Â· suc q) Â· L â‰¡ (p' Â· L) Â· suc q
    e3 = swapOuter p' (suc q) L

    s4 : (p' Â· L) Â· suc q < (suc q' Â· C) Â· suc q
    s4 = <-Â·sk high

    e5 : (suc q' Â· C) Â· suc q â‰¡ (suc q Â· C) Â· suc q'
    e5 = swapEnds (suc q') C (suc q)

    b2 : (p Â· L) Â· suc q' â‰¤ (p' Â· suc q) Â· L
    b2 = subst (_â‰¤ (p' Â· suc q) Â· L) (sym e1) a2

    b3 : (p Â· L) Â· suc q' â‰¤ (p' Â· L) Â· suc q
    b3 = subst ((p Â· L) Â· suc q' â‰¤_) e3 b2

    scaled : (p Â· L) Â· suc q' < (suc q Â· C) Â· suc q'
    scaled = subst ((p Â· L) Â· suc q' <_) e5 (â‰¤<-trans b3 s4)

------------------------------------------------------------------------
-- 4.  `Majority` was already a member of this family
--
-- The earlier module wrote `Majority bs = length bs < 2 Â count bs` and
-- did not connect it to any threshold.  It is `Above 1 1`, and the only
-- thing between the two statements is that `1 Â n` is not definitionally
-- `n` in cubical's â•.
------------------------------------------------------------------------

majorityIsAboveHalf : (bs : List Bool) â†’ Majority bs â†’ Above 1 1 bs
majorityIsAboveHalf bs = subst (_< 2 Â· count bs) (sym (Â·-identityË¡ (length bs)))

aboveHalfIsMajority : (bs : List Bool) â†’ Above 1 1 bs â†’ Majority bs
aboveHalfIsMajority bs = subst (_< 2 Â· count bs) (Â·-identityË¡ (length bs))

------------------------------------------------------------------------
-- 5.  The gap: a population exactly ON the threshold
--
-- One `true`, one `false`: the rate is exactly 1/2, so the non-strict
-- claim at 1/2 holds and the strict one does not.  This is the whole
-- difference between the families â” not a different order, a different
-- verdict at the boundary.
------------------------------------------------------------------------

onTheBoundary : List Bool
onTheBoundary = true âˆ· false âˆ· []

boundaryMeetsHalf : AtLeast 1 1 onTheBoundary
boundaryMeetsHalf = â‰¤-refl

boundaryIsNotAboveHalf : Â¬ Above 1 1 onTheBoundary
boundaryIsNotAboveHalf = Â¬m<m

atLeastWithoutAbove :
  (AtLeast 1 1 onTheBoundary) Ã— (Â¬ Above 1 1 onTheBoundary)
atLeastWithoutAbove = boundaryMeetsHalf , boundaryIsNotAboveHalf

------------------------------------------------------------------------
-- APPENDED 2026-08-19, by the same identity, at the end, altering no
-- line above.  The NOT-CLAIMED section says:
--
--   "that every threshold has such a population is NOT proved, and
--    would need a construction of a population realising an arbitrary
--    p/(suc q), which is a divisibility statement about â• and not a
--    statement about lists."
--
-- Proved now, in
-- `EveryThresholdHasABoundaryPopulationOfItsOwnDenominator`
-- (--safe, no postulates, no holes; container green under Agda 2.6.3 +
-- cubical v0.5, NOT the declared pin â” check.sh returns 1 and says so).
--
-- It is a statement about â•, and the guess that divisibility enters it
-- was wrong: the DENOMINATOR IS THE LENGTH.  For p â‰ suc q the
-- population `pop p k` â” p trues then k falses, where cubical's `â‰`
-- hands over the k with `k + p â‰¡ suc q` â” has length exactly suc q and
-- count exactly p, so `p Â length â‰¡ suc q Â count` on the nose.  No
-- subtraction, no gcd, no lowest terms.
--
-- One thing the earlier statement did not notice and the new module
-- makes load-bearing: the EMPTY population meets every threshold and
-- refutes every strict one, since `p Â 0 â‰¡ 0 â‰¡ suc q Â 0`.  So the
-- sentence quoted above is TRUE VACUOUSLY as stated, and a proof of it
-- in that form would say nothing about the gap between the families.
-- The new theorem therefore returns `length bs â‰¡ suc q` as part of the
-- claim, which the empty witness fails.  `emptyMeetsEveryThreshold` and
-- `emptyIsAboveNoThreshold` are checked there too, precisely so the
-- vacuous reading cannot be mistaken for the theorem.
--
------------------------------------------------------------------------
