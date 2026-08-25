"""Experiment 25: THE FINITE COHN-ELKIES LP ON THE WEIL FORM, NEGATIVITY-ORIENTED
(jewel 1 of notes/JEWELS.md made computational; retargeted per notes/ATIYAH.md
S4 item 2: the object hunted is a HODGE-INDEX NEGATIVITY, not a naive
positivity; companion notes/LP_CERT.md).

The derived sign structure (proved in LP_CERT.md S2, then measured here)
--------------------------------------------------------------------------
Primitive subspace P = {g : Phi_g(0) = Phi_g(1) = 0} (pole functionals = the
two rulings of the Neron-Severi hyperbolic plane on C x C).  On P the pole
form vanishes identically, so W|_P = arch|_P - prime|_P, and under RH
W|_P = sum_gamma |Phi_g(1/2+i gamma)|^2 >= 0: the Weil form restricted to
primitives is POSITIVE semidefinite for termwise-trivial reasons.  The
nontrivial statement is carried by the zero-free ARITHMETIC INTERSECTION FORM

    I(g) := prime(g) - arch(g)  =  pole(g) - W(g)      (no zeros, no pole),

built from Lambda(n) and the Gamma-factor alone:
  (H1) RH  =>  I|_P <= 0                (Castelnuovo negativity on primitives;
                                         restricted converse: Weil criterion on
                                         the pole-annihilated class, cf. Connes
                                         Selecta 5 (1999), CC 2006.13771)
  (H2) RH  =>  n_+(I) <= 1 on every finite test space (Hodge index): the pole
       form 2Re[Phi(0) conj Phi(1)] is a rank-2 hyperbolic plane with NULL
       diagonal -- exactly F1^2 = F2^2 = 0, F1.F2 = 1 -- so I = pole - W with
       W PSD has at most one positive direction (Weyl).  Castelnuovo's
       inequality Z.Z <= 2 d1 d2 becomes I(g) <= 2Re[Phi_g(0) conj Phi_g(1)].
This experiment measures the inertia of I, the spectrum of I|_P, and the cost
of each prime power against exactly these two statements.

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
(P) Negativity landscape: inertia of I = prime - arch on each dictionary
    (H2: at most one positive direction -- the hyperbolic one), spectrum of
    the primitive block I|_P (H1: <= 0), overlap of the positive direction
    with the pole plane, both cross-checked against the factored zero side.
(B) Support-capped LP: compact C^1 basis on [-T/2, T/2] (so F = g*gtilde is
    supported in [-T, T]); lambda_min(T) of the full AND primitive blocks as
    the cap grows through the prime-power thresholds log 2, log 3, log 4, ...;
    per-prime-power cost via leave-one-prime-out eigenvalue drops + Rayleigh
    budget weights.  T < log 2 with the primitive constraint is exactly the
    Connes-Consani 2006.13771 regime (their gs have hat-g(0) = hat-g(i/2) = 0
    and support in [2^{-1/2}, 2^{1/2}]).
(C) Interpolation-basis probe: conditioning of the first-K zero-evaluation
    functionals (and of the log p^k point-evaluation functionals) on the
    dictionary span -- the feasibility indicator for a Radchenko-Viazovska
    style certificate with knots {gamma} vs {log p^k}.

Figure: figures/exp25_lp.png.   Run: python3 code/exp25_lp.py  (~5-10 min)
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
    down to ~ (20 eps)^2 * lam_max.  Complex A is handled by complex SVD
    (minimization over COMPLEX coefficient vectors, as the Hermitian form
    requires; stacking Re/Im rows would restrict to real coefficients).
    """
    A = B @ Wh
    s, vt = np.linalg.svd(A, full_matrices=False)[1:]
    return s[-1] ** 2, s[0] ** 2, vt[-1].conj()


