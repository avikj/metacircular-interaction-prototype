"""Experiment 23: the third-order crossover coefficient (papers/crossover.md target 3).

Claim under test (Remark 5.6 of crossover.md): with beta_z = 1 + lambda/log z,
  D_z(lambda) = sum_{p<=z} [log(1-p^{-beta_z}) - log(1-p^{-1})]
              = Ein(lambda) - gamma*lambda/log z + c3*lambda^2/log^2 z + O(1/log^3 z),
empirical c3 ~ 0.0925.

DERIVATION (proved in notes/K2.md): up to O(z^{-1/2}),
  D_z = sum_{n<=z} Lambda(n)/(n log n) * (1 - n^{-lambda/log z})
      = -sum_{k>=1} (-lambda)^k/(k! log^k z) * Psi_k(z),
  Psi_k(z) := sum_{n<=z} Lambda(n) log^{k-1} n / n = log^k z / k + C_k + O(exp(-c sqrt(log z))),
where (Mellin against the Laurent expansion of -zeta'/zeta at s=1, PNT error)
  C_k = (-1)^{k-1} (k-1)! eta_{k-1},   -zeta'/zeta(1+s) = 1/s + sum_j eta_j s^j.
With zeta(1+s) = 1/s + gamma - gamma_1 s + (gamma_2/2) s^2 - ... (Stieltjes):
  eta_0 = -gamma,  eta_1 = gamma^2 + 2 gamma_1,  eta_2 = -(gamma^3 + 3 gamma gamma_1 + (3/2) gamma_2).
Hence the FULL asymptotic expansion, all orders in 1/log z:
  D_z(lambda) = Ein(lambda) + sum_{k>=1} eta_{k-1} lambda^k / (k log^k z)
              = Ein(lambda) - log[ delta * zeta(1+delta) ],  delta = lambda/log z,
and in particular the third-order coefficient is EXACTLY
  c3 = eta_1/2 = (gamma^2 + 2 gamma_1)/2 = 0.0937731164...   (NOT 0.0925 -- finite-z bias)
It is purely quadratic in lambda at this order: no lambda or lambda^3 admixture.

This script verifies, with its own sieve to z = 1e8:
  (1) D_z exactly vs the three-term expansion: residual*log^2 z -> c3*lambda^2;
  (2) the fourth-order residual*log^3 z -> eta_2*lambda^3/3 (bounded, correct value);
  (3) the closed form Ein(lambda) - log(delta*zeta(1+delta)) matches D_z to PNT-error;
  (4) the constant C_2: Psi_2(z) - log^2 z/2 -> -(gamma^2+2*gamma_1) directly.
"""
import numpy as np
import mpmath as mp

mp.mp.dps = 30
ZMAX = 100_000_000
GAMMA = float(mp.euler)
G1 = float(mp.stieltjes(1))
G2 = float(mp.stieltjes(2))
ETA0 = -GAMMA
ETA1 = GAMMA ** 2 + 2 * G1
ETA2 = -(GAMMA ** 3 + 3 * GAMMA * G1 + 1.5 * G2)
C3 = ETA1 / 2


def ein(lam):
    """Ein(lambda) = sum (-1)^{n+1} lambda^n/(n*n!), entire."""
    s, term = mp.mpf(0), mp.mpf(1)
    lam = mp.mpf(lam)
    for n in range(1, 60):
        term *= -lam / n
        s -= term / n
    return float(s)


