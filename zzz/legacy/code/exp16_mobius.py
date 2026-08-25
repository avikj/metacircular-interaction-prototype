"""Experiment 16: THE MOBIUS PAIR FIELD IS THE PURE PAIR FIELD.

Completion of the residue-dressing family (LIOUVILLE.md S3.2).  The Dirichlet
series of mu is 1/zeta(s): NO POLE ANYWHERE.  So the double-explicit-formula
mechanism predicts the extreme member of the family:

**Theorem H' (Mobius-Goldbach trace formula; RH + simple zeros).**
With v_rho = 1/zeta'(rho),

    G1^mu(X) = sum_{m,n>=1} mu(m)mu(n)(X-m-n)_+
             = sum_{rho,rho'} v_rho v_rho'
               Gamma(rho)Gamma(rho')/Gamma(rho+rho'+2) X^{rho+rho'+1}
               + O(X^{3/2+eps}):

NO main term, NO single-zero layer — the smoothed Mobius-Goldbach average
is NOTHING BUT the sum-spectrum of the zeta zeros.  Layer count across the
family = number of poles of the generating series:

    Lambda (-z'/z, pole at 1):  main X^3 | single X^{5/2} | pair X^2
    lambda (z(2s)/z, pole 1/2): main X^2 | single X^2     | pair X^2  (degenerate)
    mu     (1/z, no pole):      —        | —              | pair X^2  (pure)

Predictions tested:
  1. the spectrum of G1^mu/X^2 has pair lines gamma_i+gamma_j ONLY; single
     gamma_i lines are suppressed to the X^{3/2}-boundary level (~X^{-1/2}
     relative ~ 3%%-level amplitudes at X~10^6);
  2. band correlation against the pure pair model with 1/zeta' weights;
  3. mean of G1^mu/X^2 ~ 0 (no deterministic X^2 term); hence, since the
     diagonal m=n contributes sum_{2m<=X} mu(m)^2 (X-2m) = (3/(2 pi^2))X^2
     deterministically (squarefree density 6/pi^2),

     **Corollary: sum_{m!=n, m+n<=X} mu(m)mu(n)(X-m-n) = -(3/(2 pi^2))X^2
       + osc = -0.151982 X^2 + osc** — an exact negative closed form for the
     smoothed simplex-average of two-point Mobius, while pointwise
     two-point Chowla for mu remains open.
"""
import numpy as np
from scipy.special import loggamma
import mpmath as mp
import matplotlib
matplotlib.use("Agg")
import matplotlib.pyplot as plt
from pathlib import Path
from pairfield import load_zeros, additive_convolution

FIG = Path(__file__).resolve().parent.parent / "figures"
DATA = Path(__file__).resolve().parent.parent / "data"


def sieve_mobius(N):
    spf = np.zeros(N + 1, dtype=np.int64)
    for p in range(2, N + 1):
        if spf[p] == 0:
            spf[p::p] = np.where(spf[p::p] == 0, p, spf[p::p])
    mu = np.zeros(N + 1, dtype=np.float64)
    mu[1] = 1.0
    for n in range(2, N + 1):
        m = n // spf[n]
        mu[n] = 0.0 if m % spf[n] == 0 else -mu[m]
    return mu


