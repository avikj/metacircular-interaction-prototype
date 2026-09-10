# ARITH_WEIL_certificate.md — from "the JSON identities hold" to M_N ⪰ μ_N I

Companion to `NOTE_arithmetic_weil.md` §§4–6.  Generator: `arith_weil_cert.py`; standalone checker:
`arith_weil_verify.py`; certificates: `arith_weil_N1.json`, `arith_weil_N2.json`, `arith_weil_N3.json`;
interval data: `arith_weil_intervals_N{1,2,3}.json`; logs: `arith_weil_run_{1,2,3}.log`.
Symbolic verification of the formulas used by the evaluator: `ARITH_WEIL_checks.md`.

## 0. Statement

Let Z(t) be defined for t ≥ 0 by (4.3) with A_g given by Theorem 3, (5.3)–(5.5), and extended evenly
(Z(−t) = Z(t); this is the parity of (4.2) since G is even and ρ ↦ 1−ρ permutes the zeros).  Let
S_N = {−N..N}², τ_(m,n) = m log 2 + n log 3, M_N = [Z(τ_u − τ_v)]_{u,v∈S_N}, n = (2N+1)².

**Theorem.**  M_1 ⪰ μ_1 I_9, M_2 ⪰ μ_2 I_25, M_3 ⪰ μ_3 I_49 with the certified dyadic constants

| N | n | c (integer in the JSON) | μ_N = c/2^144 | note's margin | floating λ_min (not used) |
|---|---|---|---|---|---|
| 1 | 9  | 5687278854285564902564622588504902205440 | 2.550264039903e−4 | 1/5000 = 2.0e−4 | 2.55030129e−4 |
| 2 | 25 | 563450904895866993750631389498489962496  | 2.526601240810e−5 | 1/50000 = 2.0e−5 | 2.52697377e−5 |
| 3 | 49 | 180462898937686927555716198028118327296  | 8.092236260768e−6 | 1/150000 ≈ 6.67e−6 | 8.09596155e−6 |

In particular the note's Theorem 4, (6.2), holds with room to spare (μ_N exceeds the note's margins by
factors 1.28, 1.26, 1.21).  The proof has three links: (A) rigorous enclosure of every entry, (B) a safe
rounding of the enclosure to one integer matrix A, (C) an integer identity certifying A − cI ⪰ 0.

## A. Rigorous enclosure of the entries (Stage 1–2 of `arith_weil_cert.py`)

Every real quantity is an Arb ball (python-flint 0.9.0, 320-bit working precision).  Arb's contract is that
the result ball of every operation contains the exact result whenever the input balls contain the exact
inputs; we use only: +, −, ×, ÷, exp, log, sqrt, cosh, |·|, and the constants π, γ, Catalan, together
with exact integers/dyadics.  The evaluator follows (4.3)–(5.5) literally:

