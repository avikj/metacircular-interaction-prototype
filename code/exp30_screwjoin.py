"""Experiment 30: INDEPENDENT CROSS-CHECK AND STRESS TEST OF THEOREM J
(= exp23 on branch claude/repo-catchup-math-tgs5hx, commit 0f53a20:
"the Matsumoto-Suzuki screw function IS the mixed block").

Their claim, in this repo's language.  Split Lambda = Lambda#_Q + Lambda-flat
(BC conditional expectation, Lambda#_Q = sum_{q<=Q} mu(q)/phi(q) c_q) and
decompose the Matsumoto-Suzuki reweighted Goldbach summatory [MS (1.6)]
    T(X) = sum_{n<=X} (Lambda*Lambda)(n) / n^2
into blocks [##] + [mix] + [bb].  Theorem J asserts
    [##](T)  = log X + const        (smooth, spectrally dead),
    [mix](T) = 2 sum_rho X^{rho-1}/(rho(1-rho)) + const + err
             = 2 e^{-t/2} (g_H1(t) + H1(1)) + const + err,   t = log X,
    [bb](T)  = E(X)-side, subleading,
i.e. the MS screw function g_H1 (Krein masses 1/(gamma^2+1/4) on single
zeros) is an explicit invertible transform of the MIXED (pole x zero,
first-variation) block.

This experiment is the independent verification path, built without reusing
exp23's code (own Lambda#, own convolutions, own grids), plus the stress
tests exp23 lacks:

  A. reproduction on their grid: closure, band corr/ratio, [##] fit;
  B. per-zero mass extraction: matched-filter LSQ at the first 10 zero
     frequencies gives each Krein mass individually; the per-line PHASE
     discriminates the symmetrized denominator rho(1-rho) (phase 0) from
     Fujii's unsymmetrized rho(rho+1) (phase ~ pi - 2/gamma), i.e. tests
     that the n^{-2} reweighting -- not fiat -- produces the symmetrization;
  C. the c2 ledger: per-block constants vs Q, their sum vs the full-T
     constant; adjudicates exp23's "c2 = 5.1407 measured from the BC block"
     against the sibling's fitted c2 = -2.280 [SCREW.md Part 5];
  D. controls: zero-jitter and random-frequency nulls (is the band match
     real or a bandpass artifact?), Q-ablation, pair-band exclusion (the
     chirped pair sector must NOT enter [mix]).

Derivation being tested (independent; see notes/CROSSREVIEW_THMJ.md):
partial summation int_1^X y^{-2} d[-2 y^{rho+1}/(rho(rho+1))]
= 2(X^{rho-1} - 1)/(rho(1-rho)); the exponent -2 is the UNIQUE reweighting
n^{-alpha} making the resulting masses rho <-> 1-rho symmetric, hence real
on the critical line, hence Krein-eligible.

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
    """c_q(n) for n = 0..n_max, via c_q = sum_{d|q} d mu(q/d) 1_{d|n}."""
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
    X1 = np.exp(logx)
    for ch in range(0, len(gam), 2000):
        out += 2 * np.real(np.exp(np.outer(logx, rho[ch:ch + 2000] - 1))
                           @ c[ch:ch + 2000])
    return 2 * out  # overall factor 2 of MS (1.6); inner 2Re folds conjugates


def bb_model(gam, logx, K2=60, smax=80.0):
    """Reweighted pair layer of [bb](T):
    sum_{rho,rho'} W0 * s/(s-2) * X^{s-2},  s = rho+rho',
    W0 = Gamma(rho)Gamma(rho')/Gamma(rho+rho'+1)   (k=0 pair weights).
    Same-sign pairs with Im(s) <= smax only (opposite-sign: e^{-pi gamma}
    suppressed).  NOT absolutely convergent (k=0!) -- truncation-sensitive,
    reported as such."""
    g = gam[:K2]
    rho = 0.5 + 1j * np.concatenate([g, -g])
    LG = loggamma(rho)
    s = rho[:, None] + rho[None, :]
    W0 = np.exp(LG[:, None] + LG[None, :] - loggamma(s + 1))
    coef = (W0 * s / (s - 2)).ravel()
    sv = s.ravel()
    keep = np.abs(sv.imag) <= smax
    out = np.zeros(len(logx))
    E = np.exp(np.outer(logx, sv[keep] - 2))
    out = np.real(E @ coef[keep])
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
    """Complex amplitude of each e^{-t/2} cos/sin(gamma_j t) line in y(t).
    y is band-passed first (kills constants + smooth drift), then LSQ on the
    2J-column matched basis.  Returns c_j = a_j - i b_j."""
    z = bandpass(y, logx, lo, hi)
    env = np.exp(-logx / 2)
    cols = []
    for g in gams:
        cols += [env * np.cos(g * logx), env * np.sin(g * logx)]
    A = np.vstack(cols).T
    # band-limit the basis identically (common-mode with the data pipeline)
    Ab = np.column_stack([bandpass(A[:, k], logx, lo, hi) for k in range(A.shape[1])])
    sol, *_ = np.linalg.lstsq(Ab[CORE], z[CORE], rcond=None)
    return sol[0::2] - 1j * sol[1::2]


def main():
    rng = np.random.default_rng(30)
    gam = load_zeros()
    mu, phi = mobius_phi(60)
    lam = sieve_lambda(NMAX)

    print("=" * 78)
    print("PART A: reproduction of exp23 on its own grid (independent code path)")
    print("=" * 78)
    Q0 = 30
    lamS = lambda_sharp(Q0, mu, phi, NMAX)
    lamB = lam - lamS
    lamB[0] = 0.0

    r_SS = cross_conv(lamS, lamS)
    r_mix = 2 * cross_conv(lamS, lamB)
    r_BB = cross_conv(lamB, lamB)
    r_tot = cross_conv(lam, lam)

    T_SS, T_mix = T_of(r_SS, LOGX), T_of(r_mix, LOGX)
    T_BB, T_tot = T_of(r_BB, LOGX), T_of(r_tot, LOGX)
    closure = np.max(np.abs(T_SS + T_mix + T_BB - T_tot) / np.abs(T_tot))
    print(f"closure max|[##]+[mix]+[bb]-T|/|T| = {closure:.2e}")

    K1 = 30_000
    model = screw_kernel(gam[:K1], LOGX)
    model_w = screw_kernel(gam[:K1], LOGX_W)

    SINGLE, WIDE, PAIRB = (10.0, 27.5), (8.0, 45.0), (28.5, 60.0)
    c1, a1 = band_stats(T_mix, model, LOGX, *SINGLE)
    c2b, a2b = band_stats(T_mix, model, LOGX, *WIDE)
    print(f"[mix](T) vs screw kernel  band {SINGLE}: corr = {c1:.4f}, ratio = {a1:.4f}")
    print(f"[mix](T) vs screw kernel  band {WIDE}: corr = {c2b:.4f}, ratio = {a2b:.4f}")

    # [##] fit (their c2 claim) and spectral deadness
    A = np.vstack([LOGX, np.ones(M)]).T
    (slope, cSS), *_ = np.linalg.lstsq(A, T_SS, rcond=None),
    sol, *_ = np.linalg.lstsq(A, T_SS, rcond=None)
    slope, cSS = sol
    print(f"[##](T) = a logX + c:  a = {slope:.4f},  c = {cSS:.4f}  "
          f"(exp23 printed 1.0000, 5.1407)")
    print(f"[##] single-band RMS: {np.std(bandpass(T_SS, LOGX, *SINGLE)[CORE]):.2e}")

    # pair-band exclusion: [mix] in the pair band must still be SINGLE-zero
    c3, a3 = band_stats(T_mix, model, LOGX, *PAIRB)
    print(f"[mix](T) in pair band {PAIRB} vs single-zero screw model: "
          f"corr = {c3:.4f}, ratio = {a3:.4f}   <-- exclusion check")
    # [bb](T): subleading, pair frequencies
    bbm = bb_model(gam, LOGX)
    c4, a4 = band_stats(T_BB, bbm, LOGX, *PAIRB)
    print(f"[bb](T) RMS single band: {np.std(bandpass(T_BB, LOGX, *SINGLE)[CORE]):.2e}, "
          f"pair band: {np.std(bandpass(T_BB, LOGX, *PAIRB)[CORE]):.2e}")
    print(f"[bb](T) vs reweighted k=0 pair model, band {PAIRB}: "
          f"corr = {c4:.3f}, ratio = {a4:.3f}  (k=0: NOT abs. convergent; "
          f"truncation-limited)")

    print()
    print("=" * 78)
    print("PART B: per-zero Krein masses from the arithmetic mixed block")
    print("=" * 78)
    J = 10
    T_mix_w = T_of(r_mix, LOGX_W)
    cj_data = extract_lines(T_mix_w, LOGX_W, gam[:J])
    cj_model = extract_lines(model_w, LOGX_W, gam[:J])
    # wrong-kernel control: Fujii's unsymmetrized denominator rho(rho+1)
    model_fuj = screw_kernel(gam[:K1], LOGX_W, denom="fujii")
    cj_fuj = extract_lines(model_fuj, LOGX_W, gam[:J])

    print("line-by-line: mass_j := |c_j(data)| * (gamma^2+1/4)/4  (theory: 1)")
    print(f"{'j':>3} {'gamma':>8} {'mass ratio':>11} {'phase(rad)':>11} "
          f"{'data/model':>11} {'phase':>8} | {'vs-Fujii |r|':>12} {'phase':>8}")
    theo = 4.0 / (gam[:J] ** 2 + 0.25)
    for j in range(J):
        r_th = np.abs(cj_data[j]) / theo[j]
        ph_th = np.angle(cj_data[j])
        r_md = cj_data[j] / cj_model[j]
        r_fj = cj_data[j] / cj_fuj[j]
        print(f"{j+1:>3} {gam[j]:>8.3f} {r_th:>11.4f} {ph_th:>+11.4f} "
              f"{np.abs(r_md):>11.4f} {np.angle(r_md):>+8.4f} | "
              f"{np.abs(r_fj):>12.4f} {np.angle(r_fj):>+8.4f}")
    print("(symmetrization test: vs-Fujii phase should be ~ pi - 2/gamma = "
          + ", ".join(f"{np.pi - 2/g:+.3f}" for g in gam[:3]) + ", ...)")

    print()
    print("=" * 78)
    print("PART C: the c2 ledger -- block constants vs Q, and the true MS constant")
    print("=" * 78)
    # full-T constant: fit T - logX - (zero model) ~ const on the top decade
    top = LOGX > np.log(2e5)
    resid_tot = T_tot - LOGX - model
    c2_tot = resid_tot[top].mean()
    print(f"c2(total) = mean[T - logX - screwmodel] on X>2e5:  {c2_tot:+.4f}   "
          f"(drift over top decade: {resid_tot[top].std():.5f})")
    print(f"(sibling SCREW.md Part 5 fitted c2 = -2.280 with a different basis)")
    print(f"{'Q':>4} {'c_##':>9} {'c_mix':>9} {'c_bb':>9} {'sum':>9}")
    for Qt in [1, 10, 30, 50]:
        lS = lambda_sharp(Qt, mu, phi, NMAX) if Qt != Q0 else lamS
        lB = lam - lS
        lB[0] = 0.0
        tSS = T_of(cross_conv(lS, lS), LOGX)
        tMX = T_of(2 * cross_conv(lS, lB), LOGX)
        tBB = T_of(cross_conv(lB, lB), LOGX)
        cS = (tSS - LOGX)[top].mean()
        cM = (tMX - model)[top].mean()
        cB = tBB[top].mean()
        print(f"{Qt:>4} {cS:>9.4f} {cM:>9.4f} {cB:>9.4f} {cS+cM+cB:>9.4f}")
    print("==> block constants are Q-dependent; only the SUM is the MS c2.")

    print()
    print("=" * 78)
    print("PART D: controls")
    print("=" * 78)
    # D1: zero jitter / random-frequency nulls
    print("D1 jitter: corr([mix], screw model with gamma -> gamma + delta), "
          f"band {WIDE}:")
    for d in [0.0, 0.02, 0.1, 0.5]:
        mj = screw_kernel(gam[:K1] + d, LOGX)
        cj_, aj_ = band_stats(T_mix, mj, LOGX, *WIDE)
        print(f"    delta = {d:4.2f}:  corr = {cj_:+.4f}   ratio = {aj_:.4f}")
    gr = np.sort(rng.uniform(10, 50, 200))
    cr, _ = band_stats(T_mix, screw_kernel(gr, LOGX), LOGX, *WIDE)
    print(f"    200 random frequencies in [10,50]:  corr = {cr:+.4f}")

    # D2: Q-ablation of the headline numbers
    print("D2 Q-ablation: [mix](T) vs screw kernel, band (10,27.5):")
    for Qt in [1, 10, 30, 50]:
        lS = lambda_sharp(Qt, mu, phi, NMAX) if Qt != Q0 else lamS
        lB = lam - lS
        lB[0] = 0.0
        tMX = T_of(2 * cross_conv(lS, lB), LOGX)
        cq, aq = band_stats(tMX, model, LOGX, *SINGLE)
        print(f"    Q = {Qt:>3}:  corr = {cq:.4f},  ratio = {aq:.4f}")

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
    a.set_title(f"independent reproduction: corr {c2b:.4f}, ratio {a2b:.4f} (band [8,45])")
    a.legend(fontsize=8)

    a = ax[0, 1]
    jj = np.arange(1, J + 1)
    a.axhline(1.0, color="gray", lw=0.8)
    a.plot(jj, np.abs(cj_data) / theo, "o", color="navy",
           label=r"$|c_j|\,(\gamma_j^2+\frac14)/4$ (mass ratio vs theory)")
    a.plot(jj, np.abs(cj_data / cj_model), "s", ms=4, color="seagreen",
           label="data / model (pipeline-calibrated)")
    a.plot(jj, np.angle(cj_data / cj_model), "x", color="crimson",
           label="phase of data/model (rad)")
    a.axhline(0.0, color="crimson", lw=0.5, ls=":")
    a.set_xlabel("zero index j")
    a.set_title("per-zero Krein masses $1/(\\gamma_j^2+1/4)$ from arithmetic mixed block")
    a.legend(fontsize=8)

    a = ax[1, 0]
    deltas = [0.0, 0.02, 0.05, 0.1, 0.2, 0.5]
    cors = [band_stats(T_mix, screw_kernel(gam[:K1] + d, LOGX), LOGX, *WIDE)[0]
            for d in deltas]
    a.plot(deltas, cors, "o-", color="tab:red")
    a.axhline(cr, color="gray", ls="--", lw=0.8, label="random-frequency null")
    a.set_xlabel(r"zero jitter $\delta$")
    a.set_ylabel("corr in band [8,45]")
    a.set_title("the match dies at $\\delta\\sim$ 1/window: not a bandpass artifact")
    a.legend(fontsize=8)
    a.grid(alpha=0.3)

    a = ax[1, 1]
    Qs = [1, 10, 30, 50]
    table = []
    for Qt in Qs:
        lS = lambda_sharp(Qt, mu, phi, NMAX) if Qt != Q0 else lamS
        lB = lam - lS
        lB[0] = 0.0
        tSS = T_of(cross_conv(lS, lS), LOGX)
        tMX = T_of(2 * cross_conv(lS, lB), LOGX)
        tBB = T_of(cross_conv(lB, lB), LOGX)
        table.append([(tSS - LOGX)[top].mean(), (tMX - model)[top].mean(),
                      tBB[top].mean()])
    table = np.array(table)
    w = 0.25
    xpos = np.arange(len(Qs))
    for k, (lab, col) in enumerate([("$c_{\\sharp\\sharp}$", "tab:blue"),
                                    ("$c_{mix}$", "tab:orange"),
                                    ("$c_{\\flat\\flat}$", "tab:green")]):
        a.bar(xpos + (k - 1) * w, table[:, k], w, label=lab, color=col)
    a.plot(xpos, table.sum(1), "k*-", ms=10, label="sum = MS $c_2$")
    a.axhline(c2_tot, color="gray", ls="--", lw=0.8)
    a.set_xticks(xpos, [f"Q={q}" for q in Qs])
    a.set_title("the c2 ledger: block constants move with Q, the sum does not")
    a.legend(fontsize=8)

    fig.tight_layout()
    FIG.mkdir(exist_ok=True)
    fig.savefig(FIG / "exp30_screwjoin.png", dpi=140)
    print("\nsaved figures/exp30_screwjoin.png")


if __name__ == "__main__":
    main()
