"""Experiment 23: THE SCREW FUNCTION IS THE MIXED BLOCK — closing the join.

Sibling SCREW.md extracted Matsumoto-Suzuki verbatim: the RH-equivalent
screw function is g_{H1}(t) = H1(e^t) - H1(1), H1(X) = sum_rho
X^{rho-1/2}/(rho(1-rho)), i.e. Krein masses 1/(gamma^2+1/4) on the SINGLE
zeros, attached to the reweighted Goldbach summatory [MS (1.6)]:

    T(X) := sum_{n<=X} (Lambda*Lambda)(n)/n^2
          = log X + c2 + 2 sum_rho X^{rho-1}/(rho(1-rho)) + E(X).

BLOCKS.md S1 (Theorem E2) and PARITY.md S1K predicted independently that the
screw kernel lives in the MIXED (pole x zero, first-variation) block.  This
experiment closes the join numerically: split T(X) by the adelic blocks
(Lambda = Lambda#_Q + Lambda-flat, as exp11) and verify

    [##](T)      = log X + c2            (smooth; no zero lines),
    [mix](T)     = 2 sum_rho X^{rho-1}/(rho(1-rho))   <-- THE SCREW KERNEL,
    [bb](T)      = E(X)-side (pair frequencies, subleading).

CORRECTED per cross-audit (CROSSREVIEW_EXP22_25.md): the identification is
BAND-PASSED, not exact — the per-block constants are Q-dependent artifacts
(the [##] intercept is 2.362/5.141/7.159 at Q=10/30/60), and the true MS
constant is c2 = -2.2803 from the total field.  What holds: the FLUCTUATION
of the mixed block is the fluctuation of the MS screw kernel (corr 1.0000,
ratio 0.9992), the log X main sits in [##] at every Q, and the chirped pair
sector never enters.  Upgrading to an exact identity needs a canonical
smooth subtraction — the open item of the join.
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
    """T(X) = sum_{n<=X} r(n)/n^2 on the log grid."""
    n = np.arange(len(r), dtype=float)
    n[0] = 1.0
    c = np.cumsum(r / n ** 2)
    return c[XI]


def main():
    Q = 30
    mu, phi = mobius_phi(200_000)
    lam = sieve_lambda(NMAX)
    lamS = lambda_sharp(Q, mu, phi)
    lamB = lam - lamS
    lamB[0] = 0.0
    gam = load_zeros()

    T_SS = t_of(conv2(lamS, lamS))
    T_mix = 2 * t_of(conv2(lamS, lamB))
    T_BB = t_of(conv2(lamB, lamB))
    T_tot = t_of(conv2(lam, lam))
    closure = np.max(np.abs(T_SS + T_mix + T_BB - T_tot) / np.abs(T_tot))
    print(f"exact closure of the reweighted field: {closure:.2e}")

    # screw kernel model: 2 sum_rho X^{rho-1}/(rho(1-rho)), 30k zeros
    K1 = 30_000
    rho = 0.5 + 1j * gam[:K1]
    coef = 1.0 / (rho * (1 - rho))
    S = np.zeros(M)
    for ch in range(0, K1, 2000):
        rr, cc = rho[ch:ch + 2000], coef[ch:ch + 2000]
        S += 2 * np.real(np.exp(np.outer(LOGX, rr - 1)) @ cc)
    # 2Re over upper zeros folds the conjugates (= sum over all rho); the
    # remaining factor 2 is MS's own, from (1.6):
    screw_model = 2 * S

    def prep(y):
        return y - np.polyval(np.polyfit(LOGX, y, 3), LOGX)

    def bandpass(y, lo, hi):
        Y = np.fft.rfft(prep(y))
        f = np.fft.rfftfreq(M, d=(LOGX[1] - LOGX[0])) * 2 * np.pi
        Y[(f < lo) | (f > hi)] = 0
        return np.fft.irfft(Y, M)

    core = slice(M // 8, -M // 8)
    SINGLE = (10.0, 27.5)
    bd, bm = bandpass(T_mix, *SINGLE), bandpass(screw_model, *SINGLE)
    corr = np.corrcoef(bd[core], bm[core])[0, 1]
    ratio = np.std(bd[core]) / np.std(bm[core])
    print(f"[mix](T) vs screw kernel 2*sum X^(rho-1)/(rho(1-rho)), band {SINGLE}:")
    print(f"    corr = {corr:.4f},  amplitude ratio = {ratio:.4f}")

    # [##] smooth: fit log X + c2
    A = np.vstack([LOGX, np.ones(M)]).T
    sol, res, *_ = np.linalg.lstsq(A, T_SS, rcond=None)
    fitres = T_SS - A @ sol
    print(f"[##](T) = a*logX + intercept:  a = {sol[0]:.4f} (pred 1),  "
          f"intercept = {sol[1]:.4f}  [NB Q-DEPENDENT ARTIFACT, not MS's c2: "
          f"2.362/5.141/7.159 at Q=10/30/60 — see CROSSREVIEW_EXP22_25];"
          f"  residual rms = {np.std(fitres):.5f}")
    c2_true = np.mean(T_tot - LOGX - screw_model)
    print(f"true MS constant from the TOTAL field: c2 = {c2_true:.4f} "
          f"(audit + sibling SCREW.md: -2.280)")
    print(f"[##] band RMS in single band: {np.std(bandpass(T_SS,*SINGLE)[core]):.2e} "
          f"(spectrally dead)")
    print(f"[bb] band RMS in single band: {np.std(bandpass(T_BB,*SINGLE)[core]):.2e}, "
          f"in pair band [28.5,60]: {np.std(bandpass(T_BB,28.5,60)[core]):.2e}")
    print(f"[mix] RMS: {np.std(bd[core]):.2e}  — the screw kernel is the mixed block")

    fig, ax = plt.subplots(2, 1, figsize=(13, 8))
    ax[0].plot(XS[core], bd[core] * np.sqrt(XS[core]), lw=0.7,
               label=r"$\sqrt{X}\cdot$[mix]$(T)$, band [10,27.5]")
    ax[0].plot(XS[core], bm[core] * np.sqrt(XS[core]), lw=0.7, alpha=0.85,
               label=r"$\sqrt{X}\cdot 2\sum_\rho X^{\rho-1}/(\rho(1-\rho))$ (screw kernel)")
    ax[0].set_xscale("log"); ax[0].legend(fontsize=8)
    ax[0].set_title("the Matsumoto–Suzuki screw function is the mixed (first-variation) block")
    ax[1].plot(XS, T_SS, lw=0.9, label="[##](T) data")
    ax[1].plot(XS, A @ sol, "--", lw=0.9, color="crimson",
               label=f"log X + {sol[1]:.3f}")
    ax[1].set_xscale("log"); ax[1].legend(fontsize=8)
    ax[1].set_title("[##](T) = log X + c2: the BC block carries the MS main term")
    fig.tight_layout()
    fig.savefig(FIG / "exp23_screwjoin.png", dpi=140)
    print("\nsaved figures/exp23_screwjoin.png")


if __name__ == "__main__":
    main()
