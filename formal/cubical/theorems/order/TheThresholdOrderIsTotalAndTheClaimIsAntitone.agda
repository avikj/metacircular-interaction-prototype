{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- TheThresholdOrderIsTotalAndTheClaimIsAntitone
--
-- Closes the item the previous cycle left open in its own words.
-- `MajorityLiesStrictlyBetweenAllAndSome` exhibited three claim-shapes
-- with two populations and then said:
--
--   "no threshold order is shown TOTAL over all fractions -- two
--    populations are two populations, not a chain -- and no fraction
--    other than 1/2 and 1 is analysed."
--
-- Both halves are answered here, and by the same move: stop exhibiting
-- populations and state the threshold family.  A rate claim at p/(suc q)
-- is
--
--   AtLeast p q bs  =  p Â length bs â‰ suc q Â count bs
--
-- -- no division, so nothing leaves â•, and the denominator is `suc q`
-- because a threshold with denominator zero is not a threshold.
--
-- â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”
-- WHAT IS PROVED
--
--   Âsk-cancel-â‰     a positive factor cancels on the right of â‰
--                    (cubical v0.5 ships â‰-Âk and <-Âsk but no
--                     cancellation; this derives it from splitâ•-â‰)
--   âŠ-total          ANY two thresholds are comparable, by cross
--                    multiplication -- the thresholds are a CHAIN
--   atLeastAntitone  and the claim is antitone along it: a lower
--                    threshold is implied by a higher one, for EVERY
--                    population at once
--   allIsThresholdOne / thresholdOneFromAll
--                    the universal claim is exactly the top element,
--                    1/1, of that chain
--
-- So the ordering the earlier module could only illustrate at two
-- points is now the statement itself: one theorem quantified over all
-- p, q, p', q' and all bs, not a pattern read off instances.  That is
-- the repository's own rule about generating the next term rather than
-- phrasing the claim more carefully -- here the "next term" is the
-- whole family, and having it makes the two-population illustration a
-- corollary rather than the evidence.
--
-- CHECKED on the CONTAINER (Agda 2.6.3, cubical v0.5 -- NOT the
-- declared pin, Agda 2.8.0 + cubical v0.9).  --safe, no postulates, no
-- holes.
------------------------------------------------------------------------

module TheThresholdOrderIsTotalAndTheClaimIsAntitone where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat
  using (â„• ; zero ; suc ; _Â·_ ; Â·-comm ; Â·-assoc ; Â·-identityË¡)
open import Cubical.Data.Nat.Order
  using (_â‰¤_ ; _<_ ; â‰¤-refl ; â‰¤-trans ; â‰¤-antisym ; â‰¤-Â·k ; <-Â·sk
        ; <-asym ; <-weaken ; splitâ„•-â‰¤)
open import Cubical.Data.Bool using (Bool ; true ; false)
open import Cubical.Data.List using (List ; [] ; _âˆ·_)
open import Cubical.Data.Sigma using (_Ã—_ ; _,_)
open import Cubical.Data.Sum using (_âŠŽ_ ; inl ; inr)
open import Cubical.Data.Empty as âŠ¥ using (âŠ¥)
open import RateOneIsExactlyTheUniversalClaim
  using (All ; count ; length ; countIsAtMostLength ; allGivesFullCount
        ; fullCountGivesAll)

------------------------------------------------------------------------
-- 1.  Two rearrangements, and the cancellation the library omits
------------------------------------------------------------------------

swapOuter : (a b c : â„•) â†’ (a Â· b) Â· c â‰¡ (a Â· c) Â· b
swapOuter a b c =
  sym (Â·-assoc a b c) âˆ™ cong (a Â·_) (Â·-comm b c) âˆ™ Â·-assoc a c b

swapEnds : (a b c : â„•) â†’ (a Â· b) Â· c â‰¡ (c Â· b) Â· a
swapEnds a b c =
  Â·-comm (a Â· b) c âˆ™ cong (c Â·_) (Â·-comm a b) âˆ™ Â·-assoc c b a

-- cubical v0.5's `Cubical.Data.Nat.Order` has â‰-Âk (multiply) and <-Âsk
-- (multiply, strictly, by a positive) but nothing that divides one out.
-- `splitâ•-â‰` supplies the missing case split; `<-asym` kills the wrong
-- branch.  This is the only place below where a decision is used, and
-- it is a decision about â•, not about the population.
Â·sk-cancel-â‰¤ : {m n : â„•} (k : â„•) â†’ m Â· suc k â‰¤ n Â· suc k â†’ m â‰¤ n
Â·sk-cancel-â‰¤ {m} {n} k h with splitâ„•-â‰¤ m n
... | inl p = p
... | inr q = âŠ¥.rec (<-asym (<-Â·sk q) h)

------------------------------------------------------------------------
-- 2.  The threshold family, and the order on thresholds
--
-- `AtLeast p q bs` says the success rate of bs is at least p/(suc q),
-- stated by cross multiplication so that no division and no rational
-- number is needed.
------------------------------------------------------------------------

AtLeast : â„• â†’ â„• â†’ List Bool â†’ Type
AtLeast p q bs = p Â· length bs â‰¤ suc q Â· count bs

-- (p , q) âŠ (p' , q') reads "p/(suc q) is no larger than p'/(suc q')",
-- again by cross multiplication.
_âŠ‘_ : â„• Ã— â„• â†’ â„• Ã— â„• â†’ Type
(p , q) âŠ‘ (p' , q') = p Â· suc q' â‰¤ p' Â· suc q

âŠ‘-refl : (a : â„• Ã— â„•) â†’ a âŠ‘ a
âŠ‘-refl (p , q) = â‰¤-refl

-- THE CHAIN.  Any two thresholds are comparable.  This is the sentence
-- the previous module could not say, and it needs no population at all.
âŠ‘-total : (a b : â„• Ã— â„•) â†’ (a âŠ‘ b) âŠŽ (b âŠ‘ a)
âŠ‘-total (p , q) (p' , q') with splitâ„•-â‰¤ (p Â· suc q') (p' Â· suc q)
... | inl h = inl h
... | inr h = inr (<-weaken h)

------------------------------------------------------------------------
-- 3.  The claim is antitone along the chain
--
-- Higher threshold â’ lower threshold, for EVERY population at once.
-- The proof multiplies the goal by the positive denominator `suc q'`,
-- rearranges twice, and cancels it again.
------------------------------------------------------------------------

atLeastAntitone :
  (p q p' q' : â„•) (bs : List Bool)
  â†’ (p , q) âŠ‘ (p' , q')
  â†’ AtLeast p' q' bs â†’ AtLeast p q bs
atLeastAntitone p q p' q' bs cross high =
  Â·sk-cancel-â‰¤ q' scaled
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

    a4 : (p' Â· L) Â· suc q â‰¤ (suc q' Â· C) Â· suc q
    a4 = â‰¤-Â·k high

    e5 : (suc q' Â· C) Â· suc q â‰¡ (suc q Â· C) Â· suc q'
    e5 = swapEnds (suc q') C (suc q)

    b2 : (p Â· L) Â· suc q' â‰¤ (p' Â· suc q) Â· L
    b2 = subst (_â‰¤ (p' Â· suc q) Â· L) (sym e1) a2

    b3 : (p Â· L) Â· suc q' â‰¤ (p' Â· L) Â· suc q
    b3 = subst ((p Â· L) Â· suc q' â‰¤_) e3 b2

    scaled : (p Â· L) Â· suc q' â‰¤ (suc q Â· C) Â· suc q'
    scaled = subst ((p Â· L) Â· suc q' â‰¤_) e5 (â‰¤-trans b3 a4)

------------------------------------------------------------------------
-- 4.  The top of the chain is the universal claim
--
-- `AtLeast 1 0` is the threshold 1/1.  Together with `countIsAtMostLength`
-- -- the fact that a rate is a rate -- it pins the count to the length,
-- which the earlier module already showed is the Î .
------------------------------------------------------------------------

allIsThresholdOne : (bs : List Bool) â†’ AtLeast 1 0 bs â†’ All bs
allIsThresholdOne bs h = fullCountGivesAll bs (sym lengthEqCount)
  where
    lengthLeCount : length bs â‰¤ count bs
    lengthLeCount =
      subst2 _â‰¤_ (Â·-identityË¡ (length bs)) (Â·-identityË¡ (count bs)) h

    lengthEqCount : length bs â‰¡ count bs
    lengthEqCount = â‰¤-antisym lengthLeCount (countIsAtMostLength bs)

thresholdOneFromAll : (bs : List Bool) â†’ All bs â†’ AtLeast 1 0 bs
thresholdOneFromAll bs a =
  subst2 _â‰¤_ (sym (Â·-identityË¡ (length bs))) (sym (Â·-identityË¡ (count bs)))
    (subst (length bs â‰¤_) (sym (allGivesFullCount bs a)) â‰¤-refl)

------------------------------------------------------------------------
-- 5.  What Â§3 and Â§4 give together
--
-- Every threshold p/(suc q) with (p , q) âŠ (1 , 0) is implied by the
-- universal claim, uniformly in the population: `atLeastAntitone`
-- applied to `thresholdOneFromAll`.  So the label is not a different
-- KIND of criterion from a rate criterion -- it is the maximum of a
-- chain that âŠ-total shows is a chain, and every weaker rate claim is
-- one instance of one theorem below it.
--
-- The converse direction is exactly what fails, and the previous
-- module's `majorityWithoutAll` is a witness that it fails: a
-- population at 2/3 satisfies every threshold âŠ (2 , 2) and refutes the
-- top.  Nothing here weakens that; Â§3 is one-directional by
-- construction.
------------------------------------------------------------------------

universalImpliesEveryLowerThreshold :
  (p q : â„•) (bs : List Bool)
  â†’ (p , q) âŠ‘ (1 , 0)
  â†’ All bs â†’ AtLeast p q bs
universalImpliesEveryLowerThreshold p q bs cross a =
  atLeastAntitone p q 1 0 bs cross (thresholdOneFromAll bs a)

------------------------------------------------------------------------
-- APPENDED 2026-08-19, by the same identity, at the end, altering no
-- line above.  The NOT-CLAIMED section says:
--
--   "STRICT thresholds (the `Majority` of the previous module is
--    strict: length < 2 Â count) are NOT in this family; `AtLeast 1 1`
--    is the non-strict 'at least half', which is weaker, and the
--    strict/non-strict gap is not analysed."
--
-- Analysed now, in
-- `TheStrictThresholdsAreTheSameChainAndDifferOnlyAtTheBoundary`
-- (--safe, no postulates, no holes; container green under Agda 2.6.3 +
-- cubical v0.5, NOT the declared pin â” check.sh returns 1 and says so).
--
--   Above p q bs = p Â length bs < suc q Â count bs
--
--   Âsk-cancel-<     the strict counterpart of Â§1's cancellation
--   aboveAntitone    the strict family is antitone along THE SAME âŠ
--   aboveGivesAtLeast     strict â’ non-strict at each threshold
--   majorityIsAboveHalf   the earlier `Majority` IS `Above 1 1`
--   atLeastWithoutAbove   and the converse fails, at one population
--
-- What that says about Â§2 is worth recording here, because it is a
-- property of the DEFINITION above rather than of the new module: `âŠ`
-- was stated on thresholds alone, with no population in it, so a second
-- claim-family over the same thresholds inherits `âŠ-total` for free.
-- There is no second order and no second totality theorem.  What
-- separates the two families is not their ordering but their verdict at
-- a population sitting exactly ON a threshold.
--
-- The gap between the families is therefore exactly the boundary, and
------------------------------------------------------------------------

------------------------------------------------------------------------
-- APPENDED 2026-08-19, by the same identity, at the end, altering no
-- line above.  THIS ONE IS A CORRECTION, not an extension.
--
-- Â§2 proves `âŠ-refl` and `âŠ-total` and stops.  Every note and commit
-- message downstream of it â” including this module's own commit â” has
-- called âŠ a "total preorder".  TRANSITIVITY WAS NEVER PROVED HERE.
-- Reflexive + total is not a preorder, and the word was doing work it
-- had not earned.
--
-- The law is now proved, in
-- `WhichThresholdStatementsDescendToTheRate`
-- (--safe, no postulates, no holes; container green under Agda 2.6.3 +
-- cubical v0.5, NOT the declared pin â” check.sh returns 1 and says so):
--
--   âŠ-trans : (a b c) â’ a âŠ b â’ b âŠ c â’ a âŠ c
--
-- by the same multiplyâ“rearrangeâ“cancel as Â§3's `atLeastAntitone`,
-- using `Âsk-cancel-â‰` and `swapOuter` from this module.  Nothing above
-- was wrong; something above was MISSING, and was being cited as
-- present.
--
-- With it, the same-rate relation `_â‰ˆ_ = mutual âŠ` is an equivalence
-- relation, and that module answers the standing question about the
-- missing quotient in both directions:
--
--   atLeastDescends / aboveDescends
--       `AtLeast` and `Above` are properties of the RATE â” antitone in
--       both directions IS descent, so nothing new was needed
--   minimalDoesNotDescend
--       `den a â‰ length bs` is not, at (1,1) â‰ˆ (2,3)
--
-- The boundary sits where the DENOMINATOR appears alone: Â§2's claims
-- mention p and suc q only inside a product of exactly the shape âŠ
-- compares, and minimality mentions suc q on its own.
--
------------------------------------------------------------------------
