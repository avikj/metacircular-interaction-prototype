"""Experiment 12: THE PHASE LAW OF THE SUM-SPECTRUM MEASURE, AND THE KREIN TEST.

APPENDIX_D S D.6.3 proposes testing positivity of the measure
    sigma = sum_{i,j} W_ij delta_{gamma_i+gamma_j},
    W(g,g') = Gamma(rho)Gamma(rho')/Gamma(rho+rho'+2),  rho = 1/2 + i g,
as the numerical face of the Matsumoto-Suzuki screw-function join.

This experiment settles the question.  Stirling analysis predicts the exact
asymptotic law (s = g+g', p = g/s, same-sign pairs):

    W(g,g')  ~  sqrt(2*pi) * s^{-5/2} * exp(-i (s*H(p) + 5*pi/4)),
    H(p) = -p log p - (1-p) log(1-p)      (binary entropy, natural log).

  * modulus law: |W| depends only on the SUM s, with explicit constant
    sqrt(2*pi) -- a sharpening of Theorem D' (which had |W| ~ s^{-5/2});
  * phase law: arg W is a CHIRP whose rate is the entropy of the splitting.
    Interpretation: e^{-i s H(p)} X^{i s} = (pX)^{ig} ((1-p)X)^{ig'} -- the
    atom's phase evaluates each zero's wave at the stationary point
    m* = pX, n* = (1-p)X of the constraint simplex m+n <= X.  The Beta
    weight remembers WHERE on the simplex the pair resonates.

Consequences tested here:
  1. modulus and phase law verified to O(1/min(g,g')) accuracy;
  2. atom phases equidistribute => sigma is an essentially maximally
     NON-positive complex measure: the pair function
     A(u) = sum W e^{i(g+g')u} is real but NOT EVEN (a positive spectral
     measure would force A even), and its Gram matrix has large negative
     eigenvalues.  So the naive Krein join fails at the amplitude level;
     positivity can only enter at the |W|^2 (variance / Theorem D'') level.
"""
import numpy as np
from scipy.special import loggamma
import matplotlib
matplotlib.use("Agg")
import matplotlib.pyplot as plt
from pathlib import Path
from pairfield import load_zeros

FIG = Path(__file__).resolve().parent.parent / "figures"


def W_matrix(g1, g2):
    """W(g,g') for arrays of SIGNED ordinates (meshgrid)."""
    r1 = 0.5 + 1j * g1[:, None]
    r2 = 0.5 + 1j * g2[None, :]
    return np.exp(loggamma(r1) + loggamma(r2) - loggamma(r1 + r2 + 2))


