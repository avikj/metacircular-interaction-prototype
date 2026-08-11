"""Experiment 16: DIRECT computation of the additive energy of zeta-zero ordinates.

Two objects, both four-fold sums over zeros, both "energies" in the sense of
additive combinatorics:

(a) UNWEIGHTED near-diagonal additive energy
        E(delta, T0) = #{(i,j,k,l) : gamma's <= T0,
                         |gamma_i + gamma_j - gamma_k - gamma_l| < delta}
    over ORDERED quadruples.  This is the sigma = 1/2 (all zeros, on RH)
    analogue of the N*(sigma, T) energy of Tao--Trudgian--Yang
    (arXiv:2501.16779), which counts the same quadruples but restricted to
    hypothetical zeros with Re(rho) >= sigma > 1/2.

(b) WEIGHTED energy of APPENDIX_D (Theorem D''):
        E_W(delta) = sum_{|d_1234| <= delta} |W_12 W_34|,
        W_12 = Gamma(rho_1)Gamma(rho_2)/Gamma(rho_1+rho_2+2),
    with signed ordinates.  Opposite-sign pairs have exponentially small
    weight and are dropped; same-sign pairs have |W| ~ c (g+g')^{-5/2}.  With
    pair-sum density f(s) ~ s log^2 s, the DIAGONAL 2 sum|W|^2 converges like
    int f w^2 ~ s^{-4} log^2 s (tail at 300: <2%), while the OFF-DIAGONAL at
    fixed delta converges more slowly, like delta * int f^2 w^2 ~ s^{-3}
    log^4 s -- so we compute at several cutoffs and extrapolate the tail with
    that model.  The (--,--) mirror class duplicates the (+,+) class and
    cross-class quadruples never come within delta < 2*gamma_1 of the
    diagonal, so off/diagonal ratios are computed inside the (+,+) class.

Method for (a): form all pair sums s = gamma_i + gamma_j (i < j) for zeros up
to T0 (up to ~5.1e7 values for T0 = 10^4, ~410 MB), sort once, and count
near-collisions with vectorized sliding windows (searchsorted).  Diagonal
sums 2*gamma_i are kept separate so the big array needs no weight vector:

    E = 4*C(A,A) + 4*C(A,D) + C(D,D),

A = {i<j sums}, D = {2 gamma_i}, C(X,Y) = #{(x,y) in X x Y : |x-y| < delta}
(C(A,A) includes x = x, matching the identity quadruples in E).

Poisson references:
  * crude (uniform density, as specified):  E_P = P^2 * 2*delta / R,
    P = n^2 ordered pairs, R = range of the pair sums;
  * density-corrected (inhomogeneous Poisson): E_dens = 2*delta * int f(s)^2 ds
    with f the empirical pair-sum density (histogram, bin = 2), compared to
    E_offdiag = E - (2 n^2 - n)  [the 2n^2 - n identity quadruples
    {k,l} = {i,j} sit at delta = 0 for every delta].
Deviation of E_offdiag / E_dens from 1 measures genuine additive structure
beyond the density profile.
"""
import time
import numpy as np
from scipy.special import loggamma
import matplotlib
matplotlib.use("Agg")
import matplotlib.pyplot as plt
from pathlib import Path
from pairfield import load_zeros

FIG = Path(__file__).resolve().parent.parent / "figures"
DELTAS = np.array([0.01, 0.1, 1.0])
T0S = [2000, 5000, 10000]
SMAX = 300.0          # pair-sum cutoff for the weighted energy
DSTAR = 1.0 / np.log(1e6)   # resolution of Theorem D'' at X = 10^6

# Okabe-Ito, fixed categorical order
COL = {2000: "#0072B2", 5000: "#E69F00", 10000: "#009E73"}


