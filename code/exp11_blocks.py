"""Experiment 11: NUMERICAL CLOSURE OF THE TWO-BODY ADELIC BLOCK DECOMPOSITION.

ADELIC.md S3 defines the canonical BC conditional expectation at profinite
resolution Q,
    Lambda^#_Q(n) = sum_{q<=Q} mu(q)/phi(q) c_q(n),      Lambda^b = Lambda - Lambda^#,
and predicts that the smoothed Goldbach count
    G1(X) = sum_{m,n>=1} Lambda(m) Lambda(n) (X-m-n)_+
splits into blocks [##] + [#b]+[b#] + [bb] with the BC block smooth and the
zero content carried by the b-blocks.  This experiment computes all four
blocks exactly (FFT) and identifies WHICH block carries WHICH spectral layer.

Prediction (refining ADELIC.md S3): writing P = P^# + P^b with
P^#(z) ~ 1/z + (rational atoms), P^b(z) ~ -sum_rho Gamma(rho) z^{-rho} + O(1),

    [##]        -> X^3/6 + smooth        (no log-X spectral lines at all)
    [#b]+[b#]   -> -2 sum_rho X^{rho+2}/(rho(rho+1)(rho+2))   [pole x zero]
                   i.e. the SINGLE-zero layer, scale X^{5/2}, frequencies gamma_i
    [bb]        -> sum_{rho,rho'} W X^{rho+rho'+1}            [zero x zero]
                   i.e. the PAIR layer, scale X^2, frequencies gamma_i+gamma_j

so the single-zero sums of Theorem D live in the MIXED block (pole x zero),
not in [bb] as ADELIC.md S3 stated; [bb] is purely the pair layer.

Also verified: (i) exact closure [##]+[mix]+[bb] = G1 to machine precision;
(ii) the Hardy projection means (1/X) sum_n Lambda(n) c_q(n) -> mu(q)
(the conditional-expectation structure); (iii) Besicovitch orthogonality
mean(Lambda^#_Q Lambda^b_Q) -> 0 with the Q-tail rate sum_{q>Q} mu^2/phi^2.
"""
import numpy as np
from scipy.special import loggamma
import matplotlib
matplotlib.use("Agg")
import matplotlib.pyplot as plt
from pathlib import Path
from pairfield import sieve_lambda, load_zeros, additive_convolution

FIG = Path(__file__).resolve().parent.parent / "figures"

NMAX = 2_000_000
M = 8192
LOGX = np.linspace(np.log(2e4), np.log(1.9e6), M)
XS = np.exp(LOGX)
XI = XS.astype(int)


def mobius_phi(N):
    """mu(q), phi(q) for q <= N by sieve."""
    mu = np.ones(N + 1, dtype=np.int64)
    phi = np.arange(N + 1, dtype=np.int64)
    is_c = np.zeros(N + 1, dtype=bool)
    for p in range(2, N + 1):
        if not is_c[p]:
            is_c[p * p :: p] = True
            mu[p::p] *= -1
            mu[p * p :: p * p] = 0
            phi[p::p] -= phi[p::p] // p
    return mu, phi


