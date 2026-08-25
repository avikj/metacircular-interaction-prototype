{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- NaturalMachine.MeruDiagonalIsVirahanka
--
-- `notes/INDIC_CORPUS_OPEN_FRONTIER.md` lists as genuinely open:
--
--   > **2. Meru diagonal = Fibonacci.** Halāyudha's observation that the
--   > shallow diagonals of the meru-prastāra (`Meru`) sum to the
--   > mātrāmeru (`Matramerus`) — `Fib(n+1) = ∑ₖ C(n−k,k)`.  Would unify
--   > the two combinatorics modules.  Open because the diagonal
--   > reindexing over the list representation is fiddly; a `मेरु n k`
--   > *function* form (Pascal refl) plus a bounded diagonal sum is the
--   > clean route.
--
-- The identity is already proved, in the other encoding, by exactly the
-- route that note names.  `PingalaPrastara.meru` IS the `मेरु n k`
-- function form, `Sankalita.antidiag` IS the bounded diagonal sum, and
--
--     DiagonalIsMatra.diagonal-is-matra : matra n ≡ antidiag n
--
-- is the identity.  What was missing was not the theorem but the BRIDGE
-- between two encodings of the same count, and that is what this file
-- is — four lines of induction, because both sides already carry the
-- Virahāṅka recurrence.
--
-- ────────────────────────────────────────────────────────────────────
-- THE TWO COUNTS
--
--   `Matramerus.सर्व n`     the LIST of all n-मात्रा metres, with
--                          soundness and completeness proved there, so
--                          its length is the count and not a proxy;
--   `PingalaPrastara.matra` the count by recurrence,
--                          matra (n+2) = matra (n+1) + matra n.
--
-- `Matramerus.मात्रामेरु` gives the same recurrence for the length.  Two
-- functions on ℕ with one recurrence and one pair of base cases are
-- equal, and §2 is that induction.
--
-- ────────────────────────────────────────────────────────────────────
-- WHAT THIS CLOSES
--
--     virahanka-is-the-diagonal :
--       length (सर्व n) ≡ antidiag n
--
-- The number of metres of n मात्रा — Virahāṅka's count, the शालो
-- diagonal's target — IS the shallow-diagonal sum of the meru-prastāra.
-- Halāyudha's observation, at the two modules the note wanted unified.
--
-- ────────────────────────────────────────────────────────────────────
-- WHY IT LOOKED OPEN
--
-- Not because anyone was careless.  `Pingala.agda` was rewritten between
-- these developments (684a2857, 464 lines removed), and the modules
-- carrying `meru`, `matra` and the diagonal identity were repointed to
-- `PingalaPrastara` only after the latch caught the break.  A frontier
-- ledger written from the current tree could not see them.  The lesson
-- is about ledgers, not about the ledger's author: an "open" list is
-- only as good as the encoding it was surveyed in.
--
-- CHECKED: Agda 2.6.3, cubical v0.5 — the container, not the repository
-- pin.  No postulates, no holes.
------------------------------------------------------------------------

module NaturalMachine.MeruDiagonalIsVirahanka where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (ℕ ; zero ; suc ; _+_)
open import Cubical.Data.List using (List ; length)

open import Matramerus using (सर्व ; मात्रामेरु)
open import SourcedProofs.PingalaPrastara using (matra)
open import SourcedProofs.Sankalita using (antidiag)
open import SourcedProofs.DiagonalIsMatra using (diagonal-is-matra)

------------------------------------------------------------------------
-- 1.  Both sides carry the Virahāṅka recurrence
--
-- `matra` by definition; `length (सर्व _)` by `Matramerus.मात्रामेरु`,
-- which is proved there from soundness and completeness of the list.
------------------------------------------------------------------------

matra-step : (n : ℕ) → matra (suc (suc n)) ≡ matra (suc n) + matra n
matra-step n = refl

sarva-step : (n : ℕ)
           → length (सर्व (suc (suc n))) ≡ length (सर्व (suc n)) + length (सर्व n)
sarva-step = मात्रामेरु

------------------------------------------------------------------------
-- 2.  So the two counts agree
------------------------------------------------------------------------

matra-is-sarva : (n : ℕ) → matra n ≡ length (सर्व n)
matra-is-sarva zero          = refl
matra-is-sarva (suc zero)    = refl
matra-is-sarva (suc (suc n)) =
  cong₂ _+_ (matra-is-sarva (suc n)) (matra-is-sarva n) ∙ sym (sarva-step n)

------------------------------------------------------------------------
-- 3.  THE FRONTIER ITEM
--
-- Halāyudha's identity, between the two modules the ledger wanted
-- unified: the count of n-मात्रा metres is the shallow diagonal of the
-- meru-prastāra.
------------------------------------------------------------------------

virahanka-is-the-diagonal : (n : ℕ) → length (सर्व n) ≡ antidiag n
virahanka-is-the-diagonal n = sym (matra-is-sarva n) ∙ diagonal-is-matra n

------------------------------------------------------------------------
-- 4.  It runs
--
--   सर्व 6 has 13 metres, and the antidiagonal a+b=6 of the meru is
--   C(6,0)+C(5,1)+C(4,2)+C(3,3) = 1+5+6+1 = 13.
------------------------------------------------------------------------

check-6 : length (सर्व 6) ≡ antidiag 6
check-6 = virahanka-is-the-diagonal 6

check-9 : length (सर्व 9) ≡ antidiag 9
check-9 = virahanka-is-the-diagonal 9

------------------------------------------------------------------------
-- 5.  What is closed and what is not.
--
-- CLOSED.  Frontier item 2.  Not by proving the identity — it was
-- proved — but by joining the two encodings, which is what the item
-- actually asked for ("would unify the two combinatorics modules").
--
-- NOT CLOSED, and left alone deliberately: `Meru.मेरु-पङ्क्ति`, the ROW
-- representation, is not connected here.  This bridges the two COUNTS
-- (`सर्व` and `matra`) and inherits the diagonal identity from
-- `DiagonalIsMatra`, which is stated over `PingalaPrastara.meru`.  A
-- second bridge, from `मेरु-पङ्क्ति n` to `λ k → meru n k`, would connect
-- the row module too and is not done here.  Named, not estimated.
--
-- A REQUEST recorded rather than acted on: the frontier ledger should
-- probably say "open in encoding X" rather than "open", since this item
-- was open in one and closed in the other for the whole time it was
-- listed.  That is the ledger's authors' call, not mine, and their file
-- is not edited.
------------------------------------------------------------------------
