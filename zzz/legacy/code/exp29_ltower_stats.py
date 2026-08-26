"""Experiment 29: STATISTICS OF THE L-TOWER SUM SPECTRUM — paper problem 3.

The zeta sum spectrum is Poisson after unfolding (exp13: var/mean^2 = 0.997)
and diffracts with Cornu coherence (exp17).  Do these statistical laws
extend to the abelian tower?  Using the self-computed L(s,chi_3) zeros
(exp20 cache, extended here to t <= 120 for statistics):

  1. unfolded spacing statistics of the L-zero SUM spectrum
     {gamma^chi_i + gamma^chi_j} — prediction: Poisson (var/mean^2 ~ 1),
     the GUE-rigidity of the single spectrum destroyed by summation exactly
     as for zeta;
  2. dechirped Cornu coherence of the L-pair atoms (unit weights) —
     prediction: same sqrt(pi f/2)/(f - 2 gamma^chi_1) law, since the
     Gamma-part is dressing- AND conductor-universal;
  3. cross-spectrum mixing: the union of zeta-sums and L-sums — prediction:
     superposition of two independent Poisson processes is Poisson, so the
     union stays Poisson (var/mean^2 ~ 1) — the tower's spectra are
     statistically transparent to each other at the sum level.

Standing hypotheses: GRH + simple zeros for L(s,chi_3) (zeros located on
the critical line by construction).
"""
import numpy as np
from scipy.special import loggamma
import mpmath as mp
import matplotlib
matplotlib.use("Agg")
import matplotlib.pyplot as plt
from pathlib import Path
from pairfield import load_zeros
from exp20_dirichlet import l_chi3

FIG = Path(__file__).resolve().parent.parent / "figures"
DATA = Path(__file__).resolve().parent.parent / "data"


def find_l_zeros_deep(tmax=120.0):
    cache = DATA / "chi3_zeros_deep.npy"
    if cache.exists():
        return np.load(cache)
    mp.mp.dps = 15
    ts = np.arange(0.5, tmax, 0.05)
    absv = np.array([abs(complex(l_chi3(mp.mpc(0.5, t)))) for t in ts])
    zs = []
    for i in range(1, len(ts) - 1):
        if absv[i] < absv[i - 1] and absv[i] < absv[i + 1] and absv[i] < 0.5:
            try:
                root = mp.findroot(lambda t: l_chi3(mp.mpf("0.5") + 1j * t),
                                   mp.mpf(ts[i]), solver="muller")
                tr = float(mp.re(root))
                if 0 < tr < tmax and all(abs(tr - z) > 1e-6 for z in zs):
                    if abs(complex(l_chi3(mp.mpc(0.5, tr)))) < 1e-10:
                        zs.append(tr)
            except Exception:
                pass
    z = np.array(sorted(zs))
    np.save(cache, z)
    return z


def sum_spectrum(g, smax):
    kk = int(np.searchsorted(g, smax - g[0]))
    gz = g[:kk]
    iu = np.triu_indices(kk)
    f = gz[iu[0]] + gz[iu[1]]
    keep = f <= smax
    return np.sort(f[keep]), gz


def main():
    gz = find_l_zeros_deep(120.0)
    gam = load_zeros()
    print(f"L(s,chi_3) zeros to t=120: {len(gz)} (first: "
          + ", ".join(f"{t:.3f}" for t in gz[:4]) + ")")

    SMAX = 120.0
    fL, gzc = sum_spectrum(gz, SMAX)
    fz, _ = sum_spectrum(gam, SMAX)
    print(f"L-sum atoms <= {SMAX:.0f}: {len(fL)};  zeta-sum atoms: {len(fz)}")

    # ---- 1. unfolded spacings of each and of the union ------------------
    def unfold_ratio(f, dens_fn):
        sp = np.diff(f)
        loc = dens_fn(0.5 * (f[1:] + f[:-1]))
        u = sp * loc
        return np.var(u) / np.mean(u) ** 2

    # empirical density via smoothed counting (avoids conductor bookkeeping)
    def make_dens(f):
        # local density from a moving window of the atom sequence itself
        def d(x):
            idx = np.searchsorted(f, x)
            lo = np.maximum(idx - 8, 0)
            hi = np.minimum(idx + 8, len(f) - 1)
            return (hi - lo) / np.maximum(f[hi] - f[lo], 1e-9)
        return d

    for nm, f in [("zeta sums", fz), ("L sums", fL),
                  ("union", np.sort(np.concatenate([fz, fL])))]:
        r = unfold_ratio(f, make_dens(f))
        print(f"  {nm:>10}: unfolded spacing var/mean^2 = {r:.3f}  (Poisson: 1)")

    # ---- 2. Cornu coherence of the L-tower ------------------------------
    kk = len(gzc)
    r = 0.5 + 1j * gzc
    LG = loggamma(r)
    W = np.exp(LG[:, None] + LG[None, :] - loggamma(r[:, None] + r[None, :] + 2))
    iu = np.triu_indices(kk)
    f = gzc[iu[0]] + gzc[iu[1]]
    keep = f <= SMAX
    mult = np.where(iu[0] == iu[1], 1.0, 2.0)
    fA, cA = f[keep], (mult * W[iu])[keep]
    dlt = np.abs(gzc[iu[0]] - gzc[iu[1]])[keep]
    ctil = cA * np.exp(1j * (fA * np.log(2) + 5 * np.pi / 4))
    print("\nCornu coherence of the L-tower (dressing- and conductor-universal Gamma law):")
    for lo, hi in [(30, 60), (60, 90), (90, 120)]:
        m = (fA >= lo) & (fA < hi)
        if m.sum() < 15:
            continue
        fbar = np.mean(fA[m])
        meas = np.abs(ctil[m].sum()) / np.abs(cA[m]).sum()
        pred = np.sqrt(np.pi * fbar / 2) / (fbar - 2 * gz[0])
        print(f"  band [{lo},{hi}): coherent fraction {meas:.3f}  "
              f"vs Fresnel {pred:.3f}   ({m.sum()} atoms)")

    fig, ax = plt.subplots(1, 2, figsize=(12.5, 4.6))
    for nm, f, col in [("zeta", fz, "C0"), ("L(chi_3)", fL, "C1")]:
        d = make_dens(f)
        u = np.diff(f) * d(0.5 * (f[1:] + f[:-1]))
        ax[0].hist(u / np.mean(u), bins=30, density=True, alpha=0.5,
                   label=f"{nm} sums", color=col)
    xx = np.linspace(0, 5, 100)
    ax[0].plot(xx, np.exp(-xx), "k--", label="Poisson")
    ax[0].legend(fontsize=8)
    ax[0].set_title("unfolded sum-spectrum spacings: Poisson across the tower")
    o = np.argsort(dlt)
    m = (fA >= 40)
    oo = np.argsort(dlt[m])
    cs = np.cumsum(ctil[m][oo])
    ax[1].plot(cs.real, cs.imag, lw=0.9)
    ax[1].set_title("dechirped cumulative L-atom sums: the tower diffracts too")
    ax[1].set_aspect("equal")
    fig.tight_layout()
    fig.savefig(FIG / "exp29_ltower.png", dpi=140)
    print("\nsaved figures/exp29_ltower.png")


if __name__ == "__main__":
    main()
