"""Experiment 56: THE CARRIER JOIN (notes/CARRIER_JOIN.md).

Cross-branch JOIN of the product-weighted pair carrier (ia lane,
notes/PRODUCT_CARRIER.md, exp31_product_carrier) with the corrected Theorem J
(cu lane, notes/BLOCKS.md section 5, exp23_screwjoin / exp27_running /
exp30_screwjoin), against the barrier/hologram framing (notes/BARRIER.md,
notes/HOLOGRAM.md, exp41_superres).

The closed arithmetic statement under test (Theorem A of CARRIER_JOIN.md).
With the finite prime sums

    S(X)   = sum_{n<=X} Lambda(n) (X-n)/n,
    T(X,Y) = sum_{m<=X, n<=Y} Lambda(m)Lambda(n) (X-m)(Y-n)/(mn) = S(X)S(Y),

and the CLOSED-FORM smooth companion (all coefficients classical constants)

    Mt(X)    = X log X - (1+gamma_E) X + log 2pi + delta(X),
    delta(X) = -(1/2) sum_{k>=1} X^{-2k} / (k(2k+1)),   delta(1) = log 2 - 1,

the explicit formula (PRODUCT_CARRIER.md Prop. C1) gives, unconditionally and
with zero error term,

    q(X) := (S(X) - Mt(X)) / sqrt(X) = H1(X) := sum_rho X^{rho-1/2}/(rho(1-rho)),

an absolutely convergent zero sum.  With B = 2 + gamma_E - log 4pi = H1(1):

  RH <=> T(X,X) - 2 Mt(X) S(X) + Mt(X)^2 <= B^2 X   for all X >= 1
     <=> |H1(X)| <= B  for all X >= 1                 (two-sided)
     <=> S(X) <= Mt(X) + B sqrt(X)  for all X >= 1    (ONE-SIDED, via Landau)
     <=> the Krein kernel of g2(t) = H1(e^t)^2 - B^2 is PSD (screw axiom),

the last equivalence collapsing to its 1x1 (diagonal) minors; the converse
direction is Lemma B of CARRIER_JOIN.md (Laplace/Landau), proved there
in-repo, replacing the previously quoted Matsumoto-Suzuki Cor. 3.1
extraction.  Under RH the pair layer carries
nu = sum a(g)a(g') delta_{g+g'}, a(g) = 1/(g^2+1/4) > 0.

Parts:
  0. closed-form constants and exact ledger checks (Mt(1) = -B; chi_3 ledger
     c1 + c0 + B_chi + delta_chi(1) = 0)
  1. the carrier at 100k zeros; one-point positivity margins over 6 decades
  2. pair layer P = q^2 vs nu (band [28,60]); the defect B^2 - q^2 >= 0
  3. truncated Krein kernels of g2: lambda_min vs grid size n, radius T, and
     zero count K (model = 100k zeros; arithmetic = primes to 2e6 only)
  4. falsifiability: off-line quadruple rho = 1/2+delta+i*gamma_1 injected
     into the model side --- one-point crossing t* vs the explicit bound of
     Prop. D (t_D = th^{-1} log((Bt+Br+A0')/A0) + 2pi/gamma_1), sensitivity
     law delta * t* ~ const; Krein-kernel indefiniteness vs delta and the
     detection radius T_detect(delta)
  5. the Theorem-J transport: T_G(X) = sum_{n<=X} (Lambda*Lambda)(n)/n^2
     minus the SAME subtraction carried through the carrier => pointwise
     (no band-pass) identification, one limit constant c2, remainder
     E(X) ~ 1/X carrying the Beta pair lines (the sector no subtraction
     can remove)
  6. chi_3 twist (exp34_twisted_carrier conventions, 205 zeros from
     data/chi3_zeros_ext.npy): per-character one-point criterion
     |H1_chi| <= B_chi, kernel PSD, injection

Data: data/odlyzko_zeros_100k.txt (100k zeros), data/chi3_zeros_ext.npy.
Lambda sieved to 2e6 (task convention; exp31_product_carrier used 4e6 --
all other conventions identical).  Self-contained: numpy, scipy, mpmath,
matplotlib only.  Runtime ~2 min.
"""
import time
from pathlib import Path

import matplotlib
import numpy as np
import scipy.fft as sfft
from scipy.integrate import quad

matplotlib.use("Agg")
import matplotlib.pyplot as plt

ROOT = Path(__file__).resolve().parent.parent
GE = np.euler_gamma
B_EXACT = 2 + GE - np.log(4 * np.pi)
NMAX = 2_000_000
T0 = time.time()


# --------------------------------------------------------------------- utils
def load_zeros():
    return np.loadtxt(ROOT / "data" / "odlyzko_zeros_100k.txt")


def sieve_lambda(N):
    is_comp = np.zeros(N + 1, dtype=bool)
    for p in range(2, int(N ** 0.5) + 1):
        if not is_comp[p]:
            is_comp[p * p::p] = True
    primes = np.nonzero(~is_comp)[0][2:]          # drop 0, 1
    lam = np.zeros(N + 1)
    lam[primes] = np.log(primes)
    for p in primes[primes <= int(N ** 0.5)]:
        q = p * p
        lp = np.log(p)
        while q <= N:
            lam[q] = lp
            q *= p
    return lam


