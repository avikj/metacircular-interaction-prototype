"""Experiment 19: TERNARY GOLDBACH AS THE CALIBRATION POINT OF THE PROGRAM.

The cubic (k=1 Cesaro-smoothed) ternary field is

    G2(X) = sum_{a,b,c} Lambda(a)Lambda(b)Lambda(c) (X-a-b-c)_+ .

Three applications of the explicit formula and the Liouville-Dirichlet integral
give (see notes/TERNARY.md) the exact layer structure

    G2(X) =  X^4/24                                                   [main]
           - 3 sum_rho X^{rho+3} / (rho(rho+1)(rho+2)(rho+3))         [1st variation]
           + 3 sum_{rho,rho'} G(rho)G(rho')/G(rho+rho'+3) X^{rho+rho'+2}   [2nd]
           -   sum_{rho,rho',rho''} G..G../G(sum+2) X^{sum rho + 1}   [3rd]
           + smooth O(X^3) layers,

with the binomial coefficients (1,3,3,1) of (dx - dE)^3.  This experiment
verifies, on Lambda to 3e5 (cube convolution by FFT, ~2^20 padding):

  (i)  main term: G2 * 24 / X^4 -> 1;
  (ii) FIRST variation: the residual (G2 - X^4/24), band-passed to the
       single-zero band, matches the unit single-rho model with coefficient 3;
       subtracting 3*S1 collapses the (detrended) rms;
  (iii) SECOND variation: what remains oscillates at the PAIR frequencies
       gamma_i + gamma_j, and its band-passed amplitude against the UNIT pair
       model (weights G(rho)G(rho')/G(rho+rho'+3)) is 3 -- versus the binary
       case's coefficient 1, recomputed here on the same Lambda range with the
       binary weights G(rho)G(rho')/G(rho+rho'+2) (exp6b methodology).

So the ternary variation coefficients (3, 3) are read off the data next to the
binary (2, 1) of exp13/exp6b: same zeros, same bands, one more convolution.
"""
import numpy as np
from scipy.special import loggamma
import matplotlib
matplotlib.use("Agg")
import matplotlib.pyplot as plt
from pathlib import Path
from pairfield import sieve_lambda, load_zeros, additive_convolution

FIG = Path(__file__).resolve().parent.parent / "figures"

NMAX = 300_000
M = 8192                       # log-grid points
K1 = 10_000                    # zeros in the single-zero layers
K2 = 800                       # zeros (each sign) in the pair models
SINGLE_BAND = (10.0, 24.0)     # contains gamma_1 .. gamma_3
PAIR_BAND = (26.0, 250.0)      # starts above gamma_max single line used below


def cube_convolution(a):
    """r3(N) = sum_{a+b+c=N} a_a a_b a_c via FFT (length 3n-2)."""
    n = len(a)
    L = 1
    while L < 3 * n:
        L *= 2
    fa = np.fft.rfft(a, L)
    return np.fft.irfft(fa ** 3, L)[: 3 * n - 2]


def cesaro1(r, Xs):
    """sum_{N<=X} (X-N) r(N)  (exact for real X; k=1 Cesaro)."""
    N = np.arange(len(r), dtype=float)
    R, S = np.cumsum(r), np.cumsum(N * r)
    Xi = Xs.astype(int)
    return Xs * R[Xi] - S[Xi]


def single_layer(logX, gam, poles):
    """sum_rho X^{rho+poles[-1]-... } -- returns 2 Re sum_{gamma>0} X^{rho+m}/prod(rho+j, j=0..m)
    where m = poles-1; i.e. poles=4 -> X^{rho+3}/(rho(rho+1)(rho+2)(rho+3))."""
    out = np.zeros(len(logX))
    m = poles - 1
    for ch in range(0, len(gam), 2000):
        rho = 0.5 + 1j * gam[ch:ch + 2000]
        den = np.ones_like(rho)
        for j in range(poles):
            den = den * (rho + j)
        out += 2 * np.real(np.exp(np.outer(logX, rho + m)) @ (1.0 / den))
    return out


