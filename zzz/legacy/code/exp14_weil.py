"""Experiment 14: THE WEIL EXPLICIT-FORMULA QUADRATIC FORM
(the Weil-positivity corner of REPORT.md section 7(b), made quantitative;
proposition + proof in notes/WEIL.md).

Normalization (derived and *numerically verified to <= 1e-6 relative* below)
----------------------------------------------------------------------------
For F : R -> C smooth with F(u) e^{(1/2+delta)|u|} integrable, define the
"completed Mellin transform" on the multiplicative group (u = log x)

    Phi(s) = int_R F(u) e^{(s-1/2)u} du .

Weil explicit formula for zeta (all nontrivial zeros rho, with multiplicity):

    sum_rho Phi(rho)
        =  Phi(0) + Phi(1)                                     [pole terms]
         - sum_{n>=2} Lambda(n) n^{-1/2} [F(log n) + F(-log n)] [prime side]
         + (1/2pi) int_R Phi(1/2+i tau)
                         [Re psi(1/4 + i tau/2) - log pi] dtau  [archimedean]

Quadratic form: for a test bump g on the multiplicative group put
gtilde(u) = conj(g(-u)), F = g * gtilde (convolution).  Then on the critical
line Phi_F(1/2+i tau) = |Phi_g(1/2+i tau)|^2 >= 0, and Weil's criterion is

    RH  <=>  W(g) := sum_rho Phi_F(rho) >= 0  for all such g.

Test family (Gaussian bumps on the group, u = log x):

    g_{a,sigma,beta}(u) = exp(-(u-a)^2 / (2 sigma^2)) e^{i beta u} .

Closed forms (a drops out of every term of W -- translation on the group is a
modulation, and g * gtilde kills it; verified numerically here):

    Phi_F(s)   = 2 pi sigma^2 exp(sigma^2 (s - 1/2 + i beta)^2)
    zero side  = 2 pi sigma^2 sum_j [ e^{-sigma^2 (gamma_j - beta)^2}
                                    + e^{-sigma^2 (gamma_j + beta)^2} ]
    pole terms = 4 pi sigma^2 e^{sigma^2 (1/4 - beta^2)} cos(sigma^2 beta)
    prime side = 2 sigma sqrt(pi) sum_n Lambda(n) n^{-1/2}
                                  e^{-(log n)^2/(4 sigma^2)} cos(beta log n)
    archimedean= sigma^2 int e^{-sigma^2 (tau-beta)^2}
                              [Re psi(1/4+i tau/2) - log pi] dtau .

A second, independent family (complex mixtures of shifted modulated Gaussians,
class Mixture below, F computed by an independent Gaussian-product formula and
cross-checked against direct quadrature) tests the same normalization with
genuinely complex F and center-dependence.

What this experiment does
-------------------------
(1) VERIFY the explicit formula: zero side (first K <= 100000 Odlyzko zeros)
    against pole - prime + archimedean, for a battery of test functions,
    including a very broad one (sigma = 0.001) that uses ~60k zeros.
    Target: <= 1e-6 relative agreement (limited only by the 3e-9 accuracy of
    the zero data and the double-precision floor of the cancellation).
(2) POSITIVITY MARGIN: mu = W / (|pole| + |prime| + |arch|), scanned over
    width sigma (at beta = 0) and modulation frequency beta (the "center" of
    |Phi_g|^2 on the zero axis).  The margin collapses when the test function
    concentrates its Fourier mass in the spectral gap (0, gamma_1) --
    there the zero side is e^{-sigma^2 gamma_1^2}-small while pole and prime
    terms are individually large and cancel (pole ~ +4 pi sigma^2 e^{sigma^2/4},
    prime ~ -4 pi sigma^2 e^{sigma^2/4}: the PNT cancellation).
(3) Figure figures/exp14_weil.png: verification errors, sigma-scan of the
    four terms, beta-scan of the margin, and a (beta, sigma) heatmap of
    log10 mu.

Run:  python3 code/exp14_weil.py       (~2-4 min)
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

# ----------------------------------------------------------------------------
# arithmetic data
# ----------------------------------------------------------------------------
X_LAMBDA = 10 ** 7


def lambda_support(X):
    """Prime powers n <= X: returns (log n, Lambda(n) n^{-1/2}), sorted."""
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
    return np.log(n.astype(float)), lam / np.sqrt(n.astype(float))


t0 = time.time()
print(f"sieving Lambda to {X_LAMBDA:.0e} ...", flush=True)
LOGN, WLAM = lambda_support(X_LAMBDA)     # w = Lambda(n) n^{-1/2}
print(f"  {LOGN.size} prime powers  [{time.time()-t0:.1f}s]")

GAMMA = load_zeros()                       # 100k positive ordinates
print(f"  {GAMMA.size} zeros, gamma_max = {GAMMA[-1]:.1f}")

# ----------------------------------------------------------------------------
# archimedean density on a master grid (trapezoid; integrand analytic in
# |Im tau| < 1/2, so step h gives error ~ e^{-pi/h}; h = 0.02 -> e^{-157})
# ----------------------------------------------------------------------------
ARCH_H = 0.02


class ArchGrid:
    def __init__(self, tau_max, h=ARCH_H):
        self.h = h
        m = int(np.ceil(tau_max / h))
        self.tau = h * np.arange(-m, m + 1)
        self.D = np.real(digamma(0.25 + 0.5j * self.tau)) - LOGPI

    def integral(self, weight_fn):
        """(1/2pi) int Phi_F(1/2 + i tau) D(tau) dtau, Phi_F given on grid."""
        return np.trapezoid(weight_fn(self.tau) * self.D, dx=self.h) / (2 * np.pi)


# ----------------------------------------------------------------------------
# family 1: single modulated Gaussian bump (closed forms)
# ----------------------------------------------------------------------------
def weil_terms_gauss(sigma, beta, arch_grid, gam=GAMMA, kzeros=None):
    """All four terms of the explicit formula for g = exp(-u^2/2s^2) e^{i b u}.

    Returns dict: zero side (LHS), pole, prime, arch; RHS = pole - prime + arch.
    """
    g = gam if kzeros is None else gam[:kzeros]
    s2 = sigma * sigma
    with np.errstate(under="ignore"):
        zero = 2 * np.pi * s2 * np.sum(
            np.exp(-s2 * (g - beta) ** 2) + np.exp(-s2 * (g + beta) ** 2))
        pole = 4 * np.pi * s2 * np.exp(s2 * (0.25 - beta * beta)) * np.cos(s2 * beta)
        prime = 2 * sigma * np.sqrt(np.pi) * np.sum(
            WLAM * np.exp(-LOGN ** 2 / (4 * s2)) * np.cos(beta * LOGN))
        arch = arch_grid.integral(
            lambda tau: 2 * np.pi * s2 * (np.exp(-s2 * (tau - beta) ** 2)))
    return dict(zero=zero, pole=pole, prime=prime, arch=arch,
                rhs=pole - prime + arch)


# ----------------------------------------------------------------------------
# family 2: complex mixtures of shifted modulated Gaussians
#   g(u) = sum_k c_k exp(-(u-a_k)^2/(2 sigma_k^2)) e^{i beta_k u}
# F = g * gtilde computed by an independent Gaussian-product formula.
# ----------------------------------------------------------------------------
class Mixture:
    def __init__(self, c, a, sigma, beta):
        self.c = np.asarray(c, dtype=complex)
        self.a = np.asarray(a, dtype=float)
        self.s = np.asarray(sigma, dtype=float)
        self.b = np.asarray(beta, dtype=float)

    def phi_g(self, s):
        """Phi_g(s) for complex array s."""
        s = np.atleast_1d(np.asarray(s, dtype=complex))
        out = np.zeros_like(s)
        for ck, ak, sk, bk in zip(self.c, self.a, self.s, self.b):
            w = s - 0.5 + 1j * bk
            out += ck * SQ2PI * sk * np.exp(w * ak + sk ** 2 * w ** 2 / 2)
        return out

    def F(self, u):
        """(g * gtilde)(u) = int g(v) conj(g(v-u)) dv, closed form."""
        u = np.atleast_1d(np.asarray(u, dtype=float))
        out = np.zeros(u.shape, dtype=complex)
        for cj, aj, sj, bj in zip(self.c, self.a, self.s, self.b):
            for ck, ak, sk, bk in zip(self.c, self.a, self.s, self.b):
                A = 0.5 / sj ** 2 + 0.5 / sk ** 2
                B = aj / sj ** 2 + (u + ak) / sk ** 2 + 1j * (bj - bk)
                C = -aj ** 2 / (2 * sj ** 2) - (u + ak) ** 2 / (2 * sk ** 2) \
                    + 1j * bk * u
                out += cj * np.conj(ck) * np.sqrt(np.pi / A) \
                    * np.exp(B ** 2 / (4 * A) + C)
        return out

    def F_quad(self, u, L=12.0, m=6001):
        """Direct quadrature of the convolution (independent check)."""
        v = np.linspace(self.a.min() - L, self.a.max() + L, m)
        gv = np.zeros(v.shape, dtype=complex)
        for ck, ak, sk, bk in zip(self.c, self.a, self.s, self.b):
            gv += ck * np.exp(-(v - ak) ** 2 / (2 * sk ** 2) + 1j * bk * v)
        out = []
        for uu in np.atleast_1d(u):
            gvu = np.zeros(v.shape, dtype=complex)
            for ck, ak, sk, bk in zip(self.c, self.a, self.s, self.b):
                gvu += ck * np.exp(-(v - uu - ak) ** 2 / (2 * sk ** 2)
                                   + 1j * bk * (v - uu))
            out.append(np.trapezoid(gv * np.conj(gvu), v))
        return np.array(out)

    def weil_terms(self, arch_grid, gam=GAMMA):
        with np.errstate(under="ignore"):
            pg_up = self.phi_g(0.5 + 1j * gam)
            pg_dn = self.phi_g(0.5 - 1j * gam)
            zero = float(np.sum(np.abs(pg_up) ** 2 + np.abs(pg_dn) ** 2))
            pole = 2 * np.real(self.phi_g(0.0)[0] * np.conj(self.phi_g(1.0)[0]))
            # F(log n) + F(-log n) = 2 Re F(log n)  (F = g * gtilde)
            prime = float(np.sum(WLAM * 2 * np.real(self.F(LOGN))))
            arch = arch_grid.integral(
                lambda tau: np.abs(self.phi_g(0.5 + 1j * tau)) ** 2)
        return dict(zero=zero, pole=float(pole), prime=prime, arch=float(arch),
                    rhs=float(pole) - prime + float(arch))


# ============================================================================
# (1) VERIFICATION of the explicit formula
# ============================================================================
print("\n== (1) explicit-formula verification " + "=" * 40)
print(f"{'test function':<44}{'zero side':>14}{'RHS':>14}{'rel.diff':>11}")

ver_rows = []          # (label, zero, rhs, reldiff)

# --- family 1 cases: (sigma, beta) chosen so the zero side is not the tiny
#     residue of a cancellation (those go to the margin section instead).
CASES1 = [
    (0.001, 0.0), (0.005, 0.0), (0.02, 0.0), (0.05, 0.0), (0.1, 0.0),
    (0.15, 0.0),
    (0.3, 14.134725), (0.5, 14.134725), (1.0, 14.134725), (1.5, 14.134725),
    (0.5, 21.022040), (0.7, 30.424876), (1.0, 25.010858), (1.2, 37.586178),
]
big_grid = ArchGrid(tau_max=50 + 12 / min(s for s, _ in CASES1))
for sig, bet in CASES1:
    r = weil_terms_gauss(sig, bet, big_grid)
    rel = abs(r["zero"] - r["rhs"]) / abs(r["zero"])
    lab = f"gauss sigma={sig:g} beta={bet:g}"
    ver_rows.append((lab, r["zero"], r["rhs"], rel))
    print(f"{lab:<44}{r['zero']:>14.6e}{r['rhs']:>14.6e}{rel:>11.2e}")

# --- a-invariance / pipeline consistency: shifted single bump via Mixture
mix_grid = ArchGrid(tau_max=90.0)
m_shift = Mixture([1.0], [2.0], [0.3], [14.134725])
r_m = m_shift.weil_terms(mix_grid)
r_c = weil_terms_gauss(0.3, 14.134725, mix_grid)
shift_dev = max(abs(r_m[k] - r_c[k]) / (abs(r_c[k]) + 1e-300)
                for k in ("zero", "pole", "prime", "arch"))
print(f"{'a-invariance: bump shifted to a=2 (all 4 terms)':<44}"
      f"{'':>14}{'':>14}{shift_dev:>11.2e}")

# --- family 2: complex mixtures (independent F formula; quadrature check)
MIXES = [
    ("mixture M1", Mixture([1.0, 0.7 + 0.3j], [0.0, 1.0],
                           [0.3, 0.5], [0.0, 18.0])),
    ("mixture M2", Mixture([1.0, -0.5j], [0.5, 2.2],
                           [0.25, 0.4], [14.134725, 25.010858])),
]
for lab, m in MIXES:
    uu = np.array([0.0, 0.35, np.log(2), np.log(3), 2.0])
    fdev = np.max(np.abs(m.F(uu) - m.F_quad(uu))) / np.max(np.abs(m.F(uu)))
    r = m.weil_terms(mix_grid)
    rel = abs(r["zero"] - r["rhs"]) / abs(r["zero"])
    ver_rows.append((lab, r["zero"], r["rhs"], rel))
    print(f"{lab + f'  (F quadrature dev {fdev:.1e})':<44}"
          f"{r['zero']:>14.6e}{r['rhs']:>14.6e}{rel:>11.2e}")

worst = max(r[3] for r in ver_rows)
print(f"\nworst relative deviation over {len(ver_rows)} tests: {worst:.2e}"
      f"   (target 1e-6: {'PASS' if worst <= 1e-6 else 'FAIL'})")

# --- K-dependence for the broad bump (uses tens of thousands of zeros)
print("\nK-dependence (gauss sigma=0.001, beta=0): zero side vs K")
r_full = weil_terms_gauss(0.001, 0.0, big_grid)
for K in (1000, 10000, 30000, 100000):
    rK = weil_terms_gauss(0.001, 0.0, big_grid, kzeros=K)
    print(f"  K={K:>6}: zero side {rK['zero']:.9e}  "
          f"rel.diff vs RHS {abs(rK['zero']-r_full['rhs'])/r_full['rhs']:.2e}")

# effective number of zeros actually weighted (> 1e-16 of peak) at sigma=0.001
neff = int(np.sum(np.exp(-(0.001 * GAMMA) ** 2) > 1e-16))
print(f"  zeros carrying weight > 1e-16 of peak: {neff}")

# ============================================================================
# (2) POSITIVITY MARGIN
# ============================================================================
print("\n== (2) positivity margin " + "=" * 52)


def margin(r):
    return r["zero"] / (abs(r["pole"]) + abs(r["prime"]) + abs(r["arch"]))


# --- sigma-scan at beta = 0
sig_scan = np.linspace(0.05, 1.5, 88)
scan_grid = ArchGrid(tau_max=12 / 0.05 + 10)
rows_sig = [weil_terms_gauss(s, 0.0, scan_grid) for s in sig_scan]
mu_sig = np.array([margin(r) for r in rows_sig])
print("sigma-scan (beta=0): sigma, zero side, pole, -prime, arch, mu, "
      "|RHS|/scale")
for i in range(0, len(sig_scan), 12):
    r = rows_sig[i]
    sc = abs(r["pole"]) + abs(r["prime"]) + abs(r["arch"])
    print(f"  {sig_scan[i]:5.2f}  {r['zero']:11.4e}  {r['pole']:11.4e}  "
          f"{-r['prime']:11.4e}  {r['arch']:11.4e}  mu={mu_sig[i]:9.2e}  "
          f"{abs(r['rhs'])/sc:8.1e}")
arch_sig = np.array([r["arch"] for r in rows_sig])
iflip = int(np.argmax(arch_sig < 0))
print(f"  arch term changes sign between sigma={sig_scan[iflip-1]:.3f} and "
      f"{sig_scan[iflip]:.3f} (positive for narrow bumps: the density "
      f"Re psi(1/4+i tau/2)-log pi is negative only for |tau| < 2 pi)")
i_pnt = len(sig_scan) - 1
r = rows_sig[i_pnt]
print(f"  PNT cancellation at sigma={sig_scan[i_pnt]:.2f}: pole={r['pole']:.6e}"
      f" vs prime={r['prime']:.6e}  (ratio {r['prime']/r['pole']:.6f});"
      f" 4 pi sigma^2 e^(sigma^2/4) = "
      f"{4*np.pi*sig_scan[i_pnt]**2*np.exp(sig_scan[i_pnt]**2/4):.6e}")

# --- beta-scan at sigma = 1
beta_scan = np.linspace(0.0, 45.0, 451)
bgrid = ArchGrid(tau_max=45 + 14)
rows_beta = [weil_terms_gauss(1.0, b, bgrid) for b in beta_scan]
mu_beta = np.array([margin(r) for r in rows_beta])
zb = np.array([r["zero"] for r in rows_beta])
imin = int(np.argmin(np.where(mu_beta > 0, mu_beta, np.inf)))
print(f"\nbeta-scan (sigma=1): min positive mu = {mu_beta[imin]:.2e} "
      f"at beta = {beta_scan[imin]:.2f} (spectral gap (0, {GAMMA[0]:.2f}))")
# residual consistency where zero side underflows: RHS must vanish
res = np.array([abs(r["rhs"]) for r in rows_beta])
scalearr = np.array([abs(r["pole"]) + abs(r["prime"]) + abs(r["arch"])
                     for r in rows_beta])
deep = zb < 1e-30
if deep.any():
    print(f"  where zero side underflows ({deep.sum()} pts): max |RHS|/scale "
          f"= {np.max(res[deep]/scalearr[deep]):.1e}  "
          f"(assembly cancels to double-precision floor)")

# --- heatmap over (beta, sigma)
print("\nheatmap (beta, sigma) ...", flush=True)
t0 = time.time()
hb = np.linspace(0.0, 40.0, 141)
hs = np.linspace(0.08, 1.5, 56)
hgrid = ArchGrid(tau_max=40 + 12 / 0.08 + 6)
MU = np.zeros((hs.size, hb.size))
gam_h = GAMMA[GAMMA < 40 + 45 / 0.08]
for i, s in enumerate(hs):
    s2 = s * s
    wz = None
    with np.errstate(under="ignore"):
        pw = WLAM * np.exp(-LOGN ** 2 / (4 * s2))
        keep = pw > 1e-18 * pw.max()
        pwk, lnk = pw[keep], LOGN[keep]
        wgt = 2 * np.pi * s2 * np.exp(-s2 * (hgrid.tau[None, :]
                                             - hb[:, None]) ** 2)
        arch_row = np.trapezoid(wgt * hgrid.D[None, :], dx=hgrid.h,
                                axis=1) / (2 * np.pi)
        for j, b in enumerate(hb):
            zero = 2 * np.pi * s2 * np.sum(
                np.exp(-s2 * (gam_h - b) ** 2) + np.exp(-s2 * (gam_h + b) ** 2))
            pole = 4 * np.pi * s2 * np.exp(s2 * (0.25 - b * b)) * np.cos(s2 * b)
            prime = 2 * s * np.sqrt(np.pi) * np.sum(pwk * np.cos(b * lnk))
            MU[i, j] = zero / (abs(pole) + abs(prime) + abs(arch_row[j]))
print(f"  done [{time.time()-t0:.1f}s]")
ii, jj = np.unravel_index(np.argmin(np.where(MU > 0, MU, np.inf)), MU.shape)
print(f"  thinnest positive margin on grid: mu = {MU[ii, jj]:.2e} at "
      f"beta = {hb[jj]:.2f}, sigma = {hs[ii]:.2f}")
n_floor = int(np.sum(MU <= 1e-14))
print(f"  grid points at/below double-precision floor (mu <= 1e-14): {n_floor}"
      f" -- all with beta inside the spectral gap or deep between zeros")

# ============================================================================
# (3) FIGURE
# ============================================================================
# Okabe-Ito (CVD-safe); fixed assignment: pole=blue, prime=vermillion,
# arch=green, zero side / W = black.
C_POLE, C_PRIME, C_ARCH, C_W = "#0072B2", "#D55E00", "#009E73", "#111111"

fig, axes = plt.subplots(2, 2, figsize=(12.5, 9.0))
fig.suptitle("Exp 14: Weil explicit-formula quadratic form "
             r"$W(g)=\sum_\rho \Phi_{g\star\tilde g}(\rho)$"
             " — verification and positivity margin", fontsize=12.5)

# (a) verification errors
ax = axes[0, 0]
labels = [r[0] for r in ver_rows]
errs = np.array([max(r[3], 1e-16) for r in ver_rows])
ypos = np.arange(len(labels))
ax.barh(ypos, errs, color="#7f7f7f", height=0.62)
ax.axvline(1e-6, color=C_PRIME, lw=1.4, ls="--")
ax.text(1e-6, len(labels) - 0.2, " target 1e-6", color=C_PRIME, fontsize=8,
        va="top")
ax.set_xscale("log")
ax.set_xlim(1e-16, 1e-4)
ax.set_yticks(ypos, [l.replace("gauss ", "") for l in labels], fontsize=7.5)
ax.invert_yaxis()
ax.set_xlabel("|zero side − (pole − prime + arch)| / |zero side|", fontsize=9)
ax.set_title("(a) explicit formula: relative deviation, 16 test functions",
             fontsize=10)
ax.grid(axis="x", alpha=0.25, lw=0.6)

# (b) sigma-scan of the four terms
ax = axes[0, 1]
ax.semilogy(sig_scan, [r["pole"] for r in rows_sig], color=C_POLE, lw=1.8,
            label="pole  $\\Phi_F(0)+\\Phi_F(1)$")
ax.semilogy(sig_scan, [r["prime"] for r in rows_sig], color=C_PRIME, lw=1.8,
            ls="--", label="prime  $\\sum\\Lambda(n)n^{-1/2}\\,2F(\\log n)$")
ax.semilogy(sig_scan, np.abs(arch_sig), color=C_ARCH, lw=1.8,
            label=r"|arch|  (sign flips at $\sigma\approx0.06$)")
ax.semilogy(sig_scan, np.maximum([r["zero"] for r in rows_sig], 1e-18),
            color=C_W, lw=2.4, label="$W(g)$ = zero side $\\geq 0$")
ax.set_xlabel(r"bump width $\sigma$   (fixed $\beta=0$)", fontsize=9)
ax.set_title("(b) term-by-term anatomy: pole and prime cancel "
             r"($\sim 4\pi\sigma^2 e^{\sigma^2/4}$), $W$ collapses",
             fontsize=10)
ax.legend(fontsize=8, loc="center left")
ax.grid(alpha=0.25, lw=0.6)
ax.set_ylim(1e-18, 3e2)

# (c) beta-scan of the margin
ax = axes[1, 0]
ax.semilogy(beta_scan, np.maximum(mu_beta, 1e-16), color=C_W, lw=1.6)
for gmm in GAMMA[GAMMA < 45]:
    ax.axvline(gmm, color=C_POLE, lw=0.7, alpha=0.45)
ax.axvspan(0, GAMMA[0], color=C_PRIME, alpha=0.10, lw=0)
ax.text(GAMMA[0] / 2, 3e-3, "spectral gap\n$(0,\\gamma_1)$", ha="center",
        fontsize=8.5, color=C_PRIME)
ax.set_xlabel(r"modulation frequency $\beta$  ($|\Phi_g|^2$ centered at "
              r"$\tau=\beta$; $\sigma=1$)", fontsize=9)
ax.set_ylabel(r"margin $\mu = W/(|{\rm pole}|+|{\rm prime}|+|{\rm arch}|)$",
              fontsize=9)
ax.set_title("(c) margin vs frequency: peaks on zeros (thin blue lines), "
             "collapses in the gap", fontsize=10)
ax.set_ylim(1e-16, 3)
ax.grid(alpha=0.25, lw=0.6)

# (d) heatmap of log10 mu
ax = axes[1, 1]
Mplot = np.log10(np.maximum(MU, 1e-16))
pc = ax.pcolormesh(hb, hs, Mplot, cmap="Blues_r", vmin=-16, vmax=0,
                   shading="auto")
cb = fig.colorbar(pc, ax=ax, pad=0.015)
cb.set_label(r"$\log_{10}\mu$  (dark = thin margin)", fontsize=9)
for gmm in GAMMA[GAMMA < 40]:
    ax.axvline(gmm, color="#ffffff", lw=0.5, alpha=0.5)
ax.set_xlabel(r"modulation frequency $\beta$", fontsize=9)
ax.set_ylabel(r"bump width $\sigma$", fontsize=9)
ax.set_title("(d) margin landscape: thinnest for wide bumps tuned to the "
             "spectral gap", fontsize=10)

fig.tight_layout(rect=[0, 0, 1, 0.96])
out = FIGDIR / "exp14_weil.png"
fig.savefig(out, dpi=150)
print(f"\nfigure -> {out}")
print(f"total time {time.time()-t0:.0f}s (post-sieve)")
