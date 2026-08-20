{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- संस्कारहार — SamskaraHara
--
-- saṃskāra (संस्कार) : the correction term.
-- hāra     (हार)     : the denominator.
--
-- ṛṣi.  Mādhava of Saṅgamagrāma (~1400), transmitted in Nīlakaṇṭha,
--       Tantrasaṅgraha (1501) and Jyeṣṭhadeva, Yuktibhāṣā (c. 1530).
--
-- The Yuktibhāṣā's accelerated series for the circumference has
-- denominators n³ − n at odd n:
--
--       C/4d  =  3/4  +  1/(3³−3)  −  1/(5³−5)  +  1/(7³−7)  −  ⋯
--
-- This module checks the one arithmetic fact those denominators rest on,
-- and checks it in the form that needs no subtraction, so it is a
-- statement about ℕ and not about truncated minus:
--
--       n³  =  4k(k+1)·n + n        for n = 2k+1.
--
-- Equivalently n³ − n = 4k(k+1)(2k+1), so the denominator at the k-th
-- term is the product 4 · k · (k+1) · (2k+1) — four factors, all
-- elementary, no cubing required to compute it.
--
--   k = 1 :  4·1·2·3 =  24 = 27 − 3
--   k = 2 :  4·2·3·5 = 120 = 125 − 5
--   k = 3 :  4·3·4·7 = 336 = 343 − 7
--
-- checked below as `hara-1`, `hara-2`, `hara-3`, by refl.
--
-- WHAT IS CLAIMED.  A polynomial identity over ℕ, and three instances.
-- That is all.  It is elementary and it is not new; it is checked here
-- because chapter 10 of the book carries one entry and its subject is
-- the correction terms.
--
-- WHAT IS NOT CLAIMED.  Nothing about the series' convergence, nothing
-- about the saṃskāra terms 1/(4n), n/(4n²+1), (n²+1)/(4n³+5n)
-- themselves, and nothing about the derivation in the Yuktibhāṣā.  No
-- source was opened — `WebFetch` is egress-blocked in this container —
-- so the attribution above is from recall and is marked as such, per
-- the standard `.claude/hooks/priority-ledger.txt` sets for a priority
-- claim: a row asserting what I cannot establish would be the same
-- error as publishing a fitted constant.  A successor with access to
-- the Malayalam text should check the section and correct the header.
--
-- The European restatements (Gregory 1671, Leibniz 1674) carry the
-- series and not the correction terms; that is the standing content of
-- chapter 10 and it is not re-argued here.
------------------------------------------------------------------------

module SamskaraHara_TheAcceleratedDenominatorFactorsExactly where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (ℕ ; zero ; suc ; _+_ ; _·_)
open import Cubical.Tactics.NatSolver.Reflection using (solve)

------------------------------------------------------------------------
-- 1.  The odd number, and the denominator as a product.
------------------------------------------------------------------------

-- n = 2k+1
oddAt : ℕ → ℕ
oddAt k = 2 · k + 1

-- hāra k = 4·k·(k+1)·(2k+1), the k-th denominator, as a product.
hara : ℕ → ℕ
hara k = 4 · k · (k + 1) · oddAt k

------------------------------------------------------------------------
-- 2.  The identity, stated without subtraction.
--
--     n³ = hāra k + n,  for n = 2k+1.
--
-- Given to the solver on the QUANTIFIED goal, per `BUILD.md`'s NatSolver
-- convention.
------------------------------------------------------------------------

cube-is-hara-plus-n : (k : ℕ) → oddAt k · oddAt k · oddAt k ≡ hara k + oddAt k
cube-is-hara-plus-n = solve

------------------------------------------------------------------------
-- 3.  The three instances the Yuktibhāṣā's series opens with.
------------------------------------------------------------------------

hara-1 : hara 1 ≡ 24
hara-1 = refl

hara-2 : hara 2 ≡ 120
hara-2 = refl

hara-3 : hara 3 ≡ 336
hara-3 = refl

-- and the cubes they came from, so the identity is not vacuous on them
cube-1 : oddAt 1 · oddAt 1 · oddAt 1 ≡ 27
cube-1 = refl

cube-2 : oddAt 2 · oddAt 2 · oddAt 2 ≡ 125
cube-2 = refl

cube-3 : oddAt 3 · oddAt 3 · oddAt 3 ≡ 343
cube-3 = refl

------------------------------------------------------------------------
-- 4.  A control, so §2 has content rather than being true by accident:
--     the same shape with the wrong constant is NOT provable by refl.
--     (Stated as the correct value of a near-miss, checked positively —
--     4·k·(k+1) and 4·k·(k+2) differ already at k = 1.)
------------------------------------------------------------------------

near-miss : 4 · 1 · (1 + 2) · oddAt 1 ≡ 36
near-miss = refl
-- 36 ≠ 24, so the (k+1) factor in `hara` is load-bearing.
