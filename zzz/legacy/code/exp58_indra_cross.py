"""Experiment 58: INDRA'S CROSS — the cross-character mixed pair field.

Jewels reflecting each other.  For two DISTINCT non-principal characters
chi_1, chi_2 (here the quadratic characters chi_3 mod 3 and chi_4 mod 4 —
different conductors), define the ordered mixed pair field

    G1^{chi1,chi2}(X) = sum_{m,n>=1} Lambda(m)chi_1(m) Lambda(n)chi_2(n)
                        (X - m - n)_+ .

Since -L'/L(s,chi_i) has NO pole for non-principal chi_i (L(1,chi_i) != 0),
the double explicit formula predicts a PURE MIXED PAIR LAYER:

    G1^{chi1,chi2}(X) = sum_{rho in Z(L(chi_1)), rho' in Z(L(chi_2))}
        Gamma(rho)Gamma(rho')/Gamma(rho+rho'+2) X^{rho+rho'+1}
        + X^{3/2}-boundary singles + smooth dust,

with UNIT weights (residue 1 at every zero of each factor).  The log-X
frequency set is {gamma^{chi_1}_i + gamma^{chi_2}_j}: a sum spectrum that
belongs to NO single L-function — it exists only as a relation between the
two.  chi_1 = chi_2 = chi_3 reduces to exp20_dirichlet's single-character
pure field; chi_1 != chi_2 is new.

Standing hypotheses (stated per FAMILY.md §2.1 discipline): GRH and simple
zeros for L(s,chi_3), L(s,chi_4) (and for L(s,chi_12), L(s,chi_5) where
those strings are used).  The model hard-codes rho = 1/2 + i*gamma; zeros
are located on the critical line only.  Unlike the Möbius pure field
(exp16_mobius), NO Gonek-type bound is needed: the residues are exactly 1,
and absolute convergence of the pair layer follows from the D''' modulus
law |W| ~ sqrt(2pi) s^{-5/2} (BLOCKS.md §2, dressing- and conductor-
universal) plus the log-density of each string.

Layer ledger derived in notes/INDRA_CROSS.md:
  * NO X^3 (no pole x pole), NO X^{5/2} (no pole x zero): both factors are
    poleless;
  * X^2 pair layer, unit weights, universal Gamma-kernel — the only
    zero-visible layer;
  * X^{3/2} boundary singles from the s=0 Gamma-crossing: coefficient
    -L'/L(0,chi_2) on the chi_1 string and vice versa (computed below;
    suppressed by X^{-1/2} at X^2 normalization — invisible here);
  * smooth: the diagonal m=n carries chi_1 chi_2, so it is O(X^{3/2+eps})
    under GRH(chi_1 chi_2) when chi_1 chi_2 is NON-principal (our case) —
    the mixed field's foreground is even cleaner than exp20's, whose
    equal-character diagonal is (X^2/4)log X raw and must be cancelled by
    the off-diagonal smooth mean (purity forces it; verified below).

THE NET (Indra statement): the residue-pair raw data
    G(X; a,b mod q) = sum_{m=a, n=b (q)} Lambda(m)Lambda(n)(X-m-n)_+
decomposes by finite Fourier over (Z/q)^* x (Z/q)^* into the FULL GRID of
mixed fields G^{chi1,chi2} — exactly, at machine precision.  At q = 12
(containing the lifts of chi_3 and chi_4, plus chi_12 = chi_3 chi_4 and
chi_0) the grid holds 16 fields: one with the X^3 main term (chi_0,chi_0),
six with X^{5/2} single layers (chi_0 x nonprincipal), and NINE pure mixed
pair fields over the 3x3 jewel-pair grid {chi_3, chi_4, chi_12}^2.  Every
residue-pair cell of the raw Goldbach data contains the reflections of ALL
jewel pairs, with coefficients chi_1(a)chi_2(b)/phi(q)^2.

Zero location here is by SIGN CHANGES of the completed real Hardy function
Z_chi(t) = e^{-i arg(eps)/2} (q/pi)^{(s+a)/2} Gamma((s+a)/2) L(s,chi) at
s = 1/2+it (root numbers computed from Gauss sums; all four characters
give |Im Z|/|Re Z| < 1e-15) — complete by construction up to double zeros
within the 0.05 scan step, and count-checked against the Riemann-von
Mangoldt density.  NB this scan AUDITS exp29_ltower_stats's deep cache
(data/chi3_zeros_deep.npy, read-only here) and finds it missing 14 of the 36
zeros in (60,120): the |L|-minima detector loses shallow minima at height.
Confirmed by two independent counts (sign changes at steps 0.05 and 0.02) and
by the Riemann-von Mangoldt density.  Reported in notes/INDRA_CROSS.md §2.

Outputs: figures/exp58_indra_cross.png, figures/exp58_net.png; zero caches
data/exp58_chi{3,4,12,5,5bar}_zeros.npy, data/exp58_chi3_zeros_deep.npy.
Companion note: notes/INDRA_CROSS.md.
"""
import time
import numpy as np
from scipy.special import loggamma
import mpmath as mp
import matplotlib
matplotlib.use("Agg")
import matplotlib.pyplot as plt
from pathlib import Path
from pairfield import sieve_lambda, load_zeros

FIG = Path(__file__).resolve().parent.parent / "figures"
DATA = Path(__file__).resolve().parent.parent / "data"

T0 = time.time()

