"""Experiment 41 (global numbering per psvg2m claims board): THE TOY
SEPARATION THEOREM — Theorem K is an instance of superresolution theory.

HOLOGRAM.md's capacity law and BARRIER.md's WL class needed a provable
core.  It exists — imported, not invented: spike superresolution
(Candes--Fernandez-Granda, Comm. Pure Appl. Math. 2014: stable recovery of
spike trains from bandlimited data requires separation >= c/f_c; Demanet--
Nguyen / Batenkov et al.: below separation, worst-case indistinguishability
with noise amplification (separation * bandwidth)^{-(2p-1)} for p clustered
spikes).  The WL observer of BARRIER.md sees exactly a bandlimited (span-L)
observation of the spectral spike train sigma_pair; hence:

**Toy Theorem K0 (provable core, imported).**  For two spike measures that
agree except a p-cluster of sub-resolution spikes (separation delta < 1/L)
with moments matched to order 2p-1, the windowed signals differ in L^2 by
O((delta L)^{2p-1}) relative.  Any observer with relative precision eps
cannot distinguish them once (delta L)^{2p-1} < eps: below-separation gaps
are UNREADABLE at fixed precision — the K_wl phase transition, rigorously,
in the toy.

This experiment verifies the scaling on the actual pair-atom geometry:
take the true zeta pair atoms, replace the closest pair by its
moment-matched merge, and measure the window-signal L^2 difference vs
(delta * L): predicted slope 3 in log-log for p=2 (moments matched to
order 2p-2=2 -> exponent 2p-1=3).

Honest deltas between toy and arithmetic: (i) superresolution lower bounds
are minimax over amplitudes; arithmetic amplitudes are FIXED and partially
known (D''' modulus law) — priors can improve constants, and the Fresnel
inversion exploits exactly that; they do not change the exponent, which is
forced by moment matching; (ii) the arithmetic noise floor (model-error
~1e-3 relative, measured in exp6b/14) plays eps's role, giving the depth
law with constants: readable iff (sep * L)^3 > eps, i.e. sep > eps^{1/3}/L
— a refinement of the sharp-threshold crowding law (kappa becomes
precision-dependent, kappa(eps) ~ eps^{1/3} * 2pi-normalized).
"""
import numpy as np
import matplotlib
matplotlib.use("Agg")
import matplotlib.pyplot as plt
from pathlib import Path
from pairfield import load_zeros

FIG = Path(__file__).resolve().parent.parent / "figures"


