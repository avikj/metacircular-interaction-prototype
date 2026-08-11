"""Experiment 13: the two-body adelic block decomposition, computed.

Lambda = Lambda#_Q + Lambda-flat_Q, where Lambda#_Q(n) = sum_{q<=Q} (mu(q)/phi(q)) c_q(n)
is the conditional expectation onto the BC diagonal at profinite resolution Q
(Hardy's Ramanujan coefficients). The smoothed Goldbach count G1(X) then splits
EXACTLY into four blocks

  G1 = [##] + 2[#b] + [bb]

and the content is in the sizes and shapes:
  [##]  : BC block -- main term + truncated singular-series enrichment,
          should match  sum_{n<=X}(X-n) * n * S_Q(n)  where S_Q is the
          level-Q truncated singular series;
  [#b]  : mixed block -- should DECAY as Q grows (orthogonality);
  [bb]  : zero block -- carries all zeta-zero oscillation.

We compute all blocks by FFT for Q in {1, 10, 30, 100} on primes to 2e6.
"""
import numpy as np
from sympy import mobius, totient, divisors
import matplotlib
matplotlib.use("Agg")
import matplotlib.pyplot as plt
from pathlib import Path
from pairfield import sieve_lambda, additive_convolution

FIG = Path(__file__).resolve().parent.parent / "figures"

def lambda_sharp(N, Q):
    """Lambda#_Q(n) = sum_{q<=Q} mu(q)/phi(q) c_q(n), vectorized over n<=N."""
    out = np.zeros(N + 1)
    for q in range(1, Q + 1):
        mq = mobius(q)
        if mq == 0:
            continue
        w = mq / totient(q)
        for d in divisors(q):
            coef = w * d * mobius(q // d)
            if coef:
                out[d::d] += float(coef)
    out[0] = 0
    return out

def truncated_singular(N, Q):
    """S_Q(n) = sum_{q<=Q} mu(q)^2/phi(q)^2 c_q(n)  (autocorrelation of the
    level-Q model), vectorized."""
    out = np.zeros(N + 1)
    for q in range(1, Q + 1):
        if mobius(q) == 0:
            continue
        w = 1.0 / totient(q) ** 2
        for d in divisors(q):
            coef = w * d * mobius(q // d)
            if coef:
                out[d::d] += float(coef)
    return out

def G1_of(r, Xs):
    N = np.arange(len(r), dtype=float)
    R, S = np.cumsum(r), np.cumsum(N * r)
    Xi = Xs.astype(int)
    return Xs * R[Xi] - S[Xi]

def main():
    NMAX = 2_000_000
    lam = sieve_lambda(NMAX)
    Xs = np.geomspace(1e5, 1.9e6, 200)

    G1_full = G1_of(additive_convolution(lam), Xs)

    print(f"{'Q':>4} {'|2[#b]|/X^2 (rms)':>18} {'|[bb]|/X^2 (rms)':>17} "
          f"{'[##] vs S_Q-model corr':>23}")
    for Q in [1, 10, 30, 100]:
        ls = lambda_sharp(NMAX, Q)
        lb = lam - ls
        r_ss = additive_convolution(ls)
        r_sb = additive_convolution_cross(ls, lb)
        r_bb = additive_convolution(lb)
        B_ss = G1_of(r_ss, Xs)
        B_sb = G1_of(r_sb, Xs)
        B_bb = G1_of(r_bb, Xs)
        # exactness check
        err = np.max(np.abs(B_ss + 2 * B_sb + B_bb - G1_full) / Xs ** 3)
        # BC-block model: sum_{n<=X}(X-n) n S_Q(n)
        n = np.arange(NMAX + 1, dtype=float)
        SQ = truncated_singular(NMAX, Q)
        model_r = n * SQ
        M_ss = G1_of(np.concatenate([model_r, np.zeros(len(r_ss) - len(model_r))]), Xs)
        c = np.corrcoef(B_ss / Xs ** 3, M_ss / Xs ** 3)[0, 1]
        ratio = np.mean(B_ss / M_ss)
        print(f"{Q:4d} {np.sqrt(np.mean((2*B_sb/Xs**2)**2)):18.4f} "
              f"{np.sqrt(np.mean((B_bb/Xs**2)**2)):17.4f} "
              f"corr={c:.6f} ratio={ratio:.5f}  (exactness err {err:.1e})")

    # figure: block sizes vs Q at X = 1e6
    Qs = [1, 3, 10, 30, 100, 300]
    X0 = np.array([1.0e6])
    ss_v, sb_v, bb_v = [], [], []
    for Q in Qs:
        ls = lambda_sharp(NMAX, Q)
        lb = lam - ls
        sb_v.append(abs(2 * G1_of(additive_convolution_cross(ls, lb), X0)[0]) / 1e12)
        bb_v.append(abs(G1_of(additive_convolution(lb), X0)[0]) / 1e12)
        ss_v.append(G1_of(additive_convolution(ls), X0)[0] / 1e18 * 6)
    fig, ax = plt.subplots(1, 2, figsize=(12, 4.4))
    ax[0].loglog(Qs, sb_v, "o-", label="|2[#b]|/X^2 (mixed)")
    ax[0].loglog(Qs, bb_v, "s-", label="|[bb]|/X^2 (zero block)")
    ax[0].set_xlabel("profinite resolution Q"); ax[0].legend()
    ax[0].set_title("Mixed block decays with Q; zero block stabilizes")
    ax[1].semilogx(Qs, ss_v, "o-", label="[##] x 6/X^3")
    ax[1].axhline(1.0, color="k", ls="--", lw=0.8, label="main term")
    ax[1].set_xlabel("Q"); ax[1].legend()
    ax[1].set_title("BC block converges to full local prediction")
    fig.tight_layout()
    fig.savefig(FIG / "exp13_blocks.png", dpi=140)
    print("saved figures/exp13_blocks.png")

def additive_convolution_cross(a, b):
    n = len(a)
    L = 1
    while L < 2 * n:
        L *= 2
    fa, fb = np.fft.rfft(a, L), np.fft.rfft(b, L)
    return np.fft.irfft(fa * fb, L)[: 2 * n - 1]

if __name__ == "__main__":
    main()
