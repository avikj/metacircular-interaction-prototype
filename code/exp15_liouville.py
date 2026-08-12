"""Experiment 15: THE LIOUVILLE-GOLDBACH TRACE FORMULA (Theorem H).

The parity sector was held disjoint from the spectral program: PARITY.md
proves the BC projections of lambda vanish identically, and the gauge no-go
(collaborator branch, GAUGE.md) shows every parity-odd observable has exactly
zero equilibrium expectation.  Both statements live at the FINITE places.
This experiment points the ARCHIMEDEAN machinery (the Theorem-D double
explicit formula) at lambda itself.

Since sum lambda(n) n^{-s} = zeta(2s)/zeta(s), the summatory function has
(RH + simple zeros)

    L(u) = u^{1/2}/zeta(1/2) + sum_rho (zeta(2rho)/(rho zeta'(rho))) u^rho + ...

with a CRITICAL main exponent 1/2 (the pole of zeta(2s)).  Substituting twice
into G1^lam(X) = sum_{m,n>=1} lambda(m)lambda(n)(X-m-n)_+ gives

**Theorem H.**  With w_rho = zeta(2rho)/zeta'(rho),

  G1^lam(X) =  pi X^2 / (8 zeta(1/2)^2)                                [main]
             + (sqrt(pi)/zeta(1/2)) sum_rho w_rho Gamma(rho)/Gamma(rho+5/2)
                                                 X^{rho+3/2}           [single]
             + sum_{rho,rho'} w_rho w_rho' Gamma(rho)Gamma(rho')
                              / Gamma(rho+rho'+2) X^{rho+rho'+1}       [pair]
             + lower order.

ALL THREE LAYERS SIT AT SCALE X^2: because the parity pole is at s=1/2 — on
the critical line — the arithmetic main term and the zero spectrum ride at
the same amplitude.  The lambda pair field is scale-degenerate: pure
spectrum.  (Contrast Lambda: X^3 / X^{5/2} / X^2.)

Corollary (signed average Chowla on the simplex).  The diagonal m=n
contributes exactly X^2/4 + O(X); hence

  sum_{m != n, m+n<=X} lambda(m)lambda(n)(X-m-n)
      = (pi/(8 zeta(1/2)^2) - 1/4) X^2 + osc  =  -0.06585... X^2 + osc:

the smoothed simplex-average of the two-point function of lambda has an
exact, NEGATIVE value — computable from zeta(1/2) — even though pointwise
two-point Chowla is open.

This experiment verifies the constant, the single lines (frequencies
gamma_i), and the pair lines (frequencies gamma_i+gamma_j) in one
scale-degenerate stack, against weights computed by mpmath.
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


def sieve_liouville(N):
    """lambda(n) for 0 <= n <= N via smallest prime factor."""
    spf = np.zeros(N + 1, dtype=np.int64)
    for p in range(2, N + 1):
        if spf[p] == 0:
            spf[p::p] = np.where(spf[p::p] == 0, p, spf[p::p])
    lam = np.ones(N + 1, dtype=np.float64)
    lam[0] = 0.0
    for n in range(2, N + 1):
        lam[n] = -lam[n // spf[n]]
    return lam


def main():
    NMAX = 2_000_000
    lam = sieve_liouville(NMAX)
    r = additive_convolution(lam)
    N = np.arange(len(r), dtype=float)
    R, S = np.cumsum(r), np.cumsum(N * r)
    gam = load_zeros()

    M = 8192
    logX = np.linspace(np.log(2e4), np.log(1.9e6), M)
    Xs = np.exp(logX)
    Xi = Xs.astype(int)
    G1 = Xs * R[Xi] - S[Xi]
    data = G1 / Xs ** 2

    # ---- weights w_rho = zeta(2 rho)/zeta'(rho), first K zeros (mpmath) ----
    K = 40
    mp.mp.dps = 20
    cache = DATA / "liouville_weights_40.npy"
    if cache.exists():
        w = np.load(cache)
    else:
        w = np.zeros(K, dtype=complex)
        for k in range(K):
            rho = mp.mpc(0.5, gam[k])
            w[k] = complex(mp.zeta(2 * rho) / mp.zeta(rho, derivative=1))
        np.save(cache, w)
    zh = complex(mp.zeta(0.5))          # zeta(1/2) = -1.4603545...
    c0 = np.pi / (8 * zh.real ** 2)
    print(f"zeta(1/2) = {zh.real:.7f},  main-term constant c0 = pi/(8 zeta(1/2)^2) "
          f"= {c0:.6f}")
    print(f"corollary constant (off-diagonal simplex average): c0 - 1/4 = {c0-0.25:.6f}")

    # ---- model layers at X^2 scale ------------------------------------
    rho = 0.5 + 1j * gam[:K]
    # single layer: (sqrt(pi)/zeta(1/2)) sum w Gamma(rho)/Gamma(rho+5/2) X^{rho-1/2}
    cs = np.sqrt(np.pi) / zh.real * w * np.exp(loggamma(rho) - loggamma(rho + 2.5))
    single = 2 * np.real(np.exp(np.outer(logX, rho - 0.5)) @ cs)
    # pair layer: signed ordinates, weights w_rho w_rho' Gam Gam / Gam(+2)
    sgn = np.concatenate([gam[:K], -gam[:K]])
    ws = np.concatenate([w, np.conj(w)])
    rr = 0.5 + 1j * sgn
    LG = loggamma(rr)
    WW = (ws[:, None] * ws[None, :]) * np.exp(LG[:, None] + LG[None, :]
                                              - loggamma(rr[:, None] + rr[None, :] + 2))
    E = np.exp(1j * np.outer(sgn, logX))
    pair = np.real(np.einsum("km,km->m", E, WW @ E))
    model = c0 + single + pair

    # ---- constant check ------------------------------------------------
    print(f"\nmean of data over grid: {np.mean(data):.6f}   model: {np.mean(model):.6f}"
          f"   (c0 = {c0:.6f})")

    # ---- band comparison ----------------------------------------------
    win = np.hanning(M)

    def prep(y):
        return (y - np.polyval(np.polyfit(logX, y, 3), logX))

    def bandpass(y, lo, hi):
        Y = np.fft.rfft(prep(y))
        f = np.fft.rfftfreq(M, d=(logX[1] - logX[0])) * 2 * np.pi
        Y[(f < lo) | (f > hi)] = 0
        return np.fft.irfft(Y, M)

    core = slice(M // 8, -M // 8)
    for lo, hi, tag in [(10, 27.5, "single-only band"),
                        (28.5, 60, "mixed single+pair band"),
                        (10, 60, "full band")]:
        bd, bm = bandpass(data, lo, hi), bandpass(model, lo, hi)
        corr = np.corrcoef(bd[core], bm[core])[0, 1]
        ratio = np.std(bd[core]) / np.std(bm[core])
        print(f"band [{lo},{hi}] ({tag}):  corr = {corr:.4f},  amplitude ratio = {ratio:.4f}")

    # spectra + line table
    def spec(y):
        Y = np.fft.rfft(prep(y) * win)
        f = np.fft.rfftfreq(M, d=(logX[1] - logX[0])) * 2 * np.pi
        return f, np.abs(Y)
    fd, Ad = spec(data)
    fm, Am = spec(model)
    print("\nline amplitudes (data vs model) at single AND pair frequencies:")
    lines = [("g1", gam[0]), ("g2", gam[1]), ("g3", gam[2]),
             ("2g1", 2 * gam[0]), ("g1+g2", gam[0] + gam[1]), ("2g2", 2 * gam[1])]
    for nm, fr in lines:
        i = np.argmin(np.abs(fd - fr))
        print(f"  {nm:>6} at {fr:7.3f}:  data {Ad[i]:8.3f}  model {Am[i]:8.3f}  "
              f"ratio {Ad[i]/Am[i]:6.3f}")

    # ---- figure --------------------------------------------------------
    fig, ax = plt.subplots(2, 1, figsize=(13, 8.4))
    band = (fd > 8) & (fd < 60)
    ax[0].plot(fd[band], Ad[band], lw=0.9, label="Liouville-Goldbach data spectrum")
    ax[0].plot(fm[band], -Am[band], lw=0.9, color="crimson", label="Theorem H model (mirrored)")
    for i in range(4):
        ax[0].axvline(gam[i], color="green", lw=0.8, ls="--",
                      label=r"single $\gamma_i$" if i == 0 else None)
    for i in range(4):
        for j in range(i, 4):
            fr = gam[i] + gam[j]
            if fr < 60:
                ax[0].axvline(fr, color="gray", lw=0.5, ls=":",
                              label=r"$\gamma_i+\gamma_j$" if (i, j) == (0, 0) else None)
    ax[0].legend(fontsize=8)
    ax[0].set_title("The scale-degenerate stack: main + single-zero + pair layers all at $X^2$ "
                    "(weights $\\zeta(2\\rho)/\\zeta'(\\rho)$)")
    bd, bm = bandpass(data, 10, 60), bandpass(model, 10, 60)
    ax[1].plot(Xs[core], bd[core], lw=0.7, label="data, band [10,60]")
    ax[1].plot(Xs[core], bm[core], lw=0.7, alpha=0.85, label="model")
    ax[1].set_xscale("log")
    ax[1].set_title("pointwise match of the Liouville pair field against the zero spectrum")
    ax[1].legend(fontsize=8)
    fig.tight_layout()
    fig.savefig(FIG / "exp15_liouville.png", dpi=140)
    print("\nsaved figures/exp15_liouville.png")


if __name__ == "__main__":
    main()
