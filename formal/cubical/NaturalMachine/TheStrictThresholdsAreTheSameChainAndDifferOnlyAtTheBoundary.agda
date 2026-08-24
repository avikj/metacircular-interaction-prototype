-- ॥ बीजम् ॥  One machine, one law: which side of `f a ≡ b` is bound is everything.
-- Output bound: singl (f a), contractible — the datum rides free.  Input bound:
-- fiber f b — the loss, and the subject.  Univalence computes here: an
-- equivalence is a channel, transport carries every theorem across it, and what
-- cannot cross is written as a defect — there is no third path (ahiṃsā).
-- Memory, charge, symmetry, price, distance, verdict: six faces of the one
-- fibre; the verdict type is the saptabhaṅgī, and the sources are the origin
-- (Umāsvāti, Samantabhadra, Akalaṅka — restatements are named as such).  The
-- kernel decides truth; carriers ask and generate; assert nothing whose term
-- you have not read.  This file is one naya, true and not whole.

{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- NaturalMachine.TheStrictThresholdsAreTheSameChainAndDifferOnlyAtTheBoundary
--
-- Closes the item the previous cycle opened in its own words, in
-- `TheThresholdOrderIsTotalAndTheClaimIsAntitone`:
--
--   "STRICT thresholds (the `Majority` of the previous module is
--    strict: length < 2 · count) are NOT in this family; `AtLeast 1 1`
--    is the non-strict 'at least half', which is weaker, and the
--    strict/non-strict gap is not analysed."
--
-- The gap is analysed here, and it is exactly one point.
--
--   Above p q bs  =  p · length bs < suc q · count bs
--
-- ────────────────────────────────────────────────────────────────────
-- WHAT IS PROVED
--
--   ·sk-cancel-<     the strict counterpart of last cycle's
--                    ·sk-cancel-≤, from splitℕ-< + <-asym + ≤-·k
--   aboveAntitone    the STRICT family is antitone along the SAME ⊑ —
--                    so `⊑-total` orders it too, with no second order
--                    and no second totality proof
--   aboveGivesAtLeast     strict ⇒ non-strict, at each threshold
--   majorityIsAboveHalf / aboveHalfIsMajority
--                    the earlier module's `Majority` IS `Above 1 1`,
--                    definitionally up to `1 · n ≡ n`
--   atLeastWithoutAbove   and the converse of the third fails, at a
--                    population sitting exactly ON the threshold
--
-- The shape of the answer is worth naming because it is not the shape
-- the question invited.  "Two families" would have needed a second
-- order, a second totality theorem, and a comparison between the two
-- orders.  There is one order: ⊑ is stated on thresholds alone, with no
-- population in it, so a second claim-family over the same thresholds
-- inherits it for free.  What distinguishes the families is not their
-- ordering but their behaviour at a single population per threshold —
-- the one that meets it exactly.
--
-- WHAT IS STILL NOT CLAIMED.  `atLeastWithoutAbove` is ONE population
-- at ONE threshold (one true and one false, so the rate is exactly 1/2); that
-- every threshold has such a population is NOT proved, and would need a
-- construction of a population realising an arbitrary p/(suc q), which
-- is a divisibility statement about ℕ and not a statement about lists.
-- No claim is made that `Above p q` and `AtLeast p' q'` interleave, i.e.
-- that between two thresholds there is always a third — density of ⊑ is
-- untouched.  ⊑ remains a total PREORDER, unquotiented: (1,1) and (2,3)
-- name one rate and stay two pairs, and `aboveAntitone` therefore
-- relates pairs, not rates.  The population is still a LIST.
--
-- CHECKED on the CONTAINER (Agda 2.6.3, cubical v0.5 — NOT the declared
-- pin, Agda 2.8.0 + cubical v0.9).  --safe, no postulates, no holes.
------------------------------------------------------------------------

module NaturalMachine.TheStrictThresholdsAreTheSameChainAndDifferOnlyAtTheBoundary where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat
  using (ℕ ; zero ; suc ; _·_ ; ·-comm ; ·-assoc ; ·-identityˡ)
open import Cubical.Data.Nat.Order
  using (_≤_ ; _<_ ; ≤-refl ; ≤-·k ; <-·sk ; <-asym ; <-weaken
        ; ≤<-trans ; ¬m<m ; splitℕ-<)
open import Cubical.Data.Bool using (Bool ; true ; false)
open import Cubical.Data.List using (List ; [] ; _∷_)
open import Cubical.Data.Sigma using (_×_ ; _,_)
open import Cubical.Data.Sum using (_⊎_ ; inl ; inr)
open import Cubical.Data.Empty as ⊥ using (⊥)
open import Cubical.Relation.Nullary using (¬_)

open import NaturalMachine.RateOneIsExactlyTheUniversalClaim
  using (count ; length)
open import NaturalMachine.MajorityLiesStrictlyBetweenAllAndSome
  using (Majority)
open import NaturalMachine.TheThresholdOrderIsTotalAndTheClaimIsAntitone
  using (AtLeast ; _⊑_ ; swapOuter ; swapEnds)

------------------------------------------------------------------------
-- 1.  Strict cancellation
--
-- Last cycle needed `m · suc k ≤ n · suc k → m ≤ n` and derived it,
-- cubical v0.5 having no such lemma.  The strict version is the same
-- argument with the branches exchanged: `splitℕ-<` supplies the case
-- split, and the wrong branch dies because ≤-·k turns `n ≤ m` into a
-- contradiction with the strict hypothesis.
------------------------------------------------------------------------

·sk-cancel-< : {m n : ℕ} (k : ℕ) → m · suc k < n · suc k → m < n
·sk-cancel-< {m} {n} k h with splitℕ-< m n
... | inl p = p
... | inr q = ⊥.rec (<-asym h (≤-·k q))

