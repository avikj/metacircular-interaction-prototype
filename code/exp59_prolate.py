"""Experiment 59: THE PROLATE / CONNES-CONSANI BRIDGE
(STATE target 6; companion notes/PROLATE_BRIDGE.md; figure figures/exp59_prolate.png)

Purpose: connect the exp25/LP_CERT negativity landscape to the outside
prolate-spheroidal positivity literature (Slepian-Pollak 1961; Connes-Consani
arXiv:2006.13771, arXiv:2106.01715; Connes-Moscovici arXiv:2112.05500;
Connes-Consani-Moscovici arXiv:2310.18423), and test the terminal blocker of
LP_CERT S5: direct collocation on the exp25 Gaussian span is numerically
degenerate past K ~ 20 knots (cond 2.6e16 zero-knots / 1.8e16 prime-knots at
K = 24) -- "prolate/Sonin basis needed".

Normalization is exp14/exp25 (notes/WEIL.md Prop W1, verified there 1.8e-10):
g on u = log x, Phi_g(s) = int g(u) e^{(s-1/2)u} du, F = g * gtilde,
W(g) = pole - prime + arch, I := prime - arch = pole - W (zero-free form).

Parts
-----
(0) Prolate machinery: psi_n on [-1,1] with bandwidth c, built by
    diagonalizing the commuting operator L_c = -d/dx[(1-x^2)d/dx] + c^2 x^2
    in the normalized Legendre basis (tridiagonal per parity; the standard
    numerically stable route, cf. Xiao-Rokhlin-Yarvin 2001).  Validated
    against scipy pro_cv, orthonormality, and the finite-Fourier eigenrelation
    int_{-1}^1 psi_n(x) e^{icxy} dx = mu_n psi_n(y), lambda_n = c|mu_n|^2/2pi.
(S) Slepian eigenvalue plunge sanity check: lambda_n(c) ~ 1 for
    n < 2c/pi, then plunges; #\{lambda_n > 1/2\} vs the Shannon number 2c/pi.
(A) THE CONDITIONING RE-RUN (LP_CERT S5 blocker): evaluation functionals
    g -> Phi_g(1/2 + i gamma_k) (zero knots) and g -> g(log p^k) (prime
    knots) on prolate-spanned test spaces on [-4, 4] (same knot families as
    exp25 part C), condition number vs K for several bandwidths c, i.e.
    several time-bandwidth areas N ~ 2c/pi.
(B) The Weil form on the prolate span vs window width T (c = 15pi, N = 36:
    the same time-bandwidth rectangle as exp25 part B's M = 30 compact
    cosine modes): lambda_min(W), lambda_min(W|_P), top of I|_P, inertia of
    I, and the COUNT of near-null directions of W vs the Connes-Consani
    zeta-cycle prediction nu(lambda^2) ~ 2 lambda^2 = 2 e^T
    (arXiv:2106.01715 S2.5).  Both-ways cross-check zero-side vs assembled,
    with an analytic mean-density correction for the omitted zero tail
    (the hard-edged prolate has |Phi| ~ 1/tau, so the 100k-zero truncation
    is visible at ~1e-2 and must be modeled; the correction drops it to
    ~1e-6, which simultaneously validates both computations).
(C) Localization: is I = prime - arch diagonal-ish in prolate coordinates
    (as the CC compression picture suggests)?  Diagonal Frobenius fraction
    vs random-rotation control; participation ratios of the extreme
    eigenvectors in prolate coordinates.
(D) The zeta-cycle mechanism imported: Phi_{E(f)}(s) = zeta(s) M(f)(s) for
    the Connes-Consani map E(f)(v) = v^{1/2} sum_n f(nv) (checked against
    mpmath zeta), hence E(f) is an exact null vector of the Weil form when
    it converges; windowed prolate E-vectors g_m = E(psi_{2m,lambda})
    restricted to [lambda^{-1}, lambda] give Rayleigh quotients
    W(g)/||g||^2 that track the Slepian leakage 1 - lambda_{2m}(2 pi
    lambda^2) -- the CC "extremely small eigenvalues" (their 2.389e-48 at
    lambda^2 = 11) reproduced in the repo normalization, with the Poisson
    argument: for band-limited f with hat f(0) = 0, E(f) VANISHES on
    (0, 1/lambda), so truncation error = band leakage.

Run: python3 code/exp59_prolate.py   (~8-12 min)
"""
import sys
import time
from pathlib import Path

import numpy as np
from scipy.special import digamma, spherical_jn, pro_cv
from scipy.linalg import eigh_tridiagonal

import matplotlib
matplotlib.use("Agg")
import matplotlib.pyplot as plt

sys.path.insert(0, str(Path(__file__).resolve().parent))
from pairfield import load_zeros, sieve_primes

FIGDIR = Path(__file__).resolve().parent.parent / "figures"
LOGPI = np.log(np.pi)
EPS = np.finfo(float).eps
T0 = time.time()


def stamp(msg):
    print(f"{msg}   [{time.time()-T0:.1f}s]", flush=True)


# ----------------------------------------------------------------------------
# arithmetic data (exp14/exp25 conventions; support to e^4 < 55 for the prime
# knots and log n < T <= 3 for the prime side => X = 100 suffices)
# ----------------------------------------------------------------------------
def lambda_support(X):
    is_p = sieve_primes(X)
    ps = np.nonzero(is_p)[0].astype(np.int64)
    ns = [ps]
    ls = [np.log(ps.astype(float))]
    for p in ps[ps <= int(X ** 0.5)]:
        lp = np.log(float(p))
        pk = int(p) * int(p)
        while pk <= X:
            ns.append(np.array([pk], dtype=np.int64))
            ls.append(np.array([lp]))
            pk *= int(p)
    n = np.concatenate(ns)
    lam = np.concatenate(ls)
    order = np.argsort(n)
    n, lam = n[order], lam[order]
    return n, np.log(n.astype(float)), lam / np.sqrt(n.astype(float))