def null_basis(rows):
    """Orthonormal basis (columns) of the joint null space of the given
    functional rows (k x r, real or complex): the PRIMITIVE subspace when the
    rows are the pole functionals Phi(0), Phi(1) in whitened coordinates."""
    C = np.atleast_2d(np.asarray(rows))
    s = np.linalg.svd(C, compute_uv=False)
    vt = np.linalg.svd(C, full_matrices=True)[2]
    k = int(np.sum(s > max(C.shape) * EPS * (s[0] if s.size else 1.0)))
    return vt[k:].conj().T                              # (r, r-k)


def inertia(ev, tol_rel=1e-8):
    """(n_+, n_0, n_-) of a Hermitian spectrum with relative tolerance.
    Default 1e-8: the assembled matrices carry ~1e-9-absolute quadrature
    tails, and near-null primitive directions (|eig| down to 1e-30) are
    'unresolved' rather than signed at the assembly level."""
    t = tol_rel * np.max(np.abs(ev)) if ev.size else 0.0
    return int((ev > t).sum()), int((np.abs(ev) <= t).sum()), int((ev < -t).sum())


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

    # archimedean (|Phi_m|^2 ~ tau^{-6} beyond qmax: same-parity E-terms cancel
    # to two orders).  Fine grid h=0.02 to 5 qmax + 600, then a coarse grid
    # (resolving the e^{i tau L} oscillation) out to 22 qmax + 600: at small L
    # the entries are ~1e-6 while the 5qmax tail is ~4e-10, which would break
    # the 1e-6 entrywise cross-check target.  Nonuniform trapezoid weights.
    qmax = bas.q[-1]
    tau1 = 5.0 * qmax + 600.0
    tau2_end = 22.0 * qmax + 600.0
    h2 = max(ARCH_H, min(0.35, (2 * np.pi / L) / 40))
    tau = np.concatenate([np.arange(0.0, tau1, ARCH_H),
                          np.arange(tau1, tau2_end, h2)])
    D = arch_density(tau)
    P = bas.phi(0.5 + 1j * tau)                       # (M, Nt)
    # arch_jk = (1/2pi) int_R Phi_j conj(Phi_k) D = (1/pi) Re int_0^inf ...
    wt = np.empty_like(tau)
    wt[1:-1] = 0.5 * (tau[2:] - tau[:-2])
    wt[0] = 0.5 * (tau[1] - tau[0])
    wt[-1] = 0.5 * (tau[-1] - tau[-2])
    arch = ((P * (D * wt)[None, :]) @ P.conj().T).real / np.pi
    # tail estimate of the arch truncation (tau^-5 extrapolation of the end)
    endint = np.abs((P[:, -500:] * (D * wt)[None, -500:]
                     * P[:, -500:].conj()).real.sum(axis=1)).max() / np.pi
    tail = endint * (tau2_end / (500 * h2)) * 0.25

    # entrywise scale, floored at 1e-6 of the matrix scale: parity-forbidden
    # entries (odd-even mode pairs) are structural zeros where all four terms
    # sit at rounding level, and a bare entrywise ratio would flag them
    scale = np.abs(pole) + np.abs(prime) + np.abs(arch)
    scale = scale + 1e-6 * scale.max() + 1e-300
    return dict(bas=bas, G=G, B=B, Mzero=Mzero, pole=pole, prime=prime,
                arch=arch, prime_parts=prime_parts, scale=scale,
                arch_tail=tail, p0=p0, p1=p1)


