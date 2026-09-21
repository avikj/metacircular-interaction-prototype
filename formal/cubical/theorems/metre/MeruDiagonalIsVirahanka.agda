{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- MeruDiagonalIsVirahanka
--
-- MERU DIAGONAL = FIBONACCI.  Halyudha's observation that the
-- shallow diagonals of the meru-prastra (`Meru`) sum to the
-- mtrmeru (`Matramerus`) ‚î `Fib(n+1) = ‚à‚ñ C(n‚àík,k)` ‚î unifying
-- the two combinatorics modules.
--
-- The identity is proved, in the other encoding, by the `‡Æ‡‡∞‡ n k`
-- *function* form (Pascal refl) plus a bounded diagonal sum:
-- `PingalaPrastara.meru` IS the `‡Æ‡‡∞‡ n k` function form,
-- `Sankalita.antidiag` IS the bounded diagonal sum, and
--
--     DiagonalIsMatra.diagonal-is-matra : matra n ‚â° antidiag n
--
-- is the identity.  This file is the BRIDGE between two encodings of
-- the same count ‚î four lines of induction, because both sides already
-- carry the Virahka recurrence.
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
-- THE THEOREM
--
--     virahanka-is-the-diagonal :
--       length (‡‡∞‡‡µ n) ‚â° antidiag n
--
-- The number of metres of n ‡Æ‡æ‡‡‡∞‡æ ‚î Virahka's count, the ‡‡æ‡≤‡ã
-- diagonal's target ‚î IS the shallow-diagonal sum of the meru-prastra.
-- Halyudha's observation, at the two modules.
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
-- 3.  HALYUDHA'S IDENTITY
--
-- Between the two modules: the count of n-‡Æ‡æ‡‡‡∞‡æ metres is the shallow
-- diagonal of the meru-prastra.
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
-- 5.  Scope.
--
-- This bridges the two COUNTS (`‡‡∞‡‡µ` and `matra`) and inherits the
-- diagonal identity from `DiagonalIsMatra`, which is stated over
-- `PingalaPrastara.meru`.
------------------------------------------------------------------------