NVAL, LOGN, WLAM = lambda_support(100)
GAMMA = load_zeros()
G1 = GAMMA[0]
print(f"zeros: {GAMMA.size}, gamma_1 = {G1:.6f}, gamma_max = {GAMMA[-1]:.1f}")


def arch_density(tau):
    return np.real(digamma(0.25 + 0.5j * tau)) - LOGPI


def n_zeros_below(t):
    return int(np.searchsorted(GAMMA, t))


def inertia(ev, tol_rel=1e-8):
    t = tol_rel * np.max(np.abs(ev)) if ev.size else 0.0
    return int((ev > t).sum()), int((np.abs(ev) <= t).sum()), int((ev < -t).sum())


def null_basis(rows):
    C = np.atleast_2d(np.asarray(rows))
    s = np.linalg.svd(C, compute_uv=False)
    vt = np.linalg.svd(C, full_matrices=True)[2]
    k = int(np.sum(s > max(C.shape) * EPS * (s[0] if s.size else 1.0)))
    return vt[k:].conj().T


# ============================================================================
# (0) prolate machinery
# ============================================================================
def prolate_legendre_tridiag(c, Kleg):
    """L_c = -d/dx[(1-x^2)d/dx] + c^2 x^2 in the NORMALIZED Legendre basis
    Pbar_k = sqrt(k+1/2) P_k: couples k <-> k+2 only (parity chains)."""
    k = np.arange(Kleg, dtype=float)
    diag = k * (k + 1) + c ** 2 * (2 * k * (k + 1) - 1.0) / ((2 * k + 3) * (2 * k - 1))
    kk = np.arange(Kleg - 2, dtype=float)
    off = c ** 2 * (kk + 1) * (kk + 2) / ((2 * kk + 3) * np.sqrt((2 * kk + 1) * (2 * kk + 5)))
    return diag, off


def prolate_basis(c, N, Kleg=None):
    """First N prolates psi_n orthonormal on [-1,1]: (chi, C) with C (N, Kleg)
    normalized-Legendre coefficients, chi ascending (= pro_cv eigenvalues)."""
    if Kleg is None:
        Kleg = int(2 * c / np.pi) + N + 200
    diag, off = prolate_legendre_tridiag(c, Kleg)
    out_chi, out_C = [], []
    for par in (0, 1):
        d, o = diag[par::2], off[par::2]
        w, V = eigh_tridiagonal(d, o)
        for i in range(len(w)):
            col = np.zeros(Kleg)
            col[par::2] = V[:, i]
            out_chi.append(w[i])
            out_C.append(col)
    order = np.argsort(out_chi)[:N]
    chi = np.array([out_chi[i] for i in order])
    C = np.array([out_C[i] for i in order])
    v = legendre_eval(C, np.array([0.02]))[:, 0]
    C[v < 0] *= -1                       # sign convention near x = 0
    return chi, C


def legendre_eval(C, x):
    """psi values from normalized-Legendre coefficients: (N, len(x))."""
    K = C.shape[1]
    x = np.asarray(x, float)
    P = np.empty((K, x.size))
    P[0] = 1.0
    if K > 1:
        P[1] = x
    for k in range(1, K - 1):
        P[k + 1] = ((2 * k + 1) * x * P[k] - k * P[k - 1]) / (k + 1)
    return C @ (P * np.sqrt(np.arange(K) + 0.5)[:, None])


def trim(C, tol=1e-15):
    mx = np.max(np.abs(C), axis=0)
    kc = int(np.max(np.nonzero(mx > tol)[0])) + 1
    return C[:, :kc]


def finite_ft(C, a, chunk=40000):
    """int_{-1}^1 psi_n(x) e^{iax} dx = sum_k C_nk sqrt(k+1/2) 2 i^k j_k(a)."""
    C = trim(C)
    K = C.shape[1]
    a = np.asarray(a, float)
    fac = 2 * np.sqrt(np.arange(K) + 0.5) * (1j ** np.arange(K))
    Cf = C * fac[None, :]
    out = np.empty((C.shape[0], a.size), dtype=complex)
    for i0 in range(0, a.size, chunk):
        aa = a[i0:i0 + chunk]
        J = np.empty((K, aa.size))
        for k in range(K):
            J[k] = spherical_jn(k, aa)
        out[:, i0:i0 + chunk] = Cf @ J
    return out


def phi_line(C, T, tau):
    """Phi_n(1/2 + i tau) for the basis phi_n(u) = sqrt(2/T) psi_n(2u/T)."""
    return np.sqrt(T / 2) * finite_ft(C, np.asarray(tau, float) * (T / 2))


def phi_real(C, T, w, ng=600):
    """Phi_n(s) at real w = s - 1/2 (pole functionals w = -1/2, +1/2)."""
    xg, wg = np.polynomial.legendre.leggauss(ng)
    V = legendre_eval(C, xg)
    E = np.exp(np.outer(np.atleast_1d(w) * (T / 2), xg))
    return np.sqrt(T / 2) * (V * wg) @ E.T


def slepian_lams(c, N, ng=None):
    """(chi, C, lam, mu): Slepian eigenvalues lambda_n = c|mu_n|^2/(2 pi)."""
    chi, C = prolate_basis(c, N)
    if ng is None:
        ng = max(600, int(c) + 200)
    xg, wg = np.polynomial.legendre.leggauss(ng)
    V = legendre_eval(C, xg)
    F = finite_ft(C, c * xg)
    mu = ((F * wg) * V).sum(axis=1)
    lam = c * np.abs(mu) ** 2 / (2 * np.pi)
    res = np.max(np.abs(F - mu[:, None] * V) * np.sqrt(wg)[None, :])
    return chi, C, lam, mu, res


