"""Experiment 34: THE TWISTED PRODUCT CARRIER — the exp31 construction lifted
to the Dirichlet tower (chi_3, the non-principal quadratic character mod 3).

One-body carrier (Proposition T1 of notes/TWISTED_CARRIER.md):

    S_chi(X) = sum_{n<=X} Lambda(n) chi_3(n) (X-n)/n
             = (1/2pi i) int (-L'/L(w,chi_3)) X^w / (w(w-1)) dw .

-L'/L(s,chi_3) has NO pole at s=1 (L(1,chi_3) = pi/(3 sqrt 3) != 0), so the
explicit formula has NO X log X main term — only a linear layer with exact
closed-form constants and the zero layer:

    S_chi(X) = c1 X + c0 + sum_rho X^rho/(rho(1-rho)) + delta_chi(X),

    c1 = -L'/L(1,chi_3) = -0.368281615970...   (= sum_n Lambda(n)chi(n)/n),
    c0 = +L'/L(0,chi_3) = 3 log(Gamma(1/3)/Gamma(2/3)) - log 3
       = 0.948198826672...,
    delta_chi(X) = -artanh(1/X) - (X/2) log(1-X^{-2}) = -1/(2X) + O(X^{-3})

(trivial zeros of the ODD character sit at -1,-3,-5,...), zero sum absolutely
convergent (|rho(1-rho)| >= gamma^2, first ordinate 8.04).  Under GRH(chi_3)
the zero layer is sqrt(X) h_chi(log X) with the chi-twisted screw masses

    a(gamma_chi) = 1/(gamma_chi^2 + 1/4) > 0,
    B_chi = sum a = log(3/pi) - gamma_E + 2 L'/L(1,chi_3) = 0.113229969857...

The pair object T_chi(X,Y) = S_chi(X)S_chi(Y) (separable, per-variable
reweighting FIRST, diagonal LAST) carries the chi-twisted product measure

    nu_chi = sum a(gamma)a(gamma') delta_{gamma+gamma'}   over L-zero pairs

through P_chi(X) = (S_chi - c1 X - c0)^2 / X = h_chi(log X)^2 + O(X^{-5/2}).

Structural novelty vs the untwisted exp31 (Proposition T4): NO pole at s=1
means NO main term, NO single-zero-times-pole foreground, NO mixed block —
the twisted carrier is PURE screw (the chi-analogue of Mobius purity,
FAMILY.md).  Part 3 verifies the X log X coefficient is ~0 in the data and
quantifies the purity advantage for mass extraction.  The line weights are
positive REAL a(gamma): no Gauss-sum phase enters (tau(chi_3) = i sqrt 3
cancels in -L'/L residues, which are m_rho = 1 independent of chi); Part 2
measures the line phases to confirm.

Standing hypotheses, stated explicitly: GRH for L(s,chi_3) wherever h_chi /
positivity is used (the identity itself is unconditional); the model list
assumes the computed zeros are simple (all known ones are); the screw<=>GRH
converse (Prop. T3) additionally quotes the Matsumoto-Suzuki boundedness
lemma [MS arXiv:2409.00888, Cor. 3.1-type], full text unverified
(CROSSREVIEW_THMJ.md par. 7).

Parts:
  0. exact constants (c1, c0, B_chi, functional-equation identity,
     delta_chi closed form)
  1. L-zeros: load cached 17, extend with mpmath to t < TMAX, validate
     |L(1/2 + i gamma)| < 1e-10, count vs Riemann-von Mangoldt
  2. one-body identity: q = (S_chi - c1 X - c0)/sqrt X vs h_chi; per-line
     mass AND phase table at the first 8 L-zeros; zeta-line absence probe
  3. purity: fitted X log X coefficient ~ 0; extraction-protocol stress
     table (full / linear-only / no subtraction) twisted vs untwisted
  4. pair layer: P = q^2 vs h_chi^2 and vs the binned nu_chi line model;
     pair-line table; single-L-zero absence inside the pair band; DC = m0
  5. off-line injection: fake zero quadruple at beta > 1/2 -> Krein kernels
     of g_1^chi and g_2^chi (carrier of nu_chi) go indefinite

Zeros: data/chi3_zeros.npy (17 cached) extended to data/chi3_zeros_ext.npy.
Lambda to 4e6.  No fitted parameters anywhere: every subtracted constant is
closed-form; fits appear ONLY as null tests (Part 3) where the fitted
coefficient is predicted to vanish.
"""
import time
import numpy as np
from scipy.integrate import quad
import mpmath as mp
import matplotlib
matplotlib.use("Agg")
import matplotlib.pyplot as plt
from pathlib import Path
from pairfield import sieve_lambda, load_zeros

