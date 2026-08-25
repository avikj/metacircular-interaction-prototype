"""Experiment 42: BLIND EXTRACTION OF THE ZETA ZEROS FROM MOBIUS DATA.

Answers the standing criticism of this branch's headline (auditor
CROSSREVIEW_WAVE2 S1.1): every gap recovery so far evaluated phases at pair
frequencies TAKEN FROM THE ZERO TABLE, so "positions give sums, phases give
differences" was half-demonstrated — the sums were assumed.

Two changes make it fully blind:

1. **Dressing.** Use the MOBIUS field (Theorem H'): 1/zeta has no pole, so
   G1^mu(X)/X^2 is the pair layer with NO main term and NO single-zero
   layer.  Nothing has to be subtracted using known zeros — the zero-informed
   foreground step of exp14 disappears by construction.

2. **Estimator.** Replace the DFT/band-pass (a Fourier-limited dictionary
   method) by ESPRIT / matrix-pencil (Roy-Kailath 1989; Hua-Sarkar 1990):
   for uniformly sampled sums of complex exponentials, the shift-invariance
   of the signal subspace yields frequencies as eigenvalues of a small
   matrix — a PARAMETRIC estimator with no grid and no Rayleigh limit
   (resolution bounded instead by SNR, per exp41 / Theorem K0).

Pipeline (no zeta input anywhere before the final comparison):
  mu sieved to NMAX  ->  G1^mu(X) = sum mu(m)mu(n)(X-m-n)_+  ->  divide by
  X^2  ->  remove a low-order polynomial in log X (smooth foreground only)
  ->  analytic signal, band [BAND_LO, BAND_HI]  ->  decimate  ->  ESPRIT at
  model order P  ->  frequencies f_k.

Then, and only then, compare:
  * f_k vs the true pair sums gamma_i + gamma_j;
  * the CHAIN INVERSION gamma_1 = f_1/2, gamma_2 = f_2 - gamma_1,
    gamma_3 = f_3 - gamma_1, ... — the zeta zeros themselves, constructed
    from Mobius data alone;
  * blind resolution vs the Fourier limit 2pi/span (how far past Rayleigh
    the parametric estimator reaches at the arithmetic noise floor).
"""
import numpy as np
import matplotlib
matplotlib.use("Agg")
import matplotlib.pyplot as plt
from pathlib import Path
from pairfield import load_zeros, additive_convolution
from exp16_mobius import sieve_mobius

FIG = Path(__file__).resolve().parent.parent / "figures"

NMAX = 10_000_000
M = 16384
BAND_LO, BAND_HI = 26.0, 50.0
TAPER = 2.0          # raised-cosine roll-off inside each band edge
DECIM = 12
ORDER = 10           # >= number of true lines in the usable band


def esprit(z, P):
    """ESPRIT frequencies (rad/sample) from a complex sample vector."""
    N = len(z)
    K = N // 2
    # Hankel data matrix
    H = np.lib.stride_tricks.sliding_window_view(z, K)[: N - K + 1]
    U, s, _ = np.linalg.svd(H, full_matrices=False)
    Us = U[:, :P]
    A = np.linalg.lstsq(Us[:-1], Us[1:], rcond=None)[0]
    ev = np.linalg.eigvals(A)
    return np.sort(np.angle(ev)), s


