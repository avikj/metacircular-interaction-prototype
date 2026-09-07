"""Experiment 15: the divisor pair field -- the exactly solvable analog.

Replace Lambda(n) by d(n) (number of divisors). The pair field K(w,dd) =
d(w-dd) d(w+dd) has the same rank-one tensor structure as the prime pair
field, but here BOTH marginals are theorems (Ingham 1927), governed by the
SAME local object

    sigma_{-1}(k) = sum_{e | k} 1/e ,

playing the role the singular series S(k) plays for Lambda (exp4):

  difference marginal:  D_h(X) = sum_{n<=X} d(n)d(n+h)
                               ~ (6/pi^2) sigma_{-1}(h) X log^2 X      (Ingham)
  sum marginal:         r(N)   = sum_{m+n=N} d(m)d(n)
                               ~ (6/pi^2) sigma_{-1}(N) N log^2 N      (Ingham)

with full main term X P_2(log X; h) (Estermann) and error term
E(X;h) << X^{2/3+eps} (Deshouillers-Iwaniec via Kuznetsov/Maass spectrum;
true size X^{1/2+o(1)} in mean square, Motohashi 1994).

This script verifies:
  (i)   both marginals against the sigma_{-1} prediction -- the 'one local
        object, two marginals' scatter of exp4, now with proven main terms;
  (ii)  the log^2 X growth: quadratic-in-log fit recovering the leading
        coefficient (6/pi^2) sigma_{-1};
  (iii) the difference-marginal error term E(X;h): empirical exponent vs the
        classical proven envelope X^{2/3} and the conjectural X^{1/2}.

Output: figures/exp15_divisor.png + printed diagnostics.
"""
import sys
import numpy as np
import matplotlib
matplotlib.use("Agg")
import matplotlib.pyplot as plt
from pathlib import Path

HERE = Path(__file__).resolve().parent
sys.path.insert(0, str(HERE))
from pairfield import additive_convolution, autocorrelation

FIG = HERE.parent / "figures"
SIX_PI2 = 6.0 / np.pi ** 2

N = 2_000_000


def sieve_divisor(n):
    """d(k) for 0 <= k <= n by direct divisor sieve."""
    d = np.zeros(n + 1)
    for k in range(1, n + 1):
        d[k::k] += 1.0
    return d


def sieve_sigma_m1(n):
    """sigma_{-1}(k) = sum_{e|k} 1/e for 0 <= k <= n."""
    s = np.zeros(n + 1)
    for k in range(1, n + 1):
        s[k::k] += 1.0 / k
    return s


def slope_origin(x, y):
    return float(np.dot(x, y) / np.dot(x, x))


