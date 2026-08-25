"""Experiment 9: verify the beta-crossover scaling law and the operator identity (L).

(1) CROSSOVER LAW.  With beta_z = 1 + lambda/log z, and C_{beta,z}(H) the
    anchored BC correlation truncated at z, the claim is

    C_{beta_z,z}(H)/C_{1,z}(H)  ->  exp[ (k-1) * INT ],
    INT = int_0^1 (e^{-lambda u}-1)/u du = -Ein(lambda),

    universal in H (only k = |H| enters).  We test H={0,2} (k=2) and
    H={0,2,6} (k=3) at z = 1e3, 1e4, 1e5, lambda in {-1, 0.5, 1, 2}.

(2) OPERATOR IDENTITY (L).  P_s = sum Lambda(n) n^{-s} tau_n has eigenvalues
    A_r(s) = sum Lambda(n) e(rn) n^{-s} on additive characters.  For primitive
    chi mod q, Gauss summation gives

    sum_{a in (Z/q)^*} chi(a) A_{a/q}(s) = -tau(chi) L'/L(s, chi-bar).

    We verify numerically at q=5, s=2, with L(s,chi) via Hurwitz zeta.
"""
import numpy as np
from scipy.integrate import quad
from sympy import primerange
import mpmath as mp
from pairfield import sieve_lambda

def local_factor(p, beta, H):
    nu = len({h % p for h in H})
    k = len(H)
    return ((p - nu) / (p - 1)) * (1 - p ** (-beta)) ** (1 - k)

def C_beta_z(beta, z, H):
    v = 1.0
    for p in primerange(2, z + 1):
        v *= local_factor(p, beta, H)
    return v

def main():
    print("== (1) beta-crossover scaling law ==")
    for H in [(0, 2), (0, 2, 6)]:
        k = len(H)
        for lam in [-1.0, 0.5, 1.0, 2.0]:
            INT = quad(lambda u: (np.exp(-lam * u) - 1) / u, 0, 1)[0]
            pred = np.exp((k - 1) * INT)
            row = []
            for z in [10 ** 3, 10 ** 4, 10 ** 5, 10 ** 6]:
                beta = 1 + lam / np.log(z)
                row.append(C_beta_z(beta, z, H) / C_beta_z(1.0, z, H))
            # Richardson extrapolation in 1/log z from the last two points
            import math
            l1, l2 = 1/math.log(10**5), 1/math.log(10**6)
            extrap = row[3] + (row[3]-row[2]) * l2/(l1-l2)
            print(f"  k={k}, lambda={lam:5.2f}: ratios {['%.5f' % r for r in row]}"
                  f"  extrap {extrap:.5f}  predicted {pred:.5f}")

    print("\n== (2) operator identity (L): q=5, s=2 ==")
    s = 2.0
    q = 5
    NMAX = 2_000_000
    lam_v = sieve_lambda(NMAX)
    n = np.arange(NMAX + 1, dtype=float)
    n[0] = 1
    # chi: primitive character mod 5 with chi(2) = i  (2 generates (Z/5)^*)
    # powers of 2 mod 5: 2,4,3,1 -> chi(2)=i, chi(4)=i^2=-1, chi(3)=i^3=-i, chi(1)=1
    chi = {1: 1, 2: 1j, 3: -1j, 4: -1}
    # LHS: sum_a chi(a) A_{a/q}(s), A_r truncated at NMAX
    A = {}
    for a in range(1, q):
        phase = np.exp(2j * np.pi * a * np.arange(NMAX + 1) / q)
        A[a] = np.sum(lam_v * phase / n ** s)
    lhs = sum(chi[a] * A[a] for a in chi)
    # RHS: -tau(chi) * L'/L(s, chi-bar), L(s,chi) = q^{-s} sum_a chi(a) zeta_H(s, a/q)
    tau = sum(chi[a] * np.exp(2j * np.pi * a / q) for a in chi)
    mp.mp.dps = 30
    def L_chi(sv, conj=True):
        tot = mp.mpc(0)
        for a in range(1, q):
            c = np.conj(chi[a]) if conj else chi[a]
            tot += mp.mpc(complex(c)) * mp.zeta(sv, mp.mpf(int(a)) / q)
        return tot / mp.mpf(q) ** sv
    eps = mp.mpf(1) / 10 ** 10
    Lp = (L_chi(s + eps) - L_chi(s - eps)) / (2 * eps)
    rhs = -complex(tau) * complex(Lp / L_chi(s))
    print(f"  LHS (truncated at N=2e6): {lhs:.8f}")
    print(f"  RHS  -tau(chi) L'/L:      {rhs:.8f}")
    print(f"  |LHS-RHS| = {abs(lhs-rhs):.2e}")

    print("\n== (3) singular-series susceptibility: partial sums ==")
    # sum_{h<=H} S(h) = H - (1/2) log H + C + o(1)  (Montgomery/Friedlander-Goldston)
    from pairfield import sieve_primes
    kmax = 4_000_000
    isp = sieve_primes(kmax)
    ps = np.nonzero(isp)[0][1:]
    C2 = float(np.prod(1 - 1.0 / (ps - 1.0) ** 2))
    S = np.zeros(kmax + 1)
    S[2::2] = 2 * C2
    for p in ps:
        S[p::p] *= (p - 1.0) / (p - 2.0)
    S[1::2] = 0
    cs = np.cumsum(S)
    for H in [10 ** 4, 10 ** 5, 10 ** 6, 4 * 10 ** 6]:
        print(f"  H={H:9d}: sum-H = {cs[H]-H:10.4f}   -(1/2)logH = {-0.5*np.log(H):8.4f}"
              f"   diff = {cs[H]-H+0.5*np.log(H):8.4f}")

if __name__ == "__main__":
    main()