def delta_smooth(X):
    """delta(X) = -(1/2) sum_{k>=1} X^{-2k}/(k(2k+1)); delta(1) = log2 - 1."""
    X = np.atleast_1d(np.asarray(X, dtype=float))
    out = np.empty_like(X)
    k = np.arange(1.0, 1401.0)
    w = -0.5 / (k * (2 * k + 1))
    one = np.isclose(X, 1.0, rtol=0, atol=1e-12)
    out[one] = np.log(2) - 1
    Xr = X[~one]
    if len(Xr):
        parts = []
        for c in range(0, len(Xr), 512):
            xb = Xr[c:c + 512]
            parts.append(np.exp(-2.0 * np.outer(np.log(xb), k)) @ w)
        out[~one] = np.concatenate(parts)
    return out


def h_model(t, g, chunk_t=2048, chunk_g=4000):
    """h(t) = 2 sum_{gamma>0 in g} cos(gamma t)/(gamma^2 + 1/4)."""
    t = np.atleast_1d(np.asarray(t, dtype=float))
    out = np.zeros_like(t)
    a = 1.0 / (g ** 2 + 0.25)
    for ct in range(0, len(t), chunk_t):
        tb = t[ct:ct + chunk_t]
        acc = np.zeros_like(tb)
        for cg in range(0, len(g), chunk_g):
            acc += 2 * (np.cos(np.outer(tb, g[cg:cg + chunk_g]))
                        @ a[cg:cg + chunk_g])
        out[ct:ct + chunk_t] = acc
    return out


def bandpass(y, u, lo, hi):
    Y = np.fft.rfft(y - y.mean())
    f = np.fft.rfftfreq(len(y), d=(u[1] - u[0])) * 2 * np.pi
    Y[(f < lo) | (f > hi)] = 0
    return np.fft.irfft(Y, len(y))


def hann_amp(u, y, f):
    w = np.hanning(len(u))
    z = (y - y.mean()) * w
    return abs(np.sum(z * np.exp(-1j * f * u))) / (w.sum() / 2)


def krein_eigs(gfun, T, n):
    """Eigenvalues of the sampled Krein kernel G(t_i,t_j), uniform grid.

    G(t,u) = g(t-u) - g(t) - g(-u) + g(0); every g used here is even with
    g(0) = 0, so G(t,u) = g(t-u) - g(t) - g(u), and the uniform grid makes
    g(t_i - t_j) Toeplitz (2n-1 evaluations of g)."""
    t = np.linspace(-T, T, n)
    step = t[1] - t[0]
    dvals = gfun(np.arange(-(n - 1), n) * step)
    gt = gfun(t)
    idx = np.arange(n)
    G = dvals[idx[:, None] - idx[None, :] + n - 1] - gt[:, None] - gt[None, :]
    return np.linalg.eigvalsh(0.5 * (G + G.T))


class Carrier:
    """S(X) = sum_{n<=X} Lambda(n)(X-n)/n from a sieve, plus the exact
    unconditional H1 evaluator q(X) = (S - Mt)/sqrt(X)  (Prop. C1)."""

    def __init__(self, N=NMAX, weights=None):
        self.N = N
        self.lam = sieve_lambda(N)
        lamw = self.lam if weights is None else self.lam * weights[: N + 1]
        pp = np.nonzero(lamw)[0]
        self.pp = pp
        self.cpsi = np.cumsum(lamw[pp].astype(np.longdouble))
        self.cLn = np.cumsum((lamw[pp] / pp).astype(np.longdouble))

    def S(self, X):
        X = np.atleast_1d(np.asarray(X, dtype=float))
        idx = np.searchsorted(self.pp, X, "right") - 1
        Xl = X.astype(np.longdouble)
        j = np.maximum(idx, 0)
        return np.where(idx >= 0,
                        Xl * np.take(self.cLn, j) - np.take(self.cpsi, j),
                        np.longdouble(0.0))

    def q(self, X):
        """Exact H1(X) from prime data + closed-form Mt (no fitting)."""
        X = np.atleast_1d(np.asarray(X, dtype=float))
        Xl = X.astype(np.longdouble)
        M = (Xl * np.log(Xl) - (1 + np.longdouble(GE)) * Xl
             + np.log(2 * np.longdouble(np.pi)))
        return np.asarray((self.S(X) - M - delta_smooth(X)) / np.sqrt(Xl),
                          dtype=float)

    def q_of_t(self, t):
        """q at t = log X, extended evenly to t < 0 (rho <-> 1-rho pairing
        makes H1(e^{-t}) = H1(e^t) unconditionally)."""
        t = np.atleast_1d(np.asarray(t, dtype=float))
        return self.q(np.exp(np.abs(t)))


def h_pert(t, g_rest, beta, gamma0):
    """H1 with the first zero pair replaced by the off-line quadruple
    {beta +- i gamma0, 1-beta +- i gamma0} (beta = 1/2: doubled pair)."""
    t = np.atleast_1d(np.asarray(t, dtype=float))
    out = h_model(t, g_rest)
    for rho in (beta + 1j * gamma0, 1 - beta + 1j * gamma0):
        out += 2 * np.real(np.exp((rho - 0.5) * t) / (rho * (1 - rho)))
    return out


