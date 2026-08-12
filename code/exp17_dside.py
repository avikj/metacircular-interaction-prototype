"""Experiment 17: THE D-SIDE MIRROR -- gap statistics as INPUTS to the zero spectrum.

The repo's S-side result (Thm D / exp6b) reads the SUM spectrum {gamma_i+gamma_j}
of zeta zeros OFF Goldbach data: an output of zero locations, proven under RH.
This experiment builds the quantitative D-side twin, where the logic runs the
other way -- prime DIFFERENCE (gap) statistics are inputs to the zeros'
DIFFERENCE spectrum {gamma_i - gamma_j}:

(a) Montgomery's pair-correlation function from 100k zeros,
        F(alpha) = N(T)^{-1} sum_{0<gamma,gamma'<=T} T^{i alpha(gamma-gamma')}
                                                     w(gamma-gamma'),
    w(u) = 4/(4+u^2), T = gamma_100000.  Montgomery's THEOREM:
    F(alpha) = T^{-2 alpha} log T + alpha + o(1) for 0 <= alpha <= 1
    (in the (T/2pi log T)^{-1} normalization; N(T)^{-1} differs at finite T
    by log T / (log(T/2pi) - 1), which we display).  CONJECTURE: F(alpha) = 1
    for alpha >= 1.  We also compute the unfolded form (ordinates mapped by
    the counting function N(.)), for which slope-1 / plateau-1 is the clean
    finite-T statement.

(b) The Goldston-Montgomery bridge: variance of psi(x+h)-psi(x)-h over
    x <= 10^6 for h in {100, 1000, 10000} (plus a log-spaced sweep), against
    the pair-correlation prediction (Goldston-Montgomery; constant made
    precise by Montgomery-Soundararajan):
        Var(X,h) ~ h ( log(X/h) + B ),   B = -(gamma_E + log 2 pi) = -2.41516.
    We fit B per h and globally.

(c) is a derivation, not a computation -- see notes/DSIDE.md.  The third
    panel only draws the two pair-weight laws being contrasted there:
    S-side |Gamma(rho)Gamma(rho')/Gamma(rho+rho'+2)| ~ (gamma+gamma')^{-5/2}
    (absolutely summable -> theorem) vs the D-side Cesaro kernel
    |mu_X(delta)| = |int_{2/X}^1 (1-v) v^{i delta - 1} dv|
                  ~ min(log X, 1/|delta|) / (1+|delta|)
    (not absolutely summable over near-diagonal pairs -> needs F, conjectural).

Figure: figures/exp17_dside.png
"""
import numpy as np
from scipy.special import loggamma
import matplotlib
matplotlib.use("Agg")
import matplotlib.pyplot as plt
from pathlib import Path
from pairfield import sieve_lambda, load_zeros

FIG = Path(__file__).resolve().parent.parent / "figures"

EULER = 0.5772156649015329
B_PRED = -(EULER + np.log(2 * np.pi))          # -2.41516...

C_DATA, C_PRED, C_ALT, C_REF = "#2a78d6", "#eb6834", "#1baf7a", "#9a9a92"


# ----------------------------------------------------------------------
# (a) Montgomery's F(alpha) from the first 100k zeros
# ----------------------------------------------------------------------
def gap_histograms(g, D=600.0, bw_raw=2.5e-4, bw_unf=5.0e-4):
    """Weighted histograms of zero gaps d = gamma_j - gamma_i (0 < d <= D),
    weight w(d) = 4/(4+d^2), in raw units and in unfolded units
    dtilde = N(gamma_j) - N(gamma_i), N(t) = t/2pi log(t/2pi e) + 7/8.

    Truncation at D: the neglected tail is bounded by
    2 * meandensity * int_D^inf w = O(12/D) ~ 0.02 relative, and only at
    alpha ~ 0 where all phases align; for alpha >~ 0.1 it is negligible.
    """
    gu = g / (2 * np.pi) * np.log(g / (2 * np.pi * np.e)) + 7.0 / 8.0
    dens_max = np.log(g[-1] / (2 * np.pi)) / (2 * np.pi)
    W_raw = np.zeros(int(D / bw_raw) + 2)
    W_unf = np.zeros(int(D * dens_max * 1.1 / bw_unf) + 2)
    k, npairs = 1, 0
    while True:
        d = g[k:] - g[:-k]
        m = d <= D
        if not m.any():
            break
        dm = d[m]
        w = 4.0 / (4.0 + dm * dm)
        W_raw += np.bincount((dm / bw_raw).astype(np.int64),
                             weights=w, minlength=len(W_raw))
        du = gu[k:][m] - gu[:-k][m]
        W_unf += np.bincount((du / bw_unf).astype(np.int64),
                             weights=w, minlength=len(W_unf))
        npairs += dm.size
        k += 1
    print(f"  gap histograms: {npairs} ordered pairs (d>0), max offset {k-1}")
    return W_raw, bw_raw, W_unf, bw_unf