def main():
    NMAX = 2_000_000
    mob = sieve_mobius(NMAX)
    r = additive_convolution(mob)
    N = np.arange(len(r), dtype=float)
    R, S = np.cumsum(r), np.cumsum(N * r)
    gam = load_zeros()

    M = 8192
    logX = np.linspace(np.log(2e4), np.log(1.9e6), M)
    Xs = np.exp(logX)
    Xi = Xs.astype(int)
    data = (Xs * R[Xi] - S[Xi]) / Xs ** 2

    # ---- weights v_rho = 1/zeta'(rho) ---------------------------------
    K = 40
    mp.mp.dps = 20
    cache = DATA / "mobius_weights_40.npy"
    if cache.exists():
        v = np.load(cache)
    else:
        v = np.zeros(K, dtype=complex)
        for k in range(K):
            v[k] = complex(1 / mp.zeta(mp.mpc(0.5, gam[k]), derivative=1))
        np.save(cache, v)

    # ---- pure pair model ----------------------------------------------
    sgn = np.concatenate([gam[:K], -gam[:K]])
    vs = np.concatenate([v, np.conj(v)])
    rr = 0.5 + 1j * sgn
    LG = loggamma(rr)
    WW = (vs[:, None] * vs[None, :]) * np.exp(LG[:, None] + LG[None, :]
                                              - loggamma(rr[:, None] + rr[None, :] + 2))
    E = np.exp(1j * np.outer(sgn, logX))
    model = np.real(np.einsum("km,km->m", E, WW @ E))

    # ---- 1. no deterministic X^2 term; corollary ----------------------
    print(f"mean of G1^mu/X^2 over grid: {np.mean(data):+.6f}   "
          f"(prediction 0; pair-layer mean {np.mean(model):+.6f})")
    diag = 3 / (2 * np.pi ** 2)
    print(f"corollary: off-diagonal simplex average = -(3/(2pi^2)) = {-diag:.6f}")
    # direct diagonal computation for the corollary
    sq = (mob != 0).astype(float)
    m2 = np.arange(NMAX + 1, dtype=float)
    # sum_{2m<=X} mu(m)^2 (X-2m) at a few X values
    cums, cumm = np.cumsum(sq), np.cumsum(sq * m2)
    for Xv in [10 ** 5, 10 ** 6]:
        h = Xv // 2
        dsum = Xv * cums[h] - 2 * cumm[h]
        print(f"  X = {Xv:.0e}: diagonal/X^2 = {dsum/Xv**2:.6f} (pred {diag:.6f});  "
              f"off-diag/X^2 = {(np.interp(np.log(Xv), logX, data) - dsum/Xv**2):+.6f}")

    # ---- 2. band comparison + single-line suppression ------------------
    win = np.hanning(M)

    def prep(y):
        return y - np.polyval(np.polyfit(logX, y, 3), logX)

    def bandpass(y, lo, hi):
        Y = np.fft.rfft(prep(y))
        f = np.fft.rfftfreq(M, d=(logX[1] - logX[0])) * 2 * np.pi
        Y[(f < lo) | (f > hi)] = 0
        return np.fft.irfft(Y, M)

    core = slice(M // 8, -M // 8)
    for lo, hi, tag in [(28.5, 60, "pair band"), (10, 27.5, "single band (should be ~empty)")]:
        bd, bm = bandpass(data, lo, hi), bandpass(model, lo, hi)
        corr = np.corrcoef(bd[core], bm[core])[0, 1]
        ratio = np.std(bd[core]) / max(np.std(bm[core]), 1e-30)
        print(f"band [{lo},{hi}] ({tag}):  corr = {corr:.4f}, ratio = {ratio:.4f}, "
              f"data RMS = {np.std(bd[core]):.5f}")

    def spec(y):
        Y = np.fft.rfft(prep(y) * win)
        f = np.fft.rfftfreq(M, d=(logX[1] - logX[0])) * 2 * np.pi
        return f, np.abs(Y)
    fd, Ad = spec(data)
    fm, Am = spec(model)
    print("\nline amplitudes: single gamma_i (predicted SUPPRESSED) vs pair gamma_i+gamma_j:")
    for nm, fr, kind in [("g1", gam[0], "single"), ("g2", gam[1], "single"),
                         ("g3", gam[2], "single"),
                         ("2g1", 2 * gam[0], "pair"), ("g1+g2", gam[0] + gam[1], "pair"),
                         ("2g2", 2 * gam[1], "pair")]:
        i = np.argmin(np.abs(fd - fr))
        print(f"  {nm:>6} ({kind:>6}) at {fr:7.3f}:  data {Ad[i]:8.3f}  model {Am[i]:8.3f}"
              f"   ratio {Ad[i]/max(Am[i],1e-12):8.2f}")

    # ---- figure --------------------------------------------------------
    fig, ax = plt.subplots(2, 1, figsize=(13, 8.4))
    band = (fd > 8) & (fd < 60)
    ax[0].plot(fd[band], Ad[band], lw=0.9, label="Mobius-Goldbach data spectrum")
    ax[0].plot(fm[band], -Am[band], lw=0.9, color="crimson",
               label="pure pair model (mirrored), weights $1/\\zeta'(\\rho)$")
    for i in range(4):
        ax[0].axvline(gam[i], color="green", lw=0.8, ls="--",
                      label=r"single $\gamma_i$ (predicted absent)" if i == 0 else None)
    for i in range(4):
        for j in range(i, 4):
            fr = gam[i] + gam[j]
            if fr < 60:
                ax[0].axvline(fr, color="gray", lw=0.5, ls=":",
                              label=r"$\gamma_i+\gamma_j$" if (i, j) == (0, 0) else None)
    ax[0].legend(fontsize=8)
    ax[0].set_title("The pure pair field: Mobius-Goldbach data = sum-spectrum of zeros, no foreground")
    bd, bm = bandpass(data, 25, 60), bandpass(model, 25, 60)
    ax[1].plot(Xs[core], bd[core], lw=0.7, label="data, band [25,60]")
    ax[1].plot(Xs[core], bm[core], lw=0.7, alpha=0.85, label="pure pair model")
    ax[1].set_xscale("log")
    ax[1].legend(fontsize=8)
    fig.tight_layout()
    fig.savefig(FIG / "exp16_mobius.png", dpi=140)
    print("\nsaved figures/exp16_mobius.png")


if __name__ == "__main__":
    main()