def main():
    gam = load_zeros()
    print(f"loaded {len(gam)} zeta zeros, gamma_max = {gam[-1]:.3f}")

    # ------------------------------------------------------------------ P0
    print("=" * 74)
    print("PART 0: closed-form constants and exact ledger checks")
    print(f"  B = 2 + gamma_E - log 4pi = {B_EXACT:.10f}")
    for K in (1000, 10000, 100000):
        a = 1.0 / (gam[:K] ** 2 + 0.25)
        print(f"  K = {K:6d}: B_K = {2*a.sum():.8f}   "
              f"B - B_K = {B_EXACT-2*a.sum():.3e}")
    aK = 1.0 / (gam ** 2 + 0.25)
    m0 = 2 * np.sum(aK ** 2)
    S4 = 2 * np.sum(aK ** 4)
    print(f"  m0 = {m0:.6e}   S4 = {S4:.6e}   D0 = 3(m0^2-S4) = "
          f"{3*(m0**2-S4):.6e}")
    for x0 in (1.0, 1.5, 3.0, 10.0):
        dq = x0 * quad(lambda t: 0.5 * np.log(1 - t ** -2) / t ** 2,
                       x0, np.inf)[0]
        ds = delta_smooth(np.array([x0]))[0]
        print(f"  delta({x0:4.1f}): series {ds:+.12f}  quad {dq:+.12f}  "
              f"diff {ds-dq:+.1e}")
    Mt1 = -(1 + GE) + np.log(2 * np.pi) + (np.log(2) - 1)
    print(f"  sharpness anchor Mt(1) = -B:  Mt(1) = {Mt1:+.12f},  "
          f"-B = {-B_EXACT:+.12f},  diff = {Mt1+B_EXACT:.1e}")

    # chi_3 constants (closed forms of TWISTED_CARRIER.md T1; the ledger
    # L'/L(0) + L'/L(1) = -log(3/pi) + gamma_E + log 2 gives L'/L(1) from
    # the Gamma-closed form of L'/L(0) with no differentiation)
    import mpmath as mp
    mp.mp.dps = 40
    L1 = (mp.digamma(mp.mpf(2) / 3) - mp.digamma(mp.mpf(1) / 3)) / 3
    print(f"  L(1,chi_3) = {mp.nstr(L1, 15)}   pi/(3 sqrt 3) = "
          f"{mp.nstr(mp.pi/(3*mp.sqrt(3)), 15)}   diff = "
          f"{mp.nstr(L1 - mp.pi/(3*mp.sqrt(3)), 3)}")
    c0_mp = 3 * mp.log(mp.gamma(mp.mpf(1) / 3)
                       / mp.gamma(mp.mpf(2) / 3)) - mp.log(3)
    LL1_mp = -mp.log(mp.mpf(3) / mp.pi) + mp.euler + mp.log(2) - c0_mp
    # independent check of the ledger: central difference across the
    # cancelling Hurwitz poles at s = 1 (dps 40 absorbs the cancellation)
    Lchi = lambda s: 3 ** (-s) * (mp.zeta(s, mp.mpf(1) / 3)
                                  - mp.zeta(s, mp.mpf(2) / 3))
    hstep = mp.mpf(10) ** (-12)
    LL1_num = (Lchi(1 + hstep) - Lchi(1 - hstep)) / (2 * hstep) / L1
    print(f"  L'/L(1,chi_3): ledger closed form = {mp.nstr(LL1_mp, 15)}   "
          f"central diff = {mp.nstr(LL1_num, 15)}")
    print(f"    |diff| = {mp.nstr(abs(LL1_mp - LL1_num), 3)}   "
          f"(genuine check: the two routes share no formula)")
    c1_chi = float(-LL1_mp)
    c0_chi = float(c0_mp)
    B_chi = float(mp.log(mp.mpf(3) / mp.pi) - mp.euler + 2 * LL1_mp)
    print(f"  c1_chi = -L'/L(1,chi_3) = {c1_chi:.12f}   (T1: -0.368281615970)")
    print(f"  c0_chi = +L'/L(0,chi_3) = {c0_chi:.12f}   (T1: +0.948198826673)")
    print(f"  B_chi  = {B_chi:.12f}   (T1:  0.113229969857)")
    print(f"  chi sharpness anchor  c1 + c0 + B_chi + delta_chi(1) = "
          f"{c1_chi + c0_chi + B_chi - float(mp.log(2)):+.3e}   "
          f"(must be 0; delta_chi(1) = -log 2)")

    # ------------------------------------------------------------------ P1
    print("=" * 74)
    print("PART 1: carrier identity at 100k zeros + one-point margins")
    car = Carrier(NMAX)
    print(f"  [sieve to {NMAX:.0e} done, {time.time()-T0:.0f}s]")

    M_A = 8192
    logXA = np.linspace(np.log(3e3), np.log(1.9e6), M_A)
    XA = np.exp(logXA)
    qA = car.q(XA)
    hA = h_model(logXA, gam)
    resid = qA - hA
    print(f"  main grid X in [3e3, 1.9e6], M = {M_A}; model = all 100k "
          f"zeros; NO fitted constants")
    print(f"  corr(q, h)      = {np.corrcoef(qA, hA)[0,1]:.9f}")
    print(f"  RMS(q)/RMS(h)   = {qA.std()/hA.std():.7f}")
    print(f"  max|q - h|      = {np.max(np.abs(resid)):.3e}   "
          f"RMS(q-h)/RMS(h) = {resid.std()/hA.std():.3e}")

    M_B = 3000
    logXB = np.linspace(np.log(1.02), np.log(3e3), M_B)
    XB = np.exp(logXB)
    qB = car.q(XB)
    hB = h_model(logXB, gam)
    print(f"  small grid X in [1.02, 3e3], M = {M_B}: max|q - h| = "
          f"{np.max(np.abs(qB-hB)):.3e}  (floor = coherent 100k-zero "
          f"truncation tail B - B_K = {B_EXACT-2*aK.sum():.1e} near t=0)")

    q_all = np.concatenate([qB, qA])
    X_all = np.concatenate([XB, XA])
    defect = B_EXACT ** 2 - q_all ** 2
    print(f"  ONE-POINT CRITERION  B^2 X - (S - Mt)^2 >= 0  on {len(q_all)} "
          f"grid points in [1.02, 1.9e6]:")
    print(f"    holds everywhere: {bool(np.all(defect > 0))};   min defect "
          f"= {defect.min():.3e} at X = {X_all[np.argmin(defect)]:.3f}")
    print(f"    global max |q|/B = {np.max(np.abs(q_all))/B_EXACT:.4f} at "
          f"X = {X_all[np.argmax(np.abs(q_all))]:.1f}")
    print("    per-decade margins:")
    edges = [1.02, 10, 100, 1e3, 1e4, 1e5, 1e6, 1.9e6]
    print("      window                max q/B    min q/B   "
          "min (B^2-q^2)/B^2")
    for lo, hi in zip(edges[:-1], edges[1:]):
        m = (X_all >= lo) & (X_all < hi)
        print(f"      [{lo:8.2f},{hi:8.0f})   {q_all[m].max()/B_EXACT:+8.4f} "
              f"  {q_all[m].min()/B_EXACT:+8.4f}     "
              f"{defect[m].min()/B_EXACT**2:.4f}")
    for xx in (1.02, 1.1, 1.5, 2.0):
        qq = car.q(np.array([xx]))[0]
        print(f"    near X->1+: X = {xx:5.2f}: q/B = {qq/B_EXACT:.6f}   "
              f"defect/B^2 = {(B_EXACT**2-qq**2)/B_EXACT**2:.3e}")

    # ------------------------------------------------------------------ P2
    print("=" * 74)
    print("PART 2: pair layer P = q^2 vs nu, and the defect B^2 - P")
    P = qA ** 2
    Pm = hA ** 2
    lo_b, hi_b = 28.0, 60.0
    bd = bandpass(P, logXA, lo_b, hi_b)
    bm = bandpass(Pm, logXA, lo_b, hi_b)
    core = slice(M_A // 8, -M_A // 8)
    print(f"  mean(P) = {P.mean():.4e}   mean(h^2) = {Pm.mean():.4e}   "
          f"m0 = {m0:.4e}  (positive DC = diagonal of nu)")
    print(f"  band [28,60]: corr(P, h^2 model) = "
          f"{np.corrcoef(bd[core], bm[core])[0,1]:.6f}   amplitude ratio = "
          f"{bd[core].std()/bm[core].std():.6f}")
    # binned nu line model (exp31_product_carrier conventions, 1500 zeros)
    g2z = gam[:1500]
    sgn = np.concatenate([g2z, -g2z])
    av = 1.0 / (sgn ** 2 + 0.25)
    fpair = (sgn[:, None] + sgn[None, :]).ravel()
    mpair = (av[:, None] * av[None, :]).ravel()
    sel = (np.abs(fpair) > 20) & (np.abs(fpair) < 70)
    fb = np.round(fpair[sel] * 1000).astype(np.int64)
    ms = mpair[sel]
    order = np.argsort(fb)
    fb, ms = fb[order], ms[order]
    uniq, start = np.unique(fb, return_index=True)
    cmass = np.add.reduceat(ms, start)
    fpos = uniq[uniq > 0] / 1000.0
    cpos = cmass[uniq > 0]
    P_lines = np.zeros(M_A)
    for c in range(0, len(fpos), 400):
        P_lines += 2 * (np.cos(np.outer(logXA, fpos[c:c + 400]))
                        @ cpos[c:c + 400])
    bl = bandpass(P_lines, logXA, lo_b, hi_b)
    print(f"  band [28,60]: corr(P, binned-nu line model) = "
          f"{np.corrcoef(bd[core], bl[core])[0,1]:.6f}   amplitude ratio = "
          f"{bd[core].std()/bl[core].std():.6f}   "
          f"({len(fpos)} lines, all masses > 0: {bool(np.all(cpos > 0))})")
    print(f"  defect B^2 - P = B^2 - q^2 > 0 on the full grid: "
          f"{bool(np.all(defect > 0))}  (the RH-equivalent positivity, one "
          f"scalar inequality per X)")

    # ------------------------------------------------------------------ P3
    print("=" * 74)
    print("PART 3: truncated Krein kernels of g2 --- lambda_min vs truncation")
    hK0 = h_model(np.zeros(1), gam)[0]

    def g2_model(t):
        return h_model(t, gam) ** 2 - hK0 ** 2

    def g2_arith(t):
        return car.q_of_t(t) ** 2 - B_EXACT ** 2

    print("  (a) grid refinement at fixed radius T = 7 (the Toeplitz "
          "differences reach |t| = 2T,")
    print("      so the arithmetic kernel needs e^{2T} = 1.2e6 <= 2e6 --- "
          "primes only, no zeros):")
    print("      n     model lam_min   model ratio     arith lam_min   "
          "arith ratio")
    p3a = []
    for n in (10, 20, 40, 80, 160, 320):
        evm = krein_eigs(g2_model, 7.0, n)
        eva = krein_eigs(g2_arith, 7.0, n)
        p3a.append((n, evm.min(), evm.min() / np.abs(evm).max(),
                    eva.min(), eva.min() / np.abs(eva).max()))
        print(f"    {n:5d}   {evm.min():+.3e}    "
              f"{evm.min()/np.abs(evm).max():+.3e}    {eva.min():+.3e}    "
              f"{eva.min()/np.abs(eva).max():+.3e}")
    print("  (b) radius growth at fixed density (n = 8T), model (100k "
          "zeros):")
    print("      T      n    lam_min        ratio")
    for T in (5, 10, 20, 40):
        n = 8 * T
        evm = krein_eigs(g2_model, float(T), n)
        print(f"    {T:5d}  {n:5d}  {evm.min():+.3e}    "
              f"{evm.min()/np.abs(evm).max():+.3e}")
    print("  (c) spectral truncation: K zeros, fixed grid (T=14, n=160);")
    print("      adding atoms adds a PSD Gram term (Weyl), so lambda_min "
          "must be nondecreasing:")
    prev = -np.inf
    for K in (100, 1000, 10000, 100000):
        gK = gam[:K]
        h0K = h_model(np.zeros(1), gK)[0]
        ev = krein_eigs(lambda t: h_model(t, gK) ** 2 - h0K ** 2, 14.0, 160)
        mono = "ok" if ev.min() >= prev - 1e-15 else "VIOLATION"
        print(f"      K = {K:6d}: lambda_min = {ev.min():+.6e}   [{mono}]")
        prev = ev.min()
    print(f"  [kernels done, {time.time()-T0:.0f}s]")

    # ------------------------------------------------------------------ P4
    print("=" * 74)
    print("PART 4: falsifiability --- off-line quadruple "
          "rho = 1/2 + delta + i gamma_1")
    g1v = gam[0]
    rest_scan = gam[1:20000]        # truncated self-consistent world (scan)
    B_r = 2 * np.sum(1.0 / (rest_scan ** 2 + 0.25))

    print("  (a) one-point crossing: first t* > 0 with "
          "H1(e^t)^2 > H1(1)^2, vs Prop. D bound")
    print("      t_D = th^{-1} log((Bt + Br + A0')/A0) + 2pi/gamma_1:")
    print("      delta    Bt=H1(1)    t* (measured)   t_D (bound)   "
          "delta * t*")
    p4a = []
    for dl in (0.002, 0.005, 0.01, 0.02, 0.05, 0.1, 0.2):
        beta = 0.5 + dl
        rho = beta + 1j * g1v
        rhop = 1 - beta + 1j * g1v
        A0 = 2 / abs(rho * (1 - rho))
        A0p = 2 / abs(rhop * (1 - rhop))
        Bt = h_pert(np.zeros(1), rest_scan, beta, g1v)[0]
        t_bound = np.log((Bt + B_r + A0p) / A0) / dl + 2 * np.pi / g1v
        tt = np.arange(0.0, t_bound + 5, 0.04)
        D = h_pert(tt, rest_scan, beta, g1v) ** 2 - Bt ** 2
        pos = np.nonzero(D > 0)[0]
        pos = pos[pos > 0]
        if len(pos):
            t0 = tt[pos[0]]
            ttf = np.arange(max(t0 - 0.08, 1e-3), t0 + 0.08, 1e-3)
            Df = h_pert(ttf, rest_scan, beta, g1v) ** 2 - Bt ** 2
            tstar = ttf[np.nonzero(Df > 0)[0][0]]
            ok = "OK" if tstar <= t_bound else "FAIL"
            print(f"     {dl:6.3f}   {Bt:8.5f}    {tstar:10.2f}     "
                  f"{t_bound:10.2f}  {ok}   {dl*tstar:7.3f}")
            p4a.append((dl, tstar, t_bound))
        else:
            print(f"     {dl:6.3f}   {Bt:8.5f}    none < {t_bound+5:.0f}"
                  f"   {t_bound:10.2f}  FAIL")
    print("      (control) delta = 0: max of H1^2 - H1(1)^2 over "
          "t in [0.04, 100]:")
    tt = np.arange(0.04, 100, 0.04)
    Dc = (h_pert(tt, rest_scan, 0.5, g1v) ** 2
          - h_pert(np.zeros(1), rest_scan, 0.5, g1v)[0] ** 2)
    print(f"        max = {Dc.max():.3e}  (< 0: criterion holds on the line)")
    print("      sensitivity law: falsification depth log X* = t* ~ "
          "C/delta,")
    cs = [dl * ts for dl, ts, _ in p4a]
    print(f"      measured C = delta*t* in [{min(cs):.2f}, {max(cs):.2f}] "
          f"(Prop. D predicts C <= log((2B+A0)/A0) + o(1) ~= "
          f"{np.log((2*B_EXACT+0.01)/0.01):.2f})")

    print("  (b) Krein kernels, T = 25, n = 120, rest = 99,999 on-line "
          "zeros (exp31_product_carrier grid conventions):")
    print("      delta    one-body g1 ratio     pair g2 ratio")
    rest_k = gam[1:]
    p4b = []
    for dl in (0.0, 0.005, 0.01, 0.02, 0.05, 0.1, 0.2):
        beta = 0.5 + dl
        h0b = h_pert(np.zeros(1), rest_k, beta, g1v)[0]
        ev1 = krein_eigs(lambda t: h_pert(t, rest_k, beta, g1v) - h0b,
                         25.0, 120)
        ev2 = krein_eigs(lambda t: h_pert(t, rest_k, beta, g1v) ** 2
                         - h0b ** 2, 25.0, 120)
        r1 = ev1.min() / np.abs(ev1).max()
        r2 = ev2.min() / np.abs(ev2).max()
        p4b.append((dl, r1, r2))
        print(f"     {dl:6.3f}    {r1:+12.3e}       {r2:+12.3e}")
    print("  (c) detection radius: smallest T (spacing 0.15) with pair-"
          "kernel ratio < -0.01:")
    print("      delta    T_detect    delta * T_detect")
    for dl in (0.02, 0.05, 0.1, 0.2):
        beta = 0.5 + dl
        h0b = h_pert(np.zeros(1), rest_k, beta, g1v)[0]
        Tdet = None
        for T in (3, 4, 5, 6, 8, 10, 12, 15, 18, 22, 27, 33, 40, 50, 62,
                  78, 100):
            n = min(int(2 * T / 0.15), 1500)
            ev = krein_eigs(lambda t: h_pert(t, rest_k, beta, g1v) ** 2
                            - h0b ** 2, float(T), n)
            if ev.min() / np.abs(ev).max() < -0.01:
                Tdet = T
                break
        print(f"     {dl:6.3f}    {str(Tdet):>6s}      "
              f"{dl*Tdet if Tdet else float('nan'):7.2f}")
    print(f"  [injection done, {time.time()-T0:.0f}s]")

    # ------------------------------------------------------------------ P5
    print("=" * 74)
    print("PART 5: Theorem-J transport --- the SAME subtraction on the "
          "Goldbach side")
    N = car.N
    n_fft = sfft.next_fast_len(2 * N + 1)
    LA = sfft.rfft(car.lam, n_fft)
    G = sfft.irfft(LA * LA, n_fft)[:N + 1]
    l2, l3 = np.log(2), np.log(3)
    print(f"  G = Lambda*Lambda by FFT: G(4) - log^2 2 = {G[4]-l2**2:+.2e},"
          f"  G(5) - 2 log2 log3 = {G[5]-2*l2*l3:+.2e},")
    print(f"    G(6) - (2 log^2 2 + log^2 3) = {G[6]-(2*l2**2+l3**2):+.2e}")
    nn = np.arange(1, N + 1, dtype=np.float64)
    Tsum = np.cumsum((G[1:] / nn ** 2).astype(np.longdouble))
    TX = np.asarray(np.take(Tsum, np.minimum(XA.astype(np.int64), N) - 1),
                    dtype=float)
    c2X = TX - np.log(XA) - 2 * qA / np.sqrt(XA)
    print("  c2(X) = T_G(X) - log X - 2 q(X)/sqrt(X)   [q from PRIME DATA "
          "via the carrier;")
    print("   target: c2 = -2.2803, exp23_screwjoin corrected total-field "
          "value / SCREW.md Part 5 fit -2.280]:")
    for lo, hi in [(1e4, 1e5), (1e5, 1e6), (1e6, 1.9e6)]:
        m = (XA >= lo) & (XA < hi)
        print(f"    X in [{lo:.0e},{hi:.0e}): mean = {c2X[m].mean():+.5f}   "
              f"std = {c2X[m].std():.2e}")
    m_top = XA >= 5e5
    c2hat = c2X[m_top].mean()
    print(f"  c2_hat (mean over X >= 5e5) = {c2hat:+.5f}")
    E = c2X - c2hat
    print("  remainder E(X) = c2(X) - c2_hat  (Prop. E: E << X^{-1} log^3 X "
          "under RH; carries the")
    print("  reweighted Beta pair layer --- the sector NO subtraction can "
          "remove):")
    print("      window                RMS(E)       RMS(E) * Xmid")
    for lo, hi in [(1e4, 4e4), (4e4, 1.6e5), (1.6e5, 6.4e5), (6.4e5, 1.9e6)]:
        m = (XA >= lo) & (XA < hi)
        xm = np.sqrt(lo * hi)
        print(f"    [{lo:8.0e},{hi:8.0e})    {E[m].std():.3e}    "
              f"{E[m].std()*xm:8.3f}")
    slope = np.polyfit(np.log(XA), np.log(np.abs(E) + 1e-12), 1)[0]
    print(f"  log-log decay fit of |E|: slope = {slope:.2f}  "
          f"(Prop. E predicts ~ -1 up to log^3)")
    FT = TX - np.log(XA) - c2hat
    twoq = 2 * qA / np.sqrt(XA)
    print("  pointwise identification (NO band-pass) of the Goldbach "
          "fluctuation with the")
    print("  carrier fluctuation, one constant (c2_hat) of subtraction "
          "freedom left.")
    print("  The remainder/signal ratio decays like sqrt(X) * (1/X) = "
          "X^{-1/2}, so the")
    print("  identification sharpens with X (per-window, no band-pass):")
    print("      window                corr      RMS ratio   "
          "RMS(E)/RMS(2q/sqrt X)")
    for lo, hi in [(3e3, 1e4), (1e4, 1e5), (1e5, 5e5), (5e5, 1.9e6)]:
        m = (XA >= lo) & (XA < hi)
        cc = np.corrcoef(FT[m], twoq[m])[0, 1]
        print(f"    [{lo:8.0e},{hi:8.0e})   {cc:8.4f}    "
              f"{FT[m].std()/twoq[m].std():8.4f}     "
              f"{E[m].std()/twoq[m].std():.3f}")
    XE = XA * E
    print("  spectral content of X*E(X) (Hann amplitudes over the full "
          "grid; the k=0 pair")
    print("  sector: sum lines, difference/cross content --- measured, "
          "not decomposed):")
    for nm, f0 in [("gamma_1    ", gam[0]), ("2 gamma_1  ", 2 * gam[0]),
                   ("g_1 + g_2  ", gam[0] + gam[1]),
                   ("g_2 - g_1  ", gam[1] - gam[0])]:
        print(f"    {nm} = {f0:7.3f}: amp = {hann_amp(logXA, XE, f0):.3e}")
    print(f"  [transport done, {time.time()-T0:.0f}s]")

    # ------------------------------------------------------------------ P6
    print("=" * 74)
    print("PART 6: chi_3 twist (exp34_twisted_carrier conventions, "
          "205 L-zeros)")
    gchi = np.load(ROOT / "data" / "chi3_zeros_ext.npy")
    print(f"  {len(gchi)} zeros of L(s,chi_3), gamma_max = {gchi[-1]:.3f}")
    chi = np.zeros(NMAX + 1)
    chi[1::3] = 1.0
    chi[2::3] = -1.0
    car_chi = Carrier(NMAX, weights=chi)

    def delta_chi(X):
        X = np.asarray(X, dtype=float)
        return -np.arctanh(1.0 / X) - 0.5 * X * np.log1p(-1.0 / X ** 2)

    def q_chi(X):
        X = np.atleast_1d(np.asarray(X, dtype=float))
        out = np.empty_like(X)
        one = X < 1.0 + 1e-12
        # X -> 1+ limit: S_chi(1) = 0, delta_chi(1) = -log 2, so
        # q_chi(1) = -(c1 + c0 - log 2) = B_chi (the sharpness anchor)
        out[one] = -(c1_chi + c0_chi - np.log(2.0))
        Xr = X[~one]
        if len(Xr):
            sm = c1_chi * Xr + c0_chi + delta_chi(Xr)
            out[~one] = np.asarray((car_chi.S(Xr) - sm) / np.sqrt(Xr),
                                   dtype=float)
        return out

    def q_chi_of_t(t):
        t = np.atleast_1d(np.asarray(t, dtype=float))
        return q_chi(np.exp(np.abs(t)))

    logXC = np.linspace(np.log(30), np.log(1.9e6), 6000)
    XC = np.exp(logXC)
    qC = q_chi(XC)
    hC = h_model(logXC, gchi)
    print(f"  grid X in [30, 1.9e6], M = 6000; model = 205 zeros; no fitted "
          f"constants")
    print(f"  corr(q_chi, h_chi) = {np.corrcoef(qC, hC)[0,1]:.6f}   "
          f"RMS ratio = {qC.std()/hC.std():.4f}")
    bC = bandpass(qC, logXC, 5, 45)
    bM = bandpass(hC, logXC, 5, 45)
    coreC = slice(750, -750)
    print(f"  resolved band [5,45]: corr = "
          f"{np.corrcoef(bC[coreC], bM[coreC])[0,1]:.8f}   ratio = "
          f"{bC[coreC].std()/bM[coreC].std():.6f}")
    defC = B_chi ** 2 - qC ** 2
    print(f"  ONE-POINT CRITERION |q_chi| <= B_chi on the grid: holds "
          f"everywhere: {bool(np.all(defC > 0))}")
    print(f"    max |q_chi|/B_chi = {np.max(np.abs(qC))/B_chi:.4f} at "
          f"X = {XC[np.argmax(np.abs(qC))]:.1f};   min defect/B_chi^2 = "
          f"{defC.min()/B_chi**2:.4f}")
    h0C = h_model(np.zeros(1), gchi)[0]
    evc = krein_eigs(lambda t: h_model(t, gchi) ** 2 - h0C ** 2, 7.0, 160)
    eva = krein_eigs(lambda t: q_chi_of_t(t) ** 2 - B_chi ** 2, 7.0, 160)
    print(f"  Krein kernel of g2_chi (T=7, n=160): model lam_min = "
          f"{evc.min():+.3e} (ratio {evc.min()/np.abs(evc).max():+.2e});")
    print(f"    arithmetic lam_min = {eva.min():+.3e} (ratio "
          f"{eva.min()/np.abs(eva).max():+.2e})")
    print("  injection (first L-zero pair -> quadruple, 204 on line; T=25, "
          "n=120; exp34_twisted_carrier Part 5):")
    print("      beta     one-body ratio    pair ratio")
    g1c = gchi[0]
    restc = gchi[1:]
    for beta in (0.50, 0.55, 0.60):
        h0b = h_pert(np.zeros(1), restc, beta, g1c)[0]
        ev1 = krein_eigs(lambda t: h_pert(t, restc, beta, g1c) - h0b,
                         25.0, 120)
        ev2 = krein_eigs(lambda t: h_pert(t, restc, beta, g1c) ** 2
                         - h0b ** 2, 25.0, 120)
        print(f"     {beta:5.2f}    {ev1.min()/np.abs(ev1).max():+12.3e}   "
              f"{ev2.min()/np.abs(ev2).max():+12.3e}")

    # ---------------------------------------------------------------- figure
    fig, ax = plt.subplots(2, 2, figsize=(13.5, 9.5))
    for a_ in ax.flat:
        a_.grid(alpha=0.25, lw=0.5)

    ax[0, 0].plot(X_all, q_all / B_EXACT, lw=0.5, color="#1f77b4",
                  label=r"$q(X)/B=(S-\widetilde M)/(B\sqrt{X})$")
    ax[0, 0].axhline(1.0, color="crimson", lw=1.0, label=r"$\pm1$ (RH wall)")
    ax[0, 0].axhline(-1.0, color="crimson", lw=1.0)
    ax[0, 0].set_xscale("log")
    ax[0, 0].set_ylim(-1.15, 1.15)
    ax[0, 0].set_xlabel("X")
    ax[0, 0].legend(fontsize=8, loc="lower right")
    ax[0, 0].set_title("(a) one-point criterion: |q| < B, equality only "
                       "at X = 1", fontsize=10)

    ns = [r[0] for r in p3a]
    ax[0, 1].loglog(ns, [max(r[1], 1e-18) for r in p3a], "o-",
                    color="#1f77b4", label="model (100k zeros), T = 7")
    ax[0, 1].loglog(ns, [max(r[3], 1e-18) for r in p3a], "s--",
                    color="seagreen", label="arithmetic (primes to 2e6)")
    ax[0, 1].set_xlabel("grid size n")
    ax[0, 1].set_ylabel(r"$\lambda_{\min}$")
    ax[0, 1].legend(fontsize=8)
    ax[0, 1].set_title(r"(b) truncated Krein kernel of $g_2$: "
                       r"$\lambda_{\min}>0$ vs refinement", fontsize=10)

    dls = [r[0] for r in p4b]
    ax[1, 0].plot(dls, [r[2] for r in p4b], "o-", color="#1f77b4",
                  label=r"pair kernel $g_2$ (carries $\nu$)")
    ax[1, 0].plot(dls, [r[1] for r in p4b], "s--", color="crimson",
                  label=r"one-body kernel $g_1$")
    ax[1, 0].axhline(0, color="k", lw=0.6)
    ax[1, 0].set_xlabel(r"$\delta=\beta-1/2$ of injected quadruple")
    ax[1, 0].set_ylabel(r"$\lambda_{\min}/|\lambda|_{\max}$")
    ax[1, 0].legend(fontsize=8, loc="lower left")
    ax[1, 0].set_title("(c) falsifiability: kernels go indefinite off the "
                       "line (T=25, n=120)", fontsize=10)

    ax[1, 1].plot(XA, c2X, lw=0.6, color="#1f77b4",
                  label=r"$c_2(X)=T_G-\log X-2q/\sqrt{X}$  (primes only)")
    ax[1, 1].axhline(-2.2803, color="crimson", lw=1.0, ls="--",
                     label=r"$c_2=-2.2803$ (exp23_screwjoin corrected)")
    ax[1, 1].set_xscale("log")
    ax[1, 1].set_ylim(-2.45, -2.15)
    ax[1, 1].set_xlabel("X")
    ax[1, 1].legend(fontsize=8, loc="lower right")
    ax[1, 1].set_title("(d) Theorem-J transport: the carrier subtraction "
                       "leaves one constant", fontsize=10)

    fig.suptitle("exp56: the carrier join --- RH as one-point positivity of "
                 r"the finite pair carrier: $T(X,X)-2\widetilde{M}S"
                 r"+\widetilde{M}^2 \leq B^2 X$", fontsize=11)
    fig.tight_layout(rect=[0, 0, 1, 0.96])
    fig.savefig(ROOT / "figures" / "exp56_carrier_join.png", dpi=140)
    print(f"saved figures/exp56_carrier_join.png   [total "
          f"{time.time()-T0:.0f}s]")


if __name__ == "__main__":
    main()
