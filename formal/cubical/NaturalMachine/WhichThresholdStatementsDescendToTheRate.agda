{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- NaturalMachine.WhichThresholdStatementsDescendToTheRate
--
-- `MinimalityOfABoundaryPopulationNeedsLowestTerms` found that 2/4 and
-- 1/2 are the same RATE and different PAIRS, and that minimality holds
-- of one and fails of the other, and concluded:
--
--   "MINIMALITY IS NOT A PROPERTY OF THE RATE, only of the PAIR.  That
--    sharpens the standing open item about ⊑ being a preorder — it is
--    not merely untidy, it separates statements that are true of one
--    representative and false of another."
--
-- A separation without the other side is only half a result: it says
-- SOMETHING fails to descend, not WHICH things descend.  Both sides are
-- here.
--
-- ────────────────────────────────────────────────────────────────────
-- FIRST, A CORRECTION TO MY OWN EARLIER CLAIM.
--
-- `TheThresholdOrderIsTotalAndTheClaimIsAntitone` proved `⊑-refl` and
-- `⊑-total` and every note since has called ⊑ a "total preorder".
-- TRANSITIVITY WAS NEVER PROVED.  Reflexive + total is not a preorder,
-- and the word was doing work it had not earned — the equivalence
-- below is not even an equivalence relation without it.  `⊑-trans` is
-- proved here, by the same multiply–rearrange–cancel that `⊑`'s other
-- theorems use, and the word is now earned.
--
-- ────────────────────────────────────────────────────────────────────
-- WHAT IS PROVED
--
--   ⊑-trans            the missing preorder law
--   _≈_                same rate = mutual ⊑; an equivalence relation
--   atLeastDescends    `AtLeast` is a property of the RATE
--   aboveDescends      so is `Above` — both directions, both families
--   oneHalfIsTwoQuarters   (1,1) ≈ (2,3), checked
--   minimalDoesNotDescend  and `den a ≤ length bs` is NOT, at that very
--                          pair
--
-- So the boundary is sharp and sits where the DENOMINATOR appears
-- alone.  `AtLeast` and `Above` mention p and suc q only inside a
-- product `p · length ≤ suc q · count`, which is exactly the shape ⊑
-- compares; minimality mentions `suc q` on its own, and `suc q` is not
-- a function of the rate.  That is the whole criterion, and it explains
-- rather than merely records the earlier separation.
--
-- WHAT IS STILL NOT CLAIMED.  No quotient TYPE is formed — `≈` is a
-- relation, and no set-quotient, no truncation, no univalence is used
-- anywhere below.  Descent is proved for the two claim families and
-- refuted for one statement; nothing is proved about an arbitrary
-- statement, and the criterion in the paragraph above is a reading of
-- the proofs, NOT a theorem — no formal characterisation of the
-- descending statements is given, and one would need a language of
-- statements to be quantified over.  Antisymmetry still does not hold
-- and is not claimed: ≈ has non-trivial classes by construction, which
-- is the entire point.  Density of ⊑ remains untouched.
--
-- CHECKED on the CONTAINER (Agda 2.6.3, cubical v0.5 — NOT the declared
-- pin, Agda 2.8.0 + cubical v0.9).  --safe, no postulates, no holes.
------------------------------------------------------------------------

module NaturalMachine.WhichThresholdStatementsDescendToTheRate where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (ℕ ; zero ; suc ; _·_)
open import Cubical.Data.Nat.Order using (_≤_ ; ≤-refl ; ≤-trans ; ≤-·k)
open import Cubical.Data.Bool using (Bool ; true ; false)
open import Cubical.Data.List using (List ; [] ; _∷_)
open import Cubical.Data.Sigma using (_×_ ; _,_ ; fst ; snd)
open import Cubical.Relation.Nullary using (¬_)

open import NaturalMachine.RateOneIsExactlyTheUniversalClaim using (length)
open import NaturalMachine.TheThresholdOrderIsTotalAndTheClaimIsAntitone
  using (AtLeast ; _⊑_ ; atLeastAntitone ; ·sk-cancel-≤ ; swapOuter)
open import NaturalMachine.TheStrictThresholdsAreTheSameChainAndDifferOnlyAtTheBoundary
  using (Above ; aboveAntitone)
open import NaturalMachine.MinimalityOfABoundaryPopulationNeedsLowestTerms
  using (short ; shortIsShorterThanTheDenominator)

------------------------------------------------------------------------
-- 1.  The law that was assumed and never proved
------------------------------------------------------------------------

⊑-trans : (a b c : ℕ × ℕ) → a ⊑ b → b ⊑ c → a ⊑ c
⊑-trans (p , q) (p' , q') (p'' , q'') h1 h2 = ·sk-cancel-≤ q' scaled
  where
    e1 : (p · suc q'') · suc q' ≡ (p · suc q') · suc q''
    e1 = swapOuter p (suc q'') (suc q')

    a2 : (p · suc q') · suc q'' ≤ (p' · suc q) · suc q''
    a2 = ≤-·k h1

    e3 : (p' · suc q) · suc q'' ≡ (p' · suc q'') · suc q
    e3 = swapOuter p' (suc q) (suc q'')

    a4 : (p' · suc q'') · suc q ≤ (p'' · suc q') · suc q
    a4 = ≤-·k h2

    e5 : (p'' · suc q') · suc q ≡ (p'' · suc q) · suc q'
    e5 = swapOuter p'' (suc q') (suc q)

    b2 : (p · suc q'') · suc q' ≤ (p' · suc q) · suc q''
    b2 = subst (_≤ (p' · suc q) · suc q'') (sym e1) a2

    b3 : (p · suc q'') · suc q' ≤ (p' · suc q'') · suc q
    b3 = subst ((p · suc q'') · suc q' ≤_) e3 b2

    scaled : (p · suc q'') · suc q' ≤ (p'' · suc q) · suc q'
    scaled = subst ((p · suc q'') · suc q' ≤_) e5 (≤-trans b3 a4)

------------------------------------------------------------------------
-- 2.  Same rate
------------------------------------------------------------------------

_≈_ : ℕ × ℕ → ℕ × ℕ → Type
a ≈ b = (a ⊑ b) × (b ⊑ a)

≈-refl : (a : ℕ × ℕ) → a ≈ a
≈-refl (p , q) = ≤-refl , ≤-refl

≈-sym : (a b : ℕ × ℕ) → a ≈ b → b ≈ a
≈-sym a b (ab , ba) = ba , ab

≈-trans : (a b c : ℕ × ℕ) → a ≈ b → b ≈ c → a ≈ c
≈-trans a b c (ab , ba) (bc , cb) =
  ⊑-trans a b c ab bc , ⊑-trans c b a cb ba

------------------------------------------------------------------------
-- 3.  Both claim families descend
--
-- Nothing new is needed: antitone in both directions IS descent.
------------------------------------------------------------------------

atLeastDescends :
  (a b : ℕ × ℕ) → a ≈ b → (bs : List Bool)
  → (AtLeast (fst a) (snd a) bs → AtLeast (fst b) (snd b) bs)
  × (AtLeast (fst b) (snd b) bs → AtLeast (fst a) (snd a) bs)
atLeastDescends (p , q) (p' , q') (ab , ba) bs =
    atLeastAntitone p' q' p q bs ba
  , atLeastAntitone p q p' q' bs ab

aboveDescends :
  (a b : ℕ × ℕ) → a ≈ b → (bs : List Bool)
  → (Above (fst a) (snd a) bs → Above (fst b) (snd b) bs)
  × (Above (fst b) (snd b) bs → Above (fst a) (snd a) bs)
aboveDescends (p , q) (p' , q') (ab , ba) bs =
    aboveAntitone p' q' p q bs ba
  , aboveAntitone p q p' q' bs ab

------------------------------------------------------------------------
-- 4.  And one statement that does not
--
-- `den` reads the denominator off the PAIR.  It is not a function of
-- the rate, and any statement mentioning it alone is not either.
------------------------------------------------------------------------

den : ℕ × ℕ → ℕ
den (p , q) = suc q

Minimal : ℕ × ℕ → List Bool → Type
Minimal a bs = den a ≤ length bs

oneHalf twoQuarters : ℕ × ℕ
oneHalf     = 1 , 1
twoQuarters = 2 , 3

oneHalfIsTwoQuarters : oneHalf ≈ twoQuarters
oneHalfIsTwoQuarters = ≤-refl , ≤-refl

shortIsMinimalAtOneHalf : Minimal oneHalf short
shortIsMinimalAtOneHalf = ≤-refl

shortIsNotMinimalAtTwoQuarters : ¬ Minimal twoQuarters short
shortIsNotMinimalAtTwoQuarters = shortIsShorterThanTheDenominator

minimalDoesNotDescend :
  (oneHalf ≈ twoQuarters)
  × (Minimal oneHalf short)
  × (¬ Minimal twoQuarters short)
minimalDoesNotDescend =
  oneHalfIsTwoQuarters , shortIsMinimalAtOneHalf ,
  shortIsNotMinimalAtTwoQuarters