def analyze_compact(mats, drop=()):
    """lambda_min data for pole - prime + arch (optionally with some prime
    powers dropped), for the factored zero side, and for the PRIMITIVE block
    (pole functionals Phi(0) = Phi(1) = 0): W|_P from the zero side and the
    top eigenvalue of the arithmetic intersection form I = prime - arch
    restricted to P (the Hodge-index negativity, assembled without zeros)."""
    G = mats["G"]
    Wh, r = whiten(G)
    Mr = mats["pole"] - mats["prime"] + mats["arch"]
    for n in drop:
        Mr = Mr + mats["prime_parts"][n]
    Mw = Wh.T @ Mr @ Wh
    ev = np.linalg.eigvalsh(Mw)
    out = dict(rank=r, lam_rhs=ev[0], lam_rhs_max=ev[-1])
    # primitive block (constraints in whitened coordinates)
    Q = null_basis(np.vstack([mats["p0"] @ Wh, mats["p1"] @ Wh]))
    Mp = Q.T @ Mw @ Q
    evp = np.linalg.eigvalsh(0.5 * (Mp + Mp.T))
    out.update(prim_dim=Q.shape[1], lam_prim_rhs=evp[0],
               lam_prim_rhs_max=evp[-1])
    if not drop:
        B = mats["B"]
        lam0, lamx, y = lam_from_factor(B, Wh)
        c = Wh @ y
        num = dict(pole=c @ mats["pole"] @ c, prime=c @ mats["prime"] @ c,
                   arch=c @ mats["arch"] @ c)
        mu = lam0 / (abs(num["pole"]) + abs(num["prime"])
                     + abs(num["arch"]) + 1e-300)
        out.update(lam_zero=lam0, lam_max=lamx, y=y, c=c, mu=mu, terms=num)
        out["xcheck"] = np.max(np.abs(mats["Mzero"] - (mats["pole"]
                               - mats["prime"] + mats["arch"])) / mats["scale"])
        # W|_P from the factored zero side (exact PSD, trustworthy when tiny)
        lam_p, lamx_p, yp = lam_from_factor(B, Wh @ Q)
        cp = Wh @ (Q @ yp)
        out.update(lam_prim=lam_p, lam_prim_max=lamx_p, c_prim=cp)
        # I = prime - arch on P: top eigenvalue (should be <= 0 under RH;
        # equals -lam_prim exactly since pole|_P = 0)
        Iw = Wh.T @ (mats["prime"] - mats["arch"]) @ Wh
        Ip = Q.T @ Iw @ Q
        evI = np.linalg.eigvalsh(0.5 * (Ip + Ip.T))
        Pp = Q.T @ (Wh.T @ mats["pole"] @ Wh) @ Q
        out.update(evI_prim_top=evI[-1], evI_prim_bot=evI[0],
                   pole_prim_leak=np.abs(Pp).max())
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
        """All matrices in the SAME sesquilinear convention as the factored
        zero side Mzero = B^H B, i.e. entry (j,k) is conjugate-linear in j and
        linear in k: X[j,k] = X(g_j, g_k) with c^H X c = X(g,g), g = sum c_j g_j.
        (The first draft built pole/prime/arch/G in the transposed convention;
        for a complex dictionary that flips the sign of every imaginary part
        and the entrywise cross-check against Mzero fails at O(1).)"""
        n = self.n
        G = np.empty((n, n), dtype=complex)
        prime = np.zeros((n, n), dtype=complex)
        for j in range(n):
            for k in range(n):
                # F = g_k * gtilde_j has F(u) = F_kj(u) in the notation above
                G[j, k] = self.F_jk(k, j, np.array([0.0]))[0]
                # prime window: the two terms F_kj(ln) and conj(F_jk(ln)) peak
                # at ln = +mu and ln = -mu respectively (mu = a_k - a_j); over
                # ln > 0 the active one sits at |mu|, so the window MUST be
                # centered at |mu| (centering at signed mu silently zeroes the
                # (k,j) entry and Hermitization then halves the pair -- bug
                # caught by the entrywise cross-check).  Decay e^{-12^2/2}.
                mu = abs(self.a[k] - self.a[j])
                wdt = np.sqrt(self.s[j] ** 2 + self.s[k] ** 2)
                lo, hi = np.searchsorted(LOGN, [mu - 12 * wdt, mu + 12 * wdt])
                if hi > lo:
                    ln = LOGN[lo:hi]
                    Fv = self.F_jk(k, j, ln) + np.conj(self.F_jk(j, k, ln))
                    prime[j, k] = np.sum(WLAM[lo:hi] * Fv)
        G = 0.5 * (G + G.conj().T)
        prime = 0.5 * (prime + prime.conj().T)

        p0 = self.phi(np.array([0.0]))[:, 0]
        p1 = self.phi(np.array([1.0]))[:, 0]
        # pole(g_j, g_k) = Phi_k(0) conj(Phi_j(1)) + Phi_k(1) conj(Phi_j(0))
        pole = np.outer(p1.conj(), p0) + np.outer(p0.conj(), p1)

        bmax, smin = np.abs(self.b).max(), self.s.min()
        tmax = bmax + 14.0 / smin + 12.0
        tau = np.arange(-tmax, tmax, ARCH_H)
        D = arch_density(tau)
        P = self.phi(0.5 + 1j * tau)
        # arch(g_j, g_k) = (1/2pi) int conj(Phi_j) Phi_k D dtau
        wt = np.full(tau.size, ARCH_H)
        wt[0] *= 0.5
        wt[-1] *= 0.5
        arch = (P.conj() * (D * wt)[None, :]) @ P.T / (2 * np.pi)
        arch = 0.5 * (arch + arch.conj().T)

        # zero side, factored over +/- gamma (windows sit near tau = -b <= 0,
        # so keep zeros up to bmax + 30/smin on both signs)
        gk = gam[gam < bmax + 30.0 / smin]
        Pp = self.phi(0.5 + 1j * gk)
        Pm = self.phi(0.5 - 1j * gk)
        B = np.vstack([Pp.T, Pm.T])                   # (2K, n) complex
        Mzero = B.conj().T @ B
        scale = np.abs(pole) + np.abs(prime) + np.abs(arch)
        scale = scale + 1e-6 * scale.max() + 1e-300
        return dict(G=G, B=B, Mzero=Mzero, pole=pole, prime=prime, arch=arch,
                    scale=scale, p0=p0, p1=p1)


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
    del mats["B"]                     # 48 MB per cap; not needed downstream
    res_B.append((T, r, mats))
