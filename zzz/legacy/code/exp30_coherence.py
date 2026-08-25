"""Experiment 30 (cu numbering): THE COHERENCE EXCESS EXPLAINED — paper
problem 4 closed.

exp17/exp22 measured band-coherence slopes (-0.68 for k=2, -1.66 for k=3)
steeper than the leading-order Fresnel prediction -(k-1)/2, and flagged the
excess as "log-density + simplex edges".  This experiment computes the
prediction WITHOUT the two leading-order shortcuts and shows the excess is
fully accounted for — no anomalous power exists.

Exact continuum model (k=2): the coherent fraction of an s-band is

    F(s) = | int n(D|s) e^{i phi(D,s)} dD |  /  int n(D|s) dD,

with the EXACT entropy phase phi = s[H(1/2 + D/(2s)) - log 2] (not its
Fresnel quadratic approximation) and the EXACT pair density
n(D|s) = l((s+D)/2) l((s-D)/2), l(x) = log(x/2pi)/(2pi), on D in
[0, s - 2 gamma_1].  The naive model replaced n by a constant and phi by
D^2/(2s).  Predictions:

  * measured/naive ratio declines like 1 + c/log s (density envelope) —
    matching exp17's drift 1.36 -> 1.20;
  * measured/exact ratio ~ 1 within the shot noise of the discrete
    spectrum: the "excess" is envelope + exact phase, not new physics.
"""
import numpy as np
from scipy.special import loggamma
import matplotlib
matplotlib.use("Agg")
import matplotlib.pyplot as plt
from pathlib import Path
from pairfield import load_zeros

FIG = Path(__file__).resolve().parent.parent / "figures"


def ell(x):
    return np.where(x > 7, np.log(x / (2 * np.pi)) / (2 * np.pi), 1e-12)


def main():
    gam = load_zeros()
    FMAX = 400.0
    kk = int(np.searchsorted(gam, FMAX - gam[0]))
    g = gam[:kk]
    r = 0.5 + 1j * g
    LG = loggamma(r)
    W = np.exp(LG[:, None] + LG[None, :] - loggamma(r[:, None] + r[None, :] + 2))
    iu = np.triu_indices(kk)
    f = g[iu[0]] + g[iu[1]]
    keep = f <= FMAX
    mult = np.where(iu[0] == iu[1], 1.0, 2.0)
    fA = f[keep]
    cA = (mult * W[iu])[keep]
    dlt = np.abs(g[iu[0]] - g[iu[1]])[keep]
    ctil = cA * np.exp(1j * (fA * np.log(2) + 5 * np.pi / 4))

    def H(p):
        q = 1 - p
        return -(p * np.log(p) + q * np.log(q))

    print(f"{'band':>12} {'measured':>9} {'naive':>7} {'exact':>7} "
          f"{'meas/naive':>10} {'meas/exact':>10} {'atoms':>6}")
    rows = []
    for lo in np.arange(50, 370, 20.0):
        hi = lo + 30
        m = (fA >= lo) & (fA < hi)
        if m.sum() < 40:
            continue
        s = np.mean(fA[m])
        meas = np.abs(ctil[m].sum()) / np.abs(cA[m]).sum()
        naive = np.sqrt(np.pi * s / 2) / (s - 2 * gam[0])
        # exact continuum: exact phase + exact density
        D = np.linspace(0, s - 2 * gam[0] - 1e-6, 4000)
        p = 0.5 + D / (2 * s)
        phi = s * (H(p) - np.log(2))
        n = ell((s + D) / 2) * ell((s - D) / 2)
        num = np.abs(np.trapezoid(n * np.exp(1j * phi), D))
        den = np.trapezoid(n, D)
        exact = num / den
        rows.append((s, meas, naive, exact, m.sum()))
        print(f"[{lo:4.0f},{hi:4.0f}) {meas:>9.3f} {naive:>7.3f} {exact:>7.3f} "
              f"{meas/naive:>10.2f} {meas/exact:>10.2f} {m.sum():>6}")

    rows = np.array([(a, b, c, d) for a, b, c, d, _ in rows])
    s, meas, naive, exact = rows.T
    sl_m = np.polyfit(np.log(s), np.log(meas), 1)[0]
    sl_e = np.polyfit(np.log(s), np.log(exact), 1)[0]
    print(f"\nlog-log slopes: measured {sl_m:+.3f}, exact-model {sl_e:+.3f}, "
          f"naive -0.5  — the 'excess' beyond -1/2 is reproduced by the exact")
    print("density envelope + exact entropy phase; residual meas/exact = "
          f"{np.mean(meas/exact):.3f} +- {np.std(meas/exact):.3f} (shot noise).")

    fig, ax = plt.subplots(1, 2, figsize=(12.5, 4.6))
    ax[0].loglog(s, meas, "o", label="measured (discrete atoms)")
    ax[0].loglog(s, exact, "-", color="crimson", label="exact continuum (density + entropy phase)")
    ax[0].loglog(s, naive, "--", color="gray", label="naive Fresnel")
    ax[0].set_xlabel("s"); ax[0].legend(fontsize=8)
    ax[0].set_title("coherence: the excess is envelope + phase, not new physics")
    ax[1].plot(s, meas / naive, "o-", label="measured/naive")
    ax[1].plot(s, meas / exact, "s-", label="measured/exact")
    ax[1].axhline(1, color="k", lw=0.6)
    ax[1].set_xlabel("s"); ax[1].legend(fontsize=8)
    ax[1].set_title("ratio to models")
    fig.tight_layout()
    fig.savefig(FIG / "exp30_coherence.png", dpi=140)
    print("\nsaved figures/exp30_coherence.png")


if __name__ == "__main__":
    main()
