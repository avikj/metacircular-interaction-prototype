"""Experiment 8: the Bost-Connes/adelic reading, verified.

(1) BC critical correlator = singular series:
    C_F(h) = mu(e_F tau_h e_F)/mu(e_F)^2 on Z-hat with Haar mu,
    e_F = units at primes in F.  Verify the product formula against direct
    counting on Z/MZ, and convergence C_F(h) -> S(h).

(2) k-tuple version C_F(H) -> S(H) with nu_p(H) forbidden classes.

(3) Ramanujan expansion partial sums sum_{q<=Q} mu(q)^2/phi(q)^2 c_q(h) -> S(h).

(4) SYMMETRIZATION KILLS THE PHASE PROBLEM: for even (symmetric) sequences,
    autocorrelation = additive convolution, so the difference marginal on the
    SIGNED line is injective (Theorem A(i)).  The homometric pair
    {0,1,2,6,8,11} ~ {0,1,6,7,9,11} must therefore have DIFFERENT
    symmetrized autocorrelations.  Verify.

(5) Sector decomposition of the symmetrized convolution:
    r_sym(N) = r_Goldbach(N) + 2*c_gap(N)  (+ boundary terms from 0).
    "Every even N is a sum or a difference of two primes" is the positivity
    of the symmetrized field.  Verify decomposition and positivity margins.
"""
import numpy as np
from sympy import primerange, mobius, totient, primefactors
from pairfield import sieve_lambda, sieve_primes, additive_convolution, autocorrelation

TWIN = 0.6601618158468695739278121100145557784326  # C2

def S_HL(h):
    if h % 2:
        return 0.0
    v = 2 * TWIN
    for p in primefactors(h):
        if p > 2:
            v *= (p - 1) / (p - 2)
    return v

def C_F_formula(h, F):
    v = 1.0
    for p in F:
        if h % p == 0:
            v *= p / (p - 1)
        else:
            v *= 1 - 1 / (p - 1) ** 2
    return v

def C_F_direct(h, F):
    M = int(np.prod(F))
    x = np.arange(M)
    ok = np.ones(M, dtype=bool)
    ok2 = np.ones(M, dtype=bool)
    for p in F:
        ok &= (x % p) != 0
        ok2 &= ((x + h) % p) != 0
    dens = np.prod([(1 - 1 / p) for p in F])
    return np.mean(ok & ok2) / dens ** 2

def main():
    # (1)
    F = [2, 3, 5, 7, 11, 13]
    print("== (1) BC correlator: formula vs direct count on Z/30030Z ==")
    for h in [2, 6, 30, 7, 210]:
        f, d = C_F_formula(h, F), C_F_direct(h, F)
        print(f"  h={h:4d}: formula {f:.6f}  direct {d:.6f}  match {abs(f-d)<1e-12}")
    print("  convergence to S(h) as F grows:")
    for h in [2, 6, 90]:
        vals = [C_F_formula(h, list(primerange(2, B))) for B in [10, 100, 1000, 10000]]
        print(f"  h={h:3d}: {[f'{v:.6f}' for v in vals]}  ->  S(h)={S_HL(h):.6f}")

    # (2) k-tuple, H = {0,2,6}
    print("\n== (2) k-tuple correlator, H={0,2,6} ==")
    H = [0, 2, 6]
    F = [2, 3, 5, 7, 11, 13]
    M = int(np.prod(F))
    x = np.arange(M)
    ok = np.ones(M, dtype=bool)
    for hj in H:
        for p in F:
            pass
    ok = np.ones(M, dtype=bool)
    for p in F:
        allowed = np.ones(M, dtype=bool)
        for hj in H:
            allowed &= ((x + hj) % p) != 0
        ok &= allowed
    dens = np.prod([(1 - 1 / p) for p in F])
    direct = np.mean(ok) / dens ** len(H)
    prod = 1.0
    for p in F:
        nu = len({hj % p for hj in H})
        prod *= (1 - nu / p) / (1 - 1 / p) ** len(H)
    print(f"  direct {direct:.6f}  product formula {prod:.6f}  match {abs(direct-prod)<1e-12}")

    # (3) Ramanujan expansion
    print("\n== (3) Ramanujan expansion partial sums ==")
    def ram_c(q, h):
        # c_q(h) = sum over d | (q,h) of d mu(q/d)
        s = 0
        for d in range(1, q + 1):
            if q % d == 0 and h % d == 0:
                s += d * mobius(q // d)
        return s
    for h in [2, 6]:
        for Q in [10, 50, 200, 1000]:
            s = sum((mobius(q)) ** 2 / totient(q) ** 2 * ram_c(q, h)
                    for q in range(1, Q + 1))
            print(f"  h={h}, Q={Q:5d}: {float(s):.6f}", end="")
        print(f"   S(h)={S_HL(h):.6f}")

    # (4) symmetrization vs homometry
    print("\n== (4) symmetrization kills the phase problem ==")
    A = [0, 1, 2, 6, 8, 11]
    B = [0, 1, 6, 7, 9, 11]
    def seq(S, n=12):
        a = np.zeros(n); a[S] = 1; return a
    a, b = seq(A), seq(B)
    print(f"  positive-cone autocorrelations equal: "
          f"{np.allclose(autocorrelation(a), autocorrelation(b))}")
    def symmetrize(S, n=12):
        v = np.zeros(2 * n + 1)
        for s in S:
            v[n + s] = 1; v[n - s] = 1
        return v
    sa, sb = symmetrize(A), symmetrize(B)
    ca, cb = autocorrelation(sa), autocorrelation(sb)
    print(f"  symmetrized autocorrelations equal: {np.allclose(ca, cb)}  (must be False)")
    conv = additive_convolution(sa)
    # for even sequences: autocorrelation(h) = convolution shifted to center
    mid = len(sa) - 1
    print(f"  even sequence: autocorr(h) == conv(center+h): "
          f"{np.allclose(ca[:10], conv[mid:mid+10])}")

    # (5) sector decomposition with Lambda weights
    print("\n== (5) signed-line sector decomposition ==")
    NMAX = 200000
    lam = sieve_lambda(NMAX)
    r = additive_convolution(lam)          # Goldbach sector
    c = autocorrelation(lam)               # gap sector (one-sided)
    Ns = [10000, 10002, 100000, 199990]
    for N in Ns:
        print(f"  N={N}: Goldbach r(N)={r[N]:.1f}, gap c(N)={c[N]:.1f}, "
              f"symmetrized total={r[N] + 2*c[N]:.1f}")
    ev = np.arange(4, NMAX, 2)
    print(f"  min over even N<=2e5 of r(N): {r[ev].min():.2f}  "
          f"(Goldbach positivity, Lambda-weighted)")
    print(f"  min over even N<=2e5 of c(N): {c[ev[ev<NMAX//2]].min():.2f}  "
          f"(gap positivity: every even N a difference of prime powers <=2e5)")

if __name__ == "__main__":
    main()
