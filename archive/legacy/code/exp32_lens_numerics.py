"""Experiment 32: Q-UNIFORM NUMERICS FOR THE CUT-NORM LENS (open interface #2).

Executes the join `LENS_REGULARITY.md` (sibling branch
claude/prime-pair-field-research-18tq7b) x exp11/BLOCKS.md (catchup branch):
the cut-norm theorems there are stated for every fixed Q, but their exp36
measured essentially one Q (1 and 30).  Here the Q-*filtration* is the object:

  (A) Interval discrepancy D_Q(X) = sup_{I subset (0,X]} |sum_{n in I}
      Lambda^flat_Q(n)| = osc of the partial-sum path (exact for the rank-one
      array: ||W_X||_I = D_Q(X)^2, LENS_REGULARITY Thm 1(1)).  Measured for
      Q in {1, 10, 30, 100, 300} and X over 3 decades to 10^7.  RH-consistent
      prediction: D_Q(X)/sqrt(X) flat in X at EVERY Q (exponent 1/2 = Theta),
      with Q entering only through the O_Q(1) of Corollary 1.2
      (D_Q - D_1 bounded by C_Q = sum_{r<=Q} sigma(r)/phi(r)).  Removing more
      major-arc structure must NOT move the exponent -- this is the numerical
      face of the spectral-gap propositions: Lambda^sharp_Q carries only the
      pole + rational atoms, the zeros all sit in Lambda^flat_Q at every Q
      (BLOCKS.md Thm E2: the BC block is spectrally dead).

  (B) Prop 6 counting lemma, both sides: |G1 - [##]_Q| <= 2Q X^2 D_Q + X D_Q^2.
      LHS computed exactly as 2[#b] + [bb] via FFT convolutions of the sharp
      and flat parts (numerically cleaner than differencing two ~X^3 counts;
      cross-validated against the direct difference at N = 10^6).  Slack
      RHS/|LHS| quantified over an (X, Q) grid, and the LHS compared against
      the single-zero (pole x zero) model
          -4 Re sum_{gamma>0} X^{rho+2}/(rho(rho+1)(rho+2)),  rho = 1/2+i gamma
      (BLOCKS.md Thm E2 mixed block) using the Odlyzko zeros -- adjudicating
      whether the true error is X^{5/2} (single-zero layer, Prop 6 "sharp up
      to logs") or smaller (X^{3/2}-ish, which would make the bound wasteful
      by ~Q sqrt(X)).

  (C) Bohr cuts (Prop 3 / GRH face): for q <= 20, all residues a (coprime or
      not), D_{B_q}(X) = max_a osc_{x<=X} sum_{n<=x, n=a(q)} Lambda^flat_Q(n),
      at Q = 30 >= q.  GRH-consistent prediction: sqrt(X)-flat for every q,
      with constant ~ 1/sqrt(phi(q)) (the phi(q)-1 nontrivial characters
      average incoherently, each contributing ~ sqrt(X)/phi(q)).

Pure numpy sieves; the zeros table enters only the (B) model comparison.
Runtime ~ 4-6 min at N = 10^7 (FFT length 2^25).  Figure:
../figures/exp32_lens_numerics.png.  Write-up: ../notes/LENS_NUMERICS.md.
"""
import time

import numpy as np
import matplotlib

matplotlib.use("Agg")
import matplotlib.pyplot as plt
from pathlib import Path

HERE = Path(__file__).resolve().parent
FIG = HERE.parent / "figures"
DATA = HERE.parent / "data"

N = 10**7
QS = [1, 10, 30, 100, 300]
BOHR_MODULI = [3, 4, 5, 7, 11, 16, 20]
BOHR_Q = 30
N_ZEROS_MODEL = 5000

# X grids
X_TAB = np.array([10**4, 10**5, 10**6, 10**7])
X_REG = np.unique(np.geomspace(1e4, N, 61).astype(np.int64))   # regression
X_DENSE = np.unique(np.geomspace(1e3, N, 480).astype(np.int64))  # figures/model

t0 = time.time()


def tic(msg):
    print(f"[{time.time() - t0:7.1f}s] {msg}", flush=True)


