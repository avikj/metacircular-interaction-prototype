# ARITH_WEIL_certificate.md â” from "the JSON identities hold" to M_N â° Î¼_N I

Companion to `NOTE_arithmetic_weil.md` Â§Â§4â“6.  Generator: `arith_weil_cert.py`; standalone checker:
`arith_weil_verify.py`; certificates: `arith_weil_N1.json`, `arith_weil_N2.json`, `arith_weil_N3.json`;
interval data: `arith_weil_intervals_N{1,2,3}.json`; logs: `arith_weil_run_{1,2,3}.log`.
Symbolic verification of the formulas used by the evaluator: `ARITH_WEIL_checks.md`.

## 0. Statement

Let Z(t) be defined for t â‰ 0 by (4.3) with A_g given by Theorem 3, (5.3)â“(5.5), and extended evenly
(Z(âˆ’t) = Z(t); this is the parity of (4.2) since G is even and Ï â¦ 1âˆ’Ï permutes the zeros).  Let
S_N = {âˆ’N..N}Â², Ï_(m,n) = m log 2 + n log 3, M_N = [Z(Ï_u âˆ’ Ï_v)]_{u,vâˆˆS_N}, n = (2N+1)Â².

**Theorem.**  M_1 â° Î¼_1 I_9, M_2 â° Î¼_2 I_25, M_3 â° Î¼_3 I_49 with the certified dyadic constants

| N | n | c (integer in the JSON) | Î¼_N = c/2^144 | note's margin | floating Î»_min (not used) |
|---|---|---|---|---|---|
| 1 | 9  | 5687278854285564902564622588504902205440 | 2.550264039903eâˆ’4 | 1/5000 = 2.0eâˆ’4 | 2.55030129eâˆ’4 |
| 2 | 25 | 563450904895866993750631389498489962496  | 2.526601240810eâˆ’5 | 1/50000 = 2.0eâˆ’5 | 2.52697377eâˆ’5 |
| 3 | 49 | 180462898937686927555716198028118327296  | 8.092236260768eâˆ’6 | 1/150000 â‰ˆ 6.67eâˆ’6 | 8.09596155eâˆ’6 |

In particular the note's Theorem 4, (6.2), holds with room to spare (Î¼_N exceeds the note's margins by
factors 1.28, 1.26, 1.21).  The proof has three links: (A) rigorous enclosure of every entry, (B) a safe
rounding of the enclosure to one integer matrix A, (C) an integer identity certifying A âˆ’ cI â° 0.

## A. Rigorous enclosure of the entries (Stage 1â“2 of `arith_weil_cert.py`)

Every real quantity is an Arb ball (python-flint 0.9.0, 320-bit working precision).  Arb's contract is that
the result ball of every operation contains the exact result whenever the input balls contain the exact
inputs; we use only: +, âˆ’, —, , exp, log, sqrt, cosh, |Â|, and the constants Ï, Î³, Catalan, together
with exact integers/dyadics.  The evaluator follows (4.3)â“(5.5) literally:

