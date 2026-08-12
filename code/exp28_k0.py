"""Experiment 28: THE k=0 RENORMALIZATION CHALLENGE — at sharp cutoff the
scheme anomaly runs in log X.

exp27 showed that for the (absolutely convergent) k=1-type reweighted field,
the block smooth parts are CONSTANTS that run with the profinite scheme Q,
with a Q-invariant sum.  The k=0 challenge (left free by the sibling
branches): does that structure survive at sharp cutoff,

    G_0(X) = sum_{m+n<=X} Lambda(m)Lambda(n)
           = X^2/2 - 2 sum_rho X^{rho+1}/(rho(rho+1)) + [pair, conditional]
             + deterministic log-layers + ...

where the pair layer converges only conditionally?  Hypothesis: NO — the
per-block smooth parts are no longer constants but acquire log X (and
log^2 X) running, i.e. the scheme anomaly entangles with the flow in X.
That is the scheme-language form of REPORT S5's diagnosis ("the sharp
cutoff is the difficulty"): one Cesaro smoothing is exactly what
disentangles the Q-scheme running from the X-running.

Protocol: split G_0 by blocks at Q = 10/30/60; subtract each block's known
oscillatory model (single layer 1/(rho(rho+1)) for the mixed block, with
30k zeros); fit the smooth residual at X^1 scale onto [1, log X, log^2 X];
compare (i) whether log-coefficients are needed (k=1 control: no),
(ii) whether they run with Q, (iii) whether the SUM of block fits is
Q-invariant (it must be, by bilinearity — the closure control).
"""
import numpy as np
import matplotlib
matplotlib.use("Agg")
import matplotlib.pyplot as plt
from pathlib import Path
from pairfield import sieve_lambda, load_zeros
from exp11_blocks import mobius_phi, lambda_sharp, conv2, NMAX

FIG = Path(__file__).resolve().parent.parent / "figures"
M = 8192
LOGX = np.linspace(np.log(2e4), np.log(1.9e6), M)
XS = np.exp(LOGX)
XI = XS.astype(int)


def g0_of(r):
    return np.cumsum(r)[XI]


def main():
    mu, phi = mobius_phi(200_000)
    lam = sieve_lambda(NMAX)
    gam = load_zeros()

    # k=0 single-zero oscillation model: 2 sum X^{rho+1}/(rho(rho+1))
    K1 = 30_000
    rho = 0.5 + 1j * gam[:K1]
    coef = 1.0 / (rho * (rho + 1))
    S1 = np.zeros(M)
    for ch in range(0, K1, 2000):
        rr, cc = rho[ch:ch + 2000], coef[ch:ch + 2000]
        S1 += 2 * np.real(np.exp(np.outer(LOGX, rr + 1)) @ cc)

    A = np.vstack([np.ones(M), LOGX, LOGX ** 2]).T

    def fit3(y):
        sol, *_ = np.linalg.lstsq(A, y, rcond=None)
        res = np.std(y - A @ sol)
        return sol, res

    G0_tot = g0_of(conv2(lam, lam))
    y_tot = (G0_tot - XS ** 2 / 2 + 2 * S1) / XS
    sol_t, res_t = fit3(y_tot)
    print("total field (invariant control):")
    print(f"  smooth/X = {sol_t[0]:+.3f} {sol_t[1]:+.3f} logX {sol_t[2]:+.4f} log^2X"
          f"   (fit rms {res_t:.4f})")

    print(f"\n{'Q':>4} {'block':>6} {'const':>9} {'logX':>8} {'log2X':>8} {'rms':>7}")
    sums = {}
    for Q in [10, 30, 60]:
        lamS = lambda_sharp(Q, mu, phi)
        lamB = lam - lamS
        lamB[0] = 0.0
        blocks = {
            "[##]": g0_of(conv2(lamS, lamS)) - XS ** 2 / 2,
            "[mix]": 2 * g0_of(conv2(lamS, lamB)) + 2 * S1,
            "[bb]": g0_of(conv2(lamB, lamB)),
        }
        tot = np.zeros(3)
        for nm, y in blocks.items():
            sol, res = fit3(y / XS)
            tot += sol
            print(f"{Q:>4} {nm:>6} {sol[0]:>9.3f} {sol[1]:>8.3f} {sol[2]:>8.4f} {res:>7.4f}")
        sums[Q] = tot
        print(f"{Q:>4} {'SUM':>6} {tot[0]:>9.3f} {tot[1]:>8.3f} {tot[2]:>8.4f}"
              f"   (invariance control)")

    print("\nverdict inputs:")
    print("  k=1 control (exp27): per-block smooth parts are CONSTANTS "
          "(log-coefficients ~ 0), running only through Q.")
    print("  k=0: nonzero logX/log2X per-block coefficients that vary with Q ")
    print("  = the scheme anomaly entangles with the X-flow; Q-invariance of")
    print("  the SUM must persist (bilinearity).")


if __name__ == "__main__":
    main()
