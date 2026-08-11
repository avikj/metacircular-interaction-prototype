"""Experiment 25: THE FINITE COHN-ELKIES LP ON THE WEIL FORM
(jewel 1 of notes/JEWELS.md made computational; companion notes/LP_CERT.md).

Setting (normalization of exp14 / notes/WEIL.md, verified there to 1.8e-10)
---------------------------------------------------------------------------
For test bumps g on the multiplicative line u = log x put gtilde(u) =
conj(g(-u)), F = g * gtilde, Phi_g(s) = int g(u) e^{(s-1/2)u} du.  The Weil
form W(g) = sum_rho Phi_g(rho) conj(Phi_g(1 - conj(rho))) satisfies (Prop W1)

  W(g) = pole(g,g) - prime(g,g) + arch(g,g),      RH <=> W(g) >= 0 for all g.

On a finite dictionary {g_j} the form is a Hermitian matrix

  M_jk = sum_rho Phi_j(rho) conj(Phi_k(1-conj(rho)))          [zero side]
       = pole_jk - prime_jk + arch_jk                         [assembly]
  pole_jk  = Phi_j(0) conj(Phi_k(1)) + Phi_j(1) conj(Phi_k(0))
  prime_jk = sum_n Lambda(n) n^{-1/2} [F_jk(log n) + F_jk(-log n)],
             F_jk(u) = int g_j(v) conj(g_k(v-u)) dv
  arch_jk  = (1/2pi) int Phi_j(1/2+i tau) conj(Phi_k(1/2+i tau)) D(tau) dtau,
             D(tau) = Re psi(1/4 + i tau/2) - log pi.

Under RH (our zeros are on the line) M is a Gram matrix of the evaluation
vectors (Phi_j(1/2 + i gamma))_j, hence PSD up to zero-data truncation (the
omitted tail is itself PSD, so the truncated zero side is a certified LOWER
bound for the exact form).  Both sides are computed independently and
cross-checked entrywise.  The generalized eigenproblem M c = lambda G c,
G_jk = <g_j, g_k>_{L^2}, gives lambda = W(g)/||g||_2^2: lambda_min is the
"hardest direction" of the finite LP (dictionary-redundancy-free).

Numerical robustness: the zero side is kept in FACTORED form B^H B (rows =
zero evaluations), so lambda_min = sigma_min(B R^{-1})^2 with G = R^H R;
sigma_min carries absolute error ~eps*sigma_max, hence lambda_min is
trustworthy down to ~1e-26 * lambda_max, far below the 1e-16 floor of the
assembled symmetric eigenproblem.  Both are reported; where they disagree the
assembled value has hit its floor (that floor is itself exp14's deep
prime-pole cancellation, reproduced here entrywise).

Parts
-----
(A) Gaussian dictionary (exp14 families: centers a, widths sigma, modulations
    beta, 64 atoms): lambda_min and its eigenvector over nested
    sub-dictionaries; where the hardest direction concentrates in u and in
    Fourier (vs the spectral gap (0, gamma_1)).
(B) Support-capped LP: compact C^1 basis on [-T/2, T/2] (so F = g*gtilde is
    supported in [-T, T]); lambda_min(T) as the cap grows through the
    prime-power thresholds log 2, log 3, log 4, ...; per-prime-power cost via
    leave-one-prime-out eigenvalue drops + Rayleigh budget weights.
(C) Interpolation-basis probe: conditioning of the first-K zero-evaluation
    functionals (and of the log p^k point-evaluation functionals) on the
    dictionary span -- the feasibility indicator for a Radchenko-Viazovska
    style certificate with knots {gamma} vs {log p^k}.

Figure: figures/exp25_lp.png.   Run: python3 code/exp25_lp.py  (~6 min)
"""
import sys
import time
from pathlib import Path

import numpy as np
from scipy.special import digamma

import matplotlib
matplotlib.use("Agg")
import matplotlib.pyplot as plt

sys.path.insert(0, str(Path(__file__).resolve().parent))
from pairfield import load_zeros, sieve_primes

FIGDIR = Path(__file__).resolve().parent.parent / "figures"
LOGPI = np.log(np.pi)
SQ2PI = np.sqrt(2 * np.pi)
EPS = np.finfo(float).eps

# ----------------------------------------------------------------------------
# arithmetic data (same as exp14)
# ----------------------------------------------------------------------------
X_LAMBDA = 10 ** 7


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


t0 = time.time()
print(f"sieving Lambda to {X_LAMBDA:.0e} ...", flush=True)
NVAL, LOGN, WLAM = lambda_support(X_LAMBDA)      # w_n = Lambda(n) n^{-1/2}
print(f"  {LOGN.size} prime powers  [{time.time()-t0:.1f}s]")
GAMMA = load_zeros()
G1 = GAMMA[0]
print(f"  {GAMMA.size} zeros, gamma_1 = {G1:.6f}, gamma_max = {GAMMA[-1]:.1f}")

# archimedean density
ARCH_H = 0.02


def arch_density(tau):
    return np.real(digamma(0.25 + 0.5j * tau)) - LOGPI


