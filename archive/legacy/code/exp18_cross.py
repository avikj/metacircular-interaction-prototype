"""Experiment 18: THE CROSS FIELD Lambda x mu — layer algebra is compositional.

FAMILY.md gives the law: layers of a pair field = products of the two
factors' singular structures.  The ordered cross field

    G1^{Lm}(X) = sum_{m,n>=1} Lambda(m) mu(n) (X-m-n)_+

is the sharpest compositional test, because Lambda has the pole and mu does
not.  Prediction (RH + simple zeros; v_rho = 1/zeta'(rho)):

    pole x pole:  ABSENT  ->  **no X^3 main term** (mu's meanlessness kills
                              the psi main term inside the pair count);
    pole x zero:  + sum_rho v_rho Gamma(rho)/Gamma(rho+3) X^{rho+2}
                  — single-zero layer at X^{5/2} with MOBIUS weights;
    zero x pole:  ABSENT;
    zero x zero:  - sum_{rho,rho'} v_{rho'} Gamma(rho)Gamma(rho')
                    / Gamma(rho+rho'+2) X^{rho+rho'+1}   (ordered weights).

There is a FIFTH layer the naive pole/zero bookkeeping misses: the Mobius
explicit formula carries the constant 1/zeta(0) = -2 (residue at s=0), and
pole(Lambda) x constant(mu) contributes the smooth term

    (1/(2 zeta(0))) X^2  =  -X^2      [s=0 layer]

— first predicted -0 here, then DISCOVERED by this experiment's own output
(measured mean -0.99986: the arithmetic data measures zeta(0) = -1/2 to
four digits).  Diagonal corollary: Lambda(m)mu(m) = -log p at m = p, so the
diagonal contributes -X^2/4 deterministically, and the off-diagonal
smoothed average is (1/(2 zeta(0)) + 1/4) X^2:

    sum_{m!=n} Lambda(m) mu(n) (X-m-n)  =  -(3/4) X^2 + osc.
"""
import numpy as np
from scipy.special import loggamma
import matplotlib
matplotlib.use("Agg")
import matplotlib.pyplot as plt
from pathlib import Path
from pairfield import sieve_lambda, load_zeros
from exp16_mobius import sieve_mobius

FIG = Path(__file__).resolve().parent.parent / "figures"
DATA = Path(__file__).resolve().parent.parent / "data"