print("\n== (0) prolate machinery validation " + "=" * 42)
chi5, C5 = prolate_basis(5.0, 8)
ref5 = np.array([pro_cv(0, n, 5.0) for n in range(8)])
dev_cv = np.max(np.abs(chi5 - ref5) / np.abs(ref5))
xg0, wg0 = np.polynomial.legendre.leggauss(400)
V5 = legendre_eval(C5, xg0)
dev_orth = np.max(np.abs((V5 * wg0) @ V5.T - np.eye(8)))
_, _, lam10, mu10, res10 = slepian_lams(10.0, 12)
print(f"  chi vs scipy pro_cv (c=5, n=0..7): max rel dev = {dev_cv:.2e}")
print(f"  orthonormality on [-1,1]:          max dev     = {dev_orth:.2e}")
print(f"  finite-FT eigenrelation residual (c=10):        {res10:.2e}")
print(f"  mu_n phase = i^n check (c=10):     "
      + " ".join(f"{np.angle(m)/np.pi*2:+.0f}" for m in mu10[:6]) + "  (units of pi/2)")

# ============================================================================
# (S) Slepian plunge
# ============================================================================
print("\n== (S) Slepian eigenvalue plunge " + "=" * 45)
PLUNGE = {}
for c in (10.0, 15 * np.pi, 100.0):
    Np = int(2 * c / np.pi) + 25
    _, _, lam, _, _ = slepian_lams(c, Np)
    PLUNGE[c] = lam
    n_half = int((lam > 0.5).sum())
    n_plunge = int(((lam > 1e-4) & (lam < 1 - 1e-4)).sum())
    print(f"  c = {c:7.3f}: Shannon 2c/pi = {2*c/np.pi:6.2f}, #(lam > 1/2) = {n_half}, "
          f"plunge width #(1e-4 < lam < 1-1e-4) = {n_plunge}")

# ============================================================================
# (A) conditioning of the collocation functionals on prolate spans
#      (the LP_CERT S5 blocker re-run)
# ============================================================================
print("\n== (A) collocation conditioning on prolate spans, u in [-4, 4] " + "=" * 12)
# exp25 part C quoted values (LP_CERT.md S5, 60-atom Gaussian span, dim 60):
EXP25_CONDZ = {5: 5.2, 10: 2.0e2, 15: 9.1e3, 20: 2.6e8, 24: 2.6e16, 30: 1.2e17}
EXP25_CONDP = {5: 1.1, 10: 1.4, 15: 3.5e4, 20: 4.2e11, 24: 1.8e16}
TA = 8.0
pk_mask = LOGN < 4.0
u_pk = LOGN[pk_mask]
print(f"  prime knots: {u_pk.size} prime powers with log n < 4 (same as exp25)")
Ks = [5, 10, 15, 20, 24, 30, 40, 50, 60]
COND = {}
for c in (100.0, 200.0, 400.0, 652.0):
    N = int(2 * c / np.pi) + 25
    chi, C = prolate_basis(c, N)
    tau_edge = 2 * c / TA
    Ez = phi_line(C, TA, GAMMA[:60]).T                      # (60, N) complex
    Ez_n = Ez / np.linalg.norm(Ez, axis=1, keepdims=True)
    Vp = legendre_eval(C, u_pk * 2 / TA) * np.sqrt(2 / TA)  # phi_n(log p^k)
    Ep = Vp.T                                               # (24, N)
    Ep_n = Ep / np.linalg.norm(Ep, axis=1, keepdims=True)
    condz, condp = [], []
    for K in Ks:
        sz = np.linalg.svd(Ez_n[:K], compute_uv=False)
        condz.append(sz[0] / sz[-1])
        if K <= u_pk.size:
            sp = np.linalg.svd(Ep_n[:K], compute_uv=False)
            condp.append(sp[0] / sp[-1])
        else:
            condp.append(np.nan)
    EJ = np.vstack([Ez_n[:30], Ep_n])
    sj = np.linalg.svd(EJ, compute_uv=False)
    COND[c] = dict(N=N, tau_edge=tau_edge, condz=np.array(condz),
                   condp=np.array(condp), cj=sj[0] / sj[-1], sjmin=sj[-1])
    stamp(f"  c = {c:5.0f}  (N = {N}, tau_edge = 2c/T = {tau_edge:6.1f})")
print("\n  K  | " + " | ".join(f"c={c:<4.0f} zero" for c in COND)
      + " | exp25 zero || " + " | ".join(f"c={c:<4.0f} prime" for c in COND)
      + " | exp25 prime")
for i, K in enumerate(Ks):
    row = f"  {K:2d} | "
    row += " | ".join(f"{COND[c]['condz'][i]:9.3g}" for c in COND)
    row += f" | {EXP25_CONDZ.get(K, float('nan')):9.3g}  || "
    row += " | ".join(f"{COND[c]['condp'][i]:9.3g}" for c in COND)
    row += f" | {EXP25_CONDP.get(K, float('nan')):9.3g}"
    print(row)
print("  joint 30 zero + 24 prime functionals:")
for c in COND:
    print(f"    c = {c:5.0f}: cond = {COND[c]['cj']:.4g}, sigma_min = {COND[c]['sjmin']:.3e}"
          f"   (exp25: cond = 2.7e17, sigma_min = 1.3e-17)")

# ============================================================================
# (B) the Weil form on the prolate span vs window width
# ============================================================================
print("\n== (B) Weil form on the prolate span (c = 15pi, N = 36) vs window T " + "=" * 7)


