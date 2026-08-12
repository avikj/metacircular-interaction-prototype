"""Experiment 22: THIRD independent break-attempt at exp6b -- Cesaro level k=2.

Identity under test (k=2 Cesaro weight (X-m-n)^2/2, derived independently via
two applications of the explicit formula and Dirichlet's integral
  iint_{u+v<=X} u^{a-1} v^{b-1} (X-u-v)^2 du dv = Gamma(a)Gamma(b)Gamma(3)/Gamma(a+b+3) X^{a+b+2}):

  G_2(X) := (1/2) sum_{m+n<=X} Lambda(m)Lambda(n) (X-m-n)^2
          =  X^4/24
           - 2 sum_rho X^{rho+3} / (rho(rho+1)(rho+2)(rho+3))
           + sum_{rho,rho'} Gamma(rho)Gamma(rho')/Gamma(rho+rho'+3) X^{rho+rho'+2}
           + smooth lower order.

Weight law (Stirling, same-sign ordinates):  |W2| ~ sqrt(2pi) (gamma+gamma')^{-7/2}
(one power of |4+i(gamma+gamma')| steeper than the k=1 law (gamma+gamma')^{-5/2});
opposite-sign pairs exponentially suppressed.

k-dependence: at a pair line f = gamma+gamma' the amplitude ratio between the
k=2 residual (normalized /X^3) and the k=1 residual (normalized /X^2) is exactly
  |Gamma(rho+rho'+2)/Gamma(rho+rho'+3)| = 1/|rho+rho'+2| = 1/|3+i f|   (RH)
(the standing-challenge text wrote 1/|2+if|, which drops Re(rho+rho')=1; the two
differ by <0.4% in band -- we test both and report which fits).

Fresh pipeline -- shares NOTHING with exp6b / redteam_sumspectrum:
  primes to 4e6 (exp6b: 2e6, redteam: 3e6); grid [5e4, 3.8e6] with M=9000
  (theirs: [2e4,1.9e6]x8192 and [4e4,2.7e6]x6000); single-zero layer 40k zeros
  (theirs 30k / 50k); pair model 1300 zeros/sign (theirs 1200 / 1500);
  long-double cumulants; line amplitudes by JOINT Hann-weighted least-squares
  fit of the full known line list (theirs: FFT-bin readout / single-line
  Blackman projection); band [27,305] raised-cosine; detrend degree 5.
"""
import numpy as np
from scipy.special import loggamma
import matplotlib
matplotlib.use("Agg")
import matplotlib.pyplot as plt
from pathlib import Path

HERE = Path(__file__).resolve().parent
FIG = HERE.parent / "figures"
DATA = HERE.parent / "data"

NMAX = 4_000_000
M = 9000
XLO, XHI = 5.0e4, 3.8e6
K1 = 40_000          # zeros in the single-zero layers
K2 = 1300            # zeros per sign in the pair models
BAND = (27.0, 305.0)


# ----------------------------------------------------------------- fresh tools
def vonmangoldt(N):
    """Lambda(n), 0..N. Written fresh: prime sieve first, then power loop."""
    isp = np.ones(N + 1, dtype=bool)
    isp[:2] = False
    for p in range(2, int(N ** 0.5) + 1):
        if isp[p]:
            isp[p * p:: p] = False
    lam = np.zeros(N + 1)
    primes = np.nonzero(isp)[0]
    lam[primes] = np.log(primes)
    for p in primes[primes <= int(N ** 0.5) + 1]:
        q = p * p
        while q <= N:
            lam[q] = np.log(p)
            q *= p
    return lam


def selfconv(a):
    """sum_{m+n=N} a_m a_n, N = 0..2 len(a)-2, via one rfft (fresh impl)."""
    L = 1 << int(np.ceil(np.log2(2 * len(a))))
    fa = np.fft.rfft(a, L)
    return np.fft.irfft(fa * fa, L)[: 2 * len(a) - 1]


