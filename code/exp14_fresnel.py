"""Experiment 14: FRESNEL PHASES — READING ZERO *GAPS* OFF GOLDBACH DATA.

The step-back observation (Theorem G).  Expanding the D''' entropy phase about
the equal split p = 1/2  (p = gamma/s, s = gamma+gamma'):

    H(p) = log 2 - 2(p-1/2)^2 + O((p-1/2)^4),   p - 1/2 = (gamma-gamma')/(2s)

    =>  arg c_f = -f log 2 - 5pi/4 + (gamma-gamma')^2 / (2f) + O(dg^4/f^3).

The sum-spectrum atom PHASE carries the DIFFERENCE gamma-gamma' as a Fresnel
(quadratic) chirp.  So the off-diagonal cell of the 2x2 dictionary
(REPORT.md S5.1) is not empty: zero-difference information sits in the phases
of the prime-sum lines — precisely the information every Hermitian statistic
|.|^2 destroys.  Line POSITIONS give sums; line PHASES give differences.

This experiment demonstrates it on the arithmetic data: from the smoothed
Goldbach counts (Lambda to 2*10^6, X <= 1.9*10^6; same pipeline as exp6b), we
measure the complex phases of the resolvable pair lines and RECOVER the zero
gaps |gamma_i - gamma_j| via

    |gamma_i-gamma_j|  =  sqrt( 2 f * wrap_[0,2pi)( phi_measured + f log 2 + 5pi/4 ) ).

No pair-correlation input is used anywhere: the primes are the only data on
the arithmetic side.
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

    M = 8192
    logX = np.linspace(np.log(2e4), np.log(1.9e6), M)
    Xs = np.exp(logX)
    Xi = Xs.astype(int)
    G1 = Xs * R[Xi] - S[Xi]

    K1 = 30000
    rho1 = 0.5 + 1j * gam[:K1]
    coef = 1.0 / (rho1 * (rho1 + 1) * (rho1 + 2))
    S1 = np.zeros(M)
    for ch in range(0, K1, 2000):
        rr, cc = rho1[ch:ch + 2000], coef[ch:ch + 2000]
        S1 += 2 * np.real(np.exp(np.outer(logX, rr + 2)) @ cc)
    data = (G1 - Xs ** 3 / 6 + 2 * S1) / Xs ** 2

    # model pair series (for phase-accuracy comparison only; the recovery
    # below uses the DATA phases)
    K2 = 1200
    sgn = np.concatenate([gam[:K2], -gam[:K2]])
    rr = 0.5 + 1j * sgn
    LG = loggamma(rr)
    W2 = np.exp(LG[:, None] + LG[None, :] - loggamma(rr[:, None] + rr[None, :] + 2))
    model = np.zeros(M)
    E = np.exp(1j * np.outer(sgn, logX))
    for ch in range(0, M, 1024):
        Ec = E[:, ch:ch + 1024]
        model[ch:ch + 1024] = np.real(np.einsum("km,km->m", Ec, W2 @ Ec))

    # identical processing: cubic detrend + Hann window, then DFT at exact
    # atom frequencies.  With a real symmetric window, sum_u w(u) e^{-i f u}
    # picks out c_f with a REAL positive gain at the line => arg Y = arg c_f.
    win = np.hanning(M)

    def prep(y):
        return (y - np.polyval(np.polyfit(logX, y, 3), logX)) * win

    yd, ym = prep(data), prep(model)

    def dft(y, f):
        return np.sum(y * np.exp(-1j * f * logX))

    def wexact(i, j):
        a, b = 0.5 + 1j * gam[i], 0.5 + 1j * gam[j]
        m = 1.0 if i == j else 2.0
        return m * np.exp(loggamma(a) + loggamma(b) - loggamma(a + b + 2))

    def recover(f, phi):
        """Invert the Fresnel law with the next-order Stirling correction
        arg W = -sH(p) - 5pi/4 + 37/(12s) + (1/24)(1/g + 1/g') + O(s^-3),
        iterating since the correction involves the recovered gap."""
        frac0 = np.mod(phi + f * np.log(2) + 5 * np.pi / 4, 2 * np.pi)
        dg = np.sqrt(max(2 * f * frac0, 0.0))
        for _ in range(4):
            gi, gj = (f + dg) / 2, max((f - dg) / 2, 1.0)
            corr = 37 / (12 * f) + (1 / gi + 1 / gj) / 24
            dg = np.sqrt(max(2 * f * (frac0 - corr), 0.0))
        return dg

    pairs = [(0, 0), (0, 1), (0, 2), (1, 1), (0, 3), (1, 2)]
    print("line-by-line phase measurement and gap recovery")
    print(f"{'pair':>7} {'f=gi+gj':>9} | {'phi_data':>9} {'phi_model':>9} "
          f"{'arg c_f':>9} {'asympt.':>9} | {'gap rec.':>9} {'gap true':>9} {'err%':>6}")
    rec, tru = [], []
    for i, j in pairs:
        f = gam[i] + gam[j]
        pd = np.angle(dft(yd, f))
        pm = np.angle(dft(ym, f))
        pe = np.angle(wexact(i, j))
        dg_true = abs(gam[i] - gam[j])
        pa = np.angle(np.exp(1j * (-f * np.log(2) - 5 * np.pi / 4 + dg_true ** 2 / (2 * f))))
        dg_rec = recover(f, pd)      # from DATA phase alone
        err = (dg_rec - dg_true) / dg_true * 100 if dg_true > 0 else np.nan
        rec.append(dg_rec); tru.append(dg_true)
        print(f"({i+1},{j+1})".rjust(7),
              f"{f:9.3f} | {pd:9.3f} {pm:9.3f} {pe:9.3f} {pa:9.3f} | "
              f"{dg_rec:9.3f} {dg_true:9.3f} {err:6.1f}")

    dphase = [np.angle(dft(yd, gam[i] + gam[j]) / dft(ym, gam[i] + gam[j])) for i, j in pairs]
    print(f"\ndata-vs-model phase agreement: rms {np.sqrt(np.mean(np.array(dphase)**2)):.4f} rad "
          f"({np.degrees(np.sqrt(np.mean(np.array(dphase)**2))):.2f} deg)")
    print("\nrecovered individual zeros from (sums, differences) of the first lines:")
    print(f"  gamma_2 = (s_12 + gap_12)/2 = {( (gam[0]+gam[1]) + rec[1] )/2:.3f}   "
          f"(true {gam[1]:.3f})")
    print(f"  gamma_3 = (s_13 + gap_13)/2 = {( (gam[0]+gam[2]) + rec[2] )/2:.3f}   "
          f"(true {gam[2]:.3f})")
    print(f"  gamma_4 = (s_14 + gap_14)/2 = {( (gam[0]+gam[3]) + rec[4] )/2:.3f}   "
          f"(true {gam[3]:.3f})")

    # figure: Fresnel parabola — phase residual vs gap, data points on curve
    fig, ax = plt.subplots(1, 2, figsize=(12, 4.8))
    dgs = np.linspace(0, 20, 200)
    ax[0].plot(dgs, dgs ** 2, color="lightgray", lw=6,
               label=r"Fresnel law $2f\,\varphi = (\Delta\gamma)^2$")
    for (i, j), dgr in zip(pairs, rec):
        ax[0].plot(abs(gam[i] - gam[j]), dgr ** 2, "o", ms=7,
                   label=f"line ({i+1},{j+1})")
    ax[0].set_xlabel(r"true gap $|\gamma_i-\gamma_j|$")
    ax[0].set_ylabel(r"$2f\cdot$ measured phase residual")
    ax[0].set_title("zero gaps read off Goldbach phases ($\\Lambda$ to $2\\cdot10^6$)")
    ax[0].legend(fontsize=8)
    ax[1].bar(np.arange(len(pairs)) - 0.18, tru, 0.36, label="true gap")
    ax[1].bar(np.arange(len(pairs)) + 0.18, rec, 0.36, label="recovered from data phase")
    ax[1].set_xticks(np.arange(len(pairs)),
                     [f"({i+1},{j+1})" for i, j in pairs])
    ax[1].set_title(r"$|\gamma_i-\gamma_j|$: true vs recovered")
    ax[1].legend(fontsize=8)
    fig.tight_layout()
    fig.savefig(FIG / "exp14_fresnel.png", dpi=140)
    print("\nsaved figures/exp14_fresnel.png")


if __name__ == "__main__":
    main()
