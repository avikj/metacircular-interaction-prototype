"""Experiment 12: NUMERICAL TEST OF THE MATSUMOTO-SUZUKI SCREW FUNCTION
(the "screw-kernel join" of APPENDIX_D.md, section D.6, item 3).

References
----------
[MS] K. Matsumoto, M. Suzuki, "M-functions and screw functions originating
     from Goldbach's problem and zeros of the Riemann zeta function",
     arXiv:2409.00888v2, J. Number Theory 280 (2026) 918-946.
[S]  M. Suzuki, "Aspects of the screw function corresponding to the Riemann
     zeta function", arXiv:2206.03682, J. London Math. Soc. (2023).

Objects (full dictionary in notes/SCREW.md)
-------------------------------------------
[MS (1.2), Fujii]   sum_{n<=X} (Lambda*Lambda)(n) = X^2/2 - 2 X^{3/2} H(X) + R(X),
                    H(X)  = sum_rho X^{rho-1/2} / (rho(rho+1)).
[MS (1.6)]          sum_{n<=X} n^{-2} (Lambda*Lambda)(n)
                       = log X + c_2 + 2 X^{-1/2} H_1(X) + E(X),
                    H_1(X) = sum_rho X^{rho-1/2} / (rho(1-rho)).
[MS Thm 1.3]        g_{H_1}(t) := H_1(e^t) - H_1(1) is a screw function on R
                    if and only if RH holds.
Screw function:     g continuous, g(-t) = conj(g(t)), and the Krein kernel
                    G_g(t,u) = g(t-u) - g(t) - g(-u) + g(0)
                    is nonnegative definite on R x R.

Under RH (zeros used here are on the line):
    g_{H_1}(t) = sum_{gamma signed} (e^{i gamma t} - 1) / (gamma^2 + 1/4)
               = 2 sum_{gamma>0} (cos(gamma t) - 1) / (gamma^2 + 1/4),
a Krein screw function with POSITIVE spectral masses 1/(gamma^2+1/4) on the
SINGLE-zero spectrum {gamma}: this is the first-variation (single-zero) layer
of the Goldbach summatory function, NOT the zero-pair layer of Theorem D.

What this experiment does
-------------------------
(1) builds g_{H_1} from the first K zeros (K = 1000..10000), checks the
    structural axioms (g(0)=0, real, even, continuous, K-convergence);
(2) tests Krein positivity: eigenvalues of the sampled kernel G_g on uniform
    and random grids (expected: PSD to machine precision, since zeros are on
    the line and masses are positive);
(3) control experiments:
    (a) g_H built from the UNsymmetrized denominator rho(rho+1) of Fujii's
        formula: fails the screw axiom g(-t)=conj g(t) (complex masses; the
        kernel is not even symmetric), and the symmetric part of its Krein
        kernel comes out NEGATIVE definite (all Re[1/(rho(rho+1))] < 0 on the
        line) -- shows why [MS] pass from H to the rho <-> 1-rho symmetric H_1;
    (b) an off-line zero quadruple beta +- i gamma_1, 1-beta +- i gamma_1
        injected into g_{H_1}: the kernel acquires large negative eigenvalues
        (the criterion detects RH violations), swept over beta in (1/2, 1);
(4) the pair-layer contrast: the second-variation object of Theorem D,
        A(u) = sum_{gamma,gamma'} W(gamma,gamma') e^{i(gamma+gamma')u},
        W = Gamma(rho)Gamma(rho')/Gamma(rho+rho'+2),
    has COMPLEX masses on the sum-spectrum {gamma_i+gamma_j}; we bin the
    measure sum W delta_{gamma_i+gamma_j}, show it is NOT a positive measure,
    and show the Krein kernel of A is indefinite: the naive "screw-kernel
    join" of APPENDIX_D.md D.6(3) fails as stated (an honest negative result);
(5) prime-side check of the dictionary: computes the arithmetic side of
    [MS (1.6)] from Lambda up to 3*10^6 and correlates its oscillating part,
    band-passed to [8, 26.5] (only single-zero lines gamma_1..gamma_3 live
    there; pair lines start at 2 gamma_1 = 28.27), against the zero-side
    H_1(X): their screw function is literally computable from Goldbach data.

Figure: ../figures/exp12_screw.png
"""
import numpy as np
import matplotlib
matplotlib.use("Agg")
import matplotlib.pyplot as plt
from pathlib import Path
from scipy.special import loggamma
from pairfield import sieve_lambda, load_zeros, additive_convolution

