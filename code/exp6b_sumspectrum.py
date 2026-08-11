"""Experiment 6b: READING THE SUM-SPECTRUM OF ZETA ZEROS OFF GOLDBACH AVERAGES.

Take the smoothed Goldbach average G1(X) = sum (X-m-n)_+ Lambda(m)Lambda(n),
remove the main term X^3/6 and ALL single-zero oscillations
2 sum_rho X^{rho+2}/(rho(rho+1)(rho+2)) (frequencies gamma_i in log X).

What remains, at order X^2, is (i) a smooth deterministic layer (frequency ~ 0)
and (ii) the zero-pair term
    sum_{rho,rho'} Gamma(rho)Gamma(rho')/Gamma(rho+rho'+2) X^{rho+rho'+1},
whose log-X frequencies are the PAIR SUMS gamma_i + gamma_j >= 2*gamma_1 = 28.27
(opposite-sign pairs are exponentially suppressed by the Gamma weights).

So the power spectrum of the residual, in the band [25, 300], must consist of
discrete lines located exactly at {gamma_i + gamma_j} with amplitudes given by
the Beta-function weights.  We verify line positions AND amplitudes, then
band-pass both signals and correlate them pointwise.
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
    N = np.arange(len(r), dtype=float)
    R, S = np.cumsum(r), np.cumsum(N * r)
    gam = load_zeros()

    # fine log-grid
    M = 8192
    logX = np.linspace(np.log(2e4), np.log(1.9e6), M)
    Xs = np.exp(logX)
    Xi = Xs.astype(int)
    frac = Xs - Xi
    # linear interpolation of G1 between integers (G1 is piecewise linear in X):
    G1 = Xs * R[Xi] - S[Xi]          # exact for X=Xi + continuation slope R[Xi]
    # G1(X) = G1(Xi) + (X-Xi)*R(Xi) exactly (since d/dX G1 = R(X) between integers)
    # (already what the formula gives: X*R - S is exact for real X)

    # subtract single-zero sum, K1 zeros
    K1 = 30000
    rho1 = 0.5 + 1j * gam[:K1]
    coef = 1.0 / (rho1 * (rho1 + 1) * (rho1 + 2))
    S1 = np.zeros(M)
    for ch in range(0, K1, 2000):
        rr, cc = rho1[ch:ch+2000], coef[ch:ch+2000]
        S1 += 2 * np.real(np.exp(np.outer(logX, rr + 2)) @ cc)

    data = (G1 - Xs ** 3 / 6 + 2 * S1) / Xs ** 2          # residual at X^2 scale

    # model: zero-pair sum / X^2
    K2 = 1200
    g2 = gam[:K2]
    sgn = np.concatenate([g2, -g2])
    rr = 0.5 + 1j * sgn
    LG = loggamma(rr)
    W = np.exp(LG[:, None] + LG[None, :] - loggamma(rr[:, None] + rr[None, :] + 2))
    model = np.zeros(M)
    for i, lx in enumerate(logX):
        v = np.exp(1j * sgn * lx)
        model[i] = np.real(v @ W @ v)

    # spectra with Hann window
    win = np.hanning(M)
    def spec(y):
        y = y - y.mean()
        Y = np.fft.rfft((y - np.polyval(np.polyfit(logX, y, 3), logX)) * win)
        f = np.fft.rfftfreq(M, d=(logX[1] - logX[0])) * 2 * np.pi
        return f, np.abs(Y)
    fd, Ad = spec(data)
    fm, Am = spec(model)

    # band-pass [25, 320] and correlate
    def bandpass(y, lo=25.0, hi=320.0):
        y = y - y.mean()
        Y = np.fft.rfft(y * 1.0)
        f = np.fft.rfftfreq(M, d=(logX[1] - logX[0])) * 2 * np.pi
        Y[(f < lo) | (f > hi)] = 0
        return np.fft.irfft(Y, M)
    bd, bm = bandpass(data), bandpass(model)
    core = slice(M // 8, -M // 8)      # avoid filter edge artifacts
    corr = np.corrcoef(bd[core], bm[core])[0, 1]
    ratio = np.std(bd[core]) / np.std(bm[core])
    print(f"band [25,320] rad in logX:  corr(data, model) = {corr:.4f},  "
          f"amplitude ratio = {ratio:.4f}")

    fig, ax = plt.subplots(2, 1, figsize=(13, 8.4))
    band = (fd > 20) & (fd < 90)
    ax[0].plot(fd[band], Ad[band] / Ad[band].max(), lw=0.9, label="data spectrum")
    ax[0].plot(fm[band], -Am[band] / Am[band].max(), lw=0.9, color="crimson",
               label="zero-pair model (mirrored)")
    # mark pair-sum frequencies
    marks = []
    for i in range(12):
        for j in range(i, 12):
            fr = gam[i] + gam[j]
            if 20 < fr < 90:
                marks.append(fr)
    for k, fr in enumerate(sorted(marks)):
        ax[0].axvline(fr, color="gray", lw=0.5, ls=":",
                      label="gamma_i + gamma_j" if k == 0 else None)
    for i in range(6):   # single-zero frequencies -- should be ABSENT
        if 20 < gam[i] < 90:
            ax[0].axvline(gam[i], color="green", lw=1.0, ls="--",
                          label="single gamma_i (should be absent)" if i == 2 else None)
    ax[0].set_xlabel("frequency in log X"); ax[0].legend(fontsize=8)
    ax[0].set_title("Power spectrum of 2nd-order Goldbach residual: lines at pair sums "
                    r"$\gamma_i+\gamma_j$")

    ax[1].plot(Xs[core], bd[core], lw=0.7, label="data, band-passed")
    ax[1].plot(Xs[core], bm[core], lw=0.7, alpha=0.85, label="zero-pair model, band-passed")
    ax[1].set_xscale("log"); ax[1].set_xlabel("X"); ax[1].legend(fontsize=8)
    ax[1].set_title(f"Pointwise match in pair-sum band: corr = {corr:.3f}, "
                    f"amplitude ratio = {ratio:.3f}")
    fig.tight_layout()
    fig.savefig(FIG / "exp6b_sumspectrum.png", dpi=140)
    print("saved figures/exp6b_sumspectrum.png")

    # amplitude check of the strongest few lines
    for fr in [2 * gam[0], gam[0] + gam[1], 2 * gam[1], gam[0] + gam[2]]:
        i_d = np.argmin(np.abs(fd - fr))
        print(f"line at {fr:7.3f}: data amp {Ad[i_d]:.3e}, model amp {Am[i_d]:.3e}, "
              f"ratio {Ad[i_d]/Am[i_d]:.3f}")

if __name__ == "__main__":
    main()
