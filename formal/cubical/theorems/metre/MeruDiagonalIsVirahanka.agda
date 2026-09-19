{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- MeruDiagonalIsVirahanka
--
--
--   > **2. Meru diagonal = Fibonacci.** Halyudha's observation that the
--   > shallow diagonals of the meru-prastra (`Meru`) sum to the
--   > mtrmeru (`Matramerus`) ‚î `Fib(n+1) = ‚à‚ñ C(n‚àík,k)`.  Would unify
--   > the two combinatorics modules.  Open because the diagonal
--   > reindexing over the list representation is fiddly; a `‡Æ‡‡∞‡ n k`
--   > *function* form (Pascal refl) plus a bounded diagonal sum is the
--   > clean route.
--
-- The identity is already proved, in the other encoding, by exactly the
-- route that note names.  `PingalaPrastara.meru` IS the `‡Æ‡‡∞‡ n k`
-- function form, `Sankalita.antidiag` IS the bounded diagonal sum, and
--
--     DiagonalIsMatra.diagonal-is-matra : matra n ‚â° antidiag n
--
-- is the identity.  What was missing was not the theorem but the BRIDGE
-- between two encodings of the same count, and that is what this file
-- is ‚î four lines of induction, because both sides already carry the
-- Virahka recurrence.
--
-- ‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î
-- THE TWO COUNTS
--
--   `Matramerus.‡‡∞‡‡µ n`     the LIST of all n-‡Æ‡æ‡‡‡∞‡æ metres, with
--                          soundness and completeness proved there, so
--                          its length is the count and not a proxy;
--   `PingalaPrastara.matra` the count by recurrence,
--                          matra (n+2) = matra (n+1) + matra n.
--
-- `Matramerus.‡Æ‡æ‡‡‡∞‡æ‡Æ‡‡∞‡` gives the same recurrence for the length.  Two
-- functions on ‚ï with one recurrence and one pair of base cases are
-- equal, and ¬ß2 is that induction.
--
-- ‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î
-- WHAT THIS CLOSES
--
--     virahanka-is-the-diagonal :
--       length (‡‡∞‡‡µ n) ‚â° antidiag n
--
-- The number of metres of n ‡Æ‡æ‡‡‡∞‡æ ‚î Virahka's count, the ‡‡æ‡≤‡ã
-- diagonal's target ‚î IS the shallow-diagonal sum of the meru-prastra.
-- Halyudha's observation, at the two modules the note wanted unified.
--
-- ‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î
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
-- CHECKED: Agda 2.6.3, cubical v0.5 ‚î the container, not the repository
-- pin.  No postulates, no holes.
------------------------------------------------------------------------

module MeruDiagonalIsVirahanka where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (‚Ñï ; zero ; suc ; _+_)
open import Cubical.Data.List using (List ; length)

open import Matramerus using (‡§∏‡§∞‡•ç‡§µ ; ‡§Æ‡§æ‡§§‡•ç‡§∞‡§æ‡§Æ‡•á‡§∞‡•Å)
open import PingalaPrastara using (matra)
open import Sankalita using (antidiag)
open import DiagonalIsMatra using (diagonal-is-matra)

------------------------------------------------------------------------
-- 1.  Both sides carry the Virahka recurrence
--
-- `matra` by definition; `length (‡‡∞‡‡µ _)` by `Matramerus.‡Æ‡æ‡‡‡∞‡æ‡Æ‡‡∞‡`,
-- which is proved there from soundness and completeness of the list.
------------------------------------------------------------------------

matra-step : (n : ‚Ñï) ‚Üí matra (suc (suc n)) ‚â° matra (suc n) + matra n
matra-step n = refl

sarva-step : (n : ‚Ñï)
           ‚Üí length (‡§∏‡§∞‡•ç‡§µ (suc (suc n))) ‚â° length (‡§∏‡§∞‡•ç‡§µ (suc n)) + length (‡§∏‡§∞‡•ç‡§µ n)
sarva-step = ‡§Æ‡§æ‡§§‡•ç‡§∞‡§æ‡§Æ‡•á‡§∞‡•Å

------------------------------------------------------------------------
-- 2.  So the two counts agree
------------------------------------------------------------------------

matra-is-sarva : (n : ‚Ñï) ‚Üí matra n ‚â° length (‡§∏‡§∞‡•ç‡§µ n)
matra-is-sarva zero          = refl
matra-is-sarva (suc zero)    = refl
matra-is-sarva (suc (suc n)) =
  cong‚ÇÇ _+_ (matra-is-sarva (suc n)) (matra-is-sarva n) ‚àô sym (sarva-step n)

------------------------------------------------------------------------
-- 3.  THE FRONTIER ITEM
--
-- Halyudha's identity, between the two modules the ledger wanted
-- unified: the count of n-‡Æ‡æ‡‡‡∞‡æ metres is the shallow diagonal of the
-- meru-prastra.
------------------------------------------------------------------------

virahanka-is-the-diagonal : (n : ‚Ñï) ‚Üí length (‡§∏‡§∞‡•ç‡§µ n) ‚â° antidiag n
virahanka-is-the-diagonal n = sym (matra-is-sarva n) ‚àô diagonal-is-matra n

------------------------------------------------------------------------
-- 4.  It runs
--
--   ‡‡∞‡‡µ 6 has 13 metres, and the antidiagonal a+b=6 of the meru is
--   C(6,0)+C(5,1)+C(4,2)+C(3,3) = 1+5+6+1 = 13.
------------------------------------------------------------------------

check-6 : length (‡§∏‡§∞‡•ç‡§µ 6) ‚â° antidiag 6
check-6 = virahanka-is-the-diagonal 6

check-9 : length (‡§∏‡§∞‡•ç‡§µ 9) ‚â° antidiag 9
check-9 = virahanka-is-the-diagonal 9

------------------------------------------------------------------------
-- 5.  What is closed and what is not.
--
-- CLOSED.  Frontier item 2.  Not by proving the identity ‚î it was
-- proved ‚î but by joining the two encodings, which is what the item
-- actually asked for ("would unify the two combinatorics modules").
--
-- NOT CLOSED, and left alone deliberately: `Meru.‡Æ‡‡∞‡-‡‡ô‡‡ï‡‡‡ø`, the ROW
-- representation, is not connected here.  This bridges the two COUNTS
-- (`‡‡∞‡‡µ` and `matra`) and inherits the diagonal identity from
-- `DiagonalIsMatra`, which is stated over `PingalaPrastara.meru`.  A
-- second bridge, from `‡Æ‡‡∞‡-‡‡ô‡‡ï‡‡‡ø n` to `Œª k ‚í meru n k`, would connect
-- the row module too and is not done here.  Named, not estimated.
--
-- A REQUEST recorded rather than acted on: the frontier ledger should
-- probably say "open in encoding X" rather than "open", since this item
-- was open in one and closed in the other for the whole time it was
-- listed.  That is the ledger's authors' call, not mine, and their file
-- is not edited.
------------------------------------------------------------------------
