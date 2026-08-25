"""Experiment 31: THE PRODUCT-WEIGHTED PAIR CARRIER.

Target (fleet STATE board, open target 1): identify the doubly-reweighted
smoothed Goldbach sum whose zero-pair layer carries the PRODUCT measure

    nu = sum_{gamma,gamma'} a(gamma) a(gamma') delta_{gamma+gamma'},
    a(gamma) = 1/(gamma^2 + 1/4) = 1/(rho(1-rho))|_RH  > 0,

(the Matsumoto-Suzuki screw masses, squared onto the sum spectrum) instead of
Theorem D's Beta weights Gamma(rho)Gamma(rho')/Gamma(rho+rho'+2).

By the fleet's no-go (PRODUCT_WEIGHT_NO_GO.md, verified in PRODUCT.md) no
kernel of m+n can do this; the carrier must be separable (per-variable).  The
interior carrier used here is the finite arithmetic sum

    S(X) = sum_{n<=X} Lambda(n) (X-n)/n  =  X * int_1^X psi(t) t^{-2} dt,

whose explicit formula (Proposition C1 of notes/PRODUCT_CARRIER.md) is,
UNCONDITIONALLY and with an ABSOLUTELY convergent zero sum,

    S(X) = X log X - (1+gamma_E) X + log 2pi + sum_rho X^rho/(rho(1-rho)) + delta(X),
    delta(X) = X int_X^inf (1/2) log(1-t^{-2}) t^{-2} dt,   |delta| <= X^{-2} (X>=2).

No fitted constants anywhere: c1 = 1+gamma_E and c0 = log 2pi are exact
(closed form I_inf = log 2 - 1 checked in Part 0).  The doubly-reweighted
Goldbach pair object is the finite double sum

    T(X,Y) = sum_{m<=X, n<=Y} Lambda(m)Lambda(n) (X-m)(Y-n)/(mn) = S(X) S(Y),

reweighted per-variable FIRST, diagonal X=Y taken at the END; its compensated
pair layer P(X) = (S(X)-M(X))^2 / X equals, under RH,

    P(X) = sum_{gamma,gamma'} a(gamma)a(gamma') e^{i(gamma+gamma') log X} + O(X^{-5/2})
         = integral e^{i omega log X} d nu(omega) + O(X^{-5/2}).

Parts:
  0. constants (I_inf = log2 - 1; B, m0, S4 and their truncation behavior)
  1. carrier identity: arithmetic q = (S-M)/sqrt(X) vs zero side h, NO fitting
  2. product pair layer: P = q^2 vs h^2 and vs the binned line model of nu;
     line table at 2g1, g1+g2, 2g2, g1+g3; absence of single-zero lines
  3. Appendix-D variance rerun in the product metric: diagonal
     D0 = 3(m0^2 - S4), Parseval closure in band, windowed variance V(L),
     Jensen floor
  4. off-line-zero injection: Krein kernel of nu goes indefinite for beta>1/2
     (and detection strength vs the one-body kernel)

Zeros: data/odlyzko_zeros_100k.txt.  Lambda to 4e6.
"""
import numpy as np
from scipy.integrate import quad
from scipy.special import loggamma
import matplotlib
matplotlib.use("Agg")
import matplotlib.pyplot as plt
from pathlib import Path
from pairfield import sieve_lambda, load_zeros

FIG = Path(__file__).resolve().parent.parent / "figures"
GE = np.euler_gamma
C_DATA, C_MODEL, C_MARK, C_NEG = "#1f77b4", "crimson", "0.55", "#7f3fbf"


# ----------------------------------------------------------------- utilities
def hann_amp(u, y, f):
    """Hann-windowed DFT amplitude of y(u) at angular frequency f."""
    w = np.hanning(len(u))
    z = (y - y.mean()) * w
    return abs(np.sum(z * np.exp(-1j * f * u))) / (w.sum() / 2)


def bandpass(y, u, lo, hi):
    Y = np.fft.rfft(y - y.mean())
    f = np.fft.rfftfreq(len(y), d=(u[1] - u[0])) * 2 * np.pi
    Y[(f < lo) | (f > hi)] = 0
    return np.fft.irfft(Y, len(y))


