{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- NaturalMachine.Sankalita
--
-- संकलित — summation — and वारसंकलित, repeated summation: the Kerala
-- school's engine, and the identity that makes it Piṅgala's array.
--
-- ────────────────────────────────────────────────────────────────────
-- SOURCES
--
--   Piṅgala, *Chandaḥśāstra* (c. 300–200 BCE), ch. 8 — the meru-prastāra,
--   written out as the triangular array by Halāyudha (*Mṛtasañjīvanī*,
--   10th c.), each interior entry the sum of the two above it.  Already
--   checked in this repository as `Pingala.meru` with
--   `Pingala.meruRecurrence`.
--
--   The Kerala school — Mādhava (c. 1400) and the *Yuktibhāṣā*
--   (Jyeṣṭhadeva, c. 1530) — derive the power-sum asymptotics
--   `Σ k^p ≈ n^{p+1}/(p+1)` by REPEATED SUMMATION (vārasaṅkalita), an
--   exact finite operation whose result they then estimate.  The
--   estimation is analysis; the repeated summation is not, and it is the
--   part this lane can hold.
--
-- ────────────────────────────────────────────────────────────────────
-- THE IDENTITY
--
--     sankalita-is-meru :
--       Σ_{m < n} meru (m + r) r  ≡  meru (n + r) (suc r)
--
-- One summation of a column of the array is the next column.  So the
-- Kerala school's repeated summation and Piṅgala's array are the same
-- object, and iterating the identity is exactly vārasaṅkalita:
-- `r`-fold summation of the constant 1 lands on the `r`-th column.
--
-- The proof is two lines given `Pingala.meruRecurrence`, because the
-- recurrence IS the identity's induction step.  That is the content: the
-- two traditions' constructions coincide at the level of the recurrence,
-- not merely in their values.
--
-- ────────────────────────────────────────────────────────────────────
-- WHAT IS NOT CLAIMED
--
-- Nothing analytic.  Mādhava's series, its error terms, and the
-- convergence acceleration are the Kerala school's actual achievement and
-- none of them is here — this lane has no reals.  What is here is the
-- exact finite operation those arguments are built on, and its
-- identification with an array from seventeen centuries earlier.
--
-- Nor is any claim made about transmission.  The two constructions
-- agreeing is a theorem; whether the Kerala mathematicians had Piṅgala's
-- array in view is a historical question this file does not touch.
--
-- CHECKED: Agda 2.6.3, cubical v0.5 — the container, not the repository
-- pin.  No postulates, no holes.
------------------------------------------------------------------------

module NaturalMachine.Sankalita where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (ℕ ; zero ; suc ; _+_ ; +-zero ; +-suc ; +-comm)

open import Pingala using (meru ; meruRecurrence)

------------------------------------------------------------------------
-- 1.  संकलित: the summation operator
------------------------------------------------------------------------

Σ< : (ℕ → ℕ) → ℕ → ℕ
Σ< f zero    = 0
Σ< f (suc n) = Σ< f n + f n

-- वारसंकलित: repeated summation
Σ^ : ℕ → (ℕ → ℕ) → ℕ → ℕ
Σ^ zero    f = f
Σ^ (suc r) f = Σ< (Σ^ r f)

------------------------------------------------------------------------
-- 2.  The edge of the array: past the diagonal every entry is zero
------------------------------------------------------------------------

meru-above : (n d : ℕ) → meru n (n + suc d) ≡ 0
meru-above zero    d = refl
meru-above (suc n) d =
  cong₂ _+_
    (cong (meru n) (sym (+-suc n (suc d))) ∙ meru-above n (suc d))
    (meru-above n d)

meru-diag : (r : ℕ) → meru r (suc r) ≡ 0
meru-diag r =
  cong (meru r) (sym (+-suc r 0 ∙ cong suc (+-zero r))) ∙ meru-above r 0

------------------------------------------------------------------------
-- 3.  THE IDENTITY.  Summing a column of the meru gives the next column.
------------------------------------------------------------------------

sankalita-is-meru :
  (r n : ℕ) → Σ< (λ m → meru (m + r) r) n ≡ meru (n + r) (suc r)
sankalita-is-meru r zero    = sym (meru-diag r)
sankalita-is-meru r (suc n) =
    cong (_+ meru (n + r) r) (sankalita-is-meru r n)
  ∙ sym (meruRecurrence (n + r) r)

------------------------------------------------------------------------
-- 4.  It runs.  The r = 1 column summed is the r = 2 column:
--     1+2+3+4 = 10 = C(5,2).
------------------------------------------------------------------------

column1-sum : Σ< (λ m → meru (m + 1) 1) 4 ≡ 10
column1-sum = refl

column1-is-column2 : Σ< (λ m → meru (m + 1) 1) 4 ≡ meru 5 2
column1-is-column2 = sankalita-is-meru 1 4

-- and the zeroth column, summed, is the first: 1+1+1+1 = 4 = C(4,1)
column0-is-column1 : Σ< (λ m → meru (m + 0) 0) 4 ≡ meru 4 1
column0-is-column1 = sankalita-is-meru 0 4

------------------------------------------------------------------------
-- 5.  वारसंकलित, read off.
--
-- Iterating §3: the r-fold summation of the constant column lands on the
-- r-th column of the meru.  The Kerala school computes
-- `Σ k^p ≈ n^{p+1}/(p+1)` by taking these repeated sums exactly and then
-- estimating them; the exact half is this identity, and it is Piṅgala's
-- array with a different name and seventeen centuries between them.
--
-- Nothing analytic is claimed.  The estimate is the Kerala achievement
-- and it is not here.
------------------------------------------------------------------------