# ============================================================================
# shared linear algebra
# ============================================================================
def whiten(G, cut=1e-13):
    """G -> Wh with Wh^H G Wh = I on the retained subspace."""
    d, U = np.linalg.eigh(G)
    keep = d > cut * d.max()
    return U[:, keep] / np.sqrt(d[keep]), int(keep.sum())


def lam_from_factor(B, Wh):
    """Generalized eigen data from the factored zero side B^H B.

    Returns (lam_min, lam_max, y_min) with lam = sigma^2 of B @ Wh.
    sigma_min has absolute accuracy ~eps*sigma_max => lam_min trustworthy
    down to ~ (20 eps)^2 * lam_max.
    """
    A = B @ Wh
    if np.iscomplexobj(A):
        A = np.vstack([A.real, A.imag])
    s, vt = np.linalg.svd(A, full_matrices=False)[1:]
    return s[-1] ** 2, s[0] ** 2, vt[-1].conj()


# ============================================================================
# PART B machinery: compact C^1 cosine-difference basis on [0, L], u = v - L/2
#   h_m(v) = (1/2)[cos(q_{m-1} v) - cos(q_{m+1} v)],  q_r = r pi / L, m=1..M
#   (h_m and h_m' vanish at both endpoints; m=1 is the Hann window)
# ============================================================================
def Efun(z):
    """(e^z - 1)/z, stable near 0."""
    z = np.asarray(z, dtype=complex)
    out = np.empty_like(z)
    small = np.abs(z) < 1e-3
    zs = z[small]
    out[small] = 1 + zs / 2 + zs * zs / 6 + zs * zs * zs / 24
    zb = z[~small]
    out[~small] = (np.exp(zb) - 1.0) / zb
    return out


class CompactBasis:
    def __init__(self, L, M):
        self.L, self.M, self.c = L, M, L / 2
        self.q = np.arange(M + 2) * np.pi / L        # q_0 .. q_{M+1}

    def phi(self, s):
        """Phi_m(s) for an array of complex s: returns (M, len(s))."""
        s = np.atleast_1d(np.asarray(s, dtype=complex))
        w = s - 0.5
        L = self.L
        # Z[r, t] = E((w_t + i q_r) L),  Zm[r, t] = E((w_t - i q_r) L)
        Zp = Efun(np.outer(1j * self.q, np.full_like(w, L)) + w[None, :] * L)
        Zm = Efun(-np.outer(1j * self.q, np.full_like(w, L)) + w[None, :] * L)
        S = Zp + Zm                                   # (M+2, Ns)
        out = (L / 4) * (S[:-2] - S[2:])              # index m-1 vs m+1
        return np.exp(-w[None, :] * self.c) * out

    # ---- exact integrals of cosine products --------------------------------
    @staticmethod
    def _int_cos(Q, phi, t, L):
        """int_t^L cos(Q v + phi) dv  (Q may be exactly 0)."""
        if Q == 0.0:
            return (L - t) * np.cos(phi)
        return (np.sin(Q * L + phi) - np.sin(Q * t + phi)) / Q

    def F_pair(self, j, k, t):
        """F_jk(t) = int_t^L h_j(v) h_k(v - t) dv  (0 <= t <= L), exact."""
        L, q = self.L, self.q
        if t >= L:
            return 0.0
        tot = 0.0
        for sa, ja in ((+1, j - 1), (-1, j + 1)):
            for sb, kb in ((+1, k - 1), (-1, k + 1)):
                a, b = q[ja], q[kb]
                # int_t^L cos(a v) cos(b v - b t) dv
                val = 0.5 * (self._int_cos(a + b, -b * t, t, L)
                             + self._int_cos(a - b, +b * t, t, L))
                tot += 0.25 * sa * sb * val
        return tot

    def gram(self):
        G = np.empty((self.M, self.M))
        for j in range(1, self.M + 1):
            for k in range(j, self.M + 1):
                G[j - 1, k - 1] = G[k - 1, j - 1] = self.F_pair(j, k, 0.0)
        return G

    def eval_u(self, u):
        """h_m(u + c) on the physical line u in [-c, c]: (M, len(u))."""
        v = np.atleast_1d(u) + self.c
        inside = (v >= 0) & (v <= self.L)
        out = np.zeros((self.M, v.size))
        vv = v[inside]
        for m in range(1, self.M + 1):
            out[m - 1, inside] = 0.5 * (np.cos(self.q[m - 1] * vv)
                                        - np.cos(self.q[m + 1] * vv))
        return out