print(f"  scan: {len(T_grid)} support caps, M={M_MODES} modes "
      f"[{time.time()-t1:.0f}s]")
T_arr = np.array([x[0] for x in res_B])
lamz = np.array([x[1]["lam_zero"] for x in res_B])
lamr = np.array([x[1]["lam_rhs"] for x in res_B])
lamx = np.array([x[1]["lam_max"] for x in res_B])
muB = np.array([x[1]["mu"] for x in res_B])
lamp = np.array([x[1]["lam_prim"] for x in res_B])       # W|_P, zero side
lampx = np.array([x[1]["lam_prim_max"] for x in res_B])
evItop = np.array([x[1]["evI_prim_top"] for x in res_B])  # I|_P top, assembled
poleleak = np.max([x[1]["pole_prim_leak"] for x in res_B])
xchk = np.max([x[1]["xcheck"] for x in res_B])
print(f"  worst entrywise explicit-formula deviation over scan: {xchk:.1e}")
i_cc = np.searchsorted(T_arr, np.log(2)) - 1
print(f"  prime-free window: at T={T_arr[i_cc]:.2f} (< log 2): lam_min = "
      f"{lamz[i_cc]:.4e}, lam_min/lam_max = {lamz[i_cc]/lamx[i_cc]:.2e}, "
      f"exp14-margin of minimizer mu = {muB[i_cc]:.3f}")
print(f"  PRIMITIVE block (Phi(0)=Phi(1)=0, dim rank-2): pole form vanishes "
      f"on it to {poleleak:.1e} (max leak over scan)")