FIG = Path(__file__).resolve().parent.parent / "figures"
DATA = Path(__file__).resolve().parent.parent / "data"
GE = np.euler_gamma
C_DATA, C_MODEL, C_MARK, C_ABS = "#1f77b4", "crimson", "0.55", "seagreen"

TMAX = 320.0          # zero hunt height
NMAX = 4_000_000      # sieve limit
M_GRID = 8192


# ----------------------------------------------------------------- L(s,chi3)
def l_chi3(s):
    """L(s, chi_3) via Hurwitz zeta: 3^{-s} (zeta(s,1/3) - zeta(s,2/3))."""
    return mp.power(3, -s) * (mp.zeta(s, mp.mpf(1) / 3) - mp.zeta(s, mp.mpf(2) / 3))


def z_chi3(t):
    """Hardy-Z analogue for chi_3: the completed Lambda(1/2+it,chi_3) =
    (3/pi)^{(s+1)/2} Gamma((s+1)/2) L(s,chi_3) is REAL on the line (odd
    primitive chi, root number +1); divide by |prefactor| so the function
    has the scale of |L| — otherwise the e^{-pi t/4} decay of Gamma makes
    root-finding tolerances meaningless at large t."""
    s = mp.mpc(mp.mpf(1) / 2, t)
    pref = mp.power(3 / mp.pi, (s + 1) / 2) * mp.gamma((s + 1) / 2)
    return mp.re(pref * l_chi3(s)) / abs(pref)


def find_l_zeros_ext(tmax=TMAX):
    """Ordinates 0 < gamma < tmax of zeros of L(1/2+it, chi_3), by sign
    changes of the (real, unit-scale) Z_chi; cached."""
    cache = DATA / "chi3_zeros_ext.npy"
    if cache.exists():
        z = np.load(cache)
        if z.max() > tmax - 3:
            return z[z < tmax]
    mp.mp.dps = 25
    t0 = time.time()
    step = 0.15
    ts = np.arange(0.2, tmax, step)
    vals = [z_chi3(t) for t in ts]
    zs = []
    for i in range(len(ts) - 1):
        if mp.sign(vals[i]) * mp.sign(vals[i + 1]) < 0:
            root = mp.findroot(z_chi3, (mp.mpf(ts[i]), mp.mpf(ts[i + 1])),
                               solver="anderson", tol=mp.mpf("1e-30"))
            zs.append(float(root))
    z = np.array(sorted(zs))
    print(f"  [zero hunt to t={tmax:.0f}: {len(z)} zeros in {time.time()-t0:.0f}s]")
    np.save(cache, z)
    return z


def hann_amp(u, y, f, phase=False):
    """Hann-windowed DFT amplitude (optionally complex) at angular freq f."""
    w = np.hanning(len(u))
    z = (y - y.mean()) * w
    Z = np.sum(z * np.exp(-1j * f * u)) / (w.sum() / 2)
    return Z if phase else abs(Z)


def bandpass(y, u, lo, hi):
    Y = np.fft.rfft(y - y.mean())
    f = np.fft.rfftfreq(len(y), d=(u[1] - u[0])) * 2 * np.pi
    Y[(f < lo) | (f > hi)] = 0
    return np.fft.irfft(Y, len(y))


def h_model(u, gam, K=None, chunk=2000):
    """h(u) = 2 sum_{gamma>0} cos(gamma u)/(gamma^2+1/4), first K ordinates."""
    K = len(gam) if K is None else K
    out = np.zeros_like(u)
    for c in range(0, K, chunk):
        g = gam[c:c + chunk][: max(0, K - c)]
        if len(g) == 0:
            break
        out += 2 * (np.cos(np.outer(u, g)) @ (1.0 / (g ** 2 + 0.25)))
    return out


def krein_ratio(gfun, T=25.0, n=120):
    """lambda_min/|lambda|_max of the Krein kernel of g on a uniform grid."""
    t = np.linspace(-T, T, n)
    gt = gfun(t)
    G = gfun(t[:, None] - t[None, :]) - gt[:, None] - gt[None, :] + gfun(np.zeros(1))[0]
    ev = np.linalg.eigvalsh(0.5 * (G + G.T))
    return ev.min() / np.abs(ev).max()