def weil_matrices_compact(L, M, gam=GAMMA, zero_chunk=20000):
    """All pieces of the Weil matrix for the compact basis on [-L/2, L/2].

    Returns dict with G, B (factored zero side, real 2K x M), Mzero, pole,
    prime, arch, prime_parts {n: P_n}, scale (entrywise |pole|+|prime|+|arch|).
    """
    bas = CompactBasis(L, M)
    G = bas.gram()

    # zero side, factored: rows sqrt(2)*Re Phi(1/2+i gamma), sqrt(2)*Im ...
    B = np.empty((2 * gam.size, M))
    for i0 in range(0, gam.size, zero_chunk):
        g = gam[i0:i0 + zero_chunk]
        P = bas.phi(0.5 + 1j * g)                      # (M, chunk)
        B[2 * i0: 2 * i0 + 2 * g.size: 2] = np.sqrt(2) * P.real.T
        B[2 * i0 + 1: 2 * i0 + 2 * g.size: 2] = np.sqrt(2) * P.imag.T
    Mzero = B.T @ B

    # pole
    p0 = bas.phi(np.array([0.0]))[:, 0].real
    p1 = bas.phi(np.array([1.0]))[:, 0].real
    pole = np.outer(p0, p1) + np.outer(p1, p0)

    # prime side: only prime powers with log n < L contribute
    sel = LOGN < L
    prime = np.zeros((M, M))
    prime_parts = {}
    for n, ln, w in zip(NVAL[sel], LOGN[sel], WLAM[sel]):
        P = np.empty((M, M))
        for j in range(1, M + 1):
            for k in range(1, M + 1):
                P[j - 1, k - 1] = bas.F_pair(j, k, ln)
        P = w * (P + P.T)              # F_jk(log n) + F_jk(-log n) = F_kj(ln)
        prime_parts[int(n)] = P
        prime += P

    # archimedean
    qmax = bas.q[-1]
    tau_max = 3.5 * qmax + 250.0
    tau = np.arange(0.0, tau_max, ARCH_H)
    D = arch_density(tau)
    P = bas.phi(0.5 + 1j * tau)                       # (M, Nt)
    # arch_jk = (1/2pi) int_R Phi_j conj(Phi_k) D = (1/pi) Re int_0^inf ...
    W = P * D[None, :]
    arch = np.trapezoid(np.einsum('jt,kt->jkt', W, P.conj()).real,
                        dx=ARCH_H, axis=2) / np.pi
    # tail estimate of the arch truncation (last decade extrapolated)
    tail = np.abs(np.trapezoid(
        (P[:, -500:] * D[None, -500:] * P[:, -500:].conj()).real,
        dx=ARCH_H, axis=1)).max() / np.pi * (tau_max / (500 * ARCH_H)) * 0.2

    scale = np.abs(pole) + np.abs(prime) + np.abs(arch) + 1e-300
    return dict(bas=bas, G=G, B=B, Mzero=Mzero, pole=pole, prime=prime,
                arch=arch, prime_parts=prime_parts, scale=scale,
                arch_tail=tail)


def analyze_compact(mats, drop=()):
    """lambda_min data for pole - prime + arch (optionally with some prime
    powers dropped) and for the factored zero side (full form only)."""
    G, B = mats["G"], mats["B"]
    Wh, r = whiten(G)
    Mr = mats["pole"] - mats["prime"] + mats["arch"]
    for n in drop:
        Mr = Mr + mats["prime_parts"][n]
    Mw = Wh.T @ Mr @ Wh
    ev = np.linalg.eigvalsh(Mw)
    out = dict(rank=r, lam_rhs=ev[0], lam_rhs_max=ev[-1])
    if not drop:
        lam0, lamx, y = lam_from_factor(B, Wh)
        c = Wh @ y
        num = dict(pole=c @ mats["pole"] @ c, prime=c @ mats["prime"] @ c,
                   arch=c @ mats["arch"] @ c)
        mu = lam0 / (abs(num["pole"]) + abs(num["prime"])
                     + abs(num["arch"]) + 1e-300)
        out.update(lam_zero=lam0, lam_max=lamx, y=y, c=c, mu=mu, terms=num)
        out["xcheck"] = np.max(np.abs(mats["Mzero"] - (mats["pole"]
                               - mats["prime"] + mats["arch"])) / mats["scale"])
    return out