def ramanujan_row(q, mu):
    """c_q(r) for r = 0..q-1 via c_q(r) = sum_{d | gcd(q,r)} d mu(q/d)."""
    c = np.zeros(q, dtype=np.float64)
    for d in range(1, q + 1):
        if q % d == 0:
            c[::d] += d * mu[q // d]
    return c


def lambda_sharp(Q, mu, phi):
    """Lambda^#_Q(n) for 0 <= n <= NMAX (index 0 zeroed)."""
    out = np.zeros(NMAX + 1)
    for q in range(1, Q + 1):
        if mu[q] == 0:
            continue
        row = ramanujan_row(q, mu) * (mu[q] / phi[q])
        reps = NMAX // q + 2
        out += np.tile(row, reps)[: NMAX + 1]
    out[0] = 0.0
    return out


def conv2(a, b):
    """r(N) = sum_{m+n=N} a_m b_n via FFT."""
    n = len(a)
    L = 1
    while L < 2 * n:
        L *= 2
    r = np.fft.irfft(np.fft.rfft(a, L) * np.fft.rfft(b, L), L)[: 2 * n - 1]
    return r


def g1_of(r):
    """G(X) = X R(X) - S(X) on the log grid (exact: G is piecewise linear)."""
    N = np.arange(len(r), dtype=float)
    R, S = np.cumsum(r), np.cumsum(N * r)
    return XS * R[XI] - S[XI]


def spec(y):
    """Hann-windowed amplitude spectrum after cubic detrend in log X."""
    y = y - np.polyval(np.polyfit(LOGX, y, 3), LOGX)
    Y = np.fft.rfft(y * np.hanning(M))
    f = np.fft.rfftfreq(M, d=(LOGX[1] - LOGX[0])) * 2 * np.pi
    return f, np.abs(Y)


def bandpass(y, lo, hi):
    y = y - np.polyval(np.polyfit(LOGX, y, 3), LOGX)
    Y = np.fft.rfft(y)
    f = np.fft.rfftfreq(M, d=(LOGX[1] - LOGX[0])) * 2 * np.pi
    Y[(f < lo) | (f > hi)] = 0
    return np.fft.irfft(Y, M)


CORE = slice(M // 8, -M // 8)


def band_stats(y, model, lo, hi):
    by, bm = bandpass(y, lo, hi), bandpass(model, lo, hi)
    corr = np.corrcoef(by[CORE], bm[CORE])[0, 1]
    ratio = np.std(by[CORE]) / max(np.std(bm[CORE]), 1e-300)
    return np.std(by[CORE]), corr, ratio


def main():
    Q = 30
    mu, phi = mobius_phi(200_000)
    lam = sieve_lambda(NMAX)
    lamS = lambda_sharp(Q, mu, phi)
    lamB = lam - lamS
    lamB[0] = 0.0
    gam = load_zeros()

    # ---- blocks --------------------------------------------------------
    G_SS = g1_of(conv2(lamS, lamS))
    G_mix = 2 * g1_of(conv2(lamS, lamB))
    G_BB = g1_of(conv2(lamB, lamB))
    G_tot = g1_of(conv2(lam, lam))
    closure = np.max(np.abs(G_SS + G_mix + G_BB - G_tot) / G_tot)
    print(f"exact closure  max |[##]+[mix]+[bb] - G1| / G1 = {closure:.2e}")

    # ---- models --------------------------------------------------------
    # single-zero layer  -2 sum_rho X^{rho+2}/(rho(rho+1)(rho+2))
    K1 = 30_000
    rho1 = 0.5 + 1j * gam[:K1]
    coef = 1.0 / (rho1 * (rho1 + 1) * (rho1 + 2))
    S1 = np.zeros(M)
    for ch in range(0, K1, 2000):
        rr, cc = rho1[ch : ch + 2000], coef[ch : ch + 2000]
        S1 += 2 * np.real(np.exp(np.outer(LOGX, rr + 2)) @ cc)
    single_model = -2 * S1 / XS**2                      # at X^2 scale

    # pair layer  sum_{rho,rho'} W X^{rho+rho'+1}, at X^2 scale
    K2 = 1200
    sgn = np.concatenate([gam[:K2], -gam[:K2]])
    rr = 0.5 + 1j * sgn
    LG = loggamma(rr)
    W = np.exp(LG[:, None] + LG[None, :] - loggamma(rr[:, None] + rr[None, :] + 2))
    # A(u) = e^T W e with e = e^{i sgn u}, evaluated by chunked matmul
    pair_model = np.zeros(M)
    E = np.exp(1j * np.outer(sgn, LOGX))                # (2K2, M)
    for ch in range(0, M, 1024):
        Ec = E[:, ch : ch + 1024]
        pair_model[ch : ch + 1024] = np.real(np.einsum("km,km->m", Ec, W @ Ec))

    # ---- residuals at X^2 scale ---------------------------------------
    r_SS = (G_SS - XS**3 / 6) / XS**2
    r_mix = G_mix / XS**2
    r_BB = G_BB / XS**2

    SINGLE, PAIR = (10.0, 27.5), (28.5, 320.0)
    print("\nband-power split at X^2 scale (RMS over core):")
    print(f"{'block':>8} | {'single band [10,27.5]':>28} | {'pair band [28.5,320]':>28}")
    for name, y in [("[##]", r_SS), ("[mix]", r_mix), ("[bb]", r_BB)]:
        s1 = np.std(bandpass(y, *SINGLE)[CORE])
        s2 = np.std(bandpass(y, *PAIR)[CORE])
        print(f"{name:>8} | {s1:28.6f} | {s2:28.6f}")

    _, c_mix, a_mix = band_stats(r_mix, single_model, *SINGLE)
    _, c_bb, a_bb = band_stats(r_BB, pair_model, *PAIR)
    print(f"\n[mix] vs single-zero model, band {SINGLE}:  corr = {c_mix:.4f}, "
          f"amplitude ratio = {a_mix:.4f}")
    print(f"[bb]  vs pair-sum model,   band {PAIR}:  corr = {c_bb:.4f}, "
          f"amplitude ratio = {a_bb:.4f}")
    # cross-checks: wrong pairings should fail
    _, c_x1, _ = band_stats(r_BB, single_model, *SINGLE)
    _, c_x2, _ = band_stats(r_mix, pair_model, *PAIR)
    print(f"cross-check  [bb] vs single model: corr = {c_x1:+.3f};   "
          f"[mix] vs pair model: corr = {c_x2:+.3f}")
    # the mixed block's pair-band content should be the single-gamma lines
    # ABOVE 28.5 (gamma_4, gamma_5, ... lie in the pair band), i.e. still the
    # single-zero model, not pair content:
    _, c_x3, a_x3 = band_stats(r_mix, single_model, *PAIR)
    print(f"attribution  [mix] vs SINGLE-zero model in pair band: corr = {c_x3:+.4f}, "
          f"ratio = {a_x3:.4f}")

    # line amplitudes per block at pure single (gamma_1..3) and pair frequencies
    fd_SS, A_SS = spec(r_SS)
    fd_mx, A_mx = spec(r_mix)
    fd_bb, A_bb = spec(r_BB)
    print("\nline amplitudes (spectral amp at nearest bin), per block:")
    lines = [("gamma_1", gam[0]), ("gamma_2", gam[1]), ("gamma_3", gam[2]),
             ("2 gamma_1", 2 * gam[0]), ("g1+g2", gam[0] + gam[1]),
             ("2 gamma_2", 2 * gam[1])]
    print(f"{'line':>10} {'freq':>8} | {'[##]':>10} {'[mix]':>10} {'[bb]':>10}")
    for nm, fr in lines:
        i = np.argmin(np.abs(fd_SS - fr))
        print(f"{nm:>10} {fr:8.3f} | {A_SS[i]:10.3f} {A_mx[i]:10.3f} {A_bb[i]:10.3f}")

    # ---- Hardy projection: mean Lambda c_q -> mu(q) --------------------
    print("\nHardy projection  (1/X) sum_{n<=X} Lambda(n) c_q(n)  vs  mu(q):")
    print(f"{'q':>4} {'measured':>10} {'mu(q)':>6}")
    for q in [1, 2, 3, 4, 5, 6, 7, 10, 12, 15, 30]:
        row = ramanujan_row(q, mu)
        val = np.dot(lam[1:], np.tile(row, NMAX // q + 2)[1 : NMAX + 1]) / NMAX
        print(f"{q:>4} {val:>10.4f} {mu[q]:>6}")

    # ---- Q-orthogonality rate -----------------------------------------
    print("\nBesicovitch orthogonality  D(Q) = (1/X) sum Lambda^#_Q Lambda^b_Q,"
          "  tail T(Q) = sum_{Q<q<2e5} mu^2/phi^2:")
    sq = mu[1:] != 0
    qs = np.arange(1, 200_001)[sq]
    tail_terms = 1.0 / phi[qs].astype(float) ** 2
    print(f"{'Q':>5} {'D(Q)':>12} {'T(Q)':>12}")
    for Qt in [1, 2, 3, 5, 10, 30, 100]:
        lS = lambda_sharp(Qt, mu, phi)
        D = np.dot(lS[1:], (lam - lS)[1:]) / NMAX
        T = tail_terms[qs > Qt].sum()
        print(f"{Qt:>5} {D:>12.5f} {T:>12.5f}")

    # ---- figure --------------------------------------------------------
    fig, ax = plt.subplots(3, 1, figsize=(13, 11), sharex=True)
    band = (fd_SS > 8) & (fd_SS < 60)
    for a, (nm, A, mdl) in zip(
        ax,
        [("[##] BC block", A_SS, None),
         ("[mix] pole x zero block", A_mx, spec(single_model)[1]),
         ("[bb] zero x zero block", A_bb, spec(pair_model)[1])],
    ):
        a.plot(fd_SS[band], A[band], lw=0.9, label=f"{nm} spectrum")
        if mdl is not None:
            a.plot(fd_SS[band], -mdl[band], lw=0.9, color="crimson", label="model (mirrored)")
        for i in range(3):
            a.axvline(gam[i], color="green", lw=0.8, ls="--",
                      label=r"single $\gamma_i$" if i == 0 else None)
        for i in range(6):
            for j in range(i, 6):
                fr = gam[i] + gam[j]
                if fr < 60:
                    a.axvline(fr, color="gray", lw=0.5, ls=":",
                              label=r"$\gamma_i+\gamma_j$" if (i, j) == (0, 0) else None)
        a.legend(fontsize=8)
        a.set_ylabel("amplitude")
    ax[0].set_title("Block decomposition of the smoothed Goldbach count: "
                    "each spectral layer sits in exactly one adelic block")
    ax[2].set_xlabel("frequency in log X")
    fig.tight_layout()
    fig.savefig(FIG / "exp11_blocks.png", dpi=140)
    print("\nsaved figures/exp11_blocks.png")


if __name__ == "__main__":
    main()
