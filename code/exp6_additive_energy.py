"""Experiment 6: The second-order fluctuation of the (smoothed) Goldbach average
IS the sum-spectrum ("additive-energy resolvent") of the zeta zeros.

Object (Cesaro weight k=1, which makes every zero sum absolutely convergent):

  G1(X) = sum_{m,n} Lambda(m) Lambda(n) (X-m-n)_+

Exact expansion (Dirichlet integral / Languasco-Zaccagnini k=1):

  G1(X) = X^3/6
        - 2 sum_rho X^{rho+2}/(rho(rho+1)(rho+2))          [single zeros]
        + sum_{rho,rho'} G(rho)G(rho')/G(rho+rho'+2) X^{rho+rho'+1}   [zero pairs]
        + O(X^2)-deterministic + small,        G = Gamma.

Under RH the pair term is X^2 * sum_{g,g'} W e^{i(g+g') log X} with
|W| ~ c (g+g')^{-5/2} for same-sign pairs and exponentially small otherwise:
an absolutely convergent exponential sum over the SUM SPECTRUM {gamma+gamma'}.

Test: after removing main + single-zero terms and a quadratic detrend, the
data should match the zero-pair sum pointwise; subtracting it should collapse
the variance.
"""
import numpy as np
from scipy.special import loggamma
import matplotlib
matplotlib.use("Agg")
import matplotlib.pyplot as plt
from pathlib import Path
from pairfield import sieve_lambda, load_zeros, additive_convolution

FIG = Path(__file__).resolve().parent.parent / "figures"

def main():
    NMAX = 2_000_000
    lam = sieve_lambda(NMAX)
    r = additive_convolution(lam)
    # G1(X) = sum_{N<=X} (X-N) r(N) = cumsum(cumsum(r)) evaluated cleverly:
    # sum_{N<=X}(X-N)r(N) = X*R(X) - S(X) with R=cumsum(r), S=cumsum(N r(N))
    N = np.arange(len(r), dtype=float)
    R = np.cumsum(r)
    S = np.cumsum(N * r)
    gam = load_zeros()

    K1 = 20000      # single-zero sum truncation (tail ~ 1/gamma^3: negligible)
    K2 = 800        # double-zero sum truncation
    g1 = gam[:K1]
    Xs = np.geomspace(5e3, NMAX, 900)
    logX = np.log(Xs)

    # ---- single-zero sum: 2 Re sum X^{rho+2}/(rho(rho+1)(rho+2)), chunked
    rho1 = 0.5 + 1j * g1
    coef = 1.0 / (rho1 * (rho1 + 1) * (rho1 + 2))
    S1 = np.zeros(len(Xs))
    for ch in range(0, K1, 2000):
        rr = rho1[ch:ch+2000]; cc = coef[ch:ch+2000]
        S1 += 2 * np.real(np.exp(np.outer(logX, rr + 2)) @ cc)

    # ---- double-zero sum with Gamma(rho)Gamma(rho')/Gamma(rho+rho'+2)
    g2 = gam[:K2]
    sgn = np.concatenate([g2, -g2])
    rr = 0.5 + 1j * sgn
    LG = loggamma(rr)
    W = np.exp(LG[:, None] + LG[None, :] - loggamma(rr[:, None] + rr[None, :] + 2))
    D = np.zeros(len(Xs))
    for i, lx in enumerate(logX):
        v = np.exp(1j * sgn * lx)
        D[i] = np.real(v @ W @ v)
    D *= Xs ** 2                                  # X^{rho+rho'+1} = X^2 e^{i(g+g')logX}

    Xi = Xs.astype(int)
    G1 = Xs * R[Xi] - S[Xi]
    resid = G1 - Xs ** 3 / 6 + S1

    # quadratic detrend in X absorbs deterministic O(X^2), O(X), O(1) terms
    A = np.vstack([np.ones_like(Xs), Xs, Xs ** 2]).T
    def detrend(y):
        c, *_ = np.linalg.lstsq(A, y, rcond=None)
        return y - A @ c
    r_d, D_d = detrend(resid), detrend(D)

    corr = np.corrcoef(r_d / Xs**2, D_d / Xs**2)[0, 1]
    ratio = np.std(r_d / Xs**2) / np.std(D_d / Xs**2)
    after = detrend(resid - D)
    collapse = np.std(after / Xs**2) / np.std(r_d / Xs**2)
    print(f"std(data)/X^2  = {np.std(r_d/Xs**2):.3e}")
    print(f"std(model)/X^2 = {np.std(D_d/Xs**2):.3e}")
    print(f"correlation(data, zero-pair model) = {corr:.4f}")
    print(f"amplitude ratio data/model = {ratio:.3f}")
    print(f"residual std after subtracting model: {collapse:.3f} of before")

    fig, ax = plt.subplots(1, 2, figsize=(13, 4.6))
    ax[0].plot(Xs, r_d / Xs**2, lw=0.8, label="data: 2nd-order Goldbach fluctuation")
    ax[0].plot(Xs, D_d / Xs**2, lw=0.8, alpha=0.85, label=f"model: zero-pair sum (K={K2})")
    ax[0].set_xscale("log"); ax[0].set_xlabel("X"); ax[0].legend(fontsize=8)
    ax[0].set_title(f"Smoothed Goldbach 2nd-order term vs additive-energy resolvent "
                    f"(corr={corr:.3f})")
    ax[1].scatter(D_d / Xs**2, r_d / Xs**2, s=3, alpha=0.4)
    lo, hi = np.percentile(D_d/Xs**2, [0.5, 99.5])
    ax[1].plot([lo, hi], [lo, hi], "k--", lw=1)
    ax[1].set_xlabel("zero-pair model"); ax[1].set_ylabel("data")
    ax[1].set_title("Pointwise agreement")
    fig.tight_layout()
    fig.savefig(FIG / "exp6_additive_energy.png", dpi=140)
    print("saved figures/exp6_additive_energy.png")

    dvals = np.abs(np.diag(W[:K2, :K2]))
    p = np.polyfit(np.log(2 * g2[5:]), np.log(dvals[5:]), 1)
    print(f"same-sign diagonal weight decay: |W| ~ freq^{p[0]:.3f} (Stirling: -5/2)")

if __name__ == "__main__":
    main()