def main():
    print(f"gamma   = {GAMMA:.12f}")
    print(f"gamma_1 = {G1:.12f}   (Stieltjes)")
    print(f"gamma_2 = {G2:.12f}")
    print(f"eta_1 = gamma^2 + 2 gamma_1 = {ETA1:.12f}")
    print(f"c3 = eta_1/2 = (gamma^2+2 gamma_1)/2 = {C3:.10f}   <-- derived third-order coeff")
    print(f"eta_2 = -(gamma^3+3 gamma gamma_1 + 1.5 gamma_2) = {ETA2:.10f}")
    print(f"candidate table: gamma^2/2={GAMMA**2/2:.4f}  pi^2/12={np.pi**2/12:.4f}  "
          f"gamma^2/2-pi^2/24={GAMMA**2/2-np.pi**2/24:.4f}  (gamma^2+2gamma_1)/2={C3:.4f}")

    print(f"\nsieving to {ZMAX:.0e} ...")
    isp = np.ones(ZMAX + 1, dtype=bool)
    isp[:2] = False
    for p in range(2, int(ZMAX ** 0.5) + 1):
        if isp[p]:
            isp[p * p:: p] = False
    primes = np.nonzero(isp)[0].astype(np.float64)
    del isp
    logp = np.log(primes)
    print(f"{len(primes)} primes")

    zs = [10 ** 4, 10 ** 5, 10 ** 6, 10 ** 7, 10 ** 8]
    lams = [0.5, 1.0, -1.0, 2.0]

    # ---- (4) direct check of C_2 = -(gamma^2 + 2 gamma_1) --------------------
    print("\n(4) Psi_2(z) - log^2 z/2  ->  C_2 = -(gamma^2+2 gamma_1) = "
          f"{-ETA1:.7f}")
    for z in zs:
        n = np.searchsorted(primes, z + 0.5)
        s = np.sum(logp[:n] ** 2 / primes[:n])          # prime part
        # prime powers p^m <= z, m >= 2: Lambda(n) log n / n = m log^2 p / p^m
        pp = 0.0
        for p in primes[primes <= np.sqrt(z)]:
            q, m = p * p, 2
            while q <= z:
                pp += m * np.log(p) ** 2 / q
                q *= p
                m += 1
        val = s + pp - np.log(z) ** 2 / 2
        print(f"   z=1e{int(np.log10(z))}:  {val:+.6f}")

    # ---- (1)-(3) the crossover expansion ------------------------------------
    for lam in lams:
        print(f"\nlambda = {lam}:  Ein = {ein(lam):.10f};  predicted "
              f"c3*lam^2 = {C3 * lam * lam:+.6f};  eta2*lam^3/3 = {ETA2 * lam ** 3 / 3:+.6f}")
        print("      z     (D-Ein)logz   resid*log^2z   resid3*log^3z   D - closedform")
        for z in zs:
            n = np.searchsorted(primes, z + 0.5)
            L = np.log(z)
            beta = 1.0 + lam / L
            P = primes[:n]
            D = float(np.sum(np.log1p(-np.exp(-beta * logp[:n]))
                             - np.log1p(-1.0 / P)))
            E = ein(lam)
            r1 = (D - E) * L
            r2 = (D - E + GAMMA * lam / L) * L * L
            r3 = (r2 - C3 * lam * lam) * L
            delta = mp.mpf(lam) / mp.mpf(np.log(z))
            closed = float(mp.mpf(E) - mp.log(delta * mp.zeta(1 + delta)))
            print(f"   1e{int(np.log10(z))}   {r1:+.6f}   {r2:+.6f}      "
                  f"{r3:+.6f}      {D - closed:+.3e}")

    # ---- empirical extrapolation of the c3 coefficient ----------------------
    print("\nRichardson (in 1/log z) of resid*log^2 z from z=1e7,1e8, per lambda:")
    for lam in lams:
        vals = []
        for z in [10 ** 7, 10 ** 8]:
            n = np.searchsorted(primes, z + 0.5)
            L = np.log(z)
            beta = 1.0 + lam / L
            D = float(np.sum(np.log1p(-np.exp(-beta * logp[:n]))
                             - np.log1p(-1.0 / primes[:n])))
            vals.append((L, (D - ein(lam) + GAMMA * lam / L) * L * L))
        (L1, v1), (L2, v2) = vals
        # model v(L) = c + d/L  =>  c = (v2 L2 - v1 L1)/(L2 - L1)
        extrap = (v2 * L2 - v1 * L1) / (L2 - L1)
        print(f"   lambda={lam:+.1f}: v(1e7)={v1:.6f} v(1e8)={v2:.6f} "
              f"extrap={extrap:.6f}  vs c3*lam^2={C3 * lam * lam:.6f}")


if __name__ == "__main__":
    main()