FIG = Path(__file__).resolve().parent.parent / "figures"
EULER_GAMMA = 0.5772156649015329


# ----------------------------------------------------------------- g builders
def g_h1_factory(gam):
    """g_{H_1}(t) = 2 sum_{gamma>0} (cos(gamma t)-1)/(gamma^2+1/4)  (RH form)."""
    mass = 2.0 / (gam ** 2 + 0.25)

    def g(t):
        t = np.asarray(t, float)
        tf = t.ravel()
        out = np.zeros(tf.size)
        for ch in range(0, gam.size, 4000):
            out += (np.cos(np.outer(tf, gam[ch:ch + 4000])) - 1.0) @ mass[ch:ch + 4000]
        return out.reshape(t.shape)

    return g, mass


def g_h_factory(gam):
    """g_H(t) = H(e^t)-H(1), H = sum_rho X^{rho-1/2}/(rho(rho+1)): complex masses."""
    rho = 0.5 + 1j * gam
    c = 1.0 / (rho * (rho + 1))          # NOT real: Im c != 0

    def g(t):
        t = np.asarray(t, float)
        tf = t.ravel()
        out = np.zeros(tf.size)
        for ch in range(0, gam.size, 4000):
            E = np.exp(1j * np.outer(tf, gam[ch:ch + 4000])) - 1.0
            out += 2.0 * np.real(E @ c[ch:ch + 4000])
        return out.reshape(t.shape)

    return g


def g_offline_factory(gam, beta, K):
    """g_{H_1} with the first zero pair replaced by the off-line quadruple
    {beta +- i gamma_1, 1-beta +- i gamma_1} (functional-equation symmetric)."""
    g0, _ = g_h1_factory(gam[1:K])
    z = np.array([beta + 1j * gam[0], 1 - beta + 1j * gam[0]])
    D = z * (1 - z)

    def g(t):
        t = np.asarray(t, float)
        extra = np.zeros(t.shape)
        for zz, dd in zip(z, D):
            extra = extra + 2.0 * np.real((np.exp((zz - 0.5) * t) - 1.0) / dd)
        return g0(t) + extra

    return g


def pair_layer_factory(gam, K2):
    """Second-variation layer A(u) = sum W(g,g') e^{i(g+g')u} of Theorem D."""
    s = np.concatenate([gam[:K2], -gam[:K2]])
    rho = 0.5 + 1j * s
    LG = loggamma(rho)
    W = np.exp(LG[:, None] + LG[None, :] - loggamma(rho[:, None] + rho[None, :] + 2))
    freqs = (s[:, None] + s[None, :]).ravel()
    w = W.ravel()

    def A(t):
        t = np.asarray(t, float)
        tf = t.ravel()
        out = np.zeros(tf.size, complex)
        for ch in range(0, freqs.size, 200000):
            out += np.exp(1j * np.outer(tf, freqs[ch:ch + 200000])) @ w[ch:ch + 200000]
        return np.real(out).reshape(t.shape)

    return A, freqs, w


# ------------------------------------------------------------- Krein kernels
def krein_kernel_uniform(g, n, T):
    """G_g(t_i,t_j) on the uniform grid t in [-T,T]; exploits t_i-t_j uniform."""
    t = np.linspace(-T, T, n)
    h = t[1] - t[0]
    d = g((np.arange(-(n - 1), n)) * h)          # g at all differences
    gt, gmt, g0 = g(t), g(-t), float(g(np.array([0.0]))[0])
    i = np.arange(n)
    K = d[i[:, None] - i[None, :] + (n - 1)] - gt[:, None] - gmt[None, :] + g0
    asym = np.abs(K - K.T).max()
    return 0.5 * (K + K.T), asym, t


def krein_kernel_grid(g, t):
    """G_g on an arbitrary grid (direct evaluation)."""
    D = t[:, None] - t[None, :]
    K = g(D) - g(t)[:, None] - g(-t)[None, :] + float(g(np.array([0.0]))[0])
    asym = np.abs(K - K.T).max()
    return 0.5 * (K + K.T), asym