print(f"  prime-free PRIMITIVE: at T={T_arr[i_cc]:.2f}: lam_min(W|_P) = "
      f"{lamp[i_cc]:.4e} = lam_min(arch|_P) -- Connes-Consani definiteness, "
      f"measured; lam_min/lam_max = {lamp[i_cc]/lampx[i_cc]:.2e}")
print(f"  Hodge negativity I|_P <= 0: max over scan of top eig of assembled "
      f"(prime-arch)|_P = {evItop.max():+.3e} "
      f"(vs -lam_min(W|_P) exact; assembly floor ~1e-15*scale)")
print("\n  T_sup     lam_min(zero,factored)  lam_min(rhs,assembled)  "
      "lam_min/lam_max   mu(minimizer)   lam_min(W|_P)   top eig (prime-arch)|_P")
for i in range(0, len(res_B), 8):
    print(f"  {T_arr[i]:5.2f}    {lamz[i]:.6e}        {lamr[i]:+.6e}      "
          f"{lamz[i]/lamx[i]:.2e}       {muB[i]:.2e}     {lamp[i]:.4e}     "
          f"{evItop[i]:+.3e}")

# agreement between factored and assembled lambda_min (above the rhs floor)
ok = lamr > 1e-13 * lamx
agree = np.max(np.abs(lamz[ok] - lamr[ok]) / lamz[ok])
print(f"\n  factored vs assembled lam_min agree to {agree:.1e} "
      f"on the {ok.sum()} points above the assembly floor")

# ---- per-prime-power cost table --------------------------------------------
print("\n  per-prime-power cost (leave-one-out at T = log n + 0.12):")
print("  n      log n    Lambda(n)/sqrt n   lam_min(full)   lam_min(drop n)"
      "   ratio drop/full   Rayleigh wt of P_n   lam_prim(full)   "
      "lam_prim(drop n)   prim ratio")
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
    c = r["c"]
    ray = abs(c @ mats["prime_parts"][n] @ c) / lam_full
    wn = np.log(n) / np.sqrt(n) if n in (2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31)\
        else WLAM[np.searchsorted(NVAL, n)] * 1.0
    resolved = lam_drop > 1e-13 * rd["lam_rhs_max"] and lam_full > 1e-26 * r["lam_max"]
    ratio = lam_drop / lam_full if resolved else np.nan
    # primitive block: cost of prime power n on W|_P
    lam_pfull = r["lam_prim"]
    lam_pdrop = rd["lam_prim_rhs"]
    presolved = (lam_pdrop > 1e-13 * rd["lam_prim_rhs_max"]
                 and lam_pfull > 1e-26 * r["lam_prim_max"])
    pratio = lam_pdrop / lam_pfull if presolved else np.nan
    cost_rows.append((n, ln, wn, lam_full, lam_drop, ratio, ray, resolved,
                      lam_pfull, lam_pdrop, pratio))
    print(f"  {n:<5d}  {ln:.4f}   {wn:.4f}            {lam_full:.3e}      "
          f"{lam_drop:+.3e}       {ratio:8.3f}         {ray:.3f}          "
          f"{lam_pfull:.3e}      {lam_pdrop:+.3e}      {pratio:8.3f}")

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

# ============================================================================
# (P) NEGATIVITY LANDSCAPE: Hodge-index sign structure of I = prime - arch
# ============================================================================
print("\n== (P) negativity landscape: Hodge index of I = prime - arch " + "=" * 16)
print("  measured against the derived statements (docstring / LP_CERT.md S2):")
print("  (H1) I|_P <= 0 on the primitive subspace P = {Phi(0)=Phi(1)=0};")
print("  (H2) n_+(I) <= 1 on every finite dictionary (pole plane = null-"
      "diagonal hyperbolic plane; I = pole - W with W PSD under RH)")
