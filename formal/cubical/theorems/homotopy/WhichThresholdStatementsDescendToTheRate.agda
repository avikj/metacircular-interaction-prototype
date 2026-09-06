{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- WhichThresholdStatementsDescendToTheRate
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
-- THE SCOPE, EXACTLY.  No quotient TYPE is formed — `≈` is a
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

module WhichThresholdStatementsDescendToTheRate where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (ℕ ; zero ; suc ; _·_)
open import Cubical.Data.Nat.Order using (_≤_ ; ≤-refl ; ≤-trans ; ≤-·k)
open import Cubical.Data.Bool using (Bool ; true ; false)
open import Cubical.Data.List using (List ; [] ; _∷_)
open import Cubical.Data.Sigma using (_×_ ; _,_ ; fst ; snd)
open import Cubical.Relation.Nullary using (¬_)

open import RateOneIsExactlyTheUniversalClaim using (length)
open import TheThresholdOrderIsTotalAndTheClaimIsAntitone
  using (AtLeast ; _⊑_ ; atLeastAntitone ; ·sk-cancel-≤ ; swapOuter)
open import TheStrictThresholdsAreTheSameChainAndDifferOnlyAtTheBoundary
  using (Above ; aboveAntitone)
open import MinimalityOfABoundaryPopulationNeedsLowestTerms
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

------------------------------------------------------------------------
-- APPENDED 2026-08-19, by the same identity, at the end, altering no
-- line above.  "Density of ⊑ remains untouched" is the last line of the
-- NOT-CLAIMED section here, and it was the last line of two earlier
-- modules on this line as well.  Touched now, in
-- `TheThresholdChainIsDenseAndTheMediantWitnessesIt`
-- (--safe, no postulates, no holes; container green under Agda 2.6.3 +
-- cubical v0.5, NOT the declared pin — check.sh returns 1 and says so).
--
-- The chain is DENSE, and the witness is not found by a search: it is
-- the MEDIANT.  Between p/(suc q) and p'/(suc q') lies
--
--   (p + p') / (suc q + suc q')
--
-- and both halves of the betweenness reduce, after distributing, to the
-- SAME strict inequality that was assumed — one is a left additive
-- shift of it and the other a right additive shift.  No case analysis.
-- The denominator needs no arithmetic either: `suc q + suc q'` IS
-- `suc (q + suc q')`, definitionally, so the mediant is visibly a
-- threshold pair.
--
-- `⊏-gives-⊑` is checked there too, so this is density OF THIS CHAIN
-- and not of a strict relation introduced for the occasion.
--
-- NO NOVELTY: the mediant's betweenness is classical — the Farey
-- dissection (Haros 1802; Farey 1816) and the Stern–Brocot tree (Stern
-- 1858; Brocot 1861).
--
-- STILL NOT CLAIMED, and it is this module's own gap showing again:
-- density is proved for pairs, and ⊑ is a preorder, so nothing is said
-- about density of the RATES — that needs the quotient §4 above
-- explicitly does not form.  The mediant is one witness, not the only
-- one, and is not claimed to be in lowest terms.  Nothing iterates it:
-- no Stern–Brocot enumeration and no claim that every intermediate
-- threshold is reachable.
------------------------------------------------------------------------

------------------------------------------------------------------------
-- APPENDED 2026-08-19, by the same identity, at the end, altering no
-- line above.  §5's NOT-CLAIMED says "no quotient TYPE is formed — `≈`
-- is a relation, with no set-quotient, no truncation and no
-- univalence".  The mediant module ends at the same wall.  When one
-- limitation ends two results it is the object, so it is built now:
-- `TheRateQuotientExistsAndMinimalityCannotLiveOnIt`
-- (--safe, no postulates, no holes; container green under Agda 2.6.3 +
-- cubical v0.5, NOT the declared pin — check.sh returns 1 and says so).
--
--   Rate = (ℕ × ℕ) / _≈_        the set-quotient
--   AtLeastOnRate / AboveOnRate both predicates LIFT, by
--                               `SetQuotients.rec`; §3 above is exactly
--                               the respectfulness the lift needs
--   atLeastOnRateComputes       the lift agrees with the old definition
--                               on representatives, by `refl`
--   noMinimalityOnTheRate       NO function on `Rate` agrees with
--                               `Minimal` on all representatives
--
-- THE LAST ONE IS STRONGER THAN §4 HERE.  §4 exhibits a pair where
-- minimality holds of one representative and fails of another, which
-- refutes ONE definition.  With the quotient, `[ oneHalf ] ≡
-- [ twoQuarters ]` is a PATH, `cong` transports along it, and no
-- definition whatsoever can agree with `Minimal` on both — an
-- impossibility rather than an absence.
--
-- The univalence is in the lift's target: `hProp` is a set
-- (`isSetHProp`), and `⇔toPath` turns the two-way implication §3 proves
-- into a PATH.  `AtLeast` is a proposition because cubical's `≤` is, so
-- nothing needed truncating.
--
-- STILL NOT CLAIMED: DENSITY OF THE RATES.  The mediant module's `⊏`
-- is not lifted, and lifting it needs `⊏` to respect `≈` on both sides,
-- which is unchecked — so of the two sentences this closes only the
-- one quoted at the top.  No arithmetic on `Rate` is defined, no normal
-- form or lowest-terms section is constructed, `≈` is not shown
-- decidable, and `Rate` is not related to any independently defined type
-- of rationals.
------------------------------------------------------------------------