# ----------------------------------------------------------------------
# 1. Dirichlet L-functions via Hurwitz zeta; zeros by Hardy-Z sign changes
# ----------------------------------------------------------------------
# character tables on residues (value at a mod q); a = parity (chi(-1)=(-1)^a)
CHARS = {
    "chi3":  (3,  {1: 1, 2: -1}, 1),
    "chi4":  (4,  {1: 1, 3: -1}, 1),
    "chi12": (12, {1: 1, 5: -1, 7: -1, 11: 1}, 0),
    "chi5":  (5,  {1: 1, 2: 1j, 3: -1j, 4: -1}, 1),   # quartic, chi(2)=i
}


def make_L(q, table):
    items = sorted(table.items())
    def L(s):
        return mp.power(q, -s) * mp.fsum(
            [c * mp.zeta(s, mp.mpf(a) / q) for a, c in items])
    return L


def root_number(q, table, a):
    """eps(chi) = tau(chi) / (i^a sqrt(q)) from the Gauss sum."""
    tau = sum(c * np.exp(2j * np.pi * r / q) for r, c in sorted(table.items()))
    return tau / (1j ** a * np.sqrt(q))


def find_zeros(name, tmin, tmax, step=0.05, cache_name=None):
    """Ordinates of zeros of L(1/2+it, chi) in (tmin, tmax), sign-change scan
    of the rotated completed Hardy function (real for any primitive chi)."""
    cache = DATA / f"{cache_name or ('exp58_' + name + '_zeros')}.npy"
    if cache.exists():
        z = np.load(cache)
        if z.max() > tmax - 3:
            return z[(z > tmin) & (z < tmax)]
    q, table, a = CHARS[name]
    Lf = make_L(q, table)
    eps = root_number(q, table, a)
    phase = complex(np.exp(-0.5j * np.angle(eps)))

    def Zfun(t):
        s = mp.mpc(0.5, t)
        v = phase * mp.power(mp.mpf(q) / mp.pi, (s + a) / 2) \
            * mp.gamma((s + a) / 2) * Lf(s)
        return v

    mp.mp.dps = 15
    ts = np.arange(tmin, tmax, step)
    zv = np.array([complex(Zfun(t)) for t in ts])
    leak = np.abs(zv.imag).max() / np.abs(zv.real).max()
    assert leak < 1e-12, f"{name}: Z not real (leak {leak:.1e}) — bad eps?"
    sgn = np.sign(zv.real)
    zs = []
    for i in np.where(sgn[1:] * sgn[:-1] < 0)[0]:
        # bisection on the sign of Z: sign evaluation is reliable at dps 15
        # (relative error ~1e-15 even though |Z| ~ e^{-pi t/4} is tiny —
        # mpmath findroot's ABSOLUTE tolerance is useless at that scale)
        a_, b_ = mp.mpf(ts[i]), mp.mpf(ts[i + 1])
        fa = zv.real[i]
        for _ in range(45):
            m_ = (a_ + b_) / 2
            fm = float(Zfun(m_).real)
            if fa * fm <= 0:
                b_ = m_
            else:
                a_, fa = m_, fm
        tr = float((a_ + b_) / 2)
        assert abs(complex(Lf(mp.mpc(0.5, tr)))) < 1e-6, f"{name} @ {tr}"
        zs.append(tr)
    z = np.array(sorted(zs))
    np.save(cache, z)
    return z


def Zfun_of(name):
    """The rotated completed Hardy function Z_chi(t) (real on the line)."""
    q, table, a = CHARS[name]
    Lf = make_L(q, table)
    phase = complex(np.exp(-0.5j * np.angle(root_number(q, table, a))))

    def Z(t):
        s = mp.mpc(0.5, t)
        return complex(phase * mp.power(mp.mpf(q) / mp.pi, (s + a) / 2)
                       * mp.gamma((s + a) / 2) * Lf(s)).real
    return Z


def count_sign_changes(name, tmin, tmax, step):
    """Number of sign changes of Z_chi on (tmin, tmax) at the given step —
    an independent completeness probe (no root polishing)."""
    Z = Zfun_of(name)
    v = np.array([Z(t) for t in np.arange(tmin, tmax + 1e-9, step)])
    return int(np.sum(np.sign(v[1:]) * np.sign(v[:-1]) < 0))


def rvm_count(q, T):
    """Riemann-von Mangoldt-type density (one-sided, leading term)."""
    return (T / (2 * np.pi)) * (np.log(q * T / (2 * np.pi)) - 1)


TMAX = 60.0
g3 = find_zeros("chi3", 0.05, TMAX + 2.0)
g4 = find_zeros("chi4", 0.05, TMAX + 2.0)
g12 = find_zeros("chi12", 0.05, TMAX + 2.0)
print("zeros self-computed (Hardy-Z sign changes, root numbers from Gauss sums):")
for nm, g in [("chi3", g3), ("chi4", g4), ("chi12", g12)]:
    q = CHARS[nm][0]
    print(f"  L(s,{nm:>5}): {len(g):2d} zeros to t={TMAX:.0f}+2 "
          f"(RvM leading term {rvm_count(q, TMAX + 2):.1f});  first: "
          + ", ".join(f"{t:.4f}" for t in g[:4]))
print(f"  min spacing within each string: "
      f"{min(np.diff(g3).min(), np.diff(g4).min(), np.diff(g12).min()):.3f} "
      "(all zeros simple as located)")