1. Constants: log 2, log 3, log π = log(π), ψ(1/4) = −γ − π/2 − 3 log 2 (closed form; asserted to overlap
   Arb's own digamma ball), e^{−1}, e^{−2}, e^{−4}, the stencil weights b_j, 352/105, 3229/44100,
   G(1/2) = F(1/2)F(−1/2) from (4.1), and H(0) from (5.4).  All identities used here are proved in
   `ARITH_WEIL_checks.md`.
2. g(t): the piecewise closed form of §5 is used when the ball |t| lies *provably* (certain comparison of
   exact endpoints) inside [0,1/4], [1/4,1/2] or [1/2,∞); otherwise the everywhere-valid stencil sum
   g = Σ_j b_j E(t − x_j) is used (both forms proved equal).  Q_4(t) = Σ_j b_j e^{−4|t−x_j|}.
3. H(d), d > 0 (asserted from the ball's lower endpoint): Σ_{k<K} e^{−λ_k d}/(λ_k²−16)² with K chosen so
   that the (5.5) bound e^{−λ_K d}/((λ_K²−16)²(1−e^{−2d})) is < 2^{−328}; the tail is *added as the ball*
   [0, bound] (Arb `union` of 0 and the upper endpoint), so (5.5) is used exactly as stated.  d = 0 occurs
   only for the diagonal (t = 0, j = 0) and uses (5.4).  Largest K needed in the matrices: 6683
   (d = |4 log 3 − 6 log 2 − 1/4| ≈ 0.01443).
4. Prime sum: Λ(n) by an exact smallest-prime-factor sieve up to ⌊√e·36^N⌋ + 2 (59, 2136, 76922 as in the
   note); the window is the *outer* integer window [⌊lower(e^{t−1/2})⌋, ⌈upper(e^{t+1/2})⌉]; an n is skipped
   only when the ball |t − log n| is provably ≥ 1/2, where g vanishes identically; Λ(n)/√n = log p / √n in
   balls.  (E.g. t = 6 log 6: window [28298, 76923], 4507 contributing prime powers.)
5. Z(t) = 2cosh(t/2)G(1/2) + A_g(t) − prime sum, with A_g from (5.3).  For u ≠ v, t = |Δm log 2 + Δn log 3|
   is asserted to be a ball separated from 0 (true: it is a nonzero real by unique factorisation, and the
   ball radius is ~10⁻⁹⁴), and the same ball is used for (u,v) and (v,u), so the interval matrix is
   exactly symmetric.  M_N depends only on (Δm, Δn) and has 13 / 41 / 85 distinct entries.

Result: for each (u,v) an exact-dyadic interval [lo_uv, hi_uv] ∋ M_N[u,v] with

| N | max entry radius | min entry radius | Z(0) |
|---|---|---|---|
| 1 | 1.97e−92 | 1.26e−94 | 0.041566759385475803385037774511818724999 ± 2e−42 (printed) |
| 2 | 1.97e−92 | 1.25e−94 | same |
| 3 | 9.73e−92 | 1.25e−94 | same |

(The note reports widths < 10⁻³⁸ with 2^200 integer-endpoint intervals; ours are ~54 orders tighter.)

Self-tests run before every build (Stage 0): piecewise g vs stencil sum overlap at 11 points incl.
straddling ones; H(0.3) and H(2⁻⁸) vs mpmath `nsum` to 30 digits; H(2⁻⁸) − H(0) vs H′(0)·2⁻⁸ with
H′(0) = −4·3229/44100; A_g(t) by Theorem 3 vs direct quadrature of (4.4) at t = 0.13, 0.31, 0.62, 1.9
(agreement to 25 digits).  Independent witnesses (not part of the proof): (i) `arith_weil_zeros_check.py`
— Z from (4.3) with quadrature vs the zero-side definition (4.2) with 1500 zeros: agreement within the
truncation bound (3e−8 at t = 0, ≤ 4e−9 elsewhere), confirming the explicit-formula normalisation;
(ii) an mpmath floating re-evaluation (quadrature, sieve to 77000) of eleven M_3 entries including
t = 6 log 6 agrees with the Arb midpoints to 10⁻²⁴–10⁻²⁶.

## B. Safe rounding of the box to one integer matrix (Stage 3, `safe_rounding`)

All arithmetic in this step is on Python integers derived from the exact dyadic endpoints (`man_exp`).
For each entry: C_ij = ⌊2^144·mid_ij⌋; r_ij = max(⌈2^144·hi_ij⌉ − C_ij, C_ij − ⌊2^144·lo_ij⌋, 0), so that
2^144·|x − C_ij/2^144| ≤ r_ij for every x ∈ [lo_ij, hi_ij]; ρ = max_i Σ_j r_ij; and

  A = C − ρ·I     (the "A" of the JSON; A/2^144 is the rounded matrix).

**Lemma R (rounding rule).**  Every symmetric real matrix M′ with M′_ij ∈ [lo_ij, hi_ij] for all i,j
satisfies M′ ⪰ A/2^144.  In particular M_N ⪰ A/2^144.

*Proof.*  X := M′ − C/2^144 is symmetric with |X_ij| ≤ r_ij/2^144.  For a symmetric matrix the spectral
norm equals the spectral radius, which is bounded by any induced norm, in particular the row-sum norm:
‖X‖_2 ≤ ‖X‖_∞ = max_i Σ_j |X_ij| ≤ ρ/2^144.  Hence every eigenvalue of X is ≥ −ρ/2^144, i.e.
X ⪰ −(ρ/2^144) I, and M′ = C/2^144 + X ⪰ (C − ρI)/2^144 = A/2^144.  ∎

(Numerically: all r_ij = 1 and ρ = n, i.e. the absorption is n·2^{−144} ≈ 4e−43, 1e−42, 2e−42 — the ball
radii are far below 2^{−144}, so the only loss is the flooring itself.)

Consequently *any* certificate that A − cI ⪰ 0 proves M_N ⪰ (c/2^144) I.  The interval widths are thus
absorbed into A once and for all; nothing about the balls is needed downstream.

## C. The dyadic slack certificate (JSON) and its verification

JSON format: {"n", "k":144, "kL":40, "kD":64, "A", "L", "D", "E", "c", "meta"} with all matrix entries and
c Python integers.  Interpretation: Ã = A/2^144, L̃ = L/2^40 (unit lower triangular: L_ii = 2^40, L_ij = 0
for j > i), D̃ = D/2^64 with D_i ≥ 0, Ẽ = E/2^144, c̃ = c/2^144 = μ_N.  Because 144 = 2·40 + 64, the
integer identity

  (I1)  A − c·I = L·diag(D)·Lᵀ + E   (exactly, over ℤ, entrywise)

is the statement Ã − c̃I = L̃D̃L̃ᵀ + Ẽ over the dyadic rationals.  The checker (`arith_weil_verify.py`,
pure Python integers; the same checks run inside the generator before emission) verifies:

  (I0) A symmetric, L unit-lower at scale 2^40, all D_i ≥ 0;
  (I1) as above, all n² entries;
  (I2) 4·E_ii ≥ Σ_j |E_ij| + Σ_j |E_ji| for every i.

**Lemma S.**  (I0)–(I2) imply A − cI ⪰ 0 (as a real symmetric matrix).

*Proof.*  L̃D̃L̃ᵀ ⪰ 0 since xᵀL̃D̃L̃ᵀx = Σ_i D̃_i (L̃ᵀx)_i² ≥ 0.  E = (A − cI) − L D Lᵀ is symmetric (difference
of symmetric matrices), so (I2) reads 2E_ii ≥ 2Σ_j|E_ij|, i.e. E_ii ≥ Σ_{j≠i}|E_ij|: E is diagonally
dominant with nonnegative diagonal, hence E ⪰ 0 by Gershgorin's theorem (every eigenvalue lies in some disc
[E_ii − Σ_{j≠i}|E_ij|, E_ii + Σ_{j≠i}|E_ij|] ⊂ [0,∞)).  The sum of two PSD matrices is PSD.  ∎

(Had E not been symmetric, (I2) would still give xᵀEx = xᵀ((E+Eᵀ)/2)x ≥ 0 by the same Gershgorin argument
applied to the symmetric part, whose row sums are bounded by half of the row-plus-column sums; that is why
the format states the condition with both sums.)

**Conclusion.**  By Lemma R and Lemma S, M_N ⪰ A/2^144 ⪰ (c/2^144) I = μ_N I.  Since c ≥ 2^144·(note margin)
(checked and recorded in `meta.c_note_margin`), also M_N ⪰ (1/5000)I, (1/50000)I, (1/150000)I respectively;
explicitly, A − c_note I = LDLᵀ + (E + (c − c_note)I) is again a certificate of the same form.  ∎

Certificate statistics (all at real scale): min D̃_i ≈ 1.0e−18 / 5.0e−18 / 3.3e−18 (the last pivot is tiny
because c sits within ~4e−9 of λ_min); min Ẽ_ii ≈ 3.73e−9 (the deliberate slack 2^{−28} put on the diagonal
before factoring); max off-diagonal |Ẽ_ij| ≈ 2.5e−14, 2.6e−14, 3.4e−14 — the entire rounding error of
L̃ to 40 bits and D̃ to 64 bits, five orders below the slack.

How L, D, c were chosen (irrelevant to rigour): mpmath LDLᵀ at 90 digits of Ã − (μ + 2^{−28})I, L rounded to
nearest 2^{−40}, D rounded down to 2^{−64}; μ started at ⌊λ_min(Ã)·2^64⌋/2^64 (λ_min from a floating
eigen-solver) and was lowered in steps of 2^{−30} until (I0)–(I2) held; the first success is reported as c.

## D. Cross-check: the note's exact-rational LDLᵀ route (Stage 4, `rational_route`)

Q_ij = round(10^12·mid_ij)/10^12 as exact `Fraction`s; the inequality |M_ij − Q_ij| ≤ 10^{−12} is checked
*rigorously* from the ball endpoints (lo_ij ≥ (q−1)/10^12 and hi_ij ≤ (q+1)/10^12, exact rational
comparisons).  Then, exactly as the note prescribes, an exact LDLᵀ (Fraction arithmetic, no pivoting) of
Q − (μ_N + n·10^{−12})I with μ_N the note's margin: all pivots are positive (min ≈ 9.2e−4, 3.8e−4, 2.0e−4)
and the recomposition L D Lᵀ = Q − (μ_N + n·10^{−12})I holds exactly.  By the same row-sum argument as
Lemma R, ‖M_N − Q‖_2 ≤ n·10^{−12}, so M_N ⪰ Q − n·10^{−12}I ≻ μ_N I.  This reproduces (6.2) independently
of the dyadic route.  Pushing the shift up by bisection (25 exact factorisations each), the rational route
certifies μ ≈ 2.5503012e−4, 2.5269711e−5, 8.0959105e−6, i.e. within 10⁻¹⁰ of the floating λ_min; the
dyadic route certifies 2.5502640e−4, 2.5266012e−5, 8.0922363e−6 (it pays the 2^{−28} ≈ 3.7e−9 dominance
slack).  Both routes: (i) certify the note's margins; (ii) give constants consistent with each other and
with λ_min(mid); (iii) agree that M_1, M_2, M_3 are positive definite with λ_min ≈ 2.55e−4, 2.53e−5, 8.10e−6.

## E. Trust boundary

Assumed: correctness of Arb (python-flint 0.9.0) ball arithmetic for the listed elementary operations and
constants; Python big-integer / `Fraction` arithmetic; the classical explicit formula in the normalisation
(4.3)–(4.4) (numerically confirmed against the zeros, §A); Theorem 3 and (5.1), (5.4), (5.5) — verified
symbolically in `ARITH_WEIL_checks.md`.  Not trusted for anything: mpmath (used only to *propose* L, D, μ
and to print λ_min), the floating eigen-solver, and the piecewise-vs-stencil choice (both proved equal).

## F. Reproduction

    pip install python-flint sympy mpmath
    python3 arith_weil_checks.py            # 43 symbolic checks -> ARITH_WEIL_checks_raw.txt
    python3 arith_weil_cert.py 1 2 3        # ~1 min; writes arith_weil_N{1,2,3}.json, intervals, logs
    python3 arith_weil_verify.py arith_weil_N1.json arith_weil_N2.json arith_weil_N3.json
    python3 arith_weil_zeros_check.py 1500  # optional numerical witness for (4.3)