# ============================================================================
# PART A machinery: Gaussian atoms  g(u) = e^{-(u-a)^2/(2 s^2)} e^{i b u},
# normalized to ||g||_2 = 1.  Pairwise closed forms as in exp14's Mixture.
# ============================================================================
class GaussDict:
    def __init__(self, atoms):
        self.a = np.array([x[0] for x in atoms])
        self.s = np.array([x[1] for x in atoms])
        self.b = np.array([x[2] for x in atoms])
        self.norm = (self.s * np.sqrt(np.pi)) ** -0.5   # ||g||_2 = 1
        self.n = len(atoms)

    def phi(self, sarg):
        """Phi_j(s): (n_atoms, len(sarg)) complex."""
        sarg = np.atleast_1d(np.asarray(sarg, dtype=complex))
        w = sarg[None, :] - 0.5 + 1j * self.b[:, None]
        with np.errstate(under="ignore"):
            return (self.norm * SQ2PI * self.s)[:, None] * np.exp(
                w * self.a[:, None] + 0.5 * (self.s[:, None] * w) ** 2)

    def F_jk(self, j, k, u):
        """(g_j * gtilde_k)(u) closed form (validated in exp14 vs quadrature)."""
        u = np.atleast_1d(np.asarray(u, dtype=float))
        aj, sj, bj = self.a[j], self.s[j], self.b[j]
        ak, sk, bk = self.a[k], self.s[k], self.b[k]
        A = 0.5 / sj ** 2 + 0.5 / sk ** 2
        B = aj / sj ** 2 + (u + ak) / sk ** 2 + 1j * (bj - bk)
        C = -aj ** 2 / (2 * sj ** 2) - (u + ak) ** 2 / (2 * sk ** 2) + 1j * bk * u
        with np.errstate(under="ignore"):
            return (self.norm[j] * self.norm[k] * np.sqrt(np.pi / A)
                    * np.exp(B ** 2 / (4 * A) + C))

    def matrices(self, gam):
        n = self.n
        G = np.empty((n, n), dtype=complex)
        prime = np.zeros((n, n), dtype=complex)
        for j in range(n):
            for k in range(n):
                G[j, k] = self.F_jk(j, k, np.array([0.0]))[0]
                # prime window: |log n - (a_j - a_k)| <= 40 * combined width
                mu = self.a[j] - self.a[k]
                wdt = np.sqrt(self.s[j] ** 2 + self.s[k] ** 2)
                lo, hi = np.searchsorted(LOGN, [mu - 40 * wdt, mu + 40 * wdt])
                if hi > lo:
                    ln = LOGN[lo:hi]
                    Fv = self.F_jk(j, k, ln) + np.conj(self.F_jk(k, j, ln))
                    prime[j, k] = np.sum(WLAM[lo:hi] * Fv)
        G = 0.5 * (G + G.conj().T)
        prime = 0.5 * (prime + prime.conj().T)

        p0 = self.phi(np.array([0.0]))[:, 0]
        p1 = self.phi(np.array([1.0]))[:, 0]
        pole = np.outer(p0, p1.conj()) + np.outer(p1, p0.conj())

        bmax, smin = np.abs(self.b).max(), self.s.min()
        tmax = bmax + 14.0 / smin + 12.0
        tau = np.arange(-tmax, tmax, ARCH_H)
        D = arch_density(tau)
        P = self.phi(0.5 + 1j * tau)
        arch = np.trapezoid(
            np.einsum('jt,kt->jkt', P * D[None, :], P.conj()),
            dx=ARCH_H, axis=2) / (2 * np.pi)
        arch = 0.5 * (arch + arch.conj().T)

        # zero side, factored over +/- gamma (windows sit near tau = -b <= 0,
        # so keep zeros up to bmax + 30/smin on both signs)
        gk = gam[gam < bmax + 30.0 / smin]
        Pp = self.phi(0.5 + 1j * gk)
        Pm = self.phi(0.5 - 1j * gk)
        B = np.vstack([Pp.T, Pm.T])                   # (2K, n) complex
        Mzero = B.conj().T @ B
        scale = np.abs(pole) + np.abs(prime) + np.abs(arch) + 1e-300
        return dict(G=G, B=B, Mzero=Mzero, pole=pole, prime=prime, arch=arch,
                    scale=scale)


# ============================================================================
# (0) SELF-CHECK against exp14's verified closed forms (single atom diag)
# ============================================================================
print("\n== (0) self-check vs exp14 closed forms " + "=" * 37)
sig, bet = 0.3, 14.134725
d1 = GaussDict([(0.0, sig, -bet)])   # e^{-i beta u}: window at tau = +beta
m1 = d1.matrices(GAMMA)
nrm2 = 1.0 / (sig * np.sqrt(np.pi))  # our atoms are L2-normalized
s2 = sig * sig
zero14 = 2 * np.pi * s2 * np.sum(np.exp(-s2 * (GAMMA - bet) ** 2)
                                 + np.exp(-s2 * (GAMMA + bet) ** 2)) * nrm2
pole14 = 4 * np.pi * s2 * np.exp(s2 * (0.25 - bet ** 2)) * np.cos(s2 * bet) * nrm2
prime14 = 2 * sig * np.sqrt(np.pi) * np.sum(
    WLAM * np.exp(-LOGN ** 2 / (4 * s2)) * np.cos(bet * LOGN)) * nrm2
checks = [("zero", m1["Mzero"][0, 0].real, zero14),
          ("pole", m1["pole"][0, 0].real, pole14),
          ("prime", m1["prime"][0, 0].real, prime14)]
for nm, ours, ref in checks:
    print(f"  {nm:6s} ours {ours:+.9e}  exp14 {ref:+.9e}  "
          f"rel {abs(ours-ref)/abs(ref):.1e}")
    assert abs(ours - ref) / abs(ref) < 1e-9, nm
# a-invariance of the diagonal (shift atom to a = 2)
d2 = GaussDict([(2.0, sig, -bet)])
m2 = d2.matrices(GAMMA)
sh = max(abs(m2[k][0, 0] - m1[k][0, 0]) / abs(m1[k][0, 0])
         for k in ("Mzero", "pole", "prime", "arch"))
print(f"  a-invariance (atom shifted to a=2), all 4 terms: {sh:.1e}")
# compact-basis explicit formula check at two supports
for Ltest in (1.0, 2.4):
    mt = weil_matrices_compact(Ltest, 14)
    xr = np.max(np.abs(mt["Mzero"] - (mt["pole"] - mt["prime"] + mt["arch"]))
                / mt["scale"])
    print(f"  compact basis L={Ltest}: entrywise explicit-formula deviation "
          f"{xr:.1e} (arch tail est {mt['arch_tail']:.0e})")