1. Constants: log 2, log 3, log Ï = log(Ï), Ïˆ(1/4) = âˆ’Î³ âˆ’ Ï/2 âˆ’ 3 log 2 (closed form; asserted to overlap
   Arb's own digamma ball), e^{âˆ’1}, e^{âˆ’2}, e^{âˆ’4}, the stencil weights b_j, 352/105, 3229/44100,
   G(1/2) = F(1/2)F(âˆ’1/2) from (4.1), and H(0) from (5.4).  All identities used here are proved in
   `ARITH_WEIL_checks.md`.
2. g(t): the piecewise closed form of Â§5 is used when the ball |t| lies *provably* (certain comparison of
   exact endpoints) inside [0,1/4], [1/4,1/2] or [1/2,âˆž); otherwise the everywhere-valid stencil sum
   g = Î_j b_j E(t âˆ’ x_j) is used (both forms proved equal).  Q_4(t) = Î_j b_j e^{âˆ’4|tâˆ’x_j|}.
3. H(d), d > 0 (asserted from the ball's lower endpoint): Î_{k<K} e^{âˆ’Î»_k d}/(Î»_kÂ²âˆ’16)Â² with K chosen so
   that the (5.5) bound e^{âˆ’Î»_K d}/((Î»_KÂ²âˆ’16)Â²(1âˆ’e^{âˆ’2d})) is < 2^{âˆ’328}; the tail is *added as the ball*
   [0, bound] (Arb `union` of 0 and the upper endpoint), so (5.5) is used exactly as stated.  d = 0 occurs
   only for the diagonal (t = 0, j = 0) and uses (5.4).  Largest K needed in the matrices: 6683
   (d = |4 log 3 âˆ’ 6 log 2 âˆ’ 1/4| â‰ˆ 0.01443).
4. Prime sum: Î(n) by an exact smallest-prime-factor sieve up to âŠâˆeÂ36^Nâ‹ + 2 (59, 2136, 76922 as in the
   note); the window is the *outer* integer window [âŠlower(e^{tâˆ’1/2})â‹, âˆupper(e^{t+1/2})â‰]; an n is skipped
   only when the ball |t âˆ’ log n| is provably â‰ 1/2, where g vanishes identically; Î(n)/âˆn = log p / âˆn in
   balls.  (E.g. t = 6 log 6: window [28298, 76923], 4507 contributing prime powers.)
5. Z(t) = 2cosh(t/2)G(1/2) + A_g(t) âˆ’ prime sum, with A_g from (5.3).  For u â‰  v, t = |Î”m log 2 + Î”n log 3|
   is asserted to be a ball separated from 0 (true: it is a nonzero real by unique factorisation, and the
   ball radius is ~10â»ââ´), and the same ball is used for (u,v) and (v,u), so the interval matrix is
   exactly symmetric.  M_N depends only on (Î”m, Î”n) and has 13 / 41 / 85 distinct entries.

Result: for each (u,v) an exact-dyadic interval [lo_uv, hi_uv] âˆ‹ M_N[u,v] with

| N | max entry radius | min entry radius | Z(0) |
|---|---|---|---|
| 1 | 1.97eâˆ’92 | 1.26eâˆ’94 | 0.041566759385475803385037774511818724999 Â 2eâˆ’42 (printed) |
| 2 | 1.97eâˆ’92 | 1.25eâˆ’94 | same |
| 3 | 9.73eâˆ’92 | 1.25eâˆ’94 | same |

(The note reports widths < 10â»Â³â with 2^200 integer-endpoint intervals; ours are ~54 orders tighter.)

Self-tests run before every build (Stage 0): piecewise g vs stencil sum overlap at 11 points incl.
straddling ones; H(0.3) and H(2â»â) vs mpmath `nsum` to 30 digits; H(2â»â) âˆ’ H(0) vs Hâ²(0)Â2â»â with
Hâ²(0) = âˆ’4Â3229/44100; A_g(t) by Theorem 3 vs direct quadrature of (4.4) at t = 0.13, 0.31, 0.62, 1.9
(agreement to 25 digits).  Independent witnesses (not part of the proof): (i) `arith_weil_zeros_check.py`
â” Z from (4.3) with quadrature vs the zero-side definition (4.2) with 1500 zeros: agreement within the
truncation bound (3eâˆ’8 at t = 0, â‰ 4eâˆ’9 elsewhere), confirming the explicit-formula normalisation;
(ii) an mpmath floating re-evaluation (quadrature, sieve to 77000) of eleven M_3 entries including
t = 6 log 6 agrees with the Arb midpoints to 10â»Â²â´â“10â»Â²â.

## B. Safe rounding of the box to one integer matrix (Stage 3, `safe_rounding`)

All arithmetic in this step is on Python integers derived from the exact dyadic endpoints (`man_exp`).
For each entry: C_ij = âŠ2^144Âmid_ijâ‹; r_ij = max(âˆ2^144Âhi_ijâ‰ âˆ’ C_ij, C_ij âˆ’ âŠ2^144Âlo_ijâ‹, 0), so that
2^144Â|x âˆ’ C_ij/2^144| â‰ r_ij for every x âˆˆ [lo_ij, hi_ij]; Ï = max_i Î_j r_ij; and

  A = C âˆ’ ÏÂI     (the "A" of the JSON; A/2^144 is the rounded matrix).

**Lemma R (rounding rule).**  Every symmetric real matrix Mâ² with Mâ²_ij âˆˆ [lo_ij, hi_ij] for all i,j
satisfies Mâ² â° A/2^144.  In particular M_N â° A/2^144.

*Proof.*  X := Mâ² âˆ’ C/2^144 is symmetric with |X_ij| â‰ r_ij/2^144.  For a symmetric matrix the spectral
norm equals the spectral radius, which is bounded by any induced norm, in particular the row-sum norm:
â–Xâ–_2 â‰ â–Xâ–_âˆž = max_i Î_j |X_ij| â‰ Ï/2^144.  Hence every eigenvalue of X is â‰ âˆ’Ï/2^144, i.e.
X â° âˆ’(Ï/2^144) I, and Mâ² = C/2^144 + X â° (C âˆ’ ÏI)/2^144 = A/2^144.  âˆ

(Numerically: all r_ij = 1 and Ï = n, i.e. the absorption is nÂ2^{âˆ’144} â‰ˆ 4eâˆ’43, 1eâˆ’42, 2eâˆ’42 â” the ball
radii are far below 2^{âˆ’144}, so the only loss is the flooring itself.)

Consequently *any* certificate that A âˆ’ cI â° 0 proves M_N â° (c/2^144) I.  The interval widths are thus
absorbed into A once and for all; nothing about the balls is needed downstream.

## C. The dyadic slack certificate (JSON) and its verification

JSON format: {"n", "k":144, "kL":40, "kD":64, "A", "L", "D", "E", "c", "meta"} with all matrix entries and
c Python integers.  Interpretation:  = A/2^144, LÌ = L/2^40 (unit lower triangular: L_ii = 2^40, L_ij = 0
for j > i), DÌ = D/2^64 with D_i â‰ 0, º¼ = E/2^144, cÌ = c/2^144 = Î¼_N.  Because 144 = 2Â40 + 64, the
integer identity

  (I1)  A âˆ’ cÂI = LÂdiag(D)ÂLµ + E   (exactly, over â, entrywise)

is the statement  âˆ’ cÌI = LÌDÌLÌµ + º¼ over the dyadic rationals.  The checker (`arith_weil_verify.py`,
pure Python integers; the same checks run inside the generator before emission) verifies:

  (I0) A symmetric, L unit-lower at scale 2^40, all D_i â‰ 0;
  (I1) as above, all nÂ² entries;
  (I2) 4ÂE_ii â‰ Î_j |E_ij| + Î_j |E_ji| for every i.

**Lemma S.**  (I0)â“(I2) imply A âˆ’ cI â° 0 (as a real symmetric matrix).

*Proof.*  LÌDÌLÌµ â° 0 since xµLÌDÌLÌµx = Î_i DÌ_i (LÌµx)_iÂ² â‰ 0.  E = (A âˆ’ cI) âˆ’ L D Lµ is symmetric (difference
of symmetric matrices), so (I2) reads 2E_ii â‰ 2Î_j|E_ij|, i.e. E_ii â‰ Î_{jâ‰ i}|E_ij|: E is diagonally
dominant with nonnegative diagonal, hence E â° 0 by Gershgorin's theorem (every eigenvalue lies in some disc
[E_ii âˆ’ Î_{jâ‰ i}|E_ij|, E_ii + Î_{jâ‰ i}|E_ij|] âŠ [0,âˆž)).  The sum of two PSD matrices is PSD.  âˆ

(Had E not been symmetric, (I2) would still give xµEx = xµ((E+Eµ)/2)x â‰ 0 by the same Gershgorin argument
applied to the symmetric part, whose row sums are bounded by half of the row-plus-column sums; that is why
the format states the condition with both sums.)

**Conclusion.**  By Lemma R and Lemma S, M_N â° A/2^144 â° (c/2^144) I = Î¼_N I.  Since c â‰ 2^144Â(note margin)
(checked and recorded in `meta.c_note_margin`), also M_N â° (1/5000)I, (1/50000)I, (1/150000)I respectively;
explicitly, A âˆ’ c_note I = LDLµ + (E + (c âˆ’ c_note)I) is again a certificate of the same form.  âˆ

Certificate statistics (all at real scale): min DÌ_i â‰ˆ 1.0eâˆ’18 / 5.0eâˆ’18 / 3.3eâˆ’18 (the last pivot is tiny
because c sits within ~4eâˆ’9 of Î»_min); min º¼_ii â‰ˆ 3.73eâˆ’9 (the deliberate slack 2^{âˆ’28} put on the diagonal
before factoring); max off-diagonal |º¼_ij| â‰ˆ 2.5eâˆ’14, 2.6eâˆ’14, 3.4eâˆ’14 â” the entire rounding error of
LÌ to 40 bits and DÌ to 64 bits, five orders below the slack.

How L, D, c were chosen (irrelevant to rigour): mpmath LDLµ at 90 digits of  âˆ’ (Î¼ + 2^{âˆ’28})I, L rounded to
nearest 2^{âˆ’40}, D rounded down to 2^{âˆ’64}; Î¼ started at âŠÎ»_min()Â2^64â‹/2^64 (Î»_min from a floating
eigen-solver) and was lowered in steps of 2^{âˆ’30} until (I0)â“(I2) held; the first success is reported as c.

## D. Cross-check: the note's exact-rational LDLµ route (Stage 4, `rational_route`)

Q_ij = round(10^12Âmid_ij)/10^12 as exact `Fraction`s; the inequality |M_ij âˆ’ Q_ij| â‰ 10^{âˆ’12} is checked
*rigorously* from the ball endpoints (lo_ij â‰ (qâˆ’1)/10^12 and hi_ij â‰ (q+1)/10^12, exact rational
comparisons).  Then, exactly as the note prescribes, an exact LDLµ (Fraction arithmetic, no pivoting) of
Q âˆ’ (Î¼_N + nÂ10^{âˆ’12})I with Î¼_N the note's margin: all pivots are positive (min â‰ˆ 9.2eâˆ’4, 3.8eâˆ’4, 2.0eâˆ’4)
and the recomposition L D Lµ = Q âˆ’ (Î¼_N + nÂ10^{âˆ’12})I holds exactly.  By the same row-sum argument as
Lemma R, â–M_N âˆ’ Qâ–_2 â‰ nÂ10^{âˆ’12}, so M_N â° Q âˆ’ nÂ10^{âˆ’12}I â‰» Î¼_N I.  This reproduces (6.2) independently
of the dyadic route.  Pushing the shift up by bisection (25 exact factorisations each), the rational route
certifies Î¼ â‰ˆ 2.5503012eâˆ’4, 2.5269711eâˆ’5, 8.0959105eâˆ’6, i.e. within 10â»Ââ° of the floating Î»_min; the
dyadic route certifies 2.5502640eâˆ’4, 2.5266012eâˆ’5, 8.0922363eâˆ’6 (it pays the 2^{âˆ’28} â‰ˆ 3.7eâˆ’9 dominance
slack).  Both routes: (i) certify the note's margins; (ii) give constants consistent with each other and
with Î»_min(mid); (iii) agree that M_1, M_2, M_3 are positive definite with Î»_min â‰ˆ 2.55eâˆ’4, 2.53eâˆ’5, 8.10eâˆ’6.

## E. Trust boundary

Assumed: correctness of Arb (python-flint 0.9.0) ball arithmetic for the listed elementary operations and
constants; Python big-integer / `Fraction` arithmetic; the classical explicit formula in the normalisation
(4.3)â“(4.4) (numerically confirmed against the zeros, Â§A); Theorem 3 and (5.1), (5.4), (5.5) â” verified
symbolically in `ARITH_WEIL_checks.md`.  Not trusted for anything: mpmath (used only to *propose* L, D, Î¼
and to print Î»_min), the floating eigen-solver, and the piecewise-vs-stencil choice (both proved equal).

## F. Reproduction

    pip install python-flint sympy mpmath
    python3 arith_weil_checks.py            # 43 symbolic checks -> ARITH_WEIL_checks_raw.txt
    python3 arith_weil_cert.py 1 2 3        # ~1 min; writes arith_weil_N{1,2,3}.json, intervals, logs
    python3 arith_weil_verify.py arith_weil_N1.json arith_weil_N2.json arith_weil_N3.json
    python3 arith_weil_zeros_check.py 1500  # optional numerical witness for (4.3)
