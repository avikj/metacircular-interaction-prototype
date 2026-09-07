"""Experiment 26: DEEP-WINDOW FRESNEL READING — enlarging the readable gap set.

Open problem 2 of papers/phase_side.md: the Fresnel gap-reading of exp14 was
window-limited (span log(1.9e6/2e4) = 4.55, resolution ~2pi/4.55 = 1.38 rad),
which merged the (1,4) and (2,3) lines (separation 1.47) and corrupted both.
This experiment extends the sieve to 10^7: span log(9.5e6/2e4) = 6.16,
resolution ~1.02 rad — the (1,4)/(2,3) doublet resolves, and further lines
((3,3), (2,4)) enter the readable set.

Same pipeline as exp14 (single-zero layer subtracted with 30k zeros,
phase-sensitive DFT at exact line frequencies, corrected Fresnel inversion
with the 37/(12f) + (1/24)(1/g+1/g') Stirling term).
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
    NMAX = 10_000_000
    lam = sieve_lambda(NMAX)
    r = additive_convolution(lam)
    N = np.arange(len(r), dtype=float)
    R, S = np.cumsum(r), np.cumsum(N * r)
    del r
    gam = load_zeros()

    M = 16384
    logX = np.linspace(np.log(2e4), np.log(9.5e6), M)
    Xs = np.exp(logX)
    Xi = Xs.astype(int)
    G1 = Xs * R[Xi] - S[Xi]
    span = logX[-1] - logX[0]
    print(f"window span = {span:.2f} (exp14: 4.55); resolution ~ {2*np.pi/span:.2f} rad")

    K1 = 30000
    rho1 = 0.5 + 1j * gam[:K1]
    coef = 1.0 / (rho1 * (rho1 + 1) * (rho1 + 2))
    S1 = np.zeros(M)
    for ch in range(0, K1, 2000):
        rr, cc = rho1[ch:ch + 2000], coef[ch:ch + 2000]
        S1 += 2 * np.real(np.exp(np.outer(logX, rr + 2)) @ cc)
    data = (G1 - Xs ** 3 / 6 + 2 * S1) / Xs ** 2

    win = np.hanning(M)
    y = (data - np.polyval(np.polyfit(logX, data, 3), logX)) * win

    def dft(f):
        return np.sum(y * np.exp(-1j * f * logX))

    def recover(f, phi):
        frac0 = np.mod(phi + f * np.log(2) + 5 * np.pi / 4, 2 * np.pi)
        dg = np.sqrt(max(2 * f * frac0, 0.0))
        for _ in range(4):
            gi, gj = (f + dg) / 2, max((f - dg) / 2, 1.0)
            corr = 37 / (12 * f) + (1 / gi + 1 / gj) / 24
            dg = np.sqrt(max(2 * f * (frac0 - corr), 0.0))
        return dg

    pairs = [(0, 0), (0, 1), (0, 2), (1, 1), (0, 3), (1, 2), (2, 2), (1, 3)]
    print("\ndeep-window gap recovery (previously unreadable lines marked *):")
    print(f"{'pair':>7} {'f':>8} {'sep_to_nbr':>10} | {'gap rec.':>9} {'gap true':>9} {'err%':>6}")
    allsums = sorted(gam[i] + gam[j] for i in range(8) for j in range(i, 8))
    rec = {}
    for i, j in pairs:
        f = gam[i] + gam[j]
        sep = min(abs(f - x) for x in allsums if abs(f - x) > 1e-9)
        pd = np.angle(dft(f))
        dg_rec = recover(f, pd)
        dg_true = abs(gam[i] - gam[j])
        rec[(i, j)] = dg_rec
        err = (dg_rec - dg_true) / dg_true * 100 if dg_true > 0 else float("nan")
        star = "*" if (i, j) in [(0, 3), (1, 2), (2, 2), (1, 3)] else " "
        print(f"({i+1},{j+1}){star}".rjust(8),
              f"{f:8.3f} {sep:10.2f} | {dg_rec:9.3f} {dg_true:9.3f} {err:6.1f}")

    print("\nzeros recovered from (line positions, line phases), prime data only:")
    for (i, j) in [(0, 1), (0, 2), (0, 3)]:
        f = gam[i] + gam[j]
        print(f"  gamma_{j+1} = {(f + rec[(i,j)])/2:.3f}   (true {gam[j]:.3f})")


if __name__ == "__main__":
    main()