def main():
    gam = load_zeros()

    # ---- 1. the law, verified -----------------------------------------
    K = 600
    g = gam[:K]
    W = W_matrix(g, g)
    S = g[:, None] + g[None, :]
    P = g[:, None] / S
    H = -(P * np.log(P) + (1 - P) * np.log(1 - P))
    mod_pred = np.sqrt(2 * np.pi) * S ** (-2.5)
    phase_dev = np.angle(W * np.exp(1j * (S * H + 5 * np.pi / 4)))  # should be ~0
    mod_ratio = np.abs(W) / mod_pred
    mn = np.minimum(g[:, None], g[None, :])

    print("Law:  W ~ sqrt(2pi) s^{-5/2} exp(-i(s H(p) + 5pi/4)),  s=g+g', p=g/s")
    print(f"  modulus ratio |W|/pred over all {K}^2 same-sign pairs: "
          f"mean {mod_ratio.mean():.6f},  max|ratio-1| = {np.abs(mod_ratio-1).max():.4f}")
    print(f"  phase deviation (rad): rms {np.sqrt((phase_dev**2).mean()):.5f},  "
          f"max {np.abs(phase_dev).max():.5f}")
    for thr in [20, 50, 100, 300]:
        m = mn > thr
        print(f"    pairs with min(g,g') > {thr:3d}:  max|phase dev| = "
              f"{np.abs(phase_dev[m]).max():.6f}   (predicted O(1/min) ~ {1/thr:.4f})")
    # scaling exponent of the phase error against 1/min
    msk = (mn > 15) & (mn < 500)
    slope = np.polyfit(np.log(mn[msk]), np.log(np.abs(phase_dev[msk]) + 1e-15), 1)[0]
    print(f"  phase-error scaling exponent vs min(g,g'): {slope:.3f}  (predicted -1)")

    # ---- 2. phase equidistribution of the atoms ------------------------
    iu = np.triu_indices(K)
    mult = np.where(iu[0] == iu[1], 1.0, 2.0)
    atoms = mult * W[iu]                      # c_f for distinct f = g_i + g_j
    ph = np.angle(atoms)
    frac_pos = np.mean(np.cos(ph) > 0)
    wfrac = np.sum(np.abs(atoms) * (np.cos(ph) > 0)) / np.sum(np.abs(atoms))
    # Weyl sums: equidistribution mod 2pi
    weyl1 = np.abs(np.mean(np.exp(1j * ph)))
    weyl2 = np.abs(np.mean(np.exp(2j * ph)))
    print(f"\nAtom phases (all {len(atoms)} atoms):  fraction with Re c_f > 0 = "
          f"{frac_pos:.3f} (|c|-weighted {wfrac:.3f})")
    print(f"  Weyl sums |mean e^(i k arg)|: k=1: {weyl1:.4f}, k=2: {weyl2:.4f} "
          f"(equidistribution => ~ {1/np.sqrt(len(atoms)):.4f})")

    # ---- 3. non-positivity: A(u) real but not even; Gram eigenvalues ---
    # band-complete atom set: f = g_i+g_j <= FMAX
    FMAX = 300.0
    kk = int(np.searchsorted(gam, FMAX - gam[0]))
    gb = gam[:kk]
    Wb = W_matrix(gb, gb)
    Sb = gb[:, None] + gb[None, :]
    iu = np.triu_indices(kk)
    keep = Sb[iu] <= FMAX
    f_at = Sb[iu][keep]
    c_at = (np.where(iu[0] == iu[1], 1.0, 2.0) * Wb[iu])[keep]
    print(f"\nBand [0,{FMAX:.0f}]: {len(f_at)} atoms from {kk} zeros (complete).")

    def A(u):
        u = np.atleast_1d(u)
        return 2 * np.real(np.exp(1j * np.outer(u, f_at)) @ c_at)

    n, dlt = 500, 0.01
    lags = np.arange(-(n - 1), n) * dlt
    Av = A(lags)
    asym = np.linalg.norm(A(lags) - A(-lags)) / np.linalg.norm(Av)
    print(f"evenness test:  ||A(u)-A(-u)|| / ||A|| = {asym:.3f}   "
          "(a positive spectral measure forces 0)")
    idx = np.arange(n)
    Gram = Av[(idx[:, None] - idx[None, :]) + n - 1]
    Gs = 0.5 * (Gram + Gram.T)                 # PD test of symmetrized kernel
    ev = np.linalg.eigvalsh(Gs)
    print(f"Gram matrix ({n} pts, du={dlt}):  lambda_min/lambda_max = "
          f"{ev[0]/ev[-1]:.3f}   (PD requires >= 0)")
    neg_mass = -ev[ev < 0].sum() / np.abs(ev).sum()
    print(f"  negative spectral mass fraction = {neg_mass:.3f}  "
          "(0 for a screw/PD structure, 0.5 for a fully chirped measure)")

    # ---- figure --------------------------------------------------------
    fig, ax = plt.subplots(1, 3, figsize=(15, 4.6))
    # NB: consecutive diagonal frequencies are spaced wider than the chirp's
    # Nyquist rate at low gamma, so an unwrapped arg plot aliases; plot the
    # pointwise deviation from the predicted chirp instead (mod 2pi).
    diag_dev = np.angle(np.diag(W) * np.exp(1j * (2 * g * np.log(2) + 5 * np.pi / 4)))
    ax[0].plot(2 * g, diag_dev, lw=0.8)
    ax[0].axhline(0, color="crimson", ls="--", lw=1.0)
    ax[0].set_ylim(-0.35, 0.35)
    ax[0].set_xlabel(r"$f = 2\gamma$")
    ax[0].set_title(r"diagonal: arg $W(\gamma,\gamma) - (-f\log 2 - 5\pi/4)$  (mod $2\pi$)")
    ax[1].loglog(mn[msk][::97], np.abs(phase_dev[msk][::97]) + 1e-15, ".", ms=2,
                 alpha=0.4, label="|phase deviation|")
    xx = np.array([15, 500.0])
    ax[1].loglog(xx, 0.55 / xx, "--", color="crimson", label=r"$\propto 1/\min(\gamma,\gamma')$")
    from matplotlib.ticker import NullFormatter
    ax[1].xaxis.set_minor_formatter(NullFormatter())
    ax[1].set_xlabel(r"$\min(\gamma,\gamma')$"); ax[1].set_title("phase-law error")
    ax[1].legend(fontsize=8)
    ax[2].hist(ph, bins=60, density=True, alpha=0.8)
    ax[2].axhline(1 / (2 * np.pi), color="crimson", ls="--", label="uniform")
    ax[2].set_xlabel(r"arg $c_f$"); ax[2].set_title("atom phases: equidistributed")
    ax[2].legend(fontsize=8)
    fig.tight_layout()
    fig.savefig(FIG / "exp12_phaselaw.png", dpi=140)
    print("\nsaved figures/exp12_phaselaw.png")


if __name__ == "__main__":
    main()
