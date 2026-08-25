{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- Texts.Sankalita — the Kerala vārasaṅkalita engine (root Sankalita_… is Āryabhaṭa's series sums)
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

module Texts.Sankalita where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (ℕ ; zero ; suc ; _+_ ; +-zero ; +-suc ; +-comm ; snotz ; injSuc)
open import Cubical.Data.Sigma using (_×_ ; _,_)
open import Cubical.Relation.Nullary using (¬_)

open import Texts.PingalaPrastara using (meru ; meruRecurrence ; matra)

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

------------------------------------------------------------------------
-- 6.  वारसंकलित as a theorem, not a remark.
--
-- §5 asserts in prose that iterating §3 gives the r-fold summation of the
-- constant column.  Asserting is not proving, so here it is proved — and
-- the unshifted form of the identity turns out to be the shorter one, and
-- needs no edge lemma at all.
------------------------------------------------------------------------

Σ<-cong : (f g : ℕ → ℕ) → ((m : ℕ) → f m ≡ g m) → (n : ℕ) → Σ< f n ≡ Σ< g n
Σ<-cong f g h zero    = refl
Σ<-cong f g h (suc n) = cong₂ _+_ (Σ<-cong f g h n) (h n)

-- the unshifted identity: summing column r up to n is entry (n, r+1)
sankalita-column :
  (r n : ℕ) → Σ< (λ m → meru m r) n ≡ meru n (suc r)
sankalita-column r zero    = refl
sankalita-column r (suc n) =
    cong (_+ meru n r) (sankalita-column r n)
  ∙ sym (meruRecurrence n r)

one : ℕ → ℕ
one _ = 1

meru-col0 : (n : ℕ) → meru n 0 ≡ 1
meru-col0 zero    = refl
meru-col0 (suc n) = refl

-- THE STATEMENT.  r-fold summation of the constant 1 is the r-th column.
varasankalita : (r n : ℕ) → Σ^ r one n ≡ meru n r
varasankalita zero    n = sym (meru-col0 n)
varasankalita (suc r) n =
    Σ<-cong (Σ^ r one) (λ m → meru m r) (varasankalita r) n
  ∙ sankalita-column r n

------------------------------------------------------------------------
-- 7.  It runs.
--
--   Σ^ 2 1 at 5  =  0+1+2+3+4  =  10  =  C(5,2)
--   Σ^ 3 1 at 5  =  0+0+1+3+6  =  10  =  C(5,3)
------------------------------------------------------------------------

vara2 : Σ^ 2 one 5 ≡ 10
vara2 = refl

vara2-is-meru : Σ^ 2 one 5 ≡ meru 5 2
vara2-is-meru = varasankalita 2 5

vara3-is-meru : Σ^ 3 one 5 ≡ meru 5 3
vara3-is-meru = varasankalita 3 5

------------------------------------------------------------------------
-- So the Kerala school's repeated summation is Piṅgala's array, proved
-- rather than remarked, and the shifted identity of §3 is the same fact
-- with an offset.  Both are two lines from `meruRecurrence`, which is
-- Halāyudha's rule that each entry is the sum of the two above it.
------------------------------------------------------------------------

------------------------------------------------------------------------
-- 8.  The obvious next identity, and why the obvious attempt fails.
--
-- This repository holds two Indian arrays: `Pingala.meru` (the
-- meru-prastāra) and `Pingala.matra` (Virahāṅka's mātrāmeru).  The
-- classical identity relating them is the shallow-diagonal sum,
--
--     mātrā n  =  Σ_k  C(n − k, k),
--
-- and it is checked numerically by `Pingala`'s own worked instances at
-- small n.  It is NOT proved here, and the reason is worth recording so
-- the next attempt does not repeat it.
--
-- THE NATURAL ENCODING, which walks the diagonal by decreasing the first
-- index by two and increasing the second by one:
--
--     go zero            j = meru j j
--     go (suc zero)      j = meru (suc j) j
--     go (suc (suc i))   j = meru (suc (suc i) + j) j + go i (suc j)
--
-- gives the right values at `j = 0` — `go 0 0 … go 4 0` are `1 1 2 3 5`,
-- which is `mātrā 0 … mātrā 4`.  So one reaches for the Fibonacci
-- recurrence
--
--     go (suc (suc i)) j  ≟  go (suc i) j + go i j
--
-- and it is FALSE for `j > 0`.  Counterexample, by computation:
-- `go 2 1 = meru 3 1 + meru 2 2 = 3 + 1 = 4`, while
-- `go 1 1 + go 0 1 = meru 2 1 + meru 1 1 = 2 + 1 = 3`.
--
-- The recurrence holds only on the `j = 0` slice, so it cannot be the
-- induction hypothesis, and strengthening it is the whole problem.
--
-- THE ROUTE THAT SHOULD WORK, and it is Piṅgala's own: count by guru.  A
-- pattern of duration `n` with `k` guru has `n − k` syllables, so
--
--     Metre n  ≃  Σ_k  Chosen (n − k) k,
--
-- and `Pingala.meruCount : Iso (Chosen n k) (Fin (meru n k))` is already
-- checked.  That is a typed argument in the tradition's own terms rather
-- than a numeric induction, and it needs a dependent sum over a finite
-- index plus truncated subtraction — neither hard, both bookkeeping.
--
-- Recorded as an open item with a failed approach attached, which is
-- worth more than an open item alone.
------------------------------------------------------------------------

------------------------------------------------------------------------
-- 9.  Refinement of §8's diagnosis, after looking further.
--
-- §8 says the Fibonacci recurrence for `go` fails off the `j = 0` slice,
-- and gives the counterexample.  That stands.  What §8 did not say is
-- WHY, and the reason narrows the next attempt considerably.
--
-- The classical proof applies Pascal to each term and reindexes the two
-- resulting families onto the two smaller sums.  That works because
-- `C(m,k) = 0` for `k > m`, so the sums are effectively infinite and the
-- reindexing costs nothing.  `go`'s two-step descent instead truncates at
-- `⌊i/2⌋` — a HARD bound — and after the shift the two families need
-- ranges the truncation does not supply.  The failure is the truncation,
-- not the recurrence.
--
-- So the encoding to use runs the sum LONG and lets the zeros do the
-- work:
--
--     D n  =  Σ_{t ≤ n}  meru (n ∸ t) t
--
-- which gives `1 1 2 3 5` at `n = 0 … 4` by computation.  The cost of
-- that encoding is truncated subtraction inside a Pascal step, whose edge
-- conditions (`n ∸ t = 0`) then need their own case analysis — which is
-- why this is bookkeeping rather than a two-line proof, and why the typed
-- route of §8 (count by guru, using `Pingala.meruCount`) may still be the
-- shorter one.
--
-- Both routes are now specified well enough to be attempted without
-- rediscovering the obstacle.  That is what this section is for.
------------------------------------------------------------------------

------------------------------------------------------------------------
-- 10.  The monus obstacle of §9 is removable, and here is the encoding.
--
-- §9 says the long-sum encoding costs truncated subtraction inside a
-- Pascal step.  It does not have to: the same sum is the ANTIDIAGONAL of
-- the array, and antidiagonals enumerate structurally.
--
--     Σ_{t ≤ n} meru (n ∸ t) t  =  Σ_{a + b = n} meru a b
--
-- and the right-hand side needs no subtraction:
------------------------------------------------------------------------

AD : ℕ → ℕ → ℕ
AD a zero    = meru a 0
AD a (suc b) = meru a (suc b) + AD (suc a) b

antidiag : ℕ → ℕ
antidiag n = AD 0 n

-- the mātrāmeru's values, by computation
antidiag-0 : antidiag 0 ≡ 1
antidiag-0 = refl

antidiag-1 : antidiag 1 ≡ 1
antidiag-1 = refl

antidiag-2 : antidiag 2 ≡ 2
antidiag-2 = refl

antidiag-3 : antidiag 3 ≡ 3
antidiag-3 = refl

antidiag-4 : antidiag 4 ≡ 5
antidiag-4 = refl

antidiag-5 : antidiag 5 ≡ 8
antidiag-5 = refl

-- and they agree with Virahāṅka's array, at these frontiers
antidiag-is-matra-4 : antidiag 4 ≡ matra 4
antidiag-is-matra-4 = refl

antidiag-is-matra-5 : antidiag 5 ≡ matra 5
antidiag-is-matra-5 = refl

------------------------------------------------------------------------
-- 11.  What is left, stated exactly.
--
--     GOAL :  (n : ℕ) → antidiag (suc (suc n)) ≡ antidiag (suc n) + antidiag n
--
-- from which `antidiag n ≡ matra n` follows by two-step induction against
-- `Pingala.matraRecurrence`, the base cases being the `refl`s above.
--
-- Of the two obstacles §§8–9 identified:
--   * the hard truncation is gone — `AD` runs to the array's own edge and
--     the zero entries end it;
--   * the truncated subtraction is gone — `AD` enumerates the
--     antidiagonal by structural recursion on the second index.
--
-- What remains is boundary bookkeeping in the Pascal step:
-- `meruRecurrence` decomposes by the FIRST index, so applying it to
-- `meru a b` needs `a` a successor, and the `a = 0` column has to be
-- handled separately in each of the two reindexed families.  That is a
-- case analysis, not an obstacle, and it is the whole of what is left.
--
-- Three sections of diagnosis to remove two obstacles and name the third
-- precisely.  Recorded that way because "this is bookkeeping" was said in
-- §8 and was not yet true.
------------------------------------------------------------------------

------------------------------------------------------------------------
-- 12.  CORRECTION to §11: "the whole of what is left" was not checked,
--      and it is wrong.
--
-- §11 says the remaining work is boundary bookkeeping — "a case analysis,
-- not an obstacle".  I asserted that without trying the induction.  The
-- induction does not close, and the reason is not a boundary case.
--
-- Unfolding the goal at `n = suc m` gives
--
--     AD 1 (suc (suc m))  ≡  AD 1 (suc m) + AD 1 m
--
-- because `meru 0 (suc _)` is zero.  So one hopes the recurrence holds
-- for `AD a` at every `a`.  It holds at `a = 1` and FAILS at `a = 2`:
------------------------------------------------------------------------

AD1-values : (AD 1 0 ≡ 1) × ((AD 1 1 ≡ 2) × ((AD 1 2 ≡ 3) × (AD 1 3 ≡ 5)))
AD1-values = refl , refl , refl , refl

AD2-values : (AD 2 0 ≡ 1) × ((AD 2 1 ≡ 3) × ((AD 2 2 ≡ 5) × (AD 2 3 ≡ 8)))
AD2-values = refl , refl , refl , refl

-- 5 ≠ 3 + 1: the row-2 antidiagonal sums are not Fibonacci-recurrent
AD2-breaks-the-recurrence : ¬ (AD 2 2 ≡ AD 2 1 + AD 2 0)
AD2-breaks-the-recurrence p = snotz (injSuc (injSuc (injSuc (injSuc p))))

------------------------------------------------------------------------
-- 13.  What that actually shows, and where the thread stands.
--
-- `AD a b` truncates at the `b` end — the antidiagonal from `(a,b)` runs
-- out of room before the full shallow diagonal of row `a` does — so for
-- `a ≥ 2` it is not the shallow diagonal at all, and no induction whose
-- intermediate objects are `AD a _` can work.  `antidiag n = AD 0 n` is
-- correct; the family it sits in is not closed under the recurrence.
--
-- So THREE encodings have now failed, each for a different reason:
--
--   §8   two-step descent      hard truncation at ⌊i/2⌋
--   §9   long sum with monus   subtraction inside the Pascal step
--   §11  antidiagonal `AD`     the family is not closed under reindexing
--
-- and the typed route of §8 — `Metre n ≃ Σ_k Chosen (n−k) k`, using
-- `Pingala.meruCount` — is the only one still standing.  That is now a
-- recommendation with three refutations behind it rather than a guess.
--
-- Recorded at length because the alternative was to leave §11's "this is
-- bookkeeping" in place, and it is exactly the kind of sentence that
-- costs the next reader a day.
------------------------------------------------------------------------