def main():
    NMAX = 2_000_000
    lam = sieve_lambda(NMAX)
    mob = sieve_mobius(NMAX)
    L = 1
    while L < 2 * (NMAX + 1):
        L *= 2
    r = np.fft.irfft(np.fft.rfft(lam, L) * np.fft.rfft(mob, L), L)[: 2 * NMAX + 1]
    N = np.arange(len(r), dtype=float)
    R, S = np.cumsum(r), np.cumsum(N * r)
    gam = load_zeros()

    M = 8192
    logX = np.linspace(np.log(2e4), np.log(1.9e6), M)
    Xs = np.exp(logX)
    Xi = Xs.astype(int)
    G1 = Xs * R[Xi] - S[Xi]

    K = 40
    v = np.load(DATA / "mobius_weights_40.npy")
    rho = 0.5 + 1j * gam[:K]

    # ---- no main term --------------------------------------------------
    print("absence of X^3:  G1/X^3 at X = 3e4, 1e5, 1e6:",
          ", ".join(f"{np.interp(np.log(x), logX, G1/Xs**3):+.5f}"
                    for x in [3e4, 1e5, 1e6]), "  (Lambda alone would give 1/6 = 0.1667)")

    # ---- single layer at X^{5/2} with Mobius weights -------------------
    cs = v * np.exp(loggamma(rho) - loggamma(rho + 3))
    single = 2 * np.real(np.exp(np.outer(logX, rho - 0.5)) @ cs)   # X^{rho+2}/X^{5/2}
    single2 = 2 * np.real(np.exp(np.outer(logX, rho)) @ cs)        # at X^2 scale
    data25 = G1 / Xs ** 2.5

    # ---- corollary: mean and diagonal ---------------------------------
    # NB: at X^2 normalization the single layer oscillates with GROWING
    # amplitude ~ X^{1/2}|c| (order 1 at X ~ 1e6), so the smooth +1/4 must be
    # read after subtracting the single-layer model.
    print(f"mean of (G1/X^2 - single layer) over grid: "
          f"{np.mean(G1/Xs**2 - single2):+.5f}   (s=0 layer: 1/(2 zeta(0)) = -1)")
    dvals = lam * mob  # -log p at primes, 0 elsewhere (prime powers k>=2 have mu=0)
    cums, cumm = np.cumsum(dvals), np.cumsum(dvals * np.arange(NMAX + 1))
    for Xv in [10 ** 5, 10 ** 6]:
        h = Xv // 2
        dsum = Xv * cums[h] - 2 * cumm[h]
        offd = (np.interp(np.log(Xv), logX, G1 / Xs ** 2 - single2)
                - dsum / Xv ** 2)
        print(f"  X = {Xv:.0e}: diagonal/X^2 = {dsum/Xv**2:+.5f} (pred -0.25);  "
              f"off-diag/X^2 (single subtracted) = {offd:+.5f} (pred -0.75)")

    # ---- pair layer at X^2 (ordered weights) ---------------------------
    sgn = np.concatenate([gam[:K], -gam[:K]])
    vs = np.concatenate([v, np.conj(v)])
    rr = 0.5 + 1j * sgn
    LG = loggamma(rr)
    WW = -(np.ones(2 * K)[:, None] * vs[None, :]) * np.exp(
        LG[:, None] + LG[None, :] - loggamma(rr[:, None] + rr[None, :] + 2))
    E = np.exp(1j * np.outer(sgn, logX))
    pair = np.real(np.einsum("km,km->m", E, WW @ E))
    data2 = G1 / Xs ** 2

    def prep(y):
        return y - np.polyval(np.polyfit(logX, y, 3), logX)

    def bandpass(y, lo, hi):
        Y = np.fft.rfft(prep(y))
        f = np.fft.rfftfreq(M, d=(logX[1] - logX[0])) * 2 * np.pi
        Y[(f < lo) | (f > hi)] = 0
        return np.fft.irfft(Y, M)

    core = slice(M // 8, -M // 8)
    bd, bm = bandpass(data25, 10, 27.5), bandpass(single, 10, 27.5)
    c1 = np.corrcoef(bd[core], bm[core])[0, 1]
    r1 = np.std(bd[core]) / np.std(bm[core])
    print(f"\nsingle layer (X^2.5, Mobius weights), band [10,27.5]: "
          f"corr = {c1:.4f}, ratio = {r1:.4f}")
    resid2 = data2 - single2
    bd, bm = bandpass(resid2, 28.5, 60), bandpass(pair, 28.5, 60)
    c2 = np.corrcoef(bd[core], bm[core])[0, 1]
    r2 = np.std(bd[core]) / np.std(bm[core])
    print(f"pair layer (X^2, ordered weights),  band [28.5,60]: "
          f"corr = {c2:.4f}, ratio = {r2:.4f}")

    fig, ax = plt.subplots(2, 1, figsize=(13, 8))
    bd, bm = bandpass(data25, 10, 27.5), bandpass(single, 10, 27.5)
    ax[0].plot(Xs[core], bd[core], lw=0.7, label="data at $X^{5/2}$, band [10,27.5]")
    ax[0].plot(Xs[core], bm[core], lw=0.7, alpha=0.85,
               label="single-zero model, Mobius weights $1/\\zeta'(\\rho)$")
    ax[0].set_xscale("log"); ax[0].legend(fontsize=8)
    ax[0].set_title("cross field $\\Lambda\\times\\mu$: no $X^3$ main term; "
                    "$X^{5/2}$ single layer with Mobius weights")
    bd, bm = bandpass(resid2, 28.5, 60), bandpass(pair, 28.5, 60)
    ax[1].plot(Xs[core], bd[core], lw=0.7, label="residual at $X^2$, band [28.5,60]")
    ax[1].plot(Xs[core], bm[core], lw=0.7, alpha=0.85, label="ordered pair model")
    ax[1].set_xscale("log"); ax[1].legend(fontsize=8)
    fig.tight_layout()
    fig.savefig(FIG / "exp18_cross.png", dpi=140)
    print("\nsaved figures/exp18_cross.png")


if __name__ == "__main__":
    main()
