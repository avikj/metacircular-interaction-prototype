{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- TheFamiliesAgreeOffTheBoundarySoDifferOnlyIsNowBothDirections
--
-- ON THE NAME.  Checked before naming: `.claude/hooks/priority-ledger.txt`
-- (CURRENT header) and `.claude/hooks/european-frame.txt`; `formal/` and
-- invented.**  This is threshold arithmetic over ℕ on this corpus's own
-- claim-families.  Jaina enumerative mathematics is combinatorially
-- adjacent and is explicitly NOT claimed as a source — the third time
-- this run that it is declined for the same reason (083dfbd2, d3963e51).
--
-- ────────────────────────────────────────────────────────────────────
-- THE AUDIT.  Target:
-- `TheStrictThresholdsAreTheSameChainAndDifferOnlyAtTheBoundary`.  Two
-- claim-words, so both were asked.
--
-- **`THE SAME CHAIN` IS EARNED, AND FOR THE REASON IT GIVES.**  `⊑` is
-- stated on thresholds alone with no population in it, so a second
-- claim-family over the same thresholds inherits the order and its
-- totality with nothing re-proved; `aboveAntitone` is that inheritance.
-- The module says this itself and is right.
--
-- **`DIFFER ONLY AT THE BOUNDARY` WAS ONE INCLUSION AND ONE INSTANCE.**
-- Proved there: `aboveGivesAtLeast` (strict ⇒ non-strict), and
-- `atLeastWithoutAbove`, a SINGLE population — one true, one false —
-- where the non-strict claim holds and the strict one fails.  A single
-- witness shows the families differ SOMEWHERE.  **`ONLY` is the claim
-- that they differ NOWHERE ELSE, and that is a universally quantified
-- statement about every population off the boundary, which is not
-- there.**  Its §"WHAT IS STILL NOT CLAIMED" lists the one-population
-- limitation, interleaving, the unquotiented preorder and the list
-- encoding — not this.
--
-- **AND IT IS TWO LINES, BECAUSE ℕ'S ORDER SPLITS.**  `≤-split` gives
-- `m ≤ n → (m < n) ⊎ (m ≡ n)`, so `AtLeast` is exactly `Above` or
-- on-the-boundary, and the two alternatives exclude each other.
-- Diagnostic (1) called it in advance: what joins the two families is a
-- TRICHOTOMY ALREADY IN THE LIBRARY, so neither direction is a search.
--
-- ────────────────────────────────────────────────────────────────────
-- WHAT IS PROVED
--
--   OnTheBoundary        `p · length bs ≡ suc q · count bs`, the
--                        equality case named
--   atLeastSplits        `AtLeast p q bs → Above p q bs ⊎ OnTheBoundary p q bs`
--   aboveIsOffTheBoundary
--                        the disjuncts exclude each other
--   differOnlyAtTheBoundary
--                        off the boundary, non-strict ⇒ strict — the
--                        missing direction, which is what `ONLY` asserts
--   theFamiliesAgreeOffTheBoundary
--                        hence `AtLeast ⟺ Above` at every population
--                        that does not meet the threshold exactly
--
-- SYĀT — THE CLAIM, EXACTLY.  This says nothing new about WHICH populations
-- sit on a boundary — that is the audited module's appended result
-- (`pop p k`, length `suc q`), and MINIMALITY of that length is still
-- open there and here.  Nothing about interleaving or density of `⊑`.
-- `⊑` remains a total PREORDER, unquotiented: (1,1) and (2,3) name one
-- rate and stay two pairs.  The population is still a LIST, so
-- multiplicity is counted and order carried, and no claim below uses
-- the order.  No claim that `OnTheBoundary` is decidable — it is a path
-- in ℕ and `discreteℕ` would give it, but nothing here needs or states
-- that.
--
-- CHECKED on the CONTAINER (Agda 2.6.3, cubical v0.5 — NOT the declared
-- pin, Agda 2.8.0 + cubical v0.9).  --safe, no postulates, no holes.
------------------------------------------------------------------------

module TheFamiliesAgreeOffTheBoundarySoDifferOnlyIsNowBothDirections where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (ℕ ; suc ; _·_)
open import Cubical.Data.Nat.Order using (_<_ ; ≤-split ; ¬m<m)
open import Cubical.Data.Bool using (Bool)
open import Cubical.Data.List using (List)
open import Cubical.Data.Sum using (_⊎_ ; inl ; inr)
open import Cubical.Data.Sigma using (_×_ ; _,_)
open import Cubical.Data.Empty as ⊥ using (⊥)
open import Cubical.Relation.Nullary using (¬_)

open import RateOneIsExactlyTheUniversalClaim
  using (count ; length)
open import TheThresholdOrderIsTotalAndTheClaimIsAntitone
  using (AtLeast)
open import TheStrictThresholdsAreTheSameChainAndDifferOnlyAtTheBoundary
  using (Above ; aboveGivesAtLeast)

------------------------------------------------------------------------
-- 1.  The boundary, named
------------------------------------------------------------------------

OnTheBoundary : ℕ → ℕ → List Bool → Type
OnTheBoundary p q bs = p · length bs ≡ suc q · count bs

------------------------------------------------------------------------
-- 2.  Non-strict is strict-or-boundary, and the two exclude each other
------------------------------------------------------------------------

atLeastSplits :
  (p q : ℕ) (bs : List Bool)
  → AtLeast p q bs → Above p q bs ⊎ OnTheBoundary p q bs
atLeastSplits p q bs = ≤-split

aboveIsOffTheBoundary :
  (p q : ℕ) (bs : List Bool)
  → Above p q bs → ¬ OnTheBoundary p q bs
aboveIsOffTheBoundary p q bs lt e =
  ¬m<m (subst (_< suc q · count bs) e lt)

------------------------------------------------------------------------
-- 3.  So off the boundary the two families agree
------------------------------------------------------------------------

differOnlyAtTheBoundary :
  (p q : ℕ) (bs : List Bool)
  → AtLeast p q bs → ¬ OnTheBoundary p q bs → Above p q bs
differOnlyAtTheBoundary p q bs h ¬b with atLeastSplits p q bs h
... | inl lt = lt
... | inr e  = ⊥.rec (¬b e)

theFamiliesAgreeOffTheBoundary :
  (p q : ℕ) (bs : List Bool)
  → ¬ OnTheBoundary p q bs
  → (AtLeast p q bs → Above p q bs) × (Above p q bs → AtLeast p q bs)
theFamiliesAgreeOffTheBoundary p q bs ¬b =
  (λ h → differOnlyAtTheBoundary p q bs h ¬b) , aboveGivesAtLeast p q bs
