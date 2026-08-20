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

------------------------------------------------------------------------
-- CORRECTION BLOCK, appended 2026-08-20 by the author.  Nothing above is
-- changed; the theorems are unaffected.
--
-- The header says "No source was opened — `WebFetch` is egress-blocked in
-- this container — so the attribution above is from recall."  That was
-- true about the outside world and false about this repository.  Two
-- objects were on disk when it was written:
--
-- 1.  `kanye-devotional/READ_THIS_FIRST_BEFORE_ANYTHING_ELSE_IN_THIS_REPO_…txt`
--     (960 KB, cited by zero files) contains a sourced account of exactly
--     this object, and it names the omission in this module while it was
--     being made:
--
--       "this repository's own front matter says the source coverage hook
--        has been reporting Yuktibhāṣā: 0 notes and Tantrasaṅgraha: 0
--        notes for days while somebody was writing a module about
--        Mādhava's series."
--
--     Its content, which this module lacked:  the series alone needs on
--     the order of 10⁵ terms for five decimals; the *saṃskāra* correction
--     terms are the result, not an ornament on it; the third correction
--     puts a few dozen terms at eleven decimal places; Mādhava states
--     π = 3.14159265359.  In `CLAUDE.md`'s own words, the error term is
--     the content — so the accelerated denominator checked here is the
--     denominator OF THE ERROR TERM, and that is why it is the object.
--
-- 2.  `notes/` did NOT have zero mentions by 2026-08-20: the counts are
--     now Yuktibhāṣā 9 notes, Tantrasaṅgraha 5, Nīlakaṇṭha 8 (measured by
--     cf-tessera-b-3 this session).  `CLAUDE.md` still records them as
--     0, 0 and 1.  That gap has largely closed and the front matter has
--     not caught up.
--
-- WHAT THIS MODULE'S THEOREM TURNS OUT TO BE.  `cf-tessera-b-3` landed
-- `formal/cubical/Sthaulya_TheFirstCoarsenessIsTheAcceleratedDenominator.agda`
-- (`--safe`, EXIT 0) proving
--
--       I₁(n) = 1/(4n) + 1/(4(n+1)) − 1/(2n+1) = 1/(4n(n+1)(2n+1))
--             = 1/hāra(n) = 1/(p³ − p)
--
-- so `hara` as defined above is the denominator of the FIRST END
-- CORRECTION, and the *Yuktibhāṣā*'s accelerated series is that
-- correction telescoped — not a second construction standing beside it.
-- Three files held the pieces and none said they were one object; this
-- was one of the three.
--
-- Nothing here is claimed of the *Yuktibhāṣā*'s own derivation, which is
-- in Malayalam prose and which I have not read.  `yukti` means reasoning:
-- the book gives the arguments, not the results for memorisation.  That
-- is the reason to read it and it is still unread by me.
------------------------------------------------------------------------
