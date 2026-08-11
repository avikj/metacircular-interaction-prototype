"""Experiment 7: cyclotomic factors of prime polynomials = prime race ties.

Phi_m(x) divides F_X(x) = sum_{p<=X} x^{p-2}  iff  sum_{p<=X} zeta_m^{p-2} = 0,
i.e. iff the zeta_m-weighted prime race is exactly tied at X.  This is the only
observed failure mode of irreducibility of F_X (X=11, m=6), and by
palindromicity of Phi_m it never breaks homometric rigidity (Theorem A').

Exact incremental scan: for each m, maintain v_m = (counts of (p-2) mod m)
reduced modulo Phi_m over Z, updating by the precomputed reduction row of
x^{(p-2) mod m} for each new prime.  Tie iff v_m = 0.
"""
import numpy as np
import sympy
from sympy import Poly, cyclotomic_poly
from sympy.abc import x
from pairfield import sieve_primes

MMAX = 60
XMAX = 1_000_000

def reduction_rows(m):
    """rows[j] = coefficients of x^j mod Phi_m(x), j = 0..m-1, as int64 array."""
    phi = Poly(cyclotomic_poly(m, x), x)
    d = phi.degree()
    rows = np.zeros((m, d), dtype=np.int64)
    for j in range(m):
        r = Poly(x ** j, x).rem(phi)
        cs = list(reversed([int(c) for c in r.all_coeffs()])) if not r.is_zero else []
        rows[j, : len(cs)] = cs
    return rows

def main():
    isp = sieve_primes(XMAX)
    primes = np.nonzero(isp)[0]
    ms = list(range(2, MMAX + 1))
    rows = {m: reduction_rows(m) for m in ms}
    vecs = {m: np.zeros(rows[m].shape[1], dtype=np.int64) for m in ms}
    ties = []
    for idx, p in enumerate(primes):
        for m in ms:
            vecs[m] += rows[m][(p - 2) % m]
        if idx < 2:
            continue
        for m in ms:
            if not vecs[m].any():
                ties.append((int(p), m))
                print(f"TIE: Phi_{m} | F_X at X={p}  (pi(X)={idx+1})", flush=True)
    print(f"\nscan complete: m<={MMAX}, X<={XMAX}, ties found: {len(ties)}")
    with open("../data/exp7_ties.txt", "w") as f:
        for X, m in ties:
            f.write(f"{X} {m}\n")

if __name__ == "__main__":
    main()