def main():
    print(f"sieving d(n) and sigma_-1(n) to N = {N} ...")
    d = sieve_divisor(N)
    sig = sieve_sigma_m1(N)

    print("FFT marginals ...")
    r = additive_convolution(d)        # r[M] = sum_{m+n=M} d(m)d(n), M <= 2N
    c = autocorrelation(d)             # c[h] = sum_{n<=N-h} d(n)d(n+h)

    # ------------------------------------------------------------------ (i)
    Ns = np.arange(200_000, N + 1)                       # sum marginal sample
    y_sum = r[Ns] / (Ns * np.log(Ns) ** 2)
    pred_sum = SIX_PI2 * sig[Ns]

    hs = np.arange(1, 3001)                              # difference marginal
    y_diff = c[hs] / ((N - hs) * np.log(N - hs) ** 2.0)
    pred_diff = SIX_PI2 * sig[hs]

    ratio_sum = y_sum / pred_sum
    ratio_diff = y_diff / pred_diff
    sl_sum = slope_origin(pred_sum, y_sum)
    sl_diff = slope_origin(pred_diff, y_diff)
    corr_sum = np.corrcoef(np.log(y_sum), np.log(pred_sum))[0, 1]
    corr_diff = np.corrcoef(np.log(y_diff), np.log(pred_diff))[0, 1]

    print("\n(i) one local object, two marginals  [leading term only]")
    print(f"  sum  marginal: mean ratio to (6/pi^2)sigma_-1(N) N log^2 N = "
          f"{np.mean(ratio_sum):.4f}  (corr of logs {corr_sum:.4f})")
    print(f"  diff marginal: mean ratio to (6/pi^2)sigma_-1(h) X log^2 X = "
          f"{np.mean(ratio_diff):.4f}  (corr of logs {corr_diff:.4f})")
    print(f"  slope through origin, sum:  {sl_sum:.4f} x (6/pi^2)sigma_-1")
    print(f"  slope through origin, diff: {sl_diff:.4f} x (6/pi^2)sigma_-1")
    print(f"  slope agreement diff/sum:   {sl_diff/sl_sum:.4f}")
    print("  (offsets from 1 are the O(1/log) secondary terms of the PROVEN")
    print("   Estermann polynomial -- see (ii); they shrink like 1/log X.)")

    # ------------------------------------------------------------------ (ii)
    h_list = [1, 2, 3, 4, 6, 12]
    Xgrid = np.unique(np.round(np.logspace(4, np.log10(N - 20), 1500))
                      .astype(np.int64))
    fits = {}
    print("\n(ii) log^2 growth: fit D_h(X)/X = a2 log^2 X + a1 log X + a0")
    print(f"  {'h':>3} {'a2 fitted':>10} {'(6/pi^2)sig':>12} {'ratio':>7} "
          f"{'free exp p':>10}")
    for h in h_list:
        prod = d[1:N - h + 1] * d[1 + h:N + 1]
        C = np.cumsum(prod)                    # C[j] = D_h(j+1)
        Dh = C[Xgrid - 1]
        L = np.log(Xgrid.astype(float))
        A = np.column_stack([L ** 2, L, np.ones_like(L)])
        coef, *_ = np.linalg.lstsq(A, Dh / Xgrid, rcond=None)
        a2, a1, a0 = coef
        target = SIX_PI2 * sig[h]
        # free-exponent fit  D/X ~ const * log^p X  (contaminated by lower
        # order terms; the coefficient fit above is the real verification)
        p = np.polyfit(np.log(L), np.log(Dh / Xgrid), 1)[0]
        fits[h] = dict(Dh=Dh, L=L, a2=a2, a1=a1, a0=a0, p=p)
        print(f"  {h:>3} {a2:>10.4f} {target:>12.4f} {a2/target:>7.4f} "
              f"{p:>10.3f}")

    mean_a2_ratio = np.mean([fits[h]['a2'] / (SIX_PI2 * sig[h])
                             for h in h_list])
    print(f"  mean a2 / [(6/pi^2) sigma_-1(h)] over h: {mean_a2_ratio:.4f}")

    # ----------------------------------------------------------------- (iii)
    # Error term: FIX the proven a2 = (6/pi^2) sigma_-1(h); fit only the two
    # lower Estermann coefficients a1, a0; the residual is E(X;h).
    print("\n(iii) error term E(X;h) = D_h(X) - X(a2 log^2 X + a1 log X + a0),")
    print("      a2 fixed at proven value; a1,a0 fitted. RMS in log-windows,")
    print("      exponent theta from log RMS ~ theta log X:")
    err_expo = {}
    err_windows = {}
    for h in h_list:
        f = fits[h]
        L, Dh = f['L'], f['Dh']
        a2 = SIX_PI2 * sig[h]
        A = np.column_stack([L, np.ones_like(L)])
        coef, *_ = np.linalg.lstsq(A, Dh / Xgrid - a2 * L ** 2, rcond=None)
        a1, a0 = coef
        E = Dh - Xgrid * (a2 * L ** 2 + a1 * L + a0)
        # RMS in ~24 log-spaced windows over X >= 1e5
        edges = np.logspace(5, np.log10(Xgrid[-1]), 25)
        xc, rms = [], []
        for lo, hi in zip(edges[:-1], edges[1:]):
            m = (Xgrid >= lo) & (Xgrid < hi)
            if m.sum() >= 5:
                xc.append(np.sqrt(lo * hi))
                rms.append(np.sqrt(np.mean(E[m] ** 2)))
        xc, rms = np.array(xc), np.array(rms)
        theta = np.polyfit(np.log(xc), np.log(rms), 1)[0]
        err_expo[h] = theta
        err_windows[h] = (xc, rms)
        print(f"  h={h:>2}: theta = {theta:.3f}   "
              f"(RMS at X=2e6: {rms[-1]:.0f}; X^(1/2)=1414, X^(2/3)=15874)")
    mean_theta = np.mean(list(err_expo.values()))
    print(f"  mean empirical exponent: {mean_theta:.3f}  "
          f"[proven envelope 2/3 = 0.667; conjectural true size 1/2]")

    # sum-marginal quadratic fit (global, sigma_-1(N)-normalized)
    Lb = np.log(Ns.astype(float))
    A = np.column_stack([Lb ** 2, Lb, np.ones_like(Lb)])
    coefb, *_ = np.linalg.lstsq(A, r[Ns] / (Ns * sig[Ns]), rcond=None)
    b2 = coefb[0]
    print(f"\n  sum-marginal fit r(N)/(N sigma_-1(N)) = b2 log^2 N + ... : "
          f"b2 = {b2:.4f}, b2/(6/pi^2) = {b2/SIX_PI2:.4f}")

    # ------------------------------------------------------------------ figure
    fig, ax = plt.subplots(2, 2, figsize=(12.5, 9.2))

    rng = np.random.default_rng(1)
    sub = rng.choice(len(Ns), 4000, replace=False)
    ax[0, 0].scatter(sig[Ns][sub], y_sum[sub], s=2, alpha=0.3,
                     label=r"sum marginal  $r(N)/(N\log^2 N)$")
    ax[0, 0].scatter(sig[hs], y_diff, s=2, alpha=0.3, color="crimson",
                     label=r"difference marginal  $D_h(X)/(X\log^2 X)$")
    lim = [0.95, 2.6]
    xx = np.linspace(*lim, 10)
    ax[0, 0].plot(xx, SIX_PI2 * xx, "k--", lw=1,
                  label=r"$y=(6/\pi^2)\,x$  (Ingham, PROVEN)")
    ax[0, 0].set_xlim(lim)
    ax[0, 0].set_xlabel(r"$\sigma_{-1}(k)$")
    ax[0, 0].set_ylabel("normalized marginal")
    ax[0, 0].legend(fontsize=8)
    ax[0, 0].set_title("One local object, two marginals — both are theorems")

    ax[0, 1].hist(ratio_sum, bins=120, range=(0.95, 1.45), alpha=0.6,
                  density=True,
                  label=f"sum: mean ratio {np.mean(ratio_sum):.4f}")
    ax[0, 1].hist(ratio_diff, bins=120, range=(0.95, 1.45), alpha=0.6,
                  density=True,
                  label=f"diff: mean ratio {np.mean(ratio_diff):.4f}")
    ax[0, 1].axvline(1.0, color="k", lw=1, ls="--")
    ax[0, 1].set_xlabel(r"marginal / $(6/\pi^2)\sigma_{-1}\cdot$(leading term)")
    ax[0, 1].legend(fontsize=8)
    ax[0, 1].set_title(r"Ratios (offset $=$ Estermann's $O(1/\log)$ terms)")

    for h in h_list:
        f = fits[h]
        ax[1, 0].plot(f['L'], f['Dh'] / (Xgrid * SIX_PI2 * sig[h]),
                      lw=1, label=f"h={h}  (a2 ratio "
                      f"{f['a2']/(SIX_PI2*sig[h]):.3f})")
    Lx = np.linspace(9.2, np.log(N), 50)
    ax[1, 0].plot(Lx, Lx ** 2, "k--", lw=1.2, label=r"$\log^2 X$")
    ax[1, 0].set_xlabel(r"$\log X$")
    ax[1, 0].set_ylabel(r"$D_h(X)\,/\,[(6/\pi^2)\sigma_{-1}(h)X]$")
    ax[1, 0].legend(fontsize=7)
    ax[1, 0].set_title(r"$\log^2$ growth, coefficient $(6/\pi^2)\sigma_{-1}(h)$")

    for h in h_list:
        xc, rms = err_windows[h]
        ax[1, 1].loglog(xc, rms, lw=1, marker=".", ms=3,
                        label=f"h={h}  " + r"$\theta$=" + f"{err_expo[h]:.2f}")
    xr = np.array([1e5, 2e6])
    ax[1, 1].loglog(xr, 1.5 * xr ** (2 / 3), "k--", lw=1.2,
                    label=r"$X^{2/3}$ (proven, D–I)")
    ax[1, 1].loglog(xr, 1.5 * xr ** 0.5, "k:", lw=1.2,
                    label=r"$X^{1/2}$ (true size, Motohashi)")
    ax[1, 1].set_xlabel(r"$X$")
    ax[1, 1].set_ylabel(r"RMS $|E(X;h)|$ in window")
    ax[1, 1].legend(fontsize=7, ncol=2)
    ax[1, 1].set_title(f"Error term: mean exponent {mean_theta:.3f}")

    fig.suptitle("exp15: the divisor pair field — the solvable analog "
                 r"($a_n = d(n)$, local object $\sigma_{-1}$)", y=0.995)
    fig.tight_layout(rect=(0, 0, 1, 0.97))
    fig.savefig(FIG / "exp15_divisor.png", dpi=140)
    print("\nsaved figures/exp15_divisor.png")


if __name__ == "__main__":
    main()