def main():
    print("blind pipeline: Mobius sieve -> pair field -> ESPRIT (no zeta input)")
    mob = sieve_mobius(NMAX)
    r = additive_convolution(mob)
    N = np.arange(len(r), dtype=float)
    R, S = np.cumsum(r), np.cumsum(N * r)
    del r

    logX = np.linspace(np.log(2e4), np.log(9.5e6), M)
    Xs = np.exp(logX)
    Xi = Xs.astype(int)
    span = logX[-1] - logX[0]
    du = logX[1] - logX[0]
    data = (Xs * R[Xi] - S[Xi]) / Xs ** 2
    y = data - np.polyval(np.polyfit(logX, data, 4), logX)
    print(f"  span L = {span:.2f}   Fourier (Rayleigh) resolution 2pi/L = "
          f"{2*np.pi/span:.3f} rad")

    # analytic signal restricted to the band (one-sided spectrum)
    Y = np.fft.fft(y)
    freqs = 2 * np.pi * np.fft.fftfreq(M, d=du)
    # smooth (raised-cosine) band so edge truncation cannot manufacture lines
    w = np.zeros(M)
    inb = (freqs >= BAND_LO) & (freqs <= BAND_HI)
    w[inb] = 1.0
    lo_edge = (freqs >= BAND_LO) & (freqs < BAND_LO + TAPER)
    hi_edge = (freqs > BAND_HI - TAPER) & (freqs <= BAND_HI)
    w[lo_edge] = 0.5 * (1 - np.cos(np.pi * (freqs[lo_edge] - BAND_LO) / TAPER))
    w[hi_edge] = 0.5 * (1 - np.cos(np.pi * (BAND_HI - freqs[hi_edge]) / TAPER))
    Ya = 2 * Y * w
    z = np.fft.ifft(Ya)[::DECIM]
    dus = du * DECIM
    print(f"  band [{BAND_LO},{BAND_HI}] rad, decimation {DECIM} -> {len(z)} samples, "
          f"Nyquist {np.pi/dus:.1f} rad")

    ang, sv = esprit(z, ORDER)
    fhat = np.sort(ang / dus)
    fhat = fhat[(fhat > BAND_LO + TAPER) & (fhat < BAND_HI - TAPER)]
    print(f"  singular-value drop at order: "
          + ", ".join(f"{sv[i]/sv[0]:.1e}" for i in range(min(12, len(sv)))))

    # ---------- comparison (first use of zeta data) ----------
    gam = load_zeros()
    truth = np.sort([gam[i] + gam[j] for i in range(8) for j in range(i, 8)])
    truth = truth[(truth > BAND_LO + TAPER) & (truth < BAND_HI - TAPER)]
    names = {}
    for i in range(8):
        for j in range(i, 8):
            names[round(gam[i] + gam[j], 6)] = f"({i+1},{j+1})"
    # match each TRUE line to its nearest blind estimate (unbiased direction)
    print("\nTrue pair sums vs BLIND estimates (nearest blind to each true line):")
    print(f"{'pair':>8} {'true f':>10} {'blind f':>10} {'err':>9} {'err/Rayleigh':>13}")
    rows = []
    for t in truth:
        if len(fhat) == 0:
            break
        f = fhat[np.argmin(np.abs(fhat - t))]
        rows.append((f, t, names[round(t, 6)], f - t))
        print(f"{names[round(t,6)]:>8} {t:>10.4f} {f:>10.4f} {f-t:>+9.4f} "
              f"{(f-t)/(2*np.pi/span):>13.3f}")
    extra = [f for f in fhat if min(abs(f - t) for t in truth) > 0.3]
    print(f"unmatched blind estimates (>0.3 rad from any true line): "
          f"{len(extra)}" + ("  " + ", ".join(f"{x:.3f}" for x in extra) if extra else ""))

    # ---------- chain inversion: the zeros themselves ----------
    print("\nCHAIN INVERSION — zeta zeros from Mobius data alone:")
    got = {n: f for f, t, n, _ in rows}
    if "(1,1)" in got:
        g1 = got["(1,1)"] / 2
        print(f"  gamma_1 = f(1,1)/2      = {g1:9.4f}   (true {gam[0]:.4f}, "
              f"err {g1-gam[0]:+.4f})")
        for j, key in [(1, "(1,2)"), (2, "(1,3)"), (3, "(1,4)")]:
            if key in got:
                gj = got[key] - g1
                print(f"  gamma_{j+1} = f{key} - gamma_1 = {gj:9.4f}   "
                      f"(true {gam[j]:.4f}, err {gj-gam[j]:+.4f})")

    # ---------- resolution achieved ----------
    if len(rows) > 1:
        fs = np.array([r_[0] for r_ in rows])
        ts = np.array([r_[1] for r_ in rows])
        rms = np.sqrt(np.mean((fs - ts) ** 2))
        ray = 2 * np.pi / span
        print(f"\nrms frequency error = {rms:.4f} rad = {rms/ray*100:.1f}% of the "
              f"Rayleigh limit {ray:.3f}  -> localization gain {ray/rms:.1f}x")
        print(f"max |err| = {np.max(np.abs(fs-ts)):.4f} rad "
              f"({np.max(np.abs(fs-ts))/ray*100:.1f}% of Rayleigh)")

    fig, ax = plt.subplots(figsize=(11, 4.6))
    F = np.abs(np.fft.rfft(y * np.hanning(M)))
    ff = 2 * np.pi * np.fft.rfftfreq(M, d=du)
    b = (ff > BAND_LO - 2) & (ff < BAND_HI + 2)
    ax.plot(ff[b], F[b] / F[b].max(), lw=0.8, color="0.6", label="DFT of Mobius data")
    for t in truth:
        ax.axvline(t, color="green", ls="--", lw=0.8)
    for f in fhat:
        ax.axvline(f, color="crimson", lw=1.4)
    ax.plot([], [], color="green", ls="--", label=r"true $\gamma_i+\gamma_j$")
    ax.plot([], [], color="crimson", label="ESPRIT blind estimates")
    ax.set_xlabel("frequency in log X"); ax.legend(fontsize=8)
    ax.set_title("Blind parametric extraction of the zeta sum-spectrum from "
                 "Mobius–Goldbach data (no zero input)")
    fig.tight_layout()
    fig.savefig(FIG / "exp42_esprit.png", dpi=140)
    print("\nsaved figures/exp42_esprit.png")


if __name__ == "__main__":
    main()
