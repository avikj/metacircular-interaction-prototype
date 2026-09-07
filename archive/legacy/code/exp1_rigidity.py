"""Experiment 1: Marginal rigidity of the pair field.

Question: which marginals of the pair field a (x) a determine the set/sequence a?

 (a) SUM marginal r_A(N) = #{(m,n) in A^2 : m+n=N}   ("Goldbach data")
 (b) DIFFERENCE marginal d_A(h) = #{(m,n) in A^2 : m-n=h}  ("gap data")

Claims to test / illustrate:
 1. r_A determines A uniquely among finite integer sets (injectivity; proof:
    A(x)^2 = B(x)^2 in Z[x] => A(x) = +-B(x) => A=B by nonnegativity).
 2. d_A does NOT determine A up to congruence: homometric pairs exist
    (crystallographic phase problem). Brute-force the minimal example.
 3. Homometric rigidity of the PRIMES: is {p prime : p <= X} determined by its
    difference multiset up to reflection?  By Rosenblatt-Seymour (1982), all
    homometric partners of a set with generating polynomial F = Q*R arise as
    Q * reversal(R) (up to shift/reflection).  So the primes <= X are rigid iff
    no factorization of F_X yields a 0-1 partner other than F_X and its mirror.
    We factor F_X over Z and enumerate factor splits.
"""
import itertools, time, sys
import numpy as np

try:
    from flint import fmpz_poly
    HAVE_FLINT = True
except ImportError:
    HAVE_FLINT = False
    import sympy
    from sympy import Poly, ZZ
    from sympy.abc import x as sym_x

from pairfield import sieve_primes


# ---------- 1. brute force: sum marginal injectivity ----------
def rep_key_sum(A, top):
    r = [0] * (2 * top + 1)
    for a in A:
        for b in A:
            r[a + b] += 1
    return tuple(r)


def rep_key_diff(A, top):
    d = [0] * (top + 1)
    for a in A:
        for b in A:
            if a >= b:
                d[a - b] += 1
    return tuple(d)


def canon(A, top):
    """canonical form under translation and reflection"""
    A = sorted(A)
    t = tuple(a - A[0] for a in A)
    B = sorted(A[-1] - a for a in A)
    r = tuple(b - B[0] for b in B)
    return min(t, r)


def brute_force(nmax=13, sizes=(4, 5, 6, 7)):
    print(f"# Brute force over subsets of {{0..{nmax}}}, normalized (0 in A, translation-reduced)")
    sum_coll, diff_coll = 0, 0
    min_homometric = None
    for k in sizes:
        seen_sum, seen_diff = {}, {}
        for rest in itertools.combinations(range(1, nmax + 1), k - 1):
            A = (0,) + rest
            cA = canon(A, nmax)
            ks = rep_key_sum(A, nmax)
            kd = rep_key_diff(A, nmax)
            if ks in seen_sum and seen_sum[ks] != cA:
                sum_coll += 1
                print("  SUM COLLISION (should be impossible):", seen_sum[ks], cA)
            seen_sum[ks] = cA
            if kd in seen_diff and seen_diff[kd] != cA:
                diff_coll += 1
                if min_homometric is None or max(A) < max(min_homometric[0][-1], 0):
                    pass
                if min_homometric is None:
                    min_homometric = (seen_diff[kd], cA)
                print(f"  homometric pair (size {k}): {seen_diff[kd]}  ~  {cA}")
            else:
                seen_diff[kd] = cA
    print(f"# sum-marginal collisions: {sum_coll} (theory: 0)")
    print(f"# difference-marginal collisions found: {diff_coll} (theory: >0, phase problem is real)")
    return min_homometric


# ---------- 2/3. homometric rigidity of the primes via factorization ----------
def prime_poly_coeffs(X):
    isp = sieve_primes(X)
    ps = np.nonzero(isp)[0]
    deg = ps[-1] - ps[0]
    c = [0] * (deg + 1)
    for p in ps:
        c[p - ps[0]] = 1
    return c


def factor_flint(coeffs):
    f = fmpz_poly(coeffs)
    content, facs = f.factor()
    return [(list(map(int, p.coeffs())), int(e)) for (p, e) in facs]


def factor_sympy(coeffs):
    f = Poly(list(reversed(coeffs)), sym_x, domain=ZZ)
    _, facs = f.factor_list()
    out = []
    for p, e in facs:
        cs = list(reversed([int(c) for c in p.all_coeffs()]))
        out.append((cs, int(e)))
    return out


def poly_mul(a, b):
    out = [0] * (len(a) + len(b) - 1)
    for i, ai in enumerate(a):
        if ai:
            for j, bj in enumerate(b):
                out[i + j] += ai * bj
    return out


def reversal(c):
    return list(reversed(c))


def is_01(c):
    return all(v in (0, 1) for v in c)


def rigidity_of_primes(X, verbose=True):
    """Enumerate Rosenblatt-Seymour partners of F_X from factor splits."""
    coeffs = prime_poly_coeffs(X)
    t0 = time.time()
    facs = factor_flint(coeffs) if HAVE_FLINT else factor_sympy(coeffs)
    tf = time.time() - t0
    # expand with multiplicity
    flat = []
    for p, e in facs:
        flat.extend([p] * e)
    n = len(flat)
    partners = set()
    base = tuple(coeffs)
    mirror = tuple(reversal(coeffs))
    nontrivial = []
    # enumerate subsets of factors to reverse
    for mask in range(1, 2 ** n - 1):
        prod = [1]
        for i in range(n):
            prod = poly_mul(prod, reversal(flat[i]) if (mask >> i) & 1 else flat[i])
        # normalize sign: leading coeff of each irreducible factor may flip sign under reversal
        if prod[-1] < 0 or (prod[-1] == 0 and sum(prod) < 0):
            prod = [-v for v in prod]
        tp = tuple(prod)
        if tp in (base, mirror) or tp in partners:
            continue
        partners.add(tp)
        if is_01(prod):
            nontrivial.append(tp)
    if verbose:
        degs = sorted(len(p) - 1 for p in [f for f, e in facs] for _ in range(1))
        print(f"X={X:5d}: deg={len(coeffs)-1:5d}, {n} irreducible factors (degrees {degs}), "
              f"factor time {tf:.2f}s, non-mirror 0-1 partners: {len(nontrivial)}")
        for p in nontrivial:
            supp = [i for i, v in enumerate(p) if v]
            print("   NON-RIGID! partner support:", supp)
    return len(nontrivial) == 0, facs


if __name__ == "__main__":
    mh = brute_force(nmax=13)
    print()
    print("# Homometric rigidity of the primes (Rosenblatt-Seymour enumeration)")
    print("# backend:", "flint" if HAVE_FLINT else "sympy")
    Xs = [20, 30, 50, 80, 100, 150, 200, 300, 400, 500]
    for X in Xs:
        rigid, facs = rigidity_of_primes(X)
        if not rigid:
            print(f"  -> primes up to {X} NOT homometrically rigid")