# ============================================================================
# (B) SUPPORT-CAPPED LP: lambda_min vs T_sup, per-prime-power cost
# ============================================================================
print("\n== (B) support-capped LP " + "=" * 52)
M_MODES = 30
PP_THRESH = [(2, np.log(2)), (3, np.log(3)), (4, np.log(4)), (5, np.log(5)),
             (7, np.log(7)), (8, np.log(8)), (9, np.log(9)), (11, np.log(11)),
             (13, np.log(13)), (16, np.log(16)), (17, np.log(17)),
             (19, np.log(19)), (23, np.log(23)), (25, np.log(25)),
             (27, np.log(27)), (29, np.log(29)), (31, np.log(31))]

# convergence in M at two supports
for Ltest in (1.0, 2.2):
    lams = []
    for Mtest in (22, 30, 38):
        mt = weil_matrices_compact(Ltest, Mtest)
        lams.append(analyze_compact(mt)["lam_zero"])
    print(f"  M-convergence at T={Ltest}: lam_min(M=22,30,38) = "
          + ", ".join(f"{x:.4e}" for x in lams)
          + f"  (rel spread {abs(lams[2]-lams[1])/lams[2]:.1e})")

T_grid = sorted(set(np.round(np.arange(0.30, 3.45, 0.04), 3))
                | {round(t + d, 3) for _, t in PP_THRESH for d in
                   (-0.01, 0.01, 0.12) if 0.3 < t + d < 3.45})
res_B = []
t1 = time.time()
for T in T_grid:
    mats = weil_matrices_compact(T, M_MODES)
    r = analyze_compact(mats)
    res_B.append((T, r, mats))
print(f"  scan: {len(T_grid)} support caps, M={M_MODES} modes "
      f"[{time.time()-t1:.0f}s]")
T_arr = np.array([x[0] for x in res_B])
lamz = np.array([x[1]["lam_zero"] for x in res_B])
lamr = np.array([x[1]["lam_rhs"] for x in res_B])
lamx = np.array([x[1]["lam_max"] for x in res_B])
muB = np.array([x[1]["mu"] for x in res_B])
xchk = np.max([x[1]["xcheck"] for x in res_B])
print(f"  worst entrywise explicit-formula deviation over scan: {xchk:.1e}")
i_cc = np.searchsorted(T_arr, np.log(2)) - 1
print(f"  prime-free window: at T={T_arr[i_cc]:.2f} (< log 2): lam_min = "
      f"{lamz[i_cc]:.4e}, lam_min/lam_max = {lamz[i_cc]/lamx[i_cc]:.2e}, "
      f"exp14-margin of minimizer mu = {muB[i_cc]:.3f}")
print("\n  T_sup     lam_min(zero,factored)  lam_min(rhs,assembled)  "
      "lam_min/lam_max   mu(minimizer)")
for i in range(0, len(res_B), 8):
    print(f"  {T_arr[i]:5.2f}    {lamz[i]:.6e}        {lamr[i]:+.6e}      "
          f"{lamz[i]/lamx[i]:.2e}       {muB[i]:.2e}")

# agreement between factored and assembled lambda_min (above the rhs floor)
ok = lamr > 1e-13 * lamx
agree = np.max(np.abs(lamz[ok] - lamr[ok]) / lamz[ok])
print(f"\n  factored vs assembled lam_min agree to {agree:.1e} "
      f"on the {ok.sum()} points above the assembly floor")

# ---- per-prime-power cost table --------------------------------------------
print("\n  per-prime-power cost (leave-one-out at T = log n + 0.12):")
print("  n      log n    Lambda(n)/sqrt n   lam_min(full)   lam_min(drop n)"
      "   ratio drop/full   Rayleigh weight of P_n at minimizer")
cost_rows = []
for n, ln in PP_THRESH:
    Tq = round(ln + 0.12, 3)
    if Tq > T_arr[-1]:
        continue
    i = int(np.argmin(np.abs(T_arr - Tq)))
    T, r, mats = res_B[i]
    lam_full = r["lam_zero"]
    rd = analyze_compact(mats, drop=(n,))
    lam_drop = rd["lam_rhs"]
    Wh, _ = whiten(mats["G"])
    c = r["c"]
    ray = abs(c @ mats["prime_parts"][n] @ c) / lam_full
    wn = np.log(n) / np.sqrt(n) if n in (2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31)\
        else WLAM[np.searchsorted(NVAL, n)] * 1.0
    resolved = lam_drop > 1e-13 * rd["lam_rhs_max"] and lam_full > 1e-26 * r["lam_max"]
    ratio = lam_drop / lam_full if resolved else np.nan
    cost_rows.append((n, ln, wn, lam_full, lam_drop, ratio, ray, resolved))
    print(f"  {n:<5d}  {ln:.4f}   {wn:.4f}            {lam_full:.3e}      "
          f"{lam_drop:+.3e}       {ratio:8.3f}         {ray:.3f}")

# ============================================================================
# (A) GAUSSIAN DICTIONARY: hardest direction
# ============================================================================
print("\n== (A) Gaussian-dictionary LP (exp14 families) " + "=" * 30)
CENTERS = [-1.5, -0.75, 0.0, 0.75, 1.5]
BETAS = [0.0, 7.067, 14.134725, 21.02204]     # 0, mid-gap, gamma_1, gamma_2
SIGS = [0.1, 0.25, 0.5]
atoms_narrow = [(a, s, b) for s in SIGS for a in CENTERS for b in BETAS]
atoms_wide = [(0.0, s, 0.0) for s in (0.75, 1.0, 1.25, 1.5)]

