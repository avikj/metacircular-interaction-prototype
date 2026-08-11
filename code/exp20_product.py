"""Experiment 20: THE PRODUCT-WEIGHTED PAIR OBJECT
(STATE.md target 1; corrected form of the refuted APPENDIX_D.md D.6(3);
constructive counterpart of the no-go of notes/PRODUCT_WEIGHT_NO_GO.md).

Companion note: notes/PRODUCT.md.

Background
----------
SCREW.md section 4: under RH the Matsumoto-Suzuki screw theorem gives a
positive measure with masses a(gamma) = 1/(gamma^2+1/4) on SINGLE zero
frequencies; the product measure with masses a(gamma)a(gamma') on pair sums
gamma+gamma' is then positive as a corollary.  PRODUCT_WEIGHT_NO_GO.md
(verified independently in PRODUCT.md section 1) proves no kernel of m+n
alone can carry these factorized weights (the Beta coupling
Gamma(z)Gamma(w)/Gamma(z+w) is intrinsic to additive smoothing); the unique
honest carrier is a SEPARABLE (rank-one) kernel.  This experiment builds
that carrier exactly and verifies the resulting identity at exp6b precision.

The carrier (PRODUCT.md, Theorem P1)
------------------------------------
Krein-string kernel:  int_0^infty min(X,t) t^{s-2} dt = X^s/(s(1-s)),
0 < Re s < 1.  The compensated one-body sum

    Phi(X) := X int_X^infty (psi(t)-t) t^{-2} dt
            = lim_N [ sum_{n<=N} Lambda(n) min(1,X/n) - X(log(N/X)+1) ]
            = - sum_rho X^rho/(rho(1-rho)) - log 2pi + O(X^{-2})

(unconditional, absolutely convergent zero sum).  Under RH,
Phi(X) = -sqrt(X) h(log X) - log 2pi + O(X^{-2}) with
h(u) = 2 sum_{gamma>0} cos(gamma u)/(gamma^2+1/4), and the doubly-reweighted
pair sum G_w(X) = "sum_{m,n} Lambda(m)Lambda(n) min(1,X/m)min(1,X/n),
compensated" = Phi(X)^2 obeys the EXACT layer decomposition (Theorem P2):

    Phi(X)^2 = m0 X                                    [main = diagonal DC]
             + X sum_{gamma+gamma' != 0} a a' e^{i(gamma+gamma')log X}
                                                       [pair layer, masses >0]
             + 2 log(2pi) sqrt(X) h(log X)             [first variation = MS
                                                        screw data]
             + log^2(2pi) + O(X^{-3/2})                [smooth]

with m0 = sum_gamma a(gamma)^2 (signed ordinates).  The pair layer is
h(u)^2 - DC: pointwise a square, all spectral masses a(gamma)a(gamma') > 0.

What this experiment does
-------------------------
(1) computes Phi_N(X) from Lambda up to N = 2*10^6 by the exact finite form
        Phi_N(X) = psi(X) + X(Sl(N)-Sl(X)) - (X/N) psi(N) - X log(N/X),
        Sl(y) = sum_{n<=y} Lambda(n)/n,
    whose deficit from Phi(X) is EXACTLY linear in X (removed by lstsq
    together with the constant -log 2pi); checks the first-variation layer:
    q(u) := -residual/sqrt(X) against the zero-side h(u), band [8, 26.5]
    (single-zero lines only), target corr ~ 1 (the exp12 Part-5 check, now
    for the min-kernel);
(2) THE NEW IDENTITY: squares the residual, P(u) := q(u)^2, and compares to
    the product-weighted pair model h(u)^2 in the sum-spectrum band [28,60]
    (pair lines 2g1=28.27, g1+g2=35.16, g1+g3=39.15, 2g2=42.05, ...);
    identical detrending pipeline applied to model and data; target
    corr > 0.99 (exp6b precision); also checks the positive DC mass
    mean(P) ~ m0 -- the "main term = diagonal" prediction;
(3) Krein positivity of the product pair layer: g_2(t) := h(t)^2 - h(0)^2
    is a screw function (Krein kernel PSD on uniform and random grids) --
    the corrected form of the refuted D.6(3) -- while the Beta-weighted pair
    layer A(u) of Theorem D stays maximally indefinite (exp12 Part 4 control,
    reproduced);
(4) the two pair measures side by side: binned masses on the sum spectrum --
    product masses all positive, Beta masses signed/complex;
(5) variance ~ diagonal in the product metric (PRODUCT.md Theorem P4):
    V(L) = (1/L) int h^4 phi_L -> D0 = 3(m0^2 - S4) as L -> infinity, with
    the Jensen floor V >= [(1/L) int h^2 phi_L]^2 ~ m0^2 valid at EVERY L
    (positivity gives the lower bound for free; no separation input).

Figure: ../figures/exp20_product.png
"""
import numpy as np
import matplotlib
matplotlib.use("Agg")
import matplotlib.pyplot as plt
from pathlib import Path
from pairfield import sieve_lambda, load_zeros
from exp12_screw import (krein_kernel_uniform, krein_kernel_grid, eig_report,
                         pair_layer_factory)