def weil_matrices_prolate(T, c, N, tau_end=2.0e4):
    """All Weil-form pieces for phi_n(u) = sqrt(2/T) psi_n(2u/T) on [-T/2,T/2]
    (orthonormal: G = I).  Zero side factored (B real (2K, N)); assembled
    pole/prime/arch with analytic non-oscillatory tail beyond tau_end; plus a
    mean-density estimate of the zero side's omitted tail gamma > gamma_max
    (both tails share the boundary-term asymptotics Phi_n ~ edge/(i tau))."""
    chi, C = prolate_basis(c, N)
    C = trim(C)
    edge = np.sqrt(2 / T) * legendre_eval(C, np.array([1.0]))[:, 0]
    edm = edge * np.array([(-1) ** n for n in range(N)])       # phi_n(-T/2)
    # zero side
    P = phi_line(C, T, GAMMA)
    B = np.empty((2 * GAMMA.size, N))
    B[0::2] = np.sqrt(2) * P.real.T
    B[1::2] = np.sqrt(2) * P.imag.T
    Mzero = B.T @ B
    # pole
    pr = phi_real(C, T, np.array([-0.5, 0.5]))
    p0, p1 = pr[:, 0], pr[:, 1]
    pole = np.outer(p0, p1) + np.outer(p1, p0)
    # prime
    xg, wg = np.polynomial.legendre.leggauss(500)
    sel = LOGN < T
    prime = np.zeros((N, N))
    prime_parts = {}
    for n, ln, w in zip(NVAL[sel], LOGN[sel], WLAM[sel]):
        lo, hi = ln - T / 2, T / 2
        vm = 0.5 * (lo + hi) + 0.5 * (hi - lo) * xg
        wq = 0.5 * (hi - lo) * wg
        V1 = legendre_eval(C, (2 / T) * vm) * np.sqrt(2 / T)
        V2 = legendre_eval(C, (2 / T) * (vm - ln)) * np.sqrt(2 / T)
        Fm = (V1 * wq) @ V2.T
        Pn = w * (Fm + Fm.T)
        prime_parts[int(n)] = Pn
        prime += Pn
    # arch: fine grid + coarse grid + analytic tail
    tedge = 2 * c / T
    tau_fine = 5 * tedge + 600
    tau = np.concatenate([np.arange(0.0, tau_fine, 0.02),
                          np.arange(tau_fine, tau_end, 0.15)])
    D = arch_density(tau)
    wt = np.empty_like(tau)
    wt[1:-1] = 0.5 * (tau[2:] - tau[:-2])
    wt[0] = 0.5 * (tau[1] - tau[0])
    wt[-1] = 0.5 * (tau[-1] - tau[-2])
    P = phi_line(C, T, tau)
    arch = (np.einsum('jt,kt,t->jk', P.real, P.real, D * wt)
            + np.einsum('jt,kt,t->jk', P.imag, P.imag, D * wt)) / np.pi
    A_no = np.outer(edge, edge) + np.outer(edm, edm)   # non-osc boundary product
    arch += A_no * (np.log(tau_end / (2 * np.pi)) + 1.0) / tau_end / np.pi
    # omitted-zero tail (mean density (1/2pi) log(tau/2pi)), same asymptotics
    gmax = GAMMA[-1]
    zero_tail = A_no * (np.log(gmax / (2 * np.pi)) + 1.0) / gmax / np.pi
    scale = np.abs(pole) + np.abs(prime) + np.abs(arch)
    scale = scale + 1e-6 * scale.max() + 1e-300
    return dict(chi=chi, C=C, B=B, Mzero=Mzero, pole=pole, prime=prime,
                arch=arch, prime_parts=prime_parts, scale=scale, p0=p0, p1=p1,
                edge=edge, zero_tail=zero_tail)


TS = [0.60, 0.68, 0.81, 1.22, 1.50, 1.73, 2.07, 2.40, 2.60, 3.00]
CB, NB = 15 * np.pi, 36
# exp25 part B compact-basis (M=30) reference values, LP_CERT.md S4 table:
EXP25_PRIM = {0.81: 2.5e-1, 1.22: 8.4e-5, 1.50: 1.1e-9, 1.73: 1.4e-14, 2.07: 4.4e-21}
RES_B = []
for T in TS:
    m = weil_matrices_prolate(T, CB, NB)
    Massm = m['pole'] - m['prime'] + m['arch']
    xr = np.max(np.abs(m['Mzero'] - Massm) / m['scale'])
    xc = np.max(np.abs(m['Mzero'] + m['zero_tail'] - Massm) / m['scale'])
    s = np.linalg.svd(m['B'], compute_uv=False)
    lam = s ** 2                                     # W spectrum (orthonormal basis)
    counts = {thr: int((lam < thr * lam[0]).sum()) for thr in (1e-4, 1e-8, 1e-16, 1e-24)}
    # primitive block
    Q = null_basis(np.vstack([m['p0'], m['p1']]))
    sP = np.linalg.svd(m['B'] @ Q, compute_uv=False)
    lam_prim = sP[-1] ** 2
    Iful = m['prime'] - m['arch']
    evI = np.linalg.eigvalsh(0.5 * (Iful + Iful.T))
    IP = Q.T @ Iful @ Q
    evIP = np.linalg.eigvalsh(0.5 * (IP + IP.T))
    tedge = 2 * CB / T
    nz = n_zeros_below(tedge)
    RES_B.append(dict(T=T, xr=xr, xc=xc, lam=lam, lam_min=lam[-1] if False else s[-1] ** 2,
                      lam_max=lam[0], lam_prim=lam_prim, prim_max=sP[0] ** 2,
                      evI=evI, evIP_top=evIP[-1], inert=inertia(evI),
                      counts=counts, nz=nz, mats=m))
    r = RES_B[-1]
    stamp(f"  T = {T:4.2f}: xcheck raw {xr:8.2e} corr {xc:8.2e} | "
          f"lam_min(W) {s[-1]**2:9.3e} lam_min(W|_P) {lam_prim:9.3e} "
          f"top I|_P {evIP[-1]:+9.3e} | inertia(I) {r['inert']} | "
          f"nu(<1e-8) {counts[1e-8]:2d}  2e^T {2*np.e**T:5.1f}  "
          f"N-2N_z({tedge:.0f}) {NB-2*nz}")
