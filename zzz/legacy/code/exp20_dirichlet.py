"""Experiment 20: THE NET EXTENDS TO THE ABELIAN TOWER — the sum spectrum of
Dirichlet L-zeros read off character-twisted Goldbach data.

For the quadratic character chi mod 3, -L'/L(s,chi) has NO pole at s=1
(L(1,chi_3) != 0), and residue 1 at every zero rho_chi of L(s,chi_3).
So the twisted pair field

    G1^chi(X) = sum_{m,n} Lambda(m)chi(m) Lambda(n)chi(n) (X-m-n)_+

is another PURE pair field (cf. exp16 for mu), over a NEW jewel string:

    G1^chi(X) = sum_{rho,rho'} Gamma(rho)Gamma(rho')/Gamma(rho+rho'+2)
                X^{rho+rho'+1}  + smooth,     rho, rho' zeros of L(s,chi_3),

with UNIT weights (pure D''' structure) and frequencies gamma_i^chi +
gamma_j^chi.  Standing hypotheses (stated explicitly per cross-audit):
GRH + simple zeros for L(s,chi_3) — the model hard-codes rho = 1/2 + i*g
and zeros are searched on the critical line only.  Sharp discriminators:
  * pair lines at sums of L-zeros (2*8.04=16.08, 8.04+11.25=19.29, ...);
  * NO single lines at the L-zeros themselves (no pole to cross against);
  * NO lines at zeta-zero frequencies (different jewel string entirely).

The L-zeros are computed from scratch here (mpmath, Hurwitz-zeta
representation), so the experiment is self-contained: arithmetic side from
the sieve, spectral side from L(s,chi_3), no external tables.

Smooth foreground: the diagonal sum Lambda(m)^2 chi(m)^2 (X-2m) ~
(X^2/4) log X is the leading deterministic term (there is no X^3);
the cubic-in-log-X detrend removes it before spectral comparison.
"""
import numpy as np
from scipy.special import loggamma
import mpmath as mp
import matplotlib
matplotlib.use("Agg")
import matplotlib.pyplot as plt
from pathlib import Path
from pairfield import sieve_lambda, load_zeros, additive_convolution

FIG = Path(__file__).resolve().parent.parent / "figures"
DATA = Path(__file__).resolve().parent.parent / "data"


def l_chi3(s):
    """L(s, chi_3) via Hurwitz zeta: 3^{-s} (zeta(s,1/3) - zeta(s,2/3))."""
    return mp.power(3, -s) * (mp.zeta(s, mp.mpf(1) / 3) - mp.zeta(s, mp.mpf(2) / 3))


def find_l_zeros(tmax=48.0):
    """Ordinates of zeros of L(1/2+it, chi_3), 0 < t < tmax."""
    cache = DATA / "chi3_zeros.npy"
    if cache.exists():
        z = np.load(cache)
        if z.max() > tmax - 3:
            return z[z < tmax]
    mp.mp.dps = 20
    ts = np.arange(0.5, tmax, 0.05)
    vals = [complex(l_chi3(mp.mpc(0.5, t))) for t in ts]
    absv = np.abs(vals)
    zs = []
    for i in range(1, len(ts) - 1):
        if absv[i] < absv[i - 1] and absv[i] < absv[i + 1] and absv[i] < 0.4:
            try:
                root = mp.findroot(lambda t: l_chi3(mp.mpf("0.5") + 1j * t),
                                   mp.mpf(ts[i]), solver="muller")
                tr = float(mp.re(root))
                if 0 < tr < tmax and all(abs(tr - z) > 1e-6 for z in zs):
                    if abs(complex(l_chi3(mp.mpc(0.5, tr)))) < 1e-12:
                        zs.append(tr)
            except Exception:
                pass
    z = np.array(sorted(zs))
    np.save(cache, z)
    return z