nested = [("sigma<=0.1 (20 atoms)", [x for x in atoms_narrow if x[1] <= 0.1]),
          ("sigma<=0.25 (40 atoms)", [x for x in atoms_narrow if x[1] <= 0.25]),
          ("sigma<=0.5 (60 atoms)", atoms_narrow),
          ("+ exp14 wide atoms (64)", atoms_narrow + atoms_wide)]
res_A = []
for lab, atoms in nested:
    dd = GaussDict(atoms)
    mm = dd.matrices(GAMMA)
    Wh, r = whiten(mm["G"])
    lam0, lamM, y = lam_from_factor(mm["B"], Wh)
    Mr = mm["pole"] - mm["prime"] + mm["arch"]
    ev = np.linalg.eigvalsh(Wh.conj().T @ Mr @ Wh)
    xc = np.max(np.abs(mm["Mzero"] - Mr) / mm["scale"])
    c = Wh @ y
    trust = lam0 > (50 * EPS) ** 2 * lamM
    res_A.append((lab, dd, mm, Wh, lam0, lamM, ev, c, trust))
    print(f"  {lab:26s} rank {r:2d}/{dd.n:2d}  lam_min(zero) {lam0:.3e}"
          f"{' ' if trust else ' [<~floor 1e-26*lam_max: upper bound only]'}"
          f"  lam_min(rhs) {ev[0]:+.3e}  lam_max {lamM:.3e}  xcheck {xc:.1e}")

# hardest direction: last dictionary whose lam_min is trusted
lab_h, dd_h, mm_h, Wh_h, lam_h, lamM_h, ev_h, c_h, _ = \
    [ra for ra in res_A if ra[8]][-1]
print(f"\n  hardest direction taken from: {lab_h}  "
      f"(lam_min/lam_max = {lam_h/lamM_h:.2e})")
u_grid = np.linspace(-4.0, 4.0, 1601)
gu = np.zeros(u_grid.size, dtype=complex)
for cj, (aj, sj, bj) in zip(c_h, zip(dd_h.a, dd_h.s, dd_h.b)):
    gu += cj * dd_h.norm[np.argmax((dd_h.a == aj) & (dd_h.s == sj)
                                   & (dd_h.b == bj))] \
        * np.exp(-(u_grid - aj) ** 2 / (2 * sj ** 2) + 1j * bj * u_grid)
tau_g = np.arange(-45.0, 45.0, 0.01)
phig = (c_h[None, :] @ dd_h.phi(0.5 + 1j * tau_g)).ravel()
pw = np.abs(phig) ** 2
frac_gap = np.trapezoid(pw[np.abs(tau_g) < G1], dx=0.01) / (2 * np.pi)
# Parseval: int |Phi|^2 d tau = 2 pi ||g||^2 = 2 pi (whitened: c^H G c = 1)
print(f"  Fourier concentration of hardest direction: "
      f"{100*frac_gap:.1f}% of ||g||^2 inside the spectral gap |tau| < "
      f"gamma_1 = {G1:.2f}")
# effective width (std of |g|^2 in u)
w0 = np.trapezoid(np.abs(gu) ** 2, u_grid)
ubar = np.trapezoid(u_grid * np.abs(gu) ** 2, u_grid) / w0
ueff = np.sqrt(np.trapezoid((u_grid - ubar) ** 2 * np.abs(gu) ** 2, u_grid) / w0)
print(f"  effective |g|^2 std in u: {ueff:.2f} "
      f"(largest single-atom sigma in this dictionary: {dd_h.s.max():.2f})"
      f"  -> optimizer synthesizes a wider window from narrow atoms"
      if ueff > dd_h.s.max() else "")

# single wide atoms, exact log-space Rayleigh quotients (exp14 regime)
print("\n  single-atom Rayleigh quotients (log-space, exp14 wide-window "
      "regime; the LP floor continues this curve):")
sig_line = np.array([0.1, 0.25, 0.5, 0.75, 1.0, 1.25, 1.5])
lam_line = []
for s in sig_line:
    s2 = s * s
    # W/||g||^2 = 2 pi s^2 sum_gamma 2 e^{-s^2 gamma^2} / (s sqrt(pi)); logsumexp
    ex = -s2 * GAMMA ** 2
    mx = ex.max()
    log_lam = (np.log(4 * np.pi * s2) + mx + np.log(np.sum(np.exp(ex - mx)))
               - np.log(s * np.sqrt(np.pi)))
    lam_line.append(log_lam / np.log(10))
    print(f"    sigma={s:4.2f}: log10 lambda = {lam_line[-1]:8.2f}")
lam_line = np.array(lam_line)