print("\n  T    | lam_min(W|_P) prolate | exp25 compact M=30 | top I|_P assembled | -lam_min agree?")
for r in RES_B:
    ref = EXP25_PRIM.get(r['T'], None)
    refs = f"{ref:12.3g}" if ref else "      --    "
    agree = abs(r['evIP_top'] + r['lam_prim']) / max(abs(r['evIP_top']), r['lam_prim'], 1e-300)
    print(f"  {r['T']:4.2f} | {r['lam_prim']:15.4e}      | {refs}       | "
          f"{r['evIP_top']:+13.4e}     | rel dev {agree:8.2e}")

# ============================================================================
# (C) localization of I = prime - arch in prolate coordinates
# ============================================================================
print("\n== (C) localization of I = prime - arch in prolate coordinates " + "=" * 13)
rng = np.random.default_rng(59)


def diag_frac(M):
    return float(np.sum(np.diag(M) ** 2) / np.sum(M ** 2))


def participation(v):
    p = v ** 2 / np.sum(v ** 2)
    return float(1.0 / np.sum(p ** 2))


for T in (1.50, 2.60):
    r = next(rr for rr in RES_B if abs(rr['T'] - T) < 1e-9)
    m = r['mats']
    Iful = 0.5 * ((m['prime'] - m['arch']) + (m['prime'] - m['arch']).T)
    fd = diag_frac(Iful)
    fr = []
    for _ in range(20):
        Qr = np.linalg.qr(rng.standard_normal((NB, NB)))[0]
        fr.append(diag_frac(Qr.T @ Iful @ Qr))
    ev, U = np.linalg.eigh(Iful)
    vpos = U[:, -1]                       # the single positive (hyperbolic) direction
    vneg1 = U[:, np.searchsorted(ev, 0.0) - 1]   # largest negative eigenvalue
    vmin = U[:, 0]
    Q = null_basis(np.vstack([m['p0'], m['p1']]))
    IP = Q.T @ Iful @ Q
    evP, UP = np.linalg.eigh(0.5 * (IP + IP.T))
    vP_top = Q @ UP[:, -1]                # first negative direction of I|_P (top, <= 0)
    # overlap of vpos with the pole plane span(p0, p1)
    PP = np.linalg.qr(np.vstack([m['p0'], m['p1']]).T)[0]
    ovl = np.linalg.norm(PP.T @ vpos)
    print(f"  T = {T:4.2f}: diag fraction of I (prolate) = {fd:.3f}   "
          f"random-basis control: median {np.median(fr):.3f}, max {np.max(fr):.3f}")
    print(f"           participation ratio (of {NB}): v_+ {participation(vpos):5.1f}, "
          f"v_-1 {participation(vneg1):5.1f}, v_min {participation(vmin):5.1f}, "
          f"top(I|_P) {participation(vP_top):5.1f};  |proj of v_+ on pole plane| = {ovl:.4f}")
    top3 = np.argsort(np.abs(vP_top))[::-1][:3]
    print(f"           top(I|_P) direction: dominant prolate indices {top3.tolist()} "
          f"with weights {[round(float(vP_top[i]**2), 3) for i in top3]}")

# ============================================================================
# (D) the zeta-cycle mechanism: Phi_{E(f)} = zeta * M(f), and windowed
#     prolate E-vectors vs Slepian leakage
# ============================================================================
print("\n== (D) zeta-cycle mechanism " + "=" * 50)
# (D1) identity check with mpmath: f = 8 x^2 e^{-x^2/2} - x^2 e^{-x^2/8}
#      (even, f(0) = 0, int f = 0); M(f)(s) = Gamma((s+2)/2)/2 * [8*2^{(s+2)/2} - 8^{(s+2)/2}]
import mpmath as mp

uu = np.arange(-6.0, 6.0, 0.004)
vv = np.exp(uu)
nmax = int(np.ceil(16 / vv[0]))
Ef = np.zeros_like(uu)
for i, v in enumerate(vv):
    n = np.arange(1, int(16 / v) + 2)
    x = n * v
    Ef[i] = np.sqrt(v) * np.sum(8 * x ** 2 * np.exp(-x ** 2 / 2) - x ** 2 * np.exp(-x ** 2 / 8))


def phi_Ef(s):
    w = s - 0.5
    return 0.004 * np.sum(Ef * np.exp(w * uu))


def zetaM(s):
    s = mp.mpc(s)
    Mf = mp.gamma((s + 2) / 2) / 2 * (8 * mp.mpf(2) ** ((s + 2) / 2) - mp.mpf(8) ** ((s + 2) / 2))
    return complex(mp.zeta(s) * Mf)


print("  (D1) Phi_{E(f)}(s) = zeta(s) M(f)(s) for a Gaussian-pair f in S_0^ev:")
for s in (2.0 + 3.0j, 0.6 + 2.0j, 0.5 + 10.0j):
    a, b = phi_Ef(s), zetaM(s)
    print(f"    s = {s}:  quadrature {a:.6e}  zeta*M {b:.6e}  rel dev {abs(a-b)/abs(b):.2e}")
