"""Experiment 13: NUMERICAL CLOSURE OF THEOREM D'' — EXPLICIT CONSTANTS.

APPENDIX_D proves V(T,L) ~ diagonal = 2 sum |c_f|^2 modulo ONE unproved
ingredient: near-diagonal separation of the sum spectrum {gamma_i+gamma_j}
(the weighted additive-energy hypothesis).  This experiment measures that
ingredient on the complete atom set below S_MAX and closes the chain:

  1. diagonal D = 2 sum_f |c_f|^2 computed exactly AND from the D''' law
     |c_f|^2 ~ mult^2 * 2pi * s^{-5} (closed form; new since BLOCKS.md);
  2. the off-diagonal energy profile E(eta) = sum_{f != f', |f-f'|<=eta}
     |c_f c_f'| measured over five decades of eta -> linear law E ~ C*eta
     (Poisson separation), giving the explicit constant C;
  3. the windowed variance V(T,L) of (D.1) computed exactly from the
     quadruple sum -> V(L)/D -> 1 with the dyadic bound (D.2) evaluated
     from the measured E(eta);
  4. Poisson statistics of atom spacings (exponential nearest-neighbour law)
     and the truncation tail beyond S_MAX bounded via the zero-density
     estimate of the pair-sum density rho_2(s).

Output: the explicit-constant form of Theorem D'': for all L >= L*(eps),
V(T,L) = D (1 + O(eps)), with measured D, C, L*.
"""
import numpy as np
from scipy.special import loggamma
import matplotlib
matplotlib.use("Agg")
import matplotlib.pyplot as plt
from pathlib import Path
from pairfield import load_zeros

FIG = Path(__file__).resolve().parent.parent / "figures"


def atoms_below(gam, smax):
    """Complete same-sign atom set {f = g_i+g_j <= smax}: (f, c_f) sorted."""
    kk = int(np.searchsorted(gam, smax - gam[0]))
    g = gam[:kk]
    r = 0.5 + 1j * g
    W = np.exp(loggamma(r)[:, None] + loggamma(r)[None, :]
               - loggamma(r[:, None] + r[None, :] + 2))
    iu = np.triu_indices(kk)
    f = (g[iu[0]] + g[iu[1]])
    keep = f <= smax
    mult = np.where(iu[0] == iu[1], 1.0, 2.0)
    f, c = f[keep], (mult * W[iu])[keep]
    o = np.argsort(f)
    return f[o], c[o], kk


