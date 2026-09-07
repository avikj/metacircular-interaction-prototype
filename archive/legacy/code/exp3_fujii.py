"""Experiment 3: The SUM marginal sees zeros through gamma (Fujii's formula).

G(X) = sum_{N <= X} r(N),  r(N) = sum_{m+n=N} Lambda(m) Lambda(n).

Fujii (1991) / Goldston-Suriajaya (2021, unconditional):
  G(X) = X^2/2 - 2 sum_rho X^{rho+1}/(rho(rho+1)) + O(X log^3 X).

We compute G(X) exactly (FFT convolution of Lambda up to 2*10^6) and compare
against the zero expansion, showing that the oscillating error G(X) - X^2/2 is
reproduced zero-by-zero: the Goldbach (sum) marginal hears single zeros with
weight X^{rho+1}/(rho(rho+1)).
"""
import numpy as np
import matplotlib
matplotlib.use("Agg")
import matplotlib.pyplot as plt
from pathlib import Path
from pairfield import sieve_lambda, load_zeros, additive_convolution

FIG = Path(__file__).resolve().parent.parent / "figures"

def main():
    NMAX = 2_000_000
    lam = sieve_lambda(NMAX)
    r = additive_convolution(lam)          # r[N] for N <= 2*NMAX
    G = np.cumsum(r)                        # G[X]
    gam = load_zeros()
    Xs = np.geomspace(1000, NMAX, 500)

    def zero_sum(X, K):
        rho = 0.5 + 1j * gam[:K]
        return 2 * np.real(np.sum(X ** (rho + 1) / (rho * (rho + 1))))

    fig, ax = plt.subplots(1, 2, figsize=(12, 4.5))
    Gx = np.array([G[int(x)] for x in Xs])
    err0 = Gx - Xs ** 2 / 2
    ax[0].plot(Xs, err0 / Xs ** 1.5, lw=0.8, label=r"$(G(X)-X^2/2)/X^{3/2}$")
    zs = np.array([zero_sum(x, 200) for x in Xs])
    ax[0].plot(Xs, -zs / Xs ** 1.5, lw=0.8,
               label=r"$-2\,\mathrm{Re}\sum_{\rho}^{(200)} X^{\rho+1}/(\rho(\rho+1)) / X^{3/2}$")
    ax[0].set_xscale("log")
    ax[0].legend(fontsize=8); ax[0].set_xlabel("X")
    ax[0].set_title("Average Goldbach error vs zero prediction (Fujii)")

    # residual after removing K zeros
    for K in [0, 5, 50, 1000]:
        zsK = np.array([zero_sum(x, K) for x in Xs]) if K else 0 * Xs
        res = (Gx - Xs ** 2 / 2 + zsK)
        rms = np.sqrt(np.mean((res / Xs ** 1.5) ** 2))
        ax[1].plot(Xs, res / Xs ** 1.5, lw=0.7, label=f"K={K} zeros, rms={rms:.4f}")
        print(f"K={K:5d}: rms of (G - main + zerosum)/X^1.5 = {rms:.5f}")
    ax[1].set_xscale("log")
    ax[1].legend(fontsize=8); ax[1].set_xlabel("X")
    ax[1].set_title("Residual after subtracting K zeros")
    fig.tight_layout()
    fig.savefig(FIG / "exp3_fujii.png", dpi=140)
    print("saved figures/exp3_fujii.png")

if __name__ == "__main__":
    main()
