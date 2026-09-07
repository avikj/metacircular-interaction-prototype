"""Experiment 21: closing Theorem D'' -- the finite check.  (notes/DCLOSE.md)

Everything below is per (+,+) sign class; the (-,-) mirror doubles it and the
mixed classes are bounded separately (opposite-sign pairs carry mass < 1e-17,
(++)x(--) cross quadruples have |delta| >= 4*gamma_1 = 56.5).

PART A -- exact spacing floor (V2.5 standard, cf. notes/VV.md).
    The 9-decimal table entries are parsed directly from their decimal strings
    into Python/numpy int64 nano-units -- NO float enters the load-bearing
    path.  All pair sums gamma_i + gamma_j (i <= j) with sum <= H are formed
    in exact int64 arithmetic (max value ~1.5e14 << 2^63), and the minimal
    positive gap is re-verified in pure Python bignum ints.  The table entry
    is exact as a rational; the TRUE ordinate differs from it by at most
    EPS = 3e-9 (Odlyzko's stated accuracy for this table), so a quadruple
    linear form delta = g1+g2-g3-g4 satisfies
        |delta_true - delta_table| <= 4 * EPS = 1.2e-8;
    we use the conservative RES = 1.4e-8 = 4*(3e-9 + 5e-10), adding a
    4*5e-10 allowance in case the entries are only correctly *rounded* to 9
    decimals.  For each cutoff H we report the minimal table |delta| over
    OFF-DIAGONAL quadruples (distinct index multisets {i,j} != {k,l}), the
    quadruple achieving it, the Poisson expectation R/P^2, and whether the
    minimum is resolvable (> 2*RES).  delta0(H) := min - RES is then a
    *certified* spacing floor: data precision enters the final theorem as
    this explicit parameter.  Any candidate near-relation below ~2e-9 is
    UNRESOLVABLE from this table and would require certified zero
    computations (Turing-method verification a la Platt) to decide.

PART B -- explicit variance bound  |V(u0,L) - D| <= err(L)  under RH.
    V(u0,L) = sum_q W12 conj(W34) e^{i delta u0} sinc^2(L delta/2)   (D.1),
    D = multiset-diagonal = sum_p |W_p|^2 (2 - [g1=g2]).  Since sinc^2 >= 0 and
    |e^{i delta u0}| = 1,  |V - D| <= sum_{off-diag} |W12 W34| sinc^2(L d/2).
    The off-diagonal quadruples are split by pair sums s12, s34:

    core  (both <= 300)     : exact weights, exact sinc^2 double sum (direct).
    mid   (both <= 1e4)     : exact weights; dyadic/Abel bound from the exactly
                              computed energy profile E^o(delta).
    far   (1e4 < s <= S*)   : all four zeros still inside the 100k table
                              (S* = 74920.83 + gamma_1 = 74935.0); bounded by
                              [pair count in coarse bins, EXACT from the table]
                              x Phi(s12) Phi(s34) x N(s12+d) x [max zeros in a
                              window of length 2d, EXACT from the table].
                              No S(t) allowance enters: the table is complete
                              (RH verified far beyond this height).
    out   (some s > S*)     : same shape, with Riemann-von Mangoldt + Trudgian
                              |S(t)| <= 0.112 log t + 0.278 loglog t + 2.510
                              replacing the exact counts; this is where the
                              irreducible O(log) window-count allowance lives.
    cross ((++) vs (--))    : |delta| >= 4 gamma_1, bounded by C0^2 sinc^2.
    opp   (any (+,-) pair)  : total opposite-sign mass sum|W| <= 1.3e-18
                              (|W(g,-g')| <= pi e^{-pi min(g,g')} decaying in
                              |g-g'| like |g-g'|^{-5/2}), so < 1e-17 in all.

    Weight majorant (Lemma 1 of DCLOSE.md, proved from
    |Gamma(1/2+ig)|^2 = pi/cosh(pi g), |Gamma(3+is)|^2 = (4+s^2)(1+s^2)
    * pi s/sinh(pi s)):  same-sign |W| <= sqrt(2 pi) s^{-5/2}, verified here
    against the exact weights.

    Dyadic/Abel machinery: with M(d) any monotone upper bound for the
    off-diagonal mass at resolution d and f(d) = min(1, (2/(L d))^2) >= sinc^2,
    levels d_k = 2^k / L,
        sum ub sinc^2 <= M(d_0)(1 - f_0) + sum_k M(d_k)(f_{k-1} - f_k)
                          + M_tot f_K .

OUTPUTS: the certified floors delta0(H); the in-table exact-relation mass at
resolution RES (the "unresolvable" mass); the component and total error
err(L) at L = log 1e6, 1e8, 1e10, 1e12; the L -> infinity floor; and the
final explicit statement  V = D (1 + theta err/D).

Runtime ~2-3 min, peak ~1.2 GB.  python3 code/exp21_dclose.py from code/.
"""
import time
import numpy as np
from pathlib import Path
from scipy.signal import fftconvolve
from scipy.special import loggamma
from pairfield import load_zeros, DATA


