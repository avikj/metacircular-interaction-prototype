"""Experiment 22: THE k-BODY LADDER — entropy phase law and Fresnel coherence
at every order.

Complements the sibling branch's TERNARY.md (which built the cubic field's
layer/block structure and stopped at "the triple layer is below the reach of
the present numerics").  Two additions:

**Theorem D'''-k (k-body weight law).**  For the k-fold Cesaro-1 field, the
k-th-variation weight  W_k = Gamma(2) prod Gamma(rho_i) / Gamma(sum rho_i + 2),
with s = sum gamma_i (same-sign) and p_i = gamma_i/s, obeys

    W_k = (2pi)^{(k-1)/2} s^{-(k+3)/2}
          exp(-i ( s H_k(p) + (k+3) pi/4 )) (1 + O(1/min gamma_i)),

    H_k(p) = -sum p_i log p_i   (k-ary splitting entropy).

k=2 is Theorem D''' (5pi/4); k=3 gives 3pi/2, modulus 2pi s^{-3}.  The
stationary point of the phase is the equal split p = (1/k,...,1/k): the
atom's phase evaluates the k zero waves at m_i* = p_i X, the equilibrium
partition of the constraint simplex.

**Corollary (k-body diffraction).**  Near equal split the phase is a
(k-1)-dimensional Fresnel form, so the coherent fraction of an s-band of
the k-th variation decays like s^{-(k-1)/2}: each additional body adds one
transverse Cornu factor.  (Binary: s^{-1/2}, exp17; ternary: s^{-1}.)

Also quantified: WHY the ternary triple layer resists data extraction —
its lines interleave the (much stronger) pair lines at sub-resolution
spacing (3 gamma_1 = 42.407 vs 2 gamma_2 = 42.044: 0.36 apart, window
resolution ~ 1.4).
"""
import numpy as np
from scipy.special import loggamma
import matplotlib
matplotlib.use("Agg")
import matplotlib.pyplot as plt
from pathlib import Path
from pairfield import load_zeros

FIG = Path(__file__).resolve().parent.parent / "figures"


def wk_exact(gs):
    """W_k for an array of ordinate tuples, shape (n, k)."""
    r = 0.5 + 1j * gs
    return np.exp(np.sum(loggamma(r), axis=1) - loggamma(np.sum(r, axis=1) + 2))


def law_check(gs, k):
    s = gs.sum(axis=1)
    p = gs / s[:, None]
    Hk = -(p * np.log(p)).sum(axis=1)
    W = wk_exact(gs)
    mod_pred = (2 * np.pi) ** ((k - 1) / 2) * s ** (-(k + 3) / 2)
    phase_dev = np.angle(W * np.exp(1j * (s * Hk + (k + 3) * np.pi / 4)))
    mn = gs.min(axis=1)
    return np.abs(W) / mod_pred, phase_dev, mn, s


