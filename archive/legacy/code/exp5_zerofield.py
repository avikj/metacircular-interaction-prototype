"""Experiment 5: The zero pair field mirrors the prime pair field.

(a) Landau's formula: the DIFFERENCE-type resolvent of the zeros recovers primes:
      -(2 pi / T) sqrt(x) sum_{0<gamma<=T} cos(gamma log x)  ->  Lambda(x).
    (zeros -> primes: inverse of the explicit formula bridge)

(b) Difference spectrum of zeros: nearest-neighbor spacings of unfolded gamma
    follow GUE (Montgomery/Odlyzko) -- the zero field's difference marginal is
    RIGID.

(c) Sum spectrum of zeros: spacings of the multiset {gamma_i + gamma_j} in a
    window are POISSON -- the zero field's sum marginal is structureless.

So on the zero side the rigidity is in the DIFFERENCES, while on the prime side
(Exp 1) the injectivity is in the SUMS: the two pair fields carry their
structure in transverse coordinates.
"""
import numpy as np
import matplotlib
matplotlib.use("Agg")
import matplotlib.pyplot as plt
from pathlib import Path
from pairfield import load_zeros, sieve_lambda

FIG = Path(__file__).resolve().parent.parent / "figures"

def unfold(g):
    """Unfold zeros: N(gamma) ~ (gamma/2pi) log(gamma/2pi e) + 7/8."""
    return (g / (2 * np.pi)) * np.log(g / (2 * np.pi * np.e)) + 7.0 / 8

def main():
    gam = load_zeros()
    T = gam[-1]
    fig, ax = plt.subplots(1, 3, figsize=(16, 4.4))

    # (a) Landau spikes: fine u-grid resolving spike width 2 pi / T_a
    Ka = 20000
    ga = gam[:Ka]
    Ta = ga[-1]
    u = np.linspace(np.log(1.5), np.log(32), 400000)
    xs = np.exp(u)
    L = np.zeros_like(u)
    for chunk in np.array_split(ga, 200):
        L += np.cos(np.outer(chunk, u)).sum(axis=0)
    rec = -(2 * np.pi / Ta) * np.sqrt(xs) * L
    ax[0].plot(xs, rec, lw=0.7)
    lam = sieve_lambda(32)
    pp = [n for n in range(2, 33) if lam[n] > 0]
    ax[0].scatter(pp, [lam[n] for n in pp], color="crimson", s=18, zorder=3,
                  label=r"$\Lambda(n)$ at prime powers")
    ax[0].set_title("Landau resolvent of zeros recovers primes\n"
                    "-(2pi/T) sqrt(x) sum_gamma cos(gamma log x)")
    ax[0].set_xlabel("x"); ax[0].legend(fontsize=8)

    # (b) GUE spacings of unfolded zeros
    u = unfold(gam)
    s = np.diff(u)
    ax[1].hist(s, bins=80, range=(0, 3.2), density=True, alpha=0.6, label="zeta zero spacings")
    x = np.linspace(0, 3.2, 300)
    wigner = (32 / np.pi ** 2) * x ** 2 * np.exp(-4 * x ** 2 / np.pi)
    ax[1].plot(x, wigner, "k-", lw=1.2, label="GUE (Wigner surmise)")
    ax[1].plot(x, np.exp(-x), "g--", lw=1.2, label="Poisson")
    ax[1].set_title("Difference spectrum of zeros: RIGID (GUE repulsion)")
    ax[1].set_xlabel("normalized spacing"); ax[1].legend(fontsize=8)

    # (c) sum spectrum: {gamma_i + gamma_j} in a window around 2*median
    center = 2 * np.median(gam)
    W = 2.0
    sums = []
    # collect pairs with sum in [center-W, center+W]
    g = gam
    j0 = 0
    for i in range(len(g)):
        lo, hi = center - W - g[i], center + W - g[i]
        if hi < g[0] or lo > g[-1]:
            continue
        a, b = np.searchsorted(g, lo), np.searchsorted(g, hi)
        a = max(a, i)                     # dedupe: only pairs with g[j] >= g[i]
        if b > a:
            sums.append(g[i] + g[a:b])
    sums = np.concatenate(sums)
    sums.sort()
    d = np.diff(sums)
    mean_d = d.mean()
    ax[2].hist(d / mean_d, bins=80, range=(0, 3.2), density=True, alpha=0.6,
               label=r"spacings of $\{\gamma_i+\gamma_j\}$")
    ax[2].plot(x, np.exp(-x), "g--", lw=1.2, label="Poisson")
    ax[2].plot(x, wigner, "k-", lw=1.2, label="GUE")
    ax[2].set_title("Sum spectrum of zeros: POISSON (no structure)")
    ax[2].set_xlabel("normalized spacing"); ax[2].legend(fontsize=8)

    fig.tight_layout()
    fig.savefig(FIG / "exp5_zerofield.png", dpi=140)
    print("saved figures/exp5_zerofield.png")
    print(f"(a) reconstruction at x=2,3,4,5: ",
          [f"{np.interp(v, xs, rec):.3f}" for v in [2, 3, 4, 5]],
          " vs Lambda:", [f"{lam[v]:.3f}" for v in [2, 3, 4, 5]])
    print(f"(b) KS-like check: mean spacing {s.mean():.4f} (should be ~1 after unfolding)")
    print(f"(c) pairs in window: {len(sums)}, spacing var/mean^2 = {d.var()/mean_d**2:.3f} "
          f"(Poisson: 1.0, GUE: ~0.18)")

if __name__ == "__main__":
    main()