def pair_sums(g):
    """All sums g[i] + g[j], i < j, as one flat array (no weights needed)."""
    n = len(g)
    s = np.empty(n * (n - 1) // 2)
    ofs = 0
    for i in range(n - 1):
        m = n - 1 - i
        s[ofs:ofs + m] = g[i] + g[i + 1:]
        ofs += m
    return s


def window_count(sorted_x, queries, delta, chunk=4_000_000):
    """#{(x, q) in sorted_x x queries : |x - q| < delta}, exact, chunked."""
    tot = 0
    for a in range(0, len(queries), chunk):
        q = queries[a:a + chunk]
        tot += int((np.searchsorted(sorted_x, q + delta, side="right")
                    - np.searchsorted(sorted_x, q - delta, side="left")).sum())
    return tot


def unweighted(g_all):
    print("=" * 78)
    print("(a) UNWEIGHTED near-diagonal additive energy E(delta, T0)")
    print("=" * 78)
    results = {}
    for T0 in T0S:
        t0 = time.time()
        g = g_all[g_all <= T0]
        n = len(g)
        A = pair_sums(g)
        A.sort(kind="quicksort")
        D = np.sort(2.0 * g)
        smin, smax = A[0], A[-1]
        R = smax - smin
        P = n * n                      # ordered pairs
        triv = 2 * n * n - n           # identity quadruples {k,l} = {i,j}

        # density of the ordered-pair-sum multiset (A twice, D once), bin = 2
        h = 2.0
        bins = np.arange(smin - h, smax + 2 * h, h)
        cA, _ = np.histogram(A, bins=bins)
        cD, _ = np.histogram(D, bins=bins)
        c = 2.0 * cA + cD
        int_f2 = float(np.sum(c * c)) / h   # int f(s)^2 ds

        rows = []
        for d in DELTAS:
            E = (4 * window_count(A, A, d)
                 + 4 * window_count(A, D, d)
                 + window_count(D, D, d))
            E_off = E - triv
            E_pois = P * P * 2 * d / R
            E_dens = 2 * d * int_f2
            rows.append((d, E, E_off, E_pois, E / E_pois, E_off / E_dens))
        del A

        # scaling exponent from the off-diagonal energy
        ld = np.log([r[0] for r in rows])
        le = np.log([float(r[2]) for r in rows])
        slope = np.polyfit(ld, le, 1)[0]
        results[T0] = dict(n=n, P=P, R=R, rows=rows, slope=slope,
                           triv=triv, int_f2=int_f2)

        print(f"\nT0 = {T0}:  n = {n} zeros, P = n^2 = {P:.4g} ordered pairs, "
              f"sum range R = {R:.1f}   [{time.time()-t0:.1f}s]")
        print(f"  identity-quadruple floor 2n^2 - n = {triv}")
        print(f"  {'delta':>7} {'E':>14} {'E_offdiag':>14} {'E_Poisson':>12} "
              f"{'E/E_Poisson':>12} {'E_off/E_dens':>13}")
        for d, E, E_off, E_p, r1, r2 in rows:
            print(f"  {d:7.2f} {E:14d} {E_off:14d} {E_p:12.4g} "
                  f"{r1:12.4f} {r2:13.4f}")
        print(f"  scaling: log E_offdiag vs log delta slope = {slope:.4f} "
              f"(Poisson: 1)")
    return results


def weighted_class(g_all, smax):
    """(+,+) ordered pairs with sum <= smax: sorted sums s, weights |W|."""
    g = g_all[g_all <= smax - g_all[0]]
    rho = 0.5 + 1j * g
    LG = loggamma(rho)
    Sfull = g[:, None] + g[None, :]
    ii, jj = np.nonzero(Sfull <= smax)
    s = Sfull[ii, jj]
    logW = LG[ii] + LG[jj] - loggamma(rho[ii] + rho[jj] + 2)
    w = np.exp(np.real(logW))           # |W| for each ordered pair
    order = np.argsort(s)
    return s[order], w[order], ii[order], jj[order], len(g)


def weighted(g_all):
    print("\n" + "=" * 78)
    print("(b) WEIGHTED energy E_W(delta) of APPENDIX_D, (+,+) class")
    print("=" * 78)
    cutoffs = [150.0, 200.0, 250.0, SMAX]
    out = {}
    for smax in cutoffs:
        s, w, ii, jj, nz = weighted_class(g_all, smax)
        cw = np.concatenate([[0.0], np.cumsum(w)])

        def EW(delta, s=s, w=w, cw=cw):
            lo = np.searchsorted(s, s - delta, side="left")
            hi = np.searchsorted(s, s + delta, side="right")
            return float(np.sum(w * (cw[hi] - cw[lo])))

        # diagonal of D.4: (g3,g4) = (g1,g2) or (g2,g1); coincide when g1 = g2
        sum_w2 = float(np.sum(w * w))
        diag = 2 * sum_w2 - float(np.sum(w[ii == jj] ** 2))
        e_star = EW(DSTAR)
        out[smax] = dict(npairs=len(s), nz=nz, diag=diag, sum_w2=sum_w2,
                         e_star=e_star, off=e_star - diag, EW=EW,
                         ratio=(e_star - diag) / diag)

    print(f"\n  delta* = 1/log(1e6) = {DSTAR:.5f}")
    print(f"  {'cutoff':>7} {'pairs':>6} {'zeros':>6} {'sum|W|^2':>12} "
          f"{'diagonal':>12} {'off-diag':>12} {'off/diag':>9}")
    for smax in cutoffs:
        o = out[smax]
        print(f"  {smax:7.0f} {o['npairs']:6d} {o['nz']:6d} "
              f"{o['sum_w2']:12.4e} {o['diag']:12.4e} {o['off']:12.4e} "
              f"{o['ratio']:9.4f}")

    # tail extrapolation: off(inf) - off(s0) ~ K * I(s0), I = s^{-2} log^4 s / 2
    # (from off ~ delta*int f^2 w^2, f ~ s log^2 s, w ~ s^{-5/2});
    # diag(inf) - diag(s0) ~ K2 * J(s0), J = s^{-3} log^2 s / 3.
    I = lambda x: np.log(x) ** 4 / (2 * x ** 2)
    J = lambda x: np.log(x) ** 2 / (3 * x ** 3)
    a, b = cutoffs[-2], cutoffs[-1]
    K = (out[b]["off"] - out[a]["off"]) / (I(a) - I(b))
    K2 = (out[b]["diag"] - out[a]["diag"]) / (J(a) - J(b))
    off_inf = out[b]["off"] + K * I(b)
    diag_inf = out[b]["diag"] + K2 * J(b)
    ratio_inf = off_inf / diag_inf
    print(f"\n  tail-extrapolated (cutoff -> inf): diagonal = {diag_inf:.4e}, "
          f"off-diag = {off_inf:.4e}, OFF/DIAG = {ratio_inf:.4f}")

    # delta sweep on the full cutoff, for scaling + figure
    o = out[SMAX]
    dgrid = np.geomspace(1e-3, 2.0, 40)
    ratios = np.array([(o["EW"](d) - o["diag"]) / o["diag"] for d in dgrid])
    small = dgrid <= 0.12
    c_lin = float(np.sum(ratios[small] * dgrid[small])
                  / np.sum(dgrid[small] ** 2))
    print(f"  small-delta law (delta <= 0.12, cutoff {SMAX:.0f}): "
          f"off/diag ~ {c_lin:.2f} * delta  -> vanishes linearly as "
          f"delta = 1/L -> 0")

    # weighted-Poisson check: off_pred(delta) = 2 delta int f_w(s)^2 ds,
    # with the self + swap (diagonal) pairs removed from the same-bin count
    s, w = o["EW"].__defaults__[0], o["EW"].__defaults__[1]
    h = 2.0
    bins = np.arange(s[0] - h, s[-1] + 2 * h, h)
    bw, _ = np.histogram(s, bins=bins, weights=w)
    int_fw2_off = (float(np.sum(bw * bw)) - o["diag"]) / h
    print(f"  weighted-Poisson prediction 2*delta*int f_w^2 (diag removed): "
          f"off/pred at delta* = {o['off'] / (2 * DSTAR * int_fw2_off):.3f}")

    ew_row = [(d, o["EW"](d), (o["EW"](d) - o["diag"]) / o["diag"])
              for d in (0.01, DSTAR, 0.1, 1.0)]
    print(f"\n  {'delta':>9} {'E_W':>13} {'off/diag':>10}   (cutoff "
          f"{SMAX:.0f}, un-extrapolated)")
    for d, e, r in ew_row:
        print(f"  {d:9.5f} {e:13.6e} {r:10.4f}")
    out["ratio_inf"] = ratio_inf
    out["c_lin"] = c_lin
    return out, dgrid, ratios


def figure(res, dgrid, ratios):
    fig, ax = plt.subplots(1, 2, figsize=(12.5, 4.6))
    dd = np.geomspace(0.005, 2.0, 50)
    for T0 in T0S:
        r = res[T0]
        d = [row[0] for row in r["rows"]]
        eo = [row[2] for row in r["rows"]]
        ax[0].loglog(d, eo, "o-", lw=2, ms=8, color=COL[T0],
                     label=f"$T_0={T0}$  (slope {r['slope']:.3f})")
        ax[0].loglog(dd, 2 * dd * r["int_f2"], "--", lw=1.2, color=COL[T0],
                     alpha=0.55)
    ax[0].loglog([], [], "--", lw=1.2, color="0.4",
                 label=r"Poisson $2\delta\int f^2$")
    ax[0].set_xlabel(r"$\delta$")
    ax[0].set_ylabel(r"$E_{\rm offdiag}(\delta, T_0)$")
    ax[0].set_title("Unweighted additive energy vs Poisson")
    ax[0].legend(fontsize=8, frameon=False)
    ax[0].grid(True, which="both", lw=0.3, alpha=0.3)

    ax[1].loglog(dgrid, ratios, "-", lw=2, color="#0072B2")
    ax[1].axvline(DSTAR, color="0.35", lw=1, ls=":")
    ax[1].axhline(1.0, color="0.35", lw=0.8, ls="--")
    i0 = np.argmin(np.abs(dgrid - DSTAR))
    ax[1].annotate(rf"$\delta_*=1/\log 10^6$: ratio = {ratios[i0]:.3f}",
                   xy=(DSTAR, ratios[i0]), xytext=(0.15, 0.25),
                   textcoords="axes fraction", fontsize=9,
                   arrowprops=dict(arrowstyle="->", lw=0.8, color="0.3"))
    ax[1].set_xlabel(r"$\delta$")
    ax[1].set_ylabel(r"$[E_W(\delta) - \mathrm{diag}]\,/\,\mathrm{diag}$")
    ax[1].set_title(r"Weighted energy of Appendix D: off-diagonal/diagonal")
    ax[1].grid(True, which="both", lw=0.3, alpha=0.3)
    fig.tight_layout()
    fig.savefig(FIG / "exp16_energy.png", dpi=140)
    print("\nsaved figures/exp16_energy.png")


def main():
    g = load_zeros()
    res = unweighted(g)
    out, dgrid, ratios = weighted(g)
    figure(res, dgrid, ratios)

    print("\n" + "=" * 78)
    print("SUMMARY")
    print("=" * 78)
    for T0 in T0S:
        r = res[T0]["rows"]
        print(f"T0={T0:5d}: E/E_Poisson at delta=0.01,0.1,1 = "
              + ", ".join(f"{row[4]:.3f}" for row in r)
              + f";  density-corrected = "
              + ", ".join(f"{row[5]:.3f}" for row in r)
              + f";  slope = {res[T0]['slope']:.3f}")
    o = out[SMAX]
    print(f"Weighted (Appendix D), delta* = 1/log(1e6): off-diag/diag = "
          f"{o['ratio']:.4f} (cutoff {SMAX:.0f}), "
          f"{out['ratio_inf']:.4f} (tail-extrapolated); "
          f"off/diag ~ {out['c_lin']:.2f}*delta as delta -> 0")


if __name__ == "__main__":
    main()