def F_of_alpha(W, bw, thetas, N):
    """F = 1 + (2/N) sum_k W_k cos(theta d_k): diagonal gives exactly 1."""
    nz = np.nonzero(W)[0]
    c, Wn = (nz + 0.5) * bw, W[nz]
    out = np.empty(len(thetas))
    for i, th in enumerate(thetas):
        out[i] = 1.0 + (2.0 / N) * np.dot(np.cos(th * c), Wn)
    return out


def part_a(g):
    N, T = len(g), g[-1]
    logT = np.log(T)
    alphas = np.arange(0.0, 3.0001, 0.01)
    W_raw, bw_raw, W_unf, bw_unf = gap_histograms(g)
    F_raw = F_of_alpha(W_raw, bw_raw, alphas * logT, N)          # T^{i a (g-g')}
    F_unf = F_of_alpha(W_unf, bw_unf, 2 * np.pi * alphas, N)     # e^{2pi i a dt}
    F_th = np.where(alphas < 1, alphas + T ** (-2 * alphas) * logT, 1.0)

    sl = (alphas >= 0.30) & (alphas <= 0.95)
    pl = alphas >= 1.05
    fits = {}
    for name, F in (("raw", F_raw), ("unfolded", F_unf)):
        a1, a0 = np.polyfit(alphas[sl], F[sl], 1)
        fits[name] = (a1, a0, F[pl].mean(), F[pl].std())
        print(f"  F {name:9s}: slope on [0.30,0.95] = {a1:.3f} "
              f"(intercept {a0:+.3f});  plateau [1.05,3] = "
              f"{F[pl].mean():.3f} +/- {F[pl].std():.3f}   [theory: 1, 0, 1]")
    print(f"  finite-T normalization ratio logT/(log(T/2pi)-1) = "
          f"{logT / (np.log(T / (2 * np.pi)) - 1):.3f} "
          f"(raw N(T)^-1 form sits above alpha by about this factor)")
    for a in (0.5, 1.0, 1.5, 2.0, 2.5, 3.0):
        i = np.argmin(np.abs(alphas - a))
        print(f"    alpha={a:.2f}: F_raw={F_raw[i]:.3f}  F_unf={F_unf[i]:.3f}  "
              f"theory={F_th[i]:.3f}")
    return alphas, F_raw, F_unf, F_th, fits


# ----------------------------------------------------------------------
# (b) Goldston-Montgomery variance of psi in short intervals
# ----------------------------------------------------------------------
def part_b(X=10 ** 6):
    hs_main = [100, 1000, 10000]
    hs_sweep = np.unique(np.round(np.logspace(1, 4.48, 30)).astype(int))
    hmax = int(hs_sweep[-1])
    lam = sieve_lambda(X + hmax)
    S = np.cumsum(lam)                        # S[n] = psi(n)
    rows, sweep = {}, []
    for h in sorted(set(hs_main) | set(hs_sweep.tolist())):
        d = S[h:h + X] - S[:X] - h            # x = 0..X-1
        var = float(np.mean(d * d))
        Bh = var / h - np.log(X / h)
        sweep.append((h, var / h))
        if h in hs_main:
            pred = h * (np.log(X / h) + B_PRED)
            rows[h] = (var, pred, Bh)
            print(f"  h={h:5d}: Var={var:12.1f}  GM/MS pred={pred:12.1f}  "
                  f"ratio={var / pred:.3f}  fitted B={Bh:+.3f} "
                  f"(pred {B_PRED:+.3f})")
    sweep = np.array(sweep)
    L = np.log(X / sweep[:, 0])
    a1, a0 = np.polyfit(L, sweep[:, 1], 1)
    print(f"  global fit over {len(sweep)} h in [10, 30000]:  "
          f"Var/h = {a1:.3f} log(X/h) {a0:+.3f}   "
          f"[GM/MS: 1.000 {B_PRED:+.3f}]")
    return rows, sweep, (a1, a0)


# ----------------------------------------------------------------------
# (c) the two weight laws (illustration only; derivation in notes/DSIDE.md)
# ----------------------------------------------------------------------
def part_c_kernels(X=10 ** 6):
    # D-side Cesaro kernel envelope: |mu_X(delta)| = |B(i delta, 2)| saturated
    # at mu_X(0) = log(X/2) - 1 (the sharp-endpoint 2^{i delta}/delta ringing is
    # frequency-zero in log X and belongs to the smooth layer; see DSIDE.md)
    delta = np.logspace(-2, 3, 400)
    mu = np.minimum(np.log(X / 2.0) - 1.0,
                    1.0 / (delta * np.sqrt(1.0 + delta ** 2)))
    # S-side weight |Gamma(rho)Gamma(rho')/Gamma(rho+rho'+2)| on the diagonal
    # gamma = gamma' = s/2 (same sign), as a function of the pair-sum s.
    s = np.logspace(np.log10(30), 3, 200)
    rho = 0.5 + 0.5j * s
    Wsum = np.abs(np.exp(2 * loggamma(rho) - loggamma(2 * rho + 2)))
    return delta, mu, s, Wsum