# ============================================================================
# (C) INTERPOLATION-BASIS PROBE: conditioning of evaluation functionals
# ============================================================================
print("\n== (C) interpolation conditioning on the dictionary span " + "=" * 19)
lab_c, dd_c, mm_c, Wh_c = res_A[2][0], res_A[2][1], res_A[2][2], res_A[2][3]
r_c = Wh_c.shape[1]
print(f"  span: {lab_c}, whitened dimension r = {r_c}")
# zero knots: functionals g -> Phi_g(1/2 + i gamma_k)
Kmaxz = min(60, r_c)
Ez = (dd_c.phi(0.5 + 1j * GAMMA[:Kmaxz]).T @ Wh_c)        # (K, r)
Ez_n = Ez / np.linalg.norm(Ez, axis=1, keepdims=True)
# prime knots: functionals g -> g(log p^k)
pk_mask = LOGN < 4.0
u_pk = LOGN[pk_mask]
n_pk = NVAL[pk_mask]
vals = np.zeros((u_pk.size, dd_c.n), dtype=complex)
for j in range(dd_c.n):
    vals[:, j] = dd_c.norm[j] * np.exp(
        -(u_pk - dd_c.a[j]) ** 2 / (2 * dd_c.s[j] ** 2) + 1j * dd_c.b[j] * u_pk)
Ep = vals @ Wh_c
Ep_n = Ep / np.linalg.norm(Ep, axis=1, keepdims=True)
print("  K    cond(zeros, row-normalized)   cond(log p^k, row-normalized)")
Ks = [2, 5, 10, 15, 20, 24, 30, 40, 50, Kmaxz]
condz, condp = [], []
for K in Ks:
    sz = np.linalg.svd(Ez_n[:K], compute_uv=False)
    cz = sz[0] / sz[-1] if sz[-1] > 0 else np.inf
    condz.append(cz)
    if K <= u_pk.size:
        sp = np.linalg.svd(Ep_n[:K], compute_uv=False)
        cp = sp[0] / sp[-1] if sp[-1] > 0 else np.inf
        condp.append(cp)
        print(f"  {K:3d}       {cz:12.4g}                  {cp:12.4g}")
    else:
        condp.append(np.nan)
        print(f"  {K:3d}       {cz:12.4g}                  (only "
              f"{u_pk.size} knots < e^4)")
# joint RV-type system: K1 zero + K2 prime functionals
K1, K2 = 30, u_pk.size
EJ = np.vstack([Ez_n[:K1], Ep_n[:K2]])
sj = np.linalg.svd(EJ, compute_uv=False)
print(f"  joint system ({K1} zero + {K2} prime-power functionals, "
      f"{K1+K2} rows, dim {r_c}): cond = {sj[0]/sj[-1]:.4g}, "
      f"sigma_min = {sj[-1]:.3e}")

# ============================================================================
# FIGURE
# ============================================================================
C_POLE, C_PRIME, C_ARCH, C_W = "#0072B2", "#D55E00", "#009E73", "#111111"
fig, axes = plt.subplots(2, 3, figsize=(17.5, 9.6))
fig.suptitle("Exp 25: the finite Cohn–Elkies LP on the Weil form — "
             "BCK landscape, per-prime-power cost, interpolation conditioning",
             fontsize=13)

# (a) lambda_min vs support cap
ax = axes[0, 0]
ax.semilogy(T_arr, lamz, color=C_W, lw=1.8, label=r"$\lambda_{\min}$ (zero side, factored)")
mask = lamr > 0
ax.semilogy(T_arr[mask], lamr[mask], ".", color=C_POLE, ms=4,
            label=r"$\lambda_{\min}$ (pole$-$prime$+$arch)")
floor = (50 * EPS) ** 2 * np.median(lamx)
ax.axhline(floor, color="#888888", lw=0.9, ls=":")
ax.text(0.35, floor * 2, "factored-SVD trust floor", fontsize=7.5, color="#666666")
ax.axvspan(0.30, np.log(2), color=C_ARCH, alpha=0.12, lw=0)
ax.text(0.33, 3e-1, "prime-free\n(CC window)", fontsize=8, color=C_ARCH)
for n, ln in PP_THRESH:
    if ln < T_arr[-1]:
        ax.axvline(ln, color=C_PRIME, lw=0.7, alpha=0.5)
        ax.text(ln, 2.2, str(n), fontsize=7, ha="center", color=C_PRIME)
ax.set_xlabel(r"support cap $T_{\rm sup}$  ($F=g\star\tilde g$ supported in "
              r"$[-T_{\rm sup},T_{\rm sup}]$)", fontsize=9)
ax.set_ylabel(r"$\lambda_{\min}\; \big(W(g)/\|g\|_2^2\big)$", fontsize=9)
ax.set_title("(a) minimal eigenvalue vs support cap; prime powers marked",
             fontsize=10)
ax.legend(fontsize=8, loc="lower left")
ax.grid(alpha=0.25, lw=0.6)

# (b) per-prime-power cost
ax = axes[0, 1]
ns = [str(r[0]) for r in cost_rows]
ratios = np.array([r[5] for r in cost_rows])
rays = np.array([r[6] for r in cost_rows])
wns = np.array([r[2] for r in cost_rows])
xp = np.arange(len(ns))
okr = ~np.isnan(ratios)
ax.bar(xp[okr] - 0.2, ratios[okr], width=0.38, color=C_PRIME, alpha=0.85,
       label=r"$\lambda_{\rm drop\,n}/\lambda_{\rm full}$ at $T=\log n+0.12$")
ax.bar(xp + 0.2, rays, width=0.38, color=C_POLE, alpha=0.85,
       label=r"Rayleigh weight $|c^*P_nc|/\lambda_{\min}$")
