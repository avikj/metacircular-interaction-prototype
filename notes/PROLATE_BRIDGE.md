# The prolate / Connes–Consani bridge: conventions, conditioning, and what did not move

**Status: PENDING HOSTILE AUDIT.** Code: `code/exp59_prolate.py` (runs
end-to-end in **96 s**, `python3 code/exp59_prolate.py`); full log:
`data/exp59_out.txt`; figure: `figures/exp59_prolate.png`. Companions:
`notes/LP_CERT.md` (the negativity landscape and the §5 terminal blocker this
note attacks), `notes/WEIL.md` (Prop W1, the normalization, verified there to
1.8e−10), `notes/JEWELS.md` §1 (the Cohn–Elkies/Viazovska/BCK identification
that made an interpolation basis the target), `notes/FF_PAIRFIELD.md` §§3–4
(the de-centering table that makes this lane the highest-value one; §0.1
below), `collab/STATE.md` open target 6.

**Two-sentence summary.** The interpolation blocker of `LP_CERT` §5 is
**removed**: the joint 30-zero + 24-prime-knot collocation system goes from
cond 2.7e17 (σ_min 1.3e−17) to **cond 1.60 (σ_min 0.762)**, and the K = 24
zero-knot conditioning from 2.6e16 to **1.24** — but the designed-annihilation
controls show the cure is **not the prolate basis family**: it is
time–bandwidth (dimension), and the prolates are simply the basis that attains
the rectangle exactly and tells you what dimension to ask for. Everything
downstream of conditioning — the primitive-margin collapse with the window
width, the diagonalization of I = prime − arch, CC's 2.389e−48 — did **not**
move; the margin collapse is reproduced by the prolate span to within a factor
1.2–3.5 of exp25's compact basis at every shared window, i.e. it is
**basis-independent**, which is a genuine (negative) constraint on the
certificate program.