def eig_report(K, label):
    ev = np.linalg.eigvalsh(K)
    rel = ev.min() / np.abs(ev).max()
    print(f"  {label:46s} min eig {ev.min():+.3e}  max eig {ev.max():+.3e}  "
          f"min/|max| {rel:+.2e}")
    return ev, rel


# -------------------------------------------------------------------- main
def main():
    rng = np.random.default_rng(12)
    gam_all = load_zeros()

    print("=" * 78)
    print("PART 1: g_{H_1} construction and structural axioms")
    print("=" * 78)
    Ks = [1000, 3000, 10000]
    gs = {K: g_h1_factory(gam_all[:K]) for K in Ks}
    tt = np.linspace(-40, 40, 801)
    ref = gs[10000][0](tt)
    for K in Ks[:-1]:
        print(f"  sup_t |g_K - g_10000| on [-40,40], K={K:5d}:  "
              f"{np.abs(gs[K][0](tt) - ref).max():.3e}")
    g1, mass1 = gs[10000]
    B_num = mass1.sum()
    B_th = 2 + EULER_GAMMA - np.log(4 * np.pi)
    print(f"  total mass sum_rho 1/(rho(1-rho)) truncated: {B_num:.6f}  "
          f"(exact 2+gamma_E-log 4pi = {B_th:.6f}; tail = {B_th-B_num:.2e})")
    print(f"  g(0) = {float(g1(np.array([0.0]))[0]):+.2e}   (axiom: g(0)=0, real)")
    print(f"  max |g(-t)-g(t)| = {np.abs(g1(-tt)-g1(tt)).max():.2e}   "
          f"(axiom: g(-t)=conj g(t); here g real even)")
    h = 1e-4
    print(f"  continuity: max |g(t+h)-g(t)|, h=1e-4: "
          f"{np.abs(g1(tt+h)-g1(tt)).max():.2e}")

    print()
    print("=" * 78)
    print("PART 2: Krein positivity of g_{H_1} (RH numerically true: zeros on line)")
    print("=" * 78)
    evs = {}
    K160, asym, tgrid = krein_kernel_uniform(g1, 160, 40.0)
    print(f"  (kernel asymmetry before symmetrization: {asym:.2e})")
    evs["gH1_T40"], rel1 = eig_report(K160, "g_{H_1}, uniform grid n=160, T=40")
    K2u, _, _ = krein_kernel_uniform(g1, 160, 12.0)
    eig_report(K2u, "g_{H_1}, uniform grid n=160, T=12")
    worst = 0.0
    for k in range(5):
        t = np.sort(rng.uniform(-40, 40, 80))
        Kr, _ = krein_kernel_grid(g1, t)
        ev = np.linalg.eigvalsh(Kr)
        worst = min(worst, ev.min() / np.abs(ev).max())
    print(f"  5 random grids (n=80, t in [-40,40]): worst min/|max| = {worst:+.2e}")
    psd_ok = rel1 > -1e-10 and worst > -1e-10
    print(f"  ==> Krein kernel PSD to machine precision: {psd_ok}")

    print()
    print("=" * 78)
    print("PART 3a: control -- unsymmetrized g_H (denominator rho(rho+1), Fujii layer)")
    print("=" * 78)
    gH = g_h_factory(gam_all[:10000])
    print(f"  max |g_H(-t)-g_H(t)| on [-40,40] = {np.abs(gH(-tt)-gH(tt)).max():.3e}"
          f"   <-- VIOLATES screw axiom g(-t)=conj g(t)")
    KH, asymH, _ = krein_kernel_uniform(gH, 160, 40.0)
    print(f"  (kernel asymmetry {asymH:.2e}; testing Hermitian part)")
    evs["gH"], relH = eig_report(KH, "g_H (rho(rho+1)), n=160, T=40")

    print()
    print("=" * 78)
    print("PART 3b: control -- off-line zero quadruple injected into g_{H_1}")
    print("=" * 78)
    goff = g_offline_factory(gam_all, 0.60, 3000)
    Koff, _, _ = krein_kernel_uniform(goff, 160, 40.0)
    evs["off060"], _ = eig_report(Koff, "off-line beta=0.60 (gamma_1 moved), T=40")
    betas = np.array([0.50, 0.55, 0.60, 0.65, 0.70, 0.75, 0.80, 0.85, 0.90, 0.95])
    minrel = []
    for b in betas:
        gb = g_offline_factory(gam_all, b, 3000)
        Kb, _, _ = krein_kernel_uniform(gb, 120, 25.0)
        ev = np.linalg.eigvalsh(Kb)
        minrel.append(ev.min() / np.abs(ev).max())
        print(f"    beta = {b:.2f}:  min/|max| eig = {minrel[-1]:+.3e}")
    minrel = np.array(minrel)

    print()
    print("=" * 78)
    print("PART 4: the pair layer (Theorem D second variation) is NOT of screw type")
    print("=" * 78)
    A, freqs, w = pair_layer_factory(gam_all, 400)
    # binned measure sum_{i,j} W_ij delta_{gamma_i+gamma_j} on [20,100]
    sel = (freqs > 20) & (freqs < 100)
    key = np.round(freqs[sel] / 0.02).astype(np.int64)
    order = np.argsort(key)
    key, wv = key[order], w[sel][order]
    cuts = np.nonzero(np.diff(key))[0] + 1
    masses = np.add.reduceat(wv, np.concatenate([[0], cuts]))
    masses = masses[np.abs(masses) > 0]        # drop underflowed opposite-sign bins
    frac_neg = np.mean(np.real(masses) < 0)
    wneg = np.abs(masses[np.real(masses) < 0]).sum() / np.abs(masses).sum()
    print(f"  binned pair measure on [20,100]: {masses.size} lines;")
    print(f"    fraction of lines with Re(mass) < 0: {frac_neg:.2f} "
          f"(carrying {wneg:.2f} of total |mass|);")
    print(f"    min Re = {np.real(masses).min():+.3e}, "
          f"max Re = {np.real(masses).max():+.3e}; "
          f"mean |Im(mass)|/|mass| = {np.mean(np.abs(np.imag(masses))/np.abs(masses)):.2f}")
    print(f"    ==> the measure sum W delta_(gamma+gamma') is complex, NOT positive")
    KA, asymA, _ = krein_kernel_uniform(A, 120, 25.0)
    evs["pair"], relA = eig_report(KA, "pair layer A(u), n=120, T=25")
    # consistency with Thm D': opposite-sign suppression
    opp = np.abs(freqs) < 1.0
    print(f"  (Thm D' check: mass fraction on |gamma+gamma'|<1 (opposite-sign) = "
          f"{np.abs(w[opp]).sum()/np.abs(w).sum():.2e})")

    print()
    print("=" * 78)
    print("PART 5: prime-side check of [MS (1.6)] -- their g is Goldbach data")
    print("=" * 78)
    NMAX = 3_000_000
    lam = sieve_lambda(NMAX)
    r = additive_convolution(lam)[: NMAX + 1]      # G(n) = (Lambda*Lambda)(n)
    n = np.arange(NMAX + 1, dtype=float)
    wgt = np.zeros(NMAX + 1)
    wgt[1:] = r[1:] / n[1:] ** 2
    Acum = np.cumsum(wgt)                          # sum_{k<=n} G(k)/k^2

    M = 4096
    u = np.linspace(np.log(3e4), np.log(2.9e6), M)
    Xs = np.exp(u)
    y_data = (Acum[Xs.astype(int)] - u) * np.sqrt(Xs) / 2.0   # = c2 sqrt(X)/2 + H1 + ...
    # remove the smooth layer (c2 e^{u/2}/2 and residual drift), keep oscillation
    basis = np.vstack([np.exp(u / 2) / 2, np.ones(M), u]).T
    coef, *_ = np.linalg.lstsq(basis, y_data, rcond=None)
    resid = y_data - basis @ coef
    print(f"  fitted c_2 = {coef[0]:+.4f}  (constant in MS (1.6))")

    # zero-side H_1(X) = 2 sum_{gamma>0} cos(gamma log X)/(gamma^2+1/4)
    H1 = np.zeros(M)
    for ch in range(0, 10000, 2000):
        gch = gam_all[ch:ch + 2000]
        H1 += np.cos(np.outer(u, gch)) @ (2.0 / (gch ** 2 + 0.25))

    def bandpass(y, lo=8.0, hi=26.5):
        Y = np.fft.rfft(y - y.mean())
        f = np.fft.rfftfreq(M, d=(u[1] - u[0])) * 2 * np.pi
        Y[(f < lo) | (f > hi)] = 0
        return np.fft.irfft(Y, M)

    bd, bm = bandpass(resid), bandpass(H1)
    core = slice(M // 8, -M // 8)
    corr = np.corrcoef(bd[core], bm[core])[0, 1]
    ratio = np.std(bd[core]) / np.std(bm[core])
    print(f"  band [8,26.5] in log X (single-zero lines gamma_1..gamma_3 only;")
    print(f"  pair lines start at 2 gamma_1 = {2*gam_all[0]:.2f}):")
    print(f"    corr(arithmetic, zero-side H_1) = {corr:.4f},  "
          f"amplitude ratio = {ratio:.4f}")

    # ------------------------------------------------------------- figure
    fig, ax = plt.subplots(2, 2, figsize=(13.5, 9.2))

    a = ax[0, 0]
    a.plot(tt, ref, lw=1.0, color="navy")
    a.axhline(-B_num, color="gray", lw=0.8, ls="--",
              label=r"$-\sum_\rho \frac{1}{\rho(1-\rho)} = -(2+\gamma_E-\log 4\pi)$")
    a.set_xlabel("t = log X")
    a.set_title(r"Matsumoto–Suzuki screw function $g_{H_1}(t)=H_1(e^t)-H_1(1)$"
                "\n(first 10,000 zeros; = first-variation / single-zero layer)")
    a.legend(fontsize=8)

    a = ax[0, 1]
    for lab, key_, col, mk in [
            (r"$g_{H_1}$ (RH): PSD", "gH1_T40", "tab:green", "."),
            (r"off-line $\beta=0.6$", "off060", "tab:red", "x"),
            (r"$g_H$: $\rho(\rho+1)$ masses (all $<0$)", "gH", "tab:orange", "+"),
            (r"pair layer $A(u)$ (Thm D)", "pair", "tab:purple", "1")]:
        ev = np.sort(evs[key_])[::-1]
        a.plot(np.arange(ev.size), ev, mk, ms=4, color=col, label=lab, lw=0)
    a.set_yscale("symlog", linthresh=1e-14)
    a.axhline(0, color="k", lw=0.6)
    a.set_xlabel("eigenvalue rank")
    a.set_ylabel("eigenvalue (symlog)")
    a.set_title("Krein kernel spectra: only $g_{H_1}$ is nonnegative definite")
    a.legend(fontsize=8)

    a = ax[1, 0]
    a.semilogy(betas, np.maximum(-minrel, 1e-17), "o-", color="tab:red")
    a.set_xlabel(r"$\beta$ (first zero moved to $\beta\pm i\gamma_1$, "
                 r"$1-\beta\pm i\gamma_1$)")
    a.set_ylabel(r"$-\lambda_{\min}/|\lambda|_{\max}$")
    a.set_title("Krein criterion detects an off-line zero\n"
                r"($\beta=1/2$: PSD to machine precision; $\beta>1/2$: indefinite)")
    a.grid(alpha=0.3)

    a = ax[1, 1]
    a.plot(Xs[core], bd[core], lw=0.7, label="arithmetic side of MS (1.6), band-passed")
    a.plot(Xs[core], bm[core], lw=0.7, alpha=0.85,
           label=r"zero side $H_1(X)$, band-passed")
    a.set_xscale("log")
    a.set_xlabel("X")
    a.set_title(f"Prime-side check: their screw data from Goldbach counts\n"
                f"band [8, 26.5]: corr = {corr:.3f}, amplitude ratio = {ratio:.3f}")
    a.legend(fontsize=8)

    fig.tight_layout()
    FIG.mkdir(exist_ok=True)
    fig.savefig(FIG / "exp12_screw.png", dpi=140)
    print("\nsaved figures/exp12_screw.png")


if __name__ == "__main__":
    main()