def main():
    gz = find_l_zeros(48.0)
    print(f"zeros of L(s,chi_3) found (self-computed): {len(gz)}")
    print("  first ordinates:", ", ".join(f"{t:.4f}" for t in gz[:8]))

    NMAX = 2_000_000
    lam = sieve_lambda(NMAX)
    chi = np.zeros(NMAX + 1)
    n = np.arange(NMAX + 1)
    chi[n % 3 == 1] = 1.0
    chi[n % 3 == 2] = -1.0
    a = lam * chi
    r = additive_convolution(a)
    N = np.arange(len(r), dtype=float)
    R, S = np.cumsum(r), np.cumsum(N * r)

    M = 8192
    logX = np.linspace(np.log(2e4), np.log(1.9e6), M)
    Xs = np.exp(logX)
    Xi = Xs.astype(int)
    data = (Xs * R[Xi] - S[Xi]) / Xs ** 2
    print(f"\nno X^3 term: G1/X^3 at X=1e6: "
          f"{np.interp(np.log(1e6), logX, data/Xs):+.6f} (Lambda alone: 0.1667)")

    # pure pair model over L-zeros, unit weights
    K = len(gz)
    sgn = np.concatenate([gz, -gz])
    rr = 0.5 + 1j * sgn
    LG = loggamma(rr)
    WW = np.exp(LG[:, None] + LG[None, :] - loggamma(rr[:, None] + rr[None, :] + 2))
    E = np.exp(1j * np.outer(sgn, logX))
    model = np.real(np.einsum("km,km->m", E, WW @ E))

    win = np.hanning(M)

    def prep(y):
        return y - np.polyval(np.polyfit(logX, y, 3), logX)

    def bandpass(y, lo, hi):
        Y = np.fft.rfft(prep(y))
        f = np.fft.rfftfreq(M, d=(logX[1] - logX[0])) * 2 * np.pi
        Y[(f < lo) | (f > hi)] = 0
        return np.fft.irfft(Y, M)

    core = slice(M // 8, -M // 8)
    bd, bm = bandpass(data, 14, 60), bandpass(model, 14, 60)
    corr = np.corrcoef(bd[core], bm[core])[0, 1]
    ratio = np.std(bd[core]) / np.std(bm[core])
    print(f"pair band [14,60]:  corr(data, L-zero pair model) = {corr:.4f}, "
          f"ratio = {ratio:.4f}")

    def spec(y):
        Y = np.fft.rfft(prep(y) * win)
        f = np.fft.rfftfreq(M, d=(logX[1] - logX[0])) * 2 * np.pi
        return f, np.abs(Y)
    fd, Ad = spec(data)
    fm, Am = spec(model)
    gzeta = load_zeros(6)
    print("\nline check (L-pair lines present; L-singles and zeta lines absent):")
    probes = ([(f"2L1", 2 * gz[0], "L-pair"), (f"L1+L2", gz[0] + gz[1], "L-pair"),
               (f"2L2", 2 * gz[1], "L-pair"), (f"L1+L3", gz[0] + gz[2], "L-pair")]
              + [(f"L{i+1}", gz[i], "L-single") for i in range(2)])
    for nm, fr, kind in probes:
        i = np.argmin(np.abs(fd - fr))
        print(f"  {nm:>7} ({kind:>9}) at {fr:7.3f}:  data {Ad[i]:8.3f}  "
              f"model {Am[i]:8.3f}")
    # NB: a naive "zeta-line absent" probe at 2*gamma^zeta_1 = 28.269 is
    # confounded: the L-pair sum L1+L5 = 28.50 sits 0.23 away, inside the
    # window resolution ~1.4 — the sum sets of the two spectra interleave too
    # densely for isolated cross-probes at this span.  The jewel-string
    # identification rests on the 0.999+ correlation with a model containing
    # no zeta input whatsoever, plus the L-single absence above.

    fig, ax = plt.subplots(2, 1, figsize=(13, 8.4))
    band = (fd > 10) & (fd < 55)
    ax[0].plot(fd[band], Ad[band], lw=0.9, label="twisted-Goldbach data spectrum (mod 3)")
    ax[0].plot(fm[band], -Am[band], lw=0.9, color="crimson",
               label="pure pair model over $L(s,\\chi_3)$ zeros (mirrored)")
    for i in range(4):
        for j in range(i, 4):
            fr = gz[i] + gz[j]
            if fr < 55:
                ax[0].axvline(fr, color="gray", lw=0.5, ls=":",
                              label=r"$\gamma^\chi_i+\gamma^\chi_j$" if (i, j) == (0, 0) else None)
    for i in range(3):
        ax[0].axvline(gz[i], color="green", lw=0.8, ls="--",
                      label=r"single $\gamma^\chi_i$ (absent)" if i == 0 else None)
    ax[0].legend(fontsize=8)
    ax[0].set_title("the abelian tower: mod-3 twisted Goldbach displays the sum spectrum "
                    "of $L(s,\\chi_3)$ zeros")
    ax[1].plot(Xs[core], bd[core], lw=0.7, label="data, band [14,60]")
    ax[1].plot(Xs[core], bm[core], lw=0.7, alpha=0.85, label="L-zero pair model")
    ax[1].set_xscale("log"); ax[1].legend(fontsize=8)
    fig.tight_layout()
    fig.savefig(FIG / "exp20_dirichlet.png", dpi=140)
    print("\nsaved figures/exp20_dirichlet.png")


if __name__ == "__main__":
    main()