**Forecast and its outcome (PROTOCOL §4).** The pre-registered plan is the
docstring of `code/exp59_prolate.py`, written before any run. Its explicit
expectations were: (i) prolate collocation fixes the K ≈ 20 blocker —
**confirmed**; (ii) the assembled/zero-side cross-check lands at ~1e−6 after
the analytic tail correction — **partially confirmed** (1.9e−7 … 7.0e−5,
worst at small T; four orders worse than exp25's C¹ basis, diagnosed in §4.3);
(iii) I is "diagonal-ish" in prolate coordinates — **refuted** (§6);
(iv) CC's 2.389e−48 "reproduced in the repo normalization" — **not achieved,
and shown to be unachievable in double precision** (§7.4). The five controls
added by this session (A1, A2, B1, B2 and the parity-respecting null of §6)
were written into the source *with their predictions* before being run; A1's
prediction — that the dimension-matched prolate span fails like exp25 — is in
the code comment and was then confirmed.

---

## 0. Why this lane, and what it is for

`LP_CERT` §5 ended on a hard stop: direct double-precision collocation of the
zero-knot functionals g ↦ Φ_g(½+iγ_k) and the prime-knot functionals
g ↦ g(log p^k) on the exp25 Gaussian spans is numerically degenerate past
K ≈ 20 (cond 2.6e16 at K = 24 on the zero side, 1.8e16 on the prime side,
2.7e17 for the joint Radchenko–Viazovska-type system). That blocker is what
stands between `JEWELS` §1's programme — *a Viazovska-style interpolation
certificate whose knots are {log p^k} on one side and {γ} on the other* — and
any finite experiment. `LP_CERT` §5's own prescription was "a
prolate/Sonin-adapted basis, following 2006.13771/2310.18423". This note runs
that prescription and reports exactly how much of the blocker was a basis
problem (answer: none of it) and how much was a resource problem (answer: all
of it).

### 0.1 The FF_PAIRFIELD argument for priority

`notes/FF_PAIRFIELD.md` §4 tabulates which ℚ-side structures survive into the
function-field column, where RH is a theorem and therefore exerts no pull.
Its verdict on the Weil/Krein/screw positivity row is
"YES and unconditionally TRUE; fake Weil number breaks it while passing
integrality (§3) | **this is where RH lives** — correctly flagged", and its
prose adds that "this row of the dictionary, and essentially only this row, is
correctly flagged 'about RH'". Every structure that felt spectral — sum-frequency
lines, the 5/2 modulus law, the entropy phase, the Fresnel chirp, the
opposite-sign suppression — is filed there as an **archimedean artifact**.

The numerics below are consistent with that ranking and, on one point, sharpen
it. The conditioning obstruction turned out to be a pure **archimedean-place
resource statement** (a Landau/Nyquist density count on the window
[−T/2, T/2], §3.4) — exactly the kind of thing FF_PAIRFIELD predicts is *not*
about RH, and indeed it dissolved on contact. What did **not** dissolve is the
positivity margin (§4): it is reproduced basis-independently and collapses at
the same rate. So the two halves separate cleanly along FF_PAIRFIELD's line:
the part of `LP_CERT` §5 that was archimedean bookkeeping is now solved, and
the part that is the Weil-positivity row is untouched and is where all the
remaining difficulty sits. On the numerics available here that supports —
without proving — FF_PAIRFIELD's claim that this lane is the load-bearing one.

---

## 1. The bridge: a convention dictionary

This section **is** the deliverable. Everything numerical below is stated in
the repo normalization; the dictionary is what makes CC's statements
comparable. `LP_CERT` §6 established rows 1–3; rows 4–7 are added here.

Repo side (`WEIL.md` Prop W1, verified 1.8e−10, used unchanged in exp14,
exp25 and here): g lives on u = log x, admissible = C² with
g, g′, g″ ≪ e^{−(½+δ)|u|};

$$\Phi_g(s)=\int_{\mathbb R} g(u)\,e^{(s-\frac12)u}\,du,\qquad
\tilde g(u)=\overline{g(-u)},\qquad F=g\star\tilde g,$$

$$W(g)=\sum_\rho\Phi_F(\rho)=\underbrace{2\operatorname{Re}[\Phi_g(0)\overline{\Phi_g(1)}]}_{\rm pole}
-\underbrace{\sum_{n\ge2}\tfrac{\Lambda(n)}{\sqrt n}2\operatorname{Re}F(\log n)}_{\rm prime}
+\underbrace{\tfrac1{2\pi}\!\int|\Phi_g(\tfrac12+i\tau)|^2 D(\tau)\,d\tau}_{\rm arch},$$

D(τ) = Re ψ(¼ + iτ/2) − log π, and I := prime − arch = pole − W.

| # | Connes–Consani object | repo object | status of the identification |
|---|---|---|---|
| 1 | Mellin transform $\tilde k(s)=\int_0^\infty k(x)x^{s-1}dx$ of $k$ on $\mathbb R_+^\times$ | $\Phi_g(s)$ after $k(x)=x^{-1/2}g(\log x)$ | **exact**, one line: $\int_0^\infty x^{-1/2}g(\log x)x^{s-1}dx=\int_{\mathbb R}g(u)e^{(s-\frac12)u}du$. (`LP_CERT` §2(3).) |
| 2 | Fourier convention $\hat g(z)=\int g(u)e^{-izu}du$ | $\hat g(z)=\Phi_g(\tfrac12-iz)$; $\hat g(0)=\Phi_g(\tfrac12)$, $\hat g(\pm i/2)=\Phi_g(1),\Phi_g(0)$ | **exact** up to the sign choice in $z$ |
| 3 | CC's archimedean vanishing conditions (one central + one pole-side zero) | **not** the repo primitive space $P=\{\Phi_g(0)=\Phi_g(1)=0\}$ | **different codimension-2 slice** — do not conflate. CC Appendix C, Prop. C.1 with vanishing set $\{0,1\}$ *is* the exact match for $P$. (`LP_CERT` §6.) |
| 4 | window $[\lambda^{-1},\lambda]\subset\mathbb R_+^\times$; circle of length $L=\log\mu$, $\mu=\lambda^2$ | $u\in[-\tfrac T2,\tfrac T2]$ with $T=2\log\lambda=\log\lambda^2=\log\mu$ | **exact**; so CC's $\mu=\lambda^2$ is $e^{T}$ in repo window units |
| 5 | prolate/Slepian bandwidth parameter $c$ for a $\lambda$-cutoff in *both* variables | $c=2\pi\lambda^2$, Shannon number $2c/\pi=4\lambda^2$ | **exact** ($c=\Omega T_{\rm add}/2$ with $\Omega=2\pi\lambda$, $T_{\rm add}=2\lambda$); reproduced numerically, §2 |
| 6 | prolate wave operator (CM 2112.05500; CCM 2310.18423, semilocal) | classical commuting operator $L_c=-\frac{d}{dx}(1-x^2)\frac{d}{dx}+c^2x^2$ on $[-1,1]$ | **archimedean/one-place case only.** No claim of identity with the semilocal operator is made here |
| 7 | $\mathcal E(f)(x)=x^{1/2}\sum_{n>0}f(nx)$, $f\in\mathcal S_0^{\rm ev}$ (eq. (1.3), FETCHED) | $\Phi_{\mathcal E(f)}(s)=\zeta(s)\,M(f)(s)$, $M(f)(s)=\int_0^\infty f(y)y^{s-1}dy$ | **derived here** (one line, §7.1) and **verified to 1.1e−13** (§7.2). CC's own §3 statement is that the radical of the Weil form contains the range of $\mathcal E$ |

**The window-scaling row is the one that carries all the numerics.** The repo
basis used throughout is

$$\varphi_n(u)=\sqrt{2/T}\;\psi_n^{(c)}(2u/T),\qquad u\in[-T/2,T/2],$$

with ψ_n^{(c)} the c-prolates orthonormal on [−1,1]. Then
Φ_{φ_n}(½+iτ) = √(T/2)·(finite Fourier transform of ψ_n at a = τT/2), so the
span is **essentially band-limited to |τ| ≤ τ_edge := 2c/T**, is exactly
supported in [−T/2, T/2], is exactly orthonormal (Gram = I, no whitening
step and hence no whitening-induced conditioning), and has
N ≈ 2c/π = T·τ_edge/π degrees of freedom. Every conditioning statement below
is a statement about that rectangle (T, τ_edge).

**Two normalization traps, recorded.** (a) The repo prime term carries
Λ(n)/√n·2Re F(log n) with F = g ⋆ g̃; a sesquilinear-convention slip here
silently conjugates every imaginary part (this exact bug is on record in
`LP_CERT` §3 as one of three caught in exp25's first draft). (b) The
archimedean term is an integral against D(τ), **not** against the zero
counting measure; D(τ) < 0 for |τ| < 2π (WEIL §1) and D(τ) ~ log(τ/2π). With
a hard-edged window (prolates are discontinuous at ±T/2) the archimedean
integrand decays only like 1/τ², so the τ-truncation must be corrected
analytically — see §4.3, where the same asymptotic also fixes the omitted
zero tail.

---

## 2. Ground truth first: the classical prolate machinery (pratyakṣa)

Before any zeta content, the implementation is checked against classical
statements that have nothing to do with this program (`data/exp59_out.txt`,
part 0 and part S):

- eigenvalues χ_n of L_c in the normalized-Legendre tridiagonal form vs
  `scipy.special.pro_cv` (c = 5, n = 0..7): **max relative deviation
  3.87e−15**;
- orthonormality of ψ_n on [−1,1] (400-node Gauss): **3.52e−13**;
- the finite-Fourier eigenrelation ∫_{−1}^1 ψ_n(x)e^{icxy}dx = μ_n ψ_n(y)
  at c = 10: **residual 3.54e−15**, with the classical phase μ_n ∈ i^n ℝ
  reproduced (printed phases 0, π/2, π, −π/2, 0, π/2 for n = 0..5);
- **Slepian's plunge as ground truth**: with λ_n = c|μ_n|²/2π, the count
  #{λ_n > ½} equals **6, 30, 64** at c = 10, 15π, 100, against the Shannon
  number 2c/π = **6.37, 30.00, 63.66**; the plunge width
  #{1e−4 < λ_n < 1−1e−4} is 8, 10, 12 — the classical O(log c) transition.

This is the "reproduce the classical result" control demanded by
`collab/PROTOCOL.md` §7. It is passed to machine precision.

---

## 3. The headline: the LP_CERT §5 conditioning blocker is removed

### 3.1 The measurement

Same setup as exp25 part C: window u ∈ [−4, 4] (T = 8), zero knots
γ_1…γ_K, prime knots the 24 prime powers with log p^k < 4, evaluation
functionals row-normalized, conditioning = σ_max/σ_min. Prolate spans at
c = 100, 200, 400, 652 (N = 88, 152, 279, 440; τ_edge = 25, 50, 100, 163).

| K | prolate c=100 | c=200 | c=400 | c=652 | exp25 Gaussian (dim 60) |
|---|---|---|---|---|---|
| 5 | 1.35 | 1.06 | 1.06 | 1.06 | 5.2 |
| 10 | 41.1 | 1.13 | 1.13 | 1.13 | 2.0e2 |
| 15 | 6.41e4 | 5.37 | 1.19 | 1.19 | 9.1e3 |
| 20 | 2.52e7 | 332 | 1.19 | 1.19 | 2.6e8 |
| **24** | 5.56e10 | 6.83e4 | **1.24** | **1.24** | **2.6e16** |
| 30 | 1.13e16 | 7.23e8 | 1.30 | 1.30 | 1.2e17 |
| 40 | 4.72e16 | 3.41e15 | 836 | 1.34 | — |
| 50 | 1.53e17 | 2.67e16 | 2.17e9 | 1.37 | — |
| 60 | 2.43e17 | 5.0e16 | 1.22e14 | **1.38** | — |

Prime knots (24 knots < e⁴): prolate c = 652 gives cond **1.20** at K = 24
(c = 400: 1.30; c = 200: 1.83; c = 100: 7.82) against exp25's **1.8e16**.

Joint Radchenko–Viazovska-type system, 30 zero + 24 prime functionals:

| span | cond | σ_min |
|---|---|---|
| exp25 Gaussian (quoted, `LP_CERT` §5) | 2.7e17 | 1.3e−17 |
| exp25 Gaussian (re-implemented here, control A2) | 7.31e18 | 6.05e−19 |
| prolate c = 100 (N = 88) | 2.185e16 | 1.559e−16 |
| prolate c = 200 (N = 152) | 1.637e9 | 1.599e−9 |
| prolate c = 400 (N = 279) | 1.761 | 7.219e−1 |
| **prolate c = 652 (N = 440)** | **1.597** | **7.620e−1** |

**Sixteen orders of magnitude on the headline number, and σ_min moves from
below double-precision noise (1.3e−17) to 0.76.** In the c = 652 span the
54 joint functionals are, numerically, an orthonormal-ish system: a
Radchenko–Viazovska-type interpolation problem on the knot set
{γ_1…γ_30} ∪ {log p^k < 4} is **numerically well-posed** in double precision
for the first time in this program.

### 3.2 Control A2 (wrong basis): the blocker replicates

The exp25 Gaussian dictionary (5 centers × 4 modulations × 3 widths = 60
atoms, closed-form Gram and Φ) was re-implemented from scratch inside
`exp59_prolate` and whitened at eigen-cut 1e−13 (whitened dim 60, as exp25
reports). It must, and does, reproduce the blocker: cond(zero knots) =
9.50, 498, 4.33e4, 1.44e8, **2.11e16**, 3.03e17 at K = 5, 10, 15, 20, 24, 30
against exp25's quoted 5.2, 2.0e2, 9.1e3, 2.6e8, **2.6e16**, 1.2e17 —
agreement to within one order at every K, and to 20 % at the headline
K = 24. Prime knots: 1.99e17 here vs 1.8e16 quoted at K = 24 (one order;
both are past the double-precision cliff, where the value is a noise floor,
not a quantity). **The comparison of §3.1 is therefore against a replicated,
not merely quoted, baseline.** (The joint number 7.3e18 vs 2.7e17 differs by
one order for the same reason — the joint system is rank-deficient in both
implementations and σ_min is roundoff.)

### 3.3 Control A1 (dimension-matched): the prolate *family* is not the cure

Registered prediction, written into the source before running: *truncating the
prolate span to exp25's dimension 60 will fail like exp25, because the resource
being bought is time–bandwidth, not the basis family.* Confirmed:

| K | first 60 prolates, c=30π | c=100 | c=400 | c=652 | exp25 |
|---|---|---|---|---|---|
| 15 | 4.6e9 | 5.97e9 | 6.66e5 | 3.48 | 9.1e3 |
| 20 | 6.57e14 | 9.49e14 | 1.0e7 | 4.04e7 | 2.6e8 |
| **24** | **1.09e16** | 1.62e15 | 1.3e7 | 6.71e10 | **2.6e16** |
| 60 | 1.41e18 | 3.51e16 | 1.6e9 | 5.35e12 | — |

At exp25's dimension the prolate basis is **as bad as, or worse than, the
Gaussian dictionary** at the headline knot count. (The two large-c rows are
better at intermediate K only because the first 60 prolates of a large-c
operator are a well-conditioned *narrow* system near u = 0 — and correspondingly
they are *worse* on prime knots, cond 1.5e4 and 1.7e3 at K = 24 versus 5.5e5
and 6.0e6 for the small-c ones, because they cannot reach the outlying knot at
log 53 ≈ 3.97.)

**Consequence for `LP_CERT` §5.** Its closing sentence — "a better-motivated
next experiment is collocation in a prolate/Sonin-adapted basis" — is
**correct in its recommendation and wrong in its implied diagnosis**. The
Gaussian span did not fail because Gaussians are the wrong shape. It failed
because 60 degrees of freedom cannot resolve 24 zero knots reaching to
γ_24 = 87.4 inside a window of width 8. The right statement is: *ask for the
rectangle, not the basis.*

### 3.4 The diagnosis: a Landau/Nyquist density criterion (both knot families)

The data pin the mechanism exactly. Well-conditioning holds **iff the knots
sit inside the span's Nyquist resources**, and the two knot families test the
two sides of the same rectangle:

- **zero knots** need *bandwidth*: cond ≈ 1 exactly while τ_edge = 2c/T ≥ γ_K,
  and blows up exponentially past it. Read the table: c = 200 (τ_edge = 50)
  is clean to K = 10 (γ_10 = 49.8) and breaks at K = 15 (γ_15 = 65.1);
  c = 400 (τ_edge = 100) is clean to K = 30 (γ_30 = 101.3) and breaks at
  K = 40 (γ_40 = 122.9); c = 652 (τ_edge = 163) is clean to K = 60
  (γ_60 = 163.03 — the crossing is *at* the last tested knot). Required
  dimension: **N ≳ T·γ_K/π** = 222.6 at K = 24, T = 8, versus exp25's 60.
- **prime knots** need *spatial resolution*: the Nyquist spacing π/τ_edge must
  be below the minimal gap of {log p^k < 4}, which is
  log 32 − log 31 = 0.03175, i.e. **τ_edge ≳ 99**. Read the table: c = 100
  (τ_edge = 25) gives 7.82, c = 200 (τ_edge = 50) gives 1.83, c = 400
  (τ_edge = 100 — the predicted crossing) gives **1.30**, c = 652 gives 1.20.

Both are the classical Landau density conditions for interpolation in a
Paley–Wiener space, applied on the two sides of the (T, τ_edge) rectangle.
There are in fact *two* zero-side conditions and only the first binds here:
(a) **band coverage** γ_K ≤ τ_edge, i.e. N ≳ T·γ_K/π — this is the one the
data pin; (b) the **Beurling density** condition, that the zero density
(1/2π)log(γ/2π) stay below the Nyquist density T/2π, i.e. γ_K ≲ 2π e^{T} =
1.87e4 at T = 8 — not binding for K ≤ 60 (γ_60 = 163). Condition (b) is the
one that would bind for a *narrow* window, and its exponential-in-T form is
the same scale as CC's ζ-cycle length L = log μ (dictionary row 4). That
coincidence of scales is noted, not claimed.

---

## 4. The Weil form on prolate spans: what did **not** improve

Part B: basis φ_n(u) = √(2/T) ψ_n(2u/T), c = 15π, N = 36 (Shannon number
30 — the same time–bandwidth rectangle as exp25 part B's M = 30 compact
cosine modes), window T swept through the prime-power thresholds.

### 4.1 The margin collapse is basis-independent

| T | λ_min(W&#124;_P), prolate N=36 | exp25 compact M=30 (`LP_CERT` §4) | ratio |
|---|---|---|---|
| 0.81 (after 2) | 2.0174e−1 | 2.5e−1 | 0.81 |
| 1.22 (after 3) | 3.5883e−5 | 8.4e−5 | 0.43 |
| 1.50 (after 4) | 7.6942e−10 | 1.1e−9 | 0.70 |
| 1.73 (after 5) | 4.1969e−15 | 1.4e−14 | 0.30 |
| 2.07 (after 7) | 1.2619e−21 | 4.4e−21 | 0.29 |
| 2.40 | 5.2565e−26 | — | — |
| 2.60 | 4.6654e−28 | — | — |
| 3.00 | 1.0574e−31 | — | — |

Two entirely different bases (C¹ compact cosine-difference modes vs
hard-edged prolates), at the same time–bandwidth budget, produce the same
margin to within a factor 1.2–3.5 at every shared window, including the
3–7-orders-per-prime-power drops. **The negativity landscape of `LP_CERT` §4
is a property of the window, not of the dictionary.** Fixing the interpolation
conditioning bought exactly nothing here — which is the honest headline of
this half, and a real constraint: no re-choice of basis inside a fixed
(T, τ_edge) rectangle will restore margin.

The inertia statement of `LP_CERT` §2 (H2) survives on every prolate span
tested: inertia(I) = (1, ·, rest) at T = 0.60 … 3.00, i.e. exactly one
positive direction, with the positive eigenvector overlapping the pole plane
at 0.998–0.999.

### 4.2 The both-ways cross-check, and the near-null count

−λ_min(W|_P) (factored, zero side) vs the top of I|_P (assembled from Λ(n)
and the Γ-factor) agree to relative 4.9e−5 (T = 0.60), 2.1e−4 (0.81),
6.0e−4 (1.22), 7.7e−4 (1.50), 6.5e−2 (1.73), and then disagree completely:
from T = 2.07 the assembled top of I|_P returns +6.1e−15, +1.1e−14, +1.8e−14,
+2.1e−14 while the factored value is 1.3e−21 … 1.1e−31. **The assembled
computation has an absolute floor of ≈ 2e−14 on this basis**; every "+"
entry there is floor, not a positive direction. Do not read them as violating
H1.

Counts of near-null directions of W grow with the window (at threshold
1e−8·λ_max: 0, 0, 0, 1, 3, 5, 9, 12, 13, 16 across T = 0.60…3.00), but the
count is strongly threshold-dependent (at T = 3.00: 19, 16, 10 at thresholds
1e−4, 1e−8, 1e−16). Panel (e) of the figure plots CC's ν(μ) ~ 2μ = 2e^T
alongside; **this is illustrative only and is not evidence either way.** The
CC count is of eigenvalues of an angle operator between two projections on the
full space, and the part-B object is the near-radical of W on a fixed
36-dimensional span whose band 2c/T *shrinks* as T grows. They are not the
same object; the comparison is retained in the figure only because the
docstring promised it, and is hereby downgraded.

### 4.3 The cost of the hard edge (a real regression)

The prolate window is discontinuous at ±T/2, so Φ_{φ_n}(½+iτ) ~
[edge terms]/(iτ) and both the archimedean τ-integral and the zero sum have
1/τ² non-oscillatory tails. Both are corrected analytically by the same
asymptotic: writing a_j = φ_j(T/2) and b_j = φ_j(−T/2) for the two edge values
and A_no for the rank-2 matrix (a_j a_k + b_j b_k)_{jk},

tail(X) = A_no · [log(X/2π) + 1] / (πX),

applied at X = τ_end for the archimedean quadrature and at X = γ_max = 74920.8
for the omitted zeros. The correction is essential and works — the entrywise
cross-check goes from **raw 1.15e−1 to corrected 6.96e−5** at T = 0.60 and
from 5.96e−3 to **1.89e−7** at T = 3.00 — but the corrected residual
(1.9e−7 … 7.0e−5) is **four orders worse than exp25's 3.3e−9 / 9.6e−7**. The
diagnosis is the residual *oscillatory* part of the 1/τ² tail, of size
≈ 1/γ_max ≈ 1.3e−5 relative, which no non-oscillatory model removes.

**Trade recorded: the prolate basis buys 16 orders of collocation
conditioning and costs 4 orders of explicit-formula verification accuracy.**
Any theorem-level use wants a smoothed (Sonin-type) prolate, not the
hard-edged one.

---

## 5. Does the prolate span *see* an RH violation? (control B1)

A certificate space that cannot detect a violation is useless however well
conditioned. Move the pair {½ ± iγ_1} to {½ + δ + iγ_1, ½ − δ + iγ_1}; for
real g the pair contributes 2Re[Φ(½+δ+iγ_1)·conj Φ(½−δ+iγ_1)], which at
δ = 0 reduces **exactly** to the on-line 2|Φ|² (built-in consistency check —
reproduced: at T = 1.22 the perturbed λ_min at δ = 0 is 7.955480e−10 against
the unperturbed 7.955e−10).

| T | δ = 1e−3 | 1e−2 | 5e−2 | 2e−1 |
|---|---|---|---|---|
| 1.22 | +6.5e−10 (no) | −1.4e−8 (W only) | −5.6e−6 (W only) | −6.8e−4 (both) |
| 1.50 | **−8.7e−9** | −4.8e−6 | −3.8e−4 | −8.1e−3 |
| 2.07 | **−4.0e−7** | −5.6e−5 | −1.5e−3 | −2.6e−2 |
| 2.60 | **−1.1e−6** | −1.2e−4 | −3.2e−3 | −5.6e−2 |

(entries are λ_min(W_pert|_P); "W only" = detected on the full form but not
on the primitive block.) **The span detects a displacement δ = 1e−3 of the
first zero from T = 1.50 upward**, with the detected negativity 6 to 9 orders
above the dense-eigensolver floor. Detection power increases with the window,
as Weil's criterion requires. This is the designed-annihilation control for
the whole part-B apparatus: it is a known-false target that the measurement
must, and does, kill.

## 5.1 Arithmetic resolution (control B2, proves-too-much)

Scaling the prime side by (1 + ε) must break H1 (I|_P ≤ 0) at some ε:

| T | ε = 0 | 1e−12 | 1e−9 | 1e−6 | 1e−3 | 1e−1 |
|---|---|---|---|---|---|---|
| 0.81 | −2.02e−1 | −2.02e−1 | −2.02e−1 | −2.02e−1 | −2.02e−1 | −1.79e−1 |
| 1.50 | −7.70e−10 | −7.70e−10 | −6.96e−10 | **+1.61e−7** | +4.76e−4 | +7.17e−2 |
| 2.07 | +6.08e−15 (floor) | **+5.31e−13** | +8.99e−10 | +1.05e−6 | +1.34e−3 | +1.50e−1 |

At T = 0.81 the margin is O(1) and a 10 % perturbation of all of arithmetic
does not break it — the prime-free/near-prime-free regime is genuinely robust.
At T = 1.50 the form resolves ε ≈ 1e−6; by T = 2.07 it resolves ε ≈ 1e−12.
Read the other way: **past T ≈ 2 the computed statement "I|_P ≤ 0" is
sensitive to the twelfth digit of the prime side**, which is a sharper way of
saying `LP_CERT` §4's "the minimizer rides an extreme cancellation".

---

## 6. Localization of I in prolate coordinates: NO-GO (part C)

The CC compression picture suggests I = prime − arch might be near-diagonal in
prolate coordinates. It is not.

| T | diagonal Frobenius fraction of I | unrestricted random-rotation control | **parity-respecting** control |
|---|---|---|---|
| 1.50 | 0.736 | median 0.609 | median **0.633**, max 0.661 |
| 2.60 | 0.422 | median 0.273 | median **0.309**, max 0.346 |

The one exact structural fact is parity: F is even, so I couples only
same-parity prolates — the opposite-parity Frobenius mass is 1.6e−32 (T=1.50)
and 7.5e−32 (T=2.60), i.e. exactly zero. This is the checkerboard visible in
figure panel (g), and it is a triviality, not a finding; the *unrestricted*
random control is therefore too weak, which is why the parity-respecting null
was added. Against the correct null the excess is a factor **1.16 (T = 1.50)
and 1.36 (T = 2.60)** — no meaningful localization. Participation ratios of
the extreme eigenvectors are 1.7–9.8 out of 36 (the top of I|_P has
participation 2.3, dominated by prolate indices 0 and 6 with weights 0.63 and
0.10–0.12 at both windows), so the extreme *directions* are sparse in prolate
coordinates even though the *matrix* is not diagonal. **Verdict: refuted as
stated in the docstring; the residual content is that the hardest direction is
consistently a low-index-prolate object.**

---

## 7. The zeta-cycle mechanism imported (part D)

### 7.1 The identity (derivation)

With g = E(f)∘exp, i.e. g(u) = e^{u/2}Σ_{n≥1} f(n e^u):

$$\Phi_{\mathcal E(f)}(s)=\int_{\mathbb R}\!\Big(v^{1/2}\!\sum_n f(nv)\Big)v^{s-1/2}\frac{dv}{v}
=\sum_n n^{-s}\!\int_0^\infty\! f(y)y^{s-1}dy=\zeta(s)M(f)(s),$$

for f ∈ S_0^ev in the convergence range, extended by analytic continuation.
So **every E(f) is an exact null vector of the Weil form** where it is
admissible: Φ vanishes at every zero. This is the repo-normalization form of
CC's statement that the radical contains the range of E.

### 7.2 The identity verified (pratyakṣa)

For f(x) = 8x²e^{−x²/2} − x²e^{−x²/8} (even, f(0) = 0, ∫f = 0), with
M(f)(s) = ½Γ((s+2)/2)[8·2^{(s+2)/2} − 8^{(s+2)/2}]: quadrature vs
mpmath ζ(s)M(f)(s) agrees to relative **1.1e−13** (s = 2+3i), **1.2e−12**
(s = 0.6+2i), **5.6e−11** (s = ½+10i). At s = ½ + iγ_1 the quadrature gives
|Φ| = 7.78e−13 against 2.93e−2 at τ = 10 — ζ annihilates it, as the identity
demands.

### 7.3 Windowed prolate E-vectors track the Slepian leakage

Take f_m = ψ_{2m}^{(c)} on [−λ, λ] with c = 2πλ² (dictionary row 5), corrected
by ψ_0, ψ_2 to enforce f(0) = 0 = ∫f, and restrict g_m = E(f_m) to
[λ^{−1}, λ]. Because E(f) vanishes on (0, 1/λ) for band-limited f with
\hat f(0) = 0, the truncation error is exactly the band leakage. Measured
Rayleigh quotients W(g_m)/‖g_m‖² against 1 − λ_{2m}(2πλ²):

| λ² | m | W/‖g‖² | 1 − λ_{2m} | ratio |
|---|---|---|---|---|
| 3 | 4 | 2.085e−3 | 1.274e−3 | 1.64 |
| 3 | 6 | 9.503e−1 | 6.885e−1 | 1.38 |
| 5 | 4 | 7.501e−12 | 3.011e−12 | 2.49 |
| 5 | 6 | 5.170e−7 | 2.629e−7 | 1.97 |
| 5 | 8 | 3.596e−3 | 2.634e−3 | 1.37 |

**Agreement within a factor 1.4–2.5 across six orders of magnitude** (the
λ² = 3, m = 2 point is 4.2× and the λ² = 5, m = 2 point is unusable because
1 − λ_4 = 3.7e−14 is itself at the double-precision floor of computing
1 − λ). The mechanism claimed by the docstring is therefore confirmed in the
regime where both sides are resolvable: *W on a windowed zeta-cycle vector is
the Slepian band leakage.*

**Control (wrong test function).** A Gaussian pair f ∈ S_0^ev in the same
window λ² = 5, same construction: W/‖g‖² = **4.862e−3** versus the prolate
m = 2 value **1.482e−17** — **fourteen orders**. The prolate choice is not
cosmetic.

### 7.4 CC's 2.389e−48: NOT reproduced, and unreachable here

At λ² = 11 the Rayleigh quotients descend to 3.447e−24 (m = 2), while the
computable leakage 1 − λ_{2m} is pinned at its double-precision floor
4.29e−14 for every m ≤ 12 — so the tracking **cannot be checked at all at CC's
own parameter**. Worse, the λ² = 11 quotients are themselves at or near the
roundoff floor: they are **non-monotone in m** (3.4e−24, 2.7e−22, 6.0e−21,
2.2e−20, **1.3e−20**, 2.8e−18 at m = 2, 4, 6, 8, 10, 12 — the m = 10 entry
drops below m = 8), which is the signature of a floor, and a node-count-scaled
roundoff estimate for the oscillatory quadrature gives ≈ 1e−24 (an optimistic
random-walk estimate gives 4e−28; the truth is bracketed and the printed values
are inside the bracket). **Nothing at λ² = 11 in this run should be trusted
below ~1e−18.**

CC's quoted 2.389e−48 (Fig. 26, FETCHED) is ~24 orders below anything double
precision can express here. Reproducing it requires extended precision (part D
would need mpmath at ≈120 digits throughout the zero sum) and is filed as
future work, not as a result. **Nothing in this note confirms or contradicts
that number.** In particular, no numerical coincidence with it should be read
off these floors.

---

## 8. Designed annihilation (msg 0073 / PROTOCOL §7)

| control | what it would have killed | outcome |
|---|---|---|
| **Slepian plunge vs Shannon number** (classical ground truth) | the whole prolate implementation | passed: 6/30/64 vs 6.37/30.00/63.66; χ_n vs `scipy.pro_cv` 3.9e−15 |
| **A1, dimension-matched** (first 60 prolates) | the claim "the prolate *basis* fixes collocation" | **fired**: 1.09e16 at K = 24 — the basis-family reading is dead; the resource reading survives |
| **A2, wrong basis** (exp25's Gaussians re-implemented here) | the comparison itself, if the baseline were mis-quoted | passed: 2.11e16 vs 2.6e16 quoted at K = 24 |
| **B1, known-false positivity target** (off-line zero at γ_1) | the certificate value of the span | passed: δ = 1e−3 detected from T = 1.50; δ = 0 reproduces λ_min exactly |
| **B2, proves-too-much** (prime side × (1+ε)) | the claim that H1 is *measured* rather than assumed | passed: breaks at ε ≈ 1e−6 (T=1.5), ε ≈ 1e−12 (T=2.07); does *not* break at ε = 0.1 for T = 0.81. **[Qualified 2026-08-15, reach audit `notes/CORRECTION_REACH_AUDIT.md`; nothing removed.]** Restated against this note's own assembly floor φ ≈ 2e−14 (§7), `notes/SEED44_MUQABALA_OPERATOR.md` §6.2 gets: at T=1.5 the separating set is only certified to lie in (1e−9, 1e−6]; at T=2.07 the ε=0 row (v = 6.08e−15 ≤ φ) has honest output the enclosure [−2e−14, +2e−14] ∋ 0, so that line certifies a separating widening for ε ≥ 1e−12 but **certifies nothing about the undeformed H1 at that T** — the sign of the undeformed functional is not determined by the printed data. SEED-44's verdict on this cell, quoted: "reads as stronger evidence for `H1` than the numbers support." |
| **C, parity-respecting null** | the localization claim | **fired**: excess over the correct null is only 1.16–1.36× |
| **D, wrong test function** (Gaussian pair, same window) | the specialness of prolate E-vectors | passed: 4.86e−3 vs 1.48e−17 |
| **both-ways assembly** (zero side vs pole−prime+arch) | the whole part-B pipeline | passed to 4.9e−5 … 7.7e−4 relative down to T = 1.50, then hits the assembly floor 2e−14 (§4.2) |

Pramāṇa labels: §2, §3, §4, §5, §6, §7.2–7.3 are **pratyakṣa** (printed by
`code/exp59_prolate.py`; log in `data/exp59_out.txt`). §1 rows 1–2, 4–5 and
§7.1 are **anumāna** (one-line derivations, displayed in full). §1 rows 3, 6–7
and §9 are **śabda**, labelled FETCHED or UNVERIFIED-MEMORY individually.

---

## 9. Literature (śabda, individually labelled)

Fetched this session (2026-08-12) from arXiv abstract/HTML pages; PDFs were
not needed.

- **FETCHED** — Connes–Consani, *Weil positivity and Trace formula, the
  archimedean place*, **arXiv:2006.13771** (https://arxiv.org/abs/2006.13771),
  57 pp., 17 figs, MSC 11M55. Title/authors/abstract confirmed, matching the
  quotation already in `LP_CERT` §6. Selecta Math. 27 (2021) as `LP_CERT`
  states — the journal reference was **not** visible on the fetched listing
  page this session, so that half of the citation stays as `LP_CERT` recorded
  it (UNVERIFIED here).
- **FETCHED** — Connes–Consani, *Spectral triples and zeta-cycles*,
  **arXiv:2106.01715** (https://arxiv.org/abs/2106.01715), submitted
  2021-06-03. Abstract confirms: small eigenvalues of a quadratic form linked
  to Weil's explicit formulas; eigenvectors from prolate spheroidal wave
  functions; first thirty-one zeta zeros reproduced numerically; "zeta cycles"
  introduced. **The three specific claims the exp59 docstring rests on were
  checked in the full text** (https://ar5iv.labs.arxiv.org/abs/2106.01715):
  (i) the map, eq. (1.3): "ℰ(f)(x) := x^{1/2} Σ_{n>0} f(nx), ∀f ∈ 𝒮_0^{ev}";
  (ii) §3: "the angle operator between these two projections admits a finite
  number 1 + ν(λ²) ∼ 2λ² of extremely small non zero eigenvalues", attributed
  there to Slepian–Pollak; (iii) Fig. 26 caption: "For μ = 11 the eigenvalue
  is 2.389 × 10^{−48}". Definition 1.1: "A ζ-cycle is a circle C of length
  L = log μ such that the subspace Σ_μ ℰ(𝒮_0^{ev}) is not dense in L²(C)" —
  this is the source of dictionary row 4 (T = log μ).
  **Correction to the docstring:** it cites "arXiv:2106.01715 §2.5" for
  ν(λ²) ~ 2λ²; the statement is in **§3**, not §2.5.
- **FETCHED** — Connes–Moscovici, *Prolate spheroidal operator and Zeta*,
  **arXiv:2112.05500** (https://arxiv.org/abs/2112.05500), submitted
  2021-12-10. Abstract confirmed: the self-adjoint extension W of the prolate
  spheroidal operator, restricted to the complement of an interval J, has
  negative eigenvalues whose ultraviolet behaviour reproduces that of the
  squares of the zeta zeros; eigenfunctions in the Sonin space. **The
  docstring attributes this paper to "Connes–Moscovici" — correct.**
- **FETCHED** — Connes–Consani–Moscovici, *Zeta zeros and prolate wave
  operators*, **arXiv:2310.18423** (https://arxiv.org/abs/2310.18423),
  submitted 2023-10-27, revised 2024-05-04. Abstract confirmed: semilocal
  analogue of the prolate wave operator; positive part of the spectrum for
  low-lying zeros, Sonin space (negative part) for ultraviolet behaviour;
  archimedean case = square of the scaling operator plus a grading by
  orthogonal polynomials; relation to the metaplectic representation of
  SL(2,ℝ). Ann. Funct. Anal. 15 (2024) as `LP_CERT` §6 states — journal
  reference not re-verified this session (UNVERIFIED here).
- **FETCHED (bibliographic)** — Slepian & Pollak, *Prolate spheroidal wave
  functions, Fourier analysis and uncertainty — I*, **Bell System Technical
  Journal 40 (1), Jan. 1961, 43–63**
  (https://onlinelibrary.wiley.com/doi/abs/10.1002/j.1538-7305.1961.tb03976.x).
  Landau–Pollak II is the companion in the same issue, 65–84; the
  dimension-of-time-and-band-limited-signals result is Landau–Pollak III,
  BSTJ 41 (4), July 1962, 1295–1336
  (https://onlinelibrary.wiley.com/doi/abs/10.1002/j.1538-7305.1962.tb03279.x).
  The *content* used here (λ_n ≈ 1 for n < 2c/π then a plunge of width
  O(log c)) is not taken on testimony: it is re-derived numerically in §2.
- **FETCHED (bibliographic)** — Radchenko & Viazovska, *Fourier interpolation
  on the real line*, **Publ. Math. IHÉS 129 (2019) 51–81**, DOI
  10.1007/s10240-018-0101-z, arXiv:1701.00265
  (https://link.springer.com/article/10.1007/s10240-018-0101-z). Used only as
  the *motivation* for the two-sided knot system {log p^k} ∪ {γ}; no theorem
  of theirs is invoked. The zeta-side analogue is a proposal recorded in
  `JEWELS` §1, not a result of theirs.
- **FETCHED (bibliographic)** — Xiao, Rokhlin & Yarvin, *Prolate spheroidal
  wavefunctions, quadrature and interpolation*, **Inverse Problems 17 (4)
  (2001) 805–838** (https://iopscience.iop.org/article/10.1088/0266-5611/17/4/315).
  Cited in the code for the Legendre-tridiagonal route; the route's
  correctness is verified independently in §2 against `scipy.pro_cv`.
- **UNVERIFIED-MEMORY** — that the Legendre-basis tridiagonalization of L_c
  per parity chain (the specific recurrence coefficients in
  `prolate_legendre_tridiag`) appears in Xiao–Rokhlin–Yarvin in exactly that
  form. The formula is standard (Bouwkamp; Slepian) and, more to the point,
  is *checked* to 3.9e−15 against `scipy.special.pro_cv`, so nothing rests on
  the attribution.
- **UNVERIFIED-MEMORY** — the assertion in the exp59 docstring that CC's
  §2.5/§3 "zeta-cycle prediction" ν(λ²) ~ 2λ² should govern the near-null
  count of W on a *fixed finite prolate span* (part B). It should not; see
  §4.2. The CC statement is about an angle operator between two projections
  on the full space. Downgraded.

---

## 10. Honest fencing

1. Nothing here is a theorem toward RH. §3 is a numerical-linear-algebra
   result about evaluation functionals; §4–§7 are conditioned finite-dimensional
   measurements on 100,000 supplied Odlyzko ordinates in floating arithmetic.
   None of the small numbers is an interval-certified bound.
2. The conditioning headline is a statement about **row-normalized evaluation
   functionals in an orthonormal basis of a specific 440-dimensional span**.
   Good conditioning of the interpolation *system* is necessary, not
   sufficient, for a certificate: it says the linear algebra is solvable, not
   that a nonnegative solution with the required sign pattern exists.
3. Prolates are hard-edged (discontinuous at ±T/2), hence **below the C²
   admissibility of `WEIL.md` Prop W1** — worse than exp25 part B's C¹ modes.
   Every part-B number is therefore a finite-dimensional diagnostic; theorem
   transfer needs a smoothed/Sonin-type window. §4.3 quantifies the price
   already paid numerically (4 orders of cross-check accuracy).
4. The assembled part-B matrices have an absolute floor ≈ 2e−14; all
   "+" entries of top(I|_P) for T ≥ 2.07 are that floor. The factored
   (zero-side) values below ~1e−26·λ_max are below the SVD trust floor, as in
   `LP_CERT` §3.
5. Part D uses only zeros below 5000 (4520 of them) with an analytic
   jump-budget bound on the tail; the printed "+tail ≤ …" columns are that
   bound, and at λ² = 3 they are 8–20 % of the value, so the λ² = 3 ratios are
   accurate only to that.
6. exp25's quoted joint conditioning (2.7e17) and this note's re-implementation
   (7.3e18) differ by an order. Both are past the double-precision cliff where
   σ_min is roundoff; neither number is meaningful beyond "degenerate".
7. The Landau/Nyquist criterion of §3.4 is stated as a *diagnosis fitted to
   nine values of K and four values of c*, not as a proved lemma. §11 states
   what proving it would require.

---

## 11. The sharpest next lemma

**Lemma P (proposed).** Let 𝔅(T, Ω) be the space of L² functions supported in
[−T/2, T/2], and let E_K : 𝔅 → ℂ^K be the zero-knot evaluation map
g ↦ (Φ_g(½ + iγ_k))_{k≤K}, restricted to the prolate span of dimension
N = ⌈TΩ/π⌉. Then

$$\operatorname{cond}(E_K)\;=\;1+O(1)\quad\text{iff}\quad \gamma_K\le\Omega\;(1-o(1)),$$

with exponential blow-up e^{α(γ_K−Ω)T} beyond, α > 0 absolute; equivalently,
the criterion is Beurling density of {γ_k}_{k≤K} below the Nyquist density
T/2π, i.e. **γ_K ≲ 2π e^{T}** for a window of width T.

Why this is the right next target rather than more numerics: (i) it is a
*statement about the zeros' density only* — it uses log(γ/2π)/2π and nothing
else about ζ, so it is provable by classical Paley–Wiener/Landau technology
(Landau's necessary density conditions for sampling and interpolation, plus
the prolate eigenvalue plunge already reproduced in §2); (ii) it converts the
`LP_CERT` §5 blocker from an empirical cliff into a **budget**: to interpolate
at the first K zeros with a window of width T you must pay
N ≈ Tγ_K/π degrees of freedom, and since γ_K ≈ 2πK/log K this is
N ≈ 2TK/log K — superlinear in the knot count, which is precisely the cost
that any Radchenko–Viazovska-style zeta certificate must budget for; (iii) it
has an immediate *dual* on the prime side, and the dual is the expensive one.
For a window [−T/2, T/2] the prime knots are {log p^k ≤ T/2} and their minimal
gap is ≈ 1/n_max with n_max ≈ e^{T/2} (measured: 31 and 32 give
log 32 − log 31 = 0.03175 at T/2 = 4), so the Nyquist spacing condition reads

$$\Omega\;\gtrsim\;\pi/\text{(min gap)}\;\approx\;\pi\,e^{T/2},\qquad\text{hence}\qquad
N\;=\;T\Omega/\pi\;\gtrsim\;T\,e^{T/2}.$$

Combining with the zero side, the **joint feasibility budget for the two-sided
knot system of `JEWELS` §1** is

$$\boxed{\;N\;\gtrsim\;\max\bigl(T\gamma_K/\pi,\;T\,e^{T/2}\bigr)\;}$$

— *exponential in the window width*, driven by the prime knots, not the zeros.
That is the quantity the certificate program actually has to pay, it is what
`LP_CERT` §5's cliff was really measuring, and Lemma P is its archimedean half.
(Sanity: at T = 8 the bound gives N ≳ max(223, 436) = 436 for K = 24, and the
c = 652 span with N = 440 is exactly where both knot families reach cond ≈ 1.2.
This is a one-point consistency check, not a verification of the bound.)

Secondary target, from §4.1: prove that the primitive margin λ_min(W|_P) on a
(T, Ω) rectangle depends on the rectangle and not on the basis — i.e. that the
1.2–3.5 agreement between two unrelated dictionaries is a theorem
(a min-max/Weyl comparison between two N-dimensional subspaces of the same
band-limited space), which would turn §4.1's empirical basis-independence into
a genuine no-go: *no choice of dictionary inside a fixed window restores
margin.*

---

## 12. Ledger yield (PROTOCOL §4, upgrade 3)

- **Constraint learned.** The `LP_CERT` §5 collocation cliff is a
  time–bandwidth/Landau resource deficit, not a dictionary pathology. Cost of
  the fix is explicit: N ≈ Tγ_K/π.
- **Region excluded.** "Change the basis to restore Weil-form margin" is dead:
  two unrelated dictionaries at the same rectangle give the same margin to
  within 3.5× over the 20 orders of magnitude of collapse they share
  (2.0e−1 at T = 0.81 down to 1.3e−21 at T = 2.07). Also dead: I is not
  near-diagonal in prolate coordinates (§6, against the correct null).
- **Mechanism revealed.** W on a windowed zeta-cycle vector = Slepian band
  leakage (§7.3, verified to 1.4–2.5× over six orders), with a 14-order
  wrong-test-function control.
- **Statement sharpened.** Lemma P (§11) plus its prime-side dual, and the
  correction of `LP_CERT` §5's implied diagnosis.
- **Fresh obligation.** CC's 2.389e−48 requires extended precision; the
  double-precision part D is exhausted at ~1e−24.