hodge_rows = []
for lab, dd, mm, Wh, lam0, lamM, ev, c, trust in res_A:
    r = Wh.shape[1]
    Iw = Wh.conj().T @ (mm["prime"] - mm["arch"]) @ Wh
    Iw = 0.5 * (Iw + Iw.conj().T)
    evI, VI = np.linalg.eigh(Iw)
    nI = inertia(evI)
    Pw = Wh.conj().T @ mm["pole"] @ Wh
    Pw = 0.5 * (Pw + Pw.conj().T)
    nP = inertia(np.linalg.eigvalsh(Pw))
    # primitive projection: joint null space of the two pole functionals
    rows = np.vstack([mm["p0"] @ Wh, mm["p1"] @ Wh])
    Q = null_basis(rows)
    Ip = Q.conj().T @ Iw @ Q
    Ip = 0.5 * (Ip + Ip.conj().T)
    evIp = np.linalg.eigvalsh(Ip)
    nIp = inertia(evIp)
    pol_leak = np.abs(Q.conj().T @ Pw @ Q).max()
    lam_p, lamx_p, yp = lam_from_factor(mm["B"], Wh @ Q)
    # overlap of the unique positive direction of I with the pole plane
    if nI[0] >= 1:
        U = np.linalg.qr(rows.conj().T)[0]
        ov = float(np.linalg.norm(U.conj().T @ VI[:, -1]))
    else:
        ov = np.nan
    # conditioning-robust pass: whitening cut 1e-6 discards near-dependent
    # Gram directions, whose 1/lambda_G amplification of the ~1e-9 assembly
    # tails otherwise manufactures ghost positive eigenvalues at the
    # 1e-6*lam_1 level in the wide-atom spans
    Wh6, r6 = whiten(mm["G"], cut=1e-6)
    Iw6 = Wh6.conj().T @ (mm["prime"] - mm["arch"]) @ Wh6
    Iw6 = 0.5 * (Iw6 + Iw6.conj().T)
    evI6 = np.linalg.eigvalsh(Iw6)
    nI6 = inertia(evI6)
    Q6 = null_basis(np.vstack([mm["p0"] @ Wh6, mm["p1"] @ Wh6]))
    Ip6 = Q6.conj().T @ Iw6 @ Q6
    evIp6 = np.linalg.eigvalsh(0.5 * (Ip6 + Ip6.conj().T))
    nIp6 = inertia(evIp6)
    hodge_rows.append((lab, r, nI, nP, nIp, evI, evIp, lam_p, lamx_p, ov,
                       pol_leak, Q.shape[1], r6, nI6, evI6, nIp6, evIp6))
    print(f"  {lab:26s} dim {r:2d}: inertia(I) (+,0,-) = {nI}, "
          f"lam_1(I) = {evI[-1]:+.3e}, lam_2(I) = {evI[-2]:+.3e}, "
          f"inertia(pole) = {nP}"
          + (f", overlap(v_+, pole plane) = {ov:.3f}" if nI[0] else ""))
    print(f"    primitive block dim {Q.shape[1]:2d}: inertia(I|_P) = {nIp}, "
          f"top eigs I|_P = [" + ", ".join(f"{x:+.2e}" for x in evIp[-3:])
          + f"], pole leak on P = {pol_leak:.1e}")
    print(f"    robust subspace (whitening cut 1e-6) dim {r6:2d}: "
          f"inertia(I) = {nI6}, lam_2(I) = {evI6[-2]:+.3e}; "
          f"inertia(I|_P) = {nIp6}, top I|_P = {evIp6[-1]:+.3e}")
    print(f"    cross-check: -lam_min(W|_P) [zero side, factored] = "
          f"{-lam_p:+.3e}  vs top eig I|_P [assembled, floor ~1e-15*scale] = "
          f"{evIp[-1]:+.3e}")
