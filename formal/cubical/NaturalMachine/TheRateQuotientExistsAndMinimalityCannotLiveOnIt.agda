{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- NaturalMachine.TheRateQuotientExistsAndMinimalityCannotLiveOnIt
--
-- Two results on this line now end at the same sentence.
-- `WhichThresholdStatementsDescendToTheRate` says "no quotient TYPE is
-- formed — `≈` is a relation, with no set-quotient, no truncation and
-- no univalence", and
-- `TheThresholdChainIsDenseAndTheMediantWitnessesIt` says density "is
-- proved for pairs … nothing is said about density of the RATES —
-- that needs the quotient §4 above explicitly does not form."
--
-- When the SAME limitation ends two different results, that limitation
-- is the object, not either result.  The quotient is formed here.
--
-- ────────────────────────────────────────────────────────────────────
-- WHAT IS PROVED
--
--   Rate = (ℕ × ℕ) / _≈_        the set-quotient, a genuine HIT
--   AtLeastOnRate               `AtLeast` LIFTS: a function of the RATE,
--                               not of the pair
--   AboveOnRate                 and so does `Above`
--   atLeastOnRateComputes       the lift agrees with the old definition
--                               on every representative, by `refl`
--   noMinimalityOnTheRate       and NO function on `Rate` can agree with
--                               `Minimal` on all representatives — an
--                               impossibility, not an absence
--
-- The last one is what the earlier modules could not state.  They
-- exhibited a pair where minimality holds of one representative and
-- fails of another, which shows a PARTICULAR definition does not
-- descend.  With the quotient in hand the statement becomes: no
-- definition does, because `[ oneHalf ] ≡ [ twoQuarters ]` is a PATH,
-- `cong` transports along it, and the two verdicts would have to agree.
--
-- ────────────────────────────────────────────────────────────────────
-- WHERE THE UNIVALENCE IS, since this corpus's remit names it.  The
-- lift is by `SetQuotients.rec`, which needs the target to be a set;
-- the target is `List Bool → hProp`, a set because `hProp` is
-- (`isSetHProp`), and THAT is propositional univalence — `⇔toPath`
-- turns a two-way implication between propositions into a path, and it
-- is what makes `atLeastRespects` a path rather than a pair of
-- functions.  `AtLeast p q bs` is a proposition because cubical's `≤`
-- is (`isProp≤`), so nothing had to be truncated.
--
-- ────────────────────────────────────────────────────────────────────
-- NO NOVELTY.  Set-quotients, lifting along a respectful map, and
-- propositional extensionality are standard cubical practice; the
-- rationals are built this way in the library itself.  What is
-- contributed is only which of THIS corpus's threshold predicates
-- survive the quotient, and the proof that one provably does not.
--
-- WHAT IS STILL NOT CLAIMED.  DENSITY OF THE RATES is NOT proved: the
-- mediant module's `⊏` is not lifted here, and lifting it needs `⊏` to
-- respect `≈` on BOTH sides, which is not checked.  So the second of
-- the two sentences quoted at the top is still open, and only the first
-- is discharged.  No arithmetic on `Rate` is defined — no addition, no
-- mediant, no order — so this is a quotient carrying two predicates and
-- nothing else.  `Rate` is not shown to be equivalent to any
-- independently-defined type of rationals, and no normal form or
-- lowest-terms section is constructed; `≈` is not even shown decidable
-- here, though `dec≼`-style reasoning would give it.  The
-- impossibility theorem is about functions into `hProp`; a would-be
-- `Minimal` landing in an arbitrary `Type` is not covered, and could
-- not be lifted by `rec` anyway.
--
-- CHECKED on the CONTAINER (Agda 2.6.3, cubical v0.5 — NOT the declared
-- pin, Agda 2.8.0 + cubical v0.9).  --safe, no postulates, no holes.
------------------------------------------------------------------------

module NaturalMachine.TheRateQuotientExistsAndMinimalityCannotLiveOnIt where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Structure using (⟨_⟩)
open import Cubical.Foundations.HLevels using (hProp ; isSetHProp ; isSetΠ)
open import Cubical.Functions.Logic using (⇔toPath)
open import Cubical.HITs.SetQuotients as SQ using (_/_ ; [_] ; eq/)
open import Cubical.Data.Nat using (ℕ)
open import Cubical.Data.Nat.Order using (isProp≤)
open import Cubical.Data.Bool using (Bool)
open import Cubical.Data.List using (List)
open import Cubical.Data.Sigma using (_×_ ; _,_ ; fst ; snd)
open import Cubical.Data.Empty as ⊥ using (⊥)

open import NaturalMachine.TheThresholdOrderIsTotalAndTheClaimIsAntitone
  using (AtLeast)
open import NaturalMachine.TheStrictThresholdsAreTheSameChainAndDifferOnlyAtTheBoundary
  using (Above)
open import NaturalMachine.WhichThresholdStatementsDescendToTheRate
  using (_≈_ ; atLeastDescends ; aboveDescends ; Minimal
        ; oneHalf ; twoQuarters ; oneHalfIsTwoQuarters
        ; shortIsMinimalAtOneHalf ; shortIsNotMinimalAtTwoQuarters)
open import Texts.MinimalityOfABoundaryPopulationNeedsLowestTerms
  using (short)

------------------------------------------------------------------------
-- 1.  The quotient
------------------------------------------------------------------------

Rate : Type
Rate = (ℕ × ℕ) / _≈_

------------------------------------------------------------------------
-- 2.  AtLeast and Above lift
------------------------------------------------------------------------

AtLeastP : ℕ × ℕ → List Bool → hProp ℓ-zero
AtLeastP (p , q) bs = AtLeast p q bs , isProp≤

AboveP : ℕ × ℕ → List Bool → hProp ℓ-zero
AboveP (p , q) bs = Above p q bs , isProp≤

atLeastRespects :
  (a b : ℕ × ℕ) → a ≈ b → AtLeastP a ≡ AtLeastP b
atLeastRespects a b r = funExt λ bs →
  ⇔toPath (fst (atLeastDescends a b r bs)) (snd (atLeastDescends a b r bs))

aboveRespects :
  (a b : ℕ × ℕ) → a ≈ b → AboveP a ≡ AboveP b
aboveRespects a b r = funExt λ bs →
  ⇔toPath (fst (aboveDescends a b r bs)) (snd (aboveDescends a b r bs))

AtLeastOnRate : Rate → List Bool → hProp ℓ-zero
AtLeastOnRate =
  SQ.rec (isSetΠ (λ _ → isSetHProp)) AtLeastP atLeastRespects

AboveOnRate : Rate → List Bool → hProp ℓ-zero
AboveOnRate =
  SQ.rec (isSetΠ (λ _ → isSetHProp)) AboveP aboveRespects

atLeastOnRateComputes :
  (p q : ℕ) (bs : List Bool)
  → ⟨ AtLeastOnRate [ (p , q) ] bs ⟩ ≡ AtLeast p q bs
atLeastOnRateComputes p q bs = refl

------------------------------------------------------------------------
-- 3.  And minimality provably cannot
--
-- Not "the obvious definition fails to descend" — NO function on the
-- quotient agrees with `Minimal` on representatives, because
-- `[ oneHalf ] ≡ [ twoQuarters ]` is a path and `cong` transports along
-- it.
------------------------------------------------------------------------

noMinimalityOnTheRate :
  (M : Rate → List Bool → hProp ℓ-zero)
  → ((a : ℕ × ℕ) (bs : List Bool) → ⟨ M [ a ] bs ⟩ ≡ Minimal a bs)
  → ⊥
noMinimalityOnTheRate M agrees =
  shortIsNotMinimalAtTwoQuarters (transport chain shortIsMinimalAtOneHalf)
  where
    same : Path Rate [ oneHalf ] [ twoQuarters ]
    same = eq/ oneHalf twoQuarters oneHalfIsTwoQuarters

    step : ⟨ M [ oneHalf ] short ⟩ ≡ ⟨ M [ twoQuarters ] short ⟩
    step = cong (λ r → ⟨ M r short ⟩) same

    chain : Minimal oneHalf short ≡ Minimal twoQuarters short
    chain = sym (agrees oneHalf short) ∙ step ∙ agrees twoQuarters short

------------------------------------------------------------------------
-- APPENDED 2026-08-19, by the same identity, at the end, altering no
-- line above.  The NOT-CLAIMED section says:
--
--   "DENSITY OF THE RATES is NOT proved: the mediant module's `⊏` is
--    not lifted here, and lifting it needs `⊏` to respect `≈` on BOTH
--    sides, which is unchecked."
--
-- Both halves closed in
-- `NaturalMachine.TheRatesAreDenseAndTheMediantSurvivesTheQuotient`
-- (--safe, no postulates, no holes; container green under Agda 2.6.3 +
-- cubical v0.5, NOT the declared pin — check.sh returns 1 and says so),
-- and the sentence above named the harder half correctly: the LIFTING
-- is the work.
--
--   ⊑⊏-trans / ⊏⊑-trans   mixed transitivities, by the same
--                         multiply–rearrange–cancel as `⊑-trans`
--   ⊏-respects-≈          hence `⊏` respects `≈` on both sides
--   _⊏R_                  `⊏` lifted by `SetQuotients.rec2` into hProp
--   theRatesAreDense      between two rates lies a third
--
-- **AND THE MEDIANT NEVER HAS TO DESCEND.**  `mediant` is a function on
-- PAIRS and nothing shows it respects `≈`.  It does not need to:
-- density is a MERE EXISTENCE, so its target is a proposition, so
-- `elimProp2` puts the whole claim at representatives, where the
-- pair-level mediant is already a witness.  A witness that need not be
-- canonical need not be well-defined on the quotient — which is worth
-- keeping, because the instinct after building a quotient is to lift
-- everything in sight.
--
-- STILL NOT CLAIMED: whether `mediant` descends is OPEN, and returns
-- the moment a canonical between-rate is wanted.  The existence is
-- TRUNCATED, so no function producing one is constructed and none can
-- be extracted without the mediant descending or some other choice.
-- `⊏R` is a relation, not an order: irreflexivity, transitivity, and
-- its relation to `AtLeastOnRate`/`AboveOnRate` are unproved on `Rate`.
------------------------------------------------------------------------