# ----------------------------------------------------------------------
# 1b. AUDIT of the sibling cache data/chi3_zeros_deep.npy (exp29_ltower_stats)
#     Read-only: this block never writes that file.  Two independent counts of
#     #{zeros of L(s,chi3) in (60,120)}: Hardy-Z sign changes (two step sizes)
#     and the Riemann-von Mangoldt density.
# ----------------------------------------------------------------------
DLO, DHI = 60.0, 120.0
g3deep = find_zeros("chi3", 58.0, 122.0, cache_name="exp58_chi3_zeros_deep")
mine = g3deep[(g3deep > DLO) & (g3deep < DHI)]
sc_fine = count_sign_changes("chi3", DLO, DHI, 0.02)
rvm_win = rvm_count(3, DHI) - rvm_count(3, DLO)
their = np.load(DATA / "chi3_zeros_deep.npy")
theirs = their[(their > DLO) & (their < DHI)]
missing = [t for t in mine if np.abs(theirs - t).min() > 1e-3]
spurious = [t for t in theirs if np.abs(mine - t).min() > 1e-3]
agree = max((np.abs(mine - t).min() for t in theirs), default=0.0)
print(f"\n[{time.time()-T0:.0f}s] AUDIT of data/chi3_zeros_deep.npy "
      "(exp29_ltower_stats' cache; read-only)")
print(f"  #zeros of L(s,chi3) in ({DLO:.0f},{DHI:.0f}):")
print(f"    this scan, Hardy-Z sign changes @ step 0.05, Muller/bisection "
      f"polished:            {len(mine)}")
print(f"    same, independent sign-change count @ step 0.02 (no polishing):"
      f"                    {sc_fine}")
print(f"    Riemann-von Mangoldt N(120)-N(60) = (T/2pi)(log(qT/2pi)-1) "
      f"evaluated:              {rvm_win:.2f}")
print(f"    data/chi3_zeros_deep.npy contains:"
      f"                                              {len(theirs)}")
print(f"  every cached ordinate matches one of ours (max |dt| = {agree:.2e}); "
      f"spurious in cache: {len(spurious)}")
print(f"  MISSING from the cache: {len(missing)} ordinates — "
      + ", ".join(f"{t:.4f}" for t in missing))
print(f"  => the cache is INCOMPLETE above t=60 ({len(theirs)}/{len(mine)} "
      f"= {100*len(theirs)/max(len(mine),1):.0f}% of the string); its entries "
      "are correct zeros, but ~1 in 3 is absent.")

# boundary-term constants -L'/L(0,chi) for the X^{3/2} ledger
mp.mp.dps = 15
cbdy = {}
for nm in ("chi3", "chi4"):
    q, table, a = CHARS[nm]
    Lf = make_L(q, table)
    cbdy[nm] = complex(-mp.diff(Lf, 0) / Lf(0)).real
print(f"boundary constants: -L'/L(0,chi3) = {cbdy['chi3']:+.4f}, "
      f"-L'/L(0,chi4) = {cbdy['chi4']:+.4f}")

# ----------------------------------------------------------------------
# 2. arithmetic side: sieve to 2e6, ordered convolutions, log-X grid
# ----------------------------------------------------------------------
NMAX = 2_000_000
lam = sieve_lambda(NMAX)
n = np.arange(NMAX + 1)
chi3 = np.zeros(NMAX + 1); chi3[n % 3 == 1] = 1.0; chi3[n % 3 == 2] = -1.0
chi4 = np.zeros(NMAX + 1); chi4[n % 4 == 1] = 1.0; chi4[n % 4 == 3] = -1.0

M = 8192
logX = np.linspace(np.log(2e4), np.log(1.9e6), M)
Xs = np.exp(logX)
Xi = Xs.astype(int)
LFFT = 1
while LFFT < 2 * (NMAX + 1):
    LFFT *= 2


def field(a, b, power=2.0):
    """G(X) = sum a(m) b(n) (X-m-n)_+ on the grid, normalized by X^power."""
    r = np.fft.irfft(np.fft.rfft(a, LFFT) * np.fft.rfft(b, LFFT),
                     LFFT)[: 2 * NMAX + 1]
    N = np.arange(len(r), dtype=float)
    R, S = np.cumsum(r), np.cumsum(N * r)
    return (Xs * R[Xi] - S[Xi]) / Xs ** power


def prep(y, deg=3):
    return y - np.polyval(np.polyfit(logX, y, deg), logX)


def bandpass(y, lo, hi):
    Y = np.fft.rfft(prep(y))
    f = np.fft.rfftfreq(M, d=(logX[1] - logX[0])) * 2 * np.pi
    Y[(f < lo) | (f > hi)] = 0
    return np.fft.irfft(Y, M)


