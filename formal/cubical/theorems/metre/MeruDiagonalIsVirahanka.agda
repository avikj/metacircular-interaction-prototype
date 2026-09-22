{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- MeruDiagonalIsVirahanka
--
-- MERU DIAGONAL = FIBONACCI.  Halyudha's observation that the
-- shallow diagonals of the meru-prastra (`Meru`) sum to the
-- mtrmeru (`Matramerus`) — `Fib(n+1) = �� C(n−k,k)` — unifying
-- the two combinatorics modules.
--
-- The identity is proved, in the other encoding, by the `���� n k`
-- *function* form (Pascal refl) plus a bounded diagonal sum:
-- `PingalaPrastara.meru` IS the `���� n k` function form,
-- `Sankalita.antidiag` IS the bounded diagonal sum, and
--
--     DiagonalIsMatra.diagonal-is-matra : matra n ≡ antidiag n
--
-- is the identity.  This file is the BRIDGE between two encodings of
-- the same count — four lines of induction, because both sides already
-- carry the Virahka recurrence.
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
-- THE THEOREM
--
--     virahanka-is-the-diagonal :
--       length (सर्व n) ≡ antidiag n
--
-- The number of metres of n मात्रा — Virahāṅka's count, the शालो
-- diagonal's target — IS the shallow-diagonal sum of the meru-prastāra.
-- Halyudha's observation, at the two modules.
------------------------------------------------------------------------

module MeruDiagonalIsVirahanka where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (ℕ ; zero ; suc ; _+_)
open import Cubical.Data.List using (List ; length)

open import Matramerus using (सर्व ; मात्रामेरु)
open import PingalaPrastara using (matra)
open import Sankalita using (antidiag)
open import DiagonalIsMatra using (diagonal-is-matra)

------------------------------------------------------------------------
-- 1.  Both sides carry the Virahka recurrence
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
-- 3.  HALYUDHA'S IDENTITY
--
-- Between the two modules: the count of n-������ metres is the shallow
-- diagonal of the meru-prastra.
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
-- 5.  Dependencies.
--
-- This bridges the two COUNTS (`����` and `matra`) and inherits the
-- diagonal identity from `DiagonalIsMatra`, which is stated over
-- `PingalaPrastara.meru`.
------------------------------------------------------------------------