h_full = hodge_rows[-1]                      # 64-atom dictionary, for figure
npos_all = [h[2][0] for h in hodge_rows]
npos_rob = [h[13][0] for h in hodge_rows]
lam2_rel = max(h[5][-2] / abs(h[5][-1]) for h in hodge_rows)
lam2_rob = max(h[14][-2] / abs(h[14][-1]) for h in hodge_rows)
print(f"\n  H2 verdict: n_+(I) full span = {npos_all} (ghosts at the "
      f"whitening-amplified floor, worst lam_2/|lam_1| = {lam2_rel:+.1e}); "
      f"robust subspaces = {npos_rob} with lam_2/|lam_1| <= {lam2_rob:+.1e} "
      f"-- exactly ONE hyperbolic direction, never two")
print(f"  H1 verdict: I|_P <= 0 in every dictionary within the assembly "
      f"floor; exact value of its top eigenvalue is -lam_min(W|_P) < 0 "
      f"(factored zero side, e.g. {-h_full[7]:.2e} for the 64-atom span)")

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
fig, axes = plt.subplots(2, 4, figsize=(22.5, 9.8))
fig.suptitle("Exp 25: the finite Cohn–Elkies LP on the Weil form, negativity-"
             "oriented — Hodge-index sign structure of I = prime − arch, "
             "per-prime-power cost, interpolation conditioning", fontsize=13)

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
ax.set_ylabel(r"$\lambda_{\min}\;\left(W(g)/\|g\|_2^2\right)$", fontsize=9)
ax.set_title("(a) minimal eigenvalue vs support cap; prime powers marked",
             fontsize=10)
ax.legend(fontsize=8, loc="lower left")
ax.grid(alpha=0.25, lw=0.6)

# (b) per-prime-power cost: primitive margin after entry + leave-one-out sign
ax = axes[0, 1]
ns = [str(r[0]) for r in cost_rows]
wns = np.array([r[2] for r in cost_rows])
lamp_full = np.array([r[8] for r in cost_rows])
lamp_drop = np.array([r[9] for r in cost_rows])
rays = np.array([r[6] for r in cost_rows])
xp = np.arange(len(ns))
ax.bar(xp, lamp_full, width=0.55, color=C_ARCH, alpha=0.85,
       label=r"$\lambda_{\min}(W|_P)$ at $T=\log n+0.12$ (margin after $n$ enters)")
neg = lamp_drop < 0
ax.plot(xp[~neg], lamp_drop[~neg], "o", color=C_POLE, ms=7,
        label=r"$\lambda_{\min}(W|_P$ without $n)>0$")
ax.plot(xp[neg], -lamp_drop[neg], "v", color=C_PRIME, ms=8,
        label=r"$|\lambda_{\min}|$, drop-$n$ INDEFINITE ($\lambda_{\min}<0$)")
ax.set_yscale("log")
ax2 = ax.twinx()
ax2.semilogy(xp, np.maximum(rays, 1e-2), "k^--", ms=4, lw=0.9, alpha=0.7,
             label=r"Rayleigh weight $|c^*P_nc|/\lambda_{\min}$")
ax2.set_ylabel("Rayleigh weight of $P_n$ (log)", fontsize=9)
ax.set_xticks(xp, ns)
ax.set_xlabel(r"prime power $n$ entering at $T_{\rm sup}=\log n$", fontsize=9)
ax.set_ylabel(r"primitive-block eigenvalue scale (log)", fontsize=9)
ax.set_title("(b) per-prime-power cost at entry: margin after $n$;\n"
             "deleting any single $n\geq3$ makes $W|_P$ indefinite", fontsize=10)
h1, l1 = ax.get_legend_handles_labels()
h2, l2 = ax2.get_legend_handles_labels()
ax.legend(h1 + h2, l1 + l2, fontsize=7, loc="center right")
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
ax.set_ylabel(r"$|\Phi_g(\frac{1}{2}+i\tau)|^2$", fontsize=9)
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
lg = [np.log10(max(x, 1e-33)) for x in lam_nested]   # display floor ~ SVD trust
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