def main():
    rng = np.random.default_rng(7)

    # ---------------------------------------------------------------- Part 0
    print("=" * 72)
    print("PART 0: exact constants of the twisted carrier (no pole at s=1)")
    mp.mp.dps = 30
    L1 = mp.pi / (3 * mp.sqrt(3))
    L1_num = mp.quad(lambda th: l_chi3(1 + mp.mpf("0.25") * mp.exp(1j * th)),
                     [0, 2 * mp.pi]) / (2 * mp.pi)
    Lp1 = mp.quad(lambda th: l_chi3(1 + mp.mpf("0.25") * mp.exp(1j * th))
                  * mp.exp(-1j * th), [0, 2 * mp.pi]) / (2 * mp.pi * mp.mpf("0.25"))
    Lp1 = mp.re(Lp1)
    c1 = float(-Lp1 / L1)
    Lp0, L0 = mp.diff(l_chi3, 0), mp.mpf(1) / 3
    c0 = float(Lp0 / L0)
    c0_closed = float(3 * mp.log(mp.gamma(mp.mpf(1) / 3) / mp.gamma(mp.mpf(2) / 3))
                      - mp.log(3))
    Bchi = float(mp.log(3 / mp.pi) - mp.euler + 2 * Lp1 / L1)
    fe = float(Lp0 / L0 + Lp1 / L1 - (-mp.log(3 / mp.pi) + mp.euler + mp.log(2)))
    print(f"  L(1,chi3) = pi/(3 sqrt3) = {float(L1):.12f}  "
          f"(Cauchy check diff {abs(complex(L1_num)-float(L1)):.1e})")
    print(f"  c1 = -L'/L(1,chi3) = {c1:.12f}   (linear coefficient; NO X log X)")
    print(f"  c0 = +L'/L(0,chi3) = {c0:.12f}")
    print(f"     closed form 3 log(G(1/3)/G(2/3)) - log 3 = {c0_closed:.12f}   "
          f"diff = {abs(c0-c0_closed):.1e}")
    print(f"  functional-equation identity L'/L(0)+L'/L(1) = "
          f"-log(3/pi)+gamma_E+log2:  diff = {fe:.1e}")
    print(f"  B_chi = log(3/pi) - gamma_E + 2 L'/L(1,chi3) = {Bchi:.12f}")
    # delta_chi closed form vs trivial-zero residue series
    Xt = 3.0
    dser = -sum(Xt ** (1 - 2 * m) / ((2 * m - 1) * 2 * m) for m in range(1, 200))
    dcl = -np.arctanh(1 / Xt) - (Xt / 2) * np.log(1 - Xt ** -2)
    print(f"  delta_chi(3): residue series {dser:.12f}  closed form {dcl:.12f}  "
          f"diff = {abs(dser-dcl):.1e}   [delta_chi = -1/(2X) + O(X^-3)]")

    # ---------------------------------------------------------------- Part 1
    print("=" * 72)
    print(f"PART 1: zeros of L(s,chi_3) to t < {TMAX:.0f}")
    gz = find_l_zeros_ext(TMAX)
    print(f"  zeros found: {len(gz)};  first: "
          + ", ".join(f"{t:.4f}" for t in gz[:6]))
    cached = np.load(DATA / "chi3_zeros.npy")
    print(f"  vs exp20 cache (17 zeros): max|diff| = "
          f"{np.max(np.abs(gz[:len(cached)] - cached)):.2e}")
    mp.mp.dps = 20
    resid = max(abs(complex(l_chi3(mp.mpc(0.5, t)))) for t in gz)
    print(f"  validation: max |L(1/2+i gamma)| over all {len(gz)} zeros = "
          f"{resid:.1e}  (< 1e-10 required: {resid < 1e-10})")
    Npred = TMAX / (2 * np.pi) * np.log(3 * TMAX / (2 * np.pi * np.e))
    gaps = np.diff(gz)
    locmean = 2 * np.pi / np.log(3 * gz[1:] / (2 * np.pi))
    print(f"  count check: N+(T) ~ (T/2pi)log(3T/2pi e) = {Npred:.1f} vs {len(gz)} "
          f"found;  max gap/local-mean = {np.max(gaps/locmean):.2f} (no missed-zero "
          f"flag if < ~2.5)")
    a_all = 1.0 / (gz ** 2 + 0.25)
    B_K = 2 * a_all.sum()
    tail = 2 * (np.log(3 * TMAX / (2 * np.pi)) + 1) / (2 * np.pi * TMAX)
    m0 = 2 * np.sum(a_all ** 2)
    print(f"  B_chi from {len(gz)} zeros: {B_K:.6f} + est. tail {tail:.6f} = "
          f"{B_K+tail:.6f}  vs exact {Bchi:.6f}  "
          f"(gap {abs(B_K+tail-Bchi)/Bchi*100:.2f}%; 1/T convergence)")
    print(f"  m0_chi = sum a^2 (signed) = {m0:.6e}   sqrt = {np.sqrt(m0):.6f}")

    # ---------------------------------------------------------------- Part 2
    print("=" * 72)
    print("PART 2: one-body identity  q = (S_chi - c1 X - c0)/sqrt(X)  vs  h_chi")
    lam = sieve_lambda(NMAX)
    pp = np.nonzero(lam)[0]
    chi_v = np.zeros(len(pp))
    chi_v[pp % 3 == 1] = 1.0
    chi_v[pp % 3 == 2] = -1.0
    lv = lam[pp] * chi_v
    cpsi = np.cumsum(lv.astype(np.longdouble))
    cLn = np.cumsum((lv / pp).astype(np.longdouble))
    print(f"  sieve to {NMAX:.0e}: sum Lambda chi/n = {float(cLn[-1]):+.6f} vs "
          f"c1 = {c1:+.6f}  (diff {float(cLn[-1])-c1:+.1e}, O(X^-1/2) fluct.)")

    logX = np.linspace(np.log(3e3), np.log(3.9e6), M_GRID)
    Xs = np.exp(logX)
    idx = np.searchsorted(pp, Xs, "right") - 1
    Xl = Xs.astype(np.longdouble)
    S_ar = Xl * cLn[idx] - cpsi[idx]
    q = np.asarray((S_ar - (np.longdouble(c1) * Xl + np.longdouble(c0)))
                   / np.sqrt(Xl), dtype=np.float64)
    h = h_model(logX, gz)
    print(f"  grid: X in [3e3, 3.9e6], M = {M_GRID}; model: all {len(gz)} L-zeros; "
          f"NO fitted constants")
    print(f"  corr(q, h)            = {np.corrcoef(q, h)[0,1]:.6f}   (full band; "
          f"limited by {len(gz)}-zero model tail)")
    core = slice(M_GRID // 8, -M_GRID // 8)
    lo1, hi1 = 5.0, 45.0
    bq, bh = bandpass(q, logX, lo1, hi1), bandpass(h, logX, lo1, hi1)
    r_in = (bq[core] - bh[core]).std() / bh[core].std()
    print(f"  band [{lo1:.0f},{hi1:.0f}]: corr = "
          f"{np.corrcoef(bq[core], bh[core])[0,1]:.8f}   RMS ratio = "
          f"{bq[core].std()/bh[core].std():.6f}   rel. residual = {r_in:.2e}")
    print("  per-line mass AND phase table, first 8 L-zeros "
          "(Hann DFT; phase = arg(data * conj(model)), deg):")
    print("     gamma_chi     data amp    model amp   ratio    2a(gamma)  "
          "ratio(2a)  phase")
    mass_rows = []
    for i in range(8):
        f0 = gz[i]
        Zd = hann_amp(logX, q, f0, phase=True)
        Zm = hann_amp(logX, h, f0, phase=True)
        two_a = 2.0 / (f0 ** 2 + 0.25)
        ph = np.degrees(np.angle(Zd * np.conj(Zm)))
        mass_rows.append((f0, abs(Zd), abs(Zm), abs(Zd) / abs(Zm), two_a,
                          abs(Zd) / two_a, ph))
        print(f"    {f0:9.4f}   {abs(Zd):.5e}  {abs(Zm):.5e}  "
              f"{abs(Zd)/abs(Zm):.4f}   {two_a:.5e}  {abs(Zd)/two_a:.4f}   "
              f"{ph:+8.4f}")
    errs = np.abs([r[3] - 1 for r in mass_rows])
    print(f"  identity quality (vs model, same window): mean |ratio-1| = "
          f"{errs.mean()*100:.3f}%   max = {errs.max()*100:.3f}%")
    errs2a = np.abs([r[5] - 1 for r in mass_rows])
    print(f"  isolated-mass quality (vs 2a):            mean |ratio-1| = "
          f"{errs2a.mean()*100:.3f}%   max = {errs2a.max()*100:.3f}% "
          f"(neighbor interference at window res ~0.9 included)")
    phs = np.abs([r[6] for r in mass_rows])
    print(f"  finite-place fingerprint: max |phase| = {phs.max():.4f} deg — the "
          f"line weights are REAL positive a(gamma);")
    print("    no Gauss-sum phase (tau(chi_3) = i sqrt 3 cancels in the residues "
          "of -L'/L, which are 1 at every zero).")
    gzeta = load_zeros(10)
    print("  zeta-string absence probe (caveat: L-string interleaves within "
          "window resolution):")
    for fz, nm in [(gzeta[0], "zeta g1"), (gzeta[1], "zeta g2")]:
        near = gz[np.argmin(np.abs(gz - fz))]
        print(f"    {nm} = {fz:.3f}: amp in q = {hann_amp(logX, q, fz):.3e}  "
              f"(model amp {hann_amp(logX, h, fz):.3e}; nearest L-zero "
              f"{near:.3f}, dist {abs(near-fz):.2f})")

    # ---------------------------------------------------------------- Part 3
    print("=" * 72)
    print("PART 3: PURITY — no pole => no X log X foreground")
    # untwisted comparison objects
    lv_u = lam[pp]
    cpsi_u = np.cumsum(lv_u.astype(np.longdouble))
    cLn_u = np.cumsum((lv_u / pp).astype(np.longdouble))
    S_u = Xl * cLn_u[idx] - cpsi_u[idx]
    Mmain_u = (Xl * np.log(Xl) - (1 + np.longdouble(GE)) * Xl
               + np.log(2 * np.longdouble(np.pi)))
    gzeta_full = load_zeros()
    h_u = h_model(logX, gzeta_full, 30000)

    # (a) fitted X log X coefficient (null test; fit used ONLY here)
    A = np.column_stack([Xs * np.log(Xs), Xs, np.ones_like(Xs)])
    coef_t, *_ = np.linalg.lstsq(A, np.asarray(S_ar, dtype=float), rcond=None)
    coef_u, *_ = np.linalg.lstsq(A, np.asarray(S_u, dtype=float), rcond=None)
    print(f"  LSQ fit S = a X log X + b X + c  on the grid:")
    print(f"    twisted : a = {coef_t[0]:+.2e}  (predicted 0)   "
          f"b = {coef_t[1]:+.6f}  (closed form c1 = {c1:+.6f})")
    print(f"    untwisted: a = {coef_u[0]:+.6f}  (predicted 1)   "
          f"b = {coef_u[1]:+.6f}  (closed form -(1+gamma_E) = {-(1+GE):+.6f})")

    # (b) extraction stress: protocols x towers, mean line error first 8 zeros
    def line_err(sig, model, zeros8):
        e = []
        for f0 in zeros8:
            ad, am = hann_amp(logX, sig, f0), hann_amp(logX, model, f0)
            e.append(abs(ad / am - 1))
        return np.mean(e)

    q_u = np.asarray((S_u - Mmain_u) / np.sqrt(Xl), dtype=np.float64)
    prot = {}
    prot[("twisted", "full closed-form")] = line_err(q, h, gz[:8])
    prot[("twisted", "linear-only")] = prot[("twisted", "full closed-form")]
    prot[("twisted", "none")] = line_err(
        np.asarray(S_ar / np.sqrt(Xl), dtype=np.float64), h, gz[:8])
    prot[("untwisted", "full closed-form")] = line_err(q_u, h_u, gzeta_full[:8])
    q_u_lin = np.asarray((S_u - (-(1 + np.longdouble(GE)) * Xl
                                 + np.log(2 * np.longdouble(np.pi))))
                         / np.sqrt(Xl), dtype=np.float64)
    prot[("untwisted", "linear-only")] = line_err(q_u_lin, h_u, gzeta_full[:8])
    prot[("untwisted", "none")] = line_err(
        np.asarray(S_u / np.sqrt(Xl), dtype=np.float64), h_u, gzeta_full[:8])
    print("  mean |line ratio - 1| over first 8 zeros of the respective string,")
    print("  under three subtraction protocols (Hann DFT, same grid/window):")
    print("    protocol            twisted (chi_3)   untwisted (zeta)")
    for p in ("full closed-form", "linear-only", "none"):
        print(f"    {p:<18}  {prot[('twisted',p)]*100:12.3f}%   "
              f"{prot[('untwisted',p)]*100:12.3f}%")
    print("  [twisted: 'linear-only' IS the full smooth part — span{X,1} — so the")
    print("   two protocols coincide: that degeneracy is the purity statement.]")

    # ---------------------------------------------------------------- Part 4
    print("=" * 72)
    print("PART 4: pair layer  P = q^2  vs  nu_chi over L-zero pairs")
    P = q ** 2
    Pm = h ** 2
    print(f"  DC: mean(P) = {P.mean():.4e}   mean(h_chi^2) = {Pm.mean():.4e}   "
          f"m0_chi = {m0:.4e}  (positive DC = diagonal mass of nu_chi)")
    lo2, hi2 = 14.0, 55.0
    bd = bandpass(P, logX, lo2, hi2)
    bm = bandpass(Pm, logX, lo2, hi2)
    print(f"  band [{lo2:.0f},{hi2:.0f}]:  corr(P, h_chi^2) = "
          f"{np.corrcoef(bd[core], bm[core])[0,1]:.6f}   amplitude ratio = "
          f"{bd[core].std()/bm[core].std():.6f}")
    # binned nu_chi line model over signed ordinates
    sgn = np.concatenate([gz, -gz])
    av = 1.0 / (sgn ** 2 + 0.25)
    fpair = sgn[:, None] + sgn[None, :]
    mpair = av[:, None] * av[None, :]
    sel = (np.abs(fpair) > 8) & (np.abs(fpair) < 65)
    fs, ms = fpair[sel], mpair[sel]
    fb = np.round(fs * 1000).astype(np.int64)
    order = np.argsort(fb)
    fb, ms2 = fb[order], ms[order]
    uniq, start = np.unique(fb, return_index=True)
    cmass = np.add.reduceat(ms2, start)
    fpos = uniq[uniq > 0] / 1000.0
    cpos = cmass[uniq > 0]
    print(f"  binned nu_chi lines in (8,65): {len(fpos)} lines, all masses "
          f"positive: {bool(np.all(cpos > 0))}, min = {cpos.min():.2e}")
    P_lines = np.zeros(M_GRID)
    for c in range(0, len(fpos), 400):
        P_lines += 2 * (np.cos(np.outer(logX, fpos[c:c + 400])) @ cpos[c:c + 400])
    bl = bandpass(P_lines, logX, lo2, hi2)
    corr2 = np.corrcoef(bd[core], bl[core])[0, 1]
    ratio2 = bd[core].std() / bl[core].std()
    print(f"  band [{lo2:.0f},{hi2:.0f}]:  corr(P, binned-nu_chi lines) = "
          f"{corr2:.6f}   amplitude ratio = {ratio2:.6f}")
    inb = (fpos >= lo2) & (fpos <= hi2)
    print(f"  Parseval closure in band: sqrt(sum 2 c_f^2) = "
          f"{np.sqrt(np.sum(2*cpos[inb]**2)):.4e}   model RMS = "
          f"{bm[core].std():.4e}   data RMS = {bd[core].std():.4e}")
    print("  pair lines (Hann DFT; nu-model = binned-line reconstruction; "
          "2c_f = isolated mass):")
    pnames = ["2 g1     ", "g1+g2    ", "2 g2     ", "g1+g3    ", "g2+g3    "]
    pfreqs = [2 * gz[0], gz[0] + gz[1], 2 * gz[1], gz[0] + gz[2], gz[1] + gz[2]]
    pair_rows = []
    for nm, f0 in zip(pnames, pfreqs):
        ad = hann_amp(logX, P, f0)
        anu = hann_amp(logX, P_lines, f0)
        j = np.argmin(np.abs(fpos - f0))
        pair_rows.append((nm, f0, ad, anu, ad / anu, 2 * cpos[j]))
        print(f"    {nm}= {f0:7.3f}: data {ad:.4e}  nu-model {anu:.4e}  "
              f"ratio {ad/anu:.4f}   isolated 2c_f = {2*cpos[j]:.4e}")
    perr = np.abs([r[4] - 1 for r in pair_rows])
    print(f"  pair-line quality vs nu-model: mean |ratio-1| = "
          f"{perr.mean()*100:.2f}%   max = {perr.max()*100:.2f}%")
    print("  single-L-zero frequencies inside the pair band (ABSENT in P; "
          "residue = nu_chi's own difference lines):")
    for i in (3, 4):        # gamma_4 = 18.26, gamma_5 = 20.46
        f0 = gz[i]
        print(f"    gamma_{i+1} = {f0:7.3f}: amp in q = {hann_amp(logX, q, f0):.3e}"
              f"   amp in P = {hann_amp(logX, P, f0):.3e}   nu difference-line "
              f"prediction = {hann_amp(logX, P_lines, f0):.3e}")

    # ---------------------------------------------------------------- Part 5
    print("=" * 72)
    print("PART 5: off-line injection — Krein kernels go indefinite")
    g_rest = gz[1:]
    a_rest = 1.0 / (g_rest ** 2 + 0.25)

    def h_beta(t, beta):
        t = np.atleast_1d(np.asarray(t, dtype=float))
        shp = t.shape
        tf = t.ravel()
        out = 2 * (np.cos(np.outer(tf, g_rest)) @ a_rest)
        for rho in (beta + 1j * gz[0], 1 - beta + 1j * gz[0]):
            out += 2 * np.real(np.exp((rho - 0.5) * tf) / (rho * (1 - rho)))
        return out.reshape(shp)

    print("    beta    one-body g1^chi        pair g2^chi (carries nu_chi)")
    inj_rows = []
    for beta in (0.50, 0.55, 0.60, 0.65, 0.70):
        h0 = h_beta(np.zeros(1), beta)[0]
        r1 = krein_ratio(lambda t: h_beta(t, beta) - h0)
        r2 = krein_ratio(lambda t: h_beta(t, beta) ** 2 - h0 ** 2)
        inj_rows.append((beta, r1, r2))
        print(f"   {beta:.2f}   {r1:+12.3e}          {r2:+12.3e}")
    t_r = np.sort(rng.uniform(-25, 25, 90))
    h0 = h_beta(np.zeros(1), 0.6)[0]
    g2f = lambda tt: h_beta(tt, 0.6) ** 2 - h0 ** 2
    G = g2f(t_r[:, None] - t_r[None, :]) - g2f(t_r)[:, None] - g2f(t_r)[None, :]
    ev = np.linalg.eigvalsh(0.5 * (G + G.T))
    print(f"  random grid n=90, beta=0.60 (pair): lambda_min/|lambda|_max = "
          f"{ev.min()/np.abs(ev).max():+.3e}")

    # ---------------------------------------------------------------- figure
    fig, ax = plt.subplots(3, 2, figsize=(14.5, 12.5))
    for a_ in ax.flat:
        a_.grid(alpha=0.25, lw=0.5)

    b1d = bandpass(q, logX, 6, 30)
    b1m = bandpass(h, logX, 6, 30)
    ax[0, 0].plot(Xs[core], b1d[core], lw=0.8, color=C_DATA,
                  label=r"arithmetic  $q=(S_\chi-c_1X-c_0)/\sqrt{X}$")
    ax[0, 0].plot(Xs[core], b1m[core], lw=0.8, color=C_MODEL, alpha=0.75,
                  label=r"zero side  $h_\chi(\log X)$")
    ax[0, 0].set_xscale("log")
    ax[0, 0].set_xlabel("X")
    ax[0, 0].legend(fontsize=8, loc="upper right")
    ax[0, 0].set_title("(a) twisted one-body carrier, band [6, 30] — "
                       "closed-form constants only", fontsize=10)

    w = np.hanning(M_GRID)
    PAD = 8 * M_GRID          # zero-padded display spectra (finer plot grid)
    fgrid = np.fft.rfftfreq(PAD, d=(logX[1] - logX[0])) * 2 * np.pi
    Aq = np.abs(np.fft.rfft((q - q.mean()) * w, PAD))
    Ah = np.abs(np.fft.rfft((h - h.mean()) * w, PAD))
    band1 = (fgrid > 5) & (fgrid < 42)
    ax[0, 1].plot(fgrid[band1], Aq[band1] / Aq[band1].max(), lw=0.9, color=C_DATA,
                  label="data spectrum of $q$")
    ax[0, 1].plot(fgrid[band1], -Ah[band1] / Ah[band1].max(), lw=0.9, color=C_MODEL,
                  label=r"$h_\chi$ model (mirrored)")
    for k, fr in enumerate(gz[gz < 42]):
        ax[0, 1].axvline(fr, color=C_MARK, lw=0.5, ls=":",
                         label=r"$\gamma^\chi_i$ (L-string)" if k == 0 else None)
    for k, fr in enumerate(gzeta[gzeta < 42][:3]):
        ax[0, 1].axvline(fr, color=C_ABS, lw=1.0, ls="--",
                         label=r"$\zeta$ zeros (absent)" if k == 0 else None)
    ax[0, 1].set_xlabel(r"frequency in $\log X$")
    ax[0, 1].legend(fontsize=8, loc="lower right")
    ax[0, 1].set_title("(b) the jewel string of $L(s,\\chi_3)$: single-zero "
                       "lines, no $\\zeta$ lines", fontsize=10)

    ax[1, 0].plot(Xs[core], bd[core], lw=0.8, color=C_DATA, label="data  $P=q^2$")
    ax[1, 0].plot(Xs[core], bl[core], lw=0.8, color=C_MODEL, alpha=0.75,
                  label=r"binned-$\nu_\chi$ line model")
    ax[1, 0].set_xscale("log")
    ax[1, 0].set_xlabel("X")
    ax[1, 0].legend(fontsize=8, loc="upper right")
    ax[1, 0].set_title(f"(c) twisted pair layer, band [14, 55]:  corr = "
                       f"{corr2:.4f}, ratio = {ratio2:.4f}", fontsize=10)

    AP = np.abs(np.fft.rfft((P - P.mean()) * w, PAD))
    AL = np.abs(np.fft.rfft((P_lines - P_lines.mean()) * w, PAD))
    band2 = (fgrid > 12) & (fgrid < 57)
    ax[1, 1].plot(fgrid[band2], AP[band2] / AP[band2].max(), lw=0.9, color=C_DATA,
                  label="data spectrum of $P$")
    ax[1, 1].plot(fgrid[band2], -AL[band2] / AL[band2].max(), lw=0.9, color=C_MODEL,
                  label=r"$\nu_\chi$ line model (mirrored)")
    marks = sorted(gz[i] + gz[j] for i in range(6) for j in range(i, 6)
                   if 12 < gz[i] + gz[j] < 57)
    for k, fr in enumerate(marks):
        ax[1, 1].axvline(fr, color=C_MARK, lw=0.5, ls=":",
                         label=r"$\gamma^\chi_i+\gamma^\chi_j$" if k == 0 else None)
    for k, i in enumerate((3, 4)):
        ax[1, 1].axvline(gz[i], color=C_ABS, lw=1.0, ls="--",
                         label=r"single $\gamma^\chi_i$ (absent)" if k == 0 else None)
    ax[1, 1].set_xlabel(r"frequency in $\log X$")
    ax[1, 1].legend(fontsize=8, loc="lower right")
    ax[1, 1].set_title("(d) pair spectrum: lines at L-zero pair sums only",
                       fontsize=10)

    labels = ["full closed-form", "linear-only", "none"]
    tw = [prot[("twisted", p)] * 100 for p in labels]
    un = [prot[("untwisted", p)] * 100 for p in labels]
    xpos = np.arange(3)
    ax[2, 0].bar(xpos - 0.18, tw, 0.36, color=C_DATA, label=r"twisted ($\chi_3$)")
    ax[2, 0].bar(xpos + 0.18, un, 0.36, color=C_MODEL, alpha=0.8,
                 label=r"untwisted ($\zeta$)")
    ax[2, 0].set_yscale("log")
    ax[2, 0].set_xticks(xpos, labels, fontsize=8)
    ax[2, 0].set_ylabel("mean line-mass error, first 8 zeros (%)")
    for x, v in zip(xpos - 0.18, tw):
        ax[2, 0].text(x, v * 1.2, f"{v:.3g}", ha="center", fontsize=7)
    for x, v in zip(xpos + 0.18, un):
        ax[2, 0].text(x, v * 1.2, f"{v:.3g}", ha="center", fontsize=7)
    ax[2, 0].legend(fontsize=8)
    ax[2, 0].set_title("(e) PURITY: no pole $\\Rightarrow$ smooth part is linear "
                       "$\\Rightarrow$ extraction survives weak subtraction",
                       fontsize=10)

    bs = [r[0] for r in inj_rows]
    ax[2, 1].plot(bs, [r[2] for r in inj_rows], "o-", color=C_DATA,
                  label=r"pair kernel $g_2^\chi$ (carries $\nu_\chi$)")
    ax[2, 1].plot(bs, [r[1] for r in inj_rows], "s--", color=C_MODEL,
                  label=r"one-body kernel $g_1^\chi$")
    ax[2, 1].axhline(0, color="k", lw=0.6)
    ax[2, 1].set_xlabel(r"$\beta$ of injected zero quadruple")
    ax[2, 1].set_ylabel(r"$\lambda_{\min}/|\lambda|_{\max}$")
    ax[2, 1].legend(fontsize=8, loc="lower left")
    ax[2, 1].set_title("(f) off-line injection: twisted Krein kernels go "
                       "indefinite", fontsize=10)

    fig.suptitle("exp34: the twisted product carrier "
                 r"$S_\chi(X)=\sum_{n\leq X}\Lambda(n)\chi_3(n)\frac{X-n}{n}$ — "
                 r"pure screw over the $L(s,\chi_3)$ string; "
                 r"$P=q^2$ carries $\nu_\chi=\sum a(\gamma)a(\gamma')\,"
                 r"\delta_{\gamma+\gamma'}$",
                 fontsize=11)
    fig.tight_layout(rect=[0, 0, 1, 0.97])
    fig.savefig(FIG / "exp34_twisted_carrier.png", dpi=140)
    print("saved figures/exp34_twisted_carrier.png")


if __name__ == "__main__":
    main()