ax2 = ax.twinx()
ax2.plot(xp, wns, "k^--", ms=5, lw=1.0, label=r"$\Lambda(n)/\sqrt{n}$")
ax2.set_ylabel(r"$\Lambda(n)/\sqrt n$", fontsize=9)
ax.set_xticks(xp, ns)
ax.set_xlabel(r"prime power $n$ entering at $T_{\rm sup}=\log n$", fontsize=9)
ax.set_title("(b) per-prime-power cost at entry", fontsize=10)
h1, l1 = ax.get_legend_handles_labels()
h2, l2 = ax2.get_legend_handles_labels()
ax.legend(h1 + h2, l1 + l2, fontsize=7.5, loc="upper right")
ax.grid(alpha=0.25, lw=0.6)

# (c) hardest direction in u
ax = axes[0, 2]
ax.plot(u_grid, gu.real, color=C_W, lw=1.5, label=r"Re $g(u)$")
ax.plot(u_grid, np.abs(gu), color=C_PRIME, lw=1.2, ls="--", label=r"$|g(u)|$")
ax.set_xlabel(r"$u=\log x$", fontsize=9)
ax.set_title(f"(c) hardest direction ({lab_h.strip()}),\n"
             r"$\lambda_{\min}/\lambda_{\max}=$"
             f"{lam_h/lamM_h:.1e}; eff. width {ueff:.2f}", fontsize=9.5)
ax.legend(fontsize=8)
ax.grid(alpha=0.25, lw=0.6)

# (d) hardest direction in Fourier
ax = axes[1, 0]
ax.semilogy(tau_g, np.maximum(pw, 1e-24), color=C_W, lw=1.4)
for gmm in GAMMA[GAMMA < 45]:
    ax.axvline(gmm, color=C_POLE, lw=0.7, alpha=0.45)
    ax.axvline(-gmm, color=C_POLE, lw=0.7, alpha=0.45)
ax.axvspan(-G1, G1, color=C_PRIME, alpha=0.10, lw=0)
ax.text(0, np.max(pw) * 0.1, f"spectral gap\n{100*frac_gap:.0f}% of mass",
        ha="center", fontsize=8.5, color=C_PRIME)
ax.set_xlabel(r"$\tau$", fontsize=9)
ax.set_ylabel(r"$|\Phi_g(\tfrac12+i\tau)|^2$", fontsize=9)
ax.set_title("(d) hardest direction concentrates in the gap "
             r"$(-\gamma_1,\gamma_1)$; zeros = blue lines", fontsize=10)
ax.grid(alpha=0.25, lw=0.6)

# (e) interpolation conditioning
ax = axes[1, 1]
ax.semilogy(Ks, condz, "o-", color=C_POLE, lw=1.5, ms=5,
            label=r"zero knots $\{\gamma_k\}$ (row-normalized)")
okp = ~np.isnan(condp)
ax.semilogy(np.array(Ks)[okp], np.array(condp)[okp], "s-", color=C_PRIME,
            lw=1.5, ms=5, label=r"prime knots $\{\log p^k\}$")
ax.set_xlabel("number of evaluation functionals $K$", fontsize=9)
ax.set_ylabel(r"cond $\sigma_{\max}/\sigma_{\min}$", fontsize=9)
ax.set_title(f"(e) conditioning of evaluation functionals on span "
             f"(dim {r_c})", fontsize=10)
ax.legend(fontsize=8)
ax.grid(alpha=0.25, lw=0.6)

# (f) nested-dictionary lambda_min + single-atom continuation
ax = axes[1, 2]
sig_nested = [0.1, 0.25, 0.5, 1.5]
lam_nested = [ra[4] for ra in res_A]
trust_nested = [ra[8] for ra in res_A]
lg = [np.log10(max(x, 1e-300)) for x in lam_nested]
ax.plot(sig_line, lam_line, "^--", color=C_ARCH, ms=6, lw=1.2,
        label=r"single atom $(\sigma,\beta{=}0)$: $\log_{10} W/\|g\|^2$ (exact, log-space)")
for sn, lgv, tr in zip(sig_nested, lg, trust_nested):
    ax.plot([sn], [lgv], "o" if tr else "v", color=C_W, ms=8)
ax.plot([], [], "o", color=C_W, label="nested dictionary LP (resolved)")
ax.plot([], [], "v", color=C_W, label="LP at numerical floor (upper bound)")
ax.set_xlabel(r"max atom width $\sigma$ in dictionary", fontsize=9)
ax.set_ylabel(r"$\log_{10}\lambda_{\min}$", fontsize=9)
ax.set_title("(f) LP rediscovers exp14's wide-window collapse\n"
             r"$\lambda_{\min}\approx 4\sqrt{\pi}\sigma\,e^{-\sigma^2\gamma_1^2}$",
             fontsize=10)
ax.legend(fontsize=7.5, loc="lower left")
ax.grid(alpha=0.25, lw=0.6)

fig.tight_layout(rect=[0, 0, 1, 0.955])
out = FIGDIR / "exp25_lp.png"
fig.savefig(out, dpi=150)
print(f"\nfigure -> {out}")
print(f"total time {time.time()-t0:.0f}s")