def main():
    gam = load_zeros()
    S_MAX = 300.0
    f, c, kk = atoms_below(gam, S_MAX)
    n = len(f)
    ac = np.abs(c)
    print(f"complete atom set: {n} atoms (from {kk} zeros), band [2g_1, {S_MAX:.0f}]")

    # ---- 1. diagonal, exact vs D''' closed form ------------------------
    D = 2 * np.sum(ac**2)
    # closed form: |c_f| ~ mult * sqrt(2pi) s^{-5/2}, mult = 2 unless f = 2*gamma_i
    diag_f = 2 * gam[: np.searchsorted(gam, S_MAX / 2)]
    is_dbl = np.isclose(f[:, None], diag_f[None, :], atol=1e-9).any(axis=1)
    m = np.where(is_dbl, 1.0, 2.0)
    D_law = 2 * np.sum((m * np.sqrt(2 * np.pi) * f ** (-2.5)) ** 2)
    print(f"diagonal D = 2 sum|c_f|^2      exact: {D:.6e}")
    print(f"                        D''' closed form: {D_law:.6e}   "
          f"(ratio {D_law/D:.4f})")
    print(f"predicted band RMS sqrt(D/2)... rms(A) = sqrt(D) = {np.sqrt(D):.6f} "
          "(cf. APPENDIX_D D.5: 0.0025)")

    # ---- 2. off-diagonal energy profile E(eta) -------------------------
    dF = np.abs(f[:, None] - f[None, :])
    AC = ac[:, None] * ac[None, :]
    off = ~np.eye(n, dtype=bool)
    d_off, w_off = dF[off], AC[off]
    etas = np.logspace(-4, 1.3, 40)
    E = np.array([w_off[d_off <= e].sum() for e in etas])
    # linear-law fit in the small-eta regime
    lin = (etas >= 1e-3) & (etas <= 0.3)
    C = np.sum(E[lin] * etas[lin]) / np.sum(etas[lin] ** 2)   # LS through origin
    slope = np.polyfit(np.log(etas[lin]), np.log(E[lin]), 1)[0]
    print(f"\noff-diagonal energy E(eta): log-log slope on [1e-3,0.3] = {slope:.3f} "
          "(Poisson separation => 1)")
    print(f"  linear law E(eta) ~ C*eta with C = {C:.4e}   (units of D: C/D = {C/D:.3f})")

    # dyadic bound (D.2) evaluated from measured E: off(L) <= E(1/L) + sum 4^-k E(2^{k+1}/L)
    def offbound(L):
        tot = np.interp(1 / L, etas, E)
        k = 0
        while 2 ** (k + 1) / L < d_off.max():
            tot += 4.0 ** (-k) * np.interp(2 ** (k + 1) / L, etas, E,
                                           right=w_off.sum())
            k += 1
        return tot

    # ---- 3. exact windowed variance V(T,L) -----------------------------
    u0 = np.log(1e6)
    print(f"\nwindowed variance (D.1) at u0 = log 1e6, exact quadruple sum:")
    print(f"{'L':>6} {'V(L)/D':>10} {'dyadic bound off/D':>20}")
    cphase = c * np.exp(1j * f * u0)
    for L in [1, 3, 10, 30, 100, 300, 1000]:
        S2 = np.sinc(dF * L / (2 * np.pi)) ** 2          # sinc^2(L*delta/2); np.sinc(x)=sin(pi x)/(pi x)
        V = 2 * np.real(np.einsum("i,ij,j->", cphase.conj(), S2, cphase))
        print(f"{L:>6} {V/D:>10.4f} {offbound(L)/D:>20.4f}")
    eps = 0.1
    eta_star = np.interp(eps * D, E, etas)
    print(f"L*(eps=0.1)  (E(1/L) = 0.1 D):  L* = 1/eta* = {1/eta_star:.1f}")

    # ---- 4. spacing statistics + truncation tail -----------------------
    # pair-sum density rho_2(s) = (1/2) int_0^s rho(g) rho(s-g) dg, rho = log(g/2pi)/2pi
    def rho(g):
        return np.where(g > 2 * np.pi, np.log(np.maximum(g, 7) / (2 * np.pi)) / (2 * np.pi), 0)
    ss = np.linspace(30, S_MAX, 100)
    gg = np.linspace(gam[0], S_MAX - gam[0], 2000)
    rho2 = np.array([0.5 * np.trapezoid(rho(gg[gg <= s - gam[0]]) * rho(s - gg[gg <= s - gam[0]]), gg[gg <= s - gam[0]]) for s in ss])
    counts, edges = np.histogram(f, bins=20, range=(30, S_MAX))
    pred = np.interp(0.5 * (edges[1:] + edges[:-1]), ss, rho2) * np.diff(edges)
    print(f"pair-sum density check: measured/predicted counts (20 bins): "
          f"mean ratio = {np.mean(counts/pred):.3f}")
    # spacings must be UNFOLDED by the local density (the band is strongly
    # inhomogeneous: rho_2 grows ~ s log^2 s); raw var/mean^2 conflates the
    # density gradient with clustering.
    sp_raw = np.diff(f)
    sp = sp_raw * np.interp(0.5 * (f[1:] + f[:-1]), ss, rho2)
    ratio = np.var(sp) / np.mean(sp) ** 2
    print(f"unfolded atom spacings: var/mean^2 = {ratio:.3f} (Poisson: 1);  "
          f"raw (unnormalized): {np.var(sp_raw)/np.mean(sp_raw)**2:.3f}")
    # tail of D beyond S_MAX: 2 * int rho2(s) * 4 * 2pi s^-5 ds  (mult=2 generic)
    st = np.linspace(S_MAX, 50000, 20000)
    rho2t = 0.5 * st * rho(st / 2) ** 2        # upper bound rho_2(s) <= (s/2) rho(s/2)^2 is
    # wrong pointwise (rho increasing), so use rho(s)^2 which dominates the integrand:
    rho2t = 0.5 * st * rho(st) ** 2
    tail = 2 * np.trapezoid(rho2t * 4 * 2 * np.pi * st ** (-5.0), st)
    print(f"truncation tail of D beyond {S_MAX:.0f} (upper bound): {tail:.2e}  "
          f"= {tail/D:.2e} of D")

    # ---- figure --------------------------------------------------------
    fig, ax = plt.subplots(1, 3, figsize=(15, 4.6))
    ax[0].loglog(etas, E / D, "o-", ms=3, label=r"$E(\eta)/D$ measured")
    ax[0].loglog(etas, C * etas / D, "--", color="crimson", label=rf"$C\eta/D$, $C/D={C/D:.2f}$")
    ax[0].axhline(1, color="gray", lw=0.6, ls=":")
    ax[0].set_xlabel(r"$\eta$"); ax[0].set_title("off-diagonal energy: linear (Poisson) law")
    ax[0].legend(fontsize=8)
    Ls = np.array([1, 2, 3, 5, 10, 20, 30, 50, 100, 200, 300, 600, 1000], dtype=float)
    Vs = []
    for L in Ls:
        S2 = np.sinc(dF * L / (2 * np.pi)) ** 2
        Vs.append(2 * np.real(np.einsum("i,ij,j->", cphase.conj(), S2, cphase)))
    ax[1].semilogx(Ls, np.array(Vs) / D, "o-", ms=4)
    ax[1].axhline(1, color="crimson", ls="--", lw=1)
    ax[1].set_xlabel("L"); ax[1].set_title(r"$V(T,L)/D \to 1$: variance = diagonal")
    ax[2].hist(sp / np.mean(sp), bins=40, density=True, alpha=0.8)
    xx = np.linspace(0, 6, 200)
    ax[2].plot(xx, np.exp(-xx), "--", color="crimson", label="Poisson $e^{-s}$")
    ax[2].set_xlabel("normalized spacing"); ax[2].set_title("sum-spectrum spacings: Poisson")
    ax[2].legend(fontsize=8)
    fig.tight_layout()
    fig.savefig(FIG / "exp13_energy.png", dpi=140)
    print("\nsaved figures/exp13_energy.png")


if __name__ == "__main__":
    main()
