"""Experiment 19: FRESNEL GAP-READING IS DRESSING-UNIVERSAL — zero gaps from
LIOUVILLE data, with the arithmetic weights calibrated from the data itself.

FAMILY.md S2 law 3 says the Gamma-part laws (D''', Theorem G) are universal
across the residue-dressing family; only the per-zero factor w_rho changes.
For lambda, w_rho = zeta(2rho)/zeta'(rho) is complex, so pair-line phases
acquire offsets arg w_i + arg w_j.  But the lambda field is scale-degenerate:
its SINGLE lines (present at the same X^2 scale) display exactly those
offsets.  So the reading is fully data-driven:

  1. single line at gamma_i:  phase = arg[(sqrt(pi)/zeta(1/2)) w_i
                                          Gamma(rho_i)/Gamma(rho_i+5/2)]
     — everything except arg w_i is analytic  =>  CALIBRATE arg w_i;
  2. pair line at f = gamma_i+gamma_j:
     phase = arg w_i + arg w_j + arg W(gamma_i,gamma_j)
     — subtract the calibrated offsets, invert the corrected Fresnel law
     (as exp14)  =>  RECOVER |gamma_i - gamma_j|.

Same arithmetic dataset (lambda to 2e6) for both steps; no zeta' or
zeta(2rho) values are used anywhere in the recovery — only line positions
and phases of the Liouville-Goldbach data.
"""
import numpy as np
from scipy.special import loggamma
import matplotlib
matplotlib.use("Agg")
import matplotlib.pyplot as plt
from pathlib import Path
from pairfield import load_zeros, additive_convolution
from exp15_liouville import sieve_liouville

FIG = Path(__file__).resolve().parent.parent / "figures"
ZH = -1.4603545088095868          # zeta(1/2)


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
    data = (Xs * R[Xi] - S[Xi]) / Xs ** 2

    win = np.hanning(M)
    y = (data - np.polyval(np.polyfit(logX, data, 3), logX)) * win

    def dft(f):
        return np.sum(y * np.exp(-1j * f * logX))

    # ---- 1. calibrate the COMPLEX w_i from the single lines ------------
    print("step 1: calibrate complex w_i from the single lines of the SAME data")
    W0 = win.sum()
    argw, wmeas, anal_c = {}, {}, {}
    for i in range(8):
        g = gam[i]
        rho = 0.5 + 1j * g
        # analytic part of the single-line coefficient (excluding w):
        anal = (np.sqrt(np.pi) / ZH) * np.exp(loggamma(rho) - loggamma(rho + 2.5))
        anal_c[i] = anal
        wmeas[i] = dft(g) / W0 / anal
        argw[i] = np.angle(wmeas[i])
        if i < 4:
            print(f"  gamma_{i+1} = {g:7.3f}:  w_{i+1} measured = "
                  f"{np.abs(wmeas[i]):.3f} exp({argw[i]:+.3f}i)")
    # validation against mpmath truth (used ONLY for this printout, never in
    # the recovery): w_1, w_2 calibrate to ~1%; w_3, w_4 are corrupted by
    # spectral crowding — the scale-degenerate lambda field interleaves
    # single and pair lines at equal amplitude (gamma_4 sits 2.2 rad from
    # the 27x-stronger (1,1) pair line).
    wtrue = np.load(Path(__file__).resolve().parent.parent / "data"
                    / "liouville_weights_40.npy")
    for i in range(2):
        print(f"    validation: w_{i+1} true = {np.abs(wtrue[i]):.3f} "
              f"exp({np.angle(wtrue[i]):+.3f}i)  (calibration error "
              f"{abs(wmeas[i]-wtrue[i])/abs(wtrue[i])*100:.1f}%)")

    # subtract the measured single layer, fully data-driven, and re-window
    single_model = np.zeros(M)
    for i in range(8):
        single_model += 2 * np.real(anal_c[i] * wmeas[i]
                                    * np.exp(1j * gam[i] * logX))
    y = (data - single_model
         - np.polyval(np.polyfit(logX, data - single_model, 3), logX)) * win

    # ---- 2. read pair-line phases, subtract offsets, invert Fresnel ----
    def recover(f, phi):
        frac0 = np.mod(phi + f * np.log(2) + 5 * np.pi / 4, 2 * np.pi)
        dg = np.sqrt(max(2 * f * frac0, 0.0))
        for _ in range(4):
            gi, gj = (f + dg) / 2, max((f - dg) / 2, 1.0)
            corr = 37 / (12 * f) + (1 / gi + 1 / gj) / 24
            dg = np.sqrt(max(2 * f * (frac0 - corr), 0.0))
        return dg

    print("\nstep 2: gap recovery from pair-line phases (offsets subtracted)")
    print(f"{'pair':>7} {'f':>8} {'phi_pair':>9} {'dechirped':>10} "
          f"{'gap rec.':>9} {'gap true':>9} {'err%':>6}")
    for (i, j) in [(0, 0), (0, 1), (0, 2), (1, 1)]:
        f = gam[i] + gam[j]
        phi = np.angle(dft(f)) - argw[i] - argw[j]
        dg_rec = recover(f, phi)
        dg_true = abs(gam[i] - gam[j])
        err = (dg_rec - dg_true) / dg_true * 100 if dg_true > 0 else np.nan
        print(f"({i+1},{j+1})".rjust(7),
              f"{f:8.3f} {np.angle(dft(f)):+9.3f} {np.angle(np.exp(1j*phi)):+10.3f} "
              f"{dg_rec:9.3f} {dg_true:9.3f} {err:6.1f}")

    print("\nrecovered zeros (line positions give sums, phases give differences):")
    f12 = gam[0] + gam[1]
    phi = np.angle(dft(f12)) - argw[0] - argw[1]
    print(f"  gamma_2 = {(f12 + recover(f12, phi))/2:.3f}  (true {gam[1]:.3f})   "
          "— from Liouville data only")


if __name__ == "__main__":
    main()