a1 = phi_Ef(0.5 + 1j * G1)
b1 = zetaM(0.5 + 1j * G1)
a0 = phi_Ef(0.5 + 10.0j)
print(f"    at the first zero s = 1/2 + i gamma_1: |Phi| = {abs(a1):.3e} "
      f"(vs {abs(a0):.3e} at tau = 10) -- zeta kills it; zeta*M = {abs(b1):.1e}")

# (D2) windowed prolate E-vectors: lambda^2 in {3, 5, 11}; f_m = psi_{2m, lambda}
#      (truncated even prolate, c = 2 pi lambda^2), corrected by psi_0, psi_2 to
#      f(0) = 0 = int f; g_m = E(f_m)|_{[lambda^{-1}, lambda]}.
#      The zero sum is restricted to gamma < GCUT with oscillation-resolving
#      Gauss nodes per segment (the first run used 64 nodes/segment against all
#      100k zeros: for gamma*T/2 >> nodes the oscillatory quadrature returns
#      O(1) noise per zero instead of the true |Phi| ~ jump/gamma, and the
#      noise summed to a spurious W ~ 1e3 -- caught by magnitude sanity).
#      The omitted gamma > GCUT tail is bounded analytically by the jump data:
#      |Phi_g(1/2+i t)| <= J_tot/t with J_tot = sum of |jump| of g, so
#      tail <= J_tot^2 * (2/2pi) int_GCUT (log(t/2pi)) t^-2 dt.
print("\n  (D2) Rayleigh quotients W(g_m)/||g_m||^2 of windowed prolate E-vectors")
print("       vs Slepian leakage 1 - lambda_{2m}(2 pi lambda^2):")
GCUT = 5000.0
NZC = int(np.searchsorted(GAMMA, GCUT))
TAILFAC = (np.log(GCUT / (2 * np.pi)) + 1.0) / GCUT / np.pi   # 2*(1/2pi)*int
RES_D = {}


def segment_nodes(pts, gmax):
    uq, wq = [], []
    for a, b in zip(pts[:-1], pts[1:]):
        nn = int(gmax * (b - a) / 2 * 1.2) + 48
        xg, wg = np.polynomial.legendre.leggauss(nn)
        uq.append(0.5 * (a + b) + 0.5 * (b - a) * xg)
        wq.append(0.5 * (b - a) * wg)
    return np.concatenate(uq), np.concatenate(wq)


def zero_side_W(vecs, uq, wq, chunk=4000):
    Phi = np.zeros((vecs.shape[0], NZC), dtype=complex)
    gw = vecs * wq
    for i0 in range(0, NZC, chunk):
        g = GAMMA[i0:i0 + chunk]
        Phi[:, i0:i0 + chunk] = gw @ np.exp(1j * np.outer(uq, g))
    return 2 * np.real(Phi @ Phi.conj().T), Phi


for lam2 in (3, 5, 11):
    lam = np.sqrt(lam2)
    Twin = np.log(lam2)
    c = 2 * np.pi * lam2
    Npro = 4 * lam2 + 12
    chi, C, slep, mus, _ = slepian_lams(c, Npro)
    C = trim(C)
    val0 = legendre_eval(C, np.array([0.0]))[:, 0]        # psi_n(0)
    val1 = legendre_eval(C, np.array([1.0]))[:, 0]        # psi_n(1) (edge)
    integ = lam * np.sqrt(2) * C[:, 0]                    # int_{-lam}^{lam} psi_n(x/lam) dx
    brk = [np.log(lam / n) for n in range(1, int(lam2 + 1e-9) + 1)]
    pts = sorted(set([-Twin / 2, Twin / 2] + [b for b in brk if -Twin / 2 < b < Twin / 2]))
    uq, wq = segment_nodes(pts, GCUT)
    vq = np.exp(uq)
    ev_idx = list(range(0, Npro, 2))
    graw = np.zeros((len(ev_idx), uq.size))
    for i, u in enumerate(uq):
        v = vq[i]
        n = np.arange(1, int(lam / v + 1e-12) + 1)
        Vv = legendre_eval(C[ev_idx], n * v / lam)        # (n_even, len(n))
        graw[:, i] = np.sqrt(v) * Vv.sum(axis=1)
    # constrained combos: f_m = psi_{2m} - a psi_0 - b psi_2
    A22 = np.array([[val0[0], val0[2]], [integ[0], integ[2]]])
    ms = [mm for mm in range(2, len(ev_idx))]
    vecs = np.zeros((len(ms), uq.size))
    leak, jtot = [], []
    for j, mm in enumerate(ms):
        k = 2 * mm
        ab = np.linalg.solve(A22, np.array([val0[k], integ[k]]))
        vecs[j] = graw[ev_idx.index(k)] - ab[0] * graw[0] - ab[1] * graw[1]
        leak.append(max(1.0 - slep[k], 1e-16))
        # jump budget: every jump of g (breakpoints + window ends) has size
        # sqrt(lam/n) |f(lam^-)|, f(lam^-) = psi_k(1) - a psi_0(1) - b psi_2(1)
        fedge = abs(val1[k] - ab[0] * val1[0] - ab[1] * val1[2])
        jtot.append(fedge * np.sum(np.sqrt(lam / np.arange(1, lam2 + 1)))
                    + abs(vecs[j][0]) + abs(vecs[j][-1]))
    Gm = (vecs * wq) @ vecs.T
    Wm, _ = zero_side_W(vecs, uq, wq)
    rho = np.diag(Wm) / np.diag(Gm)
    tail = np.array(jtot) ** 2 * TAILFAC / np.diag(Gm)
    RES_D[lam2] = dict(ms=ms, rho=rho, leak=np.array(leak), Gm=Gm, Wm=Wm, tail=tail)
    print(f"    lambda^2 = {lam2:2d} (T = {Twin:.3f}, c = 2 pi lambda^2 = {c:.1f}, "
          f"Shannon 4 lambda^2 = {4*lam2}, zeros < {GCUT:.0f}: {NZC}):")
    for j in range(len(ms)):
        if j % 2 == 0 or j > len(ms) - 4:
            print(f"      m = {ms[j]:2d}: W/||g||^2 = {rho[j]:9.3e} "
                  f"(+tail <= {tail[j]:7.1e})   1 - lambda_{{2m}} = "
                  f"{RES_D[lam2]['leak'][j]:9.3e}")
    dG, UG = np.linalg.eigh(Gm)
    keep = dG > 1e-12 * dG.max()
    Wh = UG[:, keep] / np.sqrt(dG[keep])
    evg = np.linalg.eigvalsh(Wh.T @ Wm @ Wh)
    nsmall = int((evg < 1e-8 * max(evg.max(), 1e-300)).sum())
    print(f"      generalized eigenvalues on the span (dim {int(keep.sum())}): "
          f"min = {evg[0]:.3e}, max = {evg[-1]:.3e}, #(< 1e-8 max) = {nsmall}")
    print(f"      [CC 2106.01715 quote at lambda^2 = 11: smallest eigenvalue "
          f"2.389e-48, nu(lambda^2) ~ 2 lambda^2; double precision resolves "
          f"only down to ~1e-16 relative on the assembled sum]")
    stamp(f"    lambda^2 = {lam2} done")
