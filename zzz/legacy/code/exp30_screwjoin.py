"""Experiment 30: INDEPENDENT CROSS-CHECK AND STRESS TEST OF THEOREM J
(= exp23 on branch claude/repo-catchup-math-tgs5hx, commit 0f53a20:
"the Matsumoto-Suzuki screw function IS the mixed block").

Their claim, in this repo's language.  Split Lambda = Lambda#_Q + Lambda-flat
(BC conditional expectation, Lambda#_Q = sum_{q<=Q} mu(q)/phi(q) c_q) and
decompose the Matsumoto-Suzuki reweighted Goldbach summatory [MS (1.6)]
    T(X) = sum_{n<=X} (Lambda*Lambda)(n) / n^2
into blocks [##] + [mix] + [bb].  Theorem J asserts
    [##](T)  = log X + c2           (smooth, spectrally dead),
    [mix](T) = 2 sum_rho X^{rho-1}/(rho(1-rho))  ( = 2e^{-t/2}(g_H1+H1(1)) ),
    [bb](T)  = E(X)-side, subleading,
i.e. the MS screw function g_H1 (Krein masses 1/(gamma^2+1/4) on single
zeros) is an explicit transform of the MIXED (pole x zero, first-variation)
block.

This experiment is the independent verification path, built without reusing
exp23's code (own Lambda#, own convolutions, own grids), plus the stress
tests exp23 lacks:

  A. reproduction on their grid: closure, band corr/ratio, [##] fit;
  B. per-zero mass extraction: matched-filter LSQ at the first 10 zero
     frequencies gives each Krein mass individually; the per-line PHASE
     discriminates the symmetrized denominator rho(1-rho) (phase 0) from
     Fujii's unsymmetrized rho(rho+1) (phase ~ pi - 2/gamma), i.e. tests
     that the n^{-2} reweighting -- not fiat -- produces the symmetrization;
  C. the c2 ledger: raw (un-bandpassed) block constants vs Q, their sum vs
     the full-T constant; adjudicates exp23's "c2 = 5.1407 measured from the
     BC block" against the sibling's fitted c2 = -2.280 [SCREW.md Part 5].
     Analytic anchor: at Q=1, Lambda# = 1 and c_## = gamma_E - zeta(2)
     = -1.0677 exactly;
  D. controls: zero-jitter and random-frequency nulls (is the band match
     real or a bandpass artifact?), Q-ablation, pair-band exclusion (the
     chirped pair sector must NOT enter [mix]);
  E. audit of exp27 ("the profinite scheme runs", commit 7804143):
     (i) with a UNIFORM linear extraction the sum of block constants equals
     the total's constant to machine precision -- the "scheme invariance to
     1e-4" is closure + linearity (a tautology); the 1e-4 scatter in exp27
     is method mismatch (LSQ intercept for [##] vs plain means for the
     rest), not structure; (ii) the nontrivial content is the RUNNING LAW:
     the [##] constant grows ~ a log^2 Q (their a = 0.362), driven by the
     small-n spikes Lambda#_Q(1) = sum_{q<=Q} mu^2(q)/phi(q) ~ log Q --
     both re-measured here; divergence as Q -> infinity means no Q -> inf
     canonical subtraction exists, supporting exp27's conclusion.

Derivation being tested (independent; see notes/CROSSREVIEW_THMJ.md):
partial summation int_1^X y^{-2} d[-2 y^{rho+1}/(rho(rho+1))]
= 2(X^{rho-1} - 1)/(rho(1-rho)); the exponent -2 is the UNIQUE reweighting
n^{-alpha} making the resulting masses rho <-> 1-rho symmetric, hence real
on the critical line, hence Krein-eligible.  The derivation predicts an
OSCILLATORY-sector identity only: each block also carries a Q-dependent
smooth part (constants + drift) that no zero sum reproduces.

Figure: ../figures/exp30_screwjoin.png
"""
import numpy as np
import matplotlib
matplotlib.use("Agg")
import matplotlib.pyplot as plt
from pathlib import Path
from scipy.special import loggamma
from pairfield import sieve_lambda, load_zeros

