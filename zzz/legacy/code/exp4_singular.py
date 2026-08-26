"""Experiment 4: One singular series, two transverse marginals.

Hardy-Littlewood predicts, with the SAME Euler product
  S(k) = 2 C2 prod_{p | k, p>2} (p-1)/(p-2)   (even k; 0 for odd k),

 sum marginal:        r(N)  =  sum_{m+n=N} Lambda(m)Lambda(n)   ~  S(N) * N
 difference marginal: D_h(x) = sum_{n<=x} Lambda(n)Lambda(n+h)  ~  S(h) * x

i.e. the conjectural main terms of the Goldbach projection (in the midpoint
variable) and of the gap projection (in the shift variable) are values of the
same function of the invariant coordinate. We verify both and superimpose.
"""
import numpy as np
import matplotlib
matplotlib.use("Agg")
import matplotlib.pyplot as plt
from pathlib import Path
from pairfield import sieve_lambda, additive_convolution, autocorrelation, sieve_primes

FIG = Path(__file__).resolve().parent.parent / "figures"

def singular_series(kmax):
    """S(k) for all k=0..kmax via sieving over odd primes p <= kmax."""
    isp = sieve_primes(kmax)
    ps = np.nonzero(isp)[0][1:]          # odd primes
    C2 = float(np.prod(1 - 1.0 / (ps - 1.0) ** 2))
    S = np.zeros(kmax + 1)
    S[2::2] = 2 * C2
    for p in ps:
        S[p::p] *= (p - 1.0) / (p - 2.0)
    S[1::2] = 0.0
    return S

def main():
    NMAX = 1_000_000
    lam = sieve_lambda(NMAX)
    r = additive_convolution(lam)      # r[N], N <= 2 NMAX
    c = autocorrelation(lam)           # c[h] = sum_{n} Lam(n)Lam(n+h), n+h <= NMAX
    S = singular_series(2 * NMAX)

    Ns = np.arange(100000, 1000001, 2)         # sum marginal sample
    ratio_sum = r[Ns] / Ns
    pred_sum = S[Ns]

    hs = np.arange(2, 20001, 2)                # difference marginal sample
    ratio_diff = c[hs] / (NMAX - hs)
    pred_diff = S[hs]

    fig, ax = plt.subplots(1, 2, figsize=(12, 4.6))
    rng = np.random.default_rng(1)
    sub = rng.choice(len(Ns), 4000, replace=False)
    ax[0].scatter(pred_sum[sub], ratio_sum[sub], s=2, alpha=0.3, label="sum marginal  r(N)/N")
    ax[0].scatter(pred_diff, ratio_diff, s=2, alpha=0.3, color="crimson",
                  label=r"difference marginal  $D_h(x)/x$")
    lim = [0, 4.2]
    ax[0].plot(lim, lim, "k--", lw=1, label="y = x  (Hardy-Littlewood)")
    ax[0].set_xlim(lim); ax[0].set_ylim(lim)
    ax[0].set_xlabel(r"singular series $\mathfrak{S}(k)$")
    ax[0].set_ylabel("normalized marginal")
    ax[0].legend(fontsize=8)
    ax[0].set_title("Both marginals fall on the same Euler product")

    ok, okd = pred_sum > 0, pred_diff > 0
    ax[1].hist(ratio_sum[ok] / pred_sum[ok], bins=120, range=(0.85, 1.15), alpha=0.6,
               density=True, label=f"sum: mean ratio {np.mean(ratio_sum[ok]/pred_sum[ok]):.4f}")
    ax[1].hist(ratio_diff[okd] / pred_diff[okd], bins=120, range=(0.85, 1.15), alpha=0.6,
               density=True, label=f"diff: mean ratio {np.mean(ratio_diff[okd]/pred_diff[okd]):.4f}")
    ax[1].set_xlabel("marginal / Hardy-Littlewood prediction")
    ax[1].legend(fontsize=8)
    ax[1].set_title("Ratio to prediction")
    fig.tight_layout()
    fig.savefig(FIG / "exp4_singular.png", dpi=140)
    print("saved figures/exp4_singular.png")
    print(f"sum-marginal   mean ratio to HL: {np.mean(ratio_sum[ok]/pred_sum[ok]):.5f}")
    print(f"diff-marginal  mean ratio to HL: {np.mean(ratio_diff[okd]/pred_diff[okd]):.5f}")
    corr = np.corrcoef(np.log(ratio_sum[ok]), np.log(pred_sum[ok]))[0, 1]
    print(f"corr(log r(N)/N, log S(N)) = {corr:.4f}")

if __name__ == "__main__":
    main()