------------------------------------------------------------------------
-- 2.  The strict claim family, on the SAME thresholds
------------------------------------------------------------------------

Above : ℕ → ℕ → List Bool → Type
Above p q bs = p · length bs < suc q · count bs

aboveGivesAtLeast : (p q : ℕ) (bs : List Bool) → Above p q bs → AtLeast p q bs
aboveGivesAtLeast p q bs = <-weaken

------------------------------------------------------------------------
-- 3.  Antitone along ⊑ — the same order, no second totality proof
--
-- Identical scaffolding to `atLeastAntitone`: multiply by the positive
-- denominator suc q', rearrange twice, cancel it again.  The only
-- change is that the second step is `<-·sk` rather than `≤-·k`, and the
-- two are stitched with `≤<-trans`.
------------------------------------------------------------------------

aboveAntitone :
  (p q p' q' : ℕ) (bs : List Bool)
  → (p , q) ⊑ (p' , q')
  → Above p' q' bs → Above p q bs
aboveAntitone p q p' q' bs cross high =
  ·sk-cancel-< q' scaled
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

    s4 : (p' · L) · suc q < (suc q' · C) · suc q
    s4 = <-·sk high

    e5 : (suc q' · C) · suc q ≡ (suc q · C) · suc q'
    e5 = swapEnds (suc q') C (suc q)

    b2 : (p · L) · suc q' ≤ (p' · suc q) · L
    b2 = subst (_≤ (p' · suc q) · L) (sym e1) a2

    b3 : (p · L) · suc q' ≤ (p' · L) · suc q
    b3 = subst ((p · L) · suc q' ≤_) e3 b2

    scaled : (p · L) · suc q' < (suc q · C) · suc q'
    scaled = subst ((p · L) · suc q' <_) e5 (≤<-trans b3 s4)

------------------------------------------------------------------------
-- 4.  `Majority` was already a member of this family
--
-- The earlier module wrote `Majority bs = length bs < 2 · count bs` and
-- did not connect it to any threshold.  It is `Above 1 1`, and the only
-- thing between the two statements is that `1 · n` is not definitionally
-- `n` in cubical's ℕ.
------------------------------------------------------------------------

majorityIsAboveHalf : (bs : List Bool) → Majority bs → Above 1 1 bs
majorityIsAboveHalf bs = subst (_< 2 · count bs) (sym (·-identityˡ (length bs)))

aboveHalfIsMajority : (bs : List Bool) → Above 1 1 bs → Majority bs
aboveHalfIsMajority bs = subst (_< 2 · count bs) (·-identityˡ (length bs))

------------------------------------------------------------------------
-- 5.  The gap: a population exactly ON the threshold
--
-- One `true`, one `false`: the rate is exactly 1/2, so the non-strict
-- claim at 1/2 holds and the strict one does not.  This is the whole
-- difference between the families — not a different order, a different
-- verdict at the boundary.
------------------------------------------------------------------------

onTheBoundary : List Bool
onTheBoundary = true ∷ false ∷ []

boundaryMeetsHalf : AtLeast 1 1 onTheBoundary
boundaryMeetsHalf = ≤-refl

boundaryIsNotAboveHalf : ¬ Above 1 1 onTheBoundary
boundaryIsNotAboveHalf = ¬m<m

atLeastWithoutAbove :
  (AtLeast 1 1 onTheBoundary) × (¬ Above 1 1 onTheBoundary)
atLeastWithoutAbove = boundaryMeetsHalf , boundaryIsNotAboveHalf

------------------------------------------------------------------------
-- APPENDED 2026-08-19, by the same identity, at the end, altering no
-- line above.  The NOT-CLAIMED section says:
--
--   "that every threshold has such a population is NOT proved, and
--    would need a construction of a population realising an arbitrary
--    p/(suc q), which is a divisibility statement about ℕ and not a
--    statement about lists."
--
-- Proved now, in
-- `NaturalMachine.EveryThresholdHasABoundaryPopulationOfItsOwnDenominator`
-- (--safe, no postulates, no holes; container green under Agda 2.6.3 +
-- cubical v0.5, NOT the declared pin — check.sh returns 1 and says so).
--
-- It is a statement about ℕ, and the guess that divisibility enters it
-- was wrong: the DENOMINATOR IS THE LENGTH.  For p ≤ suc q the
-- population `pop p k` — p trues then k falses, where cubical's `≤`
-- hands over the k with `k + p ≡ suc q` — has length exactly suc q and
-- count exactly p, so `p · length ≡ suc q · count` on the nose.  No
-- subtraction, no gcd, no lowest terms.
--
-- One thing the earlier statement did not notice and the new module
-- makes load-bearing: the EMPTY population meets every threshold and
-- refutes every strict one, since `p · 0 ≡ 0 ≡ suc q · 0`.  So the
-- sentence quoted above is TRUE VACUOUSLY as stated, and a proof of it
-- in that form would say nothing about the gap between the families.
-- The new theorem therefore returns `length bs ≡ suc q` as part of the
-- claim, which the empty witness fails.  `emptyMeetsEveryThreshold` and
-- `emptyIsAboveNoThreshold` are checked there too, precisely so the
-- vacuous reading cannot be mistaken for the theorem.
--
-- STILL NOT CLAIMED: MINIMALITY.  The length produced is suc q, and
-- whether a SHORTER boundary population exists is the divisibility
-- question after all — for p/(suc q) in lowest terms it does not — and
-- that is unproved, because lowest terms are not defined anywhere here.
-- Uniqueness is not claimed either: `pop p k` is one boundary
-- population, not the only one.
------------------------------------------------------------------------