def load_zeros_exact_nano():
    """Parse the 9-decimal table entries as exact integers in nano-units.
    String processing only: '14.134725142' -> 14134725142.  No float touches
    the load-bearing path of Part A."""
    out = []
    with open(DATA / "odlyzko_zeros_100k.txt") as fh:
        for line in fh:
            tok = line.strip()
            if not tok:
                continue
            ip, _, fp = tok.partition(".")
            fp = (fp + "000000000")[:9]
            assert len(fp) == 9 and fp.isdigit() and ip.isdigit(), tok
            out.append(int(ip) * NANO + int(fp))
    return np.array(out, dtype=np.int64)

NANO = 10 ** 9
RES_NANO = 14          # 4*(3e-9 data + 5e-10 rounding) in nano-units
SMID = 1.0e4           # exact-quadruple region: pair sums <= SMID
SCORE = 300.0          # core region (matches exp16 / ENERGY.md)
H_LIST = [300, 500, 1000, 2000, 5000, 10000]
COARSE = 64            # coarse bin width for RvM counting (amortizes S(t))
MGRID = 10 ** 7        # grid extent for tail sums
SQ2PI = float(np.sqrt(2 * np.pi))
TWOPI = 2 * np.pi
B_OPP = 1e-17          # total opposite-sign quadruple mass (Lemma 1)
LS = {"1e6": np.log(1e6), "1e8": np.log(1e8),
      "1e10": np.log(1e10), "1e12": np.log(1e12)}


def R_S(t):
    """Trudgian (2014): |N(t) - t/2pi log(t/2pi e) - 7/8| <= R_S(t), t >= e."""
    t = np.asarray(t, dtype=float)
    return 0.112 * np.log(t) + 0.278 * np.log(np.log(t)) + 2.510


def N_main(t):
    t = np.asarray(t, dtype=float)
    return t / TWOPI * np.log(t / (TWOPI * np.e)) + 0.875


def Phi(s):
    """Same-sign majorant |W| <= sqrt(2 pi) s^{-5/2} (Lemma 1)."""
    return SQ2PI * np.maximum(np.asarray(s, dtype=float), 28.269450) ** -2.5


def w_exact(s):
    """|W| for a same-sign pair with sum s = g + g', exactly:
    log|W| = log pi - (lc(g)+lc(g'))/2 - log((4+s^2)(1+s^2) pi s)/2 + ls(s)/2
    with lc = log cosh(pi .), ls = log sinh(pi .).  The exponentially large
    parts cancel algebraically; the residual corrections log1p(e^{-2 pi g})
    are < 1e-38 for g >= gamma_1 and underflow to 0, so |W| is a function of
    s alone to that accuracy."""
    s = np.asarray(s, dtype=float)
    B = np.log1p(-np.exp(-TWOPI * s))          # = 0.0 in float64 here
    logw = (np.log(np.pi) + 0.5 * np.log(2.0) + 0.5 * B
            - 0.5 * np.log((4 + s * s) * (1 + s * s) * np.pi * s))
    return np.exp(logw)