FIG = Path(__file__).resolve().parent.parent / "figures"
LOG2PI = np.log(2 * np.pi)
EULER_GAMMA = 0.5772156649015329


# ------------------------------------------------------------------ builders
def h_factory(gam):
    """h(t) = sum_{gamma signed} e^{i gamma t}/(gamma^2+1/4)
            = 2 sum_{gamma>0} cos(gamma t)/(gamma^2+1/4)."""
    c = 2.0 / (gam ** 2 + 0.25)

    def h(t):
        t = np.asarray(t, float)
        tf = t.ravel()
        out = np.zeros(tf.size)
        for ch in range(0, gam.size, 4000):
            out += np.cos(np.outer(tf, gam[ch:ch + 4000])) @ c[ch:ch + 4000]
        return out.reshape(t.shape)

    return h


def bandpass(y, u, lo, hi):
    M = y.size
    Y = np.fft.rfft(y - y.mean())
    f = np.fft.rfftfreq(M, d=(u[1] - u[0])) * 2 * np.pi
    Y[(f < lo) | (f > hi)] = 0
    return np.fft.irfft(Y, M)


def bin_measure(freqs, w, lo=20.0, hi=100.0, res=0.02):
    """Bin the measure sum w_i delta_{freqs_i} restricted to [lo,hi]."""
    sel = (freqs > lo) & (freqs < hi)
    key = np.round(freqs[sel] / res).astype(np.int64)
    order = np.argsort(key)
    key, wv = key[order], w[sel][order]
    cuts = np.nonzero(np.diff(key))[0] + 1
    starts = np.concatenate([[0], cuts])
    masses = np.add.reduceat(wv, starts)
    omegas = key[starts] * res
    keep = np.abs(masses) > 0
    return omegas[keep], masses[keep]