FIG = Path(__file__).resolve().parent.parent / "figures"

NMAX = 2_000_000
M = 8192
# grid identical to exp23 (reproduction) ...
LOGX = np.linspace(np.log(2e4), np.log(1.9e6), M)
# ... and a wider grid for per-line extraction (more beat periods)
LOGX_W = np.linspace(np.log(5e3), np.log(1.9e6), M)

EULER_GAMMA = 0.5772156649015329


# ------------------------------------------------- independent block machinery
def mobius_phi(N):
    mu = np.ones(N + 1, dtype=np.int64)
    phi = np.arange(N + 1, dtype=np.int64)
    comp = np.zeros(N + 1, dtype=bool)
    for p in range(2, N + 1):
        if not comp[p]:
            comp[p * p:: p] = True
            mu[p::p] *= -1
            mu[p * p:: p * p] = 0
            phi[p::p] -= phi[p::p] // p
    return mu, phi


def ramanujan_c(q, n_max, mu):
    """c_q(n) for n = 0..n_max, via c_q(n) = sum_{d | q, d | n} d mu(q/d)."""
    out = np.zeros(n_max + 1)
    for d in range(1, q + 1):
        if q % d == 0 and mu[q // d] != 0:
            out[::d] += d * mu[q // d]
    return out


def lambda_sharp(Q, mu, phi, n_max):
    out = np.zeros(n_max + 1)
    for q in range(1, Q + 1):
        if mu[q] != 0:
            out += (mu[q] / phi[q]) * ramanujan_c(q, n_max, mu)
    out[0] = 0.0
    return out


def cross_conv(a, b):
    """sum_{m+n=N} a_m b_n, N = 0..2*len-2, via FFT."""
    L = 1
    while L < 2 * len(a):
        L *= 2
    return np.fft.irfft(np.fft.rfft(a, L) * np.fft.rfft(b, L), L)[: 2 * len(a) - 1]


def T_of(r, logx):
    """T(X) = sum_{n<=X} r(n)/n^2 sampled at X = exp(logx)."""
    n = np.arange(len(r), dtype=float)
    n[0] = 1.0
    c = np.cumsum(r / n**2)
    return c[np.exp(logx).astype(int)]


# --------------------------------------------------------------- zero models
def screw_kernel(gam, logx, denom="sym"):
    """2 sum_rho X^{rho-1}/D(rho); D = rho(1-rho) ('sym') or rho(rho+1) ('fujii')."""
    rho = 0.5 + 1j * gam
    c = 1.0 / (rho * (1 - rho)) if denom == "sym" else 1.0 / (rho * (rho + 1))
    out = np.zeros(len(logx))
    for ch in range(0, len(gam), 2000):
        out += 2 * np.real(np.exp(np.outer(logx, rho[ch:ch + 2000] - 1))
                           @ c[ch:ch + 2000])
    return 2 * out  # overall factor 2 of MS (1.6); inner 2Re folds conjugates


def bb_model(gam, logx, K2=60, smax=80.0):
    """Reweighted pair layer of [bb](T):
    sum_{rho,rho'} W0 * s/(s-2) * X^{s-2},  s = rho+rho',
    W0 = Gamma(rho)Gamma(rho')/Gamma(rho+rho'+1)   (k=0 pair weights).
    k=0 pair sums are NOT absolutely convergent -- truncation-sensitive,
    reported as such."""
    g = gam[:K2]
    rho = 0.5 + 1j * np.concatenate([g, -g])
    LG = loggamma(rho)
    s = (rho[:, None] + rho[None, :]).ravel()
    W0 = np.exp((LG[:, None] + LG[None, :]).ravel() - loggamma(s + 1))
    coef = W0 * s / (s - 2)
    keep = np.abs(s.imag) <= smax
    s, coef = s[keep], coef[keep]
    out = np.zeros(len(logx))
    for ch in range(0, len(s), 2000):
        out += np.real(np.exp(np.outer(logx, s[ch:ch + 2000] - 2))
                       @ coef[ch:ch + 2000])
    return out


def detrend(y, logx, deg=3):
    return y - np.polyval(np.polyfit(logx, y, deg), logx)


def bandpass(y, logx, lo, hi, deg=3):
    Y = np.fft.rfft(detrend(y, logx, deg))
    f = np.fft.rfftfreq(len(y), d=(logx[1] - logx[0])) * 2 * np.pi
    Y[(f < lo) | (f > hi)] = 0
    return np.fft.irfft(Y, len(y))


CORE = slice(M // 8, -M // 8)


def band_stats(y, model, logx, lo, hi):
    by, bm = bandpass(y, logx, lo, hi), bandpass(model, logx, lo, hi)
    corr = np.corrcoef(by[CORE], bm[CORE])[0, 1]
    ratio = np.std(by[CORE]) / max(np.std(bm[CORE]), 1e-300)
    return corr, ratio


# ----------------------------------------------- per-line matched-filter LSQ
def extract_lines(y, logx, gams, lo=8.0, hi=50.0):
    """Complex amplitude of each e^{-t/2} (cos, sin)(gamma_j t) line in y(t).
    y is band-passed first (kills constants + smooth drift), then LSQ on the
    2J-column matched basis, itself band-passed identically (common-mode
    pipeline).  Returns c_j = a_j - i b_j."""
    z = bandpass(y, logx, lo, hi)
    env = np.exp(-logx / 2)
    cols = []
    for g in gams:
        cols += [env * np.cos(g * logx), env * np.sin(g * logx)]
    A = np.vstack(cols).T
    Ab = np.column_stack([bandpass(A[:, k], logx, lo, hi)
                          for k in range(A.shape[1])])
    sol, *_ = np.linalg.lstsq(Ab[CORE], z[CORE], rcond=None)
    return sol[0::2] - 1j * sol[1::2]


def main():
    rng = np.random.default_rng(30)
    gam = load_zeros()
    mu, phi = mobius_phi(130)
    lam = sieve_lambda(NMAX)

    # blocks for every Q used anywhere, computed once
    QS = [1, 5, 10, 30, 50, 120]
    blocks = {}
    for Qt in QS:
        lS = lambda_sharp(Qt, mu, phi, NMAX)
        lB = lam - lS
        lB[0] = 0.0
        blocks[Qt] = dict(
            T_SS=T_of(cross_conv(lS, lS), LOGX),
            T_mix=T_of(2 * cross_conv(lS, lB), LOGX),
            T_BB=T_of(cross_conv(lB, lB), LOGX),
        )
    T_tot = T_of(cross_conv(lam, lam), LOGX)
    Q0 = 30
    T_SS, T_mix, T_BB = (blocks[Q0][k] for k in ("T_SS", "T_mix", "T_BB"))

    print("=" * 78)
    print("PART A: reproduction of exp23 on its own grid (independent code path)")
    print("=" * 78)
    closure = np.max(np.abs(T_SS + T_mix + T_BB - T_tot) / np.abs(T_tot))
    print(f"closure max|[##]+[mix]+[bb]-T|/|T| = {closure:.2e}")

    K1 = 30_000
    model = screw_kernel(gam[:K1], LOGX)
    model_w = screw_kernel(gam[:K1], LOGX_W)

    SINGLE, WIDE, PAIRB = (10.0, 27.5), (8.0, 45.0), (28.5, 60.0)
    c1, a1 = band_stats(T_mix, model, LOGX, *SINGLE)
    cW, aW = band_stats(T_mix, model, LOGX, *WIDE)
    print(f"[mix](T) vs screw kernel  band {SINGLE}: corr = {c1:.4f}, ratio = {a1:.4f}"
          f"   (exp23: 1.0000, 0.9992)")
    print(f"[mix](T) vs screw kernel  band {WIDE}: corr = {cW:.4f}, ratio = {aW:.4f}")

    A2 = np.vstack([LOGX, np.ones(M)]).T
    sol, *_ = np.linalg.lstsq(A2, T_SS, rcond=None)
    slope, cSS = sol
    print(f"[##](T) = a logX + c:  a = {slope:.4f},  c = {cSS:.4f}  "
          f"(exp23 printed 1.0000, 5.1407)")
    print(f"[##] single-band RMS: {np.std(bandpass(T_SS, LOGX, *SINGLE)[CORE]):.2e}")

    # pair-band exclusion: [mix] in the pair band must still be SINGLE-zero
    c3, a3 = band_stats(T_mix, model, LOGX, *PAIRB)
    print(f"[mix](T) in pair band {PAIRB} vs single-zero screw model: "
          f"corr = {c3:.4f}, ratio = {a3:.4f}   <-- exclusion check")
    bbm = bb_model(gam, LOGX)
    c4, a4 = band_stats(T_BB, bbm, LOGX, *PAIRB)
    print(f"[bb](T) RMS single band: {np.std(bandpass(T_BB, LOGX, *SINGLE)[CORE]):.2e}, "
          f"pair band: {np.std(bandpass(T_BB, LOGX, *PAIRB)[CORE]):.2e}")
    print(f"[bb](T) vs reweighted k=0 pair model, band {PAIRB}: "
          f"corr = {c4:.3f}, ratio = {a4:.3f}  (k=0 pair sum not abs. conv.; "
          f"truncation-limited)")

    print()
    print("=" * 78)
    print("PART B: per-zero Krein masses from the arithmetic mixed block")
    print("=" * 78)
    J = 10
    lS30 = lambda_sharp(30, mu, phi, NMAX)
    lB30 = lam - lS30
    lB30[0] = 0.0
    T_mix_w = T_of(2 * cross_conv(lS30, lB30), LOGX_W)
    cj_data = extract_lines(T_mix_w, LOGX_W, gam[:J])
    cj_model = extract_lines(model_w, LOGX_W, gam[:J])
    model_fuj = screw_kernel(gam[:K1], LOGX_W, denom="fujii")
    cj_fuj = extract_lines(model_fuj, LOGX_W, gam[:J])

    print("mass_j := |c_j(data)| (gamma_j^2+1/4)/4;  theory (MS Krein mass): 1")
    print(f"{'j':>3} {'gamma':>8} {'mass/theory':>12} {'phase':>8} "
          f"{'|data/model|':>13} {'phase':>8} | {'|data/Fujii|':>13} {'phase':>8}")
    theo = 4.0 / (gam[:J] ** 2 + 0.25)
    for j in range(J):
        r_md = cj_data[j] / cj_model[j]
        r_fj = cj_data[j] / cj_fuj[j]
        print(f"{j+1:>3} {gam[j]:>8.3f} {np.abs(cj_data[j])/theo[j]:>12.4f} "
              f"{np.angle(cj_data[j]):>+8.4f} {np.abs(r_md):>13.4f} "
              f"{np.angle(r_md):>+8.4f} | {np.abs(r_fj):>13.4f} "
              f"{np.angle(r_fj):>+8.4f}")
    print("(symmetrization test: data/Fujii phase should be ~ pi - 2/gamma = "
          + ", ".join(f"{np.pi - 2/g:+.3f}" for g in gam[:3]) + ", ...)")

    print()
    print("=" * 78)
    print("PART C: the c2 ledger -- raw block constants vs Q, and the MS constant")
    print("=" * 78)
    top = LOGX > np.log(2e5)
    resid_tot = T_tot - LOGX - model
    c2_tot = resid_tot[top].mean()
    print(f"c2(total) = mean[T - logX - screwmodel], X>2e5:  {c2_tot:+.4f}  "
          f"(drift {resid_tot[top].std():.5f})")
    print(f"  [sibling SCREW.md Part 5 fitted c2 = -2.280 with another basis]")
    print(f"  [analytic anchor: c_## at Q=1 must be gamma_E - zeta(2) = "
          f"{EULER_GAMMA - np.pi**2/6:+.4f}]")
    print(f"{'Q':>4} {'c_##':>9} {'c_mix':>9} {'c_bb':>9} {'sum':>9}")
    ctab = []
    for Qt in QS:
        b = blocks[Qt]
        cS = (b["T_SS"] - LOGX)[top].mean()
        cM = (b["T_mix"] - model)[top].mean()
        cB = b["T_BB"][top].mean()
        ctab.append([cS, cM, cB])
        print(f"{Qt:>4} {cS:>9.4f} {cM:>9.4f} {cB:>9.4f} {cS+cM+cB:>9.4f}")
    ctab = np.array(ctab)
    print("==> block constants are Q-dependent; only the SUM is the MS c2.")
    iQ30 = QS.index(30)
    print(f"exact-identity check at Q=30: raw [mix](T)(X=1e6) = "
          f"{T_mix[np.searchsorted(LOGX, np.log(1e6))]:+.4f} vs claimed "
          f"2e^(-t/2)(g_H1+H1(1)) = {model[np.searchsorted(LOGX, np.log(1e6))]:+.6f}"
          f"  -- differ by c_mix(30) = {ctab[iQ30,1]:+.4f}")

    print()
    print("=" * 78)
    print("PART D: controls")
    print("=" * 78)
    print(f"D1 jitter: corr([mix], screw model with gamma -> gamma+delta), band {WIDE}:")
    deltas = [0.0, 0.02, 0.05, 0.1, 0.2, 0.5]
    cors = []
    for d in deltas:
        cj_, aj_ = band_stats(T_mix, screw_kernel(gam[:K1] + d, LOGX), LOGX, *WIDE)
        cors.append(cj_)
        print(f"    delta = {d:4.2f}:  corr = {cj_:+.4f}   ratio = {aj_:.4f}")
    gr = np.sort(rng.uniform(10, 50, 200))
    cr, _ = band_stats(T_mix, screw_kernel(gr, LOGX), LOGX, *WIDE)
    print(f"    200 random frequencies in [10,50]:  corr = {cr:+.4f}")

    print("D2 Q-ablation: [mix](T) vs screw kernel, band (10,27.5):")
    for Qt in QS:
        cq, aq = band_stats(blocks[Qt]["T_mix"], model, LOGX, *SINGLE)
        print(f"    Q = {Qt:>3}:  corr = {cq:.4f},  ratio = {aq:.4f}")

    print()
    print("=" * 78)
    print("PART E: audit of exp27 (scheme running / invariance)")
    print("=" * 78)
    # E1: uniform linear extraction => machine-precision invariance (tautology)
    print("E1 uniform extraction (every block fit as a logX + c after removing")
    print("   its oscillatory model): sum of block (a, c) minus total's (a, c):")
    solT, *_ = np.linalg.lstsq(A2, T_tot - model, rcond=None)
    for Qt in [5, 30, 120]:
        b = blocks[Qt]
        sS, *_ = np.linalg.lstsq(A2, b["T_SS"], rcond=None)
        sM, *_ = np.linalg.lstsq(A2, b["T_mix"] - model, rcond=None)
        sB, *_ = np.linalg.lstsq(A2, b["T_BB"], rcond=None)
        d = sS + sM + sB - solT
        print(f"    Q = {Qt:>3}:  d_slope = {d[0]:+.2e},  d_const = {d[1]:+.2e}")
    print(f"   (total fit: slope = {solT[0]:.4f}, const = {solT[1]:.4f} = MS c2)")
    print("   ==> invariance of the SUM is exact by closure + linearity;")
    print("       exp27's 1e-4 scatter is LSQ-vs-mean extraction mismatch.")

    # E2: the running law and its mechanism
    lQ = np.log(np.array(QS[1:], dtype=float))          # Q >= 5
    cSS_run = ctab[1:, 0]
    co = np.polyfit(lQ, cSS_run, 2)
    print(f"E2 running law of c_## on Q in {QS[1:]}: "
          f"{co[0]:.3f} log^2 Q {co[1]:+.3f} log Q {co[2]:+.3f}  "
          f"(exp27: 0.362, +0.19, +0.33; rms here "
          f"{np.std(cSS_run - np.polyval(co, lQ)):.3f})")
    print("   spike mechanism  Lambda#_Q(1) = sum_(q<=Q) mu^2/phi  vs  log Q:")
    for Qt in [5, 30, 120]:
        spike = sum(mu[q] ** 2 / phi[q] for q in range(1, Qt + 1))
        print(f"    Q = {Qt:>3}:  Lambda#_Q(1) = {spike:.3f},   log Q = "
              f"{np.log(Qt):.3f}")
    print("   c_## grows ~ log^2 Q: block constants DIVERGE as Q -> inf;")
    print("   no Q->inf canonical subtraction -- fluctuation sector is the")
    print("   scheme-invariant content (supports exp27's conclusion).")

    # ---------------------------------------------------------------- figure
    fig, ax = plt.subplots(2, 2, figsize=(13.5, 9))

    a = ax[0, 0]
    XS = np.exp(LOGX)
    bd = bandpass(T_mix, LOGX, *WIDE) * np.sqrt(XS)
    bm = bandpass(model, LOGX, *WIDE) * np.sqrt(XS)
    a.plot(XS[CORE], bd[CORE], lw=0.6, label=r"$\sqrt{X}\,[\mathrm{mix}](T)$, band [8,45]")
    a.plot(XS[CORE], bm[CORE], lw=0.6, alpha=0.8,
           label=r"$\sqrt{X}\cdot2\sum_\rho X^{\rho-1}/(\rho(1-\rho))$")
    a.set_xscale("log")
    a.set_title(f"independent reproduction: corr {cW:.4f}, ratio {aW:.4f} (band [8,45])")
    a.legend(fontsize=8)

    a = ax[0, 1]
    jj = np.arange(1, J + 1)
    a.axhline(1.0, color="gray", lw=0.8)
    a.plot(jj, np.abs(cj_data) / theo, "o", color="navy",
           label=r"$|c_j|\,(\gamma_j^2+\frac{1}{4})/4$ (mass vs theory)")
    a.plot(jj, np.abs(cj_data / cj_model), "s", ms=4, color="seagreen",
           label="|data / model| (pipeline-calibrated)")
    a.plot(jj, np.angle(cj_data / cj_model), "x", color="crimson",
           label="phase of data/model (rad)")
    a.axhline(0.0, color="crimson", lw=0.5, ls=":")
    a.set_xlabel("zero index j")
    a.set_title("per-zero Krein masses $1/(\\gamma_j^2+1/4)$ from arithmetic mixed block")
    a.legend(fontsize=8)

    a = ax[1, 0]
    a.plot(deltas, cors, "o-", color="tab:red")
    a.axhline(cr, color="gray", ls="--", lw=0.8, label="random-frequency null")
    a.set_xlabel(r"zero jitter $\delta$")
    a.set_ylabel("corr in band [8,45]")
    a.set_title("the match dies at $\\delta\\sim$ 1/window: not a bandpass artifact")
    a.legend(fontsize=8)
    a.grid(alpha=0.3)

    a = ax[1, 1]
    w = 0.25
    xpos = np.arange(len(QS))
    for k, (lab, col) in enumerate([("$c_{\\sharp\\sharp}$", "tab:blue"),
                                    ("$c_{mix}$", "tab:orange"),
                                    ("$c_{\\flat\\flat}$", "tab:green")]):
        a.bar(xpos + (k - 1) * w, ctab[:, k], w, label=lab, color=col)
    a.plot(xpos, ctab.sum(1), "k*-", ms=10, label="sum = MS $c_2$")
    a.axhline(c2_tot, color="gray", ls="--", lw=0.8)
    a.set_xticks(xpos, [f"Q={q}" for q in QS])
    a.set_title("the c2 ledger: block constants move with Q, the sum does not")
    a.legend(fontsize=8)

    fig.tight_layout()
    FIG.mkdir(exist_ok=True)
    fig.savefig(FIG / "exp30_screwjoin.png", dpi=140)
    print("\nsaved figures/exp30_screwjoin.png")


if __name__ == "__main__":
    main()
