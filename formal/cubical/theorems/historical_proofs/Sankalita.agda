{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- Sankalita â” the Kerala vrasakalita engine (root Sankalita_â¦ is ryabhaa's series sums)
--
-- ààà•à²à¿à â” summation â” and àµà¾à°ààà•à²à¿à, repeated summation: the Kerala
-- school's engine, and the identity that makes it Pigala's array.
--
-- â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”
-- SOURCES
--
--   Pigala, *Chandastra* (c. 300â“200 BCE), ch. 8 â” the meru-prastra,
--   written out as the triangular array by Halyudha (*Mtasajvan*,
--   10th c.), each interior entry the sum of the two above it.  Already
--   checked in this repository as `Pingala.meru` with
--   `Pingala.meruRecurrence`.
--
--   The Kerala school â” Mdhava (c. 1400) and the *Yuktibh*
--   (Jyehadeva, c. 1530) â” derive the power-sum asymptotics
--   `Î k^p â‰ˆ n^{p+1}/(p+1)` by REPEATED SUMMATION (vrasakalita), an
--   exact finite operation whose result they then estimate.  The
--   estimation is analysis; the repeated summation is not, and it is the
--   part this lane can hold.
--
-- â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”
-- THE IDENTITY
--
--     sankalita-is-meru :
--       Î_{m < n} meru (m + r) r  â‰¡  meru (n + r) (suc r)
--
-- One summation of a column of the array is the next column.  So the
-- Kerala school's repeated summation and Pigala's array are the same
-- object, and iterating the identity is exactly vrasakalita:
-- `r`-fold summation of the constant 1 lands on the `r`-th column.
--
-- The proof is two lines given `Pingala.meruRecurrence`, because the
-- recurrence IS the identity's induction step.  That is the content: the
-- two traditions' constructions coincide at the level of the recurrence,
-- not merely in their values.
------------------------------------------------------------------------

module Sankalita where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (â„• ; zero ; suc ; _+_ ; +-zero ; +-suc ; +-comm ; snotz ; injSuc)
open import Cubical.Data.Sigma using (_Ã—_ ; _,_)
open import Cubical.Relation.Nullary using (Â¬_)

open import PingalaPrastara using (meru ; meruRecurrence ; matra)

------------------------------------------------------------------------
-- 1.  ààà•à²à¿à: the summation operator
------------------------------------------------------------------------

Î£< : (â„• â†’ â„•) â†’ â„• â†’ â„•
Î£< f zero    = 0
Î£< f (suc n) = Î£< f n + f n

-- àµà¾à°ààà•à²à¿à: repeated summation
Î£^ : â„• â†’ (â„• â†’ â„•) â†’ â„• â†’ â„•
Î£^ zero    f = f
Î£^ (suc r) f = Î£< (Î£^ r f)

------------------------------------------------------------------------
-- 2.  The edge of the array: past the diagonal every entry is zero
------------------------------------------------------------------------

meru-above : (n d : â„•) â†’ meru n (n + suc d) â‰¡ 0
meru-above zero    d = refl
meru-above (suc n) d =
  congâ‚‚ _+_
    (cong (meru n) (sym (+-suc n (suc d))) âˆ™ meru-above n (suc d))
    (meru-above n d)

meru-diag : (r : â„•) â†’ meru r (suc r) â‰¡ 0
meru-diag r =
  cong (meru r) (sym (+-suc r 0 âˆ™ cong suc (+-zero r))) âˆ™ meru-above r 0

------------------------------------------------------------------------
-- 3.  THE IDENTITY.  Summing a column of the meru gives the next column.
------------------------------------------------------------------------

sankalita-is-meru :
  (r n : â„•) â†’ Î£< (Î» m â†’ meru (m + r) r) n â‰¡ meru (n + r) (suc r)
sankalita-is-meru r zero    = sym (meru-diag r)
sankalita-is-meru r (suc n) =
    cong (_+ meru (n + r) r) (sankalita-is-meru r n)
  âˆ™ sym (meruRecurrence (n + r) r)

------------------------------------------------------------------------
-- 4.  It runs.  The r = 1 column summed is the r = 2 column:
--     1+2+3+4 = 10 = C(5,2).
------------------------------------------------------------------------

column1-sum : Î£< (Î» m â†’ meru (m + 1) 1) 4 â‰¡ 10
column1-sum = refl

column1-is-column2 : Î£< (Î» m â†’ meru (m + 1) 1) 4 â‰¡ meru 5 2
column1-is-column2 = sankalita-is-meru 1 4

-- and the zeroth column, summed, is the first: 1+1+1+1 = 4 = C(4,1)
column0-is-column1 : Î£< (Î» m â†’ meru (m + 0) 0) 4 â‰¡ meru 4 1
column0-is-column1 = sankalita-is-meru 0 4

------------------------------------------------------------------------
-- 5.  àµà¾à°ààà•à²à¿à, read off.
--
-- Iterating Â§3: the r-fold summation of the constant column lands on the
-- r-th column of the meru.  The Kerala school computes
-- `Î k^p â‰ˆ n^{p+1}/(p+1)` by taking these repeated sums exactly and then
-- estimating them; the exact half is this identity, and it is Pigala's
-- array with a different name and seventeen centuries between them.
------------------------------------------------------------------------

------------------------------------------------------------------------
-- 6.  àµà¾à°ààà•à²à¿à as a theorem, not a remark.
--
-- Â§5 asserts in prose that iterating Â§3 gives the r-fold summation of the
-- constant column.  Asserting is not proving, so here it is proved â” and
-- the unshifted form of the identity turns out to be the shorter one, and
-- needs no edge lemma at all.
------------------------------------------------------------------------

Î£<-cong : (f g : â„• â†’ â„•) â†’ ((m : â„•) â†’ f m â‰¡ g m) â†’ (n : â„•) â†’ Î£< f n â‰¡ Î£< g n
Î£<-cong f g h zero    = refl
Î£<-cong f g h (suc n) = congâ‚‚ _+_ (Î£<-cong f g h n) (h n)

-- the unshifted identity: summing column r up to n is entry (n, r+1)
sankalita-column :
  (r n : â„•) â†’ Î£< (Î» m â†’ meru m r) n â‰¡ meru n (suc r)
sankalita-column r zero    = refl
sankalita-column r (suc n) =
    cong (_+ meru n r) (sankalita-column r n)
  âˆ™ sym (meruRecurrence n r)

one : â„• â†’ â„•
one _ = 1

meru-col0 : (n : â„•) â†’ meru n 0 â‰¡ 1
meru-col0 zero    = refl
meru-col0 (suc n) = refl

-- THE STATEMENT.  r-fold summation of the constant 1 is the r-th column.
varasankalita : (r n : â„•) â†’ Î£^ r one n â‰¡ meru n r
varasankalita zero    n = sym (meru-col0 n)
varasankalita (suc r) n =
    Î£<-cong (Î£^ r one) (Î» m â†’ meru m r) (varasankalita r) n
  âˆ™ sankalita-column r n

------------------------------------------------------------------------
-- 7.  It runs.
--
--   Î^ 2 1 at 5  =  0+1+2+3+4  =  10  =  C(5,2)
--   Î^ 3 1 at 5  =  0+0+1+3+6  =  10  =  C(5,3)
------------------------------------------------------------------------

vara2 : Î£^ 2 one 5 â‰¡ 10
vara2 = refl

vara2-is-meru : Î£^ 2 one 5 â‰¡ meru 5 2
vara2-is-meru = varasankalita 2 5

vara3-is-meru : Î£^ 3 one 5 â‰¡ meru 5 3
vara3-is-meru = varasankalita 3 5

------------------------------------------------------------------------
-- So the Kerala school's repeated summation is Pigala's array, proved
-- rather than remarked, and the shifted identity of Â§3 is the same fact
-- with an offset.  Both are two lines from `meruRecurrence`, which is
-- Halyudha's rule that each entry is the sum of the two above it.
------------------------------------------------------------------------

------------------------------------------------------------------------
-- 8.  The shallow-diagonal identity, and why the natural encoding fails.
--
-- This repository holds two Indian arrays: `Pingala.meru` (the
-- meru-prastra) and `Pingala.matra` (Virahka's mtrmeru).  The
-- classical identity relating them is the shallow-diagonal sum,
--
--     mtr n  =  Î_k  C(n âˆ’ k, k),
--
-- and it is checked numerically by `Pingala`'s own worked instances at
-- small n.  The natural encoding does not prove it:
--
-- THE NATURAL ENCODING, which walks the diagonal by decreasing the first
-- index by two and increasing the second by one:
--
--     go zero            j = meru j j
--     go (suc zero)      j = meru (suc j) j
--     go (suc (suc i))   j = meru (suc (suc i) + j) j + go i (suc j)
--
-- gives the right values at `j = 0` â” `go 0 0 â¦ go 4 0` are `1 1 2 3 5`,
-- which is `mtr 0 â¦ mtr 4`.  So one reaches for the Fibonacci
-- recurrence
--
--     go (suc (suc i)) j  â‰Ÿ  go (suc i) j + go i j
--
-- and it is FALSE for `j > 0`.  Counterexample, by computation:
-- `go 2 1 = meru 3 1 + meru 2 2 = 3 + 1 = 4`, while
-- `go 1 1 + go 0 1 = meru 2 1 + meru 1 1 = 2 + 1 = 3`.
--
-- The recurrence holds only on the `j = 0` slice, so it cannot be the
-- induction hypothesis, and strengthening it is the whole problem.
--
-- THE ROUTE THAT WORKS, and it is Pigala's own: count by guru.  A
-- pattern of duration `n` with `k` guru has `n âˆ’ k` syllables, so
--
--     Metre n  â‰  Î_k  Chosen (n âˆ’ k) k,
--
-- and `Pingala.meruCount : Iso (Chosen n k) (Fin (meru n k))` is already
-- checked.  That is a typed argument in the tradition's own terms rather
-- than a numeric induction.
------------------------------------------------------------------------

------------------------------------------------------------------------
-- 9.  Why the recurrence fails: the truncation.
--
-- Â§8 says the Fibonacci recurrence for `go` fails off the `j = 0` slice,
-- and gives the counterexample.
--
-- The classical proof applies Pascal to each term and reindexes the two
-- resulting families onto the two smaller sums.  That works because
-- `C(m,k) = 0` for `k > m`, so the sums are effectively infinite and the
-- reindexing costs nothing.  `go`'s two-step descent instead truncates at
-- `âŠi/2â‹` â” a HARD bound â” and after the shift the two families need
-- ranges the truncation does not supply.  The failure is the truncation,
-- not the recurrence.
--
-- So the encoding to use runs the sum LONG and lets the zeros do the
-- work:
--
--     D n  =  Î_{t â‰ n}  meru (n âˆ t) t
--
-- which gives `1 1 2 3 5` at `n = 0 â¦ 4` by computation.  The cost of
-- that encoding is truncated subtraction inside a Pascal step, whose edge
-- conditions (`n âˆ t = 0`) then need their own case analysis â” which is
-- why this is bookkeeping rather than a two-line proof.
------------------------------------------------------------------------

------------------------------------------------------------------------
-- 10.  The monus obstacle of Â§9 is removable, and here is the encoding.
--
-- Â§9 says the long-sum encoding costs truncated subtraction inside a
-- Pascal step.  It does not have to: the same sum is the ANTIDIAGONAL of
-- the array, and antidiagonals enumerate structurally.
--
--     Î_{t â‰ n} meru (n âˆ t) t  =  Î_{a + b = n} meru a b
--
-- and the right-hand side needs no subtraction:
------------------------------------------------------------------------

AD : â„• â†’ â„• â†’ â„•
AD a zero    = meru a 0
AD a (suc b) = meru a (suc b) + AD (suc a) b

antidiag : â„• â†’ â„•
antidiag n = AD 0 n

-- the mtrmeru's values, by computation
antidiag-0 : antidiag 0 â‰¡ 1
antidiag-0 = refl

antidiag-1 : antidiag 1 â‰¡ 1
antidiag-1 = refl

antidiag-2 : antidiag 2 â‰¡ 2
antidiag-2 = refl

antidiag-3 : antidiag 3 â‰¡ 3
antidiag-3 = refl

antidiag-4 : antidiag 4 â‰¡ 5
antidiag-4 = refl

antidiag-5 : antidiag 5 â‰¡ 8
antidiag-5 = refl

-- and they agree with Virahka's array, at these frontiers
antidiag-is-matra-4 : antidiag 4 â‰¡ matra 4
antidiag-is-matra-4 = refl

antidiag-is-matra-5 : antidiag 5 â‰¡ matra 5
antidiag-is-matra-5 = refl

------------------------------------------------------------------------
-- 11.  The goal for the antidiagonal encoding.
--
--     GOAL :  (n : â•) â’ antidiag (suc (suc n)) â‰¡ antidiag (suc n) + antidiag n
--
-- from which `antidiag n â‰¡ matra n` follows by two-step induction against
-- `Pingala.matraRecurrence`, the base cases being the `refl`s above.
--
-- Of the two obstacles Â§Â§8â“9 identified:
--   * the hard truncation is gone â” `AD` runs to the array's own edge and
--     the zero entries end it;
--   * the truncated subtraction is gone â” `AD` enumerates the
--     antidiagonal by structural recursion on the second index.
------------------------------------------------------------------------

------------------------------------------------------------------------
-- 12.  The induction does not close, and the reason is not a boundary
--      case.
--
-- Unfolding the goal at `n = suc m` gives
--
--     AD 1 (suc (suc m))  â‰¡  AD 1 (suc m) + AD 1 m
--
-- because `meru 0 (suc _)` is zero.  So one hopes the recurrence holds
-- for `AD a` at every `a`.  It holds at `a = 1` and FAILS at `a = 2`:
------------------------------------------------------------------------

AD1-values : (AD 1 0 â‰¡ 1) Ã— ((AD 1 1 â‰¡ 2) Ã— ((AD 1 2 â‰¡ 3) Ã— (AD 1 3 â‰¡ 5)))
AD1-values = refl , refl , refl , refl

AD2-values : (AD 2 0 â‰¡ 1) Ã— ((AD 2 1 â‰¡ 3) Ã— ((AD 2 2 â‰¡ 5) Ã— (AD 2 3 â‰¡ 8)))
AD2-values = refl , refl , refl , refl

-- 5 â‰  3 + 1: the row-2 antidiagonal sums are not Fibonacci-recurrent
AD2-breaks-the-recurrence : Â¬ (AD 2 2 â‰¡ AD 2 1 + AD 2 0)
AD2-breaks-the-recurrence p = snotz (injSuc (injSuc (injSuc (injSuc p))))

------------------------------------------------------------------------
-- 13.  What that shows.
--
-- `AD a b` truncates at the `b` end â” the antidiagonal from `(a,b)` runs
-- out of room before the full shallow diagonal of row `a` does â” so for
-- `a â‰ 2` it is not the shallow diagonal at all, and no induction whose
-- intermediate objects are `AD a _` can work.  `antidiag n = AD 0 n` is
-- correct; the family it sits in is not closed under the recurrence.
--
-- So THREE encodings fail, each for a different reason:
--
--   Â§8   two-step descent      hard truncation at âŠi/2â‹
--   Â§9   long sum with monus   subtraction inside the Pascal step
--   Â§11  antidiagonal `AD`     the family is not closed under reindexing
--
-- and the typed route of Â§8 â” `Metre n â‰ Î_k Chosen (nâˆ’k) k`, using
-- `Pingala.meruCount`, is the route `DiagonalIsMatra` takes.
------------------------------------------------------------------------
