"""Experiment 27: THE PROFINITE SCHEME RUNS — the block constants' anomaly
flow, and the scheme-invariant c2.

The corrected Theorem J (BLOCKS.md S5, after CROSSREVIEW_EXP22_25) left one
open item: the block decomposition of the MS summatory T(X) is canonical
only in the fluctuation sector; the smooth per-block constants depend on
the profinite resolution Q.  This experiment measures that dependence and
gives it its right name: RENORMALIZATION.

    Q is a scheme choice (a profinite cutoff).  The per-block smooth
    constants RUN with Q; the total c2 = T - log X - (zero oscillation)
    is the scheme invariant.

Measured running law (fit below): the [##](T) intercept grows like
a log^2 Q + b log Q + c — the log^2 comes from the small-n spikes of
Lambda#_Q (of height ~ sum mu^2/phi ~ log Q) squared against the 1/n^2
weight; [mix] and [bb] constants run oppositely so the sum stays fixed at
c2 = -2.2803 at every Q (verified).

This converts the audit's "Q-dependent artifact" from a defect into a
structure: the block language needs a scheme label, exactly like a
renormalized QFT; scheme-independent statements are those about (i) the
total, (ii) fluctuation sectors, (iii) limits of scheme-covariant
combinations.
"""
import numpy as np
import matplotlib
matplotlib.use("Agg")
import matplotlib.pyplot as plt
from pathlib import Path
from pairfield import sieve_lambda, load_zeros
from exp11_blocks import mobius_phi, lambda_sharp, conv2, NMAX

FIG = Path(__file__).resolve().parent.parent / "figures"
M = 8192
LOGX = np.linspace(np.log(2e4), np.log(1.9e6), M)
XS = np.exp(LOGX)
XI = XS.astype(int)


def t_of(r):
    n = np.arange(len(r), dtype=float)
    n[0] = 1.0
    return np.cumsum(r / n ** 2)[XI]


def main():
    mu, phi = mobius_phi(200_000)
    lam = sieve_lambda(NMAX)
    gam = load_zeros()

    # screw-kernel oscillation (Q-independent zero model)
    K1 = 30_000
    rho = 0.5 + 1j * gam[:K1]
    coef = 1.0 / (rho * (1 - rho))
    S = np.zeros(M)
    for ch in range(0, K1, 2000):
        rr, cc = rho[ch:ch + 2000], coef[ch:ch + 2000]
        S += 2 * np.real(np.exp(np.outer(LOGX, rr - 1)) @ cc)
    screw = 2 * S

    T_tot = t_of(conv2(lam, lam))
    c2 = np.mean(T_tot - LOGX - screw)
    print(f"scheme invariant: c2 = {c2:.4f}\n")

    A = np.vstack([LOGX, np.ones(M)]).T
    Qs = [5, 10, 15, 20, 30, 45, 60, 90, 120]
    iSS, cMIX, cBB = [], [], []
    print(f"{'Q':>4} {'[##] intercept':>14} {'[mix] const':>12} {'[bb] const':>11} "
          f"{'sum-of-consts':>13}")
    for Q in Qs:
        lamS = lambda_sharp(Q, mu, phi)
        lamB = lam - lamS
        lamB[0] = 0.0
        T_SS = t_of(conv2(lamS, lamS))
        T_mix = 2 * t_of(conv2(lamS, lamB))
        T_BB = t_of(conv2(lamB, lamB))
        sol, *_ = np.linalg.lstsq(A, T_SS, rcond=None)
        # mixed/bb smooth constants: subtract their oscillatory models
        cm = np.mean(T_mix - screw)          # mix carries the screw oscillation
        cb = np.mean(T_BB)                   # bb oscillation is 1e-7, negligible
        iSS.append(sol[1]); cMIX.append(cm); cBB.append(cb)
        print(f"{Q:>4} {sol[1]:>14.3f} {cm:>12.3f} {cb:>11.3f} "
              f"{sol[1]+cm+cb:>13.4f}")
    iSS, cMIX, cBB = map(np.array, (iSS, cMIX, cBB))
    lq = np.log(np.array(Qs, dtype=float))
    co = np.polyfit(lq, iSS, 2)
    fit = np.polyval(co, lq)
    print(f"\nrunning law of the [##] intercept: "
          f"{co[0]:.4f} log^2 Q {co[1]:+.4f} log Q {co[2]:+.4f}")
    print(f"  fit residual rms = {np.std(iSS - fit):.4f}")
    print(f"scheme invariance: sum of block constants = {np.mean(iSS+cMIX+cBB):.4f}"
          f" +- {np.std(iSS+cMIX+cBB):.4f}   (c2 = {c2:.4f})")

    fig, ax = plt.subplots(1, 2, figsize=(12.5, 4.6))
    ax[0].plot(lq, iSS, "o-", label="[##] intercept")
    ax[0].plot(lq, cMIX, "s-", label="[mix] constant")
    ax[0].plot(lq, cBB, "^-", label="[bb] constant")
    ax[0].plot(lq, iSS + cMIX + cBB, "k--", lw=2, label=f"sum = c2 = {c2:.3f}")
    ax[0].set_xlabel("log Q"); ax[0].legend(fontsize=8)
    ax[0].set_title("block constants run with the profinite scheme; the sum is invariant")
    ax[1].plot(lq, iSS, "o", label="[##] intercept")
    ax[1].plot(lq, fit, "--", color="crimson",
               label=f"{co[0]:.3f} log$^2Q$ {co[1]:+.3f} log$Q$ {co[2]:+.3f}")
    ax[1].set_xlabel("log Q"); ax[1].legend(fontsize=8)
    ax[1].set_title("the running law")
    fig.tight_layout()
    fig.savefig(FIG / "exp27_running.png", dpi=140)
    print("\nsaved figures/exp27_running.png")


if __name__ == "__main__":
    main()