# control: Gaussian f (non-prolate) at lambda^2 = 5, same construction
lam2 = 5
lam = np.sqrt(lam2)
Twin = np.log(lam2)
pts = sorted(set([-Twin / 2, Twin / 2]
                 + [np.log(lam / n) for n in range(1, lam2 + 1)
                    if -Twin / 2 < np.log(lam / n) < Twin / 2]))
uq, wq = segment_nodes(pts, GCUT)
vq = np.exp(uq)
sig1, sig2 = lam / 3, lam / 5


def gauss_pair(vq, s1, s2):
    out = np.zeros_like(vq)
    for i, v in enumerate(vq):
        n = np.arange(1, int(lam / v + 1e-12) + 1)
        x = n * v
        f = (x ** 2 / s1 ** 3) * np.exp(-x ** 2 / (2 * s1 ** 2)) \
            - (x ** 2 / s2 ** 3) * np.exp(-x ** 2 / (2 * s2 ** 2))
        out[i] = np.sqrt(v) * f.sum()
    return out


gc = gauss_pair(vq, sig1, sig2)[None, :]
Gc = float((gc * wq) @ gc.T)
Wc = float(zero_side_W(gc, uq, wq)[0])
RHO_CTRL = Wc / Gc
print(f"    CONTROL (Gaussian-pair f in S_0^ev, same window lambda^2 = 5): "
      f"W/||g||^2 = {RHO_CTRL:.3e}  (vs prolate m=2: {RES_D[5]['rho'][0]:.3e})")

# ============================================================================
# FIGURE
# ============================================================================
C_POLE, C_PRIME, C_ARCH, C_W = "#0072B2", "#D55E00", "#009E73", "#111111"
C_SKY, C_ORG, C_PUR = "#56B4E9", "#E69F00", "#CC79A7"
fig, axes = plt.subplots(2, 4, figsize=(23, 10))
fig.suptitle("Exp 59: the prolate / Connes–Consani bridge — Slepian plunge, collocation "
             "conditioning past K≈20, Weil-form margins on prolate spans, and the "
             "zeta-cycle near-radical", fontsize=13)

ax = axes[0, 0]
for c, col in zip(PLUNGE, (C_SKY, C_POLE, C_W)):
    lam = PLUNGE[c]
    ax.semilogy(np.arange(lam.size), np.maximum(lam, 1e-18), "-", color=col, lw=2,
                label=f"c = {c:.4g}")
    ax.axvline(2 * c / np.pi, color=col, ls=":", lw=1)
ax.axhline(0.5, color="#888888", lw=0.8, ls="--")
ax.set_xlabel("prolate index n")
ax.set_ylabel(r"Slepian eigenvalue $\lambda_n(c)$")
ax.set_title("(a) the Slepian plunge; dotted = Shannon number $2c/\\pi$")
ax.legend(fontsize=8)
ax.set_ylim(1e-18, 3)

ax = axes[0, 1]
for c, col in zip(COND, (C_SKY, C_ARCH, C_ORG, C_POLE)):
    ax.semilogy(Ks, COND[c]['condz'], "o-", color=col, lw=1.5, ms=4,
                label=f"prolate c={c:.0f} (N={COND[c]['N']})")
kk = sorted(EXP25_CONDZ)
ax.semilogy(kk, [EXP25_CONDZ[k] for k in kk], "x--", color=C_W, lw=1.5, ms=8,
            label="exp25 Gaussian span (dim 60)")
ax.set_xlabel("K knots")
ax.set_ylabel(r"cond $\sigma_{\max}/\sigma_{\min}$")
ax.set_title(r"(b) zero-knot collocation $g\mapsto\Phi_g(\frac12+i\gamma_k)$")
ax.legend(fontsize=7)

ax = axes[0, 2]
for c, col in zip(COND, (C_SKY, C_ARCH, C_ORG, C_POLE)):
    ok = ~np.isnan(COND[c]['condp'])
    ax.semilogy(np.array(Ks)[ok], COND[c]['condp'][ok], "s-", color=col, lw=1.5, ms=4,
                label=f"prolate c={c:.0f}")