def pair_model(logX, gam, denom_shift):
    """UNIT-coefficient pair sum  sum_{rho,rho'} G(rho)G(rho')/G(rho+rho'+denom_shift)
    X^{i(gamma+gamma')}, both signs of gamma, at the leading scale (X^{rho+rho'+...}
    / X^{2Re rho + ...} stripped, i.e. we return the oscillatory factor only)."""
    sgn = np.concatenate([gam[:K2], -gam[:K2]])
    rr = 0.5 + 1j * sgn
    LG = loggamma(rr)
    W = np.exp(LG[:, None] + LG[None, :]
               - loggamma(rr[:, None] + rr[None, :] + denom_shift))
    out = np.empty(len(logX))
    for c0 in range(0, len(logX), 256):
        E = np.exp(1j * np.outer(logX[c0:c0 + 256], sgn))
        out[c0:c0 + 256] = np.real(np.einsum("ij,ij->i", E @ W, E))
    return out


def spec(logX, y):
    """Hann-windowed amplitude spectrum after cubic detrend in log X."""
    y = y - np.polyval(np.polyfit(logX, y, 3), logX)
    Y = np.fft.rfft(y * np.hanning(len(y)))
    f = np.fft.rfftfreq(len(y), d=(logX[1] - logX[0])) * 2 * np.pi
    return f, np.abs(Y)


def bandpass(logX, y, lo, hi):
    y = y - np.polyval(np.polyfit(logX, y, 3), logX)
    Y = np.fft.rfft(y)
    f = np.fft.rfftfreq(len(y), d=(logX[1] - logX[0])) * 2 * np.pi
    Y[(f < lo) | (f > hi)] = 0
    return np.fft.irfft(Y, len(y))


def detrended_rms(logX, y):
    y = y - np.polyval(np.polyfit(logX, y, 3), logX)
    return np.sqrt(np.mean(y ** 2))