def main():
    gam = load_zeros()
    rng = np.random.default_rng(7)

    print("Theorem D'''-k: W_k = (2pi)^{(k-1)/2} s^{-(k+3)/2} "
          "exp(-i(s H_k + (k+3)pi/4))\n")
    for k, npool, nsamp in [(2, 600, 0), (3, 300, 300000), (4, 200, 300000)]:
        if k == 2:
            i, j = np.meshgrid(np.arange(npool), np.arange(npool), indexing="ij")
            gs = np.stack([gam[i.ravel()], gam[j.ravel()]], axis=1)
        else:
            idx = rng.integers(0, npool, size=(nsamp, k))
            gs = gam[idx]
        mr, pd, mn, s = law_check(gs, k)
        print(f"k={k}: modulus ratio mean {mr.mean():.6f} "
              f"(max|dev| {np.abs(mr-1).max():.4f});  "
              f"phase dev rms {np.sqrt((pd**2).mean()):.5f} rad")
        for thr in [50, 200]:
            m = mn > thr
            if m.sum():
                print(f"     min gamma > {thr:3d}: max|phase dev| = "
                      f"{np.abs(pd[m]).max():.5f}  (O(1/min) ~ {1/thr:.4f})")

    # ---- k-body diffraction: coherence exponent -----------------------
    print("\nk-body diffraction: coherent fraction of s-bands, log-log slope in s")
    fig, ax = plt.subplots(1, 2, figsize=(12.5, 4.8))
    for k, kk, col in [(2, 140, "C0"), (3, 100, "C1")]:
        gz = gam[: kk]
        if k == 2:
            iu = np.stack(np.triu_indices(kk), axis=1)
            gs = gz[iu]
            mult = np.where(iu[:, 0] == iu[:, 1], 1.0, 2.0)
        else:
            trip = np.array([(a, b, c) for a in range(kk) for b in range(a, kk)
                             for c in range(b, kk)])
            gs = gz[trip]
            # multinomial multiplicities for ordered sums
            mult = np.array([6.0 if a < b < c else (1.0 if a == b == c else 3.0)
                             for a, b, c in trip])
        s = gs.sum(axis=1)
        keep = s <= gam[kk - 1]
        gs, s, mult = gs[keep], s[keep], mult[keep]
        p = gs / s[:, None]
        Hk = -(p * np.log(p)).sum(axis=1)
        W = mult * wk_exact(gs)
        ctil = W * np.exp(1j * (s * np.log(k) + (k + 3) * np.pi / 4))
        fcs, fr = [], []
        lo0, hi0 = (40, s.max()) if k == 2 else (60, s.max())
        for lo in np.arange(lo0, hi0 - 30, 8.0):
            m = (s >= lo) & (s < lo + 30)
            if m.sum() < 40:
                continue
            fcs.append(np.mean(s[m]))
            fr.append(np.abs(ctil[m].sum()) / np.abs(W[m]).sum())
        fcs, fr = np.array(fcs), np.array(fr)
        slope = np.polyfit(np.log(fcs), np.log(fr), 1)[0]
        print(f"  k={k}: measured slope {slope:+.3f}   (predicted -(k-1)/2 = "
              f"{-(k-1)/2:+.1f})   [{len(fcs)} bands]")
        ax[0].loglog(fcs, fr, "o-", ms=4, color=col, label=f"k={k} measured")
        ax[0].loglog(fcs, fr[0] * (fcs / fcs[0]) ** (-(k - 1) / 2), "--",
                     color=col, alpha=0.6, label=f"$s^{{-{(k-1)}/2}}$")
    ax[0].set_xlabel("s"); ax[0].set_ylabel("coherent fraction")
    ax[0].set_title("each body adds one Cornu factor")
    ax[0].legend(fontsize=8)

    # ---- why the triple layer resists data extraction ------------------
    print("\ntriple-line / pair-line interleaving (window resolution ~1.4 rad):")
    pairs = sorted(gam[i] + gam[j] for i in range(6) for j in range(i, 6))
    trips = sorted(gam[i] + gam[j] + gam[k] for i in range(4)
                   for j in range(i, 4) for k in range(j, 4))
    seps = []
    for t in trips[:6]:
        nearest = min(pairs, key=lambda x: abs(x - t))
        seps.append(abs(nearest - t))
        print(f"  triple line {t:7.3f}  nearest pair line {nearest:7.3f}  "
              f"sep {abs(nearest-t):5.3f}")
    ax[1].hist(seps, bins=6)
    ax[1].axvline(1.4, color="crimson", ls="--", label="window resolution")
    ax[1].set_xlabel("separation (rad)"); ax[1].legend(fontsize=8)
    ax[1].set_title("triple lines hide inside pair-line resolution cells")
    fig.tight_layout()
    fig.savefig(FIG / "exp22_kbody.png", dpi=140)
    print("\nsaved figures/exp22_kbody.png")


if __name__ == "__main__":
    main()