# ----------------------------------------------------------------------
def main():
    g = load_zeros()
    print("(a) Montgomery F(alpha), T = gamma_100000 =", g[-1])
    alphas, F_raw, F_unf, F_th, fits = part_a(g)
    print("(b) psi short-interval variance, X = 1e6")
    rows, sweep, (a1, a0) = part_b()
    delta, mu, s, Wsum = part_c_kernels()

    fig, ax = plt.subplots(1, 3, figsize=(15.5, 4.6))
    for a in ax:
        a.grid(True, lw=0.4, alpha=0.35)
        a.set_axisbelow(True)

    # --- panel (a)
    ax[0].plot(alphas, F_raw, color=C_DATA, lw=1.6,
               label=r"data, raw: $N^{-1}\sum T^{i\alpha(\gamma-\gamma')}w$")
    ax[0].plot(alphas, F_unf, color=C_ALT, lw=1.6,
               label="data, unfolded ordinates")
    ax[0].plot(alphas, F_th, color=C_PRED, lw=1.4, ls="--",
               label=r"$\min(\alpha+T^{-2\alpha}\log T,\ 1)$")
    ax[0].axvline(1.0, color=C_REF, lw=0.8, ls=":")
    ax[0].text(1.03, 2.55, r"$\alpha=1$: theorem $\to$ conjecture",
               fontsize=8, color="#555550", rotation=90, va="top")
    ax[0].set_xlim(0, 3), ax[0].set_ylim(0, 2.9)
    ax[0].set_xlabel(r"$\alpha$"), ax[0].set_ylabel(r"$F(\alpha)$")
    ax[0].legend(fontsize=8, loc="upper right")
    su, pu = fits["unfolded"][0], fits["unfolded"][2]
    ax[0].set_title(f"(a) Montgomery $F$, 100k zeros: unfolded slope {su:.3f}, "
                    f"plateau {pu:.3f}", fontsize=10)

    # --- panel (b)
    L = np.log(1e6 / sweep[:, 0])
    ax[1].plot(L, sweep[:, 1], "o", ms=5, color=C_DATA, mec="white", mew=0.8,
               label="measured Var$/h$")
    Lg = np.linspace(L.min(), L.max(), 2)
    ax[1].plot(Lg, Lg + B_PRED, color=C_PRED, lw=1.4, ls="--",
               label=r"GM/MS: $\log(X/h)-\gamma-\log 2\pi$")
    ax[1].plot(Lg, a1 * Lg + a0, color=C_ALT, lw=1.2,
               label=f"fit: {a1:.3f}$\\,\\log(X/h)$ {a0:+.3f}")
    for h in (100, 1000, 10000):
        var, pred, Bh = rows[h]
        x = np.log(1e6 / h)
        ax[1].annotate(f"$h=10^{{{int(np.log10(h))}}}$", (x, var / h),
                       textcoords="offset points", xytext=(6, -11), fontsize=8)
    ax[1].set_xlabel(r"$\log(X/h)$")
    ax[1].set_ylabel(r"Var$(X,h)/h$")
    ax[1].legend(fontsize=8, loc="upper left")
    ax[1].set_title(r"(b) $\psi(x+h)-\psi(x)-h$ variance, $X=10^6$",
                    fontsize=10)

    # --- panel (c)
    ax[2].loglog(delta, mu, color=C_DATA, lw=1.6,
                 label=r"D-side $|\mu_X(\gamma-\gamma')|$ envelope, $X=10^6$")
    ax[2].loglog(s, Wsum, color=C_PRED, lw=1.6,
                 label=r"S-side $|W(\gamma,\gamma')|$ vs $\gamma+\gamma'$")
    ax[2].loglog(s, 2.2 * s ** -2.5, color=C_REF, lw=0.9, ls=":",
                 label=r"slopes $-2.5$ / $-2$")
    ax[2].loglog(delta[delta > 1], 0.8 * delta[delta > 1] ** -2.0,
                 color=C_REF, lw=0.9, ls=":")
    ax[2].set_xlabel(r"$|\gamma\mp\gamma'|$ (difference / sum)")
    ax[2].set_ylabel("pair weight")
    ax[2].legend(fontsize=8, loc="lower left")
    ax[2].set_title("(c) weight laws: absolutely summable (S, theorem)\n"
                    "vs near-diagonal $\\log X$ mass (D, needs $F$)",
                    fontsize=10)

    fig.tight_layout()
    fig.savefig(FIG / "exp17_dside.png", dpi=140)
    print("saved figures/exp17_dside.png")


if __name__ == "__main__":
    main()
