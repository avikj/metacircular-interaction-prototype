"""Experiment 17: THE SUM SPECTRUM DIFFRACTS — Cornu spirals, and the
resolution of the Fresnel-zone problem (FRESNEL.md S4).

The zone conjecture said: the pair layer at frequency f is dominated by the
Fresnel zone |gamma-gamma'| <~ sqrt(2 pi f).  The D''' modulus law already
refutes half of it: |c_f| = mult * sqrt(2pi) f^{-5/2} is INDEPENDENT of the
splitting, so the VARIANCE (line content) of the pair layer is zone-uniform —
spread over all splittings in proportion to pair density.  What the zone
does carry is the COHERENT MEAN: dechirp each atom by the diagonal reference,

    c~_f = c_f * exp(i (f log 2 + 5 pi/4))   =>   arg c~_f ~ Delta^2/(2f),

and the cumulative vector sum over increasing Delta = |gamma-gamma'| is a
discrete Fresnel integral: it traces a CORNU SPIRAL with normalized
parameter nu = Delta/sqrt(pi f), converging to the Fresnel limit
sqrt(pi f/2) e^{i pi/4} * (local pair density).  Coherent fraction of an
s-band ~ sqrt(pi f/2)/(f - 2 gamma_1) ~ f^{-1/2}.

Tests:
  1. |c|^2-weighted quantiles of Delta per s-band == unweighted pair-count
     quantiles (modulus blindness: variance is zone-uniform);
  2. cumulative dechirped sums trace Cornu spirals (figure);
  3. measured coherent fraction per band vs the Fresnel prediction.

Everything here is a pure zero-spectrum computation (no arithmetic data):
it corrects and completes the FRESNEL.md S4 problem statement.
"""
import numpy as np
from scipy.special import loggamma, fresnel
import matplotlib
matplotlib.use("Agg")
import matplotlib.pyplot as plt
from pathlib import Path
from pairfield import load_zeros

FIG = Path(__file__).resolve().parent.parent / "figures"


def main():
    gam = load_zeros()
    FMAX = 400.0
    kk = int(np.searchsorted(gam, FMAX - gam[0]))
    g = gam[:kk]
    r = 0.5 + 1j * g
    LG = loggamma(r)
    W = np.exp(LG[:, None] + LG[None, :] - loggamma(r[:, None] + r[None, :] + 2))
    iu = np.triu_indices(kk)
    f = g[iu[0]] + g[iu[1]]
    keep = f <= FMAX
    mult = np.where(iu[0] == iu[1], 1.0, 2.0)
    f = f[keep]
    c = (mult * W[iu])[keep]
    dlt = np.abs(g[iu[0]] - g[iu[1]])[keep]
    ctil = c * np.exp(1j * (f * np.log(2) + 5 * np.pi / 4))   # dechirped

    bands = [(50, 100), (100, 200), (200, 300), (300, 400)]
    print("1. modulus blindness: |c|^2-weighted vs unweighted quantiles of Delta/(f-2g1)")
    print(f"{'band':>12} {'q25 w/unw':>14} {'q50 w/unw':>14} {'q75 w/unw':>14} {'atoms':>7}")
    for lo, hi in bands:
        m = (f >= lo) & (f < hi)
        x = dlt[m] / (f[m] - 2 * gam[0])          # normalized splitting in [0,1]
        wq = np.abs(c[m]) ** 2
        qs = []
        for q in (0.25, 0.5, 0.75):
            o = np.argsort(x)
            cw = np.cumsum(wq[o]) / wq.sum()
            qw = x[o][np.searchsorted(cw, q)]
            qu = np.quantile(x, q)
            qs.append(f"{qw:.3f}/{qu:.3f}")
        print(f"[{lo:>3},{hi:>3}) {qs[0]:>14} {qs[1]:>14} {qs[2]:>14} {m.sum():>7}")

    print("\n2/3. coherent fraction per band: measured vs Fresnel sqrt(pi f/2)/(f-2g1)")
    print(f"{'band':>12} {'measured':>10} {'predicted':>10}")
    fig, ax = plt.subplots(1, 3, figsize=(15.5, 4.9))
    for (lo, hi), col in zip(bands, ["C0", "C1", "C2", "C3"]):
        m = (f >= lo) & (f < hi)
        o = np.argsort(dlt[m])
        cs = np.cumsum(ctil[m][o])
        frac = np.abs(cs[-1]) / np.abs(c[m]).sum()
        fbar = np.mean(f[m])
        pred = np.sqrt(np.pi * fbar / 2) / (fbar - 2 * gam[0])
        print(f"[{lo:>3},{hi:>3}) {frac:>10.4f} {pred:>10.4f}")
        # Cornu trajectory, normalized so the ideal spiral is universal
        scale = np.abs(c[m]).sum() / (dlt[m].max())      # per-unit-Delta amplitude
        z = cs / (scale * np.sqrt(np.pi * fbar))
        ax[0].plot(z.real, z.imag, lw=1.0, color=col, label=f"band [{lo},{hi})")
    # ideal Cornu spiral: int_0^nu e^{i pi t^2/2} dt  (Fresnel S,C)
    nu = np.linspace(0, 4, 400)
    Sf, Cf = fresnel(nu)
    ax[0].plot(Cf, Sf, "k--", lw=1.2, label="ideal Cornu $C(\\nu)+iS(\\nu)$")
    ax[0].plot([0.5], [0.5], "k*", ms=10, label="Fresnel limit (1/2, 1/2)")
    ax[0].set_title("dechirped cumulative atom sums: the sum spectrum diffracts")
    ax[0].set_xlabel("Re"); ax[0].set_ylabel("Im"); ax[0].legend(fontsize=7)
    ax[0].set_aspect("equal")

    # coherent fraction vs f: sweep in overlapping bands
    fcs, fr_m, fr_p = [], [], []
    for lo in np.arange(40, 360, 10.0):
        m = (f >= lo) & (f < lo + 40)
        if m.sum() < 30:
            continue
        fbar = np.mean(f[m])
        fcs.append(fbar)
        fr_m.append(np.abs(ctil[m].sum()) / np.abs(c[m]).sum())
        fr_p.append(np.sqrt(np.pi * fbar / 2) / (fbar - 2 * gam[0]))
    ax[1].loglog(fcs, fr_m, "o-", ms=4, label="measured coherent fraction")
    ax[1].loglog(fcs, fr_p, "--", color="crimson", label=r"$\sqrt{\pi f/2}/(f-2\gamma_1)$")
    ax[1].set_xlabel("f"); ax[1].set_title(r"coherence decays like $f^{-1/2}$")
    ax[1].legend(fontsize=8)

    # variance flatness: |c|^2-weighted density of normalized splitting
    m = (f >= 100) & (f < 400)
    x = dlt[m] / (f[m] - 2 * gam[0])
    ax[2].hist(x, bins=40, weights=np.abs(c[m]) ** 2, density=True, alpha=0.7,
               label=r"$|c|^2$-weighted")
    ax[2].hist(x, bins=40, density=True, histtype="step", color="k",
               label="unweighted pair count")
    ax[2].set_xlabel(r"$\Delta/(f-2\gamma_1)$")
    ax[2].set_title("variance is zone-uniform (modulus blindness)")
    ax[2].legend(fontsize=8)
    fig.tight_layout()
    fig.savefig(FIG / "exp17_cornu.png", dpi=140)
    print("\nsaved figures/exp17_cornu.png")


if __name__ == "__main__":
    main()