kk = sorted(EXP25_CONDP)
ax.semilogy(kk, [EXP25_CONDP[k] for k in kk], "x--", color=C_W, lw=1.5, ms=8,
            label="exp25 Gaussian span")
ax.set_xlabel("K knots")
ax.set_ylabel("cond")
ax.set_title(r"(c) prime-knot collocation $g\mapsto g(\log p^k)$, $\log p^k<4$")
ax.legend(fontsize=7)

ax = axes[0, 3]
Ts = [r['T'] for r in RES_B]
ax.semilogy(Ts, [max(r['lam_min'], 1e-40) for r in RES_B], "o-", color=C_W, lw=1.5,
            ms=4, label=r"$\lambda_{\min}(W)$ prolate span")
ax.semilogy(Ts, [max(r['lam_prim'], 1e-40) for r in RES_B], "s-", color=C_POLE, lw=1.5,
            ms=4, label=r"$\lambda_{\min}(W|_P)$ prolate span")
tt = sorted(EXP25_PRIM)
ax.semilogy(tt, [EXP25_PRIM[t] for t in tt], "x--", color=C_PRIME, lw=1.5, ms=8,
            label=r"exp25 compact $M=30$: $\lambda_{\min}(W|_P)$")
for ln in np.log([2, 3, 4, 5, 7, 8, 9, 11]):
    ax.axvline(ln, color="#cccccc", lw=0.6, zorder=0)
ax.set_xlabel("window width T (support of g = [-T/2, T/2])")
ax.set_ylabel(r"$\lambda$")
ax.set_title("(d) margin collapse vs window width (gray = log p^k)")
ax.legend(fontsize=7)

ax = axes[1, 0]
ax.plot(Ts, [r['counts'][1e-4] for r in RES_B], "o-", color=C_SKY, lw=1.5, ms=4,
        label=r"# $\lambda < 10^{-4}\lambda_{\max}$")
ax.plot(Ts, [r['counts'][1e-8] for r in RES_B], "s-", color=C_POLE, lw=1.5, ms=4,
        label=r"# $\lambda < 10^{-8}\lambda_{\max}$")
ax.plot(Ts, [r['counts'][1e-16] for r in RES_B], "d-", color=C_ARCH, lw=1.5, ms=4,
        label=r"# $\lambda < 10^{-16}\lambda_{\max}$")
tt = np.linspace(0.6, 3.0, 100)
ax.plot(tt, np.minimum(2 * np.exp(tt), NB), "--", color=C_PRIME, lw=1.5,
        label=r"CC $\nu \sim 2e^{T}$ (capped at N)")
ax.plot(Ts, [max(NB - 2 * r['nz'], 0) for r in RES_B], ":", color=C_W, lw=1.5,
        label=r"$N - 2N_\zeta(2c/T)$ band-rank model")
ax.set_xlabel("window width T")
ax.set_ylabel("count of near-null directions of W")
ax.set_title("(e) the near-radical grows with the window")
ax.legend(fontsize=7)

ax = axes[1, 1]
for T, col in ((0.68, C_SKY), (1.50, C_ARCH), (2.07, C_ORG), (3.00, C_POLE)):
    r = next(rr for rr in RES_B if abs(rr['T'] - T) < 1e-9)
    lam = np.sort(np.linalg.svd(r['mats']['B'], compute_uv=False) ** 2)[::-1]
    ax.semilogy(np.arange(NB), np.maximum(lam / lam[0], 1e-36), "-", color=col, lw=2,
                label=f"T = {T:.2f}")
ax.set_xlabel("index")
ax.set_ylabel(r"$\lambda_i(W)/\lambda_{\max}$")
ax.set_title("(f) W spectra on the prolate span: a second plunge")
ax.legend(fontsize=8)

ax = axes[1, 2]
r = next(rr for rr in RES_B if abs(rr['T'] - 2.60) < 1e-9)
Iful = r['mats']['prime'] - r['mats']['arch']
im = ax.imshow(np.log10(np.abs(0.5 * (Iful + Iful.T)) + 1e-12), cmap="Blues",
               vmin=-9, vmax=1)
plt.colorbar(im, ax=ax, shrink=0.8, label=r"$\log_{10}|I_{jk}|$")
ax.set_xlabel("prolate index k")
ax.set_ylabel("prolate index j")
ax.set_title("(g) I = prime − arch in prolate coordinates (T = 2.60)")

ax = axes[1, 3]
for lam2, col, mk in ((3, C_SKY, "o"), (5, C_ARCH, "s"), (11, C_POLE, "d")):
    d = RES_D[lam2]
    ax.loglog(d['leak'], np.maximum(d['rho'], 1e-30), mk, color=col, ms=5,
              label=rf"$\lambda^2 = {lam2}$")
xx = np.logspace(-16, 0, 10)
ax.loglog(xx, xx, "--", color="#888888", lw=1, label="y = x guide")
ax.loglog([1e-16], [Wc / Gc], "*", color=C_PRIME, ms=14, label="Gaussian control")
ax.set_xlabel(r"Slepian leakage $1-\lambda_{2m}(2\pi\lambda^2)$")
ax.set_ylabel(r"$W(g_m)/\|g_m\|^2$")
ax.set_title("(h) windowed prolate E-vectors: W tracks band leakage")
ax.legend(fontsize=7)

for axx in axes.flat:
    axx.tick_params(labelsize=8)
    axx.grid(alpha=0.25, lw=0.5)
fig.tight_layout(rect=[0, 0, 1, 0.96])
FIGDIR.mkdir(exist_ok=True)
fig.savefig(FIGDIR / "exp59_prolate.png", dpi=110)
stamp(f"figure saved to {FIGDIR / 'exp59_prolate.png'}")
print("done.")