def main():
    t0 = time.time()
    g = load_zeros()
    G1 = float(g[0])
    T_TAB = float(g[-1])
    SSTAR = T_TAB + G1
    gnano = load_zeros_exact_nano()
    assert len(gnano) == len(g)
    assert int(np.abs(gnano - np.rint(g * NANO).astype(np.int64)).max()) == 0
    n10 = int(np.searchsorted(g, SMID, side="right"))
    print(f"zeros: {len(g)}, last = {T_TAB:.9f}, S* = {SSTAR:.6f}; "
          f"n(<=1e4) = {n10}")

    # -- validation of w_exact against loggamma on the core zeros ----------
    nzc = int(np.searchsorted(g, SCORE - G1, side="right"))
    rho = 0.5 + 1j * g[:nzc]
    LG = loggamma(rho)
    Sm = g[:nzc, None] + g[None, :nzc]
    Wm = np.exp(np.real(LG[:, None] + LG[None, :]
                        - loggamma(rho[:, None] + rho[None, :] + 2)))
    rel = np.abs(w_exact(Sm) / Wm - 1).max()
    assert rel < 1e-10, rel
    print(f"w_exact vs loggamma: max rel dev {rel:.2e}  [OK]")

    # -- build all pairs i <= j with s <= 1e4 ------------------------------
    SI_l, SF_l, U_l, DIA_l = [], [], [], []
    for i in range(n10):
        jm = int(np.searchsorted(g, SMID - g[i], side="right"))
        if jm <= i:
            break
        sf = g[i] + g[i:jm]
        u = 2.0 * w_exact(sf)
        u[0] *= 0.5                      # j = i diagonal-pair entry
        SI_l.append(gnano[i] + gnano[i:jm])
        SF_l.append(sf)
        U_l.append(u)
        d = np.zeros(jm - i, dtype=bool)
        d[0] = True
        DIA_l.append(d)
    SI = np.concatenate(SI_l)
    SF = np.concatenate(SF_l)
    U = np.concatenate(U_l)
    DIA = np.concatenate(DIA_l)
    del SI_l, SF_l, U_l, DIA_l
    order = np.argsort(SI, kind="stable")
    SI, SF, U, DIA = SI[order], SF[order], U[order], DIA[order]
    del order
    npairs = len(SI)
    ratio = float((U / (2 - DIA) / Phi(SF)).max())
    assert ratio <= 1.0 + 1e-12, ratio
    print(f"pairs (i<=j, s<=1e4): {npairs}  [{time.time()-t0:.0f}s]; "
          f"max |W|/Phi = {ratio:.4f}  [Lemma 1 OK]")

    # ===================== PART A: exact spacing floors ===================
    print("\n" + "=" * 78)
    print("PART A: minimal off-diagonal |g1+g2-g3-g4|, exact integer "
          "arithmetic (units 1e-9)")
    print("=" * 78)

    def find_pair(v):
        rem = v - gnano[:n10]
        pos = np.clip(np.searchsorted(gnano[:n10], rem), 0, n10 - 1)
        ok = np.where(gnano[pos] == rem)[0]
        i = int(ok[0])
        return i, int(pos[i])

    floors = {}
    print(f"  {'H':>6} {'#sums':>9} {'min |delta|':>13} {'Poisson E[min]':>14}"
          f" {'#<RES':>6}  resolvable?")
    for H in H_LIST:
        k = int(np.searchsorted(SI, H * NANO, side="right"))
        d = np.diff(SI[:k])
        dpos = d[d > 0]
        dmin = int(dpos.min())
        nbelow = int((d < RES_NANO).sum())
        idx = int(np.where(d == dmin)[0][0])
        v1, v2 = int(SI[idx]), int(SI[idx + 1])
        pois = (SI[k - 1] - SI[0]) / 1e9 / k ** 2
        res = "YES" if dmin > 2 * RES_NANO else "NO (< data precision)"
        floors[H] = (dmin, v1, v2, k)
        print(f"  {H:>6} {k:>9} {dmin/1e9:>13.9f} {pois:>14.3e} {nbelow:>6}"
              f"  {res}")
    for H in (300, 1000):
        dmin, v1, v2, k = floors[H]
        (i1, j1), (i2, j2) = find_pair(v1), find_pair(v2)
        # pure-Python bignum re-verification of the achieved gap (V2.5)
        gg = [int(x) for x in (gnano[i1], gnano[j1], gnano[i2], gnano[j2])]
        assert gg[0] + gg[1] - gg[2] - gg[3] == -dmin
        assert sorted(gg[:2]) != sorted(gg[2:])
        print(f"  H={H}: min gap {dmin} nano between "
              f"g[{i1+1}]+g[{j1+1}] = {v1/1e9:.9f} and "
              f"g[{i2+1}]+g[{j2+1}] = {v2/1e9:.9f}")
        print(f"        ({g[i1]:.9f} + {g[j1]:.9f}) vs "
              f"({g[i2]:.9f} + {g[j2]:.9f})   [int-verified]")

    # full pure-Python re-verification of the H=300 floor (small enough)
    k300 = floors[300][3]
    py_sums = sorted(int(x) for x in SI[:k300])
    py_gaps = [b - a for a, b in zip(py_sums, py_sums[1:]) if b > a]
    assert min(py_gaps) == floors[300][0]
    print(f"  H=300 floor re-verified over {k300} sums in pure Python ints: "
          f"min positive gap = {min(py_gaps)} nano  [V2.5]")
    d0_300 = floors[300][0] / 1e9 - RES_NANO / 1e9
    print(f"  certified floor delta0(300) = {floors[300][0]}e-9 - 1.4e-8 = "
          f"{d0_300:.4e}")

    # unresolvable in-table mass at resolution RES (all pair sums <= 1e4)
    cw = np.concatenate([[0.0], np.cumsum(U)])
    lo = np.searchsorted(SI, SI - RES_NANO, side="left")
    hi = np.searchsorted(SI, SI + RES_NANO, side="right")
    sum_u2 = float((U * U).sum())
    Eo_res = float((U * (cw[hi] - cw[lo])).sum()) - sum_u2
    n_res = int((hi - lo - 1).sum())
    print(f"  in-table (s<=1e4) off-diag mass within RES = 1.4e-8: "
          f"{Eo_res:.3e}  ({n_res} ordered near-pairs)")
    del SI, cw, lo, hi

    # ===================== PART B: the variance bound =====================
    print("\n" + "=" * 78)
    print("PART B: explicit |V - D| bound under RH")
    print("=" * 78)

    # --- exact energy machinery on U (all pairs s <= 1e4) -----------------
    D_U = sum_u2                        # multiset-diagonal mass, exact weights
    C_U = float(U.sum())                # ordered sum |W| over s <= 1e4
    kc = int(np.searchsorted(SF, SCORE, side="right"))
    SFc, Uc = SF[:kc].copy(), U[:kc].copy()
    sum_u2_core = float((Uc * Uc).sum())
    sumw2_ord_core = float((Uc * Uc * 0.5 * (1 + DIA[:kc])).sum())
    cwc = np.concatenate([[0.0], np.cumsum(Uc)])

    def Eo_core(dd):
        loc = np.searchsorted(SFc, SFc - dd, side="left")
        hic = np.searchsorted(SFc, SFc + dd, side="right")
        return float((Uc * (cwc[hic] - cwc[loc])).sum()) - sum_u2_core

    DSTAR = 1.0 / np.log(1e6)
    print(f"core (s<=300): pairs(i<=j) {kc}, sum|W|^2(ordered) = "
          f"{sumw2_ord_core:.4e}, diag = {sum_u2_core:.4e}, "
          f"E^o(delta*) = {Eo_core(DSTAR):.3e}   [exp16: 1.7268e-6, "
          f"3.0180e-6, 6.354e-7]")

    # binned upper-bound profile over all of U
    h = 1e-3
    b0 = float(SF[0])
    idx = ((SF - b0) / h).astype(np.int64)
    nb = int(idx.max()) + 1
    bw = np.bincount(idx, weights=U, minlength=nb)
    P = np.concatenate([[0.0], np.cumsum(bw)])
    bar = np.arange(nb)
    del idx

    def G_ub(dd):
        r = int(np.ceil(dd / h)) + 1
        hiP = P[np.minimum(bar + r + 1, nb)]
        loP = P[np.maximum(bar - r, 0)]
        return float((bw * (hiP - loP)).sum())

    def Eo_U_ub(dd):
        return G_ub(dd) - D_U

    def Eo_mid_ub(dd):
        return max(0.0, Eo_U_ub(dd) - Eo_core(dd))

    # exact (unbinned) reference evaluations over all of U
    cwU = np.concatenate([[0.0], np.cumsum(U)])

    def Eo_U_exact(dd):
        loU = np.searchsorted(SF, SF - dd, side="left")
        hiU = np.searchsorted(SF, SF + dd, side="right")
        return float((U * (cwU[hiU] - cwU[loU])).sum()) - D_U

    e_star = Eo_U_exact(DSTAR)
    print(f"D(class, s<=1e4) = {D_U:.6e};  E^o_U(delta*)/D = "
          f"{e_star/D_U:.4f} exact, <= {Eo_U_ub(DSTAR)/D_U:.4f} binned "
          f"  [exp16 core 0.2105, extrapolated ~0.30]")
    for dd in (0.01, DSTAR):
        print(f"  linear law: E^o_U({dd:.4f})/(D*delta) = "
              f"{Eo_U_exact(dd)/D_U/dd:.2f} exact   [core-only, ENERGY.md: "
              f"~2.8]")
    del cwU

    # --- coarse-bin counting grids (exact in table, RvM+Trudgian beyond) --
    kfull = int(74880 // COARSE)               # bins fully inside the table
    nco = MGRID // COARSE
    cb = np.zeros(nco)
    cb_ex = np.bincount((g // COARSE).astype(int), minlength=kfull)[:kfull]
    cb[:kfull] = cb_ex
    edges_l = COARSE * np.arange(kfull, nco).astype(float)
    cb[kfull:] = (N_main(edges_l + COARSE) + R_S(edges_l + COARSE)
                  - np.maximum(N_main(edges_l) - R_S(edges_l), 0.0))
    # sanity: RvM coarse bound dominates the exact counts on the table
    chk = (N_main(COARSE * np.arange(1, kfull + 1).astype(float))
           + R_S(COARSE * np.arange(1, kfull + 1).astype(float))
           - np.maximum(N_main(np.maximum(COARSE
                        * np.arange(kfull).astype(float), 28.0))
                        - R_S(np.maximum(COARSE
                              * np.arange(kfull).astype(float), 28.0)), 0.0))
    bad = int((cb_ex[1:] > chk[1:] + 1e-9).sum())
    assert bad == 0, bad
    print(f"coarse grid: {nco} bins of width {COARSE}; table-exact "
          f"<= RvM+Trudgian on all {kfull} table bins  [OK]")

    conv = fftconvolve(cb, cb)[:nco]
    pcb = conv + np.concatenate([[0.0], conv[:-1]])
    pcb = pcb * (1 + 1e-9) + 1e-6              # FFT roundoff safety
    mgrid = COARSE * np.arange(nco).astype(float)

    # analytic remainders beyond MGRID (nu(m) <= 0.85 log m for m >= 1e7):
    lM = np.log(MGRID)
    T_AN = 0.145 * 2 * lM ** 2 / np.sqrt(MGRID)          # sum_{s>1e7} pc*Phi
    kmid = int(SMID // COARSE) - 1
    kstar = int(SSTAR // COARSE) - 1
    T_far = float((pcb[kmid:] * Phi(mgrid[kmid:])).sum()) + T_AN
    T_out = float((pcb[kstar:] * Phi(mgrid[kstar:])).sum()) + T_AN
    C0ub = C_U + T_far
    Dtail = 2 * float((pcb[kmid:] * Phi(mgrid[kmid:]) ** 2).sum()) + 1e-15
    print(f"C0(class) <= {C0ub:.4e};  tail sums T(1e4) = {T_far:.3e}, "
          f"T(S*) = {T_out:.3e};  D-tail (s>1e4) <= {Dtail:.2e}")

    # exact window counts from the table
    g_min = float(np.diff(g).min())
    wc_cache = {}

    def wcount(ell):
        key = round(ell, 9)
        if key not in wc_cache:
            c = np.searchsorted(g, g + ell, side="right") - np.arange(len(g))
            wc_cache[key] = int(c.max())
        return wc_cache[key]

    print(f"min zero gap in table = {g_min:.6f}; max zeros in window of "
          f"length 0.145 = {wcount(0.145)}, length 2 = {wcount(2.0)}")

    def N_upper(t):
        t = np.asarray(t, dtype=float)
        out = np.empty_like(t)
        intab = t <= T_TAB
        out[intab] = np.searchsorted(g, t[intab], side="right")
        tt = np.maximum(t[~intab], 29.0)
        out[~intab] = N_main(tt) + R_S(tt)
        return out

    cap_far = T_far * C0ub
    cap_out = T_out * C0ub
    # for the (++) x (--) cross bound: sinc^2(L(sp+sq)/2) <= 4/(L(sp+sq))^2
    # <= 1/(L^2 sp sq), so  sum <= (2/L^2) (sum_p w_p/s_p)^2  (2 = both orders)
    Winv = float((U / SF).sum()) + float(
        (pcb[kmid:] * Phi(mgrid[kmid:]) / np.maximum(mgrid[kmid:], 1.0)).sum()
    ) + T_AN / MGRID

    def E_far(dd):
        """Anchored bound: pairs (1,2) with s12 > 1e4 - dd, partner pair in
        the table; window count on gamma_4 is exact from the table."""
        mlo = max(0, int((SMID - dd) // COARSE) - 1)
        ms = mgrid[mlo:kstar + 2]
        terms = (pcb[mlo:kstar + 2] * Phi(ms)
                 * N_upper(ms + COARSE + dd)
                 * Phi(np.maximum(ms - dd, 28.27))
                 * wcount(2 * dd))
        return min(float(terms.sum()), cap_far)

    def E_out(dd):
        """Anchored bound: s12 > S* - dd; gamma_4 window counted by RvM +
        Trudgian: nw <= (dd/pi) log((sigma+dd)/2pi) + 2 R_S(sigma+dd)."""
        mlo = max(0, int((SSTAR - dd) // COARSE) - 1)
        ms = mgrid[mlo:]
        t4 = ms + COARSE + 2 * dd
        nw = dd / np.pi * np.log(np.maximum(t4, 29.0) / TWOPI) + 2 * R_S(
            np.maximum(t4, 29.0))
        terms = (pcb[mlo:] * Phi(ms) * N_upper(ms + COARSE + dd)
                 * Phi(np.maximum(ms - dd, 28.27)) * nw)
        r_an = 3.8e-11 * (dd / np.pi + 0.8)     # m > 1e7 remainder
        return min(float(terms.sum()) + r_an, cap_out)

    # --- Abel/dyadic assembly --------------------------------------------
    def abel(Efun, Mtot, L, ds):
        M = np.maximum.accumulate(np.maximum([Efun(d) for d in ds], 0.0))
        f = np.minimum(1.0, (2.0 / (L * ds)) ** 2)
        Mtot = max(Mtot, M[-1])
        return float(M[0] * (1 - f[0]) + (M[1:] * -np.diff(f)).sum()
                     + Mtot * f[-1])

    def B_core_exact(L):
        tot = 0.0
        for a in range(0, kc, 512):
            Dm = SFc[a:a + 512, None] - SFc[None, :]
            K = np.sinc(L * Dm / TWOPI) ** 2
            tot += float(Uc[a:a + 512] @ (K @ Uc))
        return tot - sum_u2_core

    Mtot_mid = C_U ** 2 - D_U
    print(f"\n  {'L':>7} {'X':>6} {'B_core':>10} {'B_mid':>10} {'B_far':>10}"
          f" {'B_out':>10} {'B_cross':>10} {'err(class)':>11} {'err_V/D_V':>10}")
    results = {}
    for name, L in LS.items():
        K = int(np.ceil(4 * np.log2(3e4 * L))) + 1     # levels at ratio 2^1/4
        ds = (1.0 / L) * 2.0 ** (0.25 * np.arange(K + 1))
        bc = B_core_exact(L)
        bm = abel(Eo_mid_ub, Mtot_mid, L, ds)
        bf = abel(E_far, cap_far, L, ds)
        bo = abel(E_out, cap_out, L, ds)
        bx = 2 * Winv ** 2 / L ** 2
        err_class = bc + bm + bf + bo
        err_V = 2 * err_class + bx + B_OPP + 2 * Dtail
        D_V = 2 * D_U
        results[name] = (err_V, D_V)
        print(f"  {L:>7.3f} {name:>6} {bc:>10.3e} {bm:>10.3e} {bf:>10.3e}"
              f" {bo:>10.3e} {bx:>10.3e} {err_class:>11.3e}"
              f" {err_V/D_V:>10.4f}")

    # --- certified linear law: E^o_class(eta) <= eps0 + c_cert eta D ------
    etas = np.geomspace(1e-4, 0.1, 41)
    c_cert = max(Eo_U_ub(etas[j + 1]) / (etas[j] * D_U)
                 for j in range(len(etas) - 1))
    efar01, eout01 = E_far(0.1), E_out(0.1)
    eps0 = Eo_U_ub(1e-4) + efar01 + eout01
    print(f"\ncertified near-diagonal law (per class), 0 <= eta <= 0.1:")
    print(f"  E^o_U(eta) <= {c_cert:.2f} * eta * D   (binned grid, ratio "
          f"2^(1/8), slop included)")
    print(f"  E^o_far(eta) <= E_far(0.1) = {efar01:.3e}, E^o_out(eta) <= "
          f"E_out(0.1) = {eout01:.3e}")
    print(f"  => E^o_class(eta) <= {c_cert:.2f} eta D + {efar01+eout01:.3e}"
          f" (+ {Eo_U_ub(1e-4):.2e} for eta < 1e-4)")

    # --- the L -> infinity floor -----------------------------------------
    dres = RES_NANO / 1e9
    floor_class = Eo_res + E_far(dres) + E_out(dres)
    D_V = 2 * D_U
    floor_V = 2 * floor_class + B_OPP
    print(f"\nL->inf floor (irreducible, this data): per class "
          f"{floor_class:.3e} = [unresolved {Eo_res:.1e}] + "
          f"[far {E_far(dres):.3e}] + [out {E_out(dres):.3e}]")
    print(f"  floor_V / D_V = {floor_V/D_V:.4f}")

    print("\n" + "=" * 78)
    print("FINAL STATEMENT (under RH; zeros table complete to T = 74920.83)")
    print("=" * 78)
    print(f"  D_V = 2 sum_class |W|^2-diagonal = {D_V:.6e}  "
          f"(+ tail <= {2*Dtail:.1e})")
    print(f"  sqrt(D_V) = {np.sqrt(D_V):.6f}   [Parseval RMS 0.0025, D.5]")
    for name, (err_V, DV) in results.items():
        print(f"  X = {name}: V = D_V (1 + theta_X {err_V/DV:.3f}), "
              f"|theta| <= 1")
    print(f"  L -> inf: |V - D_V| <= {floor_V:.3e} = {floor_V/D_V:.4f} D_V")
    b_lin = (results["1e6"][0] / D_V - floor_V / D_V) * LS["1e6"]
    print(f"  representation err_V/D_V ~ {floor_V/D_V:.4f} + {b_lin:.1f}/L; "
          f"check at other L: "
          + ", ".join(f"{name}: {floor_V/D_V + b_lin/L:.3f} vs "
                      f"{results[name][0]/D_V:.3f}"
                      for name, L in list(LS.items())[1:]))
    print(f"  certified spacing floor delta0(300) = {d0_300:.4e}; "
          f"min gap at H=300 = {floors[300][0]}e-9")
    print(f"\ntotal {time.time()-t0:.0f}s")


if __name__ == "__main__":
    main()