# ---------------------------------------------------------------- sieves
def sieve_lambda_fast(n):
    """von Mangoldt Lambda(k), 0 <= k <= n (vectorized composite sieve)."""
    is_c = np.zeros(n + 1, dtype=bool)
    for p in range(2, int(n**0.5) + 1):
        if not is_c[p]:
            is_c[p * p :: p] = True
    lam = np.zeros(n + 1)
    primes = np.nonzero(~is_c)[0][2:]
    lam[primes] = np.log(primes)
    for p in primes[primes <= int(n**0.5)]:
        lp, pk = np.log(p), p * p
        while pk <= n:
            lam[pk] = lp
            pk *= p
    return lam


def mobius_phi(n):
    mu = np.ones(n + 1, dtype=np.int64)
    phi = np.arange(n + 1, dtype=np.int64)
    is_c = np.zeros(n + 1, dtype=bool)
    for p in range(2, n + 1):
        if not is_c[p]:
            is_c[p * p :: p] = True
            mu[p::p] *= -1
            mu[p * p :: p * p] = 0
            phi[p::p] -= phi[p::p] // p
    return mu, phi


MU, PHI = mobius_phi(max(QS))


def sharp_divisor_coeffs(Q):
    """A_d such that Lambda^sharp_Q(n) = sum_{d | n, d <= Q} A_d.

    From c_q(n) = sum_{d | (q,n)} d mu(q/d):
    A_d = d * sum_{q <= Q, d | q} mu(q) mu(q/d) / phi(q).
    """
    A = np.zeros(Q + 1)
    for q in range(1, Q + 1):
        if MU[q] == 0:
            continue
        w = MU[q] / PHI[q]
        for d in range(1, q + 1):
            if q % d == 0:
                A[d] += d * w * MU[q // d]
    return A


def lambda_sharp(Q, n):
    """Lambda^sharp_Q on 0..n via the divisor-coefficient sieve, O(n log Q)."""
    A = sharp_divisor_coeffs(Q)
    out = np.zeros(n + 1)
    for d in range(1, Q + 1):
        if A[d] != 0.0:
            out[d::d] += A[d]
    out[0] = 0.0
    return out


def lambda_sharp_direct(Q, n):
    """Independent construction: tile c_q residue rows (validation only)."""
    out = np.zeros(n + 1)
    for q in range(1, Q + 1):
        if MU[q] == 0:
            continue
        row = np.zeros(q)
        for d in range(1, q + 1):
            if q % d == 0:
                row[::d] += d * MU[q // d]
        out += (MU[q] / PHI[q]) * np.tile(row, n // q + 2)[: n + 1]
    out[0] = 0.0
    return out


def c_upper(Q):
    """C_Q = sum_{r <= Q} sigma(r)/phi(r) (Lemma 1.1's error constant)."""
    r = np.arange(1, Q + 1)
    sig = np.zeros(Q + 1)
    for d in range(1, Q + 1):
        sig[d::d] += d
    return float(np.sum(sig[1:] / PHI[1 : Q + 1]))


# ------------------------------------------------- validation of the sieve
tic("validating Lambda^sharp construction (N = 2*10^5) ...")
for Q in (10, 30, 300):
    a = lambda_sharp(Q, 200000)
    b = lambda_sharp_direct(Q, 200000)
    d = float(np.max(np.abs(a - b)))
    print(f"  Q={Q:4d}: max|divisor-sieve - tiled-c_q| = {d:.2e}")
    assert d < 1e-8

tic(f"sieving Lambda to N = {N:.0e} ...")
LAM = sieve_lambda_fast(N)

# ---------------------------------------------------------------- part A
tic("part A: interval discrepancy D_Q(X), five Q values ...")

resA = {}          # Q -> dict of arrays on X_DENSE
flat_cache = {}    # keep flat arrays for parts B (deleted after use)
for Q in QS:
    sharp = lambda_sharp(Q, N)
    flat = LAM - sharp
    flat[0] = 0.0
    del sharp
    P = np.cumsum(flat)
    osc = np.maximum.accumulate(P) - np.minimum.accumulate(P)
    fp = np.cumsum(np.maximum(flat, 0.0))
    fm = np.cumsum(np.maximum(-flat, 0.0))
    meascut = np.maximum(fp, fm)
    del fp, fm
    resA[Q] = dict(
        D_dense=osc[X_DENSE],
        D_reg=osc[X_REG],
        D_tab=osc[X_TAB],
        meascut_tab=meascut[X_TAB] / X_TAB,
        psi_flat_N=float(P[-1]),
    )
    del P, osc, meascut
    flat_cache[Q] = flat
    tic(f"  Q={Q:4d} done  (D(1e7) = {resA[Q]['D_tab'][-1]:.2f})")

# exponent regressions
def fit_exponent(x, y):
    lx, ly = np.log(x), np.log(np.maximum(y, 1e-300))
    A = np.vstack([lx, np.ones_like(lx)]).T
    coef, res, *_ = np.linalg.lstsq(A, ly, rcond=None)
    n = len(lx)
    s2 = float(res[0]) / (n - 2) if res.size else 0.0
    se = np.sqrt(s2 / np.sum((lx - lx.mean()) ** 2))
    return coef[0], se, np.exp(coef[1])

print("\n=== Part A: interval discrepancy across the Q-filtration ===")
print(f"{'Q':>4} {'D(1e4)':>9} {'D(1e5)':>9} {'D(1e6)':>9} {'D(1e7)':>10} "
      f"{'exp(1e4-1e7)':>13} {'exp(1e5-1e7)':>13} {'c=D/sqrtX@1e7':>14} "
      f"{'max|D_Q-D_1|':>13} {'C_Q':>9}")
D1_reg = resA[1]["D_reg"]
D1_dense = resA[1]["D_dense"]
expA = {}
for Q in QS:
    r = resA[Q]
    sl_all, se_all, _ = fit_exponent(X_REG, r["D_reg"])
    m = X_REG >= 10**5
    sl_hi, se_hi, _ = fit_exponent(X_REG[m], r["D_reg"][m])
    expA[Q] = (sl_all, se_all, sl_hi, se_hi)
    maxdiff = float(np.max(np.abs(r["D_reg"] - D1_reg)))
    c7 = r["D_tab"][-1] / np.sqrt(X_TAB[-1])
    print(f"{Q:>4} {r['D_tab'][0]:>9.2f} {r['D_tab'][1]:>9.2f} "
          f"{r['D_tab'][2]:>9.2f} {r['D_tab'][3]:>10.2f} "
          f"{sl_all:>7.4f}+-{se_all:.4f} {sl_hi:>7.4f}+-{se_hi:.4f} "
          f"{c7:>14.4f} {maxdiff:>13.2f} {c_upper(Q):>9.1f}")

print("\nD_Q/sqrt(X) at table heights (constant of the filtration):")
print(f"{'Q':>4}" + "".join(f" {f'X=1e{int(np.log10(x))}':>10}" for x in X_TAB))
for Q in QS:
    print(f"{Q:>4}" + "".join(f" {v:>10.4f}"
          for v in resA[Q]["D_tab"] / np.sqrt(X_TAB)))

print("\nmeasurable-cut scale max(sum f+, sum f-)/X (Lemma 2 degeneration):")
print(f"{'Q':>4}" + "".join(f" {f'X=1e{int(np.log10(x))}':>10}" for x in X_TAB))
for Q in QS:
    print(f"{Q:>4}" + "".join(f" {v:>10.4f}" for v in resA[Q]["meascut_tab"]))

# ---------------------------------------------------------------- part C
# (done before B so the Q=30 flat array is still guaranteed in cache)
tic("part C: Bohr cuts at Q = 30, q <= 20 ...")
flat30 = flat_cache[BOHR_Q]
resC = {}
for q in BOHR_MODULI:
    best_dense = np.zeros(len(X_DENSE))
    for a in range(q):
        sub = flat30[a::q]                      # n = a, a+q, a+2q, ...
        P = np.cumsum(sub)
        osc = np.maximum.accumulate(P) - np.minimum.accumulate(P)
        # number of progression terms n <= X:  k = floor((X-a)/q) terms with
        # n = a+q,...  index into osc: idx = floor((X-a)/q) (osc[0] is n=a).
        idx = np.minimum((X_DENSE - a) // q, len(osc) - 1)
        best_dense = np.maximum(best_dense, osc[idx])
    resC[q] = best_dense

print("\n=== Part C: Bohr-cut discrepancy D_Bq(X) at Q=30 (max over all a) ===")
print(f"{'q':>4} {'phi(q)':>6} {'D(1e6)':>9} {'D(1e7)':>9} "
      f"{'exp(1e5-1e7)':>14} {'D/sqrtX@1e7':>12} {'x sqrt(phi)':>12}")
expC = {}
for q in BOHR_MODULI:
    y = resC[q]
    m = X_DENSE >= 10**5
    sl, se, _ = fit_exponent(X_DENSE[m], y[m])
    expC[q] = (sl, se)
    i6 = np.searchsorted(X_DENSE, 10**6)
    c7 = y[-1] / np.sqrt(X_DENSE[-1])
    print(f"{q:>4} {PHI[q]:>6} {y[i6]:>9.2f} {y[-1]:>9.2f} "
          f"{sl:>8.4f}+-{se:.4f} {c7:>12.4f} {c7*np.sqrt(PHI[q]):>12.4f}")

# ---------------------------------------------------------------- part B
tic("part B: Prop 6 counting lemma via FFT convolutions ...")
L = 1 << 25
assert L >= 2 * N + 1
F_LAM = np.fft.rfft(LAM, L)


def profile(r):
    """[.](X) = sum_s (X-s)_+ r(s) = X R(X) - S(X); return evaluator arrays."""
    R = np.cumsum(r)
    S = np.cumsum(np.arange(len(r), dtype=np.float64) * r)
    return R, S


def eval_profile(R, S, xs):
    return xs.astype(np.float64) * R[xs] - S[xs]


resB = {}
for Q in QS:
    flat = flat_cache[Q]
    F_flat = np.fft.rfft(flat, L)
    F_sharp = F_LAM - F_flat
    r_sf = np.fft.irfft(F_sharp * F_flat, L)[: N + 1]
    del F_sharp
    r_ff = np.fft.irfft(F_flat * F_flat, L)[: N + 1]
    del F_flat
    Rsf, Ssf = profile(r_sf)
    del r_sf
    Rff, Sff = profile(r_ff)
    del r_ff
    lhs_dense = 2.0 * eval_profile(Rsf, Ssf, X_DENSE) + eval_profile(Rff, Sff, X_DENSE)
    bb_dense = eval_profile(Rff, Sff, X_DENSE)
    del Rsf, Ssf, Rff, Sff
    D_dense = resA[Q]["D_dense"]
    rhs_dense = 2.0 * Q * X_DENSE.astype(float) ** 2 * D_dense + X_DENSE * D_dense**2
    resB[Q] = dict(lhs=lhs_dense, rhs=rhs_dense, bb=bb_dense)
    if Q != BOHR_Q:
        del flat_cache[Q]
    tic(f"  Q={Q:4d} done  (|LHS|(1e7) = {abs(lhs_dense[-1]):.3e}, "
        f"RHS(1e7) = {rhs_dense[-1]:.3e})")

# cross-validate the flat-route LHS against the direct difference at N=1e6
tic("part B validation: direct G1 - [##] at N = 10^6, Q = 30 ...")
n_v = 10**6
Lv = 1 << 21
lam_v = LAM[: n_v + 1].copy()
sh_v = lambda_sharp(30, n_v)
r_tot = np.fft.irfft(np.fft.rfft(lam_v, Lv) ** 2, Lv)[: n_v + 1]
r_ss = np.fft.irfft(np.fft.rfft(sh_v, Lv) ** 2, Lv)[: n_v + 1]
Rt, St = profile(r_tot)
Rs, Ss = profile(r_ss)
xs_v = X_DENSE[(X_DENSE >= 10**4) & (X_DENSE <= n_v)]
lhs_direct = eval_profile(Rt, St, xs_v) - eval_profile(Rs, Ss, xs_v)
fl_v = lam_v - sh_v
fl_v[0] = 0.0
Ff = np.fft.rfft(fl_v, Lv)
Fs = np.fft.rfft(sh_v, Lv)
r_sf_v = np.fft.irfft(Fs * Ff, Lv)[: n_v + 1]
r_ff_v = np.fft.irfft(Ff * Ff, Lv)[: n_v + 1]
R1, S1 = profile(r_sf_v)
R2, S2 = profile(r_ff_v)
lhs_flat = 2.0 * eval_profile(R1, S1, xs_v) + eval_profile(R2, S2, xs_v)
relerr = np.max(np.abs(lhs_direct - lhs_flat) / np.maximum(np.abs(lhs_flat), 1.0))
print(f"  max rel diff (direct big-difference vs flat-route) = {relerr:.2e}")
del lam_v, sh_v, r_tot, r_ss, fl_v, Ff, Fs, r_sf_v, r_ff_v

# single-zero (pole x zero) model from the Odlyzko zeros
tic("part B: single-zero model from Odlyzko zeros ...")
gam = np.loadtxt(DATA / "odlyzko_zeros_100k.txt")[:N_ZEROS_MODEL]
rho = 0.5 + 1j * gam
w = 1.0 / (rho * (rho + 1.0) * (rho + 2.0))
lx = np.log(X_DENSE.astype(float))
phase = np.exp(1j * np.outer(lx, gam))            # (nX, nzeros)
model_dense = -4.0 * (X_DENSE.astype(float) ** 2.5) * (phase @ w).real
del phase

print("\n=== Part B: Prop 6  |G1 - [##]_Q| <= 2Q X^2 D_Q + X D_Q^2 ===")
mask_cmp = X_DENSE >= 10**4

# --- raw comparison (smooth X^2-scale floor included) ---
print("raw comparison (X >= 1e4), LHS vs -4 Re sum_rho X^(rho+2)/(rho(rho+1)(rho+2)):")
for Q in QS:
    lhsn = resB[Q]["lhs"][mask_cmp] / X_DENSE[mask_cmp] ** 2.5
    mdn = model_dense[mask_cmp] / X_DENSE[mask_cmp] ** 2.5
    corr = np.corrcoef(lhsn, mdn)[0, 1]
    ratio = np.std(lhsn) / np.std(mdn)
    print(f"  Q={Q:4d}: corr = {corr:.4f}, amplitude ratio = {ratio:.4f}")

# --- band-passed comparison (exp11 methodology): the smooth X^2-scale floor
# (Q-dependent block constants -- flagged as scheme artifacts by the catchup
# audit) sits at log-X frequency ~0; the single-zero layer lives at the
# ordinates gamma_i.  Cubic-detrend LHS/X^{5/2} in log X, bandpass to the
# single-zero band [10, 27.5], correlate with the identically processed model.
BP_MASK = X_DENSE >= 10**4       # ~uniform log grid above 1e4 (int jitter <1e-3)
LXB = np.log(X_DENSE[BP_MASK].astype(float))
MB = int(BP_MASK.sum())
COREB = slice(MB // 8, -MB // 8)


def bandpass_log(y, lo=10.0, hi=27.5):
    y = y - np.polyval(np.polyfit(LXB, y, 3), LXB)
    Y = np.fft.rfft(y)
    f = np.fft.rfftfreq(MB, d=(LXB[-1] - LXB[0]) / (MB - 1)) * 2 * np.pi
    Y[(f < lo) | (f > hi)] = 0.0
    return np.fft.irfft(Y, MB)


bm = bandpass_log(model_dense[BP_MASK] / X_DENSE[BP_MASK] ** 2.5)
print("\nband-passed comparison (single-zero band [10, 27.5] in log-X frequency,")
print("cubic detrend, core 3/4 of X in [1e4,1e7]; parameter-free model):")
bp_corr = {}
for Q in QS:
    by = bandpass_log(resB[Q]["lhs"][BP_MASK] / X_DENSE[BP_MASK] ** 2.5)
    corr = np.corrcoef(by[COREB], bm[COREB])[0, 1]
    ratio = np.std(by[COREB]) / np.std(bm[COREB])
    bp_corr[Q] = (corr, ratio)
    print(f"  Q={Q:4d}: corr = {corr:.4f}, amplitude ratio = {ratio:.4f}")

# --- smooth floor and crossover ---
A_env = 4.0 * float(np.sum(np.abs(w)))     # envelope of the single-zero layer
print(f"\nsingle-zero layer envelope amplitude 4*sum_gam>0 |w| = {A_env:.4e} "
      f"(x X^{{5/2}})")
print("smooth X^2-scale floor c(Q) = LHS/X^2 at X = 1e4 (zero-layer pollution "
      "~ +-0.1), Mertens law c(Q) = c0 + M(Q)/2, and predicted floor/layer "
      "crossover X* = (|c|/A)^2:")
for Q in QS:
    i4 = np.searchsorted(X_DENSE, 10**4)
    cQ = resB[Q]["lhs"][i4] / 1e8
    MQ = int(np.sum(MU[1 : Q + 1]))
    print(f"  Q={Q:4d}: c(Q) = {cQ:+.3f}, M(Q) = {MQ:+3d}, "
          f"c(Q) - M(Q)/2 = {cQ - MQ/2:+.3f}, X* ~ {(abs(cQ)/A_env)**2:.1e}")
print("  [mechanism: mean(psi^sharp_Q(x) - x) = -M(Q)/2, from "
      "sum_{d|q} d mu(q/d) = phi(q) and mean{x/d} = 1/2;")
print("   the Q-dependent block constant flagged as a scheme artifact by the "
      "catchup audit is exactly Mertens/2.]")

print(f"\n{'Q':>4} {'X':>10} {'LHS':>13} {'RHS':>13} {'slack=RHS/|LHS|':>16}")
slack_stats = {}
for Q in QS:
    lhs, rhs = resB[Q]["lhs"], resB[Q]["rhs"]
    for x in X_TAB:
        i = np.searchsorted(X_DENSE, x)
        print(f"{Q:>4} {x:>10.0e} {lhs[i]:>13.4e} {rhs[i]:>13.4e} "
              f"{rhs[i]/abs(lhs[i]):>16.1f}")
    sl = rhs[mask_cmp] / np.maximum(np.abs(lhs[mask_cmp]), 1e-300)
    slack_stats[Q] = (float(np.min(sl)), float(np.median(sl)), float(np.max(sl)))
    print(f"      slack over X in [1e4,1e7]: min = {slack_stats[Q][0]:.0f}, "
          f"median = {slack_stats[Q][1]:.0f}, max = {slack_stats[Q][2]:.0f}")

# LHS exponent (envelope): fit log|LHS| where |LHS| above noise
print("\nLHS envelope exponent (running max of |LHS|, X >= 1e4):")
for Q in QS:
    env = np.maximum.accumulate(np.abs(resB[Q]["lhs"]))
    sl, se, _ = fit_exponent(X_DENSE[mask_cmp], env[mask_cmp])
    print(f"  Q={Q:4d}: exponent = {sl:.4f} +- {se:.4f}   (Prop 6 sharpness "
          f"claim: 5/2; wasteful-bound alternative: 3/2)")

# ---------------------------------------------------------------- figure
tic("figure ...")
fig, ax = plt.subplots(2, 2, figsize=(13.5, 9))
colors = plt.cm.viridis(np.linspace(0.0, 0.85, len(QS)))

a = ax[0, 0]
for Q, c in zip(QS, colors):
    a.semilogx(X_DENSE, resA[Q]["D_dense"] / np.sqrt(X_DENSE), color=c,
               lw=1.2, label=f"Q = {Q}")
a.axhline(1.0, color="gray", lw=0.8, ls="--")
a.set_xlabel("X")
a.set_ylabel(r"$D_Q(X)/\sqrt{X}$")
a.set_title(r"A: interval discrepancy, RH scale — flat at every $Q$"
            "\n" r"(exponents $0.49$–$0.50$ for all $Q$; only the $O_Q(1)$ constant moves)")
a.legend(fontsize=8, ncol=2)
a.set_xlim(1e3, N)

a = ax[0, 1]
for Q, c in zip(QS, colors):
    a.loglog(X_DENSE, np.abs(resB[Q]["lhs"]), color=c, lw=0.9,
             label=f"|LHS|, Q={Q}")
    a.loglog(X_DENSE, resB[Q]["rhs"], color=c, lw=1.4, ls="--")
a.loglog(X_DENSE, A_env * X_DENSE.astype(float) ** 2.5, color="crimson", lw=0.9,
         ls=":", label=rf"single-zero envelope ${A_env:.1e}\,X^{{5/2}}$")
a.loglog(X_DENSE, 2.0 * X_DENSE.astype(float) ** 2, color="gray", lw=0.9,
         ls=":", label=r"$2\,X^{2}$ (smooth floor scale)")
a.set_xlabel("X")
a.set_ylabel(r"$|G_1-[\sharp\sharp]_Q|$ (solid), bound (dashed)")
a.set_title("B: Prop 6 — bound holds everywhere (slack $10^2$–$10^7$);\n"
            r"error sits on the smooth $X^2$ floor until $X^*\sim10^6$")
a.legend(fontsize=7, ncol=2)

a = ax[1, 0]
by30 = bandpass_log(resB[30]["lhs"][BP_MASK] / X_DENSE[BP_MASK] ** 2.5)
a.semilogx(X_DENSE[BP_MASK][COREB], by30[COREB],
           color="C0", lw=1.0, label=r"LHS$/X^{5/2}$, band-passed (Q=30)")
a.semilogx(X_DENSE[BP_MASK][COREB], bm[COREB],
           color="crimson", lw=0.9, ls="--",
           label=r"$-4\,\mathrm{Re}\sum_{\gamma>0}\frac{X^{\rho+2}}{\rho(\rho+1)(\rho+2)}/X^{5/2}$, band-passed")
a.axhline(0, color="gray", lw=0.5)
a.set_xlabel("X")
a.set_ylabel(r"error$/X^{5/2}$, band $[10,27.5]$")
a.set_title(f"B': oscillatory part of the Prop-6 error = single-zero layer\n"
            f"(pole×zero mixed block, Thm E2; corr = {bp_corr[30][0]:.3f}, "
            f"ratio = {bp_corr[30][1]:.3f}, no fit)")
a.legend(fontsize=8)

a = ax[1, 1]
cols2 = plt.cm.plasma(np.linspace(0.0, 0.8, len(BOHR_MODULI)))
for q, c in zip(BOHR_MODULI, cols2):
    a.semilogx(X_DENSE, resC[q] / np.sqrt(X_DENSE.astype(float)),
               color=c, lw=1.1, label=f"q = {q} ($\\varphi$ = {PHI[q]})")
a.semilogx(X_DENSE, resA[BOHR_Q]["D_dense"] / np.sqrt(X_DENSE), color="k",
           lw=1.0, ls="--", label="q = 1 (intervals)")
a.set_xlabel("X")
a.set_ylabel(r"$D_{\mathcal{B}_q}(X)/\sqrt{X}$")
a.set_title("C: Bohr cuts at Q=30 (Prop 3 / GRH face) — $\\sqrt{X}$-flat at every $q$;\n"
            r"constants 0.82–0.98, nearly $q$-independent (NOT $\propto1/\sqrt{\varphi(q)}$)")
a.legend(fontsize=8, ncol=2)
a.set_xlim(1e4, N)

fig.suptitle("exp32: the Q-filtration face of LENS_REGULARITY Thm 1 / Prop 6 "
             "(open interface #2)", y=1.0)
fig.tight_layout()
FIG.mkdir(exist_ok=True)
fig.savefig(FIG / "exp32_lens_numerics.png", dpi=140)
tic("saved figures/exp32_lens_numerics.png")
print(f"\ntotal wall time {time.time()-t0:.0f}s")
