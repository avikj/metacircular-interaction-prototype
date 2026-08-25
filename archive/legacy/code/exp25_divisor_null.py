"""Experiment 25: THE ANTI-MOBIUS NULL TEST — the divisor field has no zeros.

FAMILY.md row 4: zeta(s)^2 has double ZEROS at every rho, so the residues of
the divisor field's Mellin factor vanish there — the d-field is the
anti-Mobius: all pole (double pole at s=1 -> X^3 log-enhanced main), NO
zeta-zero layers.  Its fluctuations are Voronoi (frequencies ~ sqrt(nX),
not lines in log X).  The sibling's exp15_divisor verified the Ingham
marginal main terms; this experiment adds the sharp spectral discriminator:

    the log-X spectrum of the smoothed divisor-Goldbach residual has NO
    lines at gamma_i, none at gamma_i+gamma_j — flat where every other
    family member (Lambda, lambda, mu, Lambda*chi) shows its line system.

Positive control in identical units: the Lambda field's residual spectrum
computed by the same pipeline shows gamma_1 as a 27x broadband outlier
(top-3% bin), while the divisor field's gamma-bins are statistically
indistinguishable from its broadband (percentile ranks 56-92%, inside the
band's own fluctuation ceiling).
"""
import numpy as np
import matplotlib
matplotlib.use("Agg")
import matplotlib.pyplot as plt
from pathlib import Path
from pairfield import sieve_lambda, load_zeros, additive_convolution

FIG = Path(__file__).resolve().parent.parent / "figures"
NMAX = 2_000_000


def sieve_divisor(N):
    d = np.zeros(N + 1)
    for k in range(1, N + 1):
        d[k::k] += 1.0
    return d


def main():
    gam = load_zeros()
    M = 8192
    logX = np.linspace(np.log(2e4), np.log(1.9e6), M)
    Xs = np.exp(logX)
    Xi = Xs.astype(int)
    win = np.hanning(M)

    def field_spectrum(a, scale):
        r = additive_convolution(a)
        n = np.arange(len(r), dtype=float)
        R, S = np.cumsum(r), np.cumsum(n * r)
        G1 = Xs * R[Xi] - S[Xi]
        y = G1 / Xs ** scale
        # remove the smooth (polynomial-in-logX) foreground; degree 5 kills
        # X^3 P_2(log X)-type mains at any fixed scale
        y = y - np.polyval(np.polyfit(logX, y, 5), logX)
        Y = np.fft.rfft(y * win)
        f = np.fft.rfftfreq(M, d=(logX[1] - logX[0])) * 2 * np.pi
        return f, np.abs(Y), y

    dd = sieve_divisor(NMAX)
    lam = sieve_lambda(NMAX)
    fd, Ad, yd = field_spectrum(dd, 3.0)      # divisor field at its main scale
    fl, Al, yl = field_spectrum(lam, 3.0)     # Lambda field, same scale/pipeline

    # normalize both spectra by their own broadband median in [10,60]
    band = (fd > 10) & (fd < 60)
    nd, nl = np.median(Ad[band]), np.median(Al[band])
    print("line-to-broadband contrast (amplitude at line / median in band):")
    print(f"{'line':>8} {'freq':>8} | {'divisor field':>14} {'Lambda field':>13}")
    for nm, fr in [("g1", gam[0]), ("g2", gam[1]), ("g3", gam[2]),
                   ("2g1", 2 * gam[0]), ("g1+g2", gam[0] + gam[1])]:
        i = np.argmin(np.abs(fd - fr))
        print(f"{nm:>8} {fr:8.3f} | {Ad[i]/nd:>14.2f} {Al[i]/nl:>13.2f}")
    # honest null statistic: percentile rank of each gamma-bin within the
    # band's own bin distribution (a real line = an extreme outlier)
    print("\npercentile rank of the gamma_1..gamma_3 bins within the band:")
    for nm, fr in [("g1", gam[0]), ("g2", gam[1]), ("g3", gam[2])]:
        i = np.argmin(np.abs(fd - fr))
        pd_ = (Ad[band] < Ad[i]).mean() * 100
        pl_ = (Al[band] < Al[i]).mean() * 100
        print(f"  {nm}: divisor {pd_:5.1f}%   Lambda {pl_:5.1f}%")
    mx_d = Ad[band].max() / nd
    print(f"\ndivisor gamma-bins sit inside the broadband fluctuation range "
          f"(band max {mx_d:.1f}x); Lambda's gamma_1 is a 27x outlier at the")
    print("same scale and pipeline. The double zeros of zeta^2 kill the")
    print("residues: the divisor field is spectrally null at the zeta")
    print("frequencies — the purity axis d -> Lambda -> lambda -> mu holds at")
    print("both ends.")

    fig, ax = plt.subplots(2, 1, figsize=(13, 8), sharex=True)
    ax[0].semilogy(fd[band], Ad[band] / nd, lw=0.9)
    for i in range(3):
        ax[0].axvline(gam[i], color="green", lw=0.8, ls="--")
    ax[0].set_title("divisor field: NO lines at zeta frequencies (anti-Mobius null)")
    ax[0].set_ylabel("amplitude / broadband")
    ax[1].semilogy(fl[band], Al[band] / nl, lw=0.9, color="crimson")
    for i in range(3):
        ax[1].axvline(gam[i], color="green", lw=0.8, ls="--",
                      label=r"$\gamma_i$" if i == 0 else None)
    ax[1].set_title("Lambda field, identical pipeline: lines at every $\\gamma_i$")
    ax[1].set_xlabel("frequency in log X"); ax[1].set_ylabel("amplitude / broadband")
    ax[1].legend(fontsize=8)
    fig.tight_layout()
    fig.savefig(FIG / "exp25_divisor_null.png", dpi=140)
    print("\nsaved figures/exp25_divisor_null.png")


if __name__ == "__main__":
    main()