win = np.hanning(M)
core = slice(M // 8, -M // 8)


def spec(y):
    Y = np.fft.rfft(prep(y) * win, 8 * M)          # 8x zero-padded
    f = np.fft.rfftfreq(8 * M, d=(logX[1] - logX[0])) * 2 * np.pi
    return f, np.abs(Y)


def pair_weights(sa, sb):
    """The kernel matrix W_{ij} = Gamma(rho_i)Gamma(rho'_j)/Gamma(rho+rho'+2)."""
    ra = 0.5 + 1j * np.asarray(sa, float)
    rb = 0.5 + 1j * np.asarray(sb, float)
    return np.exp(loggamma(ra)[:, None] + loggamma(rb)[None, :]
                  - loggamma(ra[:, None] + rb[None, :] + 2))


def pair_model_full(sa, sb, keep=None):
    """sum_{rho in sa, rho' in sb} Gamma(rho)Gamma(rho')/Gamma(rho+rho'+2)
    X^{i(g+g')} (X^2-normalized), COMPLEX; sa, sb are full ordinate strings
    (both signs) exactly as given.  `keep` optionally masks the pair set."""
    sa = np.asarray(sa, float); sb = np.asarray(sb, float)
    W = pair_weights(sa, sb)
    if keep is not None:
        W = W * keep
    Ea = np.exp(1j * np.outer(sa, logX))
    Eb = np.exp(1j * np.outer(sb, logX))
    return np.einsum("km,km->m", Ea, W @ Eb)


def pair_model(ga, gb):
    """Real pair model for two SYMMETRIC strings given by positive ordinates."""
    return np.real(pair_model_full(np.concatenate([ga, -ga]),
                                   np.concatenate([gb, -gb])))


def single_model(g, kind="boundary"):
    """single-line model over string g: weights Gamma(rho)/Gamma(rho+2)
    (s=0 boundary crossing) or Gamma(rho)/Gamma(rho+3) (pole crossing)."""
    s = np.concatenate([g, -g]); r = 0.5 + 1j * s
    shift = 2 if kind == "boundary" else 3
    w = -np.exp(loggamma(r) - loggamma(r + shift))
    return np.real(w @ np.exp(1j * np.outer(s, logX)))


print(f"\n[{time.time()-T0:.0f}s] sieve to {NMAX:.0e} done; grid M={M}, "
      f"X in [2e4, 1.9e6], window span {logX[-1]-logX[0]:.2f} "
      f"(line resolution ~{2*np.pi/(logX[-1]-logX[0]):.2f})")

# ---- the mixed field, primitive dressings --------------------------------
a3, a4 = lam * chi3, lam * chi4
data = field(a3, a4)

# (a) absent layers ---------------------------------------------------------
print("\n(a) ABSENT LAYERS")
i6 = np.argmin(np.abs(logX - np.log(1e6)))
print(f"  X^3 layer:  G/X^3 at X=1e6:  {data[i6]/Xs[i6]:+.6f}   "
      "(Lambda x Lambda: 1/6 = 0.166667)")
# X^{5/2}: at X^{5/2} normalization singles would be flat; probe by corr
d52 = field(a3, a4, power=2.5)
lo52, hi52 = 5.0, 58.0
b52 = bandpass(d52, lo52, hi52)
for nm, g in [("chi3", g3), ("chi4", g4)]:
    ms = bandpass(single_model(g, "pole"), lo52, hi52)
    c = np.corrcoef(b52[core], ms[core])[0, 1]
    print(f"  X^5/2 singles vs {nm} string: corr {c:+.3f}  (no pole -> absent)")
# positive control: the (chi0, chi4) field HAS the pole, singles must appear
chi0_12 = ((n % 2 != 0) & (n % 3 != 0)).astype(float)
d52c = field(lam * chi0_12, a4, power=2.5)
b52c = bandpass(d52c, lo52, hi52)
ms4 = bandpass(single_model(g4, "pole"), lo52, hi52)
c = np.corrcoef(b52c[core], ms4[core])[0, 1]
r = np.std(b52c[core]) / np.std(ms4[core])
print(f"  positive control (chi0,chi4): corr {c:+.4f}, ratio {r:.4f} "
      "(pole x zero singles present, weight 1/(rho(rho+1)(rho+2)))")

# smooth ledger: diagonal chi1*chi2 principal vs non-principal
d33 = field(a3, a3)
m = np.arange(2, NMAX // 2)
diag33 = np.sum((lam[m] * chi3[m]) ** 2 * (1e6 - 2 * m).clip(min=0)) / 1e12
print("\n  smooth ledger at X=1e6 (X^2 units):")
print(f"    equal-char (chi3,chi3): raw diagonal {diag33:+.4f} "
      f"[~log(X)/4 = {np.log(1e6)/4:.3f}], total G/X^2 = {d33[i6]:+.4f}"
      "  -> off-diagonal cancels the log-diagonal (purity)")
print(f"    mixed (chi3,chi4): chi3*chi4 = chi12 non-principal, "
      f"total G/X^2 = {data[i6]:+.4f}  (no log term anywhere)")

# (b) the mixed pair model --------------------------------------------------
BLO, BHI = 12.0, 58.0
model34 = pair_model(g3, g4)
bd, bm = bandpass(data, BLO, BHI), bandpass(model34, BLO, BHI)
corr34 = np.corrcoef(bd[core], bm[core])[0, 1]
ratio34 = np.std(bd[core]) / np.std(bm[core])
print(f"\n(b) MIXED PAIR MODEL, band [{BLO:.0f},{BHI:.0f}]")
print(f"  corr(data, mixed model {{g3_i + g4_j}}, unit weights) = {corr34:.6f}"
      f",  amplitude ratio = {ratio34:.6f}")

# (c) controls: the wrong models -------------------------------------------
print("\n(c) CONTROLS (same data, same band, wrong line models)")
gz = load_zeros(40); gz = gz[gz < TMAX]


def false_string(q, n, seed):
    """A planted-false ordinate string: n ordinates in (0, TMAX+2) drawn from
    the Riemann-von Mangoldt density for modulus q (right density, wrong
    arithmetic) — the exp55 planted-false control pattern."""
    tt = np.linspace(0.5, TMAX + 2.0, 4000)
    cc = rvm_count(q, tt); cc -= cc[0]
    u = np.sort(np.random.default_rng(seed).uniform(0, cc[-1], n))
    return np.interp(u, cc, tt)


controls = [("pure chi3-pair {g3+g3}", pair_model(g3, g3)),
            ("pure chi4-pair {g4+g4}", pair_model(g4, g4)),
            ("zeta pair {gz+gz}", pair_model(gz, gz)),
            ("planted-false {f3+f4}",
             pair_model(false_string(3, len(g3), 583),
                        false_string(4, len(g4), 584)))]
ctrl_res = []
for nm, mod in controls:
    bc = bandpass(mod, BLO, BHI)
    c = np.corrcoef(bd[core], bc[core])[0, 1]
    r = np.std(bd[core]) / np.std(bc[core])
    ctrl_res.append((nm, c))
    print(f"  {nm:>24}: corr {c:+.6f},  amplitude ratio {r:9.4f}")
print(f"  {'MIXED MODEL {g3+g4}':>24}: corr {corr34:+.6f},  amplitude ratio "
      f"{ratio34:9.4f}   <- the claim; margin over best control "
      f"{corr34 - max(abs(c) for _, c in ctrl_res):+.4f}")

# (d) individual mixed lines ------------------------------------------------
print("\n(d) INDIVIDUAL MIXED LINES (window resolution ~1.38; 8x zero-padded "
      "peak reads)")
fd, Ad = spec(data)
fm, Am = spec(model34)
lines = [("g3_1+g4_1", g3[0] + g4[0]), ("g3_2+g4_1", g3[1] + g4[0]),
         ("g3_1+g4_2", g3[0] + g4[1]), ("g3_1+g4_3", g3[0] + g4[2]),
         ("g3_3+g4_1", g3[2] + g4[0]), ("g3_2+g4_2", g3[1] + g4[1])]
for nm, fr in lines:
    m_ = (fd > fr - 0.7) & (fd < fr + 0.7)
    fpk = fd[m_][np.argmax(Ad[m_])]
    i = np.argmin(np.abs(fd - fr))
    j = np.argmin(np.abs(fm - fr))
    print(f"  {nm} = {fr:6.3f}:  data peak {fpk:6.3f} ({fpk-fr:+.3f}), "
          f"amp data/model at line = {Ad[i]/Am[j]:.3f}")
print("  crowding: g3_2+g4_1 = 17.27 vs g3_1+g4_2 = 18.28 (sep 1.01 < 1.38, "
      "blended); 21.03/21.49/21.72 triple within 0.7 — read as a cluster")
isng = [np.argmin(np.abs(fd - g)) for g in [g3[0], g4[0], g3[1], g4[1]]]
ipar = [np.argmin(np.abs(fd - (g3[0] + g4[0])))]
sup = Ad[ipar[0]] / np.mean(Ad[isng])
print(f"  single-line suppression: amp(g3_1+g4_1) / mean amp at "
      f"g3_1,g4_1,g3_2,g4_2 = {sup:.1f}x (singles only at X^3/2 boundary)")

# ----------------------------------------------------------------------
# 3. THE NET at q=12: finite Fourier over (Z/12)* x (Z/12)*
# ----------------------------------------------------------------------
print(f"\n[{time.time()-T0:.0f}s] THE NET: q=12 residue-pair decomposition")
RES = [1, 5, 7, 11]
TAB = {"chi0": {1: 1, 5: 1, 7: 1, 11: 1},
       "chi3": {1: 1, 5: -1, 7: 1, 11: -1},     # lift of chi3 mod 3
       "chi4": {1: 1, 5: 1, 7: -1, 11: -1},     # lift of chi4 mod 4
       "chi12": {1: 1, 5: -1, 7: -1, 11: 1}}    # primitive mod 12
CN = list(TAB)

# raw residue-pair cells
mask = {a: lam * (n % 12 == a) for a in RES}
cell = {}
for a in RES:
    for b in RES:
        cell[(a, b)] = field(mask[a], mask[b])

# direct lifted character fields (independent arrays, independent FFTs)
lift = {c: lam * np.array([TAB[c].get(v, 0) for v in range(12)])[n % 12]
        for c in CN}
direct = {(c1, c2): field(lift[c1], lift[c2]) for c1 in CN for c2 in CN}

# finite Fourier both ways
cellscale = max(np.max(np.abs(cell[k])) for k in cell)
err_fwd = 0.0
err_fwd_in = 0.0
comp = {}
for c1 in CN:
    for c2 in CN:
        rec = sum(TAB[c1][a] * TAB[c2][b] * cell[(a, b)]
                  for a in RES for b in RES)
        comp[(c1, c2)] = rec
        e = np.max(np.abs(rec - direct[(c1, c2)]))
        err_fwd = max(err_fwd, e / np.max(np.abs(direct[(c1, c2)])))
        err_fwd_in = max(err_fwd_in, e / cellscale)
err_inv = 0.0
for a in RES:
    for b in RES:
        rec = sum(TAB[c1][a] * TAB[c2][b] * comp[(c1, c2)]
                  for c1 in CN for c2 in CN) / 16.0
        err_inv = max(err_inv, np.max(np.abs(rec - cell[(a, b)]))
                      / np.max(np.abs(cell[(a, b)])))
print(f"  (i) EXACTNESS (Proposition N is exact in exact arithmetic; these are"
      " float64 round-off numbers)")
print(f"      cells->characters vs direct build, rel. to the RECOVERED "
      f"component: {err_fwd:.2e}")
print(f"      same residual rel. to the RAW CELL scale being cancelled "
      f"({cellscale:.3g}): {err_fwd_in:.2e}")
print(f"      characters->cells (inverse transform): {err_inv:.2e}")
print("      [the first number is larger only because the forward transform "
      "cancels ~7 orders of magnitude; the absolute residual is float64 eps "
      "against the input scale]")

# lift vs primitive difference (2-power / 3-power boundary terms)
dl = np.max(np.abs(direct[("chi3", "chi4")] - data))
print(f"  lift-vs-primitive correction (chi3,chi4): max |dG|/X^2 = {dl:.4f} "
      "(Euler-factor boundary terms at X^3/2; cf. band amps below)")

# principal row sanity: the grid contains the whole family classification
print(f"  (chi0,chi0): G/X^3 at 1e6 = "
      f"{direct[('chi0','chi0')][i6]/Xs[i6]:.4f} (X^3/6 -> 1/6)")
b0 = bandpass(field(lift["chi0"], lift["chi4"], power=2.5), lo52, hi52)
c0 = np.corrcoef(b0[core], ms4[core])[0, 1]
print(f"  (chi0,chi4): X^5/2 singles corr vs chi4 string = {c0:+.4f} "
      "(pole x zero layer lives in the principal row only)")

# (ii) each nonprincipal component displays its own mixed spectrum
NP = ["chi3", "chi4", "chi12"]
strings = {"chi3": g3, "chi4": g4, "chi12": g12}
MKEYS = [("chi3", "chi3"), ("chi4", "chi4"), ("chi12", "chi12"),
         ("chi3", "chi4"), ("chi3", "chi12"), ("chi4", "chi12")]
models = {k: bandpass(pair_model(strings[k[0]], strings[k[1]]), BLO, BHI)
          for k in MKEYS}


def mkey(c1, c2):
    """The MKEYS entry for the unordered pair {c1,c2} (the pair model is
    symmetric; MKEYS stores one representative per pair)."""
    return (c1, c2) if (c1, c2) in MKEYS else (c2, c1)


conf = np.zeros((9, 6))
own_ratio = {}
rows = []
print("\n  (ii) confusion matrix: band corr of each recovered component "
      f"against each mixed-line model, band [{BLO:.0f},{BHI:.0f}]")
print("       component      " + "".join(f"{k[0][3:]}+{k[1][3:]:<7}" for k in MKEYS)
      + "own-ratio")
for i, (c1, c2) in enumerate([(x, y) for x in NP for y in NP]):
    bcomp = bandpass(comp[(c1, c2)], BLO, BHI)
    for j, k in enumerate(MKEYS):
        conf[i, j] = np.corrcoef(bcomp[core], models[k][core])[0, 1]
    own = MKEYS.index(mkey(c1, c2))
    own_ratio[(c1, c2)] = np.std(bcomp[core]) / np.std(models[mkey(c1, c2)][core])
    rows.append((c1, c2))
    best_wrong = max(abs(conf[i, j]) for j in range(6) if j != own)
    star = "  <- own" if np.argmax(np.abs(conf[i])) == own else "  ** MISID **"
    print(f"    ({c1[3:]:>2},{c2[3:]:>2})      "
          + "".join(f"{conf[i, j]:+.3f}    " for j in range(6))
          + f"{own_ratio[(c1, c2)]:.3f}{star}  (margin {conf[i, own]-best_wrong:+.3f})")

# cross-talk: raw cell vs recovered component band amplitudes
amp_cell = np.std(bandpass(cell[(1, 1)], BLO, BHI)[core])
amp_comp = np.std(bandpass(comp[("chi3", "chi4")], BLO, BHI)[core]) / 16.0
print(f"\n  cross-talk: raw cell (1,1) band amplitude {amp_cell:.3f} vs its "
      f"(chi3,chi4) share {amp_comp:.4f} ({amp_cell/amp_comp:.0f}x buried — "
      "the principal row's zeta/L singles dominate every raw cell; the "
      "finite Fourier cancels them exactly)")

# ----------------------------------------------------------------------
# 4. stretch: the mod-5 quartic character (complex dressing)
# ----------------------------------------------------------------------
print(f"\n[{time.time()-T0:.0f}s] STRETCH: chi5 (quartic mod 5, complex; "
      "asymmetric zero string)")
g5p = find_zeros("chi5", 0.05, TMAX + 2.0)
# negative ordinates: zeros of L(s,chi5) at t<0 = -(zeros of L(s,chibar5) at t>0)
CHARS["chi5bar"] = (5, {1: 1, 2: -1j, 3: 1j, 4: -1}, 1)
g5n = -find_zeros("chi5bar", 0.05, TMAX + 2.0)[::-1]
g5 = np.concatenate([g5n, g5p])          # the true asymmetric string
eps5 = root_number(*CHARS["chi5"])
print(f"  root number eps(chi5) = {eps5.real:+.6f}{eps5.imag:+.6f}i "
      f"(|eps| = {abs(eps5):.12f}, arg = {np.angle(eps5):+.6f})")
print(f"  chi5 zeros in (-{TMAX:.0f},{TMAX:.0f}): {len(g5)} "
      f"({len(g5n)} negative, {len(g5p)} positive — asymmetric, "
      f"first above 0: {g5p[0]:.4f}, first below: {g5n[-1]:.4f})")

chi5 = np.zeros(NMAX + 1, dtype=complex)
for r_, v in CHARS["chi5"][1].items():
    chi5[n % 5 == r_] = v
a5 = lam * chi5
rc = np.fft.ifft(np.fft.fft(a3, LFFT) * np.fft.fft(a5, LFFT))[: 2 * NMAX + 1]
Nn = np.arange(len(rc), dtype=float)
Rc, Sc = np.cumsum(rc), np.cumsum(Nn * rc)
dataC = (Xs * Rc[Xi] - Sc[Xi]) / Xs ** 2


s3 = np.concatenate([g3, -g3])                 # chi3 string, symmetric
modC = pair_model_full(s3, g5)
for part, nm in [(np.real, "Re"), (np.imag, "Im")]:
    bdc = bandpass(part(dataC), BLO, BHI)
    bmc = bandpass(part(modC), BLO, BHI)
    c = np.corrcoef(bdc[core], bmc[core])[0, 1]
    r = np.std(bdc[core]) / np.std(bmc[core])
    print(f"  G^(chi3,chi5) {nm} part: corr {c:+.6f}, ratio {r:.4f}")

# --- controls for the asymmetric string ----------------------------------
# (i) the mirrored (chibar5) string.  NB this model is the EXACT complex
#     conjugate of modC (s3 is symmetric), so it is NOT an amplitude test:
#     it can only be falsified by the SIGN of the Im-part correlation.
modCbar = pair_model_full(s3, -g5[::-1])
conj_gap = np.max(np.abs(modCbar - np.conj(modC))) / np.max(np.abs(modC))
cRe = np.corrcoef(bandpass(np.real(dataC), BLO, BHI)[core],
                  bandpass(np.real(modCbar), BLO, BHI)[core])[0, 1]
cIm = np.corrcoef(bandpass(np.imag(dataC), BLO, BHI)[core],
                  bandpass(np.imag(modCbar), BLO, BHI)[core])[0, 1]
print(f"  control 1, mirrored (chibar5) ordinates: Re corr {cRe:+.4f}, "
      f"Im corr {cIm:+.4f}")
print(f"    [HONEST READ: this model equals conj(true model) to "
      f"{conj_gap:.1e} relative, so Re is degenerate by construction and only "
      "the Im SIGN discriminates — a 1-bit control, not an amplitude control. "
      "Controls 2-3 are the real wrong-line tests.]")
# (ii) symmetrized chi5 string (the asymmetry deleted, ordinates otherwise
#      correct) and (iii) the wrong jewel entirely (chi4 in place of chi5).
for nm, sb in [("2, symmetrized chi5 string (+-g5p)",
                np.concatenate([-g5p[::-1], g5p])),
               ("3, wrong jewel: chi4 string in place of chi5",
                np.concatenate([g4, -g4]))]:
    mc = pair_model_full(s3, sb)
    cs = [np.corrcoef(bandpass(p(dataC), BLO, BHI)[core],
                      bandpass(p(mc), BLO, BHI)[core])[0, 1]
          for p in (np.real, np.imag)]
    print(f"  control {nm}: Re corr {cs[0]:+.4f}, Im corr {cs[1]:+.4f}")

# --- the dark field (chi5, chibar5): the difference spectrum --------------
a5b = lam * np.conj(chi5)
rd = np.fft.ifft(np.fft.fft(a5, LFFT) * np.fft.fft(a5b, LFFT))[: 2 * NMAX + 1]
Rd, Sd = np.cumsum(rd), np.cumsum(Nn * rd)
dataD = np.real((Xs * Rd[Xi] - Sd[Xi]) / Xs ** 2)
bD = bandpass(dataD, BLO, BHI)
modD = np.real(pair_model_full(g5, -g5[::-1]))       # difference spectrum
bmD = bandpass(modD, BLO, BHI)
bM = bandpass(np.real(modC), BLO, BHI)
# what the (chi5,chibar5) band actually contains: its own m=n diagonal,
# sum_m Lambda(m)^2 (X-2m)_+ over m coprime to 5 (chi5*chibar5 = principal)
w = (lam * np.abs(chi5)) ** 2
Cw, Cmw = np.cumsum(w), np.cumsum(np.arange(len(w), dtype=float) * w)
h = np.minimum((Xi // 2), len(w) - 1)
diagD = (Xs * Cw[h] - 2 * Cmw[h]) / Xs ** 2
bdiag = bandpass(diagD, BLO, BHI)
print("  dark field G^(chi5,chibar5), band [12,58]:")
print(f"    MODEL amplitudes: difference-spectrum pair model {np.std(bmD[core]):.3e}"
      f"  vs  sum-spectrum (chi3,chi5) pair model {np.std(bM[core]):.3e}"
      f"   (ratio {np.std(bmD[core])/np.std(bM[core]):.2f} -- the draft "
      "predicted e^{-pi*min|g|} suppression here; there is none)")
print(f"    DATA amplitude {np.std(bD[core]):.4f} vs mixed field "
      f"{np.std(bandpass(np.real(dataC), BLO, BHI)[core]):.4f}"
      "  -- the dark field's band is NOT smaller")
print(f"    corr(dark data, difference-spectrum pair model) = "
      f"{np.corrcoef(bD[core], bmD[core])[0,1]:+.6f}, amplitude ratio "
      f"{np.std(bD[core])/np.std(bmD[core]):.4f}  (the pair layer is PRESENT "
      "with unit weights -- the kernel is right, the darkness claim is not)")
print(f"    corr(dark data, its own m=n diagonal sum Lambda^2 (X-2m)_+) = "
      f"{np.corrcoef(bD[core], bdiag[core])[0,1]:+.4f}, amplitude ratio "
      f"{np.std(bD[core])/np.std(bdiag[core]):.3f}")
print("  => THE DRAFT'S 'DARK FIELD' PREDICTION IS FALSIFIED. Diagnosis "
      "(sign split of the kernel):")
al, be = g5, -g5[::-1]                       # Z(chi5) and Z(chibar5)
sgn_same = np.outer(np.sign(al), np.sign(be)) > 0
Wd = np.abs(pair_weights(al, be))
for nm, keep in [("same-sign (alpha,beta) pairs", sgn_same),
                 ("opposite-sign pairs", ~sgn_same)]:
    amp = np.std(bandpass(np.real(pair_model_full(al, be, keep=keep)),
                          BLO, BHI)[core])
    print(f"    {nm:>28}: {int(keep.sum()):4d} pairs, max|W| "
          f"{Wd[keep].max():.3e}, band amplitude {amp:.3e}")
print("    Z(chibar5) = -Z(chi5), and Z(chi5) is asymmetric but contains BOTH "
      "signs (29/29 here), so beta ranges over both signs too: roughly half "
      "the (alpha,beta) pairs are SAME-sign and therefore UNDAMPED. Those "
      "carry frequencies gamma_i - gamma_j with gamma_i>0>gamma_j, i.e. "
      "|gamma_i|+|gamma_j| -- sum-like lines wearing difference labels.")
print("    What IS exponentially dark is only the same-sign-ordinate part of "
      "the difference spectrum (the small |gamma_i - gamma_j| lines), which "
      "is the opposite-sign (alpha,beta) block above.")

# ----------------------------------------------------------------------
# 5. figures
# ----------------------------------------------------------------------
CB, CR, CGY = "#1f77b4", "crimson", "0.55"
fig, ax = plt.subplots(3, 1, figsize=(13, 12.0))
band = (fd > 10) & (fd < 55)
ax[0].plot(fd[band], Ad[band], lw=0.9, color=CB,
           label="mixed-field data spectrum  $\\Lambda\\chi_3\\otimes\\Lambda\\chi_4$")
bandm = (fm > 10) & (fm < 55)
ax[0].plot(fm[bandm], -Am[bandm], lw=0.9, color=CR,
           label="pure mixed pair model over $\\{\\gamma^{\\chi_3}_i+\\gamma^{\\chi_4}_j\\}$ (mirrored)")
first = True
for gi in g3[:5]:
    for gj in g4[:5]:
        fr = gi + gj
        if fr < 55:
            ax[0].axvline(fr, color=CGY, lw=0.5, ls=":",
                          label="mixed lines $\\gamma^{\\chi_3}_i+\\gamma^{\\chi_4}_j$" if first else None)
            first = False
for k, gi in enumerate(list(g3[:2]) + list(g4[:2])):
    ax[0].axvline(gi, color="seagreen", lw=0.8, ls="--",
                  label="single $\\gamma$ (absent)" if k == 0 else None)
ax[0].legend(fontsize=8, loc="upper right")
ax[0].set_title("exp58: the cross-character mixed pair field — a sum spectrum "
                "belonging to no single $L$-function (corr %.4f)" % corr34)
ax[0].set_xlabel("$\\log X$ frequency")
ax[1].plot(Xs[core], bd[core], lw=0.7, color=CB, label="data, band [12,58]")
ax[1].plot(Xs[core], bm[core], lw=0.7, color=CR, alpha=0.85,
           label="mixed model (unit weights, universal $\\Gamma$-kernel)")
ax[1].set_xscale("log"); ax[1].legend(fontsize=8)
ax[1].set_xlabel("$X$")
vals = [corr34] + [c for _, c in ctrl_res]
cols = [CR] + [CGY] * len(ctrl_res)
bars = ax[2].bar(range(len(vals)), vals, color=cols, width=0.55)
ax[2].axhline(0, color="k", lw=0.8)
ax[2].set_xticks(range(len(vals)))
ax[2].set_xticklabels(["mixed model\n$\\{\\gamma^{\\chi_3}+\\gamma^{\\chi_4}\\}$",
                       "pure $\\chi_3$ pairs", "pure $\\chi_4$ pairs",
                       "$\\zeta$ pairs", "planted-false\n(right density)"],
                      fontsize=9)
for b, v in zip(bars, vals):
    ax[2].text(b.get_x() + b.get_width() / 2, v + 0.03 * np.sign(v),
               f"{v:+.3f}", ha="center", fontsize=9)
ax[2].set_ylabel("band corr with data")
ax[2].set_title("controls: the mixed model wins decisively")
ax[2].set_ylim(-0.4, 1.15)
for a_ in ax:
    a_.grid(alpha=0.25, lw=0.5)
fig.tight_layout()
fig.savefig(FIG / "exp58_indra_cross.png", dpi=140)

fig2, ax2 = plt.subplots(1, 2, figsize=(13, 5.4),
                         gridspec_kw={"width_ratios": [1.35, 1]})
im = ax2[0].imshow(conf, cmap="Blues", vmin=-0.2, vmax=1.0, aspect="auto")
ax2[0].set_xticks(range(6))
ax2[0].set_xticklabels([f"{k[0][3:]}+{k[1][3:]}" for k in MKEYS], fontsize=9)
ax2[0].set_yticks(range(9))
ax2[0].set_yticklabels([f"({c1[3:]},{c2[3:]})" for c1, c2 in rows], fontsize=9)
for i in range(9):
    for j in range(6):
        ownj = MKEYS.index(mkey(*rows[i]))
        ax2[0].text(j, i, f"{conf[i,j]:+.2f}", ha="center", va="center",
                    fontsize=8, color="white" if conf[i, j] > 0.55 else "#1a1a2e",
                    fontweight="bold" if j == ownj else "normal")
ax2[0].set_xlabel("mixed-line model $\\{\\gamma^{a}+\\gamma^{b}\\}$")
ax2[0].set_ylabel("recovered component $(\\chi_1,\\chi_2)$ from residue cells")
ax2[0].set_title("the net at $q=12$: every component finds its own jewel pair")
fig2.colorbar(im, ax=ax2[0], shrink=0.85, label="band corr")
labels = ["raw cell (1,1)\nband amp", "its ($\\chi_3$,$\\chi_4$) share",
          "reconstruction\nresidual"]
vals2 = [amp_cell, amp_comp, amp_cell * err_inv]
bars2 = ax2[1].bar(range(3), vals2, color=[CGY, CR, CB], width=0.5)
ax2[1].set_yscale("log")
ax2[1].set_xticks(range(3)); ax2[1].set_xticklabels(labels, fontsize=8)
for b, v in zip(bars2, vals2):
    ax2[1].text(b.get_x() + b.get_width() / 2, v * 1.3, f"{v:.1e}",
                ha="center", fontsize=8)
ax2[1].set_title("jewels buried in every cell,\nrecovered exactly (finite Fourier)")
ax2[1].grid(alpha=0.25, lw=0.5, axis="y")
fig2.tight_layout()
fig2.savefig(FIG / "exp58_net.png", dpi=140)
print(f"\n[{time.time()-T0:.0f}s] saved figures/exp58_indra_cross.png, "
      "figures/exp58_net.png")