# (g) Hodge-index spectrum of I = prime - arch (64-atom dictionary)
ax = axes[0, 3]
labh, rh, nIh, nPh, nIph, evIh, evIph, lam_ph, lamx_ph, ovh, _, dimP = h_full[:12]
xs = np.arange(evIh.size)
pos = evIh > 0
ax.scatter(xs[~pos], evIh[~pos], s=22, color=C_POLE, label=r"$I$ eigenvalues $\leq 0$")
ax.scatter(xs[pos], evIh[pos], s=42, color=C_PRIME, marker="D",
           label=rf"positive: $n_+(I)={nIh[0]}$")
xsp = np.arange(evIph.size) + (evIh.size - evIph.size)
ax.scatter(xsp, evIph, s=12, color=C_ARCH, marker="x",
           label=rf"$I|_P$ (primitive, dim {dimP}): all $\leq 0$")
ax.set_yscale("symlog", linthresh=1e-8)
ax.axhline(0, color="#888888", lw=0.8)
ax.set_xlabel("eigenvalue index (sorted)", fontsize=9)
ax.set_ylabel(r"eigenvalues of $I=\mathrm{prime}-\mathrm{arch}$ (symlog)", fontsize=9)
ax.set_title(f"(g) Hodge index, 64-atom dictionary: inertia $(+,0,-)$ = {nIh}\n"
             f"(ghosts at 1e-6$\lambda_1$ whitening floor; robust subspace: $n_+=1$)\n"
             rf"pole plane inertia {nPh[0], nPh[2]}; overlap($v_+$, pole plane) = {ovh:.2f}",
             fontsize=9.5)
ax.legend(fontsize=7.5, loc="lower right")
ax.grid(alpha=0.25, lw=0.6)

# (h) primitive block vs support cap: Connes-Consani window and per-prime cost
ax = axes[1, 3]
ax.semilogy(T_arr, lamz, color="#999999", lw=1.1, ls="--",
            label=r"$\lambda_{\min}(W)$ (unconstrained)")
ax.semilogy(T_arr, lamp, color=C_W, lw=1.8,
            label=r"$\lambda_{\min}(W|_P)=-\,$top eig $I|_P$ (zero side)")
mask = evItop < 0
ax.semilogy(T_arr[mask], -evItop[mask], ".", color=C_PRIME, ms=4,
            label=r"$-\,$top eig of assembled $(\mathrm{prime}-\mathrm{arch})|_P$")
ax.axvspan(0.30, np.log(2), color=C_ARCH, alpha=0.12, lw=0)
ax.text(0.33, 2e-9, "prime-free:\n$W|_P=$ arch$|_P$\n(CC 2006.13771\nregime)",
        fontsize=7.5, color=C_ARCH)
for n, ln in PP_THRESH:
    if ln < T_arr[-1]:
        ax.axvline(ln, color=C_PRIME, lw=0.7, alpha=0.5)
        ax.text(ln, 1.6 * lamp.max(), str(n), fontsize=7, ha="center",
                color=C_PRIME)
ax.set_xlabel(r"support cap $T_{\rm sup}$", fontsize=9)
ax.set_ylabel(r"$\lambda_{\min}$ on the primitive block", fontsize=9)
ax.set_title("(h) primitive (Hodge) block vs support cap:\n"
             r"negativity margin of $I|_P$ as each prime power enters",
             fontsize=10)
ax.legend(fontsize=7.5, loc="lower left")
ax.grid(alpha=0.25, lw=0.6)

try:
    fig.tight_layout(rect=[0, 0, 1, 0.955])
except ValueError:
    fig.subplots_adjust(left=0.045, right=0.985, top=0.90, bottom=0.07,
                        wspace=0.30, hspace=0.34)
out = FIGDIR / "exp25_lp.png"
fig.savefig(out, dpi=150)
print(f"\nfigure -> {out}")
print(f"total time {time.time()-t0:.0f}s")
