"""Experiment 1c: push irreducibility of the prime polynomial F_X to X = 30000, 50000.

Usage: python exp1c_bigfactor2.py X
Appends result (with timing) to ../data/exp1c_out.txt.
If any nontrivial factorization appears, analyzes the factors:
  - degrees, cyclotomic? (palindromic + divides x^n - 1), self-reciprocal?
  - whether any Rosenblatt-Seymour factor split yields a 0-1 partner
    (machinery of exp1_rigidity).
"""
import sys, time, os
from flint import fmpz_poly
import numpy as np

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from pairfield import sieve_primes

OUT = os.path.join(os.path.dirname(os.path.abspath(__file__)), "..", "data", "exp1c_out.txt")


def prime_poly(X):
    isp = sieve_primes(X)
    ps = np.nonzero(isp)[0]
    c = [0] * (ps[-1] - ps[0] + 1)
    for p in ps:
        c[p - ps[0]] = 1
    return fmpz_poly(c), len(ps)


def is_palindromic(cs):
    return cs == cs[::-1]


def is_cyclotomic(cs):
    """monic integer poly is cyclotomic-product iff all roots are roots of unity;
    quick test: palindromic and divides x^n - 1 for some n <= 4*deg^2 (crude).
    We instead test: f | x^n - 1 with n = lcm bound via resultant-free trick:
    check x^n mod f == 1 for n up to a cap."""
    f = fmpz_poly(cs)
    d = f.degree()
    if not is_palindromic(cs):
        return False
    # x^n mod f == 1 for some n <= ~ d^2 (phi(m) = d => m <= ~ d^2 for d>=2)
    cap = max(2 * d * d, 1000)
    xp = fmpz_poly([0, 1])
    acc = xp % f
    one = fmpz_poly([1])
    n = 1
    while n <= cap:
        if acc == one:
            return True
        acc = (acc * xp) % f
        n += 1
    return False


def analyze_factors(facs):
    lines = []
    for cs, e in facs:
        d = len(cs) - 1
        pal = is_palindromic(cs)
        cyc = is_cyclotomic(cs) if d <= 200 else ("?" if pal else False)
        lines.append(f"    factor deg={d} mult={e} palindromic={pal} cyclotomic={cyc}"
                     + (f" coeffs={cs}" if d <= 12 else ""))
    return lines


def zero_one_partners(facs, coeffs):
    """Enumerate Rosenblatt-Seymour splits (reverse a subset of irreducible factors)."""
    from exp1_rigidity import poly_mul, reversal, is_01
    flat = []
    for p, e in facs:
        flat.extend([p] * e)
    n = len(flat)
    base, mirror = tuple(coeffs), tuple(reversal(list(coeffs)))
    hits = []
    for mask in range(1, 2 ** n - 1):
        prod = [1]
        for i in range(n):
            prod = poly_mul(prod, reversal(flat[i]) if (mask >> i) & 1 else flat[i])
        if prod[-1] < 0:
            prod = [-v for v in prod]
        tp = tuple(prod)
        if tp in (base, mirror):
            continue
        if is_01(prod):
            hits.append([i for i, v in enumerate(prod) if v])
    return hits


def main(X):
    t0 = time.time()
    f, k = prime_poly(X)
    tsieve = time.time() - t0
    t0 = time.time()
    _, facs = f.factor()
    tfac = time.time() - t0
    facs = [(list(map(int, p.coeffs())), int(e)) for p, e in facs]
    nf = sum(e for _, e in facs)
    msg = [f"X={X}: degree={f.degree()}, pi(X)={k}, irreducible_factors={nf}, "
           f"factor_time={tfac:.1f}s (sieve {tsieve:.2f}s)"]
    if nf > 1:
        msg += ["  REDUCIBLE — analysis:"]
        msg += analyze_factors(facs)
        coeffs = list(map(int, f.coeffs()))
        hits = zero_one_partners(facs, coeffs)
        msg += [f"  non-mirror 0-1 partners from factor splits: {len(hits)}"]
        for h in hits:
            msg += [f"    PARTNER support: {h}"]
    else:
        msg += ["  IRREDUCIBLE => homometric rigidity of primes <= "
                f"{X} holds unconditionally (Thm A')."]
    with open(OUT, "a") as fh:
        fh.write("\n".join(msg) + "\n")
    print("\n".join(msg))


if __name__ == "__main__":
    main(int(sys.argv[1]))
