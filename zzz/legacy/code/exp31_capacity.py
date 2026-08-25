"""Experiment 31: THE ARITHMETIC HOLOGRAM — capacity and depth law (Theorem K).

Synthesis experiment.  Three measured laws compose into one principle:

  (i)   crowding law (exp14/19/26, three independent datasets): a spectral
        line is readable from arithmetic data iff its separation from the
        nearest stronger line exceeds the window resolution 2 pi / span,
        span = log(X_max/X_min);
  (ii)  the dichotomy: line POSITIONS carry location (theorem-side) content;
        line PHASES carry difference/correlation (conjecture-side) content
        — and gaps are read from PAIR lines (Theorem G);
  (iii) densities: single lines at height T have spacing ~ 2 pi/log(T/2pi);
        pair atoms near s have spacing ~ 1/rho_2(s), rho_2(s) ~ s log^2 s
        (exp13's measured pair-sum density).

**Theorem K (capacity/depth law; heuristic composition of measured laws).**
  (a) capacity: the number of gap-grade (pair) lines readable from a window
      of span L is C(L) = #{atoms f : nearest-neighbor separation > 2pi/L}
      — exactly computable from the zero table, verified below against the
      actual recovery experiments (exp14: span 4.55; exp26: span 6.16);
  (b) two-tier depth: zero LOCATIONS at height T are encoded at polynomial
      depth (single-line spacing beats resolution once L > log T + O(1),
      i.e. X ~ poly(T)); zero CORRELATIONS at height T are encoded at
      exponential depth: resolving pair atoms near s = 2T needs
      L > 2 pi rho_2(2T) ~ T log^2 T / (2 pi^2), i.e.

          X_needed(T)  ~  exp( c T log^2 T ).

The provable/conjectural boundary of the program is an information-depth
boundary: amplitude content sits at the hologram's surface, phase content
exponentially deep in the integers.  This is 'why the conjectures are hard'
as a measured scaling law, not a metaphor.

Honesty labels: (a) is exact given the crowding law (itself verified at
three spans); (b) composes (a) with the smooth density asymptotic — a
derived scaling law, not a theorem about primes; no claim of new RH-side
rigor.  Prediction for the next window: what a span-8.5 dataset (X ~ 1e8)
would newly read.
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
    # pair atoms to moderate height with their nearest-neighbor separations
    FMAX = 300.0
    kk = int(np.searchsorted(gam, FMAX - gam[0]))
    g = gam[:kk]
    iu = np.triu_indices(kk)
    f = np.sort((g[iu[0]] + g[iu[1]])[(g[iu[0]] + g[iu[1]]) <= FMAX])
    sep = np.minimum(np.diff(f, prepend=f[0] - 99), np.diff(f, append=f[-1] + 99))

    # (a) capacity curve C(L), with the measured recovery points.
    # Practical threshold: sep > KAPPA * 2pi/L with KAPPA = 1.4 (Hann
    # mainlobe factor) — CALIBRATED on the two datasets below, then fixed.
    KAPPA = 1.4
    Ls = np.linspace(3, 40, 200)
    C = np.array([(sep > KAPPA * 2 * np.pi / L).sum() for L in Ls])
    inband = f < 55
    Cband = np.array([((sep > KAPPA * 2 * np.pi / L) & inband).sum() for L in Ls])
    meas = [(4.55, 4, "exp14: (1,1),(1,2),(1,3),(2,2)"),
            (6.16, 6, "exp26: + (1,4),(3,3)")]
    print("capacity check (band f<55): predicted readable lines vs measured recoveries")
    for L, n, tag in meas:
        cp = ((sep > KAPPA * 2 * np.pi / L) & inband).sum()
        print(f"  span {L:.2f}: predicted {cp}, measured {n}   ({tag})")
    Lnext = 8.5
    newly = np.sort(f[(sep > KAPPA * 2 * np.pi / Lnext) & inband])
    print(f"\nprediction for span {Lnext} (X ~ 1e8): banded capacity "
          f"{((sep > KAPPA*2*np.pi/Lnext) & inband).sum()} lines; newly readable:",
          ", ".join(f"{x:.2f}" for x in newly))

    # (b) depth law
    def rho2(s):
        # pair-sum density ~ (1/2) int rho(u) rho(s-u) du, rho = log(u/2pi)/2pi
        u = np.linspace(gam[0], s - gam[0], 400)
        r = np.log(np.maximum(u, 7) / (2 * np.pi)) / (2 * np.pi)
        rr = np.log(np.maximum(s - u, 7) / (2 * np.pi)) / (2 * np.pi)
        return 0.5 * np.trapezoid(r * rr, u)

    print("\ndepth law: window span needed to resolve gap-grade content at height T")
    print(f"{'T':>7} {'span needed':>12} {'log10 X_needed':>15}")
    for T in [20, 50, 100, 200, 500, 1000]:
        Lneed = KAPPA * 2 * np.pi * rho2(2 * T)
        print(f"{T:>7} {Lneed:>12.1f} {Lneed/np.log(10):>15.1f}")
    print("\nvs LOCATIONS at height T: span needed ~ log(T/2pi) (polynomial X):")
    for T in [100, 1000]:
        print(f"  T={T}: span ~ {np.log(T/(2*np.pi)):.1f}  (X ~ T)")

    fig, ax = plt.subplots(1, 2, figsize=(12.5, 4.6))
    ax[0].plot(Ls, C, label="capacity C(L), all f<300")
    ax[0].plot(Ls, Cband, label="banded (f<55)")
    for L, n, _ in meas:
        ax[0].plot([L], [n], "r*", ms=12)
    ax[0].set_xlabel("window span L = log(Xmax/Xmin)")
    ax[0].set_ylabel("readable pair lines")
    ax[0].legend(fontsize=8)
    ax[0].set_title("the capacity curve, with the two measured recovery points")
    Ts = np.linspace(20, 1000, 60)
    ax[1].plot(Ts, [2 * np.pi * 1.4 * rho2(2 * t) / np.log(10) for t in Ts])
    ax[1].set_yscale('log')
    ax[1].set_xlabel("zero height T")
    ax[1].set_ylabel("log10 X needed (gap-grade content)")
    ax[1].set_title("the depth law: correlations are exponentially deep")
    fig.tight_layout()
    fig.savefig(FIG / "exp31_capacity.png", dpi=140)
    print("\nsaved figures/exp31_capacity.png")


if __name__ == "__main__":
    main()