def h_model(u, gam, K, chunk=2000):
    """h(u) = 2 sum_{gamma>0} cos(gamma u)/(gamma^2+1/4), first K zeros."""
    out = np.zeros_like(u)
    for c in range(0, K, chunk):
        g = gam[c:c + K if False else c + chunk][: max(0, K - c)]
        if len(g) == 0:
            break
        out += 2 * (np.cos(np.outer(u, g)) @ (1.0 / (g ** 2 + 0.25)))
    return out


def krein_ratio(gfun, T=25.0, n=120):
    """lambda_min/|lambda|_max of the Krein kernel of g on a uniform grid."""
    t = np.linspace(-T, T, n)
    gt = gfun(t)                     # g even => g(-t)=g(t)
    G = gfun(t[:, None] - t[None, :]) - gt[:, None] - gt[None, :] + gfun(np.zeros(1))[0]
    ev = np.linalg.eigvalsh(0.5 * (G + G.T))
    return ev.min() / np.abs(ev).max()


def main():
    rng = np.random.default_rng(7)
    gam = load_zeros()

    # ---------------------------------------------------------------- Part 0
    print("=" * 72)
    print("PART 0: constants")
    I_inf = quad(lambda t: 0.5 * np.log(1 - t ** -2) / t ** 2, 1, np.inf)[0]
    print(f"I_inf = {I_inf:.15f}   log2 - 1 = {np.log(2)-1:.15f}   "
          f"diff = {I_inf-(np.log(2)-1):.2e}")
    B_exact = 2 + GE - np.log(4 * np.pi)
    for K in (1000, 10000, 30000):
        a = 1.0 / (gam[:K] ** 2 + 0.25)
        print(f"  K={K:6d}: B_K = {2*a.sum():.8f}  m0_K = {2*np.sum(a**2):.6e}  "
              f"S4_K = {2*np.sum(a**4):.6e}")
    print(f"  exact B = 2+gamma_E-log(4pi) = {B_exact:.8f}")
    aK = 1.0 / (gam ** 2 + 0.25)
    m0 = 2 * np.sum(aK ** 2)          # signed-ordinate convention: m0 = sum a^2
    S4 = 2 * np.sum(aK ** 4)
    D0 = 3 * (m0 ** 2 - S4)
    print(f"  full 100k zeros: m0 = {m0:.6e}  S4 = {S4:.6e}  "
          f"D0 = 3(m0^2-S4) = {D0:.6e}  sqrt(m0) = {np.sqrt(m0):.6f}")

    # ---------------------------------------------------------------- Part 1
    print("=" * 72)
    print("PART 1: interior carrier  S(X) = sum_{n<=X} Lambda(n)(X-n)/n")
    NMAX = 4_000_000
    lam = sieve_lambda(NMAX)
    pp = np.nonzero(lam)[0]
    lv = lam[pp]
    cpsi = np.cumsum(lv.astype(np.longdouble))
    cLn = np.cumsum((lv / pp).astype(np.longdouble))

    M_GRID = 8192
    logX = np.linspace(np.log(3e3), np.log(3.9e6), M_GRID)
    Xs = np.exp(logX)
    idx = np.searchsorted(pp, Xs, 'right') - 1
    Xl = Xs.astype(np.longdouble)
    S_ar = Xl * cLn[idx] - cpsi[idx]
    Mmain = Xl * np.log(Xl) - (1 + np.longdouble(GE)) * Xl + np.log(2 * np.longdouble(np.pi))
    q = np.asarray((S_ar - Mmain) / np.sqrt(Xl), dtype=np.float64)

    K1 = 30000
    h = h_model(logX, gam, K1)
    resid = q - h
    print(f"  grid: X in [3e3, 3.9e6], M = {M_GRID}; model: {K1} zeros; "
          f"NO fitted constants (c1 = 1+gamma_E, c0 = log 2pi)")
    print(f"  corr(q, h)          = {np.corrcoef(q, h)[0,1]:.8f}")
    print(f"  RMS(q)/RMS(h)       = {q.std()/h.std():.6f}")
    print(f"  RMS(q-h)/RMS(h)     = {resid.std()/h.std():.3e}   "
          f"max|q-h| = {np.max(np.abs(resid)):.3e}")
    print("  single-zero lines (Hann-windowed DFT amplitude, prediction 2a(gamma)):")
    for i in range(3):
        f0 = gam[i]
        ad, am = hann_amp(logX, q, f0), hann_amp(logX, h, f0)
        print(f"    gamma_{i+1} = {f0:8.3f}: data {ad:.4e}  model {am:.4e}  "
              f"ratio {ad/am:.4f}   2a = {2/(f0**2+.25):.4e}")

    # ---------------------------------------------------------------- Part 2
    print("=" * 72)
    print("PART 2: product pair layer  P(X) = (S-M)^2/X  vs  nu")
    P = q ** 2
    Pm = h ** 2
    print(f"  mean(P) = {P.mean():.4e}   mean(h^2) = {Pm.mean():.4e}   "
          f"m0 = {m0:.4e}  (DC of nu is POSITIVE = diagonal mass)")

    lo, hi = 28.0, 60.0
    bd = bandpass(P, logX, lo, hi)
    bm = bandpass(Pm, logX, lo, hi)
    core = slice(M_GRID // 8, -M_GRID // 8)
    corr = np.corrcoef(bd[core], bm[core])[0, 1]
    ratio = bd[core].std() / bm[core].std()
    print(f"  band [28,60]:  corr(P_data, h^2 model) = {corr:.6f}   "
          f"amplitude ratio = {ratio:.6f}")

    # independent line model: binned product measure nu from K2 zeros
    K2 = 1500
    g2 = gam[:K2]
    sgn = np.concatenate([g2, -g2])
    av = 1.0 / (sgn ** 2 + 0.25)
    fpair = sgn[:, None] + sgn[None, :]
    mpair = av[:, None] * av[None, :]
    sel = (np.abs(fpair) > 20) & (np.abs(fpair) < 70)
    fs, ms = fpair[sel], mpair[sel]
    # bin to 1e-3 and keep positive frequencies (real signal: 2 c_f cos(f u))
    fb = np.round(fs * 1000).astype(np.int64)
    order = np.argsort(fb)
    fb, ms2 = fb[order], ms[order]
    uniq, start = np.unique(fb, return_index=True)
    cmass = np.add.reduceat(ms2, start)
    fpos = uniq[uniq > 0] / 1000.0
    cpos = cmass[uniq > 0]
    print(f"  binned nu lines in (20,70): {len(fpos)} lines, "
          f"all masses positive: {bool(np.all(cpos > 0))}, "
          f"min mass = {cpos.min():.2e}")
    P_lines = np.zeros(M_GRID)
    for c in range(0, len(fpos), 400):
        P_lines += 2 * (np.cos(np.outer(logX, fpos[c:c+400])) @ cpos[c:c+400])
    bl = bandpass(P_lines, logX, lo, hi)
    corr2 = np.corrcoef(bd[core], bl[core])[0, 1]
    ratio2 = bd[core].std() / bl[core].std()
    print(f"  band [28,60]:  corr(P_data, binned-nu line model) = {corr2:.6f}   "
          f"amplitude ratio = {ratio2:.6f}")

    print("  pair lines (Hann DFT amplitude; nu-model = binned-line reconstruction,")
    print("   2c_f = isolated line mass -- differs where unresolved neighbor lines")
    print("   interfere at the window resolution ~0.9):")
    names = ["2*gamma_1  ", "g_1+g_2    ", "g_1+g_3    ", "2*gamma_2  "]
    freqs = [2 * gam[0], gam[0] + gam[1], gam[0] + gam[2], 2 * gam[1]]
    line_rows = []
    for nm, f0 in zip(names, freqs):
        ad = hann_amp(logX, P, f0)
        anu = hann_amp(logX, P_lines, f0)
        j = np.argmin(np.abs(fpos - f0))
        pred = 2 * cpos[j]
        line_rows.append((nm, f0, ad, anu, ad / anu, pred))
        print(f"    {nm} = {f0:7.3f}: data {ad:.4e}  nu-model {anu:.4e}  "
              f"ratio {ad/anu:.4f}   isolated 2c_f = {pred:.4e}")
    print("  single-zero frequencies inside the pair band (should be ABSENT in P):")
    for i in (3, 4):     # gamma_4 = 30.42, gamma_5 = 32.94
        f0 = gam[i]
        aq = hann_amp(logX, q, f0)
        ap = hann_amp(logX, P, f0)
        anu = hann_amp(logX, P_lines, f0)
        print(f"    gamma_{i+1} = {f0:7.3f}: amp in q = {aq:.3e}, amp in P = {ap:.3e}, "
              f"nu difference-line prediction = {anu:.3e}")

    # ---------------------------------------------------------------- Part 3
    print("=" * 72)
    print("PART 3: variance / Parseval in the product metric")
    # Parseval closure in band [28,60]: three ways
    inb = (fpos >= lo) & (fpos <= hi)
    rms_parseval = np.sqrt(np.sum(2 * cpos[inb] ** 2))
    print(f"  band [28,60] RMS:  Parseval over nu lines = {rms_parseval:.4e}   "
          f"model h^2 = {bm[core].std():.4e}   arithmetic P = {bd[core].std():.4e}")
    full_rms2 = 2 * m0 ** 2 - 3 * S4
    print(f"  full-spectrum check: RMS^2(h^2 - m0) closed form 2m0^2-3S4 = "
          f"{full_rms2:.4e}; grid estimate = {Pm.var():.4e} (finite window)")

    # windowed variance V(u0,L) with Fejer window, model side (K3 zeros)
    K3 = 800
    g3 = gam[:K3]
    a3 = 1.0 / (g3 ** 2 + 0.25)
    m0K = 2 * np.sum(a3 ** 2)
    S4K = 2 * np.sum(a3 ** 4)
    D0K = 3 * (m0K ** 2 - S4K)
    u0 = 12.0
    print(f"  V(u0={u0}, L) with {K3} zeros;  D0(K) = {D0K:.6e}, "
          f"Jensen floor -> m0(K)^2 = {m0K**2:.6e}")
    print("     L     V(L)        V/D0     M_L^2 (floor)  V>=floor")
    Vres = []
    for L in (4, 8, 16, 32, 64, 128):
        du = 8e-4
        uu = np.arange(-L, L + du, du)
        fej = 1 - np.abs(uu) / L
        hh = np.zeros_like(uu)
        for c in range(0, K3, 400):
            gg = g3[c:c+400]
            hh += 2 * (np.cos(np.outer(uu + u0, gg)) @ a3[c:c+400])
        V = np.trapezoid(hh ** 4 * fej, dx=du) / L
        ML = np.trapezoid(hh ** 2 * fej, dx=du) / L
        Vres.append((L, V, V / D0K, ML ** 2, V >= ML ** 2))
        print(f"   {L:5d}  {V:.4e}  {V/D0K:8.4f}   {ML**2:.4e}     {V >= ML**2}")

    # ---------------------------------------------------------------- Part 4
    print("=" * 72)
    print("PART 4: off-line-zero injection (Krein kernel of nu goes indefinite)")
    K4 = 3000
    g4 = gam[:K4]
    a4 = 1.0 / (g4[1:] ** 2 + 0.25)      # zeros 2..K4 stay on the line

    def h_beta(t, beta):
        t = np.atleast_1d(np.asarray(t, dtype=float))
        shp = t.shape
        tf = t.ravel()
        out = 2 * (np.cos(np.outer(tf, g4[1:])) @ a4)
        for rho in (beta + 1j * g4[0], 1 - beta + 1j * g4[0]):
            out += 2 * np.real(np.exp((rho - 0.5) * tf) / (rho * (1 - rho)))
        return out.reshape(shp)

    print("    beta    one-body g1 kernel    pair (nu) kernel g2")
    inj_rows = []
    for beta in (0.50, 0.55, 0.60, 0.65, 0.70):
        h0 = h_beta(np.zeros(1), beta)[0]
        r1 = krein_ratio(lambda t: h_beta(t, beta) - h0)
        r2 = krein_ratio(lambda t: h_beta(t, beta) ** 2 - h0 ** 2)
        inj_rows.append((beta, r1, r2))
        print(f"   {beta:.2f}   {r1:+12.3e}          {r2:+12.3e}")
    # random-grid confirmation at beta = 0.6
    t = np.sort(rng.uniform(-25, 25, 90))
    h0 = h_beta(np.zeros(1), 0.6)[0]
    g2f = lambda tt: h_beta(tt, 0.6) ** 2 - h0 ** 2
    G = g2f(t[:, None] - t[None, :]) - g2f(t)[:, None] - g2f(t)[None, :] + 0.0
    ev = np.linalg.eigvalsh(0.5 * (G + G.T))
    print(f"  random grid n=90, beta=0.60: lambda_min/|lambda|_max = "
          f"{ev.min()/np.abs(ev).max():+.3e}")

    # ------------------------------------------------------- Beta-weight contrast
    KB = 1200
    gB = gam[:KB]
    sgnB = np.concatenate([gB, -gB])
    rhoB = 0.5 + 1j * sgnB
    LG = loggamma(rhoB)
    WB = np.exp(LG[:, None] + LG[None, :] - loggamma(rhoB[:, None] + rhoB[None, :] + 2))
    fB = sgnB[:, None] + sgnB[None, :]
    selB = (fB > 20) & (fB < 70)
    fBs, mBs = fB[selB], WB[selB]
    fbB = np.round(fBs * 1000).astype(np.int64)
    order = np.argsort(fbB)
    fbB, mBs = fbB[order], mBs[order]
    uniqB, startB = np.unique(fbB, return_index=True)
    cB = np.add.reduceat(mBs, startB)
    # restrict statistics to the lines carrying 99.9% of |mass| (the raw count is
    # dominated by exponentially tiny mixed-sign difference lines)
    absB = np.abs(cB)
    ordm = np.argsort(absB)[::-1]
    cut = np.searchsorted(np.cumsum(absB[ordm]), 0.999 * absB.sum()) + 1
    big = cB[ordm[:cut]]
    fracneg = np.mean(np.real(big) < 0)
    massneg = np.sum(absB[np.real(cB) < 0]) / absB.sum()
    imfrac = np.mean(np.abs(np.imag(big)) / np.abs(big))
    print(f"  contrast: Beta-weight lines in (20,70): {len(cB)} total; among the "
          f"{cut} lines carrying 99.9% of |mass|:")
    print(f"    fraction with Re<0: {fracneg:.2f};  |mass| fraction on Re<0 lines: "
          f"{massneg:.2f};  mean |Im|/|c|: {imfrac:.2f}   (product metric: 0 / 0 / 0)")

    # ---------------------------------------------------------------- figure
    fig, ax = plt.subplots(3, 2, figsize=(14.5, 12.5))
    for a_ in ax.flat:
        a_.grid(alpha=0.25, lw=0.5)

    # (a) carrier: q vs h, band-passed to single-line band
    b1d = bandpass(q, logX, 8, 26.5)
    b1m = bandpass(h, logX, 8, 26.5)
    ax[0, 0].plot(Xs[core], b1d[core], lw=0.8, color=C_DATA, label="arithmetic  $q=(S-M)/\\sqrt{X}$")
    ax[0, 0].plot(Xs[core], b1m[core], lw=0.8, color=C_MODEL, alpha=0.75,
                  label="zero side  $h(\\log X)$")
    ax[0, 0].set_xscale("log")
    ax[0, 0].set_xlabel("X")
    ax[0, 0].legend(fontsize=8, loc="upper right")
    ax[0, 0].set_title("(a) interior carrier, single-zero band [8, 26.5] — no fitted constants",
                       fontsize=10)

    # (b) pair layer band [28,60]
    ax[0, 1].plot(Xs[core], bd[core], lw=0.8, color=C_DATA, label="data  $P=q^2$")
    ax[0, 1].plot(Xs[core], bl[core], lw=0.8, color=C_MODEL, alpha=0.75,
                  label=r"binned-$\nu$ line model")
    ax[0, 1].set_xscale("log")
    ax[0, 1].set_xlabel("X")
    ax[0, 1].legend(fontsize=8, loc="upper right")
    ax[0, 1].set_title(f"(b) product pair layer, band [28, 60]:  corr = {corr2:.4f}, "
                       f"ratio = {ratio2:.4f}", fontsize=10)

    # (c) spectrum of P with product-line marks
    w = np.hanning(M_GRID)
    fgrid = np.fft.rfftfreq(M_GRID, d=(logX[1] - logX[0])) * 2 * np.pi
    Ad = np.abs(np.fft.rfft((P - P.mean()) * w))
    Am = np.abs(np.fft.rfft((Pm - Pm.mean()) * w))
    band = (fgrid > 24) & (fgrid < 62)
    ax[1, 0].plot(fgrid[band], Ad[band] / Ad[band].max(), lw=0.9, color=C_DATA,
                  label="data spectrum")
    ax[1, 0].plot(fgrid[band], -Am[band] / Am[band].max(), lw=0.9, color=C_MODEL,
                  label="$h^2$ model (mirrored)")
    marks = sorted(gam[i] + gam[j] for i in range(8) for j in range(i, 8)
                   if 24 < gam[i] + gam[j] < 62)
    for k, fr in enumerate(marks):
        ax[1, 0].axvline(fr, color=C_MARK, lw=0.5, ls=":",
                         label=r"$\gamma_i+\gamma_j$" if k == 0 else None)
    for k, i in enumerate((3, 4, 5)):
        if 24 < gam[i] < 62:
            ax[1, 0].axvline(gam[i], color="seagreen", lw=1.0, ls="--",
                             label=r"single $\gamma_i$ (absent)" if k == 0 else None)
    ax[1, 0].set_xlabel(r"frequency in $\log X$")
    ax[1, 0].legend(fontsize=8, loc="lower right")
    ax[1, 0].set_title("(c) spectrum of the pair layer: lines at pair sums only", fontsize=10)

    # (d) the two measures on the sum spectrum
    ax[1, 1].vlines(fpos[inb], 0, 2 * cpos[inb], color=C_DATA, lw=1.2,
                    label=r"product $\nu$: all masses $>0$")
    fBpos = uniqB[uniqB > 0] / 1000.0
    selBB = (fBpos >= lo) & (fBpos <= hi)
    scale = (2 * cpos[inb]).max() / np.abs(np.real(cB[uniqB > 0][selBB])).max()
    ax[1, 1].vlines(fBpos[selBB], 0, np.real(cB[uniqB > 0][selBB]) * scale,
                    color=C_NEG, lw=0.7, alpha=0.6,
                    label=f"Beta weights, Re (scaled): {fracneg:.0%} negative")
    ax[1, 1].axhline(0, color="k", lw=0.6)
    ax[1, 1].set_xlabel(r"$\omega = \gamma+\gamma'$")
    ax[1, 1].legend(fontsize=8, loc="upper right")
    ax[1, 1].set_title("(d) product measure vs Beta measure on the sum spectrum", fontsize=10)

    # (e) V(L)/D0 and Jensen floor
    Ls = [r[0] for r in Vres]
    ax[2, 0].plot(Ls, [r[1] / D0K for r in Vres], "o-", color=C_DATA, label="$V(L)/D_0$")
    ax[2, 0].plot(Ls, [r[3] / D0K for r in Vres], "s--", color=C_MODEL,
                  label="Jensen floor $M_L^2/D_0$")
    ax[2, 0].axhline(1.0, color=C_MARK, lw=0.8, ls=":", label="$D_0 = 3(m_0^2-S_4)$")
    ax[2, 0].axhline(m0K ** 2 / D0K, color="seagreen", lw=0.8, ls="--",
                     label="$m_0^2/D_0 = 1/3$ (limit floor)")
    ax[2, 0].set_xscale("log", base=2)
    ax[2, 0].set_xlabel("window length L")
    ax[2, 0].set_ylim(0, 1.4)
    ax[2, 0].legend(fontsize=8, loc="lower right")
    ax[2, 0].set_title("(e) windowed variance vs diagonal, product metric", fontsize=10)

    # (f) injection
    bs = [r[0] for r in inj_rows]
    ax[2, 1].plot(bs, [r[2] for r in inj_rows], "o-", color=C_DATA,
                  label=r"pair kernel $g_2$ (carries $\nu$)")
    ax[2, 1].plot(bs, [r[1] for r in inj_rows], "s--", color=C_MODEL,
                  label="one-body kernel $g_1$")
    ax[2, 1].axhline(0, color="k", lw=0.6)
    ax[2, 1].set_xlabel(r"$\beta$ of injected zero quadruple")
    ax[2, 1].set_ylabel(r"$\lambda_{\min}/|\lambda|_{\max}$")
    ax[2, 1].legend(fontsize=8, loc="lower left")
    ax[2, 1].set_title("(f) off-line injection: Krein kernel goes indefinite", fontsize=10)

    fig.suptitle("exp31: the product-weighted pair carrier "
                 r"$T(X,X)=\sum\Lambda(m)\Lambda(n)\frac{(X-m)(X-n)}{mn}$ and the measure "
                 r"$\nu=\sum a(\gamma)a(\gamma')\,\delta_{\gamma+\gamma'}$",
                 fontsize=11)
    fig.tight_layout(rect=[0, 0, 1, 0.97])
    fig.savefig(FIG / "exp31_product_carrier.png", dpi=140)
    print("saved figures/exp31_product_carrier.png")


if __name__ == "__main__":
    main()