def main():
    lam = sieve_lambda(NMAX)
    gam = load_zeros()
    logX = np.linspace(np.log(1.5e4), np.log(2.9e5), M)
    Xs = np.exp(logX)
    core = slice(M // 8, -M // 8)      # away from filter edges

    # ---- ternary field ----------------------------------------------------
    r3 = cube_convolution(lam)         # exact for N <= NMAX
    G2 = cesaro1(r3, Xs)

    # (i) main term X^4/24
    print("(i) main term:  X        G2*24/X^4")
    for x in [3e4, 1e5, 2e5, 2.9e5]:
        i = np.argmin(np.abs(Xs - x))
        print(f"           {Xs[i]:9.3e}  {G2[i] * 24 / Xs[i] ** 4:.5f}")

    # (ii) first variation: coefficient 3 on the single-zero layer
    S1 = single_layer(logX, gam[:K1], poles=4)         # sum_rho X^{rho+3}/(rho..rho+3)
    resid1 = (G2 - Xs ** 4 / 24) / Xs ** 3.5
    model1u = -S1 / Xs ** 3.5                          # unit coefficient
    b_d = bandpass(logX, resid1, *SINGLE_BAND)
    b_m = bandpass(logX, model1u, *SINGLE_BAND)
    c1 = np.corrcoef(b_d[core], b_m[core])[0, 1]
    a1 = np.std(b_d[core]) / np.std(b_m[core])
    print(f"\n(ii) 1st variation, single band {SINGLE_BAND}: corr = {c1:.4f}, "
          f"coefficient = {a1:.3f}   (predicted 3)")
    rms_before = detrended_rms(logX, resid1)
    rms_after = detrended_rms(logX, (G2 - Xs ** 4 / 24 + 3 * S1) / Xs ** 3.5)
    print(f"     rms at X^3.5 scale: before subtracting 3*S1: {rms_before:.3e}, "
          f"after: {rms_after:.3e}  (drop x{rms_before / rms_after:.0f})")

    # (iii) second variation: coefficient 3 on the pair layer
    data_t = (G2 - Xs ** 4 / 24 + 3 * S1) / Xs ** 3
    model_t_unit = pair_model(logX, gam, denom_shift=3)
    bt_d = bandpass(logX, data_t, *PAIR_BAND)
    bt_m = bandpass(logX, model_t_unit, *PAIR_BAND)
    c2 = np.corrcoef(bt_d[core], bt_m[core])[0, 1]
    a2 = np.std(bt_d[core]) / np.std(bt_m[core])
    print(f"\n(iii) 2nd variation, pair band {PAIR_BAND}: corr = {c2:.4f}, "
          f"coefficient = {a2:.3f}   (predicted 3)")

    # ---- binary reference on the SAME Lambda range and grid ---------------
    r2 = additive_convolution(lam)
    G1 = cesaro1(r2, Xs)
    S1b = single_layer(logX, gam[:K1], poles=3)        # X^{rho+2}/(rho(rho+1)(rho+2))
    data_b = (G1 - Xs ** 3 / 6 + 2 * S1b) / Xs ** 2
    model_b_unit = pair_model(logX, gam, denom_shift=2)
    bb_d = bandpass(logX, data_b, *PAIR_BAND)
    bb_m = bandpass(logX, model_b_unit, *PAIR_BAND)
    cb = np.corrcoef(bb_d[core], bb_m[core])[0, 1]
    ab = np.std(bb_d[core]) / np.std(bb_m[core])
    print(f"\nbinary reference, same band: corr = {cb:.4f}, "
          f"coefficient = {ab:.3f}   (predicted 1)")
    print(f"\nternary/binary pair coefficient ratio = {a2 / ab:.3f}   (predicted 3)")

    # individual pair lines (ternary)
    fd, Ad = spec(logX, data_t)
    fm, Am = spec(logX, model_t_unit)
    print("\nternary pair lines (amp ratio data / 3*unit-model):")
    for fr in [2 * gam[0], gam[0] + gam[1], 2 * gam[1], gam[0] + gam[2]]:
        i_d = np.argmin(np.abs(fd - fr))
        print(f"  line at {fr:7.3f}: ratio {Ad[i_d] / (3 * Am[i_d]):.3f}")

    # ---- figure -----------------------------------------------------------
    fig, ax = plt.subplots(3, 1, figsize=(13, 12))
    band = (fd > 8) & (fd < 60)
    ax[0].plot(fd[band], Ad[band] / Ad[band].max(), lw=0.9,
               label="ternary residual spectrum (main + 3*single removed)")
    ax[0].plot(fm[band], -Am[band] / Am[band].max(), lw=0.9, color="crimson",
               label="unit pair model (mirrored)")
    marks = sorted(gam[i] + gam[j] for i in range(10) for j in range(i, 10)
                   if 8 < gam[i] + gam[j] < 60)
    for k, fr in enumerate(marks):
        ax[0].axvline(fr, color="gray", lw=0.5, ls=":",
                      label=r"$\gamma_i+\gamma_j$" if k == 0 else None)
    for i in range(4):
        if 8 < gam[i] < 60:
            ax[0].axvline(gam[i], color="green", lw=1.0, ls="--",
                          label=r"single $\gamma_i$ (absent)" if i == 0 else None)
    ax[0].set_xlabel("frequency in log X")
    ax[0].legend(fontsize=8)
    ax[0].set_title(r"Ternary $G_2$ residual: lines at pair sums $\gamma_i+\gamma_j$,"
                    " single-zero lines removed by the coefficient-3 layer")

    ax[1].plot(Xs[core], bt_d[core], lw=0.7, label="ternary data, pair band")
    ax[1].plot(Xs[core], 3 * bt_m[core], lw=0.7, alpha=0.85,
               label=r"3 $\times$ unit pair model")
    ax[1].set_xscale("log")
    ax[1].set_xlabel("X")
    ax[1].legend(fontsize=8)
    ax[1].set_title(f"Second variation carries coefficient 3: corr = {c2:.3f}, "
                    f"fitted coefficient = {a2:.3f}")

    names = ["binary pair\n(pred 1)", "ternary single\n(pred 3)",
             "ternary pair\n(pred 3)"]
    vals = [ab, a1, a2]
    preds = [1, 3, 3]
    bars = ax[2].bar(names, vals, color=["#888", "#4477aa", "#cc6677"], width=0.5)
    for b, p in zip(bars, preds):
        ax[2].hlines(p, b.get_x() - 0.08, b.get_x() + b.get_width() + 0.08,
                     color="k", ls="--", lw=1.0)
    for b, v in zip(bars, vals):
        ax[2].text(b.get_x() + b.get_width() / 2, v + 0.05, f"{v:.3f}",
                   ha="center", fontsize=9)
    ax[2].set_ylabel("fitted coefficient")
    ax[2].set_title("Variation coefficients: binomial (3,3) of $(dx-dE)^3$ vs "
                    "binary (2,1) -- dashed = predicted")
    fig.tight_layout()
    fig.savefig(FIG / "exp19_ternary.png", dpi=140)
    print("\nsaved figures/exp19_ternary.png")


if __name__ == "__main__":
    main()