def main():
    gam = load_zeros()
    # true pair atoms in a band, unit-ish amplitudes (toy: use |c| from D''')
    g = gam[:40]
    iu = np.triu_indices(len(g))
    f = np.sort((g[iu[0]] + g[iu[1]]))
    f = f[(f > 28) & (f < 90)]
    amps = np.sqrt(2 * np.pi) * f ** (-2.5)          # D''' modulus law

    # find the closest atom pair (the first casualty of crowding)
    i0 = np.argmin(np.diff(f))
    f1, f2 = f[i0], f[i0 + 1]
    a1, a2 = amps[i0], amps[i0 + 1]
    delta0 = f2 - f1
    print(f"closest atoms: {f1:.3f}, {f2:.3f} (sep {delta0:.3f}); "
          f"moment-matched merge at their amplitude-weighted centroid")

    rng = np.random.default_rng(3)
    phases = rng.uniform(0, 2 * np.pi, len(f))

    def signal(fs, cs, phs, L, M=4096):
        u = np.linspace(0, L, M)
        y = np.zeros(M)
        for fk, ck, pk in zip(fs, cs, phs):
            y += 2 * ck * np.cos(fk * u + pk)
        return u, y

    # split configuration vs moment-matched merge (0th and 1st moments):
    # merged spike at centroid fc with amplitude a1+a2 matches sum and mean;
    # mismatch starts at the 2nd moment -> signal difference O((delta L)^2)
    # per CF-G (p=2 cluster, moments to order 2p-2=2 needs 3 spikes; with a
    # single merged spike we match to order 1 -> exponent 2p-1 = 3 requires
    # matching order 2; we therefore ALSO test the 3-spike match).
    fc = (a1 * f1 + a2 * f2) / (a1 + a2)

    Ls = np.array([0.5, 1, 2, 4, 8, 16, 32])
    d1, d2 = [], []
    for L in Ls:
        keep = np.ones(len(f), bool)
        keep[i0] = keep[i0 + 1] = False
        # config A: split pair, COHERENT (equal phases) — the worst-case
        # cluster of the CF-G lower-bound construction; independent phases
        # would make even the merged spike O(1)-distinguishable
        ph = phases.copy()
        ph[i0 + 1] = ph[i0]
        _, yA = signal(f, amps, ph, L)
        # config B1: naive merge (order-1 match)
        fB = np.concatenate([f[keep], [fc]])
        aB = np.concatenate([amps[keep], [a1 + a2]])
        pB = np.concatenate([ph[keep], [ph[i0]]])
        _, yB = signal(fB, aB, pB, L)
        # config B2: symmetric 3-spike match (order-2): spikes at fc +- d/2
        # and fc with weights chosen to match moments 0,1,2 of the pair
        m0 = a1 + a2
        m2 = a1 * (f1 - fc) ** 2 + a2 * (f2 - fc) ** 2
        dd = delta0 / 2
        w_side = m2 / (2 * dd ** 2)
        w_mid = m0 - 2 * w_side
        fC = np.concatenate([f[keep], [fc - dd, fc, fc + dd]])
        aC = np.concatenate([amps[keep], [w_side, w_mid, w_side]])
        pC = np.concatenate([ph[keep], [ph[i0]] * 3])
        _, yC = signal(fC, aC, pC, L)
        nrm = np.linalg.norm(yA)
        d1.append(np.linalg.norm(yA - yB) / nrm)
        d2.append(np.linalg.norm(yA - yC) / nrm)
    d1, d2 = np.array(d1), np.array(d2)
    x = delta0 * Ls
    s1 = np.polyfit(np.log(x[x < 3]), np.log(d1[x < 3]), 1)[0]
    s2 = np.polyfit(np.log(x[x < 3]), np.log(d2[x < 3]), 1)[0]
    print(f"\nindistinguishability scaling (sub-resolution regime delta*L < 3):")
    print(f"  order-1 merge:   ||dy||/||y|| ~ (delta L)^{s1:.2f}   (predicted 2)")
    print(f"  order-2 match:   ||dy||/||y|| ~ (delta L)^{s2:.2f}   (predicted 3)")
    eps = 1e-3
    for s, nm in [(s1, "order-1"), (s2, "order-2")]:
        Lread = (eps ** (1 / s)) / delta0
        print(f"  {nm}: at arithmetic precision eps={eps:.0e}, the pair reads only "
              f"once L > {Lread:.1f}  (vs Rayleigh 2pi/delta = {2*np.pi/delta0:.1f})")

    fig, ax = plt.subplots(figsize=(7, 5))
    ax.loglog(x, d1, "o-", label=f"order-1 merge (slope {s1:.2f})")
    ax.loglog(x, d2, "s-", label=f"order-2 match (slope {s2:.2f})")
    ax.axhline(1e-3, color="crimson", ls="--", label="arithmetic noise floor")
    ax.set_xlabel(r"$\delta \cdot L$ (separation $\times$ span)")
    ax.set_ylabel("relative signal difference")
    ax.legend(fontsize=8)
    ax.set_title("Toy Theorem K0: sub-resolution gaps are unreadable\n"
                 "(superresolution scaling on the real pair-atom geometry)")
    fig.tight_layout()
    fig.savefig(FIG / "exp41_superres.png", dpi=140)
    print("\nsaved figures/exp41_superres.png")


if __name__ == "__main__":
    main()