# ----------------------------------------------------------------------- main
def main():
    rng = np.random.default_rng(20)
    gam_all = load_zeros()
    gam = gam_all[:10000]
    apos = 1.0 / (gam ** 2 + 0.25)          # a(gamma), gamma > 0
    B = 2.0 * apos.sum()                    # sum over signed gammas
    B_th = 2 + EULER_GAMMA - np.log(4 * np.pi)
    m0 = 2.0 * (apos ** 2).sum()            # sum_gamma a(gamma)^2 (signed)
    S4 = 2.0 * (apos ** 4).sum()
    D0 = 3.0 * (m0 ** 2 - S4)               # diagonal of the quadruple sum
    h = h_factory(gam)

    print("=" * 78)
    print("PART 0: spectral constants of the product metric")
    print("=" * 78)
    print(f"  B  = sum_rho 1/(rho(1-rho))  (10^4 zeros) = {B:.6f}   "
          f"(exact {B_th:.6f})")
    print(f"  m0 = sum_gamma a(gamma)^2 = {m0:.6e}   (positive DC mass of h^2)")
    print(f"  S4 = sum_gamma a(gamma)^4 = {S4:.6e}")
    print(f"  D0 = 3(m0^2 - S4)         = {D0:.6e}   (variance diagonal)")
    print(f"  Omega-constant sqrt(m0)   = {np.sqrt(m0):.6f}   "
          f"(limsup |Phi(X)|/sqrt(X) >= sqrt(m0))")

    print()
    print("=" * 78)
    print("PART 1: arithmetic side -- Phi_N(X) from Lambda to 2e6, exact form")
    print("=" * 78)
    N = 2_000_000
    lam = sieve_lambda(N)
    psi = np.cumsum(lam)                    # psi[k] = psi(k)
    nn = np.arange(N + 1, dtype=float)
    nn[0] = 1.0
    Sl = np.cumsum(lam / nn)                # Sl[k] = sum_{n<=k} Lambda(n)/n

    M = 4096
    u = np.linspace(np.log(3e3), np.log(1.5e6), M)
    X = np.exp(u)
    iX = np.floor(X).astype(np.int64)
    PhiN = psi[iX] + X * (Sl[N] - Sl[iX]) - (X / N) * psi[N] - X * np.log(N / X)
    print(f"  grid: X in [3e3, 1.5e6], M = {M} log-uniform points; N = {N}")
    print(f"  Phi_N(X) = Phi(X) - c_N X exactly (deficit linear in X)")

    # detrend: exactly-known smooth span {X (deficit), 1 (-log 2pi)} + sqrt(X)
    basis = np.vstack([X, np.sqrt(X), np.ones(M)]).T
    coef, *_ = np.linalg.lstsq(basis, PhiN, rcond=None)
    r = PhiN - basis @ coef
    q = -r / np.sqrt(X)                     # arithmetic estimate of h(log X)

    # identical pipeline on the zero-side model (shares detrend systematics)
    h_u = h(u)
    Phi_syn = -np.sqrt(X) * h_u - LOG2PI
    coef_s, *_ = np.linalg.lstsq(basis, Phi_syn, rcond=None)
    q_syn = -(Phi_syn - basis @ coef_s) / np.sqrt(X)

    core = slice(M // 8, -M // 8)
    b1d = bandpass(q, u, 8.0, 26.5)
    b1m = bandpass(q_syn, u, 8.0, 26.5)
    corr1 = np.corrcoef(b1d[core], b1m[core])[0, 1]
    rat1 = np.std(b1d[core]) / np.std(b1m[core])
    print(f"  first variation (MS screw data), band [8,26.5] "
          f"(single lines g1..g3):")
    print(f"    corr(arithmetic q, zero-side h) = {corr1:.4f},  "
          f"amplitude ratio = {rat1:.4f}")

    print()
    print("=" * 78)
    print("PART 2: the product identity -- P = q^2 vs pair model h^2, band [28,60]")
    print("=" * 78)
    P = q ** 2
    P_syn = q_syn ** 2                      # pipeline model (systematics-matched)
    P_pure = h_u ** 2                       # pure product-weighted pair model
    b2d = bandpass(P, u, 28.0, 60.0)
    b2m = bandpass(P_syn, u, 28.0, 60.0)
    b2p = bandpass(P_pure, u, 28.0, 60.0)
    corr2 = np.corrcoef(b2d[core], b2m[core])[0, 1]
    rat2 = np.std(b2d[core]) / np.std(b2m[core])
    corr2p = np.corrcoef(b2d[core], b2p[core])[0, 1]
    rat2p = np.std(b2d[core]) / np.std(b2p[core])
    print(f"  sum-spectrum band [28,60] (pair lines 2g1=28.27 ... ):")
    print(f"    corr(P, pipeline model)      = {corr2:.4f},  "
          f"amplitude ratio = {rat2:.4f}")
    print(f"    corr(P, pure h^2 model)      = {corr2p:.4f},  "
          f"amplitude ratio = {rat2p:.4f}")
    meanP, meanM = P[core].mean(), P_pure[core].mean()
    print(f"  positive DC (main = diagonal): mean P = {meanP:.4e},  "
          f"mean h^2 = {meanM:.4e},  m0 = {m0:.4e}")
    print(f"    ratio mean(P)/mean(h^2) = {meanP/meanM:.4f}")
    rmsd, rmsm = np.std(b2d[core]), np.std(b2p[core])
    print(f"  band RMS: data {rmsd:.3e}, model {rmsm:.3e} "
          f"(Parseval closure in the new metric)")

    print()
    print("=" * 78)
    print("PART 3: Krein positivity -- g_2 = h^2 - h(0)^2 IS a screw function")
    print("=" * 78)
    h0 = float(h(np.array([0.0]))[0])

    def g2(t):
        return h(t) ** 2 - h0 ** 2

    K160, asym, _ = krein_kernel_uniform(g2, 160, 40.0)
    print(f"  (kernel asymmetry before symmetrization: {asym:.2e})")
    ev_g2, rel_g2 = eig_report(K160, "g_2 (product pair layer), n=160, T=40")
    K12, _, _ = krein_kernel_uniform(g2, 160, 12.0)
    eig_report(K12, "g_2, n=160, T=12")
    worst = 0.0
    for k in range(5):
        t = np.sort(rng.uniform(-40, 40, 80))
        Kr, _ = krein_kernel_grid(g2, t)
        ev = np.linalg.eigvalsh(Kr)
        worst = min(worst, ev.min() / np.abs(ev).max())
    print(f"  5 random grids (n=80): worst min/|max| = {worst:+.2e}")
    print(f"  ==> product pair layer PSD: {rel_g2 > -1e-10 and worst > -1e-10}"
          f"   (corrected D.6(3): positivity DOES hold with product weights)")

    # control: Beta-weighted pair layer (Theorem D) stays indefinite
    A, freqsW, wW = pair_layer_factory(gam_all, 300)
    KA, _, _ = krein_kernel_uniform(A, 120, 25.0)
    ev_A, rel_A = eig_report(KA, "Beta pair layer A(u) (Thm D), n=120, T=25")
    print(f"  ==> Beta-weighted layer indefinite (min/|max| = {rel_A:+.2f}):"
          f" the no-go is real")

    print()
    print("=" * 78)
    print("PART 4: the two pair measures on the sum spectrum [20,100]")
    print("=" * 78)
    K2 = 300
    s = np.concatenate([gam_all[:K2], -gam_all[:K2]])
    a_s = 1.0 / (s ** 2 + 0.25)
    fr_pr = (s[:, None] + s[None, :]).ravel()
    w_pr = (a_s[:, None] * a_s[None, :]).ravel()
    om_p, ms_p = bin_measure(fr_pr, w_pr)
    om_b, ms_b = bin_measure(freqsW, wW)
    print(f"  product measure: {ms_p.size} lines, min mass = "
          f"{ms_p.real.min():+.3e}  (all positive: {bool((ms_p.real > 0).all())},"
          f" max |Im|/|mass| = {np.abs(ms_p.imag).max()/np.abs(ms_p).max():.1e})")
    fneg = np.mean(ms_b.real < 0)
    print(f"  Beta measure:    {ms_b.size} lines, fraction Re<0 = {fneg:.2f},  "
          f"mean |Im|/|mass| = {np.mean(np.abs(ms_b.imag)/np.abs(ms_b)):.2f}")

    print()
    print("=" * 78)
    print("PART 5: variance -> diagonal, with the Jensen floor at every L")
    print("=" * 78)
    hV = h_factory(gam_all[:3000])
    m0V = 2.0 * np.sum((1.0 / (gam_all[:3000] ** 2 + 0.25)) ** 2)
    S4V = 2.0 * np.sum((1.0 / (gam_all[:3000] ** 2 + 0.25)) ** 4)
    D0V = 3.0 * (m0V ** 2 - S4V)
    u0 = 12.0
    Ls = np.array([4.0, 8.0, 16.0, 32.0, 64.0, 128.0])
    Vs, MLs = [], []
    for L in Ls:
        du = 0.002
        ug = np.arange(u0 - L, u0 + L, du)
        hh = hV(ug)
        phi = 1.0 - np.abs(ug - u0) / L
        Vs.append(np.sum(hh ** 4 * phi) * du / L)
        MLs.append(np.sum(hh ** 2 * phi) * du / L)
    Vs, MLs = np.array(Vs), np.array(MLs)
    print(f"  D0 (3000 zeros) = {D0V:.4e};  Jensen floor m0^2 = {m0V**2:.4e}")
    print("     L      V(L)         M_L (2nd mom)   V/D0    V >= M_L^2 ?")
    for L, V, ML in zip(Ls, Vs, MLs):
        print(f"  {L:6.0f}  {V:.4e}   {ML:.4e}    {V/D0V:5.2f}   "
              f"{'yes' if V >= ML**2 else 'NO'}")

    # ------------------------------------------------------------- figure
    fig, ax = plt.subplots(2, 2, figsize=(13.5, 9.2))

    a = ax[0, 0]
    a.plot(X[core], b1d[core], lw=0.7,
           label="arithmetic $q(u)=-\\Phi$-residual$/\\sqrt{X}$")
    a.plot(X[core], b1m[core], lw=0.7, alpha=0.85,
           label="zero side $h(u)$, same pipeline")
    a.set_xscale("log")
    a.set_xlabel("X")
    a.set_title("First variation in the min-kernel: MS screw data\n"
                f"band [8, 26.5]: corr = {corr1:.4f}, ratio = {rat1:.3f}")
    a.legend(fontsize=8)

    a = ax[0, 1]
    a.plot(X[core], b2d[core], lw=0.7,
           label="arithmetic $P(u) = q(u)^2$")
    a.plot(X[core], b2m[core], lw=0.7, alpha=0.85,
           label="product pair model $h(u)^2$, same pipeline")
    a.set_xscale("log")
    a.set_xlabel("X")
    a.set_title("THE PRODUCT IDENTITY: pair layer of $\\Phi(X)^2$\n"
                f"sum-spectrum band [28, 60]: corr = {corr2:.4f}, "
                f"ratio = {rat2:.3f}")
    a.legend(fontsize=8)

    a = ax[1, 0]
    a.plot(om_b, ms_b.real, "+", ms=4, color="tab:purple",
           label=r"Beta weights $W$ (Thm D): Re mass, signed")
    a.plot(om_p, ms_p.real, ".", ms=3, color="tab:green",
           label=r"product weights $aa'$: all masses $>0$")
    a.axhline(0, color="k", lw=0.6)
    a.set_yscale("symlog", linthresh=1e-9)
    a.set_xlabel(r"$\omega = \gamma+\gamma'$")
    a.set_ylabel("line mass (symlog)")
    a.set_title("Two measures on the sum spectrum:\n"
                "Beta-coupled = complex-phased (no-go); product = positive")
    a.legend(fontsize=8)

    a = ax[1, 1]
    a.loglog(Ls, Vs, "o-", color="tab:blue",
             label=r"$V(L)=\frac{1}{L}\int h^4\phi_L$")
    a.loglog(Ls, MLs ** 2, "s--", color="tab:orange",
             label=r"Jensen floor $M_L^2$ (free lower bound)")
    a.axhline(D0V, color="tab:green", lw=1.0, ls=":",
              label=r"diagonal $D_0=3(m_0^2-S_4)$")
    a.axhline(m0V ** 2, color="tab:red", lw=1.0, ls=":",
              label=r"$m_0^2$")
    a.set_xlabel("window length L")
    a.set_title("Variance $\\to$ diagonal in the product metric\n"
                "(positivity: $V \\geq M_L^2$ at every $L$, no separation input)")
    a.legend(fontsize=8)

    fig.tight_layout()
    FIG.mkdir(exist_ok=True)
    fig.savefig(FIG / "exp20_product.png", dpi=140)
    print("\nsaved figures/exp20_product.png")


if __name__ == "__main__":
    main()
