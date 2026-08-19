{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- NaturalMachine.TheThresholdOrderIsTotalAndTheClaimIsAntitone
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
--   AtLeast p q bs  =  p · length bs ≤ suc q · count bs
--
-- -- no division, so nothing leaves ℕ, and the denominator is `suc q`
-- because a threshold with denominator zero is not a threshold.
--
-- ────────────────────────────────────────────────────────────────────
-- WHAT IS PROVED
--
--   ·sk-cancel-≤     a positive factor cancels on the right of ≤
--                    (cubical v0.5 ships ≤-·k and <-·sk but no
--                     cancellation; this derives it from splitℕ-≤)
--   ⊑-total          ANY two thresholds are comparable, by cross
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
-- WHAT IS STILL NOT CLAIMED.  Antitone is proved, ANTI-SYMMETRY of ⊑ is
-- not, so `⊑` is a total PREORDER on pairs and not an order on rates:
-- (1,1) and (2,3) name the same rate 1/2 and are distinct pairs.
-- Nothing here quotients by that.  STRICT thresholds (the `Majority`
-- of the previous module is strict: length < 2 · count) are NOT in this
-- family; `AtLeast 1 1` is the non-strict "at least half", which is
-- weaker, and the strict/non-strict gap is not analysed.  No CONVERSE
-- to antitone is claimed and none holds: a population meeting a low
-- threshold need not meet a high one, which is the whole content of the
-- previous module's two populations.  The population is still a LIST,
-- so multiplicity is counted and order carried, and no claim here uses
-- the order.
--
-- CHECKED on the CONTAINER (Agda 2.6.3, cubical v0.5 -- NOT the
-- declared pin, Agda 2.8.0 + cubical v0.9).  --safe, no postulates, no
-- holes.
------------------------------------------------------------------------

module NaturalMachine.TheThresholdOrderIsTotalAndTheClaimIsAntitone where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat
  using (ℕ ; zero ; suc ; _·_ ; ·-comm ; ·-assoc ; ·-identityˡ)
open import Cubical.Data.Nat.Order
  using (_≤_ ; _<_ ; ≤-refl ; ≤-trans ; ≤-antisym ; ≤-·k ; <-·sk
        ; <-asym ; <-weaken ; splitℕ-≤)
open import Cubical.Data.Bool using (Bool ; true ; false)
open import Cubical.Data.List using (List ; [] ; _∷_)
open import Cubical.Data.Sigma using (_×_ ; _,_)
open import Cubical.Data.Sum using (_⊎_ ; inl ; inr)
open import Cubical.Data.Empty as ⊥ using (⊥)
open import NaturalMachine.RateOneIsExactlyTheUniversalClaim
  using (All ; count ; length ; countIsAtMostLength ; allGivesFullCount
        ; fullCountGivesAll)

------------------------------------------------------------------------
-- 1.  Two rearrangements, and the cancellation the library omits
------------------------------------------------------------------------

swapOuter : (a b c : ℕ) → (a · b) · c ≡ (a · c) · b
swapOuter a b c =
  sym (·-assoc a b c) ∙ cong (a ·_) (·-comm b c) ∙ ·-assoc a c b

swapEnds : (a b c : ℕ) → (a · b) · c ≡ (c · b) · a
swapEnds a b c =
  ·-comm (a · b) c ∙ cong (c ·_) (·-comm a b) ∙ ·-assoc c b a

-- cubical v0.5's `Cubical.Data.Nat.Order` has ≤-·k (multiply) and <-·sk
-- (multiply, strictly, by a positive) but nothing that divides one out.
-- `splitℕ-≤` supplies the missing case split; `<-asym` kills the wrong
-- branch.  This is the only place below where a decision is used, and
-- it is a decision about ℕ, not about the population.
·sk-cancel-≤ : {m n : ℕ} (k : ℕ) → m · suc k ≤ n · suc k → m ≤ n
·sk-cancel-≤ {m} {n} k h with splitℕ-≤ m n
... | inl p = p
... | inr q = ⊥.rec (<-asym (<-·sk q) h)

------------------------------------------------------------------------
-- 2.  The threshold family, and the order on thresholds
--
-- `AtLeast p q bs` says the success rate of bs is at least p/(suc q),
-- stated by cross multiplication so that no division and no rational
-- number is needed.
------------------------------------------------------------------------

AtLeast : ℕ → ℕ → List Bool → Type
AtLeast p q bs = p · length bs ≤ suc q · count bs

-- (p , q) ⊑ (p' , q') reads "p/(suc q) is no larger than p'/(suc q')",
-- again by cross multiplication.
_⊑_ : ℕ × ℕ → ℕ × ℕ → Type
(p , q) ⊑ (p' , q') = p · suc q' ≤ p' · suc q

⊑-refl : (a : ℕ × ℕ) → a ⊑ a
⊑-refl (p , q) = ≤-refl

-- THE CHAIN.  Any two thresholds are comparable.  This is the sentence
-- the previous module could not say, and it needs no population at all.
⊑-total : (a b : ℕ × ℕ) → (a ⊑ b) ⊎ (b ⊑ a)
⊑-total (p , q) (p' , q') with splitℕ-≤ (p · suc q') (p' · suc q)
... | inl h = inl h
... | inr h = inr (<-weaken h)

------------------------------------------------------------------------
-- 3.  The claim is antitone along the chain
--
-- Higher threshold ⇒ lower threshold, for EVERY population at once.
-- The proof multiplies the goal by the positive denominator `suc q'`,
-- rearranges twice, and cancels it again.
------------------------------------------------------------------------

atLeastAntitone :
  (p q p' q' : ℕ) (bs : List Bool)
  → (p , q) ⊑ (p' , q')
  → AtLeast p' q' bs → AtLeast p q bs
atLeastAntitone p q p' q' bs cross high =
  ·sk-cancel-≤ q' scaled
  where
    L C : ℕ
    L = length bs
    C = count bs

    e1 : (p · L) · suc q' ≡ (p · suc q') · L
    e1 = swapOuter p L (suc q')

    a2 : (p · suc q') · L ≤ (p' · suc q) · L
    a2 = ≤-·k cross

    e3 : (p' · suc q) · L ≡ (p' · L) · suc q
    e3 = swapOuter p' (suc q) L

    a4 : (p' · L) · suc q ≤ (suc q' · C) · suc q
    a4 = ≤-·k high

    e5 : (suc q' · C) · suc q ≡ (suc q · C) · suc q'
    e5 = swapEnds (suc q') C (suc q)

    b2 : (p · L) · suc q' ≤ (p' · suc q) · L
    b2 = subst (_≤ (p' · suc q) · L) (sym e1) a2

    b3 : (p · L) · suc q' ≤ (p' · L) · suc q
    b3 = subst ((p · L) · suc q' ≤_) e3 b2

    scaled : (p · L) · suc q' ≤ (suc q · C) · suc q'
    scaled = subst ((p · L) · suc q' ≤_) e5 (≤-trans b3 a4)

------------------------------------------------------------------------
-- 4.  The top of the chain is the universal claim
--
-- `AtLeast 1 0` is the threshold 1/1.  Together with `countIsAtMostLength`
-- -- the fact that a rate is a rate -- it pins the count to the length,
-- which the earlier module already showed is the Π.
------------------------------------------------------------------------

allIsThresholdOne : (bs : List Bool) → AtLeast 1 0 bs → All bs
allIsThresholdOne bs h = fullCountGivesAll bs (sym lengthEqCount)
  where
    lengthLeCount : length bs ≤ count bs
    lengthLeCount =
      subst2 _≤_ (·-identityˡ (length bs)) (·-identityˡ (count bs)) h

    lengthEqCount : length bs ≡ count bs
    lengthEqCount = ≤-antisym lengthLeCount (countIsAtMostLength bs)

thresholdOneFromAll : (bs : List Bool) → All bs → AtLeast 1 0 bs
thresholdOneFromAll bs a =
  subst2 _≤_ (sym (·-identityˡ (length bs))) (sym (·-identityˡ (count bs)))
    (subst (length bs ≤_) (sym (allGivesFullCount bs a)) ≤-refl)

------------------------------------------------------------------------
-- 5.  What §3 and §4 give together
--
-- Every threshold p/(suc q) with (p , q) ⊑ (1 , 0) is implied by the
-- universal claim, uniformly in the population: `atLeastAntitone`
-- applied to `thresholdOneFromAll`.  So the label is not a different
-- KIND of criterion from a rate criterion -- it is the maximum of a
-- chain that ⊑-total shows is a chain, and every weaker rate claim is
-- one instance of one theorem below it.
--
-- The converse direction is exactly what fails, and the previous
-- module's `majorityWithoutAll` is a witness that it fails: a
-- population at 2/3 satisfies every threshold ⊑ (2 , 2) and refutes the
-- top.  Nothing here weakens that; §3 is one-directional by
-- construction.
------------------------------------------------------------------------

universalImpliesEveryLowerThreshold :
  (p q : ℕ) (bs : List Bool)
  → (p , q) ⊑ (1 , 0)
  → All bs → AtLeast p q bs
universalImpliesEveryLowerThreshold p q bs cross a =
  atLeastAntitone p q 1 0 bs cross (thresholdOneFromAll bs a)

------------------------------------------------------------------------
-- APPENDED 2026-08-19, by the same identity, at the end, altering no
-- line above.  The NOT-CLAIMED section says:
--
--   "STRICT thresholds (the `Majority` of the previous module is
--    strict: length < 2 · count) are NOT in this family; `AtLeast 1 1`
--    is the non-strict 'at least half', which is weaker, and the
--    strict/non-strict gap is not analysed."
--
-- Analysed now, in
-- `NaturalMachine.TheStrictThresholdsAreTheSameChainAndDifferOnlyAtTheBoundary`
-- (--safe, no postulates, no holes; container green under Agda 2.6.3 +
-- cubical v0.5, NOT the declared pin — check.sh returns 1 and says so).
--
--   Above p q bs = p · length bs < suc q · count bs
--
--   ·sk-cancel-<     the strict counterpart of §1's cancellation
--   aboveAntitone    the strict family is antitone along THE SAME ⊑
--   aboveGivesAtLeast     strict ⇒ non-strict at each threshold
--   majorityIsAboveHalf   the earlier `Majority` IS `Above 1 1`
--   atLeastWithoutAbove   and the converse fails, at one population
--
-- What that says about §2 is worth recording here, because it is a
-- property of the DEFINITION above rather than of the new module: `⊑`
-- was stated on thresholds alone, with no population in it, so a second
-- claim-family over the same thresholds inherits `⊑-total` for free.
-- There is no second order and no second totality theorem.  What
-- separates the two families is not their ordering but their verdict at
-- a population sitting exactly ON a threshold.
--
-- The gap between the families is therefore exactly the boundary, and
-- STILL NOT CLAIMED there: that every threshold HAS such a boundary
-- population.  That is a divisibility statement about ℕ, not a
-- statement about lists, and it is untouched — as is density of ⊑, and
-- as is the quotient by equal rates, which §2's preorder still lacks.
------------------------------------------------------------------------

------------------------------------------------------------------------
-- APPENDED 2026-08-19, by the same identity, at the end, altering no
-- line above.  THIS ONE IS A CORRECTION, not an extension.
--
-- §2 proves `⊑-refl` and `⊑-total` and stops.  Every note and commit
-- message downstream of it — including this module's own commit — has
-- called ⊑ a "total preorder".  TRANSITIVITY WAS NEVER PROVED HERE.
-- Reflexive + total is not a preorder, and the word was doing work it
-- had not earned.
--
-- The law is now proved, in
-- `NaturalMachine.WhichThresholdStatementsDescendToTheRate`
-- (--safe, no postulates, no holes; container green under Agda 2.6.3 +
-- cubical v0.5, NOT the declared pin — check.sh returns 1 and says so):
--
--   ⊑-trans : (a b c) → a ⊑ b → b ⊑ c → a ⊑ c
--
-- by the same multiply–rearrange–cancel as §3's `atLeastAntitone`,
-- using `·sk-cancel-≤` and `swapOuter` from this module.  Nothing above
-- was wrong; something above was MISSING, and was being cited as
-- present.
--
-- With it, the same-rate relation `_≈_ = mutual ⊑` is an equivalence
-- relation, and that module answers the standing question about the
-- missing quotient in both directions:
--
--   atLeastDescends / aboveDescends
--       `AtLeast` and `Above` are properties of the RATE — antitone in
--       both directions IS descent, so nothing new was needed
--   minimalDoesNotDescend
--       `den a ≤ length bs` is not, at (1,1) ≈ (2,3)
--
-- The boundary sits where the DENOMINATOR appears alone: §2's claims
-- mention p and suc q only inside a product of exactly the shape ⊑
-- compares, and minimality mentions suc q on its own.
--
-- STILL NOT CLAIMED: no quotient TYPE is formed anywhere; `≈` is a
-- relation, with no set-quotient, no truncation and no univalence.  The
-- boundary criterion above is a reading of the proofs, not a theorem —
-- characterising the descending statements would need a language of
-- statements to quantify over, and there is none here.
------------------------------------------------------------------------