def main():
    gam = np.loadtxt(DATA / "odlyzko_zeros_100k.txt")

    print("sieving Lambda to", NMAX)
    lam = vonmangoldt(NMAX)
    r = selfconv(lam)[: int(XHI) + 2]          # complete for N <= NMAX

    # cumulants in long double: R0 = sum r, R1 = sum N r, R2 = sum N^2 r
    Nl = np.arange(len(r), dtype=np.longdouble)
    rl = r.astype(np.longdouble)
    R0 = np.cumsum(rl)
    R1 = np.cumsum(Nl * rl)
    R2 = np.cumsum(Nl * Nl * rl)

    logX = np.linspace(np.log(XLO), np.log(XHI), M)
    Xs = np.exp(logX)
    Xi = Xs.astype(int)
    Xl = Xs.astype(np.longdouble)

    # exact piecewise evaluation of the Cesaro sums at real X:
    G1 = Xl * R0[Xi] - R1[Xi]
    G2 = 0.5 * (Xl * Xl * R0[Xi] - 2.0 * Xl * R1[Xi] + R2[Xi])

    # single-zero layers (K1 zeros), one exp pass shared between k=1 and k=2
    rho = 0.5 + 1j * gam[:K1]
    c1 = 1.0 / (rho * (rho + 1) * (rho + 2))
    c2 = c1 / (rho + 3)
    S1_1 = np.zeros(M)
    S1_2 = np.zeros(M)
    for a in range(0, K1, 2500):
        rr = rho[a: a + 2500]
        E2 = np.exp(np.outer(logX, rr + 2))          # X^{rho+2}
        S1_1 += np.real(E2 @ c1[a: a + 2500])
        S1_2 += np.real((E2 * Xs[:, None]) @ c2[a: a + 2500])   # X^{rho+3}

    # identity coefficient is -2 sum over ALL rho = -4 Re sum_{gamma>0}:
    data1 = np.asarray((G1 - Xl ** 3 / 6) / Xl ** 2, dtype=float) + 4 * S1_1 / Xs ** 2
    data2 = np.asarray((G2 - Xl ** 4 / 24) / Xl ** 3, dtype=float) + 4 * S1_2 / Xs ** 3

    # pair models, k=1 and k=2, signed ordinates
    sgn = np.concatenate([gam[:K2], -gam[:K2]])
    rr = 0.5 + 1j * sgn
    LG = loggamma(rr)
    ssum = rr[:, None] + rr[None, :]
    W1 = np.exp(LG[:, None] + LG[None, :] - loggamma(ssum + 2))
    W2 = np.exp(LG[:, None] + LG[None, :] - loggamma(ssum + 3))
    model1 = np.zeros(M)
    model2 = np.zeros(M)
    for a in range(0, M, 1500):
        V = np.exp(1j * np.outer(logX[a: a + 1500], sgn))
        model1[a: a + 1500] = np.real(np.sum((V @ W1) * V, axis=1))
        model2[a: a + 1500] = np.real(np.sum((V @ W2) * V, axis=1))

    # ------------------------------------------------ band-pass and correlate
    dlx = logX[1] - logX[0]
    freqs = np.fft.rfftfreq(M, d=dlx) * 2 * np.pi

    def detrend(y, deg=5):
        return y - np.polyval(np.polyfit(logX, y, deg), logX)

    def bandpass(y, lo, hi, edge=6.0):
        Y = np.fft.rfft(detrend(y))
        H = np.zeros_like(freqs)
        H[(freqs >= lo) & (freqs <= hi)] = 1.0
        up = (freqs > lo - edge) & (freqs < lo)
        dn = (freqs > hi) & (freqs < hi + edge)
        H[up] = 0.5 * (1 - np.cos(np.pi * (freqs[up] - (lo - edge)) / edge))
        H[dn] = 0.5 * (1 + np.cos(np.pi * (freqs[dn] - hi) / edge))
        return np.fft.irfft(Y * H, M)

    core = slice(M // 6, -M // 6)
    b_d2, b_m2 = bandpass(data2, *BAND), bandpass(model2, *BAND)
    b_d1, b_m1 = bandpass(data1, *BAND), bandpass(model1, *BAND)
    corr2 = np.corrcoef(b_d2[core], b_m2[core])[0, 1]
    rat2 = np.std(b_d2[core]) / np.std(b_m2[core])
    corr1 = np.corrcoef(b_d1[core], b_m1[core])[0, 1]
    rat1 = np.std(b_d1[core]) / np.std(b_m1[core])
    print(f"k=2 band {BAND}: corr = {corr2:.5f}, amplitude ratio = {rat2:.4f}")
    print(f"k=1 band {BAND}: corr = {corr1:.5f}, amplitude ratio = {rat1:.4f}  (reference)")

    # ------------------------------------- joint least-squares line amplitudes
    # design: all pair-sum lines from first 14 zeros with f<=95 + Legendre trend,
    # uniform weights (grid resolution 2pi/4.33 = 1.45 rad); frequencies closer
    # than 0.6 rad merged. NOTE (validated on the pure model): adding single-gamma
    # columns interlaces the pair lines at ~1 rad spacing and the resulting
    # correlated chain is ill-conditioned -- coefficient blow-up 9x-70x at
    # 2g2/g2+g3; pairs-only recovers all five exact amplitudes to <1.3%.
    raw = []
    for i in range(14):
        for j in range(i, 14):
            f = gam[i] + gam[j]
            if f <= 95:
                raw.append(f)
    raw = sorted(raw)
    merged = [raw[0]]
    for f in raw[1:]:
        if f - merged[-1] > 0.6:
            merged.append(f)
    lines = [f for f in merged if f >= 25]           # for the figure marks
    allf = np.array(merged)
    t = np.linspace(-1, 1, M)
    cols = [np.polynomial.legendre.legvander(t, 5)]
    for f in allf:
        cols.append(np.column_stack([np.cos(f * logX), np.sin(f * logX)]))
    A = np.hstack(cols)

    def line_amps(y):
        sol, *_ = np.linalg.lstsq(A, detrend(y), rcond=1e-8)
        amps = {}
        for kk, f in enumerate(allf):
            a, b = sol[6 + 2 * kk], sol[6 + 2 * kk + 1]
            amps[f] = np.hypot(a, b)
        return amps

    amps_d2, amps_m2 = line_amps(data2), line_amps(model2)
    amps_d1, amps_m1 = line_amps(data1), line_amps(model1)

    tests = [(2 * gam[0], "2g1"), (gam[0] + gam[1], "g1+g2"),
             (gam[0] + gam[2], "g1+g3"), (2 * gam[1], "2g2"),
             (gam[1] + gam[2], "g2+g3")]
    print("\nk=2 individual lines (joint weighted-LSQ amplitudes):")
    n_ok = 0
    line_rows = []
    for f, name in tests:
        q = amps_d2[f] / amps_m2[f]
        n_ok += abs(q - 1) < 0.02
        line_rows.append((name, f, amps_d2[f], amps_m2[f], q))
        print(f"  {name:6s} f={f:7.3f}: data {amps_d2[f]:.4e}  model {amps_m2[f]:.4e}"
              f"  ratio {q:.4f}")
    print(f"  lines within 2%: {n_ok} of {len(tests)}")

    # ------------------------------------------------ k-dependence of weights
    print("\nk-ratio test at strongest 3 lines: data amp(k=2)/amp(k=1) vs theory")
    print("  line     f      measured   1/|3+if|   1/|2+if|   meas/(1/|3+if|)")
    kratio_rows = []
    for f, name in tests[:3]:
        meas = amps_d2[f] / amps_d1[f]
        th3 = 1.0 / abs(3 + 1j * f)
        th2 = 1.0 / abs(2 + 1j * f)
        kratio_rows.append((name, f, meas, th3, th2))
        print(f"  {name:6s} {f:7.3f}  {meas:.6f}  {th3:.6f}  {th2:.6f}   {meas/th3:.4f}")
    print(f"  model-side LSQ check: amp_m2/amp_m1 vs 1/|3+if|: ",
          ", ".join(f"{amps_m2[f]/amps_m1[f]/(1/abs(3+1j*f)):.5f}" for f, _ in tests[:3]))
    # exact-weight check, no readout involved: enumerate pairs in +-0.02 of line
    fpair = (sgn[:, None] + sgn[None, :]).ravel()
    w1f, w2f = W1.ravel(), W2.ravel()
    print("  exact-weight check |sum W2|/|sum W1| vs 1/|3+if|: ",
          ", ".join(f"{abs(np.sum(w2f[np.abs(fpair-f)<.02]))/abs(np.sum(w1f[np.abs(fpair-f)<.02]))/(1/abs(3+1j*f)):.6f}"
                    for f, _ in tests[:3]))

    # ------------------------------------------------ weight-decay slope (7/2)
    K3 = 320
    g3 = gam[:K3]
    r3 = 0.5 + 1j * g3
    L3 = loggamma(r3)
    lw = np.real(L3[:, None] + L3[None, :]
                 - loggamma(r3[:, None] + r3[None, :] + 3))
    fs = (g3[:, None] + g3[None, :]).ravel()
    lw = lw.ravel()
    keep = fs > 40
    slope, icpt = np.polyfit(np.log(fs[keep]), lw[keep] / np.log(10) * np.log(10), 1)
    # fit in natural logs:
    slope = np.polyfit(np.log(fs[keep]), lw[keep], 1)[0]
    print(f"\nsame-sign |W2| decay: fitted slope {slope:.4f}  (predicted -3.5)")

    # ------------------------------------------------- spectra (padded, display)
    kais = np.kaiser(M, 9.0)
    NP = 8 * M
    fpad = np.fft.rfftfreq(NP, d=dlx) * 2 * np.pi

    def spec(y):
        return np.abs(np.fft.rfft(detrend(y) * kais, NP))

    sp_d, sp_m = spec(data2), spec(model2)

    # ----------------------------------------------------------------- figure
    fig, ax = plt.subplots(3, 1, figsize=(13, 12))
    band = (fpad > 22) & (fpad < 92)
    ax[0].plot(fpad[band], sp_d[band] / sp_d[band].max(), lw=0.9, label="k=2 data spectrum")
    ax[0].plot(fpad[band], -sp_m[band] / sp_m[band].max(), lw=0.9, color="crimson",
               label="k=2 zero-pair model (mirrored)")
    first = True
    for f in lines:
        if 22 < f < 92:
            ax[0].axvline(f, color="gray", lw=0.5, ls=":",
                          label="pair sums $\\gamma_i+\\gamma_j$" if first else None)
            first = False
    for g in gam[:6]:
        if 22 < g < 92:
            ax[0].axvline(g, color="green", lw=1.0, ls="--",
                          label="single $\\gamma_i$ (should be absent)" if g == gam[2] else None)
    ax[0].set_xlabel("frequency in log X")
    ax[0].legend(fontsize=8)
    ax[0].set_title("k=2 Cesàro Goldbach residual: spectral lines at pair sums "
                    "$\\gamma_i+\\gamma_j$, weights $\\Gamma(\\rho)\\Gamma(\\rho')/\\Gamma(\\rho+\\rho'+3)$")

    ax[1].plot(Xs[core], b_d2[core], lw=0.7, label="k=2 data, band-passed")
    ax[1].plot(Xs[core], b_m2[core], lw=0.7, alpha=0.85, label="k=2 model, band-passed")
    ax[1].set_xscale("log")
    ax[1].set_xlabel("X")
    ax[1].legend(fontsize=8)
    ax[1].set_title(f"band {BAND}: corr = {corr2:.4f}, amplitude ratio = {rat2:.4f} "
                    f"(k=1 same pipeline: {corr1:.4f}, {rat1:.4f})")

    ax[2].scatter(np.log10(fs[keep]), lw[keep] / np.log(10), s=1, alpha=0.3,
                  label="same-sign pairs, 320$^2$")
    xx = np.array([np.log10(41), np.log10(fs.max())])
    ax[2].plot(xx, (slope * xx * np.log(10) + np.polyfit(np.log(fs[keep]), lw[keep], 1)[1]) / np.log(10),
               "r", lw=1.5, label=f"fit slope {slope:.3f} (pred $-7/2$)")
    txt = "k-ratio (data):\n" + "\n".join(
        f"{n}: {m:.5f} vs 1/|3+if|={t3:.5f}" for n, f, m, t3, t2 in kratio_rows)
    ax[2].text(0.55, 0.95, txt, transform=ax[2].transAxes, va="top", fontsize=9,
               family="monospace")
    ax[2].set_xlabel("log10(gamma+gamma')")
    ax[2].set_ylabel("log10 |W2|")
    ax[2].legend(fontsize=8, loc="lower left")
    ax[2].set_title("k=2 weight law and k-dependence")
    fig.tight_layout()
    fig.savefig(FIG / "exp22_k2.png", dpi=140)
    print("saved figures/exp22_k2.png")


if __name__ == "__main__":
    main()
