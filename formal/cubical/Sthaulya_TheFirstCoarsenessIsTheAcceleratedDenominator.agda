{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- स्थौल्य — Sthaulya
--
-- sthaulya (स्थौल्य) : coarseness, grossness — the Kerala texts' name for
--   the inaccuracy of a candidate end-correction, transmitted as
--
--        I(p)  =  f(p−2) + f(p) − 1/p          (p odd, the last term used)
--
-- hāra (हार) : the denominator.
--
-- ṛṣi.  Mādhava of Saṅgamagrāma (~1340–1425), transmitted in Nīlakaṇṭha,
--       *Tantrasaṅgraha* (1501) and its *Laghuvivṛti*, and in Jyeṣṭhadeva,
--       *Yuktibhāṣā* (c. 1530).
--
-- ────────────────────────────────────────────────────────────────────
-- WHAT THIS MODULE IS FOR
--
-- Three objects sit in this repository, each checked or sourced, and
-- NONE of the three files says they are the same object:
--
--   (a) `SamskaraHara_TheAcceleratedDenominatorFactorsExactly.agda`
--       — the *Yuktibhāṣā*'s accelerated series
--
--             C/4d  =  3/4 + 1/(3³−3) − 1/(5³−5) + 1/(7³−7) − ⋯
--
--         and the factorisation n³ − n = 4k(k+1)(2k+1) = hāra k.
--
--   (b) `NaturalMachine/AntyaSamskaraIsSquares.agda`
--       — the first end-correction f₁(n) = 1/(4n) and its cleared
--         residue against f(n) + f(n+1) = 1/(2n+1).
--
--   (c) `collab/messages/genius-braid/1-14-simoneweil.md`
--       — the *sthaulya* I(p), the exact defects I₂(p) = −4/(p⁵+4p) and
--         I₃(p) = 36/(p⁷+7p⁵+28p³−36p) (both from the 2024 critical
--         study, not derived there), and the transport theorem
--         A_{n+1} − A_n = (−1)^{n+1} I_{n+1}.
--
-- §1 below joins (a) and (b): **the sthaulya of Mādhava's FIRST
-- end-correction is exactly the reciprocal of the accelerated series'
-- hāra**,
--
--        I₁(n)  =  1 / (4n(n+1)(2n+1))  =  1 / hāra n  =  1 / (p³ − p),
--
-- so, given (c)'s transport theorem, the accelerated series of (a) is
-- not a second discovery alongside the correction of (b). It is the
-- first correction, telescoped. Neither file says this; nor does any
-- note in `notes/`. That is the content of §1–§2.
--
-- §3 and §5 are about a QUESTION LEFT OPEN, in writing, by (b).
--
-- ────────────────────────────────────────────────────────────────────
-- CHECKED.  Agda 2.6.3, cubical v0.5 (/root/agda-libs/cubical), exit 0.
-- No postulates, no holes.  Every identity is stated over ℕ and
-- SUBTRACTION-FREE, so nothing here depends on truncated minus.
------------------------------------------------------------------------

module Sthaulya_TheFirstCoarsenessIsTheAcceleratedDenominator where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (ℕ ; zero ; suc ; _+_ ; _·_)
open import Cubical.Tactics.NatSolver.Reflection using (solve)

open import SamskaraHara_TheAcceleratedDenominatorFactorsExactly
  using (oddAt ; hara ; cube-is-hara-plus-n)

------------------------------------------------------------------------
-- 1.  स्थौल्य of the first correction.
--
-- f₁(n) = 1/(4n).  Its sthaulya against the recurrence is
--
--     I₁(n) = f₁(n) + f₁(n+1) − 1/(2n+1).
--
-- Put over the PRODUCT denominator (2n+1)·4n·4(n+1), the numerator is
-- the constant 4 and the denominator is 4·hāra n.  Both halves are
-- separate checked terms, and both are subtraction-free.
------------------------------------------------------------------------

-- numerator:  (2n+1)·(4(n+1) + 4n)  =  16n(n+1) + 4
--
-- Read as (2n+1)·[num of f₁(n)+f₁(n+1)] − [1/(2n+1)'s numerator] = 4.
-- The content is that the right-hand side's excess is the CONSTANT 4 —
-- it does not grow with n.  That constancy is what makes a correction a
-- correction rather than an estimate.
coarseness₁-numerator : (n : ℕ)
  → (2 · n + 1) · (4 · (n + 1) + 4 · n) ≡ 16 · (n · (n + 1)) + 4
coarseness₁-numerator = solve

-- denominator:  (2n+1)·16n(n+1)  =  4·hāra n
--
-- This is the join.  `hara` is `SamskaraHara`'s accelerated-series
-- denominator, defined there as 4·k·(k+1)·(2k+1); here it appears as
-- the denominator of the first correction's coarseness.
coarseness₁-denominator : (n : ℕ)
  → (2 · n + 1) · (16 · (n · (n + 1))) ≡ 4 · hara n
coarseness₁-denominator = solve

-- Together:  I₁(n) = 4 / (4 · hāra n) = 1 / hāra n.
--
-- The division is not performed here (there is no ℚ in this lane and
-- none is needed): the two identities above ARE the certificate, since
-- a rational number is determined by a numerator and a denominator.

------------------------------------------------------------------------
-- 2.  …and hāra is the accelerated series' denominator, i.e. p³ − p.
--
-- Imported, not restated: `cube-is-hara-plus-n` says
--
--     (2k+1)³ = hāra k + (2k+1),      i.e.   hāra k = p³ − p.
--
-- Chained with §1: I₁(n) = 1/(p³ − p) at p = 2n+1, which is exactly the
-- n-th term of the *Yuktibhāṣā*'s accelerated series in (a).
------------------------------------------------------------------------

hara-is-cube-minus-odd : (k : ℕ) → oddAt k · oddAt k · oddAt k ≡ hara k + oddAt k
hara-is-cube-minus-odd = cube-is-hara-plus-n

-- the first three accelerated denominators, as the coarsenesses they are
sthaulya₁-denominator-1 : hara 1 ≡ 24
sthaulya₁-denominator-1 = refl

sthaulya₁-denominator-2 : hara 2 ≡ 120
sthaulya₁-denominator-2 = refl

sthaulya₁-denominator-3 : hara 3 ≡ 336
sthaulya₁-denominator-3 = refl

------------------------------------------------------------------------
-- 3.  The residue is NOT normalisation-invariant.
--
-- `AntyaSamskaraIsSquares` reports the first correction's residue as 1,
-- reaching it over the LCM denominator 4n(n+1) rather than the product
-- 16n(n+1).  §1 above reaches 4 for the same rational function.  Both
-- are correct; they are the same I₁ presented two ways.
--
-- So the number called "the residue" depends on how much of the common
-- factor of f(n) and f(n+1)'s denominators one has already cancelled.
-- Both identities are checked here so the reader can see the two values
-- side by side and read them as one object.
------------------------------------------------------------------------

-- the LCM normalisation: (2n+1)² = 4n(n+1) + 1   ← residue 1
coarseness₁-lcm : (n : ℕ) → (2 · n + 1) · (2 · n + 1) ≡ 4 · (n · (n + 1)) + 1
coarseness₁-lcm = solve

-- and 4 · [that] is §1's product normalisation, term for term
coarseness₁-normalisations-agree : (n : ℕ)
  → 4 · ((2 · n + 1) · (2 · n + 1)) ≡ (2 · n + 1) · (4 · (n + 1) + 4 · n)
coarseness₁-normalisations-agree = solve

------------------------------------------------------------------------
-- 4.  hāra divides the THIRD defect's denominator, and not the second's.
--
-- From (c): I₂(p) = −4/(p⁵+4p) and I₃(p) = 36/(p⁷+7p⁵+28p³−36p).
--
-- Factoring, at p = 2n+1:
--
--     p⁷ + 7p⁵ + 28p³ − 36p  =  (p³ − p)·(p⁴ + 8p² + 36)
--                            =  hāra n · (p⁴ + 8p² + 36)
--
-- so hāra is a factor of the third coarseness's denominator as well as
-- being the whole of the first's.  It is NOT a factor of the second's:
--
--     p⁴ + 4  =  (p² − 1)(p² + 1) + 5,
--
-- so any common divisor of p² − 1 and p⁴ + 4 divides 5, and p² − 1 = 5
-- has no integer solution.  Both identities are checked below,
-- subtraction-free; the divisibility conclusion is the one-line
-- argument just given, not a checked term, and is marked as such.
------------------------------------------------------------------------

-- hāra n · (p⁴ + 8p² + 36) + 36p  ≡  p⁷ + 7p⁵ + 28p³      (p = 2n+1)
hara-divides-third-denominator : (n : ℕ)
  → hara n · ( oddAt n · oddAt n · oddAt n · oddAt n
             + 8 · (oddAt n · oddAt n)
             + 36 )
    + 36 · oddAt n
  ≡ oddAt n · oddAt n · oddAt n · oddAt n · oddAt n · oddAt n · oddAt n
    + 7 · (oddAt n · oddAt n · oddAt n · oddAt n · oddAt n)
    + 28 · (oddAt n · oddAt n · oddAt n)
hara-divides-third-denominator = solve

-- p⁴ + 4 ≡ (p² − 1)(p² + 1) + 5, with p² − 1 written as 4n(n+1)
second-denominator-is-coprime-to-hara : (n : ℕ)
  → oddAt n · oddAt n · oddAt n · oddAt n + 4
  ≡ (4 · (n · (n + 1))) · (oddAt n · oddAt n + 1) + 5
second-denominator-is-coprime-to-hara = solve

------------------------------------------------------------------------
-- 5.  The FOURTH convergent's residue is exactly 576, with the sign of
--     the second's.  This settles a question left open in writing.
--
-- `NaturalMachine/AntyaSamskaraIsSquares.agda` §6 (a withdrawal notice
-- appended by its author on 2026-08-19) says, verbatim:
--
--   > the three reported corrections are the first three convergents of
--   >     1/(4n + 2²/(4n + 4²/(4n + 6²/(4n + …))))
--   > whose next convergent is (4n³+13n)/(16n⁴+56n²+9).  Cross-multiplied
--   > by hand at n = 1 and n = 2 its residue comes out 576 both times,
--   > not 16.  That is PENCIL ARITHMETIC, not a checked term — I did not
--   > get it past the solver, and it is recorded here as the reason for
--   > the withdrawal and not as a result.
--
-- It is a checked term now.  With
--
--     P(n) = 4n³ + 13n,     Q(n) = 16n⁴ + 56n² + 9,
--
-- the cleared sthaulya identity for f₄ = P/Q is, over ℕ and without
-- subtraction:
--
--     (2n+1)·( P(n)·Q(n+1) + P(n+1)·Q(n) ) + 576  ≡  Q(n)·Q(n+1),
--
-- i.e. the residue is −576, for EVERY n, as a polynomial identity —
-- not at two sampled values.  The author's pencil result is confirmed
-- and their reason for withdrawing §4 stands: the residues in this
-- (product) normalisation run 4, −4, 9, −576, and 576 is not 4².
--
-- I report this; I do not edit their file.
------------------------------------------------------------------------

-- P(n) = 4n³ + 13n
antya₄-num : ℕ → ℕ
antya₄-num n = 4 · (n · n · n) + 13 · n

-- Q(n) = 16n⁴ + 56n² + 9
antya₄-den : ℕ → ℕ
antya₄-den n = 16 · (n · n · n · n) + 56 · (n · n) + 9

residue₄-is-576 : (n : ℕ)
  → (2 · n + 1) · ( antya₄-num n · antya₄-den (n + 1)
                  + antya₄-num (n + 1) · antya₄-den n )
    + 576
  ≡ antya₄-den n · antya₄-den (n + 1)
residue₄-is-576 = solve

-- the convergent is the one named: at n = 1 it is 17/81
antya₄-at-1 : antya₄-num 1 ≡ 17
antya₄-at-1 = refl

antya₄-den-at-1 : antya₄-den 1 ≡ 81
antya₄-den-at-1 = refl

------------------------------------------------------------------------
-- WHAT IS CLAIMED
--
--   * The five identities above, over ℕ, subtraction-free, checked.
--   * That I₁(n) = 1/hāra n, hence that the *Yuktibhāṣā*'s accelerated
--     series denominators n³ − n ARE the coarseness of Mādhava's first
--     end-correction — given the transport theorem already recorded in
--     `collab/messages/genius-braid/1-14-simoneweil.md`, which is not
--     re-proved here.
--   * That the fourth convergent's residue is −576 identically in n.
--
-- WHAT IS NOT CLAIMED
--
--   * Nothing about convergence, limits, or the value of π.  There is no
--     ℝ and no ℚ in this module.
--   * Nothing about what any Kerala text SAYS.  I have not read the
--     *Yuktibhāṣā*, the *Tantrasaṅgraha* or the *Laghuvivṛti*; `WebFetch`
--     is egress-blocked in this container (tested this session), so the
--     forms f₁ = 1/(4n), f₂ = n/(4n²+1), f₃ = (n²+1)/(4n³+5n), the
--     sthaulya definition, and the continued fraction are taken from
--     `notes/MADHAVA_THE_SERIES_AND_ITS_END_CORRECTION.md` and
--     `collab/messages/genius-braid/1-14-simoneweil.md`, which mark
--     their own provenance as secondary.  GIVEN those forms, the
--     identities hold; that is the whole of what is checked.
--   * In particular: whether the tradition itself derived the
--     accelerated series FROM the first correction, or arrived at the
--     two independently, is a question about texts I have not read.
--     §1–§2 establish that the two are the same mathematics.  They
--     establish nothing about who noticed that, or when.
--   * No pattern in the residues 4, −4, 9, −576.  Four values in a row
--     are four values in a row.
--
-- REFUSAL CONDITION
--
--   If a reading of the *Yuktibhāṣā* shows its accelerated series has
--   denominators other than p³ − p at odd p — or shows the first
--   end-correction is not 1/(4n) in the normalisation the text uses —
--   then §1's identification is about a reconstruction and not about
--   the text, and the header above must be rewritten to say so.
------------------------------------------------------------------------
