"""RED TEAM numerical sanity check for Theorem C's central identity:
E(t) := P(t) - 1/t + log(2 pi)  vs  the zero sum  -2 Re sum_rho Gamma(rho) t^-rho
(plus the O(t log t) trivial-zero/pole layer).  If the explicit formula for P
is right, the two should agree to ~t for small t; under RH, |E(t)| ~ t^{-1/2}
with the tiny constant sum_rho |Gamma(rho)|, so E should be numerically minute.
"""
import numpy as np
from scipy.special import loggamma
from pathlib import Path

DATA = Path(__file__).resolve().parent.parent / "data"

def sieve_lambda(N):
    lam = np.zeros(N + 1)
    isc = np.zeros(N + 1, dtype=bool)
    for p in range(2, N + 1):
        if not isc[p]:
            lp = np.log(p)
            q = p
            while q <= N:
                lam[q] = lp
                q *= p
            isc[p * p:: p] = True
    return lam

def main():
    N = 4_000_000
    lam = sieve_lambda(N)
    n = np.arange(N + 1, dtype=float)
    gam = np.loadtxt(DATA / "odlyzko_zeros_100k.txt")[:2000]
    rho = 0.5 + 1j * gam
    Grho = np.exp(loggamma(rho))
    print(f"sum_rho |Gamma(rho)| (both signs, 2000 zeros) = "
          f"{2*np.abs(Grho).sum():.3e}   <- tiny constant in E(t) << t^-1/2")
    for t in [0.02, 0.01, 0.005, 0.002]:
        P = np.sum(lam[2:] * np.exp(-n[2:] * t))
        E = P - 1 / t + np.log(2 * np.pi)
        zs = -2 * np.real(np.sum(Grho * np.exp(-rho * np.log(t))))
        # remaining trivial-zero/pole layer ~ a t log t + b t
        print(f"  t={t:6.3f}: E(t) = {E:+.8f}   zero-sum = {zs:+.3e}   "
              f"E - zerosum = {E - zs:+.8f}   (t log(1/t) = {t*np.log(1/t):.4f})")

if __name__ == "__main__":
    main()
